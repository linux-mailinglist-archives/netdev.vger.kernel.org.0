Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD4362C137
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 15:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbiKPOoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 09:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiKPOn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 09:43:59 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7243E0A0;
        Wed, 16 Nov 2022 06:43:56 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AG9kBnX016324;
        Wed, 16 Nov 2022 14:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=3eYzIFpSa6byGgozE/G7yxmwXJejf8R2l5nHMC16W24=;
 b=Wk/vlvqSgIPC9Kwgx+WJzGwKyuJIuPo4sg9N9In6Z+QxiDOeCQ8Fvy2csL7DjWm/2SMF
 PmnXwmXigpzCNrPguPS71yfl1XiJGWGnXxz3IiFxmb6CuiPapqPJran91oVkWlSLSwz/
 RGx0jkt7ChR/mweKvxA/DmvUep3F2b9HPJHMSQz9wJX7R8c6Se7neK6W6Kn/Y1Y/9AVb
 rbbNJBEgiTdk3lLjueW4rAKcCbtx8tkM3PmDd6I4/LXjET9VvNlhHU2HSvV69Bv3eNrE
 FnV3yqcFw+t1Ba8BBCUP5YU1FzL9Rh/P9tAbGPAkKSYyM+1AdyBIL4eUTIDBtMGm2J+V +Q== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kv75cs6yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 14:43:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq7r0XtCIuI6jG33BdimxW851qhvuzKotbLymCItxeQ5xq1/AcAobRDO4WiqP5GN3GwHPdKUDw/ZvfVphQtIcf5BRR1KQtEfLzrV3Ta8/pTKC1TDUj81m8Ij+LnOeAH/HD76GoUTf3zh055t3wRgFU+9sxFoTS6pRAsNN5VHwKSdwOcr1B9iIPi0lIHDF/XrXWQlzDxrKQmnIubI7lEYAEba8/Ax5UqxFlBse5QIfeFEuYZK5IjLcrrYpbSaAZhH96hC6VdVkb2sc/Z0V/rcvY4WvAa9NWhnf7wIh/NajydagMZJD0pYjMShC2AzY5SeRMhhYghOsk61t1wwGvwKYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3eYzIFpSa6byGgozE/G7yxmwXJejf8R2l5nHMC16W24=;
 b=W1KJhzdy/t5YNnouBtgThvFIvo/M6WFE8RP+WwJesSwezjCj0+E5b+sHj1FI0uHxIpgezmxeVSiPKsQ9BjlQjDhXwy8fWiB1rLyXXYJNqqDuPwylLi1TwfyHwAEu0zZ3vfTY2SNoUUElPGHgVar3ar/K536vkUvXmme/RBsQ4k0WwJSbxS/3/AI1KQ4CyoSijKtxO53PlMP4cWAQy7gjgrbKgwcohpVFp6RhWrFTwf0AVbTDAD7HsXATArZ7+VWqIaWctPaY6Lb93mAdi/oKH4LcKlGeNlykOoB0j4TqRFKcxfX+aZ0Fhts2vOs0BdXCdjMfm+inl+1m5zn18adlwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by PH8PR11MB6927.namprd11.prod.outlook.com (2603:10b6:510:225::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 14:43:25 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2%5]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 14:43:25 +0000
From:   Xiaolei Wang <xiaolei.wang@windriver.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add link between phy dev and mac dev
Date:   Wed, 16 Nov 2022 22:43:03 +0800
Message-Id: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0216.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::11) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|PH8PR11MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: 757a8680-9bbf-429d-8d61-08dac7e0ea9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DYyV99u9J8K9ByLolxNAKfvrf+QmTDA0vbhgGo0rv9e6vML0eweO4n7irEv2f+JhCEhUb4s4XQltSN+6TwASg3HdZLxUAiIPDP6Vu/0X7gff5HNncTzmymBGmktwzgLMh3l3EGAJO9TpYcXBuRAiIWJQ1B8e3H19GhA26SVX5NGdZ4uUd+sS+ao1u2iPmCcYF8Fn+19Bq8NZa7pQUiINAWk6BkbfLOY8TAV7B5dHlzRmLiiKu+cI33ly7koPdeNC82L21IeqQOkzO1Rt5qjAVFVbPyRcDkwcBlkZtb6us8cQBOQi8g7Ya7qQ/8lAreOoyC0CKJ0+XEkMtHyMXgRFbgKhzuWdtraq3WJU2iM876eH1tRPDFzWzQhyaXVgCdXmzv5MkrJwMyawUEiu7fAKmZf900uuQflvhfojEqR+H69sNDfoMWlC/Db9jZRcAhzQxpekHsKckoYcwzDvLGddwwfQxf5lg0wCidDkeg4y0sTq7G2Pne8vHcpO0SLQju6QvbZy3CJbdZR7mJ10D54SSQm1uP3ptZY0ULBo+GPJhvjSIRTK9anMaSIu6ucGrB8afQ2hie++FQX8dwOP00oVcppaeZNAzKeUS7JbkyMkPZqPyVWJ4WrtjqTw/Nf08z0BFDPmVZJJDSA3iNKhpe11lURogHetPDZ52Di7Y0km4SpFnKomZiSExNVxaQC2lvfBoRKE6avRGjA4iGXZvmw1yX69b5XLqmzqQbE9D0x6NeUO8E9UJv4uluxq8Ugiyzfz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(376002)(366004)(346002)(136003)(396003)(451199015)(83380400001)(38350700002)(186003)(2616005)(1076003)(38100700002)(2906002)(8936002)(52116002)(44832011)(6486002)(6666004)(6506007)(26005)(5660300002)(66556008)(66476007)(41300700001)(8676002)(6512007)(66946007)(4326008)(478600001)(316002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?97LTCFmIJYhbLzH813Nw7dHEDYKon9V8IWcxeP46xj8fmYe4nEAcAHYnXg6R?=
 =?us-ascii?Q?QYbE55I/34b3R47b4JTDi+XyUHU5s2PtHkhpX/GoylCdDHUUGtm45HkNrNDg?=
 =?us-ascii?Q?ILxqZDYV/spdPPnywn4e5rytK1FNhbtYpSE/rpHyGrsMb09bGHWOkxOXPJlR?=
 =?us-ascii?Q?50EeEw7nY+z3TW1SERccYrcoTHMjr2nF1oCqXkAVHoQF2OquDaixqTITa9no?=
 =?us-ascii?Q?xnPwEeigGvKNr16oYERSafuEfTk1dIL8vrb7Tt8QzpBtVK2kVJEqsB38eBA1?=
 =?us-ascii?Q?k3+mr6Oj4bvf6mAkn3l+zoZIdpdt2CeEOGKQypM6+DAmXTOcjaeDgZKa0d6K?=
 =?us-ascii?Q?juNS2vARmC/RVhlIt+BAp0VrjtfTRYHZFtOiTf+k9DoMZzQSPx6c2M48nhEk?=
 =?us-ascii?Q?A6lituIbvAkpzfdS0CIh9KS6d4es18NKlksoAA4CkoeDqRA3UaLF0UDgqmeZ?=
 =?us-ascii?Q?rmd/0DzIcAwsx+8kabywvmFrzMJiwEiGLpjuYgJsRsgva5hyTmLDjqbd2wus?=
 =?us-ascii?Q?NyRnxweOiMkLxLd5Y9YDjgWSoL6Bji6bG4UDNZGujuR0RviwBiyvOQaPbXQt?=
 =?us-ascii?Q?4PSz5gXrQ+VqGeSrFYZhW9wn+xVTumiSOfXdrz9lwyenwN/lLjfnT5FWpBIX?=
 =?us-ascii?Q?aKYPCFdt5tHQMQWhmfAymvybZZyfoOgFUzZ+YwgMnPIDJyxoSwnXxd+4ngV9?=
 =?us-ascii?Q?lBohXnIRdnN/sUAX00VF0MO8zF0v+CCGXQ+lt1f/xZJdUti/T2o6BsKJIXbp?=
 =?us-ascii?Q?QCVKe4Qa7YtfOwJthzm8S7hAbCDddJotLSX7L02nPoeTRlZcmjP6cwQ52QQm?=
 =?us-ascii?Q?1U4ABT6arNgJM2a2fP+dI840KzX/ferkvOdU/9B+hFkEjhkljBzs33SV8+xT?=
 =?us-ascii?Q?vSEEUo1kBgEq5mSLUpi2HvPDczaXTEKWlINEIkP9pKT2gBTe/8tl7/+TgM9F?=
 =?us-ascii?Q?jXk3h5Md8xmMgy8PREQxAlnYRRH0PJaU6rY5ocvHbMi2E8dP0KXsuor0PfJq?=
 =?us-ascii?Q?4cQv5Nify0S45v912UWxFDERoE9FehBkjgWSsUR204bvqvm6N9v38Ll3I/Wv?=
 =?us-ascii?Q?XZtaG+Cp8cbv0zVbB/p423EdH072GOukZscPxhzRmZbHrK0Yf+ItBopQdgHR?=
 =?us-ascii?Q?aUEX2aOcfk9SJ+y/9ejMQAjaJKtu9wwza2lFWI6xB63MdOzmxqw7Dp5exS1m?=
 =?us-ascii?Q?4WSMMJ4a4D8B3GRroxFyQkWRIXku7qQyEoYeFC5piLyXyDP4lzRHZtGLJ2YL?=
 =?us-ascii?Q?o1SxFWy7jKzSD8dEKzIE3LeQo1bf9PuTCDoJfVsNthOJX9So4NOAyJ3xELy0?=
 =?us-ascii?Q?B4dSV+8cbhZGnmkNGF6rTBMnFMdmY3wg9IMguFoBkUF7GXHSGfugEH0yAPA8?=
 =?us-ascii?Q?dw0zUBv1cLbNGwWzy8+rs0cpBH00HFbDqEtl8lA3+2NCnYnaMwz2C9KJldl+?=
 =?us-ascii?Q?gofWtyhJdNf1mFys2atU017ggqFEoEKLse9zdhKTJfQGDpmRpO8lNZkVgiNb?=
 =?us-ascii?Q?mEPx40drL948QSwfJF57Mnk+a/SK0IWYBXtybLadqCHAeSXb5kw+sf5uPkyu?=
 =?us-ascii?Q?DOTcSMMKmWxXAT9Vq7E1Bk2vnIvY1Mz0hJnK6GAfxV93j6a8sBE4cj4oShgp?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 757a8680-9bbf-429d-8d61-08dac7e0ea9c
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 14:43:25.2669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OyUC3G0HmUsBFrffXAwavS/AEhv/dK3pMG7gCojLtaV9qo5j4E90lFTrbcAqYnBEj0ul9/qIDk6uPgmbHUxlpL+7sJwxOpMofIq7Vm3JLHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6927
X-Proofpoint-GUID: _qIfhPeVA-UTHpkCF5P5OR4LRzOjIbHF
X-Proofpoint-ORIG-GUID: _qIfhPeVA-UTHpkCF5P5OR4LRzOjIbHF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=4 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 mlxscore=4 suspectscore=0
 mlxlogscore=139 clxscore=1011 adultscore=0 bulkscore=0 spamscore=4
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211160102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On imx6sx, there are two fec interfaces, but the external
phys can only be configured by fec0 mii_bus. That means
the fec1 can't work independently, it only work when the
fec0 is active. It is alright in the normal boot since the
fec0 will be probed first. But then the fec0 maybe moved
behind of fec1 in the dpm_list due to various device link.
So in system suspend and resume, we would get the following
warning when configuring the external phy of fec1 via the
fec0 mii_bus due to the inactive of fec0. In order to fix
this issue, we create a device link between phy dev and fec0.
This will make sure that fec0 is always active when fec1
is in active mode.

Therefore, in order to solve this kind of problem, an interface
function phy_mac_link_add is added to establish a link relationship
between phy dev and mac dev.

Xiaolei Wang (2):
  net: phy: Add netdev link when multiple phys share a mdio
  net: fec: net: fec: Create device link between fec0 and fec1

 drivers/net/ethernet/freescale/fec_main.c |  4 +++-
 drivers/net/phy/phy.c                     | 21 +++++++++++++++++++++
 include/linux/phy.h                       |  1 +
 3 files changed, 25 insertions(+), 1 deletion(-)

-- 
2.25.1

