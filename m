Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D751D121A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 14:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbgEMMBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 08:01:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:3480 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbgEMMBB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 08:01:01 -0400
IronPort-SDR: IVL8krBBDz81XPmoOdwSYh9RzqAyRcD2Px0PIbyLT0H2aSnf8ESqnWmyhVw5ts7LwgPUuYqB09
 3M4vXPKBbX7A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 05:01:00 -0700
IronPort-SDR: MXVJw72vgrOW7KmiCR4GlxZRP7+Lcw0fbtQaYoW4Apmijz5BPzS2woGUqdVDBshoNSx+OQcplo
 2YANBUKlnsXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,387,1583222400"; 
   d="scan'208";a="287004975"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga004.fm.intel.com with ESMTP; 13 May 2020 05:01:00 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 13 May 2020 05:01:00 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 May 2020 05:01:00 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 13 May 2020 05:01:00 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.56) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 13 May 2020 05:00:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONdgdPaDywTh1UyoL4r8fcfJ60xKoyXfggpiyIkMj17csxupt5j7Dhqi6iBQTQ7DoliQR8P/o9FnGtAon3Z6TGnmVKEKVkaGFPrDqLLP/VdDsDO4YyDRBbKX3VJ1wwt+YHklOrdziq/mwyDSMu3qNafVqPDldBWfcRmvMkd2zGUXILCCh506lrgSj165yhOVFGfhU8fy0a9i+pT07uQupksMV0pUDmE7o1YTCKYEee5aTFvmAARhGmxKZI+HAZ48ScLcBpCNL+0li0TKInQjvOmAulO7NMLcTJZvJQiToEF8OBkj7PDd/ZjCTq8leOSjGk6Ykbys1wwWnIg3uns/Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDSwQ5tQJoLraDLivU5fnmOSjlpoqodj7DeAEB+ukyQ=;
 b=G0iPX2HEKpZPu4W+u/iHJNxQ9k9qQjrGf+3/1BzloYarsJjUr8wCVqWeTNk91Poo3L6NoeOjSW3/iySS696A76sFjNSklj/LlfKR8vFK+XXbaWTTK1p30sK6uBA9raUhMnV3yJ9LgdCq+QLRg+bRnLQnHeDv440nRXAV5B3Z+kL9QQs3JS1wXB2EA0bLlRC2SOQl+iDjGNvdTLA0pTG81gs0IPMP5T23Db4TI6P1M9YnwdeVc3OHzMQZvgRpM7wcjekUz47STo6FY4WTYmOhp+BY4Vhnk9zbszSu2eaCpqAMglenm3QNVMvyxYvqzueUCzs0T1whyhgW5XUob6xUiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDSwQ5tQJoLraDLivU5fnmOSjlpoqodj7DeAEB+ukyQ=;
 b=UuPgmaS+qp0Y3d1tPxPNGHJ2YzUzKXPkbDg+vv9ywq3Ao0w6fzSZG6VPR3+I5d7SoNXLAAXJ00jh6oum9Ni6iKmgiUWmJ+4Ldd4aaiacfnXCI7rfvQzTBMz9DtMbWmjJd+fkQUCVd6H+GDNU8SthD8guKcwjJtZyUQSwn64/tko=
Received: from BL0PR11MB3057.namprd11.prod.outlook.com (2603:10b6:208:76::21)
 by BL0SPR01MB0023.namprd11.prod.outlook.com (2603:10b6:208:72::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 13 May
 2020 12:00:51 +0000
Received: from BL0PR11MB3057.namprd11.prod.outlook.com
 ([fe80::a486:da53:2f51:3eb7]) by BL0PR11MB3057.namprd11.prod.outlook.com
 ([fe80::a486:da53:2f51:3eb7%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 12:00:51 +0000
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
Thread-Index: AQHWIe4nG3hE5Qb3KkWLunzlIQwQeKilHDcAgADbixA=
Date:   Wed, 13 May 2020 12:00:51 +0000
Message-ID: <BL0PR11MB3057066ACAE065DC9426FAE3F2BF0@BL0PR11MB3057.namprd11.prod.outlook.com>
References: <20200504082558.112627-1-joyce.ooi@intel.com>
 <20200504082558.112627-11-joyce.ooi@intel.com> <20200512225240.GA18344@bogus>
In-Reply-To: <20200512225240.GA18344@bogus>
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
x-ms-office365-filtering-correlation-id: 8dec8d24-3d81-4737-6254-08d7f7354855
x-ms-traffictypediagnostic: BL0SPR01MB0023:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0SPR01MB0023C9AE8CDF781EFC1DD686F2BF0@BL0SPR01MB0023.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0402872DA1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vvpO2uEjipviToHdEhGZUM5R9+tygaQLdhy4U7qh/gh/EnEHXu4zFPDzjnuW1XG8GXw+g/DM4FgAUMAiUbWOoQAYP0g8VQqnIYCoXA3S+khHkTlQbArkIEfKOoFEmkSosFYxPBwR5+JVhQcEd8Dhwt+mAJVCmlmF8tmT1FYVcOuy7H5DkOtrGP+iyi1f/5kU22wGnSYTbBhu2IKAgMZE+k+AOF/UeuYpqvTaUQWFN4keCRwS4Fy8Ei2wNT0Pt8JHgHuiNpeaRRuWTOaoggM4hfmvZDSn9CAwzhMUFvMdVzRjDOcXJ5NLLnYiKf0ZjNNpiXs/Sw1yhDSWBoso33iOpdY40azNju8Xlrz3L2XGOcOKL82ViqBbFetECP4LibbJ63XZr/LYbx40PaTs2hB2/qoqN9u2EH7F3RygkkUgf471B6O82NYemvt5fv0rcadoeKVFK24Jw6RGJv8I8nLd1Ly5qVQ7rjn9TDkApTEI8KAYDp8D5HzTVFJpQMje6D0JuPz2OVj1H4/0k4p7k3AtiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3057.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(33430700001)(55016002)(6506007)(15650500001)(54906003)(53546011)(7696005)(316002)(26005)(5660300002)(2906002)(86362001)(33656002)(186003)(9686003)(478600001)(71200400001)(4326008)(8676002)(6916009)(8936002)(66476007)(66446008)(76116006)(64756008)(52536014)(33440700001)(66556008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Qxa1gDiPF2deYr7xbA8KqlSJu7B/sC3qEZJ4HHeQ6iPUKiWiWz249NgUKMc/YLWPId0S6Syb9jg+TKLAxXWBL1OrghrQeGUb3bPL5CjHtWd6E8lky1oxmlCDuvojlAafSOteUrhtFE7TgDiYu5nRgM4V+xGkxtA+3NPmClXePqWGnExxkXT+8/M2jKyc5zLMFxgPQNL32TnOYlVu9vGylg3aAwFEO/Uwz3DQAyTcOiJdF+vZOwzbqTOrw6Z7RIBcT148i0WWFqKNYC75KdleJNiETQX6XPr1G1SR03PEPo1knTJI+nWCUl6qsA1scjeCiNx9WtR+twFqTq/GLx3u7jZIv+jjT/DbPpOt3Saty3wtaUaiIwSFW8mG8Srxdh4xG7Ncrl+9ML6C3SGbSGcvwM4IRnm8zva4NH2h2Fw32BkSuiHeo9FuW9v/UhyKgf1dIOKy0mo/wjU+56m0HCb4FCLTKHmOM05So39gyM3p8WQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dec8d24-3d81-4737-6254-08d7f7354855
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2020 12:00:51.2678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IBHiKq2veFR3I6E4S6m30+e3uTtSi5tGzByiGHA5p255YG8pn2GLIQDYwlUvWQQ+pMbivnQ6Q4lfubifXo+6lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0SPR01MB0023
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Rob Herring <robh@kernel.org>
> Sent: Wednesday, May 13, 2020 6:53 AM
> To: Ooi, Joyce <joyce.ooi@intel.com>
> Cc: Thor Thayer <thor.thayer@linux.intel.com>; David S . Miller
> <davem@davemloft.net>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Westergreen, Dalon
> <dalon.westergreen@intel.com>; Tan, Ley Foon <ley.foon.tan@intel.com>;
> See, Chin Liang <chin.liang.see@intel.com>; Nguyen, Dinh
> <dinh.nguyen@intel.com>; devicetree@vger.kernel.org
> Subject: Re: [PATCHv2 10/10] net: eth: altera: update devicetree bindings
> documentation
>=20
> On Mon, May 04, 2020 at 04:25:58PM +0800, Joyce Ooi wrote:
> > From: Dalon Westergreen <dalon.westergreen@intel.com>
> >
> > Update devicetree bindings documentation to include msgdma prefetcher
> > and ptp bindings.
> >
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
> > Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
> > ---
> > v2: no change
> > ---
> >  .../devicetree/bindings/net/altera_tse.txt         | 103
> +++++++++++++++++----
> >  1 file changed, 84 insertions(+), 19 deletions(-)
>=20
> Reviewed-by: Rob Herring <robh@kernel.org>
>=20
> One nit below.
>=20
> >
> > diff --git a/Documentation/devicetree/bindings/net/altera_tse.txt
> > b/Documentation/devicetree/bindings/net/altera_tse.txt
> > index 0b7d4d3758ea..2f2d12603907 100644
> > --- a/Documentation/devicetree/bindings/net/altera_tse.txt
> > +++ b/Documentation/devicetree/bindings/net/altera_tse.txt
> > @@ -2,53 +2,86 @@
> >
> >  Required properties:
> >  - compatible: Should be "altr,tse-1.0" for legacy SGDMA based TSE, and
> should
> > -		be "altr,tse-msgdma-1.0" for the preferred MSGDMA based
> TSE.
> > +		be "altr,tse-msgdma-1.0" for the preferred MSGDMA based
> TSE,
> > +		and "altr,tse-msgdma-2.0" for MSGDMA with prefetcher
> based
> > +		implementations.
> >  		ALTR is supported for legacy device trees, but is deprecated.
> >  		altr should be used for all new designs.
> >  - reg: Address and length of the register set for the device. It conta=
ins
> >    the information of registers in the same order as described by
> > reg-names
> >  - reg-names: Should contain the reg names
> > -  "control_port": MAC configuration space region
> > -  "tx_csr":       xDMA Tx dispatcher control and status space region
> > -  "tx_desc":      MSGDMA Tx dispatcher descriptor space region
> > -  "rx_csr" :      xDMA Rx dispatcher control and status space region
> > -  "rx_desc":      MSGDMA Rx dispatcher descriptor space region
> > -  "rx_resp":      MSGDMA Rx dispatcher response space region
> > -  "s1":		  SGDMA descriptor memory
> >  - interrupts: Should contain the TSE interrupts and it's mode.
> >  - interrupt-names: Should contain the interrupt names
> > -  "rx_irq":       xDMA Rx dispatcher interrupt
> > -  "tx_irq":       xDMA Tx dispatcher interrupt
> > +  "rx_irq":       DMA Rx dispatcher interrupt
> > +  "tx_irq":       DMA Tx dispatcher interrupt
> >  - rx-fifo-depth: MAC receive FIFO buffer depth in bytes
> >  - tx-fifo-depth: MAC transmit FIFO buffer depth in bytes
> >  - phy-mode: See ethernet.txt in the same directory.
> >  - phy-handle: See ethernet.txt in the same directory.
> >  - phy-addr: See ethernet.txt in the same directory. A configuration sh=
ould
> >  		include phy-handle or phy-addr.
> > -- altr,has-supplementary-unicast:
> > -		If present, TSE supports additional unicast addresses.
> > -		Otherwise additional unicast addresses are not supported.
> > -- altr,has-hash-multicast-filter:
> > -		If present, TSE supports a hash based multicast filter.
> > -		Otherwise, hash-based multicast filtering is not supported.
> > -
> >  - mdio device tree subnode: When the TSE has a phy connected to its lo=
cal
> >  		mdio, there must be device tree subnode with the following
> >  		required properties:
> > -
> >  	- compatible: Must be "altr,tse-mdio".
> >  	- #address-cells: Must be <1>.
> >  	- #size-cells: Must be <0>.
> >
> >  	For each phy on the mdio bus, there must be a node with the
> following
> >  	fields:
> > -
> >  	- reg: phy id used to communicate to phy.
> >  	- device_type: Must be "ethernet-phy".
> >
> >  The MAC address will be determined using the optional properties
> > defined in  ethernet.txt.
> >
> > +- altr,has-supplementary-unicast:
> > +		If present, TSE supports additional unicast addresses.
> > +		Otherwise additional unicast addresses are not supported.
> > +- altr,has-hash-multicast-filter:
> > +		If present, TSE supports a hash based multicast filter.
> > +		Otherwise, hash-based multicast filtering is not supported.
> > +- altr,has-ptp:
> > +		If present, TSE supports 1588 timestamping.  Currently only
> > +		supported with the msgdma prefetcher.
> > +- altr,tx-poll-cnt:
> > +		Optional cycle count for Tx prefetcher to poll descriptor
> > +		list.  If not present, defaults to 128, which at 125MHz is
> > +		roughly 1usec. Only for "altr,tse-msgdma-2.0".
> > +- altr,rx-poll-cnt:
> > +		Optional cycle count for Tx prefetcher to poll descriptor
> > +		list.  If not present, defaults to 128, which at 125MHz is
> > +		roughly 1usec. Only for "altr,tse-msgdma-2.0".
> > +
> > +Required registers by compatibility string:
> > + - "altr,tse-1.0"
> > +	"control_port": MAC configuration space region
> > +	"tx_csr":       DMA Tx dispatcher control and status space region
> > +	"rx_csr" :      DMA Rx dispatcher control and status space region
> > +	"s1":		DMA descriptor memory
> > +
> > + - "altr,tse-msgdma-1.0"
> > +	"control_port": MAC configuration space region
> > +	"tx_csr":       DMA Tx dispatcher control and status space region
> > +	"tx_desc":      DMA Tx dispatcher descriptor space region
> > +	"rx_csr" :      DMA Rx dispatcher control and status space region
> > +	"rx_desc":      DMA Rx dispatcher descriptor space region
> > +	"rx_resp":      DMA Rx dispatcher response space region
> > +
> > + - "altr,tse-msgdma-2.0"
> > +	"control_port": MAC configuration space region
> > +	"tx_csr":       DMA Tx dispatcher control and status space region
> > +	"tx_pref":      DMA Tx prefetcher configuration space region
> > +	"rx_csr" :      DMA Rx dispatcher control and status space region
> > +	"rx_pref":      DMA Rx prefetcher configuration space region
> > +	"tod_ctrl":     Time of Day Control register only required when
> > +			timestamping support is enabled.  Timestamping is
> > +			only supported with the msgdma-2.0
> implementation.
> > +
> > +Optional properties:
> > +- local-mac-address: See ethernet.txt in the same directory.
> > +- max-frame-size: See ethernet.txt in the same directory.
> > +
> >  Example:
> >
> >  	tse_sub_0_eth_tse_0: ethernet@1,00000000 { @@ -86,6 +119,11
> @@
> > Example:
> >  				device_type =3D "ethernet-phy";
> >  			};
> >
> > +			phy2: ethernet-phy@2 {
> > +				reg =3D <0x2>;
> > +				device_type =3D "ethernet-phy";
> > +			};
> > +
> >  		};
> >  	};
> >
> > @@ -111,3 +149,30 @@ Example:
> >  		altr,has-hash-multicast-filter;
> >  		phy-handle =3D <&phy1>;
> >  	};
> > +
> > +
> > +	tse_sub_2_eth_tse_0: ethernet@1,00002000 {
>=20
> What bus is this on? Usually a ',' like this is for a chip select number.=
 If just a
> 64-bit address, then no comma.

It's a 64-bit address. I'll remove the comma for this and the one above.
>=20
> > +		compatible =3D "altr,tse-msgdma-2.0";
> > +		reg =3D 	<0x00000001 0x00002000 0x00000400>,
> > +			<0x00000001 0x00002400 0x00000020>,
> > +			<0x00000001 0x00002420 0x00000020>,
> > +			<0x00000001 0x00002440 0x00000020>,
> > +			<0x00000001 0x00002460 0x00000020>,
> > +			<0x00000001 0x00002480 0x00000040>;
> > +		reg-names =3D "control_port", "rx_csr", "rx_pref","tx_csr",
> "tx_pref", "tod_ctrl";
> > +		interrupt-parent =3D <&hps_0_arm_gic_0>;
> > +		interrupts =3D <0 45 4>, <0 44 4>;
> > +		interrupt-names =3D "rx_irq", "tx_irq";
> > +		rx-fifo-depth =3D <2048>;
> > +		tx-fifo-depth =3D <2048>;
> > +		address-bits =3D <48>;
> > +		max-frame-size =3D <1500>;
> > +		local-mac-address =3D [ 00 00 00 00 00 00 ];
> > +		phy-mode =3D "sgmii";
> > +		altr,has-supplementary-unicast;
> > +		altr,has-hash-multicast-filter;
> > +		altr,has-ptp;
> > +		altr,tx-poll-cnt =3D <128>;
> > +		altr,rx-poll-cnt =3D <32>;
> > +		phy-handle =3D <&phy2>;
> > +	};
> > --
> > 2.13.0
> >
