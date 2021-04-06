Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1690355A19
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 19:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346822AbhDFRPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 13:15:46 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43209 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233879AbhDFRPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 13:15:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 7BA8217B0;
        Tue,  6 Apr 2021 13:15:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 06 Apr 2021 13:15:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=GoEiTLDY1pXs2g41QovrQQVMUjO
        q/1wsknOQcAbJGMg=; b=dZoK/1JN98g9M5gQzlQ2obMOdZpjgAooh+FFgcJjkC1
        GTXoDOtdJnr44hXM/Jp/exirSmOo3F3x4yyQrCiJjnfW3WIW4JMRBieXBERHDEA3
        mJLeJA4V6dRX2IR4TDeyzk3MwCO59Posj+xjTnvZNzcxBztQXpb5ocujoHpEYQLr
        5R38keAl8mt9quawB6BuQi4u8D2mke9QP3dsScGhjoMhdSqYNhdvV7enqwxo3U2v
        IbVUUFvWLGmnspivEPRtjnx+oWUM+cXXsVfwZpkmcLo4BHHoajtFYrfHt9P4qpB3
        G8mUIvWvqkxI50ByF/8OOIXP4yhOVk/pjo1z1c9wQOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GoEiTL
        DY1pXs2g41QovrQQVMUjOq/1wsknOQcAbJGMg=; b=qimvT3SNuBHdNuaDmVDG62
        FrR0YrHzIEY/Fgif6oCcklCY+kb27xpMqdqwf7O3Bq8f4J8EAEY+/LtzkAIYsQaO
        YR7RtwX+6qzIzjuKb8/Zc5U70vfJ/1SaACJPAs2c+zPGQ6+fsND2iW5hi3jiRZ3L
        kdunQk+MxTV9IymipC8D2Fnz9Gg9b7AVVzDgkEvtcyrpDezHXJJbzPKXgQx9DiOS
        sXo9yrlrqC0jC1G2SH6G780PsCD0X6D3ZYZlMmae9/5Bi0OEpSFdzrTZZtFExVEm
        +zN5sRJFaryaT+trF/9PHFUWtpPUjCPTvYJTHMgfWCek5teUiNgmeABRONORxJiA
        ==
X-ME-Sender: <xms:N5dsYG6lQv-6UPj15aXC60R8hNA1cIzzm5EKtyWnnSLd-pXqFa4zLQ>
    <xme:N5dsYP2EynTkCdCg2KhopmAdpHRurWu-n-H2KqABKSzOkj7PjQZChGVTgLzmi_nNN
    vgFbxHWMm1y8ndxyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejhedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtddtredttddvnecuhfhrohhmpeetlhihshhs
    rgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtffrrghtthgvrhhnpeeuff
    egffdtvdffiedttefggfehtdfgudfhfffgteefgfdugeegveffieffudduvdenucfkphep
    keegrddukedurddvgeejrdduuddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepqhihlhhishhssegvvhgvrdhqhihlihhsshdrnhgvth
X-ME-Proxy: <xmx:N5dsYBAM87wkrmK9ZT-U6RRf0LLpyn3mSJUvpJbPESIdVz5pA9Z7oA>
    <xmx:N5dsYIHX2iuRwd9uC-CQxopYD82HZzs5TJOpbCa-92qguMHg3kELCA>
    <xmx:N5dsYDpMsW8_MF-VRwoIm54j5bQgXp7cENXAlo0cXKA_K6F65XAwnQ>
    <xmx:OJdsYFGBHBi4WivbdVblNZ85nBegBn36YxdaeDn0_QKdnJiI02-G0Q>
Received: from eve.qyliss.net (p54b5f76f.dip0.t-ipconnect.de [84.181.247.111])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7940D1080063;
        Tue,  6 Apr 2021 13:15:35 -0400 (EDT)
Received: by eve.qyliss.net (Postfix, from userid 1000)
        id 53AD425D; Tue,  6 Apr 2021 17:15:32 +0000 (UTC)
Date:   Tue, 6 Apr 2021 17:15:32 +0000
From:   Alyssa Ross <hi@alyssa.is>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [iproute2] finding the name of a TAP created with %d
Message-ID: <20210406171532.dlcvtm5wzmuemhwk@eve.qyliss.net>
References: <20210406134240.wwumpnrzfjbttnmd@eve.qyliss.net>
 <20210406092231.667138c2@hermes.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="thdf7qlvao4ltylx"
Content-Disposition: inline
In-Reply-To: <20210406092231.667138c2@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--thdf7qlvao4ltylx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 06, 2021 at 09:22:31AM -0700, Stephen Hemminger wrote:
> On Tue, 6 Apr 2021 13:42:40 +0000
> Alyssa Ross <hi@alyssa.is> wrote:
>
> > If I do
> >
> > 	ip tuntap add name tap%d mode tap
> >
> > then a TAP device with a name like "tap0", "tap1", etc. will be created.
> > But there's no way for me to find out which name was chosen for the
> > device created by that command.
>
> Use a follow on ip link show or look in sysfs.
>
> > Perhaps ip should print the name of tuntap devices after they're
> > created?
>
> You can already do that with followon command, or use batch to put two commands together.

I don't think that's reliable, is it?  What happens if I create one
device, but by the time I do ip link show another one has been created?
There's no way to know for sure that the last device was created by the
command I ran.

As I understand it, the only way to avoid a race like that for sure
would be to look at the ifr_name returned by the kernel from TUNSETIFF.

--thdf7qlvao4ltylx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmBslzIACgkQ+dvtSFmy
ccA3xg//fFwhfmpJBUvabETcNZv9GDGdN7FXHwEXVXcnOOg8Xozt88vsgCADOq0O
JCNswzCPdWDbjAuPiK1+zIcKKJ/mKufATrG2Yei3LUZTlFr+nebuWbj7bZ2MpI1R
putZJT++llDG+nA4k14Llhn98EF0v11beAIzqBD8cfrxI8Sbno2jMmVMNCr7zotY
3EizTEQ3teq+jJUSXMr+6PRKGOJIzjMERv75u3wOKiPozQCf2qiwEvtZtEl/bJ4I
oguKRPBH1SxQIAzv9hz0Dp+PPI8Jl9k90sZwfwalPNPuBisqzX46eHMiu3CLi1if
r3BSYan2vLHkR8rIo5dLQUgdKanfTl7zG++rPH8tW9bndtNL4blM7/jlQMsyhsT5
/Ek9KxkM8BB8pp8tjH/hthOoUUZ2nETh29ee+c75KMnpOF0/pUsRB0IBNODGcQzH
+YVnh6QgN6BIqSXKCS1lhMC8CxZfj0S6KsnRH5Mq75O+xHbcyEx0DSGm396bdfSh
jOEWrVR5SN7kWpL5q8MaZVywvggr44UVC25lh4ei7YtIdaeZUhDK6aeJVshrewEs
k9Jb3Zg2fMXaqsjCDwv0e3em2QravIHICYx6DBYxeupvVAKsMx7auMMsqDM4fxU4
ZuevwN+m3ieNnJKKH/Vy9EhamPPO6U9b6bCVFhb1ZZUw1WBu3l4=
=l//D
-----END PGP SIGNATURE-----

--thdf7qlvao4ltylx--
