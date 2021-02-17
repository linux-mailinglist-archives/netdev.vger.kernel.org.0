Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE25931D36C
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 01:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBQA0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 19:26:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35244 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhBQA0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 19:26:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11H0O7WV133864;
        Wed, 17 Feb 2021 00:25:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZQBp0ZqMrq547/rEt/E09ashwCd9qFg2pnzSajNJkFg=;
 b=lfAhoWcoEQzdVN/TvAUpV29SfQljwL637hTQw2e4H+dTq9EFc3CsEeXYL9U4nfEqMFlb
 gPhYQi74TuQD4XjL3Kd/8vqtZjraeBHqo7ISlqdqQCQ0Oh385mA2wBL+oztixUIbNlyd
 daTzHfvfQe1tEbb5J1muWTgjaqGk9+GdZ5v9OfBlZR4Xhq8IJA6Ye36Ksl06+78U7Gfe
 dkL2BP01XrzaykwsSy+efmWURA41UVbgZAIPnpgv8WPVn14c3nEiDcNsTwiwKwCfSQKE
 2mA7c+0rWoxdA/7/4lwOFvpKZpjYypc24KCmpF2TQGG+N2Mp1HpEgi065Gm1z+kG3M9G VQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36p7dngmhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 00:25:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11H0K4Kg137412;
        Wed, 17 Feb 2021 00:25:29 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2044.outbound.protection.outlook.com [104.47.73.44])
        by userp3030.oracle.com with ESMTP id 36prpxfmkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 00:25:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWEGyzI4SQugmPcxKBDVIly9C1b8QFYdEgm9Bcbks50umCbQc2gpYH8wkl3Zq4LdvsVRlguAtyuJIbLc+d8O6vaset3HwgtJWSCsVtX4vh2zIPxHTd4ub4R+68UfEJkzH8mYm2ohZaM3RdPXxBNU7wxvGgGVUpUqEdcWC+3bx6MTo9JQJeN1Hce8Lv4u3ilcGnfneNxtxPAos9QbnX3zT24xw8Y+P/vI/HTWCkxEoWx/zzVUcGPLL1D1fguSHWEQzPyf8lL0KjrkRoeHBGub5LX36QxsvfuBi90gxrFtYzd3OXgBqCpdoFkF1jg18HHl8jD374ec8arQeawJDTPYvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQBp0ZqMrq547/rEt/E09ashwCd9qFg2pnzSajNJkFg=;
 b=ayWcl0irvjGpvfUf6d5QkB2q3fsy173iSjCv9mlKgbmVHQOBp4egIl22v58mgaiiw5CV9gWm01aXTCtKgH3m+pS6tuCIsRzGGJricAwCt3Rqdymu1ODtb2sLI++PvGw60w7h5KHk3lABuNpfFxrR6oQ14Uh4vM9sAZRickhVQsk//DDReC0hvX/I0sdF2FqfT1c7VqIIOKtkgLMeBLL+yF8ouo72RWS7iRlgruIn0mZW+vz+4E8MdJVWfAQHtUGLt4j9WJiZJhNNN8u2lD1+qHSZQuVzDoaWed0qrni72w05JAl61LjhbKnJNs4NixiqrJNja/e1yunt6E8jIDQGjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQBp0ZqMrq547/rEt/E09ashwCd9qFg2pnzSajNJkFg=;
 b=KJLB/svgqKpeObvjJck0Si4rrRcdBl9+ISNTBCmxaWYZRs6URiw/tbH7Thwqp3Lo6/ISe4MB2bWYWZoQhS+jXYXC28FvJQPakyZUkPpJPrR/3Z3iHTX32pZ2jAsb2shVb9BiBC9+ygWYQPP/CKAuYs0q1VZ0pYXmn0PmmRfRAyI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SJ0PR10MB4479.namprd10.prod.outlook.com (2603:10b6:a03:2af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 17 Feb
 2021 00:25:25 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 00:25:25 +0000
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
To:     Eli Cohen <elic@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com
References: <f2206fa2-0ddc-1858-54e7-71614b142e46@redhat.com>
 <20210208063736.GA166546@mtl-vdi-166.wap.labs.mlnx>
 <0d592ed0-3cea-cfb0-9b7b-9d2755da3f12@redhat.com>
 <20210208100445.GA173340@mtl-vdi-166.wap.labs.mlnx>
 <379d79ff-c8b4-9acb-1ee4-16573b601973@redhat.com>
 <20210209061232.GC210455@mtl-vdi-166.wap.labs.mlnx>
 <411ff244-a698-a312-333a-4fdbeb3271d1@redhat.com>
 <a90dd931-43cc-e080-5886-064deb972b11@oracle.com>
 <b749313c-3a44-f6b2-f9b8-3aefa2c2d72c@redhat.com>
 <24d383db-e65c-82ff-9948-58ead3fc502b@oracle.com>
 <20210210154531.GA70716@mtl-vdi-166.wap.labs.mlnx>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <fa78717a-3707-520b-35cb-c8e37503dccf@oracle.com>
Date:   Tue, 16 Feb 2021 16:25:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210210154531.GA70716@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: SN6PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:805:de::32) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by SN6PR05CA0019.namprd05.prod.outlook.com (2603:10b6:805:de::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.17 via Frontend Transport; Wed, 17 Feb 2021 00:25:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bed86997-733b-4dad-0648-08d8d2da8457
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4479:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4479AC9A2B2C091DF0D8017BB1869@SJ0PR10MB4479.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VXhfk37GWciEVtrZ3SysigCnhLTrEsQy17raxXf2UeGjHJotXrnFNwxvwQ04o4iUKGCMtfV0xTUl1yhvCT8WSdX1GIw84UrwJSG7my8KahnOXFJZyGl8pRIkFRamYAXyWO1lYSkF7nx5YTNopRnhCtN68G0Bdv8n1nTgjyU2GgxnVRL+UxYGWobbAbmzmRsneyUZDcgO9FZLfIwcFRaLRbMf67LNlSQK4pqFyjhooR3jLV8H/Dsfj7Tze482kUp1Crkbwv2Qnb+1Ya4LH9pkbxWxQ04UpcDPxm+eSXb1M0MVurAbQZatespBwMREGA5Ci+paY5zSQTrcF3DINPk4qMIW1q0rYFKre76NQKW8FrdS6ik9OZ33Q5td0q1URWacEFTmWDqImpcUOYzN5thEGAk/H+wkgGX/c3uawoEMQssFKrszgBxCFYZcOwPDrYhN+AbRsny0APdKnAJwQ2v4guHk6X91hmBF4Vr/CPTXTpbT2plDBlwZistCAq80rVYocjQLlCJFyiafnaLTE0BTqiLiR+G6G9GFkUuVtwxpQTURRDxIyp2G6cAGyPbJkchEU/cejkHYkJvYcD4H848gfjUfCyWG9UfmrbxF7B/8ifw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(366004)(346002)(376002)(31696002)(36916002)(53546011)(83380400001)(4326008)(5660300002)(26005)(36756003)(16526019)(30864003)(8676002)(6916009)(478600001)(66556008)(66476007)(186003)(2616005)(956004)(2906002)(8936002)(16576012)(86362001)(316002)(31686004)(66946007)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UUVVNW1tdDFGL2UvSzlzcTB6Z0FDM2JkbUd6cmxGdFJEYk9HWS9Qb3ZLL3Vu?=
 =?utf-8?B?OXZzZHY1VkFHZEp1NVA3NTdETkJEVmZ5VGRxR2F3cnVHMkcyc3Q0SUovU2xy?=
 =?utf-8?B?ZUMyT3FjVkdSaENIOG52Wkw2SXIvdmsrcklNaDFPRTlMd0JFNzgwOGQxQWpU?=
 =?utf-8?B?NkIvNDV6VHBLTXJJVXN1YktZRGxRakk4dGVaMDJTMmpTdjRqNHpZSllLSEJm?=
 =?utf-8?B?dWpqaUFrWW1YRGhYRGpmTEJZVVhnT3ZGcm1TaUFrNWNJbWd0bWZJdEZJT2JL?=
 =?utf-8?B?bGpNUXUzbmxDUTAwbFlFQjJHNkVPUFhTcVhOTzdjY1hheDMzWlNwUFRyaVBp?=
 =?utf-8?B?ZEl1TW5LMVBhS2puemIwckV1MStNYkVDR3gxblVSYzM3cytkbXhwaHdKU2ZG?=
 =?utf-8?B?SWQ2SlI0OTE4QzR1aGgrS3NpTE9lRTZpc2tQRk5iRjZ4SkJHWVhMTVRHaWV2?=
 =?utf-8?B?ZjRUUGNZQlhJK3lrYzllVmtIUHpKSXdtcGtXc2E3bkJpVnkwTEkrYlNJc3hG?=
 =?utf-8?B?eTRUNGFNOU5KR0Rlam1EQlQ0NmhYQnZPYlNVT0p4bmpDd0RtSTBBQVNWVVNI?=
 =?utf-8?B?Y0VKRWMyNU5vUEc2QVRhcFQ3M2JpVmFJSmVWUHFaYnQ1OUtRb1lkRTkxcVVU?=
 =?utf-8?B?UUtQUnhBUVRzd25ZdUx0SGxmeWR4bjJDZ0JXNkw4blIwWm1zdEZ3VGtJRUV0?=
 =?utf-8?B?QWRPVFIzeW5BT1QwWlNaZnowbzg2ak1taGtZU0JzQS80Z0NPaGt3amk2UVQv?=
 =?utf-8?B?cWNHZ3lYWVlCckJGNHJvcnM2cG9YVlNIcmxKOFRibS9XeHhzM0o5WFplUWVH?=
 =?utf-8?B?QStzN2ZIUHBiWjNJWjkrTXRWaHJaZmtFQ1dGNU1oS3ZaUlNEYVp0T2VQbjYw?=
 =?utf-8?B?OXNwZENhZ2NhdUs2N0NNTERSaGt6Y252Z1UyOTIwZFlEQ2tJc3lmYnhsdnpP?=
 =?utf-8?B?YjVzcU1PVlcxREJpOHJwM0pHNjFLYzNhTjlYeVNBSnA0eWh6YUJiNDhHVVBa?=
 =?utf-8?B?Zng0NFV5ZEl5ekxXVW9zRXdzSTNiSFN0Y216TURmQkFOWWJqckdyNmo3Zy9O?=
 =?utf-8?B?Z09VOEptNUs4UnQ4MFM0SFBsbWhXVDVPNkI4ZHVpL1ZOaG1ZSnNPOGJUbU1s?=
 =?utf-8?B?NjJQaFVFUDZUdlVaTUl0d1BsMzdiSVpNTWpadnR5VzdMYUUrR212RVdVVlhx?=
 =?utf-8?B?YUc2djFTZG9iZ3Y1U1h2amxrdWRKUzlOWlFDYUh4aW93elZIbHBvNldVZWNL?=
 =?utf-8?B?R05XVjE4S2ZkTzNwVTRIa1VDQnlYMnR2bmQzSEpxQzYydGRyeU9mR1pMeFlC?=
 =?utf-8?B?aHBWRFZlVFhvTnlXaEVJanQ0NUEzaGZESDNxb1lCN2hZeEc1cXhnVzJEWUNW?=
 =?utf-8?B?Rit5RWx6Zkh0VU9rMWU4Y2NUTnNlQ3RwQ3g3U0htRCtMeTJ0aDQ5UUo2UEZs?=
 =?utf-8?B?amxBbjY3YndVR2ZMY21SU3hMNVphcEF4RVpucjltM05QcnQ3V0MyeXllNXA4?=
 =?utf-8?B?RmVuQjNkQ3BNMTZQUTM1UTE1LytEeTZwcXVnTkN0bWR0Z0ZxS1B2ald2cklV?=
 =?utf-8?B?OGpkNlljZXR4Sk5KOUdFZ0J3ZXdtZ0ZsTGxIY1N6S1VhUERQa1JMM2JsUzU3?=
 =?utf-8?B?cS95Z2ErOVJqT1c5RHQza2REK24raERMWUVBSVNGSERNcm83T0cvOVdyZlFP?=
 =?utf-8?B?L2YyckJVbjYvN2dUdkk1Mjl0aTlWQUI3Nk5yY01LeW5DVEw2RUZBZTI3RUNR?=
 =?utf-8?Q?IXddXizPTDrwUpiXrlN/SEp2hH08d/yWNfs6gMK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bed86997-733b-4dad-0648-08d8d2da8457
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 00:25:25.3665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zB/tD+VZTIdtZ51opXMY1wX4iSVnSj6nV7W8QPnopWHtJKlvYZ7FZ2zxEvQZ8Aa6hDH+qh+U1Nt23ysUtcP2QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4479
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2021 7:45 AM, Eli Cohen wrote:
> On Wed, Feb 10, 2021 at 12:59:03AM -0800, Si-Wei Liu wrote:
>>
>> On 2/9/2021 7:53 PM, Jason Wang wrote:
>>> On 2021/2/10 上午10:30, Si-Wei Liu wrote:
>>>>
>>>> On 2/8/2021 10:37 PM, Jason Wang wrote:
>>>>> On 2021/2/9 下午2:12, Eli Cohen wrote:
>>>>>> On Tue, Feb 09, 2021 at 11:20:14AM +0800, Jason Wang wrote:
>>>>>>> On 2021/2/8 下午6:04, Eli Cohen wrote:
>>>>>>>> On Mon, Feb 08, 2021 at 05:04:27PM +0800, Jason Wang wrote:
>>>>>>>>> On 2021/2/8 下午2:37, Eli Cohen wrote:
>>>>>>>>>> On Mon, Feb 08, 2021 at 12:27:18PM +0800, Jason Wang wrote:
>>>>>>>>>>> On 2021/2/6 上午7:07, Si-Wei Liu wrote:
>>>>>>>>>>>> On 2/3/2021 11:36 PM, Eli Cohen wrote:
>>>>>>>>>>>>> When a change of memory map
>>>>>>>>>>>>> occurs, the hardware resources
>>>>>>>>>>>>> are destroyed
>>>>>>>>>>>>> and then re-created again with
>>>>>>>>>>>>> the new memory map. In such
>>>>>>>>>>>>> case, we need
>>>>>>>>>>>>> to restore the hardware
>>>>>>>>>>>>> available and used indices. The
>>>>>>>>>>>>> driver failed to
>>>>>>>>>>>>> restore the used index which is added here.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Also, since the driver also
>>>>>>>>>>>>> fails to reset the available and
>>>>>>>>>>>>> used
>>>>>>>>>>>>> indices upon device reset, fix
>>>>>>>>>>>>> this here to avoid regression
>>>>>>>>>>>>> caused by
>>>>>>>>>>>>> the fact that used index may not be zero upon device reset.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Fixes: 1a86b377aa21 ("vdpa/mlx5:
>>>>>>>>>>>>> Add VDPA driver for supported
>>>>>>>>>>>>> mlx5
>>>>>>>>>>>>> devices")
>>>>>>>>>>>>> Signed-off-by: Eli Cohen<elic@nvidia.com>
>>>>>>>>>>>>> ---
>>>>>>>>>>>>> v0 -> v1:
>>>>>>>>>>>>> Clear indices upon device reset
>>>>>>>>>>>>>
>>>>>>>>>>>>>       drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++++
>>>>>>>>>>>>>       1 file changed, 18 insertions(+)
>>>>>>>>>>>>>
>>>>>>>>>>>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>>> index 88dde3455bfd..b5fe6d2ad22f 100644
>>>>>>>>>>>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>>> @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
>>>>>>>>>>>>>           u64 device_addr;
>>>>>>>>>>>>>           u64 driver_addr;
>>>>>>>>>>>>>           u16 avail_index;
>>>>>>>>>>>>> +    u16 used_index;
>>>>>>>>>>>>>           bool ready;
>>>>>>>>>>>>>           struct vdpa_callback cb;
>>>>>>>>>>>>>           bool restore;
>>>>>>>>>>>>> @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
>>>>>>>>>>>>>           u32 virtq_id;
>>>>>>>>>>>>>           struct mlx5_vdpa_net *ndev;
>>>>>>>>>>>>>           u16 avail_idx;
>>>>>>>>>>>>> +    u16 used_idx;
>>>>>>>>>>>>>           int fw_state;
>>>>>>>>>>>>>             /* keep last in the struct */
>>>>>>>>>>>>> @@ -804,6 +806,7 @@ static int
>>>>>>>>>>>>> create_virtqueue(struct
>>>>>>>>>>>>> mlx5_vdpa_net
>>>>>>>>>>>>> *ndev, struct mlx5_vdpa_virtque
>>>>>>>>>>>>>             obj_context =
>>>>>>>>>>>>> MLX5_ADDR_OF(create_virtio_net_q_in,
>>>>>>>>>>>>> in,
>>>>>>>>>>>>> obj_context);
>>>>>>>>>>>>>          
>>>>>>>>>>>>> MLX5_SET(virtio_net_q_object,
>>>>>>>>>>>>> obj_context, hw_available_index,
>>>>>>>>>>>>> mvq->avail_idx);
>>>>>>>>>>>>> +    MLX5_SET(virtio_net_q_object, obj_context, hw_used_index,
>>>>>>>>>>>>> mvq->used_idx);
>>>>>>>>>>>>>           MLX5_SET(virtio_net_q_object, obj_context,
>>>>>>>>>>>>> queue_feature_bit_mask_12_3,
>>>>>>>>>>>>> get_features_12_3(ndev->mvdev.actual_features));
>>>>>>>>>>>>>           vq_ctx =
>>>>>>>>>>>>> MLX5_ADDR_OF(virtio_net_q_object,
>>>>>>>>>>>>> obj_context,
>>>>>>>>>>>>> virtio_q_context);
>>>>>>>>>>>>> @@ -1022,6 +1025,7 @@ static int
>>>>>>>>>>>>> connect_qps(struct mlx5_vdpa_net
>>>>>>>>>>>>> *ndev, struct mlx5_vdpa_virtqueue *m
>>>>>>>>>>>>>       struct mlx5_virtq_attr {
>>>>>>>>>>>>>           u8 state;
>>>>>>>>>>>>>           u16 available_index;
>>>>>>>>>>>>> +    u16 used_index;
>>>>>>>>>>>>>       };
>>>>>>>>>>>>>         static int
>>>>>>>>>>>>> query_virtqueue(struct
>>>>>>>>>>>>> mlx5_vdpa_net *ndev, struct
>>>>>>>>>>>>> mlx5_vdpa_virtqueue *mvq,
>>>>>>>>>>>>> @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct
>>>>>>>>>>>>> mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
>>>>>>>>>>>>>           memset(attr, 0, sizeof(*attr));
>>>>>>>>>>>>>           attr->state =
>>>>>>>>>>>>> MLX5_GET(virtio_net_q_object,
>>>>>>>>>>>>> obj_context, state);
>>>>>>>>>>>>>           attr->available_index = MLX5_GET(virtio_net_q_object,
>>>>>>>>>>>>> obj_context, hw_available_index);
>>>>>>>>>>>>> +    attr->used_index =
>>>>>>>>>>>>> MLX5_GET(virtio_net_q_object,
>>>>>>>>>>>>> obj_context,
>>>>>>>>>>>>> hw_used_index);
>>>>>>>>>>>>>           kfree(out);
>>>>>>>>>>>>>           return 0;
>>>>>>>>>>>>>       @@ -1535,6 +1540,16 @@
>>>>>>>>>>>>> static void
>>>>>>>>>>>>> teardown_virtqueues(struct
>>>>>>>>>>>>> mlx5_vdpa_net *ndev)
>>>>>>>>>>>>>           }
>>>>>>>>>>>>>       }
>>>>>>>>>>>>>       +static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
>>>>>>>>>>>>> +{
>>>>>>>>>>>>> +    int i;
>>>>>>>>>>>>> +
>>>>>>>>>>>>> +    for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
>>>>>>>>>>>>> +        ndev->vqs[i].avail_idx = 0;
>>>>>>>>>>>>> +        ndev->vqs[i].used_idx = 0;
>>>>>>>>>>>>> +    }
>>>>>>>>>>>>> +}
>>>>>>>>>>>>> +
>>>>>>>>>>>>>       /* TODO: cross-endian support */
>>>>>>>>>>>>>       static inline bool
>>>>>>>>>>>>> mlx5_vdpa_is_little_endian(struct
>>>>>>>>>>>>> mlx5_vdpa_dev
>>>>>>>>>>>>> *mvdev)
>>>>>>>>>>>>>       {
>>>>>>>>>>>>> @@ -1610,6 +1625,7 @@ static int save_channel_info(struct
>>>>>>>>>>>>> mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
>>>>>>>>>>>>>               return err;
>>>>>>>>>>>>>             ri->avail_index = attr.available_index;
>>>>>>>>>>>>> +    ri->used_index = attr.used_index;
>>>>>>>>>>>>>           ri->ready = mvq->ready;
>>>>>>>>>>>>>           ri->num_ent = mvq->num_ent;
>>>>>>>>>>>>>           ri->desc_addr = mvq->desc_addr;
>>>>>>>>>>>>> @@ -1654,6 +1670,7 @@ static void restore_channels_info(struct
>>>>>>>>>>>>> mlx5_vdpa_net *ndev)
>>>>>>>>>>>>>                   continue;
>>>>>>>>>>>>>                 mvq->avail_idx = ri->avail_index;
>>>>>>>>>>>>> +        mvq->used_idx = ri->used_index;
>>>>>>>>>>>>>               mvq->ready = ri->ready;
>>>>>>>>>>>>>               mvq->num_ent = ri->num_ent;
>>>>>>>>>>>>>               mvq->desc_addr = ri->desc_addr;
>>>>>>>>>>>>> @@ -1768,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct
>>>>>>>>>>>>> vdpa_device *vdev, u8 status)
>>>>>>>>>>>>>           if (!status) {
>>>>>>>>>>>>>              
>>>>>>>>>>>>> mlx5_vdpa_info(mvdev,
>>>>>>>>>>>>> "performing device reset\n");
>>>>>>>>>>>>>               teardown_driver(ndev);
>>>>>>>>>>>>> +        clear_virtqueues(ndev);
>>>>>>>>>>>> The clearing looks fine at the first
>>>>>>>>>>>> glance, as it aligns with the other
>>>>>>>>>>>> state cleanups floating around at
>>>>>>>>>>>> the same place. However, the thing
>>>>>>>>>>>> is
>>>>>>>>>>>> get_vq_state() is supposed to be
>>>>>>>>>>>> called right after to get sync'ed
>>>>>>>>>>>> with
>>>>>>>>>>>> the latest internal avail_index from
>>>>>>>>>>>> device while vq is stopped. The
>>>>>>>>>>>> index was saved in the driver
>>>>>>>>>>>> software at vq suspension, but
>>>>>>>>>>>> before the
>>>>>>>>>>>> virtq object is destroyed. We
>>>>>>>>>>>> shouldn't clear the avail_index too
>>>>>>>>>>>> early.
>>>>>>>>>>> Good point.
>>>>>>>>>>>
>>>>>>>>>>> There's a limitation on the virtio spec
>>>>>>>>>>> and vDPA framework that we can not
>>>>>>>>>>> simply differ device suspending from device reset.
>>>>>>>>>>>
>>>>>>>>>> Are you talking about live migration where
>>>>>>>>>> you reset the device but
>>>>>>>>>> still want to know how far it progressed in
>>>>>>>>>> order to continue from the
>>>>>>>>>> same place in the new VM?
>>>>>>>>> Yes. So if we want to support live migration at we need:
>>>>>>>>>
>>>>>>>>> in src node:
>>>>>>>>> 1) suspend the device
>>>>>>>>> 2) get last_avail_idx via get_vq_state()
>>>>>>>>>
>>>>>>>>> in the dst node:
>>>>>>>>> 3) set last_avail_idx via set_vq_state()
>>>>>>>>> 4) resume the device
>>>>>>>>>
>>>>>>>>> So you can see, step 2 requires the device/driver not to forget the
>>>>>>>>> last_avail_idx.
>>>>>>>>>
>>>>>>>> Just to be sure, what really matters here is the
>>>>>>>> used index. Becuase the
>>>>>>>> vriqtueue itself is copied from the src VM to the
>>>>>>>> dest VM. The available
>>>>>>>> index is alreay there and we know the hardware reads it from there.
>>>>>>> So for "last_avail_idx" I meant the hardware internal
>>>>>>> avail index. It's not
>>>>>>> stored in the virtqueue so we must migrate it from src
>>>>>>> to dest and set them
>>>>>>> through set_vq_state(). Then in the destination, the virtqueue can be
>>>>>>> restarted from that index.
>>>>>>>
>>>>>> Consider this case: driver posted buffers till avail index becomes the
>>>>>> value 50. Hardware is executing but made it till 20 when virtqueue was
>>>>>> suspended due to live migration - this is indicated by hardware used
>>>>>> index equal 20.
>>>>>
>>>>> So in this case the used index in the virtqueue should be 20?
>>>>> Otherwise we need not sync used index itself but all the used
>>>>> entries that is not committed to the used ring.
>>>> In other word, for mlx5 vdpa there's no such internal last_avail_idx
>>>> stuff maintained by the hardware, right?
>>>
>>> For each device it should have one otherwise it won't work correctly
>>> during stop/resume. See the codes mlx5_vdpa_get_vq_state() which calls
>>> query_virtqueue() that build commands to query "last_avail_idx" from the
>>> hardware:
>>>
>>>      MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, opcode,
>>> MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
>>>      MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_type,
>>> MLX5_OBJ_TYPE_VIRTIO_NET_Q);
>>>      MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, obj_id, mvq->virtq_id);
>>>      MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
>>>      err = mlx5_cmd_exec(ndev->mvdev.mdev, in, sizeof(in), out, outlen);
>>>      if (err)
>>>          goto err_cmd;
>>>
>>>      obj_context = MLX5_ADDR_OF(query_virtio_net_q_out, out, obj_context);
>>>      memset(attr, 0, sizeof(*attr));
>>>      attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
>>>      attr->available_index = MLX5_GET(virtio_net_q_object, obj_context,
>>> hw_available_index);
>>>
>> Eli should be able to correct me, but this hw_available_index might just be
>> a cached value of virtqueue avail_index in the memory from the most recent
>> sync. I doubt it's the one you talked about in software implementation. If I
>> understand Eli correctly, hardware will always reload the latest avail_index
>> from memory whenever it's being sync'ed again.
> That's my understanding too. I am still trying to get confirmation from
> hardware guys. Will send when I have them.
>
>> <quote>
>> The hardware always goes to read the available index from memory. The
>> requirement to configure it when creating a new object is still a
>> requirement defined by the interface so I must not violate interface
>> requirments.
>> </quote>
>>
>> If the hardware does everything perfectly that is able to flush pending
>> requests, update descriptors, rings plus used indices all at once before the
>> suspension, there's no need for hardware to maintain a separate internal
>> index than the h/w used_index. The hardware can get started from the saved
>> used_index upon resuming. I view this is of (hardware) implementation
>> choices and thought it does not violate the virtio spec?
>>
>>
>>>
>>>
>>>> And the used_idx in the virtqueue is always in sync with the
>>>> hardware used_index, and hardware is supposed to commit pending used
>>>> buffers to the ring while bumping up the hardware used_index (and
>>>> also committed to memory) altogether prior to suspension, is my
>>>> understanding correct here? Double checking if this is the expected
>>>> semantics of what
>>>> modify_virtqueue(MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND) should
>>>> achieve.
>>>>
> That's my understanding too.
>
>>>> If the above is true, then it looks to me for mlx5 vdpa we should
>>>> really return h/w used_idx rather than the last_avail_idx through
>>>> get_vq_state(), in order to reconstruct the virt queue state post
>>>> live migration. For the set_map case, the internal last_avail_idx
>>>> really doesn't matter, although both indices are saved and restored
>>>> transparently as-is.
> Right, that's what I think too. In fact, I discussed that already with
> Jason over the phone yesterday. The conclusion was since the only thing
> that matters for a network device is the used index, I tried to return
> the hardware used index in get_vq_state (instead of hardware available
> index) and restore the value I get in set_vq_state into the hardware
> used index. I am still not done with this experiment but will update.
>
>>> Right, a subtle thing here is that: for the device that might have can't
>>> not complete all virtqueue requests during vq suspending, the
>>> "last_avail_idx" might not be equal to the hardware used_idx. Thing
>>> might be true for the storage devices that needs to connect to a remote
>>> backend. But this is not the case of networking device, so
>>> last_avail_idx should be equal to hardware used_idx here.
>> Eli, since it's your hardware, does it work this way? i.e. does the firmware
>> interface see a case where virtqueue requests can't be completed before
>> suspending vq?
>>
> This can happen regardless of what effort firmware does to complete all
> pending requests. An example is the hot plugging of memory. The set map
> call is called and mlx5 vdpa driver tears down the vitqueue objects
> while the guest driver can still be posting requests to the virtqueue.
> So we find ourselves in a situation and used index is behine the
> available index.
The set_map case is a bit unusual from the migration or reboot case. 
Since suspend/resume on set_map is done in a single ioctl call, I assume 
the driver is responsible for saving and restoring the used index, and 
hardware can only update used_index to the memory until the memory maps 
are fully set up (i.e. after memory keys and virtq objects get created). 
Whereas for the migration and reboot case, used_index is required to be 
sync'ed to memory for all completed requests before suspension 
(exception: network Rx path where packet drop can be tolerated). The 
procedure to resume vDPA device between these two should differ I 
suppose, but did not seem see it in the code?

>
>>> But using the "last_avail_idx" or hardware avail_idx should always be
>>> better in this case since it's guaranteed to correct and will have less
>>> confusion. We use this convention in other types of vhost backends
>>> (vhost-kernel, vhost-user).
>>>
>>> So looking at mlx5_set_vq_state(), it probably won't work since it
>>> doesn't not set either hardware avail_idx or hardware used_idx:
>> The saved mvq->avail_idx will be used to recreate hardware virtq object and
>> the used index in create_virtqueue(), once status DRIVER_OK is set. I
>> suspect we should pass the index to mvq->used_idx in
>> mlx5_vdpa_set_vq_state() below instead.
>>
> Right, that's what I am checking but still no final conclusions. I need
> to harness hardware guy to provide me with clear answers.
OK. Could you update what you find from the hardware guy and let us know 
e.g. if the current firmware interface would suffice?

Thanks,
-Siwei
>> Thanks,
>> -Siwei
>>> static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>>>                    const struct vdpa_vq_state *state)
>>> {
>>>      struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>>>      struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>>>      struct mlx5_vdpa_virtqueue *mvq = &ndev->vqs[idx];
>>>
>>>      if (mvq->fw_state == MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY) {
>>>          mlx5_vdpa_warn(mvdev, "can't modify available index\n");
>>>          return -EINVAL;
>>>      }
>>>
>>>      mvq->avail_idx = state->avail_index;
>>>      return 0;
>>> }
>>>
>>> Depends on the hardware, we should either set hardware used_idx or
>>> hardware avail_idx here.
>>>
>>> I think we need to clarify how device is supposed to work in the virtio
>>> spec.
>>>
>>> Thanks
>>>
>>>
>>>> -Siwei
>>>>
>>>>>
>>>>>> Now the vritqueue is copied to the new VM and the
>>>>>> hardware now has to continue execution from index 20. We need to tell
>>>>>> the hardware via configuring the last used_index.
>>>>>
>>>>> If the hardware can not sync the index from the virtqueue, the
>>>>> driver can do the synchronization by make the last_used_idx
>>>>> equals to used index in the virtqueue.
>>>>>
>>>>> Thanks
>>>>>
>>>>>
>>>>>>    So why don't we
>>>>>> restore the used index?
>>>>>>
>>>>>>>> So it puzzles me why is set_vq_state() we do not
>>>>>>>> communicate the saved
>>>>>>>> used index.
>>>>>>> We don't do that since:
>>>>>>>
>>>>>>> 1) if the hardware can sync its internal used index from
>>>>>>> the virtqueue
>>>>>>> during device, then we don't need it
>>>>>>> 2) if the hardware can not sync its internal used index,
>>>>>>> the driver (e.g as
>>>>>>> you did here) can do that.
>>>>>>>
>>>>>>> But there's no way for the hardware to deduce the
>>>>>>> internal avail index from
>>>>>>> the virtqueue, that's why avail index is sycned.
>>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>>

