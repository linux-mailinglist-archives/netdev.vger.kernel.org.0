Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A0B563466
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiGANdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGANdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:33:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15BF15FCD
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 06:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656682419; x=1688218419;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+jCiBYtU8ePcLvo3jW7YsIo3Uvff/+4Ue4NAmLxopiU=;
  b=BWL6HsoXtUtM8DHJpAHW3EPsA4ploqmcRXfAoNETL8r0DH2YfRI22qS8
   24HlEoyV7yHWsnNiWXqwNgogiKymXfb6DbI0DSYvrBQ6UrXuuZ79FDhqs
   LIQCaHqYe0pINXg1RwXq4W3Dtv4scN3ZJ8KUdLZVB8E1A448rz85Iog0s
   0+q5QdPeEC6kWEEVCi/+42LdcI+sgMTtlPCeyzq8DK7BF27xOcbkNkOcq
   g1VsbiXzAn38bHPP5qwCWIg7ETNeI2JvW1KI9ARnML4YEIFJylhQgFqzf
   AFUgpZvyWPvcYL/MJg5hIkTJva7xIgR67xHjn98DaCoXB7umlsVGvMY1f
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="344337264"
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="344337264"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 06:33:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="596260089"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jul 2022 06:33:38 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Jul 2022 06:33:38 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 1 Jul 2022 06:33:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 1 Jul 2022 06:33:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 1 Jul 2022 06:33:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEi7WQckEmA/l1YN6JSGD+oz42xZHvX05IP+btCQ0DodPMZ0hVaoTRpcWUrqZyJSYx+6RisFglajclzWTJUDpN+4XtqNjkghgNTZutdbOcpb3LERv3e/8NYnB+1PkaqED/dJ/8iNR9xu//tRI0vGTqw212ymE8XmzRRipvN+f6zQcSlUReWuRn7iCbIarc6QtJ8BLn4bb1GATecC/VGyWELbtamS16YiUUwclZm5fqBQ6Y/MTv+SoORMULmJC1BP6uIg1q3SkzsgTotSCTbwPE/RVwv5Jl11SLMRf+bJvVX5ZoFZZvxatBf244YQ/d5kvv+EhywgZecCIeVsZWgXtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PzZCdz6wxXvfZeDy/AiX3TfKENmxBt0bfc3+jQXvtz0=;
 b=C7/M7AjqJaGM0Mdm9mdAsEl+r8/8mNJ0DKVfqqcIjB8JJzK3kdqaLeHIYOoi7Lz2sR3RE99XUsdMIPoc0uF6WSQEMi381CKc1EB6w1D5aGLmeEt1uydAIEKEAOQFhNyOuyiaf8XvEBhfRFhRQmFXtEcgqfy35m7DCXpUteLJNAcj1wXVKhpCCuWUrjwSeNwwYK6ayc/Mn7Hkkh10/79P+7WhroYY5+qE735unuSXCvMI71ff/s7TeDOJ4blDBaX03sKkfYObHy9L/1EZdawY5A91uPSUt39dHJAnvIFgCYKL/bclZlymqFQL6w6fzZtV/bySH94CWMIZIsAZr49wlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by MW3PR11MB4716.namprd11.prod.outlook.com (2603:10b6:303:53::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 1 Jul
 2022 13:33:36 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c%3]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 13:33:36 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Guillaume Nault <gnault@redhat.com>
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
        "kuba@kernel.org" <kuba@kernel.org>,
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
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "mostrows@earthlink.net" <mostrows@earthlink.net>,
        "paulus@samba.org" <paulus@samba.org>
Subject: RE: [RFC PATCH net-next v3 1/4] flow_dissector: Add PPPoE dissectors
Thread-Topic: [RFC PATCH net-next v3 1/4] flow_dissector: Add PPPoE dissectors
Thread-Index: AQHYi8Yz71onwe1ZJkqLrfIIHXHZd61olZEAgAC2kwCAACwZgIAACRCQ
Date:   Fri, 1 Jul 2022 13:33:35 +0000
Message-ID: <MW4PR11MB57765C3D4A7B8B95F4145BBEFDBD9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220629143859.209028-1-marcin.szycik@linux.intel.com>
 <20220629143859.209028-2-marcin.szycik@linux.intel.com>
 <20220630231016.GA392@debian.home>
 <MW4PR11MB5776F1388A0EFB83990120CDFDBD9@MW4PR11MB5776.namprd11.prod.outlook.com>
 <20220701124133.GA10226@debian.home>
In-Reply-To: <20220701124133.GA10226@debian.home>
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
x-ms-office365-filtering-correlation-id: 65935b21-5fd8-4992-3295-08da5b664ccb
x-ms-traffictypediagnostic: MW3PR11MB4716:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jzzMRQa/7z9eI1xjUrC3czCVUUaq/+LpJmXgZ0/e9qw9svvy0OkmNYFW1RdkulZhqwZTtml4F5B0sOymoREnZKjs5yl526OfcPxcjyK3sJDGdpEei6qNF5uNhO+2ZKxcv/7Lgp7z2aXA8aBWGe4KuyUJPsXTS0qbsP75rCnWHEngEM7NsgPB5S562Yz5/SxEeFU+lRiAb7QwtWlFya6e9XxxFnRghCy3rzP47ZYo+WrdxC3dBABgD07Zd018UFxEmRBEiZjQIZIY/HYG5v3BMOpisbl4AwEVmq+oPrZMll+Ncdi5Xa0W+8P3dXBxHtjq6vjpCaVt4tZSIOR908iDU0W1QCS6MHoLz9AfGrvKnZ7Ksxwd/LpGgbDm9JfbTDNYWp+/CGcP+4Ct8oDqaf0GW0d+bhtdGPD12kjTUfFUnq0FZ3AYEuBW0ZXJAJabsI9/TXUw7Qsg23ETkfwkAgrFymIL08JtGT7ntNDnOF1RFv3jDh/VDyNMml1mCsQqvCasTR38Ynyj0XWMrHpHtxqOw2GizYLYvOY/2+hxmnYw7Fclhz5T8E3+JNWliZOg+dd2XZU6g6zhWq3bYdObqFCdtfpo75IOeEBamfO43aL+u3ih0bdjH0vZW398zlA4w+2IT8JqKcJu01ERKC2LYRq0IcpVNhQxUion4GdfIa9vaU1TiSUjaQe/y76A3KFAJimOIv6H9cEvlV/foqXq+5Cp55rkksEPNiKQR1jsbBtDWnCzDqFKpDcn3o05eAUiDMNiKgnLQozQDgxLa5pg7imxZ9aKZbOv1WQEIJss8UiH3jO5XDqxSirjZw+Jjd1Y6pRZpqaPxpkEApBQw4ZhwBpmxk7Td8ffFJ0jGlu7C5JdzjTbEc4gqCDHQB2vDgvzjbB6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(346002)(136003)(396003)(376002)(54906003)(6916009)(66574015)(316002)(66946007)(4326008)(66446008)(66476007)(76116006)(66556008)(86362001)(55016003)(186003)(33656002)(2906002)(8676002)(9686003)(7416002)(8936002)(5660300002)(52536014)(478600001)(53546011)(6506007)(7696005)(122000001)(71200400001)(38100700002)(26005)(83380400001)(64756008)(41300700001)(82960400001)(38070700005)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?XW5sLRtiLOAWCeel4ggQ2pgmq+uOIAKXiqXPodHcIXFQzUPiYJtCdx8NR2?=
 =?iso-8859-2?Q?ZcJB5YD6mHNFFDOwj91kYqQVkVYqfRoMIE+aLyBS0wPLMuikt8QHgTECvP?=
 =?iso-8859-2?Q?gXnefT9I2yjVRtP/wf7nn+Ujrei/IUwZn7NvJhPeYTMluZKTCvykud64Jq?=
 =?iso-8859-2?Q?uQ4lANplnpd+bIjSlMjsNpTWzcNcHwyx5REIBXK/DNtpsf0yG50EB3DxGi?=
 =?iso-8859-2?Q?7aSJ8/cfgV/c22H7IC3pE9g9ocwD9F2aordaaiiuKVOuPxhW4F4Z4p2nik?=
 =?iso-8859-2?Q?GUEOW3lksiXB7zRGwpb/FDjnxq47pg4BFOUxadghGglhwyd8nR421F9Qbl?=
 =?iso-8859-2?Q?5Bgk6KmGN3/LcYwRk8bRyGhsBQurU11onEYkrhcTLXarjua2np7daZR9HV?=
 =?iso-8859-2?Q?+M0ixoCLy2oOUc0TrHcQy1zvgVqCYmfJpGCK3Ec5HdHfOfuAc/4fKnlX/Z?=
 =?iso-8859-2?Q?M9rV2Oku2j4Y2mknkT8RS+cD0zYiXmNWCsBM+Cf9nsxyOHQlM8Bny5IVT5?=
 =?iso-8859-2?Q?ZA3viVm6XeZermTNmqpGZzruI0ca6lf+G9UhOPIr4JLnl87qswZTcsGBkb?=
 =?iso-8859-2?Q?HXIjg+Cyb+tIdQmBgkcHpyUdBVE5A6q4et5OIQUiU5tEdB2Dl85TkD/q1U?=
 =?iso-8859-2?Q?lhXKTTq1OTm7HuON4eNQ6ol5qLPsKaQDAqWqEivoWPLlKP7XD26ZZy37JR?=
 =?iso-8859-2?Q?29Uyu3t1LwuHllnBrf/2Uj7LyASnDlX3Onsc87V9Bnnpwre3d6Ce8oxFeW?=
 =?iso-8859-2?Q?sx//9gx5IyDz1Vy5gTWKUezzCkYHxyNk3BhPESWZiQrWjqDCbxgZc32p5a?=
 =?iso-8859-2?Q?LCtt1ZNOh7aMjocJAhi/vj9gFcA7n+VBKUPCPbKcEV3HYJdDIzVm6ZytuC?=
 =?iso-8859-2?Q?tkG9XU6zXD+omp3kLKDiKWS+PLm/ia1ptD4c8PAN6tj61SNsUR1ci/twZw?=
 =?iso-8859-2?Q?k/jJCI3wBScIvTkZFpXuv7kj1tGNRmBVFUbXe6Y5ozNDo1yxoY4CWq2hB6?=
 =?iso-8859-2?Q?zA2lQIrswoYIuRJ8XI1/Xi5bYlTk4JzPW84BsZ0VSUoAacyUhwHN6lbC9w?=
 =?iso-8859-2?Q?y7TsuErDb+SKw7fH1Swo8AbQcLE6lJvNgiiXA79F1Gq9nRdmEh3GHsEXFT?=
 =?iso-8859-2?Q?jbJ6IQV9oaRFQQEK9CXJjgVP3OeMJ/WiCkxZSrw1vlfSW0m2MXOFDbrLjT?=
 =?iso-8859-2?Q?eJhKXWoyub/m+6a2xgoV/b2wzHLvhk5foFi3EsT8rwIGLd42EeGQE/vxxu?=
 =?iso-8859-2?Q?jEH8djiF6MpYAXImc4pQOHEm9QCOPSIYCSjUa+BKdMhaJfJwrBSL6iuDLr?=
 =?iso-8859-2?Q?M9u3VmQzJGXpMt+oksRMrPyBF9t2E61kI8lU86dIyvpWqAksLkAKilUSOk?=
 =?iso-8859-2?Q?dGA1iUpkkVqosodcpdBoYP5j1rvyv+Htp05tFSwTUhfno5yHpy2IsHqYBi?=
 =?iso-8859-2?Q?Nu7tiEC7q1+xYUj+GjbORD3ViBXz+lLB9QSUIFLmHt94GV99nnZtUAPW21?=
 =?iso-8859-2?Q?B3gWe77pcKwUeaMWWoZd1skj7WZZvuWAtqcXK1qCIUZJcTapo9XPIWffA7?=
 =?iso-8859-2?Q?aY/nojZyzhYgVl4YOAjCsiVvBoT/KReiAiUReh9ocYuveBNHm0GBj5D4J2?=
 =?iso-8859-2?Q?JTJoNlv1BODgJ8HAdGdAIkcwIXxitRfqws?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65935b21-5fd8-4992-3295-08da5b664ccb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 13:33:35.9367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mInNMUTbK1uHYMPT2QtsbL/74CR4I5xb8hZElh086KhPX+Ath57eUTRuE6kGeqVASuAgYPBwmmnVQwXzqQ/BnrazIUuI5pxMimiM8YLfNM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4716
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
> From: Guillaume Nault <gnault@redhat.com>
> Sent: pi=B1tek, 1 lipca 2022 14:42
> To: Drewek, Wojciech <wojciech.drewek@intel.com>
> Cc: Marcin Szycik <marcin.szycik@linux.intel.com>; netdev@vger.kernel.org=
; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> davem@davemloft.net; xiyou.wangcong@gmail.com; Brandeburg, Jesse <jesse.b=
randeburg@intel.com>; gustavoars@kernel.org;
> baowen.zheng@corigine.com; boris.sukholitko@broadcom.com; edumazet@google=
.com; kuba@kernel.org; jhs@mojatatu.com;
> jiri@resnulli.us; kurt@linutronix.de; pablo@netfilter.org; pabeni@redhat.=
com; paulb@nvidia.com; simon.horman@corigine.com;
> komachi.yoshiki@gmail.com; zhangkaiheb@126.com; intel-wired-lan@lists.osu=
osl.org; michal.swiatkowski@linux.intel.com; Lobakin,
> Alexandr <alexandr.lobakin@intel.com>; mostrows@earthlink.net; paulus@sam=
ba.org
> Subject: Re: [RFC PATCH net-next v3 1/4] flow_dissector: Add PPPoE dissec=
tors
>=20
> On Fri, Jul 01, 2022 at 10:53:51AM +0000, Drewek, Wojciech wrote:
> > > > +/**
> > > > + * struct flow_dissector_key_pppoe:
> > > > + * @session_id: pppoe session id
> > > > + * @ppp_proto: ppp protocol
> > > > + */
> > > > +struct flow_dissector_key_pppoe {
> > > > +	u16 session_id;
> > > > +	__be16 ppp_proto;
> > > > +};
> > >
> > > Why isn't session_id __be16 too?
> >
> > I've got general impression that storing protocols values
> > in big endian is a standard through out the code and other values like =
vlan_id
> > don't have to be stored in big endian, but maybe it's just my illusion =
:)
> > I can change that in v3.
>=20
> I don't know of any written rule, but looking at other keys, every
> protocol field is stored with the endianess used on the wire. Only
> metadata are stored in host byte order. For flow_dissector_key_vlan,
> vlan_id is a bit special since it's only 12 bits long, but other vlan
> fields are stored in big endian (vlan_tci is __be16 for example). And
> vlan ids are special for another reason too: they're also metadata
> stored in skbuffs because of vlan hardware offload.
>=20
> But PPPoE Session Id is clearly read from the packet header, where it's
> stored in network byte order.

Thanks for explanation! We'll use __be16 for session_id since now.

>=20
> > > Also, I'm not sure I like mixing the PPPoE session ID and PPP protoco=
l
> > > fields in the same structure: they're part of two different protocols=
.
> > > However, I can't anticipate any technical problem in doing so, and I
> > > guess there's no easy way to let the flow dissector parse the PPP
> > > header independently. So well, maybe we don't have choice...
> >
> > We are not planning to match on other fields from PPP protocol so
> > separate structure just for it is not needed I guess.
>=20
> FTR, I believe it's okay to take this shortcut but for different
> reasons:
>=20
>  * When transported over PPPoE, PPP frames are not supposed to have
>    address and control fields. Therefore, in this case, the PPP header
>    is limitted to the protocol field, so the dissector key would never
>    have to be extended.
>=20
>  * It's unlikely enough that we'd ever have any other protocol
>    transporting PPP frames to implement in the flow dissector.
>    Therefore, independent PPP dissection code probably won't be needed
>    (even if one wants to add support for L2TP or PPTP in the flow
>    dissector, that probably should be done with tunnel metadata, like
>    VXLAN).
>=20
>  * We have gotos for jumping to "network" or "transport" header dissectio=
n
>    (proto_again and ip_proto_again), but no place to restart at the "link=
"
>    header and no way to tell what type of link layer header we're
>    requesting to parse (Ethernet or PPP).
>=20
> For all these reasons, I believe your approach is an acceptable
> shortcut. But I don't buy the "let's limit the flow dissector to what
> we plan to support in ice" argument.

Again thanks for explanation. Sorry, I didn't want to suggest that flow_dis=
sector
should be designed based only on our needs. We are happy to change our
implementation if requested.

We will stay with the current approach if this is the conclusion.

>=20
> > > > @@ -1221,19 +1254,29 @@ bool __skb_flow_dissect(const struct net *n=
et,
> > > >  		}
> > > >
> > > >  		nhoff +=3D PPPOE_SES_HLEN;
> > > > -		switch (hdr->proto) {
> > > > -		case htons(PPP_IP):
> > > > +		if (hdr->proto =3D=3D htons(PPP_IP)) {
> > > >  			proto =3D htons(ETH_P_IP);
> > > >  			fdret =3D FLOW_DISSECT_RET_PROTO_AGAIN;
> > > > -			break;
> > > > -		case htons(PPP_IPV6):
> > > > +		} else if (hdr->proto =3D=3D htons(PPP_IPV6)) {
> > > >  			proto =3D htons(ETH_P_IPV6);
> > > >  			fdret =3D FLOW_DISSECT_RET_PROTO_AGAIN;
> > > > -			break;
> > >
> > > 1)
> > > Looks like you could easily handle MPLS too. Did you skip it on
> > > purpose? (not enough users to justify writing and maintaining
> > > the code?).
> > >
> > > I don't mean MPLS has to be supported; I'd just like to know if it wa=
s
> > > considered.
> >
> > Yes, exactly as you write, not enough users, but I can see thet MPLS sh=
ould
> > be easy to implement so I'll include it in the next version.
>=20
> Okay.
>=20
> > > 2)
> > > Also this whole test is a bit weak: the version, type and code fields
> > > must have precise values for the PPPoE Session packet to be valid.
> > > If either version or type is different than 1, then the packet
> > > advertises a new version of the protocol that we don't know how to pa=
rse
> > > (or most probably the packet was forged or corrupted). A non-zero cod=
e
> > > is also invalid.
> > >
> > > I know the code was already like this before your patch, but it's
> > > probably better to fix it before implementing hardware offload.
> >
> > Sure, I'll add packet validation in next version.
>=20
> Great!
>=20
> > > 3)
> > > Finally, the PPP protocol could be compressed and stored in 1 byte
> > > instead of 2. This case wasn't handled before your patch, but I think
> > > that should be fixed too before implementing hardware offload.
> >
> > We faced that issue but we couldn't find out what indicates
> > when ppp protocol is stored in 1 byte instead of 2.
>=20
> That depends on the least significant bit of the first byte. If it's 0
> then the next byte is also part of the protocol field. If it's one,
> the protocol is "compressed" (that is the high order 0x00 byte has been
> stripped and we're left with only the least significant byte).
>=20
> This is explained more formally in RFC 1661 section 2 (PPP Encapsulation)=
:
>   https://datatracker.ietf.org/doc/html/rfc1661#section-2
>=20
> and section 6.5 (Protocol-Field-Compression (PFC)):
>   https://datatracker.ietf.org/doc/html/rfc1661#section-6.5
>=20
> There should be no reason to use this old PPP feature with PPPoE, but
> it's still valid (even though it breaks IP header alignment).

Thanks for explanation! From the next version we will support both options.
