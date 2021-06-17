Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC3D3ABA16
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhFQRAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:00:41 -0400
Received: from mail-eopbgr00110.outbound.protection.outlook.com ([40.107.0.110]:48517
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229816AbhFQRAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:00:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJcnTQnWENToRYDBhoFwCjA1YJdXLKLjjh6n/vKFk9poiw3LnlPYWZMz+rs77v5T1gpaPs1ERDreGr0wGS4bgL0xGql/9zORR7P3FKod1jDol8b6RgFGqt8gcc+ZxmnI6j28ZTxC5VKZYBjiAHw31GhmJmHcL/h7nTNbG7CwT05BRZYr8eI/PA7r7JPkDx/lZrJ7j9oxRBdSDUAHZwiJ5uS7MssgoHAbxk5QT5ckR3xBIXvBNVlLwH2f28qbcTzTt7ci4JVoC0lc9EihcwWPuDMVyt1K7L4Y5LS9pwnRcmbPb0fhgRzxpkzGrwbh0EaIJVR0je+paQkr4iEB7P4CfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDHI2r1uQtGL2SQJi4jk2v2Bo63/JTUtz+gunnhVwT4=;
 b=LDCC1wVKNPtRrcF2y8jdKWEuHhlAZ5TjGL61e4cX3+p7+6x9Wx4ojBjqvDIDVT3PyBaNf1TvnARR/6sCxoPusj397vbJ7KGIGn2BgSCi5n5NcLEPvQw3lh72XX9ympK87itJknfS8ZxOoijR97bW7lUE9VsInCieIeL8CkVuBFT8+YiGGcUOhsc6jlXUkq0l4VIKyJPa9yFHJm8wWfdhyT+DxzDDRsOI9A4ATcsoZC+wcZ2axhbs4BDxWSYVrF3ItJsz9mj+za0Mq7HFkP6JuV+Zc7Ik8iZL3hfUJ4eyrsC0O1Pwka32WksuKb4OGufyvxvektY+eTveXRgBHoHgcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDHI2r1uQtGL2SQJi4jk2v2Bo63/JTUtz+gunnhVwT4=;
 b=ybSgBzkMFs++CM4r7LqrRBlSI41Xofmb3xrPJFzkfXhYWxF7VAIX1sHlBhnlfGdZFcpRIjJ3ofaTsrQiKfuV3paRGXT6cpY6uSZ058Kce10uTs6zptltrdNLzK1mc6H+6ebbx+g1gW0pSl2P2YhoW8HE0h0xk2tGRHjAB+30OUY=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0570.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:55::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.16; Thu, 17 Jun 2021 16:58:27 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Thu, 17 Jun 2021
 16:58:27 +0000
Date:   Thu, 17 Jun 2021 19:58:24 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-firmware@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [GIT PULL] linux-firmware: mrvl: prestera: Update Marvell
 Prestera Switchdev v3.0 with policer support
Message-ID: <20210617165824.GA5220@plvision.eu>
References: <20210617154206.GA17555@plvision.eu>
 <YMt8GvxSen6gB7y+@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMt8GvxSen6gB7y+@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0177.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::32) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AS8PR04CA0177.eurprd04.prod.outlook.com (2603:10a6:20b:331::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 16:58:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abaf67d1-86eb-44a0-740f-08d931b12074
X-MS-TrafficTypeDiagnostic: HE1P190MB0570:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0570832C1A665BE598B54454950E9@HE1P190MB0570.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 90K6BHaqEl+ukrZeVpA3XpC46TaBIldcaSJao86m7STa9CEKp1PpvNJTAXXjruHVnijNiFaje7s76ZMT1Jv1idSe7nIj8lW3QRLwf/JO8Vhp91mjLdf+7JPkDmaNe3dO2/79fIWM4shLz0nTGuZiy14WRRxMTSWEih0CtqL0Kfa5pRrdWPVCVxVOsHeZA5D/Qc/l7S0bRxOFnvzrarN9lV+81ojLa0fggyAIRyUXhGg4295ke7vqBNjIA9AbzHKGThgqgUAliy0AJLFVjPbtz/KFvLYR7i/VwOm/Ky1kEEn1/w/5eXfNNJkjaP50J/bGsbSOmgIK3cFYcx9ZyI9ncEp403ux/KuJYinPNuRcawf++eWBk5LNS2uAijG3J9Jm3tZMFOpiF9Z6Mau3Q9a2u4xIDWnxI3Pz9BU5qlYHqbi6EdE9fGsUdftvqalF7y9s61H5DDxQoKT3AIqdM5/C6FXsPk4A1Rn3tU0/O01cDydO1wqJ/h3bbsD0MCQEQmoEIzQIuLa4baQgr0l9FkjuIO5HiJ4yJhvM4csryxRSndyXyxfSR06FNqEFmSDKJKnLkIwyPO95L/9oy66oqek+dpAHTr73/pbjsV6kIFcrhSYMZPraszqAfbCkIlsuxZQSTAsalR2QUS/1hMukoUMhF0Awl+/tsYkuykUt54v68I8trHO0DiAf/CM5AvXy4Xc+1BiBIVgguGpHMkKqff8WVBeMhEQps7M9XTaT72N4B7P/BCabBwXpmJauTZBwVNnvFBpwAaFf54D6AaARjqcIuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(396003)(39830400003)(366004)(376002)(136003)(186003)(26005)(36756003)(956004)(15650500001)(44832011)(16526019)(5660300002)(2616005)(966005)(83380400001)(2906002)(38350700002)(38100700002)(33656002)(55016002)(86362001)(66556008)(66946007)(1076003)(8676002)(52116002)(66476007)(4326008)(8886007)(478600001)(54906003)(6916009)(8936002)(7696005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lv00Sc9bMezT6upYMIaHzaIhuv/nOwZNfPSYuFWsjz0wBDK1gMVcJECZqA/w?=
 =?us-ascii?Q?2AHseYJb19LM7R18AQZL2BpBjr4iHe680NygUslheWP/MJKYzaDwqBJ7lkb6?=
 =?us-ascii?Q?29pWk9iQPKw6nPH4TDXSVjqwL5t924H26ig6RP0nFDdbagU9EmO8h/Bj2/Tz?=
 =?us-ascii?Q?buFo4VB9chNna9KEZjHb4ZjZ69uawR6/aWYTCcstZTeTBz0APNDkMOXw0Vng?=
 =?us-ascii?Q?ehXdVMhPMUXQRoHMhdRih2xNWtSyBlHxwLNGuRMwnSMOwV2NxycFpaYxXEXP?=
 =?us-ascii?Q?grgCjosTnygzEWSMjIcemkA+PhOV/fMIb3rnAUQ/yvY7LSvBANLKf0igUkVp?=
 =?us-ascii?Q?NZQprJm2Qi2Pil30K34LhYdJQRWd1OrB0g3vyZtISMaQxWmthjaR7uLY5AaO?=
 =?us-ascii?Q?JjFH4xTFhXji19Dbq+zc0njX2H9Zy5Gn6jbBoHYxGcI3XsBGX8AlsPNrDjFI?=
 =?us-ascii?Q?KlAVRqEl/+3t+gLl3ut4Wwtny37CLav0ZPDyLpTnOXP3dNjfsJ1/NzMQjU5z?=
 =?us-ascii?Q?MAQnmvfLw/uYW5zWzsPTrJysfaoXp+Rr1ggTYHR1fKDNA/7SKtZLTsHl2Kcn?=
 =?us-ascii?Q?pq9Nl1MsVwEhHk1dcR/PagkhEXc4zi3p3OJBFb3xd42zt2RuUEBM791Nv3Cg?=
 =?us-ascii?Q?DFPPDpghxwFIZTHqDqBSezy4RZsc17gi933TW0wXNxCNEG4SSv9PlPEaj4Pg?=
 =?us-ascii?Q?/0hsk0y4raTFkO91Cvt+LfTIBPbDQPECPSNF22b7Oh6W/4d/4afwPTFy55yR?=
 =?us-ascii?Q?6opGQwc1FQid/n/v+py8LNd3mmd+qczANA3Om9UIG7tkCDNy5hAu8vKf63PM?=
 =?us-ascii?Q?tCWO+dXwhzLPMoRj2wtw1CFgTRG/KjYfp2x/oseDaSyjnPH1kuY9EsZ0xndt?=
 =?us-ascii?Q?0sA6NHOyzsRFy7Ju8OkWUBEw2VxPQYZbx614lbBjysNrzC1nAePP4N6/d0Et?=
 =?us-ascii?Q?M8JkxgrMu1poT7yT2e/uWRi3sRNXZ80X3jO0Cw/zhaGXxOO1b878r/E4jn4/?=
 =?us-ascii?Q?EqDeP2kbHbwz9zicwQ4JNbEcbZxmKwWtoQ2awdCIcdv0B3OvZjv+OY1ZW3ku?=
 =?us-ascii?Q?dMtqCURhxmOLnWKc2xIn/i09Ci0cmFXwdMapTju078xqFhS3MeKJgE3olFkN?=
 =?us-ascii?Q?4SNbQXkhvgr8hxFeme56E25aDCho7aWmCOYDX3p/wQVqcKyvmPIblz2v5J8e?=
 =?us-ascii?Q?ISOoPPYyVNTrzBAGV5uyxFILVqrEzkJxYYGbL9IE26RGQ7cnfyddUILXKLGN?=
 =?us-ascii?Q?a7ScPByuqrXZOxikyqTggfDT/C0bEIcHtsjih6S1wXFoUnnkYIUb9QNU9mCd?=
 =?us-ascii?Q?0fIkqnPUpLIb9QYIamZuoMLp?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: abaf67d1-86eb-44a0-740f-08d931b12074
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 16:58:27.4050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZVhvoDuTJ2pJTtViabu2PTPi2hemX6WS8C6niMpTAnhydukBDlWClbJVL7vnjF+cpLASR/IOEX+8GGpGsgL/TvRQUn976zQQMrDUIBzRu58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0570
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Jun 17, 2021 at 06:45:14PM +0200, Andrew Lunn wrote:
> On Thu, Jun 17, 2021 at 06:42:06PM +0300, Vadym Kochan wrote:
> > The following changes since commit 0f66b74b6267fce66395316308d88b0535aa3df2:
> > 
> >   cypress: update firmware for cyw54591 pcie (2021-06-09 07:12:02 -0400)
> > 
> > are available in the Git repository at:
> > 
> >   https://github.com/PLVision/linux-firmware.git mrvl-prestera
> > 
> > for you to fetch changes up to a43d95a48b8e8167e21fb72429d860c7961c2e32:
> > 
> >   mrvl: prestera: Update Marvell Prestera Switchdev v3.0 with policer support (2021-06-17 18:22:57 +0300)
> > 
> > ----------------------------------------------------------------
> > Vadym Kochan (1):
> >       mrvl: prestera: Update Marvell Prestera Switchdev v3.0 with policer support
> > 
> >  mrvl/prestera/mvsw_prestera_fw-v3.0.img | Bin 13721584 -> 13721676 bytes
> >  1 file changed, 0 insertions(+), 0 deletions(-)
> 
> Hi Vadym
> 
> You keep the version the same, but add new features? So what does the
> version number actually mean? How does the driver know if should not
> use the policer if it cannot tell old version 3.0 from new version
> 3.0?  How is a user supposed to know if they have old version 3.0
> rather than new 3.0, when policer fails?
> 
>     Andrew

So the last 'sub' x.x.1 version will be showed in dmesg output and via:

    $ ethtool -i $PORT

    ...
    firmware-version: 3.0.1
    ...

The older driver version will not use the policer feature. I am not sure
if I need to add a check for 3.0.1 in the newer one which will have the
policer changes. So may be the only case which can be handled (in new
driver changes with policer code) is to check if the FW is not older
than 3.0.1 during the validation of police rules.

For this reason I decided to do not increase the supported version
MIN.MAJ but only the SUB (last one).
