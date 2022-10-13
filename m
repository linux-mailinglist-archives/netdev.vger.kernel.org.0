Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C685FD90F
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 14:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiJMMQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 08:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiJMMQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 08:16:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA84F52FF4;
        Thu, 13 Oct 2022 05:16:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgHXpFRIKzt1YDdLuaG1Xn0YpxXhLIBiZDMwG5dC4V5Mj+USxgZ3+A9sK4TWaLIb+Bi89hZw4p65OFtgq8TPrFDBsJLmZY0C6iAAlZ2Ri01izb4OqajTexrJD1h18zG+fBuu/sU/aKdBkRcxrJgKjY15x1yelQauImW1i1KvkGEYtro3vpSHc0nUjoPbNvmQW4318B8PDpOj94FzFp2QJtZsRmczRkCOzSVoQV0S/zfpJEOlYw3iqgVc8EcGheyuupH73O0haBsSvGY9EZWhkSNFnSVHC3pudjZKfRL7feSjAvBby/D/vIQmc3sqCgvobCGkgpT3EMEsRR/MsfrawA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgDfEzaNmyHruhoccynN8yZwGtMgHcR59fqlAen+gP4=;
 b=Cyt6k3Sf2gtV6Su/JLEiOBTMnkaHDmkwllHsHzwU5fELoQNbVEPhQiORs+iePMdIKh8hKIbNmF2altwVtaWOosjdQNDuTOF/yS5MX8Rt9KxgtHX7VJuVnkCwx00lMhUUbLJTLIuzO33Fsy/gNCDKCYKxrR0LAOs7xzV9Ul/aP1b+8FHpu8u5hE4+vjVfjRkyozXYRqfDJhZgkoGdAcKtUUCghM58DC1NtnrnXH+KPKGWj4xbgkRb901/pWQygmHh3TUIve6whorOHj04pFtZzmcBd72d/JkToApkgJcOztyppzMKtibdJetUN4hj40aRzCPAp47FtooU8EYYthN/lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgDfEzaNmyHruhoccynN8yZwGtMgHcR59fqlAen+gP4=;
 b=rQfpTnvBGwAzpPtoThM4SKADp0CosgJiwouIorhjJFHWUBmfVtkeAY7UWNW5iSavFS1iz6foJrFqiyp/8fBtjkHwmMIg7J+CgM6xvZJOYQiAE5O6bvio6nEw0k3Ex6HTWng/KNI9L/E9N5i9W2CCQrsKbWTrryMJdRrNLLkLwvRxfBkHw2JYCqiSbYv+MXmk2VdoP1F5NpWJsJIBOOIGylxRF5ZcqP1454ptYmeJlzQ76+uK781VAabD24cKfJ8Y1XF3nx55zk6YZ1bdAK/8HtlEyQIMmJZcEq1NOwnHfSGVwAZGuKNWfUchidrq9LiInLobeZ1RRvX8V4EMtnjNUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 13 Oct
 2022 12:16:40 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%6]) with mapi id 15.20.5676.031; Thu, 13 Oct 2022
 12:16:39 +0000
Date:   Thu, 13 Oct 2022 15:16:32 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v7 net-next 9/9] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <Y0gBoLRNHRQeI1PH@shredder>
References: <20221009174052.1927483-1-netdev@kapio-technology.com>
 <20221009174052.1927483-10-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009174052.1927483-10-netdev@kapio-technology.com>
X-ClientProxiedBy: VI1P18901CA0005.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ1PR12MB6051:EE_
X-MS-Office365-Filtering-Correlation-Id: 799c6396-2ed8-4806-6835-08daad14c82e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M6m0ioX/R6FD//pJzWs+gKjgoGk1fZksNHkwyhQXoE36+oKTzWgJUh4OVQjDHRgqg9xUGW0lsSbbqD5KiHBhO7jLmlMwvyNrO2qX277UL+sVgyylU6x5KKhnYLdNBWrK+Skm+lFUBIxSuwIDhHyQL88C0sFp25XytJarmaHYkNm/lugGIPV1vP8xjBou1lE0sOl59N57MUlQHpyTROGpZR+MhFkqpIL7T0DIkYFDZVHHCRdZwZBfK88qgSYyYsxSlSAkVyQXaJYCKtpy8cqELXqc5Cb6dO04S1FrJdRLMaNXwGs12AM9tD5ohE2pW9ZC4WImt6EgkF66i+7li5MhpKs3Y4jB4uMQrvKXVRJRv1UiFPCbGTQsbnBT3PevxodQtZ4zaq4a1NISrl/UZJqI5kYZ3Ug3wvi0QEiMdkHCTj+SmsYuTXX9HDdAf7PAtLXFXKr5ghufVRTbC68sF85QcaS6aG2R2SiEemwyiOQVurwcKOdJQ2UFzdVIU2hNwxeyfZ27lmfK++6NtmD7SaiALBJfV726yRRpge/i2B1ZbNlp4MpMe5syj7A/tx6QGnR90Hi4Ci4Hsnbo2sWy6NlhFSHC1m3MrF+ZVRlrMBFM7QZA9xjw4q+YqRS3C8f5L8dKlheKuQP+0EDaetIEKB1ezAMHxA2DZW5BfR7KVmed9aHK7pSMMJqTQkUi59yDRgGDb8jDd2l+T1MyklitsNtv8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199015)(5660300002)(26005)(6512007)(9686003)(7406005)(8936002)(7416002)(316002)(6506007)(6666004)(41300700001)(66946007)(66556008)(66476007)(8676002)(33716001)(38100700002)(186003)(86362001)(2906002)(478600001)(4326008)(54906003)(6916009)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jt39u+lFpizU5k+VlOF+C8jugW0itAD1udCE9W3Y60OpVA3pqbaz2qb298QR?=
 =?us-ascii?Q?zB3JvYL6Ddyo7JufI0HciGrM5XfxQH6aEJzFpZ1dH+aHta+symcStLZYEMso?=
 =?us-ascii?Q?N62od/iIPhZKrKjKgNwuAttusZT6ecZ/NPC1oynU7kcQhWvEbU7tCA/HY3vn?=
 =?us-ascii?Q?NgiLsZh6hHdunUmsHOkOUS6su7sfN6wo+iKWeEmllrLilXGcR8sY43H5GZ1g?=
 =?us-ascii?Q?+bGSepCaunMep3jAK1aNUMiCsxOInMG8sx4F74E6yZwJ29/A1IYGXusZFu+c?=
 =?us-ascii?Q?vOpAuFq36ylpXVz/TbJ7z8cYLxhJ3IChiVsBMkfYAY9S8WEy5TUy4rY+MC4J?=
 =?us-ascii?Q?xjOADOJbTG1zfntF4X885uy6IfsuxbrivxoaNFK4GsSD/fqtXNnJ0rGgRCv9?=
 =?us-ascii?Q?Q6pTI30j5NOK1IodcUyxP3vZqIe3HsO+be1yRAEf+V3MkhqNaarkAHHjb73Q?=
 =?us-ascii?Q?w0tvKuusQnA23q8oBWjmG9Ovw6J6zazZA0vNt3oHtdMnT+KY7ENBdiY6ZRCO?=
 =?us-ascii?Q?Mo6luBjFNxY71hQ4wQzOiBsUr1chjECt1wi53meyp+/Hl2Znc7Hj33JvvZgW?=
 =?us-ascii?Q?AtMXF0GO1fUL7FU2zhr3uHudUlurUUHSb8jk1bMzC1p+gFeTQZ49eDSoTRQ8?=
 =?us-ascii?Q?w8v0V+nkKo/vl4ZS7CZg89OtHy/BuoZNZdKaq+kDuZ45ncz4ecXd3GdTXXO4?=
 =?us-ascii?Q?1ENk35rkvJI9r2EzLID4laRFjogaCsx3NX84lGNYlq1Cnm5yO62GJWx2Ienj?=
 =?us-ascii?Q?rnUfBUm0WHPQDgRx3oc0XgNT/YXK5xhw5tUTwBzO53f8QXkOK5OgzrYUAII4?=
 =?us-ascii?Q?OotT6coPArCFH/Y3KKJ8JtJghLZaECr3dBHJY7gibPlgIuxW2/2PodD6XAPa?=
 =?us-ascii?Q?Tm4FXRhBVoXUMTkhQQF2xBu57MntIEXvt6TMVFKm7CW8vHLIDgZw+cB+N3Tk?=
 =?us-ascii?Q?ZghGLVliCHP1qWLuaab9oE7KZEVU2cENOnIbnZwi6Tg4RnekEhYpRwgmG1G+?=
 =?us-ascii?Q?ghOzJjvRTsedVNJ8splA3L73rZMifoR4xhqxY9wgBPjpAGByZsWXsV54xvYW?=
 =?us-ascii?Q?E7tjoRwFHp7yNAW/gbdn7jIlaQhicmJhPEvUOMn7SBgOsLrE+vSiUB/2nQPl?=
 =?us-ascii?Q?TcscpTFWkpKFlQaOMsiErnTYX7VTPrmaPsK1P+Rlm2wZ2VPGeeDoWlgrS+nc?=
 =?us-ascii?Q?gaK2b6BYJjLi8lj2ecm40zo5aFFJdaF07HxLUb5Pis9x2ESXfK2Q5U8KEG19?=
 =?us-ascii?Q?rKspTgnYeN2WSmHYwV+UzxSbnsR8aCqo4ayfbNlUxNVef99FCmniScnpSMzk?=
 =?us-ascii?Q?fn86LGYf7pJP1Hn96h9AORBu9eC427oi7EKkf88opGnqELxdW8HFd6ZnzovI?=
 =?us-ascii?Q?qIUt/dkXPsi2Vu7t7cB4vVpwzBy2lpZn8nnQ3/1Suvhye2W0X5Q54SjppSxH?=
 =?us-ascii?Q?DbBBr68cy+/TQvxKJ+6C7O+hUEYgEEYEaZCnhhNpnOM0sr8Llpj8OqRNVcIm?=
 =?us-ascii?Q?kK+a5rNTrnOXcnnqO0CmT36YnMXkA+A5dQeS7xDrInIX3jPH8VlZSIVnok8n?=
 =?us-ascii?Q?RuOqF+KZrrGWqEzbUeIiU5DXGDdamZY7QnLNMcik?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 799c6396-2ed8-4806-6835-08daad14c82e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 12:16:39.7656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UpXZ/vFiU03wD2gD5K5skxHJ2DK/BjdyMcH5XAvk7IauARp4kLpkZnIpfhBlraQDIyiGJOyE5PaASbcrwLJmXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6051
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 07:40:52PM +0200, Hans J. Schultz wrote:
> +++ b/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh
> @@ -0,0 +1,134 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +ALL_TESTS="blackhole_fdb"
> +NUM_NETIFS=4
> +source tc_common.sh
> +source lib.sh
> +
> +h1_create()
> +{
> +	simple_if_init $h1 192.0.2.1/24 2001:db8:1::1/64
> +	vlan_create $h1 100 v$h1 198.51.100.1/24
> +}
> +
> +h1_destroy()
> +{
> +	vlan_destroy $h1 100
> +	simple_if_fini $h1 192.0.2.1/24 2001:db8:1::1/64
> +}
> +
> +h2_create()
> +{
> +	simple_if_init $h2 192.0.2.2/24 2001:db8:1::2/64
> +	vlan_create $h2 100 v$h2 198.51.100.2/24
> +}
> +
> +h2_destroy()
> +{
> +	vlan_destroy $h2 100
> +	simple_if_fini $h2 192.0.2.2/24 2001:db8:1::2/64
> +}

There is unnecessary configuration here. Can be simplified:

diff --git a/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh b/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh
index 77d166180bc4..cc2145ea1968 100755
--- a/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh
@@ -8,26 +8,22 @@ source lib.sh
 
 h1_create()
 {
-	simple_if_init $h1 192.0.2.1/24 2001:db8:1::1/64
-	vlan_create $h1 100 v$h1 198.51.100.1/24
+	simple_if_init $h1 192.0.2.1/24
 }
 
 h1_destroy()
 {
-	vlan_destroy $h1 100
-	simple_if_fini $h1 192.0.2.1/24 2001:db8:1::1/64
+	simple_if_fini $h1 192.0.2.1/24
 }
 
 h2_create()
 {
-	simple_if_init $h2 192.0.2.2/24 2001:db8:1::2/64
-	vlan_create $h2 100 v$h2 198.51.100.2/24
+	simple_if_init $h2 192.0.2.2/24
 }
 
 h2_destroy()
 {
-	vlan_destroy $h2 100
-	simple_if_fini $h2 192.0.2.2/24 2001:db8:1::2/64
+	simple_if_fini $h2 192.0.2.2/24
 }
 
 switch_create()

> +
> +switch_create()
> +{
> +	ip link add dev br0 type bridge vlan_filtering 1
> +
> +	ip link set dev $swp1 master br0
> +	ip link set dev $swp2 master br0
> +
> +	ip link set dev br0 up
> +	ip link set dev $swp1 up
> +	ip link set dev $swp2 up
> +
> +	tc qdisc add dev $swp2 clsact
> +}
> +
> +switch_destroy()
> +{
> +	tc qdisc del dev $swp2 clsact
> +
> +	ip link set dev $swp2 down
> +	ip link set dev $swp1 down
> +
> +	ip link del dev br0
> +}
> +
> +setup_prepare()
> +{
> +	h1=${NETIFS[p1]}
> +	swp1=${NETIFS[p2]}
> +	h2=${NETIFS[p3]}
> +	swp2=${NETIFS[p4]}
> +
> +	vrf_prepare
> +
> +	h1_create
> +	h2_create
> +
> +	switch_create
> +}
> +
> +cleanup()
> +{
> +	pre_cleanup
> +
> +	switch_destroy
> +
> +	h2_destroy
> +	h1_destroy
> +
> +	vrf_cleanup
> +}
> +
> +# Check that there is no egress with blackhole entry and that blackhole entries can be replaced

Wrap this to 80 columns:

# Check that there is no egress with blackhole entry and that blackhole entries
# can be replaced.

> +blackhole_fdb()
> +{
> +	RET=0
> +
> +	check_blackhole_fdb_support || return 0
> +
> +	tc filter add dev $swp2 egress protocol ip pref 1 handle 1 flower \
> +		dst_ip 192.0.2.2 ip_proto udp dst_port 12345 action pass
> +
> +	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
> +		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
> +
> +	tc_check_packets "dev $swp2 egress" 1 1
> +	check_err $? "Packet not seen on egress before adding blackhole entry"
> +
> +	bridge fdb replace `mac_get $h2` dev br0 blackhole

vlan 1

> +	bridge fdb get `mac_get $h2` br br0 | grep -q blackhole

vlan 1

> +	check_err $? "Blackhole entry not found"
> +
> +	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
> +		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
> +
> +	tc_check_packets "dev $swp2 egress" 1 1
> +	check_err $? "Packet seen on egress after adding blackhole entry"
> +
> +	# Check blackhole entries can be replaced.
> +	bridge fdb replace `mac_get $h2` dev $swp2 master static

vlan 1

> +	bridge fdb get `mac_get $h2` br br0 | grep -q blackhole

vlan 1

> +	check_fail $? "Blackhole entry found after replacement"
> +
> +	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
> +		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
> +
> +	tc_check_packets "dev $swp2 egress" 1 2
> +	check_err $? "Packet not seen on egress after replacing blackhole entry"
> +
> +	bridge fdb del `mac_get $h2` dev $swp2 master static

vlan 1

> +	tc filter del dev $swp2 egress protocol ip pref 1 handle 1 flower
> +
> +	log_test "Blackhole FDB entry"
> +}

Tested with veth pairs. Looks OK to me.
