Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90F26D96D0
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 14:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDFMLA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Apr 2023 08:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjDFMK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 08:10:59 -0400
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5131B1;
        Thu,  6 Apr 2023 05:10:58 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-545cb3c9898so660075547b3.7;
        Thu, 06 Apr 2023 05:10:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680783057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ck5MlPzpVYxy8IU0ivZGLSHLjTz+SenFqhG42tF0DZ0=;
        b=lQplo8QmGtVfet6LJgglYRQJ+kLKO+j+56TlO++8QvC68lbrifWTUF9citFx7W0kbW
         KoPKihPXRpflobNeVtU1P7EftzFYtB2KNc2xOFUSoPmP8bhoDr68dhCX9C0MzgQsjN9H
         TrSkO8O0e43C4t4eu+Oc7WNnFt9yOw3Q3gEAcTU9HMORqhRwprP+sfUy9mpc78w055D9
         zFJoMQUL5rSyfCtStUQJSOBOoOw4W0ZB8+MR1JMikqtuiIM3lAdrFHjSiJsRRfAFBzuu
         kmSMnIJkUGCDZXM+kvIIjyakYKDtDUp9RPTzBRWIPuRJFJ44MIoazJb1BtfF5ZZM7n9q
         FPjg==
X-Gm-Message-State: AAQBX9c4OHlsMLA2/PhNbluBcpx2gN8X25dOXpNxpfTlzSO+PJSW5Urk
        +sjSNw09ROskYNnzMIAi2TflzbePKyBF6A==
X-Google-Smtp-Source: AKy350Zzrs4m7IUwNofRs8a7ITeQdZFQphYzXI4sdhFMePCVOlSpMsi8+QGNWWGrWoD8yWvlXHvMxA==
X-Received: by 2002:a81:4fcf:0:b0:54c:1718:7a17 with SMTP id d198-20020a814fcf000000b0054c17187a17mr632712ywb.4.1680783057355;
        Thu, 06 Apr 2023 05:10:57 -0700 (PDT)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id 132-20020a81078a000000b00545a08184bbsm266534ywh.75.2023.04.06.05.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 05:10:56 -0700 (PDT)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-536af432ee5so736133267b3.0;
        Thu, 06 Apr 2023 05:10:56 -0700 (PDT)
X-Received: by 2002:a81:a707:0:b0:544:4008:baa1 with SMTP id
 e7-20020a81a707000000b005444008baa1mr5540717ywh.4.1680783056332; Thu, 06 Apr
 2023 05:10:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
 <082e6ff7-6799-fa80-81e2-6f8092f8bb51@gmail.com> <ZC23vf6tNKU1FgRP@kernel.org>
 <ZC240XCeYCaSCu0X@casper.infradead.org> <dee4b415-0696-90f3-0e2f-2230ff941e1b@gmail.com>
 <ZC2/Pi+M4rWw89x2@casper.infradead.org>
In-Reply-To: <ZC2/Pi+M4rWw89x2@casper.infradead.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 6 Apr 2023 14:10:44 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUfmwPioxz3sbcYfw0iaBBfKG0Vx-cpNHtLF+MT5SSyFQ@mail.gmail.com>
Message-ID: <CAMuHMdUfmwPioxz3sbcYfw0iaBBfKG0Vx-cpNHtLF+MT5SSyFQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: sunhme: move asm includes to below linux includes
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Sean Anderson <seanga2@gmail.com>, Simon Horman <horms@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-m68k@lists.linux-m68k.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy,

On Wed, Apr 5, 2023 at 8:34 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Wed, Apr 05, 2023 at 02:09:55PM -0400, Sean Anderson wrote:
> > On 4/5/23 14:07, Matthew Wilcox wrote:
> > > We always include linux/* headers before asm/*.  The "sorting" of
> > > headers in this way was inappropriate.
> >
> > Is this written down anywhere? I couldn't find it in Documentation/process...
>
> Feel free to send a patch.  Generally, it should be:
>
> #include <linux/foo.h>
> #include <linux/bar.h>
>
> #include <asm/baz.h>
> #include <asm/quux.h>
>
> #include "local.h"
>
> Some drivers do this a different way with a single local.h that includes
> all necessary includes.
>
> Also if <linux/foo.h> and <asm/foo.h> both exist, you should include
> <linux/foo.h> (which almost certainly includes <asm/foo.h>)

Indeed.  Usually <asm/foo.h> should not be included directly,
except for a few exceptions like <asm/irq.h>.

Witness e.g. the (violated a lot) comment at the top of include/linux/irq.h:

    /*
     * Please do not include this file in generic code.  There is currently
     * no requirement for any architecture to implement anything held
     * within this file.
     *
     * Thanks. --rmk
     */

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
