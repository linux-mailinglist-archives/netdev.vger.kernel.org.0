Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EC063A00D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 04:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiK1DTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 22:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiK1DTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 22:19:06 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A2B12775;
        Sun, 27 Nov 2022 19:19:05 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AS2fuuW029505;
        Sun, 27 Nov 2022 19:18:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=message-id : date
 : subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=F6FwZhW4/p6eL2+utBGUwnMNV7n8h8HA0kavMKwuOKU=;
 b=bjwW3yHYimSZTSLwp3S7wSt3kjZ7BdXMm6k2MTBtjKWichp1JHfghwwFgbKEQlj2AvvP
 5audKk7wowfzkSbAHLkRRXpk2LzJtuiiIR0QcWpW+sEdtUAavuUWWv7+T3lBYmf+Lr4n
 volkroHoI0XpLQ0a8SASOqhCTcl3abglJq0F4YmRZ8Aefe6qXS5dCTi0vE/cYxDb7aJA
 gNXqVZ0lW1ySC8GWJ0t0fNzzHktluBjE6pj40Xh4Mm7ylz6hdOhQepfMV1DRyM4pE+Lr
 rVgiL9mnipdZbHt+3w5i9YhP3UW2wqxuD6eVDMZZrjYQeTgMhg0I+JJ3KrlNkwnaMJE/ qQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3m3k6r8wyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Nov 2022 19:18:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i17VoukbyVZz7lgEzV93ge4VoPfYjlUrL1aq1uzxtXkyMEtLWoCE9KkgWfbdCJWbIQ/uJPkCkxDzLkwCSZIlyHKAM+F5re6+lFuuBBeymg7JytwTDkMncJ6uyFaAMZxChY8nMvN/nA7F549DJRe98mhDnAf9ndLugC1ti4mHChEwFnbJM1Gc22W+YtV3oEfMX0jBDcoGDxWre5lWf9hWUHgTMKXDNbpz2gP5RXWuxzyJKsJZ34ZUJxQgaxogBkL2KMY/iAK5GLm0Cg7FIzTlwY2UFIBDagB4gH0KTMDw8xOkUE7NBqif/xa5wZPqsm3PzV7U54V2V6e2CXOQPWSdXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F6FwZhW4/p6eL2+utBGUwnMNV7n8h8HA0kavMKwuOKU=;
 b=Ds2nBHt0X84wI5s5e5Y6KgBIxjXnlJYDVoFSbEGogh00mmNYUzYuXxWcBGYNsfqkDAFitChfpWV5SWD7be06WZcyW38sTC866U0NpF5IV+50aTmX3IAFhxAz/tRLxCmI+w0Mgs62VkmBHwd7FoKD+5XIgD3+zShwI9cFDcENRv/7ClFmDHr9zjPwKnj3GAaAAKnTFaLpbB+ZeRsgxsWUwtRkDATOsR+heuCGJYCJVZacVRHVnWFlVGWk9RELz4GtxJ57YCzlZX28ewLlCqpu2yVm6gUu/kRYlDuSmuuhOjaSEFQpyffk3I9gEKuf11V6sgiWjXpsopUXVsvPOBbBng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Mon, 28 Nov
 2022 03:18:31 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b%3]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 03:18:31 +0000
Message-ID: <e51628d6-8baa-274d-32bb-75f922ea7a0f@windriver.com>
Date:   Mon, 28 Nov 2022 11:18:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [v2][PATCH 1/1] net: phy: Add link between phy dev and mac dev
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
 <20221125041206.1883833-2-xiaolei.wang@windriver.com>
 <Y4E3EOTXTE0PuY6B@lunn.ch>
 <6b50524f-4f24-d14e-9d3f-f03f25ca549b@windriver.com>
 <45a8283b-64ee-599d-3ec6-abe2b2f96920@gmail.com>
From:   "Wang, Xiaolei" <xiaolei.wang@windriver.com>
In-Reply-To: <45a8283b-64ee-599d-3ec6-abe2b2f96920@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SL2P216CA0222.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:18::7) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|IA1PR11MB7198:EE_
X-MS-Office365-Filtering-Correlation-Id: 9299082d-4b6f-42bf-a9bc-08dad0ef39d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NhVUDTVP6fGWi9ddXz1j+SwfjH4NPwDaotXbijQIGdUMURaLz/AFZit1Jlh9qFT5KC+CbROzIjA72FP7EoesdVqWAendERhVZbt68YrlBIoBxmSOdnC5dlIRXlmqdaIaDuX/TlWTSbBOvixBqHPfxYsSk2wvQRRAuGjbNqUHgnSJKhOfkjyxQpewh40UNEIhsmnyEe+mpkQ2/ijCRQot7YAnVQO14cta4lPY/KnNb2H7PoAKcjYKyNwfzWutVo2MjVRP146EaMTRZ6wm8lOTxbJUXtWKJpEgDKJ00Qe1R7140tdgEIYwmhxT94mvKkAKWMjQNJa6+gL1kYS5Y+uzPKFkdo67ZXFbgTMP7LcYOoc9YFK43mq/JZeB9IBah1QBHPA7g6QdeS6n16NSUhiFSXj3ZqCon2p7dS1O4WQ7I3N+cjZ/sGRBPlXxwatQzgbclaHrRe5VeSJq/g2m1n7eOZi5jKpvMQl7FFRrPoeGLw7vSyonwsyxrVeVW7pf6jXe9hL6EcerEFDnslt7W14KLZSkXRtrFuroNIY6tjXiBxiK6qzO4FAfqV3eOft1Xw1VaQWKwW4WDIYFaxIa5jePNtihcO1IprggC+fV+6Jw8gK8W1JRHp0OGw1SRoh83cm6DbObZyqarcfKj5jkRIuv2WDukLp1PgLW6YHw3Z+s/ZCsvhLzIH/k1VPt3d7apSt4vLhfoDXPc1vzm5EuJbCBClcrWeGC7ci3YpmJQU0I04lcT8WimOQ8bT5jujICGqUf+0aIxH4eq/DPgAJQP53bpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(396003)(376002)(39840400004)(451199015)(45080400002)(52116002)(6506007)(53546011)(6486002)(6512007)(478600001)(26005)(316002)(110136005)(66946007)(8676002)(4326008)(66556008)(66476007)(31686004)(6666004)(41300700001)(5660300002)(7416002)(186003)(8936002)(2906002)(36756003)(2616005)(83380400001)(38350700002)(38100700002)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmVtMmlQYWFtSUhzL2d5bWRsVWh2VG5VZHFJa2pMUTRuRmNsUWdmUkM1Q0Zs?=
 =?utf-8?B?RjJQSTdYaitpdDB6TVJqSmVDYSswMFdodTRHajJXQlpnbWNQR3Z0aDhad2Yx?=
 =?utf-8?B?VUFFT25rSisrUUh0c3NuWkM1bHFEd3NCNEpkOHpoOG91ZHlZWHNKdTUwY3Nj?=
 =?utf-8?B?NGx4UlQ1MjhRMjN1aFN5bXMvWk93S25uNDByT1ZmRU4rMDNZMTZoTkZOKzVj?=
 =?utf-8?B?MkE0MmE2Z2FEWGRWN2JoT1YydGlHL0VTYnVJekhRNmpJSGRuTTJhNjREbXpS?=
 =?utf-8?B?c3hGWXFSN3dBU2dSb24ybXMxRVBQYW83OVRmL2VuRWpRVWNvSHZoMER5Yldx?=
 =?utf-8?B?ZDdIOVExb0lnMU9iV3UzNVVwU0VCTmxhMU1DU2trQXgzU0NuSENPUEpTeHpW?=
 =?utf-8?B?eVhxL1NBcmNzV2wzRDF4RjdiVEFod3pUTEZZTmdMemJNcmZOSWE4RUlsc1Ir?=
 =?utf-8?B?NVlZL2l1VHMzS29YNVdBa3FvQjFQdGJzWkNjd0RjVzdzazNTRHIwc3hzVGFT?=
 =?utf-8?B?MnpqM0VEd04xMVVxVnF3N0QwRTNwSDJ6Z012NXlzTnpBQ2VzajJ4SFBDd09F?=
 =?utf-8?B?SWZERmlYQ1hQQ3RSU05hRkp6S2huQ3ZTeGlIRDNyLzFOWE01MlBueVFvNVNa?=
 =?utf-8?B?RnRxLzh5RkRwV1E2UzI1V0YvcTB1Y2ZLOTA5SGJZZVFsNGZDWlhTcmtoN3NT?=
 =?utf-8?B?THV6U1E1anNZSElvTXFWb3Y3MWh6dys2ZmtIOENFWWRkZVc0TFJmeXJwN1cw?=
 =?utf-8?B?YkdHNUxJazUzQ2d4aXFEUGdFVm5JNlR4Rkl2ekxiQTZQRzlGckN0aU85SW1L?=
 =?utf-8?B?b1NZU1BIWFNpY2lURkh0R3JPNytvd1VDOFZoRThJcGlOMzkxN0tuVXYwZkVr?=
 =?utf-8?B?RmozUFc0bW4zZ0hCV3VkU1NkaGpGZEgvd054WkJUQ1pHYnZ0N3VvU3BVYUs3?=
 =?utf-8?B?SDB3MkxGcTc4eHQ1NVdQbVVSdFdFVnlVTnltSmZOWEZueE5yeW1jZG9EeDVh?=
 =?utf-8?B?bDlSdElSR2hBZ0V0WkhwSUc3dUlFZzB0VmF3TzNpNHJlbGF1UkhmRFR4d0Za?=
 =?utf-8?B?K0JpUTUzSytFQ1lUdWlacE9kTUs4TW9iNm1iZnh0KzZMOTRUTUd3MDR1RXBo?=
 =?utf-8?B?K2FXTXphWkllNHhOODlBTlBtbzBQV3UwaUpwZ1BTWE1zTFBQaGVmNllFa1Bv?=
 =?utf-8?B?d090RXhxSDVIa0tmS3BTUGs2TEtYeU9hVlVmaEdja0xVZmhnc0hVekI3ZkdP?=
 =?utf-8?B?VGtCR2tZR1o2SFRkRENsRUorWmQ3NjVvZEErbGlYNnlVRjJ1VDNMVksrOFlM?=
 =?utf-8?B?d2c5OFpCTTE5UEtZbTBHeXBNeVVZWEtOaDNxRU4xT1d4dDVkSVVha1MzaGxH?=
 =?utf-8?B?eEdocjVlcTBTcGR1emgzWGxpS2xPVEtwb01ZRmd2Ry9iRDVheS9YSDkwL3pT?=
 =?utf-8?B?TTBtTXdLejJuMDBJUlBrWjk1Q1JRRHhsY2pDUmtnRkRqZWFwN0hBd050cjNQ?=
 =?utf-8?B?allMR3l4ZS9iZWZFU3RWOVVMSkV5a0tpUDBHNzJWME5kRHlVSWQ0UFArTXlm?=
 =?utf-8?B?cHBEZ1VtczR0cmZKb1VRNDdqajljUXZpWVcreW96TUVVR0grbmhjZGdnMVEy?=
 =?utf-8?B?N3lMTlhsS3lVUENQcml3OVplSHVQaXhNK3NYRWk0a2tLVDM2Vm1PSUZzalJ2?=
 =?utf-8?B?dVZ6R05kNmdUdG9oTlAzWW95cnNXclFpTmxmNVBNaVYvMGdPTkF2MXJoRmdZ?=
 =?utf-8?B?NFhzRUtNejV4Z0Y0QTJ2N01veHRoR3UzRFpTakR6UkhkVkxBN2tiekxRRVB0?=
 =?utf-8?B?SmpyNkY5VGlPYTZ2MFhMTng5ZW9GVFFMc1kxKzM4UG9ZK0tVNGhuYkdHTWJC?=
 =?utf-8?B?UVdZRU1FSmltRWR0NEJlMFFnU1pra0lVbFo2RVBPMFNialNVdVpEWmQ4ZjRF?=
 =?utf-8?B?VnJMNUc1cmZTelVWdWZ3VXFOM0U2bzhqOHAxcGZjQWoxb3VZdGNwd3BObXZO?=
 =?utf-8?B?dzdCZUEzc3pueG1iMklQZ2UxL1pacFJJeHk3SHZ3ck1zUVkrcmh1UEFaajVM?=
 =?utf-8?B?bkVWbnJRczREWmpHdDZ4ZnYyTG1tbURzakd2TkpFeGIvUG5PRXY4eG1lcDJU?=
 =?utf-8?B?S2pBaHlKOEk3Rzd6N3lDK3ZjOWhiMUlmc3d2ZW8yUSsyOEcwNEhPTnF0Y0lh?=
 =?utf-8?B?ZFE9PQ==?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9299082d-4b6f-42bf-a9bc-08dad0ef39d0
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 03:18:31.4740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tC6GFuBEM19MEK7CTVbAlE6Ve1XxLYQSpWaoUyoj2lO7zu76+3M+hG4R8zGSGT84DrOXc3fAA27BRkZNgvZO39Um8H/E4vVZwK82nBPYD4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7198
X-Proofpoint-ORIG-GUID: u0DLRfxc_jTr_XDOTdzWpIupNVBN1coS
X-Proofpoint-GUID: u0DLRfxc_jTr_XDOTdzWpIupNVBN1coS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=599 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280024
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/28/2022 4:30 AM, Florian Fainelli wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender 
> and know the content is safe.
>
> On 11/25/2022 5:41 PM, Wang, Xiaolei wrote:
>> add Florian
>>
>> thanks
>>
>> xiaolei
>>
>> On 11/26/2022 5:43 AM, Andrew Lunn wrote:
>>> CAUTION: This email comes from a non Wind River email account!
>>> Do not click links or open attachments unless you recognize the sender
>>> and know the content is safe.
>>>
>>> On Fri, Nov 25, 2022 at 12:12:06PM +0800, Xiaolei Wang wrote:
>>>> If the external phy used by current mac interface is
>>>> managed by another mac interface, it means that this
>>>> network port cannot work independently, especially
>>>> when the system suspend and resume, the following
>>>> trace may appear, so we should create a device link
>>>> between phy dev and mac dev.
>>>>
>>>>    WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983
>>>> phy_error+0x20/0x68
>>>>    Modules linked in:
>>>>    CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted
>>>> 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
>>>>    Hardware name: Freescale i.MX6 SoloX (Device Tree)
>>>>    Workqueue: events_power_efficient phy_state_machine
>>>>    unwind_backtrace from show_stack+0x10/0x14
>>>>    show_stack from dump_stack_lvl+0x68/0x90
>>>>    dump_stack_lvl from __warn+0xb4/0x24c
>>>>    __warn from warn_slowpath_fmt+0x5c/0xd8
>>>>    warn_slowpath_fmt from phy_error+0x20/0x68
>>>>    phy_error from phy_state_machine+0x22c/0x23c
>>>>    phy_state_machine from process_one_work+0x288/0x744
>>>>    process_one_work from worker_thread+0x3c/0x500
>>>>    worker_thread from kthread+0xf0/0x114
>>>>    kthread from ret_from_fork+0x14/0x28
>>>>    Exception stack(0xf0951fb0 to 0xf0951ff8)
>>>>
>>>> Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
>>> This needs Florians review, since for v1 he thinks it will cause
>>> regressions.
>
> Please give me until Tuesday to give this patch some proper testing, 
> thanks!

Hi

Test on imx6sx
Before adding the patch:

ifconfig eth1 up
echo enabled > /sys/class/tty/ttymxc0/power/wakeup
echo mem > /sys/power/state

The following problems arise:

WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983
phy_error+0x20/0x68
    Modules linked in:
    CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted
6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
    Hardware name: Freescale i.MX6 SoloX (Device Tree)
    Workqueue: events_power_efficient phy_state_machine
    unwind_backtrace from show_stack+0x10/0x14
    show_stack from dump_stack_lvl+0x68/0x90
    dump_stack_lvl from __warn+0xb4/0x24c
    __warn from warn_slowpath_fmt+0x5c/0xd8
    warn_slowpath_fmt from phy_error+0x20/0x68
    phy_error from phy_state_machine+0x22c/0x23c
    phy_state_machine from process_one_work+0x288/0x744
    process_one_work from worker_thread+0x3c/0x500
    worker_thread from kthread+0xf0/0x114
    kthread from ret_from_fork+0x14/0x28
    Exception stack (0xf0951fb0 to 0xf0951ff8)

After applying the patch:

ifconfig eth1 up

echo enabled > /sys/class/tty/ttymxc0/power/wakeup
echo mem > /sys/power/state

eth1 will link normally

Since I don't have more boards here, I haven't tested and analyzed the 
different situations of other boards. If you need more test records, 
please wait, I will collect some hardware to verify different situations.

thanks

xiaolei


> -- 
> Florian
