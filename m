Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E872C60E068
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiJZMLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbiJZMLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:11:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D054491C6;
        Wed, 26 Oct 2022 05:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666786231; x=1698322231;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w52UFWvClTdw7CwIPvtVZRysG8gCu2aRNukjc6c5mQ0=;
  b=d7NJmqryVzBF7T/cKSftHTTAawyxcEuIqvJ7NvgANFcj6T7jnCzAXTVG
   gPve8TLOPU2bxfeksY3PKW5O5osv+TdE9+RHoLw1r2K3+g3tCwH1zIknJ
   cM48dejvfQkc3PCmYOZ5P8qLHZU+4MY6vdfXElagT7dSF82xTX2OYIe1c
   M5ShM51rEpApH6HhFKRZP4cxs5/Bl+E0oDbRWPdzaoUwtqpVrpRvZDK13
   hpx6W2whgdsF49Xy4p4ChEfQVZdfxQSNpJcv+7lP2tlDelflaoQ0KxZwW
   K2Nat4BeM5rNyp1hsplviusiQo+vZywSrM8K5LMu5t39FXOF/59lzRTGX
   A==;
X-IronPort-AV: E=Sophos;i="5.95,214,1661842800"; 
   d="scan'208";a="120425247"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Oct 2022 05:10:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 26 Oct 2022 05:10:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 26 Oct 2022 05:10:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxN/q8ioJrNnGWYcMKPmxwPAPGnHxyagxpnQQPcy+c/Da3Z25e94EZJukucwExp9Oeh4Z/XVfUcQVqiTFua5akmzYJ885p/GkFUDvp1YdBWAiaXdKzJ52FlcdOmP3DSx7HbMEM4G9VT6rJgT9ZQVl6YjQEXU/5NhwDtJBxfoh5ZbY5xQ56ZuQBKs4u8IHE7oVNXp+DvEhYYhSIYSEkruarlYmqzCwZWwRYYJSd8J8gWn1NcrZWpyAG4n1tedYOO/hvSv7LG1H/kC0t7PqTb0D4Sg4GYw3vZdPtNpkrK4pCMxyWgkr+ccZkB87d4jeRRw0B4490UoEgvOHUIrZCe84w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9c8B8ZbPiwDv4vfOEBRsYPFF8GwOqJFhoWKg8MsAygc=;
 b=QZnMiZ1zN30uvg7jSdiz6Lw7lSGf5u9hx5pkuC3OcVW/dTA83eUIoNOLzAxo0YoldIt2Ib80d3F/fYzJP2lD8wWB0k5VAWolKgapkNolZyEnpOCk8v0TUuIlKRbxLuV9R6KTiAfCrImsK0abEXiZU12BOPdrgC7lOpj4xhImpcl9Ok0Q+AlsplrSZt53gOFMb4Cvrfda7yh68Q+TLwqon04LozpWy8/D9z3/QJV75y4OXSJr2gLxLalwxrKYIGGKywaiRxzgWNP9k6+PpR26TepiQDZ9tV0jvYyioSaGyCp7ttD192u50ry0wzIw4Md9Gka8zRrS6tYkev9jCmh4NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9c8B8ZbPiwDv4vfOEBRsYPFF8GwOqJFhoWKg8MsAygc=;
 b=cCDQIEQPcdH3YBSLT4A/o7ejXGHnqBpn4O+HESwfLLVaLkc49Ezh6G+HQYJHR6k3PoMgpqmFNQvo31pOHuU0dymn/a9/6Hg4o5/RWQlXiIDEM+7jb00LDyah3QAS67GvKpXYx+NmjcXMFO+S+Os4e07bM1nrcy2YlWmeWRCbnIc=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by DS0PR11MB6495.namprd11.prod.outlook.com (2603:10b6:8:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 12:10:24 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::a2ae:2047:6ef5:6a45]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::a2ae:2047:6ef5:6a45%5]) with mapi id 15.20.5746.026; Wed, 26 Oct 2022
 12:10:24 +0000
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
Subject: Re: [net-next v3 2/6] net: dcb: add new apptrust attribute
Thread-Topic: [net-next v3 2/6] net: dcb: add new apptrust attribute
Thread-Index: AQHY54eplZCAOpJ79E+/+KGuQyJoL64ghtyAgAAUtQA=
Date:   Wed, 26 Oct 2022 12:10:23 +0000
Message-ID: <Y1kmBMXluPI1Wmu/@DEN-LT-70577>
References: <20221024091333.1048061-1-daniel.machon@microchip.com>
 <20221024091333.1048061-3-daniel.machon@microchip.com>
 <87zgdizvfq.fsf@nvidia.com>
In-Reply-To: <87zgdizvfq.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|DS0PR11MB6495:EE_
x-ms-office365-filtering-correlation-id: 827e83db-abec-4fe3-9bbc-08dab74b0fb1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fA3BivyHaSQZuWb4iHUEeK9nrKxkmu0LzzaM/VsQ8zMsCNVj/fzheYL+SHhw41f2PDmAAULMgpgngZoHx83UQBidXSPOj0++/Vq77fV7ci7dV5bLDvvo0br2vc41SXmOkoTm8PO/OexeoagAo+92lSssa8CQIVhGm9tSmD8l0+nQUXX2bHy4nACrenmrvOqvUVkvDxrYlsAjyrfNd5af/gaO1oWMtVCOg8wCacg749qrbWpqBqjpGtUuMKDxgPE0M4y0l5fQgRhKQXqBzc6jNFDg+NaLm528v4EcIWzPoEthOLrM38pxgVrE488qy9WoaBCGclRZlgF8cbil8986L8m6HlUzJd1VFZ6F+JTlbnJKzyp8kphBfmlbskvIFi9A7wjyXru++s7mrtrdyR4fP2qajo8o8rU/LrUbJ+IxcNZmIHopvNrvvhMs9U54QexfmqK3VWVwdwtP9oHUcsYXo/ZDmNdQVwQhyTifAdwlXoNZbamhGle6pPduSCDw3UfxiU8D7kSzc1G4ezRI7JNV9jnivy+j5VhahliGYAGahVvHaGMNFNd6DGwlxYqq9qhEZWIIaLV3oS1f3tafPobtt8obiSGE5cmlo1hsHvzXSZqzYWZ8QBZxMVP7mP3jVcwwnRd2YsRwMUkXeo4IkEfGRSRJT+dOk+MMG12ZeZAyaoXTJ4eXL0w6hA2MF2M49+PVqB+6kqu74RbzVhQhp1zH7Dwh2p4sca7Pz18s3fMN7oCTEwHBq0wJ5ohEz9wYmx77LFt+cbbDGPKF26BrWcbHbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199015)(33716001)(4744005)(4326008)(7416002)(91956017)(122000001)(66446008)(186003)(38100700002)(5660300002)(64756008)(66556008)(2906002)(66476007)(8676002)(76116006)(54906003)(8936002)(316002)(86362001)(41300700001)(6916009)(71200400001)(26005)(6512007)(66946007)(6506007)(9686003)(38070700005)(478600001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F5NlBlF1gRoZo7RN8FsOBNwIR0ftd1DP+uYFoYeE1KNMH4lPCP+b7CPkjxbb?=
 =?us-ascii?Q?qcCeU5deT17HdqC4V9ezcmZlClZP7yNA8uMSMQdFzdPMEtds1mDLX+DJ6tL2?=
 =?us-ascii?Q?+DwnwqrNZMufgODi72YFO7Zc3HM0+qT1Hp2EbiIuM52eBvoWleu12XmrKf9X?=
 =?us-ascii?Q?CBOkb+TdQ0uVjjpDeO9YdKRqXI2xRNcRv2JUrjrFLQ/w4zGTQuAc3GadsP7K?=
 =?us-ascii?Q?SKRHbGL4Ye9hP6SxOD1Htr6tzw2qZFqjQX6sy6HPGIrwkV5Jl2SnpjWnMbiQ?=
 =?us-ascii?Q?KKX1W9ioPJL9IfBWvwZ9bQ8OZlzERDLj5woeXRlC39fP4IvniV1d0KwWryZb?=
 =?us-ascii?Q?ae9En298Usg6D/vzZAdHgZto12NJ4AJtvVRbWFJDMS3/w+lWl2UgxyZQk/Kg?=
 =?us-ascii?Q?j5Kv62MqeJmrtsmBzApBKvLj/N/smAjiCtGASbKwK4sSmYWgihasmFGaIxGz?=
 =?us-ascii?Q?A7TcYViqHCXh29Mbwp7C5U70JAkUxqlNDgDm+pTyUC6POs/SsZujgK5L+FJO?=
 =?us-ascii?Q?5VR1cVls8L+mvxeWCLaPOwIxjsfFZLZ9EWnpgqwPPjR9OcF3tuhqwGi0mD5j?=
 =?us-ascii?Q?53HXBk3TJmVj/h43ltOMxKBFJWvCU2AQ8ywKtROtLJETL5bIYP+uKUvWyPvL?=
 =?us-ascii?Q?HStfMuPJ7YFfYBcHOR0xJzxdTPVW7kJyyi3dqmVogocPqbwRWmcsRT62cP8F?=
 =?us-ascii?Q?htnTtJw/+czo6VebCmZ9DNjBN9keSz+KZaJV8sBNuMIqBZ18r1WPGU80kpcN?=
 =?us-ascii?Q?y54rBBQAjJYkiJw5S8RMBi/QVu+N4L52IQg4O/9sEawc6zetAc0rKcel4+fi?=
 =?us-ascii?Q?cZj3gl4+xZOJNX5adSDCripJnfZofANbGVnRoE1e+qVk9+z0ETQpUugNfZDM?=
 =?us-ascii?Q?0dShuv2pMsb4d46XYf7J0D3c52eYrUeq33DIW3NkKh+XontbITXg017/MAfB?=
 =?us-ascii?Q?nUFnuunKZ7Bph2Emc72y38DL10A04F1knu2RCDJ7+SW+MSupYI+0EziHoJTA?=
 =?us-ascii?Q?hobbYdcudVZiMvLZJuB42OJBKmuJlU1gygre/RG6SONNpcUzoRDP07xYcd//?=
 =?us-ascii?Q?5r6mDnsnk8bVTQvNI+scpQie86ABXjGWT0+P7VdzF+YMZU4ZSw8Fhl9I7nYR?=
 =?us-ascii?Q?PQYTZBPKI7h7uQE5CPbt0UowYFHFrcgwAIdDezTyVARJqILjq6zERosan5rs?=
 =?us-ascii?Q?23VCmHxMsEnUQoESoXuqXo1iy5SnEWCb7neO/3DV1QhAPxeEmkhVOQgWeTrd?=
 =?us-ascii?Q?NKLX2waRx/qvik3D7AUKjd0I1WlG9w8X73mSRSziPp9ssuvEY9ErhtpxPZ0B?=
 =?us-ascii?Q?P0BEvEQKa/MBO9XC7Hvo3khs8A9yoIeRr6CoxttN6FLqyH2BA1L8Z8Cr4Ddq?=
 =?us-ascii?Q?zKPrivr1EsA5V5HLFE7TMJkREHnSjTLQFOlAixweSO7mSXoQEU1LbVh4ed3r?=
 =?us-ascii?Q?khNlcCZAwuGx7kiJgp0Zr5TIgfVFwmlOamZsThstr1tUY5cCxRZCatCJ1mjG?=
 =?us-ascii?Q?0aQGyjIbnKALN+WrM9XZylrTuWbjqdrJokKzwkvLW8ZSLtFbSbZKSEZ1+hzE?=
 =?us-ascii?Q?KsF+YG0c9JhKciqGI4VPajZgQEVe71g1Ddoh2o67dfV3NQ0zwu/ZlQm7YDXr?=
 =?us-ascii?Q?ejhDY+qS5vnIxD5vknVgmTg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <43C2229516C31245BCF1DA520B6ED02B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 827e83db-abec-4fe3-9bbc-08dab74b0fb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 12:10:23.9606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mAxMlDTa1m64XG8YaD2bb0kBG91b42eS8rkVKkr+o2hbG9L5pNKrmhvyq/kSshXvwlDCULOQjplsvtMfv8S48HDF2mztTDMw21ptpMePX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6495
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +     if (ops->dcbnl_getapptrust) {
> > +             u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] =3D {0};
> > +             int nselectors;
> > +
> > +             apptrust =3D nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_T=
ABLE);
> > +             if (!app)
> > +                     return -EMSGSIZE;
> > +
> > +             err =3D ops->dcbnl_getapptrust(netdev, selectors, &nselec=
tors);
> > +             if (err)
> > +                     return -EMSGSIZE;
>=20
> This should return the error coming from the driver instead of
> -EMSGSIZE.

Hmm. The question is whether we should return at all if dcbnl_getapptrust()
fails, or just continue to fill whatever other ieee information is availabl=
e?
Seems to be like the rest of the code in ieee_fill() just ignore that error=
.

>=20
> Also, it should cancel the nest before returning.

Ack.=
