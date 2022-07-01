Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C05B56320A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbiGAK6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbiGAK6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:58:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FA574357
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 03:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656673129; x=1688209129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9WhfichglJUrphJCyaALqAsNklbn76EU/E1SYm0E8V0=;
  b=DOv/tuc+vrOjsC4jrxiloEc1r9txrTGaBJp0MPN+nlDu70ereKzLjuKP
   t69QjSE/3+tBZYdyFHz9dQODcYnvPs1SWR8IM5fFDqEWOwq5Ls/NY2Zxm
   aek69/kFYbfMbKptICH85VcahCTg1Cp072+2AJ/a7jBcjaK40ge0wr5Mz
   ykvoRUzNkqMz3JIyWi6YoLpwIKthSWAx1yksdDTPijYdSmjaKDHIhSKZL
   4ryS89n8Qcy7Klyz9gdnlgQjACNQ/hNYIz5HuzS0v0xn2efo5Ps82emGg
   rIOgGX61moCh1ypbs16fdvG5WU1Mi3tuoHzD7EbfRjWrDEDXliDiBVeEV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="346612432"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="346612432"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 03:58:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="838007357"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga006.fm.intel.com with ESMTP; 01 Jul 2022 03:58:48 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Jul 2022 03:58:48 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Jul 2022 03:58:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 1 Jul 2022 03:58:47 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 1 Jul 2022 03:58:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6WAotMpLfduOtvditYo1R2SoF7HlvpiGxsLi8g9X41ILe2T89CRz8eaOYt4+MqBbUzUuHS4J0ukOq3FWNXU7k/eV3R0cPYTgP3glFfg0IH5zXkJJf8ttVsUXvkD/52kP7ILL7X4/5d+dlBkznvWRwwOBG8Qny03H/D2jEwjDTnltOiFSrGeC1jbfI+KKMiw4S+37VF1P7AhBOhZHUC2rXZSaWLo0maZQ9q2q8JdA1b94hMaIDtUuVa1Hxi9Ut/ANTOuWK8Vaqm27vTqkeVg4u9d71KzvWyrJnoVtsOSxcD9FnCGQshZ5SQdi6h+v2Ldo5mQiiS01sTxud5N86zbZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9WhfichglJUrphJCyaALqAsNklbn76EU/E1SYm0E8V0=;
 b=TZGYT3NkfJd4+XeK3WYjL43oyZ1qyw9/Z2gV+1iMp/7O5RvofwX2NpGNM+10htGME61vwuxVjroGLUOVnlHyKV7yRs0vxBjI42IVcbVqQWz65fYciTHx48Kkp8NNsxIIAh6B3XuvbBIlaDsC2Nweb/uusGONcCFJ3mEAHpqFse6TMCljgSoQ0dDbxgQerB2Qwxr3xkbzFez9bZnhgQB60h9jFGJv9VLXdM1s503GrjaHz3LKBJ9RGXvygB/L+6nwsJg2Z/ynpcRL5pHxvj+9aG0+A2+vsII6iALy2n3Otqxc4H/zrzdTD/3029CPfzRO1ADCybbr+7E2V1C55lQ+jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by CY4PR1101MB2229.namprd11.prod.outlook.com (2603:10b6:910:19::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Fri, 1 Jul
 2022 10:58:41 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c%3]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 10:58:41 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "zhangkaiheb@126.com" <zhangkaiheb@126.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
Subject: RE: [RFC PATCH net-next v2 1/4] flow_dissector: Add PPPoE dissectors
Thread-Topic: [RFC PATCH net-next v2 1/4] flow_dissector: Add PPPoE dissectors
Thread-Index: AQHYiuJgPy2R/ctN5UOlVmjbud8j6a1lzugAgAAwpUCAAIH4gIAC2wfw
Date:   Fri, 1 Jul 2022 10:58:40 +0000
Message-ID: <MW4PR11MB57768B60FCA65A41E9B0A4A7FDBD9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
        <20220628112918.11296-2-marcin.szycik@linux.intel.com>
        <20220628214020.0f83fc21@kernel.org>
        <MW4PR11MB57761A084A3A556F4070F8CDFDBB9@MW4PR11MB5776.namprd11.prod.outlook.com>
 <20220629081937.7270e7d7@kernel.org>
In-Reply-To: <20220629081937.7270e7d7@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f15f3e9a-4828-49e7-fad0-08da5b50a89b
x-ms-traffictypediagnostic: CY4PR1101MB2229:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9cXAmtT7M2LCqwnCcyeHKekeJsUkOk9T9B/kOkXNefmDnWxzD0Gb/tGQ+4hEHCt4EA0/PEKXM3j80uZsjV0Qck4uvMP/MVxz2OBDCMDQddjdhxQisyKmjfbR0Bk/BfkYQnlZ9yiXuVgwCnyh4i+0PU6pGuf+fuF2aqjrCv/yTPnVdIhwbzClN4HBMd8xYgnw7UNB9rpzyzoLkUgWhRnwKFwF+2Y5qcdaMaDLxUW94fhjGDRaVJpN7ls0yjmqKvZ1fR56IJjjV0CSAIckzVEqjAlXoJVevunKZf/3axyHb4auzrmVzsO9JjR9ahotMzrRflM5uL/UYf/TqGmJoTmLiRaeGVYlnoYeaUGW8yc3gv7x6vjijakgXGpGMaQ7DtpRKm5KfWqrqjpdLiUQggFq/RhouQEsdAhkaNm0Dk718MNczjpHnSSm43bekhaQcLdZVOKcueYZiLxDECraZyME31Yx8E0tJdOWvaqUAL6wvs92CVq18ULTzZMCRdESJ27EE9VWJPgS9YsMo249sOcLxQ3oyLBYbpNxYTxSaMdpRIxy0KigSxVXPhRg+He8ffoYNPX+67uZOeLEZDYrsB843mXCxVM7Sgm/ySMllWZtlDEHeppjh0d7cmvhViVbe+1mCq4zUxaDtzzBadlp/fFX3jhSfwKmVUbSiw13cSJYAkzFKHNrUnMkfQfdSgqFa5ntS2uJVvP7PuwA+bLrJ6pfInqF93/ixdYic+qoXSySKIsaqHYlSNVK1yz/l0GvOeY2jRQh450DE3ytButv7EFYUPnBy6TKg3Twunl7k7iXBGpIcu/QUrDOU4Jb1Hnb5kiJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(346002)(366004)(136003)(376002)(52536014)(8936002)(5660300002)(478600001)(6506007)(6916009)(76116006)(55016003)(54906003)(71200400001)(316002)(2906002)(186003)(66556008)(64756008)(41300700001)(9686003)(66476007)(33656002)(83380400001)(7696005)(122000001)(86362001)(4326008)(66946007)(8676002)(7416002)(38100700002)(26005)(66446008)(53546011)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?6NJwIAQEH8l/xlTs0j+aERG381LdIzBVZL1BbHEVgHvtTUs16xXoCUuzxv?=
 =?iso-8859-2?Q?3DSgoTZpiqUPg1ichX16IFcKzXpZq3L0Za45CfoyUCibk4ltVDtLWlzv8P?=
 =?iso-8859-2?Q?PgfMjNyPszIor4OVkbSW8E4VvmZqG62W3c4KncBUnWQl+U4ECLq+flK8w5?=
 =?iso-8859-2?Q?tHmbVPl+1WrdchUPu4fDAsdvBawoAKs2BJornosvS7N+7abKKp06KSq/Dz?=
 =?iso-8859-2?Q?HTrydNWTcJ/k/+eabY9jnsa9fiDwC30lEt9c7y9Gni3kFG5eBH1j1EZIU+?=
 =?iso-8859-2?Q?rs+ZWALDQ9u8XfgkuSOyb80LDAEhKq+kvq78vbM6sBdd3eZroYVzWe1KdX?=
 =?iso-8859-2?Q?ns3NA45+EUSZ28U7oXrrkiJUnvjxhqt6CLpMcz2NVkqn35/ij82id1bhia?=
 =?iso-8859-2?Q?JceWaHm5R7m7kVI2ajm6O4921WRm2cpOZC+I8mL2AhT7nBo5sbstyNvS5Y?=
 =?iso-8859-2?Q?1ru0Zw/7XuIgTOdhVg1khgQI3gj6cWjVnQe4DiwMZkxYuibiv1eRRZGoiN?=
 =?iso-8859-2?Q?pOKcQj/nVO6uAqKtTYxF4x4ivpdbL2tUsw6jZvn4RXdxudaNfOBszGrHhM?=
 =?iso-8859-2?Q?qcOhR/WGAeBd5ALXjESAyAoKgrOpYCDQS4CcABwRAH6xdVkGxHk+FrLcYs?=
 =?iso-8859-2?Q?Cs2qTCP4guztXo46PWinqniazsisrvWWpCQ04fP96W7YBjMzW4/d71rjo2?=
 =?iso-8859-2?Q?e+6aCxYl5clm9QgZy3jMml74kB5nATd8V7N79ggrC007rH6CMARBeC/cZp?=
 =?iso-8859-2?Q?WHzD7/SFb4AntHchtYZyaaRl1+4LUH8O5SC7g7vfLrWoL0tyMRh6jd/ke+?=
 =?iso-8859-2?Q?HQxrXzIP9NVNpV/Z2fT+1YHynXbg/1ten9mPQkkbYiCmM0CYpN9DgmdAyL?=
 =?iso-8859-2?Q?PfZOKIYo9AqtqjK+bzxqs8923mwzECgfFBeITjC+9a0ZCoObmVjy14OBuO?=
 =?iso-8859-2?Q?33CPe/z9+DhzGmTE7xAe9ZWs26oprTGDezWFLptIDZoTKRlF5Kujr687r1?=
 =?iso-8859-2?Q?pzw5RhUPGSlh0UMyKMhxvu81ocGvmNmt4qU6zxk91u4pvf7Le0YojsCIkZ?=
 =?iso-8859-2?Q?bxry0YmggPXubbuC5durXlAnjlgYCarpw0xDWT3H+4pxdncymuo6YWU1Kg?=
 =?iso-8859-2?Q?xeoeqFSp4+xJzdVnvbV8xm0wb/XDoiqYZj3uIRUUWd5+zODl4BJ/g1txVJ?=
 =?iso-8859-2?Q?kz7QgQPG7HGqYdeC6Mzh8N1OrfZq3QOmD4LL8TN0fdv1XOWzYku9s0cgL9?=
 =?iso-8859-2?Q?AV5yIfMmdUoMU19E8i+DG2ppCyrvP3a9ooiqWspZmV/TY1i1Ltu0p92P4v?=
 =?iso-8859-2?Q?tpYdCbd/A7pJW8JKNLX+vct7H8P6B4nnIPXjaZ7RSp97NA55eQTMCOxuVQ?=
 =?iso-8859-2?Q?+TavVIw3RkQdd1Qb1FHiwZyezzna8q8gTkDA6a8PgcArdcxyLrKcRyXER1?=
 =?iso-8859-2?Q?hP2OGwmTrkqCAoEimzteK3PtUdxBPfMRCivUa7JkS245g/Bvx/w9L8MIK0?=
 =?iso-8859-2?Q?YcWULynCvi2i4DupShiT7GFwHGy2QHtX9FctnlN0/H06JRRUfWhzzNTZgQ?=
 =?iso-8859-2?Q?1Sh4KnQz+jqpzsxyP6a6pKkTK9qb2DGgnEZl67HbXSCM5H6+6T+s0bTML8?=
 =?iso-8859-2?Q?olOIaEsb90ag5QeViFZxk9lhT3hgL+PgxR?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f15f3e9a-4828-49e7-fad0-08da5b50a89b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 10:58:41.0027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YvhjXkZ2/6u/xSFG5Opeo2tf3DwATKtadku6b0kuIRvO4kFyARkrjf32PzxfgxWxuI2RR9jzCmxqHfB2d1rTt8+0kPRn9kfwqh5lu2efmVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2229
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: =B6roda, 29 czerwca 2022 17:20
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: Marcin Szycik <marcin.szycik@linux.intel.com>; netdev@vger.kernel.org=
; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> davem@davemloft.net; xiyou.wangcong@gmail.com; Brandeburg, Jesse <jesse.b=
randeburg@intel.com>; gustavoars@kernel.org;
> baowen.zheng@corigine.com; boris.sukholitko@broadcom.com; edumazet@google=
.com; jhs@mojatatu.com; jiri@resnulli.us;
> kurt@linutronix.de; pablo@netfilter.org; pabeni@redhat.com; paulb@nvidia.=
com; simon.horman@corigine.com;
> komachi.yoshiki@gmail.com; zhangkaiheb@126.com; intel-wired-lan@lists.osu=
osl.org; michal.swiatkowski@linux.intel.com; Lobakin,
> Alexandr <alexandr.lobakin@intel.com>
> Subject: Re: [RFC PATCH net-next v2 1/4] flow_dissector: Add PPPoE dissec=
tors
>=20
> On Wed, 29 Jun 2022 07:44:50 +0000 Drewek, Wojciech wrote:
> > > > +static bool is_ppp_proto_supported(__be16 proto)
> > >
> > > What does supported mean in this context?
> >
> > It means that only those protocols are going to be dissected.
>=20
> We only dissect PPP_IP and PPP_IPV6. This looks more like a list of all
> known protocols.

Sorry, maybe I wasn't precise enough. It is a list of protocols that user c=
an match on.
In case of PPP_IP and PPP_IPV6 user can also match on inner fields specific=
 for ipv4
and ipv6.
