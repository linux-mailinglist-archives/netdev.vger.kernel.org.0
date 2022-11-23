Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38F0635C73
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 13:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbiKWMKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 07:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiKWMKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 07:10:33 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A79BE3D;
        Wed, 23 Nov 2022 04:10:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBEB+uqP6HF9HRt8PkpWmWzVLYNUFlluUm1itiXxYMOjNnYEt09b1LQUvoQTqeY0rgMs/Jx6GHAKB0DNEceGxGjZJvS59l7/84MbwA2Z31ZHbkrLv0dUpfUPVBCQE+2qO5PMm4A441JcvByQ6qbCs43t2cdaj3WnLe2nnYnD1p+Y0vIHYOIw0nTu5B5KvAIg4Oeli5KyHZt7oz/zzpjDf3SwKzREV9DRMlfqLrR0BBtXzmm1T8X9QwohL8kuTNzsE73gLIRuaCZqgz3FcX1Jyc97XvpCkHjwfAw5PwTOrShnIr8sKTnKWBxZ76HINKAI2mav3hkg2b4GEYF2GsALSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vz4mh/7ng8SvzmvLEOdJXwp/JBHU/8J7Yisf6ss4s+w=;
 b=EaD+MKbMsCTBeHKXNQ0t1chRvIcZWkswQ5LWOFB1tt2GBkhQkwx0J7T7zrP2feZatWuCdhiOK52BfrdEYlB1CX6VmVdhy+XYSHast9PAvkFGiMpXKotx07PTG2lHaWH/+LNgstVMy944ZBtZCA20bgVtneI99AaUwK6ewCrYYKvoTFz4MB9zp7v4m10/AfrVIhYwCKzSNRT6RAkbw/3rAHlQAaox6RmA8BMn+WRbJxgyzd8BeOd51LwRRgMLFlZcXRSpfo0JQAstHF0rCrZN3PTo0jOA0fbgJklUz2zDJYLrxHAO0bUXs9Hf+68Yw8bCGz7XkkbXrcQ4/h0DQnFSEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vz4mh/7ng8SvzmvLEOdJXwp/JBHU/8J7Yisf6ss4s+w=;
 b=ZHLzzwBTZBCiT//x+ml+ycZBEKnUYIg6hO1iyIIp1oxwkb/GYdFEmbeEFLiIM8KUyJ15ThdQeXCZoIp49swM3sjmYAyGsSojCU9d/BuANYQOO8AJZG9IaOCrhUDIAQVs/y8S3oP3WppsAs2U152fmocnnuTX2R1QclS/+7N12oLF2z6V9ko6u5o2d3vVvQAlyX7m309c8fCesR/8o/nBBz09xOxEpkeTuNycm3VeSYI+Y2dig/YHkxTycozzW5ploE6TRfePgSoFdQNQ1vbHwKrx/boW7OtnABG5LGN4XNTinswLKeFQ+tYlvzGlKEXTPa58fj5jrVISMwv+/Rsxqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by CH0PR12MB5108.namprd12.prod.outlook.com (2603:10b6:610:bf::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.16; Wed, 23 Nov
 2022 12:10:30 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::62b2:b96:8fd1:19f5]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::62b2:b96:8fd1:19f5%4]) with mapi id 15.20.5813.013; Wed, 23 Nov 2022
 12:10:30 +0000
Date:   Wed, 23 Nov 2022 13:10:26 +0100
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate default
 information
Message-ID: <Y34NsilOe8BICA9Q@nanopsycho>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <Y33sD/atEWBTPinG@nanopsycho>
 <CAMZ6Rq+jG=iAHCfFED7SE3jP8EnSSCWc2LLFv+YDKAf0ABe0YA@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMZ6Rq+jG=iAHCfFED7SE3jP8EnSSCWc2LLFv+YDKAf0ABe0YA@mail.gmail.com>
X-ClientProxiedBy: FR0P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::16) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5979:EE_|CH0PR12MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: 925c80dd-0d06-4195-e6a8-08dacd4bb6ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZz74WoEYQUwbYExfdQCQa9jYCpKY+XWA3sPbDzzMOauPdqKQqCZFKLlCSyoSfX/Q1uX7Ujyhycdx0Ej+njB2GIr47wUxMYMOUHUeNX58g1H+XhMiFXJnt6rWd9CBMaUszQAQC7FLEDlH/wu5vQKCEqwNORfo0h1dQ4saW8Sdfhf6edtXlwtqlTXVRlKPuUhfHlcqFI5fxDpjb25VIaHoG3Q7p0rMM/e7QxDnGCr4m5RuZTlAZa/xodjU9c8REhaoTsQlvWQLvgvZc9K/XmVeKpIb547kFASfKW7HbD11c6G3J2QJkAV7B+ecEn6CHiqcCiYfRhl+F/fF+GMH5Fh164whWbezj2RQgzy63+FAyEPovN6o+mFSpa6kXxj1jaqIl4hT2+deaqhEwAdjSmBdGUScgnzRFXhh6DUwJII7OUhv3MNUNe/xTIVbt2YVQA1NqQ62cMomTDlI7YST68v+C6PXEZOSjc6Go9A9n3FEOc9KhuK72fSp6yJiiP9Ho9C3faTZE2WnL5rJ+4Ay16ZOyB0VI8YarcMMZICTDDheEPuWOxEZk2s2ZQdMoLRPZ6FqtyvetSTlJ0atoI0k2emjza++DwKOiJRN0CxXVLL0lodjb7ulr+FOVx2z1arApQGiXkwg/5bAoszurPrITC+4z+CDw9Xx0aAJS5fVOjyTaT2+z1+qsVBJ4HKiI1KNpNz4ACeE7VtS2uXko/tdm9CWCKowZvc4emzdToYFdmIBrXcZh5cBgAT1ISRnG9BCHM0pPvUK5c/yVxWFxm+DDyVWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199015)(33716001)(83380400001)(86362001)(6916009)(6506007)(6666004)(54906003)(966005)(6486002)(38100700002)(6512007)(9686003)(186003)(5660300002)(41300700001)(478600001)(4326008)(66946007)(66476007)(8676002)(66556008)(2906002)(8936002)(26005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Z+d1Kdmq+Qhfj7uKXN6r2qN05mMoo1Oog3ifNZ/IRGcrcR9FmwSfbRG/4m?=
 =?iso-8859-1?Q?vyXPFBy82hJqZOBK/EYzKoLl0HRhDw2PxhqEOPI41FFFuj46n9DoJRdjOR?=
 =?iso-8859-1?Q?3McaqN/Cb/lOzESEk+C+LVZlPO059oVBBzjjdtPOz+adWFKXufo4tb2VhC?=
 =?iso-8859-1?Q?2obh5lmlKy9bjsl4+nlivFMOYfJAYCM/7tX9G6NhkbDffQNBhJH01LPUGU?=
 =?iso-8859-1?Q?NKIfgQD5jZqFZ7b6ZGsMqWjLhqe1A3RsNQfidP/duQMPWL0jMbsOh8toXa?=
 =?iso-8859-1?Q?wtwMnu0o2OqNm6FWMjKAbj5rWBPLnYFTiKLVlD6F8l/lpn8g004ExtqCUw?=
 =?iso-8859-1?Q?5tTAryKgHCq5vOKA1MP8proOOhL1uwiYuDbYUAqyrwCgIzlwewik1E4866?=
 =?iso-8859-1?Q?fOJkLaDASx3go1CUcDtwMixhXX/yNMBmfV/N2yEaQryOrBdqUqNO6GevMG?=
 =?iso-8859-1?Q?iQiEg2ReNQ+RMxZYEVhoRqIrZMxKmgJxG1CdkPlJkO4Qu9IHUEGAyH7r2y?=
 =?iso-8859-1?Q?hT8C+hqNq9oH7gkr0+w31x/OXf6wRT6yCQDNRj1RuoAsIFeelGt2ogj0vK?=
 =?iso-8859-1?Q?EnpyQ+Z4OLu7+GDxa9NMY0VjQDr55n3x7UxQ7wV4WcAMn9n9EKFW1aKo+7?=
 =?iso-8859-1?Q?xv7zjG/k/KhIFSnxQETdoNlcumk6jDJRyrgZjXVSXtWPNLvzGYXHgOKlNU?=
 =?iso-8859-1?Q?jJk8fT8fLrbKMSvipOwZ7H1MhypB/rvtOY3Yf9dRtwvB+/OFOXvD/XQwUK?=
 =?iso-8859-1?Q?f3hDs+Q5gt0+jLd6SmP77fJ8H5POgd0vM3cUI7btS/gsAmyOtpJ7YzVawA?=
 =?iso-8859-1?Q?oCSwvmNMQrzjjVFWBemTp2A82Tw/tYdi+zP1kOxryVOVViKsRmhJ/qXm1z?=
 =?iso-8859-1?Q?f4OMHo6PW4okdznEH8WYBrRzlmDAHNKYqOn7RMGKWrobeqtZpbWok9TuSc?=
 =?iso-8859-1?Q?3YcWymXHUmDreq2xOCL3lW7Bz7aaPlg/u++kSAERFPyxMqRchy4j5z3zu0?=
 =?iso-8859-1?Q?cNVnCLOT9ipVnE1ecVs0b0GV9n2EWOoy2aPOrt0qMRsdTfUe4YFPCnKJiW?=
 =?iso-8859-1?Q?8XdQ5UlT7wBDMvfLHLFRqv4QfKl9r/eg82CrtlKi6oSKHuj6auBNIkHa5V?=
 =?iso-8859-1?Q?7oM2fu0URd8674O/EaXlc75kZhGmtUxYybUqZbpBwZbCKsw04IYGpN4fNF?=
 =?iso-8859-1?Q?bJURBXgfrbRuYHegkXgJj1KF913tSNJStrQzazuoV8m+O2cK7oFhnn3c7x?=
 =?iso-8859-1?Q?HDITHhFCFQsxddKiHlpeMGIwbF+IHPXELAIDjm5zllUe/4rA81+LqSeqW2?=
 =?iso-8859-1?Q?zS//YzQ/sYddt8StdRpridmyulId1w5zlV/tsUsAIu97NeQH+3FUqlmUtS?=
 =?iso-8859-1?Q?bT2uwepoHrEC6FBDp4E3Xkc3aknFjdIUW4eMuWFR6oXmJxe66J0O8YN8Ws?=
 =?iso-8859-1?Q?9LwIdbkwSUiZ1q/qCX3h50wlNca9OyaY4VGoKWTTmVhQvOoAsdTHhQMstq?=
 =?iso-8859-1?Q?ea/5TCYdmYcF45TXLeYyQixfxqTPq3/fw5wZbeQGZUE38bPFB6v8pDMMoV?=
 =?iso-8859-1?Q?2Ku3oUazSJX1EEfhZOfrMK4++5pNQhsdd9xx0Ep+Uox9iorDr35IM0tszG?=
 =?iso-8859-1?Q?YKzJiA/Z0judxhs2z3V8F4ndYQz3MYIeqD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 925c80dd-0d06-4195-e6a8-08dacd4bb6ce
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 12:10:30.0693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rCFmQP9kbDyguVxc/+ski+xERLLP46mVlaCfTiSY1nLAJvLrvHV+63qKkA7zxos9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5108
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 23, 2022 at 12:00:44PM CET, mailhol.vincent@wanadoo.fr wrote:
>On Wed. 23 nov. 2022 à 18:46, Jiri Pirko <jiri@nvidia.com> wrote:
>> Tue, Nov 22, 2022 at 04:49:34PM CET, mailhol.vincent@wanadoo.fr wrote:
>> >Some piece of information are common to the vast majority of the
>> >devices. Examples are:
>> >
>> >  * the driver name.
>> >  * the serial number of a USB device.
>> >
>> >Modify devlink_nl_info_fill() to retrieve those information so that
>> >the drivers do not have to. Rationale: factorize code.
>> >
>> >Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>> >---
>> >I am sending this as an RFC because I just started to study devlink.
>> >
>> >I can see a parallel with ethtool for which the core will fill
>> >whatever it can. c.f.:
>> >commit f20a0a0519f3 ("ethtool: doc: clarify what drivers can implement in their get_drvinfo()")
>> >Link: https://git.kernel.org/netdev/net-next/c/f20a0a0519f3
>> >
>> >I think that devlink should do the same.
>> >
>> >Right now, I identified two fields. If this RFC receive positive
>> >feedback, I will iron it up and try to see if there is more that can
>> >be filled by default.
>> >
>> >Thank you for your comments.
>> >---
>> > net/core/devlink.c | 36 ++++++++++++++++++++++++++++++++++++
>> > 1 file changed, 36 insertions(+)
>> >
>> >diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >index 7f789bbcbbd7..1908b360caf7 100644
>> >--- a/net/core/devlink.c
>> >+++ b/net/core/devlink.c
>> >@@ -18,6 +18,7 @@
>> > #include <linux/netdevice.h>
>> > #include <linux/spinlock.h>
>> > #include <linux/refcount.h>
>> >+#include <linux/usb.h>
>> > #include <linux/workqueue.h>
>> > #include <linux/u64_stats_sync.h>
>> > #include <linux/timekeeping.h>
>> >@@ -6685,12 +6686,37 @@ int devlink_info_version_running_put_ext(struct devlink_info_req *req,
>> > }
>> > EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
>> >
>> >+static int devlink_nl_driver_info_get(struct device_driver *drv,
>> >+                                    struct devlink_info_req *req)
>> >+{
>> >+      if (!drv)
>> >+              return 0;
>> >+
>> >+      if (drv->name[0])
>> >+              return devlink_info_driver_name_put(req, drv->name);
>>
>> Make sure that this provides the same value for all existing drivers
>> using devlink.
>
>There are 21 drivers so far which reports the driver name through devlink. c.f.:
>  $ git grep "devlink_info_driver_name_put(" drivers | wc -l
>
>Out of those 21, there is only one: the mlxsw which seems to report
>something different than device_driver::name. Instead it reports some
>bus_info:
>  https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/core.c#L1462
>  https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/core.h#L504
>
>I am not sure what the bus_info is here, but it looks like a misuse of
>the field here.

When you are not sure, look into the code to find out :) I see no misue.
What exactly do you mean by that?


>
>>
>> >+
>> >+      return 0;
>> >+}
>> >+
>> >+static int devlink_nl_usb_info_get(struct usb_device *udev,
>> >+                                 struct devlink_info_req *req)
>> >+{
>> >+      if (!udev)
>> >+              return 0;
>> >+
>> >+      if (udev->serial[0])
>> >+              return devlink_info_serial_number_put(req, udev->serial);
>> >+
>> >+      return 0;
>> >+}
>> >+
>> > static int
>> > devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
>> >                    enum devlink_command cmd, u32 portid,
>> >                    u32 seq, int flags, struct netlink_ext_ack *extack)
>> > {
>> >       struct devlink_info_req req = {};
>> >+      struct device *dev = devlink_to_dev(devlink);
>> >       void *hdr;
>> >       int err;
>> >
>> >@@ -6707,6 +6733,16 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
>> >       if (err)
>> >               goto err_cancel_msg;
>> >
>> >+      err = devlink_nl_driver_info_get(dev->driver, &req);
>> >+      if (err)
>> >+              goto err_cancel_msg;
>> >+
>> >+      if (!strcmp(dev->parent->type->name, "usb_device")) {
>>
>> Comparing to string does not seem correct here.
>
>There is a is_usb_device() which does the check:
>  https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/usb/core/usb.h#L152
>
>but this macro is not exposed outside of the usb core. The string
>comparison was the only solution I found.

Find a different one. String check here is wrong.


>
>Do you have any other ideas? If not and if this goes further than the
>RFC stage, I will ask the USB folks if there is a better way.
>
>>
>> >+              err = devlink_nl_usb_info_get(to_usb_device(dev->parent), &req);
>>
>> As Jakub pointed out, you have to make sure that driver does not put the
>> same attrs again. You have to introduce this functionality with removing
>> the fill-ups in drivers atomically, in a single patch.
>
>Either this, either track if the attribute is already set. I would
>prefer to remove all drivers fill-ups but this is not feasible for the
>serial number. c.f. my reply to Jacub in this thread:
>  https://lore.kernel.org/netdev/CAMZ6RqJ8_=h1SS7WmBeEB=75wsvVUZrb-8ELCDtpZb0gSs=2+A@mail.gmail.com/

Sure, but for the driver name it is. Let's start there.


>
>> >+              if (err)
>> >+                      goto err_cancel_msg;
>> >+      }
>> >+
>> >       genlmsg_end(msg, hdr);
>> >       return 0;
>> >
>> >--
>> >2.37.4
>> >
