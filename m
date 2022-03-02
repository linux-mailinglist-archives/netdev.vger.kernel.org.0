Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA84D4CAC59
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 18:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244196AbiCBRpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 12:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiCBRpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 12:45:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E031CE922;
        Wed,  2 Mar 2022 09:44:31 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222HOCJL005356;
        Wed, 2 Mar 2022 17:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=V/EI1+X8H6JwbudgeTm8d7dNPZ22R8wynYRtTlqhQC0=;
 b=MC+t90ccsh7v2Q/624Qxf3jZhqvrolwCmJvaekMH9Bxw8NVM6PzwD2u3Fbme3def/pMJ
 Ih03hPMFgHNnm8RIpwaF2K0x07Ob9QRdSj5gIA6wJdNE9/z87gQn6A84g7n7LjKazYgO
 rpvfaCm2C91+ZrU7z9vGcvQK6M2NWW0RM8UL77Efde6ZbKcLfnKEc8PySjrJaqj/KaJ6
 xUID+W9JEVjeoR48eFyJPiKTx6yZPq7oPC7Rb0PH9wwYH7sA2z2dovGBhfOVCpd2FaFo
 BYGg2/9QfB9t2JYeXY2dq8uM2m20U+QsZ64T0jGG2oPXEGTs4HhK62/CpYt7sWFOyTW7 Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14bxkx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 17:43:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 222Her32108043;
        Wed, 2 Mar 2022 17:43:33 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by aserp3020.oracle.com with ESMTP id 3efc170r4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 17:43:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3xpfOTTa1Sp9QAhGCTso1YHkERwybmm0Hw2fxv++ghGVbKUTZupamc0VhVNF8ZZmC4v7auPLFJuOM/tjVTNnP0SoWPsSh899iVWb2BGr/S54lSshGbRMoTdbsnEEWgW03cPu5EgwWTG4oX24HFC0hg8MxEtg1+xM3jcI9xfSvulBS2Dwgmt5OPrqXfnwmJ+YPMxdAhwGmQB/j/vpv5VzymqEPLiy9jpQCk8WDr6GBe8X3qZi9tRgyxRv1dwN8CC222zefKctuvpNE+N49QyOiqmGN2KyqgxHrwaTZvqCj9hvI/YCj0uGlKNPztiG6IksevljQmCzwbPWw/bntm+xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/EI1+X8H6JwbudgeTm8d7dNPZ22R8wynYRtTlqhQC0=;
 b=J6u7yPUfTKpJWpmZrMPNXrTD/fv9gjX+zyyUSdv6d795SqGRzALXs8BW0i79yrl6diP1cGUqsgHR/jrz1vfhePtTCSgGG9VfH5ig3PFdJAb6wnNQfApOLjKDCf9TYIL3wLu1TkGDDMjiWuN5mivpEAJE8VXOPMkEb5FCDo/a+pdLZVP7r6p1oaJtZuqBGmM+8lpL7Au7TlINUrl0CzCKkYA7RJhNVDIXbDZGPuVyPxZUGDy2f/M8w74n4c6U9zIR2fgpPagqjL46sKPGyBsfFGjvZ8ggRfMYQlj5/yYPYS0Lg4/qMBwzdpiW3jlitEJxcWyn+tB38lYvfAcwg5wwNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/EI1+X8H6JwbudgeTm8d7dNPZ22R8wynYRtTlqhQC0=;
 b=ovCv89dZmUdINxyD6cP24MEFygqECuS5rmKs8guxqp/Rq/A+TK4XNQUCrOQ7KFdkDL7e1TC7Bmw+JXlDmcQdgmuvSW1z3lD9cqWVURBhubURPElCJZTdmBDTcgwIXg0KPaaRELA5TCyGwlItMMZNjWTDXBZSh0uWv34KXBcf9BE=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB5022.namprd10.prod.outlook.com (2603:10b6:5:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 17:43:31 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 17:43:31 +0000
Subject: Re: [PATCH net-next v4 2/4] net: tap: track dropped skb via
 kfree_skb_reason()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
 <20220226084929.6417-3-dongli.zhang@oracle.com>
 <20220301184209.1f11b350@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <0556b706-cb4d-b0b6-ef29-443123afd71d@oracle.com>
Date:   Wed, 2 Mar 2022 09:43:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220301184209.1f11b350@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::37) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4c2d14a-15fe-4e19-e2c5-08d9fc742a8f
X-MS-TrafficTypeDiagnostic: DS7PR10MB5022:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5022B73176D57A64E8820566F0039@DS7PR10MB5022.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQHscpmXuLamsdmtCODb3LHOIFhg6smjtcYH3ic9HFMTyJRUjN90E7H5BHDSkM4FyHdIIFuOcqK8azg4G0/XFCr+le1HLwvgrFY8qc7UE4eYYH9w5FFXT6itcS4r9OeyrZNUssd0lKw+LwYwJjRQWZ6+1hqOZuHfPkheogMaZOgv2mV3cjwxD/zEAWYOJzGFxOIWAf7OP5Y6kr+MDDyXR/QaqDPIqPMFFMYngRRm8u996rNMYqknft0yDRJAt35jNyhgtNJI2Dtr0gQ+XYKDVDyoVHIJITJglEGa+V/tleP62sGlRNxRK94sGMvTPNFxvm/U4MVHSvbPVHRyaElIp9HW8eCzGhGKMckxkAIiWp5qf4YTodBb5jQRTxGXTWgZpEvonZ/HcYWLwboB65GucQKYqMYBKmuwa6y0LiJeBr9b4Mv1MjCHzJIORqlq7R2wiuKDggsgnzlemWWIGtOrL7NsY5dBHUvKJgD3t32uv8qvdSO/Zx/qvIj5e0L4vZNItAPuZIcXmjNkR8Q/i3FUHtXJgN0buAWQkM6F4VlRx+gN8n3t3rBXTLnpPrZGgY5UsdZYyAh3+VPCjUyjuPlTYo3tklRPY2wtIDAVm3rZJKEr/KNyBuuIGGRIXlcG6VQlctoo3HulAsX+KpADgyqxMi4MLgpTH8fZCob/RIy5vT/Pvph6ebmxPGPG78c7dKhycxHSDAinSf/IeTLDtTOV57wfpmaZBbt1Ltgd7D7LCmOPinzRxgFOpUTG9eiIaNJb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(31696002)(8936002)(5660300002)(2906002)(38100700002)(7416002)(44832011)(186003)(2616005)(6916009)(508600001)(6506007)(6512007)(53546011)(6486002)(36756003)(66946007)(66476007)(66556008)(4326008)(8676002)(31686004)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDVQM0J0SFUvOVUrN3Y5Z0taTVdQY1pLS2VIL295N0MxL3JFNFJvZ2NLRzZI?=
 =?utf-8?B?NE1IdUxVZWsvcitnM29FSldRa3FnR0swL2F2eXVSWmpIaS9SaWlHbEtjRHo0?=
 =?utf-8?B?bjh4NWRGWjZSczMzWXd3blcydzZKbE5qZUhhMmRVNFhBY2xNZlB0NGlBbS8x?=
 =?utf-8?B?cC9hSXd6SngvSlltRHZXSmZZaCtrN3o0cVVFL2EvSk1wRW1qbEhUZjdNSlBW?=
 =?utf-8?B?MCtaeGtmajdUTVlmTTg5WkNQWWMvTklyVC91V0N4aDl2K01iLzhtVGczZi81?=
 =?utf-8?B?SXJFMXlIblpVdXVKc3dnWEJQZmFjcU5aRVRLZWxrZ05rOG9SaVdmWU5tVFpa?=
 =?utf-8?B?U1lJM3BwRDYrT21TeU1YK3Q1Y3BmMTNzdWNxMzN2LzJmOXIyTnRhYjFKa3NU?=
 =?utf-8?B?K0liaS9nZUhQZUlTeUd1bUJTdEZtNUZpUnJlZDVielBvc0tkT21Ec2pSbzJO?=
 =?utf-8?B?eVNYTTAxWllqL0Q5Y3g2WkcweTF6WjhwLzZvRUpVTDd4dm5pV21xQnRWR2Rq?=
 =?utf-8?B?ZUlzbldWVWdwSTA5bjRJOGhWR2Y5TFFRY3VBc0JzQ0FVeXBwbkJ6QXkvVldy?=
 =?utf-8?B?dGZQMmhvdTQ2RnhybTlGZjZzUDErVzhpL2thSTFoVXF2eGM3Z0NtSndVNVdu?=
 =?utf-8?B?SDBKbHZTcGFxdXBrNEU4WFptYmd3ZDVCbFBzT3g5T04zMythSzlTS1dKYmo5?=
 =?utf-8?B?VS9jUzk0WG43aDhyMkpOVzdUbXR1UGJOdmVmempIQm9TWmF3TTV6RDhlc1RZ?=
 =?utf-8?B?aGRlZmFpTXB1QkwwT0M0YWtyLzczV0VQdVZ3d2RSR2E5bWdycU5vN1MrNWp3?=
 =?utf-8?B?RFB0MkU0OEk1YjNZaHNyRzlraEVEb3p4TFRpS080YUQzUGU2V24xK2VuZG5a?=
 =?utf-8?B?ekd5OHA5RXArYWhwMkFLR281L2VXSWw3NCtVR1J4MDI3b0JXakNoSjZMWWEx?=
 =?utf-8?B?OS91T3lZRUVvTVVzUHBxZzBrK3dBSFRmMk1OU04zUkNPc2tiN1hOMFUyWEti?=
 =?utf-8?B?ZzhaWk1ubTBJUWw2VW5aa09Mdis1TC95OG50NWdJUUVvM0hkdHdGYnlGcVg4?=
 =?utf-8?B?NFI4d1JvanRLZlNaUEpkdkVXekNpLzVtYytaQXBBRTdvYXFMNlZTN3lZVkFO?=
 =?utf-8?B?eW5qTzkzZ0xSZndHMEZFbUU3VXVCNUQ0RVJVY0lmTTltdmhvME1NSDBxTy9D?=
 =?utf-8?B?MlNpWGd1RklPT3VxZ0RoZWFLcUc5cEhwSDdRa0xzTFViL281RW5UbE1zQTNh?=
 =?utf-8?B?NmJaQ1lLcDZZQ0RmTXNyK1YrV2pjSGFFa3pWdHllajBvWHFnK1FNd21zZ0ZW?=
 =?utf-8?B?cWZ3bEtaUHZMeU1kMnpYMmk0aVFnNlRoN2l4azQ4Y2NQTno5U1BvUkpaNWds?=
 =?utf-8?B?aklFNWtBQ3U4bGZGOXpseGFUdmQ2QTFiN3FWZHJ6b1NnSDlKWTV1cmFJRWpi?=
 =?utf-8?B?WGp4OTlxcllienMyTGRtQlR4S2xTTU0zSEt4dkpFOXo4UnVRQjRCUWJOUmY4?=
 =?utf-8?B?YzNGem9KZW9zWXg3RUJsZDB3YzVIOHRjYzBlSzdVdHg0NkFuSVE0MFZNelg0?=
 =?utf-8?B?K2JxS2NUN3Q5c0pYbkJsazVxZktpQzFwQVRVcUJvZ29Gai9JYXMrR29QblJn?=
 =?utf-8?B?ZCtnVHFJTXNGdzBndDdqVUhkOWxNaHlDbVZLVVN1VXRBZHk2MUk2MGFObVhH?=
 =?utf-8?B?UkRXbzVnRXN1d2FWZ1FvSUlPUHE3V0daYXRydlhPUDFDSWprTjB2V3ZrdTQv?=
 =?utf-8?B?bmNsbTFyY0xpdXFkajRncG1MOFJRQVJncFRlUHJQdFVZZWc5b2xGZThUZVZX?=
 =?utf-8?B?ZVE0KzFwc25WNjhzdVdmVmhpU2oycWx5VjBuK0xPNEhXSlF2cUxjNlRGUFgv?=
 =?utf-8?B?SDdSUGVpdUFPZU5DWEl4ZVdwb2J0YmR6QlU5Ykt3T210V0RTWFl2SE42L0hP?=
 =?utf-8?B?Vzh2VTVqVk4zZ05jcjFiY08xa1F4ZW1pNEtOeWFXOEZxakZnWHFjM2NVQ0tD?=
 =?utf-8?B?ZmdFSlgyR1pMSmhHaFZxeEhuWGN4TWF2N294MndvWjkzRG5LbnAwQk9ZY0xy?=
 =?utf-8?B?a09BK0NkWDRreVVuOFl3YmRjNGhYRHcyeGMyQ096U240TXU3dDRlZEx3WXNV?=
 =?utf-8?B?N3REUHhuRXpEeTY3bU0waFR1YXJBNzhrYThqZUw4M0tEaDl1M0RnSDN0UXpS?=
 =?utf-8?B?elI1SzVRVC8wSEtKQjR6ODIya3lSSFZ2Yk56R3lxY1B4TkhLR04rc0cyQ2wr?=
 =?utf-8?B?Mmp4aTdyQ2k3K2FhRGxKemlpMWx3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c2d14a-15fe-4e19-e2c5-08d9fc742a8f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 17:43:31.1833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o28aE79pnboI0Oi9DOjtmPowZp8mUZ2i9Jqh6xU3PK2JoQosLng5KN4JxUNRh2VNTZcMVA7mLbb5Z3b1VBZSRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5022
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10274 signatures=686787
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=920
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020077
X-Proofpoint-GUID: ZKUJXPgL-QsShNPWF89ddfKL9eYh71rZ
X-Proofpoint-ORIG-GUID: ZKUJXPgL-QsShNPWF89ddfKL9eYh71rZ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 3/1/22 6:42 PM, Jakub Kicinski wrote:
> On Sat, 26 Feb 2022 00:49:27 -0800 Dongli Zhang wrote:
>> +	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum error */
> 
> Can we spell it out a little more? It sounds like the checksum was
> incorrect. Will it be clear that computing the checksum failed, rather
> than checksum validation failed?

I am just trying to make the reasons as generic as possible so that:

1. We may minimize the number of reasons.

2. People may re-use the same reason for all CSUM related issue.

> 
>> +	SKB_DROP_REASON_SKB_COPY_DATA,	/* failed to copy data from or to
>> +					 * sk_buff
>> +					 */
> 
> Here should we specify that it's copying from user space?

Same as above. I am minimizing the number of reasons so that any memory copy for
sk_buff may re-use this reason.

Please let me know if you think it is very significant to specialize the usage
of reason. I will then add "sk_buff csum computation failed" and "userspace".

> 
>> +	SKB_DROP_REASON_SKB_GSO_SEG,	/* gso segmentation error */
>> +	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
>> +					 * device driver specific header
>> +					 */
> 
> How about:
> device driver specific header / metadata was invalid
> 
> to broaden the scope also to devices which don't transfer the metadata
> in form of a header?

I will add 'metadata'.

Thank you very much!

Dongli Zhang

> 
>> +	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
