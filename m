Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19344646DB7
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiLHLAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiLHLAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:00:08 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2057.outbound.protection.outlook.com [40.107.20.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721871FC;
        Thu,  8 Dec 2022 02:55:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQWHK5F0iB/1ye0CdVdc1Sux5yiZ/adpXtQ4flw44J1SzLeGUk4DXWTJrROlNkgs+vfNWuAGuFNQZ3zxjMEk4dMu6tnXL7dWcL1SfYgtlAAPQwZ1oip1piRUQ0S3BNK9/D0WsUtwA/RJNwJHWILL/JfNXpDGrFvYgqTv7pK912mV3r9QNDRivRv0rQJ6vwhLREFcrtRqFgwnTi/UGT9HAWiJFZJLuF/gmn0P+C3bLluyZ4VrGXowzJq0tvhfwFLR8P29pbNYLaSgHCP+L9XPaZa6E2jjXU7on+xk5vFHUlhnSIEmUe64Zjw5XFY4Gj6hIj/p2cNwnqIN56Rhjw6juA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/mv4IaMXr6dQkXmBIbeJ5m8c1reEsbl81rCdHwCeW4=;
 b=Nn3dCOY1CS6KifHnU1XGm6OcLmQHpR5E6kyiWVYw/rWNK0LbMFu/3nZX7HXLpw7BocHoMTTeOFCjzdAjMArTZ1aFoVECU7Nal4gBrlJyN6ZofbaX3j3wd1I/5wtX/BgbnjJXCJgQa1dwWe3UBWHDov/2XWNFYxvA7di5ZDgi71wawMpy1qs4GcgxppTcq+dVsyeMfm1haqGpJ1Y3kjdRbXqgNkgP5mJo1yaqXvJuP2qOV+BNINPxxCt/X/2HvPT6MBgPM7xe81T+uh8gIn7QcOuGWOAbv5sqW9+z8G7GHuNj0cGUfkdzqfojJ8gJLRQY5Zl5yzPWAkrzVMuS7T+ETw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/mv4IaMXr6dQkXmBIbeJ5m8c1reEsbl81rCdHwCeW4=;
 b=4i2N6tqDhWWg7HZ/2WkoRiafn3XbCDibojzKXxunJiAJ7kDgNbo7dKJyZwhZREGHYB7f24++hJ6Um5C8PtGier+ch/BlIlvLW76Kbpkn7FT4/rdiXPPirtTH9pcxMcaEPzKBQTT46bR7Saj1mdYgni47kZYRieZhG39xSqx1eMGKYGJeDPB6ezJi6OmsExbUB8uCnZzwAmg6NN279eIUg7TFIw1/r3Y8W0OavQl00oA9KmTHqgBgyuyswYyJVyKKyiTFqtrYp6SZ6IJffjUhpg0/wbhTNXOSconB/SPabAakkJVrnEgT2KQ1pUY1+AQAn1ucTOTsWGmkUt69fh93yg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9)
 by DU0PR04MB9694.eurprd04.prod.outlook.com (2603:10a6:10:312::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 10:55:10 +0000
Received: from VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::ae59:a542:9cbc:5b3]) by VI1PR04MB7104.eurprd04.prod.outlook.com
 ([fe80::ae59:a542:9cbc:5b3%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 10:55:10 +0000
Message-ID: <b5df2262-7a4f-0dcf-6460-793dad02401d@suse.com>
Date:   Thu, 8 Dec 2022 11:55:06 +0100
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
        Philipp Tomsich <philipp.tomsich@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
 <9493232b-c8fa-5612-fb13-fccf58b01942@suse.com>
 <CAMZ6RqJejJCOUk+MSvxjw9Us0gYhTuoOB4MUTk9jji6Bk=ix3A@mail.gmail.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <CAMZ6RqJejJCOUk+MSvxjw9Us0gYhTuoOB4MUTk9jji6Bk=ix3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::7) To VI1PR04MB7104.eurprd04.prod.outlook.com
 (2603:10a6:800:126::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_|DU0PR04MB9694:EE_
X-MS-Office365-Filtering-Correlation-Id: f4f6b313-4130-4abf-f85e-08dad90aacce
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q7hAgTgauZqEMSxceVNp+wQSCvy1CEPs1mQjw4n3HLi6nnavemjOPsHd4N/hqJc4OoXOPThwbC5Cd3ju2Vxxh9+bNMpvNhDRmv6MfVhQS5ZSfX05JdXrgc+o6zDN0SAXv/EkNOeymgtf64+t19tolcjQhOcI0n0AWVMDZqsh10wwqfwEzW0wfoOM5LVjJ9u5oOretHQOQr4WV4ylFQ0hNLueTmuC+6WY+j0NBfgccFv/I9HxbIWNe9vfbXOwCtfmTmz8Py4MVfnP6bSLJnlLxEkEmi7vrBuWv8f+mJkw4s8EVlNg1DL7/ZAIyDLIwBVT54N45hLIjV5syvPQaCTh7lrFvK8qydYhZ1WgJVzUIyJL95usoCUBQ0uGU4fnTNr02XIh1m9pVH4tsiUUshhQQiaFg/ckinrdHq/ipifYGoFNeRxNPYvuM/JCvjS0qg34gHhVYdUQwp7ipW0OvoLNoSQOJCkg/a0o4AwwfHlhAwHSgC+Fa7Z4ud8WSxFF6+vN/WfKBk/a2FfAgzVDTdKp1a5SF9eXEuQGccKVqDVHUZfVQtfa8+7OroPi06kYrirMFPF1F4tZ8gtFDhCRKOvMUF77Lm23Q3tfRBl3cbMR7ol5wwJtuU/qv9TYJ6nJRb0gmhFeHIKznzzvvKyVTXmctU6/a4I0RiTfNoEKuOJPfIYT2LVYz4cJBnspzeQJCwW+pPVRhuRov7aGKMTx9Zt11soP2hdV8geNSQ4jmXknB+gvHDjwWhSP7loNb4x3x4Qz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB7104.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199015)(6512007)(8676002)(478600001)(2906002)(38100700002)(36756003)(2616005)(66946007)(6486002)(53546011)(6666004)(66556008)(66476007)(966005)(5660300002)(6506007)(110136005)(4326008)(31686004)(54906003)(83380400001)(41300700001)(8936002)(31696002)(7416002)(186003)(86362001)(316002)(7406005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUtOQ2hnNUNEakM3NzNLb1ZHaTI1ai80U3g1aGpyTlpjbHBZdG55VGJuK3hw?=
 =?utf-8?B?Z3hPYkNTR0hwYUdTQnBIS2FkRG5mRHNRNDZNMmFRWDI3ZXpOTkxvaGwvNWRW?=
 =?utf-8?B?SlJJN0F4WWg3UWo5VU1uY1BYMW83d1pZY2M2cTJ0MW9taTUrVk1VTHY2RXpF?=
 =?utf-8?B?WTY0dmtSVGNaWnNLMUxwUkh5MHZnNDc0WGZDMVkxRkI0azhmTkNGRjh1bXdB?=
 =?utf-8?B?ZTFqenlFaWgzYmNXRDFLNzh5N09aMTRhTFRldHZTVG0zUEVLV2N3ME1vMDlG?=
 =?utf-8?B?bTh2M3lTWW11NDNmajZvR2ZnZ3A4QVhYejlBeFdvWjBRYnZqdlNEcGxvOUZw?=
 =?utf-8?B?V2s1NGpCZTVDcW9qQWtnM1hsN1RCN1BYbEtjU2QySDh1SU5SNUE2MCt5WTJY?=
 =?utf-8?B?OE5NVjF5V253Rk13STk3V2duZ1V3V2Ercit2WUJCbEp0OXZDQ2hscHhRbERy?=
 =?utf-8?B?RU1JdjFPY2NKaXNNMmZ4QVdmV1hDZlR0NW9rNkVhL09hZWhFc3N0WHhEbnE2?=
 =?utf-8?B?TTdwL1p1VVNobXhqTCt0MXhSNTNXaFhFNDNlM01qOG0raEN3Wnk0bjZJU3di?=
 =?utf-8?B?NVNJY00xMTd5c2xpZHcycG8rUmRNT3BFUHlUbjNzUHNSd2ExSDRmSlJTQURq?=
 =?utf-8?B?MlhRWWZ4S3NJN2g1NEN5SUhaUU10L1FtSVlmbjI3L0JmSm1YaEFkUGsraVR1?=
 =?utf-8?B?S2lsaE9haGtKRllQT0NPZ3lsUzJzaU1kNGtWN3psdGdtUkllK3dxUExBNmVO?=
 =?utf-8?B?TkhZQ3pHMGxKMTRuSVpBeVVsOU9CSUdrYVNRbW9Wbmk4OVc3N1ppNUFuc1Rp?=
 =?utf-8?B?YnBJUVp6bUcyUzFSdEl0K2luQ3c3MUE1eFVScHFrM0Z0WEo4YnJ3QXpNeTdP?=
 =?utf-8?B?MldYaDZ3aWJZYndHSGZPamFOQ2NrS3gxTDFJRVEwNWdBazVWVk95NE41ODFQ?=
 =?utf-8?B?Rkk1ZzZOYllSMmg0ZjBVRGlQL2pjRWViNnlvYzVnU3g1NklIWW01Z1FMWk1P?=
 =?utf-8?B?anozMWIyL1k0clFHcTRqblcrV2pFYnhmVytHM0orb3cwY2x4azVjRktpMkxr?=
 =?utf-8?B?TzFDT2pLVWM2aG5EU3JpbFZLRnVzRTZWdTVDalREOTc1RkxqMmRJUkErUURL?=
 =?utf-8?B?Mng0NWU4WWFodWZ2NlVGZVRTQ3lCT0FVcTBvS08vZitITU9HcWY5L0xra01v?=
 =?utf-8?B?bkNuQ1JraEdKZjZxdTNlQVJVQm5WQnVLMjVGSzdCOUVQUEpkNGVJc2x0enE5?=
 =?utf-8?B?OVBWa1kwcXA2L2xJSFRVQlhoRjNuVWIzRC9FaDBvZGRBRlgwOEVpMHlTaDUx?=
 =?utf-8?B?WWlEWVBaZmt4NjhROFVvUTNiMkdqMk1OUXBkdjdpazBlaEt0UzhqcGgwWnVV?=
 =?utf-8?B?VWlFZi81K0lQb3hQVE1wMmdseTZkT0tSbURHc0tJS0hZZlU5MnFqRU95LzRU?=
 =?utf-8?B?aW9aVXIzT0tYY2ZoSVVmU3ZDOFo5bWdsYjlUbTAxUkt4anY2djBrbkZESVNy?=
 =?utf-8?B?djAzaHRQdmxvOW56YSswVlk0SlNQakpZUHpuZGZQZzZtTm9YRDRJTW1jSFV5?=
 =?utf-8?B?WXNlbU01U2JhRE5IQ01DNEVCZndiM25OM1puYzJKOVBDUU5qa3FBb2tTNEpQ?=
 =?utf-8?B?bDdXVkxqTVluRjZuMHB0OXZHbkNwUG1mL1A4dG16eVpOSVVkQnp3TFZTaHM1?=
 =?utf-8?B?QlZINHR2MDZWOHZxNUJLUW8wWVRnRUJkUjRoaHhhV0dTUkMwUTNTOUVXNHpG?=
 =?utf-8?B?VkhuVUFjY09HZzlWZFlRM2lFSGZuZTlwU2lLYktndUM1Sk53YkxORUkzS3F2?=
 =?utf-8?B?bmpNZU5IVmhRMkNzYitJbEZFVjErY0cxQ29LK1Q3WXlUMjlsSnRnaU43MTlZ?=
 =?utf-8?B?cllzZEEvMnVUcEdyYUNaZXNmaFdIRFh0MytNQ0E2TnZ2emFnWmI4UmJRanEr?=
 =?utf-8?B?d0VoZkFHYzZnd25OeWt3MGhHa3FxOHVCc2lRdjU3OXp2QnNZQUJKMnB4elE3?=
 =?utf-8?B?WGhsTkxPcVhFMGNkS2NRWTQzRWt0dkV6RUhHK3ZHcS9uSVk1Wm9XOWFrUHFD?=
 =?utf-8?B?cHBPRVlBdUUrYmhvczBlSmNpNXdlYStFeXE1NU5NQ3FtUS82OTBlOGxXaHlI?=
 =?utf-8?B?b3J0MEpIWGQ2Y0VLQU5obVVaZW9DWEhDMGYzUkRSY0Npcng2UW0zZ1V1WXZQ?=
 =?utf-8?Q?Fut/kTmJchrtbBe8Yo2dQVvKKDcj4BGpdFP4+IUekMpb?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f6b313-4130-4abf-f85e-08dad90aacce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB7104.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 10:55:10.1303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Zlk22MJJjS69b2U5rY9YTA8jGvHMyvdm8bWk4tsxgTSD+z599ZgVP8SKixzqcAt2wlkk08mi3uOGDJNycPT4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9694
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08.12.22 10:00, Vincent MAILHOL wrote:
> On Mon. 5 Dec. 2022 at 17:39, Oliver Neukum <oneukum@suse.com> wrote:
>> On 03.12.22 14:31, Vincent Mailhol wrote:

Good Morning!

> ACK, but I do not see the connection.
Well, useless checks are bad. In particular, we should always
make it clear whether a pointer may or may not be NULL.
That is, I have no problem with what you were trying to do
with your patch set. It is a good idea and possibly slightly
overdue. The problem is the method.

> I can see that cdc-acm sets acm->control and acm->data to NULL in his
> disconnect(), but it doesn't set its own usb_interface to NULL.

You don't have to, but you can. I was explaining the two patterns for doing so.

>> which claim secondary interfaces disconnect() will be called a second time
>> for.
> 
> Are you saying that the disconnect() of those CAN USB drivers is being
> called twice? I do not see this in the source code. The only caller of
> usb_driver::disconnect() I can see is:
> 
>    https://elixir.bootlin.com/linux/v6.0/source/drivers/usb/core/driver.c#L458

If they use usb_claim_interface(), yes it is called twice. Once per
interface. That is in the case of ACM once for the originally probed
interface and a second time for the claimed interface.
But not necessarily in that order, as you can be kicked off an interface
via sysfs. Yet you need to cease operations as soon as you are disconnected
from any interface. That is annoying because it means you cannot use a
refcount. From that stems the widespread use of intfdata as a flag.

>> In addition, a driver can use setting intfdata to NULL as a flag
>> for disconnect() having proceeded to a point where certain things
>> can no longer be safely done.
> 
> Any reference that a driver can do that? This pattern seems racy.

Technically that is exactly what drivers that use usb_claim_interface()
do. You free everything at the first call and use intfdata as a flag
to prevent a double free.
The race is prevented by usbcore locking, which guarantees that probe()
and disconnect() have mutual exclusion.
If you use intfdata in sysfs, yes additional locking is needed.

> What makes you assume that I didn't check this in the first place? Or
> do you see something I missed?

That you did not put it into the changelogs.
That reads like the drivers are doing something obsolete or stupid.
They do not. They copied something that is necessary only under
some circumstances.

And that you did not remove the checks.

>> which is likely, then please also remove checks like this:
>>
>>          struct ems_usb *dev = usb_get_intfdata(intf);
>>
>>          usb_set_intfdata(intf, NULL);
>>
>>          if (dev) {

Here. If you have a driver that uses usb_claim_interface().
You need this check or you unregister an already unregistered
netdev.

The way this disconnect() method is coded is extremely defensive.
Most drivers do not need this check. But it is never
wrong in the strict sense.

Hence doing a mass removal with a change log that does
not say that this driver is using only a single interface
hence the check can be dropped to reduce code size
is not good.

	Regards
		Oliver
