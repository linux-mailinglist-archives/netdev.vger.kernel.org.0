Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD59A405EA9
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 23:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346423AbhIIVRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 17:17:44 -0400
Received: from mail-am6eur05on2053.outbound.protection.outlook.com ([40.107.22.53]:16128
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235679AbhIIVRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 17:17:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxPidb2d0ELqNiO1bfyRe3xc1sTIbxReR29scMTZLVABp4I8OSdEdsRi7y30TwF3o2RIetRfj61/vZzEk85codnOWUAaBsWjEvTpYI3nstsBfM/sPemzeUZGhpq0Av3UMV1C3c03YqiXJqLJ+B+XA5mTW6uyq48muJ6rUC1FpT803dT98qheGhPhh08OOva7KW+V6D6nIrChQEQx5MqHP1z4m9PamVFQxiCMpdCxkc3zCPCoDfrhIf4t7mwAc+jLSaSmrX70lDN4zvKeiwPLezlbCdYyN9aucdBkab84wCnHqemLdgHy+SKzpgYtqEY+0TBIyfxhicSDB4z+AsMmmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+OWOUZzxTMTapL7qBLL1Epw2bZX3Gch6RhfarJ+6hf0=;
 b=T8wHG2FslXrLXLZUkLguTKeOKEQnEFs8NQLHjH90hKFCm1lFrl1Pomk/7X8Gh8ejm5H3ApBUsdy1QJ63DtXJbQfd/Vg2IxAMZFLdkM2Bc0zoY+g/A+FnT6iUe/Q3btNj9FyIH5LDngQpspR0WqmFw8Cw0gdk/a5jYQZrBBvvqM29YhUsXMC9WQN8DECRIDonSbrylOooqX2AilZ6IzvYtIWLnEOBzwbj2ZoRYLIRVFBRRR1tIKBJcxRc+G9f1hpl+8+8GBFne/LH16LlAWMgPhQInWHz5tb42OXpL4EQfiYmRwMueG4yO+UPX5VcE4uBWq45lvWsJl+L9JLrtp/2WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OWOUZzxTMTapL7qBLL1Epw2bZX3Gch6RhfarJ+6hf0=;
 b=NNdgjzSrHxY4jRKO0bU++WaBoX/EIJ4XyriDG9Ti8NM848DNl+mim2QBKiWX/5b8qPH1TEc8IxqYBKNXy21vUqFpLLZTGLNaYdAno4wrW+S4dZB7lMYdwYqROkZy6xRbkgh4lV1XhSJl0hoxgDMdiHZhheHrLVupG1qvJM+ER24=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5539.eurprd04.prod.outlook.com
 (2603:10a6:208:115::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 21:16:26 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::e9c1:d45f:e3ef:5f04]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::e9c1:d45f:e3ef:5f04%11]) with mapi id 15.20.4500.016; Thu, 9 Sep 2021
 21:16:26 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>
CC:     Hamza Mahfooz <someguy@effective-light.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Thread-Topic: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Thread-Index: AQHXpSuO4AOhY9kToEi8I4sPqFaslaucNY2A
Date:   Thu, 9 Sep 2021 21:16:26 +0000
Message-ID: <20210909211625.zwnbmwzqa5qqulrq@skbuf>
References: <20210518125443.34148-1-someguy@effective-light.com>
 <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
In-Reply-To: <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8986baf-71a5-4db4-55a0-08d973d715a2
x-ms-traffictypediagnostic: AM0PR04MB5539:
x-microsoft-antispam-prvs: <AM0PR04MB5539E4C613787F14A59DD630E0D59@AM0PR04MB5539.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JvG1X4BNG2/GAFhJJd4vxZTO8w9nlEH4ysqO9WwqIdtPN03fynmO3+FueCkHwUBQjCvUUZaAmb/V+pFTNL5hLBgzwLHKBDStI4qAT2pyzqRxLVLeQ+9wzwtyeRGIRmbWsOp0i82yfn8DvheFggUwsh8UkQU6d7lVRYywYUpPAtUfqobkA5fhbjLQ77Dxm+rdPMhMwQ5uVsLh1vShuImce+mrGk14B7QQS0vYPP9HewGPFIWva5gW2LcalPf9j2t2QSS2gCR7TCR2y1QAhORpwRlsZ/qhYF7/tI+NtHKHIx7oQP9L2TCbvMS8N+mVo1q8bUHHxF3XJRnye0KOyRpKiq9RsQwCzLOxT2/d5bKcZythBZxcYJvEKuhUBvZHTeHdus3k57TQnfruz7dUSM2Ma3/Rx0NkmeVqedaEOsk65Sj3W+0rzdOLAN3916ipkZmFOAXlubQn69iSNQbzWyyRQxIvWsC6TT1Tjb/TgZidpcThyW4I7qlt5m9iygF5ADhbNNG6r6+BqdBse77qWS1HpWHbYG8dRjnwyyPQzzOAb5vrAcD5b2nlf7yks1SGaN1o7BCG/fyfnriWzCxX5amWAEOCDWAVLQS223Z+hhNFppbt7R7FZO/NpyEROb1o+Ui69FX+Ug9lK1cP23A55gPOEhoVesghaYKxhMexRUwfwZdDPPZ800F7dgxdo/k02WdT1qG27KVPVn7sO3S1nW1GWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(346002)(376002)(136003)(39850400004)(366004)(122000001)(44832011)(38070700005)(9686003)(6486002)(2906002)(66446008)(6512007)(71200400001)(316002)(4326008)(6916009)(1076003)(66556008)(33716001)(53546011)(86362001)(54906003)(26005)(478600001)(66946007)(186003)(64756008)(91956017)(76116006)(6506007)(83380400001)(66476007)(8676002)(8936002)(38100700002)(5660300002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n/8a7qfOYbbulQTCO/W1fE8uBh+ZdY59i0KPSmh/0rn6cCA1Agt7gyBhBO0o?=
 =?us-ascii?Q?Zhtrq4rj/lWFXpHqWEXkNZP9qxUSuvZI35xuY7zlG7B5IMj8X/1E+xQg/Wvf?=
 =?us-ascii?Q?4Ff2NssYmliH0uA15DNZEo5qgL/8MkgXDJhCAl94Eb0BtKAt0uSHNk4ywGLO?=
 =?us-ascii?Q?yvcd5Hs894dP3QJb6Wz5qinCPN8hTW7It2LhAMei1+Cy+Eku/h8WPnZy0jiU?=
 =?us-ascii?Q?SO+97b0bZFaPCGCAf/+XYS66Bs8qeSiYKPkGngYQhTLgwC4FZlerCd7d6krr?=
 =?us-ascii?Q?BLUOWOADTlo0E6SB8QLZPluYAKjc2/90JGm2/ooyA5jf4n4sjZZZfsr6iEej?=
 =?us-ascii?Q?P2Ci55Z1Dz1ILHxBYYP/g66Vy7gjRe9CMiVldggiZtRmDCdlXhFqJ0pxNHEo?=
 =?us-ascii?Q?JWvaKFCtDFD3wKPh4EBg5sDEJ9695AJCemR4uHrfV7oLKobXpyunCyiiY7yG?=
 =?us-ascii?Q?+gpk03v6ug9202zdTkfWr+kjbHg8mkRBVKwxSfosIBb/FGlyO65e3Rw9jEfV?=
 =?us-ascii?Q?vh+Rwilutqz6MnKSDKXyulUrvcSv+YgUy0LuytKBFGJK8m2GwC/TJi4dknBw?=
 =?us-ascii?Q?g04X0iKu5oTbsaAcFXEgLZaAoGy5C3UcszdeIFEAjOwhcfOF+1Hgh5XEU4HU?=
 =?us-ascii?Q?WUSDZ0RcWr43wFnnU/8HXCPmQTuf2U8OadE5IcLgBBlIqD5oi1yeVek6tLpi?=
 =?us-ascii?Q?FDGaGH6kOMRa4SEKUPWFJO6b7TlblZIcDwcSicgQwF9s56hZ+jog4mYdUydC?=
 =?us-ascii?Q?rXQBpSfZP5blX/pAqmqXV2PGRfHTcEozaWnD87uIyi2NkvJFTLCPR0ppuo5a?=
 =?us-ascii?Q?REc9tob+QA7+ceIpYvAPX7v2LD6L4GzoJATDbVwmKLRTyLehtmb3LVF3/Iyu?=
 =?us-ascii?Q?L3q2L2dm5RhHkhmZb/ITJvKjHL29EPQgW37LFBBK6eX24d16AJL+MRzPYONF?=
 =?us-ascii?Q?n/HM9g6d9N6AzTtHC9JWCbg4cXQvgaH4aKYgJJdXf2JoMi8+Hsf4BVAIUVZH?=
 =?us-ascii?Q?2A/v5hrp7cwGmYpdDccKsun0LzuYrBWhr4t30ANX9sNsPLzDa4nbHeULGlZB?=
 =?us-ascii?Q?XmuhhU9SPLeSOGpCfhiIKStNByEP296dX6wuRtRJ7yYMqWqmW74GqGbd7SN4?=
 =?us-ascii?Q?/VX1A0EjIekmBpVaGHnn3Y1HtHKpdd/zYh5AsYUpjQzTlEB2GunQ4YsypRKv?=
 =?us-ascii?Q?6UR+f2SSTuHo2ug2mOFUcJBVSx/fW48tsHrMn8BP5k//1Z3jFP0ra73IYJlh?=
 =?us-ascii?Q?aJrMN13hyVkn04zJs7zXptYmQlUZefzFlZdCoh+c2OTlG9BWJxYp0KGdUtHV?=
 =?us-ascii?Q?5jgTALM5lMBtF6AR7U5CrhEW?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C2A57FEA214F04BB33D9EBC658A990E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8986baf-71a5-4db4-55a0-08d973d715a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 21:16:26.7129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mFml6vvj5jpcGGNZKa86LZljmB1uCSeq0CTTHvmblSD5DLbZoL8Paq81Ax5zoS05mO2ctqN/s5n1D59zmVlytA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5539
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 10:33:26PM -0500, Jeremy Linton wrote:
> +DPAA2, netdev maintainers
> Hi,
>=20
> On 5/18/21 7:54 AM, Hamza Mahfooz wrote:
> > Since, overlapping mappings are not supported by the DMA API we should
> > report an error if active_cacheline_insert returns -EEXIST.
>=20
> It seems this patch found a victim. I was trying to run iperf3 on a
> honeycomb (5.14.0, fedora 35) and the console is blasting this error mess=
age
> at 100% cpu. So, I changed it to a WARN_ONCE() to get the call trace, whi=
ch
> is attached below.
>=20

Thanks for the report.

I don't have access to hardware at the moment to actually see what's
happening since I'm on vacation.  I'll work on it in a few days.

Ioana=
