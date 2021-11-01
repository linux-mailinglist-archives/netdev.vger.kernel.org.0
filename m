Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983B94413F5
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhKAHGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:06:01 -0400
Received: from mail-cusazon11020015.outbound.protection.outlook.com ([52.101.61.15]:7442
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230407AbhKAHF5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 03:05:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMOAdLBNBUEMFN+rcpz/ts2kDt7Vhu4WcQfCKut+dx4BGOVk3sNdpQADZ6VBfgSPGuDULiCVh8mv9h3ntsRvNr+p38QwjO7zOaByNzYwfh/GQdrUcNaxEp8A8D+huQYfmBD/4wGOql4iaDg4GVyRIM7PFQl9TwJodnp7jzvoY8TmhtHmNUdE6cuuaoDcO0+lF/U2rmgvFqt2X8tvKraoVmMeVZ/7sZejZzZ8xok+ARwArJewmzyhU+vLExZt8AvwxSh29Vdk4kiS5LWRgEZSfxSp9XGrVjv9Fc+W2aYTlQ+W/SqOR+h/yMy+0O8Z3VdHZUcl8ghEDoVxaox2/ErwAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8qxLUd7RbAVe40XXDRRU8O8s2yS3szkxoGHCBcM5ng=;
 b=TQeeORRKiKsoZdfqRHfEdc4V2EeSwBMbsQJ0PqXGy/jhmqFyBIUNTC+iZzCZK4xNq1OoUZDtZ5Qy0gOVpUYmDY54INDEVZ6Sp1gvse+O8AgcDUWXgavx4J1WlbWcKnvK27EUnm7IP2ls9hb/IBGXgRpDXq9QjuTYoJJACHnb2HaKQzuY7J3pVHWLh/UZsLl1/fCl0zC50C9x/pUcBLf6WKGSoTEqoBKajUIRke7826+lS3WI1S17sRse9UvgOTHYsX9hVfffCbO8nL1aOgJgG3arxyPyk3slOsMxuraRrrkKvnFDBRjxk9Sgsz7GaRpzvD3Ds0R2NX17ayi4AxzMHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8qxLUd7RbAVe40XXDRRU8O8s2yS3szkxoGHCBcM5ng=;
 b=QPWIqu6AQdX5BpmFEdS7s8tmJbwJTyk9YkvNf/Bz1Q6H11X0Y12T1E2+aIJNFbqYhQUxstt5roq4KGpbTYsgqUcOB9aW7i8egiE7HIPdao9cRKV+QT5EgEhcwoqIU15BCKzjgTn9wIG886EJFwoqcZhRA1vx1i5aMMv5JFWHBuk=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SJ0PR21MB1869.namprd21.prod.outlook.com (2603:10b6:a03:2a2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.3; Mon, 1 Nov
 2021 07:03:19 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9c8a:6cab:68a6:ceb1]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9c8a:6cab:68a6:ceb1%6]) with mapi id 15.20.4690.002; Mon, 1 Nov 2021
 07:03:19 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH net-next 4/4] net: mana: Support hibernation and kexec
Thread-Topic: [PATCH net-next 4/4] net: mana: Support hibernation and kexec
Thread-Index: AQHXzSi5FL+xs47DTkemjnXcBfjf5qvrr5YAgAKLS0A=
Date:   Mon, 1 Nov 2021 07:03:19 +0000
Message-ID: <BYAPR21MB1270A16AA0BF1A302BABCB3FBF8A9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211030005408.13932-1-decui@microsoft.com>
 <20211030005408.13932-5-decui@microsoft.com>
 <BN8PR21MB1284785C320EFE09C75286B6CA889@BN8PR21MB1284.namprd21.prod.outlook.com>
In-Reply-To: <BN8PR21MB1284785C320EFE09C75286B6CA889@BN8PR21MB1284.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=38d1b54a-de51-47ac-a27e-8db573cfb9ed;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-30T15:43:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc9771ea-1db3-4528-28ec-08d99d05af60
x-ms-traffictypediagnostic: SJ0PR21MB1869:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR21MB18697A9BB9DC1A21664762FDBF8A9@SJ0PR21MB1869.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IunYoaSnBRwH0ArwqmY+WZri0oULEqrlK9zqM+zfNl4ezN4cnizirpOAFlfhsutyLqWx4GMZUZPGXmYqCMUPp+ji3NAdFsYzV2t1Hsn+gtyCYDZyct9KSXW/ne0XCFHrMhu8o/vKhB+37Mo9AZgUMjvunelGt9HPseCZ0Ai407DVCVUNVoE2kZBVFG/1qP36iD3wIut4iHYrVndEbF3IzGYfdfEahlPoLOBZT9/KEj74+dC6cFcOPcJUrzYHiEJkiUN+c0TbHJxxNhvGJN29ay6IKldJJLnTjQXzZVLiyKZ+6IGxIGBG7FAShoMiJJKxS0OY3Lub60Z6gmzPVrf9CLyeL4cqLjnIWOgQdPTxkz/FNFbHVOCFjGjhgcxpgXEjA/cxoAiS/J3NCKELJFPSLBbItrqfEBulPdCRe4H/dJiY8lmfUrQEsNU0NtQeDQe8o9JoQ8ppEDRuj7kj/NN4xAwpcGOwC34jRg7g/YurPaRBJBTeN7w1ESksWNgAAwcWBMJd+wx/nCDNhCwrixTeJXWtFRSVXubBf7gV6f+6SeHjopOxIC9ODUkBELESTyaK064+eGr3fckW2ZD8mppgCs9dD3da+nAboQTio3st6ZULl/PRIhHjfhrmoQEzZq6MllMiYUO8UzKA20F5eGgI6ZTqNjici/SAM9+J4FtDZL5vu1A4LR47pU47BB8UOgK5oJyN4flV3B9PGa1OkCn3YQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(33656002)(38070700005)(71200400001)(66446008)(64756008)(66556008)(55016002)(9686003)(6506007)(66476007)(76116006)(66946007)(4326008)(86362001)(10290500003)(38100700002)(122000001)(508600001)(8936002)(26005)(186003)(8676002)(83380400001)(52536014)(5660300002)(7696005)(2906002)(8990500004)(82950400001)(82960400001)(110136005)(7416002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K3oPhdhlPaZ5sIoMWQH8vqCeEsNAP0tCQ/Qs07TiuK/BAh1UlpLGGUDBS4rw?=
 =?us-ascii?Q?46rhsZdNuI52Pu/PRG/bfpHJhH2SynHuyuifBcE4TQnqYe9bjm3/jtNGzclv?=
 =?us-ascii?Q?whZlW9H6D6K8qbzhSJH1q4ln8eBi+RKuFjqN1LzBftP/4EdbzHJKSMFjVFT8?=
 =?us-ascii?Q?B7tTy0pW2hlQWNF/AZdM5JzZjaZm54fZw0H3EWmdzHXsr92U99zv112o9yDU?=
 =?us-ascii?Q?VjxdyUHzBGqS5aB5NcfWjPcAbdlTtHYTgUcw1TeKxtrj3wTTNK0BIHuQalAB?=
 =?us-ascii?Q?cUKeR4hsAVtUMkSbEzP+qsUs7uITNKamzX1O/R++yzotj+FA7LLLHW8MMeoU?=
 =?us-ascii?Q?upii39+pPmqvD77s7hFelnp7BTkCIM96LoESEkFBbAopa7P3CSH3axTwXBaP?=
 =?us-ascii?Q?gjIHD04iWDVPsLlDSeTzg0DECTxEBCiWnmA3I6+XfFaAbk2Y+hQC7QC8IC5B?=
 =?us-ascii?Q?8d2irJnwWfpigNUPJ4yg6FhSXszTHC7mcS4sv+2Quuni+KkKcYFP2BZZ+0YY?=
 =?us-ascii?Q?qA8VJgXd7DaN+tDXD6DLpzOSUXwRDd8tkVF+W/fo9WGXGorLYd958Mvofysn?=
 =?us-ascii?Q?PzcpBkMccnNvPStpRLGq+Abkq05BshII6dvvDzKTXNlNQaU+cOgZBus22V7I?=
 =?us-ascii?Q?fMtdjtEz60ANeFs8ELdkRRKH2MDm32R1G4XYoQ3/FVGfxdyI2b/tziGJn7+N?=
 =?us-ascii?Q?Q8Fau2Xxhm1ue39wikNGIao5RI00PUs1qqSufDH28OgiSkyIekC5GvxY/Sx7?=
 =?us-ascii?Q?n7b+rcBPgSAEMRnvXmch39ICchU4M3EAKzcxLq0Y6Kn10yTDm1NJy3MzfIEs?=
 =?us-ascii?Q?0Np1VTfKI6R+De7K8zHH04FC4KdVUemn1Hgd8q/YNobOj6FnusuCn4aUeR5o?=
 =?us-ascii?Q?TV925f2fziI34Yl4LCF2iHfyizV0PzgAh+JrwfVZ4X62H7ltOxx8BokvNK6O?=
 =?us-ascii?Q?ALI7fN9T56nDDH/O2evEYbGCZoVb3hCOHfyRqXgusezMlwCqyz5oLj+5XBwl?=
 =?us-ascii?Q?VE8DDh0A2jCHP9jYOIcaUL2RoeY8YdqQcJ0eGsR7J/dvHMkBMtyA1Vbc6eAI?=
 =?us-ascii?Q?IlngvWjZNCeqjYOWC462HnGwCjW2zjIJYzeVRIRZeqO07BSMSc3Y1PWwP2aw?=
 =?us-ascii?Q?oJ0AR3QqG7PYpCsfACrtZvXIM5BZ9e35nMENdUxZfgSM6OmTRw/jPyAqJb4D?=
 =?us-ascii?Q?yhILaafXJyCmjM7PSGUOwaQ/vDRX4XkGrE705IrzfUQJDGWB9MJt62tf+jAm?=
 =?us-ascii?Q?o9YhkG9+2SWzZKEMxwpxR2OI8Dfpx3GgtxcSLZeZaQ2BdoLjVUL0Hn1WzPGH?=
 =?us-ascii?Q?0D5rzczN8pbuN7iDk7Klllxw01Rn1+fdMo3M1nIDvQWwEO0TaO0uzFGVmULI?=
 =?us-ascii?Q?L5/LvDguNvjA2bt5lnqWVn2+tDHtJicG7SN0peC2zbVsshY4Lt1kUNNn/4sW?=
 =?us-ascii?Q?ONIUwcOGBO3UQfWtxqdI5F/Oao5dzqbSc/xAn4n+O4th7MBtkPVVGWRd5hKi?=
 =?us-ascii?Q?llOY+Hlkajw8cIy/Az66wmv84FumqBOUGFdq7nUyDfxsuwI9+yhuZG9xx/PF?=
 =?us-ascii?Q?kDBYS7J0Zr3CvneiAVU2AGn+0YXiktoFBTH8/ShZivxc0AjyAjC3bWS4Ljfu?=
 =?us-ascii?Q?bE2TqJ/CocQDM7VuIgclDos=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9771ea-1db3-4528-28ec-08d99d05af60
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 07:03:19.1318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sc/faO3at4wjEx6UN/05BtJj7wwgTa/ggeYGkOfcBpH+EeOpThv1jih5Na9G1ow2pjyY1lEwyHZU05dRMV3xFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1869
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Sent: Saturday, October 30, 2021 8:55 AM
> >
> > @@ -1844,44 +1845,70 @@ int mana_probe(struct gdma_dev *gd)
> >  	if (err)
> >  		return err;
> >
> > -	ac =3D kzalloc(sizeof(*ac), GFP_KERNEL);
> > -	if (!ac)
> > -		return -ENOMEM;
> > +	if (!resuming) {
> > +		ac =3D kzalloc(sizeof(*ac), GFP_KERNEL);
> > +		if (!ac)
> > +			return -ENOMEM;
> >
> > -	ac->gdma_dev =3D gd;
> > -	ac->num_ports =3D 1;
> > -	gd->driver_data =3D ac;
> > +		ac->gdma_dev =3D gd;
> > +		gd->driver_data =3D ac;
> > +	}
> >
> >  	err =3D mana_create_eq(ac);
> >  	if (err)
> >  		goto out;
> >
> >  	err =3D mana_query_device_cfg(ac, MANA_MAJOR_VERSION,
> > MANA_MINOR_VERSION,
> > -				    MANA_MICRO_VERSION, &ac->num_ports);
> > +				    MANA_MICRO_VERSION, &num_ports);
> >  	if (err)
> >  		goto out;
> >
> > +	if (!resuming) {
> > +		ac->num_ports =3D num_ports;
> > +	} else {
> > +		if (ac->num_ports !=3D num_ports) {
> > +			dev_err(dev, "The number of vPorts changed: %d->%d\n",
> > +				ac->num_ports, num_ports);
> > +			err =3D -EPROTO;
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	if (ac->num_ports =3D=3D 0)
> > +		dev_err(dev, "Failed to detect any vPort\n");
> > +
> >  	if (ac->num_ports > MAX_PORTS_IN_MANA_DEV)
> >  		ac->num_ports =3D MAX_PORTS_IN_MANA_DEV;
> >
> > -	for (i =3D 0; i < ac->num_ports; i++) {
> > -		err =3D mana_probe_port(ac, i, &ac->ports[i]);
> > -		if (err)
> > -			break;
> > +	if (!resuming) {
> > +		for (i =3D 0; i < ac->num_ports; i++) {
> > +			err =3D mana_probe_port(ac, i, &ac->ports[i]);
> > +			if (err)
> > +				break;
> > +		}
> > +	} else {
> > +		for (i =3D 0; i < ac->num_ports; i++) {
> > +			rtnl_lock();
> > +			err =3D mana_attach(ac->ports[i]);
> > +			rtnl_unlock();
> > +			if (err)
> > +				break;
> > +		}
> >  	}
> >  out:
> >  	if (err)
> > -		mana_remove(gd);
> > +		mana_remove(gd, false);
>=20
> The "goto out" can happen in both resuming true/false cases,
> should the error handling path deal with the two cases
> differently?

Let me make the below change in v2. Please let me know
if any further change is needed:

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1850,8 +1850,10 @@ int mana_probe(struct gdma_dev *gd, bool resuming)

        if (!resuming) {
                ac =3D kzalloc(sizeof(*ac), GFP_KERNEL);
-               if (!ac)
-                       return -ENOMEM;
+               if (!ac) {
+                       err =3D -ENOMEM;
+                       goto out;
+               }

                ac->gdma_dev =3D gd;
                gd->driver_data =3D ac;
@@ -1872,8 +1874,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
                if (ac->num_ports !=3D num_ports) {
                        dev_err(dev, "The number of vPorts changed: %d->%d\=
n",
                                ac->num_ports, num_ports);
-                       err =3D -EPROTO;
-                       goto out;
+                       /* It's unsafe to proceed. */
+                       return -EPROTO;
                }
        }

@@ -1886,22 +1888,36 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
        if (!resuming) {
                for (i =3D 0; i < ac->num_ports; i++) {
                        err =3D mana_probe_port(ac, i, &ac->ports[i]);
-                       if (err)
-                               break;
+                       if (err) {
+                               dev_err(dev, "Failed to probe vPort %u: %d\=
n",
+                                          i, err);
+                               goto out;
+                       }
                }
        } else {
                for (i =3D 0; i < ac->num_ports; i++) {
                        rtnl_lock();
                        err =3D mana_attach(ac->ports[i]);
                        rtnl_unlock();
-                       if (err)
-                               break;
+
+                       if (err) {
+                               netdev_err(ac->ports[i],
+                                          "Failed to resume vPort %u: %d\n=
",
+                                          i, err);
+                               return err;
+                       }
                }
        }
+
+       return 0;
 out:
-       if (err)
-               mana_remove(gd, false);
+       /* In the resuming path, it's safer to leave the device in the fail=
ed
+        * state than try to invoke mana_detach().
+        */
+       if (resuming)
+               return err;

+       mana_remove(gd, false);
        return err;
 }

@@ -1919,7 +1935,7 @@ void mana_remove(struct gdma_dev *gd, bool suspending=
)
                if (!ndev) {
                        if (i =3D=3D 0)
                                dev_err(dev, "No net device to remove\n");
-                       goto out;
+                       break;
                }

                /* All cleanup actions should stay after rtnl_lock(), other=
wise

For your easy reviewing, the new code of the function in v2 will be:

int mana_probe(struct gdma_dev *gd, bool resuming)
{
        struct gdma_context *gc =3D gd->gdma_context;
        struct mana_context *ac =3D gd->driver_data;
        struct device *dev =3D gc->dev;
        u16 num_ports =3D 0;
        int err;
        int i;

        dev_info(dev,
                 "Microsoft Azure Network Adapter protocol version: %d.%d.%=
d\n",
                 MANA_MAJOR_VERSION, MANA_MINOR_VERSION, MANA_MICRO_VERSION=
);

        err =3D mana_gd_register_device(gd);
        if (err)
                return err;

        if (!resuming) {
                ac =3D kzalloc(sizeof(*ac), GFP_KERNEL);
                if (!ac) {
                        err =3D -ENOMEM;
                        goto out;
                }

                ac->gdma_dev =3D gd;
                gd->driver_data =3D ac;
        }

        err =3D mana_create_eq(ac);
        if (err)
                goto out;

        err =3D mana_query_device_cfg(ac, MANA_MAJOR_VERSION, MANA_MINOR_VE=
RSION,
                                    MANA_MICRO_VERSION, &num_ports);
        if (err)
                goto out;

        if (!resuming) {
                ac->num_ports =3D num_ports;
        } else {
                if (ac->num_ports !=3D num_ports) {
                        dev_err(dev, "The number of vPorts changed: %d->%d\=
n",
                                ac->num_ports, num_ports);
                        /* It's unsafe to proceed. */
                        return -EPROTO;
                }
        }

        if (ac->num_ports =3D=3D 0)
                dev_err(dev, "Failed to detect any vPort\n");

        if (ac->num_ports > MAX_PORTS_IN_MANA_DEV)
                ac->num_ports =3D MAX_PORTS_IN_MANA_DEV;

        if (!resuming) {
                for (i =3D 0; i < ac->num_ports; i++) {
                        err =3D mana_probe_port(ac, i, &ac->ports[i]);
                        if (err) {
                                dev_err(dev, "Failed to probe vPort %u: %d\=
n",
                                           i, err);
                                goto out;
                        }
                }
        } else {
                for (i =3D 0; i < ac->num_ports; i++) {
                        rtnl_lock();
                        err =3D mana_attach(ac->ports[i]);
                        rtnl_unlock();

                        if (err) {
                                netdev_err(ac->ports[i],
                                           "Failed to resume vPort %u: %d\n=
",
                                           i, err);
                                return err;
                        }
                }
        }

        return 0;
out:
        /* In the resuming path, it's safer to leave the device in the fail=
ed
         * state than try to invoke mana_detach().
         */
        if (resuming)
                return err;

        mana_remove(gd, false);
        return err;
}
