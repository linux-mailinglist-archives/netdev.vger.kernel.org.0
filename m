Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B7646A2AE
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238935AbhLFR0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:26:04 -0500
Received: from mail-eopbgr130117.outbound.protection.outlook.com ([40.107.13.117]:24367
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238294AbhLFR0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 12:26:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ntj91q+TxmJGrCWgm6aqNDJJwz4N8uqpzdPvi4GsxCr/8RJV9qwVt6UeCbLtjgbF/zPDi6CqT/vHWHvn0OMmS+rF3h/iEp3dX0eAbkStDDOVwtuxpnCgXFbjiblxjd1T+HVb/jb7NHW5EQP1aI1UzM5jM04b4hQPH0jMe8Lfh6TkGwAlQfoi3u64HD1bTWA5DuFoiD3cGqEt7gjXYebG3boykmgCYVsCR00ueTn/FVRBuUuEEziemV1KVIgqH2CtcFHwjinea8PFWO5w/N10M4EUT419cn8c7NqSNr7qXXr8H8HqFROJ4Rke+e6Kyg7UeoOpEbWF9z8BmtJUFTQJFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tvy5ya+0/qh57QkiTXQ/vlor1V0Rod6uawrlaEqvZmc=;
 b=SxKYm4ZXFGXmGmvUeV0j+odcSByCZf116gowGAkbZmugzq3t3ZTm/lgOLbd+HNgWgrJGGnmMiaSp2m/3qGD3/eGjAfGVREuLYPo8JXxfgLerL6V8TAWG7GjmN0ENam7TneAHxUxqZD/z83cviy/MQEy0sK1D08xmQNOTz8gEv3yj1BR3TEvihUtk37YSct4PsC2r6NUcWvyKhwC2ghHNk8iacDsk2ujrEfvXYMPrGQGvszn8IGUP+E82ImK5sNsd3KhEnw6kszCY7AZD5Z0HQoGAMt9W/a+br5saoyCP0v//7eE4UPsxHJcDt8xIfx8Caj7cQQL/knc3OmeVJlA8Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tvy5ya+0/qh57QkiTXQ/vlor1V0Rod6uawrlaEqvZmc=;
 b=JEikerAxbSPbQwKm+qruz/nahf1zmqPjUqnorB122BAKSzjSjLbg2Kmj1U5zYXLkTh8g21ADbtSTdL9ioblL3cL7By02DSC3qgeFhl89UBSG05ylSl3H/o5XYrAjzVwnYSBKHhwyPBNQr/flYEit6quJed7BYSUjsicRi07rFhGC3uOUwAYbeg7cW62iKArVJSXufePH4Z8+65BPs9a5GD3m9ykbBSXvVkPzksg9/77OwtjfaD+fQeOA9jfAliVH5aieZbJigIBk6Xjig485pzC3vacrZP0TKkcGsnmJllj1IYQqKRbPNBBnp2J4CAGm023I6ZRIsfP2nZKTyHf9dg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com (2603:10a6:102:12e::18)
 by PR3PR06MB6665.eurprd06.prod.outlook.com (2603:10a6:102:62::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 6 Dec
 2021 17:22:30 +0000
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::42c:a94b:d533:ca15]) by PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::42c:a94b:d533:ca15%2]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 17:22:30 +0000
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
        KP Singh <kpsingh@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>
Cc:     Louis Amas <louis.amas@eho.link>,
        Emmanuel Deloget <emmanuel.deloget@eho.link>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v3 net 1/1] net: mvpp2: fix XDP rx queues registering
Date:   Mon,  6 Dec 2021 18:22:19 +0100
Message-Id: <20211206172220.602024-1-louis.amas@eho.link>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: MRXP264CA0043.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::31) To PAXPR06MB7517.eurprd06.prod.outlook.com
 (2603:10a6:102:12e::18)
MIME-Version: 1.0
Received: from las.edt.fr.ehocorp.admin (185.233.32.222) by MRXP264CA0043.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:14::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend Transport; Mon, 6 Dec 2021 17:22:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db08084a-9fb7-40ed-69fc-08d9b8dcfba5
X-MS-TrafficTypeDiagnostic: PR3PR06MB6665:EE_
X-Microsoft-Antispam-PRVS: <PR3PR06MB66652589F64B3653D6C60588EA6D9@PR3PR06MB6665.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ihd3BkoFaD2YnnlrVkQdf2quxJW9yfPA4aumWaDBRrpBr+3rcJB7umm/5rrtIwoGub9rpkbMNjW6wLv0bTlOZTP8k/xOc/TIdZp7Qd202V3VMwk2P9KKdjh1WswarUNpHuH7oMCl/SD9dUWYWGhnh0BPDBFB1h4a/rudQzR4Rpd08WkwXiedmTEEmSq7JeSLqZsd6Rn86I1agcX6dyz+evOPsus4QnYDA09eskfTYYDhx/PB+d9MvmM4eSC+HWHAAljyzb5PTl9vh5c7TRwrWPD34aL/u/oeximoXyM6xutETxcxMuF+/agTcGnwA85HctckIN7muFsr6R7kzl+yx3j6THlaxXFYnrkrMwvhQ9Yfh84mnFXPR1NO4fqLoRLuve2jfODys6AUo8f9pLkGH8+m/C6Y/GEKI3sVpJjQq7/a4WKeFQGjmY7mMPhXX7AwOM43wZtngaZ5b3y2+c/oxoQgFqAjR2rIEqD46wLQrsYOFogAEypJZyb2fm1tIqDhrOxmSjE9oezcGTb5HaA5ZJf1SeVgA/lFQHcV6JExNEB9/yaeu3U0QL3uXDX2/8Jw56/3Qb6uRTwFo8KHDKKKY4/w6VsQV6sfIeE9fVjxTpI68cfgaOjHjZ60d/qYYggnVJZpCvuMj4quGyVa7Gb4bH4hhTCdFk6dEsBSVpc+WHSxXPY/xZ57qVFZrvsd2cYMiyAOqBfWjZ2db5ODMyjwFuV2frY21yBnKmpIzYSyIl3p2u8F3l2cHea3pSx+wq1TgnmI0roIq0WanAy3Rxoz93IS3WxLf7QuVqN78FEK2m8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR06MB7517.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(346002)(366004)(376002)(39830400003)(6486002)(110136005)(6666004)(8676002)(66476007)(38350700002)(966005)(2616005)(83380400001)(8936002)(54906003)(66556008)(956004)(38100700002)(2906002)(316002)(4326008)(66946007)(921005)(5660300002)(36756003)(7416002)(26005)(6506007)(86362001)(6512007)(52116002)(186003)(1076003)(508600001)(45080400002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VvOOawuTcIzi93Q06fjiYYThubnyPYTbuOioaHCF1xEuunMNia91avN0yvYJ?=
 =?us-ascii?Q?tEvI5EKZK/nV3xBUwOlLhGo9uzd0ETYNbt4n+1xcMIN547r8sLMI+Hg3+pWS?=
 =?us-ascii?Q?DDA3pPBvws7fpf+2o2tHun70JiK1QDkOVuRWxJ724TiaqzO47TnrqC1npTna?=
 =?us-ascii?Q?5zMZdjdcy46pFIiN0Zl8F9WhG0nPZjgsxOu+Q3BMoPEO0GM0ELRLLIwjr0p8?=
 =?us-ascii?Q?IcAZ1/PSjmQ6XXUMq3Msoi/vUEJzr53aMV/ujQxUd7RjjpJ8Bx9RJfSnwMOI?=
 =?us-ascii?Q?gmKnzmMDp0q/J/cfNVvM3+8wRZxk/qEfwevtJ8yzxPvd4NgUfw6TzGvPiK5k?=
 =?us-ascii?Q?FraKx4RRSTjwRS7ohoC4QFxJyn4J1pmEvf0kNlZ9hIXJBPCSpm1/Aqj66Ea4?=
 =?us-ascii?Q?kVA97lsWMfOfVKByFWxYF4icctTTWO+KnUQOjzqBasWNWuY9H5LQMDqbWmeI?=
 =?us-ascii?Q?JEF/LlbfYPdNuC4ay2xgYnYBkasQrDMiPX5R/+MH5Gcv+MnNzdnPJRuLwvvd?=
 =?us-ascii?Q?bjEhx6NSsOd3qmarGXt+HRjRLHCrqsJCXOXewMOnDERoGBM//wTmJu+wXTaC?=
 =?us-ascii?Q?U6V6J1fXb3kXtDWYBbnGbZlTThPhgbc4STL4oE4Numc3gQMh0l+mTzt2qmzO?=
 =?us-ascii?Q?wZwxMI0RsD+Bs+HxSuaPAjULQspsj8j44qvxxo3nsKIW9RC2hd79UVriVZjE?=
 =?us-ascii?Q?/T5tqkRCOrFrw47QEUqFMHJtD7y00u51Nfq7UiW0SqW7qMdYVn8jV0MDRW3J?=
 =?us-ascii?Q?TQxR48RwCfP9NiwreygrBUZgjfZP7Ird7E0g4BNMAIMy7nGqR17S22eSf4KB?=
 =?us-ascii?Q?xkikFYtocHNNBZ3Htu/eQg7Q8WIremVpj1x3K9I/5e7BZQDZlmnkIFp5xVfE?=
 =?us-ascii?Q?zbbNeVjDJ0qqnfzQUnuuotxTyeo5avDctseRYwE/EMEodN6B8/2V5Xbl6axK?=
 =?us-ascii?Q?pRgQ7sBoSc0NVH2jnSJEoM3j/0R3QRuaDQyF3GbacR/KQTFZsyr/f0PCInzg?=
 =?us-ascii?Q?z/4HBRUWXd/Ehvu/JSktxoO/vwdPqbYJhdX7uAMmGmUibCyX596VM35tsl+g?=
 =?us-ascii?Q?ZXWjBZfOaYd2PHmIloCsZNdmBRRqpqkS1QFpWPtp+yZ1iFfxvCsfxnQU092V?=
 =?us-ascii?Q?RTIPYrP8zYEvP2oFZcwKdRCribepTpZ0+XdAB7e2Rj6LqMVJxHBXTaN2Fr6V?=
 =?us-ascii?Q?Y4ktPVm6n+cutJxlxNJlmaljCdmFSUlqdZt+dIoxUODry0HKH4JRs4wwnmo4?=
 =?us-ascii?Q?vffZct9/0AEObotiT02Aimeh9Qp+zdE9XOlGrEBo5H3Lk2GktmD6NFN/PQyS?=
 =?us-ascii?Q?+lFezONcoejEMLlVpztwF+JUY9wfYJHI+4gRAWYl++Uqx0CZC70lECIqnzwf?=
 =?us-ascii?Q?tBidabciLUouQPF67lLbOnm49ZLBzM5JokwExQOUxNZWTSEX5SdLj2Mi+Wl0?=
 =?us-ascii?Q?rokMZzrzanL5G26z69X4e4Ftj7eTiXydf/l+PEU5PPmeUotbVUd0Oyqe2j7X?=
 =?us-ascii?Q?qlhWil90+jPJlIhI+k+Uytl41kIO1TqSZQZ2IdqHh3A/H10jINqijOm/ceSe?=
 =?us-ascii?Q?tImr0GCt8IkyzDwj3H2X6ZsmlXyWjYfjOMZPw3F0P4gTTLRkwahjP/rbVgf6?=
 =?us-ascii?Q?0t030IhbrIKzkd2BmhZRnwE=3D?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: db08084a-9fb7-40ed-69fc-08d9b8dcfba5
X-MS-Exchange-CrossTenant-AuthSource: PAXPR06MB7517.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 17:22:30.5287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DadDwvAMgNB8BwjBsHD9NjcUn/4akgHMZA4Z30qqW1olXrv5Ru3dA7cGJH2geYzDCMtDB4FwlVbuLwY3mjrHMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR06MB6665
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The registration of XDP queue information is incorrect because the
RX queue id we use is invalid. When port->id =3D=3D 0 it appears to works
as expected yet it's no longer the case when port->id !=3D 0.

The problem arised while using a recent kernel version on the
MACCHIATOBin. This board has several ports:
 * eth0 and eth1 are 10Gbps interfaces ; both ports has port->id =3D=3D 0;
 * eth2 is a 1Gbps interface with port->id !=3D 0.

Code from xdp-tutorial (more specifically advanced03-AF_XDP) was used
to test packet capture and injection on all these interfaces. The XDP
kernel was simplified to:

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

Starting the program using:

        ./af_xdp_user -d DEV

Gives the following result:

 * eth0 : ok
 * eth1 : ok
 * eth2 : no capture, no injection

Investigating the issue shows that XDP rx queues for eth2 are wrong:
XDP expects their id to be in the range [0..3] but we found them to be
in the range [32..35].

Trying to force rx queue ids using:

        ./af_xdp_user -d eth2 -Q 32

fails as expected (we shall not have more than 4 queues).

When we register the XDP rx queue information (using
xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell it to use
rxq->id as the queue id. This value is computed as:

        rxq->id =3D port->id * max_rxq_count + queue_id

where max_rxq_count depends on the device version. In the MACCHIATOBin
case, this value is 32, meaning that rx queues on eth2 are numbered
from 32 to 35 - there are four of them.

Clearly, this is not the per-port queue id that XDP is expecting:
it wants a value in the range [0..3]. It shall directly use queue_id
which is stored in rxq->logic_rxq -- so let's use that value instead.

rxq->id is left untouched ; its value is indeed valid but it should
not be used in this context.

This is consistent with the remaining part of the code in
mvpp2_rxq_init().

With this change, packet capture is working as expected on all the
MACCHIATOBin ports.

Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")
Signed-off-by: Louis Amas <louis.amas@eho.link>
Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
---

Patch history:
v1 : original submission [1]
v2 : commit message rework (no change in the patch) [2]
v3 : (this version) commit message rework (no change in the patch) + added =
Acked-by

[1] https://lore.kernel.org/bpf/20211109103101.92382-1-louis.amas@eho.link/
[2] https://lore.kernel.org/bpf/20211110144104.241589-1-louis.amas@eho.link=
/

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index 6480696c979b..6da8a595026b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2960,11 +2960,11 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
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
