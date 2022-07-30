Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF8F585A6D
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 14:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbiG3M26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 08:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiG3M25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 08:28:57 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C83647A
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 05:28:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YoYyfw/yNdvJGmV+1djDhERFDqiMr7XDgFEdDNfRIdtUgXyXYRM1anJgekxEXR47keqyqKQDpfIRRPs/o7rh/98JfYOGm5B8+6KDs2eyXlj7TYkOFLOGxSvt2gzdzP250htATX7jaudTq8aS1UXdDo9FwAyws/z244Vn8pVaXIMM1uG9ja+FMAi04GDnc/mVwd60s7+oIXd6Zbm0OOPBmOW8Mof7CkUGCLN5l7a30pz+LzJoTjPGEHRMRWiJ/qwTIqqSWcWWIFzpWrLqZruvEOdwK7b0JSTmjiZSNbarCtTKF5Yc7bka6YG8f4IHCDusWZDPj0wjO8qq9wg4M5D+1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OjPYbWJy40Q1tH0wsoD/WbM5vs1udyX/8LfkbpsfFB8=;
 b=JpcELviV7Ckhqa7tOmCBdxTYbdyiUSIag+y3cDiMn68q6kJB/1OmTWmYbDbtPZ4ZFQPRIuFEPxoxu1dJnausjYhEHsf2mx0lmZ9aAbJ8mjRrK6GZgWiZiZc2EP1fThjbPVcSpYQepHemeCLLPk1NNzlwMleBqhZomhww3umEmdq0XfmUS+LHgYgSF6gJmD2/MB/qlrU4SwG8WvI5HOT/iAgS344BvfjaAdR2f+LxnMcp7okg3qeuy8RnxpjTr/j74FNAiggwT5P5rMRSq3pY7TpfOvjYFH4wNAehq12U7+TqM2taklVJAKk5VaQvLeGs7nGhojjFxcXVKHyQvOh/Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OjPYbWJy40Q1tH0wsoD/WbM5vs1udyX/8LfkbpsfFB8=;
 b=NTNx2Jus6cP2isT3YkyzWIQkYOj8h8qVe60b/YwlhW9xsgAqzpAqdTlI0hn6z0D1qBZGY9vKxyP+lFDNtwu2SLjLOhKIh1UlG17yOvOY8NwWjGixG8Qbq6GHlC07lzdjHmOukpdLAGf54CpsXVoBJqFTCthwMu9gQQvNUXZKBo3evk8aSPhsYXwBRHFdZ+4lX7nfVr28EbK/QMQn+CJz3p7eLQDgr+G0xLuL8l9TRUzYYgP8+ErdMO8eExyL0GI7EKFrZSJkh/KEkVfTxp4aqnit0fft04fJ7Sabi4Fejg9WfZy8NrO//t3jce8/9vJ7/XzzX/J3re8roxBSGw3/Fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by BN9PR12MB5099.namprd12.prod.outlook.com (2603:10b6:408:118::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Sat, 30 Jul
 2022 12:28:54 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::4c33:6e01:fd71:d2e0]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::4c33:6e01:fd71:d2e0%6]) with mapi id 15.20.5482.011; Sat, 30 Jul 2022
 12:28:54 +0000
Date:   Sat, 30 Jul 2022 14:28:48 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     dsahern@kernel.org, stephen@networkplumber.org, kuba@kernel.org,
        netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH iproute2-next v4 3/3] devlink : update man page and
 bash-completion for new commands
Message-ID: <YuUkAEJrAZeE9PNJ@nanopsycho>
References: <20220729101821.48180-1-vikas.gupta@broadcom.com>
 <20220729101821.48180-4-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729101821.48180-4-vikas.gupta@broadcom.com>
X-ClientProxiedBy: ZR0P278CA0071.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::22) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8084333-f55f-4939-f574-08da722710f4
X-MS-TrafficTypeDiagnostic: BN9PR12MB5099:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CNvsVrZrjRSupJLTJzO4uDn/2SWFv/7sub6GPSMkxS9r8rzDk1YpBGw4LhD9ymkPTv9+jmB1nCjIIoNxvMT9pwuHeBDRfNkM0sUC5Q2k/qckO+cOSd2uiI5e9p5G5SNeFtTWNOwznv90LPDTqHj50yc7KHmgSdWoKtxL1J4st3SwtiMWZjICwZjB7C4SJ2pfvSWTrtMEtGl62YSX66AzubBnyJ7WM2OscWQrxCWZhFGycR/jhdezPJI76worDtu6tnnT+F0jBiHp5zM5dP2Jqm7dzLYuPKDPLncCxXr4HBTJLHLWjccQ4oJlMbfT5syDfA3k8cO98OUvj77Hb6i25g6jXG5yEOzgU6MJUdyIFZF0FS0nV/XSvq9YOVb6xokIn4uXXuNHcYR9MIUnUMYlVgV2CJ1U903YZqE8yVXCxi9+yKO8uKYqXBnj3LLL4uowEGFfkUdX9z9xHeQvwEXPZD7/biACe/MBs9Cw3zzNpt00Ui5GdkG5imiiR2yclgtJpIn3VuL+JlwTbVuE9jgeRJXItHaq94AVxrFDPshNFnmF1wNuPcroJkt63L4zcTKtjsP7uqOvVpKu0H6bKp1Q/w5s6LppZPis7Nnsu/Q7qhbygfBH4UZ2EKUev4L7Yp/lZVQbeUn0lidsGrZHQrZ5MGvFu+vhSRE0l+98AM6JzHrhIKbZbJqoR+oSKDJTanYSq/bNOr16NzOf/kfOA0luhnLsgvp8YQoY8XPzpsRSWlC1+XlpuEWMiGiELBWNrfqJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(396003)(346002)(376002)(39860400002)(316002)(33716001)(15650500001)(186003)(6916009)(38100700002)(6486002)(66946007)(66476007)(83380400001)(8676002)(4326008)(66556008)(478600001)(5660300002)(6506007)(8936002)(41300700001)(6512007)(26005)(86362001)(6666004)(9686003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+zqRHumeNWpumm/wUN2PcxPH3ZC465VItyoh/LdPPswMXVncqi4FSeiKJVha?=
 =?us-ascii?Q?Ft2MpA35nOX3sCrCUJClLscaC9lzSml+R+fH01s5n6Pnn7VN6USRYwi6drJP?=
 =?us-ascii?Q?N1INxm/1Zym5S8vqssGJ4f+j6+f9ta7h8W0n3qBjMzpO2nO1ixA7DkbGMVOs?=
 =?us-ascii?Q?kg7cESAMAs7Qh92cFCtI4wDlGbC87uzXCKuIJLWhCydvZdwrGhFGGo/pLRa1?=
 =?us-ascii?Q?ZMK4/s1vzMk67L9ipNMQI7yyhIXD0SycVy7uPTpka1FlKwE4pdboK5pjcvDq?=
 =?us-ascii?Q?kK3cgwiXKkpbHLQMfIAK+Kmcj+VNIBrLkFRdBlSbNHD2XQcSpjU36kZdV4GN?=
 =?us-ascii?Q?1/OdhQp+iNW5drlsnNR3fbR1ROm5OsMEBSAr1Mo1iFzqjW0oYD0AOS2JTGsp?=
 =?us-ascii?Q?G2C4Om6dmRngcS4mplJ8EiEV0EHi6f3JbppxKE2CVTLWpWnHzQ0Fli4/fdTh?=
 =?us-ascii?Q?ASOqCyne8/5g7t/t0waXdhpuR1VE3EiA54QwIO9MxFd3dKz9XxwPD7MW5v6F?=
 =?us-ascii?Q?LvoM9XreEttx2JGbRBauV9aRYS19ZNB1c/IQEmhSnT+CfS2EB/2oW3zLnIGW?=
 =?us-ascii?Q?bVgCRbVgMVuujW519nqlheU11hqWIQpttPPEsb8eccIL8I+xxVhq/NFXCx/B?=
 =?us-ascii?Q?Qni7LuwuGzcTCZQCI/9L5IUkeiTIqzMGQcsQ81BWkiW4KPUtphraP+N6wa6D?=
 =?us-ascii?Q?pa0IP9RpES0MPG6b51dj9JamL0Wv6zkfOpo5sGlM0/c+niuM9uCPSGdf5uo6?=
 =?us-ascii?Q?pcyMmVm3xtoXlqRHbmGXoYvdyU9Jvu7g0luAZ/493p5HNz2GR20ninSPZIsz?=
 =?us-ascii?Q?snDYVlOQ42/25NctV2Z+W3EnLmvlamgXu5MPk3FlAf+u1xJ4cTAzTdfydGpP?=
 =?us-ascii?Q?UhZjFdrkkuj5mZ94df+3bssSg1oOFFyshPS22AjZxFM/EnaJSwDCYj2Hshrr?=
 =?us-ascii?Q?eszEVGsA2OfoOJqxISzN5u1OZkRTXzHsPKws8ik2/SSIQ2+1sW65FyU7XmT9?=
 =?us-ascii?Q?EpIcrITajGniXPv1nRLjhF5AaSgxlQg2VEtGs9nFC9EchOYKFFOML0goezDK?=
 =?us-ascii?Q?fZ1F2VI92iGZo1sgxI3Xwgn+SVo3FrxAyAwhi3JfyovOqPCQt0AQWsUGzJfa?=
 =?us-ascii?Q?iWZ/dVeXLcShlha33cw2hWDP9TDJec0O9SFI7BxxTzEM5j0G6LkC/1zqeCdQ?=
 =?us-ascii?Q?KrMHTtC3rwfU4TJydJNAva4VujKAzlEapF6fsQBBaV5oWgeS5pPtaedG9yMH?=
 =?us-ascii?Q?dgzfSJkrCMpsV9+NBH2scovxKgQYnN81fpkBVH43r2pmJ6iBUPdOWjunF0qW?=
 =?us-ascii?Q?hQyaAO9MHnx6UNZNjZQ6O08t2AcEhqVT8cNYfY9pZJxM+zp2RjSX/UpmwpKb?=
 =?us-ascii?Q?6YQVDK+AUaF7qYf+sjjpxYVnIgW0tGZCPGCUPqIGTp9ei9KlytTDcos5nXEz?=
 =?us-ascii?Q?O5U4WJ3nTtVZolH72sY0EoDwb1a7ym3s5OWAyaxU5H2N2n8Z6aiQDAPCcDaE?=
 =?us-ascii?Q?xNXD7AXg7o/sv6fxg/zLcravOouhNNldeNM1qDv4pxM7qVb4pjp2mXnvuI+l?=
 =?us-ascii?Q?p5yGrQ5EYl1ktcy2SiR3MrtkGbqrj7JQbHj8gj8l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8084333-f55f-4939-f574-08da722710f4
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2022 12:28:54.1385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBMg/LHR8i2/zZa1zDYTDQ7Zev8+awYlQPhkmx3+xdWQJ4HDKZGkAKA1IKbLLkDQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5099
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 29, 2022 at 12:18:21PM CEST, vikas.gupta@broadcom.com wrote:
>Update the man page for newly added selftests commands.
>Examples:
> devlink dev selftests run pci/0000:03:00.0 id flash
> devlink dev selftests show pci/0000:03:00.0
>
>Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
>---
> bash-completion/devlink | 21 +++++++++++++++++-
> man/man8/devlink-dev.8  | 48 +++++++++++++++++++++++++++++++++++++++++

I don't think there is a separate patchset needed for this. Just squash
to the previous one.


> 2 files changed, 68 insertions(+), 1 deletion(-)
>
>diff --git a/bash-completion/devlink b/bash-completion/devlink
>index 361be9fe..608a60d0 100644
>--- a/bash-completion/devlink
>+++ b/bash-completion/devlink
>@@ -262,6 +262,25 @@ _devlink_dev_flash()
>      esac
> }
> 
>+# Completion for devlink dev selftests
>+_devlink_dev_selftests()
>+{
>+    case "$cword" in
>+        3)
>+            COMPREPLY=( $( compgen -W "show run" -- "$cur" ) )
>+            return
>+            ;;
>+        4)
>+            _devlink_direct_complete "dev"
>+            return
>+            ;;
>+        5)
>+            COMPREPLY=( $( compgen -W "id" -- "$cur" ) )
>+            return
>+            ;;

Another tab should list available selftests for device.



>+    esac
>+}
>+
> # Completion for devlink dev
> _devlink_dev()
> {
>@@ -274,7 +293,7 @@ _devlink_dev()
>             fi
>             return
>             ;;
>-        eswitch|param)
>+        eswitch|param|selftests)
>             _devlink_dev_$command
>             return
>             ;;
>diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
>index 6906e509..5a06682a 100644
>--- a/man/man8/devlink-dev.8
>+++ b/man/man8/devlink-dev.8
>@@ -85,6 +85,20 @@ devlink-dev \- devlink device configuration
> .I ID
> ]
> 
>+.ti -8
>+.B devlink dev selftests show
>+[
>+.I DEV
>+]
>+
>+.ti -8
>+.B devlink dev selftests run
>+.I DEV
>+[
>+.B id
>+.RI "{ " TESTNAME " }"
>+]
>+
> .SH "DESCRIPTION"
> .SS devlink dev show - display devlink device attributes
> 
>@@ -249,6 +263,30 @@ should match the component names from
> .B "devlink dev info"
> and may be driver-dependent.
> 
>+.SS devlink dev selftests show - shows supported selftests on devlink device.
>+
>+.PP
>+.I "DEV"
>+- specifies the devlink device.
>+If this argument is omitted all selftests for devlink devices are listed.
>+
>+.SS devlink dev selftests run - runs selftests on devlink device.
>+
>+.PP
>+.I "DEV"
>+- specifies the devlink device to execute selftests.
>+
>+.B id
>+{
>+.RI { " ID " }
>+}
>+- The value of
>+.I ID
>+should match the selftests shown in

You can specify multiple ids, can't you? If not, you should and you
should describe it here.


>+.B "devlink dev selftests show".
>+to execute a selftest on the devlink device.
>+If this argument is omitted all selftets supported by devlink devices are executed.

s/selftets/selftests/


>+
> .SH "EXAMPLES"
> .PP
> devlink dev show
>@@ -296,6 +334,16 @@ Flashing 100%
> .br
> Flashing done
> .RE
>+.PP
>+devlink dev selftests show pci/0000:01:00.0
>+.RS 4
>+Shows the supported selftests by the devlink device.
>+.RE
>+.PP
>+devlink dev selftests run pci/0000:01:00.0 id flash
>+.RS 4
>+Perform a flash test on the devlink device.
>+.RE
> 
> .SH SEE ALSO
> .BR devlink (8),
>-- 
>2.31.1
>



