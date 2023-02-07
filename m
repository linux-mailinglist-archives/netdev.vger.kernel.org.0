Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF4968D984
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbjBGNi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjBGNiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:38:55 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605DB21A0E
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675777134; x=1707313134;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ovnUuyHQSZP8avj5wtknE1ZksA8Tau9JZLQn9sC1jQ8=;
  b=TvKIdVlpx7vVun8ObZaiOruIU0/An7sXVt9GjOUvaTJFJ0HrKxAUHM2z
   trbsZWjgyaCDUJQf3ZsoaaX26xotqwSBHriyEsUDfjnoYRZBrUuF8S4M+
   esdW5kahW+LBPMcV28gC8no/eqK3FzckAgNt0MotKQ7bH6O81Z3JRdKJU
   0gh6FB/qklFy4nB2s/EyuQswX8FkYX0ZgaEw8PG5qQrNiMQR+Nq9INLZQ
   hbKKJ56ARTTlvvhU/RwoYDF17ms7H96jitpMCv6yjE1lpseGesrJIEzI4
   hABVYcmreVbp2BlI4f57KDHb3q7QILkhmmYqCQEP2E6FCMbzBau6BuHJp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="327193927"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="327193927"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 05:38:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="644450831"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="644450831"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 07 Feb 2023 05:38:53 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 05:38:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 05:38:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 05:38:52 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 05:38:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfjzzsP7Us5MDLB5DKwy49FIdkKB3yKMdQS9DjWh7qWNeGLiQpaFyA18cv4cl0iTUHt7btEbAw5ANNg3E3NV/XhxJkBFJH5EqNKSYRPk6snmr5GWGzJyKiG4+2PvW1v9YNVuR6fQqNyJuGJeKMAK6rXKWbTf+F9OErgltLAPJ8HxLESHj323PzgggwG9gCkM18ql1VUjx9L2ComTdN9RVJB8abBKa7v+D2EDgvZS2h9ZyUEuil5CvIdDtS3SwDkhDoYXG+rzc4Uv+YD+5RHn4mZrwk4zS2Xprm276qJwAyw0CzeT3NNz5PhPWwUPnlyqS8m7oituM7CAFMMQdQ9aGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9eKUsKH1N2gq37SZGHoE8/j903H8cBEookRtwn2iYTQ=;
 b=nJh+b2ktCxKwdT8NAsqxFzP4fwPtM9DyXF8reuSmGoVe6tBQ3qcJPDUH/iLbHFbHrbM9TPGdOXphVPhjDp/X8T87kwMYytvoh/R1LceldelZHL48gg15z893C6Sb80w+4xpDYLVKqlFfdX2VMD4mTRWl1M77KJhbBvTReLJJ5g92y/ZnZ92UihUB8qNAfA63jqQFeNfWLnbOzni0uyRurQLtNR3rsnhVLfvwd3xZgn8P1Gl9l2301KzHeZX/sm9miQOJZ2dNSRjZy86q4cHRYrivYGAAP3iDPUjC6U/8LVnvzCoKd/o2zi9OaE32Vpd2JCoP27SmeEHy2+Q3+77xiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by CO1PR11MB4932.namprd11.prod.outlook.com (2603:10b6:303:98::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:38:41 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::9d60:bea:aa32:b02d]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::9d60:bea:aa32:b02d%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:38:41 +0000
From:   "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Naama Meir" <naamax.meir@linux.intel.com>
Subject: RE: [PATCH net-next 2/3] igc: offload queue max SDU from tc-taprio
Thread-Topic: [PATCH net-next 2/3] igc: offload queue max SDU from tc-taprio
Thread-Index: AQHZMQPJRT1IqANm7EWJr12MAEaMAq6whj2AgBMKsxA=
Date:   Tue, 7 Feb 2023 13:38:40 +0000
Message-ID: <SJ1PR11MB618088583739276B144665C1B8DB9@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20230125212702.4030240-1-anthony.l.nguyen@intel.com>
 <20230125212702.4030240-3-anthony.l.nguyen@intel.com>
 <Y9JbLW/BF/Q6nKBy@unreal>
In-Reply-To: <Y9JbLW/BF/Q6nKBy@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|CO1PR11MB4932:EE_
x-ms-office365-filtering-correlation-id: 1d44efa1-4ffd-4c2e-5306-08db09109fd0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B9sWMlPR3H3FwVENqaoZe68LYbznnL9u+YPdpwiTrnQXkaex/jZyzdg//NLcb2FDrraJkHFKOQTNBPipUJW9EmWHjRweZUkn/e+rLm+SCIeCkljrX8umlnlTM9cUjG1waj/wTGODm185dX1/9DgxDDS86qDMbmFifgEZYX4etxT1trncZLgRBBtKpUmomYzVMCcsbBeAdI2mOUyNl+GV0VAD3ds2IbmJTTisfkJgkFhM8ATBdY5WX9+KR9iNBx50pUYFoDJj54D4VyqJ6P21iFgH8pkd0eVhhxgClzDHjpVc0nHPCZSQl9FVV5Qf7mf9GcUSybjPN7tQHJG4qRLHaXlWAANHax72v1TufapKYUw3NjkVvZHbVm7LLlz91T94BwHTWTBJrdG2+JA1Hwe5XwssaJL+2N0PiCsr2PBfaTqBAE4Rn9D8+62bONCLYppGonCnmOEHKq+eS5XnS6twplpNWkvPdjd6HD3B/9QMHWcsy7AgN6b6xZjKoOTY4k9O3yBfW/3VGeTE/k1NmUqB4v8fMP3AUCE9xsVayu+xzBpAjj1KqkyRFxI+agC3J6ypdNHMt7a/yzXPi0EBmB2gANXPoGWu9DDsu15QzV2fd2x9Uo7YLWSCmnH9TcMXKxEyGCEYfl/w1qrlLRkrFFJiW+XCaK7YgdY1URFoXNV9v0kn3Fq+r3xNsvSH24vOGipBWZP7y6XHJkb+eL0Q8Ze6Hw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199018)(55016003)(83380400001)(478600001)(71200400001)(7696005)(53546011)(26005)(186003)(9686003)(6506007)(38070700005)(33656002)(86362001)(82960400001)(66556008)(38100700002)(66946007)(122000001)(8936002)(52536014)(5660300002)(64756008)(66476007)(66446008)(41300700001)(2906002)(76116006)(316002)(54906003)(110136005)(4326008)(6636002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T4nuwsZLwGLhK9S/9TolAJWN7CDA8FlKMvgnDohoLH//A2A8jzlgzpnsieo+?=
 =?us-ascii?Q?fRKhyXS5M1p0kvC6OiX6ISWcADIeb60YY8CL8K2CFZU0e88xgpWHVIC1lfEp?=
 =?us-ascii?Q?gxWMsB7k69hilsaL1+DytjX+gv685sq/k9sGPAIXT4mcVAOQ4DkWdartNStC?=
 =?us-ascii?Q?SklBCvlnXK5MtKbpUYNLGYzjmZr13BSy6FUjHtQIaj0qWJsVGC0IVRHNQwAs?=
 =?us-ascii?Q?AzXtHpnEcgWQSE0MvErHIYJAk3FklqBjIeWNwTP0G+L2ru+lFe8NC2bzO7/Y?=
 =?us-ascii?Q?HAppL4LLTOzial1XAKVl4AWxYaIUY+Xg0tt08fZxjfLIjgfXRSqhWcZUAYnG?=
 =?us-ascii?Q?DdpaEGMlwrLAiA7DsBCCf+EOT/Mt5SuN2blw6K2UAWoARTpXSNCb8aVmtlrP?=
 =?us-ascii?Q?Vo++VF6Yywx9QH4J9LSG08f7W90EWXW6rbnkc+Wc0/ocQIr4aS28Kb9ySDhM?=
 =?us-ascii?Q?TP4Y3e5hJ8qw8RCRSiLTVQT7/uu5Tno5HvWuBAwhrzVlUpdaTFv/I4pOYMpZ?=
 =?us-ascii?Q?KYt3hvk0AmlnkNvWoreYfveNkKm+2FJ9JRkEyYMFVelpgkFOdMjcRYd/+7FS?=
 =?us-ascii?Q?Vap5L7ufiWZp8Qx1/oIKfXOlwQBHJaWSH11gMSYWltxs2KFRJHll5yaIiKpL?=
 =?us-ascii?Q?17hYFwR9lXlHsQz9/0b0oXQMXNvG36Ojkisc2Zvl4n25VaYmE94CcyHfo8Pr?=
 =?us-ascii?Q?7Zmn7ajhuyY77SHIKkfqobO+Hh5m+V71gvjBXVsPByP1Ytw9HBacCR5XZkA9?=
 =?us-ascii?Q?WlAn0DkL4aeszsKcTUq8Et2EY7J5FussH9VFwMPNXJyrrW0XA0Aeb8jg29CX?=
 =?us-ascii?Q?rDWlu5ebeKx+M1+onYl8+exI/+dgALrIWT6hwjZDxjhqfGGyKXZGByNPYbVV?=
 =?us-ascii?Q?9ZTrgy85YQS/mXvnmSx8TswQH4MW+4xkL2OkF6zKuTTX52kLMphaZVVLJbvw?=
 =?us-ascii?Q?HiT+bkkE2fIE8um719C3hGSHR3adic8Cu2U6VrbovsQ9tZaoE/6xT4x8sza8?=
 =?us-ascii?Q?h2ypnm7tJq0KdEz9CkHhaAkW6txhayYk+44RtvOPg27kMWGtN1GHnezQ5AtF?=
 =?us-ascii?Q?6ugX5WVBcbi203V+dkxvNhf5JtfzJQdj1VJOvHmJ+MCEVDiyvbgh16LpHLgo?=
 =?us-ascii?Q?tvPF4zy3Y3dChqbzenbpXaGjtOjR9Ot9e2bZ3S4UTKqN9Sjy4mdWMXczhQDz?=
 =?us-ascii?Q?pmfWHgbr6X7aiEzqDGd+8ITpunOMsyVEFVrJ4lLF33CAxcAI8D37k7LyCshH?=
 =?us-ascii?Q?8M1k574JWf2/ijIiPCByj2mC2Dm+6L+X/4h1jjMYUz7SKVtx/BEGDD7KgtIW?=
 =?us-ascii?Q?MazGJR6PZCweG0xXq1E/m6DmvbvvogG26PA8fT4onJQdMg5i/+SgRpW/NmSp?=
 =?us-ascii?Q?I7n2BbL1DyP9eHEIIaVP2abiSesBEtfGP59X5dyE+3Cv2qP4nOVBtXugQDiH?=
 =?us-ascii?Q?PNwCFhKO5MwDkVME4Hg976tKs/TBeLgs6SrGwX8EaOi4m1hk/Cqm90EdmTYT?=
 =?us-ascii?Q?DvrBUZF06Vsl8JlhPWLOKsKCZUgY4yFRIekaX4bukw69433uVSUq4F3mNyTe?=
 =?us-ascii?Q?X7xqj5M6Az6VxPuSzZ4FLzr/uBMWZoJntf48sfZsLjqAWEFr5xg8W386uyau?=
 =?us-ascii?Q?e/PMIttGyl23mjJEim6ehmk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d44efa1-4ffd-4c2e-5306-08db09109fd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 13:38:40.7932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ECYG5MlFL/K+wi6Ems5UZFna0bJXO+yxa00gzZr1ory2kkS0Oqor7ULJQJ3lA1MolgFIsuDqlJhs7tuCD9LXD+ODre1u6eck2w7kaigT+2AJUzAWo125TFlD18fqq0/R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4932
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

Sorry for the late reply. Replied inline.

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, 26 January, 2023 6:51 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> edumazet@google.com; Tan Tee Min <tee.min.tan@linux.intel.com>;
> netdev@vger.kernel.org; Neftin, Sasha <sasha.neftin@intel.com>; Zulkifli,
> Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>; Naama Meir
> <naamax.meir@linux.intel.com>
> Subject: Re: [PATCH net-next 2/3] igc: offload queue max SDU from tc-tapr=
io
>=20
> On Wed, Jan 25, 2023 at 01:27:01PM -0800, Tony Nguyen wrote:
> > From: Tan Tee Min <tee.min.tan@linux.intel.com>
> >
> > Add support for configuring the max SDU for each Tx queue.
> > If not specified, keep the default.
> >
> > All link speeds have been tested with this implementation.
> > No performance issue observed.
> >
> > How to test:
> >
> > 1) Configure the tc with max-sdu
> >
> > tc qdisc replace dev $IFACE parent root handle 100 taprio \
> >     num_tc 4 \
> >     map 0 1 2 3 3 3 3 3 3 3 3 3 3 3 3 3 \
> >     queues 1@0 1@1 1@2 1@3 \
> >     base-time $BASE \
> >     sched-entry S 0xF 1000000 \
> >     max-sdu 1500 1498 0 0 0 0 0 0 0 0 0 0 0 0 0 0 \
> >     flags 0x2 \
> >     txtime-delay 0
> >
> > 2) Use network statistic to watch the tx queue packet to see if packet
> > able to go out or drop.
> >
> > Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> > Signed-off-by: Muhammad Husaini Zulkifli
> > <muhammad.husaini.zulkifli@intel.com>
> > Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/igc/igc.h      |  1 +
> >  drivers/net/ethernet/intel/igc/igc_main.c | 44
> > +++++++++++++++++++++++
> >  2 files changed, 45 insertions(+)
>=20
> <...>
>=20
> > +skb_drop:
> > +	dev_kfree_skb_any(skb);
> > +	skb =3D NULL;
>=20
> Why do you set skb to be NULL?

IMHO, dev_kfree_skb_any(skb) should be enough to free the buffer.
I will remove it on the next submission.

Thanks,
Husaini

>=20
> > +
> >  	return NETDEV_TX_OK;
> >  }
> >
>=20
> Thanks
