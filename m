Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD7C26E668
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgIQUNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:13:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:53016 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbgIQUNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:13:05 -0400
IronPort-SDR: kXI4cGIchulQ2LP2d7QYm9K0kFfQZxydxXoem9e1+qAJ6glgZkwfjsQVNstRpxzwSX6ZogO1FF
 cHSneLOG6hKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="159841466"
X-IronPort-AV: E=Sophos;i="5.77,272,1596524400"; 
   d="asc'?scan'208";a="159841466"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 13:06:14 -0700
IronPort-SDR: 0kX2CLGddm8HLEEag+Y+YKe3pEt+nHTcnCO7uXU06YhQNQl89NB02BAkeAGiht1fqyYtu11f8c
 qwT5lQm1SoIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="asc'?scan'208";a="380650679"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 17 Sep 2020 13:06:14 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Sep 2020 13:06:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Sep 2020 13:06:13 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 17 Sep 2020 13:06:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9X7uWGerSpxC/Gq6XW1qby/hSfZf6aq65ndm6huUhtU8MPARF8szOvoZPiN3uA7t9l4f5IgDQ5FsIL5JDoBaMlgN1WIn0YnVejucARW+3wRP+qTx+XocVTf5lKCwOoX2Igscn+RSFWkC9D6IOJOnF7wf6Cqi/T5l+3JR1v/WyEybqZTt37EOtdTWKtpzMd5IcsGSq64pqpISMvLZACLKv4loN3zvh8cjJss9esTGZZNCxvyvrqKW2YpABQGgA4qU8aFnkT71kgWQq+XcmQEvgC/kSTVmQpAps/tdpPA19Lol6MVuUg6P/xTeQXNe0StI3LEOJ1m6heXSDZ7BJpxUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/xnWwSPnkl8fVhoWrEOcirt8a6kWLIQvdt4CIVvGGo=;
 b=FxRdth+5opv9aFCRJiON1sgnTCSh1ZvwvHHWHBpBZxKin4CDo3CZQAKuszuSvOpJwtOnkQf5A8uYclikA3vRpdsbQX5WljpFvm4r4egh768dEGJLfAyf5hfElOGpgXeW6DD1AOskLbGOSD8ldRlRHUBRShsrxotgmkGPOM+GMJFHA049L31gBYiTtDmjVmWP/eiVeF9TkUwdoEkeVwnWA1As4ONUivD+D9U6h08NcRAKQ2GZFQgZJ6ArG4QyP+fnrWceLJ/jVWYij15G4i/ohU1xhuP2JxCersXPL+PJVuAmHBCOGCiLdfwQL6upQM/7e5UImCcuvufDrUlDTPdExg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/xnWwSPnkl8fVhoWrEOcirt8a6kWLIQvdt4CIVvGGo=;
 b=DAPwjwtcoei1VjWziApTBK1LXN+S1LbvPnPquwqURanHyWEMzY7ky32Dv+e+chN41xs6nDJE3w6kJgrbEXwXIpYQvjuiREa4v3TT4/udCAM5vXe3jPMhuZWsYAd71d9RUjBDzt8/grzLEQEcCQcBeLvcb9qjIeIQz+pXwlXvM/8=
Received: from BYAPR11MB3717.namprd11.prod.outlook.com (2603:10b6:a03:b0::12)
 by BY5PR11MB4228.namprd11.prod.outlook.com (2603:10b6:a03:1bd::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Thu, 17 Sep
 2020 20:06:10 +0000
Received: from BYAPR11MB3717.namprd11.prod.outlook.com
 ([fe80::8c38:841e:98cd:632]) by BYAPR11MB3717.namprd11.prod.outlook.com
 ([fe80::8c38:841e:98cd:632%6]) with mapi id 15.20.3370.019; Thu, 17 Sep 2020
 20:06:10 +0000
From:   "Rustad, Mark D" <mark.d.rustad@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v2 06/10] drivers/net/ethernet: handle one
 warning explicitly
Thread-Topic: [PATCH net-next v2 06/10] drivers/net/ethernet: handle one
 warning explicitly
Thread-Index: AQHWiw/f9wQ1MAi65UyrGE2kU32oIKltRdeA
Date:   Thu, 17 Sep 2020 20:06:10 +0000
Message-ID: <3C4D967A-183C-4EA9-BA87-CE6731C24AAF@intel.com>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
 <20200915014455.1232507-7-jesse.brandeburg@intel.com>
 <e15b85af416c7257aaa601901b18c7c9bc9586e0.camel@kernel.org>
In-Reply-To: <e15b85af416c7257aaa601901b18c7c9bc9586e0.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [76.14.31.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f38f7d8b-d9ec-4c59-aba3-08d85b451f51
x-ms-traffictypediagnostic: BY5PR11MB4228:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4228B138FC187B93C647CFADBB3E0@BY5PR11MB4228.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qxY44t7GFRwhN3coGcyQkY2s56eQ+BFFF5uMsd+mYi+EUxvzMJdDwEN++j3hUp3yqAfQVezIbWpWn6yUxXq3tQf5w7WbzmcyL9ys43acGYbpKp+s7CbDbw4z+rovN1vba4JKyENL0RcjGyesvbtz5W7F5owYzX7p1UXCBB4XykfcXSFvbkb8B9Ku1xSHGiFMxUy8z6V/itzecXmKWNpr61bzTkkObmtKb3mUXTL9/hN8tVQSDBV5EV8+l/CR4BfndES2obElRohGcqkPvWQu3H+cXIsCjDWIg6SToZ061VrjsLJSM5BGYSq0+FFRlz0+H0b/xMwXEcud14QGlvnTuiipUzE/FpH4/TvuTA4fKN7PzmE49ZVCVznXSxBrSHx4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3717.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(478600001)(76116006)(5660300002)(8676002)(33656002)(36756003)(4326008)(66446008)(6486002)(8936002)(66476007)(66616009)(66946007)(6506007)(86362001)(64756008)(66556008)(2616005)(83380400001)(2906002)(6916009)(54906003)(71200400001)(6512007)(99936003)(26005)(316002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qL32z4NbnpIp98pSAr0Z9Thbe95yhYbWs8GVM/7suXKz/QWgHc5GmIT3/yv3vH4VThFktFS45C4A34RP8THFKN2yP3NHT2cG/I0ZTEo4Bhe/9ACPEsSboCWgqGifwoyS4I20sxtiSUjG9Z0InEOdj/Lpp+woz6cMb59pINts5Zfgv0P9QBK7/XjPY7ME4F8TdPpg1V6DwU/XhX3JGrG0ObVThXZVexiA5pOhYIu2ZR0lv2SWqHGI+uX1CIa2vnVR982J0nPh/uSpqWFLMTxm7dducJHb2noNxW1ipd3fcP1mi55q9Eu5VZ2BMqkJ8LpqWYONY7XhO5vgiQpl/EZhvtbkV++WbajO08Z9WVWzSJmREkR0ncDzNbaIqN8kjrPaGfPzcfPejjgr9df9ZwYxMYGlFQGl4Wsx2/nRsQX2GuRhY7uKSL3ubZB+IAfZjlQp/8GM6S53Mem+Hhno0YPhk7pdfnFwmK+md1D6Oxwd4Kc4wgk1QX4162jZ54FckkqbCbPnf6ZW0OpaTsbzEmVxYzZQtwGuY8fbYH49lVB6ltQcIzjOfRvcqXs4Idfwyj89os+Mt2gxsD3rtndjgQQaJOnXres3S/Wj25mu0jnTuLCRRxhAqZ4Nqm+dAzDBf/G3hr2m0w35boBqK4+uvRmv7w==
Content-Type: multipart/signed;
        boundary="Apple-Mail=_0BCDF56C-DE5D-408D-B884-24A00F234934";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3717.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f38f7d8b-d9ec-4c59-aba3-08d85b451f51
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2020 20:06:10.7823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dna40YZ9T3iKaVCgg75L2J3H6Bu5S4+SoGW3xITNs+0zjhVLRtUq6i7V8Tw/h8NGcg7Whert2dEXXJgu5jSv9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4228
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Apple-Mail=_0BCDF56C-DE5D-408D-B884-24A00F234934
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii;
	delsp=yes;
	format=flowed

at 8:25 PM, Saeed Mahameed <saeed@kernel.org> wrote:

> I don't have any strong feeling against disabling compiler warnings,
> but maybe the right thing to do here is to initialize the gaps to the
> invalid value instead of pre-initializing the whole thing first and
> then setting up the valid values on the 2nd pass.
>
> I don't think there are too many gaps to fill, it is doable, so maybe
> add this as a comment to this driver maintainer so they could pickup
> the work from here.

The problem is that filling in the gaps creates a maintenance hazard. As  
another example, the kernel does exactly this kind of thing to initialize  
the system call table. Using the override in this way is the clearest,  
easiest to maintain way of expressing this.

Disabling the warning not only gets rid of the warning, but should also be  
seen as a "something special is happening here" flag in the code. With the  
warning disabled, there is a hazard of now missing the possible  
introduction of an override here, but I think that risk is less than the  
risk of failing to fill a gap when changes are made.

I completely support doing this in exactly this way.

--
Mark Rustad, Ethernet Products Group, Intel Corporation

--Apple-Mail=_0BCDF56C-DE5D-408D-B884-24A00F234934
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEE6ug8b0Wg+ULmnksNPA7/547j7m4FAl9jwbEACgkQPA7/547j
7m7+LBAAmKhPVGhMiQml4JlJi7FswoNeKMrA6QBSbyFLRKhk81iiXiMyGofRYj2p
hFwBRSehrCoj50TztiXkNeDTkVKb0TSsuVUaC8Jwc1N6sh3nQxWr0lQ+UQbX27fW
W7yDR41v5myC9EmyxV3O32P7fT9nT6yNt/D4C6G80AhinNg2g3ebHgiLyJ+ePcg6
B0NLxHmBjkVSN0zRVbiUEQMYox5rNm2Wo4OzFtokE27Mn76TCUnb86z4LmGbo5fz
Iy8ln5DE5o7wQBbctO9uYCv6nDLWUBgsF/XL6baO0zCTyv/ToJupyN3nbvJdg5yo
Va20PDkGslQldwAY1LbJ9v/GKbFQg5KrHHr3EQEWv6XgU8QU/cr4QRDxQLvaQOwF
J9gHsYGO40tQfNoMkugbMk4ZXhBuAA7XZzczRm2jnhIICWgQPzFzWtdbpQ30mskQ
zDvNXjuZMnO4tb/CuHu3qaSRuY+Vp9Mdc5DuC0ju0d2Uo+AHPwohRv8I4IXcqmmG
I8K9jPooGJR/1QmmcEzahx+561lKyTO7O2yahrXjTRDxr3bKNyVnzMkXllucdThq
bXGlFUgVRkdu7U8kk0ItvGdzFjBeZO/C3c6303aDjAwRFi9rzjrkVYdG9LGjiTLW
1//MPo94T6ksHHU/31ylXnXhKgIMQ6pmwpJ0bDNv5SxrREymHZc=
=HDfR
-----END PGP SIGNATURE-----

--Apple-Mail=_0BCDF56C-DE5D-408D-B884-24A00F234934--
