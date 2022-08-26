Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3845E5A271B
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343571AbiHZLwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiHZLwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:52:12 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2322DD5723
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661514731; x=1693050731;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bp3cQ2v+AeO7daptpIwWaudyRBDqRHB3G7Ng6IZpOhE=;
  b=DaGJ4uHkfXTXBOaXsRh0GOT93jrYiEiYn2/h7RfU+RFP/tAZrRjS1hKu
   O8A5NmZuTLUSM8JTUDWBoRoDhLEbiqmv36m1k/T/25/4ACcUpa0npxeub
   uXKEEQf7lYKbTZ3KNYHo5+lvuQsW49rh3Wc4/ICicbodknedfv3Q7QgN0
   UomhPBCP+RGGasHNDFHFKArhJp6xQRUAVX2M0iEjtinxzfrf/79Rkpgpy
   pJluF3hRvl80h7HWOuWM7ByxNXaI1BSPnprGgns2IinQWLOKqhAh1Ob6I
   eRiSKaLCm/cE9AWsJxRLPh8llZ/VCTNFkN8k5DjjnODjcBh+hXAGAmns3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="295268009"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="295268009"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 04:52:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="855985491"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 26 Aug 2022 04:52:09 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 04:52:09 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 04:52:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 26 Aug 2022 04:52:08 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 26 Aug 2022 04:52:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9pIiJmHHyzNX6K3v3jfsDDKIVc/Q/lUXtdibq55pjsSXRzIhbC25L7+za/5qmqhVvDMp7I47DQJ5IWguf8QgoYOjFIWQxAx4baQJErpr9pxK3FMQ+8VbrprVxHOrDvf8mi5dje7hozqn+osPtdjPtS02Fhmtosj63KyXOjjtKKaxL9wvu/un+sG3mdsUxi/OgQOZDDEREXaz6+A4VybcMrSUX+cCejysu4M/wpmjQVMlfdWZzvn0FqZxsKNzcLY2Yy3jTf9px5Ca032Yz+ArgxZC9SofUwGw6U6MYqo8fSKYQnSKZdC/y9at44vPow1FD2B8XydHf/yNyANE8oTcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q4iUb/8saiMzU1iYA8+2scyTlST9mPsYqXkkMXUy8+s=;
 b=dBK7fWwhiDJL+UV5mFxJVy/GAEppRk8W6sg3ZmrJlZl0GrbrE3U+RSl37ZbjK/75gDZRTB8GtI04o3tf3HgH3Cj2aX3EJ4e13BsafnpWBzidA5J9s1mDmK00M8F83QfM32YfWk/sDNrm4IaZ9yJk8ZTOZ3DAuZRZUph30drtG8qvy9RCSX2NyhXgZYBjHaOjporoIiJJZmhOxCkeMJNjJJcXGxAfkJ2oB1A9PT0FWOrn+8rHnAwVLrYW0cbpNJlee6QH2IJ3wgXx/SqWN1QdudVrHqXmnkRhelnLnmI86R5W3URq061CfEOkatdvT4C0sSGleAGoOLmkpkjZnptb5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by SJ0PR11MB4815.namprd11.prod.outlook.com (2603:10b6:a03:2dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 11:52:06 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::545c:d283:fbee:973b]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::545c:d283:fbee:973b%6]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 11:52:06 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "louis.peens@corigine.com" <louis.peens@corigine.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "maksym.glubokiy@plvision.eu" <maksym.glubokiy@plvision.eu>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jchapman@katalix.com" <jchapman@katalix.com>,
        "gnault@redhat.com" <gnault@redhat.com>
Subject: RE: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
Thread-Topic: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
Thread-Index: AQHYuT1EGbXS/DMrpk2b1r4Lo3Z3HK3BCpnwgAAGW2A=
Date:   Fri, 26 Aug 2022 11:52:06 +0000
Message-ID: <MW4PR11MB577639450F79C109465BC48CFD759@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220826110059.119927-1-wojciech.drewek@intel.com>
 <YwircDhHhOfqdHy/@nanopsycho>
 <MW4PR11MB5776E6C92351788A0E55B6CBFD759@MW4PR11MB5776.namprd11.prod.outlook.com>
In-Reply-To: <MW4PR11MB5776E6C92351788A0E55B6CBFD759@MW4PR11MB5776.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: f2b07b1f-8194-4fb6-f2fc-08da87596675
x-ms-traffictypediagnostic: SJ0PR11MB4815:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dxs5cEYv7rkkObVX6nVW78vh0o1EEyK8yAsMSXkbvxGwnKlhQPaiChkUTpASxJ1kzchlOmvsx+R4NUAziX4hz1llQvH8w0mywraA+i7qUgd+AlBVuF5/N1V/LeM7VBYC5D8DTEsWrfLqCcOEsfhyQMaHFJVtphc9wRxxX0ymd1Zv7Ugf44TBsIeKAmJ4hEowPyk0XH537pj+QgvvtTWLWFXHjDjsf2Ql9x4L5pKAmX+ociMgQnAkkjtptyoibaYaMbEk7/xYQKGeFGjmF/HB9ex5S8OEhcgQ3MP73/towD3zHkOuuYO5c8nzqOajUo7RAC/xd3CfEVjHzeVywUlQUhUjXWqFpWn31FDXlxz70zb82jAlty3dNWODMOLj+43Ifj0xdDqNTBoSdE9qiTyCSKNOMeE6yVOMj8GGf3Hrj5h4BM0mRqCz6UQfLnDHO2lnRkm55zXpB6v+GwnlPTEBWIa1vIP8S0H2FXyOyVD0+XbJiCIZRv1Nh8rwy70TVnWxgzljFv5svDDypChoK76mdcsOgrlrXnwx0aNsifU56OX9V1pv2EqIVlhQXeIH4m+EtOpM0hJZKxD4Hqat1STv86XI7+ti0QP+1we8Ew/8fP1xkGsA56OLb48AcEzSkRkWgJ2MpjYW01AGLVYiUEz2xn7CLcOidgvoMvpzp+YEhxK1eYlmnggsxCMneluaRVKmYikS2DOVeelquMI0QEZfp4U+WYIvVGlNUqnloaBGr2w70U5lt7da2lsIOMnlWkEBq0LkP9yBpqB6WbKu3EfKG5ghPnowxSxWzEVPIY5lyMf0g4+eh1SGGT3EeqVGi4loDMMBJE1AawhnwxwajUaaoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(346002)(366004)(396003)(7416002)(52536014)(8936002)(478600001)(966005)(7696005)(33656002)(86362001)(26005)(5660300002)(2940100002)(41300700001)(9686003)(53546011)(82960400001)(6506007)(2906002)(38100700002)(122000001)(55016003)(186003)(83380400001)(38070700005)(4326008)(66946007)(64756008)(6916009)(76116006)(66476007)(54906003)(8676002)(71200400001)(66446008)(66556008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?TOXykPn8RHE+eIBXqZyfGjKVe4Yl+kfo6y/4dpnnDS+ALgWibA9pO+yl8Q?=
 =?iso-8859-2?Q?fe/jptwSeoHF+2qjpXtBYuPqMS5jksMtrNOnxNKLHx4TEUP8oHwaqGgjhF?=
 =?iso-8859-2?Q?Gj/c+ED7V4p3k9nUAL/QSVlfUtQNHlfXiKUN/xyDSkUiqliLhOw2YkiK83?=
 =?iso-8859-2?Q?LOnOZzYIncXIepC3JcxaeLw6mPgttdI54bi9BwoLDqns5Z/jvNPXzFqcgm?=
 =?iso-8859-2?Q?A2SbDFq1IgYCLNwmiXVixERTiK95Oa4f8KxxbLcLrlmwkODRUJSlEsNeZY?=
 =?iso-8859-2?Q?xAr9/V/d3wUnahIJbNVB6eME4Amlh8m+Vkb9sbhPnhGzaN972kIr9A14Zf?=
 =?iso-8859-2?Q?LbaZK1nlOmru+a/9Z8SlJLW6ztzdG1W5ip1BHNp0JXKyash70b6wtUtmYw?=
 =?iso-8859-2?Q?dW9GBMyAyTIjxidD9SiNt8dMZjAtDp0rF/aUM4eal+9qNbdmzBD0UyMeq1?=
 =?iso-8859-2?Q?YkTDQpiUHBS4TQBt6hzdw1ktwY4enUMDZG+9ST4YdCSPiNgsL7bV+VLB8J?=
 =?iso-8859-2?Q?DbN2YI6k2Js1OKXV9NxoYBuWwKD6YNkVzwBjYT0pEmVjm9qbvRBRKBpVCR?=
 =?iso-8859-2?Q?WXnFn3Mjdeq79/udl+T5lxOb+MKKbrnkvTu54HDXhEsiWEkf07Yj4h1rYg?=
 =?iso-8859-2?Q?4q3H61IRr60Ejf6zTNWRgTX1WZjovUc/jt1waLY+uPAphGV6ZSx1nV0INu?=
 =?iso-8859-2?Q?BfHmWYV8EHFGOqfeneuHYp7VTOzgTTe1sSDRJDw5w1TxUMqozQj54nPxfv?=
 =?iso-8859-2?Q?GXgppecZIG/XqcoRUiI9RmmjR0sSkWhEF7/8G/85xOzsblVuxz20MbLzI/?=
 =?iso-8859-2?Q?AGbKHXVmZ1MKj4/tGnMH4muvmvt7a323s59c0lDMjdwUVULP3rB4PE+SHB?=
 =?iso-8859-2?Q?H3kWZ8HcZB2qzoDH5wIZbbxp629BDPXPpWj9wjHpf1j1805D8mC6UGOH6I?=
 =?iso-8859-2?Q?NcrowKBpno5NGzcs6HCD8AwRMHIr2LPZw6ctIvTwXM6z0gT+58n7VWFw+y?=
 =?iso-8859-2?Q?P4mp3htcoliIumol8/x8r8+5U5cFVLanBc+RzNgUBSpSGYS68mxHFFPQg2?=
 =?iso-8859-2?Q?HIb1dl9F8XgmRtbKDDKZYWMnyO3OaRYyAYWp3WUADAwdqDf9u9slsuJuer?=
 =?iso-8859-2?Q?dXnIsomDPo8oncsGjm6InU7EkP8xsIQ60ILQEW2NQnIfqNegCguxZ8k/bn?=
 =?iso-8859-2?Q?/MrYIWHxCeMZ9bGSi+6QXnzK9ekw5Sp3k3qB4ZdIqMKwQE1p4x5LY6arW7?=
 =?iso-8859-2?Q?/IP0sEIZZ8PUK1KO1YqxxyU0hcjwCV1zMa265sK3pCFs+mZBiAklfGArI/?=
 =?iso-8859-2?Q?InsSOJkddjAvcFolhsy63//z9/pnS8Qp/kClw4vCnE3BS0GVM/J5QJxgh0?=
 =?iso-8859-2?Q?mgNgY6ZKp+Pi9ZdK2DW6COA3r+KR8DmtnN4tVN6iDdx5Pc8u4Hn4cTdu49?=
 =?iso-8859-2?Q?Xy/0bpd57zjQi4+6frChGd0ly1AK3R1UZ4sgFQmLtr/4gax6QqXxUQI6NG?=
 =?iso-8859-2?Q?5GiisEfCknXQInjGFUM/VmpHwlbJbzrtYc/klS0R4qQpvLnrTVv6yygWc8?=
 =?iso-8859-2?Q?kjr1UjhBqn51kO7E/C06shMhhMVtnWKlBir7NXcKwhV1iTn55fpd7hxpf9?=
 =?iso-8859-2?Q?md1W9iT7hQt2o0OBG5nTCoyy0HyVplUIXq?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b07b1f-8194-4fb6-f2fc-08da87596675
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 11:52:06.6879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImGQ/2g3EkUBEkh51FZd9BeuaWdMFzm5E+Yhazo43oMNHyJn9XYR+b7dl2f1Zknm95qh4HvBEu5BAYgH3tCWSRWd1ysElv0dfvxWHsA5Mk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4815
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Drewek, Wojciech
> Sent: pi=B1tek, 26 sierpnia 2022 13:37
> To: Jiri Pirko <jiri@resnulli.us>
> Cc: netdev@vger.kernel.org; Lobakin, Alexandr <alexandr.lobakin@intel.com=
>; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; edum=
azet@google.com; kuba@kernel.org;
> pabeni@redhat.com; jhs@mojatatu.com; xiyou.wangcong@gmail.com; marcin.szy=
cik@linux.intel.com;
> michal.swiatkowski@linux.intel.com; kurt@linutronix.de; boris.sukholitko@=
broadcom.com; vladbu@nvidia.com;
> komachi.yoshiki@gmail.com; paulb@nvidia.com; baowen.zheng@corigine.com; l=
ouis.peens@corigine.com;
> simon.horman@corigine.com; pablo@netfilter.org; maksym.glubokiy@plvision.=
eu; intel-wired-lan@lists.osuosl.org;
> jchapman@katalix.com; gnault@redhat.com
> Subject: RE: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
>=20
>=20
>=20
> > -----Original Message-----
> > From: Jiri Pirko <jiri@resnulli.us>
> > Sent: pi=B1tek, 26 sierpnia 2022 13:16
> > To: Drewek, Wojciech <wojciech.drewek@intel.com>
> > Cc: netdev@vger.kernel.org; Lobakin, Alexandr <alexandr.lobakin@intel.c=
om>; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> > Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; ed=
umazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; jhs@mojatatu.com; xiyou.wangcong@gmail.com; marcin.s=
zycik@linux.intel.com;
> > michal.swiatkowski@linux.intel.com; kurt@linutronix.de; boris.sukholitk=
o@broadcom.com; vladbu@nvidia.com;
> > komachi.yoshiki@gmail.com; paulb@nvidia.com; baowen.zheng@corigine.com;=
 louis.peens@corigine.com;
> > simon.horman@corigine.com; pablo@netfilter.org; maksym.glubokiy@plvisio=
n.eu; intel-wired-lan@lists.osuosl.org;
> > jchapman@katalix.com; gnault@redhat.com
> > Subject: Re: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
> >
> > Fri, Aug 26, 2022 at 01:00:54PM CEST, wojciech.drewek@intel.com wrote:
> > >Add support for dissecting L2TPv3 session id in flow dissector. Add su=
pport
> > >for this field in tc-flower and support offloading L2TPv3. Finally, ad=
d
> > >support for hardware offload of L2TPv3 packets based on session id in
> > >switchdev mode in ice driver.
> > >
> > >Example filter:
> > >  # tc filter add dev $PF1 ingress prio 1 protocol ip \
> > >      flower \
> > >        ip_proto l2tp \
> > >        l2tpv3_sid 1234 \
> > >        skip_sw \
> > >      action mirred egress redirect dev $VF1_PR
> > >
> > >Changes in iproute2 are required to use the new fields.
> > >
> > >ICE COMMS DDP package is required to create a filter in ice.
> >
> > I don't understand what do you mean by this. Could you please explain
> > what this mysterious "ICE COMMS DDP package" is? Do I understand it
> > correctly that without it, the solution would not work?
>=20
> Sorry, I'll include more precise description in the next version.
> DDP (Dynamic Device Personalization) is a firmware package that contains =
definitions
> protocol's headers and packets. It allows you  to add support for the new=
 protocol to the
> NIC card without rebooting.  If the DDP package does not support L2TPv3 t=
hen hw offload
> will not work, however sw offload will still work.
>=20
> More info on DDP:
> https://www.intel.com/content/www/us/en/architecture-and-technology/ether=
net/dynamic-device-personalization-brief.html

To be more precise we need COMMS DDP package that supports more protocols (=
L2TPv3 included):
https://www.intel.com/content/www/us/en/download/19660/intel-ethernet-800-s=
eries-telecommunication-comms-dynamic-device-personalization-ddp-package.ht=
ml

>=20
> >
> > >
> > >Marcin Szycik (1):
> > >  ice: Add L2TPv3 hardware offload support
> > >
> > >Wojciech Drewek (4):
> > >  uapi: move IPPROTO_L2TP to in.h
> > >  flow_dissector: Add L2TPv3 dissectors
> > >  net/sched: flower: Add L2TPv3 filter
> > >  flow_offload: Introduce flow_match_l2tpv3
> > >
> > > .../ethernet/intel/ice/ice_protocol_type.h    |  8 +++
> > > drivers/net/ethernet/intel/ice/ice_switch.c   | 70 ++++++++++++++++++=
-
> > > drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 27 ++++++-
> > > drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  6 ++
> > > include/net/flow_dissector.h                  |  9 +++
> > > include/net/flow_offload.h                    |  6 ++
> > > include/uapi/linux/in.h                       |  2 +
> > > include/uapi/linux/l2tp.h                     |  2 -
> > > include/uapi/linux/pkt_cls.h                  |  2 +
> > > net/core/flow_dissector.c                     | 28 ++++++++
> > > net/core/flow_offload.c                       |  7 ++
> > > net/sched/cls_flower.c                        | 16 +++++
> > > 12 files changed, 179 insertions(+), 4 deletions(-)
> > >
> > >--
> > >2.31.1
> > >
