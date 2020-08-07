Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5083223F267
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 20:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHGSDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 14:03:09 -0400
Received: from mail-eopbgr1320128.outbound.protection.outlook.com ([40.107.132.128]:6072
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727956AbgHGSDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 14:03:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDevWBo1v6I9j/XUzkZkkTqgH9foQ4bZd92uuoVZn6CeUdRfBznU+ctoN8FdG+0WsvMZKKIHqh4gRANzsJxYMtXN/KnEv22CYf5NDYuEV8D4S2QAUQp8BazMdRq64uiu67CsxtrDREDoACcvgUmJyhsgQxz+vZXlJR0BTtqiECbZm3V0U31qRiWVGgIvmXyPDW/YFrW66914mqFTIC/ZA97nI8JUAol8eaik13cAji8pvGFl3DKuw5MW91HgjBtr8DgGjSjWPWOTOYeE9YVFfAb6sPDjWifVfr3Hps701ZUWy3W2nmSXg3EjKvBL8EmI0hr7IWpu5Fm1O5moHkLtvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ivm+0AxZ3LZmolE4Ez/vJaW/fkoCKh1/NjzNWhI/Mwc=;
 b=c56HmxmrT+5i4WkCgla+G++d/NfGJ3lIRVPSOxtsTnP0ZEqTQV9TtKwYP4FA67qneXgvTw9KzVeQdDEmIiLjXWu5u/6rtAXlCgegR5WQ5nrx+KTmmGB+y2geC8cf534g8MJnFT5hXztyD8SYtVjmF4ZApo4kPzVyzr5IzGgS4BeWhowG5UQxrtlNC5Tsu69KSPxfjAQzjNSPubT0lx3bibWG2h5ErZrHiq/8Nqw+Bx1DNzJPdmyQNyQjiirpQmMd7WT1NMbvMX2BL4InyAm/vLmWiRoy3qqDpOvWE24KfAhrTR7k/UWwAca9GU+rc7m/qJpgIgeigpBU/wxrJ3vf4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ivm+0AxZ3LZmolE4Ez/vJaW/fkoCKh1/NjzNWhI/Mwc=;
 b=holo4E/59bWk4h4g+bTO3G6T3hVbL4Wo1RTY6s/TpDcBhTS+BoZcVQ2wMpLvr9oEVCZNb1dLk9N/7Dyl7joo1E3Z43Ne/7+GkoAjg+AL1jDApZYH4t5++sI9JIXGfTrEm6Q3Y241+ZAXQSkEndFu0AtfVI88ibV/KHxjVM7GVcA=
Received: from KL1P15301MB0279.APCP153.PROD.OUTLOOK.COM (2603:1096:820:10::18)
 by KL1P15301MB0039.APCP153.PROD.OUTLOOK.COM (2603:1096:802:10::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.2; Fri, 7 Aug
 2020 18:03:01 +0000
Received: from KL1P15301MB0279.APCP153.PROD.OUTLOOK.COM
 ([fe80::e931:a807:bfc5:2fae]) by KL1P15301MB0279.APCP153.PROD.OUTLOOK.COM
 ([fe80::e931:a807:bfc5:2fae%2]) with mapi id 15.20.3283.003; Fri, 7 Aug 2020
 18:03:01 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>
CC:     "w@1wt.eu" <w@1wt.eu>,
        Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ohering@suse.com" <ohering@suse.com>
Subject: RE: [PATCH][for v4.4 only] udp: drop corrupt packets earlier to avoid
 data corruption
Thread-Topic: [PATCH][for v4.4 only] udp: drop corrupt packets earlier to
 avoid data corruption
Thread-Index: AQHWZIJFLibybd19cUCV0Lvi+HWCjaktADtQ
Date:   Fri, 7 Aug 2020 18:03:00 +0000
Message-ID: <KL1P15301MB0279A6C3BB3ACADE410F8144BF490@KL1P15301MB0279.APCP153.PROD.OUTLOOK.COM>
References: <20200728015505.37830-1-decui@microsoft.com>
In-Reply-To: <20200728015505.37830-1-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-08-07T18:02:58Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f1f0c9b5-8cb2-474c-b4ca-67102857b2d0;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:100:e818:402d:e7d2:aecc:5b5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e825ccbb-0a3f-4a04-bd61-08d83afc1fe3
x-ms-traffictypediagnostic: KL1P15301MB0039:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KL1P15301MB00397A34EB306145BD239F72BF490@KL1P15301MB0039.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wWKT6xevhFacfAMsUZj3gHI748Nsw6tkVThT5QOyEMPJ+UCBJSDJET0Z+3sF5fJVhtZ59yn1B3hj8uXmZHCkyiG+kFARJGZSnTA8Lj7orbhijuKEpg3R6L9M0yXk7EkbKa4cS96BIANgnDDgWxQNJs/aGXqKd3FzIoWLzR9slQ7v0uawi16jhQPPDMMEXo5q6nsGZMxXYaxmDRJF8IvPHmWxHR0MPnH8SAswFoAKPo5MKXsfengqJc+jMm/0NDYQ0SfyMfvVn0ipGXcpbe8ksYlkbanZhDy+mvapFeajROdWyo14zET7ntEk0FGsNZCkuDHXFpxeRd1vX3LSgHNqeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1P15301MB0279.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(10290500003)(53546011)(6506007)(82950400001)(54906003)(8936002)(110136005)(55016002)(83380400001)(82960400001)(8676002)(6636002)(7696005)(316002)(9686003)(66476007)(478600001)(76116006)(66946007)(8990500004)(4326008)(66556008)(66446008)(52536014)(5660300002)(64756008)(33656002)(186003)(86362001)(2906002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Au6QWawXPRgLOSCQMysJMt4BnfkBDkH4XAelE4g49ddK5jWfyzeEhwi7QbuZX/vEKVWWh66xmWCdJDwdakDke2xYL/q0iJoFuxWpq+rWu9qjR+F08nkFBHShWwuRzvIsWl2zTF67oc2UakSf1Tgjca7kRwKOfYWZNA2pk+xgrmuG0rygnUg4A38w4q3mCV4RxibTVIc0CL3tTwOfhhRTxtBJH6w8V6JsH4FIF4P2xWtyAjzWSKJ9zcKqL3EJ+MdJHZWp+7FkfiIqXM8vgOk2ba8BaXIZgvfBItgL3lBKm/NfddJ9mslMEFfKmcrp9O3S9dXNXplij8ok9TuOcCxP5tHQC4p26frFNmKy6b2TJhI//yK51BzUiKzPgSEzV5y8HydQp66VjlSPwlZrpMUYhuIr3o+fkyyWn1e2+m3Rp0jWh8XwB0ZZAoKmwHfDKREMr/jPKdHM8UG97S72dbRDIDeWTbnJ69gjcRdvkdiZ0eY5EHVhwPqO0w5ALmjZ1OKAURWv74FZVWlFA4+kogMhOIAcU69hte1QHkXXn8eT9aysvx0/ZL8hpjaTWPNL1cU4JfpYxcnFwz59NqxiIC+tZK5yTSPMBRNnE22az5qwoInUjyR2fRi0eMp5hmhmAT9P7caeybZTQF22j8TS0okhpwK7C81LMaV51zG10xBFItrQLgC8eMRbI3lqhRy3FmxRg1X2ue31ECKKTrkbOcDlgw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1P15301MB0279.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e825ccbb-0a3f-4a04-bd61-08d83afc1fe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2020 18:03:00.9586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2uso/po126SSqaBlRHN5NQt0GMpUUPvsP3KNVuZgppOYy7qgvRjf/wNSWJbl23BLt47raOQJwAbgZmiIx7VvyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1P15301MB0039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dexuan Cui <decui@microsoft.com>
> Sent: Monday, July 27, 2020 6:55 PM
> To: gregkh@linuxfoundation.org; edumazet@google.com;
> stable@vger.kernel.org
> Cc: w@1wt.eu; Dexuan Cui <decui@microsoft.com>; Joseph Salisbury
> <Joseph.Salisbury@microsoft.com>; Michael Kelley <mikelley@microsoft.com>=
;
> viro@zeniv.linux.org.uk; netdev@vger.kernel.org; davem@davemloft.net;
> ohering@suse.com
> Subject: [PATCH][for v4.4 only] udp: drop corrupt packets earlier to avoi=
d data
> corruption
>=20
> The v4.4 stable kernel lacks this bugfix:
> commit 327868212381 ("make skb_copy_datagram_msg() et.al. preserve
> ->msg_iter on error").
> As a result, the v4.4 kernel can deliver corrupt data to the application
> when a corrupt UDP packet is closely followed by a valid UDP packet: the
> same invocation of the recvmsg() syscall can deliver the corrupt packet's
> UDP payload to the application with the UDP payload length and the
> "from IP/Port" of the valid packet.
>=20
> Details:
>=20
> For a UDP packet longer than 76 bytes (see the v5.8-rc6 kernel's
> include/linux/skbuff.h:3951), Linux delays the UDP checksum verification
> until the application invokes the syscall recvmsg().
>=20
> In the recvmsg() syscall handler, while Linux is copying the UDP payload
> to the application's memory, it calculates the UDP checksum. If the
> calculated checksum doesn't match the received checksum, Linux drops the
> corrupt UDP packet, and then starts to process the next packet (if any),
> and if the next packet is valid (i.e. the checksum is correct), Linux
> will copy the valid UDP packet's payload to the application's receiver
> buffer.
>=20
> The bug is: before Linux starts to copy the valid UDP packet, the data
> structure used to track how many more bytes should be copied to the
> application memory is not reset to what it was when the application just
> entered the kernel by the syscall! Consequently, only a small portion or
> none of the valid packet's payload is copied to the application's
> receive buffer, and later when the application exits from the kernel,
> actually most of the application's receive buffer contains the payload
> of the corrupt packet while recvmsg() returns the length of the UDP
> payload of the valid packet.
>=20
> For the mainline kernel, the bug was fixed in commit 327868212381,
> but unluckily the bugfix is only backported to v4.9+. It turns out
> backporting 327868212381 to v4.4 means that some supporting patches
> must be backported first, so the overall changes seem too big, so the
> alternative is performs the csum validation earlier and drops the
> corrupt packets earlier.
>=20
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  net/ipv4/udp.c | 3 +--
>  net/ipv6/udp.c | 6 ++----
>  2 files changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index bb30699..49ab587 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1589,8 +1589,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct
> sk_buff *skb)
>  		}
>  	}
>=20
> -	if (rcu_access_pointer(sk->sk_filter) &&
> -	    udp_lib_checksum_complete(skb))
> +	if (udp_lib_checksum_complete(skb))
>  		goto csum_error;
>=20
>  	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 73f1112..2d6703d 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -686,10 +686,8 @@ int udpv6_queue_rcv_skb(struct sock *sk, struct
> sk_buff *skb)
>  		}
>  	}
>=20
> -	if (rcu_access_pointer(sk->sk_filter)) {
> -		if (udp_lib_checksum_complete(skb))
> -			goto csum_error;
> -	}
> +	if (udp_lib_checksum_complete(skb))
> +		goto csum_error;
>=20
>  	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
>  		UDP6_INC_STATS_BH(sock_net(sk),
> --
> 1.8.3.1

+Sasha

This patch is targeted to the linux-4.4.y branch of the stable tree.

Thanks,
-- Dexuan
