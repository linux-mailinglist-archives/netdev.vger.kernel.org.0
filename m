Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2718F57B1B1
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiGTHZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbiGTHZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:25:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C25EDE88
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:25:37 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26K32PYB030726;
        Wed, 20 Jul 2022 07:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=MwQENBg5psiH4bsHduCXEp3dqTER1+VVfDOy+J92EMU=;
 b=clg1QBs/k+BUahUKdxPe859w6g8GwA2+cMix6FkiECkUzE7m+SY4xvseymr2xKpxXVXn
 XV3Nj25bMn2nbh4RRWMH4mMmEFDGVbBa1E8O2YOjsUio8fGX5ASQrT0xH0OCdXnyJhkR
 nZiCGYHyFBGmX7Fmhu3W5gbxzJWcrb4v7XryKhyWQ2+U4HreYfG66e84kOfOtwqhV3LT
 3jw7P9Dh/JOwDBoi+VwmL35SNidAYzaZsXSKO9iBnm20I1LhjRN6OVDovi5SPV3At9Ix
 zae+7yCpvhIbVJ4N8/ImUraruVuxjVpbiwzUO8TRpzxF5zecyonbs5gdUg5vtzmtcT1v DQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc8dnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 07:25:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26K4Hm7e002751;
        Wed, 20 Jul 2022 07:25:12 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1mbtr5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 07:25:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1Sm8LnvTj/whyEA/SOQATWHFju/sdXKxWGFSLELtErfZVacIxATLF7oFcTJxw1Vu8vmwrEpsetXkPfG9EOF1piFbN+u8/CoInIM7o+xKTzn2i3w46YPvFDWoWqlZaSMWGwzRaRaeaCc5rrLhTeKnm4f8j/6ZU1XZAOi921Uj1VhamWzYvYNDomROTSUgK7cmklGiUWXKiA4+iCIf58xJKmGsmR+oHAyPZB/WGWy2JO0GzosUX1FAYIwBYAlgMX7Q8vD/UMhdu2VP1+K18Ohf46LrOqAF+LBEBJuOsiC0Z5tOQpXUsP2iVvho/hPNjXm0oQykgH3Ynuji9H07EWP2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwQENBg5psiH4bsHduCXEp3dqTER1+VVfDOy+J92EMU=;
 b=ZEPY+oIyBmj/ElTAg7sddoXMP0TbD22rS/tTdWP9SSb5sYYxUNaRKg3JHUSdokfTOSnPLVzQgXIMs+FkeCo2sTZKhBQG7y9B3U0FqgExcxIGHLFhhwj6tgCQOA0+w1aeI5Gz/LtJ85pDkolRb+EgF+tOlYY+yCj3MDA4E+aQ2cIEpJKW5momgyKU0flsRlpUZUSJxtT/GnecPg5bkBdxaFiDQg19rfGPuyIEUqoNw9IE13Z3nSvhk3BpjaR+GKqOaqIa93JJQMuPhAFMXI+9Z3htrgaBqWTKXOWFTfS0NrKSwJotzcpBChB8sZK4pgbqE4n81WkhVU0HeQ3/UBMb4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwQENBg5psiH4bsHduCXEp3dqTER1+VVfDOy+J92EMU=;
 b=y9ZySldcKmpu9/++fAHUFs4tp3+SqV+ePV+UXZyEL5dyOfKx5LcDE7kTiCJnghta2VVDI57BDjdNhhpvRYG098tUe9W4gVHL/ogu9JkVzshbnNhv3Yrt8yRIArbl/Aa7uRf5d9EHAWhSvNSsE8vq8nZCccs24kuS+rD9Q8cfY1s=
Received: from CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24)
 by PH7PR10MB5700.namprd10.prod.outlook.com (2603:10b6:510:125::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 20 Jul
 2022 07:25:10 +0000
Received: from CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::4962:e7cb:ff05:e3f7]) by CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::4962:e7cb:ff05:e3f7%3]) with mapi id 15.20.5458.018; Wed, 20 Jul 2022
 07:25:10 +0000
Message-ID: <fc85ff14-70d6-0c3e-247d-eda2284a5f6b@oracle.com>
Date:   Wed, 20 Jul 2022 11:24:59 +0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net v3 0/3] Split "nfc: st21nfca: Refactor
 EVT_TRANSACTION" into 3
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@google.com>, kuba@kernel.org,
        krzysztof.kozlowski@linaro.org
Cc:     christophe.ricard@gmail.com, gregkh@linuxfoundation.org,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        martin.faltesek@gmail.com, netdev@vger.kernel.org,
        linux-nfc@lists.01.org, sameo@linux.intel.com, wklin@google.com,
        theflamefire89@gmail.com
References: <20220607025729.1673212-1-mfaltesek@google.com>
From:   Denis Efremov <denis.e.efremov@oracle.com>
In-Reply-To: <20220607025729.1673212-1-mfaltesek@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0109.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::6) To CO1PR10MB4627.namprd10.prod.outlook.com
 (2603:10b6:303:9d::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ecc858f-a440-4a77-eb99-08da6a20fa6b
X-MS-TrafficTypeDiagnostic: PH7PR10MB5700:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JdXbLSyA7JVzmhSbZuH4F/5nHBojo2tfFwA1qm4jjQUYsX9GQTLAPOCD7C8krZJSsQ84+ufhXMHx4vEkKAejez5E1/2uuEOS3OAa12/UBzBjqjtr8vt4ShKrFn5iV9ljUJOXA2EMn4YvfQ1C1hPmKVE4TzzYL7Tf8fS8upgUKrO9pRYaOL+A+ifaYBAxJfKW/5e1Jvl+UN4yEWXAoDLzas/Lbqj/eld29RbwdJ/KerT9kUJROI9KcYL2TlIMnYGEPAC0z8Xh8SuuttKKGSL66bIH99V+dOkRcATvJiuShsQ6o3Gsg+dXU65Q/ApWc1ziCr2K8yVl2QR/jYugUTnk1LVdk3rLBRWNsCbiMdOcYVrjMM8AWykpVZmcSRi7t+MJdpgBI+DDSufVGYFpyZmVI10VpxT4XMgVPyxD0cxb4bessCgcQ/y1dd6Rh8z169KlnAT5IXnMnYi6ze0FWYMQDBcnunmVfgVythIwGBoHdrX4ojroFXkCwDMpaYWC3uAXCP86kpwwvKxif/hsLc1t8ZLLSOZUzJU0VFCYfK7nOhiiXIvHXtqnF+/Sj8bbKgV2n/A7X5YQcOd+Zr8HFoAB2ydgRAXK5/G262h5KXp35/VJxxPFjmHkDgROuQiNzpbUqMhSBwIL9pENxkscZ6UfNoooFMJgBtPR8JjiIjLenHKOoLDXisuKGIqON58YmR/zb6xMFPiIS+WUm+fsAB8ML9N3WwaDgB4uF+yaA0smF5gD0Yo7vTzkS76fULV+io/5xojeEvZ0pPZfVFPB1jMFvSTZblxhBePclvQcLdd6o0NbeIExfPlKdYCCx+Y09sUMpEsaXrM3SYKa2m91XYRKjFcFDEYAKBTyx5kuz9OQc5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4627.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(366004)(39860400002)(376002)(186003)(2616005)(31686004)(26005)(53546011)(6512007)(83380400001)(6506007)(31696002)(86362001)(38100700002)(6666004)(66556008)(66476007)(8676002)(4326008)(2906002)(8936002)(66946007)(41300700001)(478600001)(36756003)(316002)(7416002)(5660300002)(966005)(6486002)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2VaVHBXaXFIUlBLaWxoN3lrN2hLQ2tCODBQRjRRUXRKeTZ2QzlRV0hOcXBj?=
 =?utf-8?B?bEYrbnU2NFM5VkEvdXNNTTJVelQ4VmJIckMxek0yUmgvSGE2anhFdlRySUdU?=
 =?utf-8?B?c3pVS0pMNzBZVTIydGtiKzVId1lueFhhQmtMTzRkZ3BRZEVYZ0ZUOWRRTnVx?=
 =?utf-8?B?UE5QbHBLRHJyNThrSW5xZk1KL09Vek5CMSs3RlJyTnNFT1dtU2RJUzJzN1Y3?=
 =?utf-8?B?VnVPZnAxek9zbVhkRk1qVE4yUUhFeWMzam1pRjk0dDFKVURGd2t5bnlsZEhl?=
 =?utf-8?B?akNrcGtEMXMwNWllK0JtWXFCd3M5QWZYelZxRVBwQWJ4UjdYODFvY3kwZ2FQ?=
 =?utf-8?B?SStQdkdEOCtjTUdCc0szVzN1eXpUeUxRZi9ESXhTVG5obkJxZ3RvOGlYTWcw?=
 =?utf-8?B?Z1NLKzAxbHBzVzF4Nm03YVZGSTc4YUlLckN1aHl2WnBGcEZ0eXFCZ2RQekJo?=
 =?utf-8?B?WHplU0lYYkh3Q2g1dHRHQWtHVWc4Zk54TklVV2p1NUY0S0kvL2JuU0FOb1FR?=
 =?utf-8?B?ZWRLQ0xzY1o1MDUwZ0ZFKytWZTl4V0ZpTHo4bnQ2djJDNkhzUVE5RFcweVIw?=
 =?utf-8?B?UWpCb1JGOG9UNC96T1FzWTBQNm80ekVESmpHT2tWd3BVUkRpWjRzODJBYU5W?=
 =?utf-8?B?ei9SSStRNVFNckg3cy9MRVpFNnUrV1VEWWlBUEE0eVdiWnlDTjYrVjFWZVp4?=
 =?utf-8?B?dnJOdnFkT2VZQStxNkhnVVFLVzJCRlkrOTY5cEVuaE8yOGtBNExKd0ZVQk5y?=
 =?utf-8?B?cHZqYWI4OHFaZzA1c3ZYSU1LZEk5R2Z4a1RGM2hQZ3RsSUoyYXBqQ3RkZXJa?=
 =?utf-8?B?aXBJU2RlclFuUnkwV3l1S2tpeDBrRHJhb2FYUmt0Rk45UnlrQlVEc0NOSWFC?=
 =?utf-8?B?OWZHVWl3ZzUyMlJHbGNXVlFtS20yUEExZ0Z1d0Y5d1dVZklSS25SNjUxb2lu?=
 =?utf-8?B?Z0xHMk5Sb2VCQ3B6c1BPWGZ4L1lRbTFSOFV6b1lkenhSTzlDWDd5Rm1EVzlK?=
 =?utf-8?B?MW56bVRJNFcwQzR4dFppek5PTUNqQWd2ZkgweFFKaVlyR2YwN3NncVV6bkxS?=
 =?utf-8?B?aEE5d01jQWczaHY1SDRUcXpYWlVJK0NRbjdLY1o2OERjZ3NETmNxSmpxMGsv?=
 =?utf-8?B?RXZnMUV4VG9QQTBRZ3RYUWs1MVkyTFhPU1FqK3ptaCtnRW91UDRvdVA5L3A0?=
 =?utf-8?B?MklNWmJ3QTlzZFpKZ1huYUdhM25UZlpDanM5WktXdGFiS2pPVXRiNUR3VFFZ?=
 =?utf-8?B?VVFuNEYwbnRxTEFuSFFQZHNtZ2UvMmpoR0hNOVB5dFphOHF0U2Y1bGUxcVV1?=
 =?utf-8?B?eTA2VXVjY2tZbVNwVElwVHRCaVhMbUtqTDl0OG9sMms0bGlQRnRQYzJDZEl3?=
 =?utf-8?B?di9XVXU3cERUWFZPUjZmbHhBQ1RSWlhMV1ZRWE9kQ2JxN2ZNdlM4SnpRUjZS?=
 =?utf-8?B?N0JMaEJCZ0hmSWJMeHlBTGFnczNXZk9Yb2NnTkxONlo4WGZRVDFGak9sMXJM?=
 =?utf-8?B?Rnl6TlZ1S0VmdEpSK25SRmVoRkhrWTYrQ2d1MnE0NkExUVZ3dGJqckZCRTFp?=
 =?utf-8?B?Z2hIdTRSTVB3VnFCYzRQbENycWVMamk1Slp1RnU1dkFCT0lZMGdNM1FGcGdU?=
 =?utf-8?B?TUsraTFnaUdaSzAxZTBUUll0a0F4aFRpY3lHdjNDTnBmQURSSVVZZSsvSFNF?=
 =?utf-8?B?R2xXd1BQSW0rRmw4ZU5XRjBmelRncDVsNEk0TW1xVVVEclhFWHBQYVE3Q0No?=
 =?utf-8?B?VGo2WDRDVVg2RXdoVkpDMmdvUDNPb0xqc1F6M3lHd1VFNWQxQWtuY3Nrck1C?=
 =?utf-8?B?NU4xZTlNZUFjNW5VRVpaclpaWHE1Ykp4ZGtrTGxha3RoOVNGSXlkOVlxNmZs?=
 =?utf-8?B?Um1iRGdHVGFxQjJGSzdwWGlyRkc2QkNRaThjbFc3T0dNRnp6dTZaZFJWRGxO?=
 =?utf-8?B?QU5sV2tyUWpUWjgrcXdqUVFsVUM4ZGYzanB2SHV2dktvdksrN2RMV01Salgw?=
 =?utf-8?B?dkRKRGowM1lsS01LOWtYSzNLZC9ONHNhWVJZVi9xSGlXOUNiNGJ0OWNORFNq?=
 =?utf-8?B?b0xuSDNKeEZseUtUWmZ0VThwTnhYQmx2dG1hNVJTVk9iQVFRcFRlREhMNXhP?=
 =?utf-8?B?YVhteFJKZUxoMzZqSytDQkN1cWV3bFpzOUQvRHBzSG5tVnB3OERsYjBRUW1U?=
 =?utf-8?B?dkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ecc858f-a440-4a77-eb99-08da6a20fa6b
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4627.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 07:25:10.3752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8qzjTNMJbZCOBodw6lnh+9qg7PZWVn3OortKbmxXJsoXLnNfIrDt1LyG+1DiUhG5nKMWy3m2dp1PB7T1jRhCTbu79BnpJbzMNDUL2eDLt9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5700
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_04,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207200030
X-Proofpoint-GUID: KXoZWwIZOu4iZA93iB0AGLkH-LnLyO7b
X-Proofpoint-ORIG-GUID: KXoZWwIZOu4iZA93iB0AGLkH-LnLyO7b
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 6/7/22 06:57, Martin Faltesek wrote:
> 
> Martin Faltesek (3):
>   nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
>   nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
>   nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION
> 
>  drivers/nfc/st21nfca/se.c | 53 ++++++++++++++++++++++-----------------
>  1 file changed, 30 insertions(+), 23 deletions(-)


It looks like driver st-nci contains the same problems and all 3 fixes are
also applicable to st_nci_hci_connectivity_event_received() function.
At least I can see the memory leak
https://elixir.bootlin.com/linux/v5.19-rc7/source/drivers/nfc/st-nci/se.c#L343

Can you please double check the st-nci driver and send the same fixes to it?
Reported-by: Denis Efremov <denis.e.efremov@oracle.com>

Thanks,
Denis
