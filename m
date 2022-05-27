Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E16535F55
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 13:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351312AbiE0LgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 07:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350996AbiE0LgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 07:36:13 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB4562CC8;
        Fri, 27 May 2022 04:36:10 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id i1so3914673plg.7;
        Fri, 27 May 2022 04:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vKksjFG1JDH4G5KHVJkfgCOyerv56km+S53+dQLqcow=;
        b=Eca3DzGY1RdUD7rSSsFCjjCkRqVrJa2xxaIKMm4YqzTlK5oCXz6ZWyt/qhob0DSjSk
         jiQuSqqkf2bUL46wYJs5wY0MgleBa2egn5I7wx/ZyH60JnhQmzKkGPOVO66QATy4GLTT
         GYhFPs2K+Qgnd1hewCiNQanSzzVDfk9kGVrtuz39vwDXdhKTXUkUHhJ5CLUjqh3l9PEo
         DluJaZujn9Nr899OGBCiJKquKoEBwyzKbhuGkbcjRye6HZVcQhCTbYbRqrD+rncnDF9M
         atpHD8PsRad2NCHfHKG0gX1q9+d+lh1jnsonTJBHJWHIMAb7gSf6jkXj/5d54j4CGCuN
         4Xsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vKksjFG1JDH4G5KHVJkfgCOyerv56km+S53+dQLqcow=;
        b=cPXJiEhwAyd6617gMlsMGBZplGS4XDksv6Gc4KIjGj1AnVl6uHP39xvOETzK1uRw57
         McjdcIx7a4qG40uRlq3ifp2N7Xsf79PQCfgyi9xpDuo6mFxRNS+j6Gew9ERX9EK8uuEo
         ATkuD2fh4x4NFInvZAQuy8jI753pDjfeJwDEp/rYAGjGhlBO3+9nQMfcFnoXBwH1MBeI
         zKQ1RsAroZgYJz24g30eC9mtJ11nVVPglDRIi9otyASYpqMKVQENpprSaUep8vjbJ7W2
         mSoChFKJFEMo8Q0GlqrLqnkCS0MQozi1LXsfIv7cGpXwUC3jpbrfIVPPUnkhtJXSJATi
         OHlw==
X-Gm-Message-State: AOAM533KzrA9t+QGzP+GQHrFlky/Zie2B3YnID6izRu7mqiLR6Vw6ccF
        lkfyuO9k3Dk8/hYjor5P9yw=
X-Google-Smtp-Source: ABdhPJxCZn8A0zHsvBdlQvXjJmskFO9NaJWbYplnZkH5Bd9eSI/BzA4WGPq1E2gSioJUsusEM+Ykhw==
X-Received: by 2002:a17:90a:c484:b0:1e0:8e20:ff14 with SMTP id j4-20020a17090ac48400b001e08e20ff14mr7926939pjt.182.1653651370102;
        Fri, 27 May 2022 04:36:10 -0700 (PDT)
Received: from localhost ([157.51.122.0])
        by smtp.gmail.com with ESMTPSA id w66-20020a626245000000b0050dc76281e1sm3221704pfb.187.2022.05.27.04.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 04:36:09 -0700 (PDT)
Date:   Fri, 27 May 2022 17:06:06 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com, yhs@fb.com
Subject: Re: [PATCH v4 bpf-next 06/14] bpf: Whitelist some fields in nf_conn
 for BPF_WRITE
Message-ID: <20220527113343.h3q5zmkmqm7fev7r@apollo.legion>
References: <cover.1653600577.git.lorenzo@kernel.org>
 <2954ab26de09afeecf3a56ba93624f9629072102.1653600578.git.lorenzo@kernel.org>
 <20220526214558.GA31193@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526214558.GA31193@breakpoint.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 03:15:58AM IST, Florian Westphal wrote:
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> >
> > Since we want to allow user to set some fields in nf_conn after it is
> > allocated but before it is inserted, we can permit BPF_WRITE for normal
> > nf_conn, and then mark return value as read only on insert, preventing
> > further BPF_WRITE. This way, nf_conn can be written to using normal
> > BPF instructions after allocation, but not after insertion.
> >
> > Note that we special nf_conn a bit here, inside the btf_struct_access
> > callback for XDP and TC programs. Since this is the only struct for
> > these programs requiring such adjustments, making this mechanism
> > more generic has been left as an exercise for a future patch adding
> > custom callbacks for more structs.
>
> Are you sure this is safe?
> As far as I can see this allows nf_conn->status = ~0ul.
> I'm fairly sure this isn't a good idea, see nf_ct_delete() for example.

This only allows writing to an allocated but not yet inserted nf_conn. The idea
was that insert checks whether ct->status only has permitted bits set before
making the entry visible, and then we make nf_conn pointer read only, however
the runtime check seems to be missing right now in patch 12; something to fix in
v5. With that sorted, would it be fine?

--
Kartikeya
