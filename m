Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67838475777
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241979AbhLOLLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:11:08 -0500
Received: from mail-zr0che01on2115.outbound.protection.outlook.com ([40.107.24.115]:55136
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241988AbhLOLKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 06:10:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hwk7xuj438KP0JIXqlJMWfCWwxWHyvO1c2dqCDLw+tNa3NlZFC2letc/SwNkKBnLx35gG7UQ0XXcLQUPmw0Y1YHvb1giqoqg/+FGS4pbpvLh+1t1aSR0jL7HCgOr0BeoCJSXrVPAfFQThK2fUCfiquLZiSJ22MvSLn5OgH0edg2S7/BvfGjxVyW0VcEg8IfG+cKbi46pQ3UOY5Tp7i5ANoT00uvyejWC07UzHNcqWHG/HDZMApTCFDQCCWZx3AKI08HuPBwgSUiWJvy5/47LZXceqUSyLODzpTNQbAMrzDKT+TM6o/9z+XzD2PWsa4PBt4tjdwu3t5Kl7QBlt6742g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yiUWGd1tkNSnmK00+JTPlswg+mhd5ZAhTsRgAeBwXHM=;
 b=f1Rbwm2xxqvPo89kKRKnnnmH7xjxKwmqVir8fjQC7Aw/UN3evZPmeAOFF1Ejta8zk+NhvkTul5zY2nefXi15GorAc2mYByCUoZct8dnlKbW7WWYtyaI7jun29psVP/gSTLA6S1lG6QW4hl4RYEzXcEmTd8O9OMm0EVGjEnX7bcKCJxiLlr+hrtsJ57/6+kSGII8frgEXcyIrT/1gRP6LT6IsVlyG6G/tZi9aXpjNPS2gL7LnkPrDtRzR6I9v8AKBda0G8sqAap9M93hvUMhCR03Cw1vYoIWoRMkG8yryI0ly/Hc76E5wpRCbXv0Q7M3JvxUHbhRDhszAlVBn15Owtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yiUWGd1tkNSnmK00+JTPlswg+mhd5ZAhTsRgAeBwXHM=;
 b=HTkcFPIRJpmh46nxiA6GoX4DJsRfpBwLJmU+FDJyPqnh/jjbEPtENK9tjxRj1JLPfB3O3s0J5UD6dB+0gLEt9cDySjVKWm4RI3+AzsGebfwgC6ALYg3d8p9KPGbA4I7KnAA9NH1cA3gn+nR012b/jNE7u0K3Vf/QgB6kaTIP5Mk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZRAP278MB0285.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 15 Dec
 2021 11:10:52 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 11:10:52 +0000
Date:   Wed, 15 Dec 2021 12:10:50 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <20211215111050.GB64001@francesco-nb.int.toradex.com>
References: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
 <Ybm3NDeq96TSjh+k@lunn.ch>
 <20211215110139.GA64001@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215110139.GA64001@francesco-nb.int.toradex.com>
X-ClientProxiedBy: AM7PR02CA0017.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::27) To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f4df54d-f76a-48e6-f7a2-08d9bfbb8e87
X-MS-TrafficTypeDiagnostic: ZRAP278MB0285:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB02850A33419233045509BF2FE2769@ZRAP278MB0285.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6dicvGJ+59J7olKyqil4UF48HKOwd5QHrjM25M3IEbj1M3iHA6xsrwRzMTHkHYfVUUuBk35ufu1S/eSlxc8Hq2Se7wu+BxOjjhKBqfv1CBNlimfWLVwc6+vd1LS6uVEJwQpq6t9fJF7onkpmjSQPEAm/4zz4UGb1I/BtTUdmBz+90HEFH8hx7tQ2p6sse69LOFguS8YYBZ8ELTYV6sw0RSBZ1HfBV7VZe5TZJ8OCHNEUqO/EpUb6xHf+idgD5C01g42lpr/NwF2t1BDcKUXfyzSE8qTaW1xmMjg4VKmEyLTLv3pqXeuTb1z/uWhRcjt4fObSxFGsCV+LFBs0q6J3xwMZ6NDahQ2z9aabccnV+pezCkpOijgNxY385Q96qGBv1kAB9nZ3HyEalHxiou2BOCB8o8wWvIZdsxMRf9GlIHnlS7z3+4TQNGsqGUEqott7TKv/dvQahKOBP77fMUneEa2N4txnl04TT5Sjiunv5V+vrlTeNGiIj/aHeR7MNN+u8HvfvCfIl994ClE1GW+dobHvx0+fTzbQ3/VRuUa2/QTRYwATGAzFRgb7WvspeYlCjOBrDxYW3jjA7TjtzszhyAzNyw+VAvaRbaktogNsJoBn8ZxX7ClP0GbGYM6P1RO46/0+cIScf3st1Mkr9HaGyIfEklZtR+wLJb/pb1ETGz7cndy1XGnr2ccHRbIfwD5cMuvWa9FHjHt4Md5whveaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39840400004)(366004)(376002)(136003)(186003)(558084003)(66946007)(52116002)(107886003)(66476007)(508600001)(26005)(5660300002)(8936002)(66556008)(6506007)(2906002)(110136005)(6486002)(44832011)(83380400001)(86362001)(4326008)(33656002)(38350700002)(6512007)(316002)(1076003)(38100700002)(54906003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T8IKOLuKyT8Tg0KSsS0V96I3I2nPVDTEj+SvvgSL+iWG0mEcCKafm/HYS60n?=
 =?us-ascii?Q?7O/MTMPonn99RM2wDNRviEHMjTT3k3lnECKNPl0V19q+KaPMbKZjX3RiwWt4?=
 =?us-ascii?Q?y3fmxTXS6UN0LVz2UBL9uItIxUNSWPBEN9sTOmZeb7r8YN/zjG7tzP5iIvJl?=
 =?us-ascii?Q?m7Vc7WaOMBfWcOUu/hGEUVdOr6gI2V4IpdM6e7OJYTNlWp6JBIQVQvgC85wv?=
 =?us-ascii?Q?5Poi6klIEzI7UEayH+tCeAV54f5Wi2sr7ZWIbMjpI0PR2M032QnWlzomhXg3?=
 =?us-ascii?Q?nMlgbOy39lqvpCIeC5719tKpke+42pthRZA/LGZFcwimSGg/dVEZNcmIQgU+?=
 =?us-ascii?Q?iAnRcZemmuhig20tHfBDonZRZvW9nSelWY9Tmu8uDhLJGAfKqTk6GAl6GRe1?=
 =?us-ascii?Q?JuRh6sO0qufimaKFarU6lpWdSzbJ834Ix3Ec1UPM1PsstCeFJSoFun/S3zy6?=
 =?us-ascii?Q?E1F5p9ve+16sR3WWxU72RTmiS4RL0ZcMl3jcKYu4q060spih9UUV7Ypzna/J?=
 =?us-ascii?Q?JIDL+Ab1JTZ8NU+6wh/90Kd/NKSWEs/8IybivSCRBHw5Zm6EjdG5B6o4Fooi?=
 =?us-ascii?Q?gwtvHH110GjjYAsUHbkN9V01k8tX9mzXOycrO5ddrrVRLs5lrd4og8qVWKIB?=
 =?us-ascii?Q?pgmnO36PVTWvpYyEYrGjOMlTJTUNNsiql0OpXRhWph3DU+Ie1dNF/1KMswNp?=
 =?us-ascii?Q?sOS08i6MJ8D1LpwAQkhb9DZon9sxQIUd6re74zh8g5PbZmz5D0qM8u6esn34?=
 =?us-ascii?Q?cknhXqb2NpXlIKUS4027UUf3vOndwdpe+kSACD/WeVd21TdBxFdd3hKKefjT?=
 =?us-ascii?Q?SWTpCid7fLM78UXKBdr4nbyD0Sgg49r5QZr9VsEkfxlga3gEVczvHbQD6k6L?=
 =?us-ascii?Q?Kw7dHotT6pMhVv3u8FCFB7ULtoXn4ooz+TuFppMJS6lXvIsEWTd3UT/EoaPq?=
 =?us-ascii?Q?S4RYS1Sk5XrLqqBxPlTYiYS9zyRusVei2ONkmQ6AZZwoM7b6BsFnatqXTFEi?=
 =?us-ascii?Q?6lpr8HpNeXufYAquk5aZ8pEbZT/i31PYUd5SKQo/ZtiIIp4F9lrZ5eLUj4dZ?=
 =?us-ascii?Q?6U8a+pN6kxy2xmlw4rlXAHbOMV9HAdVgUtsBBOUyUyw1QZTUbEpTTfM1cBIs?=
 =?us-ascii?Q?MtXXcqeJVbrJzC/wgi3nwd/ixBqycqTHauRw915Ru7ND8A0UQLRXXWWxEAiw?=
 =?us-ascii?Q?J/k05q6qC90M62WXbpXHSJ//O5IDbAxsY1/6+kYLyWzHRtwrdOiJ6XWOAlKs?=
 =?us-ascii?Q?7NGbMoUwgBBBvdqoD3R+LlgtobCJ1TwceWhoPIKFXwroIMLYZdVeKXWJDuSu?=
 =?us-ascii?Q?n6ESUz7IRaZ+J4GmT7gMRgS67V7xrhuGpaCMx636ePLDJ0C2pFMGsUY6Wx1S?=
 =?us-ascii?Q?RgODBG61byHUfKQ8enUAU5GN95nHB2K42N7VDg445RSNHEK7aA+uj1VODBFH?=
 =?us-ascii?Q?kjBjy6cOaUewzPox+fKfp1WpDo9ZCCkQiXWmYG1PZkXe73gATmB6z7sTNdDP?=
 =?us-ascii?Q?QcqUve1Q/Im2CTnNaky+Wgb7Te0EKc8WNGdNp2O+1u3RpGzfo0R1hWuPd5b9?=
 =?us-ascii?Q?4iIAqsCsvlt7pwy1HFBFgOfB+CgpQgCgPI+ZIlXfeVYS186GzenvwN9AjcNU?=
 =?us-ascii?Q?cJTI7LQfVzHSZL32gsoT3QEwp4eSMBL4LPjVY4SV/WvrwboLja15VzBF294k?=
 =?us-ascii?Q?iwHrAQ=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4df54d-f76a-48e6-f7a2-08d9bfbb8e87
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 11:10:52.1377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QC7w88FpHemM0Go+AFF8yMav3Jz2qu5KHrToj1M4Zk0LM2Ar+jPT7p5tHiB5tyG/CGHetEV41g+RZIXDoljt4sSeybm7V+daERiGTbklE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0285
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 12:01:39PM +0100, Francesco Dolcini wrote:
> Any agreement on how to move forward?
...
>  3. move regulator to phy/micrel.c and assert reset in the phy driver resume
>  callback
whoops, s/resume/suspend/


