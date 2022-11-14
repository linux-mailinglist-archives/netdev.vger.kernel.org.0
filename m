Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EDA627591
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 06:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbiKNFjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 00:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiKNFja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 00:39:30 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E327DFE8
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 21:39:30 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id v17so9136016plo.1
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 21:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bksddp3q/lYwoKUWg/oUz49rom5BtctrlQr4zROL7us=;
        b=M7TgyvMubl0KGgn9+g5Zoz3p0olx3mLYiipjoJ/1OY8TIlzyaPttVmt0oGr+XcQ7VR
         obEk6788SjxosbIBvWsLeccoWPk1VieboTQSnD0OWvbDLdWQOkWaeuY0A5QNivSk+WHw
         +iM9Xsp8l/WWN60umlGmBCHLQ6gBuydrDRhLWxRcuX9pRl5tGHA8vnpPxE6jDx1eALU0
         3E4kzvcJ2WY0QS28j1ILmusW4O/zt4QQJhsgCxpfAjvcK2wEMmHyTfHdsELjzI7CSkuj
         7qTZPb/vItCu3RZEB9to6SasngU+/n/c4QKT3SpYjRaCATxBUGCHN+1LUwZQiYxb7zzu
         PKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bksddp3q/lYwoKUWg/oUz49rom5BtctrlQr4zROL7us=;
        b=zeCVNMgx0yIRBj82mPWFnPC5kAgy9AD32ODA8pPV+JnDZ3a4xASSeZbkPkFCl9vDPK
         Um/t91xHBcyPpq5tY3ePJuVfuLBVP1T/AMuSRqaA9Rydl7m8sH1ylEQO1v7nlJXR2Iiv
         neHIk4bg70gEQuJRI4KjPdRHN4ByH56784oidcJpxDKsZrQygw4OmHFnLLeYfaXwm2bj
         f1bvfjeH6XvOOs8ZPMDXWGmaELJJJ9k22o/Uvh6topgnzKss18z6GRmookn1LXh/Ge80
         wfFzuXwM5a/DyKBH/ZFnxYdzpU1nhgNGds3AfzPyseUoxetZDGOgIK4XDi8WWcYHm13+
         v/PA==
X-Gm-Message-State: ANoB5pk7szmTiqNZq+/WouBn0dpP3PSxVPtIGYXddPU3eo/m4KqNm8nE
        fEhFeJ8WoyxSNccamFI583qSom6YQTa3E9aaOU2CRLf3iGE=
X-Google-Smtp-Source: AA0mqf5KMncBccX3pzo97cmpvq3ZSPzAWxE1lrMRyoDnFoPFjQfdWZ/f0+WO8A1INU8/X1iOu55D1hQdLMq+ZSgBb9g=
X-Received: by 2002:a17:90a:7442:b0:212:d686:f99f with SMTP id
 o2-20020a17090a744200b00212d686f99fmr12171752pjk.109.1668404369623; Sun, 13
 Nov 2022 21:39:29 -0800 (PST)
MIME-Version: 1.0
References: <CAL87dS2SS9rjLUPnwufh9a0O-Cu-hMAUU7Xa534mXTB9v=KM5g@mail.gmail.com>
 <CAL87dS1Cvbxczdyk_2nviC=M2S91bMRKPXrkp1PLHXFuX=CuKg@mail.gmail.com> <Y3GZAEFaO2zp5SbJ@pop-os.localdomain>
In-Reply-To: <Y3GZAEFaO2zp5SbJ@pop-os.localdomain>
From:   mingkun bian <bianmingkun@gmail.com>
Date:   Mon, 14 Nov 2022 13:39:18 +0800
Message-ID: <CAL87dS2XjE2f0+HJ4DH4zzQwz1K-LYQx0rV0t=sbs343pxar2Q@mail.gmail.com>
Subject: Re: [ISSUE] suspicious sock leak
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> =E4=BA=8E2022=E5=B9=B411=E6=9C=8814=E6=
=97=A5=E5=91=A8=E4=B8=80 09:25=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, Nov 13, 2022 at 06:22:22PM +0800, mingkun bian wrote:
> > Hi,
> >
> > bpf map1:
> > key: cookie
> > value: addr daddr sport dport cookie sock*
> >
> > bpf map2:
> > key: sock*
> > value: addr daddr sport dport cookie sock*
>
> So none of them is sockmap? Why not use sockmap which takes care
> of sock refcnt for you?
>
> >
> > 1. Recv a "HTTP GET" request in user applicatoin
> > map1.insert(cookie, value)
> > map2.insert(sock*, value)
> >
> > 1. kprobe inet_csk_destroy_sock:
> > sk->sk_wmem_queued is 0
> > sk->sk_wmem_alloc is 4201
> > sk->sk_refcnt is 2
> > sk->__sk_common.skc_cookie is 173585924
> > saddr daddr sport dport is 192.168.10.x 80
> >
> > 2. kprobe __sk_free
> > can not find the "saddr daddr sport dport 192.168.10.x 80" in kprobe __=
sk_free
> >
> > 3. kprobe __sk_free
> > after a while, "kprobe __sk_free" find the "saddr daddr sport dport
> > 127.0.0.1 xx"' info
> > value =3D map2.find(sock*)
> > value1 =3D map1.find(sock->cookie)
> > if (value) {
> >     map2.delete(sock) //print value info, find "saddr daddr sport
> > dport" is "192.168.10.x 80=E2=80=9C=EF=BC=8C and value->cookie is 17358=
5924, which is
> > the same as "192.168.10.x 80" 's cookie.
> > }
> >
> > if (value1) {
> >     map1.delete(sock->cookie)
> > }
> >
> > Here is my test flow, commented lines represents that  sock of =E2=80=
=9Dsaddr
> > daddr sport dport 192.168.10.x 80=E2=80=9C does not come in  __sk_free=
=EF=BC=8C but it
> > is reused by =E2=80=9D saddr daddr sport dport 127.0.0.1 xx"
>
> I don't see this is a problem yet, the struct sock may be still reference=
d
> by the kernel even after you close its corresponding struct socket from
> user-space. And TCP sockets have timewait too, so...
>
> I suggest you try sockmap to store sockets instead.
>
> Thanks.

Hi,

I do not use sockmap in this scenario.

Traffic model is about 20Gbps external traffic and 80Gbps lo traffic,
only external traffic can insert bpf map.
The old sock will be reused only if the old sock exec "__sock_free"
whether  referenced or not by the kernel, but my test result is not
so.
And TIME_WAIT state still release the sock immediately=EF=BC=8C then create
tcp_timewait_sock instead of sock in function 'tcp_time_wait'.

My kernel is 4.18.0.

Thanks.
