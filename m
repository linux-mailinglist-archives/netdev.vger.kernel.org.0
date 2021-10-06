Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05530423D7C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 14:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbhJFMOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 08:14:12 -0400
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:57505
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238265AbhJFMOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 08:14:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXNVwjGjlZ68/2NdSzbwccorjKWhtdlScQkr2akgVxBMMqPYp7yvi13JqVNU1oIDZqVL4Bha1Cbx3UyQWfSNQBmju+69fA1sufPy3tAOvJIvzeXMfWO42Tm1a+xsiLQB93e9Aar9YkRD3jbC6DVI3shE5/oX2t8surEPnigmlAtZ7301Mbb8kpPPZ2PkF3MNkKZ6TzZlkIUDgrvjA/nteaMXHs5wJAGuxxsn/8Eyf2AIxIUGa/41hYpWvQXchqLfdOosa5JkgNics+iiFqCD+OmdAJuzTEDGO2I/yKgpGTALVwewCp48FONu6/+kgON6M98XzlvI6dCQcdUxOFVjFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8pFDZ8I60as1m7kGB32TDJzcQdx18Qkdxlb7ehxevtY=;
 b=EHvquusE86qkan+DiQk3ReIXXJBmbte0ud2j+MOXmrg+c1Z/rsXs3iCn5I/82zC5uTeDD7jAIrk1kfscNxhB/sARYianMfI8v9Am9vzm8jebumQzuXirom25NrVM/DIq2+ycd1j0sWvFsXOyRct26Znf5CGfDyHMXceufyoN2ag3twGqcWU0BEnnl7EQOGp2tspH2ePZ+jDqe6fGNSS1F99aNmDvRhu9cCtIbV6qnLKIy1o+OqPQ/Jo4OZOlsJVdJs4L7mAN085njBsF46pdKnszBYrQ71Ip+yGI9iYBLcIeY3JLHNbwuJ9EP06zupcxRpI6Z0R6YhQ5kUJFWqi+Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pFDZ8I60as1m7kGB32TDJzcQdx18Qkdxlb7ehxevtY=;
 b=qC9L+nbI6FiwRHt6Hw2iyv+6Nnc4vRF1VHc/ur9vOQ8HTQLOOTraKUvNW+jfNBwNDXE5j6QBoLdWJ1WaXdeQbqWsxcLoa5O2jJrsuRHMo1fhVe7jyVh9rmAArmrTzu+tAsTkOoz55O6UKbZFi/jhROITxxKZZ1fruKzyMmL2UZM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2799.eurprd04.prod.outlook.com (2603:10a6:800:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 6 Oct
 2021 12:12:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 12:12:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        Po Liu <po.liu@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Thread-Topic: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Thread-Index: AQHXtc/NwIV3BgN/R0a4xHtuLk/jJqu+tuCAgAAJ3YCAAAOmAIAABOMAgAch5QA=
Date:   Wed, 6 Oct 2021 12:12:15 +0000
Message-ID: <20211006121214.q5lrg5tl4jkiqkt5@skbuf>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
 <20211001151115.5f583f4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211001224633.u7ylsyy4mpl5kmmo@skbuf>
 <20211001155936.48eec95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211001231706.szeo66plekzwszci@skbuf>
In-Reply-To: <20211001231706.szeo66plekzwszci@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0417b954-610a-4720-9913-08d988c28986
x-ms-traffictypediagnostic: VI1PR0402MB2799:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2799DC126209B2508B051685E0B09@VI1PR0402MB2799.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lV8siD4WhKDcQB8WAFxEHisslMiF39XSiJJ0lKxPuR51yYuqetzIPiQUrd556J2C/mFjUlbCjar49g/4pq3pX0hfOxxZAS+ekn+nUwIf6npWwEwpefMqcAf15gjU/KyMF38hU1z1EpE7tsmHgyCe0h3bmc4st7rbG5ILELBA9pexFkWpX4oukzd8akV0OZAzsJMj1bjzXGNgzMLbeJB7y7upS1K2QsNweH3kqgYjn9IvIAwAIas5pODG5NH1ISygoKp4hWPI4IWH3nfGPWlWyVQI5lWhT6MZSMPC+sDG+ayUlK1GcXPU77JTAJvj6SqH+xD7NLNtT38eigE8R3EjiQnC0ZC7B/hXm7doairAlfHdCk/n6nqFkJenfFQNeGC0GWXqs6aB7qWB98xo9kVZtrfdt84a+6Tt7xj8faIwH7GT2UHaABwzt2dJMe4FJCIf3NujeMIj12+ppUii7YgWF0lXTJws3XV0hvinmn6YoB7njU5yIO4XdKcR5anqPa2rpGj2NU0bX3S3e3+30gKCcTNMp/7UCBIPMTkTJrOTwRebh+yYoXeGlw1NiQbZQLe4tiaAt/dFKpMT3dt1998TsahL390Vq3tRSXNCRZ2BlX+XE6oyXdqbDjAGCrnk5lOZoQz5/unBtBS1hZ7Mx90jG8rgqWU9pIUnSX4RWfWT/3yvIyWvTWcYW9YMo0V7lYhCpuA/MFNaWNnDvpXHtfQxlpH508juR6+BQ6DDxX4PqAkv3ruEd7TxE+To1IfoZhRDGpzUX6X4CuAfeiMMEgfjoxNsCqEoHS6ayf89maoDPHE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(2906002)(26005)(7416002)(6506007)(186003)(83380400001)(76116006)(91956017)(66946007)(316002)(66446008)(64756008)(66556008)(66476007)(8936002)(30864003)(4326008)(508600001)(5660300002)(44832011)(122000001)(38070700005)(86362001)(54906003)(1076003)(38100700002)(6512007)(9686003)(71200400001)(6486002)(966005)(8676002)(33716001)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rR59e1KU3dEElNkHOIMx56AjyjEbfgMPidYlfGKf9wSBCX5IUpvHWxAjD6c8?=
 =?us-ascii?Q?nry0pl4CqLqY1MDzy3PPL7DmapXkapcoFns3JCDPIFN/MyONveGdwePCrcgh?=
 =?us-ascii?Q?MqvX23y7/cNzF+LSD92RVA5eA5UuV4cHHKXpBicPLeyko0xQxRnuI0TE5KF9?=
 =?us-ascii?Q?MywcGau1JlPh6YP6vIk2miUgVQgEvmBtrSj+wvs/eMyvT0IGPCXuLVcDQJ15?=
 =?us-ascii?Q?++tEMNcNMV0vx+4bPfCEOwp4qmP9Xd3F9mLEjLRiATn1hyMuVcKdc+bcVnzl?=
 =?us-ascii?Q?+NDS3YIpaJDmo/Bhgf392rhT6hvGzIVJ2RbqTkNnjPeqj7+VYaCzApuvhIG4?=
 =?us-ascii?Q?p6dSIU7OrxYW2i1ztFvnKSKzGPGhiGZPmA+miaPgk1p7LiHTbv2tE5+Y9eBi?=
 =?us-ascii?Q?yuic6fAPsKgFuRhmGDLG3eeRzzA1o8yCJw7aO9C/dhtx9khuc7o0vOIuXK2t?=
 =?us-ascii?Q?jgN6ocB5kVTnG5BXROmPt86SaLVR+kagnAzwUpTr+2adJgr3IqRdESuSdJJv?=
 =?us-ascii?Q?bM3KssD/1lqgWFAwQ6v1xd1KUp9+M8/gwx+pfRF0kCjrlQIDGMv5KKZMjVV6?=
 =?us-ascii?Q?kJh2vhfVzfMp4n/PVHEvyEoJCTMH0bdz8LTPd7zK20JacSuGRCdlSz1AUu7l?=
 =?us-ascii?Q?cexST8pSFiFikGGPIQhLdcRuu7L7pR/1MwoLwXVU+Fym8mMf573ZJQ/3oR7n?=
 =?us-ascii?Q?CufPurceQ4ev0mTp0smqJh4e6xBTt5IIqulyQaPutFLc60rbXXSSKTSgPVTE?=
 =?us-ascii?Q?73u8F2CY4V3XirO3iyqDjO+Quu4yDgcsAZD2R3GDfgN7IyovwuiRNotGbtkn?=
 =?us-ascii?Q?W6hDma7/F1s7W4bvjlbwHw9KP9ztt+hZzkF4lgW9OXdN50yaAX/EenxzLm+S?=
 =?us-ascii?Q?L8YlG7YsoMdXDbRkHIBcOEDeZ53lLpvGu5Qt/0CBx2iXmXmDYF7NfQtW32M6?=
 =?us-ascii?Q?IuDCIfxuDBttqBDstbthh0Nq+/Grzo2+qGEOIMG7nDJBYeoN4Pr81VtUWhp6?=
 =?us-ascii?Q?3qemMp35UnbAHsrHPC82F2zUgLP3PSDbQW71eBfvpU67DB8ceZve4uroAMT8?=
 =?us-ascii?Q?Prk0yToTXlWGX/NqPvbaKjBeegsE99M7sJ/X+P1Cybx4X1ujldmriS8l6iYo?=
 =?us-ascii?Q?9piAOiYA7jFYg1Jx3TQvk2/mVA2i+PLRVbJprUNrQXCEX4IghCf8oirdUVgD?=
 =?us-ascii?Q?Oufba2m+F3uKv92paaGz56kQlAhwD6UCmAFGDrnctL3Nr6RO7MX3yazWRd3V?=
 =?us-ascii?Q?/wtD+7S+5/1LqjzRPCHoSkFLMZRh4Fn0iFBGNBGIr+WmeCetGK+0tf0jUcXN?=
 =?us-ascii?Q?0iKoZe9mgYkws4LeNpG1hjG8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E5D9E4760576E4CA8CDD7013F92541E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0417b954-610a-4720-9913-08d988c28986
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 12:12:16.0279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yz3l/NjL7rBCRfo2izDp3kLbtLPL0Eowcbe22oXoJ5jSStgcm0pnCZMqzg9lzwVtXxxgvQBlhyzPE1ozNY1wqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2799
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 02, 2021 at 02:17:06AM +0300, Vladimir Oltean wrote:
> On Fri, Oct 01, 2021 at 03:59:36PM -0700, Jakub Kicinski wrote:
> > On Fri, 1 Oct 2021 22:46:34 +0000 Vladimir Oltean wrote:
> > > On Fri, Oct 01, 2021 at 03:11:15PM -0700, Jakub Kicinski wrote:
> > > > On Thu, 30 Sep 2021 15:59:40 +0800 Xiaoliang Yang wrote:
> > > > > VSC9959 hardware supports Per-Stream Filtering and Policing(PSFP)=
.
> > > > > This patch series add PSFP support on tc flower offload of ocelot
> > > > > driver. Use chain 30000 to distinguish PSFP from VCAP blocks. Add=
 gate
> > > > > and police set to support PSFP in VSC9959 driver.
> > > >
> > > > Vladimir, any comments?
> > >
> > > Sorry, I was intending to try out the patches and get an overall feel
> > > from there, but I had an incredibly busy week and simply didn't have =
time.
> > > If it's okay to wait a bit more I will do that tomorrow.
> >
> > Take your time, I'll mark it as Deferred for now.
>
> Thank you.

I'm very sorry for being late.
I wrote this selftest for the ingress time gating portion of Xiaoliang's wo=
rk:

cat tools/testing/selftests/drivers/net/ocelot/psfp.sh
-----------------------------[ cut here ]-----------------------------
#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright 2021 NXP

WAIT_TIME=3D1
NUM_NETIFS=3D4
lib_dir=3D$(dirname $0)/../../../net/forwarding
source $lib_dir/tc_common.sh
source $lib_dir/lib.sh

utc_tai_offset=3D37
num_pkts=3D1000
fudge_factor=3D5000000

# https://github.com/vladimiroltean/tsn-scripts
require_command isochron
require_command phc2sys

# This setup requires patching the LS1028A device tree to move the DSA mast=
er
# from eno2 to eno3, and to use eno2 as a data port.
#
#        swp0      swp4        eno2       eno0
#   +---------------------------------------------+
#   |       DUT ports         Generator ports     |
#   | +--------+ +--------+ +--------+ +--------+ |
#   | |        | |        | |        | |        | |
#   | |dut_recv| |dut_send| |gen_recv| |gen_send| |
#   | |        | |        | |        | |        | |
#   +-+--------+-+--------+-+--------+-+--------+-+
#          ^         v           ^          v
#          |         |           |          |
#          |         +-----------+          |
#          |                                |
#          +--------------------------------+

dut_recv=3D${NETIFS[p1]}
dut_send=3D${NETIFS[p2]}
gen_recv=3D${NETIFS[p3]}
gen_send=3D${NETIFS[p4]}

dut_recv_mac=3D"de:ad:be:ef:00:00"
dut_send_mac=3D"de:ad:be:ef:00:01"
gen_recv_mac=3D"de:ad:be:ef:00:02"
gen_send_mac=3D"de:ad:be:ef:00:03"

stream_vid=3D"100"

PSFP()
{
	echo 30000
}

psfp_chain_create()
{
	local eth=3D$1

	tc qdisc add dev $eth clsact

	tc filter add dev $eth ingress chain 0 pref 49152 flower \
		skip_sw action goto chain $(PSFP)
}

psfp_chain_destroy()
{
	local eth=3D$1

	tc qdisc del dev $eth clsact
}

psfp_filter_check()
{
	local expected_matches=3D$1
	local packets=3D""
	local drops=3D""
	local stats=3D""

	stats=3D$(tc -j -s filter show dev ${dut_recv} ingress chain $(PSFP) pref =
1)
	packets=3D$(echo ${stats} | jq ".[1].options.actions[].stats.packets")
	drops=3D$(echo ${stats} | jq ".[1].options.actions[].stats.drops")

	if ! [ "${packets}" =3D "${expected_matches}" ]; then
		echo "Expected filter to match on ${expected_matches} packets but matched=
 on ${packets} instead"
	fi

	echo "Hardware filter reports ${drops} drops"
}

scrape_logs_for_phc2sys_offset() {
	local awk_program=3D'/sys offset/ { print $5; exit; }'

	tac ${phc2sys_log} | awk "${awk_program}"
}

scrape_logs_for_ptp4l_offset() {
	local log=3D$1
	local awk_program=3D'/master offset/ { print $4; exit; }'

	tac ${log} | awk "${awk_program}"
}

check_sync_phc2sys() {
	local threshold_ns=3D50
	local system_clock_offset=3D

	while :; do
		sleep 1

		system_clock_offset=3D$(scrape_logs_for_phc2sys_offset)

		# Got something, is it a number?
		case "${system_clock_offset}" in
		''|[!\-][!0-9]*)
			if ! pidof phc2sys > /dev/null; then
				echo "Please start the phc2sys service."
				return 1
			else
				echo "Trying again..."
				continue
			fi
			;;
		esac

		if [ "${system_clock_offset}" -lt 0 ]; then
			system_clock_offset=3D$((-${system_clock_offset}))
		fi
		echo "System clock offset ${system_clock_offset} ns"
		if [ "${system_clock_offset}" -gt "${threshold_ns}" ]; then
			echo "System clock is not yet synchronized..."
			continue
		fi
		# Success
		break
	done
}

check_sync_ptp4l() {
	local eth=3D$1
	local log=3D"ptp4l_log_${eth}"
	local indirect=3D"${!log}"
	local threshold_ns=3D100
	local phc_offset=3D

	while :; do
		sleep 1

		phc_offset=3D$(scrape_logs_for_ptp4l_offset "${indirect}")

		# Got something, is it a number?
		case "${phc_offset}" in
		''|[!\-][!0-9]*)
			if ! pidof ptp4l > /dev/null; then
				echo "Please start the ptp4l service."
				return 1
			else
				echo "Trying again..."
				continue
			fi
			;;
		esac

		echo "Master offset ${phc_offset} ns"
		if [ "${phc_offset}" -lt 0 ]; then
			phc_offset=3D$((-${phc_offset}))
		fi
		if [ "${phc_offset}" -gt "${threshold_ns}" ]; then
			echo "PTP clock is not yet synchronized..."
			continue
		fi
		# Success
		break
	done
}

check_sync()
{
	check_sync_phc2sys
	# gen_send is master, no need to check sync
	check_sync_ptp4l ${dut_recv}
}

phc2sys_start()
{
	local eth=3D$1

	phc2sys_log=3D"$(mktemp)"

	phc2sys -m \
		-c ${eth} \
		-s CLOCK_REALTIME \
		-O ${utc_tai_offset} \
		> "${phc2sys_log}" 2>&1 &
	phc2sys_pid=3D$!

	sleep 1
}

phc2sys_stop()
{
	{ kill ${phc2sys_pid} && wait ${phc2sys_pid}; } 2> /dev/null
	rm "${phc2sys_log}" 2> /dev/null
}

ptp4l_start()
{
	local eth=3D$1
	local slave_only=3D$2
	local log=3D"ptp4l_log_${eth}"
	local pid=3D"ptp4l_pid_${eth}"
	local extra_args=3D""

	if [ "${slave_only}" =3D true ]; then
		extra_args=3D" -s"
	fi

	# declare dynamic variables as global, will reference them later in
	# ptp4l_stop and scrape_logs_for_ptp4l_offset
	declare -g "${log}=3D$(mktemp)"

	ptp4l -m -2 -P \
		-i ${eth} ${extra_args} \
		--step_threshold 0.00002 --first_step_threshold 0.00002 \
		> "${!log}" 2>&1 &
	declare -g "${pid}=3D$!"

	echo "ptp4l for interface ${eth} logs to ${!log} and has pid ${!pid}"

	sleep 1
}

ptp4l_stop()
{
	local eth=3D$1
	local log=3D"ptp4l_log_${eth}"
	local pid=3D"ptp4l_pid_${eth}"

	{ kill ${!pid} && wait ${!pid}; } 2> /dev/null
	rm "${!log}" 2> /dev/null
}

txtime_setup()
{
	local eth=3D$1

	tc qdisc add dev ${eth} clsact
	tc filter add dev ${eth} egress protocol 0x88f7 \
		flower action skbedit priority 7
	tc filter add dev ${eth} egress protocol 802.1Q \
		flower vlan_ethtype 0xdeaf action skbedit priority 6
	tc qdisc add dev ${eth} handle 100: parent root mqprio num_tc 8 \
		queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
		map 0 1 2 3 4 5 6 7 \
		hw 1
	tc qdisc replace dev ${eth} parent 100:6 etf \
		clockid CLOCK_TAI offload delta ${fudge_factor}
	tc qdisc replace dev ${eth} parent 100:7 etf \
		clockid CLOCK_TAI offload delta ${fudge_factor}
}

txtime_cleanup()
{
	local eth=3D$1

	tc qdisc del dev ${eth} root
	tc qdisc del dev ${eth} clsact
}

setup_prepare()
{
	ip link set ${dut_recv} up
	ip link set ${dut_send} up
	ip link set ${gen_recv} up
	ip link set ${gen_send} up

	ip link add br0 type bridge vlan_filtering 1
	ip link set ${dut_recv} master br0
	ip link set ${dut_send} master br0
	ip link set br0 up

	bridge vlan add dev ${dut_send} vid ${stream_vid}
	bridge vlan add dev ${dut_recv} vid ${stream_vid}
	bridge fdb add dev ${dut_send} \
		${gen_recv_mac} vlan ${stream_vid} static master

	psfp_chain_create ${dut_recv}

	tc filter add dev ${dut_recv} ingress chain $(PSFP) pref 1 \
		protocol 802.1Q flower skip_sw \
		dst_mac ${gen_recv_mac} vlan_id ${stream_vid} \
		action gate base-time 0.000000000 \
		sched-entry OPEN  5000000 -1 -1 \
		sched-entry CLOSE 5000000 -1 -1

	# Deleting the MAC table entry (uncommenting the lines below) will
	# render the filter useless, because the SFID processing will be
	# bypassed, and the kernel does not protect against this structure
	# getting altered.
	# Interestingly though, the spurious matches described below are not
	# eliminated even with the MAC table being deleted.
	#bridge fdb del dev ${dut_send} \
	#	${gen_recv_mac} vlan ${stream_vid} static master

	ip link set ${gen_recv} promisc on

	txtime_setup ${gen_send}

	# Assumption true for LS1028A: gen_send and gen_recv use the same PHC
	phc2sys_start ${gen_send}

	ptp4l_start ${gen_send} false
	ptp4l_start ${dut_recv} true
	# ?! Hardware seems to spuriously match on the PTP packets send through
	# the switch port here. The filter reports anywhere between 2 to 4
	# packets matching on it, some even dropped, even though there isn't
	# any packet with ${gen_recv_mac} being sent.
	psfp_filter_check 0
	check_sync
}

cleanup()
{
	ptp4l_stop ${dut_recv}
	ptp4l_stop ${gen_send}
	phc2sys_stop
	isochron_recv_stop
	txtime_cleanup ${gen_send}
	ip link set ${gen_recv} promisc off
	psfp_chain_destroy ${dut_recv}
	ip link del br0
}

isochron_recv_start()
{
	local eth=3D$1

	taskset $((1 << 1)) isochron rcv \
		--interface ${eth} \
		--num-frames ${num_pkts} \
		--sched-priority 98 \
		--sched-rr \
		--etype 0xdead \
		--utc-tai-offset ${utc_tai_offset} \
		--quiet &
	isochron_pid=3D$!

	sleep 1
}

isochron_recv_stop()
{
	{ kill ${isochron_pid} && wait ${isochron_pid}; } 2> /dev/null
}

isochron_drops_check()
{
	local expected_lost=3D$1
	local drops=3D""

	drops=3D$(cat ${isochron_log} | grep -E 'seqid .* lost' | wc -l)

	if ! [ "${drops}" =3D "${expected_lost}" ]; then
		echo "Expected isochron to drop ${expected_lost} packets but dropped ${dr=
ops}"
		return 1
	fi

	return 0
}

test_isochron_common()
{
	local base_time=3D$1
	local expected_lost=3D$2
	local expected_matches=3D$3
	local isochron_log=3D"$(mktemp)"

	isochron_recv_start ${gen_recv}

	taskset $((1 << 0)) isochron send \
		--interface ${gen_send} \
		--dmac ${gen_recv_mac} \
		--priority 6 \
		--base-time ${base_time} \
		--cycle-time 0.010000000 \
		--num-frames ${num_pkts} \
		--frame-size 64 \
		--vid ${stream_vid} \
		--etype 0xdead \
		--txtime \
		--utc-tai-offset ${utc_tai_offset} \
		--sched-rr \
		--sched-priority 98 \
		--client 127.0.0.1 \
		--quiet \
		> "${isochron_log}" 2>&1

	isochron_recv_stop

	isochron_drops_check ${expected_lost} && echo "OK" || echo "FAIL"
	psfp_filter_check ${expected_matches}

	rm "${isochron_log}" 2> /dev/null
}

test_gate_in_band()
{
	# Send packets in-band with the OPEN gate entry
	test_isochron_common 0.002500000 0 ${num_pkts}
}

test_gate_out_of_band()
{
	# Send packets in-band with the CLOSE gate entry
	test_isochron_common 0.007500000 ${num_pkts} $((2 * ${num_pkts}))
}

trap cleanup EXIT

ALL_TESTS=3D"
	test_gate_in_band
	test_gate_out_of_band
"

setup_prepare
setup_wait

tests_run

exit $EXIT_STATUS
-----------------------------[ cut here ]-----------------------------

and both tests pass with OK, but here are some parts of my log:


Expected filter to match on 0 packets but matched on 2 instead
                                          ~~~~~~~~~~~~~~~~~~~~
                                          I put "psfp_filter_check 0" at th=
e end of "setup_prepare",
                                          during a time where it is guarant=
eed that no test packet belonging
                                          to the TSN stream has been sent, =
yet the hardware seems to
                                          spuriously increment this counter=
. This makes it very difficult
                                          to actually assess what's going o=
n by looking at counters.
                                          If you look at the comments, the =
SFID counters increment
                                          spuriously even if I delete the M=
AC table entry.

Hardware filter reports 0 drops
OK
[  275.429138] mscc_felix 0000:00:00.5: vsc9959_psfp_stats_get: pkts 1000 d=
rops 0 sfid 0 match 1000 not_pass_gate 0 not_pass_sdu 0 red 0
Expected filter to match on 1000 packets but matched on 1002 instead
Hardware filter reports 0 drops
Accepted connection from 127.0.0.1
Accepted connection from 127.0.0.1
OK
[  288.091715] mscc_felix 0000:00:00.5: vsc9959_psfp_stats_get: pkts 1000 d=
rops 1000 sfid 0 match 1000 not_pass_gate 1000 not_pass_sdu 0 red 0
                                                                           =
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                                                           =
                            the driver sums these up and puts them
                                                                           =
                            in stats->drops
Expected filter to match on 2000 packets but matched on 2002 instead
Hardware filter reports 0 drops
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
however "tc -s filter show ..." shows 0 drops, so the information is lost s=
omewhere along the way (the "packets" counter is correct though).


It's very hard to have an opinion considering the fact that the hardware
doesn't behave according to my understanding. One of us must be wrong :)=
