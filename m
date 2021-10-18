Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEECA4316D1
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 13:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhJRLHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 07:07:43 -0400
Received: from mail-am6eur05on2135.outbound.protection.outlook.com ([40.107.22.135]:1345
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229491AbhJRLHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 07:07:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9F7M9R1TJsSEfKAYE8okt/ALpTyhcDAy168KAaT/6EIOCKfdsF+x/yXkkYHY0qaTc7NOQJQSwgb/7kXLWSCtl01HkI1uJW/h6uyangfjgOmu5srSXrtr0UGBHzgHL/4NMznV+qvz6eg+NMvgqKtxfcHf09cDuveYq8ygdXPqyDY0eFAi9sxsHJQB/L0fswlWVtinX3eqrzqM8jdZE3QX6VEuL5HAwsF2SlF6SQn8G14oA8rtZV/TjKTYUJnBGhFLCwuRtoRrWZ3EsP1Vov0c3bz9B2ucpgAthHrFr4Wo6+0Lq+rvzbilos7S6PxOt15S5KKzhXXUeQq9+EjohXncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Y6fnRl1BuyUJVyeiwucxfP6vEZH+yhY42N3iQED+NM=;
 b=AFPJE3JWTwphP/IE9Fo2zqZXVOi53XTD1rzlHabvc5RUyb8Yy59Wmcgb+wIg+4gJlvEYEXlLvT1JYkhGGXK98bdSlyhvM/yTTWodM9QNmqnWrXMnhzkn+Z3FBs5szkKaxpIA/WFEF40x0FfOcN00EA9wfJVwSqlE31mtlucvZpGuLVKtlfU1QTTx9VDcAO+j3xvGE88Y1T9rmukChCMzU4q3e4ZE4/m9wOesjQVFShirg9VATvLtlhAsiZVJk7fBIdcfKYYLXd8UaEYy4bVHWuZJh+QlKYCqcWXvzhk8AkitgnvZBdYcXYc8aQlZeitNMfKM5Kd12+rs8ZH9gzHuyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Y6fnRl1BuyUJVyeiwucxfP6vEZH+yhY42N3iQED+NM=;
 b=nR+NqpfwmL8hJxvIcKkjuFOe/98W/aMLi14552LmLVjz6taL0yXQ4DW1KR/76haCHCb9kwEO8r1Rbhrwsae8XDrW4Th2ENKszpCNpy18cehoja5JyMH5w4d0D0fLQz9BiWHDoq1ic3ANTaHRzsxzgs+bLaZGOuGlvOrzTsPw8tk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AM7P190MB0693.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:118::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Mon, 18 Oct
 2021 11:05:26 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::a861:17ac:d33c:4347]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::a861:17ac:d33c:4347%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 11:05:26 +0000
References: <20211013104542.14146-1-pmenzel@molgen.mpg.de>
 <YWhfsiA6Vngi/1l+@shell.armlinux.org.uk>
User-agent: mu4e 0.9.18; emacs 28.0.50
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfp: add quirk for Finisar FTLF8536P4BCL
In-reply-to: <YWhfsiA6Vngi/1l+@shell.armlinux.org.uk>
Date:   Mon, 18 Oct 2021 14:05:24 +0300
Message-ID: <vrcxh2o87ma8zv.fsf@plvision.eu>
Content-Type: multipart/mixed; boundary="=-=-="
X-ClientProxiedBy: FR0P281CA0072.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::9) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
Received: from pc60716vkochan (217.20.186.93) by FR0P281CA0072.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:49::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Mon, 18 Oct 2021 11:05:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d51c042-596c-4260-4c00-08d992273027
X-MS-TrafficTypeDiagnostic: AM7P190MB0693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7P190MB06935789EA227CED0437CD1295BC9@AM7P190MB0693.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T4FFWE/uVkl2rdOk9s4STREWYgaRRdk8+/PCEqSoS481Qk7PpXWAwR3JKqGhn5EgtHxQnVv5n+2g582SvgySFhyByrKL1fDbAvGRlfeR1uFeyHE9eH9id+TzS3vUibO1COE8oeW1kwAVKkoD6SWr7IcnCbVaNkU1wV+O8PjDh6QsknknP4njSXc21sh9TsdwYcTbeGK9V8ksMQJ3kBskNQXmkdg3S1ALqlXCF9eOJygvkqL/n5ml6+sSrtPXI8+G6qiczV3UOtnyY8D66hobRgF2Lnq4WgC7vGt37369vSB2Pjo69C17sS3znMG33aCE4kYspwQIZCDjwXJJYdVHa7nAzyLuHHBvWlPQxY+k4YnvURBWH+10/I1MXv/6BWip5EiaTDTcI+a8runSPKwGQmeqGWpbhsiH++/aGvzvO+FODaAcqBKkwfs1ziSx0mls0oHzDy6LXbOWup+HkrHgRNExtAMQY6r/+S9uNBU6ejhhhOLb6RYXL9KxAPgdEUZ1U9IPh/YCu2KSL0QVYHiv58xUnjdZ3OIQWwpZPR7ZvvB40Te4i7pyINq7bOdQMk11f6wXBpVrCiW1yjCEBWcRIlymUfNndmJZJYzEOTzJcDgUDExMWmNT/PfUbgX0B915jKaYu6CXpLSU2izJBpg6GLfc61BjrtELKoye15SiAjIyKy7YDzRSkrdUvhDJwWs7NzImfUdpCQyPRype8XGwg+BDeoEE1jtkCzLtV/7E9s//rc9xkcDdPi1sBCGIx44H7sUtH5dRfet5mf1kgrc7bhODuppE4atwqK1THNCT5iuuEkyN525UtGpEkHaUV5IC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(39830400003)(366004)(8936002)(2906002)(86362001)(235185007)(316002)(38100700002)(38350700002)(956004)(54906003)(6916009)(186003)(508600001)(36756003)(26005)(5660300002)(66946007)(52116002)(8676002)(4326008)(66556008)(66476007)(6496006)(44832011)(966005)(2616005)(6486002)(505234007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q6b8eXUiw8Q3ryHhzmd0Gx+ppvdeG3dINZY35YFzjQeHM+8pCcDsB+7c95dT?=
 =?us-ascii?Q?nJz9fby24q3t+3dScKk0vRp13MxJdvebZBpoKX76RRhKxOXhGrBRfqsFIPuo?=
 =?us-ascii?Q?3EDpnwO3hNhMGXM+2OZpAoWqfz5qdfnQllmjx6sAOvo9p7Vc2+/deIK878dR?=
 =?us-ascii?Q?fMr1D3xvLH8J0a/zy6sVJCUTf0wDlXg4FxX/TxGnmVjSjrpMPEVh2HWaKeh9?=
 =?us-ascii?Q?6Sx1/okxoOY049sBTfQhh/4JuhnSMbrxD70qQ/MUraa3rYMRZF652BNym6CE?=
 =?us-ascii?Q?H+jP0gWomElbBeRuKbPQGdkaMKTRLtR2igdiHpuzKXYV9e8b8RDnkFwPHV7C?=
 =?us-ascii?Q?qIrp0FTaxNQsA66wed+obDxOWwOxIclG23QMk7UPh8Z8bIeUwLIUC2tK1jPg?=
 =?us-ascii?Q?m6t8PToCR1cnnU/QLVwaGrCRebeFDxxW2yQikH2q9gFxyuvYu4W2SY47YhY9?=
 =?us-ascii?Q?k+0W0mUiMgqg8yMUvnKupTL2Pu+YK6qdshKVX1eeml5eg4X7lH/yfM45EO5J?=
 =?us-ascii?Q?Qp7pr9xMzYQk2WEgpw3IFDjk/sOj28EgB9h6qU7kXSvJ1CDook/FYTJjkq4+?=
 =?us-ascii?Q?Qc5VAltQYmtVYNUzXY1fgfyoUYLFVLYn1bQK4lx3gTIpY27c23PDZjahhjHb?=
 =?us-ascii?Q?nK2C2NiPkIql8C1xrYGTUbE/472WcPoDJQ9vlIrzaBOtfExDiN9FtPFdXM1I?=
 =?us-ascii?Q?YQltez3MsgOtSznlV5we/YNixawaMJDRwgMe1LF6VpbNXtYDJQ5XPCvfpyFQ?=
 =?us-ascii?Q?rwMeOmb1q8EASk2aBOb+j9HBLYRLqhdpPms6ZJDW43Gx/VpbJfTXA53EeZsn?=
 =?us-ascii?Q?z6Xdu/jBYddBPnF2yaqzOXc8wrCYDXb/FSfedF58OYNXqCP0sgtsT4WacNrP?=
 =?us-ascii?Q?N9PBQSqRUotaeY8Y+R32iz/jDxp5Nypmnla3MgJrCAilM+i2kvRg/Fhjbajg?=
 =?us-ascii?Q?1Ma+GzZvMfvxbaN6lWU4IziQrR57/xbmwf+TV+ga0yRU03/dByw+u3QwEhRZ?=
 =?us-ascii?Q?k9AEhLsZRZbPgQ1yvos8B61C83cY0fPV/4xMWX/imaOu9V2G48sJ1lfR3pvh?=
 =?us-ascii?Q?kWIqkfaNQlwkTimz1aF6aR9R3igPgbi+3jskRXw37EQZEou12SnXUC5XyZZA?=
 =?us-ascii?Q?Aj6zTwHXVPCTbDtZW+q/fC9cm3ECa4rP6kZLR8UA3kDHy9hulBuD3AIZeIjc?=
 =?us-ascii?Q?OHvyzCAnuFf09GtNDGsivPI39ezDgcGyloT7NQPiS/qVG6r+N8wvK9APYu8a?=
 =?us-ascii?Q?a6RLEWfZ57i6yRbfv1MH/CBXud9UIrYJu6jIEFT7b3jApXsAci9X5Sr6md8G?=
 =?us-ascii?Q?WW4QKeWGH9CUB2UrZpP9lZ0y?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d51c042-596c-4260-4c00-08d992273027
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 11:05:26.1356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cs6ahOsRQBB3aa1axrCe9oCXelArlYJJkRIJ6yqfxTLZaGKt1cEGmkjM4aRpqjbcFOyNlUuwR31j/UsQJyG/9Jd9N2lus2AndPMuit2uwhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P190MB0693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Russel,

Russell King (Oracle) <linux@armlinux.org.uk> writes:

> On Wed, Oct 13, 2021 at 12:45:42PM +0200, Paul Menzel wrote:
>> From: Taras Chornyi <taras.chornyi@plvision.eu>
>> 
>> Finisar FTLF8536P4BCL can operate at 1000base-X and 10000base-SR, but
>> reports 25G & 100GBd SR in it's EEPROM.
>> 
>> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
>> Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
>> 
>> [Upstream from https://github.com/dentproject/dentOS/pull/133/commits/b87b10ef72ea4638e80588facf3c9c2c1be67b40]
>> 
>> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
>
> Hi Paul,
>
> Please can you send me the file resulting from:
>
> ethtool -m ethX raw on > file
>
> please - it will be binary data, and that is exactly what I'm after.
> I would like to see what the EEPROM contains before making a decision
> on this patch.
>
> Thanks.

Attached output of ethtool:


--=-=-=
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=FTLF8536P4BCL.bin
Content-Transfer-Encoding: base64

AwQHAAAAAAAAAAAG/wAAAAIACgdGSU5JU0FSIENPUlAuICAgAgCQZUZUTEY4NTM2UDRCQ0wgICBB
ICAgA1IAuAgacABVVUgyMEZMICAgICAgICAgMTYwMjEyICBo8AhkAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEsA+wBGAAAAjKB1MIi4eRgXcAH0FnYD6D3pBOsx
LQYxTfEAZD3pAJ4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP4AAAAAAAAAAAQAAAAEAAAAB
AAAAAQAAAAAA9Cbxg7YAUQAACsYAHiRLsAAFKAAABSgAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=

--=-=-=
Content-Type: text/plain


Also adding hexdump version to have it in mail:

00000000  03 04 07 00 00 00 00 00  00 00 00 06 ff 00 00 00  |................|
00000010  02 00 0a 07 46 49 4e 49  53 41 52 20 43 4f 52 50  |....FINISAR CORP|
00000020  2e 20 20 20 02 00 90 65  46 54 4c 46 38 35 33 36  |.   ...eFTLF8536|
00000030  50 34 42 43 4c 20 20 20  41 20 20 20 03 52 00 b8  |P4BCL   A   .R..|
00000040  08 1a 70 00 55 55 48 32  30 46 4c 20 20 20 20 20  |..p.UUH20FL     |
00000050  20 20 20 20 31 36 30 32  31 32 20 20 68 f0 08 64  |    160212  h..d|
00000060  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000100  4b 00 fb 00 46 00 00 00  8c a0 75 30 88 b8 79 18  |K...F.....u0..y.|
00000110  17 70 01 f4 16 76 03 e8  3d e9 04 eb 31 2d 06 31  |.p...v..=...1-.1|
00000120  4d f1 00 64 3d e9 00 9e  00 00 00 00 00 00 00 00  |M..d=...........|
00000130  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000140  00 00 00 00 3f 80 00 00  00 00 00 00 00 01 00 00  |....?...........|
00000150  00 01 00 00 00 01 00 00  00 01 00 00 00 00 00 f4  |................|
00000160  26 f1 83 b6 00 51 00 00  0a c6 00 1e 24 4b b0 00  |&....Q......$K..|
00000170  05 28 00 00 05 28 00 00  00 00 00 00 00 00 00 01  |.(...(..........|
00000180  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200

--=-=-=--
