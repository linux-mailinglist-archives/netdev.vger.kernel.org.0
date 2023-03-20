Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E18F6C0C6B
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 09:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjCTIpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 04:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjCTIpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 04:45:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3B726B3;
        Mon, 20 Mar 2023 01:44:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIy01UiGmgosPuAckLAcB679R7cy5TKFxVjHXQ0ZuoPtYqP4L666Qxgfkwk9j9TjB1eAMGiJ1CZz2uhxe234hMQWG1c+UP/uS0oYBtXHZbBRMSauIr+Uj/6uOyhXsSFQ85Eg/RyKFXZ+/O2WkMZ9fXyjbkp7CGfOXgqkKQUJL5LDP3csdheq6SwIx1cAXOhRaPxhunTsZkFh5xe9pq05fUw0RMR6x9z9XpyonTDMN4I/EVrFQq9R0YOEbgjqp29tf6HVCYHDfalISNI5nnqCgsPdKsUjHjaTMT+z0lLjyoNpkT+NbFB+Kk+Ogz+I2QRDIfXna+bCyol9bsDiLG2/mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNHsRfmOCpTOUJJ3RortJNyQmr3iYJrRJ6vNvwZYvpo=;
 b=bcQl3M4bthcpozpwqgpIv57t2FrbMg/0e4OnBqKYKiU5tF2ZlLvJcUTfBLE78LApMz9lHQG8sI1yh5jnqgDDzn9ursdasi0rJuOmK9OCHDbQYxi+oug8NhiK5RTnqf5W1hCW84HCCWTfcBILaDl7zF/BI/UoqauneyOh2vqrkUN5kee6j8jWzHyqQQbvP1DXDDAJWP/C1vUL10q4QFmxgA90YwLLUvD68vTfg/zRHyAEwCJr4WWMRmaG7q98xLyHzYpJIePbMPJhjvHc6e0s3i28IvxvoeQsWWHhhz7lvBN0ONYj+cGjNlu81T24VnG7VKyjoXLDEVL5UTOOc2DKKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNHsRfmOCpTOUJJ3RortJNyQmr3iYJrRJ6vNvwZYvpo=;
 b=o1xXadDApB5d05IJmgInzmpNSAxPLlNxGU+TfY4tfDsukX8TsB93whV5JKrwxXvwqJjzrzkbj3h3mX0wLurgbjvDZ/rm0Cq2dSseLGZ6VnqyzG4RQ0t1tnJ8HA/YdaV4B8EkkCfduyVvxOujvJsIsVTdjFQVc27vEB5zHBV+k7RsGajBT1H9zv9pCv68wNDWgmtyTbFReDY8qQSO/wJwXH2cSfyMthON12ztjvTvm6oNt5EtbVvUpoqUQTToymi/gxl0sAvJXquM/CUIprO+mLxkDssQ+N4+4CQSWoYjiAo4Y1hAy4HWsWKOYu84bCoJL7Sbv5H2bXA7mvfCu0Ztqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB8531.namprd12.prod.outlook.com (2603:10b6:610:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 08:44:57 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 08:44:57 +0000
Date:   Mon, 20 Mar 2023 10:44:50 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 6/6] selftests: forwarding: add dynamic FDB
 test
Message-ID: <ZBgdAo8mxwnl+pEE@shredder>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-7-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230318141010.513424-7-netdev@kapio-technology.com>
X-ClientProxiedBy: LO2P265CA0087.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH0PR12MB8531:EE_
X-MS-Office365-Filtering-Correlation-Id: b9cc5b87-968a-4ed7-1e27-08db291f61dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYoQC0SxTlxaBHxscBGAyrcTfQ/OlGDQmapvCINoJmoeCfKgxU1yU/DUAmPVJakh6Mf3Mgu7n49D2EbqNhGOV0cPJ4r9S4Zd1vgGJu5oriYMGip+/FXts5NLnQt7QqdmY4H96yJDDF3Bd+mGgQD4HkVJkT/pYiWrze+apMMvD49fqT9By6eA0WZ05NVhEnOpZgc9UVYH0clyEFSMOleTRiKoIBeaaj4JYBzd0dfX+ef2EtWS8QJe3eQeBgCLzjOP07HzA7xJDkuJLWr9I2E7X+CULbV2W7KFcdAQ7dikqgFNkoAaPbvv+SGPHUvQ6r+bYGR7t2e5G00TAsHQNC6i1X60I1LczHxfkMHwwiR1cmaehhrdZizAHF2lqVCXAjRr3zPr9Ba4u+1E/JsvPLemXyqXg1lJellPsC10R2rp11lJrjJn0IBiaUC8qG9HgSFoIXl2acnMLo521fQTrMNOAYDbwq39qT7Yx7IwjiYrAioVpWHU83G418KfDFVrxM+Z22Ed1nqxUYltm5Tkzbyfdw3m3q68bxMxJrQuwQrMOhsVVHIOjaOcrd+fS0PbpBfM22Yb33soAEcHlyZZwpK3xhwzPzwTtNhTq7QL/N9sfCnqnT36o+b1g1fBF+Y1fSjhgecgqQGUUD1Idsq06ZDei7e2R25J32T3IUx0UZzXsL2BbJLZ6LtAjkcxkO5FpRdn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199018)(316002)(54906003)(6666004)(38100700002)(66946007)(6916009)(8676002)(4326008)(478600001)(66476007)(66556008)(2906002)(6486002)(41300700001)(186003)(26005)(86362001)(6512007)(8936002)(9686003)(6506007)(83380400001)(33716001)(5660300002)(7416002)(7406005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IKetyVk8zcyac8H0S29+lnJnYYD3ofwYNB7uP4H3QxFj3KqwxU+z4eq2GUuR?=
 =?us-ascii?Q?BKQK/ZCCVMRx+V1JED1yg8b5iC5PCosHS+3S+v3VMR85JoJioQ7XpABAIaYA?=
 =?us-ascii?Q?jW5lRwLdMhcjou49j4Ovy/hj9GUXGHL2rbfCDxnXSNYVieux/I++k3W5zmtU?=
 =?us-ascii?Q?GSC0SIh5zclQS2aOdwAkas5aFttUtDzl1FvAz+qFk4snv8fSfsbbv6JaondD?=
 =?us-ascii?Q?6l2YjmowmiRqqDCAgBlWpVhmkw0PqTFpiox1wiFf1IriTZUA84kNvt1J/MpS?=
 =?us-ascii?Q?H+15RVs9CRC6O+C/4yrZ/jWs2i3v27CyeWDbB5t9PBA7fAlmt9Ainv2G0RWw?=
 =?us-ascii?Q?SeBdMyQ70zUujFdUSqOdFIwvWll76mTNQjbjyMR4oFoU9edPf2KBO5EceTSH?=
 =?us-ascii?Q?mc7Q3OQT99RVGHkL74+k2tX957aKFyaEbRUxUJ7AXXV+kvpTi44jKx5n02ld?=
 =?us-ascii?Q?4fUcNqot5dpfLS2sNP5ynNUNFjs2qNqHRBLzGQvhxX89VQkx7k7Bm15EtCSR?=
 =?us-ascii?Q?gViYKBJgDszUsEWTspZ5GR11q5WaaLIhQP+fcR0iDR43xWwv3Gy68aTVrSFk?=
 =?us-ascii?Q?6pFEY5KEqW+hxPUQ9CfJB1ecyCk059Wh/zUgyZ06QlJT7U5ac8zyzNcqkL66?=
 =?us-ascii?Q?weu671pYLybps8ezb/4pslEr8i7ygkPxHGQszyufpQ/lf8m+Z8a/k3Vgjrhh?=
 =?us-ascii?Q?5RQRNzj5g0ol/EtVBwYXXRupgBZtbxlpdCVlp6UI9qwY58iBnQKqqxrMZFL0?=
 =?us-ascii?Q?DpSRKz2ic0i+abgp7sRal8O1FP41lytXfXNNM9/orflOsi7pxUmMfvjtITO6?=
 =?us-ascii?Q?YA2Q5UhkAh7o6o1nsNiZs8d/bVniQVEv008AnnUDADDpojhrOTsQqUJxfzNH?=
 =?us-ascii?Q?FjShJdPqe0dYkCzUp1mlQ9JYj8n8OOMoXouJrHwpAuyz62lxWlYL32BXGv/O?=
 =?us-ascii?Q?18R4hJO9bvmPyzGT+cYlvhaaqmfilzgdIPzBo0hpyQ3YOpCWH6XJCE39RC+G?=
 =?us-ascii?Q?Pb6Tgv8G57myWFGDWRJiHZXD4q9rirRU+/8kSu1rnvDLu7R+ZU+gqLjlYuWt?=
 =?us-ascii?Q?6/QwB8h1eJvY5dZgJDrvCRCPqLFi/WQazy8UU21ckuX84BOZrBd0OE5iL57+?=
 =?us-ascii?Q?d3jeij/Dfvvqk1noLBtrXxi0ysgE0Os2xX1ZdjIAOBbrhtKBrkpw0eiKqHcc?=
 =?us-ascii?Q?qQ1wTJRXB3/X96D8T0NlrgJTkP2slk/FP+6uKb2EpkBrDKtPZIj16Efdo1T9?=
 =?us-ascii?Q?ks3GMAXCsfco6usXb1OzBv2au3KLdcxzuEnPGXdcZXJudoiG3C4cKOqVZRks?=
 =?us-ascii?Q?tZCcR+oisiAkEz8c43HUCsTZl8JxwlcczicNI1mI6fhW0lS1kbDbsPoWTEZI?=
 =?us-ascii?Q?rLfnxqHCI4QQFo1oOTMC0JuDHJFzfWyUqQ8psukLavweOQ6QxIUrmDoc3c83?=
 =?us-ascii?Q?sC2oTeQnNt1HBwS6fx7IJa658q9s31MPpBXD6MhiNe8jIxAyxQyoELCnRRsr?=
 =?us-ascii?Q?f1sjo+0JvUv4WhI+V43WpoG3OBa4GJ2JWDi70X0Log/AxI1KpYX0+HZC6yR6?=
 =?us-ascii?Q?rp90rzW8Tt8oq7bd/w6mSGb7IC5R2tN9cYLoM2MC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9cc5b87-968a-4ed7-1e27-08db291f61dc
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 08:44:56.8409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GIA23Qtqed83+/XulBUn4FGcAiOHHBDE1UqUAoik/rxLo1pe+yVrTZT/o0lwoZu8ja0yUOW7E1pheVvMDDnwJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8531
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 18, 2023 at 03:10:10PM +0100, Hans J. Schultz wrote:
> +# Test of dynamic FDB entries.
> +locked_port_dyn_fdb()
> +{
> +	local mac=00:01:02:03:04:05
> +	local ageing_time
> +
> +	RET=0
> +	ageing_time=$(bridge_ageing_time_get br0)
> +	tc qdisc add dev $swp2 clsact
> +	ip link set dev br0 type bridge ageing_time $LOW_AGEING_TIME
> +	bridge link set dev $swp1 learning on locked on
> +
> +	bridge fdb replace $mac dev $swp1 master dynamic
> +	tc filter add dev $swp2 egress protocol ip pref 1 handle 1 flower \
> +		dst_ip 192.0.2.2 ip_proto udp dst_port 12345 action pass
> +
> +	$MZ $swp1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
> +		-a $mac -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q

Packets should be injected via $h1, not $swp1. See other test cases in
this file.

> +	tc_check_packets "dev $swp2 egress" 1 1
> +	check_err $? "Packet not seen on egress after adding dynamic FDB"

Does this actually work? The packet is transmitted via $swp1, I don't
understand how it can arrive at the egress of $swp2.

> +
> +	sleep $((LOW_AGEING_TIME / 100 + 10))
> +
> +	$MZ $swp1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
> +		-a $mac -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
> +	tc_check_packets "dev $swp2 egress" 1 1
> +	check_fail $? "Dynamic FDB entry did not age out"

Shouldn't this be check_err()? After the FDB entry was aged you want to
make sure that packets received via $swp1 with SMAC being $mac are no
longer forwarded by the bridge.

Also, I suggest executing 'bridge fdb get' to make sure the entry is no
longer present in the bridge FDB.

> +
> +	ip link set dev br0 type bridge ageing_time $ageing_time
> +	bridge link set dev $swp1 learning off locked off
> +	tc qdisc del dev $swp2 clsact
> +
> +	log_test "Locked port dyn FDB"
> +}
> +
>  trap cleanup EXIT
>  
>  setup_prepare
> -- 
> 2.34.1
> 
