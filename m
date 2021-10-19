Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267494330E7
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhJSIQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:16:39 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:54994 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234561AbhJSIQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634631265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ghocWxY02FT5qpuoJoPc3DBmKjHDwZWyBlo83D0hIys=;
        b=QUfjItmVodvsGZQRdGPcg8z+iSrKegkKFsgmb1BKp/8xbz0i5zINMnnESMz243tk/dGIFV
        7H6Rg1S5dn+mdYcoUJ6NHFmMyY1oOS9e7jY9DBlMTVS3DkBw2t98iMS/HnV0ijwg4dr8QG
        B+7B3+dcOtde9al7zeECMRV/YNnkFgU=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2056.outbound.protection.outlook.com [104.47.6.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-_4K3pkYkNO-lzkrMZoLmIg-1; Tue, 19 Oct 2021 10:14:24 +0200
X-MC-Unique: _4K3pkYkNO-lzkrMZoLmIg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T41ICyN0qJCpag+2V0Q8MNsRt7jOzJhmmARbX7D6i6kkiXrxOfh/YB0m1HULNikkJABl6GF7XUR7UQAyHOU1BsHLP6fWBnD7mD0UVqr1fWAn3xqcqtNlGNNdnm3GAf50wReZmVhwZlkmlamkd2o/lhfXVmWVc/OaLxNnN2HQscT5qjpsnqOlEI4z+ciAuHkDHKqUGFmNKjgqdpfUcC6zZ0/jqrKJCvibWakAGejBBgYHvTtJgKCEtKHCvc25x6eGGK3ELfTcD0KG5BDs402kv+mg3Iqi7xwMDIRhjzg7iS5gNOfdLhVLakaTrXmYeWAgV1mv3LE26K7nMQemada6Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqfxP/dyO2zEkONcMytCsEcaovUArQkwcHHPNC/0U0k=;
 b=GZB+JKif7jS5b4APMYnIksLyy79BE0b4r7IBZSDTwVf+4LhSFevbrdmxewE5Cy2he5nnvwLPwdz007rT9/ubOgYdHpAwm3v8WhkUaMTLi206vgJaMktLbdiFrMD5zKfV3kNIa+Zy1HGTZZ1R9QJvUoqfq+ZxUSWyEVd3ILZhMs3a5c0h1zI+kGYpUmvrJ2lRei/X321VEmn0nNOtU1x1l8Gc5LN/BZDIVHT6r47/4VFCkKeONoKz+caQsDsk1Vo3U4MI6qqWuxwtjw4ojT1arqeKhlhv0g7XFKDIWAkusV7i4vWFamZYl2sbftI7Cjni7yNyQPVNNxxsT/htqS7UTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB6PR0401MB2646.eurprd04.prod.outlook.com (2603:10a6:4:38::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 08:14:23 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 08:14:22 +0000
Subject: Re: [syzbot] divide error in usbnet_start_xmit
To:     syzbot <syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000046acd05ceac1a72@google.com>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <c5a75b9b-bc2b-2bd8-f57c-833e6ca4c192@suse.com>
Date:   Tue, 19 Oct 2021 10:14:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <000000000000046acd05ceac1a72@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1d::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.9 via Frontend Transport; Tue, 19 Oct 2021 08:14:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaf3de0b-6e28-4e5d-8969-08d992d87529
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2646:
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2646E4FF6DCF733BDFD1E947C7BD9@DB6PR0401MB2646.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GFalxNRwUJD6A+Ny6B8uLGt3WTOCE4g6g5k+2Kat+h82qv/C96puYFm/bwTyonluPPIEG1eBFH8icS4BObFRQdwZxlQjqF/9P/pMXVeM+TuGpb4duhKOtZ60rtYUaiSkKTeZn6LPoxVx1NwU4DLYpAF2bH8c3PcKGL/eC+EIjNgQbSzVDKObuhooq/OQ8zUm7uq+rLZj0BdZ+eB8RpuDUHTk1ooyzQKiQxPh/g31xzza8GfJrAoHzKx+rLok0+57BdVDui/rjIoOVrWi2+WCmnXTuosSelRn/AoIdWuL7tqWfV86InN1gUbOFFVnLucTMzyL0ASh/DDNdF0iJyxvbZUaIUC0X6jNY0RzhISsu68CgZ8/RME3VfO9P7p+j+Cw/AhgAYCM68KgTIOJSEV9vnsDPg9a2OdeQJkiolUFqSQ5lWyofaIvR9j++DWGFAGhlPk62NqDj56t0XYbDtSnEU/BNmOCHmmSheaiD5m6Yk22lXr3rRmELgP9nSjscWweoZZ3jGjkY2xZLdzVGUhn5+pgGpecmhX4itUstdRQVjlPZIwX3dF/iT1uBjb1pRCbzQJGwhJOa7fS++cJoXUNsRxL/wBmM06VflcYKrKYwnYX9RKGV0KwPXiDoGo6RHc6HWkeua58GUJjCv1uoEKdVsOVRzHRarWMbq35fMO/KN7FxdWk7ChFAKva61gYbrACSxM2Emn4SgIOggBGOqgvlICc7A+vJ8TWpfp+7jrFMpB6iT1R+vimp0I/ETJzPlxvZcCuMU/8AyVaHMmkuEeI7JXQwkz+ls3cf8sLoAre+AQmmTexqMKrFKfTsJI95qA8SxCdpY2PsItRSJIgGomQvu1YaADpJCfmUzuLmRP8etVoP0SkP52dwALYM2uySV5mFsnDBByWR77kYAucd8HQupF1Xk5sgh4tbzIfsWkbEos=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(8936002)(2906002)(36756003)(6486002)(38100700002)(6506007)(508600001)(5660300002)(316002)(186003)(66476007)(66556008)(6512007)(31696002)(8676002)(86362001)(31686004)(2616005)(66946007)(53546011)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fo7XDed0bY9aCERmpRmXThbBRpFTF+jrg4fNzAR+mM/4FEvzLM7yGloRcfLm?=
 =?us-ascii?Q?YcdgvDXfz79IiiLLs686Pejx4fHCKX7UudabckKOZJ69AKZ+lXEbHjFUM1lW?=
 =?us-ascii?Q?SbNlct033mOBJR7hHa/MyiEvm3IS0DEaFzhi466KKmIRx5xyAYALhXTfgJfV?=
 =?us-ascii?Q?fLS2qAh0Ip9GYlHONPhwGAfQoMzBeUqBBFjHGatEePOYI7eW+0qa0CLiujcV?=
 =?us-ascii?Q?jqzMReLTD1Xzohw2vY7RPLzz2md+2tWEIGco4dVh67Mo5MtcCzn13/CllaOr?=
 =?us-ascii?Q?cz0BsbVvglNBIol0pcWov9hJLiSRxZ6NZ5D2tbVC5eFiEnHVGbUxLA5qTIXO?=
 =?us-ascii?Q?7UmICpTBWLo9fm/K+XjKFniSW0AallcpoCR/TNKyXdp1NRfpbS6WRWNrRoak?=
 =?us-ascii?Q?kOoZ4XdUVFSMtEfRvGXJ48xQzq9S2E3CRD2ITQZsJdg+CBZe0HlK0Rczv6pn?=
 =?us-ascii?Q?JJ0i1TW6js1gs4w4jU/O4w250sgN5gkxU1/+BQ7NN1JeF2YuafG/2xJ6ZP+N?=
 =?us-ascii?Q?C8EliawXnVk20a0h9Eg5TNP33yV64/O2IGj0Tr5cOBI9e4jNHs56qH5yx3eZ?=
 =?us-ascii?Q?yhUGIHCTKyfuHPWn8VXCRdj8d1Ox/gzVFMYfZq+MHWtLbhK4o+aS4YnNnQ56?=
 =?us-ascii?Q?C26Onb6bnUYbsJnZUmNEmbrZETbcu4+MZqRNn1mBaMZix/J0vxwyawPeieyt?=
 =?us-ascii?Q?g5TsDEGoLLv9nrDBfbpzH2PJmLxJk0wOEUswqaQC2r1ZRJrGJNA6+YtE7yC/?=
 =?us-ascii?Q?NrkxiUwD0nZOtCya/6wnvPs8cJ0cNeUoW2o0a4GUoWdxnXz3RRnvxqVpYDce?=
 =?us-ascii?Q?eNBe5/r+91emyI2eJpBajrF8Pp/hEj5W6txAnbM8EDMwEOWm9gl3K/JQsbAE?=
 =?us-ascii?Q?GKebKalCtA41P+ULPFnFO+nfJ9E0mSGZivKdn89tI0KxUehkYdTEjjWvo8Br?=
 =?us-ascii?Q?kcVjjphYww4QQqQe9dt1rsN+ZfWmHdVyjTuBF9zn7Jd3DLoI+0GgjojryMgC?=
 =?us-ascii?Q?vxMQ4hxYb8VFhKSaBwjYFcHlUm/FiRQHXnPgg9wwiFV9RgQSs4Rn8d7lonmp?=
 =?us-ascii?Q?lMTIZw87ZCqaVy4/XkdPMWDzqAuNtnT/2Jj9iwTgXSYq+cQv29SXviJx5FXn?=
 =?us-ascii?Q?W+bwYfmlILizQx7udZxW6HIMT161Ew2xDosc4KYQV1+mtJi/HFwZivpCS8RC?=
 =?us-ascii?Q?eebI9W/J7h3WyMFSncA+hjFJLFubDrivxxyjD7226q1a41+Dpuxs8ZREOOXr?=
 =?us-ascii?Q?1HuP/GrRW049GiZnUKxn9iq8+09/6y2Y7c1qJo476twg3cEnMvhYPJlayjVZ?=
 =?us-ascii?Q?LUulLF2OVgkFo1sr/RA19FZg3eUySHuyAaEUkd0RIBbE9L/oULEK6xsmV4Q2?=
 =?us-ascii?Q?OYTxEsb6gxN1AmAMSv/FZWoOyVXa?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf3de0b-6e28-4e5d-8969-08d992d87529
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 08:14:22.7112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YqKor3b73ZTIj2tfNuSwUEm2h71NlvNKVSxWNrT/pKsRPMNnv2PBURhMU0CgX8K0ueWS67mdZYzcjYFXSBGpXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2646
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19.10.21 05:17, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    c03fb16bafdf Merge 5.15-rc6 into usb-next
> git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/us=
b.git usb-testing
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D12d48f1f30000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc27d285bdb745=
7e2
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D76bb1d34ffa0adc=
03baa
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14fe6decb00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15c7bcaf30000=
0
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com

#syz test:
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git c03fb16bafdf

From a5270791d4480e9a6bc009c69a4454039aa160e7 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 19 Oct 2021 10:02:42 +0200
Subject: [PATCH] usbnet: sanity check for maxpacket

We cannot leave maxpacket at 0 because we divide by it.
Devices that give us a 0 there are unlikely to work, but let's
assume a 1, so we don't oops and a least try to operate.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
---
=C2=A0drivers/net/usb/usbnet.c | 3 +++
=C2=A01 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 840c1c2ab16a..2bdc3e0c1579 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1788,6 +1788,9 @@ usbnet_probe (struct usb_interface *udev, const
struct usb_device_id *prod)
=C2=A0=C2=A0=C2=A0=C2=A0 if (!dev->rx_urb_size)
=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 dev->rx_urb_size =3D dev->hard_=
mtu;
=C2=A0=C2=A0=C2=A0=C2=A0 dev->maxpacket =3D usb_maxpacket (dev->udev, dev->=
out, 1);
+=C2=A0=C2=A0=C2=A0 if (dev->maxpacket =3D=3D 0)
+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 /* that is a strange device */
+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 dev->maxpacket =3D 1;
=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0 /* let userspace know we have a random address */
=C2=A0=C2=A0=C2=A0=C2=A0 if (ether_addr_equal(net->dev_addr, node_id))
--=20
2.26.2

