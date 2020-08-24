Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E160250A13
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 22:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgHXUf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 16:35:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:50860 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 16:35:57 -0400
IronPort-SDR: CLcbJCxHmaOse0EHb21H/MJojjaS91+K6kRONH3kRannAAc2ZPpIVijyFTK/0hpFrYGblhIKpq
 MTKx7JmmrFVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="155241166"
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="155241166"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 13:35:56 -0700
IronPort-SDR: zPjBgCAsCsr0Qw5aFpi1EWr8OxA+9CnaajIOlZKrEt4fI579ZsngB35zZYlpY7PswyWKAHNt6j
 Gz6QVnkn4zmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,349,1592895600"; 
   d="scan'208";a="338562153"
Received: from fmsmsx603-2.cps.intel.com (HELO fmsmsx603.amr.corp.intel.com) ([10.18.84.213])
  by orsmga007.jf.intel.com with ESMTP; 24 Aug 2020 13:35:55 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Aug 2020 13:35:55 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Aug 2020 13:35:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 24 Aug 2020 13:35:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlGIhsoPiKR0uIAAxRTrBFo2+8hmVEizih5BnrcY3denyZNxTDSnzrCPTRJglHc+NUSURtjzGqQBs1RUmlzRrCiRuQ7oZDt4hEPPrXVcv5kIrGhM3s8UdQd0c7/cJv3iVRE/D4ZxKHYg+tTbKAnxMPMzRyaDef083AbmgXJh6hwP9OGYkeO/S89uJY87XnA4VOj9GZFhHt7c99fVe+lsmAFCAk84qNxfh0ee57Q0jKQSiLMf4Qd7Gv6qLRz80kPP0gE1GBLPvkgvG2jz5nDumQGHiOO/YyE0xs1NNKrW78f1Qx6T/xzn6VN63zZXEwDDRNldkKXUpOIa/E/SC49lDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDLh17IqMw4DOBVlvB5MxreVLCB8jaPCF5bnSqQuekY=;
 b=I/jMhk492QoLeGD6ALGL+kMiRWeTwp790v7G0KBAJOXvWXGr8+sTcS3w5igorAL7r6IHV4mI+3/2Mrn9HCVPffabfslPPp9vPAYjobBkBqT/+cL7ZSXoKYXoWBlcUuthf0Nr3nZ0FcrfcYlA6x2wXmwuc3fyh40ZER1Rz8e6kgVdEvZ/Pf7uN0RCiiQaKUs7+ak/pHq+72LCwwsGLauAfhZue4x0N9Aw9Ly1w5LEg1JLI6wFK6QNETo3X3NPr3AI8VVW5cCynSgqPtL4eMPC2X/iMAAbNtWm7X5ThBtYc/4p8CIpSo/sxv0pNRf687UpUOPdIO1nps1BnKV5HWxniA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDLh17IqMw4DOBVlvB5MxreVLCB8jaPCF5bnSqQuekY=;
 b=xQtEpDc8M9Xd/xId+cBiEEgF+mD3CwU7TVOHd6UqhiOIayChxx86KX001q+4fDX+5wREcDbe1BpcK+h69S0qDcR0xRMOBBqbvvRIAFUTCNGmX3U1fUuzCQblNocien/kPHorg6bnbhvc50USTUpk7qrKD7ktuZljMS1+INyQCZM=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Mon, 24 Aug
 2020 20:35:52 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 20:35:52 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v5 06/15] iecm: Implement mailbox functionality
Thread-Topic: [net-next v5 06/15] iecm: Implement mailbox functionality
Thread-Index: AQHWejy57+NJArpv8Uytwlkg0ftvVqlHt0Hw
Date:   Mon, 24 Aug 2020 20:35:51 +0000
Message-ID: <MW3PR11MB4522AEB1B7D5001AA66D15158F560@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
 <20200824173306.3178343-7-anthony.l.nguyen@intel.com>
In-Reply-To: <20200824173306.3178343-7-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0eb10c8-44f5-4807-e472-08d8486d4b26
x-ms-traffictypediagnostic: MW3PR11MB4665:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4665CC26AB19909726EF78578F560@MW3PR11MB4665.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /hM4KvK85VbEE8OJOXpMZcPZ2EyppywlGAChuYkFOO7OL7H94uOgi6Ktw6k41QhyPKi9CvnkrQGa+uR9VVX2DSAtxaLWYGcuTg72u+nOOBK+Arvtl3zEdmgbjeDP2I0X2t1NCDjqCbyucGUP6LRZT3q58Am1ftXorgz1R/vGI7AUw0F6oMEGwFk0X78RT02yYc1CQdgHtdYcRXg7D04UCY594/MYUc5jNyAOqbywVjAvJuX617Ecee7KhP+1Q1cH2BB89dNXRR0KFUu/wEwh976+E8gJWDn/JrlOGTBRccBxx64HeUBIDl5pi1LYYH7w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(76116006)(71200400001)(83380400001)(107886003)(9686003)(53546011)(6506007)(4326008)(186003)(7696005)(26005)(478600001)(8936002)(110136005)(66556008)(2906002)(15650500001)(66946007)(86362001)(8676002)(316002)(64756008)(5660300002)(33656002)(54906003)(55016002)(52536014)(66446008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: BgAZFaMAR5OnyaluJJSCI83k1PdpibADBfYO0Yk+x86gbH0Tyc+CGr0yai1r10TI15pXEIoQHDeWvma3sWZ95sf5ayoXaxCA9ijfkbsvGgDQaSFURIVdHVmEuQ+WZg7k5fn5VpQBpg2nJu0PeJn1Y5uPBvX3dTKJQa24pQv67Qxj3hcrCNxEfePFOcMggv+SpnM1w0eHdq6lqxfUdCAm0M6nfxZSZsDd1G+K7j8uSwuWbZGEGE6Qk63RJbHYKYl6/USL8JYzszDQq9QlwPoOX9hEWNYoC2bHkUB77IkJYi5BDLw274RjheBU66zFN1mMjGdmFZE/VqE+YYuua2I+0HkPX6HgXt+NaF0XwsbRE0kq33DUUhkpE+K6mq+bUgbqPsY9TvK/5p0zskg12EnIwfj0yJ9L/ZVOSbHstK2ULoWhD92mGthVLkhjSRINeRnTdR2jIhhIAkqPHzaJCkavox9ibTEzhiQdhssDqvZ0zW+PqAfrXx9QBCxAQUkNac/5P8ApMAgvddZ4kPQO4mvOKZqWWw6E21UwZQyum1zryNKJZqmoJbEN8SgkJb4I+/dm33JViRJX2zy9m9kQhrKzOHiEqy4UxcglZgTrYsAm59pfE9GlhbaAIGebdded0Rz+WVcsbCu6nlKIKArRLCXz8w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0eb10c8-44f5-4807-e472-08d8486d4b26
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2020 20:35:51.9493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jaU9afNOtkcQp5gbv8ZMnr0tUQdYjZ49O+ereL81tqu7poJh3fJu79wuQgbdWKQnzciTlDVdqi9/Zs+NXQahWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4665
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Tony Nguyen <anthony.l.nguyen@intel.com>
> Sent: Monday, August 24, 2020 10:33 AM
> To: davem@davemloft.net
> Cc: Michael, Alice <alice.michael@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Brady, Alan <alan.brady@intel.com>; Burra,
> Phani R <phani.r.burra@intel.com>; Hay, Joshua A <joshua.a.hay@intel.com>=
;
> Chittim, Madhu <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: [net-next v5 06/15] iecm: Implement mailbox functionality
>=20
> From: Alice Michael <alice.michael@intel.com>
>=20
> Implement mailbox setup, take down, and commands.
>=20
> Signed-off-by: Alice Michael <alice.michael@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  .../net/ethernet/intel/iecm/iecm_controlq.c   | 498 +++++++++++++++++-
>  .../ethernet/intel/iecm/iecm_controlq_setup.c | 105 +++-
>  drivers/net/ethernet/intel/iecm/iecm_lib.c    |  94 +++-
>  .../net/ethernet/intel/iecm/iecm_virtchnl.c   | 414 ++++++++++++++-
>  4 files changed, 1082 insertions(+), 29 deletions(-)
>=20
>  /**
> @@ -28,7 +36,32 @@ static enum iecm_status iecm_ctlq_init_regs(struct
> iecm_hw *hw,
>  					    struct iecm_ctlq_info *cq,

I believe we have made a grave error and sent the wrong version.  iecm_stat=
us enum should be completely removed.  Sincere apologies for the thrash.  W=
ill be sending another version up soon.

-Alan
