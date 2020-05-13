Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC6B1D13E3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732949AbgEMNCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:02:16 -0400
Received: from mga05.intel.com ([192.55.52.43]:6612 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729931AbgEMNCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 09:02:15 -0400
IronPort-SDR: 9GHE7NdWBWO8AoupIr+jvcjFboHMBfhMZvkpG6zJDiUX26vECSx4BOpcd8tcxOiiuQi46bKZ+z
 +lB/aEQ4whkg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 06:01:11 -0700
IronPort-SDR: bdl43ZP35SjqcCVq29GvtswRVwWf6Wk1OXMdJTfztlBDBZOJDRScMb+1voKk74Nz7UGq4gxsRy
 26ty9UeYOoHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,387,1583222400"; 
   d="scan'208";a="298358669"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga008.jf.intel.com with ESMTP; 13 May 2020 06:01:11 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 13 May 2020 06:01:10 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 May 2020 06:01:10 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 13 May 2020 06:01:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 13 May 2020 06:00:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBhnD4VFtI88SafdrB1dR6d6lX3kudUnNQeWDLb9AxC2orosfJ2EIe1dv/0W5TMOIuJINxKMx+olUfsQUgK1ofav5+K481/yEMLP9e/CUU1mLPwOZEO4GVAZ4LofnCYeJvr+WMj/jUmkM6GJ2x7Bg02Y/3rY3dWAVituSzbOY6rajdaxCNtUUPH7Dnz2rfgJXJFK2+BJHEGROsVRXGNOBNQzuEaJREIZkybGCRhlucsiykvWElBSgqGj9SamMgrveEWIUmS7b+8mN2TDm+XP/uSi6KrTcbHK0ZxE3fudiGPAh5ZLQDi3awrH5XbEqsamHQ7B3yJaKu/Dh4DPSFOYhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sw6Mx5xV63W/6RbMybES29GnsXLsJbCsSI74akOvcHc=;
 b=jiStQ+O2MA6wp/YcBntqXjCzho+3i3EyOtWv/M8uUh43yE67+AX+oJC0f71uBNAAS95zX81Y5AgTzQ7jSnfoKX6PbpmwYzSRtQQFH4SpLfqOdxCBCykzkDORXwbhmitEpNBinqjpFunqBH6VO3IWIK271o91ZwIPnFeJHwa7flo7m6sQ0hwuuMJnkFB9+QJt0QXnPWSkeUS1stbPhguibMCXIJcaSk5lDuozNqJ+2TH3ueNEvxKrLtQ9m6wQTGkWKB5Ip359X0W0WzpwJULbyROuLJwhGBf3xO6RUTx2dGGtvcmnTe/Y9yOQIu9ECf0+onYbjY+sgNe2bhAzTCOtTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sw6Mx5xV63W/6RbMybES29GnsXLsJbCsSI74akOvcHc=;
 b=a4oUwRY1pvs0xG+DhtfpPh70kATZ9zBjHYagJqsb2zU58z98O2LUI0R+2ucFMJFtKa0WQxA67ZfehiUQV3ICqxBzMR9ZBHh2a8wcTNIQMgyK5dEfFOKoIldH2wu3cv5fRYHspOQ1/OuEaDSmRNIEC0oU/L9KIJ7kHGN57lkZtcY=
Received: from BL0PR11MB3057.namprd11.prod.outlook.com (2603:10b6:208:76::21)
 by BL0PR11MB3187.namprd11.prod.outlook.com (2603:10b6:208:67::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Wed, 13 May
 2020 13:00:47 +0000
Received: from BL0PR11MB3057.namprd11.prod.outlook.com
 ([fe80::a486:da53:2f51:3eb7]) by BL0PR11MB3057.namprd11.prod.outlook.com
 ([fe80::a486:da53:2f51:3eb7%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 13:00:47 +0000
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Rob Herring <robh@kernel.org>
CC:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Westergreen, Dalon" <dalon.westergreen@intel.com>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ooi, Joyce" <joyce.ooi@intel.com>
Subject: RE: [PATCHv2 10/10] net: eth: altera: update devicetree bindings
 documentation
Thread-Topic: [PATCHv2 10/10] net: eth: altera: update devicetree bindings
 documentation
Thread-Index: AQHWIe4nG3hE5Qb3KkWLunzlIQwQeKilHDcAgADbixCAABAuMA==
Date:   Wed, 13 May 2020 13:00:47 +0000
Message-ID: <BL0PR11MB3057D0E54AA300CD4DF90F2AF2BF0@BL0PR11MB3057.namprd11.prod.outlook.com>
References: <20200504082558.112627-1-joyce.ooi@intel.com>
 <20200504082558.112627-11-joyce.ooi@intel.com> <20200512225240.GA18344@bogus>
 <BL0PR11MB3057066ACAE065DC9426FAE3F2BF0@BL0PR11MB3057.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB3057066ACAE065DC9426FAE3F2BF0@BL0PR11MB3057.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.139.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ec837c4-ee8c-4742-6188-08d7f73da7d0
x-ms-traffictypediagnostic: BL0PR11MB3187:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB318797AD7AFB2E70D6AF6C48F2BF0@BL0PR11MB3187.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0402872DA1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 86hN2ZD6/RWfMYrsbXgX0OGyLW8GZy0TlNoTe8pYPnI5bquY68obnZwQ6cr/bQSwHJDhJ8Yfjv/AdhVSMBBe0BfWyK6VmTf9AUW3a4k76aPZeb+yhLZEdqqksNh4DOS3EcwTLo+Z1Ku6RoM80Ue0akj2L1osT/urGI80uRiURNPcIhiweXqZ9q3LYiK4IknoH8O2TMYY+RGS/PeZKLUUqp9LdcDz3W66phmqkouR+GaqNi8B9NuV5ItPmFN6CCniOEnY/jit6QAi7eX/DOujI+40SA7pd1tAyKs97Z9JU0MoR2kSkSSJimS/UZd0H4V4tSjy4LPGeFwQe/pv58QLDjI9oyvf3iBSqy0LA+a3nh1hLLK4nnb2Dg2GxDLXeOo6Lf456Kl72coOwrirukrkapPds2N/oy7azdpPsAAkq6M6Mkd+QUkEG2wITbA4YYp65a37a4B8Sa9dfH6+djmrTuDC1yL+YUNTrevsH0JZXGr4QoApjvrO8XbISycAD/++tjg/zCU/iyhjuFTSzvbqQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3057.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(33430700001)(2906002)(5660300002)(86362001)(9686003)(76116006)(4326008)(71200400001)(316002)(33440700001)(55016002)(8936002)(2940100002)(15650500001)(6916009)(478600001)(6506007)(7696005)(54906003)(53546011)(64756008)(8676002)(26005)(52536014)(186003)(66446008)(66476007)(66556008)(33656002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: J0DItXkko0K5iIV19Kn+e5VlgEiiW3cCM6ciKxqpMT8iCDdBm4r+j/As9pdg+NOr02ac9nkwqUYpKrL+BhgZKNpp11td1Oh5OMhxMZBBNw4nO551ifHhBBZEIeT0rfwWA0/uQYInesVHm3dbY7mKccdQMY3DmSrPtwjE971lVJZlM5HpNmpp2T0xGltbqbBAtgoK/C4Se3iVEshNz4qmOFmcf6X5+OlzqWNHprfeOuxCL1cEjWlSXKncU9ZLQCTO6CMPCk0sGBbRJtwr95Csu7fIQospg5/7ery2zij9k6jrAVah871vEMm1iZxYel8fxNttGqHaPe1Qg3Wi4N6zBAgx8rUmUvrG/uAYYfwLixKWHoMZENqJTBZUxTX7IT/zy/hujDB92FvmbDRhRdjSGMctdWUke9T+eZpkPYTE+UsJxRAGEKJ15VX2j6ufEJTDtiyWFFnYmc2k/Tb6EwGnxkZzRY/8coPuaMQdksfRVng=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec837c4-ee8c-4742-6188-08d7f73da7d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2020 13:00:47.4992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gly0xeJcz9hKkAQCfOBABsvhwGVNsO/SNqa6+2xzEjYPjgJS6+vhu4Yd/l7kMprWlIE/krMmsgrRBln682g5Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3187
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ooi, Joyce <joyce.ooi@intel.com>
> Sent: Wednesday, May 13, 2020 8:01 PM
> To: Rob Herring <robh@kernel.org>
> Cc: Thor Thayer <thor.thayer@linux.intel.com>; David S . Miller
> <davem@davemloft.net>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Westergreen, Dalon <dalon.westergreen@intel.com>;
> Tan, Ley Foon <ley.foon.tan@intel.com>; See, Chin Liang
> <chin.liang.see@intel.com>; Nguyen, Dinh <dinh.nguyen@intel.com>;
> devicetree@vger.kernel.org; Ooi, Joyce <joyce.ooi@intel.com>
> Subject: RE: [PATCHv2 10/10] net: eth: altera: update devicetree bindings
> documentation
>=20
> > -----Original Message-----
> > From: Rob Herring <robh@kernel.org>
> > Sent: Wednesday, May 13, 2020 6:53 AM
> > To: Ooi, Joyce <joyce.ooi@intel.com>
> > Cc: Thor Thayer <thor.thayer@linux.intel.com>; David S . Miller
> > <davem@davemloft.net>; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; Westergreen, Dalon
> > <dalon.westergreen@intel.com>; Tan, Ley Foon <ley.foon.tan@intel.com>;
> > See, Chin Liang <chin.liang.see@intel.com>; Nguyen, Dinh
> > <dinh.nguyen@intel.com>; devicetree@vger.kernel.org
> > Subject: Re: [PATCHv2 10/10] net: eth: altera: update devicetree
> > bindings documentation
> >
> > On Mon, May 04, 2020 at 04:25:58PM +0800, Joyce Ooi wrote:
> > > From: Dalon Westergreen <dalon.westergreen@intel.com>
> > >
> > > Update devicetree bindings documentation to include msgdma
> > > prefetcher and ptp bindings.
> > >
> > > Cc: Rob Herring <robh+dt@kernel.org>
> > > Cc: devicetree@vger.kernel.org
> > > Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
> > > Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
> > > ---
> > > v2: no change
> > > ---
> > >  .../devicetree/bindings/net/altera_tse.txt         | 103
> > +++++++++++++++++----
> > >  1 file changed, 84 insertions(+), 19 deletions(-)
> >
> > Reviewed-by: Rob Herring <robh@kernel.org>
> >
> > One nit below.
> >
> > >
> > > diff --git a/Documentation/devicetree/bindings/net/altera_tse.txt
> > > b/Documentation/devicetree/bindings/net/altera_tse.txt
> > > index 0b7d4d3758ea..2f2d12603907 100644
> > > --- a/Documentation/devicetree/bindings/net/altera_tse.txt
> > > +++ b/Documentation/devicetree/bindings/net/altera_tse.txt
> > > @@ -2,53 +2,86 @@
> > >
> > >  Required properties:
> > >  - compatible: Should be "altr,tse-1.0" for legacy SGDMA based TSE,
> > > and
> > should
> > > -		be "altr,tse-msgdma-1.0" for the preferred MSGDMA based
> > TSE.
> > > +		be "altr,tse-msgdma-1.0" for the preferred MSGDMA based
> > TSE,
> > > +		and "altr,tse-msgdma-2.0" for MSGDMA with prefetcher
> > based
> > > +		implementations.
> > >  		ALTR is supported for legacy device trees, but is deprecated.
> > >  		altr should be used for all new designs.
> > >  - reg: Address and length of the register set for the device. It con=
tains
> > >    the information of registers in the same order as described by
> > > reg-names
> > >  - reg-names: Should contain the reg names
> > > -  "control_port": MAC configuration space region
> > > -  "tx_csr":       xDMA Tx dispatcher control and status space region
> > > -  "tx_desc":      MSGDMA Tx dispatcher descriptor space region
> > > -  "rx_csr" :      xDMA Rx dispatcher control and status space region
> > > -  "rx_desc":      MSGDMA Rx dispatcher descriptor space region
> > > -  "rx_resp":      MSGDMA Rx dispatcher response space region
> > > -  "s1":		  SGDMA descriptor memory
> > >  - interrupts: Should contain the TSE interrupts and it's mode.
> > >  - interrupt-names: Should contain the interrupt names
> > > -  "rx_irq":       xDMA Rx dispatcher interrupt
> > > -  "tx_irq":       xDMA Tx dispatcher interrupt
> > > +  "rx_irq":       DMA Rx dispatcher interrupt
> > > +  "tx_irq":       DMA Tx dispatcher interrupt
> > >  - rx-fifo-depth: MAC receive FIFO buffer depth in bytes
> > >  - tx-fifo-depth: MAC transmit FIFO buffer depth in bytes
> > >  - phy-mode: See ethernet.txt in the same directory.
> > >  - phy-handle: See ethernet.txt in the same directory.
> > >  - phy-addr: See ethernet.txt in the same directory. A configuration =
should
> > >  		include phy-handle or phy-addr.
> > > -- altr,has-supplementary-unicast:
> > > -		If present, TSE supports additional unicast addresses.
> > > -		Otherwise additional unicast addresses are not supported.
> > > -- altr,has-hash-multicast-filter:
> > > -		If present, TSE supports a hash based multicast filter.
> > > -		Otherwise, hash-based multicast filtering is not supported.
> > > -
> > >  - mdio device tree subnode: When the TSE has a phy connected to its =
local
> > >  		mdio, there must be device tree subnode with the following
> > >  		required properties:
> > > -
> > >  	- compatible: Must be "altr,tse-mdio".
> > >  	- #address-cells: Must be <1>.
> > >  	- #size-cells: Must be <0>.
> > >
> > >  	For each phy on the mdio bus, there must be a node with the
> > following
> > >  	fields:
> > > -
> > >  	- reg: phy id used to communicate to phy.
> > >  	- device_type: Must be "ethernet-phy".
> > >
> > >  The MAC address will be determined using the optional properties
> > > defined in  ethernet.txt.
> > >
> > > +- altr,has-supplementary-unicast:
> > > +		If present, TSE supports additional unicast addresses.
> > > +		Otherwise additional unicast addresses are not supported.
> > > +- altr,has-hash-multicast-filter:
> > > +		If present, TSE supports a hash based multicast filter.
> > > +		Otherwise, hash-based multicast filtering is not supported.
> > > +- altr,has-ptp:
> > > +		If present, TSE supports 1588 timestamping.  Currently only
> > > +		supported with the msgdma prefetcher.
> > > +- altr,tx-poll-cnt:
> > > +		Optional cycle count for Tx prefetcher to poll descriptor
> > > +		list.  If not present, defaults to 128, which at 125MHz is
> > > +		roughly 1usec. Only for "altr,tse-msgdma-2.0".
> > > +- altr,rx-poll-cnt:
> > > +		Optional cycle count for Tx prefetcher to poll descriptor
> > > +		list.  If not present, defaults to 128, which at 125MHz is
> > > +		roughly 1usec. Only for "altr,tse-msgdma-2.0".
> > > +
> > > +Required registers by compatibility string:
> > > + - "altr,tse-1.0"
> > > +	"control_port": MAC configuration space region
> > > +	"tx_csr":       DMA Tx dispatcher control and status space region
> > > +	"rx_csr" :      DMA Rx dispatcher control and status space region
> > > +	"s1":		DMA descriptor memory
> > > +
> > > + - "altr,tse-msgdma-1.0"
> > > +	"control_port": MAC configuration space region
> > > +	"tx_csr":       DMA Tx dispatcher control and status space region
> > > +	"tx_desc":      DMA Tx dispatcher descriptor space region
> > > +	"rx_csr" :      DMA Rx dispatcher control and status space region
> > > +	"rx_desc":      DMA Rx dispatcher descriptor space region
> > > +	"rx_resp":      DMA Rx dispatcher response space region
> > > +
> > > + - "altr,tse-msgdma-2.0"
> > > +	"control_port": MAC configuration space region
> > > +	"tx_csr":       DMA Tx dispatcher control and status space region
> > > +	"tx_pref":      DMA Tx prefetcher configuration space region
> > > +	"rx_csr" :      DMA Rx dispatcher control and status space region
> > > +	"rx_pref":      DMA Rx prefetcher configuration space region
> > > +	"tod_ctrl":     Time of Day Control register only required when
> > > +			timestamping support is enabled.  Timestamping is
> > > +			only supported with the msgdma-2.0
> > implementation.
> > > +
> > > +Optional properties:
> > > +- local-mac-address: See ethernet.txt in the same directory.
> > > +- max-frame-size: See ethernet.txt in the same directory.
> > > +
> > >  Example:
> > >
> > >  	tse_sub_0_eth_tse_0: ethernet@1,00000000 { @@ -86,6 +119,11
> > @@
> > > Example:
> > >  				device_type =3D "ethernet-phy";
> > >  			};
> > >
> > > +			phy2: ethernet-phy@2 {
> > > +				reg =3D <0x2>;
> > > +				device_type =3D "ethernet-phy";
> > > +			};
> > > +
> > >  		};
> > >  	};
> > >
> > > @@ -111,3 +149,30 @@ Example:
> > >  		altr,has-hash-multicast-filter;
> > >  		phy-handle =3D <&phy1>;
> > >  	};
> > > +
> > > +
> > > +	tse_sub_2_eth_tse_0: ethernet@1,00002000 {
> >
> > What bus is this on? Usually a ',' like this is for a chip select
> > number. If just a 64-bit address, then no comma.
>=20
> It's a 64-bit address. I'll remove the comma for this and the one above.
Found out that the comma is actually for a chip select. It was an old way o=
f sending between the lightweight bridge and main brigde to the FPGA.

> >
> > > +		compatible =3D "altr,tse-msgdma-2.0";
> > > +		reg =3D 	<0x00000001 0x00002000 0x00000400>,
> > > +			<0x00000001 0x00002400 0x00000020>,
> > > +			<0x00000001 0x00002420 0x00000020>,
> > > +			<0x00000001 0x00002440 0x00000020>,
> > > +			<0x00000001 0x00002460 0x00000020>,
> > > +			<0x00000001 0x00002480 0x00000040>;
> > > +		reg-names =3D "control_port", "rx_csr", "rx_pref","tx_csr",
> > "tx_pref", "tod_ctrl";
> > > +		interrupt-parent =3D <&hps_0_arm_gic_0>;
> > > +		interrupts =3D <0 45 4>, <0 44 4>;
> > > +		interrupt-names =3D "rx_irq", "tx_irq";
> > > +		rx-fifo-depth =3D <2048>;
> > > +		tx-fifo-depth =3D <2048>;
> > > +		address-bits =3D <48>;
> > > +		max-frame-size =3D <1500>;
> > > +		local-mac-address =3D [ 00 00 00 00 00 00 ];
> > > +		phy-mode =3D "sgmii";
> > > +		altr,has-supplementary-unicast;
> > > +		altr,has-hash-multicast-filter;
> > > +		altr,has-ptp;
> > > +		altr,tx-poll-cnt =3D <128>;
> > > +		altr,rx-poll-cnt =3D <32>;
> > > +		phy-handle =3D <&phy2>;
> > > +	};
> > > --
> > > 2.13.0
> > >
