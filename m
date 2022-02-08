Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B604ADF64
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384164AbiBHRWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245337AbiBHRWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:22:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81A4C061579;
        Tue,  8 Feb 2022 09:22:04 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218FmwdN011795;
        Tue, 8 Feb 2022 17:21:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=piIlYJiCWS8TGxER4EVfpSa8hBDY36y/x/DUaIaGfgk=;
 b=TcSN+kiLbnTcimHKg2FwCF3Gx5tQHuuL8+l4iLlpl7FtlIKQ0HuJzmFaoGdCXw60Lvxf
 pU5cMvntiN3cc6PqqPAA9dPlUqQYw3KT0yHAKp/ynG9r7qKh2u6Mq8njpQFG2E/26L0+
 TE3Oul/RLV7cM9ZF0q3K81vDE3Fl2oWQ/I1XTVYiQB/QQO21HXpYi0VDHdHR82vSHk/p
 YTf+U6VfDH6LIiG9Yim2wupGNOmry8ygcDym2/6Vf4HvkXjwJOzAedCd7G2SzxOupvkq
 3j7X0ppYVLEgxkJlH4v7qXhBPNVzrC884BzRDwwuz/nVm2hqFX9q8Vt4mOwDvDXCIF2g MQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e345sm12s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 17:20:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218HFYKR031282;
        Tue, 8 Feb 2022 17:20:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3020.oracle.com with ESMTP id 3e1h26nr9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 17:20:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGoiBoC6liRb7au1j6uOooVvBx/mM5OOiFPoqk6D7UC0lx9tnlsmnmAycnNRbjX/QDTb9nVvC4O3Ml043ShaTC9ETdyFG20rX/1Bd5TRZQuT6QAKuWJZhVd23+vqTknko7N+Q1DSvJH8/hRywA0hYr2k5cKvmVJ6WZLtzhgAWunb7haZOllwsSCS/3RQnynhpDcxakk3eNBvvIzIpItA4UlKbtSG0tyziMeI/OjajO0ZIAuK0YcnPfLZHJzD6k6SDGUskcAnmlIDQKW7sDuS8aRfU+Tau4wW+6JLJY5NuhPlguGnTMUi6v8iJqW40E3pD4DyrgwEnE48BflFoRYCWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piIlYJiCWS8TGxER4EVfpSa8hBDY36y/x/DUaIaGfgk=;
 b=OLMXyr1NsKu3R2QewGTkkZi8lTEuwFFv8w0lV/YcYhBE46CC5CptusPzuAaKQCRk22S4qo4jITDAgJcXq0IuSnc143ltWxS+M3Nnjr66eT5XADZ7zwW/mV5ts8gnmBN5bUGpuQUfvITgEZN6xCIcGwa7DlnRdjNeqMnUbdEB2XamYm4FJnJhrbQTkKzEMJt+NEiefGVRAZ4DDL6AWnQMw+/8BRB/Dz2tX4BZxckGUUh6OdHurHl/3/nHjFbMGvbKoezToz8cKWcIzSGKT5Iim8kJ/rlMUGdFZEPBSLiZGNX/t1b9PvQyDDk/6+Kb2EYwJr/GeGkpiD/isrhxrFxJhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piIlYJiCWS8TGxER4EVfpSa8hBDY36y/x/DUaIaGfgk=;
 b=H8N/CdwV6Wxj1zRExgUFVAJaL2bHpop9SikbNaY3pEKSrQl6FBzUP3G31Jl0ovCtxtloxOldBXXI+fkeD3OAmX6LtsGHo3Bwc2h758VpE536CVHEryab16cCvI5krZkm4ub+WAKRPHaUYdiSscUxwdEP44uPGsL5ODWzkJ15CVY=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BN6PR10MB1396.namprd10.prod.outlook.com (2603:10b6:404:44::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 17:20:53 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 17:20:53 +0000
Subject: Re: [PATCH 1/2] net: tap: track dropped skb via kfree_skb_reason()
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com
References: <20220208035510.1200-1-dongli.zhang@oracle.com>
 <20220208035510.1200-2-dongli.zhang@oracle.com>
 <53282d15-1e73-9aef-6384-3f76812480e6@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <98e16fc2-8797-9de2-a501-740503b65e5b@oracle.com>
Date:   Tue, 8 Feb 2022 09:20:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <53282d15-1e73-9aef-6384-3f76812480e6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:806:21::17) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c62744ae-d376-4b28-4f5b-08d9eb275c16
X-MS-TrafficTypeDiagnostic: BN6PR10MB1396:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1396DD8D42D7D2E093DCBECBF02D9@BN6PR10MB1396.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qXAx/xep7FvK6oRbcoj9TgM9QBazLLz1lNoFmYg4CpdjWbJdfgtdwCUDwx+9lBe6hXBNSTCKGSJpvD1cDgMpl9zGDOeBQFsys2dWa+29xUbLzfSwfsLd8c4RgBOEs7xTUnbNrBLurUBSee6RBI/9DIy/YA40GOgM8KiNfejxvuMZ0DUT8DGBe1GRYoQNCcNem1AKzqdJWOapKXh8ZRcxE9Fd8wfPeWr6lSCASlFZfxOO+kPFIIKP231aklpEAruZYfXcqOPu0NConJp0qTfs/CtburzE257p8YctMTyzp7r8WXBNJcAQzmmsWjEqGuqbzDE6jphiV8GY0XGQ4F5vcTpKEqKpXrp8UbKREmGmxQdWDMM6T0oP6FDkyl6i7snmUgSGQTaPRNDxMlM0sS0GAacJuvFi5YcgthnaS5N3Q4tLzLkp3RZnIFKvuON+VH+TuwSpoeJbkFxjJzCAJ8KpJ46uolCTLVT2LCQ3TqlLSwiJakE9meEQM3clhRjPENIyPSeaIaOLOokrZMor0EFyjUjHKxRpoC7EPGPegE6Fa1Vk8Jdp+1oNnIUoG9lPuOtCIP1rP/VpJ3I2RXsH0LAOJzXAwDTRLDzUI/ijRijBHxNzCp9G+w+uRuewjMtIZfBSuO3AUV+r7LR8JR6ZPGfu1wei7ZYId0NfOrfhAxkSI2LY4byiiLDMRaVdR3Mnyuaw9TsWmTcrcaOBlgRXcXPrHR4oguIQlv4pG9ZSUvET2wU5P/jVJzXQW3nJPDOPfo6+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(36756003)(4326008)(8676002)(66556008)(66476007)(8936002)(66946007)(110136005)(316002)(31686004)(186003)(2616005)(107886003)(83380400001)(31696002)(6486002)(6512007)(53546011)(6506007)(86362001)(7416002)(44832011)(5660300002)(38100700002)(508600001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L04xVU9BV3hUYSt4RVd3V2w2citidHhvbUVVQkw3TEpKN3dvOUFIY3FYdTJo?=
 =?utf-8?B?d0FHaXNKbFMyblkvc3NmOFpQZUtEMk5hVHo3QUIwRGFoZDNYNlk2ZGYvcFlW?=
 =?utf-8?B?M0MzZStKZFJKTzE3NWZIMnUwL1pGZkV4K0JFLzR3WDVPV0N2RUxybDBPcFNB?=
 =?utf-8?B?eHVvQVNGb0Q3Zk1qT01Yckp4REFHNmJQalpVT05BWkNpbXA2bUdRZWk1dXJB?=
 =?utf-8?B?Y0hpdWQ1NDVWNHlpUXJwbThjNXo0Sll2ZHVldGJpU0UvZ1BHRVIrQysrZUpR?=
 =?utf-8?B?VWZJNHdNd3ZoN2ZmOFV4MXdBdjdqY2VDeElJL0N6a1laL1FPRlVjc3BGNWJx?=
 =?utf-8?B?cllMeGIyMjZWRzVFakVFTm94dDQ0MWlWZFZrZUFHOENXc25PcVQzcHhGbXIr?=
 =?utf-8?B?OTFBRTFISmZIY01wN1Q5SS9Ha2czSENpa1Qva085VFV5MmhGcThaYkNGOGk0?=
 =?utf-8?B?Sm9Oc0h1cXd6blNNT0g3cDE0UWEvV1l6dnNqU05jYmxuVnVlN3FUM1lIMm9w?=
 =?utf-8?B?TWgyZEtzY09oUy9YWFphZTZhVHVqQUZ0R2pyZE5ZKzY2Q215S1dyVTB0Tmtm?=
 =?utf-8?B?K2o4bG8rRTZmRTFSZ2J4MUhpSjQ4Zjl3ZHZBUnpZOWllU1RMbkFGV2xYUHMy?=
 =?utf-8?B?OTI1MzQxQWhBajg2SEtBZml0MFhoaG10QkRobStCc3FndWd6R0hHYUdPdmJp?=
 =?utf-8?B?eHl5UkJmWTVIOEhqN3ZlRVh5cFNTMGpKWU9BeFZ3NE5PcGZISEtFMExkVDRT?=
 =?utf-8?B?R1dtODFoVXlHYUF4d0JEYWRlVk1BQkFvOHV4UDk1NlFzcVU0UktZQ3pwNTQ0?=
 =?utf-8?B?RDBiMFlWODVrWXJ2NlJ5ckVZRVhvVEVwMzh2WXJaNE9qSUM1bkFRWHR4NVhV?=
 =?utf-8?B?UlVYblY5c1ppSVpVcmVEU2dDUWtPMmViOEhZT0p3cyt6S3JsSGZPNXpQamls?=
 =?utf-8?B?SkpvVFFpWTVNQjBaMXJVK1o5TFZlVW5BMFcrbEFnVnhrWEtHWmUySWZqOUNh?=
 =?utf-8?B?T2ZpR0E0VXZkRGNjMmhyUk9aZFhEbzZBb1d2MkFyZTVvSEhRSWF3WjhEMzR4?=
 =?utf-8?B?VGtSWGgwYm9UckorSVZCcllFOHhxcHRpQ2M0a3diTDBDR3hlejlGNkNPYWli?=
 =?utf-8?B?SWRUY2d1Z25RNnV4ZFN1aTU4WWZ6dTFHVjJMRXBSZVNKYUVFTEQ4dHJnMzly?=
 =?utf-8?B?QzlCd1FzNmQvdWl1Snc5L2hCVkhORENrQ2pxZjhaakdtTHNuQmhIdEd2Nk0y?=
 =?utf-8?B?RXVXNFZDUm9IT3ZxVmhiQVZia0cxbTJmemFqQjM0MVR2cFNIbk9TMnlud1dC?=
 =?utf-8?B?RlVzNG1zaFVyKzRicmlRb0M0Zlg3aHVpcDNZODJmMkFVa3BTbXdXaDRnQ2Rx?=
 =?utf-8?B?SWc2Q1BYNEtScTdpNUhBaWtxTEpjZzR0N1k0eTYxazJLRExIam9YSEJ3bVBj?=
 =?utf-8?B?TUQyd2ZmRVRFZGJBNXlTYjhLSmZKdmhQVWNSK1NEMG8zdFZiMDBWQ05UWmZL?=
 =?utf-8?B?UVJJMkU1bkN4TVFaeVU4dEhqaDYrY1VINlJnc0FpemlpaU9xdnJyYlhzeFVB?=
 =?utf-8?B?OGc5NUhsbGxXSVlvZlVTam5mM2hKbTd3NnptbnBCZkUxQnl5S2NpSGxWTUFj?=
 =?utf-8?B?SXdHNnNrT212OG53OG9ERElUMVUvcDFHcG1iQ2JpZ3FjM2J1TEZEbUpCZlk3?=
 =?utf-8?B?RUhRQXJ4SitGUTNtNisvNjRSMTd6cGc3alk1TzlwVjV3OS9yOTg0TkJvcVlF?=
 =?utf-8?B?YVpHVXFTT2ppcStMMmRzQVJRYjFlT0FQdDBzNVp2TXI2blJ3MFJNZVBVeFR0?=
 =?utf-8?B?MGdsdGlCWHc4ZUtzTUY5N2xpZk5BTFNWVlREOHBKMFpEVEN2dXRSTGlnMkgw?=
 =?utf-8?B?SmlFWjYveDZ0YWVjYTI5UWlrNk9VdjlDdktUMlZIQXJuQWd3ZFp6T0x3WVpP?=
 =?utf-8?B?ejVCdk5kQjVBdm9oTDZtd3Z4M2lWbFU5UUE3R2ZDWlprelFLbTBiY1lVSUkz?=
 =?utf-8?B?Tk9kR3Z1QmxjOWNVNXNScnlIOXovZVBxbXV4emozZkdVK2xZamdab09Va3lt?=
 =?utf-8?B?emdCQkFXeSthei8yNVVLRW1ZQ1hkWlhsV2NVNlBQeGJCRG1PdjZRR3JNaHNK?=
 =?utf-8?B?WlZ6Mk9xUWdTcUVHb2hHcm1WSWRyZXljUDFFWStscjNieHBNZ0QzUmx6T0lP?=
 =?utf-8?B?UHhPYVllQ1J1aHlPREpkcWQzR1pMNjQxcUE3aHpqNFZkY2Q1dzJZTkFHYytv?=
 =?utf-8?B?elZkVk0zNWFPd210NUVobk4xNlZ3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c62744ae-d376-4b28-4f5b-08d9eb275c16
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 17:20:53.2259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1TmpITRoB5+gI5CR0o2P1iAYBhHjIkx9hQXLAFFakAEEGCvsc/aPIlIpBA0r+zpeU1T44TSt0pFQovluzBwIpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1396
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080104
X-Proofpoint-GUID: HBmT2HmplDKE8omQ7UwkL87rpMWNY9Ca
X-Proofpoint-ORIG-GUID: HBmT2HmplDKE8omQ7UwkL87rpMWNY9Ca
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 2/7/22 8:47 PM, David Ahern wrote:
> On 2/7/22 7:55 PM, Dongli Zhang wrote:
>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>> index 8e3a28ba6b28..232572289e63 100644
>> --- a/drivers/net/tap.c
>> +++ b/drivers/net/tap.c
>> @@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>>  	struct tap_dev *tap;
>>  	struct tap_queue *q;
>>  	netdev_features_t features = TAP_FEATURES;
>> +	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
> 
> maybe I missed an exit path, but I believe drop_reason is always set
> before a goto jump, so this init is not needed.

For tun/tap, the drop_reason is always set. I will avoid initialing the
'drop_reason'.

> 
>>  
>>  	tap = tap_dev_get_rcu(dev);
>>  	if (!tap)
>> @@ -343,12 +344,16 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>>  		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
>>  		struct sk_buff *next;
>>  
>> -		if (IS_ERR(segs))
>> +		if (IS_ERR(segs)) {
>> +			drop_reason = SKB_DROP_REASON_SKB_GSO_SEGMENT;
> 
> This reason points to a line of code, not the real reason for the drop.
> If you unwind __skb_gso_segment the only failure there is ENOMEM. The
> reason code needs to be meaningful to users, not just code references.

The __skb_gso_segment()->skb_mac_gso_segment() may return error as well.

Here I prefer to introduce a new reason because __skb_gso_segment() and
skb_gso_segment() are called at many locations.

E.g., to just select a driver that I never use.

2100 static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
2101                                   struct sk_buff_head *list)
... ...
2109                 segs = skb_gso_segment(skb, features);
2110                 if (IS_ERR(segs) || !segs)
2111                         goto drop;
... ...
2130 drop:
2131                 stats = &tp->netdev->stats;
2132                 stats->tx_dropped++;
2133                 dev_kfree_skb(skb);
2134         }

There are many such patterns. That's why I introduce a new reason for skb gso
segmentation so that developers may re-use it.

> 
> 
>>  			goto drop;
>> +		}
>>  
>>  		if (!segs) {
>> -			if (ptr_ring_produce(&q->ring, skb))
>> +			if (ptr_ring_produce(&q->ring, skb)) {
>> +				drop_reason = SKB_DROP_REASON_PTR_FULL;
> 
> similar comment to Eric - PTR_FULL needs to be more helpful.

I will use 'FULL_RING' as suggested by Eric.

> 
>>  				goto drop;
>> +			}
>>  			goto wake_up;
>>  		}
>>  
>> @@ -369,10 +374,14 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>>  		 */
>>  		if (skb->ip_summed == CHECKSUM_PARTIAL &&
>>  		    !(features & NETIF_F_CSUM_MASK) &&
>> -		    skb_checksum_help(skb))
>> +		    skb_checksum_help(skb)) {
>> +			drop_reason = SKB_DROP_REASON_SKB_CHECKSUM;
> 
> That is not helpful explanation of the root cause; it is more of a code
> reference.

To expand a function may generate a deep call graph. Any modification to the
callees in the call graph may have impact in the future.

The skb_checksum_help() is commonly used in the linux kernel to decide if there
is any error, e.g.,

 809 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 810                  int (*output)(struct net *, struct sock *, struct sk_buff *))
 811 {
... ...
 859         if (skb->ip_summed == CHECKSUM_PARTIAL &&
 860             (err = skb_checksum_help(skb)))
 861                 goto fail;
... ...
 985 fail:
 986         IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
 987                       IPSTATS_MIB_FRAGFAILS);
 988         kfree_skb(skb);
 989         return err;
 990 }

That's why I prefer to introduce a new reason, which can be used by developers
for other subsystem/drivers.

> 
> 
>>  			goto drop;
>> -		if (ptr_ring_produce(&q->ring, skb))
>> +		}
>> +		if (ptr_ring_produce(&q->ring, skb)) {
>> +			drop_reason = SKB_DROP_REASON_PTR_FULL;
> 
> ditto above comment
I will use 'FULL_RING' as suggested by Eric.

> 
>>  			goto drop;
>> +		}
>>  	}
>>  
>>  wake_up:
>> @@ -383,7 +392,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>>  	/* Count errors/drops only here, thus don't care about args. */
>>  	if (tap->count_rx_dropped)
>>  		tap->count_rx_dropped(tap);
>> -	kfree_skb(skb);
>> +	kfree_skb_reason(skb, drop_reason);
>>  	return RX_HANDLER_CONSUMED;
>>  }
>>  EXPORT_SYMBOL_GPL(tap_handle_frame);
>> @@ -632,6 +641,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>>  	int depth;
>>  	bool zerocopy = false;
>>  	size_t linear;
>> +	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
>>  
>>  	if (q->flags & IFF_VNET_HDR) {
>>  		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
>> @@ -696,8 +706,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>>  	else
>>  		err = skb_copy_datagram_from_iter(skb, 0, from, len);
>>  
>> -	if (err)
>> +	if (err) {
>> +		drop_reason = SKB_DROP_REASON_SKB_COPY_DATA;
> 
> As mentioned above, plus unwind the above functions and give a more
> explicit description of why the above fails.

The __zerocopy_sg_from_iter() and skb_copy_datagram_from_iter() are commonly
used by linux kernel. That's why a new reason is introduced. E.g.,

4924 int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
4925 {
... ...
4955         err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, size);
4956         if (err)
4957                 goto err_free;
... ...
4969 err_free:
4970         kfree_skb(skb);

After expanding the function, one of failure is due to copy_from_iter(). I think
COPY_DATA is able to represent the failure at many locations involving the
function to copy data.

Any other places involving data copy failure (e.g., due to privilege issue,
use-after-free, length issue) may re-use this reason.

> 
>>  		goto err_kfree;
>> +	}
>>  
>>  	skb_set_network_header(skb, ETH_HLEN);
>>  	skb_reset_mac_header(skb);
>> @@ -706,8 +718,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
>>  	if (vnet_hdr_len) {
>>  		err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
>>  					    tap_is_little_endian(q));
>> -		if (err)
>> +		if (err) {
>> +			drop_reason = SKB_DROP_REASON_VIRTNET_HDR;
> 
> and here too.
> 

The virtio_net_hdr_to_skb() may return error for a variety of reasons. To simply
return -EFAULT does not help.

Indeed it may help at TAP/TUN if this is the only place returning -EFAULT.
However, it is not helpful when there are two "goto drop;" returning the same
-EFAULT.

Here I am trying to introduce a virtio-net specific reason, saying the
virtio-net header is invalid. Perhaps SKB_DROP_REASON_PV_HDR (for all PV
drivers) or SKB_DROP_REASON_INVALID_METADATA.


In my opinion, the kfree_skb_reason() is not for admin, but for developer.

The admin helps run tcpdump and narrows down the location and reason that the
pakcket is dropped, while the developer conducts code analysis to identify the
specific reason.

Therefore, I think the kfree_skb_reason() should:

1. Be friendly to user (admin) to collect data (e.g., via dropwatch/ebpf/ftrace).

2. Be friendly to developer to analyze the issue.

Thank you very much!

Dongli Zhang
