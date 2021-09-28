Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2C041AE21
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 13:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240456AbhI1LwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 07:52:16 -0400
Received: from mail-eopbgr150043.outbound.protection.outlook.com ([40.107.15.43]:60032
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240440AbhI1LwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 07:52:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TORwUQfF7HU5c32ijZxXLfNsLeT7KqBW8AH3CFj8rscrDVzUb464i/xg+VIMugqBpPMaXo3GWpivTel+zQazp19T3C16Vhaq49Z+dBjS43zfOJpwaYDyy/962stcxbTmxH7VoGYphV1B9COqi98cHP60DjJLZtYK6912dHhudat///tTcINbByIvBnm4BvECSTL/KBEIefjKyPfb4tGF3C321RaL46dDSsdF/xJltKf/iGga2X29LInobiytdf81Hw3sl2BlEJMJ/aYSxLlvcUwZyjCKbx/kBIZpzfw3PFDHT8IgI78cdl4fj3J3moY/OlcFQgdq07p9r66wjsMDXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lyd6Jt657gX4U7h5j4ejWBJGf4y5acuYvEjHm5DDZLE=;
 b=c3ZTXd/ppFHcRpYGI6u2tgSl4zb6ozU7UJDL4lrUs+Z+QJkyxFHVKbkloY9ZrUAJKj3THRB61pIfrzRzONZkDgWNCSgf6PMkbD1qjEc9fUMv2liKHEqO8S6dQu66o2Yv1Pi0SweI3mH1gR1FXRJtZ1MUD1hiJvJs0hftm6O+n95itVlsPg6iJwuTGxeETgvFYJvOIesP7CCmFarLUFMOoU85je+Fs73+zMUeCcoilly4vOkZgX6CJhiZ5P0bPWOpJZCAQ8kgZL16oEdleafJvsOQOwaSte6mL5ALvvRVAAkDr4pw2Rox4VtSaR6U8Db7rQrjdB3bkKbggmSQsLwLqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lyd6Jt657gX4U7h5j4ejWBJGf4y5acuYvEjHm5DDZLE=;
 b=eW8dau3ijnY5rhxtCdyBGmd6W4w8QBM5NtuiHytngHEUQO2Zmxq2uKLJYoYZzkvYjtJaftl5bBGMvCDf9ymQPHnre90XWHwNIcC31RpuPFuzH3ZdGBsf9udHusqkw5QttI16Ajvg9fZYIaIi07p10g1uo+sCkHnBzLqC4U3Xqh0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10) by VI1PR04MB5773.eurprd04.prod.outlook.com
 (2603:10a6:803:e6::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 11:50:28 +0000
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b]) by VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::2408:2b97:79ac:586b%4]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 11:50:28 +0000
Message-ID: <98a91f5889b346f7a3b347bebb9aab56bddfd6dc.camel@oss.nxp.com>
Subject: Re: [PATCH net-next] ptp: add vclock timestamp conversion IOCTL
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, yannick.vignon@oss.nxp.com,
        rui.sousa@oss.nxp.com
Date:   Tue, 28 Sep 2021 13:50:23 +0200
In-Reply-To: <20210927202304.GC11172@hoboy.vegasvil.org>
References: <20210927093250.202131-1-sebastien.laveze@oss.nxp.com>
         <20210927145916.GA9549@hoboy.vegasvil.org>
         <b9397ec109ca1055af74bd8f20be8f64a7a1c961.camel@oss.nxp.com>
         <20210927202304.GC11172@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR08CA0026.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::39) To VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SOPLPUATS06 (84.102.252.120) by AM0PR08CA0026.eurprd08.prod.outlook.com (2603:10a6:208:d2::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 28 Sep 2021 11:50:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d433c3f2-fbd7-4d45-0db9-08d982762a1b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5773:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5773A54D6EB1CA31736B10C5CDA89@VI1PR04MB5773.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: usH0EwWgqxAb2fCniT509nFbKGZb+TXoblgCyBpb9ZdRPjczPXuhOw6cexloXaIuXK7/AY0teEGIFbx1BMoxu6Fcqvxx+f4ywkqY+8Rf3YX9xRl50XLaO6vClJAgvpmw/u47qoMuGL26LXXZGFuJHoN42xGrUQMYkChSLRbh+30yIKP6WeYpiGQwuTH6mxeJShoXxAZyq8l7bBR83nL4MZKzQg/JMRoy1jbRMCUxPkgzIjc/rWGTNpONx1CVl/aTtGVHYD59JnyXec9tBjwJxs+0SxgW1SXo99rXNtxytWq30rrY2u7oxWBO0f9OdK7TSyUobPcNLbWKS7UZNNbBUovnshweWUHTFmaT2TpDC4L3QNls2J+/bOF5eYN6Ejde85+Vtp32kJsMJHeWry1IAVp/sy8PQeMV5er0e2cIdc+fGAVYFuVlkOguI+PcJYOPSi4ZLc8gmmYCIZHKpi2/8fYD9N4BRL67Y10OFh95RJjC3AUXWyGoopmDEBHbTTmF4iohN2xJcP/mofIbD25LzfSe9aSRlCN2XbVIh+Ih7s1ZD5u70D7N1aaz+CS98wqFn379GuA7JobBbiSyIAIjQuV6tADvNHnH/JnXZAL7bfzMPA8Q9OPedjqO0UZRP5Htsx47W3Mb5Ko2A8PJNBMevLgea8O46vlTG+kF77addOPEs3rBs80ZUlezsJN8X8EQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(5660300002)(26005)(38100700002)(4744005)(4326008)(498600001)(86362001)(8676002)(8936002)(186003)(2616005)(44832011)(83380400001)(2906002)(956004)(52116002)(6486002)(6666004)(6496006)(66946007)(6916009)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUVVb0pYdCsvNys5RllqWjBEN0VyMnN3K2NHRlVqcXEzWDJOOXZHdzQ4bFVD?=
 =?utf-8?B?MnFpRHQyWVBraDNkckxmK3BtM3ZCelVNaUdaYW00ZGVsaC9aQUpTTmdSSTlS?=
 =?utf-8?B?eEZVUVRRRWhsUG5pbUZOc3o2YzZ5SWhzbTRTaHRBK0lrL210dmd5NHlkRURN?=
 =?utf-8?B?eXRsQ2U5YVphblVUbFBBeE0wdnhNMGZ0UVI3NjVIT091elI3TXpHSHpXSStM?=
 =?utf-8?B?L0kxSlk5QWJrQzY1NmVlaGVLSmpqR0ZqampscmI2Ykx3U09xRmU5eDdUckVY?=
 =?utf-8?B?aUY2Z2RJV2lTcFRQVnNISzJPNVk3WVpCYkxoMjlld2FrcGhuNDkyTTlaUzRv?=
 =?utf-8?B?NERxSEk2b0YrUjF3N1FLbkdXU0Z0bTVabnVoM1hNY1VmcUNaUFZFZjYwWnhZ?=
 =?utf-8?B?a0x1U3F2M2hoNllHc0RHQThFSldaTFN5MllNcXN3TlpnWVhDeHlDVGZaYjhU?=
 =?utf-8?B?SnFDZ1dldXlITTI4K1I2WkEwTjhuQ3FmSkJFNVRuQjlmeEl0eDB0SmJSc2hR?=
 =?utf-8?B?RTByVVhOa0grdkhESWpzWi9pSlJEVEVBUlVkQ25TZVBPSEx3T2huWHphaG9p?=
 =?utf-8?B?WGR4WEI1SHFNWWNRZTlkTUZzbGtmenVQUGpMUjNzUmIremJhOHo1Yk1BdEcw?=
 =?utf-8?B?eUtMOWhMY2xZMkRGamNVVVFUaVRCdWVuSy9kNmlDU0g3Kzk3V2JvNWpIR2xZ?=
 =?utf-8?B?RUdnd3FaaFpFdzlmZi8zbzNoYmJLQ2JCK1BvUytvdGFENWt4ZEJTcmNsajAv?=
 =?utf-8?B?R2tpMEpjZGEyQ2JNbDE0WlRYU2JIVnUwS1dJdGNjWkgrMkZ2dTJ6RTdDdzU4?=
 =?utf-8?B?T0podjg2NVhsTE1zb0ZzOTl3OHNISlhzNlhHRG4waTBhemRuMVl3UElLemRB?=
 =?utf-8?B?THhMLy9VMXVDY2FaQU4zSE1BbEdHNGpmdWRFZHJnbkNyeUVrWUcvQWxnY0M3?=
 =?utf-8?B?OEhnVE5mcDlxaTdFQ0ZzWFAzQlEvVUlSUkdWa2xKaFZvTGx3RHYyazRUVkVw?=
 =?utf-8?B?amZNNHcrQklYSW5HNWVqUTBDbjRBejN4TkNsMVdKNTF2bHN2T0xpNTgrdTR1?=
 =?utf-8?B?SGh0MFVpTXNSc1VWQm9XTmdxMm1XQ290b2RwUWM3Y3RlZ05jRGtpbGNRMmxF?=
 =?utf-8?B?Uk56ZFRZSUVTNzB4dVZGMUJNQmtaNURzaHp4ZTdpaXc2UWUvZUEzL0JHOHJG?=
 =?utf-8?B?TUh4eGRqOEFGNzNNam81TmVFbGloZDNueVd5elE2MktmQ0g1am41U20zYVF4?=
 =?utf-8?B?RFdSWHVVL2dRU2NwYUgyRXhBQkwxY0ZuVSs5SUo4Y05TcC8yOWRFOVZMZ1FV?=
 =?utf-8?B?SnpWOFd1cmNXZHpoNXpWTlZhRVVhRndoOG1aT0hRSlV5dzQyQjZIRTZwTkYv?=
 =?utf-8?B?Z0R4SldzaVFNSFJnK3RiQStwTklxendvODh1QmVPbzA0QkhXMThucmlONFN3?=
 =?utf-8?B?VU93QUNRcS9KTzVCREhuK0UxOXg2VFN1R1QzNlJkOHl3Y0lvVFFGQWh3SG10?=
 =?utf-8?B?Y0pHak1RNy9aK2N0U0VoaW9JRXdhOTBLMmpGMHZ5TDJhRjl2YzUrTDdPRE1C?=
 =?utf-8?B?cGJIUlZHbjNza0xMeTZpcFQ4eVA5VUFhSkhWSWRVSTZuK2Z6NDg0OXZ6a3Ew?=
 =?utf-8?B?TGtrQUo0V2p4VEJyTmJoUWxYMENkS0lzcWc2cEkvRld6Ui92YWprSVBlT1VZ?=
 =?utf-8?B?c0ZqZHZPaTZsQzVnOG43bjdMUTl6dG1IVDd4WU14TTdsaFdiclFTc2dZTFRq?=
 =?utf-8?Q?nycB1VVcH1vImZDCg2SgaldCJDKecJCiUuq27IY?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d433c3f2-fbd7-4d45-0db9-08d982762a1b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 11:50:28.1450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxKrAXdA6VYls/8YfTuyjCjNN5g/Fjeu12ESIy+be5Wx/lz7LL8Zy9dbt8M9uSe31oYWHUr/JLV4j2+W5HlBu+Ixv5u2IDhgHsqsAIMhYOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5773
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-09-27 at 13:23 -0700, Richard Cochran wrote:
> What you really want is the socket to return more than one time stamp.
> So why not do that instead?
> 
> Right now, the SO_TIMESTAMPING has an array of
> 
>    struct timespec ts[3] = 
>    [0] SOFTWARE
>    [1] LEGACY (unused)
>    [2] HARDWARE
> 
> You can extend that to have
> 
>    [0] SOFTWARE
>    [1] LEGACY (unused)
>    [2] HARDWARE (vclock 0)
>    [3] HARDWARE (vclock 1)
>    [4] HARDWARE (vclock 2)
>    ...
>    [N] HARDWARE (vclock N-2)
> 
> You could store the selected vclocks in a bit mask associated with the socket.
> 
> Hm?

Yes that would do it. Only drawback is that ALL rx and tx timestamps
are converted to the N domains instead of a few as needed.

Before going in this direction, is this a change that you really see as
worthwile for virtual clocks and timetamping support ?

What approach do you have in mind for multi-domain support with the
common CMLDS layer ?

Thanks,
Seb

