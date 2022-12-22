Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B126548BC
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 23:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiLVW50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 17:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiLVW5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 17:57:24 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA621E734
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 14:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671749843; x=1703285843;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mjbccSgm59tXWX5uhHEFHyBTU1jZEPpgEINu7/Jx140=;
  b=GWZOT7eW6v+x/MuqSGno1Wlt/dOTxK9Oeys/qyfqvr1mdJb33j0yfizD
   oI893LKHTPwY8RuneNLOUR0FS6kusaMFrSzGtvEO84SO1cXrn/9g4Squi
   uX+qC9luFDV9xdozAjkC35+iEfZrQunOV6DjOjbH8REHxRWfWgLtQF1QM
   ML6EIunoHq01k0H8FLY/hKMyePgNPgJzGLmYDYEOSUhgbwMDvB5K07sjQ
   xmrHFfrXGZlDaTIJJlqJsfP4wSCrPIwrY5SrekdsbNI6HM9LqIJDNrLKD
   hSKZxByFmZ8K24Uoh2YG2wR0g69ZOJ1RFXL7HOGGhnf5+x+1OAXxXdDLY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="303699691"
X-IronPort-AV: E=Sophos;i="5.96,266,1665471600"; 
   d="scan'208";a="303699691"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 14:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="684347663"
X-IronPort-AV: E=Sophos;i="5.96,266,1665471600"; 
   d="scan'208";a="684347663"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 22 Dec 2022 14:57:22 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 22 Dec 2022 14:57:22 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 22 Dec 2022 14:57:22 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 22 Dec 2022 14:57:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MS5gZcDGOu/KenIkd/6vBIkuHlvZTO/Vqc++5X00znFYhv0WXssuUTqzWQVJhtLRaut7NV3aEAsHhzInl6hY0jf7CORZW/X4CJsvIb0dKRdNsNPgq4B/qMB2czlfYiUmCQpSZX4eX140sjp+8LERjly7dTnLGYYPcWnuDq+yKACTr+VmcyL9RweUlXDtaSQtkmZ9AY5NJCD2C0uv89lVJdQxzC8MNPvYL0GiCPXZ8Z4otE+0pjFTvPtoCZVrWn4aCHt3tNaJ42IG4QoyRSKZEHEv/yjjyQljU31pZa0vCHzXoC76+6/83LyIPYfN/Ul35lbEPriokAL11u/HW0X08w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzk7oTUXFb0L/RZnFVguXX5ebv6QjjtXMndj3HkrwDc=;
 b=HOrYfRWuZRsNX25GSh/UiFr0KZhBIP8H8qSmMQjGhgfOQwG91ZJKlNiF15IwmTYmz6v8cxog34mgfxNFjUA3I52A34eMf1F47Kh5OxCeSnsnbGFGLiQpLPgVw8fN8SR51Owr+r7kAsAXR3Ua6pSfjZCtfnj34/5e8kbt/UqFPF9HlvJ6GC8JfgTjQN7j78aoS09XGQiAcjh5MnZ8tkHmHwDNRsJ0MwBeKVMweMKS1OsRze4cz5syhEq+vYrpRcRgy9YWinjJOef4HRDH8Mu/aGfiLwwcieYsJW/Rwnr6c7Iqi7tYq6fSYuJ1CrgDo2IGcR4mj48ePyGgVjVDk3vRnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by CH3PR11MB7769.namprd11.prod.outlook.com (2603:10b6:610:123::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 22:57:19 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::5d37:e213:a4e0:c41c]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::5d37:e213:a4e0:c41c%9]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 22:57:19 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH ethtool-next v2 2/2] netlink: add netlink handler for get
 rss (-x)
Thread-Topic: [PATCH ethtool-next v2 2/2] netlink: add netlink handler for get
 rss (-x)
Thread-Index: AQHZFZrh+b7TvGAS8k+QV/mUX8OhZK55HGaAgAFSslA=
Date:   Thu, 22 Dec 2022 22:57:19 +0000
Message-ID: <IA1PR11MB6266430ED759770807768D4EE4E89@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221222001343.1220090-1-sudheer.mogilappagari@intel.com>
        <20221222001343.1220090-3-sudheer.mogilappagari@intel.com>
 <20221221172207.30127f4f@kernel.org>
In-Reply-To: <20221221172207.30127f4f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|CH3PR11MB7769:EE_
x-ms-office365-filtering-correlation-id: 5ae9f9de-0afa-432a-fe4c-08dae46fe131
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FqJTWUxtusn/tuufobycgpQiWxZbDNxmnvp2s5lSqkte1Hspxw3Qv7qDZF+IPFJh9znUI5G1ses+CO6NPnUJxWigTrksijTFAbKnfV/l2zOcTLaAlVCV4yqtFTezfDwaWbHOE3UzkdF2D/SMDRnN2ZSIEOW6l9vOHOpL98AFrljpZK+dDg0E/651wchsPQIDAVwzTFM56eAXUn1t8+VNabw3T9gG71/X0GVN2QzC2W69aF1gzOlKkk7ZAhms+TxdZ+t9CNYL9xKTscugaE3Gff3vhN68iK3rR2J+u7xGpRWtrKP39G+SKUH3cX7RQ1DlWe8dkDHicEWPOzzjLD3WTn7BMIAnjffIikTyfqRRlbJ52fe1g1cFSsBvO+YPJEHHWPNGVbYHimlSzC7haJm4OQ5dehPfBAzhppmUEBTHHFoJVeel1umd4H0LBK2HVgBGha3bDTnOaV+5SccdTAAmTFFgcfKLUSnrSo91UcAxt310mEgk9DEEVNsl6El0noQLc6wc25ttjvT0O+n7E/2+QpBlPojcIk4mC+qQJMNA651kcFiny20bJJaf8mQj3gF6/yFI/afRNkh8o5RDaA2ed9nk8VHsmQC1ptri6JGJf+NVAO5mXAjN6g/BwSZbovPZv9nry8wN/6WcQVuN3UJppzEfH+wxKpW0X8ruZqQE2c+RFI9PWiUozGbUE312OZDnvV1uAmJ/+oFGesOr3rBldA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(5660300002)(86362001)(4326008)(8676002)(186003)(6916009)(107886003)(122000001)(9686003)(26005)(33656002)(82960400001)(38070700005)(76116006)(66476007)(316002)(66899015)(66946007)(66556008)(66446008)(64756008)(6506007)(52536014)(38100700002)(478600001)(71200400001)(8936002)(83380400001)(41300700001)(55016003)(54906003)(7696005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4fvDd1p47oJGqFWffDKQlEoAWZo5D2ISbDgzvlGxpWI36HFH4S0Zgb7Vd8d4?=
 =?us-ascii?Q?CGJBvNjLBClHc2AsHP/LY6sI492YtVbMOCogbhagDP3CqRI5BG5uEJ4YB9Dj?=
 =?us-ascii?Q?TkxoWMyfSS23TSEjL7nri1C2+NdtBBqfKeXcis3EPZQZNGIYVKP6Kmmhplaq?=
 =?us-ascii?Q?fmwqLBwctu1BA1Jor6uGK3N1H7VsywGXRdFhcDs4IlkbPPHUWykvgA0/K0Io?=
 =?us-ascii?Q?IzOziw8n9SHBaij5AkF27Sv2+eXLRrf6+MbQOUYmX0IudYRWjWwsJMrxIg2P?=
 =?us-ascii?Q?w78slyl1VjWZZ+JG+hBQilPQkGL+fU5J/IHprEQGZNADrBbmf+TiiwMscRC8?=
 =?us-ascii?Q?r7aSF9qKFEN38V4leUdbOlSR1D6h6qhM5Me1f+y5htlt+xDH7fnf0fFgbzgP?=
 =?us-ascii?Q?fTOJ7P4hf+z/+WH7o0ne8gmAO2AUSR0vHMmhaGJTMuKkpuqOreO5P2y4+Dvy?=
 =?us-ascii?Q?fpjtWK1lxi4BztDE/ebPiaAbI7tQ1DKwvmpI+mtAdOYx6se4KUVWPxbaWWRM?=
 =?us-ascii?Q?XCuIzlsJdPNPQsBL/Jiu3lO6LdQBEXzjwfVAlMO3J2aQ5midPoS+kM8JMOMM?=
 =?us-ascii?Q?gNKcGAB23YBEjMGlfXN8VXFubdJLXs/IhEL83mEpSYTX4wiRku/JpN3w6ETe?=
 =?us-ascii?Q?8dFt9CBVXoLvNkqF0MjD1SYHqFp/ZT3IxtCFwo5aNOsX+0KPvv9Xseq0mF1M?=
 =?us-ascii?Q?CrnGEKii4Jp/ebgxmq7oIhoDbiF6H8WyWBbYgQXfOoTiAY+Q4aOfg9MWa+YI?=
 =?us-ascii?Q?zgrUiZbglTXuN9Q1gVzZxhwTcoXeIoqRv4vS8HYqyGfucnGTPJx9750nat9p?=
 =?us-ascii?Q?o9ZOAJQLy2gI3TvTGjVko+/zZOfPVXuL7jK4qfphdiDPtG8PH+MKy3kdKGzY?=
 =?us-ascii?Q?06W4GxOTo/r4YBJGcYIrCfNz9tug9SlvT/6EyubcwlCzfVCugZjnBJEzC5F9?=
 =?us-ascii?Q?/7m/gVw40mWuNZuCBKMBqvhrMys7fP+V0udr5NXVAnMTpWLqMdMTPbeSqvgj?=
 =?us-ascii?Q?n2v/LyYv9wsYtjd7oNbDZPM99+Sse2XvGdRoDBsT8SkOTu0nABxGrXhPMP8e?=
 =?us-ascii?Q?d5hZZSb4KhrybQsZLKgbhNhee5SsGWPYbHV44m8ad7C4jc0NkbxqqbTdDLQX?=
 =?us-ascii?Q?GH9WrsU1/QdiFOEPldehcxzUnZbkaP6dB1NeY+CIDoG0caSMfLLNYOxS9laR?=
 =?us-ascii?Q?Y5VKFSZJuNrdRRk0BizQBdClx07AHWRhlvJyx6PuYR1i0VHManK+0q14bPWU?=
 =?us-ascii?Q?ugHrkpmB9ei1donM2AUlvjYj6mGUzwtnIvBzRpWcx1XrkIZI5oe3Bor4BmXM?=
 =?us-ascii?Q?iXc9jI5jWrYmeHva+tXc67w/IQqCienN/JwBi2Iuz9QgJX0k8Q7MP360m8kY?=
 =?us-ascii?Q?2OnhGSfFG6CCVtSwtZo+Jz59AQQ/usEeNIDsfsPl7CmhOpS6CZi0lt8TWUB0?=
 =?us-ascii?Q?PaeRvaEAmQhW6XY/VAUJf5m/lwY6kQ8nCChx0qBnMnNOLzIQovP4+R4bc/iO?=
 =?us-ascii?Q?NQDCvBvYa6Q94uKt0BehIzxbRkJWqGhuF0MFcETr7qJ5+irNM5ugPw6bd2oL?=
 =?us-ascii?Q?sp8quXClKXXKaHi4+THBDxzGKrvP8ibaB1OcFPe9OUOBf1k8geW/f6+IAizY?=
 =?us-ascii?Q?ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae9f9de-0afa-432a-fe4c-08dae46fe131
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2022 22:57:19.6531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Q1eC7qiGpBRWi8wjJnhbwlAy/x8xxMGemDfykU/kPupypi4mlVn5rEEOLgAIXJbR4OdY6F5IUolL7y8LF14Pc953okRiAozyuLhkKaJAv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7769
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>

> >     "RSS hash Key": "be:c3:13:a6:59:9a:c3:c5:d8:60:75:2b:4c:
>=20
> again, better key name, and please use an array of ints:
> "hash-key": [ 190, 195, 19, ...
> (Or binary encoded string (if it's compliant with JSON):
> "hash-key": "\xbe\xc3\x13\xa6...
> but I think array is easier to deal with.)

Will use "RSS hash-key' as key name and array.=20

Output in hex bytes like [ be,c3,13,... ] will be better
I fell but it needs below changes. Without below changes
output looks ["be", "c3", "13"...].  Will send out=20
v3 (with below changes as additional patch) unless there=20
is an objection.=20

+++ b/json_print.c
void print_hex(enum output_type type, unsigned int hex)
 {
        if (_IS_JSON_CONTEXT(type)) {
-               SPRINT_BUF(b1);
-               snprintf(b1, sizeof(b1), "%x", hex);
                if (key)
-                       jsonw_string_field(_jw, key, b1);
+                       jsonw_xint_field(_jw, key, hex);
                else
-                       jsonw_string(_jw, b1);
+                       jsonw_xint(_jw, hex);
        } else if (_IS_FP_CONTEXT(type)) {
                fprintf(stdout, fmt, hex);
        }


> >     "RSS hash function": {
> >             "toeplitz": "on",
> >             "xor": "off",
> >             "crc32": "off"
>=20
> Please use true / false.

ack

> > +	if (rss->indir_size) {
> > +		indir_str =3D calloc(1, indir_bytes * 3);
> > +		if (!indir_str) {
>=20
> where is this used?

My bad. This was from my initial implementation before finding json_array o=
p.=20
=20
> > +		print_string(PRINT_JSON, "RSS indirection table", NULL,
> > +			     "not supported");
>=20
> Why not skip the field? In non-JSON output I think we use "n/a" when
> not supported.

non-json output prints "not supported". So used the same here too.=20
Will skip the <key,value> pair in v3 as you suggested.=20

