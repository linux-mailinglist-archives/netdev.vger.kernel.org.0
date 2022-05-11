Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259DB524051
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348830AbiEKWci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348805AbiEKWcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:32:32 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC48674E9
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 15:32:30 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a11so3191101pff.1
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 15:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lu8Yk3g+KqauzNzBiFKSP6KQpOiG+G3Df6KTkrdelIs=;
        b=niGOrTTEvvwDakGPfaEm+H/jXShM05yULb78ZRtInqcr0ntY7ypT568jGc5K9zi/NK
         RvZCIZgIO5a6JOvTXSsEU9k1t13N7gMcSLzP7XtdlnXEccTeQnQtMdAFVAY2OvP9VNc5
         cf+eEx6HGQtK59kyC+ae06R1Pb5Bl+TkVXjvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lu8Yk3g+KqauzNzBiFKSP6KQpOiG+G3Df6KTkrdelIs=;
        b=3rNUwdHtOILFy+cZkBYzxav9bwLWlOPiQa689C2D1htZUiq8J5v9lNdfOilXybmjAa
         tsHkJG52yeeZ81khweUlEdxzahZalCt3ik6DKiLOmtw/tCHEa+lxATLKjBam9mCnfJ/2
         It14Q8ascofVFcoqjr7sWEL+biqa7CmpS4dgukkcb7jLkbzbhMIksDXclWLGXoJsN+9A
         u9XUZqCWUw9LTCOJlCLA1IhA0XsmooTFtK/N0OZoq/w9zH28HZX8ejNqq0sokm2fG5DV
         Fpfcrf6OxTYdUAJ6gVvrfj25h1uccCs6ZnAn1IG0irj4gC/gEh086YoAxK076qw5Dnxx
         5X6A==
X-Gm-Message-State: AOAM533VeOThLtS2qcGjUNiYbPsuInoo+jSp+CmlC/quM2sAtveUlJHh
        3+0XXiB09ULHjm9Y901kigmzBw==
X-Google-Smtp-Source: ABdhPJywPERqtDjyK6IMSaCkF3byY8oVHiUYV1+JAYdH4mGwmEW2PT4iA5vzx2yw+YiBsg79ZtNpcA==
X-Received: by 2002:a63:1a5c:0:b0:3c1:9a7c:3739 with SMTP id a28-20020a631a5c000000b003c19a7c3739mr22723271pgm.272.1652308350421;
        Wed, 11 May 2022 15:32:30 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t19-20020a62d153000000b005087c23ad8dsm2240431pfl.0.2022.05.11.15.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 15:32:29 -0700 (PDT)
Date:   Wed, 11 May 2022 15:32:29 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Maninder Singh <maninder1.s@samsung.com>
Cc:     mcgrof@kernel.org, avimalin@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, pmladek@suse.com, rostedt@goodmis.org,
        senozhatsky@chromium.org, andriy.shevchenko@linux.intel.com,
        naveen.n.rao@linux.ibm.com, davem@davemloft.net,
        mhiramat@kernel.org, anil.s.keshavamurthy@intel.com,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        v.narang@samsung.com, Onkarnath <onkarnath.1@samsung.com>
Subject: Re: [PATCH 1/2] kallsyms: add kallsyms_show_value definition in all
 cases
Message-ID: <202205111525.92B1C597@keescook>
References: <CGME20220511080722epcas5p459493d02ff662a7c75590e44a11e34a6@epcas5p4.samsung.com>
 <20220511080657.3996053-1-maninder1.s@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511080657.3996053-1-maninder1.s@samsung.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 01:36:56PM +0530, Maninder Singh wrote:
> kallsyms_show_value return false if KALLSYMS is disabled,
> but its usage is done by module.c also.
> Thus when KALLSYMS is disabled, system will not print module
> load address:

Eek, I hadn't see the other changes this depends on. I think those
changes need to be reworked first. Notably in the other patch, this is
no good:

        /* address belongs to module */
        if (add_offset)
                len = sprintf(buf, "0x%p+0x%lx", base, offset);
        else
                len = sprintf(buf, "0x%lx", value);

This is printing raw kernel addresses with no hashing, as far as I can
tell. That's not okay at all.

Once that other patch gets fixed, this one then can be revisited.

And just on naming: "kallsyms_tiny" is a weird name: it's just "ksyms"
-- there's no "all".  :)

-- 
Kees Cook
