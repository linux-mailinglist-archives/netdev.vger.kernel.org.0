Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF322BC548
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 12:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgKVLKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 06:10:52 -0500
Received: from mail-eopbgr150054.outbound.protection.outlook.com ([40.107.15.54]:48615
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727621AbgKVLKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 06:10:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOlD/WoXS1bvQUp/2RazId9jkrolW4q+ryMjegOXr10=;
 b=P8r34M6YaNztLrrXoTq//CGBr7myyFvEzhAaTI2ua8I7eqR7QqPsv9rmFPlNDn1F0jS0TX3G7djaz4TM9mYHvQC48KouiZJR9bk5C/RNxh5jNFW8XthdUrkCnathqVcSzeneAm1YVpk0uOI/6EHqNC0+LfhtKkn+eZuKON/AcgA=
Received: from DU2PR04CA0123.eurprd04.prod.outlook.com (2603:10a6:10:231::8)
 by AM6PR08MB3397.eurprd08.prod.outlook.com (2603:10a6:20b:43::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Sun, 22 Nov
 2020 11:10:46 +0000
Received: from DB5EUR03FT030.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:231:cafe::f0) by DU2PR04CA0123.outlook.office365.com
 (2603:10a6:10:231::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Sun, 22 Nov 2020 11:10:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT030.mail.protection.outlook.com (10.152.20.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Sun, 22 Nov 2020 11:10:46 +0000
Received: ("Tessian outbound 814be617737e:v71"); Sun, 22 Nov 2020 11:10:46 +0000
X-CR-MTA-TID: 64aa7808
Received: from a7c45beb74dc.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 8C823A6F-0210-4CC2-B331-A98FF1F33CFF.1;
        Sun, 22 Nov 2020 11:10:40 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a7c45beb74dc.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sun, 22 Nov 2020 11:10:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5psLs5kf1oLKzMNj2meqjz2TVn3oJc68x/1F+rlnsepnho0Z5lWeGQJgYw++KYiuP5i12UmUlOZfj0yL0e5ECAD+e78BUekHZBL+DRgGke/63FDtRiUJ4xfwP/JXwlKxnFFIWUWx6vfv16IC4ID9M58x36inyfqUYCpnODyILdNydtQZIiFbNm9JC/HNsBMdDZErfBwxulPYQHLJ5GXQrfXn8ROc20ZD9VOiA+E8oOggkpvn30mXy1xAQTjK6CFMtHQpDYsODy4uVKIktx8n7Mjul6uygStjOkw3+UvYbl8WIgoMPENdc7dp9lv/YDy7Mc7OB6dtf2luOcFG6jzRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOlD/WoXS1bvQUp/2RazId9jkrolW4q+ryMjegOXr10=;
 b=e26CAaOSLaykYqlRxSXW3GnVB6H04piULzgAOPcp8CnGeG8cc8msAC/be/JlnIu5/KsJ4S8Mx9/io9Vwu3UXSPb1+5baRI/yYpIFQpT3cUa+UzCsbZRXM/RPtCkqKlho09ClwYlu80VGSKLh8yUt6bJjjJMhpWZkCqLcY5dH0Vu3fIlZrcjvHYNwp2otwWbjP+1g9Kmq6FAPahoTDgtb3S6Iv3b3L2DSITNPYlHGIRlCyAd/cmlC3bgg7t/MHC5fT2i7xERak/7RaSTYw+HL5dEsitEQSgw4kNXgkeqn9ET3ecWFFz1A2flYnYDza+DbOSeHSXHxtF6iBaUdzuKYdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOlD/WoXS1bvQUp/2RazId9jkrolW4q+ryMjegOXr10=;
 b=P8r34M6YaNztLrrXoTq//CGBr7myyFvEzhAaTI2ua8I7eqR7QqPsv9rmFPlNDn1F0jS0TX3G7djaz4TM9mYHvQC48KouiZJR9bk5C/RNxh5jNFW8XthdUrkCnathqVcSzeneAm1YVpk0uOI/6EHqNC0+LfhtKkn+eZuKON/AcgA=
Received: from AM6PR08MB3224.eurprd08.prod.outlook.com (2603:10a6:209:47::13)
 by AM5PR0802MB2452.eurprd08.prod.outlook.com (2603:10a6:203:9f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Sun, 22 Nov
 2020 11:10:38 +0000
Received: from AM6PR08MB3224.eurprd08.prod.outlook.com
 ([fe80::98:7f10:6467:b45]) by AM6PR08MB3224.eurprd08.prod.outlook.com
 ([fe80::98:7f10:6467:b45%7]) with mapi id 15.20.3564.028; Sun, 22 Nov 2020
 11:10:38 +0000
From:   Justin He <Justin.He@arm.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Sergio Lopez <slp@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH net] vsock/virtio: discard packets only when socket is
 really closed
Thread-Topic: [PATCH net] vsock/virtio: discard packets only when socket is
 really closed
Thread-Index: AQHWvyqezes+U9UD7UGXOgDXeql7aanUARVA
Date:   Sun, 22 Nov 2020 11:10:37 +0000
Message-ID: <AM6PR08MB322464FD9542BF91211EC2ABF7FD0@AM6PR08MB3224.eurprd08.prod.outlook.com>
References: <20201120104736.73749-1-sgarzare@redhat.com>
In-Reply-To: <20201120104736.73749-1-sgarzare@redhat.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 7EB6F74980304F419AC7F0DEA43F32B3.0
x-checkrecipientchecked: true
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [223.166.32.225]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a3fe570c-79b3-4aeb-bdd3-08d88ed742b0
x-ms-traffictypediagnostic: AM5PR0802MB2452:|AM6PR08MB3397:
X-Microsoft-Antispam-PRVS: <AM6PR08MB33976E153A5E422686FD0CDAF7FD0@AM6PR08MB3397.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1728;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: /06OETTQWCZdGeCS7HdDScqyMgH9GBOAn86e5spTwi4XSyJhhggTSkgcmjveY44trn9OCySLtZ6uZCoYZLFbL3G5yb5MYoUq7z3QeFaeS1071sdSL0ACYWaoJ0w8TXZ2zKYSS/cwAk9OmeBQ5fSWrUfweLj6BQNTbrFIutDifywpS3+lnzHOCPNEi5Xjt7sMlCKtuIMnrUxjQRvdcsrqhm3GVaTc/wHUDxqz3FTER6md5R7rqX5oEh9QVPiiI3ONFQAK4sqmNx/9fh1b9OYbiWkrpJcJAV2pDa/EO/+wSpiut575RiEK1sMvmUt8RMSwvyRqd/cSREPZHaGdZhnJCMbRLMs0XuWIBu2MBWodVWa9+3ouHSQLWdw8PahhL1FT75MXN8wb7sDr7u7GcqkXcA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3224.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(39850400004)(396003)(8936002)(966005)(71200400001)(66946007)(4326008)(33656002)(9686003)(76116006)(55016002)(26005)(478600001)(66556008)(64756008)(316002)(54906003)(66476007)(66446008)(2906002)(86362001)(186003)(8676002)(7696005)(52536014)(83380400001)(110136005)(6506007)(5660300002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BRbPZi0CDwydPeN5nmHbJMqMW+QIxr2vcu1KXknmtSvpJ7bibk7Ed7hT/+wCRplCv26MOwrPXrPrtXgcvFW+GC7dqTjSQX6cAok/nxTNSSCBQDs05BKd76c+fBoI+Sox9Kxpaf0MG3CGfHMdT4/Q9WiNvDBXyj7ZD3j+oIpsFF9ibmldvFAI719g46rd9X63zUu6/YQslvE7ElRxUQm8jbHXWlWu4CvAvWKMBL68uvq5uTddrlMINkNzVU7Ehj0NMW2jh9BuTs1BL8Stnn/JBJDwsAeHSNyGxIyl3IGxMNWLPWo1Wdl4acAU4yVX9q5aseGSVNhDdbXzQV+agWnsGtlR38EhrPx5d76BWTT5GRF8Ipixgz2HxaRej/Let07mSmsbMSc+7UGUqobIchIi+UlFjZeYQrOdGTc83fMUl0Bl6o8tv1vdDE5zCMOsEboR3RNwZRKfbChMxiCr4tDnmZUjUeoUwNVoLOfRFxCawwTZCycEeoDrkafNqa2FtV5/I8+G0SplHxPZNps57iJVojDSavN+rvRs+JaPQVuy0M/OpDdbD2ByGaT/JrqGPOTPxLSnCQcDg5SY0jD4neOGI2+B8lHTRTTvDnt/UqDtiC9jRtSVFIDDkoUUiF6ou570gDG8D86ddGvxFMftTfH9OQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0802MB2452
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT030.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: cdec7b0a-d060-4822-4294-08d88ed73df8
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5SPNb8xZ8+CjLHEDAFYJnvoV55uonHOAJ4qmX7Z2bx5ZkP3hdrQIVlYgkRN54aL5p6luV9DVJTJIJLvZ8JPQq0wxNAH1itb0YsPe1+pYyEqYFFQeydSe2ha8T8AqwYZc1m9wcWI22G7MHzn7n8KBZZgxLWYReTdAr4uSjsifK3xES0bjJrzsO//qBXN4MpcLF9+nLAmDzHjDbGSq6brKf/ytINasgHI5c6hxdWU6yExIri72nBDMxQ4oCpuLgFXPCkySqU5wvTE3TA+yhWgg+wIvzqM/Qr9chvf1QZ8VXbyS8mHWrB39xOGZSbEQjE0uaI6uCG2LL5PTN7tyZl5e2tg6At3HBZrNnKU1+D8blBEAT+8vkEDzpeSIYHsz+fMzJ6j3yR1IlcuMLiyQapWtrEb8qSI4ek+ybB3xTo8PFrjuaR4Vj49VFRqLdPGToN7bBRPmkPz7xVHj3HAkl3mOVe6BdB3+dwCYxjAuLnTU1Nc=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(376002)(346002)(46966005)(82740400003)(82310400003)(47076004)(316002)(54906003)(6506007)(336012)(2906002)(52536014)(26005)(7696005)(53546011)(110136005)(356005)(83380400001)(81166007)(186003)(5660300002)(55016002)(70586007)(9686003)(8676002)(86362001)(966005)(8936002)(478600001)(70206006)(450100002)(4326008)(33656002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2020 11:10:46.0797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3fe570c-79b3-4aeb-bdd3-08d88ed742b0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT030.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3397
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Friday, November 20, 2020 6:48 PM
> To: netdev@vger.kernel.org
> Cc: Sergio Lopez <slp@redhat.com>; David S. Miller <davem@davemloft.net>;
> Stefano Garzarella <sgarzare@redhat.com>; Justin He <Justin.He@arm.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Stefan Hajnoczi
> <stefanha@redhat.com>; virtualization@lists.linux-foundation.org; Jakub
> Kicinski <kuba@kernel.org>
> Subject: [PATCH net] vsock/virtio: discard packets only when socket is
> really closed
>
> Starting from commit 8692cefc433f ("virtio_vsock: Fix race condition
> in virtio_transport_recv_pkt"), we discard packets in
> virtio_transport_recv_pkt() if the socket has been released.
>
> When the socket is connected, we schedule a delayed work to wait the
> RST packet from the other peer, also if SHUTDOWN_MASK is set in
> sk->sk_shutdown.
> This is done to complete the virtio-vsock shutdown algorithm, releasing
> the port assigned to the socket definitively only when the other peer
> has consumed all the packets.
>
> If we discard the RST packet received, the socket will be closed only
> when the VSOCK_CLOSE_TIMEOUT is reached.
>
> Sergio discovered the issue while running ab(1) HTTP benchmark using
> libkrun [1] and observing a latency increase with that commit.
>
> To avoid this issue, we discard packet only if the socket is really
> closed (SOCK_DONE flag is set).
> We also set SOCK_DONE in virtio_transport_release() when we don't need
> to wait any packets from the other peer (we didn't schedule the delayed
> work). In this case we remove the socket from the vsock lists, releasing
> the port assigned.
>
> [1] https://github.com/containers/libkrun
>
> Fixes: 8692cefc433f ("virtio_vsock: Fix race condition in
> virtio_transport_recv_pkt")

Acked-by: Jia He <justin.he@arm.com>


--
Cheers,
Justin (Jia He)


> Cc: justin.he@arm.com
> Reported-by: Sergio Lopez <slp@redhat.com>
> Tested-by: Sergio Lopez <slp@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/net/vmw_vsock/virtio_transport_common.c
> b/net/vmw_vsock/virtio_transport_common.c
> index 0edda1edf988..5956939eebb7 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -841,8 +841,10 @@ void virtio_transport_release(struct vsock_sock *vsk=
)
>  virtio_transport_free_pkt(pkt);
>  }
>
> -if (remove_sock)
> +if (remove_sock) {
> +sock_set_flag(sk, SOCK_DONE);
>  vsock_remove_sock(vsk);
> +}
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_release);
>
> @@ -1132,8 +1134,8 @@ void virtio_transport_recv_pkt(struct
> virtio_transport *t,
>
>  lock_sock(sk);
>
> -/* Check if sk has been released before lock_sock */
> -if (sk->sk_shutdown =3D=3D SHUTDOWN_MASK) {
> +/* Check if sk has been closed before lock_sock */
> +if (sock_flag(sk, SOCK_DONE)) {
>  (void)virtio_transport_reset_no_sock(t, pkt);
>  release_sock(sk);
>  sock_put(sk);
> --
> 2.26.2

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
