Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E056FFCE
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiGKLM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiGKLMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:12:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F64237E3
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 03:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657535036; x=1689071036;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uqrlgE6WX/wyZV5fVXmYIgUw0lCEgZFe3Xy1bwsVCVM=;
  b=KeQTeeG7wZHAJQYMr+Qnry0jxlCCjKWKuKUefNGkr/mIe9RyrV9my+S6
   dr3TmOSwDP13+oV8Me+W256qTuhEjJ7Jv6zu0dXcUnbuNsMFAF00PqMec
   dEUzDWq+Kk6fW6WEP6myFigHjq4sNDcWP2jgqRmExqL1Ju7gHzbYtce6l
   uPMXPRYcX/D4lVS9tv31/k//wenOhCO/D1yCJvQVltfx3Udvp0Bxm6Bhf
   jF3RyKuJkwbnbl5ZXgNy6qDTorMvFV6wEzwTFRTDY/Y1AL70RpwE5KDIX
   cu4ZcGXB/tCRYCQgqryj7FtOM6B5pdVxXNyCtVLl0ofV8IppNP+jWb8RA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="264403634"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="264403634"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 03:23:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="544960212"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 11 Jul 2022 03:23:55 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 03:23:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 11 Jul 2022 03:23:54 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 11 Jul 2022 03:23:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMNUxHeyvWRQnVd5xthT2H6+YjoWp4T+XLiLhRr7hPO/leQHuOv9lYAPfmKOnwrEKMHlU4o1OCjaYk845p9y2TETQNDXacYQJ8AIijZ69GpdZb6PPWNWCRjXuKPdpnocJ4S4PDz9yD9BfLSYkL5h9yJ4F0UGAnGz5qqWxlfIuXQLJywdRpWMyRC4TG0ZbIJ2rGwPiKZmENeWjsumofCD0SjNda7coJbhGMfNEafOu67WypC7k/qnuBWzsnCjfO504pz3y+jnSwKcyrujo35pHo2x65htsla8MoVW5MfRrZIKMY87PcuB8qmOD6oxn8w+REi6ZZhAb3AvOnywpG4+NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pmq7dtqUAGEPyMcpWEMY/WDXyUfyJgIex80zvElv9ag=;
 b=ZpN5lvL20QstWC/AqelVQCc8WrrQ+bbpJCZAy6E1skaW4o90mPNK7IjXoAb6Ynmevz25uZOM+k6zJUdpwGkaqdeawfvb1kobqiKtI3/mnLeR8BuWR6uo/+4qGHhLcocFRzTLhwdgJuJF5ouPdIkMalQrNWQ5hfRaPuTsnusmypxRQq0lZWW5p3CqEKRfCszQfdJWfVyBNXajm4aLTCU359MPKnPkWkqCeoUEjo6h7VB1XP9RtEpAMIn4O5uSolRh2oGfCjNzxm1ESws0ouXTKdxWgNQ4o15mAFR3BgWR+fGMI9LujnMOLEsi7dMiQjiHmX2gKGX0dbTaMrJCLCXs0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BN7PR11MB2833.namprd11.prod.outlook.com (2603:10b6:406:b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 11 Jul
 2022 10:23:50 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c%3]) with mapi id 15.20.5395.021; Mon, 11 Jul 2022
 10:23:50 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Guillaume Nault <gnault@redhat.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Subject: RE: [RFC PATCH net-next v4 1/4] flow_dissector: Add PPPoE dissectors
Thread-Topic: [RFC PATCH net-next v4 1/4] flow_dissector: Add PPPoE dissectors
Thread-Index: AQHYksXA2PqqPPPZHUuJSl7+xdE+Xa101dMAgAQb8zA=
Date:   Mon, 11 Jul 2022 10:23:50 +0000
Message-ID: <MW4PR11MB57767AD317D175D260362539FD879@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220708122421.19309-1-marcin.szycik@linux.intel.com>
 <20220708122421.19309-2-marcin.szycik@linux.intel.com>
 <20220708190528.GB3166@debian.home>
In-Reply-To: <20220708190528.GB3166@debian.home>
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
x-ms-office365-filtering-correlation-id: df8ad37e-fe04-4492-0bf4-08da6327726f
x-ms-traffictypediagnostic: BN7PR11MB2833:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ggz/ubh64pqdDcRwpPcQSDO+ge3X+gAahQoOPFRQyi3kESX2BznkuftonZlu9tYLxrTQvBkorQFvQfBLrDCj21/WWHOhi8HaJL6F7h4fDJcMtNFrjkHiHKHGhd2wnYArBktYakrNgr2khTib28GbLFz1MO5cl2XPIV24/bQvF9Uy15GfkuggkiAHVQX6Ce4vOf8460GnObLKdPtcw4VS660ODdU9OqtTc06I8gNfyaSmEzWoE6cRPm4UeJzgnnABscpgH1n9cnEKK6prxLkBAL37Uf4d4wGVQlCAYFbA6cvegHNsuqh5h4Na4qpkoEI0ew11hN+XG7TKoRyb+SvTCaQ3YILaW7CX/CrMM2be/wQl3qBL6RqO1SguvpRMezI4FPX0a28k1DwV3pFc0mG2taafwOaqrB09ghw72fmZKUsHAxcxNv+5G/LkXwsjaaztB8N8hAPgJ7MrZ3zPLjHjaGAddLd2TkljPeCc/f87J1xYrwhnB1rsFA27cuUSzzxIEacugWh7Xq6DtZuZWIkgmt7Z3w0iOvF3YLXHA8XypzE0yfOE1zm8FnVjxgdWbyXl8MR4cetZ92p7eAahrPxErSNlK8aljIev/oyTf9Y5KQIsOMsf2XbfkatBK7ZyRU/hHNQpcuWd51q5T089NCZWP33+M9ZPs5tUi6uTxJmCwEqTA4AGYAGqszutDVK2seySwo14PlQWC/tEZ2QfzH+CaSx/sOr9JB7JMHNGE/k3Z56zfcPWN32sjQ1qVHGWECU0AE0uTbtvDO0qub9NBeTA3ILUC9yaZRRQiO3Vy3jtO1CYq01lm5hsusV8miWXPbDp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(136003)(366004)(376002)(39860400002)(186003)(66574015)(83380400001)(8676002)(316002)(71200400001)(66446008)(66476007)(64756008)(38070700005)(76116006)(66556008)(66946007)(4326008)(82960400001)(55016003)(110136005)(122000001)(54906003)(53546011)(7696005)(38100700002)(41300700001)(86362001)(6506007)(9686003)(2906002)(26005)(478600001)(7416002)(5660300002)(52536014)(33656002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?RmVgFZ3sbuaUCnw7+3DIOTKwB9zPSkwGRDUwSMBITYtr7EphgWEB/Ywt6v?=
 =?iso-8859-2?Q?oVnvBTM0jOIWjBsuFumIYfm8peiyXzUdAktPXjT6aUv3HFxh3Ydu24hjqO?=
 =?iso-8859-2?Q?WGTSzkdOZeSv8dc4hTrPrI7i8r2miJDZ4mgNoe/JXp+ZRBgQ5aX0AZVCeT?=
 =?iso-8859-2?Q?gwC7pJkKfdn9J6PsB7MZRL8Um7t1182bPyD3jnoMAXyd5sqk9gch8K84yt?=
 =?iso-8859-2?Q?rW9AdE/yu4zHPxY+tyt3KuESqu70mSyLFxEYvReKBEJBcy16iwNV7YzrgF?=
 =?iso-8859-2?Q?SgFiHh3emPHGBFDfF1W6vbaaOb+/eYLO0zkf68NovrV0AkPcOGJMEmMTij?=
 =?iso-8859-2?Q?0tISyT8CT5wwY+f4CBrBHWKopOhhcCSiujyUKJG+2GeiAGcDGUsIlH+dbu?=
 =?iso-8859-2?Q?cQJPngge02gnF2aYn09SlhNO58CXycwaGZ9Rg/0N6Xhv8jqwjXJVxd8BoP?=
 =?iso-8859-2?Q?6S9boEq75O6teWCH9hJoGxEaELgy7ghSy1UJEOw8UzTfRdIogZGUgJnNVt?=
 =?iso-8859-2?Q?kBlGmuiF7F9AkZd2vC8TVXYAOFfc5v9hPDG0B3FRVY52JIqUb19UlgnFbJ?=
 =?iso-8859-2?Q?lhsmL+bfCerWpgU13ouwY2zE/GMRsoxVW6uKldVl2DSdQJMv67r61rtsML?=
 =?iso-8859-2?Q?I1THdP4VFD2E2k1niwyUgq6AAPSrFP7iyH+KQxyxyeIIfYIxfwaF3zWOlm?=
 =?iso-8859-2?Q?gW1JZQLSe11X1Y73ez0PFfy6ij+4Lysble5clLHABRxMpAJdBOyb+Rc19h?=
 =?iso-8859-2?Q?aX58ksOmrvgbNSDdXJPAOXYGRIxKypNlPFvtpZJIUfkdmqXq9AoZKRANYT?=
 =?iso-8859-2?Q?uTRe4erT1M78Y80aBTsI1MJ+ewqrxGZostz/sjd7m1doBIvSRTCFYYgJjc?=
 =?iso-8859-2?Q?H9zihFEOc5i2pmGMKBzPMOmA14yiqfNENbQVd4k+7+bHtCHJVm+1VpfJeR?=
 =?iso-8859-2?Q?ZLiP0QIN3PE1N/RiegBQ1WIl+MBf2V/k5qGvYj05Wr3EN6OEkBQa1eID1h?=
 =?iso-8859-2?Q?h9o5TOWd3QewQAJRj2l9xDQA/NA0lFhVV3b5wd5XhHTdJKR1h5ZcGXddtN?=
 =?iso-8859-2?Q?iPCsWdcQ8PJtLLajZc8WpYE+hXpuxI3ZfjMeQ8/MatnxutD4nrT+ciz9Mh?=
 =?iso-8859-2?Q?9/BvqBA27mu2/+qeVmzs6/lU66hc2zt1Z7n0Mqpiq8VcfCweidTLFN1Oyy?=
 =?iso-8859-2?Q?SEMzgzudbPeuQlS5n3+g1tjfQkicmkwLc47coRgo44GA4oilB5fZtmt+66?=
 =?iso-8859-2?Q?ySPTYCrttQM4pxau8H+a+VqmDgCxBzIG3cjK6IXl7+gu0bwU7WjSH73dcO?=
 =?iso-8859-2?Q?c26EVP5+0V4yLiIFfOIVntOsljYb3ZpPY9CEsql5/IE1Yx12UD1YWUpR0f?=
 =?iso-8859-2?Q?wc0RaE/V8TNNy4bWIoW/Vexy9k8yDg5DhsjDNFV0vXdioDYchJj9AnAMTY?=
 =?iso-8859-2?Q?AnNnB4RslFTwxZB8PzhzPma10efUN0JgfiqTinXYUwtfdQ/uTI4OKW36M6?=
 =?iso-8859-2?Q?FimvKaQ4PBimB6Frm7Jefs1+ItnfaEohEiZ0SEzvAo74fMK/925UVgdZGr?=
 =?iso-8859-2?Q?gsx+goFemAtfKUHRxhnAfxeM/1v7kzuiWATZl7QMcVFRYIDGFOfOvvJnvv?=
 =?iso-8859-2?Q?72w7C/jAYYEGuSGXHYilI5dowogzVacQ7u?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df8ad37e-fe04-4492-0bf4-08da6327726f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 10:23:50.0944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sdt9aR3mMPC164ekC8JTjKozvnGbnjSG2Jpot02FjNykF+tPTU5/s5ClZNoK11qjzv6wdVu8ubbX4AsIq+buwd6Pqu58+E54vGD63zIy96M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2833
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Guillaume Nault <gnault@redhat.com>
> Sent: pi=B1tek, 8 lipca 2022 21:05
> To: Marcin Szycik <marcin.szycik@linux.intel.com>
> Cc: netdev@vger.kernel.org; Nguyen, Anthony L <anthony.l.nguyen@intel.com=
>; davem@davemloft.net;
> xiyou.wangcong@gmail.com; Brandeburg, Jesse <jesse.brandeburg@intel.com>;=
 gustavoars@kernel.org;
> baowen.zheng@corigine.com; boris.sukholitko@broadcom.com; edumazet@google=
.com; kuba@kernel.org; jhs@mojatatu.com;
> jiri@resnulli.us; kurt@linutronix.de; pablo@netfilter.org; pabeni@redhat.=
com; paulb@nvidia.com; simon.horman@corigine.com;
> komachi.yoshiki@gmail.com; zhangkaiheb@126.com; intel-wired-lan@lists.osu=
osl.org; michal.swiatkowski@linux.intel.com; Drewek,
> Wojciech <wojciech.drewek@intel.com>; Lobakin, Alexandr <alexandr.lobakin=
@intel.com>; mostrows@earthlink.net;
> paulus@samba.org
> Subject: Re: [RFC PATCH net-next v4 1/4] flow_dissector: Add PPPoE dissec=
tors
>=20
> On Fri, Jul 08, 2022 at 02:24:18PM +0200, Marcin Szycik wrote:
> > From: Wojciech Drewek <wojciech.drewek@intel.com>
> >
> > Allow to dissect PPPoE specific fields which are:
> > - session ID (16 bits)
> > - ppp protocol (16 bits)
> > - type (16 bits) - this is PPPoE ethertype, for now only
> >   ETH_P_PPP_SES is supported, possible ETH_P_PPP_DISC
> >   in the future
> >
> > The goal is to make the following TC command possible:
> >
> >   # tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses \
> >       flower \
> >         pppoe_sid 12 \
> >         ppp_proto ip \
> >       action drop
> >
> > Note that only PPPoE Session is supported.
> >
> > Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> > ---
> > v4:
> >   * pppoe header validation
> >   * added MPLS dissection
> >   * added support for compressed ppp protocol field
> >   * flow_dissector_key_pppoe::session_id stored in __be16
> >   * new field: flow_dissector_key_pppoe::type
> > v3: revert byte order changes in is_ppp_proto_supported from
> >     previous version
> > v2: ntohs instead of htons in is_ppp_proto_supported
> >
> >  include/net/flow_dissector.h | 13 ++++++
> >  net/core/flow_dissector.c    | 84 +++++++++++++++++++++++++++++++++---
> >  2 files changed, 90 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.=
h
> > index a4c6057c7097..af0d429b9a26 100644
> > --- a/include/net/flow_dissector.h
> > +++ b/include/net/flow_dissector.h
> > @@ -261,6 +261,18 @@ struct flow_dissector_key_num_of_vlans {
> >  	u8 num_of_vlans;
> >  };
> >
> > +/**
> > + * struct flow_dissector_key_pppoe:
> > + * @session_id: pppoe session id
> > + * @ppp_proto: ppp protocol
> > + * @type: pppoe eth type
> > + */
> > +struct flow_dissector_key_pppoe {
> > +	__be16 session_id;
> > +	__be16 ppp_proto;
> > +	__be16 type;
>=20
> I don't understand the need for the new 'type' field.

Let's say user want to add below filter with just protocol field:
tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses action drop

cls_flower would set basic.n_proto to ETH_P_PPP_SES, then PPPoE packet
arrives with ppp_proto =3D PPP_IP, which means that in  __skb_flow_dissect =
basic.n_proto is going to
be set to ETH_P_IP. We have a mismatch here cls_flower set basic.n_proto to=
 ETH_P_PPP_SES and
flow_dissector set it to ETH_P_IP. That's why in such example basic.n_proto=
 has to be set to 0 (it works the same=20
with vlans) and key_pppoe::type has to be used. In other words basic.n_prot=
o can't be used for storing
ETH_P_PPP_SES because it will store encapsulated protocol.

We could also use it to match on ETH_P_PPP_DISC.

>=20
> > +};
> > +
> >  enum flow_dissector_key_id {
> >  	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
> >  	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
> > @@ -291,6 +303,7 @@ enum flow_dissector_key_id {
> >  	FLOW_DISSECTOR_KEY_CT, /* struct flow_dissector_key_ct */
> >  	FLOW_DISSECTOR_KEY_HASH, /* struct flow_dissector_key_hash */
> >  	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_=
vlans */
> > +	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
> >
> >  	FLOW_DISSECTOR_KEY_MAX,
> >  };
> > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > index 6aee04f75e3e..3a90219d2354 100644
> > --- a/net/core/flow_dissector.c
> > +++ b/net/core/flow_dissector.c
> > @@ -895,6 +895,42 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struc=
t bpf_flow_dissector *ctx,
> >  	return result =3D=3D BPF_OK;
> >  }
> >
> > +/**
> > + * is_ppp_proto_supported - checks if inner PPP protocol should be dis=
sected
> > + * @proto: protocol type (PPP proto field)
> > + */
> > +static bool is_ppp_proto_supported(__be16 proto)
> > +{
> > +	switch (proto) {
> > +	case htons(PPP_AT):
> > +	case htons(PPP_IPX):
> > +	case htons(PPP_VJC_COMP):
> > +	case htons(PPP_VJC_UNCOMP):
> > +	case htons(PPP_MP):
> > +	case htons(PPP_COMPFRAG):
> > +	case htons(PPP_COMP):
> > +	case htons(PPP_IPCP):
> > +	case htons(PPP_ATCP):
> > +	case htons(PPP_IPXCP):
> > +	case htons(PPP_IPV6CP):
> > +	case htons(PPP_CCPFRAG):
> > +	case htons(PPP_MPLSCP):
> > +	case htons(PPP_LCP):
> > +	case htons(PPP_PAP):
> > +	case htons(PPP_LQR):
> > +	case htons(PPP_CHAP):
> > +	case htons(PPP_CBCP):
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> > +static bool is_pppoe_ses_hdr_valid(struct pppoe_hdr hdr)
> > +{
> > +	return hdr.ver =3D=3D 1 && hdr.type =3D=3D 1 && hdr.code =3D=3D 0;
> > +}
> > +
> >  /**
> >   * __skb_flow_dissect - extract the flow_keys struct and return it
> >   * @net: associated network namespace, derived from @skb if NULL
> > @@ -1214,26 +1250,60 @@ bool __skb_flow_dissect(const struct net *net,
> >  			struct pppoe_hdr hdr;
> >  			__be16 proto;
> >  		} *hdr, _hdr;
> > +		__be16 ppp_proto;
> > +
> >  		hdr =3D __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hlen, &=
_hdr);
> >  		if (!hdr) {
> >  			fdret =3D FLOW_DISSECT_RET_OUT_BAD;
> >  			break;
> >  		}
> >
> > -		nhoff +=3D PPPOE_SES_HLEN;
> > -		switch (hdr->proto) {
> > -		case htons(PPP_IP):
> > +		if (!is_pppoe_ses_hdr_valid(hdr->hdr)) {
> > +			fdret =3D FLOW_DISSECT_RET_OUT_BAD;
> > +			break;
> > +		}
> > +
> > +		/* least significant bit of the first byte
> > +		 * indicates if protocol field was compressed
> > +		 */
> > +		if (hdr->proto & 1) {
> > +			ppp_proto =3D hdr->proto << 8;
>=20
> This is little endian specific code. We can't make such assumptions.

Both ppp_proto and hdr->prot are stored in __be16 so left shift by 8 bits
should always be ok, am I right?
Should I use cpu_to_be16 on both 1 and 8. Is that what you mean?

>=20
> > +			nhoff +=3D PPPOE_SES_HLEN - 1;
> > +		} else {
> > +			ppp_proto =3D hdr->proto;
> > +			nhoff +=3D PPPOE_SES_HLEN;
> > +		}
> > +
> > +		if (ppp_proto =3D=3D htons(PPP_IP)) {
> >  			proto =3D htons(ETH_P_IP);
> >  			fdret =3D FLOW_DISSECT_RET_PROTO_AGAIN;
> > -			break;
> > -		case htons(PPP_IPV6):
> > +		} else if (ppp_proto =3D=3D htons(PPP_IPV6)) {
> >  			proto =3D htons(ETH_P_IPV6);
> >  			fdret =3D FLOW_DISSECT_RET_PROTO_AGAIN;
> > -			break;
> > -		default:
> > +		} else if (ppp_proto =3D=3D htons(PPP_MPLS_UC)) {
> > +			proto =3D htons(ETH_P_MPLS_UC);
> > +			fdret =3D FLOW_DISSECT_RET_PROTO_AGAIN;
> > +		} else if (ppp_proto =3D=3D htons(PPP_MPLS_MC)) {
> > +			proto =3D htons(ETH_P_MPLS_MC);
> > +			fdret =3D FLOW_DISSECT_RET_PROTO_AGAIN;
> > +		} else if (is_ppp_proto_supported(ppp_proto)) {
> > +			fdret =3D FLOW_DISSECT_RET_OUT_GOOD;
> > +		} else {
> >  			fdret =3D FLOW_DISSECT_RET_OUT_BAD;
> >  			break;
> >  		}
> > +
> > +		if (dissector_uses_key(flow_dissector,
> > +				       FLOW_DISSECTOR_KEY_PPPOE)) {
> > +			struct flow_dissector_key_pppoe *key_pppoe;
> > +
> > +			key_pppoe =3D skb_flow_dissector_target(flow_dissector,
> > +							      FLOW_DISSECTOR_KEY_PPPOE,
> > +							      target_container);
> > +			key_pppoe->session_id =3D hdr->hdr.sid;
> > +			key_pppoe->ppp_proto =3D ppp_proto;
> > +			key_pppoe->type =3D htons(ETH_P_PPP_SES);
> > +		}
> >  		break;
> >  	}
> >  	case htons(ETH_P_TIPC): {
> > --
> > 2.35.1
> >

