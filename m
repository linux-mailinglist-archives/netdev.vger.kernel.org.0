Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8024B3C3E16
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhGKQuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:50:10 -0400
Received: from mail-bn7nam10on2104.outbound.protection.outlook.com ([40.107.92.104]:19531
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229934AbhGKQuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 12:50:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKCNEtSyN7Xm0+cDGLwJ+HfL68xH/Y+fXBYqA+7zdBHnwAJGS7yK11gBw0xz8scG+oaXiVEoL7Ozi0rdE+Z97jMfpQI4D0FPhydWl8sYeZH4Oy31GMfTdPWx9Wj6xCdAwRYGYLM8opmX6QQ7N2pYO50QQx+v1FpKesY5f6mi0XbFZc0pdWeMnQhuGwgwqn/NcZ6aK14xAbJPPJRbZB/TmZyEN/f2sXU+2y2OCfYRvj8S1b9b839UAmPI2+s2JhEX41MqEipXnnFwqanwB1ASgNGrXjyUtRxrPguJpemgxag2dGN9l2rEvS0CRuSuf2YK0Wlk6gpxn7ZKgpJSGzhKGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjW7PSxiOOBh1849434axFfr33n8doQUQnG1J0H9iW8=;
 b=SkytxZx6F3qSKYGPEyrCgyihH/mV7dy5zLMz2437Q1Fpag9shfiUqptgTnvxzsUY2I9bC3c3xRO6+BtyDBxF00A+Mc6pb7NdVipdQ/voBOL5oJhzXptDCblmIzuRL3W/MlVnSRv2Lqgo+Y3BOjxBUhvY7P4wdrX9aMUWUME7aVAofhSHTMrI9FO37S+jfe1hUW88GVtFi0pAmsN6dMNUMueU138+50DrqqYV9au2VuqWywNiYXCGlLITZxbYcBCfr62qHtLvVE7GlDa3amQGjhzX1pBQjp0XK4QEe+UpkLyNEJ+iYo4h1ZBym1JYRcB7P14zLQeq97gBU9j/KHPcRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjW7PSxiOOBh1849434axFfr33n8doQUQnG1J0H9iW8=;
 b=kTFup1b2dodflw5OXRscn/t/P3BQyW/B4Mpclk6uUCKB95sZn+QtfTNFqcLozVru9PFgLT+T/NzJKc0ickFrI2CKvBAwCCCzQPzidzmh5ya4vUDN/dFQW+PuluyXPpIZ/ev3nreYmZMKGKPsgQYPxJj3H94q7ibsVcGA4WgoGm4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4611.namprd10.prod.outlook.com
 (2603:10b6:303:92::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Sun, 11 Jul
 2021 16:47:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4308.026; Sun, 11 Jul 2021
 16:47:20 +0000
Date:   Sun, 11 Jul 2021 09:47:17 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 3/8] net: dsa: ocelot: felix: NULL check
 on variable
Message-ID: <20210711164717.GE2219684@euler>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-4-colin.foster@in-advantage.com>
 <20210710200628.uwwyzuuou242anzq@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710200628.uwwyzuuou242anzq@skbuf>
X-ClientProxiedBy: MWHPR14CA0067.namprd14.prod.outlook.com
 (2603:10b6:300:81::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MWHPR14CA0067.namprd14.prod.outlook.com (2603:10b6:300:81::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Sun, 11 Jul 2021 16:47:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d1cd406-13a3-4d3f-26af-08d9448b8cb6
X-MS-TrafficTypeDiagnostic: CO1PR10MB4611:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4611E6545F9CD8AD729DA405A4169@CO1PR10MB4611.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WSr3+42PI8FEISbYHGKEF/t3uGHJ/b6ouYxTQy8ANYdwrAqLTnW3oJ2iu59tXj3u5inSMuP0daUC/slHeaa2wy8nzev1bpnOJ5GQgkzXkoBya05wtLPC2SdlFcL8yopne7mtNO//UF7dMVWsXwUoDX8w6ruN0l2610wRUyDpJ1gTXGzRcpmPagEw1SZXWSECurKWcN71FAGAgvet9wBffeQwC4Nh1gcEqvk2+3PxbbsCzjafmwzCFjmXiEBJuwiTlJatW7IzJGg7rYpKavyR8p6DzxhI1iYoWrWDxDyApZajaA/NBp9Li+jN7NOuJv9CuVlR7TetZQ1LBdXTmS70Zh95ogpFLbk6LS6srOlz9zKIQTu1RYN4XkqQc+kABJHginKFkMK8+CEq+RJWwk75KmX+35cNyOCiVPIVzjg33HYdJJyfxFN8BPg8s3lfT97su1d6u5dlaiV8CIfOjEXpbrVbxblAwqD4JQKuz7jMQ/W97r5VZgsD3ExTrf8REX4RM5zvOh2q/Jgr2wXzZSbplr6b/f33Wbap1R8xgajbXIqN/HCOsEnSuooQYBey/ol+OOLL5w4/QOzSLnB0CfW0CUmnb29MpIe0Nn6mjyI+WsiKvu0YWpwc2pM+xvtO0m9DCY1mmmoZbxRXcxqzQ9NCMExKN4Sno4SQTIVQSuy/L7oURDWwJnf3bg5w4574/91birEsxbjjNoSd2her9vLm3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39830400003)(376002)(366004)(346002)(66556008)(66476007)(26005)(956004)(478600001)(55016002)(8676002)(9576002)(86362001)(33656002)(52116002)(6496006)(38350700002)(316002)(66946007)(2906002)(9686003)(44832011)(33716001)(8936002)(4326008)(38100700002)(1076003)(186003)(4744005)(5660300002)(6916009)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RjCIWOjpt3vZRFFV1sC9sFMpBaw770KzKNpMQZZmxq+v3NXsn0Xt0X+TMrog?=
 =?us-ascii?Q?j7xSSF8sAMSZk3rQrp29fzbEBwV2bHXvVVcP9tAxartqRk+SkhLYNH5YI3fV?=
 =?us-ascii?Q?mAuZl7+rGShTF5Xh8ncXzdj6djn+uL4DN4HHOWFnaOXrWcrHtdBrhTOEMMYw?=
 =?us-ascii?Q?TPfbjYahilHXwtqKSd2Rak3ze+I8YtJZWU1kiN/xRrSFUlkuvjADMLQFz3Dg?=
 =?us-ascii?Q?X5ovwBgmjc0eMUXZ7+i6mXB0pXCEmPYNhCvJqc9RKZF1XMnQI0QDV111oUs2?=
 =?us-ascii?Q?8fPoq33ZfwoTDEPAFvfWVHCVR5CLAwHWp0BlcKTWNNnx/9+5ApXEFhPXB/wv?=
 =?us-ascii?Q?1g89pOMq9uPAW7ce9ITwIbB3pi+Sequ9dWSNCxXzixdhLYmNvgvkxXjDJr03?=
 =?us-ascii?Q?JujyZDtrmmpg2oMOchJtcGt/IOYdg4qGN15xxitf3CSpjHudAHuI1rj4lD55?=
 =?us-ascii?Q?jN6tNn1oNrL6rPZoafOa46lC1ZLflSqRkCBcXnwfZ9ipcJqDLwSR7WMEpqnr?=
 =?us-ascii?Q?cI5k5xBqqxvg3LUWuVG2tg+me8u9T2i1f3pcTF1dGobdSYjcDQMt5SlCZAsR?=
 =?us-ascii?Q?8PCLpEIojNrN4Sn2tIlTvwY3csYNpvgngx6Ej/lsLVHwfRCA9JihHGb66+3K?=
 =?us-ascii?Q?ghzpyiMyF2VWiekx0I1Qk2b0kAVxzNWWnn2akEW4O9hBNtSdUF9f6nVriTNe?=
 =?us-ascii?Q?aUoKc7DHjPuSBrC97CammyeEtko0gm52s+8wIsXbxstEaM7vh3Blht9PZIJ+?=
 =?us-ascii?Q?q2M4O6xzLMCdWq5DOikiLvwqtyoJ2MLZPTq9+rEhvXrEGzo3LhqvTAvtok1/?=
 =?us-ascii?Q?jQvRwreCwFazwz3IzLVR+ml4LDIdtJdCSop9tYCNcDpDfvtFYGoAHxIdTJu3?=
 =?us-ascii?Q?Y/1Etix4VoP4kjBDjXd+G2bEJ6R2G5m0hGWH32chtb+xpaLSX5iPLwLFV8GL?=
 =?us-ascii?Q?K6lV/ClAFCz8Csw848OiBwF7acpjAbP79qsEJIezBXD/RyS/deUXBuOFsno2?=
 =?us-ascii?Q?DkYVFnroJOFfvl1B0tD2nrHIVoMCieL75OnbQzp3UiXx9LXn7eL8qEYF/8HH?=
 =?us-ascii?Q?w8QvM5DmG408dV8wCG/KlvI+qtrPav2gQPfMEr2iz45IKjfICQEussidywlY?=
 =?us-ascii?Q?FcgeHkHipJgYHm+QM3zP8yz+0QMhhU+7HgxYzMruh6DEN0qjI5pyNDmP83HW?=
 =?us-ascii?Q?Bk0eJGzeP2GbrUe6YbGP6GwF2UI0mlY1LEcMtmxbTjp3dWh8goW9ddhJ3M6U?=
 =?us-ascii?Q?gbfQcuU/Xyg+q+fBvVSJC0+v2PSyHSR87hRNtPQYpYaysv/EGaowdNuU/OQf?=
 =?us-ascii?Q?Thv8mzfjpUaLKIJndz1XmWOH?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1cd406-13a3-4d3f-26af-08d9448b8cb6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 16:47:20.3485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vfwlA7QVwNLzMV7ubF1MidxnKtvwovkDTFB0wGtZdLyWCisT+7EtXUWGnmZnRSN/7LKqZ3gDMhDCth7eBoVqWRhsFdE/wEFZ842A/dB7G90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 11:06:28PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 10, 2021 at 12:25:57PM -0700, Colin Foster wrote:
> > Add NULL check before dereferencing array
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> The patch is correct but is insufficiently documented. In particular,
> people might interpret it as a bug fix and backport it to stable
> kernels.

That makes sense. I'll clarify that it is only something that'll affect
future drivers and not a bug fix.
