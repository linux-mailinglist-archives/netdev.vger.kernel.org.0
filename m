Return-Path: <netdev+bounces-1554-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5B36FE496
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:48:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86E4F1C20DDC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663F317ABB;
	Wed, 10 May 2023 19:48:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541558C0F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:48:43 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E1D3AB3;
	Wed, 10 May 2023 12:48:42 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ADxG75001188;
	Wed, 10 May 2023 19:48:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=7EtJ3Z1JDIngTSwtURqTKn5yVzTL9+HBimdkRw3x9Vg=;
 b=qBtxCHnRlf69Om9PDvH9hxyqmOxW30TRD3R902vsjR61vjwxRpMeIQ8hia1EOgtY5lHX
 dKyhREZ5oNKuisGcASSGbOgjveFqoPY9DbKDVPWtnRUI2N0N5waoS4BvYJNzv4tVyjjZ
 k+oGNO5GtokQDqlAn+OmpocS7s7qkBaKU42cBNisTRk8PdRtRu7ee2vmA/KKsjJoN6nu
 RpcySZg3/m55tVZqpwxxWhLjCvIHFmwSBi6Vpgq3uB/l9EeKxUmbYA8y8+vk8o3W6LYO
 wyE7VYEEBBzPj0//A/pvImEy0pCib2bJyQ78BuLfEK99vgZdMCQl5Inn4NsnszaYHySI SA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf778wfmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 May 2023 19:48:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34AIUUlo004546;
	Wed, 10 May 2023 19:48:33 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qf7pk1r3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 May 2023 19:48:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+sib7iYpRSpFi1408KF6QEuTZmLvnhzMDJsR6ksaTrwrXACB+jnbp8Demu/eCSuqymOsh3S4yjENewHEwEPBmyvXRFslXAMwlCVWOIrmJy0rDp7aaAzZQWK2FEeOMC5G22pLv32zTAvsHO+CTT0U2nk8YZIoh4NwoJifRzU+tFugOOAWRL6JpfYYFIjf5pil+nYmS13Z0EeJ1eJ/6S+dDFTUH3e6oxXhN5kz3Sz1Wj3USuim1bKUCgivn2v4b/zVqQEJILJI5NbJcfGLVQsFJYLes7ASyrtnujRD1M44PLj62yhaj6dIm2W4xvoGLZ/CAvmZg3t9ntHqYYnx2Sr1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7EtJ3Z1JDIngTSwtURqTKn5yVzTL9+HBimdkRw3x9Vg=;
 b=SXmwL0YCUgusUzvperN4rcUYrkRrfXS2S++y5s06AE+6D8i6KagOriVW9y+BBsuz5uu10Ydl+wQ6yJ4cBDOFb5RgnPUr7vOamxd4rxJ5P8Wta33/ssTYD3NfbeYpUdrLDM063Arx9b60khMjNe1ZB/c5dh9pKi7mGymqURoSKaZ9adFQ59Yn7q5CGtCMhL9XvBQk/ckbRL5fWYLpbs9CAR9RPyItzPNcaLKHUmoC93OEaRm784C5kd3bbB/43GCEImDxcqRQ5iQFeuUKl9MFhwLoduEzFa3lOCECOv+kL/BeqXeacGJdx2fDBXbmC3mP0wEbScmAyxSb7TxJiZ1EFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EtJ3Z1JDIngTSwtURqTKn5yVzTL9+HBimdkRw3x9Vg=;
 b=Kl2BMwdKog+7vg1ZHL4fYqWwlIiK6ZzvsOyq8PGQwNg9XjGEyEuWj9DD+P4DoIqsBkcUF9XBUxVYAShDAUNWLMwbHxMaAD8pSQk0Iluh9xva17MQtb8H5HlW1heG9AfLSJl5KibmhwgdFL8NJj0ldxZprIJeU77KtuXq80HqNTo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6051.namprd10.prod.outlook.com (2603:10b6:208:388::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 19:48:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6387.020; Wed, 10 May
 2023 19:48:30 +0000
Message-ID: <56fad7cf-1bf4-82a1-2acc-53a5fc7f9c70@oracle.com>
Date: Wed, 10 May 2023 12:48:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH 04/11] iscsi: make all iSCSI netlink multicast namespace
 aware
Content-Language: en-US
To: Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
References: <20230506232930.195451-1-cleech@redhat.com>
 <20230506232930.195451-5-cleech@redhat.com>
From: michael.christie@oracle.com
In-Reply-To: <20230506232930.195451-5-cleech@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6051:EE_
X-MS-Office365-Filtering-Correlation-Id: 3345618c-edfd-4164-296b-08db518f87cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	UWaulGXEVvWVrtV3AeljL3AuEUZMGzB+gXyzPR7eESsJlm6p2pyKIPtHrFrmazBCNTrkR77XplNENm9W2PO/ISwzE2+TVQdiJtbRug9iWk7trbMkq8LjVSwozJC4pTWxX909UXrFZO7+iQntv477l/eibmWcrbit/ahMLuIKDViJHwI8RrKoosdN5RFyoF3c3hzwFcXi9LTIUj4j0Npmbzjql1hHXnXr8FrR28p37EJB17tgz2lPXaVKLSqCQVS6lScLAehraUxDGBLS6JMlZte+baJD7KpweVAOAKAo5k6D1/85BU98mEqWB1CdO2ODNUuJXgYu/UOs/L9cmmxxqT/jrIdCpjJuxYrjbMQ1QTieSolSAdE9gANDhfDh0emAiZGKkVSBLoCEy9/13uwrEj9AI3mOoFCF9dpAxkFRILFgY5X7smxcjdKekBbqM/iJBJU+8iHifGid6JTNvZhYw3bItLKaG864OWyng7ToSNPj8+KNqmHeIb97rm0WZ3ttdEsupuT48wW9PYjQcg8AdshhyyswfYHXaGdGrL9gyQ0gkNxIBr0xvQ5wfdARG0u1ZkBnxHLEcHn3msnbnrLQHLHAVs4QrKOdbsZQIVyTq3cCO7IrfKiR8JOnC3zf8zVd
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199021)(31686004)(6666004)(66556008)(6486002)(110136005)(38100700002)(66946007)(2616005)(66476007)(316002)(31696002)(41300700001)(86362001)(8676002)(8936002)(6506007)(478600001)(53546011)(26005)(5660300002)(9686003)(6512007)(2906002)(36756003)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?d3J4VytNaFRqNmt6RkZhc3QzbisxMk01NEdwa2lqQU44SjhXdHlSaU1pWWtS?=
 =?utf-8?B?USs0UUhoK3VjOTNRSjg0K1pqS1RNS3VSYU96TmdubHY5blF5alFrVTM2MG1Z?=
 =?utf-8?B?ckQ1S2ZBMWZSaStzVmxHYkJzek8wU0FzRkNhTmQ2clRrQzNtbUNWSE5lQmRS?=
 =?utf-8?B?MTIvaXBVOU8wUnNJbkF4alUxN1FveGJWOUFkNWFFNUZJZm1PZk1UQktsOVhT?=
 =?utf-8?B?Z1NPV1MzTDhybWlpN2VGUm9EOENydXE3OGR1ZndwUElYYUt1WVdOUjVvSFhq?=
 =?utf-8?B?ZWdrT0QyQnlJSzgvUC92RmNuNjdOaGlxS3o3dGN0cnV2SnovUUVGQ01PcnhP?=
 =?utf-8?B?cnQyMTNhK1lrTTRkVlc4ZFZNZmtlaTR3bHlpQ0NQZ1NiK1YwMUF6NjNsWFBo?=
 =?utf-8?B?ZVk2OFU4UUFFamE1dFRCc1JyODJScjAzR3VQMEFQS0NjM3ErbXVOSFhGT09k?=
 =?utf-8?B?TFRKRmZiRXp5ZjFzTTJGTEZsdmwxWlAzMVUxZ1ptcmdCNFlhZUdaRmt5WGxq?=
 =?utf-8?B?UmlXSjBaS2pLMDNldXNidTFVNGpoeVNVbVNoY1VZN1RnazB1d1VjNnQ1eGwr?=
 =?utf-8?B?NkFnNEhFdGw3M1lUdVFXRmpncUpaMlF1MS9heCtIaUMwVlU0M0dsNVVjUmFn?=
 =?utf-8?B?U2tKb2Fnd0lnRFZJS3JMRW9GOVdSaDFYRnZMaFN0eVMwUWRsSTlRMGFYRnZE?=
 =?utf-8?B?VlF1MDNOTE1IWXlQU3F5QVR4aFA4RVlJTHVSb1BJVi8yTW5yRHQyVTExVTJp?=
 =?utf-8?B?KzRBSmtzZ1BUUWVTdUNSK2RZK3BKZm1aYWRZSk55S0ZFSXczY1ZPZklLVmM0?=
 =?utf-8?B?TzNuVnBhYnY0c2h2YTNsYnp6bVUxb0dTazRIMUliU2tMeTk4aGZSWjAvdHZi?=
 =?utf-8?B?VnArZXZMbHN2WVcxaXoxeGwrNkQwcjdGZElzaDBpblJNN2lNNHAwY3g0SXFH?=
 =?utf-8?B?NkFIZVBGTmlub2NiUUc1eGJUVkJ4UjJGNUJzWk1aY2ZmQUU2YnZ5QjZvekVZ?=
 =?utf-8?B?UTdSYlBFQlZkOVhHQU0yT3l6V0hySzZDYlRqZlp5TStLUFNZSGRmd1JKSUZt?=
 =?utf-8?B?MnpydUdzZVlLR0doRXdsS2o2dW9oQkxta2h3UlFhYVNNQmlFRVQ0aDFZeTN0?=
 =?utf-8?B?VmpyZEVMV25Tci9mYys3L1cwek5YV2VxNldneEt6V0xUaUJSKzdjejJtZUVi?=
 =?utf-8?B?UXpGWkpBVHhZeUlQNkFUY2tBUW9DZG9QdlFnL2NSay90anI2VDgyTmZtMWZj?=
 =?utf-8?B?MDVGQzZRUzEwWktxVE8wd25ZWDFJN3ZOVmwvTGZXakFKYTlMNktTTk9HT3M1?=
 =?utf-8?B?N2p6c3BkVWZHalh0eTBzcXczT2h6RG5FYVIvQXNqQU14aWhBNkNrbXorRlZ4?=
 =?utf-8?B?Z3NFTStHT0VYZzl2VW01Q0FscEpXd1RxVVpWSmUyVThCV054QUdLNkR2M1VD?=
 =?utf-8?B?eEtHSGVWblUzYjUvMk9ybzkxUXFiaVpFMXFDamQ0RWdkWkxLR1FHU211QkFG?=
 =?utf-8?B?dFhhTVllU29MTklPY1k1UmY2Q2NEajlrdWxpa013Y3g1UjNHcXB6dDE4QzZv?=
 =?utf-8?B?ekdqbWZMTXZ0SzF0bnZaYjdoQWdPd3BTTE0vb3dOV2lMeDBINEpHekRXbm5a?=
 =?utf-8?B?STRUUkk5QjZ2SVpNRlRldS94SmNHRWM2eXltUFhNRmROZDdhaUJJZ2hBVlUy?=
 =?utf-8?B?TWx0VE1WQkFFK1dOc2NwNFI3OEJpMG9tZlZMZGQwRnRtc3E3VC9SczJONndW?=
 =?utf-8?B?MUUvN0ZsZWs3ZHZuMHUvb0xDdmJmRzY0Z3Z3dFBVV1ZjNnF4d0lnVjVGS0wz?=
 =?utf-8?B?aWhhVFNNNGc3bDJ3VkJQTUtjdEp2ditpeW5nYzBvMWpuQjlMZE96TnF2UUJa?=
 =?utf-8?B?aUdsbkVXcVVpZExpd0dadlBkU3Q0eDF4MlZQdXM1Sklwb1NPTkpMOTh1Z0ph?=
 =?utf-8?B?dE56OUNWOFB0cWsrNUpxaU9jU1FueVZYNm9TLzlGS3EzdzFlVzZTNzVCUzRH?=
 =?utf-8?B?dlowbjdsbFhFUDRCckZlRUtTNE9JY0pXVkh4RzlKYisyYlREWlRPaWIvNGZO?=
 =?utf-8?B?UEx6Y0pmbEhKNS80M2NFTXFyeFpabm5rNmtWUmNRMEJ0eFdDTmhxVnZXRUh2?=
 =?utf-8?B?Q2RNN0FLeEtHS1A5WTg5SWRKWFNPWVJ2d25SOXBtZXBZK2FPVTJVcXJkQ0JI?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ezJrZbLO2Rc8mhi6XxOvTnzoLxT8pco0C0FfhoLiurQV063f6xwRxThf1PGXpRE7aWFxD3l3lXeyHRxr4osmrLyw9f92X8pdQIvv9oIPwMzai9J4iB65X/2GpkWDBDHeOUZrJUon2xXXbHK7gb0jfr+2lU3CVOG9J43WnbVMo1Yu4VqR3VL7CF+7iO0E0XTAGM+HksErPecU2RJfH+qobY47NIyJCPvKNdiOa4Ql/IXeOtMeTWb+Oy5bCnKq9Yg9npCUvv5OkvPhgoXis7MOCp3qMLeunX44MIewZGmJOKI7js16RrsvVszyEwld0Z//LgfKAvnpKNqq5KNukNmuY+PLnQlKJsAZBEWUykJRVyWp4iVjm3V/alN7GkbNiRY01TI4xUDlbpENpH4WUZStmDLj68c9L9LS0aIheYeY380iJriuSnqHIPMKrIQKdwPMHXsZTGSINEYpySCOD5ZXMLhsnHPGcy+TxOqiEGTAugVSQIEYga55oIzkrBT4k0UmTWSDlMQvWIv//l7fXcljxxjRv5EoQg5yTjkzjDSAzVO503miWVNXDEqTAyoHisjwCjpU4jPQjdK9KetMw3Cp5vrxQNYBGO3+jVAh9kEkIa1TAbJVWn4fA/Hp71fn+gejX6I+Fpl10xiJ8HluyXP/gtw+4DftweqcimLqplNj6RZcwSbD7DUrGnp78XlhJe6DZM5PFIOoXjbW0vayvUFR7o4REil/Oy9QjZx3+UNSr978G15yAJVHPxDJ33yxsK5wufs4pm3N8dDawvMAp1bjoIkQlalgZMCh2RajHawWl7bvXEZ33QR1KrF9Gg8iGkQrdZbRAQTN1fe8CB3ZDw6w+nExZ/odxysTVajd3qCzfiI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3345618c-edfd-4164-296b-08db518f87cc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 19:48:30.5886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWEMIp11Vj71tyB4eV9Q8kRumahjohKrhZ2iA+eUsgRqVoeWF76y4sr05IkjHrXBT+KeQmKOrw7AeS8tGyrhFV7SvfaEyBBDW7uREF2/3cA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6051
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100161
X-Proofpoint-GUID: EGnUOnR2g-FAB5GeIM0aQDMdYDXiW8IM
X-Proofpoint-ORIG-GUID: EGnUOnR2g-FAB5GeIM0aQDMdYDXiW8IM
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/6/23 4:29 PM, Chris Leech wrote:
> @@ -2857,11 +2859,17 @@ void iscsi_post_host_event(uint32_t host_no, struct iscsi_transport *transport,
>  			   enum iscsi_host_event_code code, uint32_t data_size,
>  			   uint8_t *data)
>  {
> +	struct Scsi_Host *shost;
> +	struct net *net;
>  	struct nlmsghdr *nlh;
>  	struct sk_buff *skb;
>  	struct iscsi_uevent *ev;
>  	int len = nlmsg_total_size(sizeof(*ev) + data_size);
>  
> +	shost = scsi_host_lookup(host_no);
> +	if (!shost)
> +		return;
> +
>  	skb = alloc_skb(len, GFP_NOIO);
>  	if (!skb) {

Need scsi_host_put. Maybe just grab the net and do the put before the alloc_skb.


>  		printk(KERN_ERR "gracefully ignored host event (%d):%d OOM\n",
> @@ -2880,7 +2888,9 @@ void iscsi_post_host_event(uint32_t host_no, struct iscsi_transport *transport,
>  	if (data_size)
>  		memcpy((char *)ev + sizeof(*ev), data, data_size);
>  
> -	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_NOIO);
> +	net = iscsi_host_net(shost->shost_data);
> +	scsi_host_put(shost);
> +	iscsi_multicast_skb(net, skb, ISCSI_NL_GRP_ISCSID, GFP_NOIO);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_post_host_event);
>  
> @@ -2888,11 +2898,17 @@ void iscsi_ping_comp_event(uint32_t host_no, struct iscsi_transport *transport,
>  			   uint32_t status, uint32_t pid, uint32_t data_size,
>  			   uint8_t *data)
>  {
> +	struct Scsi_Host *shost;
> +	struct net *net;
>  	struct nlmsghdr *nlh;
>  	struct sk_buff *skb;
>  	struct iscsi_uevent *ev;
>  	int len = nlmsg_total_size(sizeof(*ev) + data_size);
>  
> +	shost = scsi_host_lookup(host_no);
> +	if (!shost)
> +		return;
> +
>  	skb = alloc_skb(len, GFP_NOIO);
>  	if (!skb) {

Same as above.

