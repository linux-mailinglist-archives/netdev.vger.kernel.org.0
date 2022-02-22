Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401664C0121
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiBVSVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbiBVSVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:21:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607F0B16C5;
        Tue, 22 Feb 2022 10:21:19 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MHwtVu002393;
        Tue, 22 Feb 2022 18:20:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hAMX4u4/X6OQuI9hHMGnBnNWloEuQ0wDAksWnw4WYgw=;
 b=c6F5fiOOANHXjPznIW7ocReS0PS9pkWlDrIsZEZoxRLrJMw4i1dlx0j4Jvp0dlSEF+Iw
 lYDvgH9ab5ODNEPTO+PDOt5a87NMVQGhSUozeUrO5bAkx6UXCQkWNxBZ08gVxj5dgUpr
 bmh8GKD2Uc3BYXfpfVWpDDAvtgR4yJMKHI5hyl6FfD6BkFKDhKyJuDjkY76uVyjg9q21
 mPq+RERJb0R3iaYxX5+biqpLIf6i6JEB5O/pwxE3om7SZ9d0PnpaXnL4z3G65Z54jcKm
 uc3Jj5L4yLm3ZzbTHWZVOEoboNiMxSWxjQKWWbiHpeb+wst0omxS+6V64bczs1zna0rw NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ectsx1yq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 18:20:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21MIGedV034923;
        Tue, 22 Feb 2022 18:20:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 3eat0nb85e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 18:20:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbSDfsv56NKwuwGq+AF08us15cXJkfDnysoTqGbTd7fr2/mBAgkpojWV/jeI/k5N9Sgu2IkjGr2+eCC19wCoq/3IQluBaePvRUuxzisWomicUIZWaIgrHZlOJ8r6t0zOtFIMkUPCA3iKod0Aaw2xMtuGoCIlio7Gjp4Md2Ca+YnsGiBPAprg7YrM37BebSSXAh7h/IdkG2tWdZqLlz9cOgT0o92yGRpLVWHGm6upnXWZ15sNUG08+/7bMEsBpcVhS+sGCTd2Y80QP2myZgbiLiHh0e+ZvQZhP3DtPLKnTFzQN9Pi+iMUPwmgFrPgE5WCPBZ7rm+oLUczb4OWwxYO1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hAMX4u4/X6OQuI9hHMGnBnNWloEuQ0wDAksWnw4WYgw=;
 b=nr0ZAk5vIizxd5H1xvyguHLeleccGYf8f+qGK/Dij+HA+M4QhQv2jv2RfYGNyYIDzBwenhRA0BjQYPWxWDiz/MwUMRTt9daeCtTRVNie343RMDKa581oRWZOUndnpqefaLj5Lr05Aa0XwiJcsy8C3yvjeQZRoA88LpeczuStB28ecLQvr3N1Ojt4g3cz296c5O09eQGPJeo4pjRFye+pJa+8Mmc8kswOjF0ruQaDqmuY2H4UNtSDjLJEPAhjH6oQUA7J1ZKITUT+NlrigL6JbG4H0K4hQj2BRyHgiVRck4mahE6xDlwxGvz4eVyf3UFTGw4xg/OvY3umF8NL0RcHyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAMX4u4/X6OQuI9hHMGnBnNWloEuQ0wDAksWnw4WYgw=;
 b=cQJ9B+Dal4gypH7pTW7mRlRqs+ochK8dn2giQo+opoBaAq+FqLnOc2sMwrFkdqTh1NA9mXEq1HEjx4pl2PKxOEYnSTpVLzkTcj0V1HhJVp04KjkngwmGRh4lkOQwerpGQRQOBWu7dRlapEO+8Ir3EHLqNSz73RISfbcMCVIjxEI=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB5103.namprd10.prod.outlook.com (2603:10b6:5:3a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Tue, 22 Feb
 2022 18:20:08 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 18:20:07 +0000
Subject: Re: [PATCH net-next v3 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
 <20220221053440.7320-5-dongli.zhang@oracle.com>
 <877dfc5d-c3a1-463f-3abc-15e5827cfdb6@gmail.com>
 <6eab223b-028d-c822-01ad-47e5869e0fe8@oracle.com>
 <c25691a0-96ab-34de-4739-524cd3ab1875@gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <edddb6f9-70d1-4fcf-5630-cbdfe175e8ee@oracle.com>
Date:   Tue, 22 Feb 2022 10:20:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <c25691a0-96ab-34de-4739-524cd3ab1875@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0055.namprd05.prod.outlook.com
 (2603:10b6:803:41::32) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 061a8a1c-3485-4e3e-1c00-08d9f62ff489
X-MS-TrafficTypeDiagnostic: DS7PR10MB5103:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB510397D98BA1F5104106C66AF03B9@DS7PR10MB5103.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYlxJY/d/BU919fyQKm9a1vFLvEXgSdxNP8vmLfPv/znqj1Ywkn7bOM1LIJNq/+76TMKuP2eaHm19HhEi/5jeMKMLrF8XYjv6hGpERnL8reIzMY2/poPsbcT1Ri/kYW2ATsQueS15j0j1wahmyAThr0MokBI/dOMcCzWzxr4jMRhUAGPLWwabUPqR9Dh9K4jS12DVCwaXrbLRfNKKfDeFx6/RpFwHehwkkk/c8rsb2z9B79etISzkz4Dvf4Idy2Qyo1mF4U0r7hjB4qC3rKbQVK1xi13bUx9DrAaIeBKqNJpaRg7x0NQvwWvR2a5aujGv/nTJdSOEMTVntfEERW+HKYN4nqXYUULdNas9FSB5Yl/QF83bXWfZ9FJAiTaZRCjifua76dqFEKFnu2ZqcMDaLKqh0IVlU1N8MlFKrFiN/cD65IzPvxtWwcJwfne6ixGTPQpqg3LXHGeSqJBPMY3BdTVj6QPkid810RKhg3nVm/ONL6oGs6k/Loi0sdfuwnuJSiafh+yn/aRoFi9RXnhO/Mr0zHKOX8NhnFRTNsxGBxFUUb9oB8qnPbMurBG8c7ySWW2m5kfOShQhGmaFkdWW7kz3t4M91gfUlxvHc66SJE6qVFu/6QVd7ozBym7mpOPJxTU510cZ39CCtoF/1RQYQRd6i+a/os377Q7/i2VhRw+ZCiKcSDdobvDJRGngPzeybw4l2UP4qAfigU9onsPmaMI7tWguePiXV9VgL+lOIA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(2616005)(36756003)(44832011)(38100700002)(186003)(83380400001)(6486002)(2906002)(31686004)(8936002)(6506007)(31696002)(66556008)(5660300002)(7416002)(66476007)(53546011)(6666004)(4326008)(66946007)(8676002)(316002)(86362001)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEpRR0d6VVVsRmJMcWI1NVV1NWhoSGdxQ3V2Z0YwREgwcHZvYnE0Q0F4c2xq?=
 =?utf-8?B?WGFRY1JpaUpjVWVHNWJHQXE1Mk9DUWVnQWxoV21vSEt2QjF1OEEvL1Vtbm1B?=
 =?utf-8?B?VFdYS1ZrRHdXZ1RHbzJkSHpCT21GRUQ3eGNXRHd5K3RRWktDbjYyMys1QlNz?=
 =?utf-8?B?K3ZqT3dCdTl0U0FGZnNid2Y1UUJZQnVKUnI5QnJ6OGFxZUNHRjUrN01wVTR4?=
 =?utf-8?B?TkhDcjFyOGZWM1Y1L0gyVWpNcmMzZU1tOThPUmg2Vmk5M0VIbFQ0UUZrWGlL?=
 =?utf-8?B?SzFiUHZoTWNyQzFaWVRwTm9hOVVSajRxOWVCalpaZjZQY3NlZm1PMGI2Y05r?=
 =?utf-8?B?cHdpNkJiOGhDRlBRWFZjUExVK2tEUkozTkZjcTJHZ0N2ZzdwUDhQVXc0dVp0?=
 =?utf-8?B?Sk5QdWJ3RG12Y3lQUXViNnk4c1VxUHFvekZqOEllNW43RzBsZHVZcTY4Y016?=
 =?utf-8?B?elJKTEZ4NTNHcEdkc015R2YzTmdDbXVrM2NWaUZXTjVkYmd1dCt0ZFVKQ09E?=
 =?utf-8?B?ZHl6cGhNZnByRzR0dlJzVm9nWmNtNTJmTTFuaEU0Vml6K0Z4N1NSRFpHMnQ5?=
 =?utf-8?B?NW13NStsSTZWTnpWYk9FdUVNNVdsU205ZEpaa0t1YWQrLzJyL0ZzckZMOVND?=
 =?utf-8?B?aFRSdk40OHpnSmg3dStOTG00QUZ1aU85b2xCM3pJdnpPbUVncHRDOG9GQnAx?=
 =?utf-8?B?am9lRTlDU2Zkc1FETEVMUVQrWFBPSEJqZTA1NkpUMFJ2TnJUc1g1YW9GNlE5?=
 =?utf-8?B?ZjZOUFB4MndvUkN6L2NyRlVjeWRXNTc0OEJ2clR0YXJ2VU1BTlhRZVFDTXVh?=
 =?utf-8?B?OGFDb1JvWGVhSUE1djhHZEJJRGZQSzZ4WVhYclBGdjJSdTh4bkpTWXA3dURi?=
 =?utf-8?B?NWFSV2twV0tERTM4c0JqcmEzR2RzMWk4ZTkrcWFtMEZ2bXdCSHdyRENQSnlm?=
 =?utf-8?B?UUtVdkJremhxY3BGKzczZmZUR3YzbTNSTlZia2YzZDdUNVV6QW1vZ0tERHVC?=
 =?utf-8?B?cFcxY04wbmhtaTNZS2lwbysvZTNMRnZJNEtDa0EzbWRkZ29WTEFFODl3R3FB?=
 =?utf-8?B?WlFLWkhhZjdrZ3BXUEFvRTFGU0NoQVFOWDZ2Y1cwTHFiNWxzR3ZRWjd3aWRC?=
 =?utf-8?B?bTQyeXZSZTl6QnNvSWhtMWRHVTV0cllNUTdiRTJERktiU0NtM1ovSXVqY1ZV?=
 =?utf-8?B?KzZ3aFhSUVpPNjFGZzZwSGE5QkZ2VzhOVDRqYS90b0xoeXpicko1dHRMWXdw?=
 =?utf-8?B?aGV5VlJvaUg0UXFuYTlMazBkMGpaN1J4aHlVNk8wRXZ6ODZOcEo3bWRxZjVG?=
 =?utf-8?B?NysxWHJHeVpsS2FGK1h6eE5iR2tzeTl2ZTdIOGx5YzJzYzhaUHdtVXVpbWxC?=
 =?utf-8?B?bCtyaFptWnIwblhyVmpXUHh0M1plNFNyeFV4OEkwZXVaOThzc0dGNTNZTTdu?=
 =?utf-8?B?UjBsTHpMbjJiQWVqL29nNnlzWFlmSGlHcHlFYmNZMEx4Yi82UkVReUFhN3VS?=
 =?utf-8?B?cGJCc2tTc1h4L0U5WG1BR1loYndkZjBaK29NYWR0MWo2bTZoWURGWE4yajc3?=
 =?utf-8?B?dVNSRVV2cTBUamQ3Y2xFNXlJdVExVU1vS094bDExMTBXSEphcUg0b2tWUkVC?=
 =?utf-8?B?UHRrVzA5U3pJSTZhemkvVXRwNjdJK2JJUzJGV2k4Y2l4RFUxNlNYbDlwY0Nx?=
 =?utf-8?B?dGk1clhHb1BBcFNCejc1SkdJTTFWYUx2TkxoWlp4eWpmWXl0U0I1YU1Uc1Rp?=
 =?utf-8?B?bjB6T2crRjFaZ1RHS1VObDJ2a2hHVFdCUHgwbUR5VTJJYWd3bXV6YVQzZDRk?=
 =?utf-8?B?N3d1bXZCUy9GN3JXR1lra1B2bEJ4aGxuQWgvOGZKdVBibVIvUzBzcHhRSkJa?=
 =?utf-8?B?bTY4eXhydEtoeWJxcFNQUHpqOUJ1TWU3S3dqcHE5SHJFZWlNUVllQzhBbnh6?=
 =?utf-8?B?ZkJKczZVTzZXdDNTOUhuR2g4dEQ3UTJ0dXUvYXVicG5ZeVFuTUMvRDFGaG9M?=
 =?utf-8?B?N3BDa2t6K3RDT2NNYmRQeUZCdFBiWGQxcFk4R3VNRUJ3MzZUQjMzQm5CTndq?=
 =?utf-8?B?M0JvZkhOR09TSDJsMXlVWU9pMmVmSTE1ZHhxY21Ma1NqRE51S0VGMlJ0Ynpr?=
 =?utf-8?B?NHpMcHJ2TUxITEpZeEJKYStLWng1VGZwZGUxdEFqY2QxdnpQaWtYUFN3cysx?=
 =?utf-8?Q?OJ77wSCOVzi2mSzWBrPDn7T4XzXB0xHzueIYAotlFZ20?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061a8a1c-3485-4e3e-1c00-08d9f62ff489
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 18:20:07.8345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6zJkQOLYyDQhQZH12BJTtQIC43PuB2fiLoiyXxFmsy60CRWxKeUrTHQwFF8cacEka/6PJoH8vo+V/Li6V1Xzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5103
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266 signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202220113
X-Proofpoint-ORIG-GUID: _mjVeIRB6E12fb6NZLt5WbIUwlxkJJJY
X-Proofpoint-GUID: _mjVeIRB6E12fb6NZLt5WbIUwlxkJJJY
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

On 2/22/22 6:39 AM, David Ahern wrote:
> On 2/21/22 9:45 PM, Dongli Zhang wrote:
>> Hi David,
>>
>> On 2/21/22 7:28 PM, David Ahern wrote:
>>> On 2/20/22 10:34 PM, Dongli Zhang wrote:
>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>> index aa27268..bf7d8cd 100644
>>>> --- a/drivers/net/tun.c
>>>> +++ b/drivers/net/tun.c
>>>> @@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>>>  	struct netdev_queue *queue;
>>>>  	struct tun_file *tfile;
>>>>  	int len = skb->len;
>>>> +	enum skb_drop_reason drop_reason;
>>>
>>> this function is already honoring reverse xmas tree style, so this needs
>>> to be moved up.
>>
>> I will move this up to before "int txq = skb->queue_mapping;".
>>
>>>
>>>>  
>>>>  	rcu_read_lock();
>>>>  	tfile = rcu_dereference(tun->tfiles[txq]);
>>>>  
>>>>  	/* Drop packet if interface is not attached */
>>>> -	if (!tfile)
>>>> +	if (!tfile) {
>>>> +		drop_reason = SKB_DROP_REASON_DEV_READY;
>>>>  		goto drop;
>>>> +	}
>>>>  
>>>>  	if (!rcu_dereference(tun->steering_prog))
>>>>  		tun_automq_xmit(tun, skb);
>>>> @@ -1078,22 +1081,32 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>>>  	/* Drop if the filter does not like it.
>>>>  	 * This is a noop if the filter is disabled.
>>>>  	 * Filter can be enabled only for the TAP devices. */
>>>> -	if (!check_filter(&tun->txflt, skb))
>>>> +	if (!check_filter(&tun->txflt, skb)) {
>>>> +		drop_reason = SKB_DROP_REASON_DEV_FILTER;
>>>>  		goto drop;
>>>> +	}
>>>>  
>>>>  	if (tfile->socket.sk->sk_filter &&
>>>> -	    sk_filter(tfile->socket.sk, skb))
>>>> +	    sk_filter(tfile->socket.sk, skb)) {
>>>> +		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
>>>>  		goto drop;
>>>> +	}
>>>>  
>>>>  	len = run_ebpf_filter(tun, skb, len);
>>>> -	if (len == 0)
>>>> +	if (len == 0) {
>>>> +		drop_reason = SKB_DROP_REASON_BPF_FILTER;
>>>
>>> how does this bpf filter differ from SKB_DROP_REASON_SOCKET_FILTER? I
>>> think the reason code needs to be a little clearer on the distinction.
>>>
>>
>>
>> While there is a diff between BPF_FILTER (here) and SOCKET_FILTER ...
>>
>> ... indeed the issue is: there is NO diff between BPF_FILTER (here) and
>> DEV_FILTER (introduced by the patch).
>>
>>
>> The run_ebpf_filter() is to run the bpf filter attached to the TUN device (not
>> socket). This is similar to DEV_FILTER, which is to run a device specific filter.
>>
>> Initially, I would use DEV_FILTER at both locations. This makes trouble to me as
>> there would be two places with same reason=DEV_FILTER. I will not be able to
>> tell where the skb is dropped.
>>
>>
>> I was thinking about to introduce a SKB_DROP_REASON_DEV_BPF. While I have
>> limited experience in device specific bpf, the TUN is the only device I know
>> that has a device specific ebpf filter (by commit aff3d70a07ff ("tun: allow to
>> attach ebpf socket filter")). The SKB_DROP_REASON_DEV_BPF is not generic enough
>> to be re-used by other drivers.
>>
>>
>> Would you mind sharing your suggestion if I would re-use (1)
>> SKB_DROP_REASON_DEV_FILTER or (2) introduce a new SKB_DROP_REASON_DEV_BPF, which
>> is for sk_buff dropped by ebpf attached to device (not socket).
>>
>>
>> To answer your question, the SOCKET_FILTER is for filter attached to socket, the
>> BPF_FILTER was supposed for ebpf filter attached to device (tun->filter_prog).
>>
>>
> 
> tun/tap does have some unique filtering options. The other sets focused
> on the core networking stack is adding a drop reason of
> SKB_DROP_REASON_BPF_CGROUP_EGRESS for cgroup based egress filters.

Thank you for the explanation!

> 
> For tun unique filters, how about using a shortened version of the ioctl
> name used to set the filter.
> 

Although TUN is widely used in virtualization environment, it is only one of
many drivers. I prefer to not introduce a reason that can be used only by a
specific driver.

In order to make it more generic and more re-usable (e.g., perhaps people may
add ebpf filter to TAP driver as well), how about we create below reasons.

SKB_DROP_REASON_DEV_FILTER,     /* dropped by filter attached to
				 * or directly implemented by a
				 * specific driver
				 */
SKB_DROP_REASON_BPF_DEV,	/* dropped by bpf directly
				 * attached to a specific device,
				 * e.g., via TUNSETFILTEREBPF
				 */

We already use SKB_DROP_REASON_DEV_FILTER in this patchset. We will use
SKB_DROP_REASON_BPF_DEV for the ebpf filter attached to TUN.

Thank you very much!

Dongli Zhang
