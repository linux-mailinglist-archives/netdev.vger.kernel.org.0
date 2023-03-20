Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2496C20F7
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjCTTMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjCTTLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:11:45 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B78832CC8
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 12:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679339050; x=1710875050;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c/FSqEHZfxXg0HlGnLiy46ohhh+8htvxTSxOCrGZJDE=;
  b=RdFdrTrufPX3xoVPSBlkImawvl2qjneYrVsQ8kjqzMxUYxrA65EAJfPe
   j0tZOSvBSlZyW+Na+JPsQzZrhkcMI8Z51X8DtZ1gcx4uALa9OSAFPflaV
   wQaH17hoxblyig2eeSF+8wFsLj3VqSflf1lY1bppStOSHh5cYoNG0RMU+
   RxCgqIw8LOap2AxK68wh6OSzBK/xhb6PX4oCgJ1Pm2SIOpqSphSnzUMVw
   GZmuSunMQBOJUd1n66xAnz1uLhJky/TUJJg7hyYgE9mCyPQdv9YDV5zD3
   ikMgQOKZTyDaG01QX/6aVpGZTpBGERmSxfOjcOQF0HxXevuzLMA+ELC5Z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="341111390"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="341111390"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 12:04:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="1010609834"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="1010609834"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 20 Mar 2023 12:04:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 12:03:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 12:03:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 12:03:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 12:03:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrihNPndHo407/yrW/CMa23q1vNRXcGwvK4QdOyV271xqlA7LFtLDgRqpJYmOivN0e5nQA52DMOXcRj17jVRBizVJI91rNtAaR9PeRrMGj2N+gSOC+dWqlTTfbbxS1qzmCjmZwaktyXRiDXh+fv5pSZV8PTUTM/OhIuTKMFoT1G4SXpT5mqLBsvAoSwW5B5hQUpf0wsQYzx4IPgSy/NBWCJs0RLOPFa4PWseC6I5TFlh6zawVQTPxPSGwpES7uQAYkK7SG2GPBoynunH3xzhCyXg5Wg9DPeqhap1YM6P/A5IaHtuZgJ9ZpVsqQ2glDtKDlb+07dA672BNm+sA7CSrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACrVXc9SRYjJcIFOzWIJMG+tgEFEV/sJXxrHoVi70Zc=;
 b=YIc2l42mI+DhqvZENqGSRRLk55WXfNMkYp4Di9siFyd+ngPix/NiEPb3ysN9MApkwr+E6gA/KPbFC86iDqg12HQ0V7axtd+CZH9EksIHE24xxA6NttQGPR1v6RCYiQbmFj1Vb7309XKJ6O9BAsbu4ajwNIuBZBywESpEDmQohG7XPwhJkLvFrKFpYdV5AAuxRbzerKDycx7u5NVlKNI6fxFGi8ANV2h3rvet2d8Kl8eZSPsaOWx/ULN5NsKgCPQcphvOS0VUULzJOWZ00xmenNP1RpaRwGKjIE2HQTfV3GKOSxOmPm1EpfDdRr4P3xHXQHht316+HemaZ9p8+juECA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB4177.namprd11.prod.outlook.com (2603:10b6:405:83::31)
 by PH7PR11MB6793.namprd11.prod.outlook.com (2603:10b6:510:1b7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:03:05 +0000
Received: from BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::d4fb:c4c1:d85f:c8dc]) by BN6PR11MB4177.namprd11.prod.outlook.com
 ([fe80::d4fb:c4c1:d85f:c8dc%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:03:01 +0000
From:   "Michalik, Michal" <michal.michalik@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Subject: RE: [PATCH net] tools: ynl: add the Python requirements.txt file
Thread-Topic: [PATCH net] tools: ynl: add the Python requirements.txt file
Thread-Index: AQHZVo86gIA/ksfkVkeNfFQzyDEwlK781aYAgAc5rKA=
Date:   Mon, 20 Mar 2023 19:03:01 +0000
Message-ID: <BN6PR11MB41772BEF5321C0ECEE4B0A2BE3809@BN6PR11MB4177.namprd11.prod.outlook.com>
References: <20230314160758.23719-1-michal.michalik@intel.com>
 <20230315214008.2536a1b4@kernel.org>
In-Reply-To: <20230315214008.2536a1b4@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB4177:EE_|PH7PR11MB6793:EE_
x-ms-office365-filtering-correlation-id: 472cafad-92d3-4ee6-1751-08db2975b9fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X+Sfe9HRbdO4woCPzKbgR/thoV7kvdtI/GnosQeqMX0rTFpbSFB5UXdJibwSFHlrFybatdkrh71zaikl7ZKYZ3TcNG/Nn11Y8kONIUxt60tls0myhAYQRnHloO2nBcmt0Fplqf5Gakcr+56MQBN7CfzdN4o02S9tgs7OL4baTcAMsg72ympZDPu9p/bziwo4Q7mFtEOlPhWBGxfOX4EgompmQlF2hwjaZfz2tJlb+Qbbjy0rGdPL4jZqYfKrQdN0XKGmf99UQ+vbAtSeGyYwJbxS+wAp+36rvKVlyFlgVwAzoip56H+8zirGJiT8yi1PXGK5a1nusIidbKzJYB5L8fEQcPr3dCUk+ocWAdpnVrlXkPr7oOCTsx1JJlsuAqUS9EqMyvAUbgQ+EJ36YuMmYLcAUweV1N2BQkxDw8i/0Kr1yiGynwsLouG2OAz0VKKCiTjm6wQmTJq08ev15tXPVrK4oki3b9/KGM4lQ6sUKzAmjt0VhBizSj2lTEvbTvcxFVutU1I8MOwTlB9W6vINszuY4mmqpxrbie3pG1NBoSSKc6NOW7SGM/k32gbu+5D0Fg4h2l72h3sLpKQfNkr2N6Ur05iF7cRAwAQu2jsKKhpM4hfjSEdZMLIpnG2A7oB7v2OvLsShIVMovTfFC0+DMUIb+ieMzNUHIwJmRbQHt+RTqYmtjPFZybh3VMmOOU8t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(136003)(366004)(39860400002)(451199018)(86362001)(55016003)(33656002)(7696005)(71200400001)(83380400001)(66556008)(64756008)(316002)(6916009)(4326008)(76116006)(478600001)(66946007)(66446008)(8676002)(66476007)(186003)(54906003)(9686003)(26005)(6506007)(107886003)(966005)(38100700002)(66899018)(38070700005)(8936002)(5660300002)(52536014)(41300700001)(82960400001)(2906002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dMvoLi5l24zNHXDV9VvTgN4T0d2TI8C3B4lEYV6HprUX0453r05KXGHGKq9b?=
 =?us-ascii?Q?ysY5BhVyyAbLbJvEQkX6SGe3AQUbLAGGKpXT0Rd/CKrQRko6Vzm0cGV7IY1H?=
 =?us-ascii?Q?hyYkGlZzgHrR5S4kmFukoKHpx5pbIfAuWFfznoiofvanqvQBxZGGFgWVbWXy?=
 =?us-ascii?Q?kqH36rLkNG3sAL2cacpJ6b7EafhGXyE/CODCgiS/RhW1nBoadQbMHRA8GCPS?=
 =?us-ascii?Q?+hM/2kQXj9/6EJ5b7m8uBI34h49fVI8Usvw+wwQliDsZgC4hPn/jr+8V46Pe?=
 =?us-ascii?Q?116aTt4SEn/bJzJyURGnLDKcKmd83Y+VI2QXlqS+XDqiJOsZQepI00qTFEi7?=
 =?us-ascii?Q?jhpgWxl5pCrS5LTY92QWnq7VeVYkjdkMfgHDnM1MoXzxekUJnwHgJVwz+Wle?=
 =?us-ascii?Q?IZT7aGiTtuZ3KwvKZfsKz/AXph6Tfy40Cpi3fZTcY7pbNCaZAj3P6AgrQAGL?=
 =?us-ascii?Q?ZjK+UrBmwX1U4B5JcTgSX2jWELGWhDpr1fD/wrH68gZDrYhx8s54jzzk+maN?=
 =?us-ascii?Q?J1HyZy7j1AIgwBJUl8DlntAU8yJiSonwfV0mVB+yDURAivO7nU75g0m6/hoG?=
 =?us-ascii?Q?ENhv2f//02URFqk2s/YMkTmDsxth8OIcu8k/yb72A29C7/TNBiDlurFIrram?=
 =?us-ascii?Q?Al23Ura1JqHYEGnlhV09YhpnsNdF2ekAIFmbys1vHDSAksQPwQ0JqmgWAwlF?=
 =?us-ascii?Q?SSQnVjuu9WsUV9900WBqSbnitgn0aE1CLXlnQTVh5/OMahex8391KpyfmPsi?=
 =?us-ascii?Q?7UtQcyNPKbaKMKrsfMBPa1eIv5AbayVe2460up2rZUGFLX5Lor6/rkIbqAa8?=
 =?us-ascii?Q?fMz9AhtxDiqdGL8OeunTwLpHvlLECRwwhVe4l60YO2uj+HdgBtRAszoT7Kap?=
 =?us-ascii?Q?9TYdCse6Tyh9s1zmtH1nkowE8575iRQjh/m0Zw90szxWqRVUEtkmORlVejpX?=
 =?us-ascii?Q?1kskPFSWSrQkgYvD5iIT9/HaNVhaMgYsIg2hPx+e+/yH0MCVng3O53eHrF8/?=
 =?us-ascii?Q?mw9u5Y9AzX++OSx+stqU0Wv9XbcWjmJHNQeN4GASzDUrENG8sI9Tz6leAtnM?=
 =?us-ascii?Q?DEfwVzw55Kg/VAhJ08Ud8RdYl0xswZERR1+hvQJkklAx1o93Exy+HpnKuOQL?=
 =?us-ascii?Q?tEmhQi/ZAG5EDm2kc7i5uJuIzqXO/0iDmENLbbRItchphBVmoCzL8zyrTBHn?=
 =?us-ascii?Q?Ft8mL4X452/DnpxUFFsT37JfECCnbFiiIUvZn59otWovkZVnZF69YYKOcrHD?=
 =?us-ascii?Q?96ncHbs9cnNRjGuRiP+UNjljC32NR4mD8HgFvhSXfA/ZX4/C86BkiyKnnsCv?=
 =?us-ascii?Q?c7r5CFiYPgjXG4b1Ad4Px/n/pVaVWp0RRQOZVSuopt+zsBTDh66lXSJ7NNkO?=
 =?us-ascii?Q?ZD64wWVZ/+NAd9mKLk4kbrNUpNGGGaRGRvzhGPN80ca840Gk9fNbxDcWBuo9?=
 =?us-ascii?Q?f/iXbotuk+C52SVe4kB9qw9eDaklksG+nNW1GMVOvntms7iipEp+xcdqxcwo?=
 =?us-ascii?Q?u4yEYlWcq3Lu0yXNcgKvuhfFa1Nmv6CftqRYH+fFlhsJJngt01en7WFBETIg?=
 =?us-ascii?Q?HdCdf8EcGrrEpJhl4w6T/eVW1FgT2pSEEzfI4dh9v34HoELbtCQssYy4+0ZV?=
 =?us-ascii?Q?Yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 472cafad-92d3-4ee6-1751-08db2975b9fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 19:03:01.0897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0HJA2uOrT04Fa/iyeK+h4nkS23nbdAOxdsG5ms644dR8BLdF/QCZvXnpAM5MbAuxuyipxDbSd66ZEPY0NHqtEpgozMJsahbm71//DhNtJ3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6793
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Thursday, March 16, 2023 5:40 AM
>=20
> On Tue, 14 Mar 2023 17:07:58 +0100 Michal Michalik wrote:
>> It is a good practice to state explicitely which are the required Python
>> packages needed in a particular project to run it. The most commonly
>> used way is to store them in the `requirements.txt` file*.
>>=20
>> *URL: https://pip.pypa.io/en/stable/reference/requirements-file-format/
>>=20
>> Currently user needs to figure out himself that Python needs `PyYAML`
>> and `jsonschema` (and theirs requirements) packages to use the tool.
>> Add the `requirements.txt` for user convenience.
>>=20
>> How to use it:
>> 1) (optional) Create and activate empty virtual environment:
>>   python3.X -m venv venv3X
>>   source ./venv3X/bin/activate
>> 2) Install all the required packages:
>>   pip install -r requirements.txt
>>     or
>>   python -m pip install -r requirements.txt
>> 3) Run the script!
>>=20
>> The `requirements.txt` file was tested for:
>> * Python 3.6
>> * Python 3.8
>> * Python 3.10
>=20
> Is this very useful? IDK much about python, I'm trying to use only
> packages which are commonly installed on Linux systems. jsonschema
> is an exception, so I've added the --no-schema option to cli.py to
> avoid it.
>=20

Well, that is a very subjective question - I will present you my point of
view and leave a decision if that is useful or not to you. I'm totally
okay with rejecting this patch if you decide so.

First of all, I love the idea behind this script - thanks for creating it.
As a experienced Python user I looked at the scripts and see no file with
requirements so I assumed the default libs would be enough. First run
proved me wrong, exception on `jsonschema` missing*. No big deal, I
installed it. Second run, exception on `import yaml`. Still, no big deal
because I know that most probably you meant `PyYAML`. I don't really like
the idea that user need to either have this knowledge or look for it, so
I proposed this good practice file containing the required libs.

If you asked me, I feel it's useful - but again, I'm really okay to drop
this patch.

*yes, you added `no-schema` and `schema` with no defaults, it would be
enough to leave only `schema` defaulting to `None` or empty string and
users would not ran into the problem I faced, because right now default
behavior is to need this package

>> diff --git a/tools/net/ynl/requirements.txt b/tools/net/ynl/requirements=
.txt
>> new file mode 100644
>> index 0000000..2ad25d9
>> --- /dev/null
>> +++ b/tools/net/ynl/requirements.txt
>> @@ -0,0 +1,7 @@
>> +attrs=3D=3D22.2.0
>> +importlib-metadata=3D=3D4.8.3
>> +jsonschema=3D=3D4.0.0
>> +pyrsistent=3D=3D0.18.0
>> +PyYAML=3D=3D6.0
>> +typing-extensions=3D=3D4.1.1
>> +zipp=3D=3D3.6.0
>=20
> Why the =3D=3D signs? Do we care about the version of any of these?
> Also, there's a lot more stuff here than I thought I'm using.
> What's zipp and why typing? Did I type something and forgot? :S
>=20

I cannot (you probably also not) guarantee the consistency of the API of
particular libraries. For example, maybe somebody would change the calls
in `jsonschema 5.0.0` in the future. In this case - your script will
still work (will use 4.0.0). I suggested this packages versions, because
I checked them for Python 3.6, 3.8, 3.10. I'm fine with removing the
exact versions, but please don't blame me in the future if any of the
maintainters of those libs changes their API.

No, you did not forget about anything (besides the PyYAML that you didn't
mention above). There is more than you expect because `PyYAML` and
`jsonschema` have their own dependencies. If you like experimenting,
please create clean environment then do `pip list` and see the list,
then install only `PyYAML` and `jsonschema` and print the list again.
