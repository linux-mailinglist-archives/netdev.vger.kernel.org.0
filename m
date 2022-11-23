Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEC7635810
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbiKWJuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238183AbiKWJty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:49:54 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A54F266E;
        Wed, 23 Nov 2022 01:47:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1I1ygbIrm/TdZeI5xAtTH/QMD+gTj58Mlrshj9tMsgUiYZy49QpC11H+xeOl9dQYE6uYtSAqLmjc5x2BTUjBqHeY6C1UlagOLDT60TFR64UWiMXiHnBo04fjZdJ0k/X8+ad7mH+ASn9f5+jDrBgjgPAP1szb+Ujz9MKBeLbi+hntBpFEQavtxkVeNzLDE1tLxKDqj1cxy8bOHqxRH9FpUn9+XdU3VBBMvQJkreIZ1OscsO0xIYWhoS57RfZq3K3xACMCsH42UJkbgMACqWybK8sXnRTLPI/kgtCqS2iJNb1hRYTKO+ISJvRyfFYakz4jCpDR5bfpxfILmoXbXkfKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3MCHNVqz0pdaDzCky7cVHrrRKkLfcxDW995JqX6bX8=;
 b=LWDDiNvDNxKbpMizwwbxMt87Mi2JrJu7ezIBDyF/OGZ5kY6hbNJP0uQLyJ8fCzSQBQPoTDnPTWXt3aRNf0k4M8ZT3xQfMkGqNz9i44/TSkh6udqI409R3NDSTGTKqIkserOQ+Z9trnh0G7y1HO/4hIcpELq7ifTAyITzN3qWMbnUo05sAG2V4fyLgJ5AopYtD8nJr2bLzW5fEGWiajihoBXKQ97YMqZgLIZ5/bMO7rV7Q5BKAmZgOVarEp8tz7LmKHkKKGRGlGVbKFkNDBZSoJgGach0RJCddevHw0CeQjeDxXFCoLTpnGBA8cCKhuCl0osHKd6vUQBZvEPESCbz2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3MCHNVqz0pdaDzCky7cVHrrRKkLfcxDW995JqX6bX8=;
 b=CwUdsIwUlLUh1wAVR41Xm/HEU8/NZ9XPp0NrLUyi65bhq5Y27ZSa8YJz9Z4tqh5pDuFZOpFkzXpx5LEbFkO97rh9nMDTWPkgfwqOvXtxOpv4JWyEkURDuPbPNuujHoZUnmSruI/9t753c7kjFHaIm4jIXOB4rXF7rLF+kGAer25T2ia4z8km9z6D7DAdQhOMynLluvG1h2r11/YsoaT/G9XTjYc4Wjcnk54zfLbOUCKIWYZuWBqANUmy0RsJ5GF9iDlGhgWrDvPi4Bj2x5X68s6sc2fwbeSwhcPgRzEtyPNeULbX0QAlbYLE2CafhV7whssiezZq3WUo5+CGnCjBPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by IA1PR12MB6532.namprd12.prod.outlook.com (2603:10b6:208:3a3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 09:47:01 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::62b2:b96:8fd1:19f5]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::62b2:b96:8fd1:19f5%4]) with mapi id 15.20.5813.013; Wed, 23 Nov 2022
 09:47:01 +0000
Date:   Wed, 23 Nov 2022 10:46:55 +0100
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate default
 information
Message-ID: <Y33sD/atEWBTPinG@nanopsycho>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
X-ClientProxiedBy: FR0P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::18) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5979:EE_|IA1PR12MB6532:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ae7fa92-296f-4b97-2922-08dacd37aafc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xX5W7PRXf1jDw0L6dX5AfxTltY+08Yrr11yEsgCS3pYKKmT1CmtZ4SAY58tAdoavzELrX4PHZMYEPe1btT6KSRFyyTaOsMVcRpjllWRtFRdazZZbjBQsEJ4dzvnms/lMjWx5sisxJ9VF1aqIjwmtK1K/hNdXRQcRjSnT6K+uRh/+ILEmHatPyBp8Tuk1uiKl3uNW3KMyH3ANaBe0sT/TZFfElrJPpFQ9L0JQAtf8tjNN7flBVhypjlf5xR42YVw8WUFv1MgB2bYXxJwA9NKV6H0KRCfvf1ZK7FHskhgEwKg5AtQqy+pjXmtE1hnO0FedOdeEgfKUHQPh1kj5328JVd4+KCKqup++4c0J5A1lIApasEkPXGb6/UkUtY00j3BxumhLnM1S2O8Ax95vZ5LYEtt0oV2ECqAO1gRgRlzpsVAcnVbNz+NPXVwsKDI3sdUbGnuCIks/uxkfE+FC9xOSyWj7Fbs5Fycr4cVPsNS84W1ecTOTLV1zFnCJkeCLHmsbhPKEYtHENk07KFvB2Vhvrl6ikrJaruv0EGnsSCsKoWMKeu4eE45slVN2MwZ2oybIm+3rhZZEqs2DpFtDy2ss/2c0IGKMHlwUvP+Njs6FQotnNBWqeO4CtSzrCGr6YnTweB4MVpGtQ8W7Jqryv0dlCk8dqpiUX9IVwLwCzsxcBez0Dnij9Dl+FFY+jk0+v7/Jl1RL25c8y4etSpPP3jtnnIXCPQU41XcZTOUZNvhry34=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199015)(83380400001)(26005)(6486002)(966005)(478600001)(2906002)(86362001)(33716001)(186003)(9686003)(38100700002)(66476007)(66946007)(66556008)(6506007)(6666004)(316002)(8676002)(4326008)(6512007)(41300700001)(6916009)(54906003)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QbOHd0ZAbxds9SHYgWy+tg9TAuK7ffC6iWgv9QtnX1JOGVStSMVJTH3s2Lef?=
 =?us-ascii?Q?UUhxUZyMMIl+aRO10wSprrgpvjEOysjYv0MnhdF/urVa8lMxjAI7+EXLbMAP?=
 =?us-ascii?Q?EtBzlmlsSHi0QPmMQ0sWsKWZFj+xz8tMOdMZwDf8mdksoEaT1Tpzoh+N7wwA?=
 =?us-ascii?Q?9LWAoEuOLqcbDyBj+nKzxQPqQ5XqXJOdtpjEsyvM8Kk4FNmfO+o/sWTtBWlq?=
 =?us-ascii?Q?wAKYKRROxdoE1OLxhFP9sjtg08ptPoBamYEYU/nb6EOaVikVxOmJSBtUT1xM?=
 =?us-ascii?Q?0cCMae/GKZa0RL+x8Lk2R8PdpEYRXW/nAEUTBtDpzaTt4ocpvsS4tPhYkeeS?=
 =?us-ascii?Q?YM3kPFeBx9XjsEKkaeNuBQSQXIF90hBrRlYEZ+YFKajacj41OHR+8gvLcbPU?=
 =?us-ascii?Q?n1fTQ3iY6Z6mEUGUtO3N1IdHAXn9yc17MeL90q27CdAgYL9kKv3Uqyn7Hwou?=
 =?us-ascii?Q?ERdnjInZTtoCygl2zbdDrjR/oW/eLgSzfjEwP6qrL7vHRAXs+xhtLbMOz6kg?=
 =?us-ascii?Q?w4UKss64gpEaj+iFfMhQmP6RVjTcTeybzhg6twTXS2Nha8VJhCcuyMXUNpXK?=
 =?us-ascii?Q?JfAvoeM/SewcXsuif7DP/KLhH6UBCnbfcnbso7ZZCDYket2BynklNyRshLUh?=
 =?us-ascii?Q?UAXpcYQ7n1X3ltdIlmkirSHBf5Zg/yPda3NVXgclTtJAdXIjvUbO9wUJIfJm?=
 =?us-ascii?Q?9nNzRSVxJm3HPUyqtZz31t8cWMoUTKz0Me4pinKUvJGJqSyih7Gk7UmiYR0C?=
 =?us-ascii?Q?HStxjqiqjjEr5BF9hkIsYfkfZqHLGndhmAObln+s9qW2SHyhyQStPUZtU8Iu?=
 =?us-ascii?Q?MPnOhCL9sm1j1hKoD5bbw3JZ7RT/EJs5288SDEi58cQKmUZ7vvji/vf24TwB?=
 =?us-ascii?Q?BNUr5gz12W4gjLEzfCWJeyakri4sk9ado1K5qjFpu3NDwaFzooEl7WDs7T1T?=
 =?us-ascii?Q?L3YqyKUFwr02mo1kXAurrOLLiN6Sq7T4AXhvgnUylJDQVrPHqzHOHHx1IM0e?=
 =?us-ascii?Q?JZTQ+ml55O55rWgBB4+GkC/MqB81P/C2WdevMpY6Z1NojTN3ka7FeOVib9bk?=
 =?us-ascii?Q?GF8O8zLnZBiTRiRoWYKbKB62Zk05dJHWo2wEMsb7Fv2a1FJGrFSm7d6fhBk7?=
 =?us-ascii?Q?PiveRoBX4JnVFIr4Y96PYXbrA7oT+E+Ut4uk81aBqLEjfDE87LhDC5EzQ5lH?=
 =?us-ascii?Q?bj8cU/e5PvQ8TjqLWoIY/2Dp/iHPB+UkeNRMjOJ1ZXNWR/lDKbB1z9GN6Yku?=
 =?us-ascii?Q?SAbs8rTA25/c2tteOTDQmnw4SZr2Z239X1OhT2cE/ms9H2KQzupms3kIgdKT?=
 =?us-ascii?Q?qHjtTUDRXbAWSRfWF6v83Gxk2TXcMUcKKwzbSoQCGDeJ8IYVHP7CmFb02+qJ?=
 =?us-ascii?Q?qmpzg5A2rcIoVn3Ve5YhLlNLGbgdPxsWWqEZyXrmnxHL5qhVtzWE6p8CEGK1?=
 =?us-ascii?Q?uivZAXIYSkq2/23T6rSOo9XHGzKoioNq7WCjNmSbkDxOrYlJqu1eZb6W3SK1?=
 =?us-ascii?Q?0dZjY8sJcyujiTKfWuewjgU+GvVhYLar060ef2f9mfBtHDhkMhXx4RleSjAx?=
 =?us-ascii?Q?UAcdDbiJeC8hijm6FIZGmTQV7UhTTs4mQhOE6TRf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ae7fa92-296f-4b97-2922-08dacd37aafc
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 09:47:01.3623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1iXcE2vsFkUSMtOmsJ7sd6SbnPCOA6aRkO3AI52O7YjosHqB8l4REg5YXCwwPzuJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6532
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 22, 2022 at 04:49:34PM CET, mailhol.vincent@wanadoo.fr wrote:
>Some piece of information are common to the vast majority of the
>devices. Examples are:
>
>  * the driver name.
>  * the serial number of a USB device.
>
>Modify devlink_nl_info_fill() to retrieve those information so that
>the drivers do not have to. Rationale: factorize code.
>
>Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>---
>I am sending this as an RFC because I just started to study devlink.
>
>I can see a parallel with ethtool for which the core will fill
>whatever it can. c.f.:
>commit f20a0a0519f3 ("ethtool: doc: clarify what drivers can implement in their get_drvinfo()")
>Link: https://git.kernel.org/netdev/net-next/c/f20a0a0519f3
>
>I think that devlink should do the same.
>
>Right now, I identified two fields. If this RFC receive positive
>feedback, I will iron it up and try to see if there is more that can
>be filled by default.
>
>Thank you for your comments.
>---
> net/core/devlink.c | 36 ++++++++++++++++++++++++++++++++++++
> 1 file changed, 36 insertions(+)
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 7f789bbcbbd7..1908b360caf7 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -18,6 +18,7 @@
> #include <linux/netdevice.h>
> #include <linux/spinlock.h>
> #include <linux/refcount.h>
>+#include <linux/usb.h>
> #include <linux/workqueue.h>
> #include <linux/u64_stats_sync.h>
> #include <linux/timekeeping.h>
>@@ -6685,12 +6686,37 @@ int devlink_info_version_running_put_ext(struct devlink_info_req *req,
> }
> EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
> 
>+static int devlink_nl_driver_info_get(struct device_driver *drv,
>+				      struct devlink_info_req *req)
>+{
>+	if (!drv)
>+		return 0;
>+
>+	if (drv->name[0])
>+		return devlink_info_driver_name_put(req, drv->name);

Make sure that this provides the same value for all existing drivers
using devlink.


>+
>+	return 0;
>+}
>+
>+static int devlink_nl_usb_info_get(struct usb_device *udev,
>+				   struct devlink_info_req *req)
>+{
>+	if (!udev)
>+		return 0;
>+
>+	if (udev->serial[0])
>+		return devlink_info_serial_number_put(req, udev->serial);
>+
>+	return 0;
>+}
>+
> static int
> devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
> 		     enum devlink_command cmd, u32 portid,
> 		     u32 seq, int flags, struct netlink_ext_ack *extack)
> {
> 	struct devlink_info_req req = {};
>+	struct device *dev = devlink_to_dev(devlink);
> 	void *hdr;
> 	int err;
> 
>@@ -6707,6 +6733,16 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
> 	if (err)
> 		goto err_cancel_msg;
> 
>+	err = devlink_nl_driver_info_get(dev->driver, &req);
>+	if (err)
>+		goto err_cancel_msg;
>+
>+	if (!strcmp(dev->parent->type->name, "usb_device")) {

Comparing to string does not seem correct here.


>+		err = devlink_nl_usb_info_get(to_usb_device(dev->parent), &req);

As Jakub pointed out, you have to make sure that driver does not put the
same attrs again. You have to introduce this functionality with removing
the fill-ups in drivers atomically, in a single patch.


>+		if (err)
>+			goto err_cancel_msg;
>+	}
>+
> 	genlmsg_end(msg, hdr);
> 	return 0;
> 
>-- 
>2.37.4
>
