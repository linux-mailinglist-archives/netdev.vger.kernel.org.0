Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2644B9353
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 22:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbiBPVnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 16:43:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiBPVnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 16:43:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B7215F63B
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 13:42:59 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21GKMCZ1009055;
        Wed, 16 Feb 2022 21:42:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=aayG9LiRotyrHk44Wrb/zO8wmWOQxkLazKGMUsD/jnk=;
 b=fk1IHzoyDaZ5C7A8E09FkOC+aACJJYWr4IJCtADnU6YqX8F7bJivWqmjfgtzehNhQqxq
 0s8yjAB72Wz8nVqCxG8VJWsmz9ReCh40Yb9XxeRflId4R3SV5mM8CUagPgewX7koUPo+
 LrVxp6sh1HFoeU5uNI8sQlllqkP3B8ajag+/yHTlo4ZNuXK8cueXLbfV6KMMOz0cLW1h
 fKiy/rjO5lw0oWGe4HnxrWSjZ1+5tegbsAMBBGhWlfW8SO4xObA+HSw5V8WQQoKWpaq3
 dxM1RjQAk9IcV1YVHPf5RDXYk9rQCWfXvpyGsC5VlzKz/kbbFHDPQDZ4JLtOYBv1lpcr ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nb3kejd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 21:42:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21GLbJHu125179;
        Wed, 16 Feb 2022 21:42:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 3e8nkyfuss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Feb 2022 21:42:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJiY268IaFnI/l6CsARo7mJ1xsSmf03b8SvnxNCRs+Dt/n4tILyJ5f9cto1dvpOFyFbFDUB6wXadQVFzaLqg6fvVN9zXlrA5KEodrVdplGpaE2VU/uJZP8o0pHUDTUL442OHZuF1qBo4Krlc5f5gFF3A6rtrQn5BLNzJLoNZgbAkM2uXFEpKXRAK7xQ3jRD1tetx9Zms4QzRubii5ZuFIoRl90BDMPno1FW0CTPtgkcRn5aTI1oNClnyrm4hHw6c4CEKoYITe+IUT+7q4/8BTcoooVG+DB5ebf7qlxk7ZkDlTtSB0dGYRpa908dnilapsy32VKrRYUmvxIx2KacIqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aayG9LiRotyrHk44Wrb/zO8wmWOQxkLazKGMUsD/jnk=;
 b=QafvARuABIMvRFa97n8YIlp4+mQtm7xoulCuy5hKD/Wl6+SI2K0/wzeztBji5AElRvL3nSfhfm90jf4xtWpgw7bCtuYkzzX3syiCg7BMWZWAaAKKJVzsFTdnlgMdYji+8/QlTZWkvurjOdD0ixfPn/9CuV9/8cWIdpuHJ+vxRljCWsmPjosztX3CLZUlOVSIAQhKR3ftBa18E+5LaSCHun7alE/E2gLffbephUAUC1DzZlZeENrndjZjYA9Q4apVGtwhSS/zxCwD1XqOsPTFDAWUi/Tw6N/2MlSwu9USG2pOHcMK0eezgyGkEiojlhgATqrdWiJmAld8yTDyOI2hMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aayG9LiRotyrHk44Wrb/zO8wmWOQxkLazKGMUsD/jnk=;
 b=bt4BTUkFFDHYUBBmc1JP3KEl7yYd7XCM3ufm24iOjdt2RTZlaAYGEzeedw9J/zCp21pdWvDE4CHRD70I5mErdnQJGOeE/P24vBSEOlXEaL3P0gABSH7O+DvIKEoUrTeB3U4xaLmSu6CpzSMiW72JdcmbIT76T+NcPQ8TXdgLcww=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by MWHPR10MB1776.namprd10.prod.outlook.com (2603:10b6:301:4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 21:42:53 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd%6]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 21:42:53 +0000
Message-ID: <87485606-0e15-6982-624d-34af938e8a00@oracle.com>
Date:   Wed, 16 Feb 2022 13:42:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v1 2/4] vdpa: Allow for printing negotiated features of a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        jasowang@redhat.com, lulu@redhat.com
References: <20220210133115.115967-1-elic@nvidia.com>
 <20220210133115.115967-3-elic@nvidia.com>
 <51789e9b-4080-acb1-8b8b-2cf3f5d6a0f9@oracle.com>
 <20220215151627.GA2109@mtl-vdi-166.wap.labs.mlnx>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220215151627.GA2109@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c34949f4-0e0a-40b5-a89e-08d9f19548f2
X-MS-TrafficTypeDiagnostic: MWHPR10MB1776:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1776BBD2B8071A0544F56E3FB1359@MWHPR10MB1776.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwAhsGP0iUdcVvA6VP30C09rBoBTjdbScJMazSQcuogbJ/cRz1a6tP+LgKBX7V2cdHWnnNYWYTvrt3kfLGLfKiCQVYLbvJufjEhK4BCaCLuTRNwy4AgEmr1OJDeiFAASHGFg72hKiZ78oII5XUl5eFrFtWOsFalxbYpl2e37GJ8YemmUULpsTpqq0FauECcbjBpKcTJpDclApIyLAOsRUeISLbZTCTm0X0sEy5N6EGMphfVpEUDxfNrJk7B2Zkwk6hAEMGmj+QqoZRtSC2BmCIVBctjIYPFBJSTmkjn3RxKe+MFcbPJqrguHZwXjTAiJfJTkBDLMV3AGETDyCr7fCBj9cyh2h1gXqKf7s/nwXP5zRmacHlILpeLmeXigs+5VHepVifnvb0/uHX7ozB+Tjat/KQPzqWGlkBAx95aaoFALhOzS3qxCIzgiDdR/HuKO1Xajc+pc5pKKs6YcO7GuCjFU8xcOmrAqSoicaWpIKHAM6a4m5jx2ldEPE57IgIRvAr3BS5XO135Y5D6fvdYE8qMXYFIhSnblRX9UNGot4sypM5S9aH99cEqorMjkWV0DqsihOqfS+w+Xt755TwgNVK2P4u3mTEQgqRInOAYEQh48AJcLfsHOowLM84IjNwxQQG34aJEsQK8thCH/7nDAP3jVT1wRBZRJwkKogxqJ4EvjSvRUfSnV2A1MlIBqCwhndYVQw8vZ3zN73n+SVZYIMQnQmPG5ou3kq+jkmVFeW7E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(86362001)(2906002)(6486002)(316002)(36916002)(36756003)(31686004)(508600001)(6512007)(31696002)(6916009)(53546011)(83380400001)(186003)(26005)(5660300002)(6666004)(38100700002)(8936002)(66946007)(8676002)(6506007)(4326008)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjcyUjIzZjdXK1laVVVqRWQwZkpueFo4MnpjbWV2Q2pWT3huN1NSUVlPTDVq?=
 =?utf-8?B?QUdMc1lPaXFaWnRIM3oyeTNGazlrU25KWVV2bXJjR2l6OE9yRW5JVGZuS1hu?=
 =?utf-8?B?MlNKNkFRSGpoVmRsV2k2VTQrZkswOWJFMysxM21KTzBSaWRqenVWREVjQmJo?=
 =?utf-8?B?MXlUNm00SUdISWpESTNCUVo5aXRxS2hYSVJTUUFvd2dMbE9HSzNpT3I0b1hW?=
 =?utf-8?B?U0NBZVlGcE5waDVhdksyRXMveTVzOUoxbDBBNkczOXc0UjZLandJQWRDazJs?=
 =?utf-8?B?NStnM1N2MlZRd2V2MWFCVGdZUmUyRUFnL3VubHYvMnROMGU0V2txajlXOHUy?=
 =?utf-8?B?K3o4Z1RMbHl5UWdDUkJwVWFkcy9iVmZGVnlqdFkzQ2xXWmpQeWNnNTBDNFJS?=
 =?utf-8?B?TVFPamdVdmcyYTJVMzNzaTVSdU45WkxvKzArRkg4SFFFQjhPdHd3Q1ZtRk5o?=
 =?utf-8?B?NW40d204ZFdHSmdTVXQzK2lJbWM0aVlvS0g0VHZMeXZYa0FzdzJGWEsyak9Y?=
 =?utf-8?B?ak5IU1FOOXNqMnlyQnVDaGJkUGtsYnpJUFczQlNrN1RzKzNXMGhmN1hJK2E3?=
 =?utf-8?B?WFZkT0I2eTJOV0lTR2d0SDBndFpKeXVzSlc5bGxxVlVQRWsxWjZBWGx5eVRP?=
 =?utf-8?B?bi9UdGUxRXVkMzJibTBXSUFaQW5KYTJLT3BMMkRpS1pyUHlkVVhCYXo1WDEv?=
 =?utf-8?B?bDM3SnZwVGdubWFYMFozVjJtYXJsRHlWR2tmZk43N0xrM2RSWFNjQVVybXJi?=
 =?utf-8?B?Ly9hdnBnTG04TmxFQkVidUhxUkZlUjRhVEMvaFJ5SlB0d0ZjYmh0U21KZnVx?=
 =?utf-8?B?S3E5SHNxdGxiOUt1VkxOa1puaUlxTjRQdWFXbWdVdjk0RmFwQ2tMSk01NHh5?=
 =?utf-8?B?MENkRGRNMGlXSlB3L25aVVJxOTAwbFRYY201S2xTUkMzanlWalZSN0hKTVda?=
 =?utf-8?B?MVo2VEo1TW1CZUNwSUFrWU5sQTFtQmcvMWN5bURKaVRvRkUyZlNRVjZzVWZ0?=
 =?utf-8?B?R09RdnRPaDVWcDUvOEtpMjBPMndjOWo4bE80eXZxMTNpWG51RnJBMXFZeXUy?=
 =?utf-8?B?WFpIY1FDQitpWUNhS05ORWZtNk5oc2MrS3ppcS8xaUdvcUU1eXlJMEV5Nkw3?=
 =?utf-8?B?enFjVEpvR0xqVUNvakRzT3Z2aXhGd3ZPaS9XZzFJREw2djdnbnNyWGJ5MEMw?=
 =?utf-8?B?bVVKZTQycU1PdDVaaTZkbHp4azZ0RlNkU2FVU1U3WFVxL0NuQllrS2FYVEtE?=
 =?utf-8?B?U0p0UHJGd05LU2s5YnV3N3FXLzh0amlsTERobnhGZks0TWdJbVFCYmZic0VB?=
 =?utf-8?B?emZ6QXFMeDNMU2d6RlhTcC84aWtxMkhWWXpCNkc3dC9kZlE4UVZvUE55ZmFH?=
 =?utf-8?B?amZNTTJmcmhIdWNWQS9PdlJqVzZzc081cHlNSUVVS2lBbHR5SG9oZWhKdW1y?=
 =?utf-8?B?azVTZ0hzeC8xb0QwWTUxQnZ3Q1pkSnNpb3NOTU1qYVZQZVo4OS9rWDNVRklM?=
 =?utf-8?B?SWVWUHdSM2NFOFRLSGNmbEhzcUM1QTBwQStQdE1FU2lPVzljVEEzYUFqazBp?=
 =?utf-8?B?V0tiT0I4VUZzSlZIWUFRWUFnWll6N2hNeEVVZ2dPbzY0ZFl0djl3OXFYUXE3?=
 =?utf-8?B?QS93V3lPdGNzNDQrWllzMUlDUjhvYkVVb29ZTVdPWXp0VS9iRGVxZVlGM3Z5?=
 =?utf-8?B?MC9kZnBpcStzWmZ4ZTEyRHNUR0tBVUgzWHlMMWN3eTRMWnlSSDNyT2Zmc0N6?=
 =?utf-8?B?ZVRWaU5kMVk1dEI5QllHVkhhWGRSOC9EQ0NQSE84NFVBMDJVaEVhZ2pNOFdq?=
 =?utf-8?B?TFJLZy96aVhiSVc3R2lzSDBUaDVIbzBHcGE4cTJQczBFV0hjb3hEZ25kbUFI?=
 =?utf-8?B?Vm1pTk1VWkZDWVUwbDBsTk9ZOHBMbzVpYzZXSks5OWhVWlZ0b1VnTWI3ek51?=
 =?utf-8?B?R1Y3RndqQ3dhY1FxTDNhRXFlQjdpQTZWVFZMeFVvclNpME1vZWNSNzRJc0JL?=
 =?utf-8?B?OGoxenRDSnZBVTc3WlE4SnREWXIvZnp6eHNTbUl0VEc2NHQ5N21lYlo0TmtU?=
 =?utf-8?B?Q1oxTWRCVVkyR2hrNUtwTGdyQXBJcjZZR3pFM1FvNTJRVUF2ZEZTa0EzbzMr?=
 =?utf-8?B?QUlTUmFHVUdyYWJCbVM2ZmpDcTVSTTV2V2dYM3JBRUx5NlZpYlVSdWVuTXNV?=
 =?utf-8?Q?lwhei5/kfADOXKOGlQviozk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c34949f4-0e0a-40b5-a89e-08d9f19548f2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 21:42:53.1387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lcCexuqTt8Cs0h08UbxZ/DKiVUTtID1zNk2LTGmA/9TcHxgdIZNIlgwWhClogBPciPEVdFbxEd4pax/yZ7RwGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1776
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10260 signatures=675971
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202160117
X-Proofpoint-GUID: KMCoh2E4k4JC-Ic48YBdq_qLHq87xaom
X-Proofpoint-ORIG-GUID: KMCoh2E4k4JC-Ic48YBdq_qLHq87xaom
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/15/2022 7:16 AM, Eli Cohen wrote:
> On Fri, Feb 11, 2022 at 05:15:51PM -0800, Si-Wei Liu wrote:
>>
>> On 2/10/2022 5:31 AM, Eli Cohen wrote:
>>> When reading the configuration of a vdpa device, check if the
>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES is available. If it is, parse the
>>> feature bits and print a string representation of each of the feature
>>> bits.
>>>
>>> We keep the strings in two different arrays. One for net device related
>>> devices and one for generic feature bits.
>>>
>>> In this patch we parse only net device specific features. Support for
>>> other devices can be added later. If the device queried is not a net
>>> device, we print its bit number only.
>>>
>>> Examples:
>>> 1.
>>> $ vdpa dev config show vdpa-a
>>> vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 3 \
>>>           mtu 1500
>>>     negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS \
>>>                         CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
>>>
>>> 2. json output
>>> $ vdpa -j dev config show vdpa-a
>>> {"config":{"vdpa-a":{"mac":"00:00:00:00:88:88","link":"up","link_announce":false, \
>>>     "max_vq_pairs":3,"mtu":1500,"negotiated_features":["CSUM","GUEST_CSUM","MTU", \
>>>     "MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ","CTRL_MAC_ADDR", \
>>>     "VERSION_1","ACCESS_PLATFORM"]}}}
>>>
>>> 3. pretty json
>>> $ vdpa -jp dev config show vdpa-a
>>> {
>>>       "config": {
>>>           "vdpa-a": {
>>>               "mac": "00:00:00:00:88:88",
>>>               "link ": "up",
>>>               "link_announce ": false,
>>>               "max_vq_pairs": 3,
>>>               "mtu": 1500,
>>>               "negotiated_features": [
>>> "CSUM","GUEST_CSUM","MTU","MAC","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ", \
>>> "MQ","CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
>>>           }
>>>       }
>>> }
>>>
>>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>>> ---
>>>    vdpa/include/uapi/linux/vdpa.h |   2 +
>>>    vdpa/vdpa.c                    | 126 +++++++++++++++++++++++++++++++--
>>>    2 files changed, 124 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
>>> index b7eab069988a..748c350450b2 100644
>>> --- a/vdpa/include/uapi/linux/vdpa.h
>>> +++ b/vdpa/include/uapi/linux/vdpa.h
>>> @@ -40,6 +40,8 @@ enum vdpa_attr {
>>>    	VDPA_ATTR_DEV_NET_CFG_MAX_VQP,		/* u16 */
>>>    	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
>>> +	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>>> +
>>>    	/* new attributes must be added above here */
>>>    	VDPA_ATTR_MAX,
>>>    };
>>> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
>>> index 4ccb564872a0..7deab710913d 100644
>>> --- a/vdpa/vdpa.c
>>> +++ b/vdpa/vdpa.c
>>> @@ -10,6 +10,7 @@
>>>    #include <linux/virtio_net.h>
>>>    #include <linux/netlink.h>
>>>    #include <libmnl/libmnl.h>
>>> +#include <linux/virtio_ring.h>
>>>    #include "mnl_utils.h"
>>>    #include <rt_names.h>
>>> @@ -78,6 +79,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>>>    	[VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
>>>    	[VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
>>>    	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
>>> +	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
>>>    };
>>>    static int attr_cb(const struct nlattr *attr, void *data)
>>> @@ -385,17 +387,120 @@ static const char *parse_class(int num)
>>>    	return class ? class : "< unknown class >";
>>>    }
>>> +static const char * const net_feature_strs[64] = {
>>> +	[VIRTIO_NET_F_CSUM] = "CSUM",
>>> +	[VIRTIO_NET_F_GUEST_CSUM] = "GUEST_CSUM",
>>> +	[VIRTIO_NET_F_CTRL_GUEST_OFFLOADS] = "CTRL_GUEST_OFFLOADS",
>>> +	[VIRTIO_NET_F_MTU] = "MTU",
>>> +	[VIRTIO_NET_F_MAC] = "MAC",
>>> +	[VIRTIO_NET_F_GUEST_TSO4] = "GUEST_TSO4",
>>> +	[VIRTIO_NET_F_GUEST_TSO6] = "GUEST_TSO6",
>>> +	[VIRTIO_NET_F_GUEST_ECN] = "GUEST_ECN",
>>> +	[VIRTIO_NET_F_GUEST_UFO] = "GUEST_UFO",
>>> +	[VIRTIO_NET_F_HOST_TSO4] = "HOST_TSO4",
>>> +	[VIRTIO_NET_F_HOST_TSO6] = "HOST_TSO6",
>>> +	[VIRTIO_NET_F_HOST_ECN] = "HOST_ECN",
>>> +	[VIRTIO_NET_F_HOST_UFO] = "HOST_UFO",
>>> +	[VIRTIO_NET_F_MRG_RXBUF] = "MRG_RXBUF",
>>> +	[VIRTIO_NET_F_STATUS] = "STATUS",
>>> +	[VIRTIO_NET_F_CTRL_VQ] = "CTRL_VQ",
>>> +	[VIRTIO_NET_F_CTRL_RX] = "CTRL_RX",
>>> +	[VIRTIO_NET_F_CTRL_VLAN] = "CTRL_VLAN",
>>> +	[VIRTIO_NET_F_CTRL_RX_EXTRA] = "CTRL_RX_EXTRA",
>>> +	[VIRTIO_NET_F_GUEST_ANNOUNCE] = "GUEST_ANNOUNCE",
>>> +	[VIRTIO_NET_F_MQ] = "MQ",
>>> +	[VIRTIO_F_NOTIFY_ON_EMPTY] = "NOTIFY_ON_EMPTY",
>>> +	[VIRTIO_NET_F_CTRL_MAC_ADDR] = "CTRL_MAC_ADDR",
>>> +	[VIRTIO_F_ANY_LAYOUT] = "ANY_LAYOUT",
>>> +	[VIRTIO_NET_F_RSC_EXT] = "RSC_EXT",
>>> +	[VIRTIO_NET_F_HASH_REPORT] = "HASH_REPORT",
>>> +	[VIRTIO_NET_F_RSS] = "RSS",
>>> +	[VIRTIO_NET_F_STANDBY] = "STANDBY",
>>> +	[VIRTIO_NET_F_SPEED_DUPLEX] = "SPEED_DUPLEX",
>>> +};
>>> +
>>> +#define VIRTIO_F_IN_ORDER 35
>>> +#define VIRTIO_F_NOTIFICATION_DATA 38
>>> +#define VDPA_EXT_FEATURES_SZ (VIRTIO_TRANSPORT_F_END - \
>>> +			      VIRTIO_TRANSPORT_F_START + 1)
>>> +
>>> +static const char * const ext_feature_strs[VDPA_EXT_FEATURES_SZ] = {
>>> +	[VIRTIO_RING_F_INDIRECT_DESC - VIRTIO_TRANSPORT_F_START] = "RING_INDIRECT_DESC",
>>> +	[VIRTIO_RING_F_EVENT_IDX - VIRTIO_TRANSPORT_F_START] = "RING_EVENT_IDX",
>>> +	[VIRTIO_F_VERSION_1 - VIRTIO_TRANSPORT_F_START] = "VERSION_1",
>>> +	[VIRTIO_F_ACCESS_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ACCESS_PLATFORM",
>>> +	[VIRTIO_F_RING_PACKED - VIRTIO_TRANSPORT_F_START] = "RING_PACKED",
>>> +	[VIRTIO_F_IN_ORDER - VIRTIO_TRANSPORT_F_START] = "IN_ORDER",
>>> +	[VIRTIO_F_ORDER_PLATFORM - VIRTIO_TRANSPORT_F_START] = "ORDER_PLATFORM",
>>> +	[VIRTIO_F_SR_IOV - VIRTIO_TRANSPORT_F_START] = "SR_IOV",
>>> +	[VIRTIO_F_NOTIFICATION_DATA - VIRTIO_TRANSPORT_F_START] = "NOTIFICATION_DATA",
>>> +};
>>> +
>>> +static void print_net_features(struct vdpa *vdpa, uint64_t features, bool maxf)
>>> +{
>>> +	const char *s;
>>> +	int i;
>>> +
>>> +	if (maxf)
>> This could use a better name. mgmtdevf maybe?
> Will change.
>
>>> +		pr_out_array_start(vdpa, "dev_features");
>>> +	else
>>> +		pr_out_array_start(vdpa, "negotiated_features");
>>> +
>>> +	for (i = 0; i < 64; i++) {
>>> +		if (!(features & (1ULL << i)))
>>> +			continue;
>>> +
>>> +		if (i >= VIRTIO_TRANSPORT_F_START && i <= VIRTIO_TRANSPORT_F_END)
>>> +			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
>>> +		else
>>> +			s = net_feature_strs[i];
>>> +
>>> +		if (!s)
>>> +			print_uint(PRINT_ANY, NULL, " unrecognized_bit_%d", i);
>>> +		else
>>> +			print_string(PRINT_ANY, NULL, " %s", s);
>>> +	}
>>> +	pr_out_array_end(vdpa);
>>> +}
>>> +
>>> +static void print_generic_features(struct vdpa *vdpa, uint64_t features, bool maxf)
>>> +{
>>> +	const char *s;
>>> +	int i;
>>> +
>>> +	if (maxf)
>>> +		pr_out_array_start(vdpa, "dev_features");
>>> +	else
>>> +		pr_out_array_start(vdpa, "negotiated_features");
>>> +
>>> +	for (i = 0; i < 64; i++) {
>>> +		if (!(features & (1ULL << i)))
>>> +			continue;
>>> +
>>> +		if (i >= VIRTIO_TRANSPORT_F_START && i <= VIRTIO_TRANSPORT_F_END)
>>> +			s = ext_feature_strs[i - VIRTIO_TRANSPORT_F_START];
>>> +		else
>>> +			s = NULL;
>>> +
>>> +		if (!s)
>>> +			print_uint(PRINT_ANY, NULL, " bit_%d", i);
>>> +		else
>>> +			print_string(PRINT_ANY, NULL, " %s", s);
>>> +	}
>>> +	pr_out_array_end(vdpa);
>>> +}
>>> +
>> It looks like most of the implantation in the above two functions are the
>> same and the rest are similar. I wonder if can consolidate into one by
>> adding a virtio type (dev_id) argument? You may create another global static
>> array that helps mapping VIRTIO_ID_NET to net_feature_strs?
>>
> So maybe just create multidimensional array of to find the string for a
> device_id/bit number combination and simplify the code above. And for
> now just populate it for net devices. For undefined just print "bit_n".
Yeah, that sounds fine, too.

Thanks,
-Siwei

>
>>>    static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>>>    				struct nlattr **tb)
>>>    {
>>> +	uint64_t classes = 0;
>>>    	const char *class;
>>>    	unsigned int i;
>>>    	pr_out_handle_start(vdpa, tb);
>>>    	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
>>> -		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
>>> -
>>> +		classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
>>>    		pr_out_array_start(vdpa, "supported_classes");
>> This looks like a minor adjustment to the existing code? Not sure if worth
>> another patch though.
> I will remove it from this patch.
>>>    		for (i = 1; i < 64; i++) {
>>> @@ -579,9 +684,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
>>>    	return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
>>>    }
>>> -static void pr_out_dev_net_config(struct nlattr **tb)
>>> +static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
>>>    {
>>>    	SPRINT_BUF(macaddr);
>>> +	uint64_t val_u64;
>>>    	uint16_t val_u16;
>>>    	if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
>>> @@ -610,6 +716,18 @@ static void pr_out_dev_net_config(struct nlattr **tb)
>>>    		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MTU]);
>>>    		print_uint(PRINT_ANY, "mtu", "mtu %d ", val_u16);
>>>    	}
>>> +	if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]) {
>>> +		uint16_t dev_id = 0;
>>> +
>>> +		if (tb[VDPA_ATTR_DEV_ID])
>>> +			dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
>>> +
>>> +		val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
>>> +		if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] && dev_id == VIRTIO_ID_NET)
>>> +			print_net_features(vdpa, val_u64, false);
>>> +		else
>>> +			print_generic_features(vdpa, val_u64, true);
>> Why the last arg is true? That would output the dev_features line instead.
>>
> Will fix.
>
>> -Siwei
>>
>>> +	}
>>>    }
>>>    static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
>>> @@ -619,7 +737,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
>>>    	pr_out_vdev_handle_start(vdpa, tb);
>>>    	switch (device_id) {
>>>    	case VIRTIO_ID_NET:
>>> -		pr_out_dev_net_config(tb);
>>> +		pr_out_dev_net_config(vdpa, tb);
>>>    		break;
>>>    	default:
>>>    		break;

