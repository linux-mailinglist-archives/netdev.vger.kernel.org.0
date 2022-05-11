Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4698523058
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239731AbiEKKKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240938AbiEKKJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:09:56 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9683135683
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652263794; x=1683799794;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rM/YKZOP8TdAlDbDa5NzpSSsuAgZ7N0iqFaAXVdt1z0=;
  b=OqPz6uiH2LU6f9Z8ZDrLV6PplUAFv/wZ/Ek8Y4A1GMCs+LKiVm0aF6re
   pcWHPH2KTsQ7OKxK09VITGmkYy3vPUpVlzjpIUstObQTIg5jihd8NmAL/
   lEehOPen5QVHjPmFZC2HXSFMBieHymm1Hm0qRc/wJX+pyp/mE24RuTC99
   YDuEEB98qSUgnirhLdQBV3K3v72TEaCEY6eU3mBUkRg5ZhYz+M/Quc+lQ
   tM7iICV6eQonQSbcJWI5gR54HMjy/yD4MrouIpglay6ZMcZgfSLPX3e8O
   CBRZh5AvbLBgS5zFCqF62OAHG+ZDX7iRgXEr767kICPaHFm3ae5s7EKTF
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="330252429"
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="330252429"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 03:09:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,216,1647327600"; 
   d="scan'208";a="711423558"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 11 May 2022 03:09:54 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 03:09:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 11 May 2022 03:09:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 11 May 2022 03:09:53 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 11 May 2022 03:09:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzLd1MUprzG99HtcrfpsELcv0SQNXix0HM/H1/+9Gfbka6YM9KcSQl7QrZd+L6WAkJSKerMcu2+JsjHqo9BYOt3XkdY2iatGkNFCjCrWkUUXc2Uyx7RSDEvl7grv4c7ooTE9RjANLFy/6sz+p66xxEbj+cRt7RkH1VTMCziARW5HtFp4rhN8zUfdaE6THXti59jGVojjljURKFgSUHla9LIgW5Xaq2AhbYyjMuDRrn6H+lCzKK6JJzoMlbUb+gEyTVbb6Ay0qk/K7TvpRWU72GqU2Nh6sts8jOegO9PX0IyJL8tu3Ccefw+rTyRce9vtO3UvN7PUdOrMD8B3jDgV4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leMXgZyMvpZhxsD6iJ4v5CAz5hpDHWyjediHoUoozk8=;
 b=GPLlQZdRYLRAW76NIG5fzTqFpr7K5jUakehOItkmiqsElbi+y1j9M0u86veR+KAm/T2YLCTtfasmEEqYuUf39K66wo6gAIkndwkf5+3q76SmRPQ8Tdodf4Jlqf4LYU2kliPs4taAkyUiJKSotGAuRJtd9p79Qxju6LFTDLIH8UdHM6ayDDsXIXIHDFvcxgrD9SZShpAvJatXd7nP9Y5gEdUSpJAqIuJArVWg+MgBKWpRXEPVTVckor90Gfy6XJcAWFBDcNUNMs0ZYLjJ6eVnKR/9bUWKQRJko7rzOablog7sD6VtvLVolxU1iG4RUsYIwTlQsgGQa1blY3RIoZiXJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5288.namprd11.prod.outlook.com (2603:10b6:208:316::22)
 by BY5PR11MB4181.namprd11.prod.outlook.com (2603:10b6:a03:18c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 10:09:50 +0000
Received: from BL1PR11MB5288.namprd11.prod.outlook.com
 ([fe80::e5a1:4f2b:ea64:595a]) by BL1PR11MB5288.namprd11.prod.outlook.com
 ([fe80::e5a1:4f2b:ea64:595a%7]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 10:09:50 +0000
From:   "Palczewski, Mateusz" <mateusz.palczewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
Subject: RE: [PATCH net-next 2/2] iavf: Add waiting for response from PF in
 set mac
Thread-Topic: [PATCH net-next 2/2] iavf: Add waiting for response from PF in
 set mac
Thread-Index: AQHYY8upkRs3PW6/FEGqN6oEN7i5760Y8LGAgACEtmA=
Date:   Wed, 11 May 2022 10:09:49 +0000
Message-ID: <BL1PR11MB5288BAE1249799CD02FD281687C89@BL1PR11MB5288.namprd11.prod.outlook.com>
References: <20220509173547.562461-1-anthony.l.nguyen@intel.com>
        <20220509173547.562461-3-anthony.l.nguyen@intel.com>
 <20220510190927.56004f10@kernel.org>
In-Reply-To: <20220510190927.56004f10@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48a452eb-0293-4090-1693-08da33366286
x-ms-traffictypediagnostic: BY5PR11MB4181:EE_
x-microsoft-antispam-prvs: <BY5PR11MB4181731BA7FD4CC2149B75FE87C89@BY5PR11MB4181.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d8qSrRgxPXCq9G6rd1fBv/uJXoNJFQv50D6lTUvblB97mU3OpybYMhB19xuc3pvISzHdKdffpzwNrv5XkHGboii2DnLgnBEoDVXzkiI5OSDbX/xKZ++3w9E4T1a0r4oXIG7i1l8nJn0zIN9grFhEEq8uamWnQArDC4Jpcpp+/0Mt7ZSxbcJL6WSapTJoxfqS35q/ZhLZBX8g3vGLgpL8BanKGY7xqEy9GGgysOJ1RYW0xMjs3GFq2Tao4hd5EG3AmdRYVgL/Bh7ypNlPyelvTuRTwTPtbn5AihrMbLCQE8FJkd9r2S+Iw7uBU0/B1R2XsJNyY0G+PQ4PBfcOOMOVDseNmejfmwyupqmlUan1nPPH8/ToXn8dsL01LDzREEPH6JC9EgM6iBaLKCQQgmQw8gjAfSku53LDWDvvntZlAv8y/lDmpjDFu90HWWV9+MbDFBNDjq/Sb+H03MApEEbZIj/w8B63r+N4pT+Wsduzc7FKczdc5xtNz30sULFXD9HyClORagk2lm05B4Pb8V10eBoVHx/H4+MDB7cCkMqnAghknyFGlccYTg+LZCaFrYwnLEH4Yc3kfs2rxx0i8GU20iEzYvhCCKYgeqChaNhEQy4dO02xWTFyoVbfwaiRS0KOteRaeJegJ6I5c3DaBt8w8m2GWK2mba6ENJ65mEg8JgWmXSbsQ2bLoGtTM/ebh096Pa4lfMW+bCTsT0Iy6ad6QtGah8L5IXEalP1c1LB3TG8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5288.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52536014)(8936002)(5660300002)(82960400001)(508600001)(122000001)(316002)(110136005)(55016003)(107886003)(6506007)(33656002)(9686003)(2906002)(54906003)(38100700002)(38070700005)(83380400001)(76116006)(66476007)(66946007)(66556008)(64756008)(66446008)(86362001)(8676002)(4326008)(26005)(186003)(7696005)(71200400001)(6636002)(69900200002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B62EaosOBYgUHRanko1gOWhDdxkNtvc3lUOF2fBFIWOtgsb1P4uW0CIhdL5L?=
 =?us-ascii?Q?asagxSTuUgYm4i4qOlfOhAxsWg3W523+zSTbciaTXPrrCbjCzgUIV4jPZSeP?=
 =?us-ascii?Q?U/OIvUL2m2JFNq/75cjEzE7IfKSI1N4pQhtMnvrli6QWQArpI53YsadT4FHG?=
 =?us-ascii?Q?gz2HP32rfRCA+/qHgA1bYYWnySHkf+bcnEi0Ecx17maQo2G8MyE09NqMay9Q?=
 =?us-ascii?Q?pr4ILLFgmbvR417OH/J8NKgRrKVDxa1GnZvBbmPW6hq7mAP3g6UAIik/gwj2?=
 =?us-ascii?Q?wIJvMUFhItYhtxwqwO1kwecF3ockrKkZf1meThB/WRuRZhYp4ynlBi2hcJ6w?=
 =?us-ascii?Q?wp06bv6AlGmNH13RwrPBqzllOnGaSSdbVmRsipP6Lxx5TSPDcWLymwZtb5tc?=
 =?us-ascii?Q?tgH0FxkjSpYVjDSYJhrhWVbbn3tPV3mkAmnjpwQlpeQsJXs7/0SRFWs4OdKn?=
 =?us-ascii?Q?dxDE05G66zQ1ca2GY8IridAc7efE9v81g7Hul6jpBcTuYdt78NK7D32Or0eT?=
 =?us-ascii?Q?3NBbRkkYcA4Gna4KWvlQhMmHZNfjZzCmyMJF+1xNA+myGB87GxkMVnr8ehaz?=
 =?us-ascii?Q?1qvCSDjCdbkKMWPnwgjXMO0Ff4p1oOFsA+ftf8Omb81hTa1yvLKuuAyD8TC9?=
 =?us-ascii?Q?SAx1XFLDveHCHO79QEr0jhbQgEpPZxqneCSQsyxz6aTQjwC3KIKG0sk70fsr?=
 =?us-ascii?Q?sazcEwd5p2otWFy9yXZN7lUS+ttVL3WCxtjweHhYAXPaGNHlpxK8c6otVBgT?=
 =?us-ascii?Q?GvanfcaB36xGXFQVFvrpBNnhbgL0HqI7Uqi2qCE7LC1bz2wfuA1LWku6YSrU?=
 =?us-ascii?Q?eyxZB3vH+Is1ZSZH964Lj6OQaQKuf1sH4BHgVdPq7bO2a9m1BpFX61WDQSqH?=
 =?us-ascii?Q?22G7uFNoDjMcwqeXbDGJf8rQMmUjDdapy0+jJFggovDtGzbmm8eL/kOuzfsk?=
 =?us-ascii?Q?T0GfzqjkeyCXJDaXkUcJGEWZx7RZtKxorSfcZlP2UAR1383iyu+flbd9fSpY?=
 =?us-ascii?Q?DEjng0XDST0Rz9JsV0y8bTe/OKjkYJcr3BzxzIXgn9ScSlmSQeMvtCX23J3F?=
 =?us-ascii?Q?BWOj7EG96OoSYd1jFgjtZjOnlxBKoS2Iv/5pW8e8MIPcsS05LsrjURTXiRMy?=
 =?us-ascii?Q?NVE0PnuAjONwA3iPh9u7ufAwKqX7lWQprfcSTJZKPPPXXcFybkN9L6R0FFeQ?=
 =?us-ascii?Q?mCMde9Q2UKVZIFyRdY2vKYWXCgzbI3hzGGFXJlTTej1f7N9sQd8QDxQnyu6N?=
 =?us-ascii?Q?UDUC97ALVg0vFHA/a4b5jYpfg2qstS4x2DLegw5HfkM7My/7vYNM92l2iwsm?=
 =?us-ascii?Q?5gMjEhfFSeNRU9xPTLi/CXivnx6EhLQXEUF+c2EiVhxoUPzBuHUGqtt2GYwj?=
 =?us-ascii?Q?Ss8e4MLtGWCS4h13yD8ytxpOn8IGKar/Fz37oNhYkYYmXxMLmr9AAc41Ys1H?=
 =?us-ascii?Q?xYy8vUK7dtGqKnm/gZ26EMIveFJYK+tFl3VB5d3G/QukoSmNfm154LNdE7kI?=
 =?us-ascii?Q?GXf6u5s8CE/SDtJPgbKkWX2mf2Qzz+HXt1417PigQutlrAArOEVJ0DGEKsEw?=
 =?us-ascii?Q?QjJg49pPzh9rkSyrZXf+jxxuhC+VZPMao1obOXHZ2IULTIRNlVqJaMb8R7GR?=
 =?us-ascii?Q?rUiYRmGE1SUyWj+NSR1BprKxIf8aHqIY1knaD0uUB2ZwNLuPVJZgH33VWXHL?=
 =?us-ascii?Q?uR6ve8BeDZBxJYgCF94r5V02lsYcP2L+EzS2tyXXgZAaGiOQapNzFeCWPzsR?=
 =?us-ascii?Q?BbCMT7z4jA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5288.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a452eb-0293-4090-1693-08da33366286
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 10:09:50.0239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oL3I5YghMONIh0c8jGv4iTzTW7ESCL6Sh1obeoHPAymaeUoLLOTcrDmgUI+1V09MaCypXGf0IgnAFVwo3nVyj+Xy+qJeG4qjmPQ77XW5/HQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4181
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Mon,  9 May 2022 10:35:47 -0700 Tony Nguyen wrote:
>> +static int iavf_set_mac(struct net_device *netdev, void *p) {
>> +	struct iavf_adapter *adapter =3D netdev_priv(netdev);
>> +	struct sockaddr *addr =3D p;
>> +	bool handle_mac =3D iavf_is_mac_set_handled(netdev, addr->sa_data);
>> +	int ret;
>> +
>> +	if (!is_valid_ether_addr(addr->sa_data))
>> +		return -EADDRNOTAVAIL;
>> +
>> +	ret =3D iavf_replace_primary_mac(adapter, addr->sa_data);
>> +
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* If this is an initial set mac during VF spawn do not wait */
>> +	if (adapter->flags & IAVF_FLAG_INITIAL_MAC_SET) {
>> +		adapter->flags &=3D ~IAVF_FLAG_INITIAL_MAC_SET;
>> +		return 0;
>> +	}
>> +
>> +	ret =3D wait_event_interruptible_timeout(adapter->vc_waitqueue,=20
>> +handle_mac, msecs_to_jiffies(2500));
>
>Passing in a value as a condition looks a little odd, are you sure this is=
 what you want? Because you can rewrite this as:
>
>	if (handled_mac)
>		goto done;
>
>	ret =3D wait_eve..(wq, false, msecs...);
>	if (ret < 0)
>		...
>	if (!ret)
>		...
>
>done:
>	if (!ether_addr_equal(netdev->dev_addr, addr->sa_data))
>		return -EACCESS;
>	return 0;
>
Thanks for a tip, will work on rewriting this as You suggested and will tes=
t if everything still works fine.
