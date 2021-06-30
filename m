Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683D53B801C
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 11:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhF3Jiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 05:38:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:38884 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233952AbhF3Jis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 05:38:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="229955610"
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="229955610"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 02:36:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="641645157"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2021 02:36:17 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 30 Jun 2021 02:36:16 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 30 Jun 2021 02:36:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 30 Jun 2021 02:36:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 30 Jun 2021 02:36:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGRvXp8e14GgrM7PlBA9K70LIyephy5nfo6M3zzScDRU9vua6M18KhW9vo1xc9NipJ7SPtX9bU6Hp0DZlk6eVemZzOffNMvbl0NwjAATB3gpOxZeTsWpUUrxzzZW9Y1JEYZ4e72Gr3WOc8+r26HpnEjN89MQc6QmhLMiwsveasA6ZUvlaJ/NPPkoOjSCDsDZCyQoi5d6FS1M+9efaDEKeFppHCPcLnbw6WisTwT6IFp7nzRUwK80BNnFw3M5JwCCgdSLcmZlTAooaXzva5OP+aSsxOft+zgLZA1bR1+/tmbG+iiPU85SFyBaW2uFDoLler9SOEG9MPQeCKKLmZI3sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFtJcwz4di6eafShsFU0waBrDTztP/42Q5tcDki2+Qw=;
 b=jbE6bjYnM3Mi7t5vPwGDGCumKwfVy17s5OQgC9um/hlOHR8+aWOqVoszjVOVopXbvROvi78aC24oEpUU2qRO40XRNwUo0ptBcd4YbuQGjgFp7m0akGvEFFKtGirKzkIu4xuHtXfAQyzeHshNWtftZjri9oGUHqaKZPdB3/xcL3B702ZziOPbKcpvwwGvsU+bHSj7FXzWTA2Aviw3XTuPQIPG+FeP42O4VNPXX5K2UssrYoQlc4Q4bCfEqAIcZx23yaLUy8HZPgUxvmLVYCizk7enz2xeDFIrIbIZ/KSTLfjA1TtmdgQP+uu35ycMdCR8dB5Z4A+aNedaNWY/J86SBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFtJcwz4di6eafShsFU0waBrDTztP/42Q5tcDki2+Qw=;
 b=Hi5GWd05d6JAVu1cSnTk8pbjxpjitpo6DgowPmM4F4Kx4L3XfjYZe4V87ujsBK3sZcsMDSCT6UkM50Y9gyb1HnnAs+LncBul3Y4CeR8Ey/NNEd+KJKjY6FF4Mv/vqGl+sidPkAFrLugodafDSA+4Y7MwdVtfSqyJqufUO2M05iE=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by CO1PR11MB5027.namprd11.prod.outlook.com (2603:10b6:303:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.26; Wed, 30 Jun
 2021 09:36:15 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::44f:69d:f997:336b]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::44f:69d:f997:336b%8]) with mapi id 15.20.4264.027; Wed, 30 Jun 2021
 09:36:15 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net] net: stmmac: Terminate FPE workqueue in suspend
Thread-Topic: [PATCH net] net: stmmac: Terminate FPE workqueue in suspend
Thread-Index: AQHXbZDxwVBFmrbn6UOsWXk8TxYekassSnMAgAAA+hA=
Date:   Wed, 30 Jun 2021 09:36:15 +0000
Message-ID: <CO1PR11MB4771641AAA5020C0253964FED5019@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20210630091754.23423-1-mohammad.athari.ismail@intel.com>
 <YNw6Fm/bxum6Diiy@kroah.com>
In-Reply-To: <YNw6Fm/bxum6Diiy@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [175.136.124.169]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc18a81a-1d43-4a5f-c29a-08d93baa81b8
x-ms-traffictypediagnostic: CO1PR11MB5027:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB50279DF03053791C1D6D8E46D5019@CO1PR11MB5027.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r9eHqQ2WPTTAgf1AINn5ZFglrXsWUEVM35qcMMrpuw5I1lmpL4/Xqc3vjvdfBG5AEdt+DTL9s8IeUDgmd2TYwaTCCvt8v6jF7kKKsFKc4hoypuXPAlCiJUh+QdM1JZzmbY3oP3WjNEE4QD+x7i7kObwdYQdoKMnTR2w532J88T/mlLrl4M4zVB1vf23+H6jm/6bs4G+ILiROnpX0hLCvXcotO6PJW5ss65iKAA2XWPVDzmUJJzHW8Q9yWDpe6LO13C/fpi+R5v9S2dFHuceGYCJFkh2d/l7nja4x7rWWISKYWjFze/zB9hisLDcuH0R+PZMgoATKAQKdSsDNGJZMZe1jPO9jVkW60DqGL2pJx4ob9s3MSP3j1SwNnoUg577Rtuv9Z/GtMbtt1fsCQFIlvaO8054GjHmGpypFbXcXC39aJEBHSQyGcxRhKJtywrE9yDzaSt+QiW2cQylYc4fIY6bMKedcOlbOAdnPv2iUJc3saxb1UvsI/PBhXZW7jtqqBFgDZ5ltx8sA+wnUyW39Ewn8NeuUK0+mkpxJc1OcN3DtxmawBKqFvREPSVXNTv2HmJOPZ5wmQJ6e2PHmGaL07Dt+p6EwLSWUUO4FXgzCmdDC4O+vl/Z0q2rSvmtw8QZumJJoQ74sYIH2o52GdycF4+nVnz+5MpFkJvLRUoI2ddLlS4SZ7OQCp2HdCSe0mIv7pp5vibPW6zCAPLCne3R78yLN8Y0s+ZZn7mkHHhg7aCkcbLhVp9BkxlatD12QuCk2+5uJ5p1xmIu6HIdnJXa1mg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(39860400002)(396003)(52536014)(8676002)(186003)(15650500001)(26005)(55016002)(86362001)(6916009)(9686003)(5660300002)(33656002)(7696005)(8936002)(53546011)(38100700002)(4326008)(55236004)(316002)(83380400001)(7416002)(478600001)(54906003)(66946007)(6506007)(122000001)(966005)(71200400001)(76116006)(64756008)(66476007)(66556008)(2906002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SVDxbMlIkKRRdJttLinA4D6YJ+JV3Ian/11mGZwYIkuUQQiDCkCdpBQ5eblE?=
 =?us-ascii?Q?aVZ/enfl+jctuSymD2BIzQI2wMrRkFXlZXwDHtwL8aWvKP2NYnKH3/eLVtDz?=
 =?us-ascii?Q?qACQXYxWTSJE3nnWuIpw0FvS0W+WfRLSykpZzSPavtaXwFqmP3ApOKtKitxm?=
 =?us-ascii?Q?B0L4mUP9OYSYEy98OVtZ2ZlGo1/rDm6cfa6FHObQZL5gf4/D5Q9iihafYqae?=
 =?us-ascii?Q?Ko4XOuMnvnR5PG6hUJTVqfpb4rMPLt/ZDWo93a5bpv32wa7Nt6h8fMJ5eSXb?=
 =?us-ascii?Q?EmMY6rcIiNVcmgXadfyvBSfEgr6xeHnxBEg2uZIpwh6hXRbHNvMZM+6YV+Ol?=
 =?us-ascii?Q?u71YscQkJ4w7fu51NlKpXlhhj/Yy3mYc1PGo9K6M6JCbIGBIGJhpcSOHAbx+?=
 =?us-ascii?Q?IR/j6ka5eHhczq+jh3WCv7bxu1Wwh9lVElhBiuFx+dAW2E6+h9F5KEmzMgeB?=
 =?us-ascii?Q?z7TnbBqzkjLTab9Epo9Vn55rBzJEQ5Jfh6fH32lGVjjXykkcooYPmkUOi8oB?=
 =?us-ascii?Q?4CyACgneD0jy1qRypcsZ7uEyM4oqiSM9zNleUeBR100vVPlhP+YL1tynsAmi?=
 =?us-ascii?Q?v8dwQOGUOF2icYJCnqDXqQVLPu74TAhm+yz3m9WhBwUVbD4pAqFfRyUfA7He?=
 =?us-ascii?Q?jzvN4ct+rl+yxSkSEvH3OoCnDvjgjEryypoqpJWeNPO6kP80OyqeAehvFCc0?=
 =?us-ascii?Q?eLX3nPYCMAU7QiBla/YBhcO+BoijPKglG2wNqKeQ8o1P8GT/9xcRd/0mmlIZ?=
 =?us-ascii?Q?kNmAyNgUDF/sYftjdRW4kQukR7ND0/7xZJ+O/t+jFHMJgwbAPBn8SzE4zLaD?=
 =?us-ascii?Q?//GEa7l+S5dOevCmtquGLRjH0IQgcQJfKSiXTX8BfGEcsCALovyHbbxBJMID?=
 =?us-ascii?Q?t11FQ+wefIjCkSgWrPIqDPzT/JBeey8dAKkmDMqvPAwDioX3qNpEX+yFRXTc?=
 =?us-ascii?Q?fVFIkbtaOSjxNcV9+pJZwU1SLfj67ExHkrSH/Gal8k8tjEFsmmhJHHu7kh5Y?=
 =?us-ascii?Q?DYyxRUXa7dWkILO4bh6SoOriNuNd/seiiTWGfVamhBSDPP5jf7TajWnxFjGu?=
 =?us-ascii?Q?JOa6YokIpo4fEfql2DN1nQWe/NQ9Z9dXSvdX/FpD/dnhJ2opip6j6kX8Lob/?=
 =?us-ascii?Q?M52PfBYgTYRniRtT36v302S5Fg3zBGorKpHMTiJpdfXj9iWEWRYMbUa+so88?=
 =?us-ascii?Q?kr+E6flKFxQkPBHCXSNN3CDwc0LtW9jqNUaN/XLgx8qjW+c+iUP8cBJt2NXZ?=
 =?us-ascii?Q?Kf02j9M9Did59wgDgW/e7t8ZE2Ejt7zvTv62VW5v7pfZa32oTitKVfFhTPGx?=
 =?us-ascii?Q?b3fxiX8MMLIAPXQneOKtoTIp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc18a81a-1d43-4a5f-c29a-08d93baa81b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2021 09:36:15.5468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ygqkr9q2X8P9zjHXrGlCpflg/QsJ1yEvcINt34Cx+6vnAsd+eTbaq2Cm18UhhM61QJhj8miZeWg5KWgbH8l22hwY25qnkyYxZFSlDzfH5h2/z9SXPxVbk1TpEhb7PyYW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5027
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Wednesday, June 30, 2021 5:32 PM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Giuseppe Cavallaro <peppe.cavallaro@st.com>;
> Maxime Coquelin <mcoquelin.stm32@gmail.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; Voon, Weifeng <weifeng.voon@intel.com>; Tan,
> Tee Min <tee.min.tan@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH net] net: stmmac: Terminate FPE workqueue in suspend
>=20
> On Wed, Jun 30, 2021 at 05:17:54PM +0800,
> mohammad.athari.ismail@intel.com wrote:
> > From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> >
> > Add stmmac_fpe_stop_wq() in stmmac_suspend() to terminate FPE
> > workqueue during suspend. So, in suspend mode, there will be no FPE
> > workqueue available. Without this fix, new additional FPE workqueue
> > will be created in every suspend->resume cycle.
> >
> > Fixes: 5a5586112b92 ("net: stmmac: support FPE link partner
> > hand-shaking procedure")
> > Signed-off-by: Mohammad Athari Bin Ismail
> > <mohammad.athari.ismail@intel.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
> >  1 file changed, 1 insertion(+)
>=20
> <formletter>
>=20
> This is not the correct way to submit patches for inclusion in the stable=
 kernel
> tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.ht=
ml
> for how to do this properly.
>=20
> </formletter>

I'm sorry. Will follow the correct process. Thank you for the advice.

-Athari-
