Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2694AE060
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 19:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384575AbiBHSJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 13:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384579AbiBHSJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 13:09:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C22C0613C9;
        Tue,  8 Feb 2022 10:09:23 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218GVOub011035;
        Tue, 8 Feb 2022 18:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=EwZpFB06xB5F1n2xgR3CWwIoLEp9Z963hlBDe/MasK0=;
 b=D2y3zX12YVl9qCC177hyK0R00tWyhPkteQSpq3D+8BziT5qIPIw5iAhVyPVa3oFGGZIp
 DshupY/sRXgnz0ksDXc05OsUN84T6IWA0xGfQCuaDoyWlVRuwgiBi2ZqUyNjqbkpQKKx
 x4MYeB/LzD2pw02cESyy8Dl8jpqusVDV1blG1mMWb159GnLNUmljYcsbksxOlKH7Q2/0
 B4mSsbcyDE/xbwvrCTygmW2RNaJ6HexvEnla3tvsLs9MV61bcAGI1giVTgMCb1wk0Bv3
 mVXJNzMJYYNLWHhIAfzv4i6aL6iEer9Lc3CwHr+LBinYe/e1fqR73udyV63iClFGUDYu xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdst7bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 18:08:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218I27Fe139477;
        Tue, 8 Feb 2022 18:08:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3030.oracle.com with ESMTP id 3e1f9fsyba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 18:08:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7xxQSmGUJnhx4qxb0xoQCDvSMFkhRroY7eqf2w7KkQOJwb2WO2/zl0j+D4iPb8h2rBBX3p5Sg7jgLiYEkXp6761De3jqeKgdD9h9U9NTa2xSB2phLXrwdEVfJaQGU8DU78H+gaF+QndGoES8Bolz7gb/8XsO/RkdBbCoEaIFn0WuO3W4NqwaqTnPUAzluLFn34tAvbY9E0GxtI5LY7vDL7s6MU3czU7oEe0M8P4uSd9pMZ3PEr0ksxgJztsPoMtYUV/9xUEy66VygWQcxTItY/ahfiyF0U0GkHiGhsTnRmsObz579vZvE6ifUa7ADaOdC33xt1HLZU7p/gEuPxkTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwZpFB06xB5F1n2xgR3CWwIoLEp9Z963hlBDe/MasK0=;
 b=ZjviKl9tfrZbjDYx5urL5j2sKIhgFae52WyLL6fEBMuOxsiOrgIlQzJrmqCNtifzQty/aot8lIxYb2kMz1wuBpLeKaPmEJrVYdMN2av4IOckVxAmBZq4uJZtrfTnqtb3b/kFPbBGtEZanuQDILl76nMsqo58d4Q9aZcGXqOESSojvnNbscQ2xzMoRxd3cNg0cdwH/B23ccNePZFUMgZDcjwyIkXqmiK/PoMqJ4ZdOP2Zk388pZWL53ik3LuMVAWVPQGMil+NbeCNIIIR6EjXvh4kokzJN25a5LJS/eLNN78hJ7G02P7hoid4BfoF2LYY6pGRsZm1IFw+WKVr9NKjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwZpFB06xB5F1n2xgR3CWwIoLEp9Z963hlBDe/MasK0=;
 b=xQMiEmFz2Z/Rv15o2G7kDDXC1pUKa2j+EA1YxFIgJbnRZU4VedTHU5we1+zsnj/XrUqj4h1qq87zzGrTwsnyXA4gM7pTSYlgglvsg6/ANKmUV3gnr+cOqVYkQ+AkabhrFAtD/2srStdmqMOp7nrJruJkYawvZmAyJZEbDmh2qYg=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BN0PR10MB5144.namprd10.prod.outlook.com (2603:10b6:408:127::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 18:08:13 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 18:08:13 +0000
Subject: Re: [PATCH 2/2] net: tun: track dropped skb via kfree_skb_reason()
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220208035510.1200-1-dongli.zhang@oracle.com>
 <20220208035510.1200-3-dongli.zhang@oracle.com>
 <f1d1f29b-45e8-1ba3-bdbd-4c892b6a4e0f@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <1467d007-c472-1f08-1db5-c6d2ba2b3a55@oracle.com>
Date:   Tue, 8 Feb 2022 10:08:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <f1d1f29b-45e8-1ba3-bdbd-4c892b6a4e0f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0090.namprd04.prod.outlook.com
 (2603:10b6:805:f2::31) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f83392ea-1814-41de-dbeb-08d9eb2df8e7
X-MS-TrafficTypeDiagnostic: BN0PR10MB5144:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB5144B714ECEFCFD5411BFA5CF02D9@BN0PR10MB5144.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CG28dl6PGHYwwo/ncIdeBtX6wkoD3vOLr12CVny0wHYQIxoXu2jOmsUVUUR7+neOF9IZvAaXTLbQxuPQk+K80b6ZJzyRLEfbuOqxrYxy+P9gLms8WR7phmeHH+qO8I6Uj0bEAR/hh00VBD8Ca82v/ZSN3bKy//xkkqmkNSxE+cy0KIf5Zv+YQUBs5M27jROyx7qSHy2i8Gxq53+NnvkeCy7UfRJEwn7zVNhsgKj3TY60MhkmGB1qJri9zSSdYPx95n7457Fvvg9oNtDQQwgX+jxaxJs1KH0GP4ckp5z0T7n3+zFba++GWWFDWoTKMYPyqWAVCqgoR68a1PL6sTBgzWdqSG7h25YL9K9kkN0W9Zy/74k/d2Hf3m9UoqnPJdTd2DAoTHZzsE/3y2tn97ct2RzTMDQ143Dzf1vl9HhPCZfnS09BhYrdFc1n4sO1UUXddjzRtbFbpej+3mSi5LC3jZPCwUMax8yvFMQfadiHCdGbwiv+EdzJnMZZH7VH2PEPwDlK5Ms6bqwga29RKmrfWdtOsGkOuEKYbGkg7xhyymh9lRFkqTCvycVGV5Eowzm9yI2hXfDPVoWxs9uvG0MKCUYL8+8DDoTJ+qmxjP1JGC0/WjEoKdaSayhhNOYI0M1Ppe6+5tlvip2M5nTBseft1y6SvqjRaIcUp9f9Vgp5sCj7rpcE/FBd0CGNNpOWn6sc2q9iqRyrUvnC1izZ5q4cGwgUuQoXOYC/NbLd+yPhITr5e9wxIehkEbeyGbBqTOLs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(6512007)(66556008)(5660300002)(2616005)(31686004)(6506007)(31696002)(44832011)(316002)(186003)(83380400001)(8936002)(66476007)(66946007)(8676002)(4326008)(508600001)(2906002)(6486002)(86362001)(38100700002)(53546011)(6666004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2JubU1aUk1PYkRYNk9tWjl1TmN6ekFLeUVEWEZOQVVOcnB2bVowOFJYSmI1?=
 =?utf-8?B?Z3M5cjdFQ3VjbVR6S3ptNDR2aHgwc2hyVUt0YXpGS3dmWHd2cnk3TnF1YmU3?=
 =?utf-8?B?ZWxQNE5YRldUQ3pvTy8vcXJ3MEY0ZmlLQmI2bDFyWDFacFdMajVuSkMySk5o?=
 =?utf-8?B?M2lhN1pucWJ0SEovbGxLMnpta0JjZzF4Yjc0dHEvMTdqNWk0cE1pMzN6MFNm?=
 =?utf-8?B?RlJra0RxOXBGL1hXZ09ZMVhDY1pQQ3kxN1duRWtXa0lWOHBCaHhFWDlHMUxp?=
 =?utf-8?B?WEFoL3pxbFRWTHVsS1JmR2ZXaXJEVmVCMEVpMUlIRFZXRjVzNmFNcStGMmND?=
 =?utf-8?B?ZSszOGQ5dW92QUFWVWhEMEpKbnVUeGlXSnZmdjQ0VGdYNlJvRm9RakNTODBD?=
 =?utf-8?B?MFNBLzN6TDRLZzBjVDhBd01sOS9PT3kwRDBEalg5UDZjdksvUGg0U0x5ZTZr?=
 =?utf-8?B?R2trRVVZcVZRS1VudTlET0srdjErS2FrYmRXV0VOc25XQVVBcytOREJjUkh2?=
 =?utf-8?B?SEhiUTdVNTgwUjRCRzV4eGRDeCtjeXA4aGMxaUxWSEtEQnhQb21OZUJtV0Ru?=
 =?utf-8?B?L0hLeTRwREJsYldnbXhxdzVxb2tQSlBLdWtTcVRONm9hOUdDUE1OUTFMUWp2?=
 =?utf-8?B?cWxJc2dqdis5VldNWldOK3ZVMWdBSDhDRU5oWWpsMktIczZYUGNoWXdoSXBx?=
 =?utf-8?B?M3lNNG5CdXExY0dvNXNlSWFPbVJFVXc5bFo5a0ZqMHEwTEhtU20vNEpsRU9I?=
 =?utf-8?B?TmROVmVoaC9MQzhIc0c1azd2K1drTVNibjFHblV3M1p0VmtWNmpma1BYWTBS?=
 =?utf-8?B?cmZXd3BlZ3VJUE01K015blQ2Q2NSNXJ6Mk8veFcxTks3bEFxS0JzRzlnRVZh?=
 =?utf-8?B?ckhuQlM4R3Y1U3hTYWcxV3pEMGdRQjB3Z254UUxpRll1SDdsSTdLZGFoTVpl?=
 =?utf-8?B?RzdSK3ZmK21LcTJ0TjlqZUVxMUlhMmkvbXBNZWN2RFZHNG5SUnh4ME1LL3Jj?=
 =?utf-8?B?ZEJjbjR5VTMzazRJQjVCWGM2OXhJMlBjMVNYVHRxNE9mbjFIelpTblZmREJE?=
 =?utf-8?B?dkFtdGdYNks4WExocHRzUS8zVjBKNVdnbDQyMXdDRnpJVWV4VFoxWXR1QXkw?=
 =?utf-8?B?TmtYVDNGTnFNSHJCMmFCTTlQM2tZWW1xc2pFKzVmREs4aVJ2dnNodThkTkUw?=
 =?utf-8?B?bGJCRnRVQkVQNHJrMEE0cngrQ2o5RndabUY4U1Z1QStjUU5ydTlReHFvaVNZ?=
 =?utf-8?B?QVN1NzcvaWFZRUxJR0hCRDk2Rng5S05jRDA1bUVrbGRyUjZsT3NVeVlzRm5D?=
 =?utf-8?B?SVptS005UjZJdEFIRWI4ek53eHFqUENjdHhvR0NTRndkS1g1SHgwaE1NR1FH?=
 =?utf-8?B?dUpJajdMYUxIUElYT2hMUTQyam5MVW9FNjVHMkxxVVkvMnVKbTFmUXhwUzRX?=
 =?utf-8?B?a2gzRU1mVDR3TDZOV0R3V0o3RXp0QXRZYlVXQ281RjQ3a1Y3bU5MV2Qzdmc5?=
 =?utf-8?B?cXJMWjlVVFVzSTFtZCt2cGV0bDdLWkZCSGhaOHRyNERURG1RVjM2a0tQcDZR?=
 =?utf-8?B?QzdoV0lNWnpQamZrdFpvelEybU1LN0xpczVBazl4b2lWVkhYMEdta3VKaW9G?=
 =?utf-8?B?RU0rYzVuZlh3MWNTQVFuU1FRZGh1cXVsWCtRUDBiUDF0dFh5ajBraDVKWDhP?=
 =?utf-8?B?Y0FaRjRvalFaeTNDQVFzbk9Xa1NuRGJSMUVXbitINHo0MkIxMGdVb1BidUhh?=
 =?utf-8?B?MEZZdnFvdUFuV28wYzVyMldZWlpIQjdaT1VXWWdNVWNNQWNGVUhTRGViejV2?=
 =?utf-8?B?Y2YyWjlCeEl1ZUw3WGttU3RQNGI5YlBjTlFDZDI5OTFGdWNYQ1U1T3ZXanJn?=
 =?utf-8?B?VTVzWVNKNUlUQ1RMaEwrRTgrRTdZR2hiQUlUYTdDLzJZdlFXL2JrVkY2Yk5K?=
 =?utf-8?B?aFR5ZU1UVkF3Z3Y4SWlLczNrU1FMcHIrSzRaeTNmODJPakgra2dXVWFreGNY?=
 =?utf-8?B?aDIyUmFMS1dveFFGK0IrQW5SOWxETEFUYkk3aGlEUTVWQktnOWZrSHZkSUVM?=
 =?utf-8?B?STg5ZDYxL3FjckxFMTE5NVhtZ2hnMit0NUkrWnZla0xUM1NoUUpIcnJEa2Np?=
 =?utf-8?B?akRNdkJaTGR4SXNESUxKKzIyUGJpKzBCaThGQTR5Qm03NEQxM1FrY0pMU3pk?=
 =?utf-8?B?bFN4dkI5eTFXVGVvaWdoNjkvQnlHR3NEVnlnY3IxcVhLa2c4eFpieSswNmlr?=
 =?utf-8?B?TmRCM0U4N0VRWjFFVkpubXNmc1ZBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f83392ea-1814-41de-dbeb-08d9eb2df8e7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 18:08:13.3979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: saRU3u2LhJit38tu2d5Du63tAaT3/TrTd9cFjsZ6AaaxmWCfd00qZiiejv73zFYr1yXTtaK8IG/9mx9SC6xedA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5144
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080106
X-Proofpoint-GUID: o9vqhEf3Ga37b99RAL0rluOezNVwP43y
X-Proofpoint-ORIG-GUID: o9vqhEf3Ga37b99RAL0rluOezNVwP43y
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

On 2/7/22 9:03 PM, David Ahern wrote:
> On 2/7/22 7:55 PM, Dongli Zhang wrote:
>> The TUN can be used as vhost-net backend. E.g, the tun_net_xmit() is the
>> interface to forward the skb from TUN to vhost-net/virtio-net.
>>
>> However, there are many "goto drop" in the TUN driver. Therefore, the
>> kfree_skb_reason() is involved at each "goto drop" to help userspace
>> ftrace/ebpf to track the reason for the loss of packets.
>>
>> Cc: Joao Martins <joao.m.martins@oracle.com>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  drivers/net/tun.c          | 33 +++++++++++++++++++++++++--------
>>  include/linux/skbuff.h     |  6 ++++++
>>  include/trace/events/skb.h |  6 ++++++
>>  3 files changed, 37 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index fed85447701a..d67f2419dbb4 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>  	struct netdev_queue *queue;
>>  	struct tun_file *tfile;
>>  	int len = skb->len;
>> +	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
> 

I will avoid initializing here.

> 
>>  
>>  	rcu_read_lock();
>>  	tfile = rcu_dereference(tun->tfiles[txq]);
>>  
>>  	/* Drop packet if interface is not attached */
>> -	if (!tfile)
>> +	if (!tfile) {
>> +		drop_reason = SKB_DROP_REASON_DEV_NOT_ATTACHED;

Initially I was using TUN_NOT_ATTACHED. I used a more generic DEV_NOT_ATTACHED
in order to re-use the reason in the future.

How about TUN specific TUN_NOT_ATTACHED, as the core issue is because the below
is not hit.

rcu_assign_pointer(tun->tfiles[tun->numqueues], tfile);

> 
> That is going to be a confusing reason code (tap device existed to get
> here) and does not really explain this error.
> 
> 
>>  		goto drop;
>> +	}
>>  
>>  	if (!rcu_dereference(tun->steering_prog))
>>  		tun_automq_xmit(tun, skb);
>> @@ -1078,19 +1081,27 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>  	/* Drop if the filter does not like it.
>>  	 * This is a noop if the filter is disabled.
>>  	 * Filter can be enabled only for the TAP devices. */
>> -	if (!check_filter(&tun->txflt, skb))
>> +	if (!check_filter(&tun->txflt, skb)) {
>> +		drop_reason = SKB_DROP_REASON_TAP_RUN_FILTER;
> 
> just SKB_DROP_REASON_TAP_FILTER

I will use SKB_DROP_REASON_TAP_FILTER.

> 
>>  		goto drop;
>> +	}
>>  
>>  	if (tfile->socket.sk->sk_filter &&
>> -	    sk_filter(tfile->socket.sk, skb))
>> +	    sk_filter(tfile->socket.sk, skb)) {
>> +		drop_reason = SKB_DROP_REASON_SKB_TRIM;
> 
> SKB_DROP_REASON_SOCKET_FILTER

Sorry for my mistake, I should have re-used this SKB_DROP_REASON_SOCKET_FILTER.

> 
> The remainder of your changes feels like another variant of your
> previous "function / line" reason code. You are creating new reason
> codes for every goto failure with a code based name. The reason needs to
> be the essence of the failure in a user friendly label.
> 

The remainder are:

- SKB_DROP_REASON_SKB_TRIM
- SKB_DROP_REASON_SKB_ORPHAN_FRAGS
- SKB_DROP_REASON_SKB_PULL
- SKB_DROP_REASON_DEV_DOWN
- SKB_DROP_REASON_SKB_COPY_DATA (introduced by Patch 1/2)

I tried to make them self-explaining and re-usable to other developers.

Yes, I am creating new reason codes for every goto failure with a code based
name because each function might be failed due to many reasons. In addition, I
need to avoid duplicate 'drop_reason' returned by a function in order to help
developer identify the specific line of code that the sk_buff is dropped.

Thank you very much!

Dongli Zhang
