Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BA54DB9DB
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 22:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243568AbiCPVDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 17:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238785AbiCPVDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 17:03:23 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8125721BE
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 14:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647464528; x=1679000528;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0wX1dx0f2r81tDDrgFjunXf49EVd8CDorNGhCJbDO/M=;
  b=dsA7wyy/0hzZaHhJFWT8m2LstKRIeA0o4eRyHTLY1RDnfygxHwvksEMP
   hmhPuO8Rkw1bikiXUTp8gyHlOuWYlZXxUomLD7whb2OtmfJTmGrBpJiy4
   ScZBB61VnxmOGum8MHbhVGzDtn61bQ5NBJ5tHdtuNS71y68MAbGiBP0E6
   GltFtOJxvFulYL66IWFkAn4QR16BOjxsVddIrp08npdpSn7uprrK86JW4
   Iwd/lyBySCKHavaLCpF7FOLNSPWOEQwJbfCUumGrayM8s5xwvItWmzson
   qGaNNN1Vo7eiFYCPyef5emPoBlJjrGiJGHq30bhf6L7cSdc5M4CLrEbxJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="237318234"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208,217";a="237318234"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 14:02:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208,217";a="613781300"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 16 Mar 2022 14:02:08 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 14:02:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 16 Mar 2022 14:02:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 16 Mar 2022 14:02:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPdn6mgyxwDAOmFzkIylnVSs1FfcSESChQ9QMLF/kTyFiiABP1eHQXv9xwCLoTuhpRuknC/ZOkub9ZTcKtv5g3DfDRO1XjLU57p++6JgCXORdE62OOYwV9G0UWO8r6khK4GxOE7UtMG9YyQNWp5UP5odZml+UpOrtQE7g5jy9cX4817uvNQLZU7ZpcBJQ/CVRUOH42szI4qUhwAUlB7ftJpcUaZ2hks3NlTefV99zb66lvCI5SDuZkW7bonGORIL6dvw+AGTO0EUOTw7sw2ZRCHh2CaE4Q3TzMiDBt8OcjlGWF+ANy5wzNIGffWYMDTUeJUlX4jN2u0pTgR1QWmzRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bhh0m9aHn63Qcu01ulvzGeaPdfnSA00pB6hnaSnloX8=;
 b=Lw8BRU2/uujNnzZJZy3apcNnKS0F6ou8cxwLFT52RqNCmNg01tRyzQs1kJ3foav3MOp/lbLo+B2GeVI9iCRtortXCIO4P0KwxsNYEsumJXez0paVvv8Hkzofeh3Gyy2tpziclLGieUemY6DkUAcmC1jDQU/2RkQ6U0PLsRwhAD50KMgpCFSOTAh2dTEbeJVbBYXcgJCBcZMphNRnZdmvFEdJ9JxWC0oecVzRzAiyBe9Cx5HgRKIGYsCvdokm+C90u547LkAkAauuvbupkxrQoY/kV1+kTce0QMifnraB8ldj6F1Iahh6OcOQaQqRLyWllZ7TvXuJXkkjOhnot7vsFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5482.namprd11.prod.outlook.com (2603:10b6:408:103::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 16 Mar
 2022 21:02:06 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8%8]) with mapi id 15.20.5081.014; Wed, 16 Mar 2022
 21:02:05 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Drewek, Wojciech" <wojciech.drewek@intel.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "laforge@gnumonks.org" <laforge@gnumonks.org>,
        "osmocom-net-gprs@lists.osmocom.org" 
        <osmocom-net-gprs@lists.osmocom.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH net-next 4/4] ice: add trace events for tx timestamps
Thread-Topic: [PATCH net-next 4/4] ice: add trace events for tx timestamps
Thread-Index: AQHYOXYIibbGubT6CkWLgOQBrxlnZKzCfstQ
Date:   Wed, 16 Mar 2022 21:02:05 +0000
Message-ID: <CO1PR11MB508909743E1C3DF45037053ED6119@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220316204024.3201500-1-anthony.l.nguyen@intel.com>
 <20220316204024.3201500-5-anthony.l.nguyen@intel.com>
In-Reply-To: <20220316204024.3201500-5-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 415d8afd-37fa-41c9-f902-08da07903a26
x-ms-traffictypediagnostic: BN9PR11MB5482:EE_
x-microsoft-antispam-prvs: <BN9PR11MB5482A29C72E4FBA92C735FB9D6119@BN9PR11MB5482.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mk4SPptVAAEYOltL7rhgm4vgzjRbYuE4WBhZ9p0hLBPBdLnr3+QLVVw2qT+lV3gltR+VnAhJ+QFBIxt6TCjbBngvSqqL5jLJai6qhKQE7EBvsHYfXYIOKXHn1NfCqbUwvECxeDdPzC+Of8MDRL34AeKWUOMvoebjRL7kuOPXDhyhIvFY1knaZ6z17qcLn3JZgTrDnHEce8ys17ANtbXiLGjwS0u5LQo+HcSkhrQCKyR1j88ZcHdhH5e3utqWAowE0IcirW17CTnfLkCVxMhIFmzMelhK6r/Eu5pdzU/Fm59dRbt0vsh5q1Ib4jQZZCJiGEt6mstjUguOMYwwWan6AVCeX120a+LoRCuTzhxkXEZ53S2G/iGAiLC5NCAsjeVJpiII6wu5wYqArsTpH4se/oP3m1nHI9a1hrMoVbHlrv4Ii5UU+pTdgXANYk/scJAmEZmo9KMlbFkV81Yl0oLJF7C3WRkajN1jFEoPFKaVFIS/T3s9SDUqySvnLv0v6Onx2s7pQ/ugo//Y2IRfVz18cG02R0OxYzBa0gA+m5Uv5WF8D1VxF/HNRDZ+OCs/nXE0+Md6QZ7iw+IHSIvXCZVc9oAB8zV7kWfaxQ3SEYWfKszCI+VJ5LBCLDCrjJvxyBbNNivHHVTS33cwBakCzjA32iP80mvj9AXG0jUvaOYo067ADpfs6o3aZopnPD81xp3ExkyvsoEtuL85jgVyxRp1MQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(26005)(83380400001)(9686003)(186003)(52536014)(53546011)(82960400001)(508600001)(5660300002)(7696005)(71200400001)(2906002)(8936002)(122000001)(86362001)(76116006)(8676002)(66446008)(66476007)(66556008)(66946007)(64756008)(4326008)(33656002)(110136005)(55016003)(54906003)(316002)(107886003)(38100700002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cfTJby0mCPgvgOKt2I5flGXhN53XsDarF9JTfmz9pZX096bYVTCgjjW4nLsv?=
 =?us-ascii?Q?Jo1/2KenhuVyxKPMwFUvdE3mzOFSusR8K0MiKaMysy9ysBedsEhjsRWpffh0?=
 =?us-ascii?Q?XGuce7QIlUp8U2e+7RTASzo8T90KuwEpOf7Axs8xrqOLVETFS4RS18fC9OZa?=
 =?us-ascii?Q?CtNNYlMxNq6kuhPMGb/EECLBW2UFEFOslBTk9b9PAN0aYrk28d2YZvvaC964?=
 =?us-ascii?Q?B1Mq+0sQ5CwXrsrApT9Amq36x0bGLPlo+pi+ag+EQi+URqmYsQX89CngbfFY?=
 =?us-ascii?Q?Zx/zpBNkhW8pTh3RfindHpO+NP4ER3N8nU950G7h4pszDmAz+662K2FiTn/C?=
 =?us-ascii?Q?hqgv0gdr1keYZuozJcjrXfPvuM21bhiib1/4JCkt5vm4hXbU6/d0vLyjMza3?=
 =?us-ascii?Q?eD0flpGZzoQDf7lpXugsrfP/ukUe0U1s7H//lhfbxNdHrUDvURz5Iz7ceb9O?=
 =?us-ascii?Q?VMc6wLcknEgSyDNJlRk3cEkWszsM7x5mp2hpAjxmFmidldl2p5nhYMoIy97f?=
 =?us-ascii?Q?G6hcTxELJbccJcbPbbNwYOseQUSJNscYrQhZBQzpzlLkaNqBqn42XdzIXP+M?=
 =?us-ascii?Q?H0tLo28E/V8p+U4vkDeZIVL2zNNLsVRxkCnbmzp9ma7qT06/iFGgO3T8jbQv?=
 =?us-ascii?Q?OmSnegsxACKNBx8mmQybHKmFFSkwAND7giPd41HBc03HirFD3IKexY96Tcbv?=
 =?us-ascii?Q?wGlO6aUg/BxnTWTqlZHnQD0fJL4vPTmhPz3/i+D6lY4viaboFocBJvEcpfyt?=
 =?us-ascii?Q?Nxet/OOaVS3SEAww6E7tMJPgCtzso7+o7R0Iq4A+BaD1I9/DbmqyAWpzVlNJ?=
 =?us-ascii?Q?dmWdy7xReitx0Lcoa+L87NSmAYjn2bmLdUmjinJYq3ZAHCPBtkiPaeQsCGSg?=
 =?us-ascii?Q?9EnbgMvfMffmfHH4i9ZU2IivGKHLmGc/gMN16Yc2wzpqRfRmNbX6lHM2wW22?=
 =?us-ascii?Q?BfeK142hslkIbTi3yKS753y++f3UZx1V5oWa2gbmswj9wJ85fVImmmQSDLLS?=
 =?us-ascii?Q?afhhq7KwoGYIgH/OVGEEW86K8MLQzlIqAP+PjyyhsEeQtECnuM/uBI5iUNmt?=
 =?us-ascii?Q?q1pqS8fnY6ybt+fB1RqJ3BS0wnH8/lT4arpKQtARrbbjp/RrPd4bB4btsnqB?=
 =?us-ascii?Q?AB2eJDB3++eMzBncdyiSYeMnayb18Hlda94jfW4DUHA/1aDS8ZAhGq9Z3riz?=
 =?us-ascii?Q?TB5/hhwQueHzsqm9kBjbFQs2tsEhuXs1TPryssGOl38tgS8qk87uYhTmIx6x?=
 =?us-ascii?Q?uVKjTB2fmJfk6yzEAvTL/QizsvWPZ9YnjNnQFTJxcduNfHmkDf2hgV3rfAib?=
 =?us-ascii?Q?Wo7SQEfXAjgP2WyWyO+iTw04XVhYEG1cs9/SFcsP+hRPe1Q/6Rfbz90EbK3G?=
 =?us-ascii?Q?xpCUXfw+OXohMSjXczgRRSjywaxXXStOgA8j19tx9aqWTBX7NvnrIvdS7G2X?=
 =?us-ascii?Q?ujyztQTcZ5ds5hgU+JQP8KtySsM/Rgq3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 415d8afd-37fa-41c9-f902-08da07903a26
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 21:02:05.7101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QgOreyp40QmodvBYIVZc74ABy2D2YGE7xRtQ9fpEOO9Bk37zL5dwyrrU8vw0dHRK/HdoscR1yoMbUVpyjeEJvscN3lugcYIAnsaf8or+R+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5482
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Sent: Wednesday, March 16, 2022 1:40 PM
> To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com
> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org; N=
guyen,
> Anthony L <anthony.l.nguyen@intel.com>; Drewek, Wojciech
> <wojciech.drewek@intel.com>; pablo@netfilter.org; laforge@gnumonks.org;
> osmocom-net-gprs@lists.osmocom.org; G, GurucharanX
> <gurucharanx.g@intel.com>
> Subject: [PATCH net-next 4/4] ice: add trace events for tx timestamps
>=20
> From: Jacob Keller <jacob.e.keller@intel.com>
>=20
> We've previously run into many issues related to the latency of a Tx
> timestamp completion with the ice hardware. It can be difficult to
> determine the root cause of a slow Tx timestamp. To aid in this,
> introduce new trace events which capture timing data about when the
> driver reaches certain points while processing a transmit timestamp
>=20
>  * ice_tx_tstamp_request: Trace when the stack initiates a new timestamp
>    request.
>=20
>  * ice_tx_tstamp_fw_req: Trace when the driver begins a read of the
>    timestamp register in the work thread.
>=20
>  * ice_tx_tstamp_fw_done: Trace when the driver finishes reading a
>    timestamp register in the work thread.
>=20
>  * ice_tx_tstamp_complete: Trace when the driver submits the skb back to
>    the stack with a completed Tx timestamp.
>=20
> These trace events can be enabled using the standard trace event
> subsystem exposed by the ice driver. If they are disabled, they become
> no-ops with no run time cost.
>=20
> The following is a simple GNU AWK script which can highlight one
> potential way to use the trace events to capture latency data from the
> trace buffer about how long the driver takes to process a timestamp:
>=20
> -----
>   BEGIN {
>       PREC=3D256
>   }
>=20

Another engineer recently asked me about this script so I wanted to clarify=
 here: this is a GNU awk script intended to be invoked with "gawk -f <scrip=
t>". It relies on the trace events already being enabled and that it is rea=
ding the trace (or trace_pipe) file as its standard input.

Thanks,
Jake

>   # Detect requests
>   /tx_tstamp_request/ {
>       time=3Dstrtonum($4)
>       skb=3D$7
>=20
>       # Store the time of request for this skb
>       requests[skb] =3D time
>       printf("skb %s: idx %d at %.6f\n", skb, idx, time)
>   }
>=20
>   # Detect completions
>   /tx_tstamp_complete/ {
>       time=3Dstrtonum($4)
>       skb=3D$7
>       idx=3D$9
>=20
>       if (skb in requests) {
>           latency =3D (time - requests[skb]) * 1000
>           printf("skb %s: %.3f to complete\n", skb, latency)
>           if (latency > 4) {
>               printf(">>> HIGH LATENCY <<<\n")
>           }
>           printf("\n")
>       } else {
>           printf("!!! skb %s (idx %d) at %.6f\n", skb, idx, time)
>       }
>   }
> -----
>=20
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at
> Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c   |  8 ++++++++
>  drivers/net/ethernet/intel/ice/ice_trace.h | 24 ++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c
> b/drivers/net/ethernet/intel/ice/ice_ptp.c
> index 000c39d163a2..a1cd33273ca4 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
> @@ -3,6 +3,7 @@
>=20
>  #include "ice.h"
>  #include "ice_lib.h"
> +#include "ice_trace.h"
>=20
>  #define E810_OUT_PROP_DELAY_NS 1
>=20
> @@ -2063,11 +2064,15 @@ static void ice_ptp_tx_tstamp_work(struct
> kthread_work *work)
>  		struct sk_buff *skb;
>  		int err;
>=20
> +		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
> +
>  		err =3D ice_read_phy_tstamp(hw, tx->quad, phy_idx,
>  					  &raw_tstamp);
>  		if (err)
>  			continue;
>=20
> +		ice_trace(tx_tstamp_fw_done, tx->tstamps[idx].skb, idx);
> +
>  		/* Check if the timestamp is invalid or stale */
>  		if (!(raw_tstamp & ICE_PTP_TS_VALID) ||
>  		    raw_tstamp =3D=3D tx->tstamps[idx].cached_tstamp)
> @@ -2093,6 +2098,8 @@ static void ice_ptp_tx_tstamp_work(struct
> kthread_work *work)
>  		tstamp =3D ice_ptp_extend_40b_ts(pf, raw_tstamp);
>  		shhwtstamps.hwtstamp =3D ns_to_ktime(tstamp);
>=20
> +		ice_trace(tx_tstamp_complete, skb, idx);
> +
>  		skb_tstamp_tx(skb, &shhwtstamps);
>  		dev_kfree_skb_any(skb);
>  	}
> @@ -2131,6 +2138,7 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct
> sk_buff *skb)
>  		tx->tstamps[idx].start =3D jiffies;
>  		tx->tstamps[idx].skb =3D skb_get(skb);
>  		skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
> +		ice_trace(tx_tstamp_request, skb, idx);
>  	}
>=20
>  	spin_unlock(&tx->lock);
> diff --git a/drivers/net/ethernet/intel/ice/ice_trace.h
> b/drivers/net/ethernet/intel/ice/ice_trace.h
> index cf685247c07a..ae98d5a8ff60 100644
> --- a/drivers/net/ethernet/intel/ice/ice_trace.h
> +++ b/drivers/net/ethernet/intel/ice/ice_trace.h
> @@ -216,6 +216,30 @@ DEFINE_EVENT(ice_xmit_template, name, \
>  DEFINE_XMIT_TEMPLATE_OP_EVENT(ice_xmit_frame_ring);
>  DEFINE_XMIT_TEMPLATE_OP_EVENT(ice_xmit_frame_ring_drop);
>=20
> +DECLARE_EVENT_CLASS(ice_tx_tstamp_template,
> +		    TP_PROTO(struct sk_buff *skb, int idx),
> +
> +		    TP_ARGS(skb, idx),
> +
> +		    TP_STRUCT__entry(__field(void *, skb)
> +				     __field(int, idx)),
> +
> +		    TP_fast_assign(__entry->skb =3D skb;
> +				   __entry->idx =3D idx;),
> +
> +		    TP_printk("skb %pK idx %d",
> +			      __entry->skb, __entry->idx)
> +);
> +#define DEFINE_TX_TSTAMP_OP_EVENT(name) \
> +DEFINE_EVENT(ice_tx_tstamp_template, name, \
> +	     TP_PROTO(struct sk_buff *skb, int idx), \
> +	     TP_ARGS(skb, idx))
> +
> +DEFINE_TX_TSTAMP_OP_EVENT(ice_tx_tstamp_request);
> +DEFINE_TX_TSTAMP_OP_EVENT(ice_tx_tstamp_fw_req);
> +DEFINE_TX_TSTAMP_OP_EVENT(ice_tx_tstamp_fw_done);
> +DEFINE_TX_TSTAMP_OP_EVENT(ice_tx_tstamp_complete);
> +
>  /* End tracepoints */
>=20
>  #endif /* _ICE_TRACE_H_ */
> --
> 2.31.1

