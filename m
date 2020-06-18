Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A53B1FFE77
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgFRXH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:07:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:4537 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbgFRXHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 19:07:25 -0400
IronPort-SDR: BHt9wtBDw4yTIQG797Y5z3icRdYJMNnaldkB1xEC6lrBnXkcTcwD+kXSJ4BqpZcRWoPE0mRR+9
 5oMY3Qj2XKEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="131162723"
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="131162723"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 16:07:24 -0700
IronPort-SDR: S+oxzcuw1uATkQ5v9nkuet3cltlBXPsPVnEovG3cEdIf8ZIqqoVT0Ghg4ZV/qgHBqPNzeLEKdR
 e0RH+O+VstQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="421667322"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga004.jf.intel.com with ESMTP; 18 Jun 2020 16:07:24 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jun 2020 16:07:24 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.57) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 18 Jun 2020 16:07:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsAO+ClKTRc1RHKKdMa9KXYejifB55P5qW+HSoJRT+YPx3gPOsAk26JgKlcm5updcYEUMf3dFTIpSACvVEJKrZM5e50/ReqHVcF9zcQcmcoyHEYv7V58iVtJvwXcNUL0+cDJzRX1e8vUSDx5dPijmLJ0UWyTHTKO/BOWPD3uyp/Chl5i0oBzwczQa4VKTNEUC/hlMGz0npPA3G5XkfLzhGP52F+NnOEP2ohhrJR+WxWFzmZhyInLUpvZvTXxMAqObCrw7X7cOX0iO8SEI27D/H7veCpUX9xIiW1cHZ7lMiGpSYgQwZJluzD4T9jd1NbzPYNXHgX1uk8sXijwd4UtCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grurwqM4HSOLP3wmnxFlQLgEFaaonXV20wmIjSZ6jAc=;
 b=X1VZDeJh+H1IcNSdSIYeMsZvPvuiyXEnZJtgjWiUyfGzTOnul8xiqHxxwISAywrb5Zh0fD8srafMp90+un2Q0cR4M39bhlmyRF/EwZa71Ig8HPMF9i0R87BbTqTucrC+1ryCYuEcSmlNtYsxTNG3VA5CJsY2e+ehhSmW59jrUTEpglKC3emeCzf7bVhT1LCSwqrvK6ztArOWBpmJdYtsfZc207QbsOacoaGLhOOG/nBUMgrCpvmyShRvhf0Q6GZtlA4D3ydLSr9/jyYmrjTiniDnvq3v7Et7TPiyP3Kwm6Oy+d7GTOsUfYQk0qlpGPEGxrHuXw1WLS+3fIR0q5/Byg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grurwqM4HSOLP3wmnxFlQLgEFaaonXV20wmIjSZ6jAc=;
 b=Nn8DBK3kRlyD73kHD7QvXTBz4Kbp5E/BBjGUu5JDg6NYpQatuSQCOUaDlbZv4xOZCce8R0sHYax9uMO44WvNb8dhsw8jSwiTwrmDpbZK9/0IjLMbRUOTZS/zNmwCfLqdDia312PSRbjK0R3U9a47heffZlSnMTsHyMUOM9rRl2E=
Received: from MW3PR11MB4683.namprd11.prod.outlook.com (2603:10b6:303:5c::24)
 by MW3PR11MB4698.namprd11.prod.outlook.com (2603:10b6:303:5a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 23:07:22 +0000
Received: from MW3PR11MB4683.namprd11.prod.outlook.com
 ([fe80::498f:e5ca:221d:3eac]) by MW3PR11MB4683.namprd11.prod.outlook.com
 ([fe80::498f:e5ca:221d:3eac%7]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 23:07:22 +0000
From:   "Michael, Alice" <alice.michael@intel.com>
To:     Joe Perches <joe@perches.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brady, Alan" <alan.brady@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next 02/15] iecm: Add framework set of header files
Thread-Topic: [net-next 02/15] iecm: Add framework set of header files
Thread-Index: AQHWRS9FYgxNCUggRUiNdIrYnP2LDajd2VyAgAEmaRA=
Date:   Thu, 18 Jun 2020 23:07:22 +0000
Message-ID: <MW3PR11MB46831BBF9032F62FB39914DCE49B0@MW3PR11MB4683.namprd11.prod.outlook.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
         <20200618051344.516587-3-jeffrey.t.kirsher@intel.com>
 <57110139759cc77f21a150a3faed0d2584dfbe21.camel@perches.com>
In-Reply-To: <57110139759cc77f21a150a3faed0d2584dfbe21.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [67.189.98.221]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d68d068-eef1-4666-de46-08d813dc5b9b
x-ms-traffictypediagnostic: MW3PR11MB4698:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB469828D78CD51011ECE27434E49B0@MW3PR11MB4698.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v3RR/HYgu2M1cBGxo3r/aBZt4Rhw5OrIZMwEYxKqjA4BBM7aI1xZq57FH3ZnqtpgFhTsUKIBA77QQU3vvDwyLJf5o2GJbHTcjltx0bKxpiF2QJWEFIcfcdaNhoYCzKQVnKnp+r3jRLsEUJ9T0q/7yfOYh6ICyFYtYuFfaQcW5RZVNHPpMoG/S2x0e7YaX15LN5p0OZ+sct/iCcct18yYEkoFHLmDZiGjI9EQ9b3gp5DddBQQb8Kyi4orSFQu2FljGFCjQPDZhNVBkScsJmKXbYBu876WDJkFzYdWdnvZilE1OKGmLpXtgGQbIK+iyljg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4683.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(107886003)(5660300002)(316002)(86362001)(52536014)(33656002)(186003)(4326008)(54906003)(55016002)(9686003)(110136005)(26005)(71200400001)(76116006)(66446008)(66946007)(8676002)(64756008)(478600001)(6506007)(83380400001)(8936002)(53546011)(2906002)(7696005)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Zkj7Oh1VYdP/aIN2UqWHPOo6Xt9ewilbjQ9qomAnhN9sQwIClCcwgFVDQvtG8dHnuwGntPG6JhpBLSLiOG8v3lQ6yYtRERIo85JhviAPBdUAP4i9+xUfj3smIff4U62Iyj7k4YezIBWUiCTI4gAsE9aat6xpvI9eSdVNXuU6KwDC+hH1BUWHxIKhjAPCQHHqpKiakDLU/jNRXkgeW6CoVpFYhwuTeNnl1mBjmmnL1jLyO81mv9PRwVuVa1F0cnJDF3bWZVBZzpwInZ4TaBg8X8hT6m97XD71kuDLvOYV2SpZ8fIFOGAnwWRck0lDkUdvPPFM21W15mUOFztPqJt164AjfV6Oc96FZhC3D1awnULVfob3P+3krw4cZNnOfj1Aiis660rEIZxmeK/Fs2Q3s6K0SQnOl52Z4SzCm6oDQY5FWeWfDeYfFmPcFtU9lvQWP2rfKEr6ckzJXWAUST6JIHdm8HOSH5TYB1r1g2ePri0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d68d068-eef1-4666-de46-08d813dc5b9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 23:07:22.1260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gMNjzLW40QhSrVWsDyAwQjVo2HJJpEVRnUhOHCYBo43fgNqcLtwA/TBnRRkcUELI2ltgdLHJQmte6+PkdoFYLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4698
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Joe Perches
> Sent: Wednesday, June 17, 2020 10:33 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: Michael, Alice <alice.michael@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next 02/15] iecm: Add framework set of header files
>=20
> On Wed, 2020-06-17 at 22:13 -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> []
> > diff --git a/include/linux/net/intel/iecm_controlq_api.h
> > b/include/linux/net/intel/iecm_controlq_api.h
> []
> > +enum iecm_ctlq_err {
> > +	IECM_CTLQ_RC_OK		=3D 0,  /* Success */
>=20
> Why is it necessary to effectively duplicate the generic error codes with
> different error numbers?
>=20
Ah this is a good point.  This was an old API we were looking at early on a=
nd abandoned and I am working to pull this chunk of memory out of the patch=
es for a V2.  Thanks

> > +	IECM_CTLQ_RC_EPERM	=3D 1,  /* Operation not permitted */
> > +	IECM_CTLQ_RC_ENOENT	=3D 2,  /* No such element */
> > +	IECM_CTLQ_RC_ESRCH	=3D 3,  /* Bad opcode */
> > +	IECM_CTLQ_RC_EINTR	=3D 4,  /* Operation interrupted */
> > +	IECM_CTLQ_RC_EIO	=3D 5,  /* I/O error */
> > +	IECM_CTLQ_RC_ENXIO	=3D 6,  /* No such resource */
> > +	IECM_CTLQ_RC_E2BIG	=3D 7,  /* Arg too long */
> > +	IECM_CTLQ_RC_EAGAIN	=3D 8,  /* Try again */
> > +	IECM_CTLQ_RC_ENOMEM	=3D 9,  /* Out of memory */
> > +	IECM_CTLQ_RC_EACCES	=3D 10, /* Permission denied */
> > +	IECM_CTLQ_RC_EFAULT	=3D 11, /* Bad address */
> > +	IECM_CTLQ_RC_EBUSY	=3D 12, /* Device or resource busy */
> > +	IECM_CTLQ_RC_EEXIST	=3D 13, /* object already exists */
> > +	IECM_CTLQ_RC_EINVAL	=3D 14, /* Invalid argument */
> > +	IECM_CTLQ_RC_ENOTTY	=3D 15, /* Not a typewriter */
> > +	IECM_CTLQ_RC_ENOSPC	=3D 16, /* No space left or allocation
> failure */
> > +	IECM_CTLQ_RC_ENOSYS	=3D 17, /* Function not implemented */
> > +	IECM_CTLQ_RC_ERANGE	=3D 18, /* Parameter out of range */
> > +	IECM_CTLQ_RC_EFLUSHED	=3D 19, /* Cmd flushed due to prev cmd
> error */
> > +	IECM_CTLQ_RC_BAD_ADDR	=3D 20, /* Descriptor contains a bad
> pointer */
> > +	IECM_CTLQ_RC_EMODE	=3D 21, /* Op not allowed in current
> dev mode */
> > +	IECM_CTLQ_RC_EFBIG	=3D 22, /* File too big */
> > +	IECM_CTLQ_RC_ENOSEC	=3D 24, /* Missing security manifest */
> > +	IECM_CTLQ_RC_EBADSIG	=3D 25, /* Bad RSA signature */
> > +	IECM_CTLQ_RC_ESVN	=3D 26, /* SVN number prohibits this package
> */
> > +	IECM_CTLQ_RC_EBADMAN	=3D 27, /* Manifest hash mismatch */
> > +	IECM_CTLQ_RC_EBADBUF	=3D 28, /* Buffer hash mismatches
> manifest */
> > +};
>=20

