Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7D96365C3
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbiKWQ0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbiKWQ0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:26:51 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5D68F3F2;
        Wed, 23 Nov 2022 08:26:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMXcO2tFtfiQUktSwpWk+vcKPf+xuzJXz8FRWvSkD5utkyBqKal1SOc22bUJw54cLZL10k+VsqiDzVDp7OyLuCopf7jUVlwA2YW63j+2WByC288rD4h9yHmtoDGpc8nOvRqh6mPEc5n2voXVBNNr9nRbNlaG38TbEY915RJqiwa9ccY4e1h7VsQx9FHvmUSt+TrR2GlTHe9EHAnrOibx/fYvjMfAhJRqCvOzyrqbbQqn5xzoIqyQwrgZyNDR89y9Srj4pqkKCP83HRtzSFxVSUC7S+qReP9Ca0RibDrY0UUFFpbn5/ZZzBncfYoVYV7txn2aUxKtLxjZm1mzGvsH2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yeBtRT+sdOMmzXgmOsBwnUXznzSKl/XNleLQXemqEGo=;
 b=chDoIlgzuzMBwd5LlUYqsS4zWKqOfTO0CxyQNeHN+Ud5zaBQAo4mS8MGF3pcW2P0JR9HzjN7Kkmc29SdA1GdkQw85oGl7guwah+BTmIP5cCIywkJ8+ft8Lat8byy04bS74cNIk3n61fde8C86VzXjO69lAwNOVLraAPq2D8rz66ROV750UwLaOqsqfDMSRxKNwu4dZn38ZDxuptkKTFpt8WNlFYG8X+adnXbf5Loai8t0R9c22PEEaBptjeoGdOjCXTYQK+JBSyNuZ2XE4dV5F74PFdDEeMWub4TcfeDs+PTPQj/oaICiOd0fBnbhBDfzPt8gYoZJel+WFS5NxOF7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yeBtRT+sdOMmzXgmOsBwnUXznzSKl/XNleLQXemqEGo=;
 b=O+hgXao9tEuWC2AgF6rqSpq0UFkE3Y1VoUd3cqHP5TNst5qoI/NxkoHy2R0MyylF4ZrhFosrjQWEIXRJ5vsW1rO70AICdTL7beZ6/jAwr0BkWZyVmYF/WAA1+tnGJ+nrGd8I+le2kFr1gTmKrhz5Q8WfHXHMvdGAlKZ9DAQx+ofxSXrob0sSJE9Vy3O153AVIP/sI6zLlJgyb8VC3kVgwj2+jAoGbtxbsPNw5cTepEx3Q33kJ8WLAS/wjJLfn93dkmnhaFkq3C8qNCn906TMcFl4A+M+Okmjk+Ze4iUCw2WtoOKSHJBhqEYsYNEUJUtyt2azx89Bzi0gRHMagSVQxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by SJ2PR12MB7964.namprd12.prod.outlook.com (2603:10b6:a03:4cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 16:26:47 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::62b2:b96:8fd1:19f5]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::62b2:b96:8fd1:19f5%4]) with mapi id 15.20.5813.013; Wed, 23 Nov 2022
 16:26:47 +0000
Date:   Wed, 23 Nov 2022 17:26:42 +0100
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate default
 information
Message-ID: <Y35JwvX2h/AXQkgc@nanopsycho>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <Y33sD/atEWBTPinG@nanopsycho>
 <CAMZ6Rq+jG=iAHCfFED7SE3jP8EnSSCWc2LLFv+YDKAf0ABe0YA@mail.gmail.com>
 <Y34NsilOe8BICA9Q@nanopsycho>
 <CAMZ6RqKdDoDHB2TiTR9wkpWQ=p_bZC2NFQLFV43Us20OS0qq_Q@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMZ6RqKdDoDHB2TiTR9wkpWQ=p_bZC2NFQLFV43Us20OS0qq_Q@mail.gmail.com>
X-ClientProxiedBy: FR0P281CA0121.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::19) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5979:EE_|SJ2PR12MB7964:EE_
X-MS-Office365-Filtering-Correlation-Id: b060d819-0745-4047-385e-08dacd6f8479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A2MUV26UI8+AHaz1yqMDK/YNZq/breobla0ZkUoC7Kghu/GwnsAiuttkgyvIJzU2VDOK87MzRIUR8iyJKU59EhvirptPUyeZUz7MRYnH4gFugGhqPGEn+ErYcYof7PI1t1Mctj/L5SDflZKKIiXGeQiQew7W4NTwZJ2n6vGc7H8gRZV33pdSnT3mV8XaVn/Nrj1Ugzj5yBq1VnB6XtsCcaqcHaJC0nCPYRC+7ubH86UjGtGRrPgM+TTkBBJxYHwlzcxZCnmyzciwIJPQHnv7fujoYulXYTDA84T5xy+B6P3sK3dQZA9/7MCoKUDdowO4cyKliFhpt01Rs4bvo0rZfi8INzV4XZtqfiY81Q1ABASeiim9Y630x0kw+jJRFOO3Vh1rVWtepFaYTO9jDbTuVSFhG1E2MTHE9cxvv+mxVluggMl6iKvTMoBxjVwlTuMJ7YZZ/xehXQSb4QQ0m860q79cCjKHdqRjFR9uWfxV3HM2rE7Zz9RU2AwQVdQtDoGTqTcTBABFs8Dw40RaKyez0dq/nLy7vawTy+AkEA+dbyB1HVHzVma+YcS/+B7pRG/CzEXJer90FefBYUBe5DFWQCs7DUfje4oioJvjIgwbgo0ujIOPyy91rzt2bwNh63WcS+yL3wIh68DLnc1NlhUb1YUxxBA5u8Gm8h4JYPZ5R8W6dADfMio/xhsqhNSXbrDH55d0sWJ3uPm0o9LR0TCdThPY9rWgC7j0igvArytYRitjzIdwQD3dW/lyq057bzArztAev/c2kWS7paLzrdECqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199015)(26005)(2906002)(478600001)(6506007)(86362001)(6486002)(33716001)(6666004)(83380400001)(38100700002)(9686003)(6512007)(186003)(8936002)(8676002)(41300700001)(966005)(66556008)(66476007)(4326008)(6916009)(66946007)(5660300002)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?9WYTYSpRX9u7/W44rGmYDL9uEtgx4GQlDMXPvbvJqbgumcjn7Ay+9z9LJZ?=
 =?iso-8859-1?Q?GEbszizGwYjIjZ/uaxmNJGM/TjQL8EN4JdXAaQY64bNG/ujycE8y9F8G13?=
 =?iso-8859-1?Q?UL5wih2+NW3r6XYjcQI8KwFsvdJJ+69v3aec/sswf0MZeCQkbKeorrB6r/?=
 =?iso-8859-1?Q?9CZNpjwA+21uAGjxBLJaw19CNikuhc1crOjvnejzdbTeXfaeebf3caVsZr?=
 =?iso-8859-1?Q?99oTHDoXThTO22JpgP8R8SL2GbLXub/VvJcWY7QJlrTPaYZQJieQujLlxB?=
 =?iso-8859-1?Q?rTYmLr0y3Qq53b40cpZrnCwYflMJfyGBzf/6PCV/WVq400O7+aDJu56jMm?=
 =?iso-8859-1?Q?DYB/Qw3ooTR6KanuWnrFt8n5JVaxvAWvxd3JnEeEFSa2JdlzwEIZfoZsi3?=
 =?iso-8859-1?Q?7zcXdPAyvSqXMqHAAMtORi9Pg6Nt9+daEmeWuWtLiVDGv9M7vwu7hOGeW/?=
 =?iso-8859-1?Q?fbDJCWdCYfzaOWEZmpiMLWbTX1LePvN27Cw6VsECfDbVz/LGvMhtGiRWAb?=
 =?iso-8859-1?Q?R2BJICOsfXcUEC9WaGcHcPDO0Wozu/HEK5YMxZWpwY8IFgfv64KX3JlnER?=
 =?iso-8859-1?Q?SLVSkyPJu1zYYda8yhF1l2UAYaHqAYnbhQzU4eKQi1gkTJYzoVw1TwgDC/?=
 =?iso-8859-1?Q?AruVNDkbzdANtJujCK2YjX3ptPRzCZpHhEjF+7+8XfjH67tL6djsWX7ufC?=
 =?iso-8859-1?Q?LU7XyLCEsAOW1wPxUDCiKU6e2Ij61N4IoCMQHuDoS1E1+jHFEI04sXM0Yl?=
 =?iso-8859-1?Q?iN5UoFVUkn87Qp3pwCUvBZOfl9+nwRVTfdbLQBh4XkgmxOkVf1bsvaMrQA?=
 =?iso-8859-1?Q?IkJ7ljAqcFuhRcFC/k3iH/Bhw1c3yJy1sR75Ycop1wFOg9ByVmgPcCnTYv?=
 =?iso-8859-1?Q?Ze1oU8b2ZO0Cx+hcNESl4PBJvHBS39ep8kAUMZ8UDzB5JGNaiWuu1DJOTN?=
 =?iso-8859-1?Q?b89G+dZMdztYM6HwX6NTCDS1EsNffZ7HE5hpffm/7qzOAN+MJun0XSU11k?=
 =?iso-8859-1?Q?iVwu6nhXK1B+pY3rHMz5McvF2rP4aVMSshvQJ+FDcvUEdEIwgRuRA8nh2L?=
 =?iso-8859-1?Q?zTjEkB38Fau8VBcKirWDUAo+ZTeuojiW6fFp3+RaLvMt/JROcUyrK/huiW?=
 =?iso-8859-1?Q?OGX7Hcm83ot/fAXglXvOz9o/q+n5y4DzYp+f6ZTWwJKKRAlpBjMagzpPo2?=
 =?iso-8859-1?Q?1AVssBre+zDE+HrchGoebi5ylxZUBS7AvtKLCnBB9e1WDkCHe4II33KVi8?=
 =?iso-8859-1?Q?QcLo7sgxXuKG6k5gYvimxnmdeBIwJ2WKoJECob4WzlIRb8NpWoqP+WHoJA?=
 =?iso-8859-1?Q?zLDHB3z8UdWnLBveSKZxAjqyYqNQj48W4fe7hFboGAccCuhTU6JsOPeTZl?=
 =?iso-8859-1?Q?ZFVdtEv4WJPW0whwL5sWARid1lPVVdV1OdCS6XkgVubNlwisOFo/iKF1+f?=
 =?iso-8859-1?Q?uUpvvqn9jwPNoTqAXJ7/7HB4OKA09sBqHEYmaxWB72svi2ia2i7U7G9zD/?=
 =?iso-8859-1?Q?QSRJ3Jf4UTC+6TYI0Ql+Hj3J6UYrYFW+TrbflKWeP/bp5gVqLYr5rpNG0G?=
 =?iso-8859-1?Q?SVB1TW5DkTazGqzPxaPF7ieSgjgag1/MisdGJPoSEiS6L1GZRp+Mgr2Rrx?=
 =?iso-8859-1?Q?BnMr4rLdKHRknAi2oRkp9d/+KtY24V2ol7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b060d819-0745-4047-385e-08dacd6f8479
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 16:26:47.5665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pN1XqIAQZYVOvAZoY0deNLbQYKOLjoK6jrMJffiHNeykyx8u0X3uTMuw5iPEA1iG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7964
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 05:08:10PM CET, mailhol.vincent@wanadoo.fr wrote:
>On Wed. 23 Nov. 2022 at 21:10, Jiri Pirko <jiri@nvidia.com> wrote:
>> Wed, Nov 23, 2022 at 12:00:44PM CET, mailhol.vincent@wanadoo.fr wrote:
>> >On Wed. 23 nov. 2022 à 18:46, Jiri Pirko <jiri@nvidia.com> wrote:
>> >> Tue, Nov 22, 2022 at 04:49:34PM CET, mailhol.vincent@wanadoo.fr wrote:
>> >> >Some piece of information are common to the vast majority of the
>> >> >devices. Examples are:
>> >> >
>> >> >  * the driver name.
>> >> >  * the serial number of a USB device.
>> >> >
>> >> >Modify devlink_nl_info_fill() to retrieve those information so that
>> >> >the drivers do not have to. Rationale: factorize code.
>> >> >
>> >> >Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>> >> >---
>> >> >I am sending this as an RFC because I just started to study devlink.
>> >> >
>> >> >I can see a parallel with ethtool for which the core will fill
>> >> >whatever it can. c.f.:
>> >> >commit f20a0a0519f3 ("ethtool: doc: clarify what drivers can implement in their get_drvinfo()")
>> >> >Link: https://git.kernel.org/netdev/net-next/c/f20a0a0519f3
>> >> >
>> >> >I think that devlink should do the same.
>> >> >
>> >> >Right now, I identified two fields. If this RFC receive positive
>> >> >feedback, I will iron it up and try to see if there is more that can
>> >> >be filled by default.
>> >> >
>> >> >Thank you for your comments.
>> >> >---
>> >> > net/core/devlink.c | 36 ++++++++++++++++++++++++++++++++++++
>> >> > 1 file changed, 36 insertions(+)
>> >> >
>> >> >diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >> >index 7f789bbcbbd7..1908b360caf7 100644
>> >> >--- a/net/core/devlink.c
>> >> >+++ b/net/core/devlink.c
>> >> >@@ -18,6 +18,7 @@
>> >> > #include <linux/netdevice.h>
>> >> > #include <linux/spinlock.h>
>> >> > #include <linux/refcount.h>
>> >> >+#include <linux/usb.h>
>> >> > #include <linux/workqueue.h>
>> >> > #include <linux/u64_stats_sync.h>
>> >> > #include <linux/timekeeping.h>
>> >> >@@ -6685,12 +6686,37 @@ int devlink_info_version_running_put_ext(struct devlink_info_req *req,
>> >> > }
>> >> > EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
>> >> >
>> >> >+static int devlink_nl_driver_info_get(struct device_driver *drv,
>> >> >+                                    struct devlink_info_req *req)
>> >> >+{
>> >> >+      if (!drv)
>> >> >+              return 0;
>> >> >+
>> >> >+      if (drv->name[0])
>> >> >+              return devlink_info_driver_name_put(req, drv->name);
>> >>
>> >> Make sure that this provides the same value for all existing drivers
>> >> using devlink.
>> >
>> >There are 21 drivers so far which reports the driver name through devlink. c.f.:
>> >  $ git grep "devlink_info_driver_name_put(" drivers | wc -l
>> >
>> >Out of those 21, there is only one: the mlxsw which seems to report
>> >something different than device_driver::name. Instead it reports some
>> >bus_info:
>> >  https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/core.c#L1462
>> >  https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/core.h#L504
>> >
>> >I am not sure what the bus_info is here, but it looks like a misuse of
>> >the field here.
>>
>> When you are not sure, look into the code to find out :) I see no misue.
>> What exactly do you mean by that?
>
>I mean that device_kind, it does not sound like a field that would
>hold the driver name.
>
>Looking deeper in the code, I got the confirmation.
>bus_info::device_kind is initialized here (among other):
>https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/i2c.c#L714
>
>and it uses ic2_client::name which indicate the type of the device
>(e.g. chip name):
>https://elixir.bootlin.com/linux/v6.1-rc1/source/include/linux/i2c.h#L317
>
>So I confirm that this is a misuse. This driver does not report the
>driver's name.

Okay, I think that is a bug of mlxsw_i2c implementation. You can fix it
along the way.


>
>> >> >+
>> >> >+      return 0;
>> >> >+}
>> >> >+
>> >> >+static int devlink_nl_usb_info_get(struct usb_device *udev,
>> >> >+                                 struct devlink_info_req *req)
>> >> >+{
>> >> >+      if (!udev)
>> >> >+              return 0;
>> >> >+
>> >> >+      if (udev->serial[0])
>> >> >+              return devlink_info_serial_number_put(req, udev->serial);
>> >> >+
>> >> >+      return 0;
>> >> >+}
>> >> >+
>> >> > static int
>> >> > devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
>> >> >                    enum devlink_command cmd, u32 portid,
>> >> >                    u32 seq, int flags, struct netlink_ext_ack *extack)
>> >> > {
>> >> >       struct devlink_info_req req = {};
>> >> >+      struct device *dev = devlink_to_dev(devlink);
>> >> >       void *hdr;
>> >> >       int err;
>> >> >
>> >> >@@ -6707,6 +6733,16 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
>> >> >       if (err)
>> >> >               goto err_cancel_msg;
>> >> >
>> >> >+      err = devlink_nl_driver_info_get(dev->driver, &req);
>> >> >+      if (err)
>> >> >+              goto err_cancel_msg;
>> >> >+
>> >> >+      if (!strcmp(dev->parent->type->name, "usb_device")) {
>> >>
>> >> Comparing to string does not seem correct here.
>> >
>> >There is a is_usb_device() which does the check:
>> >  https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/usb/core/usb.h#L152
>> >
>> >but this macro is not exposed outside of the usb core. The string
>> >comparison was the only solution I found.
>>
>> Find a different one. String check here is wrong.
>> >
>> >Do you have any other ideas? If not and if this goes further than the
>> >RFC stage, I will ask the USB folks if there is a better way.
>> >
>> >>
>> >> >+              err = devlink_nl_usb_info_get(to_usb_device(dev->parent), &req);
>> >>
>> >> As Jakub pointed out, you have to make sure that driver does not put the
>> >> same attrs again. You have to introduce this functionality with removing
>> >> the fill-ups in drivers atomically, in a single patch.
>> >
>> >Either this, either track if the attribute is already set. I would
>> >prefer to remove all drivers fill-ups but this is not feasible for the
>> >serial number. c.f. my reply to Jacub in this thread:
>> >  https://lore.kernel.org/netdev/CAMZ6RqJ8_=h1SS7WmBeEB=75wsvVUZrb-8ELCDtpZb0gSs=2+A@mail.gmail.com/
>>
>> Sure, but for the driver name it is. Let's start there.
>
>I will do a first patch only for the driver name and think again of
>the USB serial later on.

Yep, thanks!


>
>
>Yours sincerely,
>Vincent Mailhol
