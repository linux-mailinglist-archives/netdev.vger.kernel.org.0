Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314894FBFB2
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347429AbiDKO7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiDKO7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:59:42 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130071.outbound.protection.outlook.com [40.107.13.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42B517048
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:57:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnnotC1RxEmpvatd63wJPzYlPm7sUH6vLmMNE41ycJdd0g1B5PU5LnQ4KVd0zC7RMiA+bSDYbU2RSvONSt/DIMfVKsit+6zWlneTqFQvO+DgRBZJf68QUvrydP6VH+kG+nx/ddMoa26BwisfT9OOqy77dWG2bFl3eZKFrfBEh8A1tJOxBOQUL6FT+mHrmIXpwT9m4WHhbFmIJaYILvZOeKTZWoBKvG9XHgYD6JKlp52o0Ox4dcrlaEvoV5YrMpOjm1KLLNeOnQ5uafiQ9407LGNdVF+Kz9zSeVZTAXf8TImoZglHuQrv3r9a1NO0y1tiqqb4kB5zj05TPj/zWkG+fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJt7dRPyImoIkWCnql4iy6gz2E6l+RMyxABvw34u1/A=;
 b=F4xkC5KBES+ZQHkMF5UOOWzlpsD0OctjVXUHzDTuK5RVzHIV2tJeSD4fdIqPnYIvekPQo7JurFJJwrfKseLhGTcHIf6G3fLTFeeEnY68NXaOqQlbga/kLwGkRqAHyK5rrx544jLsvhGupnL+g4LdC9iQwvRKyU30PnbbYcZ8X62PMheIJFfsAOhOy+/xhHvTN4C4fZjz7KG2Ovu5urr7+HF2iUSEWQxT7ZPKgApXGUUn5t/sxUzVBEoO7bnEaEX4bhtYTbdMfg/8yrgbLNM/8Z5lHq5WkLGzgN32BQZFK06IOZ1gxvWL2o2stknzECyMA1lYbjEh0Y1bU+SgkXI4iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJt7dRPyImoIkWCnql4iy6gz2E6l+RMyxABvw34u1/A=;
 b=DgkZQoqOtBRpZfzI7jrAjfoKMvwICB900kIgXxh2oUg+EFh0Sy9clOG5pDlTx9zbEYR3hPY10rzgvao3PW9eThDZViHkgIk8XxiDOOqO4Tr88QhR7dDr8eBKI7zGnIUuUuDA/aRFDvVnqBO18lXS4CcP6eBV7eBtN91+A3p7HUoMYZ3ueogZ/0Zlnmy3oXBFsFKIqLX9roRGKINq0uErebkuQk2vyMQm7JbkeGv8UcRNN9xI06Qt+Gy0shcQYndN5USzoGZp9UgC1p2/b7PefllzEE5QLGKJfqE38g9m++7oLBFEGpTd80eIbcNC2J8tnXWJGMDZ5I2eXahg83RlcA==
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by HE1PR10MB1609.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:7:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:57:24 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2826:61fb:9338:aafb]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2826:61fb:9338:aafb%7]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:57:24 +0000
From:   "Geva, Erez" <erez.geva.ext@siemens.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Meisinger, Andreas" <andreas.meisinger@siemens.com>,
        "Schild, Henning" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>
Subject: RE: [PATCH 1/1] DSA Add callback to traffic control information
Thread-Topic: [PATCH 1/1] DSA Add callback to traffic control information
Thread-Index: AQHYTaW3YftshBPJT0uGZWTNekz6x6zqtRYAgAANgcCAAAcIAIAAAeTg
Date:   Mon, 11 Apr 2022 14:57:24 +0000
Message-ID: <VI1PR10MB2446DC2C0771F52D4F35A0A3ABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
References: <20220411131148.532520-1-erez.geva.ext@siemens.com>
 <20220411131148.532520-2-erez.geva.ext@siemens.com>
 <20220411132938.c3iy45lchov7xcko@skbuf>
 <VI1PR10MB2446B3B9EC2441B962691D67ABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
 <20220411144308.v343ykjkn7eutzbr@skbuf>
In-Reply-To: <20220411144308.v343ykjkn7eutzbr@skbuf>
Accept-Language: de-DE, en-GB, en-DE, he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Enabled=true;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2022-04-11T14:57:22Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=5ad4552b-2da7-4ba5-9054-2ca4bc42f7ee;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 939ac117-587a-4f9e-6727-08da1bcb968a
x-ms-traffictypediagnostic: HE1PR10MB1609:EE_
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-microsoft-antispam-prvs: <HE1PR10MB16098CE3D2AA3E4E16BAE0E8ABEA9@HE1PR10MB1609.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PQoLWC4kziRdvzlhk90BE2zjMYE+ljlxwfYRYib1Nej7/UJ4+rzix1dPKXVWBqX8OwGltkdkINJZTq1eI2NB4GkzaiY2efJTvExVpW6ZgXikntrrW0pynkFHLIypwTEonOHJgIURkkCiBCzSxXScFGD/WHpgdXkWFZpBDZ+yOgQcgRSAfdsJh73QmllHCn3XV1p1RguIDfzDV5UvXBQJAPv11H82ssMibhJdp11iXkL9qeB71mhsXh+FesrNRFt/we2PnG0cr1hrQ6rCzzAFAwTOOOEtdj3XR8YNzLOB7jwnO67eKH+eHosjYq1d2XXeSoSsMW2s/I/EcqYEg4/AUEU6Ss/Jh0UoJrWtEBRRsawZbS4/oPSQpW4DxROSGihXDBXKjwz4e1FUKj1aTa5tXWJKPO4hPZmjJMoVb6q4WRoDp2CAoujfsnpzcNgWaXFVQbWN5cLltlFdrRd+4QqIoSNSOolZlLGdEJlvf3fOqPPP+zE8PGnXKLyIPtyBHweUezcmEnG+nlF5Jvp4vdqcnmK7+l/9Dx6R4oxYWE54aXdcBW3+Y8B9XlfG7+CyUyuuocpb+FOJ9H099zBwDxIQAD+39hj+Crh7QcSYXgpZzt6sSfXPcfMBVgg8AgZhNNaHhzIV/fj09o5tkx/tAJ2ki7wvr/MJLoex0++5Q55bfj5kG5JNdwqm5Js4U1ljRVETt+ok8V0jey9H1ErtDgo+Nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(186003)(26005)(86362001)(53546011)(71200400001)(7696005)(6506007)(9686003)(107886003)(38070700005)(52536014)(66476007)(122000001)(82960400001)(54906003)(8676002)(5660300002)(8936002)(2906002)(38100700002)(33656002)(66556008)(4326008)(6916009)(316002)(64756008)(66446008)(66946007)(76116006)(83380400001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RMjmftsYByOfMk6DsQxT7o3jPlZMmK72Rsu6kwBj3ibqHO+2GHXS1Po7d2ud?=
 =?us-ascii?Q?7kdHiO5p3dDtlng4ZI4M9mCDTmcN3p5NGuUMhv988PbU7nmbm2A7J8T7g8Qj?=
 =?us-ascii?Q?3j2cftGrbDEdWRL4P+/oFLIDMiLG008Gks0XzCdswTuVdqjUiP7fiPYgV+rI?=
 =?us-ascii?Q?shMuo6wwoivxh9LuO5FC0u/QSr3Hd6bmz5of2s0MbBqLi4ai4NNEn3zDeHDj?=
 =?us-ascii?Q?7wVZUXPMPdmGJHoyqYnBJ04ybVhO38f6B4IRPWAnp+ZATZggVBTAZs6u0pes?=
 =?us-ascii?Q?ZPXMjhJ4lZq2khdObrRDlCkxxIwxF9y0Iy9p6Fm2v+pZILVqKdiXQGRr5GJw?=
 =?us-ascii?Q?47NNGAL4cIEMRqa3Vgsij7ctnKolb4JDIs22qg8YImksVQbEQ3TT4+aXmi25?=
 =?us-ascii?Q?7bA8JLSIzVN02pJ+PY9AeHn1LUo0LcN1iT4Nvv7Jkr7+fCPKlTnUtoxAson0?=
 =?us-ascii?Q?SJ90RspeGrgnWo7GegMov0EyCSR2xJ6ru2JBK2na1jppy31PFoNH7kdWM9lZ?=
 =?us-ascii?Q?wkZbz6P+PYyCcTeBBfhbwVQv8lvrN4Uq9Hb84zqKQszOwIaRvuT8nTfIyBul?=
 =?us-ascii?Q?FF9rYeNUIoYn4RGgeVwe/kxrRCkDVB5LKXNFRMpms18oTyVr4nAFNf2XOI0y?=
 =?us-ascii?Q?zWBYf+feNoxE6tcgPlPpUjvPnC8TjZEcj1v5HlkIRc0bwiMPbqxN8q+KvVCi?=
 =?us-ascii?Q?VuakHuiJpeo3dTYwb/O+aB9+VWf3SVO+NRRbrAKfNVV1XMJN5jIAfZefchhG?=
 =?us-ascii?Q?MjaqP1zbNWmZYVMLTIMLsSKCOYXiQVVz+mv+Ld7rbUZdBDDVXP13lzpQ7nRE?=
 =?us-ascii?Q?0rlFSKsbiNtakYANI6YPe1CeRh349hikeecQlDyL8zftufQmAtytmt9EcEyH?=
 =?us-ascii?Q?BJUqouvghZtgwga4s4p/RxoG7n/FF2QEKtphUhQXK8y+RACDLg3HN5MRoQw/?=
 =?us-ascii?Q?ADw7/csJiWXe+209uVKgxsOGtQ1ElfrAcDxgnDpKPTlqHVVUckiIiGczIpor?=
 =?us-ascii?Q?FQt6FlRf0DXCv+x3fTT5ZUI8iJ3xDmZaHttInldN3KhpPGpaV7VcGzvchap+?=
 =?us-ascii?Q?NkEKjhCAOAsVwRYpG9rqG9MDKuDVHyuJYrJH28F7+GktzBjZF9tVIzPOVVrC?=
 =?us-ascii?Q?TC/HsLYyjA900R9dqM9E0KnAKL/nGEwIPLcUmOIptW5WTA0j0YbchLVsrfzu?=
 =?us-ascii?Q?/duo+HCrgt23QHSneZ2lulc9z8LlS+m4l5eki5fhNUHIE3N3sO3ht/CBy119?=
 =?us-ascii?Q?80cNLpPMHxri+AGp8I0RBI3Fqqg2RPu1tzeleMlMzmckIhPC0+EhxKOv7TGw?=
 =?us-ascii?Q?2OU7ZN0OskKgzmq6LMuvOV8vLBNAu/5SiZYjob6E/nOMhXH0Zp8KZupEIjkv?=
 =?us-ascii?Q?nW8SYNDh7m6SoksuaArycj1zXomjNaOcPwk6g99LknlLftRrGacYtXxaPIew?=
 =?us-ascii?Q?gPHUjr3bSlVI0zCi6yu+0rCRDulVeRvlM6J4kx38xDlKWVUF8FHJe4KfXVVI?=
 =?us-ascii?Q?SVZpPQcWafuqNA45c9fE4dOOuliQZBgjKNThDB1dBSJWqmH418eUcIjekRzj?=
 =?us-ascii?Q?TQWFuF6raaiguPz8GTtogluSK3Dv/1HcoPIjsBM2RIyCeXLWRbDVsXoMCbE6?=
 =?us-ascii?Q?OBr+DxsgbQfF85iWyIuCaXzgfv4km7nEdldYcIA7NecUKFqM/TA3eVnAnbrk?=
 =?us-ascii?Q?o5+22mTAUbEG8piSe2YF/d0iquTt401mJS2lb9Of16Dt3aVqDsYcxHG0stII?=
 =?us-ascii?Q?vKf6HL8rPilwi+R4inRfhlipCXlNkaA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 939ac117-587a-4f9e-6727-08da1bcb968a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 14:57:24.3685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 115GJEJPKgTjuIkRva2Egf1wO1Bg9RcsPJTKzC6YnsapHRx0vdzf3GhC+fsI0cEFWjvgnKi45lbJoICIhqCpyarNKnRy9Ys+NRslyPf3AyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR10MB1609
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the tip.

Thanks
  Erez

-----Original Message-----
From: Vladimir Oltean <olteanv@gmail.com>=20
Sent: Monday, 11 April 2022 16:43
To: Geva, Erez (ext) (DI PA DCP R&D 3) <erez.geva.ext@siemens.com>
Cc: netdev@vger.kernel.org; Andrew Lunn <andrew@lunn.ch>; Vivien Didelot <v=
ivien.didelot@gmail.com>; Florian Fainelli <f.fainelli@gmail.com>; Sudler, =
Simon (DI PA DCP TI) <simon.sudler@siemens.com>; Meisinger, Andreas (DI PA =
DCP TI) <andreas.meisinger@siemens.com>; Schild, Henning (T CED SES-DE) <he=
nning.schild@siemens.com>; Kiszka, Jan (T CED) <jan.kiszka@siemens.com>
Subject: Re: [PATCH 1/1] DSA Add callback to traffic control information

On Mon, Apr 11, 2022 at 02:23:59PM +0000, Geva, Erez wrote:
> As I mention, I do not own the tag driver code.
>=20
> But for example for ETF, is like:
>=20
> ... tag_xmit(struct sk_buff *skb, struct net_device *dev)
> +       struct tc_etf_qopt_offload etf;
> ...
> +       etf.queue =3D skb_get_queue_mapping(skb);
> +       if (dsa_slave_fetch_tc(dev, TC_SETUP_QDISC_ETF, &etf) =3D=3D 0 &&=
=20
> + etf.enable) {
> ...
>=20
> The port_fetch_tc callback is similar to port_setup_tc, only it reads the=
 configuration instead of setting it.
>=20
> I think it is easier to add a generic call back, so we do not need to add=
 a new callback each time we support a new TC.
>=20
> Erez

Since kernel v5.17 there exists struct dsa_device_ops :: connect() which al=
lows tagging protocol drivers to store persistent data for each switch.
Switch drivers also have a struct dsa_switch_ops :: connect_tag_protocol() =
through which they can fix up or populate stuff in the tagging protocol dri=
ver's private storage.
What you could do is set up something lockless, or even a function pointer,=
 to denote whether TX queue X is set up for ETF or not.

In any case, demanding that code with no in-kernel user gets accepted will =
get a hard no, no matter how small it is.

