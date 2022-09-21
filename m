Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86035BF768
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiIUHPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiIUHPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:15:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E97696EE;
        Wed, 21 Sep 2022 00:15:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fK7//yh16g2K/6f+itOeDh87J054WEqL0l9WXyatAvyqdfbjNn7XsMcl9ibuZOxRX4QwiI80hZyquuTmOcPt2TlxpaXEwJEns4LUEieE6P8sXknKhDjaWwxeRUmu05pPOhbuSzLv7+tFQSo194AAVI6Gbwu04gqc0SIaM+4XqbWH3n4Xblll1u9oXqialuUdbIXiL2ybku4GmixYQD16YpLwHBiSF6luYTyx8/wAF38u/AmJtz7xsDIiKPraoMTFBSnchPQsBZFUW9oVyZ+S6Q0WIFti/udrXNo0noXdrDZ2nnzQnJVIShEtuNvufTkmksLMVL2uq6Czdw0SJpDaPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lw6682kc/DZV9ZI9Esqa7vHuDGcKIwUBWoAk25d563U=;
 b=dqbHgOLq24b2B//eznJeyE+Y0DHiXe+wDP7vI1OE3ataR2UzIOCQvl33u9Q18voC/KDQ1mkEArDybvJXgwKXHY0727hTGtCknhTdv9jBQPUF+YXOnGt/tvA3HFeTsFEluovLg77ryRicaGJcxdvs5AyiXjqV5nIQikJF5kklUH/bsrzj823zmYoRnisxAEWeyGpVNV7530dSYOs9Gv4cLpS0oll54d9lyLAkVxBFxAuwS8leV0RCxSag0my3XhfOEyDnV4e7h1gjjtX8VGq3ghyM3nHsFUku19cGlbdFXe/UzKRbxr6YNVpvBdemJpjoeR993ddYtmorIpQrFSjMVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lw6682kc/DZV9ZI9Esqa7vHuDGcKIwUBWoAk25d563U=;
 b=NKyrNGGxT9N3Dnzr355DK6Ldr611OyyJ4mKMIlWAP+NKamVvhyp4vsaVk05bWPHblagfNTbAYtYsDzLfgplgTxI05uATQgOwipXBTXqACTKUkvPaqIHcgJoQt6JY+LrEGF4+AclVpyq2EpMun0ZFAeblcK14CUGDTYtk11rNroKOaYrkXWwvblPgxnh7HQFluXzbqP/+nnOK7QP76a45IbIy5kPoryiBTrLZK3igWEo7PksGod4nrZ4uYTDJYW93p6O3U3PehVx6a70b9GfCg1Ef0QSH1dddvUxtUn76Q8yJB28/upuSjaI3kFO7F8fOBHdVIkr8qtfO3qnw9ZUuCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 07:15:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2f04:b3e6:43b5:c532]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2f04:b3e6:43b5:c532%6]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 07:15:25 +0000
Date:   Wed, 21 Sep 2022 10:15:18 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <Yyq6BnUfctLeerqE@shredder>
References: <YxNo/0+/Sbg9svid@shredder>
 <5cee059b65f6f7671e099150f9da79c1@kapio-technology.com>
 <Yxmgs7Du62V1zyjK@shredder>
 <8dfc9b525f084fa5ad55019f4418a35e@kapio-technology.com>
 <20220908112044.czjh3xkzb4r27ohq@skbuf>
 <152c0ceadefbd742331c340bec2f50c0@kapio-technology.com>
 <20220911001346.qno33l47i6nvgiwy@skbuf>
 <15ee472a68beca4a151118179da5e663@kapio-technology.com>
 <Yx73FOpN5uhPQhFl@shredder>
 <086704ce7f323cc1b3cca78670b42095@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <086704ce7f323cc1b3cca78670b42095@kapio-technology.com>
X-ClientProxiedBy: VI1PR08CA0238.eurprd08.prod.outlook.com
 (2603:10a6:802:15::47) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL1PR12MB5174:EE_
X-MS-Office365-Filtering-Correlation-Id: 63352899-a26f-441d-20b3-08da9ba10de7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o68tOdoeJ1w7azU+a82i/YksBYfWLZVBd5WT9l7xbVrQBR/6KuVmcCVGIIIodArctv4cri57t0ez6K3Bd9TLOZUoKrfGd4cG/9OsgIxVAZ1A3dpIXmWBpMKsewA8BORVJ4G28AlExrKWO7GdOyyXb+p/UFpdt6FMfwpsLVHk/mKvOh9ZR1n1UM5ObhMPQN+Se670N+wbP3iNhYz4zhyR3WSzbYb/wr7BoDv47fBut5s6daygjK2jVA6HWDtdODWDqGWpV8y3gHn93mVQ9soeVrRbH9Vf8Op0S64Mur/59kmqj29/9Oio3BD7vHwGSfvv0ux9kK2eC9l8e1GrVS/z8ZvPr+bNyIfEYRx9G9tSXpu0raqaolUAGmiPz3+vtsDrnrbYRH499vB2cVrNsoIlqmZyRwdrXklbfYrDyGulpyFmvtY52e60j3sd7u+RcjrYmDPuYEwDOjB9AggEpmb2e4BT6JTGE0k2V/L0RmVrbc1eJU7bB01Bd/sD+1VB+dxp4Kgj4qtbwktNvgk7ecuSYgXlCy6IZB+4sHfX4QW+EBntM8cnxj1B53Fv5V9tbDtQ47dMdXs6hRzv9hj7ThHP1vYcSMkeO3uKDwYn985b3Vvs941JPbVgFyq//VrhuYOqLOqLzNRyviXlVKCTV7wto4eGjqmsjWAR+d0k1H8Whzw2kc6r7q7K0g33hIZuWEXt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(83380400001)(186003)(41300700001)(38100700002)(6512007)(26005)(7416002)(7406005)(5660300002)(9686003)(6486002)(478600001)(6666004)(6506007)(8936002)(33716001)(86362001)(4326008)(8676002)(66946007)(66556008)(66476007)(6916009)(54906003)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L49Gr+uY3EID1KHBjPHpFm3YicvYYC1fpR//tv8+1J7ERYE4R9xdXNLfuj0Z?=
 =?us-ascii?Q?NXhpcoW78Z5nQQuxl076YwDHhgexLKFkYuW5CAVnjH793dJ0eZ4T9bUixHcN?=
 =?us-ascii?Q?hvP0VQlgGDjyoL/IRWojb6i5aZDmQgllhZGwl5I6NYlI3wWeOtv33C/zhe9K?=
 =?us-ascii?Q?WWGzciYiovpsWrJXqDAaSrnrr0uiL5rf7rvyp8kk2CPke9ra+yAjfK0LbZib?=
 =?us-ascii?Q?eNJrLGK4x7TU4qYjjDwk2adF2SmD6nWIEILNdRrN1QnL2DnZkH9H+KmZXrpQ?=
 =?us-ascii?Q?Kr+Zn8JwAVERc8zOJ3JRCBSJsRDip/lGRCC1uD89iRXMszZ3awdqP8hCw2K9?=
 =?us-ascii?Q?Uja+N6yqhzRb1cDWioVVwMh8B3LSfteaFW7KHnjsQaO2evDW1KeQYbUhCeGL?=
 =?us-ascii?Q?C5mNiS/w9W1qV/Sv+pz3LaysVNNeaJYIEyqk4WQAZDlblUdM7nLUcuXvLM4v?=
 =?us-ascii?Q?JWFG0XM9Rg5ZN72Qp7rj8tLxjJT5IGYRH7e3PdrFERmra4ZWBe2V9ZfURLil?=
 =?us-ascii?Q?xPECILcUQNzXKVXjIqGr2eAKv34lds6j1yAnlR8wgFO8CXED/Gfn34j9vK4K?=
 =?us-ascii?Q?ENP8cwXzUHnONKDLkx+C+EDYaWVKAeRRbUgshdJ0rILLud5R9ALqv+XZXMnx?=
 =?us-ascii?Q?Pc5+7tTkcrmqxp+y6NcWQO8QjW1uYy/f1GpmjQ/4A2xgXiLE9ra1WQdlavjv?=
 =?us-ascii?Q?bupGeF5YHOaS3ENWaV+D9wMbXl99vX7wkX82mEPESy8yyRrQEMrQAMvsJS87?=
 =?us-ascii?Q?6YDu3E15oC9ZWfEFHdAkrk4l2MwytHKq2s1ievWOJNEOB8VMZ0itDZ+60ZcX?=
 =?us-ascii?Q?se8hG7w64gsJmBmAf6zY3NhdeFCDpIL9SDRQZUkp5KVJ4FGtBnI6EP08TAbE?=
 =?us-ascii?Q?9h2aW5NbAI8DWsLGlYBvXRh3vOOBV6cjh7ZvDCZSFztTkKH+2DbjJG7BgDhF?=
 =?us-ascii?Q?OaWoYrwl4qXd24cl5SoaK6D7mcpboWdoItuRWNC/lBA5cl4PzEh53LW7mY2g?=
 =?us-ascii?Q?TkaYem6TPL7pGOODHfYNVHWv4c7Nvedcexv9RU7MozkNQjpevtQ3uYEMtX+H?=
 =?us-ascii?Q?wo94Hs5TEgR99L7PFuTHzQB6ESd2UslTwLHWSwULLAbWs0NI0NBZmGhWd4jj?=
 =?us-ascii?Q?gIvWEtNcx4NUeOlFY944Ouw9i3PqnRw7dSICMPK8rc0m2GPEK7nGQahumu8r?=
 =?us-ascii?Q?leDM+x+FHjuxeyVhXL/240rM4OBGINfNyJ3+CCkG6tnGJ34PIZ5eUSG45/JX?=
 =?us-ascii?Q?Ih0EI7LW6SDbKjIJuqpl3MQhDjPenUd7YZ493F8XGrU0ZUABTHOKQ75Zu16a?=
 =?us-ascii?Q?/cSHu9Na9HvWTa0tgnZS7UzhXFpsrQ6TMdQN+kolpxPyTQZS6sN2tU1gcEnT?=
 =?us-ascii?Q?zHhFXq5f2Gy1xxgPyL/GkW1g7nUYXe3E3FQyxxbKydesfQdqVjhyWdUmaeG5?=
 =?us-ascii?Q?yWLYPiOdgT1co4j/Xh/L7/CmO4o+jBqcfrlIKrHsYtArVsaQyqiXW4kaEMCb?=
 =?us-ascii?Q?UKz38Z9ReR7G7cAE0TOdO+BosISreYoG6ZBNGMYCgCSmWW+h3mOjiO/uY7pu?=
 =?us-ascii?Q?4SSMzLFZzqiEheexAr/ws6W+aOqU/NrDzNF4gmHj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63352899-a26f-441d-20b3-08da9ba10de7
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 07:15:25.4293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEcz5Y6GlqKWfAlUv3G0tEWo3vBh3jMU8usopCuul4yhIMdGavWkMbNzsL3wFl+I8hXzSZaBPGaiYhS0Muz5xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5174
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 11:29:12PM +0200, netdev@kapio-technology.com wrote:
> I have made a blackhole selftest, which looks like this:
> 
> test_blackhole_fdb()
> {
>         RET=0
> 
>         check_blackhole_fdb_support || return 0
> 
>         tcpdump_start $h2
>         $MZ $h1 -q -t udp -a $h1 -b $h2

I don't think you can give an interface name to '-a' and '-b'?

>         tcpdump_stop
>         tcpdump_show | grep -q udp
>         check_err $? "test_blackhole_fdb: No packet seen on initial"
>         tcpdump_cleanup
> 
>         bridge fdb add `mac_get $h2` dev br0 blackhole
>         bridge fdb show dev br0 | grep -q "blackhole"

Make this grep more specific so that we are sure it is the entry user
space installed. Something like this:

bridge fdb get `mac_get $h2` br br0 | grep -q blackhole

>         check_err $? "test_blackhole_fdb: No blackhole FDB entry found"
> 
>         tcpdump_start $h2
>         $MZ $h1 -q -t udp -a $h1 -b $h2
>         tcpdump_stop
>         tcpdump_show | grep -q udp
>         check_fail $? "test_blackhole_fdb: packet seen with blackhole fdb
> entry"
>         tcpdump_cleanup

The tcpdump filter is not specific enough. It can catch other UDP
packets (e.g., multicast) being received by $h2. Anyway, to be sure the
feature works as expected we need to make sure that the packets are not
even egressing $swp2. Checking that they are not received by $h2 is not
enough. See this (untested) suggestion [1] that uses a tc filter on the
egress of $swp2.

> 
>         bridge fdb del `mac_get $h2` dev br0 blackhole
>         bridge fdb show dev br0 | grep -q "blackhole"
>         check_fail $? "test_blackhole_fdb: Blackhole FDB entry not deleted"
> 
>         tcpdump_start $h2
>         $MZ $h1 -q -t udp -a $h1 -b $h2
>         tcpdump_stop
>         tcpdump_show | grep -q udp
>         check_err $? "test_blackhole_fdb: No packet seen after removing
> blackhole FDB entry"
>         tcpdump_cleanup
> 
>         log_test "Blackhole FDB entry test"
> }
> 
> the setup is simple and is the same as in bridge_sticky_fdb.sh.
> 
> Does the test look sound or is there obvious mistakes?

[1]
blackhole_fdb()
{
	RET=0

	tc filter add dev $swp2 egress protocol ip pref 1 handle 1 flower \
		dst_ip 192.0.2.2 ip_proto udp dst_port 12345 action pass

	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q

	tc_check_packets "dev $swp2 egress" 1 1
	check_err $? "Packet not seen on egress before adding blackhole entry"

	bridge fdb add `mac_get $h2` dev br0 blackhole
	bridge fdb get `mac_get $h2` br br0 | grep -q blackhole
	check_err $? "Blackhole entry not found"

	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q

	tc_check_packets "dev $swp2 egress" 1 1
	check_err $? "Packet seen on egress after adding blackhole entry"

	# Check blackhole entries can be replaced.
	bridge fdb replace `mac_get $h2` dev $swp2 master static
	bridge fdb get `mac_get $h2` br br0 | grep -q blackhole
	check_fail $? "Blackhole entry found after replacement"

	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q

	tc_check_packets "dev $swp2 egress" 1 2
	check_err $? "Packet not seen on egress after replacing blackhole entry"

	bridge fdb del `mac_get $h2` dev $swp2 master static
	tc filter del dev $swp2 egress protocol ip pref 1 handle 1 flower

	log_test "Blackhole FDB entry"
}
