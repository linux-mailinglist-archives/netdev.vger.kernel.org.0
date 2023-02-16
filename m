Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500C7699681
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBPOAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBPOAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:00:21 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49727497C8;
        Thu, 16 Feb 2023 06:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676556020; x=1708092020;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NHIgfwbepSz23MvjOcpxQaEhKUWjB4fgBnBAva6kNFA=;
  b=HEsaNXmVGENc+HWmClLwufAxwuGc1B0/12t02gma/E72jc9RH9coogw+
   HtQMVgE2+jlwLvFnW8vpGldoioyPZ6GxxPkNUSmheoz1mvIVHhZe+8iUw
   znbZzJUeXp/53KA8ABBJvTaWnd0D/30DAGF7g5YTLSFDAmeEZ8VmXF+ag
   9bOxMQtyIHnFbMJ37xkjQDeN/j7XHS+H5TosaCiAl6WuL0GgFdtkr5w9m
   rCJaZuGa0enWNfVJonWnD/zsFGV1zZHkCzMiYrfN3Reezml8+UIfuESCF
   ijZ2TzzNIaKz6Men1TOQJdY7w2WhGQOERTwDrY1WYTY1BVoCLcp1IajKP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="333047615"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="333047615"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 06:00:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="812971069"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="812971069"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 16 Feb 2023 06:00:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:00:08 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 06:00:08 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 06:00:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQUZgoXJf6gGYTPmRzDCmCFt2sgmBBnoIjy85zBH2k17d/bLLtap978gq07Apotln/XjTY0kWhaWCQJ7Pjj4wGkW37ledxC9adlDHQr3B/M20wqjRlSg9foTEEl9Kl/9SmsQeBXw6qHd0qP44HJsgMh+Czo6WPo/Iff639468BdFtPQhR0PtY5q/FjwHv69mnFbWQ4Wu3R/6h3vVesxhhx8fq8sTWHitN/mkoNdaezdKLhKoFN69saKBbrQuHUcoAu8PmG2P7YuhwksNELKW89aB5Y2oOCPRcDYCIC37VrieKJNxLwV7TFEeJzR5RQPPuOeCjNPxr4HXXDomu72iMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGOXPY2FlBwUvE/zkUlGyPsif3/2/JtzPWsG4UUU/6o=;
 b=EFoSBxcEbFrsJ0z1eN0v28aMuQhQSO+x6XvVAm79oWvVM2gHIG+lcXk5rNYz4SJAlqTtg0MQusVJ8ixMh34qMO0Ga5uc963FJ9h8wgMpCGojkI2qaGPLvELQKgLBH/FVhXYSEYq5NlJXBjdKvdq6Q6wMP6MyTYM1WcnwXrbMIe5wRaSVUra4mXts2Ud76fx5L86m4jOH692sOjRttbvKwnAcuDAG/GC3YDeBDZtuIEUFfOmoW+1zTkDSsNC4vDLaF4ciJoLee+uVTECl1NixtZfJ/KlaYWC5brfMVQUDZ3RYKiRvFCE5N0bLYcSwKoIKXLYd/JWwW2KURa2CHwvUVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com (2603:10b6:903:b9::9)
 by PH8PR11MB7023.namprd11.prod.outlook.com (2603:10b6:510:221::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 14:00:05 +0000
Received: from CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::ca4b:b3ce:b8a0:f0da]) by CY4PR1101MB2360.namprd11.prod.outlook.com
 ([fe80::ca4b:b3ce:b8a0:f0da%11]) with mapi id 15.20.6111.013; Thu, 16 Feb
 2023 14:00:04 +0000
From:   "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [PATCH intel-next v3 8/8] i40e: add support for XDP multi-buffer
 Rx
Thread-Topic: [PATCH intel-next v3 8/8] i40e: add support for XDP multi-buffer
 Rx
Thread-Index: AQHZQHImdH8aDiB8C0qjnCvdyK/ZYK7OqxGAgADAfzCAAhHfAIAAHdGA
Date:   Thu, 16 Feb 2023 14:00:04 +0000
Message-ID: <CY4PR1101MB2360FB8FB19B6342536FDB7090A09@CY4PR1101MB2360.namprd11.prod.outlook.com>
References: <20230214123018.54386-1-tirthendu.sarkar@intel.com>
 <20230214123018.54386-9-tirthendu.sarkar@intel.com> <Y+u+aUJJ2EQYEdJB@boxer>
 <CY4PR1101MB2360B76C18FDEECAFE3169EE90A39@CY4PR1101MB2360.namprd11.prod.outlook.com>
 <Y+4cYNvEYKOb8Kzp@boxer>
In-Reply-To: <Y+4cYNvEYKOb8Kzp@boxer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY4PR1101MB2360:EE_|PH8PR11MB7023:EE_
x-ms-office365-filtering-correlation-id: 8c07134a-0b84-4747-7d2f-08db10261ace
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S2wULZKFLKkox8Ek6ycsP86Yk2G1J9PzZW6o31o9RfoWaPGXyDQOK5vQtUXmVA9l3j7wI4kZHKIEaziICwYYKkEGoVttVYFF/2x13SmGGERzSMMqxW2v3jvreqKmtiSOGmhywwxmMHnxPERUTxWrBo3gj1bJ3WE1R8UeByYLpPbR1+GgJkCAygqly+gYv1SXS0yE0Rru61ESS2dEiAKxYzgcuL1Iuv5DbFDlcjrJSy0FhUoZj4ZGLGnxFMJSPcUmOtCOV6UXSK+uXwGc+ayggntyuANVaFJcdv3RDzU+dxtUvggk3D2o4YpMFCa+EUy0R27W/PPhJr9ODvUSNOyIkS3X6y6TB/Pfg8otNwrgcpM0ciRACAuJQ7Tkxp2V3TZXym2rugORz0ZJ4Cood4C3Bs+P8WTuanSw0tywCqaFmnR4jVH4w/ryvbrqPlnryciGSHo8fkf4TI4vULeC2RarVS0xxTfg3DOIl3uqMQoKMGKk7pDsewARKJskEeaZ2hEWKxFQcTHz1/eYP2n+vupP17xoOagaZKhVyNg0DMkJ+sp2LzX7CsM3sQRP1U9vvC4Si+Y9VzatlicJ6pSL/q4+x5B+6fGA6eDTcaG17kLFF95sQXS7wVkx83sT4FbmNOTNIlRsSZGz06YCp21aePl62GxspI9RcGKZuG7sPVAdPSc2Tu5jN5DOMsZ21oefebzsH7A7ZuS4KsI+7fs7LLFUoqgIfkkj408clrIRYuYv2MU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(38070700005)(82960400001)(33656002)(38100700002)(86362001)(55016003)(71200400001)(6636002)(7696005)(316002)(54906003)(107886003)(26005)(186003)(6506007)(9686003)(478600001)(6862004)(5660300002)(8936002)(41300700001)(2906002)(122000001)(66446008)(64756008)(8676002)(4326008)(66556008)(76116006)(52536014)(66476007)(66946007)(83323001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EiN6FcPRngQSks1PbAoABZW1z/p86/7MkNadxhnDEGBiKCoyLbMYGL1VqWM5?=
 =?us-ascii?Q?0y0CF3JuJZNWBjxuwvLlwwn+OtKM71AILZfMc2wzHHm95zwnuOCVqVzHURPs?=
 =?us-ascii?Q?U9pgCdr3ocVeRlElbVyvV4etCxkyLFUgsNV4EVvAdgrhXQnRBuMLKi9bjPlU?=
 =?us-ascii?Q?kclY1gmSJuyOaM0K8t8zmIlpKCvKGIw9s6WcLsmi9pJLtlw5NiZkO6QN8ptl?=
 =?us-ascii?Q?wqNAEFjNWSfRz03ffP8Tb9R79gDlZufkE0h59vp8/tB/HySZop0f9cZrLDvw?=
 =?us-ascii?Q?iJzeheyGZY3f/K/5Hir2VwnZlMfnWaSkC+C2pkMX0DHT/rheedA0oNwjyt6/?=
 =?us-ascii?Q?8rAVK7VAZd0MLwYlfGej/sOoAMjSHVOMs4XYc5fRKNag1jx37atBUMZCc0CB?=
 =?us-ascii?Q?JD/p8aYLYNaLhwo4EVwv/jWwCYNWd4zxUh53nK2NP5te25gUJsIwEVEaWsz4?=
 =?us-ascii?Q?LQ4EB5emBzOZKjXrNNOcKnOR3NCB64wHmhgX6jRMIXYwVAUCjcRuMbIY1ezw?=
 =?us-ascii?Q?+jd1TSAgsvjnFxYqVRAVKwfZ8iSToG//wSseAJ7L+l8MegTWWQi5VIGkmspo?=
 =?us-ascii?Q?ihKSD3dynUCgFFvLyRAIsX7X4thQozTvSpAp3tesRXivmQba7VQPdqkMc0jd?=
 =?us-ascii?Q?V2pZCLc2ZsjYuL4SHSP/wgYH9FRJ9BflS1/uAiJ+RdpNlvbO+sU6SA+8xZRw?=
 =?us-ascii?Q?TXzYmr3OJtsm8KIEgmnXOdxex81hcff73yKwICGZzk8c/XdirbNVWNEnPlAs?=
 =?us-ascii?Q?rau0qgX7ZgP/ifJOnn1rfr+bRdnZmcJ9Z0hHo3Nw5A9adxbKyK+H36Z5b63X?=
 =?us-ascii?Q?gLWs8BfITX2azl6tZRutE2M5qjt7h0PFfmHqeWcxW5RJmOwn7exogiBOv8+T?=
 =?us-ascii?Q?oKZSGvibFHijS98Iz+cQgqJJxCC37gMAMW5/4LQjRDV8no/JgJjcJkCbnJVk?=
 =?us-ascii?Q?iYJfhhdOaitCy5kkngXy5WAyr/2iJ7uPe5CwB8MOsKcqtC6WgK4qhjV0YD+Z?=
 =?us-ascii?Q?9HmM5714TsixULiEvncDcW5d/u2ri1Z8K+NejKfSTwJyt1tt+atq6CjrrSAW?=
 =?us-ascii?Q?aklYB+DkSQ0stdHbvQkm1IanTsCEK5d6s9LFz7T0ACFSXJwT/shX2gwDk20z?=
 =?us-ascii?Q?x4R7xrFf+IDLQNg+wPpMAXptrcHxXubSn6hHeYzxy+AlenD10ag/Lg+e4H+C?=
 =?us-ascii?Q?41J/wy6U6tZpJ7jDt0Mwb+URZC+uvEbVdtaG6WQOX5jlhwnOBUcy1xOvBXA4?=
 =?us-ascii?Q?e6gV5S8sJwKd16UAGMiXAc6Amr06pOPXFFNaWxUBZJhazg4dPO97apE54VWx?=
 =?us-ascii?Q?U+ERDTnHGN9jRFiZdcuCsAnLmHSKK1OBsuG5HRGE5GmJo3pevCvIHZXZGRjU?=
 =?us-ascii?Q?U21FFA13RNbt3hKXlCDnANYuqYRqlEDmCDA8hyh4RscUpipiLPXyl76CXgha?=
 =?us-ascii?Q?+XUsTXAMey/FvWd9EiRkokJZ7xQWk9ZVBbjC34QdYVPWT/HnmTvrco8fRJck?=
 =?us-ascii?Q?VTGqnt31tU+zYqmpN6W9SxH9fQu/+DKlAcHKD+kH0tU4yhQxCvDCOZV40uxe?=
 =?us-ascii?Q?2A4lzDxn9Hc5LKLGzYnyEpymcq4pKsoCaIfK6Z8FfGIc7kVgsAf4cGd3MB+Q?=
 =?us-ascii?Q?LA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c07134a-0b84-4747-7d2f-08db10261ace
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 14:00:04.7130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5m6MDiuWvdXxOox9xvlzqEEt03PtnCrunmX15eH0Vj2MybhkcPCf12MfcvwIWfDhy6Tc4BvLWRzojT1nnRpBXpDdymAxhPCJxUYr27smJbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7023
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Sent: Thursday, February 16, 2023 5:37 PM
=20
[...]

> > > > +		xdp_res =3D i40e_run_xdp(rx_ring, xdp, xdp_prog);
> > > > +
> > > >  		if (xdp_res) {
> > > > -			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
> > > > -				xdp_xmit |=3D xdp_res;
> > > > +			xdp_xmit |=3D xdp_res & (I40E_XDP_TX |
> > > I40E_XDP_REDIR);
> > >
> > > what was wrong with having above included in the
> > >
> > > 	} else if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
> > >
> > > branch?
> > >
> >
> > For multi-buffer packets, only the first 'if' branch will be executed. =
We
> need to set
> > xdp_xmit for both single and multi-buffer packets.
>=20
> maybe pass xdp_xmit to i40e_process_rx_buffs and use it for buf_flip
> initialization? also you trimmed the code, but in there please don't
> define on-stack variables smaller than u32 (u16 next)
>=20

xdp_xmit may have been set by the xdp_res of a preceding packet in the curr=
ent=20
napi call. We want to consume or flip the buffer based on only the xdp_res =
of current packet.

ACK for u16 -> u32.
