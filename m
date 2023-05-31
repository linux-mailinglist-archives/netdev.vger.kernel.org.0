Return-Path: <netdev+bounces-6808-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C96171841A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F0FE2814EE
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB7415482;
	Wed, 31 May 2023 14:03:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1927C14AB8
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:03:25 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2061c.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::61c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A3449C5;
	Wed, 31 May 2023 07:03:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XvVIUgrC0WAG9Oq1IqAtNiXnumOJ8Xe0zIEr22o4UW9VrZPpqp8tWsfX0a/ZS5JtHwwNbP7G5KVGAknupyhElvJbgmrgq6n+wmH1vH5NdqKxMMNm18U/eDP4TIKksyh2HRpMbtfhuouGoKEgKP4ayZyWRLDDSbfbi/Wy2HxdbII5ol050wqOOwhJXBAeFU7EAXt0yU1yjoDIPmt01pnC//eD2/41adzgef8H85RREyDfjmnxTfkmf+bpRRL52Xt3IRu1sWclDMZGdwmLrhItML2/rDEggMvkNjUZ30wp2yI/g/unc6xW5jFhXdGAeMj0UT/B/oPfM7vvt1eo3n8OZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bASjZ1N5BVTSRoc3V/v4NoYifEDYAi4ckoA/pdY91l0=;
 b=Sd621u970KTyp15SwT9+w75MItV0ljEdEvT8lKHECBkhfYviGiMJXuhV4xe2vul8DR1LpaAcX6Gv8LP7EcjYKUWek921Y0e51/woCsUhFiVVgtQHl1mrmhhYSkSq/2z9b5YYTNnvCgzxO69wN8sgpT9mHHMZsUWOEaR4Jybv7rB0TNQ2jRhoQFENwSjPp1sapnWnOMx/6rOHtdg+IhW3mQpNMKJw6w0dVZPnzOVgoAyRxEQ2EyOirucvnzV/G7s0blt8Xo92y+35WdmMSFz9nDxNqmfxiOBxXPbrhScVPwz9iBwTr8a6B2jcNHbsBpiA2U8NSwA9xcR/KBApmFCg0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bASjZ1N5BVTSRoc3V/v4NoYifEDYAi4ckoA/pdY91l0=;
 b=gvvzEHovRZjB96/ymlAGvzGLSC5isgiNWZuANzZ7BlF2fbf+zgoUTzJQl49kZ/YO3xHXO0kUxxFFK/CUDbEp8AjpksTShn29O30Hsqvev4VWHgpQcBULz1etTrSqOVBTYfmxZImMaS7Pf3YeEbHgsrFZSuYKpqbc69RaPrRsWAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sord.co.jp;
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com (2603:1096:604:13c::13)
 by OSZPR01MB8138.jpnprd01.prod.outlook.com (2603:1096:604:1a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 13:57:46 +0000
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e]) by OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e%2]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 13:57:46 +0000
Message-ID: <70e70a16-76d0-cfda-efe0-9831ca3bea60@sord.co.jp>
Date: Wed, 31 May 2023 22:57:44 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To: netdev@vger.kernel.org, devicetree@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
 Alexandru Tachici <alexandru.tachici@analog.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
 Heiner Kallweit <hkallweit1@gmail.com>, Russell King
 <linux@armlinux.org.uk>, Horatiu Vultur <horatiu.vultur@microchip.com>
From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Subject: [PATCH net-next v2 0/2] net: phy: adin: add support for inverting the
 link status output signal
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:404:56::35) To OSZPR01MB7049.jpnprd01.prod.outlook.com
 (2603:1096:604:13c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7049:EE_|OSZPR01MB8138:EE_
X-MS-Office365-Filtering-Correlation-Id: e12dc935-d04f-4718-9b2f-08db61df0358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pN5diRwqorRqyzzgFoY6Vmzwnd2M8nXH1pS+QOWGPwGqtd2u9QP12KcLtPMEwcundcJPFCBTuAJkxVco21D/PTmHhMQ5i98jnpRO/RTk45znINWRH/I4Met5y9ZSPopWYL6TBvciLaP7WvRni5NZs6wrgojnq1w8GAWPSxv+nmXhdz++Xs+pmGuQMl1RiN4J9+gRWwHFFghJ2neF0mamwwXCz21TYJ4LfSWrfOP9eJOpXDTo7EBRFeFVnaHP+ff3bu984C4ZOeg8RoSCz91vAqJAj2UOxJKaMnD01JQkGMj/4W8tcquxV45zPFOfVmQvENmFuEgHUr0dTIj6GHNAKlHOwVkQ+6lLzsEn+LnU/pEm/yuJl6My2b+MYRRWBg6Tt6We9/NvE3JA2rZMPhqzf4fmHR85RT/btVCD04RW/DPZ1nemyFKfjB8LFZg8z36Z4vqAOaK2mh300T0yAioSAoVivHno2nqz93X9UGTFmQ5W8JRH7Lymqn9jUmaWmsjoMQcklGRRNmoxzRom40sby9eAecdGr0iOAkFz20d+bFsAXj7nyMB0uvABpL9A4+FdeoDiNbJP+Kg46sHBrAuro/iMzXbZRhXs5HqWaiNBZXBTWqj5EBbANKa/f/6r5dH9ThHxmH4UnUcNs/73R0Ar2g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7049.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39850400004)(346002)(396003)(366004)(136003)(451199021)(966005)(38100700002)(41300700001)(31686004)(6512007)(6506007)(186003)(2616005)(26005)(6486002)(478600001)(8676002)(54906003)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(8936002)(44832011)(7416002)(86362001)(4744005)(2906002)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b29CVmdEMmNDZ205OWV0YjI3WjNJQy9KVWlUaVlycEk2UEtpQldxaVpRUmlj?=
 =?utf-8?B?bzlUSWhselpkYnVIT2MwUWJJaGVYditHc2JJSThFS2F6a3JubGpXTXRUaWtM?=
 =?utf-8?B?eUVZSlBNSDhVRzE4dHZWcmg3ZWlselJseDRmcEVGT0duNzV3UytrRi9jS3lk?=
 =?utf-8?B?Sk91bW5nNVRsaEhHOWRnU29zTDVnOWJadGp3SnNhL2FTd1VHK2ZTODdxWUp2?=
 =?utf-8?B?YVBPaU5pTHhKQVdmVWNCazBlQS9uRWZUbDJjMStQNldadjNubmd1YkJ4eG9S?=
 =?utf-8?B?NFp0SS9UVkdEcVpncGtRSEhVR25vKzdVdVNTUHpYZDE0OFFKZk9EZ1VaV1lM?=
 =?utf-8?B?NnRmVHl6UVU3dDFDWkd6TC80YUN3Q2xKT205bTM4clpCYkt5TTRrbkJzdXdr?=
 =?utf-8?B?cEthalJmdVR5OGNsMmg1MEVrdGxJbXJVeXcyTkFRV0Ztb0hxWklFQlA3a0J4?=
 =?utf-8?B?TjR0L3BSSVp0T1c2QXczQ3FuT0ExdkpvRnozR0VHK2szUkxYbkZZT1NYVjFq?=
 =?utf-8?B?RlFRZm1tS3oycERMUXhzVXlIcUdEUFpkVkF0cU1qdlMzQUdneEtFNDU3clBl?=
 =?utf-8?B?cXI3Q1U3Z28zREl3OEJEdkZqbVJQNGlhbHIvZ21FQTduNTJ1d1pvY1JzUDdX?=
 =?utf-8?B?VUgyZWtCNmFMd2NIZ01tMEdOUEVpN2VNUmZSWnhRem5lb2NIb3N6Q1o4VDRt?=
 =?utf-8?B?TTRRWTFib0s2cDhnb0VhOS9LK3FuK2lnTEtveVVMOFlHeGlJeG44VFdRaW0v?=
 =?utf-8?B?Rjk2YXdJMTd2T2dCQVZRMmZ5alA4NUZuLzFmNTF3NzVHTXQreWZQelZvYTRy?=
 =?utf-8?B?QktvL2VFZGZaWDR3eFREYzJaaHRuQnpUR3pmK0x2dkpJSDI3TXJNY2lHd1RK?=
 =?utf-8?B?WjZOdXRZNUFIdElGNFI0aWJ6ZWRkYzV5ckJ5ck9nb2pFVjVDTnJCNURwWExM?=
 =?utf-8?B?ZSt5TnBFa2tZOGVQd3RadDhEdmdKZTNBc21uMm5meUU5UHE3OG1vNXNFbThC?=
 =?utf-8?B?Wno0WUduV2Q2a3RzSktxSkl4UzFXM3ZlazU2aDBBdWZpUmN6dDhDMkpjQ1hS?=
 =?utf-8?B?SmptT3NIek9JZEZPaWloL1VwYkNJTzU5VmE5YnRtQ1NoTUZFc0lPRmYrbmp2?=
 =?utf-8?B?TUora2VNYlRuRjcvVjZMTHEwNnhyaitwOWZVckZLYXFnSWREcmNkQ0oxMlJz?=
 =?utf-8?B?NUpYRk5DUHQwOVZPQ0VaSm1GWnNsQlNMWC9DUUFZUmFEaUtsVkt6akwvQmlo?=
 =?utf-8?B?cTRxZ3pqSGErTUgxUkpMQmplM053Q0NKWWdQbGhmTDFTMndNWVhIY09kamVW?=
 =?utf-8?B?dmZyT0VuaEpTbUpYSHFBcDRpcVhiZkhsWGJvZ0FQVUxGR2VNNVVESGNqNERo?=
 =?utf-8?B?dW1NNjZQRXhJdXRKZjZlTlphY3g0eWZNZEo3eUFIOE9zN2tnM09oL3NpL1Fh?=
 =?utf-8?B?UG1mNmVYcG91S1I2YmxaRXZsY2UxOWxZV3VYVVBwazhESGgvK2dFZHJJWlJ6?=
 =?utf-8?B?UUdCZDRUYmQyWCtheVJqY1FuRFZPdXRNOXB0MHNwZXhHVVZVdmFWTkZrS09W?=
 =?utf-8?B?MTVGaG9HUmI5aE9INXZuWWFCTWVEaTNoVWtyUk1JVU04QXlrRWdadDQwenZq?=
 =?utf-8?B?MjJJWDc0SURFQ3V2THhEK2cvMFUxb0wrbndudGVJWFhySHJBYnJQRmp3RFVl?=
 =?utf-8?B?Y2lOYTlnSFZnWkVud0pHVmFHNzg4WXVBbUpGTzhzV2MwOXRMdk9vMWd0TUZn?=
 =?utf-8?B?RUVHRHJXelUvcUxYL2MvR2l5ZytVQm41RUZ6T05FWUxrSGVGc1dCb2kvOVBD?=
 =?utf-8?B?V2FMWitoS0FTREk2WEV3SmZlbGRrQnk1RVNBcFZDbDhEbnN6a0NTcWxXZXlS?=
 =?utf-8?B?MjREODRzR0NoM1N2WTdKdmllY09yMWpwcmE2bmRZM0NnNTR2UWcwZUhTcGdw?=
 =?utf-8?B?VHV5UXhRSlltNUc5b1QvK0pBMjNGWUJ5Y2RodHZrdG84UEdhY1VwbGx1V25W?=
 =?utf-8?B?L2tJblQxWVg1UG5UdzY0N1MwMDhxdjhRTmZrc2t1dnRDNXdlS3pBemlyQ2lx?=
 =?utf-8?B?UER5cUtuVzJpblN6cUNRdkpoVzJxdUd6S3FnWmNHU1VXUCtkQURwbEo1QTNj?=
 =?utf-8?B?RVZ0N2k0YitpbE40UjFJODdVdjM5MHVUU0tUdXRULzdGUEJYbjJzcEYzU1ZM?=
 =?utf-8?B?clE9PQ==?=
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: e12dc935-d04f-4718-9b2f-08db61df0358
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7049.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 13:57:46.5981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LbnO/FTjexjyHS8mJUm2t/sRkQzhfZTGFxenMvNDvQe3oAAStIKXxyarsEgzZTNwVIufvrFkDtvP3r/W+O2BrZGl//AMPM519cWWQ+V1Lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB8138
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The ADIN1200/ADIN1300 supports inverting the link status output signal
on the LINK_ST pin.

Add support for selecting this feature via device-tree properties.

Atsushi Nemoto (2):
  dt-bindings: net: adin: document a phy link status inversion property
  net: phy: adin: add support for inverting the link status output
    signal

 Documentation/devicetree/bindings/net/adi,adin.yaml |  5 +++++
 drivers/net/phy/adin.c                              | 12 ++++++++++++
 2 files changed, 17 insertions(+)

---
v2:
  - no change on patch itself
  - add a cover letter
  - add all the maintaners to CC list
v1: https://lore.kernel.org/r/1bb924e1-37ee-db64-a7b3-8873b13a1a91@sord.co.jp


