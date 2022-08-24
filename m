Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541E25A044E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiHXWxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbiHXWxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:53:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662FD74CE0
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661381627; x=1692917627;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KriLL163KCs20zDh4xi6on+caDIII8xaIcBFUQQRCTo=;
  b=l6QxNMsg3CG7sILuJVxz1Rcm34bUg0aUp5TRt8ewnGGjTrC0Hyqfu2nr
   S19exvzx5DTKXX9fXIKqFJnPltrGm/ICcmH5/FUIiylZ/z6BQsq/jMIGi
   1yAmiuwwhH2YJIgoIuIo/sEeioqLDVY2b53/yRP+Du9ry9RTU6TTKc9o5
   nYfu6it1Q+quiclEc+IlbRidoZoDJHrj76KW9Uc3YAvFiKSvfLvmoyvUD
   lYUD2dmFU/ZpJIeXo+Gh6kQzbPXUIGVHx7ylSttpSDmDG+9a9gXK7+sV9
   Y+c+XxMl/ZBXn28ewc9PLKcTocQRvg6iVlrCEE8Q4S7Xs0wtGBF3/Hb3G
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="294875568"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="294875568"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 15:53:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="855430758"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 24 Aug 2022 15:53:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 15:53:46 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 15:53:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 15:53:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 15:53:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLKKUZFp29CSVFLq8D9HXu2dmnKGCP4Zms0TcXWJStGUrCr4cNVhKaLxzeV/6VtO0W6c65XHQX1ccRMFG7it8hb5a/Vf/MBBkPjDyb+70qioB16Q9gTjiyvtrBlCu1jwtjXF+KmvA0mju2YXBT0xU1112pi7YLX5V2fxZqAL4PiZFiXsEhU5+hkRWzx3Kc6SdeSKTRtZuAveBS+Mc4u85CPl7q8ckP+H/iQyQ9j0fK0+H5PM6T+4SabLoUXwjfQEyunMu10+IfF90daNnwbOmc3qASjofA979O0aEfplUexhS/MWCAhiElli7M0pYkkhHYt2QNsR6tRNwyzxWoX3Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KriLL163KCs20zDh4xi6on+caDIII8xaIcBFUQQRCTo=;
 b=Ms9BKNwB8ShcQGyktxSHcWrzmaJXkZmZ1JkOvoqyC+VR/qBaJ4RxnwhhKq1lA/+3ATyAfBljHiSP5YAY1DFBIyNNJio65wG1cgxgRjtOSFKsxnTx1eWelo93lP4qSs+d58nNF3FCW/6ws3R/S0AaIVu/OAmrlGs/1h6hRBgIgfIKBMeG2KMw6FwNiGLBQO2pTJ7DWnP2mbuGPiGI60l8Bh1g3O7uOZDWmVz3ni7Ai49t1R39dKQ1QJ+j1bd8r9MQR9BJ9DwbVkl4tD1YQ98dgULTXCo5lNfDGNisCrSmQ1X3NGrRklhGjkl05aldx2nntm/CcRAa1oMxjn+4kGlW+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5370.namprd11.prod.outlook.com (2603:10b6:408:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Wed, 24 Aug
 2022 22:53:44 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 22:53:44 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Greenwalt, Paul" <paul.greenwalt@intel.com>
Subject: RE: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC
 disabled via ETHTOOL_SFECPARAM
Thread-Topic: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC
 disabled via ETHTOOL_SFECPARAM
Thread-Index: AQHYtwG/f8zW/T1x2kmfvh0Pne5Gi629DlOAgAGC4zCAABe+gIAAAZYw
Date:   Wed, 24 Aug 2022 22:53:44 +0000
Message-ID: <CO1PR11MB5089262FADDECF5AA21DBFCAD6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <20220823150438.3613327-3-jacob.e.keller@intel.com>
        <20220823151745.3b6b67cb@kernel.org>
        <CO1PR11MB508971C03652EF412A43DD80D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220824154727.450ff9d9@kernel.org>
In-Reply-To: <20220824154727.450ff9d9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55189bec-e6a0-466f-16f2-08da86237f1c
x-ms-traffictypediagnostic: BN9PR11MB5370:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YIBxr3VbLWH7M0fL1X4KN/Iam8Y2BOIWgXEWDDKHskmAdLl1vYKz8qnkFsFXljTkOidPQ9NqGOLlVoHbyK5HWk3fjZXgR6LbzmdFQqfBtTLiKEMEQNQyytFiMV0zLXIrnMamTfqw5Aoy8n3nUJqqRgUMLEO3LvDI4ENXqS2C+8MnolPWp4V1fyxCFHfFwQPwo0vn5ivh/yC76nlFVWfJfTWh1or1XFSdptXgN75X80bUNQ4RxtgWmg6WQu6XSDjhPbeLb4fmy+X1ACtklBJXrv3FO/JI6+jii0+rX63Zo4j2MsExgKg+W3ugNsuCe9oLbi9wl6zfeyV8h7XOli/QUa+KSX+Dnc0+zr96bLQpe55yqiEk/Do5Lffbh8WFXrG4wB4hLO3pgK9utzWoTIwqCS1P7xcCdQlMJx4w0E9f6FSiY4e0F8myM6Jd2XhNdHzEV9B9sY7en/hxLh1iSclrVL2AvQ/tmux0W0Ct/GMYRjJQXSA4cjyWq8btSU9KvHHBY7Sol+mkJqs3hUw1K9hY+86kqrf1ZGM2xNhklbzieLjlvX8AGcvdc1Q4kMWEsADPXVryaGDJvuNWthbVM++NDHPWhGEWLWNNHIrtq2gFQqq2//LTa71D+wZEwaOW93y4X/fDHxuGYALw8IJGoMjqzULRZTc+H+Ktri2zYlPRvUjO+rt+S1UNxD+/L7mCNolj7wkOLD8O1I3apLeWiZ1sAH2hHnQQWrOXaAA0MzE2gvK0GfcULfhB7xcQ/wj/efuqKW8x8VtA2s76ypI+zG4ROA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(39860400002)(396003)(346002)(366004)(66446008)(2906002)(4326008)(66556008)(66476007)(55016003)(76116006)(64756008)(66946007)(6506007)(107886003)(33656002)(71200400001)(7696005)(54906003)(316002)(478600001)(41300700001)(26005)(53546011)(6916009)(5660300002)(9686003)(38100700002)(86362001)(82960400001)(38070700005)(186003)(122000001)(8676002)(4744005)(8936002)(83380400001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pRkufPq/m39Kr8lLSQ1bwK3zsb9TPhilF0ojvAqAZaP/q83i4ItdygtcWJLs?=
 =?us-ascii?Q?9ZgM7EF0/T7EnrcGDdR4sE/nZSqERLWlITQZIFMUJ/s6NznnOuxJndeKSJN7?=
 =?us-ascii?Q?aBHQr98Sd0ss26jAQaBE9Ew3zZ9FW2HE0WhpaQAglqbTn6U9tkDIpPX6hmvQ?=
 =?us-ascii?Q?aBLdyq+U5r0xDawcMH1tx4oIQh7BW7F5jTqvgpsfEaf7dMd8lzEM3jRM5ItL?=
 =?us-ascii?Q?1o7SieFYhMfuSzTnCdhD1H3mM/H2q0yMunbnUs+zylwFxmvUx94GFvs3h7AC?=
 =?us-ascii?Q?zJqC0ydexs1O7K8T1zTPr9wwgh5YAWEy/gYbZX0MSuFbPyXRzYFb0ZaxhC+j?=
 =?us-ascii?Q?pANO+dS7Inqwnec5mDLlBa9ZCscapZ/2G9kNXXXoH090rngCXIbVtYPCa4Cd?=
 =?us-ascii?Q?itlgfL8Af3K0F1e/PLQSB1z0XqU9K3P67aCixlzeEpHIq3aAeNSW2wtHMCB9?=
 =?us-ascii?Q?Pm0hGzyCBPheF1X+bnwLgk5CihhlSk2uV/q8vkDuMOLHDmQgxJfczRGROVpc?=
 =?us-ascii?Q?aMrBbHGOIuxkjjabzvoyZv3ozpvCGDq1KpsRxcpM5TQW0RniiBK+pWl3HaK1?=
 =?us-ascii?Q?55KUjTW1jpWG8b0ggOF3Zqjp+ko63IEs6b6GRZLH7vgf6SbMJmZWPx4snBL3?=
 =?us-ascii?Q?rXVUfKslruewHRl7S+ms9xzUTxpKvnFCW2/XYttCGg3pRb0/sLGZysl5gQSu?=
 =?us-ascii?Q?FKZJkvoj0VAoR07/e3Xub5RdmiCLzHoaTxne+mBWJ27R4A9iuhWSBEGRWHTe?=
 =?us-ascii?Q?7FtjKgZmRW33lJQkBrH3RbGnWHntyKmrqhFQGQWJR/WPcl9/1819/ER02Dxi?=
 =?us-ascii?Q?eu8aHlheZz1llO7MJ34UaKa1+/lsmXXm3t4UZHXaZoxSgEHicEC2rZe351tJ?=
 =?us-ascii?Q?XdISVhjzybbxU7cVwUlD5KYMq9k2pSvD1r3MjJvzOlEPIY4ueFCSjsBrw0+J?=
 =?us-ascii?Q?R8BuZ/SY5x9kPN4nuDUIZEnM2jkNuMFr4g89i0W2i9jGoQf8b4lUXSks/z6f?=
 =?us-ascii?Q?/z4kgIxBQxGluSyZvtSVbjUr9FJFTthcn3Gr5dItRx1ZSezpCUfqBScihJll?=
 =?us-ascii?Q?RVnYetWRQjthVpNjpDevjGtmxuO7I/pEfimAN6rO7brYZ8grjZgeSffYY4+U?=
 =?us-ascii?Q?f8zFC+GbRlavKMaGqiTQyfF4bhRJk1d+FHSeLXA03tcYqUAMxoBr/LPa9+dj?=
 =?us-ascii?Q?n62M0+T73VzUsXI9miDX2yhLMLqM9Q8KsR/1cRUGed/BaEP1OOLoghY4qypB?=
 =?us-ascii?Q?/MDYgXE1JqpJ72pqtLQyMwkwQXU5BsgxAKA4EJioH5WbsaAfJXLVjBHdqblL?=
 =?us-ascii?Q?71ZjXNNf0Jmmf0jOgsOQSRjSEtAek4Wn7DLQrWhYOoNarTxgGhRaxye2dUcy?=
 =?us-ascii?Q?3VsxFFbiF6SF1ZjS6SEH57LRbnssx5y0Aswd8iKLZsVAIkyTD3nMWFdF4LTB?=
 =?us-ascii?Q?/eH4b21t44PX/oG7ybySK+XSZW81IisQxy54Yz0DUmq+ttnzXPA0aYax9fgY?=
 =?us-ascii?Q?BWJPKryT1Mzsnlp5W99RHKqi/6Icc4GRoVxjLWTHzqw/Mjo0wTtdqCJ1a74a?=
 =?us-ascii?Q?mqWDNDhL3t1Hr5RBgf7LbAcAgxTJp70uwlcT1/zk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55189bec-e6a0-466f-16f2-08da86237f1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 22:53:44.0245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PL3UEZHJNXyuMSfCvcb297xRKUYJalvXXWVG/kqs0ehfFCGQAYbMXdWOPNZRrzY4rfFtBE53MnN947wu6fZiogyFBBNdtfOC9SmIGp3/5bE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5370
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, August 24, 2022 3:47 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Greenwalt, Paul <paul.greenwalt@intel.com>
> Subject: Re: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC =
disabled
> via ETHTOOL_SFECPARAM
>=20
> On Wed, 24 Aug 2022 21:29:31 +0000 Keller, Jacob E wrote:
> > Ok I got information from the other folks here. LESM is not a
> > standard its just the name we used internally for how the firmware
> > establishes link. I'll rephrase this whole section and clarify it.
>=20
> Hold up, I'm pretty sure this is in the standard.

According to the folks I talked to what we have here, we didn't understand =
this as being from a standard, but if it is I'd love to read on it.

Thanks,
Jake
