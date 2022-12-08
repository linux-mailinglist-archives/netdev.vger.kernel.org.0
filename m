Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5316474AC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiLHQvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiLHQv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:51:29 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2087.outbound.protection.outlook.com [40.107.21.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10A2AFCF7;
        Thu,  8 Dec 2022 08:51:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULhzQ5N5UTH83oHRYmLIOQAgikup2vTVfaOuXh4DciX/5RMJJEMPqOygTjjo/xKz9qQdIcnyyhnSXMnWMb0Iwu3WOgDh4aYMczFWbnjiCIaU7dqkWq3DcXxe2QCbrAblX7sv4Q1B+22hlMFRV6Rmx6GGDao5TV4vQPnL2FQOSxqrVGGKU2XD3uZmD6I41B8vP+vd0TvnRFMmARv7k0IS0OYqb2GRQbNRadw3lazdJmFDhvHG2rkR/3oHVSvUrmsl+xvOelNm5EGchNGmA9bFWUtXfZdBI1ylOuhsPGFdG4PaMajR/NGig3msw5T1I+Fi5ouKXX2rjd/AikxvYWfZDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOKHlXiVOpuG6Gb7m+z3KOKbAr5LQOv+Ziu1ZrWJ92c=;
 b=lgDlqnjvZZHItTUU/oymBGgC3ZHNwfN0GCzKRNknXeA++vfyRPmTM0RCUDJFwLTXIZ1kZ4TGB/yC3DbNGzCb52+qvyf0pB+MBm5wRBDiPUbXM9K3ZH63WwLv+Jc/+COEvSzVwHYPqqOX26yD6NydysO37d0xGNfXKoLRJQDUsqc5ifMt/W0Nd9ZaG+A29laFp0asMFDkJeQy1vM0LXGYyUDSSKVDN2NLiqb5XsDvWi9GgUk+1ePJKNgdgKrcm3zihuQCDCLaaC9gVFaCeeISvtsjppwvpYw0TH3VB92RU/EktNWLmctP0OMiFqiyx5oRIyqaBAGajI2nrkJL8vjoJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOKHlXiVOpuG6Gb7m+z3KOKbAr5LQOv+Ziu1ZrWJ92c=;
 b=d7IHflOd388xF6jPwK39+ea6Z3+ZwrNjwVbLwEdHPZElDBU3RHELaAhDaizLwguN9l2m9puViAQ3mMlYqk9gMNSP4mY4EMAE6N6zBvUinp9G27ZfaH8q9c2J6ZYd0QHWyuE7IwZ/lVYPEToVLesZxEbDMOgOtXaxwGA8u/XRoj8o2Rig1b/4zNlNPA00U3Y9ba4OCQt5o/ybtqkttvLtLe1UhRlJlAWXS3LaMdpwz7vBlTLzwho4sem1SJKV4qklI/VkvfOVd84SgYNkcCdM42ZqqRCQHodJWJ8ml5Z5eiGe9tRMC4sC1iZWyEQMDz2opvNNGRzid9SZTkW1kRtMOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by DBAPR04MB7477.eurprd04.prod.outlook.com (2603:10a6:10:1a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Thu, 8 Dec
 2022 16:51:21 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::ae59:a542:9cbc:5b3]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::ae59:a542:9cbc:5b3%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 16:51:21 +0000
Message-ID: <9d1fac95-d7e0-69a5-c6c1-9df5bd90bcb0@suse.com>
Date:   Thu, 8 Dec 2022 17:51:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 0/8] can: usb: remove all usb_set_intfdata(intf, NULL) in
 drivers' disconnect()
Content-Language: en-US
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Oliver Neukum <oneukum@suse.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        =?UTF-8?Q?Stefan_M=c3=a4tje?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        =?UTF-8?Q?Christoph_M=c3=b6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Maximilian Schneider <max@schneidersoft.net>,
        Daniel Berglund <db@kvaser.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        =?UTF-8?B?UmVtaWdpdXN6IEtvxYLFgsSFdGFq?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
 <9493232b-c8fa-5612-fb13-fccf58b01942@suse.com>
 <CAMZ6RqJejJCOUk+MSvxjw9Us0gYhTuoOB4MUTk9jji6Bk=ix3A@mail.gmail.com>
 <b5df2262-7a4f-0dcf-6460-793dad02401d@suse.com>
 <CAMZ6RqL9eKco+fAMZoQ6X9PNE7dDK3KnFZoMCXrjgvx_ZU8=Ew@mail.gmail.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <CAMZ6RqL9eKco+fAMZoQ6X9PNE7dDK3KnFZoMCXrjgvx_ZU8=Ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|DBAPR04MB7477:EE_
X-MS-Office365-Filtering-Correlation-Id: affdadc7-eeac-4ef8-372b-08dad93c6f1e
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WxGyHteMFHF8icYnaZZjGeWI8skPlta7QtGYHyZk+beZY8OeKs5P4+VtRkMZCiNzgGH65KTjsavHmUIsiqgTskE861i1wpR5uRUhAwgMJSK2V7QsT4bgXcIG6OHZGktRluRm22wQ7xxgumNdl655jm1gAqP0s3bv575RZJnN6WzQTpxkXcLL8gJVbrmx8CONoQ0eZRYUdCqQYIKgSaMrBaq60Rl3w/MA0TIyGwUtT5Ypi9mWW3H4NE3XYRDJOjUdhhhMH11D1W2g/jEx3QZZnbRle1XMhtEulQN6f/wyBDIyIjgcI+Wjv9ce71hjvyrGVV2EiVeONnDuCAJPyJv4RKUX8OxzVis/JVnPKGnJ+WHXA7IH3+VV+hA848OX1faiUuUW3SaSkyv8UFCUNstplE4RqV4+Y+MOk16Sh8TtuD5ac5ZpWdcvz0lbGvUEOMwDvx+bY8JIBEhopzcVFIol7Yz0d3w4SybPRjkF68ja88QgP+r7L67LncgxUKKfhZFUpQfVOfqDuywMA+fyzpX+yqp4q6yaGE6Bxvjp22uVFT+pqvnAatzl+19x6giSV/IPvJPtHGyedoKn21i9urs80IVa2AYqToR+qXCcHpNCnC81GGPTp8YuYtFbLM4a3JZOAyHSxnrTh87vVw/8TF/K+UN5AmC2BV8Wx/n0P9R+iaAZ1GTOvcGlRrG3JkhGTdSKELMr4BBO/PMOPUghlT8CgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199015)(31686004)(31696002)(53546011)(6506007)(6486002)(86362001)(478600001)(36756003)(6512007)(8936002)(7416002)(5660300002)(38100700002)(2616005)(186003)(4326008)(6666004)(2906002)(4744005)(316002)(66556008)(7406005)(8676002)(41300700001)(66476007)(66946007)(110136005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UENkcmlJaTZkeTJwWWthR1NzZGRqT0tiMjZlanlOQjlSaHhRRHNDU1AxRWwr?=
 =?utf-8?B?SFRSYWlvSVNUR0pmN0M1dzVCSWZYL2tWVHlsREl5R3psaUZicnZtYTIwcGlS?=
 =?utf-8?B?V1YwT0c1K0xkUUtlYnUyczBHY2l3OEViTlVlMmlKZFNTbDZGbnpzdGxBMy9o?=
 =?utf-8?B?a3ZXdk13THRISjRNZ29LcFg5RjFtdEhMYmloSjI0TmxLRGpMaEJNRFlUN1lz?=
 =?utf-8?B?eHpIbk1UWHYxSi9uNVZzUncwdjRoSGU5SjkrY0s3aUliTDFWZllHUWFJTkpH?=
 =?utf-8?B?Y1ZpaGJUd2ozMWVzTlRNVk5QR250U042N2wxd3R3OWQ3UUNvMXY3a3VzSG04?=
 =?utf-8?B?M2tzWmZUMWYySFRBU1d3Q010YnpHTG10UkdjUkxjdXJ1T1FLMEZyYjNwYlFk?=
 =?utf-8?B?RHZnTGdKVEY2MGRUT25vVTJJNzJEcStVdXhHNVhLTGZtQW14VUE1ZHYzZmpU?=
 =?utf-8?B?UTdRYk5USHQzSnlCbjNUUHducmhEc2x1OVRScVZmeUZTd2l6WGZxQWtMVmM2?=
 =?utf-8?B?SmxCTGVjN3lkcHBkamRBOUsyNEFYT2t5TllDeXRMT3hCK3FVT0Z1TmZBQXFS?=
 =?utf-8?B?bGxvaWtnM2dNYU9PcTN4RnN5eXZuTU42NStIVmVvT3RPdGJlZ2ptUjMzOVh4?=
 =?utf-8?B?dDhPOEk1SFJ6cC81MmQyODVsT0VHWXd4R29UZHJhZzdPMG1HaXIwdjU0eERx?=
 =?utf-8?B?MHNWN0FnRGJWMlY2KzFiTmtQRnc5R3JUZk5BVkxXbzBZdjJDVDN3SmxEV0dL?=
 =?utf-8?B?UXh3dStTbm1vMks4VTZrTWtSOC82RjEwbWJqcEliMzBrRktsRW5ZOHkzdG1H?=
 =?utf-8?B?Q0JtdGZoRERRZE1Ucy9WellwMTZJamQ4aXFKVktvbzFtUlUvbGdZRUlLYlZI?=
 =?utf-8?B?YXFPWkhtUEI5cEh4WlZrQm9IVVg2QkYwS1V0N2hZOEpDZUdMakpQWUJ4T2Yz?=
 =?utf-8?B?clpEaVU2djdldm14a2pRdnFOaHZNclNQaWRRN2pGNHR3MmZLV1Z6b2RXYWJL?=
 =?utf-8?B?c2JoN2E1ckMzZmlhWEJhSk10RFVKemxIaWFtRFpQcUc0dWdvbGlZTllwR1FR?=
 =?utf-8?B?dnBzZExBcVJwVnhDYVNkNGJEVyt5QjlybFdFWmQ4OE9YZWF0TFVMZVBtb3gw?=
 =?utf-8?B?RG5JeGI4amdQaE9uMXVESEdYOEZ3elJodklEMmROQXc5eWplZENqQjU3TEli?=
 =?utf-8?B?ZmZZMzhUNXRGTXFXWVo2WTRBbmh0amhCSUJHQzRoeWFwMWRuNFJVQlptUDNI?=
 =?utf-8?B?Q1ZMSVJ2a29XSkVhSGl0dzJIc1lBanl1d0o1OXduMUQvZURvN2ZldEhVeG4v?=
 =?utf-8?B?VGdtUWM4NHhjd1BKRzUyTzRsWCswUFVzYzFSWTJvcEl1aDlNQmRvTmhaVjM0?=
 =?utf-8?B?SjJnekt4bkNqSUVvNU56ZmtxSGNaQTlCd3VleVNYN1FnV3ZUaS9jV0VnUFl2?=
 =?utf-8?B?dTJGRFM3RXVsTnJ6UFBHQ0YrMnpJcmxMRGlKeGVDcmNTVWw5YWVWM3dneVFu?=
 =?utf-8?B?dStQeTRibHEvS2dTbDJadzQyc1JoNkxqY2VzdTZQbFJEbkxqRzZ3OVVyN3R0?=
 =?utf-8?B?aE5reDlCek1JMGJraVZNSkh6K3pScE5JLzQvUlFNNHJQNjdncnZhTkhJQ3Jk?=
 =?utf-8?B?YWVCc2YyV3FOTWJHUzNuVUdXd2JaNFFIM1AxUGhOWHZkTS9yRHBCc2tpL0Q2?=
 =?utf-8?B?NFZFSmRPdUtKVXI2ODBhMXNPVWlVTUJMdmpBMXE2K0xuTU54RkYrWGdkSFRD?=
 =?utf-8?B?N1R2cTFob0UvSHpzZ0JXUnFHOUJ3WDR1Y0x0dDc3L0VGOEMxQm1SWklaNElo?=
 =?utf-8?B?QUUyODB2Q3Rwb0szRWJ2YjQxTWtwZzJkWEYvUmhteXBuSFhVWktpSFhzY3JX?=
 =?utf-8?B?L3ROOG9GR25JblpxNStPZGJzaS9wN0Rwbkllc056UStkYUZBVERnMitJWXdy?=
 =?utf-8?B?TE9jTEtud2tqUytDT2Flbk40R05JRktDMG9PR3BGUGdJQjgrTFVzN0JWUXQ2?=
 =?utf-8?B?clZDbW1sZHFsM3JGV0pkT2VRVzFQSVBhSXZ5L1pYaDRsdVFnNUpsQmdHZXpV?=
 =?utf-8?B?bmxXbGpxWWhlaFFFREFvSzlDaU94by91YmFEdlNHUjB0Tnkvc3R5ZHhiRzFG?=
 =?utf-8?B?emJXMkU2Tlg3L0pXb1NIVUhOY1Vreno5Z2NFc2k0bW5ZMSs2Z0hURU1od1hK?=
 =?utf-8?Q?jcile+GRCXBAibVFFvBmfqYLiE9mQS2yUFT7ZdFGNkvm?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: affdadc7-eeac-4ef8-372b-08dad93c6f1e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 16:51:21.4362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRLtTpb2+2Wlfuy21OKbsH4MvD6tS9vkQ6nb8hYru4rIyp1HX289OPxz5ySz2FtLy0q1284tXcmX7Lu0uLn4wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7477
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08.12.22 16:44, Vincent MAILHOL wrote:
> On Thu. 8 Dec. 2022 at 20:04, Oliver Neukum <oneukum@suse.com> wrote:
>> On 08.12.22 10:00, Vincent MAILHOL wrote:
>>> On Mon. 5 Dec. 2022 at 17:39, Oliver Neukum <oneukum@suse.com> wrote:
>>>> On 03.12.22 14:31, Vincent Mailhol wrote:
>>
>> Good Morning!
> 
> Good night! (different time zone :))

Good evening!

> 
> How do you check that disconnect() has proceeded *to a given point*
> using intf without being racy? You can check if it has already
> completed once but not check how far it has proceeded, right?

You'd use intfdata, which is a pointer stored in intf.

But other than that the simplest way would be to use a mutex.


	Regards
		Oliver

