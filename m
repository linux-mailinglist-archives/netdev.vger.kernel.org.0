Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F23466223
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 12:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357223AbhLBLSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 06:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbhLBLSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 06:18:06 -0500
X-Greylist: delayed 2149 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Dec 2021 03:14:43 PST
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35D5C06174A;
        Thu,  2 Dec 2021 03:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6ZX4/rDyI9TC6fZAy8o9U/KWfl5nBYItNLL25UAVrsg=; b=DhAdne7fPcy62bDjH98bPlxMg/
        zddh7n20+1xp+S9rgOZHz4iKc+4/KU3KbB1mIKlN4uvPLokHjkiBg39Sc2jLMQr6IP+NSbc3+2zUv
        Yh2yS0ZYyrjnv4OBL4g1jb/sB8Ydb6BgR07htGaum4J7eCFEmtmjdzGOIJKwapSLFL0fM3IXGjfOl
        QFlOGCoPqRzEBm8sTHSFbpTTKHXKlkaalEjveqe5HcPLPPu/e4N3jVs6yYTAXcORH6LyyYaQJgH1z
        J9yVbYxy3clvBfR43CAid6ZBQWhtQ0Q3hB7Xe5Ls9+51pnrACzjbwgPTf9wAeyMRnrm40ynTAzHjc
        lBo7DtrA==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1msjTn-00Cwc2-G8; Thu, 02 Dec 2021 10:38:19 +0000
Date:   Thu, 2 Dec 2021 10:38:15 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Bixuan Cui <cuibixuan@linux.alibaba.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        leon@kernel.org, w@1wt.eu, keescook@chromium.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH -next] mm: delete oversized WARN_ON() in kvmalloc() calls
Message-ID: <YaiiFxD7jfFT9cSR@azazel.net>
References: <1638410784-48646-1-git-send-email-cuibixuan@linux.alibaba.com>
 <20211201192643.ecb0586e0d53bf8454c93669@linux-foundation.org>
 <10cb0382-012b-5012-b664-c29461ce4de8@linux.alibaba.com>
 <20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sT98d0V/FmLH+krX"
Content-Disposition: inline
In-Reply-To: <20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sT98d0V/FmLH+krX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2021-12-01, at 20:29:05 -0800, Andrew Morton wrote:
> On Thu, 2 Dec 2021 12:05:15 +0800 Bixuan Cui wrote:
> > =E5=9C=A8 2021/12/2 =E4=B8=8A=E5=8D=8811:26, Andrew Morton =E5=86=99=E9=
=81=93:
> > >> Delete the WARN_ON() and return NULL directly for oversized
> > >> parameter in kvmalloc() calls.
> > >> Also add unlikely().
> > >>
> > >> Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
> > >> Signed-off-by: Bixuan Cui<cuibixuan@linux.alibaba.com>
> > >> ---
> > >> There are a lot of oversize warnings and patches about kvmalloc()
> > >> calls recently. Maybe these warnings are not very necessary.
> > >
> > > Or maybe they are.  Please let's take a look at these warnings,
> > > one at a time.  If a large number of them are bogus then sure,
> > > let's disable the runtime test.  But perhaps it's the case that
> > > calling code has genuine issues and should be repaired.
> >
> > Such as=EF=BC=9A
>
> Thanks, that's helpful.
>
> Let's bring all these to the attention of the relevant developers.
>
> If the consensus is "the code's fine, the warning is bogus" then let's
> consider retiring the warning.
>
> If the consensus is otherwise then hopefully they will fix their stuff!
>
> > https://syzkaller.appspot.com/bug?id=3D24452f89446639c901ac07379ccc7028=
08471e8e
>
> (cc bpf@vger.kernel.org)
>
> > https://syzkaller.appspot.com/bug?id=3Df7c5a86e747f9b7ce333e7295875cd4e=
de2c7a0d
>
> (cc netdev@vger.kernel.org, maintainers)
>
> > https://syzkaller.appspot.com/bug?id=3D8f306f3db150657a1f6bbe1927467084=
531602c7
>
> (cc kvm@vger.kernel.org)
>
> > https://syzkaller.appspot.com/bug?id=3D6f30adb592d476978777a1125d1f680e=
dfc23e00
>
> (cc netfilter-devel@vger.kernel.org)

The netfilter bug has since been fixed:

  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?i=
d=3D7bbc3d385bd813077acaf0e6fdb2a86a901f5382

> > https://syzkaller.appspot.com/bug?id=3D4c9ab8c7d0f8b551950db06559dc9cde=
4119ac83
>
> (bpf again).

J.

--sT98d0V/FmLH+krX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGoohAACgkQKYasCr3x
BA1LEg/9EsWoxlPj8GB9UCjUy4vKBvWJalWrQpvWej9DHMbRhV2UH4SOMXMyEoro
ukt29Co69KOMZ5HpPRGMmcjA0P+ZtCIk7zCD1c4wCmVssGpH9agykLfpgRzqyS8C
21S94Uy7hJjK4j3LuYZHFBMacFATP5ejqx6xdgB7ANuqu/sMAKFcp3S6NxskrADc
Kq+dCd0M5yhNodBn0STRP/91MeQNxFfAdzKGphyF3iRwratHJkjmuoevaa6lZEn1
wND3FYczcWYROaKHdnWxORcwAPrveAwZNjnuDZIuDrws7jO58PCGh3E1wBla5u9A
i77mqMC298p6+7ms2/H49illteoyo3+mVvMoECA7xf/B4VKCnw8kn+bA25tNNrNw
gX0Q8KWNagQe7HPeKXvoHY5XgEauCHq6aOEORNgzm96Bi3HAQZxSHVgNmAkV2GBG
TXia7IUAqoqoOuABryAWsO52NpjSXND6GuFixbbIrfXBDiic2Vimk1MSQcwSV7om
ybTKdZWLyo6ARJzLx/yxFNiiWU63FJi/6twlOMgoQAFVBIY4UsgWYJYix8RD1E5o
56m/B49uEaLI/Vdd9YanE0yIVIpAxMSzf5DmIj1pfOQ2g3NplmjR3TH2MCpwB5jt
EN3oIIfoNunZPSh0rzPrzurSBX5nBSiA2vJgOeb1zZOPm1kJHNs=
=z1bg
-----END PGP SIGNATURE-----

--sT98d0V/FmLH+krX--
