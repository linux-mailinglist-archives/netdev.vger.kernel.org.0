Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DFE522C3B
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242152AbiEKGXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242042AbiEKGXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:23:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E6E81FC7EB
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 23:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652250187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WwyljACqAbVlQtU4LAdoRLkrWe0WUBj5SX13dxtUmBw=;
        b=LLMEWoQn1bOStS/dx8iGTNnuKBT3j92eqM0pMdKdITcECbk8XGXmBIKj6gXLo2N0uMvyav
        bnzuC6R2+bCpFWgdGPhFtnqlR57XvFYAyfDq7fW0TkJ2kWXPQRTaPaoAIR+heoh2EsEB+e
        MUWW6ayLh0cUsHIukhSO0TJVGUGMz/I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-AW26DCFIOtye5jmNpaP9zA-1; Wed, 11 May 2022 02:23:03 -0400
X-MC-Unique: AW26DCFIOtye5jmNpaP9zA-1
Received: by mail-wr1-f71.google.com with SMTP id o11-20020adfca0b000000b0020adc114131so429989wrh.8
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 23:23:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WwyljACqAbVlQtU4LAdoRLkrWe0WUBj5SX13dxtUmBw=;
        b=iSNeuvPR/WTbFSDqtuzSn7Suz4LeNFXg7M3zAJkPxFUrmIoXHMwUn9na7sS0r82pX6
         m/heb2Vdbyt/6YrqJKVI8zCbxryipnyyF/4OKab4YxVEUlxwsfw032+DrCsZs1M2KvP1
         IGH/e1W1ktCzjCbeQK34JBvOhcdW1/7bVDk93ND/DfIyp1x0x0BRIAVTygeuKvTc2jiT
         cH8epI32DMn5cUMbipOJoT2D3U8a5+G5zYSXk1zZOqqYmizL4WeftZRjHf74Gc/4JLHU
         Kn6g9i9TqzLlAZtjrsEpI2OUv/h0XBDgEehcoWniDsWbDkr4QvNtGiMRwNtY/R9Ukpul
         c11g==
X-Gm-Message-State: AOAM532KXCxo2cYMsFhbtDPCLPTtWn/Bi27t5yu2HbfNYb0hHi8HSlhl
        nlK/7Fl4Vfp9IyHKgHlzg9V/aj7to1+pnEaKbzeQovnpByUj6pDGn/6QUVW7k1Bf6ReLHrSgj3K
        iYPq2v85Iks3grosl
X-Received: by 2002:a05:600c:5112:b0:394:55bd:5f9d with SMTP id o18-20020a05600c511200b0039455bd5f9dmr3210783wms.188.1652250182463;
        Tue, 10 May 2022 23:23:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcV3T8X8kCnCQofNw+5gZoO6rnCBUJnaiWHS+ZFla1vKmmL1Rqa83V1y1VetYmuhrJXc006Q==
X-Received: by 2002:a05:600c:5112:b0:394:55bd:5f9d with SMTP id o18-20020a05600c511200b0039455bd5f9dmr3210762wms.188.1652250182189;
        Tue, 10 May 2022 23:23:02 -0700 (PDT)
Received: from redhat.com ([2.55.31.58])
        by smtp.gmail.com with ESMTPSA id p19-20020a7bcc93000000b003942a244ecesm1155431wma.19.2022.05.10.23.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 23:23:01 -0700 (PDT)
Date:   Wed, 11 May 2022 02:22:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
Message-ID: <20220511021608-mutt-send-email-mst@kernel.org>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 11:23:11AM -0700, Linus Torvalds wrote:
> On Tue, May 10, 2022 at 5:24 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > A last minute fixup of the transitional ID numbers.
> > Important to get these right - if users start to depend on the
> > wrong ones they are very hard to fix.
> 
> Hmm. I've pulled this, but those numbers aren't exactly "new".
> 
> They've been that way since 5.14, so what makes you think people
> haven't already started depending on them?

Yes they have been in the header but they are not used by *Linux* yet.
My worry is for when we start using them and then someone backports
the patches without backporting the macro fix.
Maybe we should just drop these until there's a user, but I am
a bit wary of a step like this so late in the cycle.

> And - once again - I want to complain about the "Link:" in that commit.
> 
> It points to a completely useless patch submission. It doesn't point
> to anything useful at all.
> 
> I think it's a disease that likely comes from "b4", and people decided
> that "hey, I can use the -l parameter to add that Link: field", and it
> looks better that way.
> 
> And then they add it all the time, whether it makes any sense or not.
> 
> I've mainly noticed it with the -tip tree, but maybe that's just
> because I've happened to look at it.
> 
> I really hate those worthless links that basically add zero actual
> information to the commit.
> 
> The "Link" field is for _useful_ links. Not "let's add a link just
> because we can".
> 
>                            Linus


OK I will stop doing this.
I thought they are handy for when there are several versions of the
patch. It helps me make sure I applied the latest one. Saving the
message ID of the original mail in some other way would also be ok.
Any suggestions for a better way to do this?

-- 
MST

