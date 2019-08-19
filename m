Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FEE94C71
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfHSSP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:15:57 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41662 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfHSSP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 14:15:56 -0400
Received: by mail-qt1-f193.google.com with SMTP id i4so2929733qtj.8
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 11:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bs5L+qkzRV9dDTyGcq3nzvwWPlKthL1KJX4yczCTVN4=;
        b=ZtZ64+Xp73NFn45pV0jdesznI+l2j5EdE+s6u/13o9zmJ3TQBw3Hn4U+554ogUCpZP
         8nwdr+K/OkzdwCEGl2RyNKZchTzgtVmrmeeEA7U1qfhaIJDlwKsfsIyTiLwMt9KXGifc
         vunkVVit3dkSnO5f62q2FOGUgUbgpofJmMl4CWjG6Q8vg/KOYs0p8zalY3uLGPbOuzN0
         y0ZM+5cRWYgYE4kul3pYP2RM/uv3u0ecIEP6LzdcQDQP+tJyyR/BFbwmVbfrCUehtXhb
         MPWsHZnfFWj7m/pTkwnyKxSEklLLOBJTrEbhTFG22/9B4FsOI4vQSYT/rmMHrjd4Mr9f
         +SmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bs5L+qkzRV9dDTyGcq3nzvwWPlKthL1KJX4yczCTVN4=;
        b=jOqao6TN/CFPvzIT+XPQ5p43ibJ1Bev35sgIoLGd2eGe1ool19/oiZtWMgTeCavyXR
         aOjrDMtzGx/sBff/Hs91iKgvtm+kHJuf47mFxwvlxvtMaGRzoRRSBo6BDRdrhJuURxuG
         p/XVN66jrOr5wESWIY2RcufuEKlpE9Kf6fkUPBAWkda2kL9mUb8e/ZLZyEgJv0EM/mXi
         yHBnmwqsDBkH3sV4rA+PI+kc3x+KmqhiIkKIsLg3Rv3YPxU0mqYrCcrLT5J6Cx98Tzxg
         zcZt8QQaHuk3lEM6NOL1/h23Jz/1OFPTUrQ8pMczrTiLdH36/+r8U+/a2h2fmmkvkJht
         Fm2A==
X-Gm-Message-State: APjAAAUk+DLGrMIkw5sP3WWYE09e0LAonSISQFkPxcwqHnYYsJquDH0h
        UlCXloxiaJjhky06g7hyjwt78w==
X-Google-Smtp-Source: APXvYqwB0Rp8XJeOPWgqkJ/09NaTgfVUfx9epHFffJ7HlToOx4IVXpNT5+50w8W/CnrRCKL+2kv/CA==
X-Received: by 2002:ac8:6112:: with SMTP id a18mr22408793qtm.272.1566238555538;
        Mon, 19 Aug 2019 11:15:55 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b202sm7224092qkg.83.2019.08.19.11.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 11:15:55 -0700 (PDT)
Date:   Mon, 19 Aug 2019 11:15:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
Message-ID: <20190819111546.35a8ed76@cakuba.netronome.com>
In-Reply-To: <5e9bee13-a746-f148-00de-feb7cb7b1403@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
        <20190814170715.GJ2820@mini-arch>
        <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
        <20190815152100.GN2820@mini-arch>
        <20190815122232.4b1fa01c@cakuba.netronome.com>
        <da840b14-ab5b-91f1-df2f-6bdd0ed41173@gmail.com>
        <20190816115224.6aafd4ee@cakuba.netronome.com>
        <5e9bee13-a746-f148-00de-feb7cb7b1403@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Aug 2019 23:01:59 +0900, Toshiaki Makita wrote:
> On 19/08/17 (=E5=9C=9F) 3:52:24, Jakub Kicinski wrote:
> > On Fri, 16 Aug 2019 10:28:10 +0900, Toshiaki Makita wrote: =20
> >> On 2019/08/16 4:22, Jakub Kicinski wrote: =20
> >>> There's a certain allure in bringing the in-kernel BPF translation
> >>> infrastructure forward. OTOH from system architecture perspective IMHO
> >>> it does seem like a task best handed in user space. bpfilter can repl=
ace
> >>> iptables completely, here we're looking at an acceleration relatively
> >>> loosely coupled with flower. =20
> >>
> >> I don't think it's loosely coupled. Emulating TC behavior in userspace
> >> is not so easy.
> >>
> >> Think about recent multi-mask support in flower. Previously userspace =
could
> >> assume there is one mask and hash table for each preference in TC. Aft=
er the
> >> change TC accepts different masks with the same pref. Such a change te=
nds to
> >> break userspace emulation. It may ignore masks passed from flow insert=
ion
> >> and use the mask remembered when the first flow of the pref is inserte=
d. It
> >> may override the mask of all existing flows with the pref. It may fail=
 to
> >> insert such flows. Any of them would result in unexpected wrong datapa=
th
> >> handling which is critical.
> >> I think such an emulation layer needs to be updated in sync with TC. =
=20
> >=20
> > Oh, so you're saying that if xdp_flow is merged all patches to
> > cls_flower and netfilter which affect flow offload will be required
> > to update xdp_flow as well? =20
>=20
> Hmm... you are saying that we are allowed to break other in-kernel=20
> subsystem by some change? Sounds strange...

No I'm not saying that, please don't put words in my mouth.
I'm asking you if that's your intention.

Having an implementation nor support a feature of another implementation
and degrade gracefully to the slower one is not necessarily breakage.
We need to make a concious decision here, hence the clarifying question.

> > That's a question of policy. Technically the implementation in user
> > space is equivalent.
> >=20
> > The advantage of user space implementation is that you can add more
> > to it and explore use cases which do not fit in the flow offload API,
> > but are trivial for BPF. Not to mention the obvious advantage of
> > decoupling the upgrade path. =20
>=20
> I understand the advantage, but I can't trust such a third-party kernel=20
> emulation solution for this kind of thing which handles critical data pat=
h.

That's a strange argument to make. All production data path BPF today
comes from user space.

> > Personally I'm not happy with the way this patch set messes with the
> > flow infrastructure. You should use the indirect callback
> > infrastructure instead, and that way you can build the whole thing
> > touching none of the flow offload core. =20
>=20
> I don't want to mess up the core flow infrastructure either. I'm all=20
> ears about less invasive ways. Using indirect callback sounds like a=20
> good idea. Will give it a try. Many thanks.

Excellent, thanks!
