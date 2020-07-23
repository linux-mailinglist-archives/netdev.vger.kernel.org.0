Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBFA22A3D1
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733080AbgGWAqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:46:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:17500 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbgGWAqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 20:46:01 -0400
IronPort-SDR: nA/wlx0JpdDbCHATVh02PSlI2acrOSZRtXLMBOZrRP70GIeZOaOc4inMKfbmk9xtPgzH5Imdjr
 9Qp8e4heAmIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="130518560"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="130518560"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 17:46:00 -0700
IronPort-SDR: tF83ZjfkStAletn/XbzywfGm8b9DTiXUOswBC74XmuDXxyKpbz5pyOq6ePtRc+GQ5VpwaUEkyD
 ha6TrTb6GDmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="488646662"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 22 Jul 2020 17:45:59 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 Jul 2020 17:45:59 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 22 Jul 2020 17:45:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jul 2020 17:45:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjB61QLdNBEk+xlQ3oASRQ7V2LKfIK1C7MUqScwC3iH6iOaOtILqBWtEVN7d3sVfmAHK5GbBGKmsxjFuToAnXbVARfhKguvRz4ruNm62PBLlWWpv5QNdj5PFfqLpD7vBfUU14Z/Nd8dN8CWgy8lLBDKsQFbng/pnwpMR2lEjbSi1bh/DtiZkSiC4WZ7NgFdDEotZR6mgSuE7AEYrM+O7incMqFwXNG5eu0IpYd/nAK/xw+JflCmbBW7UQBM6JUGzm22in3EztS1TAfLZaHyBRVtBO6ZOEhPmcXG03jXwoBTMB5Jjz2kuU3qXYTMSYZs9Su1hFK/ZWPM8rWfVxH9MVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8djlEZjZta6xxGdrg2LcU1hp/uYsmmXXq0YdEAckTo=;
 b=IX8NbsT3RbAooITwcaMp0G5oRMjsnBayEB30T13K+FmM7vAdEzMOp76knBHdonvm5YKB5nSNaC7qcXT4l5bcpLVMztekASnNBZgPXEc/galdQVnWQ1wEuUp8BtdC3DeAzUzmb1pd8YmEQiiOQOtUMg9m+YnNDtWll3v8M36Azj5kH5agLGa7YTpaSD/daPHoM1ALB/qtCaF9yPSZqDEvYB9vt0jxa2UNeGImNJBUrAOuu4DIXJFXva2MP9mwptdfq1ZjJxatGGMgm0282LA6yXgTipRhzAG38aJReX5R/12lr9CluJZsaUjbg5YMBQeA+o2NvJ+yfR4xcm3ziEfPUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8djlEZjZta6xxGdrg2LcU1hp/uYsmmXXq0YdEAckTo=;
 b=KQFUVRNWhIwTI8vnrO/Kc7V/SzYvYHEgTqbicdTUlYR0JXfFHvanJxpQP+a4EjJap0hKp8DtjvuJmyNFw8eCi5S8GwGX98Y4cmcNAlDnewT8aFuILSTPj0wiZsLuz/agnOSZLjgKZUqPMVivbo+GJe6p6iFDSq5AuIchQh0G3XY=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB0014.namprd11.prod.outlook.com (2603:10b6:301:64::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Thu, 23 Jul
 2020 00:45:55 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3216.020; Thu, 23 Jul 2020
 00:45:55 +0000
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
Thread-Index: AQHWXvdUsd8ZG91aOkup8VGE9K7Tj6kSVOCAgAICAlA=
Date:   Thu, 23 Jul 2020 00:45:55 +0000
Message-ID: <MW3PR11MB452210A982F0491F1419BBEF8F760@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200721003810.2770559-1-anthony.l.nguyen@intel.com>
        <20200721003810.2770559-7-anthony.l.nguyen@intel.com>
 <20200721110441.50b5c43c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721110441.50b5c43c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: c90bd6b5-b45c-4bd7-9282-08d82ea1c271
x-ms-traffictypediagnostic: MWHPR11MB0014:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB00142C1A087E9D1715A9B5318F760@MWHPR11MB0014.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tIXHE3vB5V097pp/5yBSDagiyNRIeQT26VIvFpUasQlflLxCmKszF9QRMv5c6XJ+pPrDc6KugJ3lO6wxy10/3caYucipLRfXlF8BoXwA8AQw8by72LQxOBTg8E/k77rXLLVcKQIiteNK+kY55QL0WnCURCeltFkrcFrg33ECscjHe9IAz05yhNSc9+uC0YSbmEOOBV7YhJdtmcxDRFsHUzQfzOUDtFZbw+Q6cQ4a2oXX5PV8+JFfiMyqlBXL1xTyOeps4rFrJS0I9aDIf0w/PFLGuAYMVLN3PHPJFlIp7U2UuXdVC0FhaBJXHIryD5+hgWpV5MnQL2s9RDojQP5HTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(7696005)(6636002)(316002)(64756008)(66446008)(66556008)(66476007)(76116006)(66946007)(52536014)(83380400001)(107886003)(26005)(478600001)(8936002)(33656002)(186003)(2906002)(15650500001)(86362001)(55016002)(71200400001)(8676002)(9686003)(110136005)(6506007)(4326008)(53546011)(54906003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fROKphZNQSv323r4v2n6Q/oUCt6YcPR4Cwpm6RSK8GoJJGdHb/uJ0rGxF0VAZz/h/pdorGZwKHRN8+YGiwKbuGCYazQV9qFBWi8nnKJ7baUqBsvC1RQW8ODtbH50B4f1M7X43NKA+lfX9zRc90HHBJBODotqUzTBcyz90Wy60yXqkMiuSdPGhEnVBXqSY2ZxHgp8pvA40FVFZ/0Txv7FU/DU7zJ043WMNcqKVyCzBuXGJRk+EfbD2KAw2KRlNBQ4yyFjZFJnZbdD+Ax2GFlEvDHUe5viA30p8MJieroO+XEGkG3JOi6qzAaBN/kb+tA23o+5gS1Iv16kCCj4HAZmVys3ShgvDQGziI5nI/BvAXx6ZzkL8VCxvoWgmQcCdJbAVlEJdfB9qUlVRhrb5TkB7/ALaQoa4E6Hx8Y1B16Epp+yayf9mkrbDB67w8rC9pSc0eCPB4lIRVF/ujOeHEdCtjh6UWYAYNN9r1F0ppuTNdZUbVkEOJXMPpS6Woc34g4y
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c90bd6b5-b45c-4bd7-9282-08d82ea1c271
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 00:45:55.7072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xbTNLvmRpK6efvuIvdiOeKWc/gqEwIRP+sWxdWfUYZfn3nSttL7QNLrEFFxZgH1g+9yd1/1fXzwuDMsKRdPYSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0014
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, July 21, 2020 11:05 AM
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
> > +		(cq->next_to_use)++;
> > +		if (cq->next_to_use =3D=3D cq->ring_size)
> > +			cq->next_to_use =3D 0;
> > +	}
> > +
> > +	/* Force memory write to complete before letting hardware
> > +	 * know that there are new descriptors to fetch.
> > +	 */
> > +	iecm_wmb();
>=20
> dma_wmb() would probably be sufficient here?
>=20
> > +	wr32(hw, cq->reg.tail, cq->next_to_use);

We will investigate and see if dma_wmb is sufficient.  We do have a test fo=
r triggering the weak-ordered issue so we should be able to tell for certai=
n.  The reasoning makes sense dma_wmb is sufficient but we want to test to =
be sure.

Alan
