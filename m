Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4E22C639C
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 12:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgK0LKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 06:10:00 -0500
Received: from mail-eopbgr140093.outbound.protection.outlook.com ([40.107.14.93]:8933
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725616AbgK0LJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 06:09:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6YYngwbCSp4jYyri/xxUKyAJjmgHNDfE07AHPEQYF4s6liwbnIjcF7Xl12apMBZuwGqjrCg2KY8SAumf5dIRaUif+gM3bXLj9KF7p1w07w6jumPklA0z8SxLO+H8w5j4BjWJJyn/uskr+aduE7+2KWuVZ/ZDgQaQHDVphfsKNARhyTGWVt06OBZK2UhCaUVm8Lx3l5VloXVgYzvirapMouqL3P97Re00jVbZbc8n3FpuY6CZJzLDgF72Te87NM2HSRZrWTWvXOBeU06Ydwy1jHROFCXwyp6BVGnnRosAV5MVvzIu/fwNaKdarN928ed8XTRq+eKhST4YSrwYYT+yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXGeRBcgw7GvXwmobby6IW97iuOSSZtIYDiOsulzLRM=;
 b=BeBgue7RuzpMthpBs5EMk4DPpnERa7mKm/hmPBIYuVnJD3lvr6fr9NZNZIQEIauaGrLpQPshAOolIbD35wGEwX0GZUcGzGTGbTZZ68qdShrZNzFgQemIMDpA5cYYLmznjjsh8i3d6+QrxxlcZ9z+254FXlE4iFZTRxiPZ+Hm7C0trDklWgDPlh8nYlLFShsxjDvcCrHB9rU4anCQ0RM1Ej5R6rgnX4ZLQkvVFd+boMlFWUYCQAviu7eFaw9WSbdLr8A6mCjiAOOviBD/Jii4cIrgplVLYHVco9CAEYbPM+COG9FFTggSgBJWrRJ9kvkUXtk0brDTFPTj6Xtj030a7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXGeRBcgw7GvXwmobby6IW97iuOSSZtIYDiOsulzLRM=;
 b=ngX63rJDEPx1YA3TuENQ6bk57LuBYwsW+2f3lwW1LfDDOtsfaLq56n1jYUONRHS5EhYuTiHqWLaHgW2Z1ugPOF1XOxUai5FaEuAn2/h/fFPUOCnhsyDqcrqqoJKRN5+Ns1mUjsCOevVeJk2lS61vME/wAP6ApZCbxurrIqsY6Vg=
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=victronenergy.com;
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com (2603:10a6:10:192::11)
 by DBAPR07MB6583.eurprd07.prod.outlook.com (2603:10a6:10:184::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.9; Fri, 27 Nov
 2020 11:09:56 +0000
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c]) by DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c%3]) with mapi id 15.20.3632.009; Fri, 27 Nov 2020
 11:09:56 +0000
Subject: Re: [PATCH] can: don't count arbitration lose as an error
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>
References: <20201127095941.21609-1-jhofstee@victronenergy.com>
 <434167b4-c2df-02bf-8a9c-2d4716c5435f@pengutronix.de>
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
Message-ID: <f5f93e72-c55f-cfd3-a686-3454e42c4371@victronenergy.com>
Date:   Fri, 27 Nov 2020 12:09:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <434167b4-c2df-02bf-8a9c-2d4716c5435f@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2001:1c01:3bc5:4e00:e791:efe6:bf00:7133]
X-ClientProxiedBy: AM4PR0302CA0004.eurprd03.prod.outlook.com
 (2603:10a6:205:2::17) To DBAPR07MB6967.eurprd07.prod.outlook.com
 (2603:10a6:10:192::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2001:1c01:3bc5:4e00:e791:efe6:bf00:7133] (2001:1c01:3bc5:4e00:e791:efe6:bf00:7133) by AM4PR0302CA0004.eurprd03.prod.outlook.com (2603:10a6:205:2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Fri, 27 Nov 2020 11:09:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3aabbc4f-87a5-4bee-97ad-08d892c4f8c1
X-MS-TrafficTypeDiagnostic: DBAPR07MB6583:
X-Microsoft-Antispam-PRVS: <DBAPR07MB6583616352EFD4FC0E4ED103C0F80@DBAPR07MB6583.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ytndjLFrqAXkud6qRT0DImvbk3UiihcjuwB1AdJe3dmaLakLfaWBAKsJNxjIsvFo0C6pInSVsUQfqhdVYoqUMW1fy2Na6qNQgV+yJxiS274BWGvOsJ/CDy4FpYMRE8lK/xEW+AMCRz3V9b7EXad9eqvRAbKGACRj1uI+wy4OTV3NorFHRP0niPS8L8DIfi2w5GpEJdh5SPsFUfZQx3LPioL/PepXTuAKAnC0LDSdtaS4vRazwi9lCg46bKxmzrDyqmJC7fsGn1o4b0auyt0DSrvFnaahEcaXFJ08JQtaF+kJxRgNQcnteXrtVqS4TYuxe04IsNAE2Mz3a2um1lBc7nGASe3bAQrSw7P8CN5KmqlWu/feXaeu9uagMWPEnOqJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR07MB6967.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39850400004)(136003)(5660300002)(8936002)(53546011)(52116002)(4326008)(66556008)(478600001)(86362001)(8676002)(2616005)(316002)(66946007)(83380400001)(186003)(31686004)(66476007)(16526019)(31696002)(2906002)(36756003)(6486002)(54906003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Tjh2NFU2SXYrdHZoYU4vOHZLUE5FNWVvaWdFV1ZYdU5ZRFVWN3hTYjhRMXJU?=
 =?utf-8?B?ZVJYWGRsOU1hUjQvdTRuQjNvY1l1UElLSHI0cHZEM051M1NTODdWRGkwNFBt?=
 =?utf-8?B?aEhvRmxodFJVVm54M0hqeCt3STE4cDNVdnlVVkFTcVNaVjVmb3JTRVRkcnNZ?=
 =?utf-8?B?UmoycHBuU2dHM1phNEd3ejRwQTBhWFMyZ3lsL0NGY2xndFJmdFU5eWt6WHhE?=
 =?utf-8?B?dGJxZGFnWllOcjU5WWZEbmRWZWd0alU1TGl2RVYyOWplTk9FVjVjdVBUUzZM?=
 =?utf-8?B?TE5NRUtuaFMxU0hEbEdDYW9NZHo2L24zaEVHcU9hVmQwVlIzT2pwZ1lJdTM2?=
 =?utf-8?B?N1EvUkgza0tiRzFPK1V3V1ArcjFxbVlTcG1Md1EyQjVKdkVLZ2t6VzVLM25q?=
 =?utf-8?B?dnQrUTVMVWlic0NJQ3NpaGdXaTh6YVp1ZXd2TXgwUDgvUnJtc3JUZFo1Z0ky?=
 =?utf-8?B?a3gza0N2bGxrOU5DZFNlM2FwdlZyR2gvOXhTTWNZbVhBUi9YNWFNZUt6R2th?=
 =?utf-8?B?NUtrWUpFeUtGQUlURGpSNkJyNTNpNGNQYW9EVnVlQTJoTmI1WWtDUHJOL2ZM?=
 =?utf-8?B?b1cyN3NlTlhZSm1NYXdHLzVXdVNYV2UxMnpnM3I2NWw0ZUNpWDNyWUN1SHFY?=
 =?utf-8?B?ankxc0dXVkRVK2FySFJ5ODg4Mzc5YlloK1dOSUhnWXVmQkhlTndONHJESmhP?=
 =?utf-8?B?amY3RG9FRjNlWXRRRklHN0l4dmJhQ1N6M2tCWno0dkI1L050cWdsdDk4TGZi?=
 =?utf-8?B?Myt5eUNSam9jM096amM1bHplK09OOElvOE5YVXJHNVVGZy9Ya3hBanE1RXdM?=
 =?utf-8?B?bVFhR0FSUGQ1SDdIZGJsZXpHakhQQWJlN3BMaDhKNUc0Y05wQ29xUXZ4Y0w4?=
 =?utf-8?B?b1hPRHZtbkppS05YT2FwWFZXWS8zVDd5ZGxGRUJWK0grcTVpWTVSQWhyYU1U?=
 =?utf-8?B?K0JoK1VVS3Y4WGphTXJFbnhzSUpyNEhXZUdhejdnclNGei8rb2dXN1hIRmFX?=
 =?utf-8?B?bXA1ZXdjQlNuaEJXSjZnQ25UNlVYNCtNNStQSFBzZC9aNGtPVFNqWGVDZjRL?=
 =?utf-8?B?K3NMMndETkVFaDViQTRhNXliRWtBNlJLQUt5KzhFMXVLeTFrNFRCeFlpejhk?=
 =?utf-8?B?Z1F0d0tWUGJSQVNveC8yVkJjd0VQNjBjK0NTdm05TU9ySGNmcjlOT2QwWGJB?=
 =?utf-8?B?YXg5SmpHb1VCam5DYlNMMVFlVEdVY0l1VlEzaVVOM0FSTUpqSFN4SmZXSVhs?=
 =?utf-8?B?ZzFubFRPSVRZVEF1KzExNUZOa3RGY1ZRbitTempaR29ibmFDWkNvSXN6SjZJ?=
 =?utf-8?B?L2VXZ2lBcjdMMnZweVhUWXhlT3piZnI3SGlUQ0FlWGQ0UjZyME9OOGVwM1FL?=
 =?utf-8?B?VEVwVi9XN3RtVkc0SW5Objk3QUNPLzFtTnlSeW0xYzF0Q0RncFFjSzZOODhF?=
 =?utf-8?Q?5/oXNBja?=
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aabbc4f-87a5-4bee-97ad-08d892c4f8c1
X-MS-Exchange-CrossTenant-AuthSource: DBAPR07MB6967.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 11:09:55.9528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wotaMTJoSUBI88QEuJ4EJiIP4HoPVCuj7eei3V8fuxycnbaipwFzomsr9msHc45LMNzG3RtlSPPYxOrJvvALhRoMntDFLyJL4haNqK8ilK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR07MB6583
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/27/20 11:30 AM, Marc Kleine-Budde wrote:
> On 11/27/20 10:59 AM, Jeroen Hofstee wrote:
>> Losing arbitration is normal in a CAN-bus network, it means that a
>> higher priority frame is being send and the pending message will be
>> retried later. Hence most driver only increment arbitration_lost, but
>> the sja1000 and sun4i driver also incremeant tx_error, causing errors
>> to be reported on a normal functioning CAN-bus. So stop counting them
>> as errors.
> Sounds plausible.
>
>> For completeness, the Kvaser USB hybra also increments the tx_error
>> on arbitration lose, but it does so in single shot. Since in that
>> case the message is not retried, that behaviour is kept.
> You mean only in one shot mode?

Yes, well at least the function is called kvaser_usb_hydra_one_shot_fail.


>   What about one shot mode on the sja1000 cores?


That is a good question. I guess it will be counted as error by:

         if (isrc & IRQ_TI) {
             /* transmission buffer released */
             if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
                 !(status & SR_TCS)) {
                 stats->tx_errors++;
                 can_free_echo_skb(dev, 0);
             } else {
                 /* transmission complete */
                 stats->tx_bytes +=
                     priv->read_reg(priv, SJA1000_FI) & 0xf;
                 stats->tx_packets++;
                 can_get_echo_skb(dev, 0);
             }
             netif_wake_queue(dev);
             can_led_event(dev, CAN_LED_EVENT_TX);
         }

 From the datasheet, Transmit Interrupt:

"set; this bit is set whenever the transmit bufferstatus
changes from ‘0-to-1’ (released) and the TIE bit is set
within the interrupt enable register".

I cannot test it though, since I don't have a sja1000.

>
>> Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
> I've split this into two patches, and added Fixes: lines, and pushed this for
> now to linux-can/sja1000.
>
Thanks, regards,

Jeroen


