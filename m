Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250B25FDC07
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiJMOHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 10:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiJMOHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:07:14 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2042.outbound.protection.outlook.com [40.107.101.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79816E6F6A;
        Thu, 13 Oct 2022 07:07:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPMUjI0ns2uPIVtjGbKe19uCkgrmmFmhJNNflkjIzjZhHLBdeAYwLpxPdww1qPg3ZKE0T4RfYgXMorXFMvd3zZTK9f8mAXelhOb2yUZ/Ryr3SQqV47t6QPfCmiSybjc/o3OaCUfleFuawMLiOoX5yCC0UEQ19ePzWwVbEYNZM6fezBtjYOnyAnfcnKsT1wuSH2/nnS4GQzyU+8ZeyZbUS81Si+ImvHntBe1rvax0k+MfxdEQiQLQMmhdoIJaF0Iyusew22g4UgSEQA5Qpp+mJyCdR5XsCVIR/RdGYmkxQRqwfKF27YLuW+wZah6KmMSdGXpbfF51Aixh+LeXKD5wAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POSAfKjE6zvEwR6cQjzhYazJSFGO2KOXOP0fthXCztI=;
 b=aJdvCEspNylzM523xeWJkkhYQhqR9JKcF3rtufJz4SfShh4JEquHJVFiqfuP6ugtmwW2xXnJsjCgCW1NKMCENncik7N38zlGUYne37Z8BG4/lTgHcz6XZBcmsRxXlKt93/a2nD15pGFzleOXHU3S3+RujWhtP5R79Y21hwUOFjgPqt7SMSyocS5oNRhLp5wbERrbsavzc5fAIMXEBYlexnHUfxkpbG+onWOS8wCTE1WFuc8xQegfz/ImksjqCP6TJWIpv9vPman8YKuhAeMICkk1El57hixdLksuipcRHvWFJ4Mh5bkzUQ7FQqmgH0t5APaSQgASjf54F4WpWlP/dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POSAfKjE6zvEwR6cQjzhYazJSFGO2KOXOP0fthXCztI=;
 b=SpEq/wM7GtG+vnE+fphKp/Q8i6x0+MjbvL9EC7LF67abwXgXO6VNi5lK1Dqv1icpwy0Jesj7F48rlmvcT/uAN8Cg3ZAK3TuCDG7wlRY0KGWEKU2heYbi2SlQqbrRXuJjJxOu7CHaF+OULmEL30DDhNWlGhAFlfMaxRM+nUItLZ3erP4OlemkrrkGcH/9Sur8yeH8N/Q4V7e07vTW6E2YaH06AzdlBta4a60QwzD36xUPZCmgR4jr7/QecMqT6XA6i/je4WvRvkhZLx49cmCP2opocDO4sIZJHF42THpHTknmKfj8lb/iWxNWVMGlbAH0xN+Bj1GmO455P3MWsdJ1DA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL3PR12MB6404.namprd12.prod.outlook.com (2603:10b6:208:3b4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 13 Oct
 2022 14:06:21 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%6]) with mapi id 15.20.5676.031; Thu, 13 Oct 2022
 14:06:20 +0000
Date:   Thu, 13 Oct 2022 17:06:14 +0300
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
Subject: Re: [PATCH v7 net-next 3/9] net: switchdev: add support for
 offloading of the FDB locked flag
Message-ID: <Y0gbVoeV/e6wzlbM@shredder>
References: <20221009174052.1927483-1-netdev@kapio-technology.com>
 <20221009174052.1927483-4-netdev@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009174052.1927483-4-netdev@kapio-technology.com>
X-ClientProxiedBy: VI1PR0102CA0099.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::40) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL3PR12MB6404:EE_
X-MS-Office365-Filtering-Correlation-Id: ba0b1003-3c33-4f72-fa3b-08daad241a91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z/AS0X42y7/jNVW4/P3k5zz2BZ/nZozRbGqFMsHCBxGDdv/ToP+ReyZbEcuF/C8WI2dtEWIbKsrHJxFbTDJW7sRCM16mfGdkcA1l70WJjrw8XgANSfhquoLmDeCJI8dKbodTgWLnLjeJ7HaEfpovREJO1HNUAL4UU/Qb6UKiA7sUAmYQNq2RfIaN83VI88U+p3BHkLoR2/XGAZQNxWW0v6i3oft5jvKwKEmfA/fczSDZbldo3jp+Zzxo33z4tcMydWYmx5mfQK9O/uo7oHyvyQDx+UGmsKUJD75jdGOco9KR32jq213rgxih4kRoGA7eswaG3tEdGFb7SF/L+wRXkBDnx7uQbBGnux7U5GfIBiI542sIaIWcRyr/56UukUFGF6uxWIVFYeSkgtta8FrLr2Cl3k7IEualAnbxe27mPX1JIyuaQLrs+hJwpD5D4iyl4mrqtUktR3v0t21p+SYdK3/X3pOB+X+1xf/WgO1BAHaCJoVb6qllV/2IT1JrF7GqtqeEeA1WCOqTMCbnrkHR5uQRLjrb00lJArQSlOvaIr6gdZCiH1BusQpHS7tUeheWgdm6C0PPOeD6OT0lmoPxONkQXKNvzPVGmitMhoKswn6c+2j7WbjbvUejTPcLtilTlt9TvzC5ybe+upUuB+UfzcqGl4eKVZwPsTPXnr+FKlLDdNHvtYxH7fVyrSwgah/gJqm48EjVigEsxoPdmCUvvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199015)(316002)(54906003)(6916009)(6486002)(86362001)(478600001)(8936002)(66556008)(5660300002)(7416002)(7406005)(66946007)(66476007)(8676002)(33716001)(38100700002)(41300700001)(4326008)(83380400001)(26005)(6506007)(9686003)(6512007)(6666004)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hcJmpbrX1CDHzna4Rf1qbJ7AvvutQbsgYrZsXvj7MlUuNUeY5Z4GhiSRFeAV?=
 =?us-ascii?Q?EtHOZnNwnQSJoJ2AQpApZJXSWvF8blaeNh7grUDrFuhjpbk96gEO6FKAvqx3?=
 =?us-ascii?Q?z0d+5I3qS3+J58T0WmEPDdskXQ23+MsYxnN/3c/9AjkSnrPpDKmyAnMiTLpw?=
 =?us-ascii?Q?Prx001jfjS7HcBjE0jr+dhTKxQyZLr9s5lA555JSIbzqcCv7zwCbWTOBfxUJ?=
 =?us-ascii?Q?KHMCDGSFClUJpEI8Z+RR0u4ixABw58JZOjSg09Zn+ZEFNZ9o8icBihDkqau9?=
 =?us-ascii?Q?IeQbFX9BwrRnS4Dq1zwF1FNDJzk85ZIOHi/2hP2JZLCYoB6KKYjAe/OZ1OqA?=
 =?us-ascii?Q?z0GygvEaRrVMp17K3XpwLogUqhObhLwb7MVYYn753RYF3V186NS4Pc3j/4Ev?=
 =?us-ascii?Q?tR83IlX5t2/SvYDe7eHuPAlyVPM3AqyYmKLVJnAYgKLinf4vg2CpfP2W2ANi?=
 =?us-ascii?Q?ocdiNtQKNtakftGuCIAzTjuqTV8HuKklugZwGeIj6hkGHNrg7mwInW+ikjsM?=
 =?us-ascii?Q?GsCLuATtkzLalkF47/XaO80AMYdnr12iNxoW6Ew5Y3Y/Zhy5vRMlSSTbZubO?=
 =?us-ascii?Q?94MbXPvQ2nphENV8thivn03pKRrzK4ksof0KUKEVpJ1bP7+QXYAHZpoTqPHq?=
 =?us-ascii?Q?1pCWjVgZ4JA0Z55LWNhKxOzLiatSizndJPAJAwSnDS2g7a3jSzrjQKNdZuA9?=
 =?us-ascii?Q?+cxitpXsZAIptw5yHjb5g2/Wxo+bPyH+A0GRFGVQO5b9KNZST0jor2ygf4aV?=
 =?us-ascii?Q?J64odDO9JL0R3801e1xToGiZ/FpwmxLth3kkMNfnpHba0sJ/FgUMT9pgTer9?=
 =?us-ascii?Q?geCfJq4YDTdTtTwO8++coqFaICSrh4RLmLRlbj0v5HVP1unuztP4nxR5mYZr?=
 =?us-ascii?Q?1M8/y9qhXZprQmcWi4R1hCSKHkyLsFNkByMYgYw05p4dEbQoWJVyGiWbS68K?=
 =?us-ascii?Q?6B2JxBtD8B07F6jqZQ5ooGMhrL00aw8uPY81PeHQx+rCeypSok0hUoqoOB+H?=
 =?us-ascii?Q?fb9UDpNBw+VZjCIo+xB24AGIiji+C2K9chJDm901akEyUOVCv30JgJMMug6S?=
 =?us-ascii?Q?Dm6XpARVpxjQGlXEzDzmuoG3xmZR7Iz1ObRRC7h/krcXZWR2qdme6EGQVvsl?=
 =?us-ascii?Q?WHvDj7NtyxFGxKoyCMPqVdMKeCySgi/jrX1KV5LG+WElWrvfDM5gAGL04ksc?=
 =?us-ascii?Q?pEvdAc6NkIfgaG8Q8NkwO5Z2G3ScvC2GX2z38RaqGrhL0mfrnvJ5gQkO8jug?=
 =?us-ascii?Q?LFMCQGHPXvDEjglWTJVWzAhVyuG8CW2EAgAc0H0uaJ4cmmOHVHu3Q9zxt6lV?=
 =?us-ascii?Q?ynjtTuQx7v029N1ePiPCps5vSb76gQAppRnOhcc2NsURjZw50nP6ZDf06vTb?=
 =?us-ascii?Q?2bSbxNCzYhYkW+gFzc5jJIkYYajI5L3K7z4PHkE0/mYtUlpYv07aBLA0X8LN?=
 =?us-ascii?Q?sDWU5lFStJ1L1hLcBCRbPxag843nvsty+RfIxF9b8/20zzsf0Z7ctWJdbW0T?=
 =?us-ascii?Q?G3O5UPGDSlLhUbjPLwqQMmB50BhNewGh5A6QC3ER0QjShzkjB+uKpymiCMfT?=
 =?us-ascii?Q?0Qg354mY8Pj0f/PcRpBSgBTLw4YYK8EviZQ1102u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0b1003-3c33-4f72-fa3b-08daad241a91
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 14:06:20.6922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgN6Khhh1Pw+AnRWwmwqBPilslfZ/GnApuhyuiROUVgBVB0aPTsOMXpXXWsRmljN5BbMmtvlOUFsICq07gP9bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6404
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 07:40:46PM +0200, Hans J. Schultz wrote:
> Add support for offloading of the MAB/MacAuth feature flag and the FDB
> locked flag which is used by the Mac-Auth/MAB feature.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  include/net/dsa.h         |  2 ++
>  include/net/switchdev.h   |  1 +
>  net/bridge/br.c           |  4 ++--
>  net/bridge/br_fdb.c       | 12 ++++++++++--
>  net/bridge/br_private.h   |  2 +-
>  net/bridge/br_switchdev.c |  3 ++-
>  net/dsa/dsa_priv.h        |  6 ++++--
>  net/dsa/port.c            | 10 ++++++----
>  net/dsa/slave.c           | 10 ++++++++--
>  net/dsa/switch.c          | 16 ++++++++--------
>  10 files changed, 44 insertions(+), 22 deletions(-)

There is more than one logical change here. I suggest splitting it to
make review easier:

1. A patch allowing the bridge driver to install locked entries notified
from device drivers. These changes:

include/net/switchdev.h   |  1 +
net/bridge/br.c           |  4 ++--
net/bridge/br_fdb.c       | 12 ++++++++++--
net/bridge/br_private.h   |  2 +-

And the br_switchdev_fdb_populate() hunk

2. A patch allowing DSA core to report locked entries to the bridge
driver

3. A patch adding the new MAB flag to BR_PORT_FLAGS_HW_OFFLOAD

4. A patch allowing DSA core to propagate the MAB flag to device drivers

[...]

> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index e4a0513816bb..eab32b7a945a 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -304,7 +304,7 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
>  					 struct netlink_ext_ack *extack)
>  {
>  	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
> -				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
> +				   BR_BCAST_FLOOD;

Not sure how this is related to the patchset.

>  	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
>  	int flag, err;
