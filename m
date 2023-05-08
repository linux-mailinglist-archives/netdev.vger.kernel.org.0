Return-Path: <netdev+bounces-983-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 932696FBB61
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 01:22:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42DD8281159
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 23:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C1A8125B0;
	Mon,  8 May 2023 23:22:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB562598
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 23:22:37 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D093EA
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683588155; x=1715124155;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TFTRjbLYMMUkwms50JxodD1EVDwzyEf9MJVvO3FlARI=;
  b=EEVyuJVcuaNmOmb2NfS90lRHTadrFeH9FA2ZGT2FEpC7qLHzaWDkfniT
   frZF3GTdrCYu2iWnxzjBDmy21LBWDP5zgUrmaJ4OAjNeYMNrNu8CxQUba
   XUtvk9XBH3t160HAVh24D6WWOGSGR8INDRpNhcbrMYslqbpoiqBb16U3i
   j6RNsznEcajY90VQRPMghchIpFZjCS4dYkxg8FdZMjLxmE1pMsOmVkytX
   XSHsGXFomoNPE21Nso50TFLIYlSmI8E8rvz2Ry5Ko0I9dOuRI7JFeMwGB
   +q2tMNuVrV5lLAKh/CW7K+VrD3R2zXkC2Jnn7oIBXHBQpMJ79I4m1CdpV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="338999237"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="338999237"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 16:22:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="763586113"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="763586113"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 08 May 2023 16:22:34 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 16:22:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 16:22:34 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 16:22:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHh5B130ABQBUpQEh82MZwVzwCHwEhBl6/SFauaHiOvwiSgTqy48MTkwdZH6hnQ+9jSY7n7S0ElYQaqsN5JfjF7cG1GucYXVE4+DEd1V2Y7NtCEseregRfd3nx7q85PBdumgrimFmzSI2CZyUwUZ8rHNW5457w0NRD3H7By84WZv4ND0V+FAbO9ecLqgbOB/SJyUnlwsqSB479//PU34Sbc4HWeaiYSqjU+xEN/1DviToPaRb/FqNC/jHhBECFNb4LoEMXAYC6/yhK4m7/bHRvX6fhb4r7Uh54ls41Qe2E83vxBIjPx0iLTmvwQyXYuB+MtA7/bH/uFhN6QUVqnnCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6eEhCVh3jFQQNMMjbcAoEz0vAKRw3WXJsp5G9xHJryo=;
 b=F1xyiT83sVpBKF5cNdIEm+BbuzhTz2fdSATsLI+fDOklTmId2iEZof4+bOALqqFmPCDLMQqXtXeLqDOu3rIC0olthmhsjTTUy43PRKREBwZF7kY/X8VMJjOlCl39CmfVvU0SKiuu0Cka/JGsNwf9Zd64/dqXapeXVC7npZaRK6Vy0MbIwA1kAY3r3VRbAbfJ/9S37B2I/+tt8lRIPP8V+llr7E1h/thfAjkP2or3hNRDInd84fDZYENw5+Suz6hikyjcf+RS3nylrquB1jDMT6+B3h5KKqDxq2x08D1fDbHaxMNzwCw6CQfB9WQYE0HZRUb77iTg5S9tyaLzzSj+Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4107.namprd11.prod.outlook.com (2603:10b6:5:198::24)
 by SA1PR11MB8446.namprd11.prod.outlook.com (2603:10b6:806:3a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 23:22:31 +0000
Received: from DM6PR11MB4107.namprd11.prod.outlook.com
 ([fe80::29e3:b4cc:730a:eb25]) by DM6PR11MB4107.namprd11.prod.outlook.com
 ([fe80::29e3:b4cc:730a:eb25%6]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 23:22:31 +0000
From: "Chen, Tim C" <tim.c.chen@intel.com>
To: "Zhang, Cathy" <cathy.zhang@intel.com>, "edumazet@google.com"
	<edumazet@google.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH 1/2] net: Keep sk->sk_forward_alloc as a proper size
Thread-Topic: [PATCH 1/2] net: Keep sk->sk_forward_alloc as a proper size
Thread-Index: AQHZf9Ntgehazzv1OE2sbGvaPAj1ya9RBoYQgAABTHA=
Date: Mon, 8 May 2023 23:22:31 +0000
Message-ID: <DM6PR11MB4107B44513F6BCCFDB813E23DC719@DM6PR11MB4107.namprd11.prod.outlook.com>
References: <20230506042958.15051-1-cathy.zhang@intel.com>
 <20230506042958.15051-2-cathy.zhang@intel.com>
 <DM6PR11MB4107DCA9F443CB5BE3A94119DC719@DM6PR11MB4107.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB4107DCA9F443CB5BE3A94119DC719@DM6PR11MB4107.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4107:EE_|SA1PR11MB8446:EE_
x-ms-office365-filtering-correlation-id: 88b3b721-17ff-44d0-c46b-08db501b18e2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IM3CnQMkcGu62FhqF10XhRl+SETVGSiw0E7wBzfxgacRvQdJJR2mkUCIr5HuyKHbY/v/+if51jeDZKV5k96dX86vIE1H0hO0ey3UBb9m/trlIIdHZOyibLAB/nJduS6wiuQXgWBJKU79yavZ/GDB1xgW8QKeDALqdiuN2AvYi5Q1E7HugN5MLpkEasABQY8Omhifm9MIJU3NEhvsf5ZnHHL7A9ZVKlkNd73yiP3/FN2uQVNam6WtyX5GDeTt/dA7bj3LOP0eokp7+pDUMvaxWNgjcSPFYVdHyubli6w8NUk18+b4CH8oS8ooBWgIG+MUZ0xOagdzkQ5Cdz14i+8/onKZsjM5RpHkB7jFv4vJqdR34cX+qfHoUx8BTn6eCkG2GKjO6cc9xmvnTS2DQnBTGqF6TrYv2QGFFShCynOp0ikKYnR7h9NGBl99kIjb7ZFwK5PP5GkpT/g2r6xvGnTkUX8ts8Lr/V7x5bQEU7WaeJnTLXNl0HCHDVLbOlgKXBfoRCuQHmhxbvkmCCRCoBtrh8hH+XkhvmI9qrqAs727bXcUtjESPSn6/Hhhw6yCL0gv6rE6+65LoH2Y2PBdOJQcNx4dO6Mb+ZNzxQSjYdlUQto=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(966005)(66556008)(66446008)(64756008)(4326008)(76116006)(66946007)(316002)(478600001)(7696005)(110136005)(54906003)(86362001)(66476007)(33656002)(83380400001)(6506007)(26005)(53546011)(9686003)(71200400001)(52536014)(2906002)(5660300002)(41300700001)(8936002)(8676002)(55016003)(2940100002)(82960400001)(38100700002)(122000001)(186003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IWHt9FwQoJg2uVoKB/Ue1e1O8nuNL2EUNugkaM1nHosYXXF6o9YI4/XloVzW?=
 =?us-ascii?Q?riXbY+HvESyvPuKe7fc984ROATYqb1dlFfMeLhjbP6HDiUJX1fmdhQPS4Qax?=
 =?us-ascii?Q?Wn5EodeaEM9SWniCAmyecQ5NickQtnB04Oo6VHB0OugjzmglXfi14+knsOjz?=
 =?us-ascii?Q?i5jbhb67lrIfwJAmvWwHEIeniUM4cwqret70sVqhqBJP/NXCHCl0ESGgRao4?=
 =?us-ascii?Q?DDVezS2NgVgwaBekClk6/MGSt8UQeZxASuZ9oPwFjEkPK/4oYqaHGMQsmOqW?=
 =?us-ascii?Q?WEfCIozPAr/633UeZKq6LfJ4ygpgxDF9KhcpMmYB7F/VO8wKKo8UznwL6w/P?=
 =?us-ascii?Q?err67Zy8uUUuqcOOfhq7XMvcWMpd88golnUtfYoGFaXAFLGyDwYlyC6VVzE8?=
 =?us-ascii?Q?S89+69iMRWX4JEJH1wLMXE7xr+eyEhC3EITlSmmPWxe2xN+HPlH0zrHLH6HN?=
 =?us-ascii?Q?n+S0QOZ8UMiT6R7iuwXCqtgFoCRMUvbgPxS6pI7AFEBXP0xBiqqwO2CldNJ6?=
 =?us-ascii?Q?y1gF/Da3FTeCCJyF7i+xqR//Gkbqfx3+XhcxFHE57ywxjzpX//6FcSg/47NJ?=
 =?us-ascii?Q?PU1X26Qy7fsSc+wHPcD+KYQrcpXXnt6wbbYh6mX3+V9CbapZGNcU0hc670Ue?=
 =?us-ascii?Q?Ys7dCzCwzAgfV+lzbUCzEpjAu1u/kk/E+9NftbPUVDkY1Jepu5kpyxmKtekC?=
 =?us-ascii?Q?uG/F31YK7GwBAi2dVMl9PYDYT2U19sjmiynTdT1RPPTQ9IO0HDQlxMGbwyjy?=
 =?us-ascii?Q?uQXre+uyFcJ4wjjRnIN/71Tj72RNXyWPyj3by8HMBrJjG7tkmIdhJNO/UODK?=
 =?us-ascii?Q?RazthsBLGBnfvpriH1sBf9FQGHmH488C2AZbH9ljq3iPgeUN5jK+pBvTsCIw?=
 =?us-ascii?Q?nuVR92jMlF2aR/RuNJ66Hu6ITZ/sf73pkDHvIG9DfvZG1twpnDAGUy2hZKgO?=
 =?us-ascii?Q?GxPD2DLG0vZ/WM3jPc7Mi1BzmKNhloRXSvEivvvcQEyunL8RAUWvWnFVAUsk?=
 =?us-ascii?Q?vG6s+RP7q9LR/MxVAY/AqtwVgGPSvCpnClneYXgIIW1oCRAL2YItIo1Ta62z?=
 =?us-ascii?Q?H4Ydck4Y7JZKxSZJCamgXF030GsxOqSYHQbbGLqOd0XjEAUczWmbtRGdifZs?=
 =?us-ascii?Q?ACrkLDwnZyT0EV08NxRJ0gezjEjxgAwDYibr607C4DNunp4TJxBa4Df1PtWC?=
 =?us-ascii?Q?lC4jM/Ib7+CJvPyxr87RSemD+I5RZ8uk5/WjaZ16SmaMcU6UcmdwparzEdT2?=
 =?us-ascii?Q?1xDnUPenQ+ptUjgCM0lKESkedIjx4w23PkgFpXjO/RA5PHmQ3UD9PBgJaFQT?=
 =?us-ascii?Q?C2kpVsSWKZ8UPi9+IBC56agRtyCPWK/iVzycx6IA9L2u13KNQgwD9zbZfd6b?=
 =?us-ascii?Q?QltenTu8KuOUkTouCDwaaDDtTHihCwL1xOQ38zFTdLLywzvIYwtjkG7aMLrc?=
 =?us-ascii?Q?jaPbfwAQQmVdu1PRlBBlCy3SN+Q/SSKUqu4OriLf+y8QZOjdEjn9JuXKyG1H?=
 =?us-ascii?Q?bYayQVb8MuQ909/jKE/FG2vt8CUmlRyS5tnuDFi3BR+DqvH5bz6Lly2Eok0L?=
 =?us-ascii?Q?k6iZjgZZnaZLWiFd+4PPREb1JKIi0fOIXa8SweGz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b3b721-17ff-44d0-c46b-08db501b18e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 23:22:31.4342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7fchC92KxSalugc/Tk3YQ0U6DRGLMWhi1BMI5hlUGlR++dA0rKq8lr/S07ju4EcHpkMEO3fLD1VOByc9zC0JtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8446
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Never mind. networking code has its own comment style according to
https://www.kernel.org/doc/html/v4.10/process/coding-style.html

Tim

-----Original Message-----
From: Chen, Tim C=20
Sent: Monday, May 8, 2023 4:17 PM
To: Zhang, Cathy <cathy.zhang@intel.com>; edumazet@google.com; davem@daveml=
oft.net; kuba@kernel.org; pabeni@redhat.com
Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh <sures=
h.srinivas@intel.com>; You, Lizhen <Lizhen.You@intel.com>; eric.dumazet@gma=
il.com; netdev@vger.kernel.org
Subject: RE: [PATCH 1/2] net: Keep sk->sk_forward_alloc as a proper size

+
+	/* Reclaim memory to reduce memory pressure when multiple sockets

Improper comment style.
	/*=20
	  * comment
	  */


+	 * run in parallel. However, if we reclaim all pages and keep
+	 * sk->sk_forward_alloc as small as possible, it will cause
+	 * paths like tcp_rcv_established() going to the slow path with
+	 * much higher rate for forwarded memory expansion, which leads
+	 * to contention hot points and performance drop.
+	 *
+	 * In order to avoid the above issue, it's necessary to keep
+	 * sk->sk_forward_alloc with a proper size while doing reclaim.
+	 */
+	if (reclaimable > SK_RECLAIM_THRESHOLD) {
+		reclaimable -=3D SK_RECLAIM_THRESHOLD;
+		__sk_mem_reclaim(sk, reclaimable);
+	}
 }
=20
 /*
--
2.34.1


