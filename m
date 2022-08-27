Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D655A3970
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 20:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiH0SWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 14:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH0SWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 14:22:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EA47EFC0;
        Sat, 27 Aug 2022 11:22:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ewo7ppF0vzy5D8xBeg1aE/obwyGSWE81Dbjpbxn+uJoya4olvgmEB0Hmpp0tvXaO54KJbf9BeXtBkWqv5YXxRPJ9ugurfBP574wXPtD+lCrWtQcdu04fMrBnNwSZ1y4f8DRpmqn4SGeMrgN9W3hRpheCN1XyQzYcPQbJrbr9RqMZlC5s1SkP/FfHMsChZJhc54PMMVbpALgxzGJ8riSIY9F4ykXsvwCe9A1aCP/djwzBHYadsKDxsVF7QOAzTX6qIjbwJSBm5mpydR6G04kckVYm/Y3dHiLzK5jAnihJ0kOPmRkKcZat1d1rATCbs1U+GP9HxBGw1gmveF81ywrm/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qydGxQSqpZ6GetVPeC2IuOqyVuL9vwfb0MkvjQX6/g=;
 b=T/p1b1PA4iMB3UW5b1XwGEptxdGrfPlQQ1EQ3uzTbzv4mzsdJYezORF+LTot3m/+edKiCSvWeI0GJPbCpl0EmBOX5Az7o8fordDBxwU82Mv+MvQ78Qa8EqVgdmgzsDLRuLp7/qYPzmGd5bH9MMFxYBx2eMibtYrGrjFimzWOlXuU4Ajzm8byHH1R3uajqtkdaDBhD6cwRTPeGItR0L2QjknUGQH1yFn2fL+t4KeTSgsNmLuBHg3KCvcQxcztMoev718geDiA4OfHTuo+G8h/XZsynTrpVjsmnvlf8VcIorWEcYvVIPVqk0ok4h2WwmKfJ6A0/ySnfSgUdO86/fouTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qydGxQSqpZ6GetVPeC2IuOqyVuL9vwfb0MkvjQX6/g=;
 b=t2FHPb3/P0xuvz4ENKTVu9EvOnvjwZ6nOFux7hdyD3HXjO85+haQoWAYWtVbvvFx8n8r3FX+9Ck2o0WxEfDdKHsIUgaXAS0tZRGI7pq64bEbRFro8264/gB9fHP64KBqGHHPEiiPNfiOmRvxG0TmHAY2nvEHRA68RsDxLpu1WgbEMY8h1okJTi4k/HnI4dfGCzGDMg4CbxSuqoJdjz5GJKpQ4FnGYzvFrh+DwvOIbSbWmjauKsb+DL1HIY3q5pHXqZuW77+1FIEyvVDklebJgQ4Wm2ZfwzOgE/GalFQc2Y56FV/O8MM/P8ogQRiFgZIf0dFlDybRvDvx9S2EHPbXsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by BN6PR12MB1300.namprd12.prod.outlook.com (2603:10b6:404:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Sat, 27 Aug
 2022 18:21:58 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Sat, 27 Aug 2022
 18:21:57 +0000
Date:   Sat, 27 Aug 2022 21:21:50 +0300
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
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <YwpgvkojEdytzCAB@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-7-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826114538.705433-7-netdev@kapio-technology.com>
X-ClientProxiedBy: VI1P194CA0034.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::23) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d3c5ac1-dbcd-4063-23d5-08da885906a0
X-MS-TrafficTypeDiagnostic: BN6PR12MB1300:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +/kO5VUKuam35uKdBco8RV5il9R/L4kimP7MswcXFnB7xTQJjtug/gHps8exLd48VQ2wQLsYdh/IqKapDI+xYLdUO0my+kzZez4AP16JRC6NXSjHggwBUtZXYwgsmH1I2TB4VS/W1hRX1d2dpFmXYgOtyZo7kZtqixJyKH/cGLHnSBCZNMVvShh0KftT0fTMkaVocym7L2918vR2QJsR2Y8h1C5s4z7OhnzAO3AcYvz7cGqgKZ+y1YxA5r1ytHmHb4hkiUfMb3JtRVIi6c4R9QmbdiGHoqpnXximydvnq4Zi4XSCf0+/aGzjAgF4zU+sg5Akp7jP0ObqNjzCkeG3fubdO/0nCHAahq+HyjxFbmv5vo4rFconhzRrCp78ybQ4RSppEnMomQ8yj9rKb4jH68+EOKTEjQjz93wsqGIqjUvNztXWBT9aOs9T6u8uspZGfA18iNZ0SZeiSaXODao8rySEX3J54gQl6vggIqSytsa+FsQWE483h8cy4flXBY4N4QPICsyxvmhtnwb2WStsF4XHtHmnPWXjF7YTa2EalfO04W+CfzicfLb4DMCD9wecNjSHBRKszv2Wj2lPkpxnjroa0vX4m18gHsk4K+JlnFB/VIFy1SvsoSl0867vjJ69Ve+/VnMyNKhBxMGto1bist+QMOoO9NmceE47lQnwXM3kx5Z8iVc2D6iTFXGnmD7FBee/519RTPYKLAMhCUhLUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(346002)(376002)(396003)(136003)(39860400002)(478600001)(41300700001)(6486002)(6916009)(316002)(83380400001)(54906003)(186003)(6506007)(66476007)(86362001)(6512007)(33716001)(38100700002)(26005)(9686003)(7406005)(66556008)(8676002)(8936002)(7416002)(5660300002)(2906002)(6666004)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?goZrBipmLOCYbsvfqrQruQYXc75MmDfBC9H2WTFrqvkwwClrQz44btlaH6Qz?=
 =?us-ascii?Q?OaAgbhcMSP7+CuEfk+FZniU12JaVlKUBf1IO5GNb48eiXLhDajj75D88say4?=
 =?us-ascii?Q?9hErh6Luhzi8FK313jzqL1bMtbnCXJwQrVz9xIIzAcIQYDoUoT/Zeo/Y8iZ0?=
 =?us-ascii?Q?G7U0zmlZq0JRQCO29NJqhQHWGQ5Vci9UszP55/CWdTCSNkcv0P9aofY3ssmW?=
 =?us-ascii?Q?kIYg3eR2RtVRqzszNjsdnmU3dEN6+ikXF1M1qdSvV4XkmxMmbSN9jQsvkDWM?=
 =?us-ascii?Q?3u6P7Y80Gm2isg/hII3dr2xhRt93QeoApxBmZyWDfNGaVSJQHe0xm1yC28jK?=
 =?us-ascii?Q?tRurI2xyWNVDUPQzjGvKGGgx4OYDB/z1sQPbcPgLRlNtff35jhZKBTTT91x/?=
 =?us-ascii?Q?nv/CZsrlcr6CWwnDYyMrdV9oZuFqnDNCKHxCq7gHe+Xw/OPfB7UQTH6Qbjn2?=
 =?us-ascii?Q?bUe/G3oWCarY48FILOwxAVGAKdAqs3/YDSwG2tp8RlWxEY8qjCm73heIauJd?=
 =?us-ascii?Q?hAh96o7rALToeMikM2Bl4FzrgG/zNZA32gaSumJGGR4+ipDqNZVbpDtk+Xu0?=
 =?us-ascii?Q?LV1b0P9DjkeiS1rje8HgepxAElCNT/QQgc9OCQOUK/oifeVr3LqAvlhJjuHQ?=
 =?us-ascii?Q?sEWmT73tgDjpWXCx48grMgmzKBFC5pRtG/8Ets00BEdeW5abeYnxzhECzG3c?=
 =?us-ascii?Q?uc+bAnnx/s6lFYq295HMBqctO4bjqQ8Bi4RCYdzP/E5AbQsSgnKIrReXLnJn?=
 =?us-ascii?Q?NmEDO+gXHf2lyzXeO4+hRYRBbW7XhfzqcSXdVDbiCKCFSJd34E4W2bIEcqlM?=
 =?us-ascii?Q?LIztY3tEkRJlLWfUAj/L77bjegLCSzUY1xsOnQdYv41s9+hNBwQjmxW5fnR1?=
 =?us-ascii?Q?JRXqAHdKlKigfUsLKwr1ClS76J+DhH9iZ3l1vM5j8hy3OtpDsG4X1AKPGHyI?=
 =?us-ascii?Q?CDaMH6irJEvUHCVJuI8I3Ei3xRFl6sl/rMeOWNcrwX+ILoydSiLrFBE+jckS?=
 =?us-ascii?Q?2sveRsD4PdzCU0h8q7FowxZ9RNdTN8zJfSsjNcHCTt6jUsBbKIvJWdJuFTaO?=
 =?us-ascii?Q?udgBqLA37X8pojpOHalaaJlzDgLcPgFWvYsC20906t7mFstkWPpxS4NHn6rC?=
 =?us-ascii?Q?M5wDvSOlQ1/vtJQibC72VmVVev3AiX689tmDFCv8jSIb6sHD8gkY9SXo60fj?=
 =?us-ascii?Q?jMzId8rNNIk/5BgzVlG46Jfv7smo1vVUudl7ELXeSatE8WIu5VhlQXNhbR8i?=
 =?us-ascii?Q?fl50WNEZfWUkYiDxArqJTwoFdck25ZDQH1/6eeYhL6nFAQhk3+6gZmBJGBla?=
 =?us-ascii?Q?CCUHsIOVNpSNLN0U3DjW1uODVohVuj9dcvmnR0StxNP4Z45wD9glN+0JUyrH?=
 =?us-ascii?Q?2xtlhuHrRVB+KZagn5k9njKNBiT3zsyqt16YDWVz4VPEci7SibFeUE7PQb9S?=
 =?us-ascii?Q?PprgXLPGo8qJewECdTsuobt7w5iDKCW/MotbW+LftV8VKIacOcvrzuwmE5N8?=
 =?us-ascii?Q?DZSSt6PSmfqogEP3nnO8yx+TMpL83X7/SZn9CMEZlUAbGqYhCCGKImAheAiq?=
 =?us-ascii?Q?znDaL4bRwfz2kccugeDOfEcG/PGtRULr2BeiWDFq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3c5ac1-dbcd-4063-23d5-08da885906a0
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2022 18:21:57.4720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CwM9nFxh0pG2pkowscrkNWgLAdX5BkoDC7drD5Xr8tekRmRRYbB3+huusU8tgwdrinIz0A+MsxZRUqcmPwmrPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1300
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 01:45:38PM +0200, Hans Schultz wrote:
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
> @@ -166,6 +174,103 @@ locked_port_ipv6()
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
> +	bridge link set dev $swp1 learning on

"locked on learning on" is counter intuitive and IMO very much a
misconfiguration that we should have disallowed when the "locked" option
was introduced. It is my understanding that the only reason we are even
talking about it is because mv88e6xxx needs it for MAB for some reason.
Please avoid leaking this implementation detail to user space and
instead use the "MAB" flag to enable learning if you need it in
mv88e6xxx.

> +	if ! bridge link set dev $swp1 mab on 2>/dev/null; then
> +		echo "SKIP: iproute2 too old; MacAuth feature not supported."
> +		return $ksft_skip
> +	fi

Please add a similar function to check_locked_port_support() and invoke
it next to it.

> +
> +	ping_do $h1 192.0.2.2
> +	check_fail $? "MAB: Ping worked on locked port without FDB entry"
> +
> +	bridge fdb show | grep `mac_get $h1` | grep -q "locked"
> +	check_err $? "MAB: No locked fdb entry after ping on locked port"
> +
> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
> +
> +	ping_do $h1 192.0.2.2
> +	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
> +
> +	bridge fdb del `mac_get $h1` dev $swp1 master

Missing:

bridge link set dev $swp1 mab off

> +	bridge link set dev $swp1 learning off

Can be removed assuming we get rid of "learning on" above.

> +	bridge link set dev $swp1 locked off
> +
> +	log_test "Locked port MAB"
> +}
> +
> +# No roaming allowed to a simple locked port
> +locked_port_station_move()
> +{
> +	local mac=a0:b0:c0:c0:b0:a0
> +
> +	RET=0
> +	check_locked_port_support || return 0
> +
> +	bridge link set dev $swp1 locked on
> +	bridge link set dev $swp1 learning on

Same comment as above. 

> +
> +	$MZ $h1 -q -t udp -a $mac -b rand
> +	bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0"
> +	check_fail $? "Locked port station move: FDB entry on first injection"
> +
> +	$MZ $h2 -q -t udp -a $mac -b rand
> +	bridge fdb show dev $swp2 | grep -q "$mac vlan 1 master br0"
> +	check_err $? "Locked port station move: Entry not found on unlocked port"

Looks like this is going to fail with offloaded data path as according
to fdb_print_flags() in iproute2 both the "extern_learn" and "offload"
flags will be printed before "master".

I suggest using "bridge fdb get" instead (didn't test, might need small
tweaks, but you will figure it):

bridge fdb get $mac br br0 vlan 1 master 2> /dev/null | grep -q "$swp2"

Same in other places where "bridge fdb show" is used.

> +
> +	$MZ $h1 -q -t udp -a $mac -b rand
> +	bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0"
> +	check_fail $? "Locked port station move: entry roamed to locked port"

Missing:

bridge link set dev $swp1 locked off
bridge fdb del $mac dev $swp1 master vlan 1

> +
> +	log_test "Locked port station move"
> +}
> +
> +# Roaming to and from a MAB enabled port should work if sticky flag is not set
> +locked_port_mab_station_move()
> +{
> +	local mac=10:20:30:30:20:10
> +
> +	RET=0
> +	check_locked_port_support || return 0
> +
> +	bridge link set dev $swp1 locked on
> +	bridge link set dev $swp1 learning on

Same comment as above.

> +	if ! bridge link set dev $swp1 mab on 2>/dev/null; then

Same comment as above.

> +		echo "SKIP: iproute2 too old; MacAuth feature not supported."
> +		return $ksft_skip
> +	fi
> +
> +	$MZ $h1 -q -t udp -a $mac -b rand
> +	if bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0" | grep -q sticky; then

Will need to change to "permanent" instead of "sticky".

> +		echo "SKIP: Roaming not possible with sticky flag, run sticky flag roaming test"
> +		return $ksft_skip

Missing cleanup before the return.

> +	fi
> +
> +	bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 locked"
> +	check_err $? "MAB station move: no locked entry on first injection"
> +
> +	$MZ $h2 -q -t udp -a $mac -b rand
> +	bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 locked"
> +	check_fail $? "MAB station move: locked entry did not move"
> +
> +	bridge fdb show dev $swp2 | grep -q "$mac vlan 1 master br0"

Need to check that it does not roam with the "locked" flag set.

> +	check_err $? "MAB station move: roamed entry not found"
> +
> +	$MZ $h1 -q -t udp -a $mac -b rand
> +	bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 locked"
> +	check_err $? "MAB station move: entry did not roam back to locked port"

This will need to change to "check_fail" assuming we don't allow roaming
from an authorized port to an unauthorized port, which I believe makes
sense.

> +

Missing cleanup.

> +	log_test "Locked port MAB station move"
> +}
> +
>  trap cleanup EXIT
>  
>  setup_prepare
