Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3A0516D63
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 11:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384223AbiEBJeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 05:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384210AbiEBJdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 05:33:50 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97E66407;
        Mon,  2 May 2022 02:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651483821; x=1683019821;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X7nItg/45B61e7lcH2I/dWfXopbW3TmFEE8UJqW3kFA=;
  b=dSBIOQig8hw96zlNU9aP977iT35EfH1wzx147aFTcwtVX0eutBhGDrwO
   obyX0qGTav1V5zINXS9HNH3jpxIG/QZq5Qkbhapetq7DWPmN+qKRuXxiY
   GFJcg97Q1P1aKwVYO/8a51RaHPFUQqgMknrWXQb98IlvAh9Rn+MNJ1Vgn
   LXsq8EcLd52/e28Vys3KY8e3Z3hpZU8LqtosKgONJ4pYdkcyg3HQhKAr3
   xU6bB3AhnW/0sWIviEVeTIxXHR0/XOW19MnzIVjabQxylMKifh2iiKrGQ
   5MWqeIbfiHlL5V00yNSRyd5Px9A1DXOroL+bvPs/2jJeXDtEaAOrusgFc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="266746734"
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="266746734"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 02:30:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="546075029"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga002.jf.intel.com with ESMTP; 02 May 2022 02:30:21 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 2 May 2022 02:30:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 2 May 2022 02:30:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 2 May 2022 02:29:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihtI0YlABm0lfQqGYjOLiLZ61oDcrRlg3wUNIJ6XYWFzmMIALc9ZT46wu4dOz1EMQYmVNxhrSt4CfOZ/E4g1IlpyVbxzyKjBHJpTFe/SupD8zphwbGcKB/xcBL0APzTHImPG/us9cb+pIZ0AsZZpnMPUMCp4I96AEixdaUZpK+XhsmvM7EFUltWlGn8JwjdVYjzl3bt4/xrEt88NTuAVCbbrEb4sFfyPCENTM4PoCxEPJm/tf3MB/P0R/OC5xT1MGghGCa2CbqJYScl6YHEBdeVtCXPjifAbUnr9iG5Ya4BcBFEN6KXo/pRor0mx61Gvjler12WN25sazbtDmTjF3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UI4Ap2wY0xj8Vr+qse8RqMdnz6BF84cvTorrVlvYBQ=;
 b=OpdIZcsoA6sk4jS0pTpdGvHsjBOuTbgZBNRfA1fPf9sEUBmppcv9zx44wMHnHfTEd0qgTzrZ7SBNXe3FkaZAb+gUyNJJB20PYhmIUsWUrD1dOi9oj3wcRw/WkKlBN6mGusrda9Qpe4PfnAPlUDteJT2oYQ91BG/qxlNfeZFVKY85GI4UcpbLZiv/IXTl2J2RXO+i9Zr3QKb/mSfIj+ZrzgdF7MPC/oRPJzgEhZak8DdImvJ/bRotPgWpJObeqTrt5tLnVDLw30CtY5db5m3AlgrYsd59iui3MPmDRos3ZaR4M0MOMQdT340WT9JIwkWXvvey1lJFU0UcaKHBrd/xlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BN6PR11MB1746.namprd11.prod.outlook.com (2603:10b6:404:fb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 09:29:56 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7%6]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 09:29:56 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Weiny, Ira" <ira.weiny@intel.com>,
        Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
CC:     "outreachy@lists.linux.dev" <outreachy@lists.linux.dev>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH v5] igb: Convert kmap() to
 kmap_local_page()
Thread-Topic: [Intel-wired-lan] [PATCH v5] igb: Convert kmap() to
 kmap_local_page()
Thread-Index: AQHYVEdQ+T0ZohAO50qTE3iliBi8Jaz6p6WAgBC+BhA=
Date:   Mon, 2 May 2022 09:29:56 +0000
Message-ID: <BYAPR11MB3367A2BBE81A95AAEF6D0498FCC19@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220419234313.10324-1-eng.alaamohamedsoliman.am@gmail.com>
 <YmGZFfcY/Yz6Iv1Y@iweiny-desk3>
In-Reply-To: <YmGZFfcY/Yz6Iv1Y@iweiny-desk3>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9674d0f4-0b65-4918-6ed8-08da2c1e522e
x-ms-traffictypediagnostic: BN6PR11MB1746:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB1746D1E3434FB052A502224AFCC19@BN6PR11MB1746.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fRBpOm2qpFgmMy/DItZExJQiPnwDoNFaEJ9DK25DurcKveo+l1V0RpH28wTabwk/Xt3pEgIHeVPEX8z8LQUqqcQRBj1mk9HO65FBwmWM5FXE6MXfPp9Hd8xwF6ibN85AlkcRWTBvoW5O+kd7Z+Nz9Fxoj2uxzXp/m4jhKIC/xK5+YJiwG5lJDHFpechVQ2azRNorXRs063TD506JQjZ/HarH2gqBNXNQiWjWEROyTB01krjAqVLOhdgRGAr9wG76GUAaFPV9IFjVxwouEFGyE4ZDy0HUuTAmxGcYbHDxSBYUWIO6u0gBeB5dZT6FRrZIgpV7RsNfKycmVM1mpiOR888WQzXPr6rGpjN/jtiGT2j5nTYJGXg8mUV+9oIXSpeWOHUkVJ5HATwLBlpSd+xTabMwQzdpseJl2HvisRZygKpBDN/plUCGP806/xSvMGYZIdiO/+xXEmXQ2YXozJYtPWCChZTNbYxRbWT5a9KUxnJIq+Tpq8d/Y9ubgyiZDcO8wuPLaqBkrXz6AAdW68pTw/xU0jSyLg5SpoyheU6hxk8SmSqCrMLLe0XXXH1edf6EWj8KIl3gKmhHrf18lc/hyxrZKeiHdh5HRFt/IEEDjOiO6zgG0uE/BZDwNxGcjh+kd8n+f1kwHs0y0fztENEwFa4kCz8E5BRxUiJY1qHLx3B2ybqGJqax5pjQ3uGUCOuucKigtmvB6cdZRAGs60X0kQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(110136005)(33656002)(54906003)(186003)(122000001)(55016003)(2906002)(5660300002)(83380400001)(8936002)(52536014)(8676002)(76116006)(66946007)(4326008)(86362001)(66556008)(66476007)(64756008)(316002)(66446008)(82960400001)(26005)(38070700005)(71200400001)(6506007)(38100700002)(508600001)(53546011)(7696005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z9uGFTl7+vZg2TjAtEmuv9XWsF4UtSFKCAjUUl0iwwm1tUfxfKuYOdImpS+F?=
 =?us-ascii?Q?Z4QIVQzQRQFIm9+IBum7ev321izSqX4y3D6PwXruEN2vJvCGQho7mlTJbwEX?=
 =?us-ascii?Q?BWEMY182X0ps9U2sARUJUcmNiTMCHfeJgyJ5mJs6Hr1hMwPwgFnJdvQSYju9?=
 =?us-ascii?Q?rEPg8gWB1jiVubdc8JNk83S0Rw9InDNWHYXfVZ79TbLds7MB3N6+vLPSNiyZ?=
 =?us-ascii?Q?gbmRaU17V32gmVsOz8tlLbQV+7rHiP+z8FKSDwsa+vniOsiVEXI4IDwTTijI?=
 =?us-ascii?Q?bWBNcP6sVlrvY1tQrcjruXYo167/6QYxubsCVD4xMgueW9uAQeQGIYdNfpSs?=
 =?us-ascii?Q?xGz+oxGjz+1psL9tau0BVsnuLLezZvGYN4tzLyvTLTDdkNV8pXwfTUaBVOjT?=
 =?us-ascii?Q?zVzhf+hUYmN4F7Kr0BJTMTCm5GcmFleLDavcGNkZdiFU9++qwGPymTPZHW69?=
 =?us-ascii?Q?Iw0A6X/F2mNk4bfCIn1rg30JnsSsUxYg10U09ChDmU7qSV5heHPAtCpOlgtu?=
 =?us-ascii?Q?iMMqVNJNJXnAjg5ratQ+PCZ0sjbS/CKLXDRfJsIrUpbDzi2YJFeCEM8yg9sA?=
 =?us-ascii?Q?J3XAS7AZQ0hYB9fLPrFiBBmoa1QbhktYkW9U5X3E84skhdz3Rph5n5GUahXi?=
 =?us-ascii?Q?IIkvOmuab9XswFeJQLGp1jX4dtHeyQmRfHHwCsicU1CT0gOul/Lw458d/GWZ?=
 =?us-ascii?Q?iSDDcH2KvwaoKBN4hS3fAGSXATCEfpX7YgZzEu6t8JX8Q/GIpTAho7t9QIvw?=
 =?us-ascii?Q?+Aa48Ivvd9gJ5T9egjcJoyze3x8p0YpfIszDC1Max1hQQwe/b6SCQufhiw2z?=
 =?us-ascii?Q?+E5Io3a/e0g7lFtnbyS2ssBjNr5TCmB4pr1jCNyDXDDgFovrC62Qh49fXfs2?=
 =?us-ascii?Q?R5V1wckea2wtOXXJRjs0WPO3yrN6xouMa89++1X7lv6mvzsxOREavChf82LR?=
 =?us-ascii?Q?XK+i57LePRmRzzt+ptgPZD2N2Rtgf+4zQ8WPKZiClizG4VYAlSwRM0XZbEfo?=
 =?us-ascii?Q?tOa3NepHDaYxWsrEaGChiYLtCvynCW+utLif9eyRwnd3l8mmkhgCQ4FAqoVD?=
 =?us-ascii?Q?aEL9kEya6/DULXE1zTwjLzanKkcnwmR7lFWT/BFZWk9R2IYH0O8FSJMNUmZy?=
 =?us-ascii?Q?yRkIpEKrpQemFKgYt5SRdsEds7Kgfyc/l4t38O3SWL8TP2Qik3Zt2OjxbQYd?=
 =?us-ascii?Q?XF2PWH3t3dzA6w+x/Zwyf6AgSIoL0X8fx6DS7nXixk5Pcf/1bFSVxKrf2rUn?=
 =?us-ascii?Q?t8Qd0tjiK3x+17wOPlrttfH2PibQRWf5sG2RSqRdMW+4B8eEHX8vFGNSvfka?=
 =?us-ascii?Q?ruCpZzZx2TFnx9UEDnQezSHyr/wLmDQkGXtxSFhyrjZU6JWvrHixcaEbz/cu?=
 =?us-ascii?Q?NEIEkVroihkvq88xBubBJi/wcFnlVlB1lBkDIrO2Q4lMPGG/kwUsnrK8ZDfO?=
 =?us-ascii?Q?yqt9jGvaPvIiljb0/DDCiDFXBlpR+/t8bF1PKdE6wunvvHsVtZOqm1pzb0+C?=
 =?us-ascii?Q?RBuIxtSPsScnlO0oC3DvfynzpylizmJYMs6IAWmESOvfvhgQ4Pr4F1twkoVT?=
 =?us-ascii?Q?/DsaCdApg+J/iPye3sMVoO9r4FiVjY2PySNYPcba2t56RpvoQxVCXl1S+zZT?=
 =?us-ascii?Q?o/Eq7IkvtVHEvqkrVjNF2KVpZlFcO+fP/uioIuwgQTEcZ58L5VrPWYdpywsW?=
 =?us-ascii?Q?0hKkzJuqjMJink5SXoBgSUGFNE5+k7LIam1HPbYRop161ajpl5+RdD80wT7A?=
 =?us-ascii?Q?+tDRlHcBgw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9674d0f4-0b65-4918-6ed8-08da2c1e522e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2022 09:29:56.5137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9RQB3CrIRsAlkIqmnxr97TCa58okxHF6Ivw/pJCAEfs6DdxghOS0Lk2yHBg3Bm2Yp/dQocAiVXKW2AmiggtwWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1746
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Ira Weiny
> Sent: Thursday, April 21, 2022 11:19 PM
> To: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> Cc: outreachy@lists.linux.dev; intel-wired-lan@lists.osuosl.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org; kuba@kernel.org;
> pabeni@redhat.com; davem@davemloft.net
> Subject: Re: [Intel-wired-lan] [PATCH v5] igb: Convert kmap() to
> kmap_local_page()
>=20
> On Wed, Apr 20, 2022 at 01:43:13AM +0200, Alaa Mohamed wrote:
> > kmap() is being deprecated and these usages are all local to the
> > thread so there is no reason kmap_local_page() can't be used.
> >
> > Replace kmap() calls with kmap_local_page().
> >
> > Signed-off-by: Alaa Mohamed
> <eng.alaamohamedsoliman.am@gmail.com>
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>=20
> > ---
> > changes in V2:
> > 	fix kunmap_local path value to take address of the mapped page.
> > ---
> > changes in V3:
> > 	edit commit message to be clearer
> > ---
> > changes in V4:
> > 	edit the commit message
> > ---
> > changes in V5:
> > 	-edit commit subject
> > 	-edit commit message
> > ---
> >  drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
