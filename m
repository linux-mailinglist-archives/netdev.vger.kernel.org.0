Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233FB52B1B8
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 07:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiERE6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 00:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiERE6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 00:58:07 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18DC4990E
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 21:58:05 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e3so1056498ios.6
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 21:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rmEVSz8Ov4VLePaxRqZlqBSc68Uu6/Lnq8r0Z264Ghc=;
        b=RejBYio0j313jVh3W/Nq3YuXD1TuXQazMZACV5LqhPHNcgPwi3ZFH1K03KiYiGw3TA
         WVH9aJMaoFkrIaAz107LNiB2dgwToZOtt/JN/87V8KzEScELToOctTLGYsYEz+AlRLaW
         EBL9kbjZ/I6mMPduR/tfRGJ9lTpKIJ746vPV/UUbYFwp38TUX+oFLdOurmRQgdVvBTtQ
         dyRqV0QKr5le6vjXHdBSHAtgi1EV4acPglMPDSttFLzQQHIojU8u2TLKUXS6vqJ6Bv6Z
         ICuKpb6k3hrNxXoKnhR3BCl6dWVOgpn74GDVaQmVIEICw8PVE9IyrqPdYNRkIo/xlEql
         anSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rmEVSz8Ov4VLePaxRqZlqBSc68Uu6/Lnq8r0Z264Ghc=;
        b=VQsxCr2Fd7muPyD2JgoJEWoZgCKoyVZpmpqm8Cdeu1gJ9912RF5fLIke9WUpwWZ7Zg
         9XHqzKS/tFBTmQAhcR1rgaF9uu1L2Ym6NWxtoABT3ThtanomOF/2G3opEIzlUBU+WDlu
         SwNcELsQ+O9Wx7Furg2Rbs98JgMnWfQNmOwVPSRsx9Z5P3NbVqPKQPaZZ0zeyV4arAKb
         PKVonWARra7yxPHyPE7oj7+sytO6vxIJVCvrfSeRWhFAqp2o56PEr7uOVl6IBBNK16eK
         fdKwQf+AKuAloSCiR3Ty9QaHrQPvQ+AxS2orIZbHX6cGtP7Y3iVLmRSE6sjjasy9yWf4
         r6IQ==
X-Gm-Message-State: AOAM530tkCdlDlpkp3dET4mXtAMsSpRdRviAHqjDD7AOwfCVotthggjt
        f5Uk8j3D26zl6AaOmQ3PbXxbkqp84kjXIfCtln5krOSoelo=
X-Google-Smtp-Source: ABdhPJxaCEFKanUDhjp6nFe5x25mWTq2EI5m/39SlwK/6jlpZ0PsZUOLerEnVX+9/QRZuFi1I35l3ELVtJDjMl2y3I0=
X-Received: by 2002:a05:6638:516:b0:32e:26e7:30b3 with SMTP id
 i22-20020a056638051600b0032e26e730b3mr8424824jar.287.1652849885225; Tue, 17
 May 2022 21:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220512205041.1208962-1-joannelkoong@gmail.com>
 <20220512205041.1208962-2-joannelkoong@gmail.com> <CANn89iKryk30MM=XuwDmdZ7T_rDJUe+zZrZMsaPXQG2mghe6tQ@mail.gmail.com>
In-Reply-To: <CANn89iKryk30MM=XuwDmdZ7T_rDJUe+zZrZMsaPXQG2mghe6tQ@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 17 May 2022 21:57:54 -0700
Message-ID: <CAJnrk1Y+6zVBVNd+YW4Qwmk_KJPbSVLXX74QnWRGmtr_zy5VWg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/2] net: Add a second bind table hashed by
 port and address
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 9:59 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, May 12, 2022 at 1:51 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > We currently have one tcp bind table (bhash) which hashes by port
> > number only. In the socket bind path, we check for bind conflicts by
> > traversing the specified port's inet_bind2_bucket while holding the
> > bucket's spinlock (see inet_csk_get_port() and inet_csk_bind_conflict()).
> >
> > In instances where there are tons of sockets hashed to the same port
> > at different addresses, checking for a bind conflict is time-intensive
> > and can cause softirq cpu lockups, as well as stops new tcp connections
> > since __inet_inherit_port() also contests for the spinlock.
> >
> > This patch proposes adding a second bind table, bhash2, that hashes by
> > port and ip address. Searching the bhash2 table leads to significantly
> > faster conflict resolution and less time holding the spinlock.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>
> Scary patch, but I could not find obvious issues with it.
> Let's give it a try, thanks !
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
Thanks for reviewing this code, Eric.

I will submit a v5 that tidies up some of the things flagged by
patchworks [1] (removing the inline in the "static inline bool
check_bind2_bucket_match(...)" function in net/ipv4/inet_hashtables.c
and adding line breaks to keep the lengths to 80 columns)

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20220512205041.1208962-2-joannelkoong@gmail.com/
