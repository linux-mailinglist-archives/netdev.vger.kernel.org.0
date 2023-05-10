Return-Path: <netdev+bounces-1555-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B9966FE49A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E1DB1C20C1D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 19:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1946017AC1;
	Wed, 10 May 2023 19:50:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048E516413
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:50:30 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBAF1FEA;
	Wed, 10 May 2023 12:50:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ADwqJa005122;
	Wed, 10 May 2023 19:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DG6L26HrSTQpPu4uHjwRdanrXjK8w4VWvYbwI4QyjOw=;
 b=cdrOrfUPbiEmkSVZqxssb8/HlWL5ea2iui2lX3ei5W88O/o0YrjMz3clAvdqXSpOQPnU
 5d8NaeWBTDs3j6so8AjlAQlGxxEAP7/LbcurzX2lO3sGgsflOVgBGZCLjsbAPUXXQZ2y
 acV7pkI8R3lRXdfgDN4V6eyov8VJgdSYoSBcEoiTPQk/KuSVnZ30h5e4E3SF8C4BpHzy
 IN8G+Sfj1N4EH29L8amFrtOYqmPSBbSi8ew2zZLmA42ab5Ox9QSjsvqKz7PIFz6cG4ot
 WRTYXJ/BgIRu2HcyDWeh8K1X3PAXXmAkRLmROOMVKesTMTQuqBcltV3dkomBsbx3ifES Bw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qf7775fx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 May 2023 19:50:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34AIPSe8018200;
	Wed, 10 May 2023 19:50:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qf77hu2yy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 May 2023 19:50:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZbWKUPVLlXqGoxsaaS9HfTLR+DRUgqkZNAvslBmikBpBeYUw2R7niHb52g+4Wm3q+j5yzlfCMxx1nyLNC4aSTwcnvBBRJL2gubbU5I51cC56gZxwxm7NI71GtkplJD6Ts6WFSgHg+4pVbyTMnAIFwAX8+/Z9K2H2e9OKGW6qeg/PTPuTkAp8pJSw3DKmaPACeRvtOI854XEMB5vjWg/ygwhI05vKOWsh5KjSq0yQi/OJWqENhaKyGy+jNWZ7vyIgaqcHCuMjCYiwCoPT82joe0pAEW6YqlKEynD9C1wTV8WQ3kzMn+z+OPv+dxu32WLh8/vIGbQWEaKDkT+yhcjFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DG6L26HrSTQpPu4uHjwRdanrXjK8w4VWvYbwI4QyjOw=;
 b=mC7sHs8pLD/xfGNmlOHQ3ZOnYUJZKs8pZtoy4c1EmKYRpFQY/q6Kww2szuwTQUjh1eHVmXS2Pid95xbn7yRsuit/95Xe8mKM/zSFvHqvWU9yv0wIm2CMiEyaeV+Y22iDtvM4UzY1ewj1OBgrxd18Q1FyW/ldjzOOhy97KG40Xmgp69xh5d3bTl8PhcfwKZ0AxGT2P9BgtWggqCuTrgTj0S9jE3DXvWd5gC4tNalpTLT8IUPojQMe5pbfRipxplwIN7qY6RmNXAwJP0mj13b/ey1q03wAf/b+7UWcuinxEv6YXMTNtF2qX4OKN/bo3dUTGSW/mXH6ZEYU+GwCiBReDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DG6L26HrSTQpPu4uHjwRdanrXjK8w4VWvYbwI4QyjOw=;
 b=k1iryL2porcXeE5G2+AMX8RVTB9Zi0WtuGRLNEqAqrqtcwbyAsniI8GYJDoGo2oIv+nLObqwAwpHrZ0oDhRdCsvGK4kK2Q+KxNzkzSit2mNCPQ3azB21NjTG0TjC0GOZLUzg4fus+HZhh4Il9BoeL28joptpTSEGeunvffzU/tQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6051.namprd10.prod.outlook.com (2603:10b6:208:388::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 19:50:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::264c:5118:2153:91ef%12]) with mapi id 15.20.6387.020; Wed, 10 May
 2023 19:50:17 +0000
Message-ID: <3604c700-3106-dfc6-d39b-5583775be029@oracle.com>
Date: Wed, 10 May 2023 12:50:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH 03/11] iscsi: sysfs filtering by network namespace
Content-Language: en-US
To: Chris Leech <cleech@redhat.com>, Lee Duncan <lduncan@suse.com>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org
References: <20230506232930.195451-1-cleech@redhat.com>
 <20230506232930.195451-4-cleech@redhat.com>
From: michael.christie@oracle.com
In-Reply-To: <20230506232930.195451-4-cleech@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6051:EE_
X-MS-Office365-Filtering-Correlation-Id: fb48c46e-1812-41b2-ad15-08db518fc77e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	P35oOiN4teTcYyhwDHmUoj5ciGr8uFoGYo+ww+wZQ54ie0NFuR2IfwZuyiCPlaReU3/0iQ2El7L6rhWVLaCPoUxp+M1OmsbSccRUW3iDFsMo+/JsbMO8RoC9/VZvLKhylUFWenFzBrDe8xLGJxUdN4Vx7Aa0pchho8tEe9Okpf1gzdSQ7U7lg85wOuwTab/rpwDPbL6+iH8MzrZaoCA5Tja+Zb47Eq50Sa41gTRgbtgyOXVH1/k2sUklbmvczuVWe7TJgE9rRfYW/bCQS8kJzqRTjjMePYRstVFvKaaGVmCuscGAqzgS+nNyrbwEJbM653xGV0mryTzlHfn4C0xGY3vwhV4vaHDQBH5jev4CwVQ7TIRByNmx8wmsewfW9JB9mmMRCzVwWlVwL9Yu7QW6lwnJjXjrynaBju8Yam1oAjMdKLWaBHwErneft3pAQ1ALS1ti7NleBDgC5yKJ5XCiJ95KHXeImuSdttq0OAR8/XtQYYA6VrpYxLkbUiEjTEkQ9bI5ADYs1eQaRcNVcDNfxVrLwDY8kxFrjBDfNHXOBq9Wycnz+iiiu6No4Ot1rxj3eNaDx112pIUG19viFx2caKA+uLw7GGwLLx41Oy8kh0vU7aOY+uT5Jj2XVXZYEUgx
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199021)(31686004)(6666004)(66556008)(6486002)(110136005)(38100700002)(66946007)(2616005)(66476007)(316002)(31696002)(41300700001)(86362001)(8676002)(8936002)(6506007)(478600001)(53546011)(26005)(5660300002)(9686003)(6512007)(4744005)(2906002)(36756003)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OTdPOVovcTRFYkczdS9yeTVsVXByc2hzZmlNWGprOFVYVHRFNnhSOXJmSWM1?=
 =?utf-8?B?NTd3b3BhRjdYczUyaW5FNjA1VEE5aUtPblltcnZoRHdmNFBJYzZGb3N5aHRo?=
 =?utf-8?B?bU5QTS8rQk1sSWFVSEZ1eWY3alJwN0dHTEhheTRncjhsZG5KQ0Z0OGIwdC9w?=
 =?utf-8?B?N0NhcXdrV054ZE1xMXV3UHZoZGlGNmNSR0RSaHBYWTZ3amRRMUcyOU9Na2JZ?=
 =?utf-8?B?dWZJT1ExeE92bHE4bDNWbEY4RnVJUGFIeWpsS3haYjJJZXZpSHJOajc3OVVJ?=
 =?utf-8?B?WWJwWmlBNytBZit3RGtQYzUrVnpleXJaQ0phVktIRkNkaFNMZVpzdnBHeDJo?=
 =?utf-8?B?aWkxdm1QdWZsOVpwUFBIZ0ZnTTNEQVJBUlNlSFlHYkZFc3JqZGh2TEYvM0VE?=
 =?utf-8?B?ZzI5ZFF1MGJNZ0pZVkVzSFViMUgvVnNpem50Z2JPOUFPbDI5VDdOaTVnSVlL?=
 =?utf-8?B?Smk5TVAyRlNpSUFKRHpTdTdCSFJMc3NjRUZJQm5pM1MvZEZ0NGdyTDRXTi9G?=
 =?utf-8?B?WHNBZUp1ZlRLWUN2cHhlK0hCZjZsOFlrVWIvaDBlbWZCT0FYOVhYOVJVZ1ZK?=
 =?utf-8?B?WVI2amtmaFVRd29mY1FURFl3VzBDazd1dFdRUW15UjQzdU85aVVjMk1EaGx4?=
 =?utf-8?B?L0ZJcjQyWFgzY21GclBsOU1ld3JiK0NERjZsbGpCczY2RXJ3QmlQWUthcUxR?=
 =?utf-8?B?b1FaUXR2aHlZS0FVaGRqWGNyVXVReUlwcTBESjQrN2VQMFZ1YlUrTnZkSlJj?=
 =?utf-8?B?U0dYTVRxV090UVFLUlFQZUd3MW13elVXbUJadFByVjNUYkZyV2xCOCtOSm5G?=
 =?utf-8?B?bHFNaSs2ajRVc0U2Wk1wSFdJekdCWFRjRGlpSUh2UW9EeUFQQWpzMGpxdWZ5?=
 =?utf-8?B?ckl6VjhNbTFrU1hmNHFNT1R0ditWb25VbTBVaW4xdzZRU0g2QnBzTWtmOE1l?=
 =?utf-8?B?eGl6OXN6WHFiQysrdmtCYSsrNjhFYXc3Y0Y4UjBYc1ByakIxaTZYcEpQWWpQ?=
 =?utf-8?B?QkRtSlVhdDAzczlBdFFKL0llNno1eVpzRmh5RTJTWGRWVSszV0o1Y1VrOGVR?=
 =?utf-8?B?Z1VSUGFwUWhCOHRXalBNZzdMREs2MkdJeHhLN1pQV3pHRStxbFhhSnJja0p5?=
 =?utf-8?B?WlZHVUNZUnhReEZBSlMrVjExSTJXL0FQc0NWYnNZaHZGSEI2L2FZdFRPeHp3?=
 =?utf-8?B?Mjd4VzRFU2pMUWRJRmpIS0tITGpPRlFDbVJqU3ppT282aHVuSU4yNDMreEdE?=
 =?utf-8?B?YmFNdjM4cmEweTFZM25xdm1SdVF2WW1zNTJhN0Y3YmRXYTN0RFd0cytqRG0x?=
 =?utf-8?B?cGQ3UGlDNTVlNm1wZ3pFRGp0aDdvVGJVWjBMbjZWdmEvZHk3NmVTUEhhMVc3?=
 =?utf-8?B?VUdNaldKbjBkN1JmN3ArSnBrMWo5cUZ0VTVRcDBVQUFsSENaWjVoWFhwanpL?=
 =?utf-8?B?Z3VMTW9QcUNDdml6SFVva3RxZ1h5dHdDbTFLSnVwVkx1Uzl5R3lDRERWZ3VK?=
 =?utf-8?B?THAyZDhuUElFbk8rS25BRGVmR1JoZi95bGRXbDBKbnc0QVNBUFplNnpmbWkr?=
 =?utf-8?B?Yy9PS241dVlpWDJkSXp6cWsxSTBkZlAxWkNidTM1VFFuTzJIK3FnRlJPTU9Z?=
 =?utf-8?B?VFBlSzRSaFE0SXJXWUx2YitPY1hZcEcyZlVwVXlkY0c4VlhGQlhsYzhkVStH?=
 =?utf-8?B?NHVRQmYydm02V0xEb1NlWUFFSWYyVEpuVmV3N1JkQVp6SzlTUXhYOWQ5S1BY?=
 =?utf-8?B?SlJhSER3RGVhTlE1VE1hWG5OYWZFSll2MTQ4Wm53cVN1SjR3M0FzeFZ4aEZ5?=
 =?utf-8?B?N0JFWjFsdUx5T0l6YzZCaHc4eVVVbzFhK09pNkFwajJYdVFLV1NCaURqUXVQ?=
 =?utf-8?B?d2RhWDZWQW5DZklFczVJQ2ZYeTRzczhGS2M1NzZ0SmtIV1lPalZlWGwyRlp6?=
 =?utf-8?B?UkQrclZvdW9FTlZwalFvcUNqcTcyVDVkRmZ6RXJ2YVVJNzhUdmEyZTRHemYy?=
 =?utf-8?B?d1ZXVWlIdVMvQXoxTW8zTkZsZzYwZjNCZFpNckpZWmE1U3ltMG54ODkvNU00?=
 =?utf-8?B?bW9MTHNnMFEwdmo5VHprMXhzR1liT3NJR3RtSFcrTlNTSHNKMG1qaTIwMXZs?=
 =?utf-8?B?VktHdE9IdS9JeCt6YUkrL3NzdzBqTDR2bCtyTGxpME1lbTRhRjdMcXdwTkJ6?=
 =?utf-8?B?Mmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+WTj85P1KOk5ZUyviDKtudywpCF2+sIDa+2X3MlbuK9uM6ttsbjxpQ3VJ7er1IZbsY6JeTHaTVOgGJKyfw5kVnYSjMUJjFcZJgn1R0Xm9mmQ5lBlGgqY2k3r3ZGlRtt5AwotqnRWfaYI4dQDOlHY6wpkZ2Go//upDFz+UuvwBt952Og6vpistGTaKC6FN99b0P/eyaR0IvtLt7/Pv3PY/7slQftUwh83CTXqwG8XedgHC//CUm9zbsecrDhgmWmdnyZFHRcnxqocgs0XWDBhOg1MnrXNLA6hs2KiJz8pESDg389Eee8ARHd6NgJ3fHJu+U1uWUEvl0R56etEggguh4geprP1E2d9pKfoFE+7S/YdNXVd03o/+r6NgRkOx1o887YlGchMWg+iKNGRCMv4HXFayIzGusKB0aoUkTaFNgTARS9/KnP2+qf51Ta5h5m4VNGzkalS2sJwTpfVwyGFHy0lGTc9RA3pBv3u3bo4UBF0vLYQIJqX1fAuJ6+0oloyXEyXQUhHHfLofLEyuuIKOkpW+hOALxTUq34sWns7PZINTU0F5i+vt0BRLf12NANC0p5jYIw5fKoLs3LRfIj2sDySqaxDoTlF1D9ITH2G6CPicJPNYZocLQAyULa+4DoH49u5jvj5a/HcQnP2Sn35fjVYFZd45wvye6tibgVAM5LMqR/gw6Mso7hzgqyl+uVdOdbUD+vQfAja9zDB5FDVoVLSDIaBhkXEqhI9reXrc8GwkowwL72we9kexzC6tw8UgQTnfRx49950dgH/X0UqarBlY+zBWcRRIk0A4pliS8/qoDeMivO1sKn+C6OXjUzJc2lgOVt0fw4sGFdJtR4Xy6stFQRZ9RXjU8NFlhtV8zg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb48c46e-1812-41b2-ad15-08db518fc77e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 19:50:17.4410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpW7XCaFW7mICDE3RamNqJZeHy0ZoMQkd0TI5A30+9r7819pqLiqantxhzlfEYBL/hg6z0rhBomB2seEdSm2IsvSrH1B1fJy++8q404/Zzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6051
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=965 malwarescore=0
 adultscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100161
X-Proofpoint-GUID: vbv89t6G5umT7DSLCFTEsmCcAdp6DoRi
X-Proofpoint-ORIG-GUID: vbv89t6G5umT7DSLCFTEsmCcAdp6DoRi
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/6/23 4:29 PM, Chris Leech wrote:
> +#define DECLARE_TRANSPORT_CLASS_NS(cls, nm, su, rm, cfg, ns, nslookup)	\
> +struct transport_class cls = {						\
> +	.class = {							\
> +		.name = nm,						\
> +		.ns_type = ns,						\
> +		.namespace = nslookup,					\
> +	},								\
> +	.setup = su,							\
> +	.remove = rm,							\
> +	.configure = cfg,						\
> +}

I think this would be in the transport class for others to use in the future
and or you want to name it differently so it doesn't clash with the future
transport class naming. Same as other places in the patch.

