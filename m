Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605E141BC94
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 04:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243723AbhI2CIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 22:08:02 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:49494 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242761AbhI2CIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 22:08:01 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T20UbS010093;
        Tue, 28 Sep 2021 19:05:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=p00CPv95rBVU16C8uNZ8q6weqZzp4TdsdyjKjED9mak=;
 b=Ml/fOP6/LX81f/I+NW3TppWvIkoy4O6HvolffmPZwAPQLgrAHLjWl5pYKy/uT2KxXDqG
 6CbB1UDxxXqParfIWrAHooNp5B3+q8/67ZnCIes8ShuP7j4HBUqNM8eofv70pn+RwSZ8
 g94o4vvVMO3oacuS6EQX7UXgyPTnmMFNT7I/gEGNBo6k/r1I9AlX6ARVvTQQlrEeTtaX
 2Wx4PtUpgV5uowpIU34j2ZXmLqX/5hSDnka92RIyl52Gx7yQLsedSun8euC/KToQU9+S
 /llpsIpbARVO3ONdKXMEJlM3q+ialrRHANfVOSAERiVIHdV4MedoGpO9dsjm9P3/PA/7 IQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bcceqg3bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 19:05:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9kL8gRWsIFYHmFdgNMKJNycR144uZ/QW24L7iHbmWzewtU5W5Bi62vbR/XCeboFHNTEkHkrNq93n7Yj3cETaxQHOqW+RoD/kkj+X7WkLA1szDeAbQdJsVvGPGEilM/VfWrTOu01zNdYDCIJ+OQt3j9dID13CB+opL0k1+yfxHATvP2YS5KxB5nFIsJvSTVu2ZMmXQNhjRMl/6hPyZgcHn8LC4d3Puk1dwJ6Zy0RELqRXhKeiwiBtFf6YN3rpzgwW89EO649XAlkg586W1grNTOkIZChZURgZPotZ2zzvm2At6+Q3Tha0ZE4oeiGSnwolKkwMOcC7f6zKLrx9GYDCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=p00CPv95rBVU16C8uNZ8q6weqZzp4TdsdyjKjED9mak=;
 b=IeIwJn7h4iWje5/4XvjRzll9epB8bP8AABs7j8X903tNFeSOtt8Rn1FV2SaJzR3OIEoLXPzbX9ypgBLhkWChIDbSKcVgSn9ZfBurlQDPLJCxLspQr/qPcRnuCkgnRr4uTqciR6ByrSjDGDCPznfdfeQXRQfs76GfX3U9oS1rdMSLqrWPco1MTJuOdNsMR1hMYihoYoIGoJUv1IzL1KI8QzwijrsFXxyqt8Xu7SWl/m6V6bF/HCWggbAzqO5vRYbDFPhWcW9LKZACKlSLD+6AqpII0z3vn909iK8OkZAVwCxgdq4Bi14sVoUCc7qu7MrP9+dlmRAMVaDz/YW/a9dF5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM8PR11MB5734.namprd11.prod.outlook.com (2603:10b6:8:31::22) by
 DM6PR11MB3866.namprd11.prod.outlook.com (2603:10b6:5:199::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.13; Wed, 29 Sep 2021 02:05:52 +0000
Received: from DM8PR11MB5734.namprd11.prod.outlook.com
 ([fe80::51b7:91e3:7c34:57a5]) by DM8PR11MB5734.namprd11.prod.outlook.com
 ([fe80::51b7:91e3:7c34:57a5%3]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 02:05:52 +0000
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
To:     Dongliang Mu <mudongliangabcd@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, p.zabel@pengutronix.de,
        syzbot <syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
 <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
 <20210928105943.GL2083@kadam>
 <283d01f0-d5eb-914e-1bd2-baae0420073c@gmail.com>
 <f587da4b-09dd-4c32-4ee4-5ec8b9ad792f@gmail.com>
 <20210928113055.GN2083@kadam> <YVMRWNDZDUOvQjHL@shell.armlinux.org.uk>
 <20210928135207.GP2083@kadam> <YVM3sFBIHzEnshvd@shell.armlinux.org.uk>
 <CAD-N9QXHcrv+6SJSOz3NyBkAnze2wVf_azYmjbGCVd5Ge_OQng@mail.gmail.com>
From:   "Xu, Yanfei" <yanfei.xu@windriver.com>
Message-ID: <bc07380e-54ae-1699-aaaf-3380f11c3eaf@windriver.com>
Date:   Wed, 29 Sep 2021 10:05:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAD-N9QXHcrv+6SJSOz3NyBkAnze2wVf_azYmjbGCVd5Ge_OQng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::17) To DM8PR11MB5734.namprd11.prod.outlook.com
 (2603:10b6:8:31::22)
MIME-Version: 1.0
Received: from [128.224.162.160] (60.247.85.82) by SJ0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:a03:33a::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Wed, 29 Sep 2021 02:05:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a64656c3-aa1b-4484-cb87-08d982eda9d2
X-MS-TrafficTypeDiagnostic: DM6PR11MB3866:
X-Microsoft-Antispam-PRVS: <DM6PR11MB38667789DD968B85E5795AC0E4A99@DM6PR11MB3866.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H7Rhy89SrxngveC/nYIEqmKQkcp0xo3h0XU8GowHbMZdq2heM+rNyxG0ty5UxpGcvTWDCLsCVDoBYoPRzSm/jmK+JHAYlQ8OS6/ZoV+Wk/uX8yiZSGzKf+zjow1pZkfgYspSdST4TPMYQ97ql84qctM3Cz/tVn2SKfRWhnF7ejP63H3WTht3A3HH1V/xy7XraTF9TkfdWqtrRshFolfL/E/3JEs5AQSR9w2p5jbpE7UDyI0oh0fCeGFfEMpUklymBI008LVswwe637WO/iF6dpA8khi6aYmLTurWhvdrmAHMBsa9U3aDLCYfZBXPIo8uhH7La/uLD6ghrNP2qjv9KOn/vbAa8HbN2ca53x2O8r4er4P3sNUGR5u7ug1gWmFVI8cruXc1MjpDVU1XRMP6JjR9IA8NbTRr+ZrbssJdoOCE1ew63LpzrCxyMxYgeBDkYGAiUvgxj2Hz2IldUSVO0sh5w3NlY/Gb0ESEFMp5jqixAnJdaJjZi1ifcwvmXRLB0OJPffWjkfX5rbCqi/we+Z8ve1jVmqYxM8UIm7J8oGDld+db9ftA7nVPrSChTZxWO9nvxldSF7vHtvADShmy03lHe0xsYY93C4PS63H3c4iXSa361Z0Ya1EWdNSJGqrOObTftx4pUFyiekRde/bCpNtt+GKd5ZWuA1v+nlNzYJjzsWGkkp88WUUlwuUC+rTHz5QBrNTFLfcSlNvM053lPENCgKDRkzLSCcEoC52+sRMXtmGSWJ2ykmfsAxMggnB8pl84pqGSEFMgSzl7kAfo0CO3FO5dqWGm+2o+YUklULR/ZfRn+ycsb1k4mxvV7gbNNOd64fX5/uzhssnJqtJJl9xMe+lzRpeuJwCDFfs5KpMOBHWwJSBjafo6g2xF06TdDCIa7JAovlsDmMF0J3HhlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(16576012)(54906003)(83380400001)(8936002)(26005)(2616005)(8676002)(38350700002)(6666004)(110136005)(38100700002)(5660300002)(316002)(4326008)(52116002)(6706004)(186003)(66556008)(956004)(7416002)(31696002)(6486002)(66946007)(2906002)(966005)(86362001)(66476007)(31686004)(508600001)(36756003)(99710200001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGVONUtmNUlIN3VsYjAvMk1WY3o0eTVzZkxuWnp4dHRrODVZVWl3UHdKODkz?=
 =?utf-8?B?NTNldkxDcldLczc1bXpMRk1vaVZZQ2xlbDFnWUxaRjZMdXRIeEt6UUptOUJM?=
 =?utf-8?B?d0hxRmxGY0RpQXBzTVZxUmd1TmZQLzMwNTV6dXM0SUYzZUNhNk5lUFZHVXlr?=
 =?utf-8?B?WTAxUzFkOEc1NVhhNEZPY0FwLzR4c3J1d2NFclJQUUJ1VFU5N05xb2d5ODg5?=
 =?utf-8?B?bjlLelVvaXhOMGRTR2prZ3RpY2ROUWhVdXJLZ2QvbFJIRVRGaW9sVW1pL2Nq?=
 =?utf-8?B?K0JFQWc4Smt1ZjhCOG9oZEoyN0xYSTBDSTNpWGJlZFQxTzhkYWJMZVg5anFG?=
 =?utf-8?B?cWd3NXFRRzBnNWZOWDIybURscDBYdlg3SEd0Qm4yS1J3YnRhMXpBNlBXaExz?=
 =?utf-8?B?SlhsbVBaL3ZCMTY2WWpMOEprV1k4SEROK2VxTUlMTm05RG9jT2lIWGVGQVRD?=
 =?utf-8?B?UGxoRU56UE5JcTBrQThMemZEeE9UcjRzankyQVUxNDdBR0JwdGl3Zjk1cXFk?=
 =?utf-8?B?UGF6dndwaGRBMGQ5c2ZqUGhRVjMzNEVSU1pqcFd1MWwvTkVtaGtPK3A1M1Jv?=
 =?utf-8?B?OGhaYnlwekFXOTFRUHJGTDRwZXFQUjRFdjJyQm5OT1pIcnkzYlJRc2ZEcnlZ?=
 =?utf-8?B?SFcwVTFwUHhQN3ZkdW1Eem96UlV1TFRINGVjcE9qWHcyZU9mSFhNc0Q5S2hl?=
 =?utf-8?B?MDIvRXprNnN0aFpVL1duckVnZDBpR3ZvWlZ3UHFXMkFPWDVReEkxcGlrMnUv?=
 =?utf-8?B?UXhoWVpaK2FzZGorVW4zUWkxeFQxQlFvS0UyNkx2SWxHZnVZUW9OK3ZmYlhN?=
 =?utf-8?B?eTBwNGk2VkxJS1d0aDl3Uy9rTnBRL2lpblBQRGoxUy9RSVRiTVc3SU1jNUk4?=
 =?utf-8?B?aTdocmFYWXE3VDA2emRMdjQ0RVdncE52TEtMdkFvUUNlSEgrMy80K1J4L012?=
 =?utf-8?B?VG00Ulpza3M1MWlPcUw3aXA4Z3VzMWxINHp4Y0ticmZsLy9KRWI2UDRsSUtX?=
 =?utf-8?B?UUdWaWtudUhqVW5oY3BNOUlIR1pZOVhZSk00WmlZdGlwVHZWVWNkcUtkQVps?=
 =?utf-8?B?T0dSL0pDQjZ5MElTT0N3a094M0Q3czk1a09TSFBjbFNpbFIzdTBZaHBFZjlV?=
 =?utf-8?B?dWJvZnlqb1ZEQi9kWkx5cE9aRDN3S3FnUUh0WmtBUy9ocUpMVkttcFRCZklq?=
 =?utf-8?B?TUVQRXNSNkNSS3kwTHUzRXhITHVLY05mR2djWWNzcndpSmxTUSt5K1pGT0ll?=
 =?utf-8?B?RFFzMEJndm5tNlAzVGduak9mYnlsMSsvbDBxeVlhNHJqNjJ5T01iRU1FZWFw?=
 =?utf-8?B?VnNoR0FiVXpPaHBTWGFiMC9IcEJ1NnNYTXNTaEdua0luVExxZ2ZuUzl4K2Qx?=
 =?utf-8?B?VktkakZUSmg1Yk5PU0F2Vnl4Uys4Y1M0eWNQT203SFQ3cE9mNEpMdmJCVjJP?=
 =?utf-8?B?YXo4bDlWSnRnU1BiVlFkOHNCQUNyNi9pOHFCWUQreU1EbWNhRnhrVm1pN29s?=
 =?utf-8?B?MWR2c3c4QnBiV2UydWhmdm0yTkFKNEMyMnk1dzl0aUZNSHk3Nmlob29XaUJK?=
 =?utf-8?B?ZElJZU8vSUYxOGh6QXF0RmVYVU5xVFl2eWhGenNIQkl3K203OWxzaExUQUdE?=
 =?utf-8?B?ejMwTVVYTTlNdlBtM0ZINzBxY0hWUUJaY1MyakZyMmUrb2lnSUZhUXRDVG93?=
 =?utf-8?B?WXpzMkUyV2pIcFJ3ay9uTEJLYWtVbTYvNzdxdHRhVXkxdzl0QVdsVW50dHNY?=
 =?utf-8?Q?uqee7Vw81WxaHXZ60FrND/YnVcy7iX5TRO9bhjm?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a64656c3-aa1b-4484-cb87-08d982eda9d2
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 02:05:52.0746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rDUrmbbZsQucP152rR8svXoWEQySM8kntAcGPZfcSiJ0cDm1YG4+johykrITeQI7tdvLsXtVk7vr/kJJQsIMmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3866
X-Proofpoint-ORIG-GUID: f67eDul3iP8-6ogSEWo5LGfonStegE9Z
X-Proofpoint-GUID: f67eDul3iP8-6ogSEWo5LGfonStegE9Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_11,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 clxscore=1011 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 impostorscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/28/21 11:48 PM, Dongliang Mu wrote:
> [Please note: This e-mail is from an EXTERNAL e-mail address]
> 
> On Tue, Sep 28, 2021 at 11:41 PM Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
>>
>> On Tue, Sep 28, 2021 at 04:52:07PM +0300, Dan Carpenter wrote:
>>> On Tue, Sep 28, 2021 at 01:58:00PM +0100, Russell King (Oracle) wrote:
>>>>
>>>> This thread seems to be getting out of hand.
>>>
>>> The thread was closed.  We need to revert Yanfei's patch and apply
>>> Pavel's patch.  He's going to resend.
>>>

Sorry for my patch, it is my bad. :( And thanks for Pavel's v2 which 
help to revert mine.

Regards,
Yanfei

>>>> So, I would suggest a simple fix is to set bus->state to
>>>> MDIOBUS_UNREGISTERED immediately _after_ the successful
>>>> device_register().
>>>
>>> Not after.  It has to be set to MDIOBUS_UNREGISTERED if device_register()
>>> fails, otherwise there will still be a leak.
>>
>> Ah yes, you are correct - the device name may not be freed. Also...
>>
>>   * NOTE: _Never_ directly free @dev after calling this function, even
>>   * if it returned an error! Always use put_device() to give up your
>>   * reference instead.
>>
>> So yes, we must set to MDIOBUS_UNREGISTERED even if device_register()
>> fails.
>>
> 
> So we have reached an agreement. Pavel's patch fixes the syzbot link
> [1], other than Yanfei's patch. However, Yanfei's patch also fixes
> another memory link nearby.
> 
> Right?
> 
> [1] https://syzkaller.appspot.com/bug?id=fa99459691911a0369622248e0f4e3285fcedd97
> 
>> --
>> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
