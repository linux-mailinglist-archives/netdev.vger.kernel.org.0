Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFFBB9CE0
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 09:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbfIUHNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 03:13:06 -0400
Received: from mout.web.de ([212.227.15.3]:35391 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727600AbfIUHNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Sep 2019 03:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569049974;
        bh=AxWoEWnEVeK4mlVorc58mK18SmNuE7t6dMUDR4t2Ugo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=K6GAPcqRrmM9f9Wnh0IMXHWi4Pm6DtiGYutS753sbiLpUIeq3MUQL+PcImaXD/ad+
         sMOgh7UDMZcUxE+LJ73sHD5imr171qWW+EqRFn2cNYwSDTZPn64/LaVjt495xHaCRc
         d1a9lsIfs2hnZBIHwiT2qFWerDkDfgdrYUmlwKC4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.64.44]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MRlJB-1idqrH1jyr-00Ss8s; Sat, 21
 Sep 2019 09:12:54 +0200
Subject: Re: [0/2] net: dsa: vsc73xx: Adjustments for vsc73xx_platform_probe()
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <98fee5f4-1e45-a0c6-2a38-9201b201c6eb@web.de>
 <20190920150924.GG3530@lunn.ch> <4a220bc4-0340-d54a-70bd-7bea62257b81@web.de>
 <5d068275-796d-7d76-ba33-6eb03fb1d7cc@gmail.com>
 <20190920151230.0d290654@cakuba.netronome.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a5e3f8e6-bdb9-c5fb-2435-81a545cad121@web.de>
Date:   Sat, 21 Sep 2019 09:12:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190920151230.0d290654@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Afi8ioQs/EFRlfmlRK18fcK9DIxMplbIMPT1dV/oJmzRHiPl3Un
 qjjxmpcsN2WcsRUE9aHQpHQkBYs8bjjCH8hXs0d7YmfCfGBGimOuuiE8MsjgeDWdbY53Pbv
 1bjfJWbfXb2u2fZirfA2rh8ZrRr0mwYwtzyBHmhLogTyU7KVMQwkGAfOoIEvzcced8lwV1j
 r8wr6LRaSuVJvuUxBFxiw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wQqkgLRr5Ao=:1pdlg8Hd2erh3S6mYNYR6A
 UfCZO9xo8aLzlwm2NGjWjd40tg9/8Eaf9SsnpfWQKOj9VSLW3an52mHgfCU6pcOdMa9hLMzS4
 Q4SVsumMGH4RkAM+Uz60IDFClTZ7fYSa46KkWVv7yeELE3Xiq+mxjONO59KfXEd/n6AFO0rxO
 12F+oBFgNDKCVX5zOWOOU9C35A0l78G1ZhsFxDjLLVj2sQx+nlGgVgdtSdyFcgwiFxz+Kt0Ft
 zU8lRZgtCUql6iXYXt8OLkS3V+xk36gcAbqCPqBk+FaK8KKsv1RsF1ku69qVu+Z2CMaNzCrUb
 PfvT4QrNV5hxMOYF3hNZBWw4SOTkRu5+34tSutTxUa+ZrsR70+I4opNNPXGS66Dixwukt8DDl
 ly7tealSnZc3edrL9yFPGttB+hRhf0TA/WQ53gZBp8Ve1aAVrhHOeiuZlvTUlhYkyu0v1RbEM
 kE83G9GTe5uBw367YX/9CpGW9Y4m55Oy84QJszTnY8XA1GQHyIosqYznXfuWKBxFl2ZJ/DZpu
 Jy+3v7paJNobKINtdKnchdjyGrD5PiJ1/nOB4ZzoVANs+KhzVqSKxbAKll9BuVqu6+5Lbfwvi
 FzqXO/SzWNBw58JMCVUETz3XXOTlHJxXib2rxTPQ+VRZz4WRtMLPRLhJlEjMDyUIBzuk03aLF
 K5K3OPQ5y+8UrSDNhnkYeGg0yPvFhWFnVE84fLYIL+dds88Epes/KNQk3K3K2FBmKwADUJ8Hc
 nyPFmZfbLE0Fpykx1ND3ivbu+gIyTNIyx9aLr2gKbUR4GqAW5WV9MhbA2vRTDCdmgMjFgkFs9
 TxPnc+mPFcOxRKlY9Zpudp4PAWS2bIkqFX8sigblOKobCCAL+I5B9DzOYPOPUazCKy0uauOJH
 Bh20OQgVIu8Sh9FJbCbD0eZNhvrhQ1lH0BsOPuZEFuWxXDUXS95RsQNYcBLjfeRksUhC1TpBh
 pp9rbIXG2p9w1pzi/HZmYJ4WfRp8c4jJDlb8K0n1tZ+GbDjeW9rGadaoNLyWgET28xXAiF1DK
 X8ZrzuEB312n90w0alxvl37Tzp5cqA3UJSKUbGdZFDu8gEpsaoFRfKYpDUSun6YSbMVOTYdpc
 qE8kxfKeY4nXku4GMMSOVLr9jnyGW3zuZytqJknRzPAus52deNOZalDy/NcxpNHDt7+vGSbBZ
 e+deimnGjXhERlsfGNsiudaPZGYJumOQcSO5E2myBfobt0e4SFTrHIPN5YxNE99RS82hTNdSW
 elw0ff6RZ9d98Gj5VmoCDZmbOsUQGZAuJKFRWhUtrB5S4zHaMMpYF7vThYaA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Indeed, looks like we have a mix of clean ups of varying clarity here.
> I will just drop all, including the devm_platform_ioremap_resource()
> conversion patches from patchwork for now.

I would prefer an other patch management in this case.


> Markus, please repost them all once net-next opens.
> Sorry for inconvenience.

I would find it nicer if presented change possibilities can be
automatically reconsidered on demand after each closed period.
https://patchwork.ozlabs.org/project/netdev/list/?submitter=3D76334&state=
=3D*
https://patchwork.ozlabs.org/project/netdev/list/?submitter=3D65077&state=
=3D*&archive=3Dboth

Regards,
Markus
