Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963854FBF8E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245685AbiDKOv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239759AbiDKOv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:51:58 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2061.outbound.protection.outlook.com [40.107.21.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309062E698
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:49:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXT62BFvQnhdwRpqNA9FNCI/lwrwAgPOCt+qIseTj24/PQ2d6pLOklNNeozQlvqoR5qE1mg7AvAao0FIpO7D2x8JxixrAVykwzmloz4blHZKX3q2Ipm1XtkKvGQobsnD0Pm8MtsbiAEoIT/1iM+tCyDQUJ57lNuh+kUoK6NBBYHG8acr7ihH8DYlwpcr7NuYrbsyQg3lxrWUD6EC5Juo7q/U1ObMqj0PkdAxzMv5DIAVtGS3L8vBMZKR/8er7y24vtGNSkOYaojnw1jGCTgy+2LFBQvawy0/1E352Pu7lzcw/s411UdeHqBON9BrQvdIW4iPpe/17RxgkpRrr1tt4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vBsdW6tIzMkXMGgLkfCZxVEdRJz7akinRvy0sGNBiw=;
 b=Y1HuDXY2ctLwC4fIK0esOP/Bpp1oHwz7dLwU1J9zf6aPkml0PDdRKLTlHHiVJlcUqiYw+ABTMgNqk3EScZFlhx42A9otVio7Fdh5b3LFl4xpkaTmz9SBLwOGzT7Uew3lqTToHCsQRjADp4kxgWWUfCn6ZliCSrJuSK8ENzLyCrZYuoAKC+lLNyjOas9u1LoMV9NzeBS+FZqDrpGjnPG4EhzJ8eu0+tPptScTjgiT1sYdtD5pxxGT22NtiA+FwinHrXD9NfvUBiq1PjSbug5OYKt2lJMnNCPROCdqMdruTxgBNGIpv/bllYP2zqUCMx1jip+pqHoZt/5pqatU8Iz+7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0vBsdW6tIzMkXMGgLkfCZxVEdRJz7akinRvy0sGNBiw=;
 b=CHq5KFlnWCAoHSSTcpHdH0wp4LNISFlZNj50VZtEVmpaOS0QyrOasPB9shYkkjokkT7aLjMivKnVNa3j3u0XtRhpYQYhNwjixnCZ4JHKCiIse4FjgdTaEFRWWmOk3Mh/448dsIcnheUgKTrDqjFo5tvlQJm4PpEgKzoOdx1AiuDhMwg/VisF5Y4PU+YfcvP763q8a6HYyH1b1RB7mdbt9pbRhYQTZTfCcqTvR1OruS5GlEzlhUGaPYnMsb/yqtZmI3zvzSYIXx3r6qLpPFHo+QmXPj4xndumN0TVmH1UUsXbn0uedsjIjZEbTosywDpsiwcP1PCz3g3zZ8tJ1wha1w==
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:7c::28)
 by AM0PR10MB2884.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:49:40 +0000
Received: from VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2826:61fb:9338:aafb]) by VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2826:61fb:9338:aafb%7]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:49:40 +0000
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
Thread-Index: AQHYTaW3YftshBPJT0uGZWTNekz6x6zqtRYAgAANgcCAAAcIAIAAAY7w
Date:   Mon, 11 Apr 2022 14:49:40 +0000
Message-ID: <VI1PR10MB2446DB6CD7B54411232E0CCAABEA9@VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM>
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
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SetDate=2022-04-11T14:49:39Z;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Method=Standard;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_Name=restricted-default;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_SiteId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ActionId=3e49d844-da4f-4a45-933f-ab97021e48e5;
 MSIP_Label_a59b6cd5-d141-4a33-8bf1-0ca04484304f_ContentBits=0
document_confidentiality: Restricted
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 139c2ffb-dd55-45ac-3e18-08da1bca822b
x-ms-traffictypediagnostic: AM0PR10MB2884:EE_
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-microsoft-antispam-prvs: <AM0PR10MB2884D26D4F8F96B0A6CED6DBABEA9@AM0PR10MB2884.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iiBjoU1dcGq5fq4g1rHvMiNSK+J/gxKyv/ZM+TeOmEkCbV8hYH0XBf8t9fkViqUveo1y4McS30xAoD4cwdgDxKh+YK8Ajz3XszTvpPGdAqYRDmEJIjkOhYKL8+Kx0YMgYA+wBXAcDHNc3XAIWgw5FfV6inqJFgyyAO2iXF3+zHGsuH/84HKS0sOwB4vvati+JI421pDfbchgzzH4Edkkio8C1tb20XDQkybEwWQ2KrqR0fTxPd63HqVpS9IecuGoSgXvmMWPF5Tzd1sRn08MkgkV/JY0W6EijK0sWOsyAyMTJLxxIvMDFFVbMqznZOoaGAkbXvjPaBYL50HU6elQH8P5gamjKN375AFOrgKfhLd21Mk9Hy1m91SaumrEPiwpo2W4BcHZJ75Qe5w2YuwMUyH46YHLvX5s2DhfEW2G1WmTTETBze8LjCA/m4SCx42i8bn/agaAd+m30mE6MKcMdXBBOPTTr+BbTkx6Bp8X057FVagNgh5rFBYZXq82J39L4VFI0qjaI9qbERaKTz6L2VDwdoYb2NesrwmysjcMA4TKNwwgOyFJwrKgghvRpVzA0o9prylRJgzYxfuwTuf721C8N2r9l56DHqq5Q1jMMOeEx9dKp0tbJ4gNhHB+LTgodsDSXTNeeg/I65FFHus421DSZaZOxoF8vVdw/5p+t0PIZ7dWTvZ66XyiGWN61i0+VHRCGQ0BA4SrWkLADTYbCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(83380400001)(8676002)(107886003)(26005)(66946007)(64756008)(66476007)(66556008)(6916009)(54906003)(66446008)(76116006)(186003)(8936002)(316002)(52536014)(33656002)(82960400001)(86362001)(38100700002)(9686003)(2906002)(122000001)(508600001)(6506007)(7696005)(38070700005)(5660300002)(53546011)(55016003)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gM2MigKnNU+zyr2vH9//7Ycue2FYaGYXE8f4EJoct3skA0DzMYSFUgjaWoIo?=
 =?us-ascii?Q?dzRGTnrPiAfmyhR+aZ1X/fsRjyR6K/+mUaxOJw4WvlOsOt6cqZhVRjltaUli?=
 =?us-ascii?Q?E01E1pvjStSe43PedxRprIezm/kchyOKlUanWfB0jdodzoE1tocKPFw/ry9H?=
 =?us-ascii?Q?UzEto0lCQgkKw/PMoupnxB9i6Q7jWyitqYXfAK6H1wXGb0fnKWkTqkoD/Y28?=
 =?us-ascii?Q?Jml6f7PA9/FKHU0xQ+ryc+mqkNe5HTB0j3o00+YParOFyKJywgnFeCag4E1E?=
 =?us-ascii?Q?UaoNTXwQFaw3pACgNPL6yPDz59b51DZ0mlFRCCCIuMeypy2NWnQnEqxbdctI?=
 =?us-ascii?Q?cUxzxUobNE/mjU6DMSr4+jrmAaDz72QtzsGPmrVFlWflG4994V6njcwPTPs8?=
 =?us-ascii?Q?Zja/Sb+RZFZaCSMGTPNXE8fWGIw86ejuIgsrYhNHq5ztaVWapwpY0vSwn55e?=
 =?us-ascii?Q?hdF7xerQzbWjDF3xp12f+Eb+qXuHiyxgf+cLmiqpSNZFThhWQe4pUVJBufBx?=
 =?us-ascii?Q?oNtfdZY1smi7yvmgejM4+e358oAjRlA2FEbnVF9blUJWaR6qDPtseb6PB2qY?=
 =?us-ascii?Q?AZjLKGRoHJybUI2aThwsdbb2739bBYmsad8NuZ/mG/EgWrz254tW+Q5gKCsa?=
 =?us-ascii?Q?5hSq1OcAs5hCOY8VBVGIXfHb1y+FOtbSRZ/yucELQkAGVZcEoNe2zFZ+497D?=
 =?us-ascii?Q?1rVW9GajI9cnj6GKxBCJcla2rHeO4A0534AQozGvzgdg1O5ROgojYbdLdiwH?=
 =?us-ascii?Q?bt266WNgd+SXDbXovNPR9fbhMQP0HTuDDlnW96p31Fkony1M2Wp1+gCe/G7M?=
 =?us-ascii?Q?VuN7J33MP7BqKxwmFil181CsKiafY5OIRHdJ9/83VMtFnTr02cbSux2M/oWA?=
 =?us-ascii?Q?WT5a5MuDflOrSPgD/YW5231qKe9BLP5GcFPjmpYF2wp79AxsxK35PPiTwLog?=
 =?us-ascii?Q?HERXDd2N/UGN0qA1LZH/+2oAOOZyxBnfT92QQOabL2rSikpJwy/0gykoutjG?=
 =?us-ascii?Q?2rySJn7YO3EXcB2d7oXLTGLNxEdWwn2qZ97doR1EmbIekqOrX+erpbUcEhfE?=
 =?us-ascii?Q?XVLmdAZelhyFNfLnZ+F78iFlCmVtDcU7TybCplCrJuN1N3RkE9YbXpAQcrrZ?=
 =?us-ascii?Q?Eh29/qmvotUaYjB1kqowt9OCeQwf5x0CzM/xheCTAtgrGNQDRjH+8CrBq1fL?=
 =?us-ascii?Q?BOA1JKTOxCcDVClD3TPIuZGp3/GZaYeFvyomqvxg6wIDGaxSyglIns7uzOMJ?=
 =?us-ascii?Q?tJySQm6Zrr2vlFJG+e9OGdVUyleVWK7tmVCRn9B0Ia59DehDJTJGU4WJovPU?=
 =?us-ascii?Q?BJIEXKLq7vYPtIL8nfFmgAqwYXJA1FlE8EIHbhsOg03MSoD3fuC9zMl+gByQ?=
 =?us-ascii?Q?hhNKYhwvpiagw5y5IAIEaayKIRyhVoGIeM4/pLcx9Mzl6Mt2R1GGMXa/hRF8?=
 =?us-ascii?Q?ekX1HYFG3lJfyWIf2LmeQHFcD2CV31e+Vz/KxyjPj/eI3lJbJdRnDfev5pKS?=
 =?us-ascii?Q?PUTM7KN6aJbJ9RTgo7clkqsuGqOkqr54yJjY9L9w2fCCoZpfeiZpJrRgYpjX?=
 =?us-ascii?Q?rDspJquA8SwcnOdJZdbQlRe6tFz2M/LmA2PZfdqdcmNaDTDrxGubw3566DMd?=
 =?us-ascii?Q?MuDQfqqiALjO7ZvNAG5761JX3ezlp4KZ4lYBTgJlWP4aFeZdPRpv81XcAmEj?=
 =?us-ascii?Q?HsH9jQ8rzEJdEGm8DWdqeSFaulxRQUEUJEQxetUX0vFPx2VOx4h9rCRXcDYX?=
 =?us-ascii?Q?XFKwC3gnIwvXPB8iXBFnCabBMOHdqZI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR10MB2446.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 139c2ffb-dd55-45ac-3e18-08da1bca822b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 14:49:40.7093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: klNlwFU79IxnCjechaRgPoyynMjUNvbvr0l/eKlwRJ71W+744QYlzultvfSioDYtcR69Mx1MIbyeRDQcc58cwi+gwSzgFeYfEDOM7J9jet4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2884
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



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
