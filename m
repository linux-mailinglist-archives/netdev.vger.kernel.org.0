Return-Path: <netdev+bounces-6824-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CDFA71855C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:53:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F36F62814ED
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6DD216416;
	Wed, 31 May 2023 14:52:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AB116415
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:52:50 +0000 (UTC)
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2046.outbound.protection.outlook.com [40.107.114.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4380C0;
	Wed, 31 May 2023 07:52:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pj0xQhctX5BirZjgGp8DuiC3gR2LUbOZ8svGtO8FK693q5Vc7ZUr6kN1PDw0vt8PEmpYo9QiVCjfMbvz9VO8OHbRyxxeAZvg8uuSfNmPvS33KuGS7uIqQB6cyN3RgoyX8cf1Q9UIzDk03zrV5TLYrW8sN1xnBydkQGSVa86V3hugvXXpte5/E3sbqkrMGL1ZYrEkAh4PRS0ljUiin2/3mYKrRV86MsWU3Y1Bq69e8xOZnuFCiqwnSMXz7xzocSM2iqem7ttuO/Xld6EJloZxlyt8JOtt9vG3vRVKH58ZLjB29zmxgm9DsOoTSMPjJru25iFGb36DvMI/nadx322L3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QB9+9O8YHe6jYhIs7vr7ASVe3UNw2FxjtZRaVnMmbzc=;
 b=iRwIZr+IXHuftkWB0XMUScTBEEFvaEdMvo6xlbE9CU/jytQkpaf4jeRj8aSQ44QPNWKap6XiMc3XQK/eItsf88sIowLl0JDSVeQ7EcKEgYSk2AkteC6qVE9mPCAKhilDqUZKiB3ghXm5Ti1MG2DcnHPK9KYYCdQmJL4u6zTeKzZ+CUkwGYRld8v+gc/eqacwbM4MJhVWsccZw1V2EXu1HXrUUSEeGkZUJuMRrlGZE9lubnqdEtYGJWfiCHa1DNJLS3hOLns4ZxjQ78TRi+l+sbsTl9Xn8bOzjhSkA/6mPC9mC3sRw1zQ++9nYvAEEvm7D/pnD0G63HuBqDq+96Bs7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sord.co.jp; dmarc=pass action=none header.from=sord.co.jp;
 dkim=pass header.d=sord.co.jp; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sordcorp.onmicrosoft.com; s=selector2-sordcorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QB9+9O8YHe6jYhIs7vr7ASVe3UNw2FxjtZRaVnMmbzc=;
 b=l0xiuzK7h5T46Qb4l5YHWJt8U31Q63Hp1Yc4OOc95xrQ/GvQTwkOmknOmmZkd/3eqZi8zPSLJEF+sleeMCW4H747knvNhOlpno40URdlBoCicJk6UblkOgppKWXTxyUbuV+FRweoR0ZpxraP+dKzKO86S73gdKoMSEUeVaTrH1k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sord.co.jp;
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com (2603:1096:604:13c::13)
 by TYWPR01MB8872.jpnprd01.prod.outlook.com (2603:1096:400:16f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 14:52:46 +0000
Received: from OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e]) by OSZPR01MB7049.jpnprd01.prod.outlook.com
 ([fe80::361d:fa2b:36c9:268e%2]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 14:52:46 +0000
Message-ID: <167dd6d4-1154-3259-9a00-c46b8f764388@sord.co.jp>
Date: Wed, 31 May 2023 23:52:44 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 2/2] net: phy: adin: add support for inverting
 the link status output signal
Content-Language: en-US
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 Michael Hennerich <michael.hennerich@analog.com>,
 Alexandru Tachici <alexandru.tachici@analog.com>
References: <7eedd83d-7d87-ba3e-7a38-990f05a44579@sord.co.jp>
 <20230531063714.7znsc7cepsk3yu44@soft-dev3-1>
From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
In-Reply-To: <20230531063714.7znsc7cepsk3yu44@soft-dev3-1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0033.jpnprd01.prod.outlook.com
 (2603:1096:405:1::21) To OSZPR01MB7049.jpnprd01.prod.outlook.com
 (2603:1096:604:13c::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZPR01MB7049:EE_|TYWPR01MB8872:EE_
X-MS-Office365-Filtering-Correlation-Id: d49b9d80-f29f-4028-1921-08db61e6b1ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZLfA+EiusQOldiY3q/lrj8lGRJsJXigVkEdjKwFTOQ/0RmefT6yliF90yegVa4di/7CYwRAnZx4Bs2qx9dBVaJ2qm8idNr0stoqsdBmjy87H38eGrTjJiEpA/eQbhLTEZFUTAdqpjhPmv2eEooo3u24fayeKKEtK6+j+76oxZ/LCMp+vO7KPfKP21CnPnXNZE33Q6xGNYAYNfdxyL5/6ONKiAd8/CyA0ERTsJaTJWOK37ToIB4zMM0riQSyhOH5xu4Z3L9FQCePgPv9tm0ln/gxXfM5vsDvj1gKWgdNoUqHkTPKfhzAO3In10JjfYg6sqUq80kj5GvfQr+cTwhaBVuEBM/z6edKffi5ALPGLWT7AsEsY0tt/m7FihZhG0d8mqtTQjK+VAxbmHmCPeX7FoOA2hIA0EkINTSIfBWIa2Ft03KHYWsy8xmIHGC99bY8CxJYhIDhPPXFYJMFj6ukJNHlP7h5HD56kY7wv/nclG/pYXnU24BhdNKzVzlJqXtuMHDt+XVMlUCALLsPcQC2Mpn8a3MYZ0DVO32ZXLoDCsVXWuHw45iBZacWQRk6D1oDNLNi1+KUf2ixO31FzMPVMSPLZM2H6zrBxjo5Ikym253cXcEKB2R2DdyMQA6KB2ZYVrfY6stDeVm6fG0pDXSO0aw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB7049.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39850400004)(366004)(346002)(376002)(396003)(136003)(451199021)(66476007)(5660300002)(36756003)(4326008)(6916009)(66946007)(66556008)(478600001)(31686004)(54906003)(8676002)(316002)(6486002)(41300700001)(44832011)(38100700002)(8936002)(86362001)(2616005)(6512007)(53546011)(186003)(31696002)(6506007)(26005)(4744005)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azJRZEd6NFQ2UHlMby9aOGN1MnlFcW9TT2J4b1RqbzA4K3FwRUFKTGVRSzZZ?=
 =?utf-8?B?amFKNGVRMU9LeW52dVM4N2xacmN4NWhEb2JHLzBDY0hVeElxQ0MwNDgyamNr?=
 =?utf-8?B?bDQ1eUY2b2FuSmRwdTZtZi9QM3FTYWNldXdES2pFS0tEMnJNQ0liUTROcFZN?=
 =?utf-8?B?ZVlBNVRRdkxja050dUY4ZkFFeWp4dUcwU081cTUyZXRsaVg4Zm9adE9uQlo2?=
 =?utf-8?B?L0N6Y1pPVVAyYWYrYm9udE01SERkSXFHN1VoalZKaVMxNWxiQ1BpSVU1RlJl?=
 =?utf-8?B?dk84SVRtMWl0eG1qUlRMQW9nY0trc3hQVDdiQ3FYT3EwYlF3ZTB3WWsrS2RY?=
 =?utf-8?B?Z1BrdkZ1OVlxVUJ0UlBmNFMraEEvN1pJbjIzbUFGbnJ3aEdycE5zc3hESS9W?=
 =?utf-8?B?ZXVNMDNKclBXVjVwTGV6R3VzRkJ1M2pTQnZDVUovZ1hKMWoyaUhmL3g1M2Yv?=
 =?utf-8?B?N05xWEZnaVE3dkZESk5SMWIrR2N3WDZLWksyT2Z0MGptOVc4WWtVdGgzcW1r?=
 =?utf-8?B?ejA0Q3M0dWpHK2hEK3hQN3hTU0s5MEZzdURueHdJaURhRUlabTRLZ3JOakE1?=
 =?utf-8?B?NHhwNWcrQWhzUXM2WGNuTXhjTWJKWHFFbHd0OXFoTkUxSnVjc2NROEpWQ2Jr?=
 =?utf-8?B?UHcvM1llUllhUWlySUREUFcxZTJTWXF5cnNqUnJaRFdhR3o3WGFxNTlLbXRp?=
 =?utf-8?B?dkJQSHVUQXBSSnZrbnFXbjZyM0tobDlQZWU0M1pQT0p5SVRMM2hPUlc5L1Jy?=
 =?utf-8?B?OGlTbHBVbFdqb2tMS3puMEt0U3kwRzBhOGY0NTd2WGdkZG9HQVErVHBmTWFS?=
 =?utf-8?B?eEJMMkZWVkdMTDQyblp3bGkvdkJqM3lpQnhoTU1aUnFyMi9JdnZueEo4ZVRz?=
 =?utf-8?B?ZUNWWjEyVGVKSVRTZ01WS2VLK2dBNUYzZXhwa2dJMStHN1hvZFFEOS9xd0Vl?=
 =?utf-8?B?TDZvOHZYUnNCMVRCVzJmV09SSFNVejM1SzNIZmdYZngvZ0hMOGpOeHNodWlr?=
 =?utf-8?B?V2o3RE9pMFpaajB1NmprTG91RlpqMW9waU1GUVdjWDVlTHhwMmROczZwR2tC?=
 =?utf-8?B?NnN1V29ZZDQ2ZE9ialk4ZStURldxRkphdUN6WUdYQkZDUXUxMWtTM1BhOVUw?=
 =?utf-8?B?WmVjNS8ySUpTaTZEQnNCZVVSNUtNNTNTaXFYV0dJa1JPSkZ5Z0M3TjExMFFB?=
 =?utf-8?B?WmxUQXJBWTFJQ1NkUXRkM2RGTGkvemRmUGs1ZWc0SXkyUGtYd1RJMER3RjJy?=
 =?utf-8?B?eTd4VWJGdU44WUo1L3pjbWNyUG5LRGo3WUZXeW1KTW1MVGZkVU1QNlRvdXBC?=
 =?utf-8?B?ZzNkVWphMWJPbGxCeUNiZ2I0Y2hrenB2ZUNDREdtMkJ0NEVuSjc4cGVHTEpM?=
 =?utf-8?B?bVF0Qko2V2VzSlh6QU0yaG1yWEFXOU40VVdpYU9wK0d3SGt5OHMwTU41aVB0?=
 =?utf-8?B?SzU4c0NTN2xIbzZtZ0FZaHYwNUxWbkd1dHhMbW0zSHUwU2RrQUV2QnlrMDdK?=
 =?utf-8?B?a0tVUnFva1N4NmZkVS9jSXQrcXhENlI5NGhqNVJkUy9GVTZ1UmhQbmRaMzFG?=
 =?utf-8?B?S2xrUjZwSFl5NTJ3UUZ3RDE4NEVFUG05SmFQM0Q4ek91b2tYQk1UdVBHTk9O?=
 =?utf-8?B?aEtiUFBvYjZhRHpFbjJrVWNnWldhTFF1d1A5VFBhbHlJUC81OXJ1Sko1WVFQ?=
 =?utf-8?B?MXBYODNralVLSm81cVhqbkxCdm4xbTNIR05xRHhZMExpSGVidHpjSkU0akw5?=
 =?utf-8?B?VFgwdlJkTVVWOW41blF1QlZkZXNwbldka00rME9QRm1BaXpZNkZCcnROVUJB?=
 =?utf-8?B?RXRoWG1xYWM4U1lCU2VFU0ljRlVWWkIxeEI2aElDcnFXTHU0dVV1NGRuOXBt?=
 =?utf-8?B?bmo4M0pNMld1NkJyQUJKN0VhdGo0ZGtieDlIdkhvSXhRTW9Cdm1NT0dxdzNY?=
 =?utf-8?B?YXhwSGEwRmxxYWlvTjBGTktvZS9tOVo4U3VlNmdpYy9KSGhQZnVUTmM3dTJl?=
 =?utf-8?B?MEJjSXlmVWdxU3h6aUxaTDFHK09RWWVyd3VsMkRPdnp2aVZzb2hGSWkwWUhK?=
 =?utf-8?B?WEFybkQ1NTIxdmFNdG9oK3JVend6cmhGUENBZXVocmNpa2N0WTNKZStTenI4?=
 =?utf-8?B?NjVIRWc5WVNjdElKS1d3WnNaaXhjN1lldHQvOVBVekMwRUxmLzZvQ1JlQWpt?=
 =?utf-8?B?VGc9PQ==?=
X-OriginatorOrg: sord.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: d49b9d80-f29f-4028-1921-08db61e6b1ea
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB7049.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 14:52:45.9802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: cf867293-59a2-46d0-8328-dfdea9397b80
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wHIMYgxajNVEa1djTP8xet2f48RtwikEFqWCs2Dx1ED1AeMWjjMoSt8P2CAOJPmETVX47zHwGLbGN1ip9rWVu+T8uu1oYGue5k5pvLpb90U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8872
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/05/31 15:37, Horatiu Vultur wrote:
> When you create patch series that contains more than 1 patch, you need to
> create also a cover letter.
> Also it seems that not all the maintainers were CCed. To find out which
> ones are the maintainers please use: ./scripts/get_maintainer.pl
> 
> Other than that, it looks OK.

Thank you for your review.
I just posted revised patchset.

---
Atsushi Nemoto


