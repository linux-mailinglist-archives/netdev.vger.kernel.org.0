Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981165F3168
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 15:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiJCNlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 09:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJCNlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 09:41:09 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C1242AC6;
        Mon,  3 Oct 2022 06:41:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bce5wSnqe8FRe5vHB4kMNuX7mMiXdByGyodZUWMq17fHHFfb82PWSF7EeAvHnLy5ZKgWzhnvoFCC/a3l4C9j94P6kyXW54k76mzrKsUpN+qofuknSbf9IIAR+LHdPxWsBMiAvQbFMr8I2Z5xNABV/N0ILT6RduAMnvx6TBE9O4zKI8HBDjXD2BI7TkEgix7w06rDl4Lqk8WDZghEqeVG6gqpWIx90COHWbrjRpT838qa2+uh80MuaGb/Y9gfbVsGSY6thaJR03RjyOYV9ntZNC7oaGSfj273oP2CeeZaQRJ15WPlaoDTDOjpu2ZE8SSBi1lzkiZywr3IDQsXMscIBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=th8FObEzykbe5usYHZ75+799LggMLqSPlhxMxSx2G5o=;
 b=KxTggfvYFcbATyy2ianQyhbk7KEk2X3ixUzTkYAtOvpORnk5Wuhxuh29HU5EJkvCX3kMupCJk8N2tpjM1u4Z142PdXgxZ4RAc4Xcp6Fj2/vZ5zdbcHH1LXp7rb61ZTVEZtps8GHFFqHtB+zyo/A+1IvbhOJLViALA2JYp575OL9VnzNUT/w1JfhdxYzv1knKzQPyU+DIJUc47ggYzS7SWowgO3xMBeWXqlmyeZlzYAxeGL4hMhqw5sRjI7NgBH28tsYC5KQoDbsyenB38W3ugxvK7gV5sibUQztP/7ZXf7hm2oqzXUvc1Cmc1T3Jr3Y6QrLgMN7vfB0xyOPMYAx+yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=th8FObEzykbe5usYHZ75+799LggMLqSPlhxMxSx2G5o=;
 b=YMcNt79x6PPHwbfdFdevaN6Ykik13X/URi8+OPRMhWajMZJIQgi2sSAgvOWYVX3Hb2Vb8gRnWxprWDaKglcbM1vf+w6aBlRT0HdyUK+36aSt/K9udDlHRsdd/8XHi9NB4S/H+uXhBrSppSNPg8s5Zc9wfWdvk7v8WYiqfx2EBx7esPc6azlSxHkzKJu3VsjE7F7kPccVUdNSkCDOV1fESauboaJoYZEw+wdiHMdg9mhjWA6JZc/Wvx8RvJ1QdtMgqA0Pl0EYeWDxxJ9KecKVewMERFrp+QwFNVBGiI0BG417nlRbEvdT9rbO++ReaF0sHlt6IRXCnmbUVS129Y90cA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA0PR12MB4493.namprd12.prod.outlook.com (2603:10b6:806:72::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Mon, 3 Oct
 2022 13:41:04 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::8f0b:1a79:520a:64c5%7]) with mapi id 15.20.5676.024; Mon, 3 Oct 2022
 13:41:04 +0000
Date:   Mon, 3 Oct 2022 16:40:58 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hans Schultz <netdev@kapio-technology.com>
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
Subject: Re: [PATCH v6 net-next 9/9] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <YzrmaixRZ3k/alPh@shredder>
References: <20220928150256.115248-1-netdev@kapio-technology.com>
 <20220928150256.115248-10-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928150256.115248-10-netdev@kapio-technology.com>
X-ClientProxiedBy: VI1P190CA0034.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::47) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA0PR12MB4493:EE_
X-MS-Office365-Filtering-Correlation-Id: 177b20d3-7beb-4497-4b6b-08daa544ea77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ce+QwlShe3tF466HuhFamXGy04PKvyXNx/U3QTeHWqeGVwlxnnX0MBCRLfNU/95SfEiReGPcJh15i2lrWRVQ854XNVtY9nOXLUOVdMlBcF5EqDiVhuvdR0cmMYkZzfoRDNrLV9/otU6K9pBTmjq3zj1G36SKmXA4vyW9JUCZfYy6NeBFVB20FEOXqXjGKpoj+ochicbRSgjwiUEMhJbsaDO9XT2rAiSa8nq3f6KYZzwoNKB5ktG+ia0qfdZp9qtu3iGHydO/Wpn3L8dH3dYmJWqjVSYoJ6/q02jk+TGWHSUxFY6xsmEzZ90ZzDByUJm1+9pMVml9Mk4W2geUEcZoMrD29FYsTtjecKEYDgnLeVczBm1v4aAhLJPMNw5QVKWjl9uWDcLqXndlOu1yvIiiw2c/aMWriusKX4e5sQrr+14WqkJ1Dr8ID5j2uw8jpuHIYiUHnrj+1Vugs433lHOQhxyNXP9Ycsv+UutFeHoqEG2xRV14fGqC4nu0UVZrz5uSICREEIJ1qhAQq3mNY6U8pa9rRl+T3NmadE0KNIadHzcAZNwBJEWp4/TGu2Nv2sx4TCz87yqNUkU0RPjpeM8YOhndxTFidk+Q4F8/DSnn1xB3UNs/oVwSSHt3/k1UmzDMOxWXIYS293oRKa2F6A9QyMCu5Ih1Mkz42ZoEGbqMjCrbfcOiWk40N8T44blp548DoXqgGM5QfvKDWDkH5nFRAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199015)(54906003)(316002)(66476007)(66556008)(66946007)(5660300002)(4326008)(7406005)(8676002)(26005)(8936002)(6666004)(41300700001)(478600001)(6916009)(7416002)(6512007)(9686003)(30864003)(6486002)(186003)(33716001)(83380400001)(38100700002)(6506007)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZtQcNCqcGEW/4DThqlf8R8S0RJ5EmLle6NsPqwRrD/mcahBgKn205mOWJFLa?=
 =?us-ascii?Q?+GxEeInTxgvgmpKUU2M1HRBg1h0LoDGqmWrFUCJrklTXTCU4TynWlue4kEAc?=
 =?us-ascii?Q?auy1Oangeor4k/vJM57OipnJm1BK1iY7+gOealEmGH2DMzks21I3/u+ekOFN?=
 =?us-ascii?Q?+cgCFN0SxKPBoM2uyqzett5vaIiplhRwRjXDg7sVMze+yI8VrpWXTRAM8Q26?=
 =?us-ascii?Q?Q6CcPI2fczYjEaW6Qw8vYwwsdoTHVtcqAPEIyYNb4swkRiUYn4aRs6dksSHN?=
 =?us-ascii?Q?RgmpjL5WZvETkWQySHvIgfPQjQGSijm+2rOZ91XfdhECIhRPNYAKd7fwVTih?=
 =?us-ascii?Q?yINCMpZN0aJ/vQdJoshfUtSF+Vopp0/vHQ78qgnPnPNaT15sqT1FW+/nIHfZ?=
 =?us-ascii?Q?w9gfZEwjhr5iqsSDqsJYDWFH9jWrUAECoGFq2mrhE0FE89Yu6wOPyTRMadgB?=
 =?us-ascii?Q?rEfLdwF6CLrg1cQCh3tL+rpCLcJivtZSMkEYl6wRR21B0Zy5/zVx7gWp7g88?=
 =?us-ascii?Q?iYBj5a3nDsakPdJ9BwYayyxpe7GPCk5mlTeJhNCwVDx1xwxwimpzEAnVAwOE?=
 =?us-ascii?Q?3h2zrLYIosKLTfj0CV7Hz7KQlODl86Dt0CeJfnvCxtAT4UePqmJo+BInArg5?=
 =?us-ascii?Q?E9ZYXXEMYaN2EMspL8qYDYjJPQRJjIT3y3p11XrK0kenuwoMSIx24fxpeVgu?=
 =?us-ascii?Q?M3rsr555gBglxdPKiAUIVtPER1WCeM1z98JfG7alp7COYydumRBEiBI/0cga?=
 =?us-ascii?Q?mqCJfksnOo/DynJQK/vrN2isI4PfyLgW9HW7O/KLJlwD+2jYILFlTmOsfgJr?=
 =?us-ascii?Q?xGYiABLi7IfhfXai11JtAb4KwFP3zXnTjUxiY/kirsmOYAwPD41QXrtPEsx8?=
 =?us-ascii?Q?O2p8tmHMy+uDgpni/NTf9p4Amm8bLuzALLcyOmnI/8N1W/PQ1/atv890OEYi?=
 =?us-ascii?Q?9u5b1+f9dn1mKFAJIwQWbaqxwbkywYEC2GB9Qr+VUP8chgKoyL+nHLZzJSJy?=
 =?us-ascii?Q?dBPbW+JNUJfHZdQWoI142dxbzmhm1/AbLk/j3a/8PKJmIjvovNB6qrGLcOP3?=
 =?us-ascii?Q?hCBxPjc1eAUszSrSbUKhbb9hTtd9SGGUchan5CfWAMVMSbUYRF8ZYC+bcG8T?=
 =?us-ascii?Q?2KuTvAtGPseoHXErCzQgptLjGq8cMzxXjdef2OXGeYGUuEqnKPzkuvLeM70P?=
 =?us-ascii?Q?L4GQ8cL02ZJv4wOlr8A9v2wrTXTCH/MxTpAzgAbhkh5qN8lVjLISQukzT5Ln?=
 =?us-ascii?Q?6oIr8j6hwS3Vq4ijB/tR8T1M4jVVDgXM/X7exiAK3H2DuZGg7YkECVc+8VJ4?=
 =?us-ascii?Q?C1OnRKooIcYSScrEvxw5m9pZGG8QtQHHIvGwBGo9Y7eUHB0m9IHgwoNfLN08?=
 =?us-ascii?Q?nyirAeYd44YaRmE11wOMRLJh5maDJp4F0L3Q9zVfUg1OUBIrBqZEt4rADV87?=
 =?us-ascii?Q?6LZjsZxXw+Iy5lkkjkxQBMkF4Tt3kqM3lONqyMhMbQeskrgCLNNbGa+MnqTO?=
 =?us-ascii?Q?g8/i1yRFYNBtofHsTIO6XmoddZbefiYRrksItldEptbzsYdYD/oMhvLNN125?=
 =?us-ascii?Q?PPkzzvjcDvCb2Rc40MLy4krG1tecQpc6o/tcx16k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 177b20d3-7beb-4497-4b6b-08daa544ea77
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 13:41:03.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PlddoJBfuKn7/auyIWILpR1Nbj3DbmzuY/pXbL1394wQqKkpb2rBAwVb45o1TxcXXROJPqXcP1VdSzRBSRM5Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4493
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 05:02:56PM +0200, Hans Schultz wrote:
> From: "Hans J. Schultz" <netdev@kapio-technology.com>
> 
> Verify that the MAC-Auth mechanism works by adding a FDB entry with the
> locked flag set, denying access until the FDB entry is replaced with a
> FDB entry without the locked flag set.
> 
> Add test of blackhole fdb entries, verifying that there is no forwarding
> to a blackhole entry from any port, and that the blackhole entry can be
> replaced.
> 
> Also add a test that verifies that sticky FDB entries cannot roam (this
> is not needed for now, but should in general be present anyhow for future
> applications).

The sticky selftests are not related to this set and need to be posted
separately.

> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  .../net/forwarding/bridge_blackhole_fdb.sh    | 102 +++++++++++++++++
>  .../net/forwarding/bridge_locked_port.sh      | 106 +++++++++++++++++-
>  .../net/forwarding/bridge_sticky_fdb.sh       |  21 +++-
>  tools/testing/selftests/net/forwarding/lib.sh |  18 +++
>  4 files changed, 245 insertions(+), 2 deletions(-)
>  create mode 100755 tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh
> 
> diff --git a/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh b/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh
> new file mode 100755
> index 000000000000..54b1a51e1ed6
> --- /dev/null
> +++ b/tools/testing/selftests/net/forwarding/bridge_blackhole_fdb.sh
> @@ -0,0 +1,102 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +ALL_TESTS="blackhole_fdb"
> +NUM_NETIFS=4
> +source lib.sh
> +
> +switch_create()
> +{
> +        ip link add dev br0 type bridge
> +
> +        ip link set dev $swp1 master br0
> +        ip link set dev $swp2 master br0
> +
> +        ip link set dev br0 up
> +        ip link set dev $h1 up
> +        ip link set dev $swp1 up
> +        ip link set dev $h2 up
> +        ip link set dev $swp2 up
> +
> +	tc qdisc add dev $swp2 clsact

There are indentation problems in this file. The coding style is to
indent using tabs that are 8 characters deep, not spaces.

> +}

This is not how the selftests are usually constructed. We have
h1_create(), h2_create() and switch_create() and the hosts use VRFs via
simple_if_init(). Look at bridge_locked_port.sh, for example.

> +
> +switch_destroy()
> +{
> +	tc qdisc del dev $swp2 clsact
> +
> +        ip link set dev $swp2 down
> +        ip link set dev $h2 down
> +        ip link set dev $swp1 down
> +        ip link set dev $h1 down
> +
> +        ip link del dev br0
> +}
> +
> +setup_prepare()
> +{
> +        h1=${NETIFS[p1]}
> +        swp1=${NETIFS[p2]}
> +        h2=${NETIFS[p3]}
> +        swp2=${NETIFS[p4]}
> +
> +        switch_create
> +}
> +
> +cleanup()
> +{
> +        pre_cleanup
> +        switch_destroy
> +}
> +
> +# Check that there is no egress with blackhole entry and that blackhole entries can be replaced
> +blackhole_fdb()
> +{
> +        RET=0
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
> +	bridge fdb add `mac_get $h2` dev br0 blackhole
> +	bridge fdb get `mac_get $h2` br br0 | grep -q blackhole
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
> +	bridge fdb get `mac_get $h2` br br0 | grep -q blackhole
> +	check_fail $? "Blackhole entry found after replacement"
> +
> +	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
> +		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
> +
> +	tc_check_packets "dev $swp2 egress" 1 2
> +	check_err $? "Packet not seen on egress after replacing blackhole entry"
> +
> +	bridge fdb del `mac_get $h2` dev $swp2 master static
> +	tc filter del dev $swp2 egress protocol ip pref 1 handle 1 flower
> +
> +        log_test "Blackhole FDB entry"
> +}
> +
> +trap cleanup EXIT
> +
> +setup_prepare
> +setup_wait
> +
> +tests_run
> +
> +exit $EXIT_STATUS
> diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> index 5b02b6b60ce7..59b8b7666eab 100755
> --- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> +++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> @@ -1,7 +1,15 @@
>  #!/bin/bash
>  # SPDX-License-Identifier: GPL-2.0
>  
> -ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan"
> +ALL_TESTS="
> +	locked_port_ipv4
> +	locked_port_ipv6
> +	locked_port_vlan
> +	locked_port_mab
> +	locked_port_station_move
> +	locked_port_mab_station_move
> +"
> +
>  NUM_NETIFS=4
>  CHECK_TC="no"
>  source lib.sh
> @@ -166,6 +174,102 @@ locked_port_ipv6()
>  	log_test "Locked port ipv6"
>  }
>  
> +locked_port_mab()
> +{
> +	RET=0
> +	check_locked_port_support || return 0
> +
> +	ping_do $h1 192.0.2.2
> +	check_err $? "MAB: Ping did not work before locking port"
> +
> +	bridge link set dev $swp1 locked on
> +	check_port_mab_support $swp1 || return 0

Move this check to the beginning of the test and instead do:

bridge link set dev $swp1 locked on mab on

See the comment at the end regarding check_port_mab_support()

> +
> +	ping_do $h1 192.0.2.2
> +	check_fail $? "MAB: Ping worked on locked port without FDB entry"
> +
> +	bridge fdb show | grep `mac_get $h1` | grep -q "locked"

Use "bridge fdb get" like in the blackhole test instead of dumping the
entire FDB.

> +	check_err $? "MAB: No locked fdb entry after ping on locked port"
> +
> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
> +
> +	ping_do $h1 192.0.2.2
> +	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
> +
> +	bridge fdb del `mac_get $h1` dev $swp1 master
> +	bridge link set dev $swp1 locked off mab off
> +
> +	log_test "Locked port MAB"
> +}
> +
> +# No roaming allowed to a simple locked port

# Check that entries cannot roam from an unlocked port to a locked port.

> +locked_port_station_move()
> +{
> +	local mac=a0:b0:c0:c0:b0:a0
> +
> +	RET=0
> +	check_locked_port_support || return 0
> +
> +	bridge link set dev $swp1 locked on

It is quite pointless to check that an entry cannot roam to a port that
has learning disabled... Need:

bridge link set dev $swp1 locked on learning on

> +
> +	$MZ $h1 -q -t udp -a $mac -b rand
> +	bridge fdb show dev $swp1 | grep "$mac vlan 1" | grep -q "master br0"

bridge fdb get ...

Same in other places

> +	check_fail $? "Locked port station move: FDB entry on first injection"
> +
> +	$MZ $h2 -q -t udp -a $mac -b rand
> +	bridge fdb show dev $swp2 | grep "$mac vlan 1" | grep -q "master br0"
> +	check_err $? "Locked port station move: Entry not found on unlocked port"
> +
> +	$MZ $h1 -q -t udp -a $mac -b rand
> +	bridge fdb show dev $swp1 | grep "$mac vlan 1" | grep -q "master br0"
> +	check_fail $? "Locked port station move: entry roamed to locked port"
> +
> +	bridge link set dev $swp1 locked off

bridge link set dev $swp1 locked off learning off

And need to delete the FDB entry pointing to $swp2

> +
> +	log_test "Locked port station move"
> +}
> +
> +# Roaming to and from a MAB enabled port should work if sticky flag is not set

# Check that entries can roam from a locked port to an unlocked port.

> +locked_port_mab_station_move()
> +{
> +	local mac=10:20:30:30:20:10
> +
> +	RET=0
> +	check_locked_port_support || return 0
> +
> +	bridge link set dev $swp1 locked on
> +
> +	check_port_mab_support $swp1 || return 0

Move to the beginning of the test

> +
> +	$MZ $h1 -q -t udp -a $mac -b rand

# Some device drivers report locked entries to the bridge driver as
# permanent entries that cannot roam. In such cases there is no point in
# checking that locked entries can roam to an unlocked port.

> +	if bridge fdb show dev $swp1 | grep "$mac vlan 1" | grep -q "permanent"; then
> +		echo "SKIP: Roaming not possible with local flag, skipping test..."
> +		bridge link set dev $swp1 locked off mab off
> +		return $ksft_skip
> +	fi
> +
> +	bridge fdb show dev $swp1 | grep "$mac vlan 1" | grep -q "locked"
> +	check_err $? "MAB station move: no locked entry on first injection"
> +
> +	$MZ $h2 -q -t udp -a $mac -b rand
> +	bridge fdb show dev $swp1 | grep "$mac vlan 1" | grep -q "locked"
> +	check_fail $? "MAB station move: locked entry did not move"
> +
> +	bridge fdb show dev $swp2 | grep "$mac vlan 1" | grep -q "locked"
> +	check_fail $? "MAB station move: roamed entry to unlocked port had locked flag on"
> +
> +	bridge fdb show dev $swp2 | grep "$mac vlan 1" | grep -q "master br0"
> +	check_err $? "MAB station move: roamed entry not found"

First check that the entry roamed to $swp2 using "bridge fdb get", then
check that the locked flag is not set on it.

> +
> +	$MZ $h1 -q -t udp -a $mac -b rand
> +	bridge fdb show dev $swp1 | grep "$mac vlan 1" | grep "master br0" | grep -q "locked"
> +	check_fail $? "MAB station move: entry roamed back to locked port"

This was already checked in locked_port_station_move()

> +

Need to delete the FBD entry from $swp2.

> +	bridge link set dev $swp1 locked off mab off
> +
> +	log_test "Locked port MAB station move"
> +}
> +
>  trap cleanup EXIT

[...]

> diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
> index 3ffb9d6c0950..642fbf217c20 100755
> --- a/tools/testing/selftests/net/forwarding/lib.sh
> +++ b/tools/testing/selftests/net/forwarding/lib.sh
> @@ -137,6 +137,24 @@ check_locked_port_support()
>  	fi
>  }
>  
> +check_port_mab_support()
> +{
> +	local dev=$1;

Why this helper needs a device, but check_locked_port_support() does
not? Please change this helper to work like check_locked_port_support().

> +
> +	if ! bridge link set dev $dev mab on 2>/dev/null; then
> +		echo "SKIP: iproute2 too old; MacAuth feature not supported."
> +		return $ksft_skip
> +	fi
> +}
