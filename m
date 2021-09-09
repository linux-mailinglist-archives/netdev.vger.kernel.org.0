Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042FA405B2F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 18:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238929AbhIIQsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 12:48:10 -0400
Received: from mout.gmx.net ([212.227.17.20]:38001 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhIIQsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 12:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631206010;
        bh=QxZAkZqlho/J9IwDDFNM1foB3IdvDvT3798/E2VPsJc=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=CmfZXWjtqeTY2seJ3LnyhvrYf6IAt7lxSXwcaiymDqlDIhB6u123h+5faWcTRxDVd
         vm8B2ix/fySykbZAWVKyZyhEHqhkkQXY0XW1rI8vwbHGGvpHXTIUnqeCo9fjCHhb7s
         +eHj0ipQWzISzYudBoVd+fLKNGr+fzeIywT6o7AY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MS3mt-1mUipN1APz-00TTHY; Thu, 09
 Sep 2021 18:46:50 +0200
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <YTokNsh6mohaWvH0@lunn.ch>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <8d168388-4388-c0ec-7cfa-5757bf5b0c24@gmx.de>
Date:   Thu, 9 Sep 2021 18:46:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YTokNsh6mohaWvH0@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:r06BYnCbv+HAOJFP1MlkD37lF+DCF/QAEaCdii1bGJZrqbRbdvF
 qDU1EsYbznL0Ekr6uDKQz653kD+mNLmmfFn3bDUWfxUp376jyDbcMKzZ6ZmVhf0V+MVfHGh
 q75zJ5C4UEf0X6//ltxW5uLt2h95IDEKFS5O3MHUyTtBBmVp/tRpcSlaIgGVQ1y8O3j0PSD
 oWWUsfiw9qBRaWL4OFAJQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:h5T4Cdg5vvE=:05epvPVZcjAf9+37A2POmU
 E/7wq8y1sRyamgRsWas86ckRHfgLDorW2OakDu9TkgdnZpKX6gGW3WJ0kZnzi53nleM9hWM4e
 2QjotD2GaAuLHBDAltrve73Wa6U8iuNk8Bc/lUqPNYPZzaxkfqtlB67E8CL/hgDLhqpPsDOx7
 lsW80HKfEI0cdFMbnUc7o1YBQmCHamo/Jir0HCGB2HrQ7Yf9K41lvZ2VU1y0hCWzbOHfZ89Ar
 07KYV4EI+b0AY46rxhNdyEIZb2jMhpiylz/ycq0Rn53+iI4uXUIdfVgRqalN9cBjzVLJODSyD
 qDEh2s3owtrn67+fLwPIbaaELu+HNlmycWbHvwq5zLkaefELPF5KXpIe6mzndtjQqE/1iOYio
 wUNWa1vyn5u9lG5c4+hKfd/6fs1EkpGrsKmqYZa5mG4JtKY3JkWCXRoq7uAB6y+zaRfi+c9rO
 Xp8v5W++2UjqSkM4fhtj5EpYJhGG30Rs2/BLBJjklkQtvayxZ6v4DHaFG5yDTaj84Kx2TPqs8
 SQ2uUk6B97PuvUsGWFoxW24fjn8cPkZkoh9X/brx+V4U05DlGprNb+ooOd4Fq2m/JCYFO5EtY
 EEe0GDs48h95av85KbxBMIOvmgfqTMEvEBqDjxwqmpr/FcKpM/kibjIo03kGGwi9o4d9LzTzX
 LdNU42jTB/fbN05JKWsD6h2MNEEuwp5mX1zj4Ze17ot1xfcTMxu774zwKI2qTml3F/r6dRCnA
 Bc+yltNPCelr/eiPiUMC6/ksHwTySGpoAOnuseX8f/+caLmcLuxc9M6ZneYbhN0V9KgF83oud
 bfCWpNku4MbrTHIXeR4hBcz74BtJEq4OF5/IzMvusJ7ka2mFp/0SFbRUEO7AKPLh6rkIIMG8k
 UVJKL3bGS5AlURNjQeUqfszRi7JZ+P7qSjB4ya2MWYOfMBzUDP/engcb9AEZkrPNEqpoRN1Pr
 UxNTLMa6ehSyjvkkgwevAepoP3B0oacVFTfz8WLZDp0tFrEQtQlgTgqERQ+4BgJmgpzB5brLB
 Cfaq07w0w7JKa8Abyoc+gEFMtvKH+5mpLUlyP3S4DoudiMK90TorinS1Zou9+opfO5GTdNo2L
 zK1K6+YlVtB00E=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.09.21 at 17:11, Andrew Lunn wrote:
>> Andrew: the switch is not on a hat, the device tree part I use is:
>
> And this is not an overlay. It is all there at boot?
>

Well actually we DO use an overlay. The dev tree snipped I posted was an e=
xcerpt form
fdtdump. The concerning fragment looks like this in the overlay file:


        fragment@4 {
                target =3D <&spi6>;
                __overlay__ {
                        #address-cells =3D <1>;
                        #size-cells =3D <0>;
                        pinctrl-names =3D "default";
                        pinctrl-0 =3D <&spi6_pins>, <&spi6_cs_pins>;
                        cs-gpios =3D <&gpio 16 GPIO_ACTIVE_LOW>,
                                   <&gpio 18 GPIO_ACTIVE_LOW>;
                        status =3D "okay";

                        ksz9897: ksz9897@0 {
                                compatible =3D "microchip,ksz9897";
                                reg =3D <0>;
                                spi-max-frequency =3D <50000000>;
                                spi-cpha;
                                spi-cpol;
                                reset-gpios =3D <&expander_core 13 GPIO_AC=
TIVE_LOW>;
                                status =3D "okay";

                                ports {
                                        #address-cells =3D <1>;
                                        #size-cells =3D <0>;
                                        /* PORT 1 */
                                        port@0 {
                                                reg =3D <0>;
                                                label =3D "cpu";
                                                ethernet =3D <&genet>;
                                        };
                                        /* PORT 2 */
                                        port@1 {
                                                reg =3D <1>;
                                                label =3D "pileft";
                                        };
                                        /* PORT 3 */
                                        port@2 {
                                                reg =3D <2>;
                                                label =3D "piright";
                                        };
                                        /*
                                         * PORT 4-7 unused
                                         */
                                };
                        };

                        tpm: tpm@1 {
                                compatible =3D "infineon,slb9670";
                                pinctrl-names =3D "default";
                                pinctrl-0 =3D <&tpm_pins>;
                                reg =3D <1>;
                                spi-max-frequency =3D <1000000>;
                                interrupt-parent =3D <&gpio>;
                                #interrupt-cells =3D <2>;
                                interrupts =3D <10 IRQ_TYPE_LEVEL_LOW>;
                                status =3D "okay";
                        };
                };
        };


But probably this does not matter any more now
that Vladimir was able to reproduce the issue.

> I was just thinking that maybe the Ethernet interface gets opened at
> boot, and overlay is loaded, and the interface is opened a second
> time. I don't know of anybody using DSA with overlays, so that could
> of been the key difference which breaks it for you.
>
> Your decompiled DT blob looks O.K.
>
>     Andrew
>

