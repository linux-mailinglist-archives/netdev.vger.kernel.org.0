Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825A35B67F2
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 08:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiIMGds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 02:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiIMGdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 02:33:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687E613F71
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 23:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663050819; x=1694586819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xV+Fy/310EPj6bHzncQCeE/135HY2hf2DJCcx0/C2z0=;
  b=SHLyX+nMhJyZC731Ovm6lIfQ88W/O81qq3zlWaR/ZrEHd1nyob4CempZ
   gg3HI8GZgmw0WBjDUooKvjoJj6krrOLxjgx07CoBGto7SG0nhXJoZmxGG
   n+e6IIr3BFBHIK+hXsr43xhl+NDii/p2fp/xMN1jQwMkwqwpD0QBsC7kt
   zx5tc9PWfTp7c/wSYS6sFKaEN0uYBZKDxAbZ+NQOEGyJ4ANQAPdQxto3t
   dJRRj+URrV1Jj8NVkpCZIiWIZ1KHDASQP3l54JSggyoOcosT7K0SjLIPs
   vMrkz7umO0RCXmPIhyrRyV+KmqQPs0u1PI377UTN7mJE+9kYuvv2HqlpU
   A==;
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="176854787"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Sep 2022 23:33:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 12 Sep 2022 23:33:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 12 Sep 2022 23:33:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CD+OBr/aV6WCKUdUqdb4iz6P+PQAmJ7OAQdMl3+gjgnZ0p0U1hhrISrhSaCnB0RZjgD2dHUrzlF4+Bynh5QMa+DhV4aaorYRoThj7MSUIDnMv+azygVG+ufaLVyMLKaIz6Q0Ho9yUZIHzrorxUkOwIs7leiwq1nnehOvlOCxqpsJ6sB1+WSMDS1Cx35TvPEyal8EP03J7eDgyzKOCrGuCII7p8V+qEGpQpah+YIrbzOZBVfn2mbJQ8aE8W5zveG5bIY4q0c1/zeLprpvACqi9PGikUh0vLKAMPj+Mh59iBbWhJ+W138y+jfGUYKHrE9INXS1BA20fPzytoj8Cbd9Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TakxaVQKHNPkJAu8mj1lynyHVS/MbSfvtrRF9UWruOI=;
 b=i6NZHp87159iWzFxVG11Us25WlJaF5DtHGV3eMp6vpIsrAHxPyyImTWGzhI1ldFV6pa2vP5cyz7W8UklPwwEG8RYMD7f0nF/6mq44MVIx455IMOKvek9u/0jzTYdQmuxB6QoKsXq/VS804CnX6NE0xtZPNEDER4w8aZ4e0hfVuNnN9TrQu3rHKnaP2sKA0SFZAQhtI8BCfEGerhLxNrhSXjzRR0HLLeWwKvwXhID1sE5t8ukn1lxzejUagi5c6QZbiZpYQuqCY6r5qtayA71XqdnLFZ1OGJwafWrLacsoW+ucAuJIu2YCtpKRjBWxaFgrUxXCGLZZ0KsH3PlBKK06w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TakxaVQKHNPkJAu8mj1lynyHVS/MbSfvtrRF9UWruOI=;
 b=ssnvOrRX4YN+Oftefb6s7vniz0t2Otiq/9FcucsnzZ/TpH2Q/WGwATMSQIm9rKBwf99cY2kv7T8U5rjckhP0PQ5SZfZ23wUDK+V0ElU0ZU1XbMp6dQmy5xj+tF2Bo/8JoRmXJoPvYlBvERNiJ3xCquejejuhjrp65sBwJumHofY=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by PH7PR11MB6794.namprd11.prod.outlook.com (2603:10b6:510:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 13 Sep
 2022 06:33:30 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::e9dd:3bcd:855f:dc9f%7]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 06:33:30 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH net-next 1/2] net: dcb: add new pcp selector to app
 object
Thread-Topic: [RFC PATCH net-next 1/2] net: dcb: add new pcp selector to app
 object
Thread-Index: AQHYw3oKWFkSI+gyhk+qyKWWaFYz8a3b/qqAgADycYA=
Date:   Tue, 13 Sep 2022 06:33:30 +0000
Message-ID: <YyAmZaQegw2zMNLb@DEN-LT-70577>
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
 <20220908120442.3069771-2-daniel.machon@microchip.com>
 <878rmoeezf.fsf@nvidia.com>
In-Reply-To: <878rmoeezf.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|PH7PR11MB6794:EE_
x-ms-office365-filtering-correlation-id: d7655f0f-9047-4a88-9330-08da9551dfa4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vozPnUwGuKKr4aNrT856gDVWQaSCF6inBd2tEWRuDfi9wtDuQQYR8b3tm7BhTt2W1JLmnxSydPphRQIlvtm+W7hhSi9U+R4oZozXR4M+szA41aRJmssOhVrnHAPlt+NNzD8mW3ryh9NPdZ01+qTa2Zpbt/W9SIo26mGRZys29icLf85s4Jf2s47qR/P+UO9QxzYAsn1wHlRY/p9EqcPUPd2wEVPMt0/JIl5v/DjgJhB1BZtIypTmmOIMLFDnonwD4zpyh7UaJvQk6sUGZQq9Xgf+JBfznyBpIm2rSdH+JRnakMoXoNAk45TSv1pD3BjT2Ycut1lVCV5Esf2/WGG/CE9AEoLWKoM9FLX2Vv6+UYEDA6cBfXoElpk8CdvlMuUvItZonvGnUkbpOBlmh1Jj4my/ZbrCJFpLIZUN+7F4iZCkB+ZqKprgd5kQc4tRr+AUeW8Y0Nkyq5IaNBSy2fSC33uMO9ocgWEUaF2yrqZRXA9IJegMJhv6Xgvv7sax1xo46Xsp+BEIOecCydsFTr+/17KfDB8HpxHhpGFjEodhONdvSoFKCaaEoufpJ6kudlxmZz/VhddsmuHFKDPBdHd6AR/guBmsoyQotsxFlbRi21KO7EhNzjOysYHHPMn7boz9y23KZI5Z/9HWvw5EMS8PS7lWFhI2qd+V/Z5OlW02poqARSF3GlkhV7Y9Bz5dnrGKIc1uXSVw3mt2JTcZrB243elAMMedD36eatfoiuZ7F083eV41o3fo6xp4iSOkPqn6SaCUCcoOp18ae2Nsi0p43g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199015)(478600001)(86362001)(83380400001)(66556008)(38100700002)(316002)(4326008)(66946007)(41300700001)(54906003)(38070700005)(122000001)(186003)(2906002)(6486002)(5660300002)(66476007)(8936002)(76116006)(9686003)(8676002)(91956017)(66446008)(64756008)(6916009)(71200400001)(6512007)(33716001)(26005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T7JqGcLszg27eUd0CY5uD4UJ4EJGDCVQoyndwPT1zKz1wQMDie+WskKWhYtU?=
 =?us-ascii?Q?KGcNtj+sM5Jk0r99AjansViJWR6EqTtf6os52DhqlvbstwGJxDyKBzDqvr99?=
 =?us-ascii?Q?pA9sosCbW9l8B+dtWnjIwlTuDlL8Esk121jiedKLxurCsCuoCLTIlUtjGdP2?=
 =?us-ascii?Q?/BAIuSpPSY99efpFC1uNDCEO3RC/bf4ZJXdYZ1bHVBXJa+B3Jzm/bpq/J2tb?=
 =?us-ascii?Q?y+65nN3A89ORLt1AFtRC/cdvvRy5s83b1LwdEyNmHpwHW7Kxp4eGAMJesfEW?=
 =?us-ascii?Q?5qBb6exgRxwXbgm1zR4RPdc9R/Ygfwe3OFdNSM+2fLmArXiS3FbwZNKo81Wk?=
 =?us-ascii?Q?nkIQIbjk6ubKurYF6LWcJIXa1INVAVfZxy1jlOmLh1tIyUU97iTET04AGttc?=
 =?us-ascii?Q?PGYJ2lpNxUzn12jxocrHggl3ZODf57dSsgd1sZx9xRRt75DGVwi3DGUdMwjj?=
 =?us-ascii?Q?Y0CWogAk+65VokRQKvxuVI1VJdCa1KOdKAH/tJTotcTB8Uv61wtFg8NGTq2y?=
 =?us-ascii?Q?ZoE60kjo/yjp8RafksSPxekSNVdEddgN4zfkFLmTS1a1Cz4I5PlYKwc6LXbQ?=
 =?us-ascii?Q?jbUvq1ebF0Vev4eOXr9K4mKRXnV7hHYguIJe8qFXgR4MiptuEmpveLYV2jXD?=
 =?us-ascii?Q?rjdhxrZKMErBj0p3zgn1Wi1LYBflpns2Z9Iqp6d2hJoKs/EYVKW8zajG5yRn?=
 =?us-ascii?Q?nbH2tjEbN79fgDqVJyE1DiWbqvoRyByJIZVivab4iIPZwHl8/UhaSj4KnneT?=
 =?us-ascii?Q?Ya1vd5TtjOg1zbq1vwUtNC2RADXdaCJoQua187/kKm6uocTwjYQ8Cl38F36U?=
 =?us-ascii?Q?KVGjSBoJe35B9GGcEHC/DeV7Eu+Wa0vyM8ZZr5XcVfZD639aL8E9Y07Tz1PR?=
 =?us-ascii?Q?svqWbdxJ53cXno7iXsOC1IFtwj1wpUhSofWEnHLeGBdi2PlhwwKly3JEw/Nt?=
 =?us-ascii?Q?IwGDlZd2eRM4mUZEgRMWd/ouWO4AGDx/7lSSTx2RjNHtLOkAdhyhffMzrWc0?=
 =?us-ascii?Q?6sWlcOabx6CGLhugfGv4j60LSquVwznZBhvYvjEt20hR+yHqtprQxuqqdVxD?=
 =?us-ascii?Q?5a/xTmSkOu2Yps/fm/gLt54zfjdd/8OzSdSMadyQKVgJ8Ggha9BhCypNPaS/?=
 =?us-ascii?Q?H5g0T7A83qNrDz7cJ1uP3tbwdokXdy/6jtNuRH37SfQ4FJfxas/E48VBgx5z?=
 =?us-ascii?Q?ofkdzBlEjFPcuXHrVloagXT9UksQ3DxzNEcJOZkYYToLUycVPW5jtt9P2/Al?=
 =?us-ascii?Q?6b3NZ+DbwKvQIexZVi4WLmbfoemDtUdkgzEXQzYCdh1ORlCLsI8PwZAweWgJ?=
 =?us-ascii?Q?8DNir/jGkwzGkvE3ISp5OCGg50hFrbS+JTek/QerwhwroMXr0ttmk6aQI1pd?=
 =?us-ascii?Q?+Ffj4708nEeR9c7CBn3C0UbycbsEolDtHVEwJCPsulRr3Hj25eg2JvVGgarb?=
 =?us-ascii?Q?+GVXce7C4V2UqeYItm9/qZWD6itRiBaBIZfNrXtYR9T9efT0kdo+Gvujet6a?=
 =?us-ascii?Q?y87mtJYSOA3xK4zFlEQl5ssC6p13t8fgIPhQ+RrzKXtxn3GNYiQD9JTp7Fuc?=
 =?us-ascii?Q?Altvtd9UkLztNRn7pXA8vUmfusZfcqB19hpvqWXw/d4p6VOAJfPOUYX3v9ew?=
 =?us-ascii?Q?a8yzHX2Sz5SzzVh3iEKigIU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C0FB4FA34A23D542A473A1F9270F4ED5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7655f0f-9047-4a88-9330-08da9551dfa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 06:33:30.3028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AylSt4RhlGRHsvMKIL17AQI1RyvPKKALYLITpyvsWwqu7F1JvK6MDvl2coMQ2f5sC2JQ+YG6zDa9a9H/cwxeGm5D0aa09+e5Q7ZPImvvEz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6794
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The purpose of adding the PCP selector, is to be able to offload
> > PCP-based queue classification to the 8021Q Priority Code Point table,
> > see 6.9.3 of IEEE Std 802.1Q-2018.
> >
> > PCP and DEI is encoded in the protocol field as 8*dei+pcp, so that a
> > mapping of PCP 2 and DEI 1 to priority 3 is encoded as {255, 10, 3}.
> >
> > While PCP is not a standard 8021Qaz selector, it seems very convenient
> > to add it to the APP object, as this is where similar priority mapping
> > is handled, and it perfectly fits the {selector, protocol, priority}
> > triplet.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  include/uapi/linux/dcbnl.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
> > index a791a94013a6..8eab16e5bc13 100644
> > --- a/include/uapi/linux/dcbnl.h
> > +++ b/include/uapi/linux/dcbnl.h
> > @@ -217,6 +217,7 @@ struct cee_pfc {
> >  #define IEEE_8021QAZ_APP_SEL_DGRAM   3
> >  #define IEEE_8021QAZ_APP_SEL_ANY     4
> >  #define IEEE_8021QAZ_APP_SEL_DSCP       5
> > +#define IEEE_8021QAZ_APP_SEL_PCP     255
> >
> >  /* This structure contains the IEEE 802.1Qaz APP managed object. This
> >   * object is also used for the CEE std as well.
>=20
> I'm thinking how to further isolate this from the IEEE standard values.
> I think it would be better to pass the non-standard APP contributions in
> a different attribute. IIUIC, this is how the APP table is passed:
>=20
> DCB_ATTR_IEEE_APP_TABLE {
>     DCB_ATTR_IEEE_APP {
>         struct dcb_app { ... };
>     }
>     DCB_ATTR_IEEE_APP {
>         struct dcb_app { ... };
>     }
> }
>=20
> Well, instead, the non-standard stuff could be passed in a different
> attribute:
>=20
> DCB_ATTR_IEEE_APP_TABLE {
>     DCB_ATTR_IEEE_APP {
>         struct dcb_app { ... }; // standard contribution to APP table
>     }
>     DCB_ATTR_DCB_APP {
>         struct dcb_app { ... }; // non-standard contribution
>     }
> }
>=20
> The new selector could still stay as 255. This will allow us to keep the
> internal bookkeeping simple for the likely case that 255 never becomes a
> valid IEEE selector. But if it ever does, the UAPI can stay the same,
> just the internals will need to be updated.

I get your sentiment, but it seems a little far-fetched to me. The=20
trade-off will be extra code, in trade for something that IMO very likely=20
will not happen. Like you said earlier - how many selectors could one
possibly prioritize on?=
