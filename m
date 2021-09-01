Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603243FE4FB
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 23:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344818AbhIAVb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 17:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245467AbhIAVb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 17:31:58 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03ABC061575;
        Wed,  1 Sep 2021 14:31:00 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4H0HKs1ft2zQlRS;
        Wed,  1 Sep 2021 23:30:57 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1630531855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ofF1WBpV+fMca+FMIOkn+ipn3MhCFdSk9qxPyh64bPw=;
        b=bXT3GqJHRK4s1Qr8IwrLfb8UrIKp8N0iGluvhJaw1GhJHlw4gha0c3xoAUWph+Onu5VmuC
        LVbMj/EG9d3Bd2E2/fafT/DsZcBK7/bT5ho1kGyg+1rcz9COD0mbE1kJPzWaigFQ5BFIcd
        I8d/HgIoguauk8uBg2hkjHkleSBTwYYNo00IzD90OwzULgMkdMLbB/F42WCmpdsPt+SyFf
        1IP6+CHJj6RDKHHPoDcWBolzigF5yX4XG+bhBRLlg3jj1ufXCADEJEiMCJCTIEWWcUDAvl
        VUiOpMjbd0PPC6si+wA44DdPKscC6B2M2ALfVXxBr1kZBrV+aKjnm8JCxuHbsQ==
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: fix maximum frame length
To:     Jan Hoffmann <jan@3e8.eu>, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, Thomas Nixon <tom@tomn.co.uk>
References: <20210901184933.312389-1-jan@3e8.eu>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <72db98ef-b27d-f6b0-ebfa-c5f3e5ec8b3c@hauke-m.de>
Date:   Wed, 1 Sep 2021 23:30:48 +0200
MIME-Version: 1.0
In-Reply-To: <20210901184933.312389-1-jan@3e8.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HHVLBqUK1RI5w43kZg5jZYnFq47lSQgTb"
X-Rspamd-Queue-Id: 2D328269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HHVLBqUK1RI5w43kZg5jZYnFq47lSQgTb
Content-Type: multipart/mixed; boundary="Mmg5nkAcXW4nctY5ZQaM91DvkhTh1yNFa";
 protected-headers="v1"
From: Hauke Mehrtens <hauke@hauke-m.de>
To: Jan Hoffmann <jan@3e8.eu>, netdev@vger.kernel.org
Cc: stable@vger.kernel.org, Thomas Nixon <tom@tomn.co.uk>
Message-ID: <72db98ef-b27d-f6b0-ebfa-c5f3e5ec8b3c@hauke-m.de>
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: fix maximum frame length
References: <20210901184933.312389-1-jan@3e8.eu>
In-Reply-To: <20210901184933.312389-1-jan@3e8.eu>

--Mmg5nkAcXW4nctY5ZQaM91DvkhTh1yNFa
Content-Type: multipart/mixed;
 boundary="------------A1777C099884B1F4BA1CD4F9"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------A1777C099884B1F4BA1CD4F9
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/1/21 8:49 PM, Jan Hoffmann wrote:
> Currently, outgoing packets larger than 1496 bytes are dropped when
> tagged VLAN is used on a switch port.
>=20
> Add the frame check sequence length to the value of the register
> GSWIP_MAC_FLEN to fix this. This matches the lantiq_ppa vendor driver,
> which uses a value consisting of 1518 bytes for the MAC frame, plus the=

> lengths of special tag and VLAN tags.

This field is the size of the Ethernet Frame which probably includes the =

FCS which your patch adds.

There is also a discussion in the OpenWrt github about the same topic:=20
https://github.com/openwrt/openwrt/pull/4353

> Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx20=
0")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jan Hoffmann <jan@3e8.eu>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>   drivers/net/dsa/lantiq_gswip.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gs=
wip.c
> index e78026ef6d8c..64d6dfa83122 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -843,7 +843,8 @@ static int gswip_setup(struct dsa_switch *ds)
>  =20
>   	gswip_switch_mask(priv, 0, GSWIP_MAC_CTRL_2_MLEN,
>   			  GSWIP_MAC_CTRL_2p(cpu_port));
> -	gswip_switch_w(priv, VLAN_ETH_FRAME_LEN + 8, GSWIP_MAC_FLEN);
> +	gswip_switch_w(priv, VLAN_ETH_FRAME_LEN + 8 + ETH_FCS_LEN,
> +		       GSWIP_MAC_FLEN);
>   	gswip_switch_mask(priv, 0, GSWIP_BM_QUEUE_GCTRL_GL_MOD,
>   			  GSWIP_BM_QUEUE_GCTRL);
>  =20
>=20


--------------A1777C099884B1F4BA1CD4F9
Content-Type: application/pgp-keys;
 name="OpenPGP_0x93DD20630910B515.asc"
Content-Transfer-Encoding: quoted-printable
Content-Description: OpenPGP public key
Content-Disposition: attachment;
 filename="OpenPGP_0x93DD20630910B515.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFtLdKcBEADFOTNUys8TnhpEdE5e1wO1vC+a62dPtuZgxYG83+9iVpsAyaSrCGGz5tmuB=
gkE
MZVK9YogfMyVHFEcy0RqfO7gIYBYvFp0z32btJhjkjBm9hZ6eonjFnG9XmqDKg/aZI+ud9KGU=
h0D
eaHT9FY96qdUsxIsdCodowf1eTNTJn+hdCudjLWjDf9FlBV0XKTN+ETY3pbPL2yih8Uem7tC3=
pmU
7oN7Z0OpKev5E2hLhhx+Lpcro4ikeclxdAg7g3XZWQLqfvKsjiOJsCWNXpy7hhru9PQE8oNFg=
SNz
zx2tMouhmXIlzEX4xFnJghprn+8EA/sCaczhdna+LVjICHxTO36ytOv7L3q6xDxIkdF6vyeEt=
Vm1
OfRzfGSgKdrvxc+FRJjp3TIRPFqvYUADDPh5Az7xa1LRy3YcvKYxpsDDKpJ8nCxNaYs6hqTbz=
4lo
Hpv1hQLrPXFVpoFUApfvH/q7bb+eXVjRW1m2Ahvp7QipLEAKGbiV7uvALuIjnlVtfBZSxI+Xg=
7SB
ETxgK1YHxV7PhlzMdTIKY9GL0Rtl6CMir/zMFJkxTMeO1P8wzt+WOvpxF9TixOhUtmfv0X7ay=
93H
WOdddAzov7eCKp4Ju1ZQj8QqROqsc/Ba87OH8cnG/QX9pHXpO9efHcZYIIwx1nquXnXyjJ/sM=
dS7
jGiEOfGlp6N9IwARAQABzSFIYXVrZSBNZWhydGVucyA8aGF1a2VAaGF1a2UtbS5kZT7CwZQEE=
wEI
AD4CGwEFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AWIQS4+/Pwq1ZO6E9/sdOT3SBjCRC1FQUCX=
r/2
hwUJBcXE4AAKCRCT3SBjCRC1FX1BEACXkrQyF2DJuoWQ9up7LKEHjnQ3CjL06kNWH3FtvdOjd=
e/H
7ACo2gEAPz3mWYGocdH8NjpmlnneX+3SzDspkW9dOJP/xjq9IlttJi3WeQqrBpe/01285IUDf=
OYi
+DasdqGFEzAYGznGmptL9X7hcAdu7fWUbxjZgPtJKw2pshRu9cCrPJqqlKkRFVlthFc+mkcLF=
xeP
l7SvLY+ANwvviQBblXJ2WXTSTX+Kqx8ywrKPwsJlTGysqvNRKScDMr2u+aROaOC9rvU3bucmW=
NSu
igtXJLSA1PbU7khRCHRb1q5q3AN+PCM3SXYwV7DL/4pCkEYdrQPztJ57jnsnJVjKR5TCkBwUa=
PIX
jFmOk15/BNuZWAfAZqYHkcbVjwo4Dr1XnJJon4vQncnVE4Igqlt2jujTRlB/AomuzLWy61mqk=
wUQ
l+uM1tNmeg0yC/b8bM6PqPca6tKfvkvseFzcVK6kKRfeO5zbVLoLQ3hQzRWTS2qOeiHDJyX7i=
KW/
jmR7YpLcx/Srqayb5YO207yo8NHkztyuSqFoAKBElEYIKtpJwZ8mnMJizijs5wjQ0VqDpGbRQ=
anU
x025D4lN8PrHNEnDbx/e7MSZGye2oK73GZYcExXpEC4QkJwu7AVoVir9lZUclC7Lz0QZS08ap=
VSY
u81UzhmlEprdOEPPGEXOtC1zs6y9O8LBlAQTAQgAPgIbAQULCQgHAgYVCAkKCwIEFgIDAQIeA=
QIX
gBYhBLj78/CrVk7oT3+x05PdIGMJELUVBQJdBNjNBQkDmpemAAoJEJPdIGMJELUVPpwP/2APQ=
K0A
8SUrCE0bNn8o1Avf35DgY5cMA7HI/v3uB6DLKS9qpT+nQw4p3HwXYMckIaWuQFaqIS1hQBGdQ=
k6B
+2hMtqWJ3ASnp6Jkz0SqKfmtFHoHk0hhQiMcCnGM8dKZ/CzmmdoF0jo1Xy3lGk5MA0iUF8/pt=
MES
lUZsLQHC8EVp0ai9wouucA1ni8vnrODTKRGiC0Pyt6g28ms0MrtcKsLZLQRhwYPlxe54lul/o=
lFy
6widiMyb+DaxEIfhxCz9U6OPcLrqw0Qy+9l0oTFmCH/2X1GZbRfrLsDRIO1HcA9hYYjBXRuFN=
La6
y44ABlC8WFz6J1IbRisepGI5OdbE6deQUVo52Z+T315Zqqlc4iDEevpalWuiZUj7ApZU0Re6Y=
t1s
QC/LW/EK2loZCm6fmZFx6zkYHaWRnNGOb3S5L0+BYHUhiPV6FF66PSOaSlqfRd0SHAWNDf4p/=
LNf
tiC3SBvO+IZu1IHazUyHScB22j1F0hiLeAItCHdpu3CTrOqwdEGnUgePI2rrSexRK17ijX6ZE=
GgH
oju5OTGok+bKfCmYChpiQ3YxE7wLU7T1h3gfcCAUZkFemhVumHxDuETfdj1SsSV+IOy92Pj4l=
W7W
x088YVa2mOl7kt6hfMsA0BsnZP5jrxSC2w0UJtIqNexEmUsgdHXIdBurZV1QOaxRlpFswsGOB=
BMB
CAA4AhsBBQsJCAcCBhUICQoLAgQWAgMBAh4BAheAFiEEuPvz8KtWTuhPf7HTk90gYwkQtRUFA=
ltL
fU8ACgkQk90gYwkQtRUXrRAAlmgonnRA/mOmabOSEBPY6dWAmqkABAu/LI+AC3lOJHWd+Tm3v=
fbs
kNKv77z5ZxYoJKe8ngQz/sDxx3Otd/zjZGs/r10iLc+aBwreqNkLnpQ1/HCgg+M3sZoj38rCQ=
8E3
MJoPKD53zKpqG//e5dSKE535IFj2I34449glJFyCU2Mdd6umxxWEPBQbq/D0VjLfsTpWSN9x7=
EAj
I3PmpHQP1C3JaWrg+uJ2C/2tJGpFIL/cIGdGhE/vlTqQT0EH738ySRSrARFpmXbTKpfF4Ms04=
iFL
vaB9wqizQoHQd73pGD8N5bVdzMb1LQgrGTMwKYnTsiZwnNwSRJX94O4FdVuuzZ6hpuFPCo9Lq=
BuD
B4f2dK2qn6zVa28Cj1Q3i5AYJHQ7nfU7kx9+WnU2Dx0BBmqH+c6jiZNIzmWAtA+UwirBnkZwk=
kfl
kWCy74nzUIcmi5kxgNXcNxVILCo3u8nUT9MqTJziaS2BUUoJLptfAu3gX4JPSkalxYJSK4e4d=
m68
lBMr0eK+IAAYveurlNk53xjmWqQx28IBCv9ne/4sS9fQfL2ZbwTUHaSmtsjvRKv6Hg1fL2c1a=
/Q4
cKQRHAMO17GlwH7x93jLbYj+gyRlc47tG1lA7tF6qOD4SZWJuK5qO2wJeRE4QFLbXFCc9a7ku=
3JO
ls57hcKnd54mF9PNEstq5bbCwZQEEwEIAD4CGwEFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AWI=
QS4
+/Pwq1ZO6E9/sdOT3SBjCRC1FQUCYRE/IAUJCBcNeQAKCRCT3SBjCRC1FTP5EAClicgO32ReY=
WAD
9lm6l/XJV3L+HvujQwkNvTFWpNL3FdIs+LSweQmTy7f6NLdYy6040QgrfG+KAEBv49Z5+AOoj=
ziv
qouXb1NFlqObFcVu2IwcTNLbgRWOiCVIaY7HgFCKjNROlYl1EC57edt987pqyy1CUoEriJua5=
obO
afeUghDZod+yitAqjkWZj/Hc12VwZ/MgP9vwWz0p2ZIL1mEQ8KleHuHELuqHJZTGDOaSLVlLf=
Q3e
uYSWVLtZTsQHrb9yoeOO28XjlMsssc6w1+VMQ4QV1NLNCNILrbfnIHJgGlG0eT7M953sCj83W=
Amv
Fc1JtvPPo38R9nZJ+cO/EaIl5viZSh29FRnbO48GJWBYIX9VCJChcGc26lgdTJnSIdt76KUB7=
zlS
sr8vbU4E/09S/K8sqIpHe1Cv5nfxQQAJqYsEqd1xAHKmOiRBE6MUJZPol8xzg5p9Fsi7H9mml=
BZ5
PLFe5Ofe69wCcocAiujpN9W2rowIGibAo2gr/45cNJbUAE0FcUU5kL/yfHoU/gHuVXrqfeuCQ=
ZMc
F1qn0OMeBdmjIV46o4c6aY+e0sI34hwb34t9dSfNkFkQqpGEgYfXfTWAN0mFjxdxdItzQUvwD=
JcY
nremOPfL/s7JKHWmWigMID4SJkkwg5D/EgB1TQ6k4stjZ9EnjOyyl7VXY/i4JMJdBBMRAgAdF=
iEE
JKL+D3GVlSBtEMd0rcX0gpXFjnsFAltLflUACgkQrcX0gpXFjnvhfgCghuT0nUhockO2cOXZT=
Gye
noUzEhkAn3AVltvVvqnxoVqZgtgy0rirvLH4wsFzBBABCAAdFiEEASyssijGxT6XdZEjs6I4m=
53i
M0oFAl0A948ACgkQs6I4m53iM0qrIhAAnyAVk96qdPkLqtzvONlD/FcH54aYJ69X+274SqX+a=
Byj
enpbJSuytp6jPRWo97dyYVHBInjnr3drUtaDlFgctMfgoAaCp67fu7is/k0JrxZatVlgurRgU=
ewK
tpmoqgtqJurjfDeopdEweXRxechUW33HRNjWQ5cersH8CyE9uQtoEmhxAIo/bcLCr2yTNMiud=
AeW
/Z8n+zAkzROD6T+QADosYtEQ6yYTVCq/ef3/TZ99iuFWQzqnuvtIL+zMv/kuSFKYOIaCeqGML=
TuN
tp6AUEdKg3j/Dr2m5ywrsuxFpkWKBCn2cZn32Zz+VTd9MQKj99rNCZY59W3F9Cqsn+BNyuFZE=
ux6
5zA/azYQBIxMicPolrGDTPnJWSg6+yFbCIlJJhrKOJPvYkTDcAYHgqjRrbYyZ16A3oSFVC+dU=
/un
EGPuv9+EYPhUIy9tP7Sx+T+WZDpwTzwI3ky0G4iSXlbJkq24HOGf6Y/mI3C86HR+7qGeCGDaS=
5Eg
mUyTNkjIWv2BHmmx+qCB3BfSz4ii5N/888Bin42orzE2qEYBVQ9Ergn9ImeNRA4FboYCde45U=
zZ3
t3IZ2vFJiY4lD4jl4ruwOfBxwdAbPwvIZJ84GLr7QNw5roFkxuTWlk2oNRpFZYCI1TABF1olM=
u1+
DGTbj0iBsYaZxrU9mDyY9PPa186UNFvOwE0EW0t7AwEIAOA7WMwe9wVGMTGlNoGxU6z8F7g22=
vjY
C6WhfNDz1yV2nHWKCpJVcg9t705Ob8NQLzGHt9mNeqoC5Jq/Pm0vSpS5qYDZ+azFszqiq/zfp=
tgx
u3plgIN5FY0UZCRDbNWkGaFCBSRQcZVWdjrlEmB71ro3o9dQixZMUKPRH2t+UABHosxBrY4Yx=
HeD
lE+Yj7sca+ckP+yAffKE09e1AbOtmwyMohvA4brPrRvCWQLz74faTDAIHFn/gbLuANNK/l8qI=
6tO
qZwTGu+PHpVdQaOPAYNKRFZ3BckPWEhIi7XYMJ6ulvBNNJAExlaTdX2n78RkS1T30G36yk4k5=
Att
dC+579sAEQEAAcLBfAQYAQgAJgIbDBYhBLj78/CrVk7oT3+x05PdIGMJELUVBQJev/bJBQkFx=
b7G
AAoJEJPdIGMJELUV0e8QALOYmuyRwi5rIONihFqDCFyNj/FPiuJTemMgcEldk/ZBVrbKBq+iA=
O4U
nTRy34G/gUp77KqiXgzEkfWfg8yZRZh6F+zb/WWN+MViLa3jXEphVQtw+Yey12V+YDoMshhR8=
j2E
52BRl0G3hD7C0/iwPqQAswwXg5ZcRyVWMkmytVBIHKOlKA5yFowOhoQlV+tdq/OBIn+K0XZFb=
qxx
VjEWC/crVaOQb5j9Ibkfzr3QW04SMFBZ9jHBv2fXx8WaM+kUkl7brQO2G/RXaS2waMGUnuwKx=
lMa
dyXjmKUYJW+eopWP6I0ksv4EjwZECUaOndp1muGAmR9TecIkNCzeC96eDeLR4lc57WoFLN6kW=
gz5
Mt0ejgwwzMc+nrUUyFGMrkbL73ZOi9q1a5tftTQmeIOmnlunkjbAFzwxfgPKEuqBhJNdGuoJs=
my5
qyMQbAZuRHbj8mdZBAN63DGifpnI2hAtpM1U1vA6XXTjEB3/ey0Mf4gSz+5PGpsdAZ9E9j3qk=
O1X
U+LtLwIXwOE6opKJJ1gTxEtxi3Y//BI8vVqpPIW50SrXgopHGm25vt992akGpUtgB6cQjlee0=
wH7
AOev7ZipgQa3Qe3x1Or4umo5MJRhxE5H7REmAMhLnbTlJ0HcWSeQatWS8x6wnybc/2XPcIcW1=
xED
McFR3koNGyK62hwOj6q9wsF8BBgBCAAmAhsMFiEEuPvz8KtWTuhPf7HTk90gYwkQtRUFAl0E2=
QUF
CQOakYIACgkQk90gYwkQtRUEfQ//SxFjktcASBIl8TZO9a5CcCKtwO3EvyS667D6S1bg3dFon=
qIL
XoMGJLM0z4kQa6VsVhtw2JGOIwbMnDeHtxuxLkxYvcPP6+GwQMkQmOsU0g8iT7EldKvjlW2ES=
aIV
QFKAmXS8re36eQqj73Ap5lzbsZ6thw1gK9ZcMr1Ft1Eigw02ckkY+BFetR5XGO4GaSBhRBYY7=
y4X
y0WuZCenY7Ev58tZr72DZJVd1Gi4YjavmCUHBaTv9lLPBS84C3fObxy5OvNFmKRg1NARMLqjo=
Qeq
LBwBFOUPcL9xr0//Yv5+p1SLDoEyVBhS0M9KSM0n9RcOiCeHVwadsmfo8sFXnfDy6tWSpGi0r=
UPz
h9xSh5bU7htRKsGNCv1N4mUmpKroPLKjUsfHqytT4VGwdTDFS5E+2/ls2xi4Nj23MRh6vvocI=
xot
J6uNHX1kYu+1iOvsIjty700P3IveQoXxjQ0dfvq3Ud/Sl/5bUelft21g4Qwqp+cJGy34fSWD4=
PzO
CEe6UgmZeKzd/w78+tWPvzrTXNLatbb2OpYV8gpoaeNcLlO2DHg3tRbe/3nHoU8//OciZ0Aqj=
s97
Wq0ZaC6Cdq82QNw1dZixSEWAcwBw0ej3Ujdh7TUAl6tx5AcVxEAmzkgDEuoJBI4vyA1eSgMwd=
qpd
FJW2V9Lbgjg52H6vOq/ZDai29hjCwXYEGAEIACAWIQS4+/Pwq1ZO6E9/sdOT3SBjCRC1FQUCW=
0t7
AwIbDAAKCRCT3SBjCRC1FdQPD/9mUbTho+I+5Fdy55KC40R2W9ShTsRA95C3r37uBnA37T6Mf=
8X2
8efeHc7RRQX4eRpKMmoNMM0geW1oQ5rhqX9umAJkdSO/rKrpZ2+Oy6HohehcKm1cRYoLw49rl=
lZF
zMhoalNjjITCRiLTBMy8Vgg7VY9poCpRYjunrdeoigLmrRgHwQtjHBVa6R7OlTD66bG6/P+Sy=
TQk
cCx9eNMydgcZio7K77mB1lyXsdz4ikOeN5O7uPAwlNRYT/e6bIyROudLHmXT+Fkijsg7mZyJi=
Jun
1oAaGkYB6Z0uk6AVjy1Cd7/aTGBU/4+CnOnzYs55UNJ4deMdFLyuGdTxa7vR8YLvnYunALN2x=
Lne
xRF+h8B5cTDwDoJtzDWKASLbWs6LdUh4LHAOiejNVAzyF0FbmN8mbCfn3w/Qw8RJLHdnUxDei=
e6i
k1yeyv0u7a3lsU3bz2fsAz1RUa+uWg38UozJHMKVFUWxzUpEXBVoc0tjDyOXBOVHy2BnhA1Ri=
PRA
Ouh/8i11lnQpyaadJgoAKOrBsq6IJRqdpUkOJvJOtCaLS/DP/Q/IgBaxoXilBnvx1HADQH+MR=
7Bj
dEMDUE7Lfl2f2Ab6qvR9uRhj1hlgWKTWn89g4EWfRr/y0Wnx4+xkZAC4t0AA1wl2iLJ4ZR6OS=
2xY
c7DDgLBUm92DF40ru3IjdrOagsLBfAQYAQgAJgIbDBYhBLj78/CrVk7oT3+x05PdIGMJELUVB=
QJh
ET7LBQkIFwbIAAoJEJPdIGMJELUVLmUQAJyKtf2D+5iGERjrZahB+DWb3H4O+4AdUIZX/aLKR=
3w4
TsYGYy7M6PX1DCSC7oyPvt4Sq/O4Qat/EsqOM0CzGM2DcoEhtMkPNOr2Cr/DNWSU4/nDYljm1=
Ot5
bfMMIUQTK+WaQ2tskeo0sIvG9wEheCgW87b2+FR3pk3N2dNPROucNR2HP+sfVTloZXqdiAds/=
Mrp
3wxm8R3t3+ZaEoqCKE9ziGqsqx9MDUq1gzfRNk7NhIl3toiv10xyoIcVtxitDwaU4HGS2Wk7v=
fVL
zhte1JpozQ6nMvK41hdPVY09tjC3oh0xa+60zkxn5EP6hd6FPqbNJNQ8Ektl6RrKqLLwW8zrx=
sty
G4vg5LygSqrcEElsqElSUSbwn58Lq9/PC+rzUhp73Wf2TsczX+1bkwSd/8j+t6Kd57D50+M9j=
aJU
uj8w9N1ft5DaWoe3bSrdDZhMubHEwxLY90q3ao/B8wyKKDs9g8+lcfThPg6FEG3++afOwB7sf=
hbU
fPD0AaZjDFUMdqwHv5vE0ZNE6Qg2cGP9ji0g0HepTHkcS+AOztlF9jw7WtAxCX7Y7LHbmt48l=
DV9
+yGMMaWfIVEU+LH343PMuwuWA9yI+J94V2moAvyda9vPJlmU0263kZJCEqtMe17xX+zkSg0iT=
PUa
soGqLbjoBQEcHqg7bd4H+yiy+pUEK8fzzsBNBFtLe3EBCADmapwk56BXkxaCVNph3RDAIbH4e=
1+M
EzxUcuPDu9MuDxQ4Ip4MBE6vJ47wATAxozfvtNBfHGeORzTQeXlCg3FvWwZsa7QivhdMj7uX8=
vtD
ODbaMNz8hzDSLTliCnf/xGsziorh2q4XOn9ToBKzEoXv/a05pU6KscFZn5x4tWiusL1W04jYB=
srf
thYAOgUCKAoZDxjUOqYFeUJQhFr8W3soqGzkgMdXYq7H6ICcHE77AlP0Gk7nwCPUDvHZ3ukir=
Kec
+fMooFj8A5zhfy70Nung62B455O5FbgVSFoypaYgENNIXy1O78EB9KJ3HweR0/3y9W9uOtYZs=
F8X
lfoxM0JJABEBAAHCwrIEGAEIACYCGwIWIQS4+/Pwq1ZO6E9/sdOT3SBjCRC1FQUCXr/2ygUJB=
cW+
WAFAwHQgBBkBCAAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAltLe3EACgkQ8bdnhZyy68d1W=
gf8
Dabx9vKo1usbgDHl4LZzrJhfRm2I3+J5FTboLJsFe8jpRNcf6eGJpGLeW3s/wqWd8cYsLtbzJ=
a1z
noz3EwPhHaIHmwXw4TgYm+NVu2Cm9dg2aLNQj8haNfOPhIGqr5unvhnlwrbG+Yjl0er2sAdB5=
zXl
Ix8hIjHofMJIoW4yB79T4eZseFyrwA+OeI6pJTgQ1daXlOph26ZGulMy++pviIP/Ab57PJ81/=
DTS
PWXqmEe72nLW5jWKXeHbTMaH9KVNdxJCIl8ZZgq4zN2msnpliJ+EoNVgGOgKiRckeGlkWtcez=
Q0I
r5yBaABkVVZCSydYfETSJ7TrFwY1wQwyCFcL7wkQk90gYwkQtRUwlg//f3nAAxpgGxP5xb+Nc=
+c6
X1DkWUFjBVuMEJ6ywYGnb+TWx3tv1mK8Pnfm7mp/OnDLgVuPdpFU/bByn3i0bK63cJcDTeXKN=
NpG
OnLa60+bwxWpwPRt4Bx1Gwil1d3bm26s8mQdtY2QyGmO/L8wbDBpPFbqgomBHj9pia7OeTWxs=
dIB
QJxgS9kw3iSH045z7xAZpaQbyePH9JR/HsJRoshBgpsylaENjh3VceblFA3ub+iFZp7TPgzg2=
Yc3
0mMjDG0ToiuisahgXR8kA+9AgkbXvfM2IW+y3XWFdgCzNhrbOYyt8j9ol1b7bye84EOmGBO+p=
Bgs
ghcWSqI9uvdC2dt74heF0vWyd+TC6dQJ5Al6F8Xrjs7rCE3CsefSXM5lg1m9k1MBtzRJTFKF6=
wVW
saEoP8iTvI5vwk3XS6+86uHt6tNrjFSEhPuy3K4W9AANbFR1GTb2LB/pLCXawsnM5mSo3J6Wd=
cc0
yIAiUxCKaYDvKBmaOqvUo2S0tCiOoTC2mMEavyzzWcg5jHfH1Vb5q5pcmnGKZEOBTRbqmplyT=
u2f
IW0wdVoJUQnTDW1Yvi/X2toCdaU9+C3CkT/2qnah0dEr3OAde7184ZJp433aeEjucBhjIc+5w=
dSS
OwowkUX/h58hc4X8VFb6TWQmKtfIihQc4pWTSi44fbJcuPg6wglKdnLCwrIEGAEIACYCGwIWI=
QS4
+/Pwq1ZO6E9/sdOT3SBjCRC1FQUCXQTZBQUJA5qRFAFAwHQgBBkBCAAdFiEEyz0/uAcd+JwXm=
wtD
8bdnhZyy68cFAltLe3EACgkQ8bdnhZyy68d1Wgf8Dabx9vKo1usbgDHl4LZzrJhfRm2I3+J5F=
Tbo
LJsFe8jpRNcf6eGJpGLeW3s/wqWd8cYsLtbzJa1znoz3EwPhHaIHmwXw4TgYm+NVu2Cm9dg2a=
LNQ
j8haNfOPhIGqr5unvhnlwrbG+Yjl0er2sAdB5zXlIx8hIjHofMJIoW4yB79T4eZseFyrwA+Oe=
I6p
JTgQ1daXlOph26ZGulMy++pviIP/Ab57PJ81/DTSPWXqmEe72nLW5jWKXeHbTMaH9KVNdxJCI=
l8Z
Zgq4zN2msnpliJ+EoNVgGOgKiRckeGlkWtcezQ0Ir5yBaABkVVZCSydYfETSJ7TrFwY1wQwyC=
FcL
7wkQk90gYwkQtRWRXA//XyWOe110AQ1PSKKk8V76+k9F4z4O2p2DUwssN2lwlvzKxwFdvzACv=
Vts
W11pjMr4Ync3Rh4PNFd3ibnOF70La7ytx4w8Ye2aRfY1FUN/YyjWEYNpR4OtYMWDd8XPye9w8=
PJL
p3rL2Utnxx8xtR649qFr98VG4fr70dSsmqXeYXvEdO6975hu4gkKIzWAa31Q92YHpxJmxrPXz=
NYf
p9TvmIVjoMT11snyDCH+1kznmNIp+Ag6tsoCX1mkp+hYHeBf1FWY0Rl9CU0f08BOUtssq9UP/=
L1K
lDvMIYAnbppqQvOSE2b4CPCDljMpD/h2UqKlCsm7BZa1+6vd8pJFjWSnJO1OxhXv8Qomsb8cj=
4O7
wLjCwzspKjWdcCWM6EJGtZCYukZgRaQ0FIO/vz0upQhaBKaVqe3lEkjT5vFRW48GtQ9zIEt/l=
Uij
jJhVhkQmPfW1p5dmXdo33RE5gRTVwPeJoNjdryP0x47u/btXUfYM6Yx+0d45j76RHNlglObiX=
2la
ABKofZCNg+zZUAhvNFJFwxxpnKBwZ7IhGRo85uc2DmIp401HqMtxdPGk2fnv7I/q+FUzlAf29=
I8v
iT58Z9txZLRiGJ0PpS7AJJnG3A8AqKeFefcHkdnqsAannTUVF+Tkz/d5VCIa0SMt3GU/wOZzX=
FHg
mEUvGwkRSq0ChJ/dkRbCwqwEGAEIACAWIQS4+/Pwq1ZO6E9/sdOT3SBjCRC1FQUCW0t7cQIbA=
gFA
CRCT3SBjCRC1FcB0IAQZAQgAHRYhBMs9P7gHHficF5sLQ/G3Z4WcsuvHBQJbS3txAAoJEPG3Z=
4Wc
suvHdVoH/A2m8fbyqNbrG4Ax5eC2c6yYX0ZtiN/ieRU26CybBXvI6UTXH+nhiaRi3lt7P8Kln=
fHG
LC7W8yWtc56M9xMD4R2iB5sF8OE4GJvjVbtgpvXYNmizUI/IWjXzj4SBqq+bp74Z5cK2xvmI5=
dHq
9rAHQec15SMfISIx6HzCSKFuMge/U+HmbHhcq8APjniOqSU4ENXWl5TqYdumRrpTMvvqb4iD/=
wG+
ezyfNfw00j1l6phHu9py1uY1il3h20zGh/SlTXcSQiJfGWYKuMzdprJ6ZYifhKDVYBjoCokXJ=
Hhp
ZFrXHs0NCK+cgWgAZFVWQksnWHxE0ie06xcGNcEMMghXC+/COw//VAN09RiXmxfUBs6K38NQH=
Fma
xG79pK9NZk3ZnMOuSnegTfBqcD3JjGDZWEL1AhbDpqAPR4n9vdn1GNZdbNGmFcgRcGmTW5HJ4=
l2P
NF9IyBJplWiXIvzza6eRkYN1uMew1xbFCotslAl5OWO2Ag3HtnCYagPpkPp6gxL46C76CRVGg=
gyL
wvgQT/Q4I6ydbP62AEmIrUrJ5KDZgK7drpgCfFTmPu0NkrFX5c7lyp5o5x5F0bofLK8cs3JP2=
vRK
Jm2kr30aVditJ5gfKnVzcSlrVk9Df+ymzpT5KpGSgQGUoE1wRC6oZou0oFA3OBfJxMEd0Z42U=
bHp
fH5ckKCK+aqdilieG7ivXOToo2EYbzfIxacP7O8+5jPTdz5x0KsjnCCtY+pajEIwv5JkSqTft=
E62
jM/JV/EyPXTbcv1xblbfWPWL9b30hR2RGKlkH0RQGEiAP6LwW+wkQaPEneJ2y5O8/u0P7TtWc=
v10
vlBqcIAbUMn9Fkwtlg0iv4Jk8BYVr2uPtfShrqluE3g2oirWpIvzax8Ah92jlsdMa8Y+Fa9ql=
RDv
UJLJPuEWbdkC1/TwpZgw2UfyoJwBiFWh3MOjp59NpGu/lfXPA3CY0KQ+iMrCNK+FNCwlDHXbc=
Kmg
5P9C0fDN/i4UO9PpFkQgGNEAmWuaQlPStj9vp8+4rOLBdYTVWq/CwrIEGAEIACYCGwIWIQS4+=
/Pw
q1ZO6E9/sdOT3SBjCRC1FQUCYRE/LAUJCBcGuwFAwHQgBBkBCAAdFiEEyz0/uAcd+JwXmwtD8=
bdn
hZyy68cFAltLe3EACgkQ8bdnhZyy68d1Wgf8Dabx9vKo1usbgDHl4LZzrJhfRm2I3+J5FTboL=
JsF
e8jpRNcf6eGJpGLeW3s/wqWd8cYsLtbzJa1znoz3EwPhHaIHmwXw4TgYm+NVu2Cm9dg2aLNQj=
8ha
NfOPhIGqr5unvhnlwrbG+Yjl0er2sAdB5zXlIx8hIjHofMJIoW4yB79T4eZseFyrwA+OeI6pJ=
TgQ
1daXlOph26ZGulMy++pviIP/Ab57PJ81/DTSPWXqmEe72nLW5jWKXeHbTMaH9KVNdxJCIl8ZZ=
gq4
zN2msnpliJ+EoNVgGOgKiRckeGlkWtcezQ0Ir5yBaABkVVZCSydYfETSJ7TrFwY1wQwyCFcL7=
wkQ
k90gYwkQtRVVgg/+Jth976QlxY44wvhNafpdjXzmTrMW6mHXU6C+F0TO/0RSkrb4zN5RYIPUh=
n8a
8GCRFoejzOhJPXpMlV2IATRJ18hSfhs28yTcD3NA+2lRk7Xi3idvlNwn37ylxANHs8vzCOXla=
e8N
E2/Lt6gOb9ME87cDtIE1YrBsW8x22vPoNJbw2ZBKtHum4HxJBgiTLFPM4WCxHyo8p577rxs8J=
HF2
MRKez3SKemdlw5JCvDNBOawN4wDL/b+ztv1xcYFMqhwttjr9yS9DCt9q0/RphT+Sb2is+tQ+B=
yqE
LJUiy/yO6b+l00p011j2yP5jj0c9TGtkHVy4khRy4xbAPagY3YGoOQT96qJwKwAB+jNW1RbRs=
zLx
1JO/5NYyIRIyQRr1SPWeZlaLuEngRPt3aVhrcUwjFfcLK+LYbdRH7I77wIfy6SrKLnGAZbDvT=
CXp
oNZR+Kn2bdWji1k5/NaznGnuE9G3d5lsDhHHcxFf+NLIlpUTXXyY4VtWvS9SdPrw/c+jG1DjB=
orH
+9ZFPVwr4wubZc56pdVR+Ejymm206eT+0Xdu9dnMYF+7x+EhU8IJA1Q1+0U3yjwEuh03XGygH=
0GY
slwzACmIB2AAxbNfa18wpGUGJtbp8VNhHfaPSFjbiCAC+f1s4DSoIEnkLCDW7e0Bp9NfhMbRy=
6To
Cceh5AjrsobBERk=3D
=3DTjd9
-----END PGP PUBLIC KEY BLOCK-----

--------------A1777C099884B1F4BA1CD4F9--

--Mmg5nkAcXW4nctY5ZQaM91DvkhTh1yNFa--

--HHVLBqUK1RI5w43kZg5jZYnFq47lSQgTb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAmEv8QgACgkQ8bdnhZyy
68eQlgf/b0FKA7BY4KNCgzGQMjO7pNEzHViRsV3jg2qV67ITsCX+vVxrxKCeqgVD
55q/BsCnX7XYftamPz432AZLJPtNfXQASD8zNMaXKtFSPJDCaFKFwTA3KniQYlsF
j2jh94ifIbj8bTb4/MF+1BybpCwIfIp0y7kgGFjEOI1oH3K1AZMhR597VE6x/qVS
MwvloyYYfl8zi9qfSV0L76FYaruomNbIWTnzf9LN2S3onkVw9sPo8O70+6BvdoUJ
mXAVjNPzAFRGduEf+0dMJTYZbNk4WUm0/73XJnTO7t97+P8xn3k2BOFxOL6WQpS5
8xn2g3P+DtEHuKq1fQ8MqCyPJ+01JQ==
=d4UH
-----END PGP SIGNATURE-----

--HHVLBqUK1RI5w43kZg5jZYnFq47lSQgTb--
