Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C008290C5A
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 21:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411094AbgJPTgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 15:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411089AbgJPTgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 15:36:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33DDC061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 12:36:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kTVWZ-0001TL-Py; Fri, 16 Oct 2020 21:36:23 +0200
Received: from [IPv6:2a03:f580:87bc:d400:11bc:f68a:b193:452] (unknown [IPv6:2a03:f580:87bc:d400:11bc:f68a:b193:452])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 566E357ACAA;
        Fri, 16 Oct 2020 19:36:20 +0000 (UTC)
Subject: Re: [RFC] can: can_create_echo_skb(): fix echo skb generation: always
 use skb_clone()
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        dev.kurt@vandijck-laurijssen.be, wg@grandegger.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
References: <20200124132656.22156-1-o.rempel@pengutronix.de>
 <20200214120948.4sjnqn2jvndldphw@pengutronix.de>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f2ae9b3a-0d10-64ae-1533-2308e9346ebc@pengutronix.de>
Date:   Fri, 16 Oct 2020 21:36:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200214120948.4sjnqn2jvndldphw@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="n3giXz5InSHdvfjztmUxruz38fjbuz1dn"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n3giXz5InSHdvfjztmUxruz38fjbuz1dn
Content-Type: multipart/mixed; boundary="C94m3spvx1gPxz05V2BSJLQh1v5TKI24U";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Oleksij Rempel <o.rempel@pengutronix.de>,
 dev.kurt@vandijck-laurijssen.be, wg@grandegger.com
Cc: netdev@vger.kernel.org, kernel@pengutronix.de, linux-can@vger.kernel.org
Message-ID: <f2ae9b3a-0d10-64ae-1533-2308e9346ebc@pengutronix.de>
Subject: Re: [RFC] can: can_create_echo_skb(): fix echo skb generation: always
 use skb_clone()
References: <20200124132656.22156-1-o.rempel@pengutronix.de>
 <20200214120948.4sjnqn2jvndldphw@pengutronix.de>
In-Reply-To: <20200214120948.4sjnqn2jvndldphw@pengutronix.de>

--C94m3spvx1gPxz05V2BSJLQh1v5TKI24U
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 2/14/20 1:09 PM, Oleksij Rempel wrote:
> Hi all,
>=20
> any comments on this patch?

I'm going to take this patch now for 5.10....Comments?

Marc

>=20
> On Fri, Jan 24, 2020 at 02:26:56PM +0100, Oleksij Rempel wrote:
>> All user space generated SKBs are owned by a socket (unless injected
>> into the key via AF_PACKET). If a socket is closed, all associated skb=
s
>> will be cleaned up.
>>
>> This leads to a problem when a CAN driver calls can_put_echo_skb() on =
a
>> unshared SKB. If the socket is closed prior to the TX complete handler=
,
>> can_get_echo_skb() and the subsequent delivering of the echo SKB to
>> all registered callbacks, a SKB with a refcount of 0 is delivered.
>>
>> To avoid the problem, in can_get_echo_skb() the original SKB is now
>> always cloned, regardless of shared SKB or not. If the process exists =
it
>> can now safely discard its SKBs, without disturbing the delivery of th=
e
>> echo SKB.
>>
>> The problem shows up in the j1939 stack, when it clones the
>> incoming skb, which detects the already 0 refcount.
>>
>> We can easily reproduce this with following example:
>>
>> testj1939 -B -r can0: &
>> cansend can0 1823ff40#0123
>>
>> WARNING: CPU: 0 PID: 293 at lib/refcount.c:25 refcount_warn_saturate+0=
x108/0x174
>> refcount_t: addition on 0; use-after-free.
>> Modules linked in: coda_vpu imx_vdoa videobuf2_vmalloc dw_hdmi_ahb_aud=
io vcan
>> CPU: 0 PID: 293 Comm: cansend Not tainted 5.5.0-rc6-00376-g9e20dcb7040=
d #1
>> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
>> Backtrace:
>> [<c010f570>] (dump_backtrace) from [<c010f90c>] (show_stack+0x20/0x24)=

>> [<c010f8ec>] (show_stack) from [<c0c3e1a4>] (dump_stack+0x8c/0xa0)
>> [<c0c3e118>] (dump_stack) from [<c0127fec>] (__warn+0xe0/0x108)
>> [<c0127f0c>] (__warn) from [<c01283c8>] (warn_slowpath_fmt+0xa8/0xcc)
>> [<c0128324>] (warn_slowpath_fmt) from [<c0539c0c>] (refcount_warn_satu=
rate+0x108/0x174)
>> [<c0539b04>] (refcount_warn_saturate) from [<c0ad2cac>] (j1939_can_rec=
v+0x20c/0x210)
>> [<c0ad2aa0>] (j1939_can_recv) from [<c0ac9dc8>] (can_rcv_filter+0xb4/0=
x268)
>> [<c0ac9d14>] (can_rcv_filter) from [<c0aca2cc>] (can_receive+0xb0/0xe4=
)
>> [<c0aca21c>] (can_receive) from [<c0aca348>] (can_rcv+0x48/0x98)
>> [<c0aca300>] (can_rcv) from [<c09b1fdc>] (__netif_receive_skb_one_core=
+0x64/0x88)
>> [<c09b1f78>] (__netif_receive_skb_one_core) from [<c09b2070>] (__netif=
_receive_skb+0x38/0x94)
>> [<c09b2038>] (__netif_receive_skb) from [<c09b2130>] (netif_receive_sk=
b_internal+0x64/0xf8)
>> [<c09b20cc>] (netif_receive_skb_internal) from [<c09b21f8>] (netif_rec=
eive_skb+0x34/0x19c)
>> [<c09b21c4>] (netif_receive_skb) from [<c0791278>] (can_rx_offload_nap=
i_poll+0x58/0xb4)
>>
>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>> ---
>>  include/linux/can/skb.h | 20 ++++++++------------
>>  1 file changed, 8 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
>> index a954def26c0d..0783b0c6d9e2 100644
>> --- a/include/linux/can/skb.h
>> +++ b/include/linux/can/skb.h
>> @@ -61,21 +61,17 @@ static inline void can_skb_set_owner(struct sk_buf=
f *skb, struct sock *sk)
>>   */
>>  static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb=
)
>>  {
>> -	if (skb_shared(skb)) {
>> -		struct sk_buff *nskb =3D skb_clone(skb, GFP_ATOMIC);
>> +	struct sk_buff *nskb;
>> =20
>> -		if (likely(nskb)) {
>> -			can_skb_set_owner(nskb, skb->sk);
>> -			consume_skb(skb);
>> -			return nskb;
>> -		} else {
>> -			kfree_skb(skb);
>> -			return NULL;
>> -		}
>> +	nskb =3D skb_clone(skb, GFP_ATOMIC);
>> +	if (unlikely(!nskb)) {
>> +		kfree_skb(skb);
>> +		return NULL;
>>  	}
>> =20
>> -	/* we can assume to have an unshared skb with proper owner */
>> -	return skb;
>> +	can_skb_set_owner(nskb, skb->sk);
>> +	consume_skb(skb);
>> +	return nskb;
>>  }
>> =20
>>  #endif /* !_CAN_SKB_H */
>> --=20
>> 2.25.0
>>
>>
>>
>=20


--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--C94m3spvx1gPxz05V2BSJLQh1v5TKI24U--

--n3giXz5InSHdvfjztmUxruz38fjbuz1dn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+J9isACgkQqclaivrt
76kGhQf+I5D7eopDXxzbmNsSj9muBUJUncUav7aqWo5V8240zx09Qmk7EBBFq4jb
HWl+YiuJ0RKHz511/tu5rWtG3LICNk6CneGej/Mm50js7sMDHnUAXuo+QaOSPoO4
F4VWN2IbOu7CRhmbCKhwAXFTssF5HVZ+p1HBeBgii3HhJR3of+cw4srPolHpeYVJ
Oey9xEFfkCJqNya+XreYSxt9Jx9AVVK2w+9+yUSwcmWh38clrrTP5HjKH39CoBIz
XygGtQShlNVF4g/DiEjaXLujVb7n3k1WeTyUQmxeeA95/+FUuaYRMTIb7l+53z3D
99IDJeGUjiXZyhuQlT5ZEYQGElntjA==
=10Rx
-----END PGP SIGNATURE-----

--n3giXz5InSHdvfjztmUxruz38fjbuz1dn--
