Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D73D557C52
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiFWM5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiFWM5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:57:20 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130055.outbound.protection.outlook.com [40.107.13.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5580E4BFF0;
        Thu, 23 Jun 2022 05:57:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B55J7x0TYRDRGkFJHuh/0luQlJbY9HlHgsLlSk1/GDlR7UUE5ZTzT8JJoU8QbJ7MIwoAUwcUZaNPNnyFBtuR6V9Hm6gwmdBN5fxVliZ3NwSSSv2q6xVYTYtfddtjQ6C5CeWIbUfIc9Exc7ke1wkntydb5JZORGQvegV1MX4nBkR/4GSGGkDPj368IVpuKz3EKS0CVu0kxLjS9yv/tyqNqorE085pVoO+KthkPtZ8PNs4oTbVL5u9QIucFP3DNCxhuHC79+7AJHNrBwQ498cA5uCbzv86od5XEowR//q75yrN2xZnT/kk4M7rYuMRxijbuqB1HIJ2LjX+DbnFoyfSqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRWrBdyYomSvMhn3ZzlqKmfVs7QAGveUYAYLaMQUP4I=;
 b=BXQ99c6uN5UoIXyJV3LU5OeBdVZhUAyPv4I0GnWinlVmXQi1mCui5+sHcuuiVYXrFpucexzbZ6KkIN7PGFKWQJhL6pK/1Qxd9lHA1XpRcKiqenFZdqpMDlLB9PMt/O6u1Vb644MJeBoK6578sOMxaTNaSRY4sFRpy89jr4Oy45qzDzzcIcpV5wBlcXBDfpcKSW+emsnIAs+SxO1vVBzlgCLFc+zbPpRV22XZEJfiBLf/+7LSbP424uY4DpoR3iuocTQx0Cy6c2O7tK7LkXvIBl+/3fr06ecx0fLElwHEPJlrY5vdmRrl96MY6FThyUyZd66iD9fZfY9Kr2XRjgKUjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRWrBdyYomSvMhn3ZzlqKmfVs7QAGveUYAYLaMQUP4I=;
 b=3DIZq8CussXJIixZEGfCH2q8fg+Ylv0YmXI3Xog1I5Q/siwO57IzYOuHf9JwPvLQQIS4AAVRXuzvQA/eEevSl3PNEa9DbtJYx+vLGXnEQLbelDimVDA+AXl5d0DQZTusNJrXXRSiZQFN+np2e+5fM5t+TO93dAkHBNOzDTjrx3jZNCbxg2m7I/Gm8QJKilLU+IIeG4kGPRT4q2ltrReHfKD9oZdmmtW8yq98b7QnfGgJJu6umwYn8AXtdfoGHf9Ow/rCZRgMAxya6DI+KrqQ9oKjaZGJf+xmPW/wVU0wYXZeLkWRMr/pytyM42Y0j6hhFnFvqsB1vGQeztSOneQzpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by VI1PR04MB5152.eurprd04.prod.outlook.com
 (2603:10a6:803:5b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 23 Jun
 2022 12:57:13 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5353.022; Thu, 23 Jun
 2022 12:57:13 +0000
Message-ID: <bdf77222-efca-26da-fa37-d969b2aa6234@suse.com>
Date:   Thu, 23 Jun 2022 14:57:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2] usbnet: Fix linkwatch use-after-free on
 disconnect
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <d1c87ebe9fc502bffcd1576e238d685ad08321e4.1655987888.git.lukas@wunner.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <d1c87ebe9fc502bffcd1576e238d685ad08321e4.1655987888.git.lukas@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0031.eurprd06.prod.outlook.com
 (2603:10a6:20b:463::7) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 120ce752-c362-45cf-d1a5-08da5517e423
X-MS-TrafficTypeDiagnostic: VI1PR04MB5152:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR04MB5152688FD86227B87C505B8AC7B59@VI1PR04MB5152.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVq1LX9z1xlZ0f6fbLmG7jEAuUigMBQtE0l92vthhBBheNSWJtFW6QU1O/EGboRRr8UIktEbQOxcJ4hiS3QqvcevZ7dCyRpR8/lsIyOpYoL9hDVB/mqCE8KMUksSFbAU5ZFHZgQFFeDgaq84NCEGFvO7oC9DddthuKtzS4+mbB41jBMaV1Ci0cG2mccXFeQD3diHgMoiIQ4vWcNYQmLPeCxqQeEIiCNz6BNXBmgB+fEu4xfvPzsGSCH7wVOCgCwsK1wOYezGCv7+cqL/JoG4+fYoqSqTWF00s4muZuMDRAZCT1o/3e2wRqOWrXkA+/Yyy0vsFyA0UcCVbuAkw/4tm9Tgld3f5Iric1kHdS9zwAVlzayigxb1JIceKHOSWIfa5zk0D2N3FxYLqd2j3jLWShu4q9/Kfi0ZeYZXJVbFPI/7JKeYATafgq0rYwwex1sfKiw47gUTdinYF5A0tEHldYCZ2NUv/EPby6aRy/NtjKBMt3fqe3Hhc+9cHB36zZBgN9v1AhWnBUpmf4trZmhc+NrjyiGljYPLozdLA7psTUlGTs6cf6+jwAY4DwpoAElszJGbStCQgBnw2iQhRzUGltGcSRMNPBhVrgxDKgycJ6qcK0TTaYEsVIWIY30wUEaKHHepyF7srv9eG7MGDIJdsalZxRpO0F2U+UgcFbOx49wuA+R8aOZQHO26vd83pc3/rRsLWpV8Ukowe7T8NHDxM69wVn0h+uMoFe8XFRMCZdMpiah/ChDuBPGgriI6X6xtIzkwThCPZhP8mkisJT/NGhgmwB8EJoqU3NKra2zoy5ekr7HqL5Y3cHlvwAL9MjezJXr+xghc5xuNZuRNCfYy+1pLu6uftb2FTe5/634ycoA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(136003)(39860400002)(4326008)(8676002)(66476007)(66556008)(86362001)(66946007)(38100700002)(31696002)(6486002)(966005)(6506007)(41300700001)(478600001)(6666004)(53546011)(316002)(54906003)(110136005)(6512007)(36756003)(83380400001)(186003)(7416002)(8936002)(2616005)(5660300002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHg0eVFuZG5SQjl2QmhRam9WWE05bTRMWFZTWlQ2K3UvU0V5bksyaXpsa3lq?=
 =?utf-8?B?aVhmRzFaYlJaZWR5RWJLb2lteFZ3NDVQR25UZUQrWDBDWmlERS8vZmtPQ2th?=
 =?utf-8?B?Q0FkZVJmT3llY3JLSFUvelVXWU51eHFPTUo0R0E4YmtvOG9xdzJ3V3MrTXo4?=
 =?utf-8?B?OU5NVEl5WkJ3S3ZQRFN6V3NWL0p3S2JQOHB5dE5pMGF4YVJYUU9OemZidWxU?=
 =?utf-8?B?VlUxaFRHNkhKTFdUem5FZ25YWlRQZVBwamNiVzlVMWZBSjFDa2c3L1h4M2NL?=
 =?utf-8?B?MmpqSGZ4NjNyOVNMQjVQUHF5ZVZmb3hRc2VvV0RBTXhPK1BvMGdYTGZjTzg1?=
 =?utf-8?B?VkhPai82ZlFVNlR0WE1YTmgxUnNFRFhiYXErSGVSOHhsM3E4U2Z0TUVqZmov?=
 =?utf-8?B?T0ovN3p2NUxqdVRsV0F4ZDBTVTNqRllZQW5iUUlhTkFrUHQ1SGkzSjZNMXdR?=
 =?utf-8?B?bUl1SEhoL2c4VERWUmpnVFl3dEI1enhaM2s3NXJzY0U2Z09FbzBwZFJub1hl?=
 =?utf-8?B?T1B1RFo0Rldhdi9BbW13UEljaDF6Q3NMRzFCVE04Z3l1ZnFyVmUwK1FEQjZy?=
 =?utf-8?B?S2N2M0d2VStmbCtDTmhkeEpYemFnaGRNQmYrRjBnbjBvd2RvZGJTMVkzWWFt?=
 =?utf-8?B?UCtNbGN5UVhTM0RKeDVqVW9rY2ZnU2RyL2pFV1dNangyL2pOb1dmbEdVK0dk?=
 =?utf-8?B?cklYQzlLZUJTbzgxaEN6d2FHS01GbVM2bEZOcmNPUjZ0WjJ2dWlwOUNKNFRU?=
 =?utf-8?B?cGZlcE5kMkRXVUdUL3RPZExIbkxiQWNEYUpzcmk3ZU4yY1lFYkt5WHlhb3Nq?=
 =?utf-8?B?OFEydVdmeWZ6cDhuakxBT0FwSHM2czNYY0lqRDJaTTVUUnF3N3BzbGc3UEg4?=
 =?utf-8?B?WkpYaFpBdEhlaVl5UVZhQnNEeVJvUnkxQytRQ1U4V2VEQ0Q1UFA1cncyNDFz?=
 =?utf-8?B?TWFMK25BMklHWWtFaVkxVWRneVVseWNabzBGVTdqZzZzK3pwTExGbVhvVWxS?=
 =?utf-8?B?c002RTJKZUVkWGtMYnduTGpyZ083WkZ5UUFKSlZzODhSdXlGMUw3M0hFZk4w?=
 =?utf-8?B?VjdsNDZBZmo3S2lnRHhJYTR5bU16aEhiYmE1bzFlMjIrSnlCdmNBOHk2UVVo?=
 =?utf-8?B?S29DMU9LV0xGN3VBRnBuS3pLRmo4dGJOcGM4UzBYZTVlL2tYSTV5RTZHck1B?=
 =?utf-8?B?OTJhbm1teGdzSnVLZzJaT2JsM3hIREl1eEQzcVJId1hZVzRkYTN0eFhQd0cr?=
 =?utf-8?B?QXltVnYzcCtYdUMyVW1PbGNTSGpqQjZlUTZBNzZCY0xiZzlVVnNUNUhlUkQr?=
 =?utf-8?B?WmtEUitTS1hmV2xFRUh4TG92alhwZzM5VjU0dGliK0RWZU9xdlFVMFh0QjAy?=
 =?utf-8?B?eHhDVm1YRzhhanVKMmNzQ0RaZXp2cVhydUJqVEljdGNuQlNyZjFJeHZDQVd1?=
 =?utf-8?B?TTNoMEhQZW5uc00xR2JxU3hINDYrbG5McXFiZGE3ckZ5RmVVYlU0djU1Zmdo?=
 =?utf-8?B?d1kzbTBmT3hLVm1mSzFEdFdXbStQMktNSVN5eFVpZTZEZ2ptek5pQWRyeGEr?=
 =?utf-8?B?Z2YrZ3JCT0xHNitwSVQ3VG9vYnhsdWpEckNzSUhtenB1VVZUVWRlSTNXNGZQ?=
 =?utf-8?B?bGtSYWlPbmlES0htTjJXY0o2MitNajZvK3BtQTJuSmlNeURxaUNHWFFycklT?=
 =?utf-8?B?TVpxQkVrTEdNR1gxZDZ1aEVpOWZnaFZ4eVBVUUdzaVFuVmx6Z2I3QnoxalNj?=
 =?utf-8?B?NUtxbzRWY2VOL0xnV3hsS05HNmVLUCs0SDFFY3NpYkRKcklpL3o5K2dxajdI?=
 =?utf-8?B?alJZT3V6WDAwYkYrU0VEekVlUGlnaGErQmdxODZkOUVzUkVFZFMzVDNLL29Y?=
 =?utf-8?B?VzZta0NVdS9LQXgwYVY3TGZhYnlEa3daMld2Z0kwVW9sTytGTkFjNFF0VTJm?=
 =?utf-8?B?VkdUazZJNU14b043YVk3RE9PWHJlRk1EMW1oc2d1TXZIc0l4MWNwa0dlbkNY?=
 =?utf-8?B?UHhsZDJHdzVpQXRDMC8wU0Q5SWljQmpvdWJPMldpaVQrTlduRDRmc0NHUytU?=
 =?utf-8?B?MUFuWnk2NU8ra2ZQOVRseGNldy8wanAwc3F6QnhSMENXc0VqZFcrUGhYSStS?=
 =?utf-8?B?L05YUXhYcGg1enJwbW0wSHJQTW1ub1VLRUdsaXoxck1wMjBhSmd0NS9hNXBE?=
 =?utf-8?Q?e3dSap6TEOi8nT9ibWMo5dZK9qsiIlDlPIGCv95ytF9V?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 120ce752-c362-45cf-d1a5-08da5517e423
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 12:57:13.1663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISmbfGtDgsy5evbK3k4nGUSyVapTtDs0r2xfBrjrtR1S9NTiHo8zAMc/Y+fBe3vEIC0psiyXQiU4KSWqqiwmcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5152
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23.06.22 14:50, Lukas Wunner wrote:
> usbnet uses the work usbnet_deferred_kevent() to perform tasks which may
> sleep.  On disconnect, completion of the work was originally awaited in
> ->ndo_stop().  But in 2003, that was moved to ->disconnect() by historic
> commit "[PATCH] USB: usbnet, prevent exotic rtnl deadlock":
> 
>   https://git.kernel.org/tglx/history/c/0f138bbfd83c
> 
> The change was made because back then, the kernel's workqueue
> implementation did not allow waiting for a single work.  One had to wait
> for completion of *all* work by calling flush_scheduled_work(), and that
> could deadlock when waiting for usbnet_deferred_kevent() with rtnl_mutex
> held in ->ndo_stop().
> 
> The commit solved one problem but created another:  It causes a
> use-after-free in USB Ethernet drivers aqc111.c, asix_devices.c,
> ax88179_178a.c, ch9200.c and smsc75xx.c:
> 
> * If the drivers receive a link change interrupt immediately before
>   disconnect, they raise EVENT_LINK_RESET in their (non-sleepable)
>   ->status() callback and schedule usbnet_deferred_kevent().
> * usbnet_deferred_kevent() invokes the driver's ->link_reset() callback,
>   which calls netif_carrier_{on,off}().
> * That in turn schedules the work linkwatch_event().
> 
> Because usbnet_deferred_kevent() is awaited after unregister_netdev(),
> netif_carrier_{on,off}() may operate on an unregistered netdev and
> linkwatch_event() may run after free_netdev(), causing a use-after-free.
> 
> In 2010, usbnet was changed to only wait for a single instance of
> usbnet_deferred_kevent() instead of *all* work by commit 23f333a2bfaf
> ("drivers/net: don't use flush_scheduled_work()").
> 
> Unfortunately the commit neglected to move the wait back to
> ->ndo_stop().  Rectify that omission at long last.
> 
> Reported-by: Jann Horn <jannh@google.com>
> Link: https://lore.kernel.org/netdev/CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com/
> Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Link: https://lore.kernel.org/netdev/20220315113841.GA22337@pengutronix.de/
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: stable@vger.kernel.org
> Cc: Oliver Neukum <oneukum@suse.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
