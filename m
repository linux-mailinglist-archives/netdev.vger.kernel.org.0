Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B2D4CAD83
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 19:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244527AbiCBS1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241703AbiCBS1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:27:51 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD8CBDE56;
        Wed,  2 Mar 2022 10:27:08 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222HQ3fa024511;
        Wed, 2 Mar 2022 18:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=iiwDqj7VGQBS2Vezt01YmeaYOskh0GYHaiVDBBiEBOo=;
 b=X0XZtkZA1VFPrfSj6FQCYHx2+mqeS1kfkyWTouShgquMr6nU5XBHSf9N/HO7BeXuSBU+
 4mdZ2MBYNPHjXaR0N83q5YZtffeo8NVPnNCY690947Xoe+ao7edvhsP0aiIvpKmVxoMI
 zUXkVKunx2pmoRhC6jgHSFfl0EHEY9/nP47mNlOnloKtUmltOC9W88862YQfWkdMwl0E
 57/KutXnVlwDVp1W/lwgF0rmbbjM811dRt/TXNhxm7wXyY+XbAiVc/ZTLnGuWIftgMEH
 83z9rMaToOdd0QzTRNPBY6VQt+6crJLIYl6vakPuhs/HodOfasS4J+6eQafp9qjcPSCi pQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k46nrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 18:26:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 222I6riJ172573;
        Wed, 2 Mar 2022 18:26:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by aserp3020.oracle.com with ESMTP id 3efc17336f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 18:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhcLbVHQnbBMgswV9fuAbL/Uk1b8A1hpvcRLwyLQwOzaWVUpBOqzBT1iXf2ApRAFfxf82vEVxUQM8bvtDPSoeg/chOaIWm9/vc6jHEfsVm9aEYlw2aGSpv3qGSHQ6DaQyEL7zMAKt4rx669m3TvlJC8ZoW4r/1RleXLA02uUJ8CsxjurYgDXi06TZuUj9Ohi9IGbvcG/KYYVqoURs/n3BUXNxGFq8ts/V7rSRAXNhbVdBt9izLYimcopWFDdf7NQ3tkNn+41G9fgdZPjUAYwO65d2vESoqzrC2/HSNOL5P+fpX+t1FCOXna9wQwp59Ive8TJhn3k8axd4ibziRVp1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiwDqj7VGQBS2Vezt01YmeaYOskh0GYHaiVDBBiEBOo=;
 b=fkATsFmcpvVIj+2N++Q6H/jsSdD3+00+J//CM2G2h5l7ci++9pRulG3dv/iTzedlQt+ZVTaDpWUI0O66BAgda05xarD5CZW3eOM3oxKSnqwvJesClhnEyn+uyh1BKbHnqSuxkkFv/jTNVvcr5Cx0mOPxtsSt7bXS3cAUpAona9suW/OqXXtZurYPK7dILBwr2q/P1ovjy1klUVwAB1CRwp6P5vGzV3mFfefrnmCX9FCKDvMe7IWndJMu93Nl8i1Pi31/EvgJjX6hP7pzn/kaVbLbXIpfOHrurfernbrev+EzMpt2lmATQPFYTuZfuMD3yUvF2eb7WUQOw6nWRJrZHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iiwDqj7VGQBS2Vezt01YmeaYOskh0GYHaiVDBBiEBOo=;
 b=j1sA/Z2JwqVHahqS4qk8R5xYKKry+vJ2wZK23PKc0GV3yG8KFnn0MrtdItLh4nOd8vwPeI0RsndZLHwpM0Hmaa6zdELX9eG4f7L++Bic5EvI+eTcvYywbRaT2pzSMqmeZn8+7NoQw2wWzvVoawtn4vMEqMOUkCq4vaSItJPTkVs=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM5PR10MB1627.namprd10.prod.outlook.com (2603:10b6:4:4::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.26; Wed, 2 Mar 2022 18:26:08 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 18:26:08 +0000
Subject: Re: [Internet]Re: [PATCH net-next v4 4/4] net: tun: track dropped skb
 via kfree_skb_reason()
To:     =?UTF-8?B?aW1hZ2Vkb25nKOiRo+aipum+mSk=?= <imagedong@tencent.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>,
        "edumazet@google.com" <edumazet@google.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
 <20220226084929.6417-5-dongli.zhang@oracle.com>
 <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2071f8a0-148d-96fa-75b9-8277c2f87287@gmail.com>
 <7991329A-DC69-4A6D-925D-33866EF5FB7E@tencent.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <9ce6ca48-9199-dc9c-296a-7ad61fd1ac31@oracle.com>
Date:   Wed, 2 Mar 2022 10:26:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <7991329A-DC69-4A6D-925D-33866EF5FB7E@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:a03:40::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f131afd8-016c-414d-2b8d-08d9fc7a1ebb
X-MS-TrafficTypeDiagnostic: DM5PR10MB1627:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB162786688C92D7957C4EE6C1F0039@DM5PR10MB1627.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/OGyPQ0dqdU/0/P2J/+aGT7SjzJF4EuLoJ9a38Mi343pSaB/kfvrdlKu4Dse90ehw/z9jRMYbBCFQlhI3lmQhUhA4knldW9xht16D3v58M5/2gA+2ZEX8OI8bNyRQnkVGIOmtJWeNjIfJxVZudfD1T6jcPrnLVZsk7pYmobBjglRwHjHD1rC3Bcl/Ds9SZ/oy6ybylfAWGeLaGCuoldIRumsw6V6mTygbyvvkyC5oVXzkNPx5rZJW5Q5G9lsEgN/61ABzPhEbkJ1+RiEWxTU5iaiM8KoJUYaDW6BMBwXaH4iG6pBGar0LGT3bWdJd8kEsmMKdcXAgqzFbAsf1VV806q7q8B3sWy1UDmolBckC/Pn3mUdEnX+C4ZO+KV+hC9idWVnrASbASHD/blRBuJMpC8YDLIhPNaLLlsk8u2q5DpzuzcAWs/XZfRGRO9vLeLmcShxtY4wjTOlZ+8Sv576vNq5fivIwNBahXok/4fQcFOncxfQLPtsYTvqFg5PdSKa8td/L9T7SuPBzBnCvRbEwVBhH/bjnkOS4SmooxMOuaHew1Hf3yXZu9/mBvM+D0mlNwPJ5JcSie6/15io1DyMKuMX6VBEm9fGCfTbxx0fZqKkTCyfhSK/5piHBwPkcaWcJQG0Eress3rYldCrZq/OMRN00EHCVj4YumMyKDx/FgrrTOurrfcpSu/sQoWwjEfEypBthYp4BiWd8TUs+1OsQLHbrXG5xGjk7jw/38ezroBu01HPhokhXlT5GAp4UlR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(54906003)(5660300002)(110136005)(186003)(66556008)(66476007)(66946007)(6486002)(36756003)(31686004)(508600001)(6506007)(2616005)(6666004)(7416002)(53546011)(38100700002)(44832011)(4326008)(316002)(8676002)(2906002)(6512007)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkFpOGZTamhkYlRzZFJuMU56ajk0blFFSzRCT3Zra3AzNXFvMVBQSzJhaU9i?=
 =?utf-8?B?Y3NOQ3R6amlkOUtCKzhHeEt6SXhzZXVxZHoydjZ5WVViSlJWczVHNEVaa2p0?=
 =?utf-8?B?TklQbGZ1Y0hrS3ltQnl5djNHVHR1NjhaU2F6RnNPYW1QRS9ELzJpMVVNcDdT?=
 =?utf-8?B?RkNTTWw4eXhWT2lCRkxUMUkrM2xCS3ovbDNPSktmUUptWXNwM3N0ODFBYmN5?=
 =?utf-8?B?NVpDbmo1NGJCeWEvcTVpdE9pd1VoUXZjRjU2Qm9nZVc0dDNwS2MxZERJV3A4?=
 =?utf-8?B?Sko1YUlpaDUrdmZZRGtIT2IwdlAyb21uODBET2xmRUNNOW1NdnhPT0o0WFhB?=
 =?utf-8?B?TFJQOTkvaWRBcE1RTzdPVnFyOUExSnNPRTdZMjVBSGMvd3d6Wk13Nk9jTkx0?=
 =?utf-8?B?VUg4YUYveGE2YkRaSjhZQWRPWENtK2JRelFjWTJLTVNZaXdXTU5qVC9JQ2dK?=
 =?utf-8?B?VFpZSE05R0g0QWErcnBaV0l4VEwvUzJ3cXdlUDlYWmlvVUxaZUYwdC9BdlNH?=
 =?utf-8?B?MUtWVXJrNHFPYUNxQ2Z3WHVmVkZwY0JFclhXdWJpNjBvTlJneCttYVhzSzQ4?=
 =?utf-8?B?MjhGR2hDeGQ4dWVsRzdHYlVnSEhISE5IaUxGTlB3aEVidFhtdCtnL0piVHp3?=
 =?utf-8?B?YTNaNHY0T0FuWXFCTFExS3J4b0QyVEFVSWFyTi80SDBpcnFneW1ZTGxMbGNi?=
 =?utf-8?B?ZndjdnBFalBHMmx4Wmc2L1BaQVdBYXNSUXR1NXRWeDhZL1E2OEk3RjN4OGJX?=
 =?utf-8?B?dXhFZE1sY21kWUpzMlhQVDRFa2orSWQ1U1IxOWcxb0IxNUhvNlk3WGtjUlVw?=
 =?utf-8?B?OXBWbDJxTk4yWTdtektGZ2gwZlMyVDFRWmdnVFZ6VnluR3RFUkJZbzl6UG41?=
 =?utf-8?B?b3I3ZTFTZ0wvTWcyWUdPaG92YzJNVzlkM3N0ajFIYmhFYlVtZXRBeTJIcHVE?=
 =?utf-8?B?dUhTeXVpeU80V3lpOW8xMDZYempXdm5GSm5LV1lKbTdNNklDd0wyaXZjRWhw?=
 =?utf-8?B?cHc2c1RjNWYxQTJ3M1RCQUxSZlYrTG9VeDVqT09jYkxneEovM3EwT0JyelNG?=
 =?utf-8?B?QTJhbUJNajFKUXgyakpmbi9HMVhyNUxQdllUVTZrZzVLajgxZ2pPckpKWHgv?=
 =?utf-8?B?TWFLeVVSRjdhZHBVdVNxRC9Kem5aZzBrazlOZzJMb1Y3bzlhV21HSjArcGUx?=
 =?utf-8?B?dUN4SUdPSFlIbmtiMldBQmZxRlFudFNPUkUwRk9zU3F4MmY0OUx0dU5ZRW55?=
 =?utf-8?B?VERhV0trNWYwb3Y5VDZHcDJVWWNDNjVleUJ5UElmeTU1MEJESTVRUkJFekVE?=
 =?utf-8?B?K2lqbEs2QkR4dysrMWZ0WW13YnJib3hRRXU5L3FWcGphWmNRaTBnZmMvL0RB?=
 =?utf-8?B?cDJqaGhJZDE1RW1vVDhpUEJ0VFI0SjN2dWVCVW9LTzRhT25oNmkxZm40dVdw?=
 =?utf-8?B?SEN0Yk12eUR1ZDF1aktqMmk4UkNiM2k5SW1Zay8yYkZrcjVMT0k5b29udVNI?=
 =?utf-8?B?bWN6alQ4T0tlbFdieWlsODJuTHlGOFp0Y0VwYklyWlREekRqMFFlemhDVXlJ?=
 =?utf-8?B?Z2NIYjlDckl4T29nek9YNUcvcVV1YVl2VWdqWWt0V2syWEJMVVJjVmw5Q2ZI?=
 =?utf-8?B?ZjBGVEkyWWFIZmlEYytKRHJORkJ1ZHhpSC8rMVNpTFBobHNrbEExRTMzVC9N?=
 =?utf-8?B?TW9MY3RvMTBVTjhzcURaTlF0UXg0UlV2NW9mY09PVmlSVFl2L2JMUk9ERkJs?=
 =?utf-8?B?ZnpvYmR0aVpndFZFdkc1dVFJbUJQbkZ3ejlUeXBiRWZCQnJuZmdGa2FIK3l4?=
 =?utf-8?B?OSt6L1VhbUFaRkhGT25ESlZVeWNrTUFGS3dOVFdXT2xBZ0pwT3htN1VpekVU?=
 =?utf-8?B?K3c1WDUwMVU5NXcxWUVOaTBmcjZtSkl4UGZSN3BMQXhybWRRRHFZdmNXcWlr?=
 =?utf-8?B?dGM1MDk0UWQxY2FxUy9RVHB0TGxXRHRFblBGSXBrOGt3N1BFd1hDTktDZm43?=
 =?utf-8?B?S1lRbG0yb1NHZTZiRnpSbHR4WmFTTEtVeTdxQytoa2hwVFIzd3RRbW5ZamhY?=
 =?utf-8?B?b0FycUd4WDg0alVQR01ocWZnV3MrMFZsOHNFSUtzSXY0ZDVEbUlRT0lwVUE5?=
 =?utf-8?B?bDZZQkZPWXFFdStyUXAyeWZNaEV6Um1vNXRFMWl6S0hlYy96VVFzMWxmc3cz?=
 =?utf-8?B?eG9Oa2djUldGNGZPNzFJVlhONE94MnBKUlFkYktPcEsvSVdOQ3JkRUwvTi9h?=
 =?utf-8?B?S001MjVQT3FnM1cwby8yaGFWZGl3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f131afd8-016c-414d-2b8d-08d9fc7a1ebb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 18:26:08.2834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvjmkI1NQHi2C19nTvdn+Q528sVdNDud3hE6ihrl2vxTUtWFnKQNbkiwRnoOdgr7RRcSnzaiqBafAbawVHC8xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1627
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10274 signatures=686787
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020078
X-Proofpoint-ORIG-GUID: pB_LNCTY9bphtef4HtKzYX1n8ysX4a9Z
X-Proofpoint-GUID: pB_LNCTY9bphtef4HtKzYX1n8ysX4a9Z
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Menglong,

On 3/1/22 8:16 PM, imagedong(董梦龙) wrote:
> 
> 
> On 2022/3/2 AM 11:29，“David Ahern”<dsahern@gmail.com> write:
> 
>> On 3/1/22 7:50 PM, Jakub Kicinski wrote:
>>> On Sat, 26 Feb 2022 00:49:29 -0800 Dongli Zhang wrote:
>>>> +	SKB_DROP_REASON_SKB_PULL,	/* failed to pull sk_buff data */
>>>> +	SKB_DROP_REASON_SKB_TRIM,	/* failed to trim sk_buff data */
>>>
> [...]
>>>>  	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
>>>>  					 * device driver specific header
>>>>  					 */
>>>> +	SKB_DROP_REASON_DEV_READY,	/* device is not ready */
>>>
>>> What is ready? link is not up? peer not connected? can we expand?
>>
>> As I recall in this case it is the tfile for a tun device disappeared -
>> ie., a race condition.
> 
> This seems is that tun is not attached to a file (the tun device file
> is not opened?) Maybe TAP_UNATTACHED is more suitable :)
> 
> 

Thank you very much for the suggestions! TAP_UNATTACHED is more suitable.

The tap/tun are only two of drivers in linux kernel. We have already introduced
another two tap/tun specific reasons.

My concern is we may finally have too many reasons. That's why I am always
trying to define the reason as generic as possible so that they will be re-used
by most networking drivers.

We may expand the reason if it is fine to have too many reasons for skb_drop_reason.

Dongli Zhang
