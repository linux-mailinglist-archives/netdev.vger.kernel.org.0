Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A560B627801
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbiKNIpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiKNIpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:45:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F37A1BE98;
        Mon, 14 Nov 2022 00:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668415547; x=1699951547;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gis2LuB7GvwjWaYFjksUhrQQMFJCisWMVTr2lPunFSo=;
  b=q86FAvbSW0pYLwEKfRt3IaVr6V9oYQJmkkLew0fSL2eFkEDcwKLHgNPV
   WLO72qdwBF4qES83pLVx1hvQSQKHpvuIsJlwLaliO474Zg51SjUr30aYO
   Bhw0WmC7Umo9AVhdOQVKBOMuDePkqViUWSr10ju5CpY7kHcbHQ70JwFVU
   0KXIqvOSvpXfzwxCGuWABmtl3P/JtJr1bgWzW07R1YMaSFfi0p8fWvX1a
   PVbpDhACLiGCMFsNw2GtrLBPcsPDSBPhyAhabmydXfl/AyNW2FyLrJaj/
   cn6OxbxoLgWaMFvq6qZ4QlZ+BYo5f0F3muCRSFop4cnsKo1jTrNB4ylW0
   g==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="188906375"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Nov 2022 01:45:46 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 14 Nov 2022 01:45:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 14 Nov 2022 01:45:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B30vpP6HQl1D8GCqdTLe+awbU8J7vW1UOf1dQ5xtx0vaTRLmHv0zDgOTt7Bj13aMAjwST1Jk8N5YEQTZS06Zd/c3F96vdNfLfW4CapeMnQYGQg2upfUDqNavmn20m2BtQW8cFA41xHUdSYIKtbOgaRQkpJql7VMjEzH0gNKeTs94aNrDnHokBVhvEzxcEkwqCDu6G+9+6V06kaSxQwplGLceot/kW4QaixmSYfEBrmH2iKsO1Dhil+AmzpGb0GqhXFy9xSWuvxTH9xnD2CM8tK3Z7nCVqFuyP5LjQUTSXalpan/WckEZ2g33BBZJ0gIDBxotDmFb371GZGr4MIh4Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TnXkrFeCATUlHPdNqTWyXOLduL4oER69REjp9pOtSlo=;
 b=XBt9I7lg/su94zH79bcFmqCGnrbB9oFy/dAfkSz20X73leRR2KM67wZxJzK3c0g00aL4Ea+fEjAmBy7CkJuSABDJP+fdg5mz0KK3D4play44tm9/ivx8Qn0RvKzwkkNpUsRzuD4Yy3qWX6cIurmxtsRbRWk+KMtuPqfjW6yfaARDqBcTENjxCZ0LqzG26cBfPVkZO0t0CRE2HOd1yhtDPh8MG6xlgUBF9MxpNksHq0/HFzhACfqNkwwRlf82UrXG1EhsXKWoOYvaWdSK9oTBH7C/lyJ/mi7yP3bM038zdRQcwMQ1M0Sje3QVCxSqhpW2IQJHEGS2BAhkepGwQXITUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnXkrFeCATUlHPdNqTWyXOLduL4oER69REjp9pOtSlo=;
 b=rYNAayvsBoe9XWa/khtoylVkEY59hdWGGXKDofugHa9NYdGFqJiSmxagVnfBNHwkPytheRlgAQ9biGmRvgqESTWw2nWD38KYtj2qk35lUu7YxbZ2p53R/uI2Xzs7dRwZfp+a0g/Yp6BAMQ1ayToVj0iTm/XcIiher0q7oQBVP94=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SA2PR11MB5035.namprd11.prod.outlook.com (2603:10b6:806:116::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 08:45:42 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620%3]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 08:45:42 +0000
From:   <Daniel.Machon@microchip.com>
To:     <joe@perches.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <lkp@intel.com>
Subject: Re: [PATCH net-next] net: dcb: move getapptrust to separate function
Thread-Topic: [PATCH net-next] net: dcb: move getapptrust to separate function
Thread-Index: AQHY9OgDJPilDH1/CUmOWEpqQ4wOy644Wb6AgADxvQCAAGJMgIAEdl8A
Date:   Mon, 14 Nov 2022 08:45:42 +0000
Message-ID: <Y3ICvKvpiG+Rn+2h@DEN-LT-70577>
References: <20221110094623.3395670-1-daniel.machon@microchip.com>
 <87eduaoj8g.fsf@nvidia.com> <Y23x/PSlybLqaQIS@DEN-LT-70577>
 <180a55b046e4659609cdfeea4fd979edab17f0c9.camel@perches.com>
In-Reply-To: <180a55b046e4659609cdfeea4fd979edab17f0c9.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SA2PR11MB5035:EE_
x-ms-office365-filtering-correlation-id: cbbd28c7-e73d-49b9-8a3f-08dac61c9d35
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w24QiUHuo4Nm+SWiubffmeceAIv7mBXxI4qn0etOFQRsS0gbXxzYz5iLrLgRCf5OVeWn9LFKzstI7yzBS9Wj52fF0IIfrauDYoW+FWBv1e7QaGBuvEt0Oq9JJT3UuLRBR8FvuyT7nf+eAhUZLwE02I/iKVj+zyMRGgNsTJjRdhiVhcYAK2FKS94JkGkuPSFKLoCNQYrRadbL/x1zlXQztNQonn78dQYoUhh9nL2N55PIC5xp9aYAUHtrB5/CtYnrNIiwVNkOZSx964AV+ljRZzUafbUPRqQ7ZbY1msUgKuZHLQs+nLgo54AUXEeEir/SYrdP7zS1bj8LSKp42L4lZLJBYcUYvaB6ANnN1QAFaslH1TlRmX0goXe7AI9mp5rbKlBDqnuFT8fsk82C5fVINxFoffwgHBtSyxZHN2M+XJZspSBTNyBGzcEI/OLgRexaiSmvuwmazFYKf4t8rw8EPZ2uFxxZQLh2mWXXlTmj2ccGvPfyLO+X/xM7fdCWKEtpPtk0ZguwG5TbsUp3+CBV5huf3haYqd+QygLqppj1nKDaNLXULhopacbL9uqfKzIvyeWw3eNtFH/iO9BthPtHuQm5YHArwYVkeou2P9+6qZOHRyMmFIei1MCMdJh97BgMBP+WPg74zSpP318H9puya+z40+EPe2/RZZLmAkF+nFPRnsTT3p6oz9JIQcVaU5yAWBMBs0JGovQWgBq59LFn1+2+SlUnDy6KhXJb2q2RfYRBUFBfTA05rv9nz2O6IGhqNdUfbhBIxVoPtXiiI13auw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199015)(38070700005)(2906002)(9686003)(478600001)(26005)(71200400001)(6512007)(6506007)(6486002)(54906003)(316002)(86362001)(186003)(6916009)(91956017)(33716001)(122000001)(66446008)(66946007)(76116006)(66556008)(66476007)(64756008)(4326008)(41300700001)(8676002)(83380400001)(8936002)(7416002)(5660300002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6HFSQyqy7THsw1BZLUxxSC1hq3M79AL/JkdpWNqaFU2VlC75AbSIhnKTkWVH?=
 =?us-ascii?Q?RNyY6k9HwO3w9hUa0Jh+vXiMr61QilmZeT0XuMeRVLwbtRxeQzlANHimNgG0?=
 =?us-ascii?Q?mW9DHWSof8YiuPPDvdWa5G7ji9bKbqyUOUCQPdOaZkSSe9xIf20uxxxElcSO?=
 =?us-ascii?Q?WrV6a6rZLWIzWhS4cuWjBKIuP/8ayTbJwkl1czr+dvEXgldCyRdPZPsXDxvo?=
 =?us-ascii?Q?b3116B06M0d47XWk5lFyBe0T8SMsn3ckoAgH+VqWZmmMbgBIiH/WjiemDrs6?=
 =?us-ascii?Q?fSTvO0LJuE2Vde7/dgAd6W5hg+PP3jswQtro9mqO+OYi5//32BSYY0PbTiUB?=
 =?us-ascii?Q?DsR+CHDVxs/z9VNgrEg+NFjmvlR+BhQC6QGcDeQKP/V2nNUHoqIlP88Uj290?=
 =?us-ascii?Q?2z8ipbTba/Nbz7t6gKwcRl796jY9JfHk8dILRBqXxZ9qmboEgxnoUUsyxQYe?=
 =?us-ascii?Q?jqUtxlG92AnsLJA8Gjutl7HFcit6KTE4AJ/Qp5koU4vYclka1163v3kYBSVf?=
 =?us-ascii?Q?Vp/nqTU3fefFAomitL8Pl7h743a22v9DhTelKs/YZGQuTebDAxGkzdq8MRgX?=
 =?us-ascii?Q?//aQWvQRI0mPLnwe7vTHT5dFWOXmrs5JQtJ2IdiijUl9WPRuBuO+Y/NFyyV7?=
 =?us-ascii?Q?pwAYdjsvjwqzZ4FIUeMLf7X2vI30CKlvf/0Phgi65ZTxOuqwa2FMsJSdG764?=
 =?us-ascii?Q?e3Wuiyxc1yoH/3Ro4t0028kn+B5PplLapJ2WSFAFMrzRmMCND8Cl1Chxxrhz?=
 =?us-ascii?Q?eVdRmSE3YCs0YZjSSzIOsOGXAQb65cvJIiYhmCAp4Wtf6j9sASQXbnOOb1ss?=
 =?us-ascii?Q?k1om68msHO1D7DIqVWDF6ozGYH6TAeFnvJJZFcSPRphj4keC25JJu0DDl+9N?=
 =?us-ascii?Q?5tBj/GVNQUAKgod4ej9CyqthqL8PlfxglA/m2Sozm8MvvQ1u1/pppB3lJmap?=
 =?us-ascii?Q?ZkD1fJvSm+ypsErALtvw3rPxfmOFoWWHD7f82rLcKmTbukvHpV2tyVsOxIH3?=
 =?us-ascii?Q?xkbV1PLORbZkS05c69FWteiheA4MhH3Zs5Gx21/JYNtW3wdpDNd1BGHTVXZV?=
 =?us-ascii?Q?usJ9yS+fLbTA607YlYnAIFNMIYN02uuc+6FgvtK1boUqFdxXsqM2u0MQXYzO?=
 =?us-ascii?Q?Z0eTptWxs6W+WKAwnEQ0wc+fwn9oIq2oyL5AMnnaCzzFBEf7OfaSqpTi6EvB?=
 =?us-ascii?Q?I/yBzdMxgH3Wdrzl3i2o4usGmSH6cs0Ey82nDwoATm3UWksk21imkV2YmuHK?=
 =?us-ascii?Q?DoWuuC3kXASyMnqxR3usAe72dRC7LT6ODUigluKDMuB6NHNqejGGvAE4XCpC?=
 =?us-ascii?Q?uBIheJo0OsZNhAq2zHoFac5JJnSicOtjeS17K2jLAwAESxa3Nk3ONoBB+iYh?=
 =?us-ascii?Q?bVeBfY5ZWTQ13310S50+NfAgYyP7hHLdXJGOEMB/MYwcf7OuF9gSUOXjEjQp?=
 =?us-ascii?Q?TkpEvXbT20sCO2HEWFrnvtTBN9gr/ce1N5qOJBD1eBFDnxVfgi0nWixpUhC1?=
 =?us-ascii?Q?axtQYnv22K9NtcDn2vPbVtExHqg9uqKcuwoEYngt9rFABzg69jjZy6/5f0zx?=
 =?us-ascii?Q?IWzsCxoRulZ5KWcYSnV2X+mtfv3ujXOs/OzCgkYFU+/dXfxDvcu692mNQ4MU?=
 =?us-ascii?Q?cQuZmvtT+yqoputwFG+JEYg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0AA2D481330DA64694691D0662968A57@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbbd28c7-e73d-49b9-8a3f-08dac61c9d35
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 08:45:42.4949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3RQJlyWp2VX/eh1toiiWi+JqXWYRMnJGkBL+DXodRpBvAuHMUwne58kxzJDQJJd2mXcOPDDgSLJe9tHI5fbpLBCrh1AqFdqPFwX4F0j6PY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5035
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > +
> > > > +             err =3D -EMSGSIZE;
> > > > +
> > > > +             apptrust =3D nla_nest_start(skb, DCB_ATTR_DCB_APP_TRU=
ST_TABLE);
> > > > +             if (!apptrust)
> > > > +                     goto nla_put_failure;
> > > > +
> > > > +             for (i =3D 0; i < nselectors; i++) {
> > > > +                     enum ieee_attrs_app type =3D
> > > > +                             dcbnl_app_attr_type_get(selectors[i])=
;
> > >
> > > Doesn't checkpatch warn about this? There should be a blank line afte=
r
> > > the variable declaration block. (Even if there wasn't one there in th=
e
> > > original code either.)
> >
> > Nope, no warning. And I think it has something to do with the way the l=
ine
> > is split.
>=20
> yup.
>=20
> And style trivia:
>=20
> I suggest adding error types after specific errors,
> reversing the test and unindenting the code too.
>=20
> Something like:
>=20
>         err =3D ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
>         if (err) {
>                 err =3D 0;
>                 goto out;
>         }
>=20
>         apptrust =3D nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
>         if (!apptrust) {
>                 err =3D -EMSGSIZE;
>                 goto out;
>         }
>=20
>         for (i =3D 0; i < nselectors; i++) {
>                 enum ieee_attrs_app type =3D dcbnl_app_attr_type_get(sele=
ctors[i]);
>                 err =3D nla_put_u8(skb, type, selectors[i]);
>                 if (err) {
>                         nla_nest_cancel(skb, apptrust);
>                         goto out;
>                 }
>         }
>         nla_nest_end(skb, apptrust);
>=20
>         err =3D 0;
>=20
> out:
>         kfree(selectors);
>         return err;
> }
>

LGTM.

The last err =3D 0 can even be removed, as I see it.
Will submit a new version with the changes suggested.

/ Daniel
