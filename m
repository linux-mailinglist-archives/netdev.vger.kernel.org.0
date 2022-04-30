Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634E05159B7
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 04:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379712AbiD3CDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 22:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347819AbiD3CD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 22:03:29 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F362633
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 19:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651284008; x=1682820008;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cKgtVfkEdMQ/EW7j8qMoH9lPv5MAkn0AaEEPMc/S56w=;
  b=TOb69qD9xgGR10BzdU+liW/FM8mBlaZ1SsYTYPXvMzR9fjyvZK02aLG8
   SiUg7VhBhznXW18SvZCmt50UTyzUADhnLQwL4Llq9wLKwOuUmjjqSARHJ
   NemMbW/Tz1xgK3hedtUCYAIxBPb1HNcqmNvDjSNMdi8Yyvp2DS/r9fX7l
   tgv9DY07IOcv1ntn6qkDZ5PigrJ41hVr+XT6Z/yri3H3n6lSSKzZjgZMU
   vbtdGilrxvodoaC1SOUv9l4+fLdQH23iaC0T2TZlLuManJT5ohqFuWQmE
   tI6QMchBkxVgeEh3NuVQ3zwCve1NBwuY29SZ9Ns0EZeQnP72oVzQMn2qZ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="246733779"
X-IronPort-AV: E=Sophos;i="5.91,187,1647327600"; 
   d="scan'208";a="246733779"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 19:00:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,187,1647327600"; 
   d="scan'208";a="582534603"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 29 Apr 2022 19:00:07 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 19:00:07 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 29 Apr 2022 19:00:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 29 Apr 2022 19:00:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 29 Apr 2022 19:00:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqP0vkGuj64kRdn+B5kbbwxbEGL8aTIEZgAssfGj4OLp4f5gGR1dRuRCQR4zuFUxex4Vqpj4RHpkAteiIqwor6maNcGYcaqiejn5xub/T2sRBNGMSxcLsg1K7HECY2jhaFHLjgenZVArR574DZMYi6vHLkqYxwk7/ZN1Th1Z3tTTMUAr+5/75zgw2HkAL1VKaL4BH45GdpdqUxpUjkt3RHbinm8l7N0gR4VKgia21VlLlVaCdQUhddE0gXza8bezu9lJvDdwNwWWHH3n87uGKXONuUFmg+/8SouQaHaKq/n6QeliSAiPUHZ00SKH9iGc1F64oS27rTeqE5IV8sAGIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b84JP+Qs95YV9uXWcvsPbZLgT0zc9bVTgLAfTYzoaTs=;
 b=Qh95hKGTen8nqv3WrYsmKwBWvzzda0XglEuCc4F0pTlJKwGCWU1KaWgE8HDYQioOjML/OyIT4zXpHVyDbBvbT40OzqUtcaAJPACo3m/fiB/YJYoOoyvqynlHCR+YQVpa6AMrE3JCMf2/BUQaClGUvkD7HKlyPH1GX4DWUB8NPJq+vkmOVu5FCOjIB6CFbAJBnl4ICMBXuA2eal0PJyndHKy4lJQTkFiAKAYR8CJc6oArAw57BVNlzNx1K1J4y5ob3JUH20PMyk/y5fptEpgxP1vHMCat/tZfChThfq7xK2uHqY/g1fyxY8Nfz/QjP60QpJ2GdHJcQ6tHITBSAygMiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by CO1PR11MB5171.namprd11.prod.outlook.com (2603:10b6:303:94::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sat, 30 Apr
 2022 02:00:05 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::5839:bffa:4db3:cc6b]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::5839:bffa:4db3:cc6b%11]) with mapi id 15.20.5186.023; Sat, 30 Apr
 2022 02:00:05 +0000
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: RE: [PATCH net-next 01/11] ice: Add support for classid based queue
 selection
Thread-Topic: [PATCH net-next 01/11] ice: Add support for classid based queue
 selection
Thread-Index: AQHYWyU+3sAH6JN4DkyuLtGetMwV2a0F8kQAgAGT6HCAABLWgIAAFyLg
Date:   Sat, 30 Apr 2022 02:00:05 +0000
Message-ID: <MWHPR11MB129308C755FAB7B4EA1F8DDCF1FF9@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
        <20220428172430.1004528-2-anthony.l.nguyen@intel.com>
        <20220428160414.28990a0c@kernel.org>
        <MWHPR11MB1293C17C30E689270E0C39AAF1FC9@MWHPR11MB1293.namprd11.prod.outlook.com>
 <20220429171717.5b0b2a81@kernel.org>
In-Reply-To: <20220429171717.5b0b2a81@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d766a731-cc0a-4b12-e607-08da2a4d25a7
x-ms-traffictypediagnostic: CO1PR11MB5171:EE_
x-microsoft-antispam-prvs: <CO1PR11MB5171CABE325E52F84D725931F1FF9@CO1PR11MB5171.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uCr+E8qt4F/F7qkHnGPFVyiN6GqyB0LOBAxKkwROXGN488eMtnYzkDNmsyRdIHpasiK4kPyNSM+YnOJWr05H3qxG47fHHFJtIkRHTJhlBX004+dnwQOswyiAlOJP9K9IIXbkGwc3OD4P7xBz6nIRD/zOWJJ6js7mzmNlGGZL1sG9taQxgdsjMiI+lKDJ3+pX+kou1TWITWLGlwLjxWO8js3E1qHzmjAbnNwPfM8ZiP0m5GT77Tu1a/GnkJts78SnK0yeWsgdjtI4zXVUzmPL/pxz4wddfJu38pskcvhyBbzISHQqgCQNrXt63p1fiiM1psyuuEidCWQiVS7ZFnGZPywOnbCeUAb3LPmD2wnTFLmoQ2y51sxDj5WWeQG00sLBQC6JjBtlmu6txmdDgvspSFf8gbr4f4LTmaSMzjNqYm+HB9H2ARO/CTBO9HivSkg0ipMqPHwRL9zB+p8QN8Hvrf6PRsZohqUug3BpFp/Hwi32N9OSOrxlhl/HFqa/bkNBnyYTEBV2whojrGL2qhN8Laanm86PgqPQmYvXs/cd3McYYKBEp8jbfNLPL4w52X2ZT9tmLp6r8ubiDd4L0tc3qvbbLZu0MhAflF3hgBLGfV2eM2sOml2kp5ld4xIxBWDfynn+8+zv6M6XLyvVnNZqSwVDINm2R0m4SOwPSqXTaqQ3GNQvFHJz1QWZUYb/M+wDSra1eFj6XdwF3R6Vp04MCXXNJLVD0E/8hEJuHVDmufzwnJSaDWmJR4HcRJXyupvPWazOaUCwfHNOPcoYZrDLlJhc7r1mk4U8h/frJiwpYJM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(508600001)(9686003)(966005)(71200400001)(83380400001)(6916009)(316002)(54906003)(66946007)(4326008)(8676002)(33656002)(52536014)(76116006)(186003)(66556008)(66476007)(66446008)(64756008)(5660300002)(8936002)(86362001)(38070700005)(82960400001)(122000001)(38100700002)(6506007)(7696005)(53546011)(55016003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fe/Oh7uQtd+ye0BHiOYiSiF9v335YPO6ywzV3vpGNel0k4ES8BmStGFxQxrJ?=
 =?us-ascii?Q?JUh1l5oT0tVBH6NdCuoDHXV6+xpUFqqxf/UZDQ9MlmVlTT10Zxb/R1MTZ+JE?=
 =?us-ascii?Q?UlF0fibDt73XGUwA4bg/yZWZTabbStKnvkY9w+pf2NSyC9jaMI1SREXdqGAZ?=
 =?us-ascii?Q?2Lyw5k7LCbI6qbC9F8k3i8KoaISnHPK3diRghJE1p5E3jRYA5BbuKjY2/AbX?=
 =?us-ascii?Q?qcePel0uUj0MPc6Ufikp8mkO58W2h17HjmDE5T4j+pCSlR+OJG8aSJOgXCQ0?=
 =?us-ascii?Q?n9cle0X7HbHV3tBp4C//Lbe8W92z+PXx3E6uaIlPNjKcOJRtSZ2HUH+16nVH?=
 =?us-ascii?Q?D+rlJ7TXpTzl74+jJSc0MOoYPuR/4nF3wl2mBztl5iVOw/ZGVDQ05/J46cu6?=
 =?us-ascii?Q?dQKSwTrhbLH/k32k7iEJmJQQa5rqcyP6seDckeWYr+ZVQSa2q9rwvkt4KywC?=
 =?us-ascii?Q?rxTL9TDdDcqHkf1RX170w+XgyE877GGZnhL1EbZAzfgnPJcMQC4XYLGKwLwQ?=
 =?us-ascii?Q?MivS8xgFyzo+Jk3MQd7g2XL2gtf2YGMh8ftvhhR73JK44QCbnKnqRehtWHqj?=
 =?us-ascii?Q?/8z5gMj3EMqbsy7SEm7JLDMBzNZEHhY7iakD67wyOmFDtpksGGlUkjmdJDIR?=
 =?us-ascii?Q?h6VJ9C3kQqwaKxE9XowEnwQeHGsHWILf6UFDiDWyU+4lafMaNasEunxtrogM?=
 =?us-ascii?Q?M0BJkBAWfqrG84M8b9iNnWkO+khJFa7vpue5jh/uXTypakkOAYKepGW1jJEU?=
 =?us-ascii?Q?d7Q0w5NpC96wEijyg0EE/2QmCwL8HklRGb+DM0LXtqzbGmTKetV0WcHEYw4p?=
 =?us-ascii?Q?Hvwq4dzqyGPoQtIEXTBwr2BsU4d+BDKiphSDwLPScT2lfT2g818T1wS0UFfn?=
 =?us-ascii?Q?u7VHRwJy1qlM5di3M7KfiL2pFZbJeYk+nrt/gL+F7aQyok24AqPJruybaH6J?=
 =?us-ascii?Q?2IKXPw7cBwzs84CXwRUQ0WFOAOnbbPlg1iL4ktta1kuKYoyVgFjwKYu7Foh3?=
 =?us-ascii?Q?7eaqi1gkw0RQ+m/dM74CUrOEwObEwB74auXBK75dkoNLIXm5WR3v2zyYIuYW?=
 =?us-ascii?Q?Lks7X3n/LY6TWv8J/OcyNHsGXUIl4QcV4/SeEKuo7qdOVyg7CyayoOT6N0Ka?=
 =?us-ascii?Q?0hadAFth/bQqufCZ4l8Chq+AdCVN3wEL/h7wOOIYbH7Vu/JAmp4nVVDDjUr9?=
 =?us-ascii?Q?G+aBMh0kaJ0zcuJGmI9vIMTB6OPZ8bYpo4gAM/pV+leuJssrRj79kvCTR+Iw?=
 =?us-ascii?Q?RcqwB7zzd1ebDl8XKiFIseNyctMBgcseV8BaU3fY/+XsLQu5KGVo9NT+2xPx?=
 =?us-ascii?Q?7vEkwccy2vTIFK57+JT9Um4SigN08Of3xrH3S2SkYbw4VnptiG1D69XKEvzl?=
 =?us-ascii?Q?jaiTKrUvB7sWP1itOW2w170EQGtjziC8bKgkZEUZQXIfVqrw7ESgAcZs7QdM?=
 =?us-ascii?Q?gzz2CfQfiLnfazSAjE55lQVEPEmh5tTCu8vU5JCHdGHI+mo2sQp9LnNRm0W+?=
 =?us-ascii?Q?kOGmexGtyn5J1guiRhe7Vjy4aLtB+CR7lK5wEc6WmO5DNNGxzl5vxmDB9QZj?=
 =?us-ascii?Q?ezC4L8IOsQkX7RmHOlJmtNnwWeGjbxP7UKmalC25FQ/WtGG6EXNZ2ZP1ZFME?=
 =?us-ascii?Q?+FM2BXHrOE99OTXUtUWgPRlVGsMQZCzsgM6S5MyVrX080s4GrloDD7iXC7wI?=
 =?us-ascii?Q?qavCFgtO9Ku8wSbdUgMeJaW7giLDPwK+FxzdxEQELLibDqtaSklHwyaSnDuD?=
 =?us-ascii?Q?W9PvCtbGlA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d766a731-cc0a-4b12-e607-08da2a4d25a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2022 02:00:05.8486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cItJwZCqkZfAgR0cc7irfmksQNtcvLx+lxfT638FMbsR5GEJZY1EIVbeuk7bO04jiD5YawlyPK3e+TkFBzABFgtC0Pb7HSqLSo6e568zMwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5171
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URI_NO_WWW_INFO_CGI autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, April 29, 2022 5:17 PM
> To: Nambiar, Amritha <amritha.nambiar@intel.com>
> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> davem@davemloft.net; pabeni@redhat.com; edumazet@google.com;
> netdev@vger.kernel.org; Mogilappagari, Sudheer
> <sudheer.mogilappagari@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>; Sreenivas, Bharathi
> <bharathi.sreenivas@intel.com>; Jamal Hadi Salim <jhs@mojatatu.com>
> Subject: Re: [PATCH net-next 01/11] ice: Add support for classid based qu=
eue
> selection
>=20
> On Fri, 29 Apr 2022 23:43:06 +0000 Nambiar, Amritha wrote:
> > > > HW.
> > > > Example:
> > > > $ tc filter add dev ens4f0 protocol ip ingress flower\
> > > >   dst_ip 192.168.1.12 ip_proto tcp dst_port 5001\
> > > >   skip_sw classid ffff:0x5
> > > >
> > > > The above command adds an ingress filter, the accepted packets
> > > > will be directed to queue 4. The major number represents the ingres=
s
> > >
> > > ..and "directed" here. TC is used for so many different things you
> > > really need to explain what your use case is.
> > >
> >
> > Sorry about using the terms "forward" and "direct" interchangeably in t=
his
> > context. I should have been more consistent with the terminology.
> >
> > The use case is to accept incoming packets into a queue via TC ingress =
filter.
> > TC filters are offloaded to a hardware table called the "switch" table.=
 This
> > table supports two types of actions in hardware termed as "forward to
> queue" and
> > "forward to a VSI aka queue-group". Accepting packets into a queue usin=
g
> > ethtool filter is also supported, but this type of filter is added into=
 a
> > different hardware table called the "flow director" table. The flow dir=
ector
> > table has certain restrictions that it can only have filters with the s=
ame
> packet
> > type. The switch table does not have this restriction.
> >
> > > > qdisc. The general rule is "classID's minor number - 1" upto max
> > > > queues supported. The queue number is in hex format.
> > >
> > > The "general rule" you speak of is a rule you'd like to establish,
> > > or an existing rule?
> >
> > This is an existing rule already being used in the TX qdiscs. We are us=
ing
> > this in the ingress qdisc and offloading RX filters following the expla=
nation
> > from Netdev 0x13 session presented by Jamal. Section 4.1 from
> > https://legacy.netdevconf.info/0x13/session.html?talk-tc-u-classifier
> > "There is one interesting tidbit on the above rule exposed
> > via the "classid 1:1" construct: the accepted packets will be
> > queued to DMA ring 0. If classid 1:2 was used then they
> > would be queued to DMA ring 1 etc. The general rule is the
> > "classid's minor number - 1" upto a max of DMA queues
> > supported by the NIC (64 in the case of the ixgbe). By definition, this=
 is
> > how tc classids are intended to be used i.e they select queues (in this
> > case hardware ingress queues)."
>=20
> So we're faking mqprio behavior on ingress? I guess that's fine.
>=20
> Wouldn't SKBEDIT_F_QUEUE_MAPPING be a more natural fit here?

IIUC, currently the action skbedit queue_mapping is for transmit queue sele=
ction,
and the bound checking is w.r.to dev->real_num_tx_queues. Also, based on my
discussion with Alex (https://www.spinics.net/lists/netdev/msg761581.html),=
 it
looks like this currently applies at the qdisc enqueue stage and not at the
classifier level. Alex had proposed a solution to make this more generic to=
 work
with qdisc, ingress and egress hooks, but I haven't had a chance to get to =
it (being
on medical leave).

