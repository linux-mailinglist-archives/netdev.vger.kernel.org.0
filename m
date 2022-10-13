Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F6B5FD665
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 10:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJMIo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 04:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiJMIoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 04:44:54 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359D61276F;
        Thu, 13 Oct 2022 01:44:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bc4xkTn7+Cd0mGS4tejOAX9zcyebmPiPTEcxSvLekw1JFBkw4ZFlmRQh7orZHjQ06uYB2MMESl57+9bJDe3wyzsG/7qXXswM9wxzCQZW368+d2dZicWkcU1Q9h9cXaotGrcIfeMpqSZSKwk/ZtCkXEg5xOzTjnZ3FzzVfxtkD6ten5b8l4wGR4bla7JwWMPq9iZmaw/OmyGVsr/aakgZgU69jQvwINnjKGx0OS/3N65gxQjVFpyMP0PKz2C3c0mgB43u6+BEs4lh8lZ5tuwJ7mnK5m0YDW+l5M+fEh7+mxdVpH9kmwoRZzcm6X176+uO2Yl2ZzueLWLQEf3EQOAdFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vm9/KTjbCKMw2MlqSb0+dmxN5eog0LXtAS5rSkM1mgI=;
 b=Hlt2goZi26a1bukwl1II4RF8IC/55SQBs4m6EtsbOh6oE4lPDsuASPMdAKYRZZzfpqi5IBWSDe2fMvOmxLSO5dUdizhaS9idS58EVNtPRBFC7rUOfBhRuHfWopf9hD5zOob+qTut3QVItTaBIFSDSJuaZl8cQX8wT5pmBOJjTaD+HN+WmcX/gxImCfqP0S5uHBuidujiHttX2zoHDuNfUDcAzYGEHEItmIqrnFKgyIg4B2+NZabDoHMyN8L7Ece4+YZuIqwOQeXgoLPzAY6+h/Uxy+GAF5HYsRHWDJJ7KADb8gdemsg5vmYSHv4HmUj9to+n7VA+VtjYp2H+QakQvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vm9/KTjbCKMw2MlqSb0+dmxN5eog0LXtAS5rSkM1mgI=;
 b=StpekHpYvb/TZn/r60gcQV0bH0K6XMFSPKYiAPxTI8l24pS8gn/ArqTKeIFDRPfR3/uQTo0EaZfiiH1vvYUn58KRq4Iukqv7Wd0lLjRJGDeWKcYQP7DasEAUyAC1vpYFnZtX54mUYo8/wZqP/piMVEJzdxiaIpv62O4fHXo9PEUoDSSnCVenV1B85PjmtmN172rTwTnPFnms7zvnJEpnWY0LWjrk8oSvPofXtlDUHAQROllgryrL0JJpQ+G8irqQk1eeuVn5jojPGGaTOKmJwLeyvRqOm8bCiyjhAQiyNwZVlT+DCHO/o0RvaL7jKfmamNY81Ifn8azByQQw768VZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB7519.namprd12.prod.outlook.com (2603:10b6:208:418::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Thu, 13 Oct
 2022 08:44:50 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%6]) with mapi id 15.20.5676.031; Thu, 13 Oct 2022
 08:44:50 +0000
Date:   Thu, 13 Oct 2022 11:44:43 +0300
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
Subject: Re: [PATCH v2 iproute2-next 4/4] bridge: fdb: enable FDB blackhole
 feature
Message-ID: <Y0fP+9C0tE7P2xyK@shredder>
References: <20221004152036.7848-1-netdev@kapio-technology.com>
 <20221004152036.7848-4-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004152036.7848-4-netdev@kapio-technology.com>
X-ClientProxiedBy: VI1P189CA0033.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::46) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB7519:EE_
X-MS-Office365-Filtering-Correlation-Id: a0a5b7c5-96f5-453b-7962-08daacf73090
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HI6fe5yqP8+spy9tV0ESpdm1aUbO1iOrVo/Fb5keEpB4lVuF84Ec7Cn2nIMbDXj+cB33oIWp/ATzEUme8LLe+c1qc+PM6Y4hb0G9bPqZSild5O4t6g9ob3nrllQZHiA7Fg0IFP/Qe31NnpXvxvcIbad6E09jevNieHzzo5pARpFs2uk2J45FlQg51ZRvYVqHayOVz1n0TUdGH94M+1Cb3co8aoQ4nzuhLIL060xMnfv0PeF5QUZdWa1FRGltUw4XW1lDSAg6vvRZWV8p4w3c6Goei6UIYB8NiJrFRhFBMp2qDdHPzIDC3S9rXg2EMbd5ZtJ3G3CUe/QkcacW064PPLArA+POMYUZj6KeRn1zh7g0YL5aWlxMqvzwHAxN6Sd7ApF/Hx3O1tg3knm5PHZjnMlFL7aX4caMG8VRG7Rqups0JI4GukKPkz0lttQ/WeQU5r9wgg5Dixx0GE9ON33suv8k9EFsMMSv4ow09bt3dAlhpZ2GOKF19fVtF3Q4p/PP8BPKrFzuQJZ3fl3AfjgoeqzenZbROHBMPGZvbSxaU1JovUGfuKChX72I3McpWKu56Pk1gx4NiglmnRYqHE0w/PRTcjs2rTIWvMyNoWoVZ+YkVwrWCzrG3blMQsbIPuVcaQcCQPodlJr70Cgv4oNACzJ0d5pJGiW28RKobg57w+H6W1QuV4RMD1z+ZujQ9iexfxzOVKKpERMVSRmdWiL9++4UIAJJdbbUGw04Lpp0lJRf51KT4rSN3gKEXiCekJj0PTpySAe4Z1sijKlOJDV3WRXgGr50wJfCOqHTL5KcbMnw57wxwNPWzAvve4IJBYTYepiIEgewvzNCCyfTNxLzyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199015)(186003)(966005)(7416002)(7406005)(38100700002)(6486002)(5660300002)(478600001)(54906003)(6916009)(8936002)(316002)(83380400001)(2906002)(26005)(9686003)(33716001)(6512007)(6666004)(66946007)(8676002)(66556008)(66476007)(6506007)(66574015)(86362001)(4326008)(41300700001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UAdF8GBTJ6OjxSjQTWvcb55hUt89GyanXowbugJAF18JJqiLmACdDlLtVkF7?=
 =?us-ascii?Q?TGf/U/Eu+JAxgAIget/PpeX0ND8UayZR5VnTOmzFTIPGJ5lkLab4UGI6cyfo?=
 =?us-ascii?Q?5hDafsPte6XDgDEE1nuEbUhY9q5Yy04PPRwWzfr0c0RihlI33EKY3SMSLf28?=
 =?us-ascii?Q?20qUye0PiQPyQ3rcMwbErd6W9QXreYSvXcqX42lL+TTOVDEBL275MSAf5nLc?=
 =?us-ascii?Q?2CZbj4NYIZ6kbngU3xsbf3B814zHJ0fP8MyOGOw4Ue4tJwoItcKCm4Vyhbg3?=
 =?us-ascii?Q?11whYq0rWOaqwEeAgD0bKYDcp3TPs3vXEQYdW6MvMiNyL+wvL9dQX+w/UrnV?=
 =?us-ascii?Q?Up8IAGm3GMi3TedxvL4ist+w49e+Vyq98SRTGzy+tqkUqgLbtgcsr6+PhRZi?=
 =?us-ascii?Q?vOWsF6aaiwY0kjTTvR51EBcBqdqzAWT4LAR7o4/gOP+Rh7gPaIU20pOUa5Mg?=
 =?us-ascii?Q?fmRN9jKP72gY901OQwrsZmuRqgPTPEIBIKZzNTplPUWhgezihjx9V6urxrze?=
 =?us-ascii?Q?IikXgelAeYN0zFaW5xDO0jELCgHGTkcSB3zHCEIa5zCQ7RRwV3R08pEAm2qR?=
 =?us-ascii?Q?TEAKOUTg6azykcT5CDn2zB7P9P/YcbhFPZ+uE6ObC9w0zi9BuUoicap6yICT?=
 =?us-ascii?Q?NczHGNwK9MHUIFIKj20VBTZcp1peLHD86uX7FLSO9NmZCnsjTxvuYgezyXZ3?=
 =?us-ascii?Q?X5bd+x+F0oXc8a9/8VJXL/BrURolHUFfdVZC6lVRnH0sTXKNh+0BwTpKCjCN?=
 =?us-ascii?Q?NDKPYikdgMCVs6qOrXS2h+Tt7lEMmLjHrdqQk1hL5GNWttAyumaS0lkpF8xJ?=
 =?us-ascii?Q?8CyAXFsRT6ok542aRAMOkbAMwHgHHVSDeXXAejct1oX6EQUFLuELBBadIDM7?=
 =?us-ascii?Q?GJeBRVCb4YM6FfTbcrUsYb36YvQbUR5NxOmyOix0Mdv02Q6R5bUFQ0Ykt3KH?=
 =?us-ascii?Q?A7N1ii1st4rbHJYzGhZjYiwUrCduKVwKt9WgKc76AJZdXqJav+luBWkaLQMr?=
 =?us-ascii?Q?PiTAYEdxKDyT39ElJYlPuRmsg62T/ImsY1fwg21N5NrNbvJ+1gpmCgjoWQfu?=
 =?us-ascii?Q?IvNRoDmNz9K/ZK6HxXyLDybP85iKxOmQF11Lg67X4/Wm+DJHvfIhZRsQQeUX?=
 =?us-ascii?Q?qFVAfmNpKsHio+i4jjbLVDj/8zgL6EfnfpIq3Peh8A66Rtp+S+x9GfuNa1mX?=
 =?us-ascii?Q?B3dtK/T42NE8MwiGPnx/il7OPMs8SRsSUEsO15pxCCaj8XDfuSc47EhRfzKT?=
 =?us-ascii?Q?JMqal0kJSXMYRc8/5lNgs8s+u1vSWBWV1crhACAUFnwM/jEOlDOOUfUd0BQd?=
 =?us-ascii?Q?U4dBzWFF6gIJQaJQY/sRHNhJOa1k4nkeYrXMXLtJLw6DMHh05gBMxEQOZGjF?=
 =?us-ascii?Q?ZbXiFyXR98t5H+Hu50VdOLAmkjAIFdru0Ey+t16lWrmvYSpg2PKo3c3is9Ob?=
 =?us-ascii?Q?AMjw4fUN7hVF9oShqhCl7ynU/Z8OnxKiUY+xzVAqKMdIr+qtuv3G0BhJVWjP?=
 =?us-ascii?Q?Z/5k8Tls9xv+TwcWxn0FOguGeyx+OvoP/ENNJG4aWlNNsp6enUWcAPwnB+79?=
 =?us-ascii?Q?ubyvbSpBDJsd61O1UbQMLMnOOx9dGP0NFqv7W7xs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a5b7c5-96f5-453b-7962-08daacf73090
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 08:44:50.0051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47EfwzvU4XGwhpChGOrXtHBeoCKuRnk9HuJOURo9OrXH1mG4r97LNj+Qr6L5E6JrnhTgfCVCq+MPPALaCHZy9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7519
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 05:20:36PM +0200, Hans Schultz wrote:
> Block traffic to a specific host with the command:
> bridge fdb add <MAC> vlan <vid> dev br0 blackhole
> 
> Blackhole FDB entries can be added, deleted and replaced with
> ordinary FDB entries.
> 
> Example with output:
> 
> $ bridge fdb add 10:10:10:10:10:10 dev br0 blackhole
> $ bridge -d fdb show dev br0
> 10:10:10:10:10:10 vlan 1 blackhole master br0 permanent
> 10:10:10:10:10:10 blackhole master br0 permanent
> $ bridge -d -j -p fdb show dev br0
> [ {
>         "mac": "10:10:10:10:10:10",
>         "vlan": 1,
>         "flags": [ "blackhole" ],
>         "master": "br0",
>         "state": "permanent"
>     },{
>         "mac": "10:10:10:10:10:10",
>         "flags": [ "blackhole" ],
>         "master": "br0",
>         "state": "permanent"
>     } ]
> 
> Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
> ---
>  bridge/fdb.c      | 13 ++++++++++++-
>  man/man8/bridge.8 | 12 ++++++++++++
>  2 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/bridge/fdb.c b/bridge/fdb.c
> index f1f0a5bb..1c8c50a8 100644
> --- a/bridge/fdb.c
> +++ b/bridge/fdb.c
> @@ -38,7 +38,7 @@ static void usage(void)
>  	fprintf(stderr,
>  		"Usage: bridge fdb { add | append | del | replace } ADDR dev DEV\n"
>  		"              [ self ] [ master ] [ use ] [ router ] [ extern_learn ]\n"
> -		"              [ sticky ] [ local | static | dynamic ] [ vlan VID ]\n"
> +		"              [ sticky ] [ local | static | dynamic ] [ blackhole ] [ vlan VID ]\n"
>  		"              { [ dst IPADDR ] [ port PORT] [ vni VNI ] | [ nhid NHID ] }\n"
>  		"	       [ via DEV ] [ src_vni VNI ]\n"
>  		"       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ]\n"
> @@ -116,6 +116,9 @@ static void fdb_print_flags(FILE *fp, unsigned int flags, __u8 ext_flags)
>  	if (flags & NTF_STICKY)
>  		print_string(PRINT_ANY, NULL, "%s ", "sticky");
>  
> +	if (ext_flags & NTF_EXT_BLACKHOLE)
> +		print_string(PRINT_ANY, NULL, "%s ", "blackhole");
> +
>  	if (ext_flags & NTF_EXT_LOCKED)
>  		print_string(PRINT_ANY, NULL, "%s ", "locked");
>  
> @@ -421,6 +424,7 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
>  	char *endptr;
>  	short vid = -1;
>  	__u32 nhid = 0;
> +	__u32 ext_flags = 0;
>  
>  	while (argc > 0) {
>  		if (strcmp(*argv, "dev") == 0) {
> @@ -492,6 +496,8 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
>  			req.ndm.ndm_flags |= NTF_EXT_LEARNED;
>  		} else if (matches(*argv, "sticky") == 0) {
>  			req.ndm.ndm_flags |= NTF_STICKY;
> +		} else if (matches(*argv, "blackhole") == 0) {
> +			ext_flags |= NTF_EXT_BLACKHOLE;

The policy seems to be to use strcmp() instead of matches() in new code:

https://lore.kernel.org/netdev/f7251b13-dbf2-f86c-6c2a-2c037b208017@gmail.com/

>  		} else {
>  			if (strcmp(*argv, "to") == 0)
>  				NEXT_ARG();
> @@ -534,6 +540,11 @@ static int fdb_modify(int cmd, int flags, int argc, char **argv)
>  	if (dst_ok)
>  		addattr_l(&req.n, sizeof(req), NDA_DST, &dst.data, dst.bytelen);
>  
> +	if (ext_flags &&
> +	    addattr_l(&req.n, sizeof(req), NDA_FLAGS_EXT, &ext_flags,
> +		      sizeof(ext_flags)) < 0)

addattr32() ?

I will check the kernel patches now. I wouldn't submit a new version to
iproute2-next until the kernel patches are accepted.

> +		return -1;
> +
>  	if (vid >= 0)
>  		addattr16(&req.n, sizeof(req), NDA_VLAN, vid);
>  	if (nhid > 0)
> diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
> index f4f1d807..0119a2a9 100644
> --- a/man/man8/bridge.8
> +++ b/man/man8/bridge.8
> @@ -85,6 +85,13 @@ bridge \- show / manipulate bridge addresses and devices
>  .B nhid
>  .IR NHID " } "
>  
> +.ti -8
> +.BR "bridge fdb" " { " add " | " del " } "
> +.I LLADR
> +.B dev
> +.IR BRDEV " [ "
> +.BR self " ] [ " local " ] [ " blackhole " ] "
> +
>  .ti -8
>  .BR "bridge fdb" " [ [ " show " ] [ "
>  .B br
> @@ -701,6 +708,11 @@ controller learnt dynamic entry. Kernel will not age such an entry.
>  - this entry will not change its port due to learning.
>  .sp
>  
> +.B blackhole
> +- this entry will silently discard all matching packets. The entry must
> +be added as a local permanent entry.
> +.sp
> +
>  .in -8
>  The next command line parameters apply only
>  when the specified device
> -- 
> 2.34.1
> 
