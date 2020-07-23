Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3D122A3D6
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732755AbgGWArf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:47:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:65065 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgGWAre (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 20:47:34 -0400
IronPort-SDR: hfLLA5Vp+TqhgagAL6iMNpLhSey1VJQkh1FUz7xp34slXa/ULGPTJEdREidz2UQq2Ao8ZgVzMp
 k0AyQxmmLHSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="138527972"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="138527972"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 17:47:32 -0700
IronPort-SDR: 0DrW/RPprbN7H7OqQNO1RGZNU3+1zkFZ2QP3F1fipoMY0dwLx76jNnBmspyS89BbbrNxxYcTrO
 vFJizcLeZYyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="270899646"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jul 2020 17:47:32 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 Jul 2020 17:47:32 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 Jul 2020 17:47:32 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 22 Jul 2020 17:47:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVxQ7CZc9QdiBqavJfWzqIO8C2zpW2ui9LQYBEYeiu5CFp+XWzX2Nm2aE/xTyBzJo0qcuBTc8slaKYqXM78dW0RQmHr7wIoczEDucuTenqW/rU6KykOlvCMkIqBihthzfZtek0GbpPRtNZX/6QeHpBBw2a3yI2e0K7TrGw3ghVNk3DEZmZ9/xWcRREw1KbK6PVMd6q2oHqdUvcqWLKLvdQ/Gjrbyxkq2rE2AbHlIEvY3F0y2v4tcedTDC8EjoRHKcb4fw7zIhLDxH+ybU1YB2lhxOWuIxQyyy86zXPKOrmKgYtkKRtyMPRIVYMYPjLkDGrZ/cD1g+17jTHzbyPVpdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nEoP3KsN5QGx70YK7EDjI6RF8CcVfFqdmZrN23TdcM=;
 b=Qc+oS2Cyj5e/WzI+uPszrfbDMqnnMZLvIBpQvtxXXQvmVPRXE8xoKM3ZwkfbhpRApy5VkeqVcI3cWtQTdJ60gUsxPgI73rPap8uJYNeQkldQznzkr8RQ65P+k9psLGHaV8H22jeSHRZnGVlv/2pl3Bka3cTeIWPzVJSH/oGl/EZUpQOjnWocTSAS7PGBfFzDNZymfWrZUWpfc975Un/GQnTH1f+qsXduifxzZZV7nUKbXht6yfKz+7THCnghGOY5MxzMlgOc0vusCrwZHKngxQeAANekdWhDAQtjr9ctc3Vjb9Hvlwrh282Iffa38PzakQH5Gjn757Ygp5xlLQso3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nEoP3KsN5QGx70YK7EDjI6RF8CcVfFqdmZrN23TdcM=;
 b=wdNJbCQW0mxo43pVe5am+rDxliycbzgMLkwAgoDMYvvuZq4gvx72btq4de7dImuUvPDzgjmfTQfiXYNYAk0E+79HvS//k4sQYWlyWu6tmHaEAUik/cAjeWxyM37L8yVzLzf9lNsKTVt18p4wdPi77l7XUu5dkXXf6UrN4hWePHc=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB0014.namprd11.prod.outlook.com (2603:10b6:301:64::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Thu, 23 Jul
 2020 00:47:29 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3216.020; Thu, 23 Jul 2020
 00:47:29 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v4 06/15] iecm: Implement mailbox functionality
Thread-Topic: [net-next v4 06/15] iecm: Implement mailbox functionality
Thread-Index: AQHWXvdUsd8ZG91aOkup8VGE9K7Tj6kSU+IAgAIDeAA=
Date:   Thu, 23 Jul 2020 00:47:28 +0000
Message-ID: <MW3PR11MB45221A2D18E5FF5D30396F348F760@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200721003810.2770559-1-anthony.l.nguyen@intel.com>
        <20200721003810.2770559-7-anthony.l.nguyen@intel.com>
 <20200721110108.428105d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721110108.428105d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 888660ee-9df6-4319-a3c9-08d82ea1f9f0
x-ms-traffictypediagnostic: MWHPR11MB0014:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB00141EB8EEE5E57A50447B5E8F760@MWHPR11MB0014.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ezN2b3eksZacY0GniOA02Z6iQiy+IGndUosl49RAH98eS7FGB7RHytFPMhxqEJLayU9Tt/pddwZQykqiI9vQgFO98FmqRQAZSViLGBGIdBI0dhSgXwNP9SzGHguLrr2QKS4VjEImWJuk8ZB0YtnY8yzHXuLGF2SqLiNSHU6M6DU8hLPnH4Lg/Ked+H57iR9OhVpfCuXjDRkR6apUuDdv8hmGOoeeVeGIKJ1JbxfNSLyhbFlIHKdpU91yAxtD6nsRG4Zh3vVSQgQBW5nnMqW2EC5gBeDUTleeIn8lp/ygROgaiZ9XOJgLRgkenJvd0XyJ2n4tjKaFNCbmidS08i8dfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(7696005)(6636002)(316002)(64756008)(66446008)(66556008)(66476007)(76116006)(66946007)(52536014)(83380400001)(107886003)(26005)(478600001)(8936002)(33656002)(186003)(2906002)(15650500001)(86362001)(55016002)(71200400001)(8676002)(9686003)(110136005)(6506007)(4326008)(53546011)(54906003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vvkb58UDcuzgql0eyyiANz0p46btDeoPhBUnXWBeWXi92B7cYgOntTkApXtoJE5A9jXYaWzrygbznkNys7yJN8vpQ5mdDPsJvbPaXEpl3G0U0rnsu4yGLEOo1u1nVrGjRT5bKcq+lxUMAcLA2owJ/DOKY1IyZ0dSRn4qjKxZ8BVc4XbWh4sO+CdY6+ZTVjecjmzDqEn1prSKhadmepwiSreP8j++EEX6/dLn34ENY7fhcn0VHftC1inVSSuWPUgNcwe90NrR/AqxfeEzBraQc1mhYRycBAiT89WBWN0qe85LWDkOF4hCRiH3BsvDIOEplNwcHTTLrLWCV5TPyb9mw/JLyjj05rzim2c1axJlvMsZDAIm7odEWqww//CLQ5dMnbPBjl+TM7WRrWA+zQmLOXe8s3TpPYad9fekybiPtFfVAke2vgXmY2ni4/ohqOY5wdvAUF07KYwt3e0G421tlj6l9uWf7ccHrLfmyL6xaLTq/NLHGvxbzGUu4tvPjhxE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 888660ee-9df6-4319-a3c9-08d82ea1f9f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 00:47:28.8445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XlAf8qXdE0AjhHQWlFqArDIb8rnIK6sDphOrS0iqKW42LS4K9r3qBxWVzXbcF4ObtaX9DyHIMaabThgupqggVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0014
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, July 21, 2020 11:01 AM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v4 06/15] iecm: Implement mailbox functionality
>=20
> On Mon, 20 Jul 2020 17:38:01 -0700 Tony Nguyen wrote:
> > @@ -30,7 +38,32 @@ static enum iecm_status iecm_ctlq_init_regs(struct
> iecm_hw *hw,
> >  					    struct iecm_ctlq_info *cq,
> >  					    bool is_rxq)
> >  {
> > -	/* stub */
> > +	u32 reg =3D 0;
> > +
> > +	if (is_rxq)
> > +		/* Update tail to post pre-allocated buffers for Rx queues */
> > +		wr32(hw, cq->reg.tail, (u32)(cq->ring_size - 1));
> > +	else
> > +		wr32(hw, cq->reg.tail, 0);
> > +
> > +	/* For non-Mailbox control queues only TAIL need to be set */
> > +	if (cq->q_id !=3D -1)
> > +		return 0;
> > +
> > +	/* Clear Head for both send or receive */
> > +	wr32(hw, cq->reg.head, 0);
> > +
> > +	/* set starting point */
> > +	wr32(hw, cq->reg.bal, IECM_LO_DWORD(cq->desc_ring.pa));
> > +	wr32(hw, cq->reg.bah, IECM_HI_DWORD(cq->desc_ring.pa));
> > +	wr32(hw, cq->reg.len, (cq->ring_size | cq->reg.len_ena_mask));
> > +
> > +	/* Check one register to verify that config was applied */
> > +	reg =3D rd32(hw, cq->reg.bah);
> > +	if (reg !=3D IECM_HI_DWORD(cq->desc_ring.pa))
> > +		return IECM_ERR_CTLQ_ERROR;
>=20
> Please stop using your own error codes.
>=20

We did drastically reduce the amount enum idpf_status usage, but if still n=
ot quite satisfactory, we will try and go further with it.

Alan
