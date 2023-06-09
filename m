Return-Path: <netdev+bounces-9494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB837296CD
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90C9A1C20DBF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 701761548F;
	Fri,  9 Jun 2023 10:25:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D99B14AA3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:25:38 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B308A46A6
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:25:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGJg0tc5IEmDree2UzO9kZLxJ2jddulZf3zjcIHNgngBTBQM4nu2sQBb1bWOdq0C4UvIg4IGPPhsAMtQE30qGaKHTvfPgHpx6xwJ+9DxtmDYZ9N5I/z4jRx3/k9u6moMnigjGAN5uHm1cit7Avm1srgyWofmbojZVescyLalwUbALqK/kQumtuZcjIZdnw3dL316Kfrn1OpYImEMzWBUgC2JL/GfOvc9NTpiWp0zkTSUeHxuuGHu52VfxabcAXbR2DT5PPpQTMdJhKG1Pvm2syLYvBw/35ot0AHmrCbo/6GDl/B+npYFfhyPZZTsuYWvIw2wFBO24AWvyeyYCfB59w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzVmN2gNPvzzRrIPhJNQ0GEZeDJ6AdIEDL5k7ewK9lU=;
 b=MjljTGhvdM76/L4ZVGUKg+ah18NUkMVi9JrsbmdV8Uaw+rhZKw0aAChAvcnbR8aWNNp2U+cWu9EuSn8/EbLUDsE7y6zmKoAmo4maCOqYwveJ/3T8krsPZdO1nyypPInkGz70HOytLMDMHbbMkizEo1xqtlSF5Q0GtyTCR2bN3CHbia/XQWLb2gQh6cs5+FgHDcgkB4jzbfduuXVkWYsndJEaoULfM39veAR88RmRje4HNygWnewMDPX2p2PqW9smzIFxspngAwYoPQR/9yZCCceinYWxvAd5s8+aCbvq3D6lvensLjjwB7cQnfgvKFYUBT77JGkvoA/Om50NKPchAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzVmN2gNPvzzRrIPhJNQ0GEZeDJ6AdIEDL5k7ewK9lU=;
 b=Yz4j9jDT3R18dI9di4vIudkTEPgRRmYJeIkdZr0YPGesX/xt4L4Xv0hanSsMdSyrCUsLJw8ffFcLAvJERRKwtmsl+CKrNi/Dq7/MD722g/VW6Nd+ahbgwjen5gzqGAg+8DlTgcLlm97z/KbSwcNXyEs5FXskjGmnyMJclkrnUeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 CH3PR12MB8852.namprd12.prod.outlook.com (2603:10b6:610:17d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Fri, 9 Jun
 2023 10:25:33 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54%6]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 10:25:33 +0000
Message-ID: <f8d82e49-dfdd-d2b4-0caa-7c8d13bb9390@amd.com>
Date: Fri, 9 Jun 2023 11:25:26 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH v2 net-next 5/6] sfc: neighbour lookup for TC encap action
 offload
To: edward.cree@amd.com, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc: Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
 <c8f47cbeeb9eaf9172721ef2146c3373d229c2b4.1686240142.git.ecree.xilinx@gmail.com>
Content-Language: en-US
In-Reply-To: <c8f47cbeeb9eaf9172721ef2146c3373d229c2b4.1686240142.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0067.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::31) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|CH3PR12MB8852:EE_
X-MS-Office365-Filtering-Correlation-Id: 16bc4acd-c872-404b-f42a-08db68d3db8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	V/duuC+JlYGskf+DASdJbRCiIojIFp0R+u43etY4Hz3jERHbtrZvc6r8DNddf1VnHnn0L0j6KIVd4ungS1OCmJMt71HwiI7ZsAN9PAZLTDbj68kT+M/AKWHzZPs1LWpFigxrGZW3DUgCTHdH0al49PUHgbyTZ8l/AZpW0UsS4X9qVTJ8m++geOAF8njU9zirQCCfzr4oaM04rYwbKScK1EbzELT9nOM3fXmb7teZE0QJlljNO9/EtRI7PJhv/UsljOGOVPllZU3DFj1mZ9WE8vw2Q89hdB77lZuHYaDj0xujt4WFCJLQv7OVq9JpnwkApLRlJeD5UNrUQlYOwOiMfFCRlpWUIO81hcLwPRVu8E3SoSXGP0cbifm2R9TzSfobR79k/mSgnki6LBb/Uy2wgl6M28X2xM7B1Ssucdjz3jZ5y6cVZzfaaJ9+jQV5OPtR6I5VIfmzS0VqnjIwxw3UZ8xClngS33iqIepoDIPAFvg5RjFpJsBcyHFEDa7w6ujM4qsg1coE66nMHAe/bnPq1tWQOORQWaPbmLhwUZjSOPiMnuKERgHUnzUxbhzehYFDfAxQjNcrUsH721x6P2rB7PtN5TBwk9JMR7vLs733PnAMfdu8uzKklhZsAxMhFOxECoZPDgQzTUDFxLGYZPDgAw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199021)(36756003)(31696002)(86362001)(478600001)(4326008)(66556008)(66946007)(66476007)(316002)(6486002)(6666004)(8676002)(41300700001)(5660300002)(4744005)(2906002)(8936002)(38100700002)(2616005)(6506007)(6512007)(26005)(186003)(53546011)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTI4eVdUS0toVXFpUmpVSlBxSmQ4M3h4Z1BueXhkNVdrOGMvM3dGZkkyem9W?=
 =?utf-8?B?eWhJSTRKVGM2WXh4VGVyblR2dFczbmRBMnRVaERreE1nV3RXMVl4ODBtdUlX?=
 =?utf-8?B?VG9DQkxtb25qWWd2N08rM1lwTUpiTTNnK0t5Rk9uQk05SHNMckpNUDY4cGFq?=
 =?utf-8?B?bFdGRXh6RXZXemdXR3FZMHQwSnJpdW9mdzZNZ0dPbEt3b04zd2R4N0o3QkRj?=
 =?utf-8?B?ZTltWDNkNXpJUTg5ZmJzYWczMnYzVUQreThWL0dqMjJhbmc3ZUs1QjNPa1F6?=
 =?utf-8?B?T3dHNkNISlBkM25KVi9RUVAyejFtTzBmTzlONDJqUjF5d0RVVTg2cGorUEtU?=
 =?utf-8?B?dUdGQzdLbEh6KzdJZ1M1NTJSeHlLcWViTXh0TnFmcGRFaWo3KzFlWHpweWxs?=
 =?utf-8?B?NjdTbnA0K2hwQWVPR284Tm85T3c3YkdOYVVVbW9USVZvaHp1UGdQTEhNYUpn?=
 =?utf-8?B?bncxUGVnV3RrK0lQaTRHcVRWK2tlSDFvUTlyUFREb3JFc3BQWlR3ZkJubTVn?=
 =?utf-8?B?Z25MTDF0b2ZWVCt4SnV1bWJEQ01RNmY1dlFESGF6aWMzemljU1E5WHpMUEpQ?=
 =?utf-8?B?UkVpZzFpQUtLQTAzR1RTcTM4RmM4Y0xXTFYzUEZXUm1RaHhxekJCa2lKdGVy?=
 =?utf-8?B?ekJtN3FKcm5TZ1dYa0N6M1BEMDNZb0NuM1kwY3g0L29VL1g4TW9UL3FoZFhj?=
 =?utf-8?B?YlVRQU9ST3FaU0M2WnV0empqcExjUFFwVy9pRGszdERBUlBTMG42Z2lCdVRj?=
 =?utf-8?B?OUJVMmlaMnUrMmNXSDBNdjUwOHVXSXBNMmU2b2JVZjBXZGdtbW5HSmd5WkJR?=
 =?utf-8?B?UWZlTHlkdzByOHR3QktXTEM0VWhKK2RtSnpLR3VXSmNZc25uK0oxcmsvOElm?=
 =?utf-8?B?QThydmVXQUQrbUxvUzd4N2VLVmFzTW9uUWl2VGZqVWNPdlpsQmVIeE1iUDdp?=
 =?utf-8?B?WEU0YVdXUXNLcTFpVXVVdmQ4djY5enBUT2ttRTBiamdMWlhjSHNxREExbnFu?=
 =?utf-8?B?ZkQ4b2JKbFpHZUxPaVBRU0s0NWxuK091RFpTNklnU2FXeWFQdUJoMWtiOXNM?=
 =?utf-8?B?NmVTZnpiNHdoTE4wK0U2b3AycmQzQjRTVHBYQnRSRzBuS3BsV1hYeEFkR2Ey?=
 =?utf-8?B?M2lsd2VwL1piK0dMSHVTdUZOZjBrOVRZTGFMa3M1ZG5jelBEU3RMOWY4dyth?=
 =?utf-8?B?dXpzOGFDTFhaTnNrRERtZGVXTFVRMTlEUlB3T3FieCs4VWV1YnhZcEVrTlNl?=
 =?utf-8?B?QVdJOGJhdzJwZld0SWU0R1lGMmdKaTh4QUdhTUVVaU1UVWhvM1VDMWdtbG1t?=
 =?utf-8?B?SWsrbCtWUFRCTXdydVRJRFFKeExIS2xyQTF3bUNoaXhKSzkxOG9EN2lnUklK?=
 =?utf-8?B?R1YzMjV2VFpwOHdJYnVYeUZHOUxnbncwQzhha3llZFpUcEhTTjJObTlFYy9h?=
 =?utf-8?B?VkgwOXEwbTdDRHRCRE8zUCthUHdXVDVTU1FIdWFyOWh2b0RZaTZFd0dIbEJx?=
 =?utf-8?B?dGlzVlVVN09Wc2hTN3RPaXNwdTF5aVhRMzZNeCtMbUZ1MG8wOFlMK0lMN0FO?=
 =?utf-8?B?ZFFSdmIveUVvOVVjYXhIV1Q2VlljOFVKWDM5ZklvZFRaM2VZV3ZoRkdMeE1U?=
 =?utf-8?B?OXZPbmdKSTJFZWVyK2g3Yi9jQ2lYbUtMZzd3RjUwL2Q3MjFmcjM1a0pBSGox?=
 =?utf-8?B?Tk5IdzZHdVBMcFR6TTdTRy85MjViUVllSWlTdTZtV0NKRFk2QUc3ZmZTZ1N0?=
 =?utf-8?B?ZFFsQ3Q2SkxGSU5KRm1iMmdUdzBTbFdjU1lBa3VHZGF1Q1FqTkxLOHNyNjFZ?=
 =?utf-8?B?bXdVb1BnQk5VMnVFSDRhVWFCSHhQQzNIR05VOHB0R1BaTnUybkorS01XMnBM?=
 =?utf-8?B?WW9xcmQ1bWtub25xQ1lVaVdBeXNILzVQeUlpMzNYbXNNV0ZXazJlTXZQUkNN?=
 =?utf-8?B?a2pyeHY2SEcrcjNhKzUwMDRmWHNEK1dkb3lhZkV2eUdxRVVPMUNxcVNzak96?=
 =?utf-8?B?THFaaWxhRkRsVEtyZnNuSkx5aFhuc1pBZUp1Z00zcjNvNVQ0eWRlejJpYmhD?=
 =?utf-8?B?VVU3SnU3Rit2cjM0cVFFVUpVTDd5am9PQkdHaFRjdG5EeTloajFtdDhTRUVJ?=
 =?utf-8?Q?qfHc8T7FGLVMQkYgDD1C/sgZ8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16bc4acd-c872-404b-f42a-08db68d3db8c
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 10:25:33.6459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IALqQb1EK3hlLhh8KEqOlch+7d47664sX68edgzVkTTc7sJL+MP1P0Z8qG14s2Og
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8852
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 08/06/2023 17:42, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> For each neighbour we're interested in, create a struct efx_neigh_binder
>  object which has a list of all the encap_actions using it.  When we
>  receive a neighbouring update (through the netevent notifier), find the
>  corresponding efx_neigh_binder and update all its users.
> Since the actual generation of encap headers is still only a stub, the
>  resulting rules still get left on fallback actions.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

