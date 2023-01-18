Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEAB671EF8
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjAROJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjAROIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:08:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8935528C;
        Wed, 18 Jan 2023 05:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674049680; x=1705585680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=27gus0S9cCP5w0OnyKW7bH9Uqvl1YIQfh+Al2QipAdQ=;
  b=BXKgz8QKT146FFhCFm6li3H0BtAEPxqFHmURAwm3Isd89H7AAQQ+9xlK
   l+sVzyt4aJv4gTUrfq6Nkeler93O2DHEaKv5FvxnVZrX0wMb7FLqxwg+A
   WgIDK1Oa1Y+kneqCalP08b+lHWEdDywinhVhrkzHJ+JwCChkDN/EyVH1c
   EJeWiwM/cxM3zXpOSDirCKLTPbg7/nCWxJ3Eh4flETmSBZDz5+PnsFHRT
   5L1lIVXyQTO7OWY6ZkfVYUOyZRbBg24LzR4r7hiHPY6crviSJjSPM27Ux
   IllFGBPKlY27Kx29nlwvN8+VYBHLIXwK6YNI+DRz9fE5vB4Rs4ksX6qAW
   A==;
X-IronPort-AV: E=Sophos;i="5.97,226,1669100400"; 
   d="scan'208";a="208305325"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 06:47:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 06:47:59 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Wed, 18 Jan 2023 06:47:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izsk7nLBWQnLVATLeKFa5niZgZ0IKbpzkz4LFtKGsXAuyw2uTLrvxOe3ycNG5GnFGNQgqxOywCU4GqThvzhen7L5ef58ev9GEaWmEsZniSU5M9HKAB44o5WXtKbBwxAPWKdRCwi613J04ooJnV9jaFQVcDsfRRFtwhVH62+cPuMkkSPDHh/ovGGiyvNFyPvuN5tEjbXjqDFCN7YA0t/KRHHBkXUXkVv6c9vbpildDtUP+wFU3DK9lc3zUBV0dMDDQrJ40So4+H6bpr2b8bpEjg4WLtTPrTmEq8o3rYJh8mTn938dc9MmWtfz4sXunCMgAYwf60C+SGq6ojIRjwtdNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPT5koDcTM711GUw+xiUjyBTenIT26cZUTL+IhVrLtk=;
 b=Ofd4Ssf8gUHsLsZQve0tqwAGzVxZP6wB7t0uWGwnNoXi2O8kg7EpVIbbxme3kNJPMJGM2reHqj2EIbKYyjVenO1qZWXaeMZtOxlNx8fBZAWtPNXMH31zdYACnsk/Q+x8sprWSpBotQtsvvOqofQqxveIURtHR//W/oeEIlI748IHkySK/Adm2nZshWrRwtHdlxrinGihxOEj3S9ASeTdPqJPjeO04LpynlJfX7WjaRBW6BavANPp4TXUQZ8TUnqULAo4p75aiK+Ti/tcTi6l+wY5vMHc7OxLbbQXzuNREQWzEnd+sw9KCc+WiS4PlQX6Eqy9LGHwsl9t1g/lhBW2EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPT5koDcTM711GUw+xiUjyBTenIT26cZUTL+IhVrLtk=;
 b=t2vAfiC7sbOR5fha7/0DgQ8t1DozUqOpCVvC1hhrLtsU5lbDe8aIeleAhUgJNuWe4VM8sOtHeNCiv0tY/G4dwqDdNIlqKcgpcGZJa0vJf5Bqu0YTOgXQIeqM4gEa6BcYvjcw1/uLj/sxwsrRsSUSQ0944vJ2MXXRFv2HtEJAHDU=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by DM4PR11MB5552.namprd11.prod.outlook.com (2603:10b6:5:399::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 13:47:57 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::8155:464d:11a2:a626]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::8155:464d:11a2:a626%7]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 13:47:57 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/6] net: dcb: add new rewrite table
Thread-Topic: [PATCH net-next v2 3/6] net: dcb: add new rewrite table
Thread-Index: AQHZKbm5BtwmhtpMEECQnUzYRY/XFK6kAv+AgAAwfIA=
Date:   Wed, 18 Jan 2023 13:47:57 +0000
Message-ID: <Y8f4i2ablWnNO9Op@DEN-LT-70577>
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-4-daniel.machon@microchip.com>
 <87lem0w1k3.fsf@nvidia.com>
In-Reply-To: <87lem0w1k3.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|DM4PR11MB5552:EE_
x-ms-office365-filtering-correlation-id: b025c496-875a-4107-1db4-08daf95a9b6a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KoqeQlfCiOq4oyQGD6kapnGTro1b36RzoStHg0Yq7a2GAiwRVE4GBaoRa3Opr9nhpbAeOWZRhDSvDr89BKib6RXPkplXeceBvv/HD3KZdjE6mPXql+sj9/eQkf6V+caCSu73KtjFHRqd9YfbtrIHref1Pat6B0W2FiM415ySPG9/6AxzqtcG0coKobjroTNxKGmUl4dKG5tpPCYj2QkFWUM2eL2I2ttcOhWy5RU9aqnteyZxogPMiWqm0GSCqtepJKbxT18+6gbYV5P85r8p0OjQWUQQ5+/d9cseAusC3lEGb09NgvIiiVhwAgZFHdviN/ArQQtKnW9x8GvkVYMgD5A7XqjYGv7KrJ++c2a58CpMGtaOyWL6ppITaWbqIn7Nv2Kd2qN4FjHdahESjqGRl8Zrg4CXXQRgBpdUDGgBYyaUocS3DSg5dKPHBkJ6jpLnTeqEo+ZncVd6Iaogu5tHsckmq+/7f8oTiw5krTB+2ffunAk41v6LUYnLgDCxb8Sr3vWkDliUmOFca8divlqiV5mj6ojEvjfXyn1XbTMv+z9tMEblMky1aXkqTKn1uue9o3tzaS8LGGaD5AQE63o0XE02vRdGINU0YRSp/cS8oUI9Uiq6cH/Tk6HL4ZI/1QNT393xLu5ifGeuMzoe1Sph9sNU8b5J9j3QRpXBNKp1X1ZlUTrd+wDCHBPAtClAizxWYUlfdG1KtGLCLydYn7UiXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199015)(38100700002)(76116006)(122000001)(66476007)(38070700005)(86362001)(5660300002)(8936002)(7416002)(2906002)(91956017)(66946007)(66556008)(66446008)(64756008)(4326008)(8676002)(6916009)(41300700001)(33716001)(26005)(186003)(6512007)(9686003)(83380400001)(71200400001)(316002)(54906003)(6506007)(6486002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Hwv4GjxP2m9k1JjYIMmYBiHI6b4YydfCxH0ymboER8GYNEi5X6OeqrHEMCm1?=
 =?us-ascii?Q?C75gllJARblz1HHjiNNRY1nkTLxBdLTD2dHqqIhy/tXg2UyXzCspDosle6+H?=
 =?us-ascii?Q?GaYd+f8wUFaVKKhvlLIC3gLQA29gK7x8rh8TyG2Wwn9y25ZkwFqSPtOp61Rb?=
 =?us-ascii?Q?ckmNf414JSh8Mu251cV3zq0kkIiRLQTis0TF1ax8Flt9T/y3py7qPKcK/ZwY?=
 =?us-ascii?Q?1/iCbggeXrmsDFI3Src45NcmmyYM7POQ/TjCezV2k/KzreMMoifZpqluZO50?=
 =?us-ascii?Q?5phGKYO3nCMfNjSHMkV1FxGJMmpBktu9VfChmT6budm+Fq2YVXnslZqmOCEG?=
 =?us-ascii?Q?rCGPNcuCJgrdMl8yL5i42ghwDgzJKBVoh/TbZFB51UYwE6eBp85nYIhbpcwB?=
 =?us-ascii?Q?TOlhDrfdofjJbzFAXrBjm73lUf1UhPDwsGRlOBwKTMSDs74iQMkV3UloodRY?=
 =?us-ascii?Q?OaWQNOwb2wF5GIg/ITJmk66+NMPWlMZnc9UvajQdMYBBa3hj4ZSUR7k+FD49?=
 =?us-ascii?Q?n9KH7NM3EFhaokYveKgjNvLuYmcglS9LLzdJeFTg6Kba0O9CmqEN+RWaACly?=
 =?us-ascii?Q?0tXiU7/dMX6G8NXSRYHPGoK5frdzQCzXPXmvnc85rVoo5JEJOXhRv7kFLB+c?=
 =?us-ascii?Q?GECfI6SuktNFsg48I2Ov3kMoh3S9wvUSPYLlRWTgjiMj13V/J69bMsI5YF6B?=
 =?us-ascii?Q?dA7/Gr4SAvuxzlkYJ3NYpC+4ERwXZUblnEhUxVK9CroWCx1CWAn4S8n9+qa4?=
 =?us-ascii?Q?C1ISO+GDddFYYd6EnM9MgicJplN6I0cQBhzXatnkTzOqA2nnnf5ooSj679Vg?=
 =?us-ascii?Q?1uM0voqxeExI3GPT4L/gZwPCU9en/SOd3V8zJVo13+LFFBp0ob/hCEJoJJnw?=
 =?us-ascii?Q?zsP1oJKnOo8wrfH1b/tBO32z7HxY+dGIjOXXyFhNwF936RFKks4dpeNUtTjt?=
 =?us-ascii?Q?FcUr2hbD5bomq46tJ6OX+N2wti3f8KRjgtGbXsUzKSYK0QpO5RTeovd2wJGB?=
 =?us-ascii?Q?TWlguhZCYJ21Wnf3yl21tFhGmX5PP4iKX8PsNUSbvXZPFUcSPadbgUx+Vl5o?=
 =?us-ascii?Q?TGPIDnJSent4hSZ0bc/cXJRCjx2JDATs4Ah06IcGJP7badR+kwLvXEHYWkzO?=
 =?us-ascii?Q?eq2l0Gfv7zaPempm1gYBrUrYkKKufqKr2j+65N2JYtqQXEoTe5juzLhCBzfa?=
 =?us-ascii?Q?i1WpNi88V8s1+Bbd++L2sUZErM8Kk3XjTPaR4Yu95wTpERDOYCrEHnwBcL14?=
 =?us-ascii?Q?9XQ6ShPmCKKlNbbF2iVjRpeUcpR5SCZ6tkoIkbVSxOro0rUIHcZOYXy8usOu?=
 =?us-ascii?Q?iSaSSkc/YABo7iDLJKDAk964A3zAYxsCM9rF26g7N3oXKLpfHtp57rva0W/N?=
 =?us-ascii?Q?s6HSmLvs/TKorws3EFGg3Qs/0rKtFz8k3qY984JxkSAVxBEM7RFVqiqEPASN?=
 =?us-ascii?Q?0S5rTykTXRY+8iQQR828peMJtRsCekRKki/dB3tA+m7jLe28V7LWXrI2RwiA?=
 =?us-ascii?Q?1dPa9PNCuSgJyhJFkXPGz3+ixMEmxQzbvS8+5b5xLeuS4+yLkRKT+2v3lU7Q?=
 =?us-ascii?Q?pg3bqT5qdUoWeGYae17w02weyZ4F7SGld2tdeRSCpCTbs5XfywM1YroZAlAw?=
 =?us-ascii?Q?1Br9MuMKvEJLEQLJOZ0nJpU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CAFD1C91A3E425458FEB53CCF15CE29E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b025c496-875a-4107-1db4-08daf95a9b6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 13:47:57.5517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JTSPfS/1zAAix1LnieDkXrethudKD/H1gy8mxmZPM4lKK415cYEnzcKCL4jpeY7MyNBAfbBh0vsxOggPw59+foOJGsXJEoylje5S06ODIeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5552
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +     rewr =3D nla_nest_start_noflag(skb, DCB_ATTR_DCB_REWR_TABLE);
> > +     if (!rewr)
> > +             return -EMSGSIZE;
>=20
> This being new code, don't use _noflag please.

Ack.

>=20
> > +
> > +     spin_lock_bh(&dcb_lock);
> > +     list_for_each_entry(itr, &dcb_rewr_list, list) {
> > +             if (itr->ifindex =3D=3D netdev->ifindex) {
> > +                     enum ieee_attrs_app type =3D
> > +                             dcbnl_app_attr_type_get(itr->app.selector=
);
> > +                     err =3D nla_put(skb, type, sizeof(itr->app), &itr=
->app);
> > +                     if (err) {
> > +                             spin_unlock_bh(&dcb_lock);
>=20
> This should cancel the nest started above.

Yes, it should.

>=20
> I wonder if it would be cleaner in a separate function, so that there
> can be a dedicated clean-up block to goto.

Well yes. That would make sense if the function were reused for both APP
and rewr.

Though in the APP equivalent code, nla_nest_start_noflag is used, and
dcbnl_ops->getdcbx() is called. Is there any userspace side-effect of
using nla_nest_start for APP too?

dcbnl_ops->getdcbx() would then be left outside of the shared function.
Does that call even have to hold the dcb_lock? Not as far as I can tell.

something like:

err =3D dcbnl_app_table_get(ndev, skb, &dcb_app_list,
			  DCB_ATTR_IEEE_APP_TABLE);
if (err)
	return -EMSGSIZE;

err =3D dcbnl_app_table_get(ndev, skb, &dcb_rewr_list,
			  DCB_ATTR_DCB_REWR_TABLE);
if (err)
        return -EMSGSIZE;

if (netdev->dcbnl_ops->getdcbx)
	dcbx =3D netdev->dcbnl_ops->getdcbx(netdev); <-- without lock held
else
	dcbx =3D -EOPNOTSUPP;

Let me hear your thoughts.
