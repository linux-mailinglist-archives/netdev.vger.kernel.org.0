Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1204F649912
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 07:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiLLGra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 01:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiLLGr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 01:47:28 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98C5BC2A;
        Sun, 11 Dec 2022 22:47:27 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BBLmTCV009061;
        Sun, 11 Dec 2022 22:47:14 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mcrbvcr0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Dec 2022 22:47:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUoc2Tu/+vx0tSrk6qa0gCb+xYVj6w+vrCUGXSSoPAl2vmw5Oc/9FyCFI5rOPYYxakYhYLqVpsb/fWVFzJ/DesL73ROewX8nW+aVaYRxNK9JhpQiRTIQ7IUaVpfyfbtt8u1QmJDHK/x1mpEh5dJR39U81S8cjn903MpsFdKKgrN3QfuXtuBjn3RzZV3dL6oZoQBnQmsvsFrqUpvp5/ZXQ1Jbw4k9iIyNz2rzjrXDKZeHnjQ/X6lGP43Umzn+aXgtSLlytDKrQXuptAK0Axb/K6p6ROr5NQE/HkBmpcZrQaob/wfvXL74/Agm/lu7fEQALsWvq4Pp/xFwhmUewvIvJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAAjyaWKLj8XklaPBxn/1CjxhMcIrmxZaIzdS1efPVU=;
 b=jzH6IlN5Nndo+dcDeBmW7htgv+r0ZyMtGf5eSaigIEJ8mY5i9OXkGlJGKCsr4ilnNjhfhGWDLmJEYCQy0lWEXH05hQhgo0YneOwQCpCmZX6HSLnxIOd8QiSO+1oNbiST1OLpV+UyXlGRWs7A1g3bAkxBKaAG8Sm5WyUB2AetvkVgYmpg5DwjIWc9vdRQ/JR1r+n1fjm+rMDwmu1vk6qGjEokxDHDAKJiFS1TD6qb54T1PM3hu+jw9LFttm/yuwkA0hKf19qabKIqirlY0yifoiZNb+eEg8BmKOWAK2XEAvBy2sSSf+JoV0Y9EGrD/NE8TWlaa9ZVBMsF/fPWuAC+8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAAjyaWKLj8XklaPBxn/1CjxhMcIrmxZaIzdS1efPVU=;
 b=NYKiBjJ8s27bDiZgse7X1Sv4nqFQ2aprxBbNG9IEnllKlXMAVoDRA1Sf82I4W/7l18HZCkDoBzfv5iHlKbwroyC6mDHeGRHhImnKOhflwYcgGfoHyMdQe4Yb64Ja/EHAafRwGiVg3i+rI9jJtFzO4vNKp9hIxJ5oqKLZvg1sYB0=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by CO1PR18MB4796.namprd18.prod.outlook.com (2603:10b6:303:ef::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 12 Dec
 2022 06:47:12 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7acb:2734:b129:b652]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7acb:2734:b129:b652%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 06:47:12 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vamsi Krishna Attunuru <vattunuru@marvell.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] [PATCH] octeontx2-af: cn10k: mcs: Fix a resource leak in
 the probe and remove functions
Thread-Topic: [EXT] [PATCH] octeontx2-af: cn10k: mcs: Fix a resource leak in
 the probe and remove functions
Thread-Index: AQHZDL3C+qOL08Hx702nLM7QAz3h/a5p0XCW
Date:   Mon, 12 Dec 2022 06:47:12 +0000
Message-ID: <DM6PR18MB260274199FF752A2E5307C0DCDE29@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <69f153db5152a141069f990206e7389f961d41ec.1670693669.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <69f153db5152a141069f990206e7389f961d41ec.1670693669.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR18MB2602:EE_|CO1PR18MB4796:EE_
x-ms-office365-filtering-correlation-id: a2ac9cf1-cae3-41c6-0bfa-08dadc0cb29d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c0A54r4+VSI0l71AaAqOJosT26zR5yeasj00HcOtHNJ09jClNmBIOOUVn/RA2DS0YUXdd4VXhZKC5T4kCZt7dcIGmUDsMLwARBtQY05cUHAAYWCO+fz7Yl8xU9r2wVAoJz4HsX1N9yAfXiTatgB3hZmR7nl4whMBIKdV2MA22NsVbCW1kuJF4eMRe7TRnQt4BFK3mgpgk3bvcBSx/p8cH8loLaMcpEQRb8oqt9MYXUPyn5le2074BEs/BxX3zXOjRIn5N6zCjcp95OV401FYxdsaGiSflMSt/qc65BVGwMk0fH8YITL7M1OV9Nj+ECX4h5rjE2W4GZpUFUTfc9Jv8FelyYgE69fdT1VclHiUhcD39ZCeNAA3UC/DVwNISgOO9RrHu9sNCYEz6GvJ7truMXowaJAXQjmPoY8AbIkDcYM+6Ku8HaDAdU4E11glkCIj/ccPrTPsSfBirhCzBmXMmKxH2fVGdgOrXsH7yBOm1Kk9iOX7b6HNlxC/93s7xf2LkZ8Bk8onb+13g33ZrNvZH3aGTaM3iB2zCDko9DY3y36CPxaYHCtvlDTtursh4fwESSjwAcqYPEvwYPMdbPq3hCdzK3d0UjXuGqBupYOiB9bOi0TizgOdUjV7Nm3v+flS5VjSMR26dh4hs8Nq6PrA4wlGBTfJzCdLlsHoKfrIiDXTjz8Vz7n5eV/8nMJh504hFdXjZJgzDztm0Ton83ShC7PFoR1v/w4nlfl6AdNBRRs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(396003)(346002)(39840400004)(451199015)(54906003)(6636002)(316002)(2906002)(71200400001)(33656002)(110136005)(921005)(478600001)(122000001)(38100700002)(83380400001)(86362001)(55016003)(7696005)(38070700005)(186003)(9686003)(26005)(53546011)(6506007)(5660300002)(91956017)(52536014)(8936002)(41300700001)(4326008)(66446008)(66556008)(66946007)(76116006)(66476007)(64756008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?He2r+/fzeKL11x+xw1+MThRFuD7Q+Q7O+dWt3EmqysxUFEgBEHdH+pEDO/w0?=
 =?us-ascii?Q?N66jNbxjUNCaxUv99di3UJSiTYKvpsi4FipaVZ+gHksIE4FBx8/PoIU7u5YP?=
 =?us-ascii?Q?59RT8HmLgzmiue2jasr1fN+yLFLiKTrcZJ92caHXIKPpdpoDRsZCiJOGTiBg?=
 =?us-ascii?Q?97Y5c44VXTvC0/00pQk3JA46miRbRUbCHE/x1pZixk1woptiTQ02vAXmAuUR?=
 =?us-ascii?Q?REvL1iQYyL//GXyfDgOBN/R8sBTa/82pU1Jf+96pNLTSI5gkI978eWz+xL++?=
 =?us-ascii?Q?c4BWazOj84CthDaq/Rj9A5XdQOGnimjHfUCQjVG8TTij/l5UruTAgaYev5Z9?=
 =?us-ascii?Q?oCIA7JPrEru0GzIofBATl9uHz0zjmBYJ81XwUDU2nno8fi2/fIRjXJGBOsPn?=
 =?us-ascii?Q?+uYwy9F0zAL8ff6lm7P0KvI/riGMaf1YyhquMiNeRWMgWdvFfS9TojQ4gleN?=
 =?us-ascii?Q?TRwulQ/tNdCDJaj5nEbST9yyYQgerk66nzSpQWvH/0JgBI1ajHSueOScFJ4N?=
 =?us-ascii?Q?DnY0Br8ht7OaEtsZPeSpF/WRQ+y3Pmm7nASCh+/Fmt+yanXerEr+xsJosJp5?=
 =?us-ascii?Q?cDhRR0ZoTbHOvyyyIzc78Z1lWrUsPFEIbpqQauAqeMEgp7FTXTsErEay2aAS?=
 =?us-ascii?Q?70EuYEl9pdi9u3gdJiQHcSq8X7LJbQTClHHW+tjiA1/ScoKy4r8FVywgUaJs?=
 =?us-ascii?Q?bF8NT0ioewZ1QV3Z+5b/Bf/3A/BW/9/8Oy6cv74RpLjeaqw109in+4HLxVPv?=
 =?us-ascii?Q?c/hcBh9NVQoSZBhqFnhuJ8WRtPYAKLFJcNiVU86uP09gb+XTuVXh1hKihjT5?=
 =?us-ascii?Q?VIYtFUYqEByHQvCPGRcwyUyJQCvgQRJzouzHWYwmb0n7k6OpP1NjQ4Kn9oPS?=
 =?us-ascii?Q?suc3GDKElUO+5C8Lx13vkubFkTlQX3Z9JErVa0Vz8or7D1VRUgn6BKRwDH2V?=
 =?us-ascii?Q?V0HF4zdWaJ+sP7Y8N1DuQnRhNN4PpW6lpdKj1L0MJQuaNQlRaXEQwJMLtBpC?=
 =?us-ascii?Q?1F6bJ2UqqH2xAMxlDw5KFFaTSksWCWmk+IFvJofglBx1GdQbHDeSoOodyXo5?=
 =?us-ascii?Q?LTHxXzOKNKKIp/UM2dpNyXLvJbCxc1REYRMIxKUgWOcxHotg+1xCJY7usc6U?=
 =?us-ascii?Q?2Zwq5Ke2pXHROJoSpTSceNzOIhsYiOCKgxBxspKwf61PjQDy8m4N9KMRXlm5?=
 =?us-ascii?Q?p6JsnPr+7M1btTX8kgHJiSX5/wa257PEC3SVdGdUAzUfAjWegd1ce6+IYysA?=
 =?us-ascii?Q?+rrupTICqwPWilYPF6h7mjFJ494V5WgiePvu//c8W4IzVd+SvGYpY1KdSiAl?=
 =?us-ascii?Q?+fVCZv+1WVI7JayJsGiXGepUxy/PvNlzF647/lvHCJyiUB1ebF/jZkpa4UkL?=
 =?us-ascii?Q?33Zua/9ecc9uuFXgBYUqLNUurWtAzAvbYkflOSHrKDb2m0IT8B2o1AjUeqdo?=
 =?us-ascii?Q?kkO9rVL1vSE8yEur/+ywuZQxDpOSJfuEEvwU2SuM7EkeJJZNU4DiWA0QgBZ7?=
 =?us-ascii?Q?7EzEOfxJpJxzLWIssBZuIwyajJ8c9PMg2G+kNeVu/4n7v0GbEiR6yxq5LPNG?=
 =?us-ascii?Q?s6nkdxRba26OSCa4Kng=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ac9cf1-cae3-41c6-0bfa-08dadc0cb29d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2022 06:47:12.0545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0gv4DIwxk2hDk5P7V5xtXu0ZULkhXFcRsZRa6EGDu2JbfwM1gvpKMWZhUh1Vzb8ch/zxJLr/U0BC5dOIZLRuhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4796
X-Proofpoint-GUID: 5bKB811eHjDmgghy5BTbfvJJLuNTLbtZ
X-Proofpoint-ORIG-GUID: 5bKB811eHjDmgghy5BTbfvJJLuNTLbtZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_01,2022-12-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ack.
Thanks for the patch.

Geetha.

________________________________________
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Sent: Saturday, December 10, 2022 11:05 PM
To: Sunil Kovvuri Goutham; Linu Cherian; Geethasowjanya Akula; Jerin Jacob =
Kollanukkaran; Hariprasad Kelam; Subbaraya Sundeep Bhatta; David S. Miller;=
 Eric Dumazet; Jakub Kicinski; Paolo Abeni; Vamsi Krishna Attunuru
Cc: linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Christop=
he JAILLET; netdev@vger.kernel.org
Subject: [EXT] [PATCH] octeontx2-af: cn10k: mcs: Fix a resource leak in the=
 probe and remove functions

External Email

----------------------------------------------------------------------
In mcs_register_interrupts(), a call to request_irq() is not balanced by a
corresponding free_irq(), neither in the error handling path, nor in the
remove function.

Add the missing calls.

Fixes: 6c635f78c474 ("octeontx2-af: cn10k: mcs: Handle MCS block interrupts=
")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is untested and speculative.
I'm always reluctant to send patches around irq management, because it is
sometimes tricky.
Review with care!

Maybe introducing a mcs_unregister_interrupts() function would be cleaner
and more future proof.
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/=
ethernet/marvell/octeontx2/af/mcs.c
index c0bedf402da9..f68a6a0e3aa4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -1184,10 +1184,13 @@ static int mcs_register_interrupts(struct mcs *mcs)
        mcs->tx_sa_active =3D alloc_mem(mcs, mcs->hw->sc_entries);
        if (!mcs->tx_sa_active) {
                ret =3D -ENOMEM;
-               goto exit;
+               goto free_irq;
        }

        return ret;
+
+free_irq:
+       free_irq(pci_irq_vector(mcs->pdev, MCS_INT_VEC_IP), mcs);
 exit:
        pci_free_irq_vectors(mcs->pdev);
        mcs->num_vec =3D 0;
@@ -1589,6 +1592,7 @@ static void mcs_remove(struct pci_dev *pdev)

        /* Set MCS to external bypass */
        mcs_set_external_bypass(mcs, true);
+       free_irq(pci_irq_vector(pdev, MCS_INT_VEC_IP), mcs);
        pci_free_irq_vectors(pdev);
        pci_release_regions(pdev);
        pci_disable_device(pdev);
--
2.34.1

