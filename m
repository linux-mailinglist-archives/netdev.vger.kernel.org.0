Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE80441356
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 06:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhKAGCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:02:10 -0400
Received: from mail-cusazon11021027.outbound.protection.outlook.com ([52.101.62.27]:36565
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229528AbhKAGCK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 02:02:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISwJA4UYqX/SzVF1rDkxUYwkJJPdPJK/N5kDZZiARqdRLgBOOMuW8sPc58t5ZIXhiMdNcpK6TBQTVqWmcs+Yb7PoKLV7zBfcgiqlhvo9Ejjh0jwWGakkZRFMZed28IxvIann+voC9C8x5zQ1QGrBDbTIfJWMBYSS7MCDIJjmgmlA7CyTuo0viTeSoxOTfHmhGWyfy9mqXiZK0RJ/MKEXKPRtZMnCW4f7s4bJxYeEKI0iBEXPEtR1BCvC8OV6Cz0TDX82RV+2xT6hQBEeXsmS8GYsib01GcEnz7gt7cXkG+RepPdzXTwoUu06BDFyLinO/7q2dEL9PkkKrEMGeuKhRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YyoiKahtcHMuo7UotiduiKZ/L170nLG7JsE6stfOpwI=;
 b=my65velyxOt7zcVbxl+8dWiwR5EsDccPskVVEi9Q9bacOwd9CH6wpNjum2ZVEjofFDLaiHd9s2Vg5CTDYbsJgHpib8vyT11jSxfq7pA0oSCtBaI1h/uvHp91BDDcPS2xptNIematA+4v5Ta4/F5fBNxETmXtWzyNWe/j/BFt+5n6PMBnQjxV7WSADxLaZk6WuSphkBGdePQopaNoZJ5+ndRDFRkgzgtqkkebZijduVX0W3J0Kos+29a5XktwYrvaEvo4NgawLgH0fzVQ4Rwlu8DMynmmys9mlD+wm0FpZh4WQX2MhjcTDYXGvYKXFj2ZkC2u0GZ69+LcF+Au/zsInQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YyoiKahtcHMuo7UotiduiKZ/L170nLG7JsE6stfOpwI=;
 b=IEMPkEFdcuyFQY8isNA2GWEJ/qa3RBABokvg2foGwYRhOxLLtVSqQ7/oUbh1T66Q+Bm00MNBIto7HOyMfrJqUHEFKC3qKMu1nP4mwKhCyjGAIEY24WAF7yQhZ/dBRmnA1JkizG4CX9rx6gvj8+nwkUNyDwFkFO15OiVUip/5TOw=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1333.namprd21.prod.outlook.com (2603:10b6:a03:115::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.2; Mon, 1 Nov
 2021 05:59:31 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9c8a:6cab:68a6:ceb1]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9c8a:6cab:68a6:ceb1%6]) with mapi id 15.20.4690.002; Mon, 1 Nov 2021
 05:59:31 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH net-next 1/4] net: mana: Fix the netdev_err()'s vPort
 argument in mana_init_port()
Thread-Topic: [PATCH net-next 1/4] net: mana: Fix the netdev_err()'s vPort
 argument in mana_init_port()
Thread-Index: AQHXzcnDfY7vTYX8HE6DzgmGfa6sg6vuKBmQ
Date:   Mon, 1 Nov 2021 05:59:31 +0000
Message-ID: <BYAPR21MB1270500F9F47E805A19E2C00BF8A9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211030005408.13932-1-decui@microsoft.com>
        <20211030005408.13932-2-decui@microsoft.com>
 <20211030130718.3471728c@hermes.local>
In-Reply-To: <20211030130718.3471728c@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a10573c8-7a5f-40c0-b8c6-19b8c8630206;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-11-01T05:32:19Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a92c697-94ec-4e8a-b141-08d99cfcc5b5
x-ms-traffictypediagnostic: BYAPR21MB1333:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BYAPR21MB1333EB3431030FC876541B21BF8A9@BYAPR21MB1333.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d3YOaUX47p1/QTAFJxk3KeatADlfn23bkvc8WPbvPzthrjvSGuS+9YLuBrX2heB+wequ4YqojopiP0w+K/4lyLR3l797iVnCJAb1gZQPLwqrMmA35IlN3a3b61JgmEsZMjk+3YkPleqlFntOBWvAjcyqqfTOyax4W+h5YoPDNJpU6Bz3U3RXUBpMa5fQj+DdUnJP7dvrUTob6EBRmxc0D73CJuGRoHfpOTTPAMoUUW4E4AFZOfA4k9pQkwFRxI+FusAzgPXILwKmlZe/i1XiFr2g+uXFUBw28h10XKPDmVtiN4wT3nLRGZLu7eBiowTnYJ5spelkexQb64wHjCezOYOHvjqs1fjrCg6Y/Gkv0oFCkHLEkm1ACm1BfYtlABez+C5moVVXiq9wE/+tpiUd4CtRu6LPE/p/4Q4MjOBtFf4xrygIDtSbZTmiAlXtOF8XDtVjT5+w+biF+oGhPG5Qxz2BdO/WpxtII3Hl2ZOzG13YdntLK9Cp+mgQ82GX2QEssW1KbEgbBCs+9cxYQ/YB8V7TfdzbwbO/S/7A50AyfCVLPcfN1yDisZbUazU+m0BNIajSd81HSLHtvTSP8oGVvxveg0U9N/947ZrBy2/ki+/OQz/0+QeOgd5AoZrSBbRN4Yx2t75hcYOmmuty3lEUcfDBYUFXEqZTgBDqawyfsNIGqrOMygm0Hx2A5IvpEqdcdC3rn/TWlt0xMDf/pLtTjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(5660300002)(7696005)(38070700005)(82960400001)(82950400001)(6916009)(508600001)(4326008)(10290500003)(8990500004)(66446008)(86362001)(66556008)(66946007)(54906003)(76116006)(64756008)(9686003)(66476007)(55016002)(186003)(6506007)(122000001)(33656002)(38100700002)(52536014)(316002)(7416002)(8676002)(71200400001)(26005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uYL3jqwStSxltrqVl/QJyBElBtNV7vA4zX4Sn+W3J7w5hUvMnQVmO0WL6/xw?=
 =?us-ascii?Q?mOHYb1qXNooMiiel6Un8ysuehR8s829/ucz5Avh2A01HZjK42HMWg6XxQouY?=
 =?us-ascii?Q?CSAoWstuJR6TUAK5oGnNbd0wvWfEJHWj3iBqSc3nR4v3FoWiYCuQvY0C0TAB?=
 =?us-ascii?Q?ddcpugTLxgp7a5+GIBBnTdhCmMauutmTYDCiYvopuwjGFrbkcBs+BM0GIIk0?=
 =?us-ascii?Q?/enqENwfGYTi0C6E4+Ayj3hg405kag84KfL6iF5BfRO/391mmhLboHJr6KL3?=
 =?us-ascii?Q?5d4cSDIx8DpizsdFeCQPG0Z1H3k05x4XBKS99l2gELMh9/WoWJ+xHG6s0Fx5?=
 =?us-ascii?Q?PSxCfQrPaoesd+TvWkyeIjMpMe+qV55L3kXEc358/bkMOtIt+WwKW7C372k8?=
 =?us-ascii?Q?eFW8ouHpwV3kJSqsuV84xNdKFBrac2EKzQHjQSVo3OIgz2NbhxfZsqEu0TGv?=
 =?us-ascii?Q?1FF/kxsBus5vR51YAUlYebV7jhSzRnS41pAh/Gz9ga5qgPr9bz1TuewIqCf8?=
 =?us-ascii?Q?u7D3m8vVOftUM/Q0A26GpnOvd61R4WfsuB4uN0FLYf1k/DiWZ+eaNGdzPevf?=
 =?us-ascii?Q?Qo/4vMxE41PqmbDHcrlnTK8oigTYhlToLMSDjmzw5wa4jeA38WjkaCMpHsf/?=
 =?us-ascii?Q?tkm6Ew0hYV/k0q9+KovjeMrHEW5x+fo6LMH+O+BFGIRQKJ+ujatBq08NxPjl?=
 =?us-ascii?Q?lmruiylcGRDepfO9PIeIm7In3BS6HWZ++fitnP9AfGvGQEkmeA48flIb1O+m?=
 =?us-ascii?Q?gA2YuD1jBN1F7kv/U6HbOvn/LZuj7H+Q/AbVx6I/LHaRTifZzJIOsgv4shwh?=
 =?us-ascii?Q?HsqehIERprNby7Zhr1q8TxASpGSAfpFyUL0PMpGoPjWpHVtfFt/9K//EA1lL?=
 =?us-ascii?Q?QRxR0p06ZMhHmzqd2auQ9dUvQPJdgfPVw1OXAR4tNNapA9JqEYoi6G5kmKpO?=
 =?us-ascii?Q?7H4D7nJSDgR38Q9cBtjhcMs+SLMn7P1640KFpgv8OUdMetRjvMpZtaYaEH8u?=
 =?us-ascii?Q?YZOeDwjC6xu2lu4v91oo9E0Ef48cMhfNQ4kkIAW0O15QA3RlVF9P1z0dy0iH?=
 =?us-ascii?Q?iNXWAgkmL/o85SZ4cAOVT3juKyxFFkRk+tGfQjrnvwJdLot/FKzFwFTAGeVK?=
 =?us-ascii?Q?baq5Mki/FoMTTKc0b70zo3W/1ttJDZ7I91P1MzH92dRra91mIrXjmrOHDZQJ?=
 =?us-ascii?Q?3uDQQAksfdbigZkssjqPCFBeEGXjjl7xx2QfCgE+Ep5WNptsxRA17ybF/wMj?=
 =?us-ascii?Q?Sv9Qyid+U4KHO+vA4YPXBab/H+e1CZQmI2FzRvaL/YuJBPfHJuI+NiMr9lAY?=
 =?us-ascii?Q?QcLc4SafT7z6x8qeqqqMADrcoVl7V18/1BoaYot2B1DpYr5KouDTkVWmI8Tb?=
 =?us-ascii?Q?qx8raUIp18pCtNDnNawhxTF8bGu0RoLzNZOhd9WAnrmLsMfzs0062EZuDXJN?=
 =?us-ascii?Q?6zWTxn+lcowQnC64rkdf4jqzVAwOliRgkOkKXrkzQaQEhhjwEoBAEpjFz5Oq?=
 =?us-ascii?Q?HK7YbRNeCe3nPMBtqwvppqvDCLpNuhP0oyPHQLyb/V9vaMsk8n4ubBtKl4rq?=
 =?us-ascii?Q?Iky2qnQtAAk15HjZvFEorBHd2mx87og1O4U7poSm1Odo7F+RRsQXLK6k4qxu?=
 =?us-ascii?Q?JesoYfnubhSHQYWcUZPJ1HM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a92c697-94ec-4e8a-b141-08d99cfcc5b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 05:59:31.0987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oeZ7f7z6M8dsgxpf2HyA3gIs0x3zQ/llSl+Jv7cfOlJ2VgCb21FcLvYtfQYsFfJM5xen0ixrT1oD59tVH3ohXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Saturday, October 30, 2021 1:07 PM
>=20
> On Fri, 29 Oct 2021 17:54:05 -0700
> Dexuan Cui <decui@microsoft.com> wrote:
>=20
> > diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > index 1417d1e72b7b..4ff5a1fc506f 100644
> > --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > @@ -1599,7 +1599,8 @@ static int mana_init_port(struct net_device *ndev=
)
> >  	err =3D mana_query_vport_cfg(apc, port_idx, &max_txq, &max_rxq,
> >  				   &num_indirect_entries);
> >  	if (err) {
> > -		netdev_err(ndev, "Failed to query info for vPort 0\n");
> > +		netdev_err(ndev, "Failed to query info for vPort %d\n",
> > +			   port_idx);
>=20
> Shouldn't port_idx have been unsigned or u16?
> It is u16 in mana_port_context.

Thanks! I'll use "u32" and "%u" here.

I'll post v2 like the below. Please let me know if any further change is ne=
eded.

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ether=
net/microsoft/mana/mana.h
index fc98a5ba5ed0..0a4246646447 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -359,6 +359,9 @@ struct mana_port_context {

        mana_handle_t port_handle;

+       /* This doesn't have to be u32, because the max_num_vports is u16:
+        * see mana_query_device_cfg().
+        */
        u16 port_idx;

        bool port_is_up;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/et=
hernet/microsoft/mana/mana_en.c
index 1417d1e72b7b..b495e9a20324 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -479,6 +479,9 @@ static int mana_query_device_cfg(struct mana_context *a=
c, u32 proto_major_ver,
        return 0;
 }

+/* The range of the 'vport_index' parameter is actually only u16, but sinc=
e
+ * the PF driver defines req.vport_index as u32, we also use u32 here.
+ */
 static int mana_query_vport_cfg(struct mana_port_context *apc, u32 vport_i=
ndex,
                                u32 *max_sq, u32 *max_rq, u32 *num_indir_en=
try)
 {
@@ -1588,7 +1591,7 @@ static int mana_init_port(struct net_device *ndev)
 {
        struct mana_port_context *apc =3D netdev_priv(ndev);
        u32 max_txq, max_rxq, max_queues;
-       int port_idx =3D apc->port_idx;
+       u32 port_idx =3D apc->port_idx;
        u32 num_indirect_entries;
        int err;

@@ -1599,7 +1602,8 @@ static int mana_init_port(struct net_device *ndev)
        err =3D mana_query_vport_cfg(apc, port_idx, &max_txq, &max_rxq,
                                   &num_indirect_entries);
        if (err) {
-               netdev_err(ndev, "Failed to query info for vPort 0\n");
+               netdev_err(ndev, "Failed to query info for vPort %u\n",
+                          port_idx);
                goto reset_apc;
        }

