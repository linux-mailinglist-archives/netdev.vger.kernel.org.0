Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B1E11712C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLIQHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:07:46 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59305 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfLIQHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:07:45 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ieLZU-00009f-R1; Mon, 09 Dec 2019 17:07:40 +0100
Received: from [IPv6:2a03:f580:87bc:d400:858e:130c:14c0:366e] (unknown [IPv6:2a03:f580:87bc:d400:858e:130c:14c0:366e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EEA5C48BF38;
        Mon,  9 Dec 2019 16:07:38 +0000 (UTC)
Subject: Re: [PATCH] can: ensure an initialized headroom in outgoing CAN
 sk_buffs
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, dvyukov@google.com
Cc:     syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com,
        glider@google.com, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        eric.dumazet@gmail.com
References: <20191207183418.28868-1-socketcan@hartkopp.net>
 <cc102c3b-d9d3-6447-7581-a36795259cc2@pengutronix.de>
 <2b997c05-fcef-e067-2771-8e07e35dfadd@hartkopp.net>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 mQINBFFVq30BEACtnSvtXHoeHJxG6nRULcvlkW6RuNwHKmrqoksispp43X8+nwqIFYgb8UaX
 zu8T6kZP2wEIpM9RjEL3jdBjZNCsjSS6x1qzpc2+2ivjdiJsqeaagIgvy2JWy7vUa4/PyGfx
 QyUeXOxdj59DvLwAx8I6hOgeHx2X/ntKAMUxwawYfPZpP3gwTNKc27dJWSomOLgp+gbmOmgc
 6U5KwhAxPTEb3CsT5RicsC+uQQFumdl5I6XS+pbeXZndXwnj5t84M+HEj7RN6bUfV2WZO/AB
 Xt5+qFkC/AVUcj/dcHvZwQJlGeZxoi4veCoOT2MYqfR0ax1MmN+LVRvKm29oSyD4Ts/97cbs
 XsZDRxnEG3z/7Winiv0ZanclA7v7CQwrzsbpCv+oj+zokGuKasofzKdpywkjAfSE1zTyF+8K
 nxBAmzwEqeQ3iKqBc3AcCseqSPX53mPqmwvNVS2GqBpnOfY7Mxr1AEmxdEcRYbhG6Xdn+ACq
 Dq0Db3A++3PhMSaOu125uIAIwMXRJIzCXYSqXo8NIeo9tobk0C/9w3fUfMTrBDtSviLHqlp8
 eQEP8+TDSmRP/CwmFHv36jd+XGmBHzW5I7qw0OORRwNFYBeEuiOIgxAfjjbLGHh9SRwEqXAL
 kw+WVTwh0MN1k7I9/CDVlGvc3yIKS0sA+wudYiselXzgLuP5cQARAQABtCZNYXJjIEtsZWlu
 ZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPokCVAQTAQoAPgIbAwIeAQIXgAULCQgHAwUV
 CgkICwUWAgMBABYhBMFAC6CzmJ5vvH1bXCte4hHFiupUBQJcUsSbBQkM366zAAoJECte4hHF
 iupUgkAP/2RdxKPZ3GMqag33jKwKAbn/fRqAFWqUH9TCsRH3h6+/uEPnZdzhkL4a9p/6OeJn
 Z6NXqgsyRAOTZsSFcwlfxLNHVxBWm8pMwrBecdt4lzrjSt/3ws2GqxPsmza1Gs61lEdYvLST
 Ix2vPbB4FAfE0kizKAjRZzlwOyuHOr2ilujDsKTpFtd8lV1nBNNn6HBIBR5ShvJnwyUdzuby
 tOsSt7qJEvF1x3y49bHCy3uy+MmYuoEyG6zo9udUzhVsKe3hHYC2kfB16ZOBjFC3lH2U5An+
 yQYIIPZrSWXUeKjeMaKGvbg6W9Oi4XEtrwpzUGhbewxCZZCIrzAH2hz0dUhacxB201Y/faY6
 BdTS75SPs+zjTYo8yE9Y9eG7x/lB60nQjJiZVNvZ88QDfVuLl/heuIq+fyNajBbqbtBT5CWf
 mOP4Dh4xjm3Vwlz8imWW/drEVJZJrPYqv0HdPbY8jVMpqoe5jDloyVn3prfLdXSbKPexlJaW
 5tnPd4lj8rqOFShRnLFCibpeHWIumqrIqIkiRA9kFW3XMgtU6JkIrQzhJb6Tc6mZg2wuYW0d
 Wo2qvdziMgPkMFiWJpsxM9xPk9BBVwR+uojNq5LzdCsXQ2seG0dhaOTaaIDWVS8U/V8Nqjrl
 6bGG2quo5YzJuXKjtKjZ4R6k762pHJ3tnzI/jnlc1sXzuQENBFxSzJYBCAC58uHRFEjVVE3J
 31eyEQT6H1zSFCccTMPO/ewwAnotQWo98Bc67ecmprcnjRjSUKTbyY/eFxS21JnC4ZB0pJKx
 MNwK6zq71wLmpseXOgjufuG3kvCgwHLGf/nkBHXmSINHvW00eFK/kJBakwHEbddq8Dr4ewmr
 G7yr8d6A3CSn/qhOYWhIxNORK3SVo4Io7ExNX/ljbisGsgRzsWvY1JlN4sabSNEr7a8YaqTd
 2CfFe/5fPcQRGsfhAbH2pVGigr7JddONJPXGE7XzOrx5KTwEv19H6xNe+D/W3FwjZdO4TKIo
 vcZveSDrFWOi4o2Te4O5OB/2zZbNWPEON8MaXi9zABEBAAGJA3IEGAEKACYWIQTBQAugs5ie
 b7x9W1wrXuIRxYrqVAUCXFLMlgIbAgUJAeKNmgFACRArXuIRxYrqVMB0IAQZAQoAHRYhBJrx
 JF84Dn3PPNRrhVrGIaOR5J0gBQJcUsyWAAoJEFrGIaOR5J0grw4H/itil/yryJCvzi6iuZHS
 suSHHOiEf+UQHib1MLP96LM7FmDabjVSmJDpH4TsMu17A0HTG+bPMAdeia0+q9FWSvSHYW8D
 wNhfkb8zojpa37qBpVpiNy7r6BKGSRSoFOv6m/iIoRJuJ041AEKao6djj/FdQF8OV1EtWKRO
 +nE2bNuDCcwHkhHP+FHExdzhKSmnIsMjGpGwIQKN6DxlJ7fN4W7UZFIQdSO21ei+akinBo4K
 O0uNCnVmePU1UzrwXKG2sS2f97A+sZE89vkc59NtfPHhofI3JkmYexIF6uqLA3PumTqLQ2Lu
 bywPAC3YNphlhmBrG589p+sdtwDQlpoH9O7NeBAAg/lyGOUUIONrheii/l/zR0xxr2TDE6tq
 6HZWdtjWoqcaky6MSyJQIeJ20AjzdV/PxMkd8zOijRVTnlK44bcfidqFM6yuT1bvXAO6NOPy
 pvBRnfP66L/xECnZe7s07rXpNFy72XGNZwhj89xfpK4a9E8HQcOD0mNtCJaz7TTugqBOsQx2
 45VPHosmhdtBQ6/gjlf2WY9FXb5RyceeSuK4lVrz9uZB+fUHBge/giOSsrqFo/9fWAZsE67k
 6Mkdbpc7ZQwxelcpP/giB9N+XAfBsffQ8q6kIyuFV4ILsIECCIA4nt1rYmzphv6t5J6PmlTq
 TzW9jNzbYANoOFAGnjzNRyc9i8UiLvjhTzaKPBOkQfhStEJaZrdSWuR/7Tt2wZBBoNTsgNAw
 A+cEu+SWCvdX7vNpsCHMiHtcEmVt5R0Tex1Ky87EfXdnGR2mDi6Iyxi3MQcHez3C61Ga3Baf
 P8UtXR6zrrrlX22xXtpNJf4I4Z6RaLpB/avIXTFXPbJ8CUUbVD2R2mZ/jyzaTzgiABDZspbS
 gw17QQUrKqUog0nHXuaGGA1uvreHTnyBWx5P8FP7rhtvYKhw6XdJ06ns+2SFcQv0Bv6PcSDK
 aRXmnW+OsDthn84x1YkfGIRJEPvvmiOKQsFEiB4OUtTX2pheYmZcZc81KFfJMmE8Z9+LT6Ry
 uSS5AQ0EXFLNDgEIAL14qAzTMCE1PwRrYJRI/RSQGAGF3HLdYvjbQd9Ozzg02K3mNCF2Phb1
 cjsbMk/V6WMxYoZCEtCh4X2GjQG2GDDW4KC9HOa8cTmr9Vcno+f+pUle09TMzWDgtnH92WKx
 d0FIQev1zDbxU7lk1dIqyOjjpyhmR8Put6vgunvuIjGJ/GapHL/O0yjVlpumtmow6eME2muc
 TeJjpapPWBGcy/8VU4LM8xMeMWv8DtQML5ogyJxZ0Smt+AntIzcF9miV2SeYXA3OFiojQstF
 vScN7owL1XiQ3UjJotCp6pUcSVgVv0SgJXbDo5Nv87M2itn68VPfTu2uBBxRYqXQovsR++kA
 EQEAAYkCPAQYAQoAJhYhBMFAC6CzmJ5vvH1bXCte4hHFiupUBQJcUs0OAhsMBQkB4o0iAAoJ
 ECte4hHFiupUbioQAJ40bEJmMOF28vFcGvQrpI+lfHJGk9zSrh4F4SlJyOVWV1yWyUAINr8w
 v1aamg2nAppZ16z4nAnGU/47tWZ4P8blLVG8x4SWzz3D7MCy1FsQBTrWGLqWldPhkBAGp2VH
 xDOK4rLhuQWx3H5zd3kPXaIgvHI3EliWaQN+u2xmTQSJN75I/V47QsaPvkm4TVe3JlB7l1Fg
 OmSvYx31YC+3slh89ayjPWt8hFaTLnB9NaW9bLhs3E2ESF9Dei0FRXIt3qnFV/hnETsx3X4h
 KEnXxhSRDVeURP7V6P/z3+WIfddVKZk5ZLHi39fJpxvsg9YLSfStMJ/cJfiPXk1vKdoa+FjN
 7nGAZyF6NHTNhsI7aHnvZMDavmAD3lK6CY+UBGtGQA3QhrUc2cedp1V53lXwor/D/D3Wo9wY
 iSXKOl4fFCh2Peo7qYmFUaDdyiCxvFm+YcIeMZ8wO5udzkjDtP4lWKAn4tUcdcwMOT5d0I3q
 WATP4wFI8QktNBqF3VY47HFwF9PtNuOZIqeAquKezywUc5KqKdqEWCPx9pfLxBAh3GW2Zfjp
 lP6A5upKs2ktDZOC2HZXP4IJ1GTk8hnfS4ade8s9FNcwu9m3JlxcGKLPq5DnIbPVQI1UUR4F
 QyAqTtIdSpeFYbvH8D7pO4lxLSz2ZyBMk+aKKs6GL5MqEci8OcFW
Message-ID: <547fd63f-6d79-2ce7-3bd8-29949260189d@pengutronix.de>
Date:   Mon, 9 Dec 2019 17:07:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <2b997c05-fcef-e067-2771-8e07e35dfadd@hartkopp.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="JTLSR7X2EXpraVkHslfGWCRuJ8N2IsEt1"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JTLSR7X2EXpraVkHslfGWCRuJ8N2IsEt1
Content-Type: multipart/mixed; boundary="8O8qOyFE32kqnxD6fDG4q4wTtjqEWxrhU";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>, linux-can@vger.kernel.org,
 dvyukov@google.com
Cc: syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com, glider@google.com,
 syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
 o.rempel@pengutronix.de, eric.dumazet@gmail.com
Message-ID: <547fd63f-6d79-2ce7-3bd8-29949260189d@pengutronix.de>
Subject: Re: [PATCH] can: ensure an initialized headroom in outgoing CAN
 sk_buffs
References: <20191207183418.28868-1-socketcan@hartkopp.net>
 <cc102c3b-d9d3-6447-7581-a36795259cc2@pengutronix.de>
 <2b997c05-fcef-e067-2771-8e07e35dfadd@hartkopp.net>
In-Reply-To: <2b997c05-fcef-e067-2771-8e07e35dfadd@hartkopp.net>

--8O8qOyFE32kqnxD6fDG4q4wTtjqEWxrhU
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 12/8/19 12:34 PM, Oliver Hartkopp wrote:
>=20
>=20
> On 08/12/2019 11.48, Marc Kleine-Budde wrote:
>> On 12/7/19 7:34 PM, Oliver Hartkopp wrote:
>>> KMSAN sysbot detected a read access to an untinitialized value in the=
 headroom
>>> of an outgoing CAN related sk_buff. When using CAN sockets this area =
is filled
>>> appropriately - but when using a packet socket this initialization is=
 missing.
>=20
>=20
>>> +/* Check for outgoing skbs that have not been created by the CAN sub=
system */
>>> +static inline bool can_check_skb_headroom(struct net_device *dev,
>>> +					  struct sk_buff *skb)
>>
>> Do we want to have such a big function as a static inline?
>>
>=20
> No. Usually not. can_dropped_invalid_skb() has the same problem IMO.
>=20
> This additional inline function approach was the only way to ensure=20
> simple backwards portability for stable kernels.

A "normal" function called from the can_dropped_invalid_skb() works aswel=
l.

> I would suggest to clean this up once this patch went into mainline.
>=20
>>> +{
>>> +	/* af_packet creates a headroom of HH_DATA_MOD bytes which is fine =
*/
>>> +	if (WARN_ON_ONCE(skb_headroom(skb) < sizeof(struct can_skb_priv)))
>>> +		return true;
>>> +
>>> +	/* af_packet does not apply CAN skb specific settings */
>>> +	if (skb->ip_summed =3D=3D CHECKSUM_NONE) {
>>
>> Is it possible to set the ip_summed via the packet socket or is it
>> always 0 (=3D=3D CHECKSUM_NONE)?
>=20
> af_packet only reads ip_summed in the receive path. It is not set when =

> creating the outgoing skb where the struct skb is mainly zero'ed.
>=20
>>
>>> +
>>
>> Please remove that empty line.
>>
>=20
> ok.
>=20
>>> +		/* init headroom */
>>> +		can_skb_prv(skb)->ifindex =3D dev->ifindex;
>>> +		can_skb_prv(skb)->skbcnt =3D 0;
>>> +
>>> +		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
>>> +
>>> +		/* preform proper loopback on capable devices */
>>> +		if (dev->flags & IFF_ECHO)
>>> +			skb->pkt_type =3D PACKET_LOOPBACK;
>>> +		else
>>> +			skb->pkt_type =3D PACKET_HOST;
>>> +
>>> +		skb_reset_mac_header(skb);
>>> +		skb_reset_network_header(skb);
>>> +		skb_reset_transport_header(skb);
>>> +	}
>>> +
>>> +	return false;
>>> +}
>>> +
>>>   /* Drop a given socketbuffer if it does not contain a valid CAN fra=
me. */
>>>   static inline bool can_dropped_invalid_skb(struct net_device *dev,
>>>   					  struct sk_buff *skb)
>>> @@ -108,6 +140,9 @@ static inline bool can_dropped_invalid_skb(struct=
 net_device *dev,
>>>   	} else
>>>   		goto inval_skb;
>>>  =20
>>> +	if (can_check_skb_headroom(dev, skb))
>>
>> Can you rename the function, so that it's clear that returning false
>> means it's an invalid skb?
>>
>=20
> Returning 'false' is *good* like in can_dropped_invalid_skb(). What=20
> naming would you suggest?

Something like: can_skb_headroom_valid().

See v2 I just sent around.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--8O8qOyFE32kqnxD6fDG4q4wTtjqEWxrhU--

--JTLSR7X2EXpraVkHslfGWCRuJ8N2IsEt1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl3ucUMACgkQWsYho5Hk
nSDeeAf+MS5yzMPcqPLMd6dYecASeaBLZVeSpqnA6NHz23POI7ow6JTHk0iGqsLd
2LD27kHPRoW7Xa+1oZJ3sADXamDlbw1Q7TBDrC6pQkhGDwmFPu9fQHr/slHVt2Yk
r6IO2O4+mS8gy33EjwGxZo72s9Pv5RA/8fwPiBnzKtlwOVyvH+uwTa5Gnm69MNmQ
SMt6nqcgnrm97PBqla0hjn0eJe6zPIdU3K6q19oe4qxhJDNu6y8cJLdNJdiYo9Qt
WcF19RrfpkV0O3XlGytZX6ZTBItXkXhmbj9pjYGM5iiCkhqnQbcbrU+CR+0vRY1a
lBXvPO9L7sHkg1ltlS+vx70u1+1heQ==
=bJcj
-----END PGP SIGNATURE-----

--JTLSR7X2EXpraVkHslfGWCRuJ8N2IsEt1--
