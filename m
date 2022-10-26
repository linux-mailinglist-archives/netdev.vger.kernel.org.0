Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D119F60DF64
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 13:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbiJZLTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 07:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiJZLTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 07:19:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B60715FEF;
        Wed, 26 Oct 2022 04:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666783174; x=1698319174;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4UsIQ0F9oFKUdIS68eiFz/DNfsueZtWtjGhsq1ik+W4=;
  b=w0hDr48zi6KA9CqIygK2SXP70CUvT6+GnA9fQOg2FWqyhEDYW/qGdQPU
   J2PmJFD7/p1BOPYt+X++wWFTaUPCRfVrEK1zh7so+nDOjVYJYLhgysXah
   mTq3SeqlKFkWyohKMCexBtEUQyQHhs7J1mMkbaylEF+aQ+3eIpuHzylSF
   NVpy7q54f0lmfxDVvXhB3OkKcN/IoVHiy1jqJD71yjkez7zpY4iz+3P09
   GtRgn6LwUj+JgNvgP1Zjzq4D/1U6h4Trb2CjrBKNG9mD1Onq3VdShD/B8
   9vkNOmIRRFVru4zwN7Z1x14o9AiyqKp1TGhIYVM/I4aZH8N4QMt45yz4t
   g==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661842800"; 
   d="scan'208";a="197093365"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Oct 2022 04:19:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 26 Oct 2022 04:19:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 26 Oct 2022 04:19:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvPS4PygCLUV86DgWxyyR5MoEJRp2vcrEzyD+ZfAr5l6dEqBq8mEQG9vf1JJQS3kFDxqSKHoSvnxp4KNBpxk2n6BORKU7IwJ83ZnRiOKgyaRJYdm9EYQ0PHz9JVkCIGtZH67zCqKksfHQmVb1PqGln4NC3v1d7p8hLJFB3mREhK1y932LyEPESnhy21qUTQK6QS7DtMJxx1YKmkh8nVoKpSt/l7AQmDqQCzLf0OhFAetIIfQ9V9mbbQ5vsbyktzfLwBevFO7Wv/OipMrKE6O+GjizaJL0dI9KyG1JdaXGL5HFHfzRjq0rD0QUK4+V/5SQ2pvpSb8OYRIQV2/G3EByQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LkWFH9EIPInFXkb3b3G4VV8G7ha4cg4uX+IgPJKnnaQ=;
 b=egca4Ku6dPpc08VdE7hZDqnlCbPRqKXAqDAEORTcw5il3nxCR2Yexlz6idSOomO4UXlXtiB8W/P5Tk181V7r42zJQJOpbG4sQvcjJ8gQ9w//r9x9tb8EMCe2ViAUHODzEjXJJKlg3Eng8fgwtJKdjLJUCs/kD+WLa8/iQKY3s4NFmCGnajM2IRfv4qY06GRl5XI6TRNwVUXa+Kt6MEVyXa6Xs04mOyUUc7ots5+wo47J1PmhlFBvPJqb/qq1Xfx+JoPtkdu2Fq71eIXopi05J7aO3QhQtzcey/+rzMj+gWkpOOFk/0+9Os9Qwq2PL1bWQFpJKHXxv8Pjc93dILEeYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LkWFH9EIPInFXkb3b3G4VV8G7ha4cg4uX+IgPJKnnaQ=;
 b=S5xQtFGqpvpz23YGR+1Lod09O3x+huS+BRKohGf6JMMZCBvnn3A1K17a4Jg8wNImCFdtw+KMRjLB7YpuCugR87H/LevQIdTPqQNng5GLOidBLJkAG/Nbqmk8IP7U5HZfuQ7UAkQfV2eFIn255kLApLNx+sT0NRbtNdBwg+iHtg4=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by MW3PR11MB4587.namprd11.prod.outlook.com (2603:10b6:303:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 11:19:26 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::a2ae:2047:6ef5:6a45]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::a2ae:2047:6ef5:6a45%5]) with mapi id 15.20.5746.026; Wed, 26 Oct 2022
 11:19:26 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [net-next v3 1/6] net: dcb: add new pcp selector to app object
Thread-Topic: [net-next v3 1/6] net: dcb: add new pcp selector to app object
Thread-Index: AQHY54e/oXdDISkOjUKo8XH7CRcTxq4gd3gAgAAV3AA=
Date:   Wed, 26 Oct 2022 11:19:26 +0000
Message-ID: <Y1kaErnPh5h4otWe@DEN-LT-70577>
References: <20221024091333.1048061-1-daniel.machon@microchip.com>
 <20221024091333.1048061-2-daniel.machon@microchip.com>
 <874jvq28l3.fsf@nvidia.com>
In-Reply-To: <874jvq28l3.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|MW3PR11MB4587:EE_
x-ms-office365-filtering-correlation-id: 01127928-b20b-4c92-1f37-08dab743f14d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a6dE+lJi76Q2ayQhuL+3Qi7q5B+opHMs9MckW5AVt+Mk+3EnxTZgh/Zoi+yn4nj+fUCHd+81ebhE108kDs9mJIiImnkExBjXeLlQ0u/KI/kxJz2dgYR6RXBESFdwBcjR5lCPX9w1utRCNlxZKlWLJn6XRPsi62R+e0NJgK/tnn+fhXIeJHNPNSj5OQkqhI8bL3vluxTjoT8IqIHa4VkUDZX7VMubPnFqpQ7XfkFAxqtFKh7N+OXAIDAkLxPPF6eC4X2TyqDeXa+uPOtJIJ0BBFYuGHHy9rmPA5OmZeq29bccUG8lrDKB2kgldHQeYSw2L3Rcj7K625/BgqndydlLSIdwLgpKDY70a9kUgU/8vrI0WgRORNSLbZV1hcSGOMmdj4moLAdL0boGOP6jeKrDvzdgrAuPxZlwtpu6v8fovvsPHozYH8GL75tfgyT/OGSNC/X0r3ZH1UdFYKYjQg2jlfIHVHsice46+nh8pCEolZRF80f7XD4GSifAyk84RsdfqD/nn11GXEySn6w/K2c6F+xB2QhJ2Oj4j5nfaeuntAGvDA0vVyA4bZuFBUseiPeVZlQb3mP96XAgWUTEzfolRYnQAhKqpgGjkXf6OYOXAnaw2nLXI5UT8PTpMNg/Wzf7nm6RkKvFBlcje2UgQml2RbQZsFxMgGBuScs4I0Jc9//XVZrjg/FRLIlVehMYfjP/Am03LA9e/MGv00apiLz43w0zNda250yb+9ViQX8WEpnDtjkK4zq9AVN0o/3bqCnI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199015)(33716001)(91956017)(478600001)(5660300002)(7416002)(2906002)(38070700005)(83380400001)(66556008)(64756008)(66446008)(6486002)(76116006)(66946007)(41300700001)(71200400001)(8676002)(316002)(4326008)(66476007)(8936002)(6512007)(186003)(6916009)(54906003)(9686003)(38100700002)(122000001)(86362001)(26005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Y9Fntu87VXdIM4rrAZr/V+rdwR4MN6PY9BawfbwNf74lB1Kq88J7ET4ZX054?=
 =?us-ascii?Q?02nqh96SbtVoBRpEJnjnCcEF94H3SEQgJDsHvUOzVnEXbHyo5JxtyBmDEUQw?=
 =?us-ascii?Q?564+0qATOdclbuFlcggN0I0H6T5W8RftKWvct1oMGSlqqdL5JDuqDECLOwF/?=
 =?us-ascii?Q?cq3dHtPI2zUyh40ERnh8L7lGkXa/lGfxUqSA6J9S2PIuJZ3Yo2WpmqDnJrzZ?=
 =?us-ascii?Q?hyxIRbgDK2CNUl1bqQ8NzOTAUMwuW+OlXmv3RzdiN4cUcpMLE3ycXbg2ZXAD?=
 =?us-ascii?Q?HLfIRBbMo5rPuMcfoGWa94+1/x+hzcNMSS8bLy0m2RQKljU4VntaCRk4/eyA?=
 =?us-ascii?Q?SurKuIaS2oPi19CAs7qf5jiBHNJlu+1bfBKGbtWCi+izMG7uIwbA0vwS1lOh?=
 =?us-ascii?Q?/LEET5OQO/RSOZJM0sODdD0FkJ/23ri8fRaCUucSvPQ6w8rDil/5W5VKt5U1?=
 =?us-ascii?Q?SQ6kDmL1jJOqiQQbRSTmHtCU1VyasUECX3rdHFg6Xf55rXcHpUFqOgWIwWKw?=
 =?us-ascii?Q?bMUasJgMDBSqbsneAc7BeLsmq39gk6gIG3ZQjxWo/wn/47jGYT9mUax/B7/1?=
 =?us-ascii?Q?GeGsyHP3DQEw7QufBDUkAK3KQ+EPuWlM4Gw1rEOIDLhRov4gRy4s+JzYzB4+?=
 =?us-ascii?Q?CMzjhPf4ZHuibiboD9ZtXXLknsWbY6px5JZwVqU34pvvllLDwh3DVTW0tIng?=
 =?us-ascii?Q?dc40C+SYRFoN4wgp72OBKCfKi7TVxr1qlqOXhbqJET3IVSGeCinDet8uMni0?=
 =?us-ascii?Q?FSjP497Jv4KahPoOUFlqa1j9TwnjT6CT3cTE1bvzp7+rbyNnLewwoiy9NNf2?=
 =?us-ascii?Q?FGE7KmGSpB0vRscTNIjz1Gqk99+ijyHWbXb4zNpm3RmVvHtoHL+43gHz7/eK?=
 =?us-ascii?Q?vlAlMBSIL8GP1hEDcXRgNndj0mwEmqKZfIfq5U+1aiiObC2vtNtG3ZwomTM0?=
 =?us-ascii?Q?R2+dD3EYKe0U26UDoga950iYbO0grI2kdHcWn8Kx9RFHegK73+YE+qFJ3sqS?=
 =?us-ascii?Q?NKIZakZ9bXh/VU+EZEflRTLuLZ9BLlqxV7er49vLUaiqoXCBCGEszbIATSYJ?=
 =?us-ascii?Q?upT1s4jKbKTisB2mmsRCiVEn/yfmch+2LJkxW7cleTP11vDTwyftzysRdOcT?=
 =?us-ascii?Q?uCUxbdh4cuKxzE43z44fTV+LcUrbzF7jddZvx7eBR4RHzSxpFNP7h12bSkuF?=
 =?us-ascii?Q?BEKTfy9uBbpO6ACV6y8m27kX1r9LD3f8koLBmll0onKD6w7i4gCmHt/5QNOY?=
 =?us-ascii?Q?cL/YcZv9db+ocvV0mqeaTZTl7Bqojj56MXJh3Flg3P0qbG4ypuztPOxac3Kv?=
 =?us-ascii?Q?2D+/LY4QjNRWQPm+8moS1yS6PKyCdCNSALWwAx/kACkIJgWZ4Fwpq7JweINx?=
 =?us-ascii?Q?yx713l61uDJjqJ0OOImxtyVgofYPJi1nHG+emK3twoe2hVPFIvSuYKUmcZNH?=
 =?us-ascii?Q?OkBOLCG1sEK22GJxl0GIwfoLZJvmn3qLo3qC7knT18ltHvsqX4CCUIWoRbAz?=
 =?us-ascii?Q?Tw89NT5DOp3EQMYD9/YCUSLKkfkX23FV/h/BvGtV3/GwxPisWtx1V8o2l6JR?=
 =?us-ascii?Q?9csDNewG64ghI8lDD1CxfyaIryWS/aExHOLAsHgWL8T2TXpOIZvlI/KgcGM1?=
 =?us-ascii?Q?tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FAA1B9A57DE24440BBFE276EC19C7CC2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01127928-b20b-4c92-1f37-08dab743f14d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 11:19:26.4776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TPPMSBFR0bY23qSu6tE2uXDxzvyYFhRFXgeUGtuObAD3YvN+0eSwWySQIdZU8pszoiUeAu4xqOeMO/Y60ykcxz13n/JAvrcaejB7SGJRu58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4587
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Add new PCP selector for the 8021Qaz APP managed object.
> >
> > As the PCP selector is not part of the 8021Qaz standard, a new non-std
> > extension attribute DCB_ATTR_DCB_APP has been introduced. Also two
> > helper functions to translate between selector and app attribute type
> > has been added. The new selector has been given a value of 255, to
> > minimize the risk of future overlap of std- and non-std attributes.
> >
> > The new DCB_ATTR_DCB_APP is sent alongside the ieee std attribute in th=
e
> > app table. This means that the dcb_app struct can now both contain std-
> > and non-std app attributes. Currently there is no overlap between the
> > selector values of the two attributes.
> >
> > The purpose of adding the PCP selector, is to be able to offload
> > PCP-based queue classification to the 8021Q Priority Code Point table,
> > see 6.9.3 of IEEE Std 802.1Q-2018.
> >
> > PCP and DEI is encoded in the protocol field as 8*dei+pcp, so that a
> > mapping of PCP 2 and DEI 1 to priority 3 is encoded as {255, 10, 3}.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
>=20
> >  static struct sk_buff *dcbnl_newmsg(int type, u8 cmd, u32 port, u32 se=
q,
> >                                   u32 flags, struct nlmsghdr **nlhp)
> >  {
> > @@ -1116,8 +1143,9 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, s=
truct net_device *netdev)
> >       spin_lock_bh(&dcb_lock);
> >       list_for_each_entry(itr, &dcb_app_list, list) {
> >               if (itr->ifindex =3D=3D netdev->ifindex) {
> > -                     err =3D nla_put(skb, DCB_ATTR_IEEE_APP, sizeof(it=
r->app),
> > -                                      &itr->app);
> > +                     enum ieee_attrs_app type =3D
> > +                             dcbnl_app_attr_type_get(itr->app.selector=
);
> > +                     err =3D nla_put(skb, type, sizeof(itr->app), &itr=
->app);
> >                       if (err) {
> >                               spin_unlock_bh(&dcb_lock);
> >                               return -EMSGSIZE;
> > @@ -1495,7 +1523,7 @@ static int dcbnl_ieee_set(struct net_device *netd=
ev, struct nlmsghdr *nlh,
> >               nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], =
rem) {
> >                       struct dcb_app *app_data;
> >
> > -                     if (nla_type(attr) !=3D DCB_ATTR_IEEE_APP)
> > +                     if (!dcbnl_app_attr_type_validate(nla_type(attr))=
)
> >                               continue;
> >
> >                       if (nla_len(attr) < sizeof(struct dcb_app)) {
> > @@ -1556,7 +1584,7 @@ static int dcbnl_ieee_del(struct net_device *netd=
ev, struct nlmsghdr *nlh,
> >               nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], =
rem) {
> >                       struct dcb_app *app_data;
> >
> > -                     if (nla_type(attr) !=3D DCB_ATTR_IEEE_APP)
> > +                     if (!dcbnl_app_attr_type_validate(nla_type(attr))=
)
> >                               continue;
> >                       app_data =3D nla_data(attr);
> >                       if (ops->ieee_delapp)
>=20
> I'm missing a validation that DCB_APP_SEL_PCP is always sent in
> DCB_ATTR_DCB_APP encapsulation. Wouldn't the current code permit
> sending it in the IEEE encap? This should be forbidden.

Right. Current impl. does not check that the non-std selectors received, ar=
e
sent with a DCB_ATTR_DCB_APP type.  We could introduce a new check
dcbnl_app_attr_selector_validate() that checks combination of type and=20
selector, after the type and nla_len(attr) has been checked, so that:

 validate type -> validate nla_len(attr) -> validate selector

> And vice versa: I'm not sure we want to permit sending the standard
> attributes in the DCB encap.

dcbnl_app_attr_type_get() in dcbnl_ieee_fill() takes care of this. IEEE are
always sent in DCB_ATTR_IEEE and non-std are sent in DCB_ATTR_DCB.

/ Daniel
