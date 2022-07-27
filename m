Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4A45824CD
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiG0KuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiG0KuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:50:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19F22A955;
        Wed, 27 Jul 2022 03:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658919002; x=1690455002;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o01P1UAIeXGzUEjwPyfaMR1zK4eH4Lzju7vzTmRKnxg=;
  b=W5R31bQ4Gbd6Vq6Ep+fLD/vKPFIfg9prmxgh/DOhiC9zFhkeC0Qq191g
   BYlbfOMxkjmIydBHUhD5MVaDZvqMXrsQvHMbI+K+qotz+37HoqD5CHQq3
   2i9W/JkJLr948tdQQgYE3NMYh/IX+88Qa18corRgNs2VmGTksN+l9QG4t
   6CKBdhThkU0ZtMLvQTITI0r5lOnky8S6A0IhtKLKoNg8Whvbdo+0P7vHz
   RJoaZDsNgxM/bBIWDm6MpCOgsPcFw/Zsy5PPmRAjnwaOatzxyn4bpJmnu
   0m/k107HEZwpnABLcQKMCnlbUY+WA1SSKYFtmm9rLQd4GqUHqmY1SsKsa
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="374502729"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="374502729"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 03:50:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="633164670"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga001.jf.intel.com with ESMTP; 27 Jul 2022 03:50:02 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 27 Jul 2022 03:50:01 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 27 Jul 2022 03:50:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 27 Jul 2022 03:50:01 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 27 Jul 2022 03:50:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2spWjxpdiPxF421kh5+GqQ6vQ2PgPYj/LMWY8omHOKh9SU1cHA/KnbouzEu6vZwysICxwDG/mM2JHW7Xrn3IYdVNS+Y/GlPnxFd1/WwK5TvHWIKqPqhU5JSatWVgmjxl2DtvTKBu3M6DXub2v2tnESXBGgJvCYFv5XRnhqhTixb4oVZLvZvROhW3m1JA6dymEHdyqksqvhuU+uooKpzZvR7lwvw3FQXo255N9nVFTCjmUzAfOW7jjD/ZJ/cdTk/5aue9nUI/bvOA4Su41cDGebL2Mo8KAXlLdU+DvkKogEEizlJhyzxnbz/nxXsn+bv1YoGLN5qjU2tNlDeBRg4fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YoQAKki45BLl5DUos2zRaJz8sB5MADRZkxFDQT6bmIg=;
 b=Xh1HhLRCx6CKQ8pDrqEQJd+Ud02JCFgH2zJDXcGrrioZ3xZryoYsdlvQwyKqleVuVzptACuzPu+hdtMsdCWP3eWSwj/4La8+DnZVZn54b8hE873cKcLn+YVuYGIQG+LwQMaF1prEnD5mjoAj+vMM44IfgkRKeFPQBzCgPdyE7qdRmc1JC7SssrqurJrHa5yG1JWh8M1P6dqCCYguw43Tl5alT/UaJqf5YLb/0zTosnp/E6ZT1OgSjBu8Ycu4rasWUYoYv4pmFMVtXKmWV7TjSqmvQviKa3y8VGBJVNupikMDkLxVKRsqwwlMdqTOOo6pddAm83gO7sYYdCPytx4Ofg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3995.namprd11.prod.outlook.com (2603:10b6:5:6::12) by
 BYAPR11MB3368.namprd11.prod.outlook.com (2603:10b6:a03:1b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.21; Wed, 27 Jul 2022 10:49:58 +0000
Received: from DM6PR11MB3995.namprd11.prod.outlook.com
 ([fe80::4df7:c35c:7387:c82c]) by DM6PR11MB3995.namprd11.prod.outlook.com
 ([fe80::4df7:c35c:7387:c82c%5]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 10:49:57 +0000
From:   "Koikkara Reeny, Shibin" <shibin.koikkara.reeny@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Loftus, Ciara" <ciara.loftus@intel.com>
Subject: RE: [PATCH bpf-next] selftests: xsk: Update poll test cases
Thread-Topic: [PATCH bpf-next] selftests: xsk: Update poll test cases
Thread-Index: AQHYmozD9Km0bnyrNEyqNWtE2fFuDK2KdhGAgAXy+NCAAFS5AIABWIIw
Date:   Wed, 27 Jul 2022 10:49:57 +0000
Message-ID: <DM6PR11MB3995F941D45E5CC3CA05554DA2979@DM6PR11MB3995.namprd11.prod.outlook.com>
References: <20220718095712.588513-1-shibin.koikkara.reeny@intel.com>
 <YtqxJ4f1osDc1Rtg@boxer>
 <DM6PR11MB3995991A0874B1FEFB384376A2949@DM6PR11MB3995.namprd11.prod.outlook.com>
 <Yt/1yLNzEvPFR0Y2@boxer>
In-Reply-To: <Yt/1yLNzEvPFR0Y2@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c3a2990-47b1-477d-f87f-08da6fbdbf7b
x-ms-traffictypediagnostic: BYAPR11MB3368:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j1ggobbGXfwMBTReiKm+tSSoSxjUbZYXCjg0zP1C1iblpm9KZgeuZ2Nkqcq+X6qgwhxxl6eQ2GbVZP/hcp8edJlmW+1VpKeRwmYwVO8j+oF/L/nEmazASZzsKwFzRXSyPrMqSpqzGhvsM1TBHS1eHcsQdKg2QvfeMDh308hh8VSrf9uWDveBFFEdoyZsGSe+YsHM1i35N1ARtzTr3Z844zTiln7pSUjfRZSkThMOXchfbw7SV7TgcUBaDia05pHM8rJkQH6Izu1kLsMnCvKx5FXEva06Og51TmICpae7M6hz/VmwtM99YadG2MnGsV8JF4RAsQGD86vUbivzQx5lkB9PZhiRpBEBP5ATycdD9KjhCc76GFLhckolZT1zPA1dUErCABAX7kIPDO16GwuzRDy9XWr3m4KXc16oWa0g0RMROwCMd34tVR9f89+CJBHPMGNn/8QTpgPzCO6j1g3kmQC1enCNJQLICzBeePcx+6kJKRd1/wIfx9WNfcE3iohOu56Idc2zDXLHfUNYxCAsyYnMc1iXPVrm+uNHAHJA+WmO1Xkis+8ztsiRoKg26Nnslaveswo1ZabSI61K3MEoiW7aO04dmDQyrx4uMQ78KavPNsF05UVtoQu6oP3dVYqXrNQAFDMxKUEdKn2lw9dZK8ZjQA8F09UX5o7ugm5f+G4aw17byfNV8DypeN+kio0og0cjAnHhbaMulLYqDTvVv5Zv95OdU69HvvyZBIJy3zBJIiIS4cOVWPseAs12GBTESVNy0IhNvCYdE1u0hvdANFS67hRbg1vRr79JimxZy2BtWXVKrThjd56k8Yu8agcg5oc3eyMaSpHXFP7c8g9hSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(376002)(136003)(366004)(346002)(6506007)(41300700001)(26005)(316002)(478600001)(83380400001)(82960400001)(53546011)(6636002)(122000001)(54906003)(2906002)(38100700002)(71200400001)(186003)(76116006)(33656002)(64756008)(66476007)(55016003)(66446008)(66946007)(86362001)(66556008)(8936002)(5660300002)(4326008)(15650500001)(6862004)(8676002)(9686003)(7696005)(38070700005)(52536014)(30864003)(107886003)(559001)(579004)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iAlXGeb1M/zhxz69MhVzox3d+QYRAU34VzyFn+ahIK0nuxd3t7InUbK9onu+?=
 =?us-ascii?Q?VPhkojxBdxcdSgQy0WcU63IcIQRwzmZEgqugkGLz7ht5nTWUOnMRQtWlsmw+?=
 =?us-ascii?Q?1eiL+BddKcXA0tlokFmmAW7/rswSFfr5fHXb1TS9tmdI11VbDSIwWMvDQp35?=
 =?us-ascii?Q?wVRZLd8iPfO2kVMeD5P6Hxs9/HnSCzviFi68v1/E12w5nLZZkZlbaDLMfRwp?=
 =?us-ascii?Q?2wdhTXRS9z1lkaDBQ7RqQas6DGfiHxDX+9yiCoWSXHou2XB7kFNMzWjzylH1?=
 =?us-ascii?Q?CN7x5mA1wqRboV4OroffD5LE5n4W5/bBmdhtFR5xmx9HfL5V7SfhCieTH7Nm?=
 =?us-ascii?Q?Laej+8ou6lU7x6HXcR9hlNXKzThC9+2f+u/N4THyHtY0qQ82Ir4tukQia803?=
 =?us-ascii?Q?8WXvKILC/vUwWAWzxFOXRyxpWTiVcIoLnTJVGmj073TB6ogX+kukVWZHD4hZ?=
 =?us-ascii?Q?GPU3Q4BxVpxh3kKlWwuS1Rj5fpKMfRjuCPwPZV2VCBx/WqB87APCnwmuLwoW?=
 =?us-ascii?Q?5YQ6yZl84oMo8xHWtaGW/0SO6TB8pC5KloZeF46/3JRpKp0GOKxOz9xMXaiO?=
 =?us-ascii?Q?fLPx6HewB9qauUyqrx5PffcQaNewSNR+ywJgJFTH5t5HmiGVnQrdfvqqhOIc?=
 =?us-ascii?Q?IpI9cxOY4sf4WLhkSSNHrxU4cpgdy8w7X0j0+XPsUL+GYbMJRZZf7hufxhSf?=
 =?us-ascii?Q?aSheb9XNYqtkM5CxyCj14kV+ouhUiaAQW95uB2g0cM6Hes9+Q6y9mVBxdRCZ?=
 =?us-ascii?Q?xK58yzj+FBiOkVZMR2gbr9+in9hPODWtQ0dBhnm1Lm7fgCWhJxgiGMb/E0yd?=
 =?us-ascii?Q?vl/0bdlvPovSc2XJkT5AjVqy/ElzUyTWHdBQ/SIt/OgnTBa6I1Xo9BPiiZZp?=
 =?us-ascii?Q?xrSKV/69qAd3APhwRKe45Ln427VyZQdKjCkeB4D3KPnfHAjH3BwMo7p66Gi5?=
 =?us-ascii?Q?3oo9LIGDq4vV8lExqUJeBLJqwpQWTVS5MHSCmSmTAAwZsLy/azKZgC3W7DZH?=
 =?us-ascii?Q?vt4UFWAIddOTLVhw/OSiv7Lexe490Oidyjwav6rXZCAL7cxN+ouqN/DH7/k6?=
 =?us-ascii?Q?0e9grQ5eGSFTn015XAMgbcfsslL4zt37oBZBoyBlvx4pUXESePguHEviN8sk?=
 =?us-ascii?Q?NXD/bI8kTNqXr2UdgjsseW3NNJy7bXEQJ+0DDUjsQVvYYAyrhiS4kmit28yH?=
 =?us-ascii?Q?PiQ2vb3QvavT6piC2C3G0FGbyHVvzGruNs0DoU5/lbsdR8Q/R2jv+9WwFn2D?=
 =?us-ascii?Q?pceh7Q6hHdkEbjJq0zhQ6kOS+8Y7y1dKWoZ4RTNdXD1eCS7CdAAxxCnf5HoE?=
 =?us-ascii?Q?MARpYMryc/XVCw9gvth6mBl+QibM9KSeB525taaJ1/roIS52vKd9l6GZX/xp?=
 =?us-ascii?Q?ozGjG16b24RAe56IQmpfVa7HJLzCfKUx+5/9LmNN0s8B7qbill5vrn1j78sl?=
 =?us-ascii?Q?ofieThNoM3g+0Flnw9D++HEADVE38QnPS3eDCMK6sbMuuRfnqtAsSHq3fKUe?=
 =?us-ascii?Q?iM4vgnHpc4uUnetkL1RtbUklvjtRCHyLqJio1Tk0DpqmV8tDUnyq9CZIqq5C?=
 =?us-ascii?Q?1oLMpCtEIUSYnFt3/kpw3ynalBewpq2bPVLCqTeEfZlB0aXze3Bw8FOCaBAA?=
 =?us-ascii?Q?bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c3a2990-47b1-477d-f87f-08da6fbdbf7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2022 10:49:57.8108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ZXhLoqpJV65L2IkCgaFjo5REGwby7coHNUwvtJ+AX4CSa5lAAjxbj+52Ub/NMIb4wkQsDFqMUlSKzWturVXK8R9G2AYAk2kcaHE4s7NesU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3368
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Sent: Tuesday, July 26, 2022 3:10 PM
> To: Koikkara Reeny, Shibin <shibin.koikkara.reeny@intel.com>
> Cc: bpf@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net;
> netdev@vger.kernel.org; Karlsson, Magnus <magnus.karlsson@intel.com>;
> bjorn@kernel.org; kuba@kernel.org; andrii@kernel.org; Loftus, Ciara
> <ciara.loftus@intel.com>
> Subject: Re: [PATCH bpf-next] selftests: xsk: Update poll test cases
>=20
> On Tue, Jul 26, 2022 at 10:43:36AM +0100, Koikkara Reeny, Shibin wrote:
> > > -----Original Message-----
> > > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Sent: Friday, July 22, 2022 3:16 PM
> > > To: Koikkara Reeny, Shibin <shibin.koikkara.reeny@intel.com>
> > > Cc: bpf@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net;
> > > netdev@vger.kernel.org; Karlsson, Magnus
> > > <magnus.karlsson@intel.com>; bjorn@kernel.org; kuba@kernel.org;
> > > andrii@kernel.org; Loftus, Ciara <ciara.loftus@intel.com>
> > > Subject: Re: [PATCH bpf-next] selftests: xsk: Update poll test cases
> > >
> > > On Mon, Jul 18, 2022 at 09:57:12AM +0000, Shibin Koikkara Reeny wrote=
:
> > > > Poll test case was not testing all the functionality of the poll
> > > > feature in the testsuite. This patch update the poll test case
> > > > with 2 more testcases to check the timeout features.
> > > >
> > > > Poll test case have 4 sub test cases:
> > >
> > > Hi Shibin,
> > >
> > > Kinda not clear with count of added test cases, at first you say you
> > > add 2 more but then you mention something about 4 sub test cases.
> > >
> > > To me these are separate test cases.
> > >
> > Hi Maciej,
> >
> > Will update it in V2
> >
> > > >
> > > > 1. TEST_TYPE_RX_POLL:
> > > > Check if POLLIN function work as expect.
> > > >
> > > > 2. TEST_TYPE_TX_POLL:
> > > > Check if POLLOUT function work as expect.
> > >
> > > From run_pkt_test, I don't see any difference between 1 and 2. Why
> > > split then?
> > >
> >
> >
> > It was done to show which case exactly broke. If RX poll event or TX
> > poll event
> >
> > > >
> > > > 3. TEST_TYPE_POLL_RXQ_EMPTY:
> > >
> > > 3 and 4 don't match with the code here
> > > (TEST_TYPE_POLL_{R,T}XQ_TMOUT)
> > >
> > > > call poll function with parameter POLLIN on empty rx queue will
> > > > cause timeout.If return timeout then test case is pass.
> > > >
> >
> >
> > True but  It was change to RXQ_EMPTY and TXQ_FULL from _TMOUT to
> make
> > it more clearer to what exactly is happening to cause timeout.
> >
> > > > 4. TEST_TYPE_POLL_TXQ_FULL:
> > > > When txq is filled and packets are not cleaned by the kernel then
> > > > if we invoke the poll function with POLLOUT then it should trigger
> > > > timeout.If return timeout then test case is pass.
> > > >
> > > > Signed-off-by: Shibin Koikkara Reeny
> > > > <shibin.koikkara.reeny@intel.com>
> > > > ---
> > > >  tools/testing/selftests/bpf/xskxceiver.c | 173
> > > > +++++++++++++++++------  tools/testing/selftests/bpf/xskxceiver.h
> > > > +++++++++++++++++|
> > > > 10 +-
> > > >  2 files changed, 139 insertions(+), 44 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/xskxceiver.c
> > > > b/tools/testing/selftests/bpf/xskxceiver.c
> > > > index 74d56d971baf..8ecab3a47c9e 100644
> > > > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > > > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > > > @@ -424,6 +424,8 @@ static void __test_spec_init(struct test_spec
> > > > *test, struct ifobject *ifobj_tx,
> > > >
> > > >  		ifobj->xsk =3D &ifobj->xsk_arr[0];
> > > >  		ifobj->use_poll =3D false;
> > > > +		ifobj->skip_rx =3D false;
> > > > +		ifobj->skip_tx =3D false;
> > >
> > > Any chances of trying to avoid these booleans? Not that it's a hard
> > > nack, but the less booleans we spread around in this code the better.
> >
> >
> > Not sure if it is possible but using any other logic will make the
> > code more complex and less readable.
>=20
> How did you come with such judgement? You didn't even try the idea that I
> gave to you about having a testapp_validate_traffic() equivalent with a s=
ingle
> thread.
>=20

Hi Maciej,

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selft=
ests/bpf/xskxceiver.c
index 4394788829bf..0b58e026f2a2 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1317,6 +1317,24 @@ static void *worker_testapp_validate_rx(void *arg)
        pthread_exit(NULL);
 }

+static int testapp_validate_traffic_txq_tmout(struct test_spec *test)
+{
+       struct ifobject *ifobj_tx =3D test->ifobj_tx;
+       pthread_t t0;
+
+       if (pthread_barrier_init(&barr, NULL, 2))
+               exit_with_error(errno);
+
+       test->current_step++;
+       pkt_stream_reset(ifobj_rx->pkt_stream);
+
+       pthread_create(&t0, NULL, ifobj_tx->func_ptr, test);
+       pthread_join(t0, NULL);
+
+       return !!test->fail;
+}
+

This is what you are suggesting do ?

My point is ifobj_tx->func_ptr calls worker_testapp_validate_tx() =3D=3D> s=
end_pkts() =3D=3D> __send_pkts().

Normal case when poll timeout happen send_pkts() return TEST_FAILURE which =
is expected.
Test Case like TEST_TYPE_POLL_TXQ_TMOUT and TEST_TYPE_POLL_RXQ_TMOUT when p=
oll timeout happen
it should return TEST_PASS rather than TEST_FAILURE. How should I let the s=
end_pkts()
to know what timeout type of test is running without a new variable or flag=
?=20
Then boolean skip_rx and skip_tx are both used in the send_pkts() and recei=
ve_pkts().

This is why I thought it might be complex but if you have new suggestion I =
open to try it.

> >
> > >
> > > >  		ifobj->use_fill_ring =3D true;
> > > >  		ifobj->release_rx =3D true;
> > > >  		ifobj->pkt_stream =3D test->pkt_stream_default; @@ -589,6
> > > +591,19 @@
> > > > static struct pkt_stream *pkt_stream_clone(struct xsk_umem_info
> > > *umem,
> > > >  	return pkt_stream_generate(umem, pkt_stream->nb_pkts,
> > > > pkt_stream->pkts[0].len);  }
> > > >
> > > > +static void pkt_stream_invalid(struct test_spec *test, u32
> > > > +nb_pkts,
> > > > +u32 pkt_len) {
> > > > +	struct pkt_stream *pkt_stream;
> > > > +	u32 i;
> > > > +
> > > > +	pkt_stream =3D pkt_stream_generate(test->ifobj_tx->umem,
> > > nb_pkts, pkt_len);
> > > > +	for (i =3D 0; i < nb_pkts; i++)
> > > > +		pkt_stream->pkts[i].valid =3D false;
> > > > +
> > > > +	test->ifobj_tx->pkt_stream =3D pkt_stream;
> > > > +	test->ifobj_rx->pkt_stream =3D pkt_stream; }
> > >
> > > Please explain how this work, e.g. why you need to have to have
> > > invalid pkt stream + avoiding launching rx thread and why one of them=
 is
> not enough.
> > >
> > > Personally I think this is not needed. When calling
> > > pkt_stream_generate(), validity of pkt is set based on length of pack=
et vs
> frame size:
> > >
> > > 		if (pkt_len > umem->frame_size)
> > > 			pkt_stream->pkts[i].valid =3D false;
> > >
> > > so couldn't you use 2k frame size and bigger length of a packet?
> > >
> > This function was introduced for TEST_TYPE_POLL_TXQ_FULL keep the TX
> > full and stop nofying the kernel that there is packet to cleanup.
> > So we are manually setting the packets to invalid. This help to keep
> > the __send_pkts() more generic and reduce the if conditions.
> > ex: xsk_ring_prod__submit() is not needed to be added inside if conditi=
on.
>=20
> I understand the intend behind it but what I was saying was that you have
> everything ready to be used without a need for introducing new functions.
> You could also try out what I suggested just to see if this makes things
> simpler.
>=20

Are you suggesting to do this ?
                test->ifobj_tx->use_poll =3D true;
-               pkt_stream_invalid(test, 2 * DEFAULT_PKT_CNT, PKT_SIZE);
+               test->ifobj_tx->umem->frame_size =3D 2048;
+               pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
                testapp_validate_traffic(test);


> >
> > You are right we don't need rx stream but thought it will be good to
> > keep as can be used for other features in future and will be more gener=
ic.
>=20
> If there are other features that would utilize this then let's introduce =
this
> then ;)
>=20

Got it.

> >
> > > > +
> > > >  static void pkt_stream_replace(struct test_spec *test, u32
> > > > nb_pkts,
> > > > u32 pkt_len)  {
> > > >  	struct pkt_stream *pkt_stream;
> > > > @@ -817,9 +832,9 @@ static int complete_pkts(struct
> > > > xsk_socket_info
> > > *xsk, int batch_size)
> > > >  	return TEST_PASS;
> > > >  }
> > > >
> > > > -static int receive_pkts(struct ifobject *ifobj, struct pollfd
> > > > *fds)
> > > > +static int receive_pkts(struct ifobject *ifobj, struct pollfd
> > > > +*fds, bool skip_tx)
> > > >  {
> > > > -	struct timeval tv_end, tv_now, tv_timeout =3D {RECV_TMOUT, 0};
> > > > +	struct timeval tv_end, tv_now, tv_timeout =3D {THREAD_TMOUT, 0};
> > > >  	u32 idx_rx =3D 0, idx_fq =3D 0, rcvd, i, pkts_sent =3D 0;
> > > >  	struct pkt_stream *pkt_stream =3D ifobj->pkt_stream;
> > > >  	struct xsk_socket_info *xsk =3D ifobj->xsk; @@ -843,17 +858,28 @@
> > > > static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> > > >  		}
> > > >
> > > >  		kick_rx(xsk);
> > > > +		if (ifobj->use_poll) {
> > > > +			ret =3D poll(fds, 1, POLL_TMOUT);
> > > > +			if (ret < 0)
> > > > +				exit_with_error(-ret);
> > > > +
> > > > +			if (!ret) {
> > > > +				if (skip_tx)
> > > > +					return TEST_PASS;
> > > > +
> > > > +				ksft_print_msg("ERROR: [%s] Poll timed
> > > out\n", __func__);
> > > > +				return TEST_FAILURE;
> > > >
> > > > -		rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
> > > &idx_rx);
> > > > -		if (!rcvd) {
> > > > -			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
> > >
> > > So now we don't check if fq needs to be woken up in non-poll case?
> > > I believe this is still needed so we get to the driver and pick fq
> > > entries. Prove me wrong of course if I'm missing something.
> >
> > xsk_ring_prod__needs_wakeup() =3D=3D>  *r->flags &
> XDP_RING_NEED_WAKEUP;
> > This function only check if the flag is set or not and it is not
> > updating or triggering anything. In the original case if flag is set
> > then trigger the poll event and continue.
> > In this patch poll event is called in any case if it enter the if (!rcv=
d)  is true..
> > We don't check if XDP_RING_NEED_WAKEUP is set or not.
> >
> >
> > >
> > > > -				ret =3D poll(fds, 1, POLL_TMOUT);
> > > > -				if (ret < 0)
> > > > -					exit_with_error(-ret);
> > > >  			}
> > > > -			continue;
> > > > +
> > > > +			if (!(fds->revents & POLLIN))
> > > > +				continue;
> > > >  		}
> > > >
> > > > +		rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
> > > &idx_rx);
> > > > +		if (!rcvd)
> > > > +			continue;
> > > > +
> > > >  		if (ifobj->use_fill_ring) {
> > > >  			ret =3D xsk_ring_prod__reserve(&umem->fq, rcvd,
> > > &idx_fq);
> > > >  			while (ret !=3D rcvd) {
> > > > @@ -863,6 +889,7 @@ static int receive_pkts(struct ifobject
> > > > *ifobj, struct
> > > pollfd *fds)
> > > >  					ret =3D poll(fds, 1, POLL_TMOUT);
> > > >  					if (ret < 0)
> > > >  						exit_with_error(-ret);
> > > > +					continue;
> > >
> > > Why continue here?
> >
> > You are right it is not needed. Will update in V2 patch. Thanks.
> >
> > >
> > > >  				}
> > > >  				ret =3D xsk_ring_prod__reserve(&umem->fq,
> > > rcvd, &idx_fq);
> > > >  			}
> > > > @@ -900,13 +927,34 @@ static int receive_pkts(struct ifobject
> > > > *ifobj, struct
> > > pollfd *fds)
> > > >  	return TEST_PASS;
> > > >  }
> > > >
> > > > -static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
> > > > +static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb,
> > > > +bool
> > > use_poll,
> > > > +		       struct pollfd *fds, bool timeout)
> > > >  {
> > > >  	struct xsk_socket_info *xsk =3D ifobject->xsk;
> > > > -	u32 i, idx, valid_pkts =3D 0;
> > > > +	u32 i, idx, ret, valid_pkts =3D 0;
> > > > +
> > > > +	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) <
> > > BATCH_SIZE) {
> > > > +		if (use_poll) {
> > > > +			ret =3D poll(fds, 1, POLL_TMOUT);
> > > > +			if (timeout) {
> > > > +				if (ret < 0) {
> > > > +					ksft_print_msg("DEBUG: [%s] Poll
> > > error %d\n",
> > > > +						       __func__, ret);
> > > > +					return TEST_FAILURE;
> > > > +				}
> > > > +				if (ret =3D=3D 0)
> > > > +					return TEST_PASS;
> > > > +				break;
> > > > +			}
> > > > +			if (ret <=3D 0) {
> > > > +				ksft_print_msg("DEBUG: [%s] Poll error
> > > %d\n",
> > > > +					       __func__, ret);
> > > > +				return TEST_FAILURE;
> > > > +			}
> > > > +		}
> > > >
> > > > -	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) <
> > > BATCH_SIZE)
> > > >  		complete_pkts(xsk, BATCH_SIZE);
> > > > +	}
> > > >
> > > >  	for (i =3D 0; i < BATCH_SIZE; i++) {
> > > >  		struct xdp_desc *tx_desc =3D xsk_ring_prod__tx_desc(&xsk-
> tx, idx
> > > >+  i); @@ -933,11 +981,27 @@ static int __send_pkts(struct ifobject
> > > >*ifobject, u32 *pkt_nb)
> > > >
> > > >  	xsk_ring_prod__submit(&xsk->tx, i);
> > > >  	xsk->outstanding_tx +=3D valid_pkts;
> > > > -	if (complete_pkts(xsk, i))
> > > > -		return TEST_FAILURE;
> > > >
> > > > -	usleep(10);
> > > > -	return TEST_PASS;
> > > > +	if (use_poll) {
> > > > +		ret =3D poll(fds, 1, POLL_TMOUT);
> > > > +		if (ret <=3D 0) {
> > > > +			if (ret =3D=3D 0 && timeout)
> > > > +				return TEST_PASS;
> > > > +
> > > > +			ksft_print_msg("DEBUG: [%s] Poll error %d\n",
>=20
> avoid debug prints in upstream patches

I can remove it or I can replace DEBUG as ERROR. What do you suggest?=20


>=20
> > > __func__, ret);
> > > > +			return TEST_FAILURE;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	if (!timeout) {
> > > > +		if (complete_pkts(xsk, i))
> > > > +			return TEST_FAILURE;
> > > > +
> > > > +		usleep(10);
> > > > +		return TEST_PASS;
> > > > +	}
> > > > +
> > > > +	return TEST_CONTINUE;
> > >
> > > Why do you need this?
> > >
> >
> > __send_pkts is expected to return TEST_PASS or TEST_FAIL to send_pkts
> > function and if returned TEST_PASS then continue sending pkts and exit
> when all the packet are finished.
> > if returned TEST_FAILURE then test failed and return.
> >
> > For TEST_TYPE_POLL_TXQ_TMOUT  TEST_PASS is return value when timout
> > happened and should not sent anymore packets and break. But this will
> > break other test. So needed new return type TEST_CONTINUE to keep
> sending packets.
> >
> > > >  }
> > > >
> > > >  static void wait_for_tx_completion(struct xsk_socket_info *xsk)
> > > > @@
> > > > -948,29 +1012,33 @@ static void wait_for_tx_completion(struct
> > > > xsk_socket_info *xsk)
> > > >
> > > >  static int send_pkts(struct test_spec *test, struct ifobject
> > > > *ifobject)  {
> > > > +	struct timeval tv_end, tv_now, tv_timeout =3D {THREAD_TMOUT, 0};
> > > > +	bool timeout =3D test->ifobj_rx->skip_rx;
> > > >  	struct pollfd fds =3D { };
> > > > -	u32 pkt_cnt =3D 0;
> > > > +	u32 pkt_cnt =3D 0, ret;
> > > >
> > > >  	fds.fd =3D xsk_socket__fd(ifobject->xsk->xsk);
> > > >  	fds.events =3D POLLOUT;
> > > >
> > > > -	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
> > > > -		int err;
> > > > -
> > > > -		if (ifobject->use_poll) {
> > > > -			int ret;
> > > > -
> > > > -			ret =3D poll(&fds, 1, POLL_TMOUT);
> > > > -			if (ret <=3D 0)
> > > > -				continue;
> > > > +	ret =3D gettimeofday(&tv_now, NULL);
> > > > +	if (ret)
> > > > +		exit_with_error(errno);
> > > > +	timeradd(&tv_now, &tv_timeout, &tv_end);
> > >
> > > This logic of timer on Tx side is not mentioned anywhere in the
> > > commit message. Please try your best to describe all of the changes
> > > you're proposing.
> > >
> >
> > Will update in the commit message in V2 patch.
> >
> > > Also, couldn't this be a separate patch?
> > >
> > I prefer to keep it. But if you suggest otherwise I can remove.
>=20
> I'm not talking about removing this altogether, pulling this out to separ=
ate
> patch would make this one cleaner and reviewers job easier.
>=20
Sure. I agree will update in V3 patch.

> >
> > > >
> > > > -			if (!(fds.revents & POLLOUT))
> > > > -				continue;
> > > > +	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
> > > > +		ret =3D gettimeofday(&tv_now, NULL);
> > > > +		if (ret)
> > > > +			exit_with_error(errno);
> > > > +		if (timercmp(&tv_now, &tv_end, >)) {
> > > > +			ksft_print_msg("ERROR: [%s] Send loop timed
> > > out\n", __func__);
> > > > +			return TEST_FAILURE;
> > > >  		}
> > > >
> > > > -		err =3D __send_pkts(ifobject, &pkt_cnt);
> > > > -		if (err || test->fail)
> > > > +		ret =3D __send_pkts(ifobject, &pkt_cnt, ifobject->use_poll,
> > > &fds, timeout);
> > > > +		if ((ret || test->fail) && !timeout)
> > > >  			return TEST_FAILURE;
> > > > +		else if (ret =3D=3D TEST_PASS && timeout)
> > > > +			return ret;
> > > >  	}
> > > >
> > > >  	wait_for_tx_completion(ifobject->xsk);
> > > > @@ -1235,8 +1303,7 @@ static void *worker_testapp_validate_rx(void
> > > > *arg)
> > > >
> > > >  	pthread_barrier_wait(&barr);
> > > >
> > > > -	err =3D receive_pkts(ifobject, &fds);
> > > > -
> > > > +	err =3D receive_pkts(ifobject, &fds, test->ifobj_tx->skip_tx);
> > > >  	if (!err && ifobject->validation_func)
> > > >  		err =3D ifobject->validation_func(ifobject);
> > > >  	if (err) {
> > > > @@ -1265,17 +1332,21 @@ static int testapp_validate_traffic(struct
> > > test_spec *test)
> > > >  	pkts_in_flight =3D 0;
> > > >
> > > >  	/*Spawn RX thread */
> > > > -	pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
> > > > -
> > > > -	pthread_barrier_wait(&barr);
> > > > -	if (pthread_barrier_destroy(&barr))
> > > > -		exit_with_error(errno);
> > > > +	if (!ifobj_rx->skip_rx) {
> > > > +		pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
> > > > +		pthread_barrier_wait(&barr);
> > > > +		if (pthread_barrier_destroy(&barr))
> > > > +			exit_with_error(errno);
> > > > +	}
> > > >
> > > >  	/*Spawn TX thread */
> > > > -	pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> > > > +	if (!ifobj_tx->skip_tx) {
> > > > +		pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> > > > +		pthread_join(t1, NULL);
> > > > +	}
> > > >
> > > > -	pthread_join(t1, NULL);
> > > > -	pthread_join(t0, NULL);
> > > > +	if (!ifobj_rx->skip_rx)
> > > > +		pthread_join(t0, NULL);
> > >
> > > Have you thought of a testapp_validate_traffic() variant with a
> > > single thread, either Tx or Rx? In this case probably would make
> > > everything clearer in the current pthread code. Also, wouldn't this d=
rop
> the need for skip booleans?
> > >
> >
> > My suggestion will be to reuse the existing functions. If you suggest
> > otherwise I can look into it.
>=20
> Existing function wasn't designed for single thread execution which you n=
eed
> for your poll test cases. That's why I asked you to discover if having a =
function
> designed for single threaded tests is worth the hassle.
>=20

Still I think i will need a variable to let the send and receive function t=
o see if the timeout is expect or an error.=20
I don't know if i am missing something. I am open to the suggestion.

> >
> > > >
> > > >  	return !!test->fail;
> > > >  }
> > > > @@ -1548,10 +1619,28 @@ static void run_pkt_test(struct test_spec
> > > > *test, enum test_mode mode, enum test_
> > > >
> > > >  		pkt_stream_restore_default(test);
> > > >  		break;
> > > > -	case TEST_TYPE_POLL:
> > > > +	case TEST_TYPE_RX_POLL:
> > > > +		test->ifobj_rx->use_poll =3D true;
> > > > +		test_spec_set_name(test, "POLL_RX");
> > > > +		testapp_validate_traffic(test);
> > > > +		break;
> > > > +	case TEST_TYPE_TX_POLL:
> > > >  		test->ifobj_tx->use_poll =3D true;
> > > > +		test_spec_set_name(test, "POLL_TX");
> > > > +		testapp_validate_traffic(test);
> > > > +		break;
> > > > +	case TEST_TYPE_POLL_TXQ_TMOUT:
> > > > +		test_spec_set_name(test, "POLL_TXQ_FULL");
> > > > +		test->ifobj_rx->skip_rx =3D true;
> > > > +		test->ifobj_tx->use_poll =3D true;
> > > > +		pkt_stream_invalid(test, 2 * DEFAULT_PKT_CNT, PKT_SIZE);
> > > > +		testapp_validate_traffic(test);
> > > > +		pkt_stream_restore_default(test);
> > > > +		break;
> > > > +	case TEST_TYPE_POLL_RXQ_TMOUT:
> > > > +		test_spec_set_name(test, "POLL_RXQ_EMPTY");
> > > > +		test->ifobj_tx->skip_tx =3D true;
> > > >  		test->ifobj_rx->use_poll =3D true;
> > > > -		test_spec_set_name(test, "POLL");
> > > >  		testapp_validate_traffic(test);
> > > >  		break;
> > > >  	case TEST_TYPE_ALIGNED_INV_DESC:
> > > > diff --git a/tools/testing/selftests/bpf/xskxceiver.h
> > > > b/tools/testing/selftests/bpf/xskxceiver.h
> > > > index 3d17053f98e5..0db7e0acccb2 100644
> > > > --- a/tools/testing/selftests/bpf/xskxceiver.h
> > > > +++ b/tools/testing/selftests/bpf/xskxceiver.h
> > > > @@ -27,6 +27,7 @@
> > > >
> > > >  #define TEST_PASS 0
> > > >  #define TEST_FAILURE -1
> > > > +#define TEST_CONTINUE 1
> > > >  #define MAX_INTERFACES 2
> > > >  #define MAX_INTERFACE_NAME_CHARS 7  #define
> > > > MAX_INTERFACES_NAMESPACE_CHARS 10 @@ -48,7 +49,7 @@
> > > #define
> > > > SOCK_RECONF_CTR 10  #define BATCH_SIZE 64  #define POLL_TMOUT
> > > 1000
> > > > -#define RECV_TMOUT 3
> > > > +#define THREAD_TMOUT 3
> > > >  #define DEFAULT_PKT_CNT (4 * 1024)  #define
> DEFAULT_UMEM_BUFFERS
> > > > (DEFAULT_PKT_CNT / 4)  #define
> > > UMEM_SIZE
> > > > (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE)
> @@ -
> > > 68,7 +69,10
> > > > @@ enum test_type {
> > > >  	TEST_TYPE_RUN_TO_COMPLETION,
> > > >  	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
> > > >  	TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
> > > > -	TEST_TYPE_POLL,
> > > > +	TEST_TYPE_RX_POLL,
> > > > +	TEST_TYPE_TX_POLL,
> > > > +	TEST_TYPE_POLL_RXQ_TMOUT,
> > > > +	TEST_TYPE_POLL_TXQ_TMOUT,
> > > >  	TEST_TYPE_UNALIGNED,
> > > >  	TEST_TYPE_ALIGNED_INV_DESC,
> > > >  	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
> > > > @@ -145,6 +149,8 @@ struct ifobject {
> > > >  	bool tx_on;
> > > >  	bool rx_on;
> > > >  	bool use_poll;
> > > > +	bool skip_rx;
> > > > +	bool skip_tx;
> > > >  	bool busy_poll;
> > > >  	bool use_fill_ring;
> > > >  	bool release_rx;
> > > > --
> > > > 2.34.1
> > > >
