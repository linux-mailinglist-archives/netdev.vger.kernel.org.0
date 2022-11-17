Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F79B62D261
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 05:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbiKQEmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 23:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239284AbiKQEk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 23:40:57 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29F66B235;
        Wed, 16 Nov 2022 20:40:44 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AH4cikJ027639;
        Wed, 16 Nov 2022 20:40:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=qx1b1SGAE7325qgjg6jqZ0hglAHx74JC0vd+fviSPQs=;
 b=AUKK8eOCoWJgxf6K8QpxsAhX3OtiBjwDiAJ7+Yo5JiwxM/kh3quWW6bfjvrjEH0NbTnF
 fcTaH1uIDeZrci4xF1i8eIFfwQtvJo8/4w5lmL2UUa2sTCmM5x03OMHy5wRoy7q6Kw6r
 GgI41ogoK3RM52e7cGk2hRRszKEZY7pAN+pMSuk060bRQWmBOd4Xl09A/NSHbvs2Aocs
 y87yeKklbusZ4GGjibmbpeNEJ/XzuDZgeSr2kYra5t1VUib/eNMd3Z1hWmI3Lk0pCfZE
 jZ6twHjqApWzJ46Sw5SL3Nx/x8n8dYG0JUlkflf8kgLfO7tUfQmiKbZt4QWfHuuDT/pI 3g== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kwbve02q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 20:40:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvb2p9fIoGV66MmzRqfvgPEqpVq5T9zOdPIl97skPbWoJh/+WytneIBzfVvoxWBFh677LzN615t/bg7V8YZP8zHIv8CvnKqAE584/FZpzoFumtsh4r2W48qpoGimHMVd/2QKJ+hlLFtUta+Sf5P8jxJmhtzupLpdcHHZ7gOJ3V6Je4h4KL+8Pu3af40L9rsNC/63msIPIQ4D3Qbk2OrhSE9lOEDvzulpMSBLwQ0rmdd3sEBrzqeX9S70AeJTzNNPTFZAYgHHZ48Ws/0NfWUOh1zF4Jt0UIxwyDRH/1Brem8JHlb410K+mkUDyXmqG3vZqUWlY8laEWFMRKlqF5FjyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qx1b1SGAE7325qgjg6jqZ0hglAHx74JC0vd+fviSPQs=;
 b=Ucq8gCpO+7uLDvvRflFGTFtaoPq3Kp9Z7ASmronXnYdqYzpRBHZyUZOGdJmF/q6d0ohrGj9v530SxU2LkUo9WJ1yhxYcZNcM3wQXTmKRpU5Tm/MFCiMjhcvki3RrHAA7d1co+Vwry0T4pZKcea/L3fevdzmFa6IF+GlwcPumkncY6LlunlTbJlS0srkDBvffKnJUccRn30g2z+JxL6hi/8vHWkALz0HWMXvY7MCpjwoREZeqHsQGzHWrq19E6QOD1YYoTzhBxEpo63GD0KGan3C/S2bGcPS0geD4QqaAefRYzST8AL1twnutvbv04pvgdVzBwR1hRxh2f2AHdCzEpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by PH7PR11MB7028.namprd11.prod.outlook.com (2603:10b6:510:20b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 04:40:31 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::d789:b673:44d7:b9b2%5]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 04:40:31 +0000
Message-ID: <160179b7-eec0-3db6-e7af-bc62333f9457@windriver.com>
Date:   Thu, 17 Nov 2022 12:40:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] net: fec: Create device link between phy dev and mac
 dev
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
 <20221116144305.2317573-3-xiaolei.wang@windriver.com>
 <Y3T8wliAKdl/paS6@lunn.ch> <355a8611-b60e-1166-0f7b-87a194debd07@gmail.com>
 <Y3V5AgBMBOx/ptwx@lunn.ch> <9c9643e3-db53-bd35-6028-1c8b718e1cc2@gmail.com>
From:   "Wang, Xiaolei" <xiaolei.wang@windriver.com>
In-Reply-To: <9c9643e3-db53-bd35-6028-1c8b718e1cc2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SL2P216CA0119.KORP216.PROD.OUTLOOK.COM (2603:1096:101::16)
 To MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|PH7PR11MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d87598d-1ecc-4b9a-e6d2-08dac855db9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tF/CjYdhor9UZwIflwqZNkvbqcY58ANxQGevowbZPyFtUlEI9d0PAWAI9jewKbVmcEg46uBGlYpctpL6A/o9UTd2TFbt0UmdNPngk+Ld+FrvbbznnTjOybwpeD+AruXza9wuHEwnbXFEV3ULRrP1CTTQisiRXXMVIysIOJV/A6QYfMZKteq11YMbGGZUV0NFissLYdSxzHs+aSUkfPSVgINgce6Vn3WCp0goKZEYozdDtyBeSnx0RH4C7V+d4hvC2CRy5gmQJE5QDAIkYYMM39n49/NxaRruoYB3119gBtNt6cNtDJyN4e6xb3U8J23bEJt2E5VvdmOZoQHomKLKnrDGEzB6nVygPN6vMu91+vIoEFFaQWMIO7+0hQGmlxu3NQ7dMwvgpYLkBYl0UvAaKXQHjUTG1DstVwNjnIfLsjk6/b2y/QCOTaefoGWHySJ3DBq2HUjAiwCsToPvZvdb24+LyT6RocAWBjCQQFuVEKPvzNiKBVzZXHtJAjxTT5ymMihsm++J+BAIvttVWR/gacwlACnxLMffMyaXntNv13WzJQWj8O6x05JlpIJAv3bkU9+SnRgHLqm+/s2K+iwsofWT43eUvxPvTXNWh7Cyf8QEhS4pHxaQO0b4qpi/z+91xQCq0FT0TW/nsX5OBNIhnsOe76dl2JhbYPoKGjKYZ9CzK4EELP1gJSYFQ5KzrP7NeicDo0U3rKYNJlIUiwLNmqvGlSSl25uvfv9BmezHaWWK7qLkixueRgTcXa+3TYeAR39QIKVBSHlsoF0fQuDdYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(396003)(136003)(39850400004)(451199015)(83380400001)(31686004)(2906002)(8936002)(478600001)(38100700002)(186003)(7416002)(5660300002)(38350700002)(6486002)(2616005)(52116002)(53546011)(316002)(86362001)(41300700001)(31696002)(6512007)(26005)(6666004)(36756003)(110136005)(6506007)(4326008)(8676002)(66476007)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUZJaDhtMlovV2tqWXB6YXkxQTNjZ1RqYWd4WldxSEVzdzF1N0FIQldXazBM?=
 =?utf-8?B?bUN6NWIzYnZqUVNhVFFGU2daZnk4ejRNQjhxV2V6RFo3eFRRNEI4VWIvbWpP?=
 =?utf-8?B?aFBPMUVjMVZoaXFCMkJONkkzREFERENIUVJxWm1pVXZIYjBzanNiUGZ3dFE5?=
 =?utf-8?B?UWxPdWNIaHFxa3N3aG9PTXVlbUNDbG1Tdi8vTzRMUENwUWxSRllmMHNFb05P?=
 =?utf-8?B?YS9pR295OTZFeDdqRlJTd3NycWg2eVRWbldLMkd6Q3Q5SUN5UlFRTmxxRG5J?=
 =?utf-8?B?Ylc3TTJMbUFub2lqWUsyNC9BamVYdXJETDRRZGdjeE1nbDhIREdwUGVRKzUv?=
 =?utf-8?B?VHpuZHFsdkZPTUE4Qlo2TEJlellwMzNrWnZmSWxIYWtBNFFUTFA0WFpzSzA3?=
 =?utf-8?B?dzRsZ0NCMVcycjUxMk9sOEU4dFc3NUpsSCtTeFNac3h1UUx5Z1dpeksyNGNE?=
 =?utf-8?B?a1Q3REZ3dHpsb2hIVnlkWGdKdDZDQ05TK2MxWFRyamgzM0Jpa0ZLcVg1RXJK?=
 =?utf-8?B?R3k0V3Vsd0NjN1JzWGMwY05KUjlpQjdtWHNITzB5M0wyQnVEOVJ4MGZxbkdz?=
 =?utf-8?B?dTdsU29NZktmUi9FT1FrSjB2U0h6MC9JNGlNZEdISnFHUlQ5aFpYNTB2Qm1B?=
 =?utf-8?B?MldQL2Q1bElneTFLS29PaTFaL3V1aGFBSlIxb0hJWG14NTF1ZWdtNThZZy9s?=
 =?utf-8?B?bnl5U2NwVkZ1VFVDQ3hMcVBCTkpIdkZiYXNjTlRTWCtoaDlVQW9sUXZBclEy?=
 =?utf-8?B?aTdYekdaSnRObEFEMU5QTTBRcDhrZnFsdDlZOGoyVVpCbHdLQjJSUUpYSVNz?=
 =?utf-8?B?TjJnWElEOC9PWGFGUUxBQ0hvSDY5b2wrbVkzMmswUWkwcHJXOFBvR1VXK01h?=
 =?utf-8?B?M3lsdi9SYUVySGlIMDJUdWNvT3phRFBZUVdBTitnbURWang3bkE4MXZGOUw3?=
 =?utf-8?B?RWUxajJsRTgyVEdhMUdOUlVJY2xpQkZ2d1N4VDcwUmUxSHlhbURGVHRQVWRv?=
 =?utf-8?B?WVdqbFk3ZFZWTnMwajVCRm1MbnhFZUFyOFRHbUNpSG96NTMzMlB1MFVOMmdL?=
 =?utf-8?B?ZGRubnZVeGJBdDBjZDY5MFdlNTBTbzVNNDRUMEN1Y2NtaVo0TG9kc3UxamVO?=
 =?utf-8?B?Sy9kbndZOFptRFVrMXNBYklWQ2gwWjBST0FRdnh0cGo4em9xbUh0WEZENkJo?=
 =?utf-8?B?K0t2dDJSWWE0cU5iaGptYnlRM2dIUDhjY0NlM25ET2o2Y25ZM2UyWkp2TnBn?=
 =?utf-8?B?N2g4c3RvN2x1bFcvcVU4UUpOVUxITE0rbXM0RzBkdnp1MUwxOW1mZXV2TDF3?=
 =?utf-8?B?L2NCVTRMci9IeTNlVWlXS2RTWW1XVzZwcFhPcm14TVVtVmIwMzBsZk1RdGVI?=
 =?utf-8?B?VmpBRW1YZC9TL2RYYUlSSWVBbk5VWEwxUFlROXVjYlZwY3hqRDNlNlU0RmtS?=
 =?utf-8?B?ckhmSHEvdDVYVEFQc2ZYRXRIVzBwck1aVTJYRHA3MUtVSm1vZzVQMmQ4VXJZ?=
 =?utf-8?B?dTZ6M2RqdnBVOU5BSm9SSFcwK2xlazl0ZkVRclJDVmhsU0YvMWdGQXlNVFhF?=
 =?utf-8?B?MHVHeklRelBSRTdBTFBuLzdaYkNib2ZOankxcDgrbUszQlZoWitFN0cyY3BV?=
 =?utf-8?B?SGphUzFiOS9ySkI3UTk0aGt1SHdGYlZPVy9PUW1ENnVOWjFLZHZpMjJZUWhj?=
 =?utf-8?B?RG0vRGhvQ1RvenBLZGdaaXhobkZwTjlmY1BRUDIwUWtZTzNHVzFCRlFXdHNk?=
 =?utf-8?B?UEJGbnNLR2JQenRtZSsyR0t6bkxUNVNoSkJNSStEWHk5My9WUDBlL01iQ3Zy?=
 =?utf-8?B?d0Y2SThiM0pGYjcrVUFCZm9wZmY2Q09jd3N3RHowbVJTck10empxVUNpL0Nm?=
 =?utf-8?B?V1ZGNGxTcjBPQ1pldGxhWkdSWjZVSHcybkdEdUMwRGRsTGNaWThUbW4vTVM2?=
 =?utf-8?B?a2RCSDkrNWZDQkNSeGdpcGRKTG4reWVDdTdKbWN5d3ZObFRTTllKMUZJY1hs?=
 =?utf-8?B?ODU5UlBvUUdzT2t1Q1lLMGNScmdaaVd2TFpPT0p5bDNFY3NJUmM0Nmk1MGJl?=
 =?utf-8?B?NTNsR0srOWE2MS9HeERScDVUM3ZmYTJ3VW5ycTBDUE8zbURsMHJYMUw5aTFD?=
 =?utf-8?B?WURmU3Y2Qmg2ZkVpZmRBNG0xUzF2NVFLdTh2YjJxTW5nRjVRWHZ1UG83a0dB?=
 =?utf-8?B?cWc9PQ==?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d87598d-1ecc-4b9a-e6d2-08dac855db9c
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 04:40:31.0801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yoKNKyWnDPi385uv4Cr1CnFSEJ2Av/e0EKOIHO4cL/eV5tpRU0cb4bDz2qc4fUIA+x9wLgdFmwPR9m106TYQOMDIBvoi5iAcGFYaFQ7oKc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7028
X-Proofpoint-GUID: -mDzdHSutXUfHoGQz8DeLkKRF1Ejsz_v
X-Proofpoint-ORIG-GUID: -mDzdHSutXUfHoGQz8DeLkKRF1Ejsz_v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_02,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170032
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/17/2022 8:21 AM, Florian Fainelli wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender 
> and know the content is safe.
>
> On 11/16/22 15:57, Andrew Lunn wrote:
>> On Wed, Nov 16, 2022 at 03:27:39PM -0800, Florian Fainelli wrote:
>>> On 11/16/22 07:07, Andrew Lunn wrote:
>>>> On Wed, Nov 16, 2022 at 10:43:05PM +0800, Xiaolei Wang wrote:
>>>>> On imx6sx, there are two fec interfaces, but the external
>>>>> phys can only be configured by fec0 mii_bus. That means
>>>>> the fec1 can't work independently, it only work when the
>>>>> fec0 is active. It is alright in the normal boot since the
>>>>> fec0 will be probed first. But then the fec0 maybe moved
>>>>> behind of fec1 in the dpm_list due to various device link.
>>>
>>> Humm, but if FEC1 depends upon its PHY to be available by the FEC0 
>>> MDIO bus
>>> provider, then surely we will need to make sure that FEC0's MDIO bus is
>>> always functional, and that includes surviving re-ordering as well 
>>> as any
>>> sort of run-time power management that can occur.
>>
>> Runtime PM is solved for the FECs MDIO bus, because there are switches
>> hanging off it, which have their own life cycle independent of the
>> MAC. This is something i had to fix many moons ago, when the FEC would
>> power off the MDIO bus when the interface is admin down, stopping
>> access to the switch. The mdio read and write functions now do run
>> time pm get and put as needed.
>>
>> I've never done suspend/resume with a switch, it is not something
>> needed in the use cases i've covered.
>
> All of the systems with integrated I worked on had to support
> suspend/resume both with HW maintaining the state, and with HW losing
> the state because of being powered off. The whole thing is IMHO still
> not quite well supported upstream if you have applied some configuration
> more complicated than a bridge or standalone ports. Anyway, this is a
> topic for another 10 years to come :)
>
>>
>>>>> So in system suspend and resume, we would get the following
>>>>> warning when configuring the external phy of fec1 via the
>>>>> fec0 mii_bus due to the inactive of fec0. In order to fix
>>>>> this issue, we create a device link between phy dev and fec0.
>>>>> This will make sure that fec0 is always active when fec1
>>>>> is in active mode.
>>>
>>> Still not clear to me how the proposed fix works, let alone how it 
>>> does not
>>> leak device links since there is no device_link_del(), also you are 
>>> going to
>>> be creating guaranteed regressions by putting that change in the PHY
>>> library.
>>
>> The reference leak is bad, but i think phylib is the correct place to
>> fix this general issue. It is not specific to the FEC. There are other
>> boards with dual MAC SoCs and they save a couple of pins by putting
>> both PHYs on one MDIO bus. Having the link should help better
>> represent the device tree so that suspend/resume can do stuff in the
>> right order.
>
> My concern is that we already have had a hard time solving the proper
> suspend/resume sequence whether the MAC suspends the PHY or the MDIO bus
> suspends the PHY and throwing device links will either change the
> ordering in subtle ways, or hopefully just provide the same piece of
> information we already have via mac_managed_pm.
>
> It seems like in Xiaolei's case, the MDIO bus should suspend the PHY and
> that ought to take care of all dependencies, one would think.

Hi

mac_managed_pm solves the soft reset triggered during aeg. If you modify 
it back to MDIO bus to suspend phy, you still need to solve the problem 
of auto-negotiation,

thanks

xiaolei

> -- 
> Florian
>
