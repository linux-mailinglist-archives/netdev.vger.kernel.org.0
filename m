Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF1F44AB86
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 11:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245353AbhKIKeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 05:34:15 -0500
Received: from mail-db8eur05on2093.outbound.protection.outlook.com ([40.107.20.93]:21441
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245347AbhKIKeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 05:34:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hRRU4aXMF44nL/AhcNTjjoYd17RRks5uxf41BYezt4PsPmeOZVA/ut1/pcyOa5K+BEQhpuu3zDbjF9jQVTzEYLq2J4K6Bdbyss1TvVNHWWKi5Gb/xmBZIN6DEmBMW5S4mFgoOPN6emFFf+jfT+mEszAyKnzns0co59XI8NOhsEzRCxkuNTtOLpvLhTotl2XW6C9LbSfauzDC6HzkSK62eXyoRkXuBjN3vqDsnNqkNufl85vAqOVUF9GARPnzuHeZI60FvzMV9lh66FYgywMOCemZhk8eXKBnLj/Ckbv2oWDom/Q+iBRbQC+3t6BmXyzpmylc+mhk3wPGZoHWbFnU2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muwU5Ab53jdkRahd2AT/NSycEQBmewI7F9kt1A9r2ps=;
 b=i7mQbxaNLI68qqNpRKPuYnzdtHUW9XBFomjznpLptx38EZYujKVlp3dw71ogFTgaPQ94Zv7Vw65SLSIXWwuf6b+scKAgQs2kFrGUr+Ryeznlz9A5+82OPcCTxfm0LI9s6Xpg7zcXgU1LqANhzcL6xj2O6rqplQjPbrZWi+KceC2+TH85y0p4PCToqM18C4SD1Q5jbaKCnPJJ7fBOtK6QJE9qI+FoBS1FLXrA/QxWC8UipsTgg5e5xjKYt2uj2iIwQOFhgXWtYJHXf12yHKXLttICgmMLsyIx74tGV4E0+vzHo197NYfPGU94OiEPQa6okETjjQL/jPCXEhQSo5GFLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muwU5Ab53jdkRahd2AT/NSycEQBmewI7F9kt1A9r2ps=;
 b=YcIx/A/wYdhacITbeJhgf33PiTppfTddEsKut79gY9sqpCPbJBm94L3dlpK5OR3k0v1mXyFQMUfpTsMxCdlzcCGqfMKJ0p8O0x8+8tGSe3xZE8sXsgfiHOJxqF2aPeBuI5BlPFaDycOeQUH0gli7Q3TPaHtE9f2jmKqJm8qbu4Mt6pzQhdBymBkT8mlf7E+JcvCiqH54CFPyO5AMf/yNmRk4cdS6Oe5HmfZ8FUGSltl0Lf45Q1btTD7Lwl8VNpO1jj8K6DB46r4pN2eqrNKl6JLNFw8QrnnyfGJDM/4MS5/zagYA6c8GYATPwvRyywYY75ywz1uJ9zPFreVEyahp1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com (2603:10a6:102:12e::18)
 by PR3PR06MB6683.eurprd06.prod.outlook.com (2603:10a6:102:6b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 10:31:21 +0000
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::89b8:d738:4829:5a15]) by PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::89b8:d738:4829:5a15%8]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 10:31:21 +0000
From:   Louis Amas <louis.amas@eho.link>
To:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Louis Amas <louis.amas@eho.link>,
        Emmanuel Deloget <emmanuel.deloget@eho.link>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] net: mvpp2: fix XDP rx queues registering
Date:   Tue,  9 Nov 2021 11:31:00 +0100
Message-Id: <20211109103101.92382-1-louis.amas@eho.link>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: PR1PR01CA0033.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::46) To PAXPR06MB7517.eurprd06.prod.outlook.com
 (2603:10a6:102:12e::18)
MIME-Version: 1.0
Received: from las.edt.fr.ehocorp.admin (2a10:d780:2:103:e360:3559:c48d:bc79) by PR1PR01CA0033.eurprd01.prod.exchangelabs.com (2603:10a6:102::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13 via Frontend Transport; Tue, 9 Nov 2021 10:31:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 784ca284-34a9-45f7-3bde-08d9a36c125a
X-MS-TrafficTypeDiagnostic: PR3PR06MB6683:
X-Microsoft-Antispam-PRVS: <PR3PR06MB66832129ADEF9A6AD38955EEEA929@PR3PR06MB6683.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vxuuE2FtkZlOAGG13qpdgY6WhdsERSO93lEwVpylUfRGjAION2jlyNCnXkeWTTS5tV0Vw12WSx7/9JcKTqlxehUP1Atek85EM3fPpIA4ymryiPJCpR7wapIGdVIlkg+DvQH6XeDpwX7O8OftkoSUnZda+ZZ9Un401jWurT8r40FP15HqIVn4i2gImvrPjsCXpSuPJs0sV3f1sXm6WlZTKIhyyVpATmGNp9nPw62zW8Y1hb+UtENKtinp/5mwcpsMmqTiIQazS3MMh1tev9dVGjVdnkKFtm8nKzrMyU43G0fUuqyxFVAG88mxNrxMmWo8hbaKT46+tju6iGFQnylT+wrNYtaiQG7b+CI3iDjjxjzVKDvtlsJrzKO6MsD2w4+Nsc0L/wmmt5DroIlstxug3Jjko1Tj1BOOzdEFCUUm8E2SEn0IkZLmHGIm7IZNywiVqjZCQsOeMbGq+rxDhsd516g3WLoplFv4ci79DHlaBHbTFkXMBiSOLCUAmE3U1BKZBz9YQyblFvAiu+iiftluAZVhtu44t4q3mSq/3T9OJAWUAp0WuaKPj31HMCVEjAhzCpB/os5c4YwvNqbozAqUy5Az8qSsyhQqTozJ3B6acjUB90lktKwsQKenH4i3dBZTz+CJzija3933OUc8DmHoer4w+9LbdvORqmviO5i0ylBSYxCc0HUKWMtqR5DPGRsI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR06MB7517.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39830400003)(136003)(376002)(396003)(366004)(6666004)(7416002)(45080400002)(2906002)(52116002)(110136005)(316002)(6506007)(5660300002)(36756003)(186003)(54906003)(921005)(83380400001)(4326008)(66556008)(2616005)(66946007)(508600001)(86362001)(6512007)(1076003)(8936002)(8676002)(66476007)(6486002)(44832011)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mH/WT3uSBbx+2oENSib8M5fha4+SlphkNfB/vkhVbTHhTUsO0JtPxjWvQvf8?=
 =?us-ascii?Q?IOTnJD4GnXHg0/f38htKlwwXg7VIb8gVjWsHvqefTb2BoQxgcP9f70GDYhtI?=
 =?us-ascii?Q?CXOzxV4VFaeyrGymr93o6PGyUTMVkBsNlyyT584P1se8BcP8DQ/kjU7OJtXe?=
 =?us-ascii?Q?OxwVtcEwqyOJ3g40lU4P9Evu7o+X7ASOUHMlqhnktrwVvqVc0lpf+OXb9lcD?=
 =?us-ascii?Q?VxQ78OdsC+/21oSQ85f2MirGBAI1D17XQ2TryrmAuvXNSpFdXAEIhdUek8WE?=
 =?us-ascii?Q?1UlrLHXMFoMgS3uHSZKpKnjQZsGfLGkRrk8+GC4xQ1ifOvGvLCM/uU3l5Rr8?=
 =?us-ascii?Q?e/1ml7NFs2UHnaumbxSk09vaihJN3J6qeaFXKf6eFmjlIFTJMIaZBQ9+jecQ?=
 =?us-ascii?Q?LJXG9mHL9ny3k0hT9zOJLoPxEr6M2KSDvzCEDpNI7c2I2/VZqHzAGKmdMYO5?=
 =?us-ascii?Q?ZcuXJXG/nMxXO5nKKdy+nYMGVt125G7Bos0F68fwj8GEf9lg8CvkLi2ndv7P?=
 =?us-ascii?Q?suFS06Q3nCSxr0QqwMric9H3LCbwMvuY5/jx2yDL19DdS/8thmrmrcsxxUf8?=
 =?us-ascii?Q?0s4r5lnHowkjTcx7y3zHuzMqyjI+r+9fcWdK1mUcMX4verTn6xeJETNvmWIn?=
 =?us-ascii?Q?ArkD+hggnEuLcWhOAIrwAu7VKYEFLhrzTfprLFoZlEf8JQ41ISAN57ih7n2t?=
 =?us-ascii?Q?T5EVJ39yyvcux50m6RZ61H3huJslJSqvN0v0AJbHTZYiKmZUC1RVHLyV3ISm?=
 =?us-ascii?Q?/d0ca7qslkeXIA+9FwUgh5Q3ayYS9JWWrvfQ1Muq/QdmIjGPrHIsKxkpqR0O?=
 =?us-ascii?Q?dszpzw46wMlwLFXzTeIq8OxQ8j7iM6frfU9MdC7Y8TnB31AxwAuaXvF9qU76?=
 =?us-ascii?Q?DnvlhRQlHaY7oRn5W5DB9hp+QoBRXSTL6n/gs7BYqnKZM+RFHmdhs1GfuTfC?=
 =?us-ascii?Q?v0bOcKsstyUtS/X9u0ftUELEZkvRFcyNsrLxPx4ahNSEfoLTz0LYp0PLiHYZ?=
 =?us-ascii?Q?8Uzb4TtSHWTFP3FD41gPG6hSNSGIpG+NmqipGcXteI2GxGY86fmGck1H9GF/?=
 =?us-ascii?Q?D/a4hs9NldeuGPUZ1nMr8eLr0d3Dfyh6y69xrT0n2biR8zEhe+jEY4qdKGAT?=
 =?us-ascii?Q?E+3XnnEx5w5+wG1AwOvkKXeZkVoUybvfrwVfuD3i0Tyl5BS+fqnb0RvrS74N?=
 =?us-ascii?Q?T2UpUlHsSJfIeoDloTII+ue0dw4zKoEnd/V52A/gq7xMXjAmnUbOqn21vQLt?=
 =?us-ascii?Q?UQRjJbZrTGn5hlK9o5/NaNmq6dhX/XaaB2WEm6KPmOnhyOFhhckNNgsCzXkV?=
 =?us-ascii?Q?vM3a96b5nnpg30HEApI2DAdnrkBjyDXkvENJPy9Nhjvb4tTWGv5qEDWDlQgl?=
 =?us-ascii?Q?Ub3X43I7Qcn4Otx5FT6fEcnU5FV0X1q5lm5/gs1bhV6PxBRv87KWa1Zozv5S?=
 =?us-ascii?Q?V9SIRr3dqhSEyQwcKBTbUlukF1kVrnFk/w54dLPl0l0fEfnNpVQ6NV4Xj8o+?=
 =?us-ascii?Q?7AMWBcqGu3cgBM1I3a1lwo6NV6nZVz5fiPkb8f137Oo34XcYqj/5kiw8OzVC?=
 =?us-ascii?Q?kYwbiNYWvZL61XAs+0TWgyr9t9iNlocf9hPUPawJsTKwgd9Kt8Q/SVBZl7Q/?=
 =?us-ascii?Q?K0zjF4bvvG5/rEI4zA5KIv1kI2NrwBakbTSxo1SrMX7NDwJShdNltdXrrFxB?=
 =?us-ascii?Q?wD0E7O7q9Kp0WDwIOzyIUJNS5Ns=3D?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: 784ca284-34a9-45f7-3bde-08d9a36c125a
X-MS-Exchange-CrossTenant-AuthSource: PAXPR06MB7517.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 10:31:21.0290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WASN3yKf3aR0Dfl9JTPGag0DoXDgKF91k2vM/u2fhYaWVT+4U66ER/bdF1jfnaRDCn1PO8HKL/8M+WnPfyTzyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR06MB6683
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The registration of XDP queue information is incorrect because the RX queue=
 id we use is invalid.
When port->id =3D=3D 0 it appears to works as expected yet it's no longer t=
he case when port->id !=3D 0.

This is due to the fact that the value we use (rxq->id) is not the per-port=
 queue index which
XDP expects -- it's a global index which should not be used in this case. I=
nstead we shall use
rxq->logic_rxq which is the correct, per-port value.

Signed-off-by: Louis Amas <louis.amas@eho.link>
Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
---

As we were trying to capture packets using XDP on our mv8040-powered
MacchiatoBin, we experienced an issue related to rx queue numbering.

Before I get to the problem itself, a bit of setup:

* the Macchiato has several ports, all of them handled using the mvpp2
  ethernet driver. We are able to reproduce our issue on any device whose
  port->id !=3D 0 (we used eth2 for our tests). When port->id =3D=3D 0 (for
  example on eth0) everything works as expected ;

* we use xdp-tutorial for our tests ; more specifically, we used the
  advanced03-AF_XDP tutorial as it provides a simple testbed. We modified
  the kernel to simplify it:

        SEC("xdp_sock")
        int xdp_sock_prog(struct xdp_md *ctx)
        {
                int index =3D ctx->rx_queue_index;

                /* A set entry here means that the correspnding queue_id
                 * has an active AF_XDP socket bound to it. */
                if (bpf_map_lookup_elem(&xsks_map, &index))
                        return bpf_redirect_map(&xsks_map, index, 0);

                return XDP_PASS;
        }

* we tested kernel 5.10 (out target) and 5.15 (for reference) ; both kernel=
s
  exhibits the same symptoms ; I expect kernel 5.9 (the first linux kernel
  with XDP support in the mvpp2 driver) to exhibit the same problem.

The normal invocation of this program would be:

        ./af_xdp_user -d ETHDEV

We should then capture packets on this interface. When ETHDEV is eth0
(port->id =3D=3D 0) everything works as expcted ; when using ETHDEV =3D=3D =
eth2
we fail to capture anything.

We investigated the issue and found that XDP rx queues (setup as
struct xdp_rxq_info by the mvpp2 driver) for this device were wrong. XDP
expected them to be numbered in [0..3] but we found numbers in [32..35].

The reason for this lies in mvpp2_main.c at lines 2962 and 2966 which are
of the form (symbolic notation, close to actual code, function
mvpp2_rxq_init()):

        err =3D xdp_rxq_info_reg(&rxq->some_xdp_rxqinfo, port->dev, rxq->id=
, 0);

The rxq->id value we pass to this function is incorrect - it's a virtual qu=
eue
id which is computed as (symbolic notation, not actual code):

        rxq->id =3D port->id * max_rxq_count + queue_id

In our case, max_rxq_count =3D=3D 32 and port->id =3D=3D 1 for eth2, meanin=
g our
rxq->id are in the range [32..35] (for 4 queues).

We tried to force the rx queue id on the XDP side by using:

        ./af_xdp_user -d eth2 -Q 32

But that failed -- as expected, because we should not have more than 4
rx queues.

The computing of rxq->id is valid, but the use of rxq->id in this context i=
s
not. What we really want here is the rx queue id for this port, and this va=
lue
is stored in rxq->logic_rxq -- as hinted by the code in mvpp2_rxq_init().
Replacing rxq->id by this value in the two xdp_rxq_info_reg() calls fixed t=
he
issue and allowed us to use XDP on all the Macchiato ethernet ports.

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
