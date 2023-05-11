Return-Path: <netdev+bounces-1696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7227C6FEDDE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:35:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42FB51C20F42
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE76377;
	Thu, 11 May 2023 08:35:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0713804
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:35:12 +0000 (UTC)
X-Greylist: delayed 82562 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 May 2023 01:35:07 PDT
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909D461AF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:35:07 -0700 (PDT)
X-QQ-mid: bizesmtp71t1683794100tzge7m9p
Received: from smtpclient.apple ( [125.119.253.217])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 11 May 2023 16:34:59 +0800 (CST)
X-QQ-SSF: 00400000000000N0Z000000A0000000
X-QQ-FEAT: +ynUkgUhZJmfFOKOsc543359W1GZmihXUg6AwcP2azmdlbYoBaRPDd6Ur1+Ja
	Rd3TlImx549bOdtimhVm7QPjt1++bwpI4vSS7Wx61bfDKHcEIAu80VO7onblXPt4rHFU0gh
	2MGd3s8dwssMWbswZ35UdqLk52z6luFzWkOa58eNPHBX5mENKEDIiFrTLSLqoTkIro5WJzm
	juotGS+XlFG9nv1Qqgbc1STBBm5OG9hoo9o2KWd84/Y0Qb7fZaGz/66NluCMJw+Sj74DlQM
	m6BdTYcReFLDKpd12w2KB3aIfaMjvTCO92PRCYDu/qvTb6wZRGgMmywEE1xlc/VqIL9Ru2Q
	8ulpNpq15G9S0ZK0xiiOt/r7uDabECexVqaoghLvm5nd30U5BDIjJHeVwAa8tC9rT8UHdgN
	FUqJnKq4KX4=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 155838097167296723
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH net-next v4 2/7] net: wangxun: libwx add rx offload
 functions
From: "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <b26664c9-7df9-f2dc-ca49-3e5abd3dab70@huawei.com>
Date: Thu, 11 May 2023 16:34:52 +0800
Cc: netdev@vger.kernel.org,
 jiawenwu@trustnetic.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <25FF2886-3FE3-4B20-9A77-217ADE6502B8@net-swift.com>
References: <20230510093845.47446-1-mengyuanlou@net-swift.com>
 <20230510093845.47446-3-mengyuanlou@net-swift.com>
 <b26664c9-7df9-f2dc-ca49-3e5abd3dab70@huawei.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> 2023=E5=B9=B45=E6=9C=8810=E6=97=A5 19:43=EF=BC=8CYunsheng Lin =
<linyunsheng@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 2023/5/10 17:38, Mengyuan Lou wrote:
> ...
>=20
>> +/**
>> + * wx_rx_checksum - indicate in skb if hw indicated a good cksum
>> + * @ring: structure containing ring specific data
>> + * @rx_desc: current Rx descriptor being processed
>> + * @skb: skb currently being received and modified
>> + **/
>> +static void wx_rx_checksum(struct wx_ring *ring,
>> +   union wx_rx_desc *rx_desc,
>> +   struct sk_buff *skb)
>> +{
>> + struct wx_dec_ptype dptype =3D =
wx_decode_ptype(WX_RXD_PKTTYPE(rx_desc));
>> +
>> + skb->ip_summed =3D CHECKSUM_NONE;
>> + skb_checksum_none_assert(skb);
>=20
> It does not make much to check skb->ip_summed when it is just
> set one line above.
>=20
> Also the "skb->ip_summed =3D CHECKSUM_NONE" seems unnecessary,
> as alloc/build_skb() all have the below to make sure
> skb->ip_summed is zero:
>=20
> memset(skb, 0, offsetofstruct sk_buff, tail))
It=E2=80=99s right.
>=20
>> + /* Rx csum disabled */
>> + if (!(ring->netdev->features & NETIF_F_RXCSUM))
>> + return;
>> +
>> + /* if IPv4 header checksum error */
>> + if ((wx_test_staterr(rx_desc, WX_RXD_STAT_IPCS) &&
>> +     wx_test_staterr(rx_desc, WX_RXD_ERR_IPE)) ||
>> +    (wx_test_staterr(rx_desc, WX_RXD_STAT_OUTERIPCS) &&
>> +     wx_test_staterr(rx_desc, WX_RXD_ERR_OUTERIPER))) {
>> + ring->rx_stats.csum_err++;
>> + return;
>> + }
>> +
>> + /* L4 checksum offload flag must set for the below code to work */
>> + if (!wx_test_staterr(rx_desc, WX_RXD_STAT_L4CS))
>> + return;
>> +
>> + /*likely incorrect csum if IPv6 Dest Header found */
>=20
> What does "likely incorrect" mean here? If it is incorrect,
> does ring->rx_stats.csum_err need incrementing?

This is a workaround for hardware, which the IPV6EX is on hardware can =
not
guarantee the correctness of the verification. So just ignored these =
packages
Check.
>=20
>> + if (dptype.prot !=3D WX_DEC_PTYPE_PROT_SCTP && =
WX_RXD_IPV6EX(rx_desc))
>> + return;
>> +
>> + /* if L4 checksum error */
>> + if (wx_test_staterr(rx_desc, WX_RXD_ERR_TCPE)) {
>> + ring->rx_stats.csum_err++;
>> + return;
>> + }
>> +
>> + /* If there is an outer header present that might contain a =
checksum
>> + * we need to bump the checksum level by 1 to reflect the fact that
>> + * we are indicating we validated the inner checksum.
>> + */
>> + if (dptype.etype >=3D WX_DEC_PTYPE_ETYPE_IG) {
>> + skb->csum_level =3D 1;
>> + skb->encapsulation =3D 1;
>> + }
>> +
>> + /* It must be a TCP or UDP or SCTP packet with a valid checksum */
>> + skb->ip_summed =3D CHECKSUM_UNNECESSARY;
>> + ring->rx_stats.csum_good_cnt++;
>> +}
>> +
>> +/**
>> + * wx_process_skb_fields - Populate skb header fields from Rx =
descriptor
>> + * @rx_ring: rx descriptor ring packet is being transacted on
>> + * @rx_desc: pointer to the EOP Rx descriptor
>> + * @skb: pointer to current skb being populated
>> + *
>> + * This function checks the ring, descriptor, and packet information =
in
>> + * order to populate the hash, checksum, VLAN, timestamp, protocol, =
and
>=20
> For now VLAN, timestamp are not populated yet.
>=20
>> + * other fields within the skb.
>> + **/
>> +static void wx_process_skb_fields(struct wx_ring *rx_ring,
>> +  union wx_rx_desc *rx_desc,
>> +  struct sk_buff *skb)
>> +{
>> + wx_rx_hash(rx_ring, rx_desc, skb);
>> + wx_rx_checksum(rx_ring, rx_desc, skb);
>> + skb_record_rx_queue(skb, rx_ring->queue_index);
>> + skb->protocol =3D eth_type_trans(skb, rx_ring->netdev);
>> +}
>> +
>> /**
>>  * wx_clean_rx_irq - Clean completed descriptors from Rx ring - =
bounce buf
>>  * @q_vector: structure containing interrupt and ring information
>> @@ -491,8 +586,8 @@ static int wx_clean_rx_irq(struct wx_q_vector =
*q_vector,
>> /* probably a little skewed due to removing CRC */
>> total_rx_bytes +=3D skb->len;
>>=20
>> - skb_record_rx_queue(skb, rx_ring->queue_index);
>> - skb->protocol =3D eth_type_trans(skb, rx_ring->netdev);
>> + /* populate checksum, timestamp, VLAN, and protocol */
>> + wx_process_skb_fields(rx_ring, rx_desc, skb);
>> napi_gro_receive(&q_vector->napi, skb);
>>=20
>> /* update budget accounting */
>> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h =
b/drivers/net/ethernet/wangxun/libwx/wx_type.h
>> index 70f5fd168e40..69a9ed7bc2df 100644
>> --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
>> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
>> @@ -321,8 +321,31 @@
>=20
> ...
>=20
>> +
>> +static inline struct wx_dec_ptype wx_decode_ptype(const u8 ptype)
>=20
> If the above is only used in one .c file, maybe it does not need
> to be in the .h file?

If I put it to .c file which use it, when compiling the other .c files =
will say
"warning: =E2=80=98wx_ptype_lookup=E2=80=99 defined but not used=E2=80=9D.=

>=20
>> +{
>> + return wx_ptype_lookup[ptype];
>> +}
>> +
>> /* Host Interface Command Structures */
>> struct wx_hic_hdr {
>> u8 cmd;
>> @@ -624,6 +853,11 @@ struct wx_queue_stats {
>> u64 bytes;
>> };
>>=20
>> +struct wx_rx_queue_stats {
>> + u64 csum_good_cnt;
>> + u64 csum_err;
>> +};
>> +
>> /* iterator for handling rings in ring container */
>> #define wx_for_each_ring(posm, headm) \
>> for (posm =3D (headm).ring; posm; posm =3D posm->next)
>> @@ -665,6 +899,9 @@ struct wx_ring {
>>=20
>> struct wx_queue_stats stats;
>> struct u64_stats_sync syncp;
>> + union {
>> + struct wx_rx_queue_stats rx_stats;
>> + };
>> } ____cacheline_internodealigned_in_smp;
>>=20
>> struct wx_q_vector {
>> @@ -680,6 +917,7 @@ struct wx_q_vector {
>> struct napi_struct napi;
>> struct rcu_head rcu;    /* to avoid race with update stats on free */
>>=20
>> + bool netpoll_rx;
>=20
> Unused?
>=20
>> char name[IFNAMSIZ + 17];
>>=20
>> /* for dynamic allocation of rings associated with this q_vector */
>>=20
>=20


