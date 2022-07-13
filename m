Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B6B572FDA
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbiGMH7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbiGMH7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:59:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F33D861F
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657699142; x=1689235142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WleSXfzbSwLNhwgEyu2lvjPueIWHp3SzhxOySa5ZqT8=;
  b=famBFo0pDyhrPfaryLWaTQbrfrvbhz56773/fjDEiyE+4lV3DSJI94Ys
   Ed5Q7YxmJUXA6x7ZIZhuxh5isfwbRFSWFr5CCywvQlPme8AMZYOgEYIAH
   Oj8A1w4Jc7tPoKoaaWiDUnEhvYGkE/lDWzzwxC2pqdPAtUjE0PXo+oRXn
   eS+hbbDgYG3314cwBGsgzq1Q/Qp3+lrfbVb6RAwLb7UrGNxmBsYnU6m0H
   d7obToOVmxmcHi3Is2OzHmKa9Wxb65NtwGrJoa87/Q6BTEujie2H3/AbO
   obi75DeukxYXK7FBQRFgpnCROyLmNUYeiflCFzPiq/v3oyI93DTr13Lik
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="268179807"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="268179807"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:59:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="545748226"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 13 Jul 2022 00:59:01 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 00:59:01 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 13 Jul 2022 00:59:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 13 Jul 2022 00:59:01 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 13 Jul 2022 00:59:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jni2MSh+c4p7ebYjDU4tC+3U7aKEt9KtLOTNIYw10ROcwI+MuaOjPD49D8+uw05nEk6wiJ1u9gEJhmCytqQ1u6l9VTR8FEjO2yfASq1PBZQkKteIGuGAddiPgMWI2Y/slQHISjHngaDnVbU+RhVjlAhc0w1X4o8CglDRKEVDyDxoTAmTtF7eFX7fYcQOzTL8fJwLMubps7QFaeoUOJlN3xNS70TYxNUs4FdBBCRnFSv/MOtsOKM2qxy+euNxDLxV2izfXXic/zB1H8QejqroTEbpqmwLQ9ZPFKj9fKkf7yRmkEimIyao2/hsCMAU+QKpK8MUwGUF8WlGIAYvNs141A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=peqbJ4GwIZy8aEpPKBnPQ+HuOXJ3XGI9UvlFq5LSlbo=;
 b=T+9ca6pQLIOwlubp6FVKI6KaL37G9ACpKlEHekIejayj4bKvPgg2Rnvm/2h7Y5qBuYOD+OC84FL76u80ELBIXlc0ID/k28hWUiaZJLXixp8TrRiKoN1gCvnF7hYd9j9gHbVvnXX41Rar4jwn8cQAW6LqcdhE2rBgj1ukSjNVazpXOz3ULyFqtM6Ps7ma5pFpoteQvzcVUHdU+vg7UvPqr6LvJURER2Y8wlg2EsByJ448DKfCHfDbwz/vfol+bf8358cIOYk+8o8wDANNnUX7E6DyGMuDfOhvr06mFq6easSrJEPJ+AMneYV1IpA1G6nhgQeAgYOq6tkNL4+berkStg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by DS7PR11MB6079.namprd11.prod.outlook.com (2603:10b6:8:85::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 07:59:00 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::9eb:1dcb:baf2:a46c%3]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 07:58:59 +0000
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
Subject: RE: [RFC PATCH net-next v4 1/4] flow_dissector: Add PPPoE dissectors
Thread-Topic: [RFC PATCH net-next v4 1/4] flow_dissector: Add PPPoE dissectors
Thread-Index: AQHYksXA2PqqPPPZHUuJSl7+xdE+Xa101dMAgAQb8zCAAg//AIAA9U2A
Date:   Wed, 13 Jul 2022 07:58:59 +0000
Message-ID: <MW4PR11MB577640BD1BAC97D3BB27A339FD899@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220708122421.19309-1-marcin.szycik@linux.intel.com>
 <20220708122421.19309-2-marcin.szycik@linux.intel.com>
 <20220708190528.GB3166@debian.home>
 <MW4PR11MB57767AD317D175D260362539FD879@MW4PR11MB5776.namprd11.prod.outlook.com>
 <20220712172018.GA3794@localhost.localdomain>
In-Reply-To: <20220712172018.GA3794@localhost.localdomain>
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
x-ms-office365-filtering-correlation-id: 5c251585-b8a3-4521-9a17-08da64a58b73
x-ms-traffictypediagnostic: DS7PR11MB6079:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QNQWP4qq/xTWu9ej4A7ec7+3pbtndGoCOrCkva92ccYBFsmzpjidbfV8Xlhg3G4IQnvjOrbyYrzud+Y9+qAcGNB6FkmN/jGm1KrXRcMvUAVG5l2BK2f65dW3d1HV22tyRKy6BMSBUpgEtqClnQAFYfESF7B/hM1Z96Mc5xjkGD28Dtm+BpSO3rstpJsowVsTwM+RD+U1dfUl1hQYQbUk344hH3NSwkz25aTsnRPFXr6zX7Rx1rnuMnBEJ14HahbIVsaxTnJrObH64nOv5tFGbSmhSmT6BfvTQYrjWuc3/T3rtoFRCUG7vpgNpt1rBvLgww1+LpsROm48PS2QugCMTub2T3BgCjSSgnQHwOH8f+8Aa7enSkbceB+vYange6SzD1L1ZqnmLw718fED/x1z57zB4idKbl7dlGfghnm441gWZXN6rL5Xd/Fbb31cViJG1413XDf1B3JlC7/imz7NlQGv2NFXBzBu/un5mxT3B2zjjIAochc57TGqkrm777tLUtw+sQiMyNWQglL7VHwfk1Rtg9deY3k0R9BpkvKZH7XoX8kg1tkA3+1YAaE2LU6k35h1tvsb3VXQnSOl+TBFxUVmg2l0DJzQK2IIwNp/if+p4xqZUshKybG966WC2U60LlkcYvNQkTbRCMlgWfkCOyUYZhTFxfXqXwzj4tRHd5rQV41VCQmeBVMUNes6fMWH13WnMcFq0o3mj3iPr+HFNZ/96+Bhm0w4FUlge1ibIyZ6rUKFZmRNhoQs9kEFlS+CxQyMVvFh+uNQGuO/qW5+iSJPP+DmV3IY3F68+vXOiKoUkfgw3x0rJVnyqmkycHZS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(136003)(376002)(396003)(38100700002)(186003)(122000001)(66946007)(7416002)(82960400001)(38070700005)(8676002)(66446008)(83380400001)(76116006)(5660300002)(8936002)(4326008)(64756008)(66556008)(52536014)(66476007)(2906002)(55016003)(9686003)(6506007)(54906003)(41300700001)(71200400001)(86362001)(53546011)(478600001)(316002)(7696005)(33656002)(6916009)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4vOyJ8jUoDbvJCtZkQKZj5+K7dZlvtPUVKe4D2Yiud5pH1dlDACEWYRB30Pu?=
 =?us-ascii?Q?82sAyxJ2ijEkEgOtrmFhYRbglHVY23jJv9wr8k4j2jq8qNUfl0IeFm121LnT?=
 =?us-ascii?Q?ySoRvZXo9XJTAXKvoWiYskg3rzQLR2TAz2aZ0gPkj0y6S64gcKMXQXLegREb?=
 =?us-ascii?Q?y9Jy7c3waigyXdyFT6TZbVCFTxLpX4MkwQLVWPzk+Wb/lA7wRLCNK1N8nCnI?=
 =?us-ascii?Q?L9UDbIOrZ7gVGcBNclCGy/dT2P0IIQI47IrizCmgjhET4tWzcs9jQlR8Ju7d?=
 =?us-ascii?Q?8TO8OEzRw2FjmlUgrINZ1nKBgXqtifoOznL5Ah6Gxs6AxD0hiVeF0TdGPhZX?=
 =?us-ascii?Q?lanGfp0MXdBMhK50tgP5x33VDyDuRSOacIe67i2vEFfVsDK5Rb3ncpPLX56c?=
 =?us-ascii?Q?oILN2KZJEhsuXx4Rp0fyoU9w1yZCdrXD1DRWTSVPIgFNbtRLv+nkgMYWM4Rg?=
 =?us-ascii?Q?/Jic/IbRB0bA5eBNfwXTEo2TEOGIs3a2bK4IHegu/ue0KX+7Dax0F0KDejYW?=
 =?us-ascii?Q?ebnCZcIViBuBikWcm12/FyVxt6ZPbJuSigpcPQ2HNgQ0DBfsSQYvVXmbEVzd?=
 =?us-ascii?Q?8iOHLlXjJYrw06Wa7JMHzgs0Wg+f4z3QCXnGnWaTQcmsDJgcn/tU3P6dgh3Q?=
 =?us-ascii?Q?uC8JPOxYYtwWNBlE8GYgJ216A12a1KjZxKVRyb0VnTddxOun6aH1buAdmrbi?=
 =?us-ascii?Q?lZUpfC5I8z7630pYEnx0z6nMPJnAlHUuUTC9cTSK8uEY9SUjacvPNBMWltmD?=
 =?us-ascii?Q?2Ly8KKeJinBMS43gDLwuHRJ96BhMsVrNWx8GEp/S4a+LSXQA1tLQogJSx8pL?=
 =?us-ascii?Q?+4MxUL4aIkIhVX8uMXKAWK2p7umYBbulx61MhTRXuQUuuDU/uowAJz8dKNZP?=
 =?us-ascii?Q?noQUa+akSMrZ9Uyx1ZQWM/tnkD6g1/wltKTWjWcUEbf+tv08tceFtTgscclT?=
 =?us-ascii?Q?GlgSYkFFtwdqg+JV41ZxQRyLoEoBTiR1CIgABy1GNGd33Kceizb5oKx5VEt4?=
 =?us-ascii?Q?OphL+svHaUiuDBxQZ0087//yBLaBwuuebc8KRR8H6LLhnTkAoGASGHUoF7B9?=
 =?us-ascii?Q?xm2C91km+3Vqgf5NXuRZkEJGCL2ue2btsaZG6h63fJKXXeG5a76rQwLDbWN8?=
 =?us-ascii?Q?25QyzdUFeda1ek+mfR6olMeh3wgHUj52sIuTVSuBMxOe3zEDc1ZHzlsIk2sM?=
 =?us-ascii?Q?pGnoQ3M68U0/ksg4VgqXw5sWGjQyECr4Y1KYZbVAImQzFXZLBFiMrFg9tDT8?=
 =?us-ascii?Q?Ckuee0AfcAfkYQwaQHY6TyXGf/S0eLMyBbx6qhwz4PetlifF0o90upgZ7piN?=
 =?us-ascii?Q?dJ0pq/CAPExT/W33GCkcqCac80EcaKSKogHYWFgiyYUHmr4Ht3ujUV6ej9km?=
 =?us-ascii?Q?osWVxXgi3IOkJDSV0ARhPrJcQexQIuwsbbQ9g6z80RnQ8bUFAOfpoMTma886?=
 =?us-ascii?Q?xpJ3/XmWlBb6wzmRZPWIpRKGJEyHT43PBFS+30ZhFIzg56WOa5vUfX5y8apl?=
 =?us-ascii?Q?ECmLhLPXYOM+mHk/U5ePAfzMpaMfACizVcfTqd/eaFMn8A8HXiYrQUnkRkoL?=
 =?us-ascii?Q?zv/EtmwKsT0pBCRKCgE6QPFbKBO5RV0lSOoqWxSl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c251585-b8a3-4521-9a17-08da64a58b73
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 07:58:59.7868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UY4Q52GkR4Z4+4hasmbOW94EsNJrr/3W3UpCQltApY/+WrxVNXXIBb4vzHyjpviSpsQj4d9wmDfaXlctyAje1EOXylxny4lvw1nzJKPXTG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6079
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Guillaume Nault <gnault@redhat.com>
> Sent: wtorek, 12 lipca 2022 19:20
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
> Subject: Re: [RFC PATCH net-next v4 1/4] flow_dissector: Add PPPoE dissec=
tors
>=20
> On Mon, Jul 11, 2022 at 10:23:50AM +0000, Drewek, Wojciech wrote:
> > > > diff --git a/include/net/flow_dissector.h b/include/net/flow_dissec=
tor.h
> > > > index a4c6057c7097..af0d429b9a26 100644
> > > > --- a/include/net/flow_dissector.h
> > > > +++ b/include/net/flow_dissector.h
> > > > @@ -261,6 +261,18 @@ struct flow_dissector_key_num_of_vlans {
> > > >  	u8 num_of_vlans;
> > > >  };
> > > >
> > > > +/**
> > > > + * struct flow_dissector_key_pppoe:
> > > > + * @session_id: pppoe session id
> > > > + * @ppp_proto: ppp protocol
> > > > + * @type: pppoe eth type
> > > > + */
> > > > +struct flow_dissector_key_pppoe {
> > > > +	__be16 session_id;
> > > > +	__be16 ppp_proto;
> > > > +	__be16 type;
> > >
> > > I don't understand the need for the new 'type' field.
> >
> > Let's say user want to add below filter with just protocol field:
> > tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses action drop
> >
> > cls_flower would set basic.n_proto to ETH_P_PPP_SES, then PPPoE packet
> > arrives with ppp_proto =3D PPP_IP, which means that in  __skb_flow_diss=
ect basic.n_proto is going to
> > be set to ETH_P_IP. We have a mismatch here cls_flower set basic.n_prot=
o to ETH_P_PPP_SES and
> > flow_dissector set it to ETH_P_IP. That's why in such example basic.n_p=
roto has to be set to 0 (it works the same
> > with vlans) and key_pppoe::type has to be used. In other words basic.n_=
proto can't be used for storing
> > ETH_P_PPP_SES because it will store encapsulated protocol.
> >
> > We could also use it to match on ETH_P_PPP_DISC.
>=20
> Thanks for the explanation. That makes sense.
>=20
> > > > @@ -1214,26 +1250,60 @@ bool __skb_flow_dissect(const struct net *n=
et,
> > > >  			struct pppoe_hdr hdr;
> > > >  			__be16 proto;
> > > >  		} *hdr, _hdr;
> > > > +		__be16 ppp_proto;
> > > > +
> > > >  		hdr =3D __skb_header_pointer(skb, nhoff, sizeof(_hdr), data, hle=
n, &_hdr);
> > > >  		if (!hdr) {
> > > >  			fdret =3D FLOW_DISSECT_RET_OUT_BAD;
> > > >  			break;
> > > >  		}
> > > >
> > > > -		nhoff +=3D PPPOE_SES_HLEN;
> > > > -		switch (hdr->proto) {
> > > > -		case htons(PPP_IP):
> > > > +		if (!is_pppoe_ses_hdr_valid(hdr->hdr)) {
> > > > +			fdret =3D FLOW_DISSECT_RET_OUT_BAD;
> > > > +			break;
> > > > +		}
> > > > +
> > > > +		/* least significant bit of the first byte
> > > > +		 * indicates if protocol field was compressed
> > > > +		 */
> > > > +		if (hdr->proto & 1) {
> > > > +			ppp_proto =3D hdr->proto << 8;
> > >
> > > This is little endian specific code. We can't make such assumptions.
> >
> > Both ppp_proto and hdr->prot are stored in __be16 so left shift by 8 bi=
ts
> > should always be ok, am I right?
>=20
> Sorry, I don't understand. How could the test and the bit shift
> operation give the correct result on a big endian machine?
>=20
> Let's say we handle an IPv4 packet and the PPP protocol field isn't
> compressed. That is, protocol is 0x0021.
> On a big endian machine 'hdr->proto & 1' is true and the bit shift sets
> ppp_proto to 0x2100, while the code should have left the original value
> untouched.
>=20

Ok, I see now, we'll fix it in the next version.

> > Should I use cpu_to_be16 on both 1 and 8. Is that what you mean?
>=20
> I can't see how cpu_to_be16() could help here. I was thinking of simply
> using ntohs(hdr->proto).

