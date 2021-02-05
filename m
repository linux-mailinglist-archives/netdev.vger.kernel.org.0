Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D17310A4F
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 12:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhBELdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 06:33:03 -0500
Received: from mail-am6eur05on2090.outbound.protection.outlook.com ([40.107.22.90]:10369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231597AbhBELaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 06:30:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFeDJ7IxCIV48wTqd1vbgC5HhkZBz+ZmvClD1urnSH2iuiueOUrWbo96SRsKfG1nRDVppMxNo76UlHYs9d7u3QyoP5VmLYiF+5SQRpnxhmUKs6yzGjMQmj898NQxF302MZxyjxCBswO0OcJ3Z+PGsHrtvQA0zhIsLdzhbfo/P91HGXK2Bh+dmLIvnOg+5Jop5sZ+E1vsZ3N3mFz1yA9/LIxdVZBw+Rzyjfz0Yi6GELTybdB+xgBd7Lvnh4fPMrTpmicvotkJ5yr7vYOZHhLBJ+AnNnPEhrimvbw1tdhEQWL8ZmIX1byg4fNkWwPfQcYC3KatNZEOGpRL0IS/TO+SFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DP9Bx5E/Syt52Fzqzc93u4PY0qhtntHc4DOYXeyYikc=;
 b=dmFg2OECIeIsjwR/sY6QG8WNI9+1U/gxOzAHPaxoZjmOX26deLdGR08KSDyfKVEWxcLVhLPwqox3KWmC1osmCfcgy44t+/mpwzPJFAktJDV1dIWBO1lX6Zb6OkkvtLmRqhKoPLTBxIo+gJ9MgbveKsOhhLOdDMTiaX7di6x6DhH3cWdSQ9ODQRnrsBk3xh45qVWZmITV6KiGzzQOpDf/YmHyXFHmFra5UIVx4kid1AVUyRJwInQS0Nfn/6rKoSmKytVW/wPtKYOv5KyqxlhQdssxxYyO3cE0oQfU5ZkgXZTj/tFbudTPswdhagDeNQZu7+khviKnYwCvRgrNUQ3Z1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DP9Bx5E/Syt52Fzqzc93u4PY0qhtntHc4DOYXeyYikc=;
 b=oBo6F1eCGbF55X3R4voz5e53tVVKojCtWmzyL6uzZUENqe9pZuTq2yb37qRvhRJOeFG/KexI+V22jQ971PTY8tSVEHsHW6u7yW04I3xiJH3xb1jximN5WG2kQfrUG9Kp6vC3+/9LxtxxG2CUbuGFundcnrfW3Fjdo1vy5KTDiuM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0331.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.19; Fri, 5 Feb 2021 11:29:28 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Fri, 5 Feb 2021
 11:29:28 +0000
Date:   Fri, 5 Feb 2021 13:29:26 +0200
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     linux-firmware@kernel.org
Cc:     netdev@vger.kernel.org, Mickey Rachamim <mickeyr@marvell.com>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: Re: [GIT PULL linux-firmware] mrvl: prestera: Add Marvell Prestera
 Switchdev firmware 2.5 version
Message-ID: <20210205112926.GC19627@plvision.eu>
References: <20210203141748.GA18116@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203141748.GA18116@plvision.eu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0301CA0007.eurprd03.prod.outlook.com
 (2603:10a6:206:14::20) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0301CA0007.eurprd03.prod.outlook.com (2603:10a6:206:14::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Fri, 5 Feb 2021 11:29:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27d319fe-055b-4469-e764-08d8c9c94cb7
X-MS-TrafficTypeDiagnostic: HE1P190MB0331:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0331674CF6D3D0EFF4B63F9495B29@HE1P190MB0331.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMMVF6eKUljUFE/W76QH3lC6tvTH4cy1YJjjyVkVod5++Xu5J7Vj0zEJQr8B993QPtAbv+7TJeMBXIs4WB9LexmEfQNk6QJjd1t80xADLeNtCuSNviwZTnnRSN0c3RfLbg7enJbp9J3BqvWdNCAHe6ZqrsIl3lIfO7NjDyl3p6485AzL3zoNZ5whGrmRzPa09O2C2flK6zWFMKoMVRB6uJKkQMSSELcH7XqDZoDoJv2RwBfMMJ8xCg1UCCjTromjK6bw61aIB+7F1kJM9c7xGtYYWTvZ7277Q1n5IAZEZhJjlcfjtLjtWBc1FqDrKD/LvOElyYvC+LNuZpCmoKdDG+RbvQXzlpDtJieRh5MzhchJf25pBeRcjWcNLJEVm7X532GaK8snyiLy76vr42sLgU2TKbz4MzKq1hpJDjfBT7xX3MPbM1ENRNmAX09dz13i4nu2D6X8X19t3h1B2Q8JaJAtrDKq0CERDKbfdMm1jw70ddXnPIxLd4RhLpSXdiCI36W13o/N0MjE5twX4nY45qM05ElLng0nvBzR6qx/gsPvYLT33BZOD0fekZX5H66JJFOH/+rbVrPBXKjW4VVtyukUSXlTqhX0baN5OkXDlGY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39830400003)(346002)(376002)(4744005)(4326008)(44832011)(2906002)(8886007)(66556008)(8676002)(6916009)(66476007)(66946007)(7696005)(1076003)(2616005)(956004)(8936002)(52116002)(83380400001)(966005)(478600001)(54906003)(26005)(316002)(86362001)(107886003)(55016002)(33656002)(186003)(36756003)(16526019)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j3o4ZraOKscKzmSltp4a8DQ/U6xli/DfKvJG4FCqQZ17/QpR4B7ukb6JKd3J?=
 =?us-ascii?Q?5b94K/Id1uN7/UfKGPh2sKDWUJN1jkokcabBg4LCJo81lTzTdfKwz0PNkkbM?=
 =?us-ascii?Q?aRsAxv2cl7N8jdJ1RB/lSRgbSTT9hMC/wLf9yabVfiEVaZ9jZ6wkD+m8MmgO?=
 =?us-ascii?Q?MuvcoEuQLeqotqrayxxDS/yegYU8QNd7i8ulx7tzhd/kXRW34bK4UKluOuwf?=
 =?us-ascii?Q?T+FjyCyf8i6bA1evrN6ad2+Q7/f7F92ngqI5n2quEp7Gih6ILanM1lGmrE0G?=
 =?us-ascii?Q?jVmqFCvPV7/ffLSt9wSa1Q/XaB9rSj5orjI5rkUKq4umwUOL6uwWzW96Kzvm?=
 =?us-ascii?Q?FXxcFLbhK3Bgif4WbxK2gw0HYPw+krdSTMdj7vjqhyq0OXGmRF7yukhfpxvE?=
 =?us-ascii?Q?5Nfxxp6pAAvNx5G5qrvCXj5UQD3YqZtX6ViEklQneXEP9pFLll1PJULsWreE?=
 =?us-ascii?Q?yNHFVkauzU3Oj1/6vM5sULTEe+DF0yP6Id0FeElJ8P10rU51G2jhrDdiPGbh?=
 =?us-ascii?Q?AGSZvsbLubmF95v8RrsYMrXcUi1CpIWi5vNolTS2FDb/l5QnHqwv6IiKNq3M?=
 =?us-ascii?Q?fb9xX6JgGl1k9En8zlr9ruQo3PbFHdKLdcDGKlTsytQPvSmgSxxj+wtofeDx?=
 =?us-ascii?Q?UexVFgQFMMUjbUwaFKSaKUm77LnX8LgefW5zoj15WboF/bKX4AKeTL1CuKZM?=
 =?us-ascii?Q?PAULpYUxZoh2e8f/QtBagMWWLpp8R5Nq2Un4ZMz6/orI5e+aGMn31AvfqeWf?=
 =?us-ascii?Q?aTx+KcJmX9WfelWhQthcOyVqWHWqrr+YkMMLNmQL9TmdnoC8/e2kuTKg3Smg?=
 =?us-ascii?Q?MGrEWg3UrmcrrlpJOVtP6pGDTumYeMCCSwhotfXq0rh2+LPv72axTxM/oGEC?=
 =?us-ascii?Q?F7EBGEpmkIBP25HGjDm3O0b1vW9r71gMjl/MLfXs8APS0sUwUr5aHZsKmwkM?=
 =?us-ascii?Q?NbFHXdAfJnItLbCIXzBWoggXNtYLz6crWbpMhkeMh19hSzGjfL38Ple1mXNb?=
 =?us-ascii?Q?YtKm2O41vQPAocsMTJZ2qgExg1NW0mUb8hRayYGyKRYoYZf2h5ECoOSmKXMw?=
 =?us-ascii?Q?GYPaSV2q/9pSovvBmZ4jEncpisay6WEN6EvHX4BLT6DyarRzaJNQo9eqbHfS?=
 =?us-ascii?Q?sThj2gmE2yKfCutX5pFNMpSXxm85P5vUQPggDp6kYLwzv79kwXnvLo35fw/u?=
 =?us-ascii?Q?gcZghp1iI2csP21VDvFF0V/LzpiczcALK/j4QRy7D4CoqV8vPl2tTrkcp21X?=
 =?us-ascii?Q?TOhm7cwmS/SpVSRbAgtWgC/zCPDwG2UHYr1udN7ESO8f0OEWckaMZCDa3BqZ?=
 =?us-ascii?Q?KoN52MIdQPt/d5ETBQB328A4?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d319fe-055b-4469-e764-08d8c9c94cb7
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 11:29:28.7744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEqJTpgwqxnCPmxk5/AQfbBlNmBlV0wHD8hdWq9uRRfe0VZkkYCQh+kywZe6w+ZUU3etnXIUaCTv9nIeYZ+K1pHoJ1jQSpXtdmOrkDbVFv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Feb 03, 2021 at 04:17:48PM +0200, Vadym Kochan wrote:
> The following changes since commit 05789708b79b38eb0f1a20d8449b4eb56d39b39f:
> 
>   brcm: Link RPi4's WiFi firmware with DMI machine name. (2021-01-19 07:42:43 -0500)
> 
> are available in the Git repository at:
> 
>   https://github.com/PLVision/linux-firmware.git mrvl-prestera
> 
> for you to fetch changes up to 1722d0deb575e4bd5433914bb2eeabfd0703ed2f:
> 
>   mrvl: prestera: Add Marvell Prestera Switchdev firmware 2.5 version (2021-02-03 16:04:13 +0200)
> 
> ----------------------------------------------------------------
> Vadym Kochan (1):
>       mrvl: prestera: Add Marvell Prestera Switchdev firmware 2.5 version
> 
>  mrvl/prestera/mvsw_prestera_fw-v2.5.img | Bin 0 -> 13721600 bytes
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  create mode 100755 mrvl/prestera/mvsw_prestera_fw-v2.5.img

Please ignore this PR, will resend v2 with incremented major version.
