Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA521BE5F
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgGJURJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:17:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:17297 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgGJURI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 16:17:08 -0400
IronPort-SDR: 4BkQe+a9t2KHhu098WsN6r/5XlB/mUaoq5oYIhMymn92As0/SKJIvM1jU5S4wFVb9uIgdAMJxD
 RFkTeBz7bang==
X-IronPort-AV: E=McAfee;i="6000,8403,9678"; a="233156777"
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="233156777"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 13:17:07 -0700
IronPort-SDR: idwwgc8qs9/pbMi3AN/KjrHlEjsHiIJNZZk5QATdFsoTSDNmoUn/0uUmwdTnlHMbTCj2GNILU4
 hpBRHINVdjaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,336,1589266800"; 
   d="scan'208";a="267809363"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2020 13:17:07 -0700
Received: from orsmsx116.amr.corp.intel.com (10.22.240.14) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 10 Jul 2020 13:17:07 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX116.amr.corp.intel.com (10.22.240.14) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 10 Jul 2020 13:17:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 10 Jul 2020 13:17:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebIXGDvl2ekshU7k8xm71OhnrRzvAzyLVGHGVCTiTxp+mjrk0PDi7r9AjnpLQ/yuZEVaFU5ZNzYc5S/Cqd5Oa/OKOpMWFT/f6KMuBiQm6V9FM8rcAtMO502ogwnYHgYzsttk9pDb49CyjqldypMMEIwL+zLG6A+4UCZfLCZDhPXNchZX0GoAwruuIUMgnTwPtQe7r4Bae1cL8saqa/dkZv4wgjfQnf+vG0FRisaSlSeia1sY6LjXpUBrdWO2QZiC/M2gi9ZGK78KMfMYD2e5Q6rUN9ob3BzigoEflp8MDgarFN4VOAzNTXXMq+YHatGNuA1KmriVH+3FHcY1IjDkAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDb/IV3gzJ3luUPItPoKFRAoHgIF/WrWkLbYb+D6tgs=;
 b=Sf0PZ8S6slf9PE8+eSIjzkgM6MLRGD/LeEvPNSTuYrRhxQlXZRyVB3J2+UtDkBs/nLWaUXKMjhjci1tTKmXGOREuXdEVLx32mTdlOYd59icVRMNxZL+LvxLovNfiaWFnO5agVM+kzd9ELjuWOIEmNv+QDxMGVW2YNUzvbXxi3w75tAxykOmaZoBg+jz9BFcxtUxkwde4KaTzUsd1Cgnd5GY82N+1wdsdprQgyz1hv0MQqzm7oxjsM4tduEPVz68bw7MEloYRtbshOAd5CX+p18mq0ewuJquIJ7hrboBi333tPil/acUTHfi8iO5i30pS5TwraYCW1bToCQ0DfMMg9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDb/IV3gzJ3luUPItPoKFRAoHgIF/WrWkLbYb+D6tgs=;
 b=OeQ0963R3+yNIGK14WJBU9v56mD0tnAeZx64cDF4TF81VNRtCtLspZKw95i+SZ2/4gv3zyyJ/H/nteytQgftK5v+xATVmdw5SPFu7ozmpT+rStgDJFrYnQGSACd0aobDbQ9pWHx5MAXN8Ju2CCcV0MDGFW+CxZzJ3a53VktzMIc=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1503.namprd11.prod.outlook.com (2603:10b6:301:f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 20:16:59 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%7]) with mapi id 15.20.3153.029; Fri, 10 Jul 2020
 20:16:59 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v3 13/15] iecm: Add ethtool
Thread-Topic: [net-next v3 13/15] iecm: Add ethtool
Thread-Index: AQHWS16ZZzIbMh9UG0WTZD4rdYDCP6jrSZyAgBYMg/A=
Date:   Fri, 10 Jul 2020 20:16:59 +0000
Message-ID: <MW3PR11MB45229B97B3B6AC861CA2267B8F650@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
 <20200626122957.127d21e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626122957.127d21e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 605b8df8-76bf-42f0-9d28-08d8250e338c
x-ms-traffictypediagnostic: MWHPR11MB1503:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1503626993606ACDB308CA2E8F650@MWHPR11MB1503.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TQqcDZ8OFt2hrHBNtRBANvOdpFa0qFqBa0mwrLolqs6OAa18GdAO1LJV7Xu309ZlZa2aGyQTZlrfMP+t1AzSWngelidg4Uo/90weXtaTODagGsl6H3OF4hbgS3pLD8TVVAYU7mDHjqn/9O6nDIuoO7OFSm6CcI/tWtuuiTyHJA6Ly4KEbxUOfdmWSFeiauNo+bClQFwo5TjY88eWp0yRIeGI7lxYBy2cKHEUI1WYgdKTAEYh+atVtTmW1FaZfOPDMhgWQ7QsN1+fpCsmx42bycx2d7ITz9a/k2sCiRmXzxOLOVWtBrrjyaUJ44ZgZy8MF05se6ROvi/x5YbcWWjZ4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(83380400001)(33656002)(55016002)(64756008)(66446008)(66476007)(2906002)(66556008)(6636002)(478600001)(76116006)(66946007)(4326008)(6506007)(53546011)(26005)(52536014)(8936002)(186003)(107886003)(316002)(86362001)(5660300002)(8676002)(9686003)(54906003)(7696005)(71200400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 2jc6GjKAeM/HJPGwSRVp5UPdqH4kNYPK3k7XyirPmuvBb5lZJBdcjcjOjxgDBvg0m+CYCkYM/zceeYUmH3DKqK+KZdNbawXFdOscl/yvR1wk/mqx+ewY5/K50kNBuI/nkw2uEhuAM/0I+cnfWw4KlS2a9LmqWrg7I5EfXbdmSWpNIIR5N4XNCqA+MDE+JlUcTEkyJUtd5iWSlwtlJKJk4g19YYcLvdqGlm4En3dXUaSNZyFMjpw31YyjPM8P129FnUyesEGWAv4mUYcNpvvKwNJG5z7RSbe1mnccfLdYc0Mz9H9q+EqFh1qAaF3UEF7fH0SoEHUU1NBTZXfitWtmMAn8CZs7MU8oRYoQ2DQfk0rJGKZJJxdDy8ezV50IXUHo0uPscRaYWXxLcfK7oSrpIO1hPQkhl72Bj8OjDDBsZGRuuvvv1y1X5rU7xRFkavc9y3PQ4Go6t/1+C9s9qzWZncFJAFkukh4HZRUX1yaCVyY4zXMgSoxN7UYoJIhALI3p
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 605b8df8-76bf-42f0-9d28-08d8250e338c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 20:16:59.6492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VD1phm+pL6DugePKcXn4xX3bAhpjOqLHvzOxRJi6sVSSyn/hN+l+e4qohXEapbdo/t9Dczz3Fj7OvQYi3yY8yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1503
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, June 26, 2020 12:30 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Brady, Alan <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.c=
om>;
> Hay, Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 13/15] iecm: Add ethtool
>=20
> On Thu, 25 Jun 2020 19:07:35 -0700 Jeff Kirsher wrote:
> > @@ -794,7 +824,57 @@ static void iecm_vc_event_task(struct work_struct
> > *work)  int iecm_initiate_soft_reset(struct iecm_vport *vport,
> >  			     enum iecm_flags reset_cause)
> >  {
> > -	/* stub */
> > +	struct iecm_adapter *adapter =3D vport->adapter;
> > +	enum iecm_state current_state;
> > +	enum iecm_status status;
> > +	int err =3D 0;
> > +
> > +	/* Make sure we do not end up in initiating multiple resets */
> > +	mutex_lock(&adapter->reset_lock);
> > +
> > +	current_state =3D vport->adapter->state;
> > +	switch (reset_cause) {
> > +	case __IECM_SR_Q_CHANGE:
> > +		/* If we're changing number of queues requested, we need to
> > +		 * send a 'delete' message before freeing the queue resources.
> > +		 * We'll send an 'add' message in adjust_qs which doesn't
> > +		 * require the queue resources to be reallocated yet.
> > +		 */
> > +		if (current_state <=3D __IECM_DOWN) {
> > +			iecm_send_delete_queues_msg(vport);
> > +		} else {
> > +			set_bit(__IECM_DEL_QUEUES, adapter->flags);
> > +			iecm_vport_stop(vport);
> > +		}
> > +		iecm_deinit_rss(vport);
> > +		status =3D adapter->dev_ops.vc_ops.adjust_qs(vport);
> > +		if (status) {
> > +			err =3D -EFAULT;
> > +			goto reset_failure;
> > +		}
> > +		iecm_intr_rel(adapter);
> > +		iecm_vport_calc_num_q_vec(vport);
> > +		iecm_intr_req(adapter);
> > +		break;
> > +	case __IECM_SR_Q_DESC_CHANGE:
> > +		iecm_vport_stop(vport);
> > +		iecm_vport_calc_num_q_desc(vport);
> > +		break;
> > +	case __IECM_SR_Q_SCH_CHANGE:
> > +	case __IECM_SR_MTU_CHANGE:
> > +		iecm_vport_stop(vport);
> > +		break;
> > +	default:
> > +		dev_err(&adapter->pdev->dev, "Unhandled soft reset
> cause\n");
> > +		err =3D -EINVAL;
> > +		goto reset_failure;
> > +	}
> > +
> > +	if (current_state =3D=3D __IECM_UP)
> > +		err =3D iecm_vport_open(vport);
> > +reset_failure:
> > +	mutex_unlock(&adapter->reset_lock);
> > +	return err;
> >  }
>=20
> The close then open mode of operation will not cut it in 21st century.
>=20
> You can't free all the resources and then fail to open if system is tight=
 on
> memory.

We will refactor this flow to take memory allocations into account. We're p=
lanning to push another version next week with this fixed.  Thanks.

Alan
