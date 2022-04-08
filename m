Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBE24F8C39
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiDHBMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 21:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiDHBMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 21:12:23 -0400
Received: from mx0b-00273201.pphosted.com (mx0b-00273201.pphosted.com [67.231.152.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106BF200
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 18:10:19 -0700 (PDT)
Received: from pps.filterd (m0108162.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 237GXfhR015653;
        Thu, 7 Apr 2022 18:10:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS1017;
 bh=n/tqXjLbuib1ZZ7byxb22xsm3HjwwJKbfVCu3EjJcwQ=;
 b=dww7pG+EJrRwL/8s1zXOcE8rZRbPTFRA9EjetJkaK7bXKOzF9t/vVE3G+0/xRXorALPq
 bhG0+8nIkHpPiH3hEkOEgDmoeY2BV3j5gt8rHJl1/SnhQB0ry3Ld+ijLxZW4B/Re5EQr
 r1CZ6sQ8fobU58PKAse/9sESpX0S/dGzPEQMF8kRZrMBt7Zxha8T+fzuGLRrClWmwdWN
 obVKq9gW1m61ZJAa/ZBYar1xIagZNIV0TsWkqtAm3eLPHmUJsoUfU1/vcAWZbYSAQE9P
 wbdhfLK34hsShD8UlzMh2qnkDUukBJ5HrWNUm56OgncmuAnPBRwTtWca3YY7NZnaz2fx WQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0b-00273201.pphosted.com (PPS) with ESMTPS id 3f9hxabq17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 18:10:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GinsdGSCH2Jh5KCTNGkQXd5plUniN4jsxojK9P0UVYuF4qVutdxjEpQ+IR+wKVTCcxOa025IayZh9v1cmSRuqHBpsh/q3/F2PxZL+McGrrFXlcKb/qF/jZ7qBhQUOeZGy533ksTz8r4gqNRq/typC4ZqnGWbwJq+YAnOQrupbpPFTMLMrsBYubNqde4sopIS5hjW3kYqHJ1lwCMiNSue+ndJLhiIxkXAUX8MHLRupox59Y5Tp6s9GW3UoxnQx29x0gA2tbApTgI5BB1id3jZSHlgyA1OuY5rdNC2tiMPAEnFFXUjsHTh0mIqa4jUC/wLYnRorym4dhi6guqIqr3fpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/tqXjLbuib1ZZ7byxb22xsm3HjwwJKbfVCu3EjJcwQ=;
 b=UCbqQPVXyEOqMSbVg2qxF9qp0MXsj49tRhjoUXSqPZyn0WpFiZs99hBWbV7BrLXVbZAQ0KXBe7E1Wy4c7WIGXdk/p/aViVZ0cWkk+DGxRhewOmuYvs2WUz9+VVbHaw+kfkpotLHedzgK1VM7KCumrx8o6HGwHUFW85KScpY4p6/tTAfSISiqhST5PHwZTPGrkvWYLAmKowCAbK3tFV7c8Sn2naArT5G3k03FkO1vmuD4MHFxgD6EUvi4/5KmzhMlwkd73Wauyunp1r1DuPiMJhtPvIEcfAvCJZReleCoUR2Ei3ErSv+KgAEoKQzhJXQDZk3AJ8ldAsiXJ1Xvjg/veg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/tqXjLbuib1ZZ7byxb22xsm3HjwwJKbfVCu3EjJcwQ=;
 b=B9iM1CKffbI3DZH9DctzN0UWI013rblhVwyGcrTOzdRqyK6Kmyv/U+EiqLrzokO0LgaDAeTlXXBvWnKQZwAhf1u2zNSKdyrQRejxjxxHD7zC7ya0+84+4ECVKxCMU6MZO2YVPU9Q/JPMEgKWOgzsgsHJevSUqovoN7SLMz9xLEE=
Received: from BY3PR05MB8002.namprd05.prod.outlook.com (2603:10b6:a03:364::8)
 by SA1PR05MB8360.namprd05.prod.outlook.com (2603:10b6:806:1d3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.8; Fri, 8 Apr
 2022 01:10:14 +0000
Received: from BY3PR05MB8002.namprd05.prod.outlook.com
 ([fe80::61f9:1a95:d910:a835]) by BY3PR05MB8002.namprd05.prod.outlook.com
 ([fe80::61f9:1a95:d910:a835%6]) with mapi id 15.20.5164.008; Fri, 8 Apr 2022
 01:10:14 +0000
Message-ID: <be35a6ae-ec41-ef6f-9244-44f061376949@juniper.net>
Date:   Thu, 7 Apr 2022 21:10:11 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: =?UTF-8?Q?Re=3a_TCP_stack_gets_into_state_of_continually_advertisin?=
 =?UTF-8?B?ZyDigJxzaWxseSB3aW5kb3figJ0gc2l6ZSBvZiAx?=
Content-Language: en-CA
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <BY3PR05MB8002A408749086AA839466C2D0E69@BY3PR05MB8002.namprd05.prod.outlook.com>
 <1c29e93f-5bfa-fcd1-eaa8-49983db8d3bb@gmail.com>
From:   Erin MacNeil <emacneil@juniper.net>
In-Reply-To: <1c29e93f-5bfa-fcd1-eaa8-49983db8d3bb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::10) To BY3PR05MB8002.namprd05.prod.outlook.com
 (2603:10b6:a03:364::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 444b0114-9616-4c20-fa37-08da18fc8944
X-MS-TrafficTypeDiagnostic: SA1PR05MB8360:EE_
X-MS-Exchange-AtpMessageProperties: SA|SL
X-Microsoft-Antispam-PRVS: <SA1PR05MB8360A7C0EA8F5473D35FB2FCD0E99@SA1PR05MB8360.namprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BqKsT8S7Upy6+B3LrB0hav9cfIVtdSnpjZJNGhuNYt0zgAHMK2BCKhirMyI58O0FMCXXXn6hAEKHequ1ZP7O5/vHg3pBWiTMOSp9ZHXjop5upnEjMXUh8+KK+frq9DDx9eEVcTPF13vXqc1Dka98GX5BtMTM1loaYmL0c9c6uYFpdbOfcHsVaSdIy2YujRhjuBBjcy7OI+MGmQ85JneuaBahMtmfETck7JEzUHO4qmbBMqyMk1wAp76Adx/XreGrIvNJWBTseGd5Coz5JNp3saINXmImlOCulBuch6w6GzXxeMJ4zm3NwLrkEPTY6qyo/MNbak2bezqvqmOn7UpTf0INlwnjpn0CU13gvawWN8dM+0mrhr97shJFTf6TQJ1Pos0uaohD7Otnbr2Eu2B3Yi7mczmFA8Ihkp7Y5Virrbm/YkITFeTWafob0F7II7Ya+MN75gwkMHpgbwcBbdCl0l73uUsDvt+h7T6p7CcrEuS9tLYVejKNkp7WCEsp05uwaun8VPAKrtZjscnsCSiuJ6XukITTvCFXm6TPWa2MZhToCORCG7Bksso1hUT42i1nim+9QuHc6pA5EF3NI9cDEw5d1N8S0aQScXKs5RHiTFmpbBl2pk2/WLfcZmTOaKbRd5EQkUt4mnDn8b/E1TJUzEnTAnyc9GkG+biuEksUcqD3is/RH4zhqdjw3uc8s7NI9kkMQ69aLaKsc5K00QfF3XN/mJ6IkiwjP6ltxqIYoi6AzAdxIJ7a4PwZtZpyU99FIfck+ou9Ee1m/WCBjJXuSE2YuIsL7NlyegOWd00/6x8P6xgCK9haz0SfUcG1ePrh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8002.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(36756003)(38100700002)(38350700002)(316002)(110136005)(66946007)(53546011)(6512007)(66556008)(5660300002)(66476007)(83380400001)(52116002)(2906002)(6486002)(8936002)(186003)(86362001)(31696002)(508600001)(6506007)(2616005)(45080400002)(26005)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1N0OEVTNDYwT3pObCtnSFhwVmpnK3VwWDF1WDlja3ZoaEl1MFUwRk5zQWw0?=
 =?utf-8?B?dzhCTmV5aVV6ZzArdXA5QU9CamJUZXF0ekNHdm52OCsvV0RuNG90cVJtYUxX?=
 =?utf-8?B?UmNPY0NrZkcyQjBsMFcyaTFDckJGRC9UclgyOGJOU2E5aFRyeWRjbzFjNy9Q?=
 =?utf-8?B?RU9aZ0Zud2FvUlplWm51dHdyTUdGWGlMd2d3UHFpTkF3VkFIQkE1eitjNzV4?=
 =?utf-8?B?ZlduaU90eXBrSkw4SjAwVzh6SXluM2N5QU9kZ0toNzBWeVVyNytWeGRYbEVE?=
 =?utf-8?B?eHpNSzFQY0oyb0R2OThwcVR3MHFkR1RWZTRLNnFtNkh4YlhjV2NyR1Rtcmkv?=
 =?utf-8?B?NHl5Q0V2WHRScHY2WC9VKzRTMm1qaEdFRGUvTElGUTBZNFZMM1gzVHZ5d3J0?=
 =?utf-8?B?dkx4ZlYxeE0wYjF5c1pkMDVuMHB3RGsxS1I1eGVrRWlHbjFIeFV3bmZUK3Nq?=
 =?utf-8?B?aFB1RzFicG1TODRtUmdnL244NXgvR1U3S2NyTWZ6eE9zcHUzeXdRQll3WHBW?=
 =?utf-8?B?SHlOcUhUMk9yV3ZWdzhLN2JoWWNLZkw3Sm5XNndFcmJaM09WU1U2TE8zemxY?=
 =?utf-8?B?YjhZa000QlgwRm5ObU9Cb28xUDRBaGl1cU1YVFMyQzF5a2JGSlhKMGJIc3RF?=
 =?utf-8?B?YUhzeWxUakZFWG84ZWNxVzRsdy83bjRvckhYSW1GRk5aeWdNKzRuTzB5SzVB?=
 =?utf-8?B?T2JtZERSNHpsVDNZeGs4a1piYVNqd3Q5SUxldEpLMkRTM2g2MzA3NEUrU2xt?=
 =?utf-8?B?UXNTQlJKVEF6OFhqYnNJVXZNWXc0VmNuSlZENUMzYUUyczNsR0o0bFF6a0Ry?=
 =?utf-8?B?ZFNRTWxtNDVzZURLYmZDUHd4TndaOGwrN1MrK1o3Z1pPdlBQZFpuZUxIc1JX?=
 =?utf-8?B?TjlqMC95c3gwa3ZUbFhpbnQyUm0vSkk0RXptWElSOVRLQWFPZlBST2hRTGRa?=
 =?utf-8?B?OXZ2bTlCcktLRmxPZmJzb3IxZ3p1OWZZQjd3Tjl1Zk5pMUxlM2VBbGRTKzZy?=
 =?utf-8?B?d0FoSVZJUFZwWmowLzYxeExXWEsrcEMvbzMyU1NTejRHUzVPZVdWVW5GVkVn?=
 =?utf-8?B?REpWazJ3ME5zb1JOQWVmMk02MlNLTk1tdVlUOVBSOFVCRXNkL0RJWUZCTUFn?=
 =?utf-8?B?SXlGSmpYcHU2ZkhybVFzSWRLaCtnQUFqeE1VL1dFRzlPd1MyV2RTTlFuZHYw?=
 =?utf-8?B?cnVwdnlScyt5ZWhwaDJVZXFUc1B2NnFlV3NiQU95a3crVGNncVIrMWxkTGZo?=
 =?utf-8?B?S0xJTDNjeVUvNHgwZDZvQ0M2dVV3MU9oV05oTHppZkZXZWdyemxTZWpKL0pv?=
 =?utf-8?B?QjU0dEtQQ0d4Q1hmTUZNdGdBcEltUUVLWUhaMW5qVmFGVnlsT09Ia2pQeHAr?=
 =?utf-8?B?QjM0alErSzdvYmJVbFFNMmRqeFEyN2xVMHFJWDRIR0VYYWlMR2FRNWJZRHpt?=
 =?utf-8?B?ejRIa1Nka1pMUXp6bE9vSmpxTEI3RU0ydEZEK00wTTNkV3k3alRISGMveEZj?=
 =?utf-8?B?WEkxdTRFOGJNak1FVUt0NnI2MG9LZndyK1ZDMndpanRIZmkxT1ZzVGEzY2Y0?=
 =?utf-8?B?T1dYY1MzUzRYNVU3RUxwNkRPbWZSc0JnSitUTDNPWkFhWldaeVVMNWRkMmxB?=
 =?utf-8?B?elhYc3YrenBnSnRxb3BuY21Fbk5remZrUlFPSlQvRVg0TENnQmxUZnVFZ21H?=
 =?utf-8?B?SFJ3UzFVNTRvdjlWNFRsNm5ITGdNSk5wR2JSaHo1NTR2ODdrSmhITlQ4M291?=
 =?utf-8?B?MUhlcEJHekpueFpCVndnWEtmMzRlc2hBdlNsZHpwdm53ZkQyWHFUYUZoc0R5?=
 =?utf-8?B?NTlBTy9nMys0VTBKT2diNkJYQzRhUGJKNC9RSm9NNGs5TmFHSmVacnUrV1ZE?=
 =?utf-8?B?akFia2kwbEI4dm1DcDNXTmRPMzcyYzBTU0thRDhYeGYrU1oxT2FPOEMyZmVn?=
 =?utf-8?B?bThkUHlkODI4L2RYZ2h4V2t3WHRnOHl0VHliLytpVWE3YkpNdEo0eFovalh5?=
 =?utf-8?B?ZVVscnlRaG8zY1pyc3ZiWGtlT0VsU3lxTmhWV1pwUTVpY2JNc2ZDUmNDQWZn?=
 =?utf-8?B?Tk0rcEVjY0xSbmx4czlHaGNML1orbzQxb25XUGdneHNuMU16U0hnVHNQTHZM?=
 =?utf-8?B?bTN3aTdTVkMrTXUvc1lZN2N3Nk42SEs1WEpCZVJ5RTdNNlNVMnUzRzdRY05x?=
 =?utf-8?B?QjVsT0UzSnFlSUJrRmlSUnJUQ3JKd2ZSSytYMHgwekp2QUlXaDhvSkRaR0NT?=
 =?utf-8?B?VnhlRjc4aTlqUWhndzhXQjVWUjFHQ2dFenExSm5aWk92Z2tHYmhwR0l3YlRi?=
 =?utf-8?B?NHBJdFR1WFFmVGNVby80WHNXZGJ4NUFVOHNzcS9wcnU5TUFpd3hEc0ZPTjBr?=
 =?utf-8?Q?kfOAtgG2RWigPBfE=3D?=
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 444b0114-9616-4c20-fa37-08da18fc8944
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 01:10:14.5169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ehaA9fFOSRlERUHyQ99lCXhzdSHHRPsUGoezc25nNiQuq3qNZ8PsInef6Y6eunSSPIO0lEUd2INw8f+bCdBBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8360
X-Proofpoint-ORIG-GUID: qEnI4bCS9ZBtdXDrTGaNC3x1fyVaVVRL
X-Proofpoint-GUID: qEnI4bCS9ZBtdXDrTGaNC3x1fyVaVVRL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-07_05,2022-04-07_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 malwarescore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 impostorscore=0
 mlxscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204080004
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-04-07 4:31 p.m., Eric Dumazet wrote:
> [External Email. Be cautious of content]
> 
> 
> On 4/7/22 10:57, Erin MacNeil wrote:
>> In-Reply-To: 
>> <BY3PR05MB80023CD8700DA1B1F203A975D0E79@BY3PR05MB8002.namprd05.prod.outlook.com> 
>>
>>
>>> On 4/6/22 10:40, Eric Dumazet wrote:
>>>> On 4/6/22 07:19, Erin MacNeil wrote:
>>>> This issue has been observed with the  4.8.28 kernel, I am wondering 
>>>> if it may be a known issue with an available fix?
>>>>
...
>>
>>> Presumably 16k buffers while MTU is 9000 is not correct.
>>>
>>> Kernel has some logic to ensure a minimal value, based on standard MTU
>>> sizes.
>>>
>>>
>>> Have you tried not using setsockopt() SO_RCVBUF & SO_SNDBUF ?
>> Yes, a temporary workaround for the issue is to increase the value of 
>> SO_SNDBUF which reduces the likelihood of device A’s receive window 
>> dropping to 0, and hence device B sending problematic TCP window probes.
>>
> 
> Not sure how 'temporary' it is.
> 
> For ABI reason, and the fact that setsockopt() can be performed
> _before_  the connect() or accept() is done, thus before knowing MTU
> size, we can not after the MTU is known increase buffers, as it might
> 
> break some applications expecting getsockopt() to return a stable value
> (if a prior setsockopt() has set a value)
> 
> If we chose to increase minimal limits, I think some users might complain.
> 

Is this not a TCP bug though?  The stream was initially working "ok" 
until the window closed.  There is no data the in the socket queue 
should the window not re-open to where it had been.

Thanks
-Erin
