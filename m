Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9C744C33F
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhKJOqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:46:18 -0500
Received: from mail-db8eur05on2092.outbound.protection.outlook.com ([40.107.20.92]:46240
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231731AbhKJOqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:46:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQ9LI7wwsBt3PVtrIxmwHWsBFPloYy+JUOicHBzPj82/fGMafmlBfQ8yoq10ZosLboW7lU44MJD4UcUaKWAa+uzeRdfPl46+s/poqky79Nj+FNvzUoQWFkRP33xHQylEqfhkEIrIkkaJ1iurFtLcNKYX+T8dqdskF2PdZ6STbexcbrqvSj7PQo32GARBe6R/KrXikyq7qXK8h+kMNWeoQXiAxkZtoGPMzrr5DTbopjAtY/nqKdH2e9V+My1HU3vU69qgMa1QMmQ7Hn66l4KuKIiLuFbtSjLWdvzG3A9s+yg1LsY1oxn5zwzJFFI+xHt3NSUHgeqhIkPTjzeYDdsEFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHAzYfWTYGKOBoFMapHP1Twmlvhq/PVFNHxGl6q5wU8=;
 b=kqdPHAeFSNf/DR3oY4Pze8zf2ThxYK6BLUoIaobi0OJQBjs1rhWk7Wvqr2P0IM1Y3zEp4NKZsn8piuDAWL4t6g1WdEYz7pTD5rai48sRAHdCkhAOp5fQCAATUKZvDaZBZg5VHylxKAOMn1FLIn11UZvWbfl6G1s1Dvz7tWEn8EqZF6koaUIurlJJN+RI121haujKblx/yMyyR729mSy5HgM1EVV/oQDF3zCsty+KKaTjqmxR7UptR/cFrv1ZIozFICYXd1UKBr+RjQJwyh31B60J4Xz4cXWJSeJbNHiC60CAxkKCZfipMzjuf7c8dvKuxj1IK4HAWdKE6s3Ydkt3Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHAzYfWTYGKOBoFMapHP1Twmlvhq/PVFNHxGl6q5wU8=;
 b=TsywTzLP2aYMBi39FzH5to1s/LWAnltbXK70s13k6WHoyUBCDEQsebct2uoZHyw+j6AOsgU2X3L8Si50fp0rkvMsqvkZRAGBn/EchsT7UGwljQuJ4nEFRbO3krkq+U0k/PO77XUKo2gnp8cDlJo7lb5x2jw72nhv/mrWD9vdAHSCnfYfYamf4ZoIT9oF2AcM7N04r97RblDUcx8W7e0oIPLz7UdJGnC6/PNMOUyxJLn3KtYEqIIwdq1GyqzDvHbvkAQwp9ONgMQCXtrS/kPjjQO7fulotqlBXTipbgLQKCRXchZ+ekGiHs9VKPiOvaRIHuIHqueS3UxlW9zg7Ec5oA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com (2603:10a6:102:12e::18)
 by PR1PR06MB5482.eurprd06.prod.outlook.com (2603:10a6:102:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Wed, 10 Nov
 2021 14:43:27 +0000
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::89b8:d738:4829:5a15]) by PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::89b8:d738:4829:5a15%8]) with mapi id 15.20.4669.016; Wed, 10 Nov 2021
 14:43:27 +0000
From:   Louis Amas <louis.amas@eho.link>
To:     emmanuel.deloget@eho.link
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, louis.amas@eho.link, mw@semihalf.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: [PATCH 1/1] net: mvpp2: fix XDP rx queues registering
Date:   Wed, 10 Nov 2021 15:41:06 +0100
Message-Id: <20211110144104.241589-1-louis.amas@eho.link>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <DB9PR06MB8058D71218633CD7024976CAFA929@DB9PR06MB8058.eurprd06.prod.outlook.com>
References: <DB9PR06MB8058D71218633CD7024976CAFA929@DB9PR06MB8058.eurprd06.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0159.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:1::22) To PAXPR06MB7517.eurprd06.prod.outlook.com
 (2603:10a6:102:12e::18)
MIME-Version: 1.0
Received: from las.office.fr.ehocorp.admin (2a10:d780:2:104:b76d:bd61:93c2:dac9) by MR2P264CA0159.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Wed, 10 Nov 2021 14:43:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1b4833a-6511-4a6e-e36f-08d9a45874c7
X-MS-TrafficTypeDiagnostic: PR1PR06MB5482:
X-Microsoft-Antispam-PRVS: <PR1PR06MB5482A92AD2E05EECAE68CED3EA939@PR1PR06MB5482.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IqjF0OaR+NVVk5xOcnR3D8uGtvPaldX9BjRsoEbd/IH9Q3/Wd/hCBkjUkAAp1flH5RW83fWakjIuJ4/3T0zTMt9+508XLNC2V/SBRnE7W2NM6yEb7ddaiguhzl21chWUaRUdvMpK9sXjVs/nVg0Dm9XghRzsCmFXjqxvdERyScaJd9WHbzlhW9uQz1SIfzs7KkBRsTfOYjyrB7Sr5HVgfWqu+JRSIQ6FJhTX7Qd0AUZuj+ODFKyWxNNL+o6dOx5vZ5P08sEtp2y3RD4rdt8e1fLTDb7HmJlG8FMazTshePGeBKAZCeplWVj5jh14v4GFbhpVAFZDkM32fzqdHyW4lAzn/u7gD9oAFbEigy52kiswMto1SHfTQJhr5maUYC3Wvgqi/wHtOH/l12Ad6wacYjKI+NJjGzZ9AlQq+AEaYpZaGX2FmKnEKBvLacmhXJVhYErUCAZZbuwP/yR5iEqU36SlsIoJ6XpiFh1mLM2pvNKXmuzIxgV9fWz0sC1WJW3K6jxmFQ7pqpx+FzzZ6oNDg3zgkW4IhSBhHO2/A8tPKVoNxhOGaRue13v8Dp96r65XP9Iq+eHZ95CuHh9qkXLOWl9kRU68XsScY9f9a+Y48GassDZBtsqC73jN9n797rLNg6hmfUQVNXlKWXS+mGyRbHWFqUUy9hvHrOVT8Xt+R+jjuoXMceoRgUQT3m/wNFFXV3S6WxOp/7KMIE4D5Dl5l7FCbde/7qH6jkjmgUULPAE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR06MB7517.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2616005)(6506007)(6486002)(34206002)(66946007)(508600001)(36756003)(44832011)(7416002)(86362001)(1076003)(5660300002)(8936002)(66556008)(6636002)(45080400002)(6512007)(52116002)(38100700002)(316002)(83380400001)(966005)(66476007)(37006003)(6666004)(2906002)(186003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?spVe9wprTvI4XXHyK+pOjJpDZjdfwAP4C59pvAI/gaD8D0OJZpWRYSKsA5Qy?=
 =?us-ascii?Q?ZQSTylAJze3Z+9SkUSMZ1UzxXQbwJawDQJcDPoyzmfjDmd2WZLbSOUtd6fcj?=
 =?us-ascii?Q?oEI0ZfM/xjtKLcM64iZ9Ci6rNu2+eJf87b9WZOgZwvQcyAXprfqCgu+vPM+n?=
 =?us-ascii?Q?hlgtNotSZ0hNXvPcKrejJqUQx+T6vvUlD3DfNtGseOf0KDJ+7zk+FnhFD7BL?=
 =?us-ascii?Q?aO6v0gXTAW+zDuVhtuuJMvsGMbitwyEhMpCOc9RPibFmuPY7rftd/MB+IjOv?=
 =?us-ascii?Q?FyGI/02BKDH9zJf3cHvpFc0d74C5eMkz6SBo5OtbVUgzadI7Cg2kFDbliZ06?=
 =?us-ascii?Q?iLKrMWqQrzXgr4BcpSIctARrYS0lbT+UZwCG5OFr92jpSq/XerCK0lAmrIdi?=
 =?us-ascii?Q?2Fmhxj59U5wbpAaMmggrKtMQaNKuva+B1EX3XitT1Dio7cEwzy0+6vPifKHg?=
 =?us-ascii?Q?9iB4nXD7a41wZD+1s+BEFiuxllheF68Ey0NllDZeZ66HqZPFfVpqsY51boaW?=
 =?us-ascii?Q?1NK0MYg69VtVUcE9dMV1+Vh6jXQylUQQnf5R106gx9yVKhHpGnZdsZNnKJXr?=
 =?us-ascii?Q?23Qna/JNq7Hy5FvnqfPZMSNG5gC3+Zcx2g3zbxe50ShgG2FznK19Y3ECBLVD?=
 =?us-ascii?Q?xTHg/zZYG7E8yLK972wPZADc+xoiKBOjAUn/ZsFofPjcMbvQ/ljP+wV1vt8+?=
 =?us-ascii?Q?1pR73NsjyBnLGzoEsV+qrhZOUPRdHP1DB0Ne4+F4yOzfggDuQoRVcjCtwFwU?=
 =?us-ascii?Q?nD/IdxZmKO3Vfn/JlISThzswtg7Q/6vY0tyzrAvyKlQtLKX8LSvJEg7GHwDS?=
 =?us-ascii?Q?0FZIaSgCgs08dYMysA9qeeotqgsk3KkE83AwR7iwiEW/evJsiv5V8o6wzaEY?=
 =?us-ascii?Q?F6VYU+1ngRVUByggduQKoxhETpTXiXKUfFOzEIG0OphIgHnWnUoO/EBX7G9W?=
 =?us-ascii?Q?qTfw3ymVEmfpfmlWDJGKCzWNwh4+ZSo4GVqx2s05KR98A9uX5mGh/uXT+gnz?=
 =?us-ascii?Q?jEN5T/SJ3R1pSXsZW9bZetMqO+rIT8quNdWo7OqCY6xP+wWxASoNTx5h2mwA?=
 =?us-ascii?Q?5457HrEutppxHHzwX02MjmKjLII9+zSuCsiBOXsyJxHDnvRl8+QTLBgqcYx7?=
 =?us-ascii?Q?TMBNNrF/AJ4DBpm7j4WpzgFDfNhgX4WzUFL8fv5yO7pPIogSLOgK+X4Itmoq?=
 =?us-ascii?Q?UbEZifZJjDGqDSZ10yZ352QZ9kvpJMleGrAfhglcSb+ER6GnxERzjmS/PF1C?=
 =?us-ascii?Q?SJRaKL16CfeWvFAwgmbfocLez/hslVpsSgfkVykM5cZ7kI0e6riDqwNTMSiO?=
 =?us-ascii?Q?q9t7sf8Asr0fb80/uTv+P27mD5FLWEo6tDH3ZF8oTGS1B+2UYY1o4G+wnOu8?=
 =?us-ascii?Q?szkZgHk+JM0IDjbunAyqjwiloSa84rPMPuXEtzrqwXSSBxijFFcJUIw4+J2J?=
 =?us-ascii?Q?eGvGedcIzBhVhQTgJ6f23AKoT9AR5zye4p36rkUzKIFSA5FvZPpmPjm0LOHD?=
 =?us-ascii?Q?PhmCmhG/tOoEeEG7HLtY0dSuwgJSRc0WbZ/E8oB2rGnolONHpnGZtZ8t6gBY?=
 =?us-ascii?Q?bRp071umIuZqnZEyuuLbt37eOW+Y3HXHiWsOp8NG/8MvmBRniud4/eWvpsTU?=
 =?us-ascii?Q?2fc2mMZTb3Rm+AhxkemzA9MS+xFiHBYYUecCmmJAg1AaSaqWtAZbvRNWQ8UK?=
 =?us-ascii?Q?sqKfpCQIm03VjnzsbBRSE4F1Nj0=3D?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b4833a-6511-4a6e-e36f-08d9a45874c7
X-MS-Exchange-CrossTenant-AuthSource: PAXPR06MB7517.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2021 14:43:27.4901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tLIARKfxi1xDkP7C4BA7umVV1z1IXXS2XED+4gBJNwiGHaSkRluY4KuRfSzaxPMsIWy1eEZxnEaWkGMXHsXXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1PR06MB5482
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The registration of XDP queue information is incorrect because the
RX queue id we use is invalid. When port->id =3D=3D 0 it appears to works
as expected yet it's no longer the case when port->id !=3D 0.

When we register the XDP rx queue information (using
xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell them to use
rxq->id as the queue id. This value iscomputed as:
rxq->id =3D port->id * max_rxq_count + queue_id

where max_rxq_count depends on the device version. In the MB case,
this value is 32, meaning that rx queues on eth2 are numbered from
32 to 35 - there are four of them.

Clearly, this is not the per-port queue id that XDP is expecting:
it wants a value in the range [0..3]. It shall directly use queue_id
which is stored in rxq->logic_rxq -- so let's use that value instead.

This is consistent with the remaining part of the code in
mvpp2_rxq_init().

Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")
Signed-off-by: Louis Amas <louis.amas@eho.link>
Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
---
This is a repost of [1]. The patch itself is not changed, but the
commit message has been enhanced using part of the explaination in
order to make it clearer (hopefully) and to incorporate the
reviewed-by tag from Marcin.

v1: original patch
v2: revamped commit description (no change in the patch itself)

[1] https://lore.kernel.org/bpf/20211109103101.92382-1-louis.amas@eho.link/

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index 587def69a6f7..f0ea377341c6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2959,11 +2959,11 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
        mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);

        if (priv->percpu_pools) {
-               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rx=
q->id, 0);
+               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rx=
q->logic_rxq, 0);
                if (err < 0)
                        goto err_free_dma;

-               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq=
->id, 0);
+               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq=
->logic_rxq, 0);
                if (err < 0)
                        goto err_unregister_rxq_short;

--
2.25.1


[eho.link event] <https://www.linkedin.com/company/eho.link/>
