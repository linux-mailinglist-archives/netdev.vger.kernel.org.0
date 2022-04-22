Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7987B50BBBC
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449080AbiDVPfX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Apr 2022 11:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385481AbiDVPfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:35:21 -0400
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Apr 2022 08:32:26 PDT
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.109.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 522C65C661
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:32:26 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2046.outbound.protection.outlook.com [104.47.22.46]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-16-bNLCtF9kMw65wnxknaxtkA-1; Fri, 22 Apr 2022 17:26:15 +0200
X-MC-Unique: bNLCtF9kMw65wnxknaxtkA-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZRAP278MB0528.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Fri, 22 Apr 2022 15:26:14 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 15:26:14 +0000
Date:   Fri, 22 Apr 2022 17:26:12 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: FEC MDIO read timeout on linkup
Message-ID: <20220422152612.GA510015@francesco-nb.int.toradex.com>
X-ClientProxiedBy: MR1P264CA0059.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::9) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7208ca7d-fd59-4dc2-c438-08da24746ffc
X-MS-TrafficTypeDiagnostic: ZRAP278MB0528:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB052875CF1FF460F50EEC815CE2F79@ZRAP278MB0528.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 8ZK2FiSen6JipRSh6Bx/I/nELjkGl02A4pXFExWI7NNNSCFWMy+ctRGTz+lvmPeJqgJznzFVOmPSGRvz/mGeKkbf5zvYLWGbpD0k0AYKMqGOmaBUHfm/uS8C7rKh6Oywz/fd1hamm/vZ7Om1J74LRxAXi8qazJ81+MVUB9q/trT/CYlGeocMkFkK2mT/JDCKOBCz2IC3nPJM7GS6WX1kssKsHfMC272nlsZoNosgZ1FEk9olMvyQ7uHbF0GTk+4ndVfTMs+AXPjf6gF5H34ZtPDf1ccSH25X0LtTAvXsDmNM0qNp99FSKOlh7MilLq+2BEE+w+U9OHla8FqwKd51YIKkfbSGNXkIViDzH2GV8mFA2zF4HixWLj980hmWgjAKSEKlqj+ksne3sbia/KBfJrmULHcq8OLJO0PhoGJDLTdASQ4z8sKASZpfzkmgxSs4FuxGjdNk70JEKPjG+PCbegpF2r4CIlpXIa7xta5euVcfv+SdgjKs7BVRydnRot607vkZ0nGAqnMKApelzsmkiFLv9LCqG2zw6rwZn5nzcDcarKlh6XogzRDUDPAL5tcktDXuR2z4dmaF7Dr2oU03pv8i4B30dUoxS16TntFYH6fKFnxvaXGC0Y3XlTpiVQ4HuJcBbgLfBX9aERddE1yZg8kFAFzmP+4JQW4u1EZJ3soCR4Nbb9xhzirEYIwWFmqd43StzJ/U6RpsD/tq+8XBx32OgpHFhJQFmmVnklEdcecvUU85N6CmdeGVHDCSnLBQSOljGPS3gOsVY57Xzh5vXJ7rtyX/KV8rhurvuA2X5to=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(396003)(366004)(346002)(39850400004)(376002)(136003)(54906003)(110136005)(6512007)(966005)(6486002)(316002)(186003)(1076003)(26005)(508600001)(86362001)(5660300002)(8936002)(7416002)(83380400001)(45080400002)(2906002)(44832011)(4326008)(8676002)(38350700002)(66946007)(66476007)(66556008)(52116002)(6506007)(33656002)(38100700002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FFgg2Wh/T8oKQR67i4R8tMDfLAaGNs+0aWydF6xsBqOK6EJ/jAMMDOMV6ebR?=
 =?us-ascii?Q?PUAgzCMZB38NWGsGiHq2WMZ2gtFjX/gSf79rI1RJ1jl07NKi7Mc+PNBCVaam?=
 =?us-ascii?Q?oU/7bL5VLX7wOKkHcDXE0fSDcm5GDcjoy1soUaXL16y5dmfqqbBOkRtzwz7V?=
 =?us-ascii?Q?MojpIuku1JwLsu7+J0ywJeQZo59BLOdzy9KWgp5UsLNUrhOojWT/rQAewcrr?=
 =?us-ascii?Q?u7kdSILBFult6ILIbfsxCybYY+JANLEnPT1CGwEUHMuEQv1pYrybCjS9Sw6A?=
 =?us-ascii?Q?qjeQclagK+TsRDp1+MBvWHUlISfmNSzYJducnip7a+RFYVaQ/A82gAWjhpz9?=
 =?us-ascii?Q?33nuwLF7X8JnJqysuA0tbg40bIVjop4zwXVif3CdEizoyBI9ZZKc+312FTYh?=
 =?us-ascii?Q?t/iUvgioVt0XApKeFGitHnWWvqPUFnmSHChp8WK4HQtiXsbb7OvHd8lkGhES?=
 =?us-ascii?Q?iXnDfMZMsc3vCHuA45C8Cddcp1DgFJ7c6g5oTjX/dLWo3qE0kbSuyypZwSvS?=
 =?us-ascii?Q?5D1vyO0K+VQjitZ5argBhx14KfQE9BMkPbKoBQ1Bud52R08INJFD1PodvbGa?=
 =?us-ascii?Q?VfcUqtDb+RiNrimKs8YVHPquH4xYc5utOnlAlr8vdX+oB/gf/USbBzJtSZtx?=
 =?us-ascii?Q?jS1XCcZerDAcDzRIzt2IMjl4XU+lA/cXnYPDvlohU7+1xE1gcc6lbkvF644x?=
 =?us-ascii?Q?8M5z6+MLImFDK0SEWVWZvkR5wk5UQP+2njMR+h/d5ZeBMrC1vEcBoGRxnL4C?=
 =?us-ascii?Q?qg635erzyof2XgovbbhjRHU0OAnDMgm5Tvb8AUchgNQg7iAk+eEWweF5mGjD?=
 =?us-ascii?Q?Jgocxh8ebIlHLUGdr85Ahy/p2ZzpPmgvymlPnZePbgDaLIiFzaKJyUY+nNJg?=
 =?us-ascii?Q?OJxYJ5mwdT01wkjns08huLN4mheB7M0lOMlfoEL6my6DATjjWg5uW9lkmGUp?=
 =?us-ascii?Q?fA4r4cJVbVKBtEf2Rq7I4T94vdLnwXyfQOLz2BJgiqKZnEz9vaLH/LBXJRKC?=
 =?us-ascii?Q?wyEZeIBSj4UyLm8qizxePVuUURBf1kw9K8UflrfvUUJ7QxEMGu+X9NqRtWvQ?=
 =?us-ascii?Q?8p9RXe3wx1M8IuQ/Tn2U+I2kXFhvKhrRdAxBAU7/hrq3i7IGIMlEbc73LP3W?=
 =?us-ascii?Q?yPU6vxUfWx6kcgHUenbusiAald6JLQUq8n5KdplaK7lRBomhq+ggyBUKETlp?=
 =?us-ascii?Q?UnvOcG9zyb5zNeflMhIQbfcYOBRvd6srDvkV0GhK1ZMhvTE3PL6tV0KoEhM4?=
 =?us-ascii?Q?l7HvTSOPyuViYUNfQaXtj4CsTQFpqTDqtUpsYTZ5B6EcA1Pdm2BtA2MG1k21?=
 =?us-ascii?Q?1jCr2W8oNEt2WIh3zBdTvy9AFuoiBCDLEunW7zbgD7LIEKn7ZAlfLSyTGDCl?=
 =?us-ascii?Q?lRZddBDWVtz1ddUM8I85d5WA+3bOhWogLQZ7iXGLc5Q5iZKBTQhKL/oLr8zf?=
 =?us-ascii?Q?yGtn6VgJZgWOWbK0cHAT52yrOVkOUwQ2S2jWL+XOGH8lWOIGFhBKCM9+d1XQ?=
 =?us-ascii?Q?nRYFk8xwjtjv5zhsk/KCXy3wRfBZO7uq73xepKdfikl10QPAGFGWhN52/nHw?=
 =?us-ascii?Q?iJXTuIv+1bWLN342V2GUA+xV0NSd/Inmkn6JrDxOERpZ9kLBD7iKbv7WIYG3?=
 =?us-ascii?Q?W5N8xuWfXGF+PRUvny8binqqQkUoxQD39Q1bbjrk+Ke6H7bjgj36OdCW3s9c?=
 =?us-ascii?Q?hP1i3kl94j0gRp2KhVfmFEw2/T8OHKK53BgAYbGR+O8H7ebxF6p9k612jqYV?=
 =?us-ascii?Q?t2JI6/WWjPDeejlHTGNfNPqWliBxoNE=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7208ca7d-fd59-4dc2-c438-08da24746ffc
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 15:26:14.0769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bzqJolp9CBNBd27mANAsf4QKY6/rcNn/7lxOiqHfp8jLwWp//bqmLDD741gaVHf8sycDNwWEIIoGRbbd0oP887xmH4m5jLod1CVr7tW+Fzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0528
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,
I have been recently trying to debug an issue with FEC driver erroring
a MDIO read timeout during linkup [0]. At the beginning I was working
with an old 5.4 kernel, but today I tried with the current master
(5.18.0-rc3-00080-gd569e86915b7) and the issue is just there.

I'm also aware of the old discussions on the topic and I tried to
increase the timeout without success (even if I'm not sure is relevant
with the newer polling solution).

The issue was reproduced on an apalis-imx6 that has a KSZ9131
ethernet connected to the FEC MAC.

No load on the machine, 4 cores just idling during my test.

What I can see from the code is that the timeout is coming from
net/phy/micrel.c:kszphy_handle_interrupt().

Could this be some sort of race condition? Any suggestion for debugging
this?

Here the stack trace:

[  146.195696] fec 2188000.ethernet eth0: MDIO read timeout
[  146.201779] ------------[ cut here ]------------
[  146.206671] WARNING: CPU: 0 PID: 571 at drivers/net/phy/phy.c:942 phy_error+0x24/0x6c
[  146.214744] Modules linked in: bnep imx_vdoa imx_sdma evbug
[  146.220640] CPU: 0 PID: 571 Comm: irq/128-2188000 Not tainted 5.18.0-rc3-00080-gd569e86915b7 #9
[  146.229563] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
[  146.236257]  unwind_backtrace from show_stack+0x10/0x14
[  146.241640]  show_stack from dump_stack_lvl+0x58/0x70
[  146.246841]  dump_stack_lvl from __warn+0xb4/0x24c
[  146.251772]  __warn from warn_slowpath_fmt+0x5c/0xd4
[  146.256873]  warn_slowpath_fmt from phy_error+0x24/0x6c
[  146.262249]  phy_error from kszphy_handle_interrupt+0x40/0x48
[  146.268159]  kszphy_handle_interrupt from irq_thread_fn+0x1c/0x78
[  146.274417]  irq_thread_fn from irq_thread+0xf0/0x1dc
[  146.279605]  irq_thread from kthread+0xe4/0x104
[  146.284267]  kthread from ret_from_fork+0x14/0x28
[  146.289164] Exception stack(0xe6fa1fb0 to 0xe6fa1ff8)
[  146.294448] 1fa0:                                     00000000 00000000 00000000 00000000
[  146.302842] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  146.311281] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  146.318262] irq event stamp: 12325
[  146.321780] hardirqs last  enabled at (12333): [<c01984c4>] __up_console_sem+0x50/0x60
[  146.330013] hardirqs last disabled at (12342): [<c01984b0>] __up_console_sem+0x3c/0x60
[  146.338259] softirqs last  enabled at (12324): [<c01017f0>] __do_softirq+0x2c0/0x624
[  146.346311] softirqs last disabled at (12319): [<c01300ac>] __irq_exit_rcu+0x138/0x178
[  146.354447] ---[ end trace 0000000000000000 ]---


The issue is not systematic, however using the following script is
pretty easy (minutes) to trigger:

```
#!/bin/bash

count=0

wait_link_or_exit()
{
	tmo=600
	while ! ethtool eth0 |grep -qF 'Link detected: yes'
	do
		sleep 0.1
		tmo=$((tmo - 1))
		[ $tmo -gt 0 ] || exit 1
	done
}

while true
do
	count=$((count + 1))
	echo "run $count"

	ethtool -s eth0 speed 10 duplex half autoneg on
	wait_link_or_exit

	ethtool -s eth0 speed 10 duplex full autoneg on
	wait_link_or_exit

	ethtool -s eth0 speed 100 duplex half autoneg on
	wait_link_or_exit

	ethtool -s eth0 speed 100 duplex full autoneg on
	wait_link_or_exit
done

```

Francesco

[0] https://lore.kernel.org/all/20220325140808.GA1047855@francesco-nb.int.toradex.com/


