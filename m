Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F053B5BDE
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 12:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhF1KCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:02:20 -0400
Received: from mail-am6eur05on2079.outbound.protection.outlook.com ([40.107.22.79]:30905
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232539AbhF1KCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 06:02:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pz8Ja5F9dTluQFPM213bplrMamz6ScuHizIn6NdqDCF/qO5SvdbVU+NWhyN33U0Duod654HSzS8wiOwXeTUP3hlgv71IR4uKlVePbsg5yyMXQ8O8dc0OUkHnLFA4k/k3h1zVR6dkcneIyBzrzDt7f/IMxdQw4rwMYNqZnxFTRS3thpou2mQaLuPuCDO0vwu63A9jgp+4rcrOwI2W662OgDgnA3umAAhezMIcnsI9utb4LpVdqbiNOzNkNzF3XIS5xBY7+h1YE+EnSScKY6l9HNsU3dwEvGgONWh8l1ISPF1KZyz//emMkBb8nia+/3XIdstpmyYIY94X+OZ7u3GvKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gElJHxfGz+hFd6180C/ogXd8du07nRkEbdwS1E39mfk=;
 b=kIahKd8NK80bEX+kCd/tKbhMbgyGbGh7i0r4A5Ws2kWk3tcC72OwAmzljC7ImU4GInjkcEKGVa3lfVp7VxG8tHJfawYwcYqiVukQ/03e+o605cviKwWCpRamzAeNuI/c+rJSbMcqHrx/6MkjBW1OLbknAx1OATWLZBSzWSXGhtCkIUb9RCxDWpDNyQk/ZWgd6TqIewPfxpQqgEooj7NVms7yGA4/VZ5fnXhLEjfXn9qgRHt+TwEGFlpBq3kN2xvkUWrYDDqFGdwqF1aYFS9SEipY9T6+GgkTxDZcer0FjW4kx+Tclc3A/CUDw0podHvMmXPeJJMrsYDrBjuyW+6SBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gElJHxfGz+hFd6180C/ogXd8du07nRkEbdwS1E39mfk=;
 b=f2inn/FPABU9uynlkwS1KqCnE08e2x6aJDW/JbHh3lhjUwzqnKeNVXqqNBkGRaET4Nwj4Qs29xMT2v/50EUZY18isFS6UphRa1sZrwQYMFF+SuKs3Uw/VS5YU3UWrohBOF2pRMFDl40lGAfh3B9OcdVDX2LHN8DS4uXyGGaXnwc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2511.eurprd04.prod.outlook.com (2603:10a6:800:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Mon, 28 Jun
 2021 09:59:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 09:59:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 12/12] igc: Add support for Frame Preemption
 verification
Thread-Topic: [PATCH net-next v4 12/12] igc: Add support for Frame Preemption
 verification
Thread-Index: AQHXaiLx4TRJNgYN1Uq4MDxOaStQpKspNGUA
Date:   Mon, 28 Jun 2021 09:59:51 +0000
Message-ID: <20210628095950.ifbgzmsmpecmlol4@skbuf>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
 <20210626003314.3159402-13-vinicius.gomes@intel.com>
In-Reply-To: <20210626003314.3159402-13-vinicius.gomes@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.224.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc9ce051-c6fc-4db6-4b96-08d93a1b78df
x-ms-traffictypediagnostic: VI1PR0401MB2511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2511CC7832F96CE88B74F301E0039@VI1PR0401MB2511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ClljiRpS5yHMDgYmhUE/d7WfrlNTTkFuUwvyz9iHOfJZWDJ39eEd8RuR054i+tTqGPr4DGRq9VMkRZYHbm2R71bb6W9paXjPuKCLIyNRzo6ePxI/k1012KDZHqs2XMoK4ploY0qRxxOOseLDgVK5lWbJVwDmn4oKNRguJ9Xr4TviaE2VVmXP5aZ+iXz4wpgwQBN6+Wc9ooXjowaHbfdcmvkg6+881nbmD5cyYqHl4DzBZKAu46LM3gm9hss8Il7yX1YdgzelBPy0+Bjvx/ak6KdrChLP7fPWCZxe3oPcSYrX9AZq3gxeXVe25ZEKX8GpW6yMJ252QthHkUNHMhOV/UJkFs/DitAncGHbqtAR+iBOEduhotCQc0CcB54QSIm2tOn/Nqkga/YuTx6DVBX+Zqpew27pLiwo/2VFPGEAQKumOIJSOWuqjbt78vFFLIqfwYcSe+IILaymcYrGAG3dVAGnhDtHeEeRkOw0TojZ7U/gNrVhNnh25P6ZVERtBDnzOxQgDaDe8oe9/7P/5WPhsUqE8FHHUJY3OOLs/hLHVTaOLgCXQUa6lvKC9mVCmVfHWTYQuoLYCxZa5cQVSH18JhslASLgnam4crs01FURxpnrbYAPhxxjxHzuxSlNM/TtGXxesrj1AQXZAs5Vj54ZKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(5660300002)(30864003)(86362001)(1076003)(15650500001)(71200400001)(6506007)(186003)(6486002)(6512007)(83380400001)(6916009)(2906002)(9686003)(8936002)(66556008)(54906003)(122000001)(478600001)(33716001)(8676002)(66446008)(64756008)(66946007)(76116006)(26005)(66476007)(316002)(44832011)(4326008)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P/BzR5M/Jmz3AN0w3J8mSki609x94ACH+wo4U9ZbMMMBHigIglN+MZVNaBDN?=
 =?us-ascii?Q?eKik9z1vhNQZesS3LCO7YYZHLcYf3DiMMS3R69ctHN5dYEOVSQj+m5zEm1O4?=
 =?us-ascii?Q?Nu2Wv00mExczpRWSGzWI9JhFUHRWOmWu6mswjgMJkNSLbfjbBDD0KiThklMk?=
 =?us-ascii?Q?tZR6sfwVAps+5bnTLJHedGa8+tRc/7V1FCkPAOe9wzWkcRI+pEf/e86HZza/?=
 =?us-ascii?Q?pArHce+nTuExklHtUFMyRR+Nr5+99qC3ofv9ZI6jp5T2oRn21DSIIZ0TYwXG?=
 =?us-ascii?Q?YBh5HSFxaaJ3xPW+WF3qyBs3Zxz5SreOMQi30I3MMMBjb6jKUwAVgvOztHWn?=
 =?us-ascii?Q?HUSyXY6+oRCLFjLptzM/3WSL8Ka91GeeKL2snvfIRTqP4pvzONOk/6JJQq9t?=
 =?us-ascii?Q?ZAKhFGKbbN19ZAlTw+sMx1pTBK8He5ab9Z9lMdzKniChQDKdLQtDFZ5qWWIe?=
 =?us-ascii?Q?fBW8dMchhiPzBhOehOhSlCiEELobPA6TTWqZdtvDa4/uwYKe/3avVjNahlVA?=
 =?us-ascii?Q?15/gnoLDcj5sqcBXYaqtJQ5q/kkF5I6HhGrN4FGKTGPTF/1RFb1FdcK6XklV?=
 =?us-ascii?Q?UTuHCvjIbzST6aB0cgebe0gjVZAjvIDIeD+obx324lgJOfA43ztkgtDwadFa?=
 =?us-ascii?Q?CV11hUVMtuQllk8h+v0g2sc5YbR3hNvU4A3/Txeoe/hYucOYgLfePYS+fUQ8?=
 =?us-ascii?Q?futyK3Z3y1KLu9hxXeyfTiLRf5xtyh9AT3UgPDhvGi2q4YivWzrHr6o9a8UI?=
 =?us-ascii?Q?P6IGClYlBXcTXnfyUTjLkmfrfP2TVxS7tDnx2jJ4QUgu121M/DC0TNjWktAZ?=
 =?us-ascii?Q?rS/pValiu4r+MCiBWbDdyqyow4tenj7hGRJlvIwAs72gH4u5SbOMqYLbqzIT?=
 =?us-ascii?Q?TscEZSF1X/Yd5BFSDro2qVobRt95zx2/LOQeRpYcTSNVjQu8mKc8SVEIZDa/?=
 =?us-ascii?Q?9LyCyGjEwA84aYdnVvSDZR7h9bDXwXWnNTihCETHkjWA8sv6ApBVSpA+K9fR?=
 =?us-ascii?Q?l5E1DglsVoDsR8RiT/7yeOFWvULy6tWNPzfh5wTXSgA3P6F+dqM8swGT2GdL?=
 =?us-ascii?Q?3sShe6Vm35hs1ui0oYUI5LnJ8/iGt0FIGW9rn1F8kdMnJFChOs7JaPJCFa1R?=
 =?us-ascii?Q?4t1u+OMivZS8ohG1NtKyNK/QnIOH71JtFs8TQXff/uQ0pSQlqLoY+e88PGak?=
 =?us-ascii?Q?nZgqeMTRBMuBr/ArAk5uBuyxbRZ3OYABZoIhf/RFFlDXHOQa16b0WbGy/D24?=
 =?us-ascii?Q?azqEx6mIWNSyeQlHaddb4uYGyopkLSYoikkXQAU3frpkhFozSiTAPeOCwEQG?=
 =?us-ascii?Q?vdgw2Q4XakWhLOdXvRackl2P?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8A928175E8DCF840BC78C34508FB8F50@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9ce051-c6fc-4db6-4b96-08d93a1b78df
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 09:59:51.4800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AVh3Vu2HA+/cmcgYDk3M3E2aXn+cPv5WOdD/a8skpPDgnxOEypLF4caOVqukewRiwVKXMye1ReWgc1ljRxw7jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 05:33:14PM -0700, Vinicius Costa Gomes wrote:
> Add support for sending/receiving Frame Preemption verification
> frames.
>=20
> The i225 hardware doesn't implement the process of verification
> internally, this is left to the driver.
>=20
> Add a simple implementation of the state machine defined in IEEE
> 802.3-2018, Section 99.4.7.
>=20
> For now, the state machine is started manually by the user, when
> enabling verification. Example:
>=20
> $ ethtool --set-frame-preemption IFACE disable-verify off
>=20
> The "verified" condition is set to true when the SMD-V frame is sent,
> and the SMD-R frame is received. So, it only tracks the transmission
> side. This seems to be what's expected from IEEE 802.3-2018.
>=20
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc.h         |  15 ++
>  drivers/net/ethernet/intel/igc/igc_defines.h |  13 ++
>  drivers/net/ethernet/intel/igc/igc_ethtool.c |  20 +-
>  drivers/net/ethernet/intel/igc/igc_main.c    | 216 +++++++++++++++++++
>  4 files changed, 261 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/=
intel/igc/igc.h
> index 9b2ddcbf65fb..84234efed781 100644
> --- a/drivers/net/ethernet/intel/igc/igc.h
> +++ b/drivers/net/ethernet/intel/igc/igc.h
> @@ -122,6 +122,13 @@ struct igc_ring {
>  	struct xsk_buff_pool *xsk_pool;
>  } ____cacheline_internodealigned_in_smp;
> =20
> +enum frame_preemption_state {
> +	FRAME_PREEMPTION_STATE_FAILED,
> +	FRAME_PREEMPTION_STATE_DONE,
> +	FRAME_PREEMPTION_STATE_START,
> +	FRAME_PREEMPTION_STATE_SENT,
> +};
> +
>  /* Board specific private data structure */
>  struct igc_adapter {
>  	struct net_device *netdev;
> @@ -240,6 +247,14 @@ struct igc_adapter {
>  		struct timespec64 start;
>  		struct timespec64 period;
>  	} perout[IGC_N_PEROUT];
> +
> +	struct delayed_work fp_verification_work;
> +	unsigned long fp_start;
> +	bool fp_received_smd_v;
> +	bool fp_received_smd_r;
> +	unsigned int fp_verify_cnt;
> +	enum frame_preemption_state fp_tx_state;
> +	bool fp_disable_verify;
>  };
> =20
>  void igc_up(struct igc_adapter *adapter);
> diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/e=
thernet/intel/igc/igc_defines.h
> index a2ea057d8e6e..cf46f5d5a505 100644
> --- a/drivers/net/ethernet/intel/igc/igc_defines.h
> +++ b/drivers/net/ethernet/intel/igc/igc_defines.h
> @@ -268,6 +268,8 @@
>  #define IGC_TXD_DTYP_C		0x00000000 /* Context Descriptor */
>  #define IGC_TXD_POPTS_IXSM	0x01       /* Insert IP checksum */
>  #define IGC_TXD_POPTS_TXSM	0x02       /* Insert TCP/UDP checksum */
> +#define IGC_TXD_POPTS_SMD_V	0x10       /* Transmitted packet is a SMD-Ve=
rify */
> +#define IGC_TXD_POPTS_SMD_R	0x20       /* Transmitted packet is a SMD-Re=
sponse */
>  #define IGC_TXD_CMD_EOP		0x01000000 /* End of Packet */
>  #define IGC_TXD_CMD_IC		0x04000000 /* Insert Checksum */
>  #define IGC_TXD_CMD_DEXT	0x20000000 /* Desc extension (0 =3D legacy) */
> @@ -327,9 +329,20 @@
> =20
>  #define IGC_RXDEXT_STATERR_LB	0x00040000
> =20
> +#define IGC_RXD_STAT_SMD_V	0x2000  /* Received packet is SMD-Verify pack=
et */
> +#define IGC_RXD_STAT_SMD_R	0x4000  /* Received packet is SMD-Response pa=
cket */
> +

So the i225 gives you the ability to select from multiple
Start-of-mPacket-Delimiter values on a per-TX descriptor basis?
And this is in addition to configuring that TX ring as preemptable I
guess? Because I notice that you're sending on the TX ring affine to the
current CPU that the verification work item is running on (which you
don't check anywhere that it is configured as going to the pMAC or not).
And on RX, it always gives you the kind of SMD that the packet had
(including the classic SFD for express packets)?
Cool.

It would be nice if I could connect back to back an i225 board with an
NXP LS1028A to see if the verification state machines pass both ways (on
LS1028A it is 100% hardware based, we just enable/disable the feature
and we can monitor the state changes via an interrupt).

>  /* Advanced Receive Descriptor bit definitions */
>  #define IGC_RXDADV_STAT_TSIP	0x08000 /* timestamp in packet */
> =20
> +#define IGC_RXDADV_STAT_SMD_TYPE_MASK	0x06000
> +#define IGC_RXDADV_STAT_SMD_TYPE_SHIFT	13
> +
> +#define IGC_SMD_TYPE_SFD		0x0
> +#define IGC_SMD_TYPE_SMD_V		0x1
> +#define IGC_SMD_TYPE_SMD_R		0x2
> +#define IGC_SMD_TYPE_COMPLETE		0x3
> +
>  #define IGC_RXDEXT_STATERR_L4E		0x20000000
>  #define IGC_RXDEXT_STATERR_IPE		0x40000000
>  #define IGC_RXDEXT_STATERR_RXE		0x80000000
> diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/e=
thernet/intel/igc/igc_ethtool.c
> index 84d5afe92154..f52a7be3af66 100644
> --- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
> +++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
> @@ -1649,6 +1649,8 @@ static int igc_ethtool_get_preempt(struct net_devic=
e *netdev,
> =20
>  	fpcmd->enabled =3D adapter->frame_preemption_active;
>  	fpcmd->add_frag_size =3D adapter->add_frag_size;
> +	fpcmd->verified =3D adapter->fp_tx_state =3D=3D FRAME_PREEMPTION_STATE_=
DONE;
> +	fpcmd->disable_verify =3D adapter->fp_disable_verify;
> =20
>  	return 0;
>  }
> @@ -1664,10 +1666,22 @@ static int igc_ethtool_set_preempt(struct net_dev=
ice *netdev,
>  		return -EINVAL;
>  	}
> =20
> -	adapter->frame_preemption_active =3D fpcmd->enabled;
> -	adapter->add_frag_size =3D fpcmd->add_frag_size;
> +	if (!fpcmd->disable_verify && adapter->fp_disable_verify) {
> +		adapter->fp_tx_state =3D FRAME_PREEMPTION_STATE_START;
> +		schedule_delayed_work(&adapter->fp_verification_work, msecs_to_jiffies=
(10));

Not sure how much you'd like to tune this, but the spec has a
configurable verifyTime between 1 ms and 128 ms. You chose the default
value, so we should be ok for now.

> +	}
> =20
> -	return igc_tsn_offload_apply(adapter);
> +	adapter->fp_disable_verify =3D fpcmd->disable_verify;
> +
> +	if (adapter->frame_preemption_active !=3D fpcmd->enabled ||
> +	    adapter->add_frag_size !=3D fpcmd->add_frag_size) {
> +		adapter->frame_preemption_active =3D fpcmd->enabled;
> +		adapter->add_frag_size =3D fpcmd->add_frag_size;
> +
> +		return igc_tsn_offload_apply(adapter);
> +	}
> +
> +	return 0;
>  }
> =20
>  static int igc_ethtool_begin(struct net_device *netdev)
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethe=
rnet/intel/igc/igc_main.c
> index 20dac04a02f2..ed55bd13e4a1 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -28,6 +28,11 @@
>  #define IGC_XDP_TX		BIT(1)
>  #define IGC_XDP_REDIRECT	BIT(2)
> =20
> +#define IGC_FP_TIMEOUT msecs_to_jiffies(100)
> +#define IGC_MAX_VERIFY_CNT 3
> +
> +#define IGC_FP_SMD_FRAME_SIZE 60
> +
>  static int debug =3D -1;
> =20
>  MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
> @@ -2169,6 +2174,79 @@ static int igc_xdp_init_tx_descriptor(struct igc_r=
ing *ring,
>  	return 0;
>  }
> =20
> +static int igc_fp_init_smd_frame(struct igc_ring *ring, struct igc_tx_bu=
ffer *buffer,
> +				 struct sk_buff *skb)
> +{
> +	dma_addr_t dma;
> +	unsigned int size;
> +
> +	size =3D skb_headlen(skb);
> +
> +	dma =3D dma_map_single(ring->dev, skb->data, size, DMA_TO_DEVICE);
> +	if (dma_mapping_error(ring->dev, dma)) {
> +		netdev_err_once(ring->netdev, "Failed to map DMA for TX\n");
> +		return -ENOMEM;
> +	}
> +
> +	buffer->skb =3D skb;
> +	buffer->protocol =3D 0;
> +	buffer->bytecount =3D skb->len;
> +	buffer->gso_segs =3D 1;
> +	buffer->time_stamp =3D jiffies;
> +	dma_unmap_len_set(buffer, len, skb->len);
> +	dma_unmap_addr_set(buffer, dma, dma);
> +
> +	return 0;
> +}
> +
> +static int igc_fp_init_tx_descriptor(struct igc_ring *ring,
> +				     struct sk_buff *skb, int type)
> +{
> +	struct igc_tx_buffer *buffer;
> +	union igc_adv_tx_desc *desc;
> +	u32 cmd_type, olinfo_status;
> +	int err;
> +
> +	if (!igc_desc_unused(ring))
> +		return -EBUSY;
> +
> +	buffer =3D &ring->tx_buffer_info[ring->next_to_use];
> +	err =3D igc_fp_init_smd_frame(ring, buffer, skb);
> +	if (err)
> +		return err;
> +
> +	cmd_type =3D IGC_ADVTXD_DTYP_DATA | IGC_ADVTXD_DCMD_DEXT |
> +		   IGC_ADVTXD_DCMD_IFCS | IGC_TXD_DCMD |
> +		   buffer->bytecount;
> +	olinfo_status =3D buffer->bytecount << IGC_ADVTXD_PAYLEN_SHIFT;
> +
> +	switch (type) {
> +	case IGC_SMD_TYPE_SMD_V:
> +		olinfo_status |=3D (IGC_TXD_POPTS_SMD_V << 8);
> +		break;
> +	case IGC_SMD_TYPE_SMD_R:
> +		olinfo_status |=3D (IGC_TXD_POPTS_SMD_R << 8);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	desc =3D IGC_TX_DESC(ring, ring->next_to_use);
> +	desc->read.cmd_type_len =3D cpu_to_le32(cmd_type);
> +	desc->read.olinfo_status =3D cpu_to_le32(olinfo_status);
> +	desc->read.buffer_addr =3D cpu_to_le64(dma_unmap_addr(buffer, dma));
> +
> +	netdev_tx_sent_queue(txring_txq(ring), skb->len);
> +
> +	buffer->next_to_watch =3D desc;
> +
> +	ring->next_to_use++;
> +	if (ring->next_to_use =3D=3D ring->count)
> +		ring->next_to_use =3D 0;
> +
> +	return 0;
> +}
> +
>  static struct igc_ring *igc_xdp_get_tx_ring(struct igc_adapter *adapter,
>  					    int cpu)
>  {
> @@ -2299,6 +2377,19 @@ static void igc_update_rx_stats(struct igc_q_vecto=
r *q_vector,
>  	q_vector->rx.total_bytes +=3D bytes;
>  }
> =20
> +static int igc_rx_desc_smd_type(union igc_adv_rx_desc *rx_desc)
> +{
> +	u32 status =3D le32_to_cpu(rx_desc->wb.upper.status_error);
> +
> +	return (status & IGC_RXDADV_STAT_SMD_TYPE_MASK)
> +		>> IGC_RXDADV_STAT_SMD_TYPE_SHIFT;
> +}
> +
> +static bool igc_check_smd_frame(struct igc_rx_buffer *rx_buffer, unsigne=
d int size)
> +{
> +	return size =3D=3D 60;

You should probably also verify that the contents is 60 octets of zeroes (s=
ans the mCRC)?

> +}
> +
>  static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int bud=
get)
>  {
>  	unsigned int total_bytes =3D 0, total_packets =3D 0;
> @@ -2315,6 +2406,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_=
vector, const int budget)
>  		ktime_t timestamp =3D 0;
>  		struct xdp_buff xdp;
>  		int pkt_offset =3D 0;
> +		int smd_type;
>  		void *pktbuf;
> =20
>  		/* return some buffers to hardware, one at a time is too slow */
> @@ -2346,6 +2438,22 @@ static int igc_clean_rx_irq(struct igc_q_vector *q=
_vector, const int budget)
>  			size -=3D IGC_TS_HDR_LEN;
>  		}
> =20
> +		smd_type =3D igc_rx_desc_smd_type(rx_desc);
> +
> +		if (smd_type =3D=3D IGC_SMD_TYPE_SMD_V || smd_type =3D=3D IGC_SMD_TYPE=
_SMD_R) {

I guess the performance people will love you for this change. You should
probably guard it by an "if (unlikely(disableVerify =3D=3D false))" conditi=
on.

> +			if (igc_check_smd_frame(rx_buffer, size)) {
> +				adapter->fp_received_smd_v =3D smd_type =3D=3D IGC_SMD_TYPE_SMD_V;
> +				adapter->fp_received_smd_r =3D smd_type =3D=3D IGC_SMD_TYPE_SMD_R;
> +				schedule_delayed_work(&adapter->fp_verification_work, 0);
> +			}
> +
> +			/* Advance the ring next-to-clean */
> +			igc_is_non_eop(rx_ring, rx_desc);
> +
> +			cleaned_count++;
> +			continue;
> +		}
> +
>  		if (!skb) {
>  			xdp_init_buff(&xdp, truesize, &rx_ring->xdp_rxq);
>  			xdp_prepare_buff(&xdp, pktbuf - igc_rx_offset(rx_ring),
> @@ -5607,6 +5715,107 @@ static int igc_tsn_enable_qbv_scheduling(struct i=
gc_adapter *adapter,
>  	return igc_tsn_offload_apply(adapter);
>  }
> =20
> +/* I225 doesn't send the SMD frames automatically, we need to handle
> + * them ourselves.
> + */
> +static int igc_xmit_smd_frame(struct igc_adapter *adapter, int type)
> +{
> +	int cpu =3D smp_processor_id();
> +	struct netdev_queue *nq;
> +	struct igc_ring *ring;
> +	struct sk_buff *skb;
> +	void *data;
> +	int err;
> +
> +	if (!netif_running(adapter->netdev))
> +		return -ENOTCONN;
> +
> +	/* FIXME: rename this function to something less specific, as
> +	 * it can be used outside XDP.
> +	 */
> +	ring =3D igc_xdp_get_tx_ring(adapter, cpu);
> +	nq =3D txring_txq(ring);
> +
> +	skb =3D alloc_skb(IGC_FP_SMD_FRAME_SIZE, GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	data =3D skb_put(skb, IGC_FP_SMD_FRAME_SIZE);
> +	memset(data, 0, IGC_FP_SMD_FRAME_SIZE);
> +
> +	__netif_tx_lock(nq, cpu);
> +
> +	err =3D igc_fp_init_tx_descriptor(ring, skb, type);
> +
> +	igc_flush_tx_descriptors(ring);
> +
> +	__netif_tx_unlock(nq);
> +
> +	return err;
> +}
> +
> +static void igc_fp_verification_work(struct work_struct *work)
> +{
> +	struct delayed_work *dwork =3D to_delayed_work(work);
> +	struct igc_adapter *adapter;
> +	int err;
> +
> +	adapter =3D container_of(dwork, struct igc_adapter, fp_verification_wor=
k);
> +
> +	if (adapter->fp_disable_verify)
> +		goto done;
> +
> +	switch (adapter->fp_tx_state) {
> +	case FRAME_PREEMPTION_STATE_START:
> +		adapter->fp_received_smd_r =3D false;
> +		err =3D igc_xmit_smd_frame(adapter, IGC_SMD_TYPE_SMD_V);
> +		if (err < 0)
> +			netdev_err(adapter->netdev, "Error sending SMD-V frame\n");

On TX error should you really advance to the STATE_SENT?

> +
> +		adapter->fp_tx_state =3D FRAME_PREEMPTION_STATE_SENT;
> +		adapter->fp_start =3D jiffies;
> +		schedule_delayed_work(&adapter->fp_verification_work, IGC_FP_TIMEOUT);
> +		break;
> +
> +	case FRAME_PREEMPTION_STATE_SENT:
> +		if (adapter->fp_received_smd_r) {
> +			adapter->fp_tx_state =3D FRAME_PREEMPTION_STATE_DONE;
> +			adapter->fp_received_smd_r =3D false;
> +			break;
> +		}
> +
> +		if (time_is_before_jiffies(adapter->fp_start + IGC_FP_TIMEOUT)) {
> +			adapter->fp_verify_cnt++;
> +			netdev_warn(adapter->netdev, "Timeout waiting for SMD-R frame\n");
> +
> +			if (adapter->fp_verify_cnt > IGC_MAX_VERIFY_CNT) {
> +				adapter->fp_verify_cnt =3D 0;
> +				adapter->fp_tx_state =3D FRAME_PREEMPTION_STATE_FAILED;
> +				netdev_err(adapter->netdev,
> +					   "Exceeded number of attempts for frame preemption verification\n=
");
> +			} else {
> +				adapter->fp_tx_state =3D FRAME_PREEMPTION_STATE_START;
> +			}
> +			schedule_delayed_work(&adapter->fp_verification_work, IGC_FP_TIMEOUT)=
;
> +		}
> +
> +		break;
> +
> +	case FRAME_PREEMPTION_STATE_FAILED:
> +	case FRAME_PREEMPTION_STATE_DONE:
> +		break;
> +	}
> +
> +done:
> +	if (adapter->fp_received_smd_v) {
> +		err =3D igc_xmit_smd_frame(adapter, IGC_SMD_TYPE_SMD_R);
> +		if (err < 0)
> +			netdev_err(adapter->netdev, "Error sending SMD-R frame\n");
> +
> +		adapter->fp_received_smd_v =3D false;
> +	}
> +}
> +
>  static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
>  			void *type_data)
>  {
> @@ -6023,6 +6232,7 @@ static int igc_probe(struct pci_dev *pdev,
> =20
>  	INIT_WORK(&adapter->reset_task, igc_reset_task);
>  	INIT_WORK(&adapter->watchdog_task, igc_watchdog_task);
> +	INIT_DELAYED_WORK(&adapter->fp_verification_work, igc_fp_verification_w=
ork);
> =20
>  	/* Initialize link properties that are user-changeable */
>  	adapter->fc_autoneg =3D true;
> @@ -6044,6 +6254,12 @@ static int igc_probe(struct pci_dev *pdev,
> =20
>  	igc_ptp_init(adapter);
> =20
> +	/* FIXME: This sets the default to not do the verification
> +	 * automatically, when we have support in multiple
> +	 * controllers, this default can be changed.
> +	 */
> +	adapter->fp_disable_verify =3D true;
> +

Hmmmmm. So we need to instruct our users to explicitly enable
verification in their ethtool-based scripts, since the default values
will vary wildly from one vendor to another. On LS1028A I see no reason
why verification would be disabled by default.

>  	/* reset the hardware with the new settings */
>  	igc_reset(adapter);
> =20
> --=20
> 2.32.0
>=20
