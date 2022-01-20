Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34461494AC8
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 10:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359591AbiATJcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 04:32:02 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.7]:38314 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229687AbiATJcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 04:32:01 -0500
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jan 2022 04:32:01 EST
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 50CE416090C
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:23:11 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-he1eur02lp2059.outbound.protection.outlook.com [104.47.5.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 112709C0093;
        Thu, 20 Jan 2022 09:23:08 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBJOwRoazizlLKDu8gvRG8LKxEMe0z00hdPIaFVHa/5NierFrdexda5ybZDV3DCz9BQu1LSDPLW64LwQXcjHkvg9ewuepApREOuYrLkAOZfmAU2wLYSCRny3y3wxu67j5vX/AYJeM3CTK7ecKnlcOWhmaI42QUKE9kzGja6c+TOmUPeCtxYAjFKvwIwhvFhxPfaSJJwcZ+IfaFcEQa6uXrXZQFa5LObchQ1nty9RbW+9XlNW2NiSAehPyhRqlzuosfacALTVPzm3ftBNPVBji2GnjkHh/wcrfwsrjwkR3A05LiYoy/PM/PR2N0R/zKwDRWx1QGd4FLt2Lvup5vWlbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFeb3rwnkYtDh2rjueASmSf3JoD0qgG+dseMNJduWRw=;
 b=YbhpDwUb2viGEqSt17j0/Plner+jCqTajxCL3FvAVIcGKbKlFwtDf6Cw59S2t2PBuPZID7Bqf79L587XmmtHgIxNNF0FLQlfM52wp7H6sl3H0VrsAhsAgBd++5IgH7xYJoztZ1en0KNLY7V63EiAAgNzOqJceMKBUpqNk/P37fRHs1S1DqhxlLNy/fba4kv7LS8ssqTCPt1NRiI6ueic4sKN9mGQSAbns2hEuKcWh8HsVuPjdIa2jykKMqfKRetaLabInfiQq8ev/1ixaIQQQdqQ62583++CHW3yU7iBXExm5Jlh04LGXYtmkHOi8f4iL2pSLSPyK5x/5MD4gpBZVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ellipsbv.onmicrosoft.com; s=selector2-ellipsbv-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFeb3rwnkYtDh2rjueASmSf3JoD0qgG+dseMNJduWRw=;
 b=qyi1Xkgzso+A5dYAby4DOJoZY7Xg4mUzfjym6n6loCy8nRHm91xmgJmtg6k2kIZeSJBsCYP9x6NG8r49zs1TM+IQ6u+eprGVHFe8b8WwAmdAFzOc8bcyGeGnjk6LNGdnaAMPovaizL/RHyGL747QLb3XPPu524UCNAJnyB3AU/M=
Received: from VI1PR02MB4142.eurprd02.prod.outlook.com (2603:10a6:803:85::27)
 by VI1PR0201MB2094.eurprd02.prod.outlook.com (2603:10a6:800:24::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Thu, 20 Jan
 2022 09:23:06 +0000
Received: from VI1PR02MB4142.eurprd02.prod.outlook.com
 ([fe80::e5ff:3f5d:5021:235]) by VI1PR02MB4142.eurprd02.prod.outlook.com
 ([fe80::e5ff:3f5d:5021:235%6]) with mapi id 15.20.4888.014; Thu, 20 Jan 2022
 09:23:06 +0000
From:   "Maurice Baijens (Ellips B.V.)" <maurice.baijens@ellips.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: ixgbe driver link down causes 100% load in ksoftirqd/x
Thread-Topic: ixgbe driver link down causes 100% load in ksoftirqd/x
Thread-Index: AdgN3k7I7vjd3hpWRMu+eZtY4Feu8g==
Date:   Thu, 20 Jan 2022 09:23:06 +0000
Message-ID: <VI1PR02MB4142A638EC38107B262DB32F885A9@VI1PR02MB4142.eurprd02.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ellips.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 160a9ef0-2e9d-451b-2b5c-08d9dbf677a1
x-ms-traffictypediagnostic: VI1PR0201MB2094:EE_
x-microsoft-antispam-prvs: <VI1PR0201MB2094A62F151D7386B4FA6851885A9@VI1PR0201MB2094.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BvISTqIWNTOXFm9EUpnRBguPh2EzbaF9nISQWDgkNOFEBx0JkMaPxWS7iyG/rbliYGBlKXQ+966mQa954Epng5/jo5Yiwx43+zZEawsbMdIkyrQyBD3BrZYpEw5K4AtccU2aVJ/ZOQYMsICjRzRaZzqcCGdvqodB8h/1X9C80+6dMT78w7qsLevX9b69G2jmv7ab6b9n0zw0iBvK0vORxQRwCEVRcdPZSac0E2gWV0nmTro0ZlLGNQap87YojASw5sEKncakN/yqvbjbMFESHrrrdK0rtXzQSVEKZZI6Vq69WtYcnVSLvys8sBwntj315BVB5rumA4bn2+k0oQ3CfT+W1vp90e0HFUS6w3nNG1TVO59Rd3Lr03v4vi2BdWstiM1QH/ZCi2Xt96NyqGO/JFTa+Y3knMKq9MBWLmTAkUPjC+OPJt8urTUylVuTuLAjS2cq0ZfqLZLe4rJdYtVgMcqDl95I1/b5gJ2eiuTnNN6eGDLcrnihQrEMuXqML5NhroCT8ht8d/6bkjZ6yB0EEONvEEA5OnC+V9XPOhgvNh9UpMMF9gF1kJkFQYtaVTfB+Auw7GLsJgzUTOq5doB+JB3L4Bo/AZ9GeyoymI8zC2u7CQY+yAup3gu9/pHfDWcUrLm7h5qCDK4smG9y/T7I/bFQ7j2zorPyUS4bIFGX/WBvNS6EO4CDPMaqe5WfHCIjq37hb1CikOAXjFqYqz5Xhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR02MB4142.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(136003)(396003)(346002)(376002)(7696005)(71200400001)(9686003)(38100700002)(8676002)(38070700005)(508600001)(4326008)(26005)(55016003)(2906002)(8936002)(52536014)(122000001)(6506007)(76116006)(33656002)(6916009)(66476007)(66446008)(66556008)(64756008)(66946007)(86362001)(186003)(5660300002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C390faV7mL9WmK89QbupNHrtV4DEr02apBfoWCqDIjHr63wBmKpeel1/SzUr?=
 =?us-ascii?Q?EIXbv3R1qXP+kZUcFNtcaFfibF9XX+oMcaux5Lfj+5K9qWepac17e4YNbYFN?=
 =?us-ascii?Q?Z1/fDY/GQs2hOCY7RYEq+80DTD29krfz0eSq/wyikF+/8FsY/kHFEIhfwm78?=
 =?us-ascii?Q?+V2BK4PUOQhONb+RlVLSIvqX0tWxFS5gFsWyFRjzRI4fbrT5VtZ9gUupKbHl?=
 =?us-ascii?Q?DKjXG19GPtp2ViEYp1OR47cv1/DKzgib7BG8KfOPmKTqcdht/DbOR+Hgmz8B?=
 =?us-ascii?Q?ekONM8H4i07hmfk7jTt9PepIrtt3rxYGQq8Po9SwLTKGxw+f6hI0ttVSLE4D?=
 =?us-ascii?Q?Y6UWSYKIay55+rz85IYCPFffJpry0RrwF6BS6fjigE9nXoFY5PuhC455cSmS?=
 =?us-ascii?Q?5i8Gg+DH4u4bXZpc2IOaOwMuL0hScnnrDMByzOKwpaW6FYtxHnVRQiH911ZE?=
 =?us-ascii?Q?oxkNRdasDvSyBLvvG5doHgwE5VCSKmvvEYyw3i+gVGoDZL1eQUMxpqFFaow5?=
 =?us-ascii?Q?jHv2N096Jg2JsaM8fn/YQlkv6ebtJW4Qhhz36FfF+CdpkRBA9xu1O+/ArEyV?=
 =?us-ascii?Q?3Np+m1R2KsCrTCpcllZq+4NtT6BQ10XF7zfngTR8AZ2gGULQlPd014hf6m+4?=
 =?us-ascii?Q?1C/aQmNfbGdQTH+oRJyaLEvqaXolSNaXzcpie2a5mTL5K7dJoSrujYz26nyi?=
 =?us-ascii?Q?hjfN1YeVlh2HSc4mGdSCdzlXmPJurfZpWQTXkrsncWksHs8H4HzvLSNm8STY?=
 =?us-ascii?Q?wK2qccvL/imLDgwCSaiiuag6vz6639V7XG5uzHhcWTL/sQGudLls8kunPLwp?=
 =?us-ascii?Q?XF/tv6fy7DrFCZAAlyvwA8PFyrXbZyAO9L8qls2GiNF3Dv1FLlUEnY8jsOdV?=
 =?us-ascii?Q?i7FTWo6wQq2a5+YUnJSWrI5HdJPcOVyCI8ooKSCwy5ODzS4z++jpBeDu7tUs?=
 =?us-ascii?Q?JHE/mytHZ/NkQ8PQz7SuzsQGPKgcvN4zmxgG7rMBO8J6VM3gIg+rw64eKG92?=
 =?us-ascii?Q?IaXv+tPBphYjcMCuAABq4f8grrkTEofU6r9NOPglh2PyO+HYfb7ZQ8J+TT7D?=
 =?us-ascii?Q?WzLopC7Kmz4boF3rPMnECIbp/iqWdZcsom0gkToAzJg6m2ut2+X5ZRAJZ5OK?=
 =?us-ascii?Q?KnD7IXLSXtjL0PGpN9qMFfcyr6bvaEQf6tVavIx3quy9UwlIRAskefsKj86k?=
 =?us-ascii?Q?XROOVgGMVyhn8PAjt2GLGJY7lZZvOIr4Py2r6bBpIgJBe7/e1yqG2FicaYqm?=
 =?us-ascii?Q?iTKveLTlYpqhh+Uyp7AakDP3zWMZC3dZOX4nz1Us2LrI2r0IHd6wSRixFmSE?=
 =?us-ascii?Q?jOqZyVoq05eTCW2rnddb8s+DsNFGNXIRowM3XvRFkPeZkeYyk80rbVBXh+47?=
 =?us-ascii?Q?np3vOLtkpxw6qXMFf7bAX1qgCP/xrqOIQhW7t0BOlOEyEtbfyxc1VbMUzBRd?=
 =?us-ascii?Q?P6rc/Nl9zWXq6wmoTB7YITax1yVNmbXlWd1349nGvXuAoeoF8rn+6oJb7ZXl?=
 =?us-ascii?Q?21RohhjI/WFzN1yYRUzplCLq9SYZ1cJHPOkBkigSO5OXE2SXHHNu9HglE1b9?=
 =?us-ascii?Q?11CgxlzMQ7VIdsPNGK15pCry9yUlI38wmcFTDxBBHqYDs+4nOu3hVIyFTCij?=
 =?us-ascii?Q?p0nFw8dzdCQSm2BaBAD92Ts=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ellips.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR02MB4142.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 160a9ef0-2e9d-451b-2b5c-08d9dbf677a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 09:23:06.4030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53a902d4-22e7-42c6-a1ea-5776f15ccd54
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LHJrJLca92AV1aHn62JLblWxrGKDkA4UR7Zi7WGaV9zPvtKIIj4XPA0gYNVJzwEY8VIJKgKoIkwAb2PPd6aUuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0201MB2094
X-MDID: 1642670589-PYMomZwb6aS5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,


I have an issue with the ixgbe driver and X550Tx network adapter.
When I disconnect the network cable I end up with 100% load in ksoftirqd/x.=
 I am running the adapter in
xdp mode (XDP_FLAGS_DRV_MODE). Problem seen in linux kernel 5.15.x and also=
 5.16.0+ (head).

I traced the problem down to function ixgbe_xmit_zc in ixgbe_xsk.c:

if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
    !netif_carrier_ok(xdp_ring->netdev)) {
            work_done =3D false;
            break;
}

This function is called from ixgbe_poll() function via ixgbe_clean_xdp_tx_i=
rq(). It sets
work_done to false if netif_carrier_ok() returns false (so if link is down)=
. Because work_done
is always false, ixgbe_poll keeps on polling forever.

I made a fix by checking link in ixgbe_poll() function and if no link exiti=
ng polling mode:

/* If all work not completed, return budget and keep polling */
if ((!clean_complete) && netif_carrier_ok(adapter->netdev))
            return budget;

This is probably fine for our application as we only run in xdpdrv mode, ho=
wever I am not sure this
is the correct way to fix this issue and the behaviour of the normal skb mo=
de operation is=20
also affected by my fix.

So hopefully my observations are correct and someone here can fix the issue=
 and push it upstream.


Best regards,
	Maurice Baijens
