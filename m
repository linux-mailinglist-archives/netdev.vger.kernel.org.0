Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E32644FC9
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiLFXpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLFXpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:45:03 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F72E30F6B;
        Tue,  6 Dec 2022 15:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670370302; x=1701906302;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GFiiW54+jst3kpBlnIKNHI50Ubnlbj/j0BGpVSmRMRU=;
  b=k3HPmv43FryAIzSNiBMnaGhirDHhbmtNpf9PrfJVoyvmh20olWndwJNU
   0EI3W30VlI8DlNrGN+NIZeEOUgbcPMwJ8terHfyH3JNokpE9TA6HrqNIR
   krxh2xZSw/Josvqn2Ws8DKbfJQJK1MCzm+Y9pNBKRbZ3/EcnDu5+OsggW
   xqVZfSi0YtO5BFpn3djUDVPczpF6MfKUZuPjll9gE+DzWRd93gSrOeokP
   fu61Gkfc9ZrB4JOGVjyHPtVXr1LMRalD0ALh9ThF8Mt1ZzL7GCQpeDhMD
   PJ85obfKMjcYcaeJzHOS7lnGPL7FZwlwrNrsxugL3t0SR7+Iw0XinKsaC
   g==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="202895779"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 16:45:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 16:45:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 16:45:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDmY0es1yfLKPV2xmBRIO6H6SZpb3CnNO54MlL6cUUZqIH5D1UX4QPOXvlQAAM9xhy4cUJPbzvfBuR2HYmgKOMu0XRImkR3vk6OXCsRxuCOCCnxZcQTXGFdojqiPpJHs2wwssIdak3BegTEmj8ESJjkv/X63rgZIZpjGVL1aCR5uuC48it5akAIvaQKTZ9xF3hSe1UBuUI5vQt5dLdqkrvbTcvK4HA3jE1fzZMA6Dg7je0ugmivanyf/uKunN6SD2qRVg9/HQUaqcOknmKIqXDrZWaCMaIIQIbCr26S7ot1H779TkhRS3wsfqPlbXL0mKG06S7eK0z0jHLXQ7FoYMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h5bfSYaOEOPrSzqW/NZl/ljA0N8KzTxA/LCXc9mmdBw=;
 b=BP/fSCvoFWi9wTOVEHjvp9sLplEKx6GtXYPQsO6dj0WBenjrgk1Z9X6vmSeVfl6jqBmv7zMolNT06N95MRONgeydFRw32n8cPeuG5TZHw2dIc3VbSx1M7+2hap9GJsrl0piwwo8GSbiWnaPYjt56cdzbbetQKMCDuFePuNTGcrduxJXL/UK0TYFo76D4vRp2QQpMYvtb03yBVeGhG0ejzSOJpYWU597x0OlZgPhI+KGFYOe0HE+kPFMbYNMWxTCYRuk1je52C5lFV/BwSOQURf/+73e5fieEUDGeW0dlE/xys1arCyvH2Bi6kYuwv6nyzAUcw+NlkAaX8Lgw3GcvJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5bfSYaOEOPrSzqW/NZl/ljA0N8KzTxA/LCXc9mmdBw=;
 b=AH6Bfk7Lj0gjNEyA3YXBrNwboWPj308Hd+plLrTM9n9di7MTRR0eu9lMFonrOyrmdfYJO275VbP1cTETirzrAeof4eRlq/zsOzzn2iyqGjiC2Tj9FbuGeyQ3RQZYeH1eyixopgZBMmQ2o39UY14hMuxqY/yJz5GPQt+MEywMOKo=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by SJ0PR11MB5868.namprd11.prod.outlook.com (2603:10b6:a03:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 23:44:58 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 23:44:58 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next v3 1/2] dsa: lan9303: Add port_max_mtu API
Thread-Topic: [PATCH net-next v3 1/2] dsa: lan9303: Add port_max_mtu API
Thread-Index: AQHZCaGGUS2s+i6LNUmfdfFZp/Wl6a5hNZMAgABQdTA=
Date:   Tue, 6 Dec 2022 23:44:58 +0000
Message-ID: <MWHPR11MB16930878ED42D3F4CC95A015EF1B9@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221206183500.6898-1-jerry.ray@microchip.com>
 <20221206183500.6898-2-jerry.ray@microchip.com>
 <20221206185616.2ksuvlcmgelsfvw5@skbuf>
In-Reply-To: <20221206185616.2ksuvlcmgelsfvw5@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|SJ0PR11MB5868:EE_
x-ms-office365-filtering-correlation-id: 62ecb261-8a46-4c4b-ab34-08dad7e3e274
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2B/itd1aARae9i+dBf1cArrVS2J5MB7Kv7APs4y/m/VShdYhRk9jr7cbnECcgC84vSFWEZZjZEcG8HBH+tEhFc1MbXw5NcGDFMzZeq5vVYKLbkuZ9NhQz5/ddMHzIbAsz7vcGT8rUnWvGbHhHiFyXrRPNFFcb+VUGqDM5hWbULiFm4GK6MZ3Jnx8tkLo44/B7KR0auXIPGqlfZzQLA2BTKarjoFIyq3AguUUE0LLZkhfSD4La6d1cwxjuE6JoPFFEPcNvn0aDmp4VmGH1RMcDeZOuS9scz0Gye0sgOaOECX+j4qYDNh5BsbLB2Ul4nqheqzYiSM86ST3oyFOT5CXqi2PUFTSnLDtjkvyByZygSxIFWD6+WAGK4AGgO8c9vZo1zV71a5vDu50vUrfDI5vvYyKhYRC7zjAQ8QXerFhRyVyC6eM2DUyGu5qCiVVJAEWYVcWCualPlz5qG3XcvsMexpMIjUhqeb1GVzJv0BV6tekrVi2eoRVHboelmPnIB76763inFR2EUx4MsF1um3bCElN0MTHwOIogNjESmWphJCtiYcSNu2tuRH7OeyzlhkoDFapU3ULf+1/V9v7xz2O6jF1wUsXKjuzlp8YKOPChEOb0nCPd+dDgMrTKeDcMBny6JI1n5olaM+UHRXDNbqfxrVytETupVRnpi19zzuKyLNwZIVLKAdCEE6G6ggiI4gR+N/WMa8fsS5O5+eeySNE5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(55016003)(33656002)(478600001)(38070700005)(7416002)(38100700002)(6506007)(7696005)(71200400001)(122000001)(2906002)(83380400001)(8676002)(26005)(41300700001)(9686003)(52536014)(186003)(8936002)(54906003)(6916009)(316002)(66946007)(64756008)(66476007)(76116006)(86362001)(5660300002)(4326008)(66446008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jArNnY7wGNOTQcQ6lD23JJAJjjo+j77Jk939ZNUgGVqwhZ4AoiJvK46kVH5H?=
 =?us-ascii?Q?uCJyoWyXo9Gv13d1OWdYoE9aGzOW9bxuK1cLGU1yika/emDe+iYFbSfbmZ8r?=
 =?us-ascii?Q?M2mQXsewbZSPFL7Jg2dkXWUNMAquroJjfF0rnN55OkOeCv7MxNAkcSBgn4bf?=
 =?us-ascii?Q?/pGnJoGXgjJvWQ/YDqDSi06Jpk1T/stJ3bAppOfp/GbRLcArsWIhh7pUFnrp?=
 =?us-ascii?Q?WBy13bk2z9Vd2ePuhWbPVMJltewvywlP1c80dwGGiq/OMScgcPR42akSWecE?=
 =?us-ascii?Q?zBzgOHuIPREMD8AaWrb2KE9rjOEBTBsPo36OAlUi6U2j9AsZROLITsEvoCN1?=
 =?us-ascii?Q?6y00VBCQIQSso3Sfq7scc3U23Fb3r6Rv0Of7lZqI0yFuCdFAQDh99m3SbBZ/?=
 =?us-ascii?Q?NTJrlRDAq5v8Wm9R65MvHlZzAISDPeg02Qh92kFTaCqHvQ1Px4CbrQb5SgA3?=
 =?us-ascii?Q?xKqjN1VNka6moz47i2xVyCt6ETNB1ee3w4nKojtVUYDwxRSynuEN0wUNaVwM?=
 =?us-ascii?Q?J6w0dc4Va0+2CClhksBLxwukGqO1QoRC3MwEWpaD9LlqT5db8TIRVpNHftFP?=
 =?us-ascii?Q?qruBSo4xzbLULb+Tr1BGKJ0CpBTtiCw+byQd6C227e5Sha0qsBjCRUjnKmW2?=
 =?us-ascii?Q?S5qClPxHHmR568ycT1p0nVn38ZXvlInbwenKNYDECvWXvUctAKAptZoHowVm?=
 =?us-ascii?Q?1wr9BKKu4Khph0RAIfihxsXeiSl8akcOX0Myvu01J5f91A7LwaUUsML3HgEZ?=
 =?us-ascii?Q?hsR2bBX6ec0FiwTseFyRQtr6y5w8FSMkzlCEU/Z9p2m7CJlJQ9e0439q3YJV?=
 =?us-ascii?Q?bWZLvwsLFpI2g+HsLYY1/poFFgR+fjV+gae1xxDHJbP9LYUU5BzlDCkvLfzK?=
 =?us-ascii?Q?3RDbef5IPGz/9BoX/N7iBB9X+hM4lO/mHvbKiIiRquqkncezoo5JT6B7pSYm?=
 =?us-ascii?Q?tqrPloEv+mUONdiZt8WBw006T78f6d4H0G/8pJcVlHnNbb8naSGRBGx+JZsd?=
 =?us-ascii?Q?u9GC9xv8PO25BNtL5SKm+dw4VzFSvUDGKh69vQZCP1FiWm1fWpfWWDH65GAQ?=
 =?us-ascii?Q?Ik3AuXxacXKAWBfBN8xCGW62SF366l1M8Ac2aGtyIAvcN+NAmS4Ep10+0L9Q?=
 =?us-ascii?Q?hTK0a5HfqeO5OB1ueh2cJuxFRg0RBCJnmxBSiNDWQbA3/4ZBZdfipPjS/fV9?=
 =?us-ascii?Q?g5OhZmGflJwfFoE6mJ5mKAMaj4rkn6fe3IP/N8lPtFkzR1cElmfAP+DOqFVe?=
 =?us-ascii?Q?Hpa4LU/Sh/YbhFK1xYvU03TtA3SkkniTYTEeRKXa4yf/emf/EFMo1Wce+2NN?=
 =?us-ascii?Q?vgGWAIlYvBJoTy03i0XbO4KscKlKN/HImzeITxPOvRftrQyq1yHI9lB9hGap?=
 =?us-ascii?Q?IA2mLXSrfCC6xLxcQj5V/7AW7sg2jiQKJcxweEWhD7Z/A95k3O8+h5slhNNf?=
 =?us-ascii?Q?yUDm0Z1D9c8S5o/DYLGYPOLhfevC0EPr6daj6wZ1cpF/JdwY2WDi/iDhkS0d?=
 =?us-ascii?Q?TzFJ5EznfFF9J3vNaNDOKMfnK5zfiUUTh6wdp6p+f69d79vyv5tptenZnGad?=
 =?us-ascii?Q?xvPKj7ZOcDflNc92kRDPkJMovXahkXgaDG1FRu1R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ecb261-8a46-4c4b-ab34-08dad7e3e274
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 23:44:58.2878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TAHeiVlk4oOgSAs/Rx7UJ0F9oAPOW9p5xfsNao9kEMWAyG20HUqNHX7VV4d6qF5ors9+1eOOxkSYBK+1Alp/rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5868
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +/* For non-cpu ports, the max frame size is 1518.
> > + * The CPU port supports a max frame size of 1522.
> > + * There is a JUMBO flag to make the max size 2048, but this driver
> > + * presently does not support using it.
> > + */
> > +static int lan9303_port_max_mtu(struct dsa_switch *ds, int port)
> > +{
> > +     struct net_device *p =3D dsa_port_to_master(dsa_to_port(ds, port)=
);
>=20
> You can put debugging prints in the code, but please, in the code that
> you submit, do remove gratuitous poking in the master net_device.
>=20
> > +     struct lan9303 *chip =3D ds->priv;
> > +
> > +     dev_dbg(chip->dev, "%s(%d) entered. NET max_mtu is %d",
> > +             __func__, port, p->max_mtu);
> > +
> > +     if (dsa_port_is_cpu(dsa_to_port(ds, port)))
>=20
> The ds->ops->port_max_mtu() function is never called for the CPU port.
> You must know this, you put a debugging print right above. If this would
> have been called for anything other than user ports, dsa_port_to_master()
> would have triggered a NULL pointer dereference (dp->cpu_dp is set to
> NULL for CPU ports).
>=20
> So please remove dead code.
>=20

I've written the function to handle being called with any port.  While I
couldn't directly exercise calling the port_max_mtu with the cpu port, I di=
d
simulate it to verify it would work.

I'm using the dsa_to_port() rather than the dsa_port_to_master() function.

I'd rather include support for calling the api with the cpu port. I didn't
want to assume otherwise.  That's why I don't consider this dead code.

> > +             return 1522 - ETH_HLEN - ETH_FCS_LEN;
> > +     else
> > +             return 1518 - ETH_HLEN - ETH_FCS_LEN;
>=20
> Please replace "1518 - ETH_HLEN - ETH_FCS_LEN" with "ETH_DATA_LEN".
>=20
> Which brings me to a more serious question. If you say that the max_mtu
> is equal to the default interface MTU (1500), and you provide no means
> for the user to change the MTU to a different value, then why write the
> patch? What behaves differently with and without it?
>=20

I began adding the port_max_mtu api to attempt to get rid of the following
error message:
"macb f802c000.ethernet eth0: error -22 setting MTU to 1504 to include DSA =
overhead"

If someone were to check the max_mtu supported on the CPU port of the LAN93=
03,
they would see that 1504 is okay.

> > +}
> > +
> >  static const struct dsa_switch_ops lan9303_switch_ops =3D {
> >       .get_tag_protocol =3D lan9303_get_tag_protocol,
> >       .setup =3D lan9303_setup,
> > @@ -1299,6 +1318,7 @@ static const struct dsa_switch_ops lan9303_switch=
_ops =3D {
> >       .port_fdb_dump          =3D lan9303_port_fdb_dump,
> >       .port_mdb_add           =3D lan9303_port_mdb_add,
> >       .port_mdb_del           =3D lan9303_port_mdb_del,
> > +     .port_max_mtu           =3D lan9303_port_max_mtu,
> >  };
>=20

Regards,
Jerry.
