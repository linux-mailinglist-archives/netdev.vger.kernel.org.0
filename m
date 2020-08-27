Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83112254C2D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgH0R3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:29:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:3213 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgH0R3R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 13:29:17 -0400
IronPort-SDR: 3s6ZexlOYJedeIxoSr5JIcWxuWsD/mu6BG5MaKtZbE7/CKfg22+ztE1pAdaWsIuAAoiwe1VTvc
 auEDriSkxfLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="136078284"
X-IronPort-AV: E=Sophos;i="5.76,360,1592895600"; 
   d="scan'208";a="136078284"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 10:29:17 -0700
IronPort-SDR: tQAsbVclQN9BxpP/OfSynHonKWl6bnbw+B3ELOUCGlD6EMp4eiuUkeDMUB49azaerFCsjn1IyI
 ideQzFaIyP5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,360,1592895600"; 
   d="scan'208";a="475311402"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 27 Aug 2020 10:29:16 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Aug 2020 10:29:03 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Aug 2020 10:28:56 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Aug 2020 10:28:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Aug 2020 10:28:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObMZvja/8bn/Q+xZ0+x+dXJuANlKKPhsGJuk4mhaVfeS8y6VFcaj/84ZtHSOuK6spxL1LH6JG6i8sRZAMx4Niiw54NB1Ok3mjrK3rbHVNNtzgUXpsvjkGGmGN59aQ+cjz/sTODNv5eBKkqj0aJZmK6yB62th1G1DVF+8V/fzNMTKLYgKBtQ9M1ZzScy673wTM5QK8Y/k8+VOSkA2f97Ahy1vfvcKE4BPR151JV0xbPVcE2tUisYT3yxAgMkYYBUFSKjCVEhWu2jk6lqGkFa0XTsYWt76yTyJ9T55XIn8TaY1WrG79tYnPqJwFM/BpAg52oH44pMzN89uSY9hp+IoOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qxp39/ucPykEd+Jq4LHonUNdnqU4yZ3EIM5AExeW+9U=;
 b=hRHO4Jyi0FPyGXsq8Gy+IyZn/0G78NeDAya3Ua2UivfEdjCwsDU6cpPG4vMQVH6EjdJmWyCnRyiPHOeUw7muJxy3FQ7rCTjzI+ZIINDB+JQfiKiJpFd5mOHP4x4hfSbBahfVS1I1qVI5xafsy4klOvRKoMC5NAb4Z3SM6A6sI+n7jCDMiPuiovxC2S/V0JmmYiVat0/v88omdu4mUY9Lyoyvjeotrpwp6Vt2F8KLkgAW1crBh2EXaJLzDXgeQfK1sVtEiTkJaU8k2TVsOSn/+tkiK49y2YGGNBL+tNYNVi4jRz7YhwaL7oig6P1yhYGYWhOCTvQBv+6Ue/RsWSQHcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qxp39/ucPykEd+Jq4LHonUNdnqU4yZ3EIM5AExeW+9U=;
 b=n9nPIffaZtZRyKWrYCJ0hDTAEHXoi2y3c/UnHoiK83p/ZpxKcHxfnADXHyNl2c7P0K7EKNygUBdnDQW8Bm/Gi2m7j+KHjlUSgLfywz31N+AnmkC51GPQyFQsmY5/rXJ1hXSKRvMVKHxBxPte1dZnPTr2nIvrRzpwYF4lV2BrMFQ=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR1101MB2287.namprd11.prod.outlook.com (2603:10b6:301:4e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Thu, 27 Aug
 2020 17:28:29 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 17:28:29 +0000
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
Subject: RE: [net-next v5 08/15] iecm: Implement vector allocation
Thread-Topic: [net-next v5 08/15] iecm: Implement vector allocation
Thread-Index: AQHWejy2z2Gi79IX60+zT1K8s/+H+6lHuXEAgASARxA=
Date:   Thu, 27 Aug 2020 17:28:29 +0000
Message-ID: <MW3PR11MB45226215CC02BFE53CD9F01E8F550@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-9-anthony.l.nguyen@intel.com>
 <20200824134136.7ceabe06@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200824134136.7ceabe06@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6129fc9e-0868-41ba-3874-08d84aae9d6e
x-ms-traffictypediagnostic: MWHPR1101MB2287:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB22872BEFC95C9892AA5C87538F550@MWHPR1101MB2287.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zx3fIlXX8ONNIoAhdPN/WNAfuJwAIIjvosM+LPjvsXY8t4kX23EBS80Y6Wq+8FUxRsBjaoRtyfRo52c8LvAQGswBj8NulintKS/AlpzdeoVXwbkpMD99u7SGT3ngr8y84SJCu2UA4Fwjy7A24wLmSanTL1CuduXUKCVl+NH6DO29E9OlP80UrYRS2M6dB35mO8odv6X8nbDuQQ6ydDDcJ7c+lIhXOp0XFiC3yyEkgZp5ah++dntGov46tsSO6DaLIVL4hq7a88dntlEvzBaesrP1p5LnAEzrjh1OwIqqXzmmGiMS9zgN2KOXylyIf11l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(6636002)(8676002)(8936002)(107886003)(186003)(26005)(4326008)(55016002)(9686003)(53546011)(52536014)(71200400001)(2906002)(33656002)(7696005)(86362001)(6506007)(83380400001)(5660300002)(66556008)(76116006)(66476007)(110136005)(64756008)(66446008)(54906003)(66946007)(316002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UDuRn4fBlbQlf6nMbWqpno7QFipUDhLyEKoeQCoo/lkJ5sdOsnJkjKhMm+ZmROEW2wE/CjwgqRERdoWkLl3qMqRWokT8fvqMlUpxAyRVbdVV+AZIBpRM/YPm3jU17W9oxKlL2WsXxH0NqSbL6jQN1IptAuln9FRvE92Ob0Iq+VRWtnEtXo1gs+DxvZ88qrnV/gme3ACq5tZFYQ+qx29d6Cq0wEZyCk75YSUgxaFI7nskDU5hsPA16OTNGcTv7kV/QUZhG1Ddp/TSHAD6p5ar/g9zN3DJ+73teOpu1Ih64mMCybVBxzMvuywyF5V2xqpbKWlKZ01/ogjHdvIQtHQhMzoRsiUma5Sij2PSFCojHeLFAXD9soqCjiAKrYf5hO1q0nRWvRI4giogsfyTQsnJYgNPkKNzVuWl9d62peOq1WWqzp6ulFLX/CRAE7tSfCq6qxsbiuHYrls1vcmY7azFdWqikYYWknPIFFD2fkXRFOeGaZtDAz2Vc+RZac2ZIC7qQWStEYmpTab1LLymvKdZiYXg2eHmkLRuQGIqVvPofi5gSJWarkz4kPTYKjH0avfpYQRgTnS9GbFR2bLv/EMuEKfIMGtF5e/zrSY1KyCUwIbbU27+ewD2sV+ru6aMD6rdv/PifXjuZQd1IcvcY+GHFw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6129fc9e-0868-41ba-3874-08d84aae9d6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 17:28:29.5959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cHxfYu2PlfwM7YD/qmetYfxx8n82nvBkiQV1CPfWYFXveR+wmf7491l3QXAP/3mcCLFb3ID59/lke936elx1BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2287
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, August 24, 2020 1:42 PM
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
> Subject: Re: [net-next v5 08/15] iecm: Implement vector allocation
>=20
> On Mon, 24 Aug 2020 10:32:59 -0700 Tony Nguyen wrote:
> >  static void iecm_mb_intr_rel_irq(struct iecm_adapter *adapter)  {
> > -	/* stub */
> > +	int irq_num;
> > +
> > +	irq_num =3D adapter->msix_entries[0].vector;
> > +	synchronize_irq(irq_num);
>=20
> I don't think you need to sync irq before freeing it.
>=20

I see other non-Intel drivers syncing before disable/free and Intel drivers=
 have historically done it, not that that's necessarily correct, but are yo=
u certain?

> > +	free_irq(irq_num, adapter);
>=20
>=20
> >  static int iecm_mb_intr_init(struct iecm_adapter *adapter)  {
> > -	/* stub */
> > +	int err =3D 0;
> > +
> > +	iecm_get_mb_vec_id(adapter);
> > +	adapter->dev_ops.reg_ops.mb_intr_reg_init(adapter);
> > +	adapter->irq_mb_handler =3D iecm_mb_intr_clean;
> > +	err =3D iecm_mb_intr_req_irq(adapter);
> > +	return err;
>=20
> return iecm_mb_intr_req_irq(adapter);
>=20
> >  static void iecm_vport_intr_rel_irq(struct iecm_vport *vport)  {
> > -	/* stub */
> > +	struct iecm_adapter *adapter =3D vport->adapter;
> > +	int vector;
> > +
> > +	for (vector =3D 0; vector < vport->num_q_vectors; vector++) {
> > +		struct iecm_q_vector *q_vector =3D &vport->q_vectors[vector];
> > +		int irq_num, vidx;
> > +
> > +		/* free only the IRQs that were actually requested */
> > +		if (!q_vector)
> > +			continue;
> > +
> > +		vidx =3D vector + vport->q_vector_base;
> > +		irq_num =3D adapter->msix_entries[vidx].vector;
> > +
> > +		/* clear the affinity_mask in the IRQ descriptor */
> > +		irq_set_affinity_hint(irq_num, NULL);
> > +		synchronize_irq(irq_num);
>=20
> here as well
>=20
> > +		free_irq(irq_num, q_vector);
> > +	}
> >  }
>=20
> >  void iecm_vport_intr_dis_irq_all(struct iecm_vport *vport)  {
> > -	/* stub */
> > +	struct iecm_q_vector *q_vector =3D vport->q_vectors;
> > +	struct iecm_hw *hw =3D &vport->adapter->hw;
> > +	int q_idx;
> > +
> > +	for (q_idx =3D 0; q_idx < vport->num_q_vectors; q_idx++)
> > +		writel_relaxed(0, hw->hw_addr +
> > +				  q_vector[q_idx].intr_reg.dyn_ctl);
>=20
> Why the use of _releaxed() here? is this performance-sensitive?
> There is no barrier after, which makes this code fragile.
>=20

_relaxed not required here, will fix.

-Alan
