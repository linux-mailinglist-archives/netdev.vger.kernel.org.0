Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A2B65AF9C
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 11:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjABKeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 05:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbjABKeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 05:34:22 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2072.outbound.protection.outlook.com [40.107.22.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D98910F6;
        Mon,  2 Jan 2023 02:34:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc607d8uwrwXKef/LeH9o9YleCU3KnSjA3yzzwgHGVd0LOcZgrpEDjbfTYnZclm0F+qp09oKhelvHKOiJvl4CgPamURii6TN4dKE8mon8sYhzimvt/UVNn4cW81PMoi0KfqWoh0ZWakZYl5hsyqt2XThI1jPhnyRNuj7SraFTEjes2/6o+wFbHzhGlTbmzek6zS076qTuKI36BZFjz+L6hd2EZaVJ921bfihRkpxRi/PuTSx7slJIFpKsz2rZF3+XkJcM+cl2XyC6US8lHRwAtsaPTkOXZLfMQjMT96I4vKYtivJETxk1qyl+lAykLusXXek3+ALMejUmlPJOGCmDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Bzt9pNNCuOIBzznasd0I+5xVSYhIg+uPooxzFvIxaw=;
 b=SaJgcwQd6XChXfCeB9I7Q8cCmKcU5RZlLyddSYjaLv/wNeJqhY5R57dUkN7AefUGE5amC4Moe1KHOjEw9fAST2KrkMdh/AiYFSMDhHxvpnUXt2kwmWG2EJwDWeXyv67gfBJCXDLsQSdmtz3T1a61MMVlpnYuqG004NQcqFI1iwBnw2EepcwS1jJwLyQEtG4GFr5Ua2mLGBQkPMvQWIWea4ikYo7c3DCQ41mp9o6YP1BNuoT92st8yp0s3g6f++d3n1qG1oMSDME+UBy7Zfc55mS8v7KUWOC74O4kUsdEQxOKxVpVtk1fDpE165fAG4nuMandGtWs2g7sKquACHqJwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Bzt9pNNCuOIBzznasd0I+5xVSYhIg+uPooxzFvIxaw=;
 b=WaXJ/UTrIsuRap2+fvxE92ZlphQjChLmWnchrrtZ79fcVd/+y5OYqjhOH3TkADUpGNJOLnngAYSOTiNl83Mhmkbotgt+JBivUMXl4LzYqAXHk7qQR6jd7Dr0aBQ01VxthGbpOk1aw4bN3bZ4TZRelViMHLQTsQHSzIqd7NMUVVq4KrJb4RJ8HxFPImggmOwexmXXxSgdOvTid6DTrjCOInYSX7DzZIFh8pNmbopmmhwapVqVqs9i6WZKFc5Ogb0p9yocuC3YkS4HYcH73cwCPQhs7z80tqzM5AT/mEWJrhpExFpMNx1tYtvIJGnyJbRPGZ1zkqWg61H2IJbTX+yVSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3395.eurprd04.prod.outlook.com
 (2603:10a6:208:1a::16) by AS8PR04MB7525.eurprd04.prod.outlook.com
 (2603:10a6:20b:29b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 2 Jan
 2023 10:34:19 +0000
Received: from AM0PR0402MB3395.eurprd04.prod.outlook.com
 ([fe80::14eb:6506:8510:875f]) by AM0PR0402MB3395.eurprd04.prod.outlook.com
 ([fe80::14eb:6506:8510:875f%7]) with mapi id 15.20.5944.019; Mon, 2 Jan 2023
 10:34:19 +0000
Message-ID: <e939dbde-8905-fc98-5717-c555e05b708d@suse.com>
Date:   Mon, 2 Jan 2023 11:33:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Part of devices not initialized with mlx4
To:     Leon Romanovsky <leon@kernel.org>
Cc:     tariqt@nvidia.com, yishaih@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <0a361ac2-c6bd-2b18-4841-b1b991f0635e@suse.com>
 <Y57jE03Rmr7wphlj@unreal>
Content-Language: en-US
From:   Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <Y57jE03Rmr7wphlj@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0188.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::20) To AM0PR0402MB3395.eurprd04.prod.outlook.com
 (2603:10a6:208:1a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3395:EE_|AS8PR04MB7525:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a50a057-6c73-44b6-2048-08daecaccf7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IHN1WIaomgA07agH7+6XyNMAyfe/AmhuInULcuZ92G9MQZu/kQq2YeULlShOKCzRoaQdIZ76nD8eaVqXNPBWTuG+8S7+rRMFg12qSpLQgiL8XXEvy+Juao69MzslbIu/Q57sGHqow0gp7WhnlAi8lDV3mOumRzVAo7/bpBWd0x/YF9aIyw6E96qj3cOj51+EDDn0hijYZFEJ3mMGjFuVrdYKhwFvkAy4mG3rKKihqxIrsnZci2kI0ADXTrvtefvZvNWjKDCuwWjrOkvfU/dPhxD/UyyQht+tdfwP9TRcPW+02osxoLRCi1S0M4edrQ5vzB95Ur0b94Ijn4zP6sfaibKQH9hn0IYROE/zLwDn4oio+JGDAWRRYKdQld3hXEXg4NszpitgbVykHv5Nlw+pZBB8qJ3t6HFcyI49nKA+V8qfNJXQxiBUSqwWiX6uPy044jb48SvrI2tb7OGDHsdid5uQgj7wuM46b2bNrIhuXkMeqyQsB/6y2UVgWORFMjnGu7GfFamZa4vLcLKArpfoC6dnPMiaGZXV/GcZgI1Xf4oSBuxgRgepmtdySo6U2ZPrnqIzwGipoeOwZDu8IvlU/c+aizcp1LKbko2RrM3TwKaJhRhESs77+tfnlAbxgJI9DAWB0CKnKYYkjAymtPwwZarkcKxj2gqPn31jmIO7n2dxWtsHQ6x+q0hGNaTAgWGCsqQH2F+wVv5BdhbwSTV++kYcijDOEu4aESGpY0fkj5XEF1iDDikU4WeU6DuCtHkwIjZ0GOvtLT12mtz2Od1EhOChccGThHIl1RYRvemBu/Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3395.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199015)(31686004)(36756003)(31696002)(86362001)(41300700001)(4326008)(6916009)(66476007)(66556008)(8676002)(66946007)(38100700002)(6506007)(6486002)(966005)(186003)(26005)(53546011)(55236004)(478600001)(6512007)(6666004)(2906002)(8936002)(5660300002)(316002)(83380400001)(44832011)(2616005)(22166006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFBnSytGWWtlQmxWZVU2N0wyaXlueU9rQ2V5Z21HSXc3cVl6RFcyZGo1THpJ?=
 =?utf-8?B?Vkp2aXREM2JZNkdOQzY5VHpSSm1VZjFvbk1jYjZ1ajdWWG9vRkdtdlNOeTdN?=
 =?utf-8?B?NXQ2YURBK3dpMENGeGhWa1poenpDWG1YTEFyQWlmeWZqZ29oc2RzRjJrbDR1?=
 =?utf-8?B?eE4yOVM1Y25xS3A1SGxoYnF6UTBQRVV1K0tVT1JKZkRJVU1HVlRadXNDY3hv?=
 =?utf-8?B?czNuRFpibFNiMEVROThKcWk0OEJxUWNaeFhLTzRzKzdFVHEyQ1I4RjFvMGQ0?=
 =?utf-8?B?T2szeHhhaDRlM3pCcVJwNHBlNzIrdU9EYk51UkRSd0NDSENSN2VQV3ltWTA4?=
 =?utf-8?B?UDM5Zm9HbGQrQUNYa2w0K29YaGRHb1BaeUc1dUFiZ3d5d0NCZHVCREJacXhV?=
 =?utf-8?B?dE80Y3o2S2ZWR21xdTZTMTc0bjNZZEVhUFExNXR1TGlhSzNzQjhUWTVrZUY5?=
 =?utf-8?B?amcvN2VkNndnSkwyZS9FRFVYWlZhWGl0ZFJxU3F6L3AwWDNVZ2U3blpOb1Zy?=
 =?utf-8?B?cVpkMHlDUHZDaXdiQWpZOXFYUDRaQzlUQXBPeWc1bTBXYWdDUzYyVkRhQXkv?=
 =?utf-8?B?S1pJb1hQVDYwVkZ4S2dtOXN0MzcxbUh5WlM2TGhnbFhpamNmRFBRcklmN3pV?=
 =?utf-8?B?SE9YZ3liUm5oRDN5TEVtVUtkelRrZVpjVjJkYmx4QkVWUmtKeGZvT1Y1Qmph?=
 =?utf-8?B?cnY1K2wyOFlvdVNGQVQwN0plZ1creHArWURlT3ozNFF3ZnZrVi81Q0dZMDdv?=
 =?utf-8?B?SmgxMWUzczdQeDZ0RGpNSmVqdkx4ZTJuS0NsNkpvRUtRdEhLdnB6Q29QdzBN?=
 =?utf-8?B?RUVkc1IrRW45MU0rWDBZdDY0a0xLVW1BL0VJUDRERUR0S2g1V2Jub1FEZ1Yx?=
 =?utf-8?B?SDBtblJzZXV6RElKRmMyRmhkVG5QS0xjc1Y0azQ0L0M2MUtydmQyODE2bUlu?=
 =?utf-8?B?OVZuYUZGd1R5bE50QWFXckxXU2p4NVhTcmNWWmI5RTZ4clNxWXJ1eTB5ejV0?=
 =?utf-8?B?MHZSRDQrTUJ4b3dJbUthMzUyZ1d3V2Naa044UnNXTzcrRlM0VWlVdzVVMXMz?=
 =?utf-8?B?VHpwU2QyMnQzVEdCbEhENWRhOTR2d0tpR0tHdDhVSFJCSUZUbVVyaEc4RUlR?=
 =?utf-8?B?NkN6SkZ3dkZldGM4QjFpY3BqL1ozbUh6U2EzL09tanlaYm9aNFg1MnNVTUw3?=
 =?utf-8?B?Rm1JTzFPYVE3dHdRUkN5SWRidjRUK3lyVkUvYXhROXJYNFN3bDNXR1ZFazhj?=
 =?utf-8?B?V2pQRDdqelBNRXc5MlFXYk5xMi9KcmFNdDB5WC9ndEJUMmVQb0I2VGczNmlV?=
 =?utf-8?B?SDBUTGZPaVBZbEFJc3Z4ZldJRzdvNW1wVHRvTWZIZ0tKQjVVUWR2RHRjNm13?=
 =?utf-8?B?QVNKREVYZ3A2SGtxVHNPZkpMTkNJeUdKN29YWERZbkhCWHcxUlNSNkFhblpH?=
 =?utf-8?B?bXFFTXdSTEk3UUVMcVNZZFR1blpld1VMcTg4OXc1VzRwVGZRVVBIOWIzZU1r?=
 =?utf-8?B?MDBjdjRaZW5QQkk0VnBmMzVVdUhnVFVSaGlpcFJERkJYMDRJSmxlajJJZU9T?=
 =?utf-8?B?dW93bWR6NEhnNS9UWXVPZmFEMlpYMjEvVWhDYndiVWZPRTI1UVF1c3Y3U3ZZ?=
 =?utf-8?B?ZUJHU09VUUdUNzZ6a3NYMUNWWXhTUkxkTk1DNCtPVnVuVkJqVFV3YmhSZXhI?=
 =?utf-8?B?U0NXdVAySFA0OXpwbmVFTzgzeFV4TkpQUGtRQURnYVE2UjdIR3BTL3BKN2d6?=
 =?utf-8?B?TnBUUFlYY2o4SDNaSjVNQThXRXJDRkFtMmZMR2VoY0tFUWJlK0czWDgxMnJy?=
 =?utf-8?B?RVoxdUh2eVEwRWdVR211V1U2aDRreGZ6bC9BVTZ6L2VxUFluWXB5YlJINndj?=
 =?utf-8?B?blpzOTE4UXFwQWpKV2JrWEdkMmFSR3hEaEZkV3dLVzh6NmxRSHhCV294dUlN?=
 =?utf-8?B?QnRkenNkVjdNd1FCUVlnUWN0dC9WVkR6R3JlQlhaWklhbWU0dXNnQ29UbHpK?=
 =?utf-8?B?RFhYWTlqVVIwQ0RKWjRNNUJONUlYZ252QzNXMGxRdDFZZW03L1pwUFlvTFlV?=
 =?utf-8?B?SG0wTmFWUVBtbU0xSTJyalpFcTNwdzZENkdJZ1BXZERiaGV2ZkVCZmRycGpQ?=
 =?utf-8?Q?ABXwSyfgbAAzYaJCyu3uOxDFG?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a50a057-6c73-44b6-2048-08daecaccf7c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3395.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2023 10:34:19.5553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J4lfbIbx1vB+gsFEdJxEIkmluAvaZLjRhnzhDE6hGGIwZXwtv3gOKREJ3OYdIV2R2sEXur0iYUbxEMmkLp0bZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7525
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/22 10:53, Leon Romanovsky wrote:
> On Thu, Dec 15, 2022 at 10:51:15AM +0100, Petr Pavlu wrote:
>> Hello,
>>
>> We have seen an issue when some of ConnectX-3 devices are not initialized
>> when mlx4 drivers are a part of initrd.
> 
> <...>
> 
>> * Systemd stops running services and then sends SIGTERM to "unmanaged" tasks
>>   on the system to terminate them too. This includes the modprobe task.
>> * Initialization of mlx4_en is interrupted in the middle of its init function.
> 
> And why do you think that this systemd behaviour is correct one?

My view is that this is an issue between the kernel and initrd/systemd.
Switching the root is a delicate operation and both parts need to carefully
cooperate for it to work correctly.

I think it is generally sensible that systemd tries to terminate any remaining
processes started from the initrd. They would have troubles when the root is
switched under their hands anyway, unless they are specifically prepared for
it. Systemd only skips terminating kthreads and allows to exclude root storage
daemons. A modprobe helper could be excluded from being terminated too but the
problem with the root switch remains.

It looks to me that a good approach is to complete all running module loads
before switching the root and continue with any further loads after the
operation is done. Leaving module loads to udevd assures this, hence the idea
to use an auxiliary bus.

>>   The module remains inserted but only some eth devices are initialized and
>>   operational.
> 
> <...>
> 
>> One idea how to address this issue is to model the mlx4 drivers using an
>> auxiliary bus, similar to how the same conversion was already done in mlx5.
>> This leaves all module loads to udevd which better integrates with the systemd
>> processing and a load of mlx4_en doesn't get interrupted.
>>
>> My incomplete patches implementing this idea are available at:
>> https://github.com/petrpavlu/linux/commits/bsc1187236-wip-v1
>>
>> The rework turned out to be not exactly straightforward and would need more
>> effort.
> 
> Right, I didn't see any ROI of converting mlx4 to aux bus.

I see, but in case you and other maintainers are not immediately opposed to
this conversion idea, I could try to resolve remaining problems in my port and
see how it turns out?

>> I realize mlx4 is only used for ConnectX-3 and older hardware. I wonder then
>> if this kind of rework would be suitable and something to proceed with, or if
>> some simpler idea how to address the described issue would be better and
>> preferread.
> 
> Will it help if you move mlx4_en to rootfs?

Yes, if mlx4 drivers are not in the initrd but only on the rootfs then this
issue is not present. A problem is that VM image templates have their initrd
typically generated as no-hostonly and so include all drivers. Some images
might also require that networking is already available in the initrd for
instance initialization and so must include these drivers.

Thanks,
Petr
