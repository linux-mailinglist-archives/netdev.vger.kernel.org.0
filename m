Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FC22FF747
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 22:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbhAUV3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 16:29:53 -0500
Received: from mail-eopbgr130117.outbound.protection.outlook.com ([40.107.13.117]:16983
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbhAUV3t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 16:29:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1hU6yso5ONk/L6S3KEwQ4+j4Ra5Ar0FBi3wnAbIgOh4e7yJ5N8eWQMHQEvyOkgaaBzttPlsLOVirjvfJwtdjltEw99T/CLhF30DJXEU9blQUUUxvrnnaK/upz9J4MFsll7MB7cdNdHowqDOPMv2A9FzT9qcs6vGXDNcAMIShPhAKfqCpFrsxdtB5QZCZL1qdXQyv5eRyRZXUGQTwUVw8Vox69TKVCdLBVAy/guB2SdOCQZkmkGWAp2jahS33wrHD8EUwrnOXY0lqPCBbOPqwv5Nucbh0Aw3xyblq9Dlr1G1JcDqpEVVhUNTIL4zEXZsltzoIxM8aKk4d26OPjkqfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sdh7VQ8Xrk24wtzDDkJJ9jbk6TXVfMId6hm3nIYgsOk=;
 b=HGawsdHW/Dd4qdvwt9GxnDMzxy4QVZt+nzV2RcHv1zANb5sT7o8e1/v20VLcRpMBITnsF/mwvgtgzpfgjQyR10/RTwIOXBGzGWkdzttsy0yVx9f+dLufIFelP5fnq1OpnS5tWDf4vgYgCyICDhvzcIp2LqnYzb+2yKVeGVcZUUETZH2ksaBlD2VicEmMOjkh793iOx6wlZPRf+5X9KmTh1UNB+lzM5/AmZ6Jgb2ejvDOrjSO4Be5P8iDjTlHhCyD7+FpTaIB+ikbYYZTk8ASJrcywehwVA/xmx0FDo4iqoHielT95s5JkDlGMnyiZGyND8jl0Kpn75JbuoKJLCorfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sdh7VQ8Xrk24wtzDDkJJ9jbk6TXVfMId6hm3nIYgsOk=;
 b=H0how+42PYIclGqXxoQjDCWlTe4BQf0YQ1RLOto2fD58lfKh/NcQqpfA+kfvYHOOxTxLkKuUxcbNzsXZ8Ml4ZD0KTEHcKy59uOobdphycoUN2DoJt5qn9WdV3Vqv6IwIFFYH1BF2HQM5JSVMBRZCpumWSf/b+gnPdSy1/B7fTIk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3507.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:159::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 21 Jan
 2021 21:29:00 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 21:29:00 +0000
Subject: Re: [PATCH net v2 1/2] net: mrp: fix definitions of MRP test packets
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20210121204037.61390-1-rasmus.villemoes@prevas.dk>
 <20210121204037.61390-2-rasmus.villemoes@prevas.dk>
 <20210121212340.dtvdkm4nnqcqjhss@soft-dev3.localdomain>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <ed160e34-e515-e2ec-aa95-d5176ecbc4bc@prevas.dk>
Date:   Thu, 21 Jan 2021 22:28:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210121212340.dtvdkm4nnqcqjhss@soft-dev3.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P192CA0011.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::24) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6P192CA0011.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 21:28:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6459040d-bbef-4a31-84c8-08d8be53910a
X-MS-TrafficTypeDiagnostic: AM0PR10MB3507:
X-Microsoft-Antispam-PRVS: <AM0PR10MB3507F61C48592A2AFAB0312793A10@AM0PR10MB3507.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWXreGZko8itvSNvJk1Tf9eSWrXTP3RrJmfLVZz8m1EzPDScAKdOx/doiJPvrnHGWCphRphhQGyJ2Fc/LLnexXFy9ekkNT5Iyf5sEiwU5WOWi74mJFeIrBhArHtrr+qNVUSQ01+Hb2lFWTrsIx+WJMJ55aI6paxIg6BTEzGtv/qDVbTAUExHWZg3IvN7BFgmBt1yKbpgY9KhtTC9q9CAGPmaR9JLmeEbKR7lKWnSfnIKvnR24Ov1UUjuStf1+REgevra3Z3OXCgMxLhQXipsJITdeu7QDOWOe06/uqdZXUSI/g2+C9tRgTzA2UcP41Aug318zzezSlI/mQ6Wt3d58kyEGs0RRw4Z/y55BQRJ/cWM4iIlUTfz8s8STnK47wnjSycR94YrdhKJPeqbzwnA3CGa2BC8965SRVqjPwUpcP2RGM/TBkRdY4M2QjNWQZ5xd8CT3Dw7Oq1D6nItTV0aCiN9h+n2cfmL1FhSmUQyfyA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(39840400004)(376002)(366004)(8936002)(36756003)(4326008)(956004)(16526019)(2616005)(16576012)(54906003)(316002)(8676002)(26005)(52116002)(44832011)(5660300002)(66556008)(6916009)(66476007)(66946007)(8976002)(186003)(4744005)(86362001)(478600001)(31696002)(31686004)(6486002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TlpjdEp3NHd6T0Y5VElIYW1EV1lndytXNUxvM2dybnN1QUgzdHJTUjkra3VQ?=
 =?utf-8?B?NmQwYUEvS0RBNDc5SzRERGhOQjNFQnBLMjQ0L2U0aHNRUGlNUkllejNNaGU0?=
 =?utf-8?B?MnVxVlVJTDE0aVJ6bTBNVTR4N1dNMmJENTVVUXI1ODR0VzhaT1VsUEZtbG9P?=
 =?utf-8?B?RDVxMUU3TUNWY0lYUHRjWWRUd0dpUWlLV2poSHhjZFZreVl3L2RxMGlYY1Ux?=
 =?utf-8?B?aGwxM25TQ3E4NnAwR2ZXQlQ2M3d0cDBuTGZZZUJQOHdYK3g1aTVLZW4zelRZ?=
 =?utf-8?B?dStUNlhIRnp2cnpRdzdJUHJPaGFuQlZhWHFxR052dVNiOVF2SHpMNUxnUXdD?=
 =?utf-8?B?UG85SmdiSTBRdXlmZ09qRncveVFsSlo3dEFXMDV3Z3VUY1BoT3V1WDFranRt?=
 =?utf-8?B?Rk04eTB1VmtncTlQUGVQVVR6OHhzN2pEcWIxcUxlUzNJVVQwVFJ0YTNkQ1Jr?=
 =?utf-8?B?V0VJVGJWN0IreWlZMkkvR3RvS1NrdithVFRlUlJTZTJIdGk4d01hSmFrQUxy?=
 =?utf-8?B?ZTZqN0liL09JYTJic2d6UFJhYzJwdXlJQldjVXdpcHdybFFuT1I5L0tvaDRQ?=
 =?utf-8?B?TDl0cFhTK01lVi8wSmREa0oyMmRXTkFZUjRlQnMvclpsNUh2NjJXckpoOUpD?=
 =?utf-8?B?SUcweTlnalUvOEdsZmVHZ0RNcklVd3VQejEwanBidXdGTkMrQWE1MzFTVGk5?=
 =?utf-8?B?ZzJMMHVtL2tvd2Myb09Edy85RWZEazdLUDZtaXBubkhuamdzUCs1S0s1eU5E?=
 =?utf-8?B?d3Q5d0hOMGRRSXhEUFpyYnIzOVh3cFh4TFFvcks3R29Wb3ErSUlEdzlJNitn?=
 =?utf-8?B?OWpxbStRZU5NOG5ERU1hZHFMYTRKL3NzWkhIYkJkQ3p3em16WjZwYmpWWWhQ?=
 =?utf-8?B?VUFuN1NYQU0wdFNOSTNud202OStBNTRLbDJXcmFsd3V3MzJFckdneXVvbFpE?=
 =?utf-8?B?NS9rai83ZEMrWU9tRFRPd2I1ZUtBMkVESENuenlJWGdYaFc0ZFpWOXFJTFJh?=
 =?utf-8?B?TnJaV0IwOEJaVVFkcDYyTDlFemRQV1FLak1BSWhEbTRaWW55UDRUK1h1WDRu?=
 =?utf-8?B?bnRZL0pYbnJNTThhOVJ2eDZGNTZxKytKcUlqc1R4NGVuZ0hXSEEyWkpEV0p5?=
 =?utf-8?B?UU8zNk05L1I4cHUwK3dBOHlKZmZwWDZIYUVBSXJoZXZCSXVtWnNob0VXa2Jz?=
 =?utf-8?B?aW9ndDBOUkxucDYrRGV0dCtYS2pUNjJCelFHQncrejErenJxZ0ErdWFRTXNw?=
 =?utf-8?B?d3pKWDFoK0lOT3JobXJNWmhHdG9LVndyZEJOcTBVeFF3VEFXSVFxQVFPeXNM?=
 =?utf-8?Q?H7gDOspljiOWZyG822jtYlv/t3X0jnefY2?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 6459040d-bbef-4a31-84c8-08d8be53910a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 21:29:00.0692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UKeFNe9H/ySKR9v+X9WONFGxKqJDa5ISfh7buc/Cw2phjYUTwVvbJeJ4fUm/wUesXYrw4pFoFDsEgPmCjgzMPJ0PdV0D7AbJOPnsJmd5NkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3507
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2021 22.23, Horatiu Vultur wrote:
> The 01/21/2021 21:40, Rasmus Villemoes wrote:
> 
> It seems that is missing a Fixes tag, other than that it looks fine.

That would be these two I guess:

Fixes: 2801758391ba ("bridge: uapi: mrp: Extend MRP attributes for MRP
interconnect")
Fixes: 4714d13791f8 ("bridge: uapi: mrp: Add mrp attributes.")

> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Thanks,
Rasmus
