Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD0C453201
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 13:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbhKPMWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 07:22:11 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:52128 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbhKPMV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 07:21:58 -0500
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637065134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UxstMfuhLeN5/jMedYHgGOo7lkIy2tu51aj5ea1+e58=;
        b=uYIo1Vt2tdTSXYliTzbzT6S6b0CrV5Gr4nA28gFpToXF5O1N1997tpEdijFmcGr5/r5rL4
        xQiUKC3xXFEah3n3usNFY2C7CBGNXHqVaQw5MHliEHhtRzwQeuRbG81nlA/0ivud4wmSos
        +zNO658/K2HU0nOQX2NdXim4vTEjkmwpZJ/hwyZZYN5LGpMqv3ENg/yKU3cO1pivb8g7Si
        4zNhT0YNQwKWaQM27+jk13Fy32qLvCnkSEHCRg5m12EGfyi6dD9U8ZnRJsHK/qadvmljqg
        VpeVYeXpg5pCmI1+z53GAKcTL1VtU121h3n6zoCuNUZ4DOfXjklRM9Yv1Eg8fA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637065134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UxstMfuhLeN5/jMedYHgGOo7lkIy2tu51aj5ea1+e58=;
        b=ZmZWJTEapiDDCqzr36mlSXGjduoTOQVb+V2nbXl+6eLeRFytjAZFC/T1Kz7KiZGBc2J97j
        3beddcUAXXZMzHBQ==
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: Re: [PATCH net] net: stmmac: allow a tc-taprio base-time of zero
In-Reply-To: <144f229b-fc8b-92fd-1031-f24fcc740064@oss.nxp.com>
References: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
 <87bl2t3fkq.fsf@kurt> <20211109103504.ahl2djymnevsbhoj@skbuf>
 <87h7cl1j41.fsf@kurt> <144f229b-fc8b-92fd-1031-f24fcc740064@oss.nxp.com>
Date:   Tue, 16 Nov 2021 13:18:53 +0100
Message-ID: <87v90s9tua.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Yannick,

On Tue Nov 09 2021, Yannick Vignon wrote:
> Hi Kurt,
>
> On 11/9/2021 3:47 PM, Kurt Kanzenbach wrote:
>> On Tue Nov 09 2021, Vladimir Oltean wrote:
>>> On Tue, Nov 09, 2021 at 09:20:53AM +0100, Kurt Kanzenbach wrote:
>>>> Hi Vladimir,
>>>>
>>>> On Mon Nov 08 2021, Vladimir Oltean wrote:
>>>>> Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
>>>>> base_time is in the past") allowed some base time values in the past,
>>>>> but apparently not all, the base-time value of 0 (Jan 1st 1970) is st=
ill
>>>>> explicitly denied by the driver.
>>>>>
>>>>> Remove the bogus check.
>>>>>
>>>>> Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO schedule=
r API")
>>>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>>
>>>> I've experienced the same problem and wanted to send a patch for
>>>> it. Thanks!
>>>>
>>>> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
>>>
>>> Cool. So you had that patch queued up? What other stmmac patches do you
>>> have queued up? :).
>>=20
>> I'm experiencing some problems with XDP using this driver. We're
>> currently investigating.
>
> Could you elaborate a bit?

It was a combination of oddities within the PCP based VLAN steering and
bugs in my application. No driver issues.

The last issue I have is packet loss from time to time. Still debugging.

> I've been using XDP a lot with the stmmac driver recently, and while I=20
> did see issues initially, most of them got fixed by using a recent=20
> enough kernel, thanks to the following commits:
> . a6451192da2691dcf39507bd ("net: stmmac: fix kernel panic due to NULL=20
> pointer dereference of xsk_pool")
> . 2b9fff64f03219d78044d1ab ("net: stmmac: fix kernel panic due to NULL=20
> pointer dereference of buf->xdp")
> . 81d0885d68ec427e62044cf4 ("net: stmmac: Fix overall budget calculation=
=20
> for rxtx_napi")
>
> There was one remaining issue for which I need to push a fix: if you=20
> remove an XDP program from an interface while transmitting traffic, you=20
> are likely to trigger a kernel panic. I'll try to push a patch for that=20
> soon.

OK, great.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJSBAEBCgA8FiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGToa0eHGt1cnQua2Fu
emVuYmFjaEBsaW51dHJvbml4LmRlAAoJEHkqW4HLmPCmNfkP/21fsU6JI1QnFA6+
d5SZvciv0J2GEQ4aSXLeixh3ciUdx66t5+Sug8hen2yCJcEsbl6nCpIg/I0JcpZG
OYvSvnj2FC1CfHPqaqeDaslMcUtKtUjsvC2T7RnO5avSgn9otk9p7khEVd1VOWwL
Q7Cq+ee5ykcQ5UE180RtkGrL/9qRmRhKYEifvGdyJoQE7VagXXD/wlnk5Wbjvhfw
JrXpnBMtiQbrRzgRtYtnjqDMW+M4HGVSDVe0LOIhcR7MD0vm8kyJ15Q38Oepn+xI
c6W7mIlhBtw0lDwaX9lsj7Mk5mfF72Op0qzA+FtmYxw1tzH6yZyHpyQK3Jkl4KRu
qkF4wmLpac/SWJCWj23lTanxohDpw1Hf3jsKJBD2221/2cFBjbDmEDKCpJQz4cMX
3kZvPse5CyaQ2C/Bf87yIJrkxh+sxfixj0TIECMDgNsTjY8yS0uZ+GffLkfkDzjx
/AVs58RoSJBVWcA7zFdd/jTo9kcYe9vx/w8dYumA7XIBy4gRon2M8m11bjMnnSul
bwDoWI6VYqgTLTogZWvdPodr3bo+cEDfgBowbfbSuGMqCk0KP0zrIV6TJxDSkQK6
iC0n8vd3+CDv3/ZwbVCK+Zg561D/gvLYyrO9l7xeYBUyAjME6/XDIoBAgHln8eST
O4VKyIuoB+PNyWz6O9T1BCkssk1h
=M39l
-----END PGP SIGNATURE-----
--=-=-=--
