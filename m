Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14ED4CC16F
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 16:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiCCPgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 10:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiCCPgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 10:36:17 -0500
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40081.outbound.protection.outlook.com [40.107.4.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCAD16F95C
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 07:35:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cr/ijxbFS+Bsug2OMyn9ms/Dji5i3hOp7/MHTOnyBgTLr9ROQO/8E6lXuh4eZ1MoOlLwvkrSaUco8LayfXlOFnvliObNGop9H3JZM/wdHwgYfbOLqdADhkiR76qtNiuMEtPnMc17EbcelZAIa0QX32yoxd/lzmN3DoM2rxHpWr1qCOBSkFzbNXBEZzOzM/NfgY0LlSf6ehuAON928QH5iiiI8ZdS6zW/TtLnaKsX5iFCI87ErIo5x2u2442vyRg/1um6bjUlnThtBQ6uXJiJ0sgM5s2nCpp+Utwyxe/3Um1VooL5LrQdAoCRMceWQ+7ua5vbguaDw3wTIT3xjCwfvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18LhCi2gFq6kB86uhT58VmlpgSY9qFOuG1oswT3sue0=;
 b=ftzvog1TRa6q7jc0HxgVDKd1FfhoE86hZ3hO5w//3s2FZ2ivROdLRVxmlotrNBWC2NKReA469cNNW+pKs0zlrM5Dm/b9flt6o0GOX11KMDELtfSwFDqZjkDoShgcRsxHXwzcAoSbnkDTwbB0iuz07SUlUx0kPX48AxSbCduyaKdBKaogre8UMRm32ULJE3LT05LYfp68T8Wvvpu9grYisLpbW6amY8zHftmbotD6CmRk40kPmMDbiHm470RFRXLVYHp/QkhPtSdXrpCGt6sJDfqk9O8CDU6MUVYSUvbIYdfMibKcTJhnFc+VZ9ArbQe6zrmmXmVgc1/kqCQETl7jqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18LhCi2gFq6kB86uhT58VmlpgSY9qFOuG1oswT3sue0=;
 b=jdTujQlHw+c5FT/mr5tJCgjUuTpx7FaMeAk5s3Xdx4B9GUF68k2HfZPZmt8wk9+sKpekNknpAhWjc2XoHSXGaAtvztaZWEjOg5qFSiP5oFZnX9Q7sUgVj0O4w5CmtPoVrgdijAZjNY2lnv/lswRhsA2zn8TNwpoDFC4TNK8WXes=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR0402MB3746.eurprd04.prod.outlook.com (2603:10a6:208:e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 3 Mar
 2022 15:35:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 15:35:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 00/10] DSA unicast filtering
Thread-Topic: [PATCH net-next 00/10] DSA unicast filtering
Thread-Index: AQHYLmnKbqJ8uFqvo0eudldhc5/zKayty8oA
Date:   Thu, 3 Mar 2022 15:35:29 +0000
Message-ID: <20220303153528.mgaoxg4bafxmlxfz@skbuf>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
 <87wnhbdyee.fsf@bang-olufsen.dk> <20220303131820.4qzrcrdtx7tlhaei@skbuf>
 <87h78fdsnn.fsf@bang-olufsen.dk> <20220303143529.jitz7x2d2ehp7jlh@skbuf>
 <87czj3dq6y.fsf@bang-olufsen.dk>
In-Reply-To: <87czj3dq6y.fsf@bang-olufsen.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 202899bb-47f2-4bfe-bce3-08d9fd2b728e
x-ms-traffictypediagnostic: AM0PR0402MB3746:EE_
x-microsoft-antispam-prvs: <AM0PR0402MB3746EDAA316267033C0AEF37E0049@AM0PR0402MB3746.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: myZH/3+pnYQ7/Q3dXe+uPbg0A22Ek8CfQmLl61djfsiRTocOyZPxN9mzda87sB0y09eZU1B0qECc3pU/NX1Uy9UbuazG2TK1CpOMkYSylb5AzNhOB5NT+E9ot913iYG7q9EB7lWUWqH4ZyvhVTekJ7w8/B/mxMz4vExqB4Yb9GBuPr+4ImbPANVMZ11sQxLHAfSIegU8WS4McDF7w61+gWP+OZykFkxz5Sk2AGKT1wr9DdkHiVDsKzYDLxOIGhGThk1PJOFG6Ihh2x72toBhKWbzoXAuxtBn6EoBaFDCEBzsrWRYTabNKlTMHu+uDICEiTJg154T4U3aVKo85WBjEQtZ4/moS2ZdW0r4h3V190VjnCwXeWSwrdiB/JNEdWslYaC4qnrJC7Q+Hu+bwZvLvmbUNe+k3oKR+oa9pu2LWuhRufV5ro0g0msy3IOSVExatM4eSSEDViKGtKUlgwhRvOin76Gy4HOXeU/PmBxtZcALh3Euf7szdbiqukVF98EUymOfyfRHblE/nNJIuYO9MPV/Fo2FdwyRRA1xCRZDtoiuasjTmqeydL8EvKemj2BmTO9k3wD661T5rOLieMWhgPpArLyx3bG1gjnreq9t1qN9wVWpUp4O704fLSkVwNuTKPNzs8bmJSJDWywLf2CQLknErj5SN4qs30PtpEPbrJiI1e0MqX8qcqPN8J5fUYe+wA9Yswq9+XrxfLT8eJ/Ndw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(44832011)(508600001)(83380400001)(122000001)(8936002)(33716001)(38100700002)(9686003)(6486002)(6512007)(7416002)(6506007)(4744005)(1076003)(66556008)(66946007)(76116006)(8676002)(66574015)(38070700005)(64756008)(66446008)(66476007)(71200400001)(4326008)(316002)(5660300002)(86362001)(54906003)(6916009)(186003)(2906002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aEpKaHdVZHNSeFhXWWgyd2NMVUpTZHBvMXQ2NWNmbTkxVW9NUzU5ZFNrNVpO?=
 =?utf-8?B?S0hEMlhCQjJMelNEK2pJU1piUm5lNVlhZDR3ZW03WnB6QUpFeUtQaSt5TmMw?=
 =?utf-8?B?bndXZmwwY0VSOHZUVHZua3lGS2hLejkvR3N6OWhyZzR6d1A2aGhOWDZjNnd1?=
 =?utf-8?B?YXdwVSt5M1g0ZnZXcnNBcTloaWVjY3BWdEh2dmJSZXlrQ2tNZHRETDNFUEh6?=
 =?utf-8?B?ejFwLzRIZ2hSVlgzMzd0ZUtpQldYL21uanJMQ0M1bTJQTmhXdVgzK3dtamM3?=
 =?utf-8?B?SkdOMktzbll6ditPRk1ST2pFSXd3S2ZKdEsvRzRMLzFiUFMyMHR3bHF6NzF5?=
 =?utf-8?B?emlyZjdpVTg0ekxIL1Eza2Y5UHBmOFhBQzdCTHNaSWt6cUE3MXU3SVFDY29X?=
 =?utf-8?B?bWtKdHZQazR6YmZHekZkUWVwcll0WmJKQ1ZRUmUwTmVCcTJJSnFsR0Y1bk92?=
 =?utf-8?B?dlhMMmFlWDFjQlB3YnRTVkJIY1JySGtpeFdHcElLZ20zcDBsYzFEbzYwRkRO?=
 =?utf-8?B?UUt3aS80Nm9yV0F1VFptNjFxdktxMkFtckpaTUxkOHo4cEVVcDFrUmo4RDk3?=
 =?utf-8?B?WWNvUDJqalRsV0hrVXNlSytjNWk5cDU1VXhxVWtnL1R2RzJGakdWSkV4ZEtu?=
 =?utf-8?B?TFY3QUptTC9CNUp2NHY0TzN2RXRGbFpPVlF0R2pvYzl2bDJrZ05QMkxNYjg4?=
 =?utf-8?B?S0UxNC9COFdwM1d0c1dRTnNtVzYwOHhnREdsRlh4OHBYZ0MyTUVGWmtSdDE5?=
 =?utf-8?B?V3FmRkp6bG4vQ1dkT1JDQkVaUENaRmo4a3A4dm9PUmFKb1JEWDM0WkE0Yktr?=
 =?utf-8?B?SGxkUk44bFlZTUNwK28rdXVjRWlxdEFreVdmSnZRc2cwczNjVktLbDQ2ZHl2?=
 =?utf-8?B?RktGcFdtM3UvdmhhblZ4Rk1OL2RVL0JBK2kvTldNbXUxT0dVcTA2UXVpMEJD?=
 =?utf-8?B?VldkemdxOU5CY2luaWNYZG1sRlJTTGdkSlpjaCs3SXhIK3FxZVYyRU1BcmJJ?=
 =?utf-8?B?K2lkK2c2a0RxTC94RGZaT3p5Mk9zT0FJS2dPdHJiZjJDK01UdGV4Y3lwckZJ?=
 =?utf-8?B?SjVDT2NDNmYxcXdOTXEzS3ZXa1Z0ZnVEVVc4ajBnb2RXRjBZUWdjUms0dlRX?=
 =?utf-8?B?UFNySnJtRmExdlBTakNMUEhVREo0aVFrbFhzS2toR2NXZmhwV2NxYVFiOG5j?=
 =?utf-8?B?bGZlZE8zMDdrVkp4VHphTUt0NDVJOEtQUmdJOUdqRGFSVTBleDhMeHZocDFR?=
 =?utf-8?B?WVpBMFBPYzY0MjJSN3FIUXpacnc3WkhiWUo5bFd1b1grMTh0R29KRUpTQXYy?=
 =?utf-8?B?Rk5MY1FDTmhnbTdiVmpmenVRK1FYalhGdkZRaFRRc3l2cGRzSlA1TmJyc2Ft?=
 =?utf-8?B?OWVZb3RwWFd4V0FLNElaVVRET1k2bEdZaUM1Z2lOKytINlhTL0NCS09Mamx4?=
 =?utf-8?B?bVpVZkJ5cVJEVHMxclFwYSt0T2lPWXZqanVhOHZnU2p6cXBlOFJlVXRFL0Rj?=
 =?utf-8?B?djFGVDEyZURxWE5WMnRFZ2RYQXptRVp2VTRPRDg1Y1NYK1EzK3E3M3hQZTFx?=
 =?utf-8?B?aHRtR2ZTNzJoUVRtYnpRYUFMU0xQaU01ZVlFK1dOakFOZ1hTcXl5SHlWOEF0?=
 =?utf-8?B?ZzBrSGg2dnI2SUlOc0JGSU1qdDFrLyt2Mld5N3VSdVY5czRnam5Zbm14eEhV?=
 =?utf-8?B?MkFRUGtIbksrbkM4WTVmZWRSQmQzN2tOV1VlelVYTWhCRDRsVkFjeGtBdXR5?=
 =?utf-8?B?dnE4dlB1MENhQ3psdmFMclhFRzg2WlBaUlN2d1R3ZUNXNEIzTjhHaitDV01w?=
 =?utf-8?B?b1FIM1VmRlBUWVJNNW9GVU5YYU1hcnAweWhlaWxsV3dGWUwwSzhHUW1LMDFP?=
 =?utf-8?B?emU0OFN6UHB1YkwyUzJBYityWEFZUGI4M0dhRnhqL0FpSFRBeWFUWHo2N2ov?=
 =?utf-8?B?Vlh3NWR3NTJNKzdjN1poS3J0ckdselpacG1uMEs1S1h5Z1VDNjVhVUlyeDhT?=
 =?utf-8?B?RU1GRlR4bnRyalJSNXR3ZkVzSUszTzRpS0YxVHVEQ2drVnY4NHgrc2d4WGtY?=
 =?utf-8?B?dGlRNVgvYzRWWXNFUDl4TDdYby96bFhkYWdEVnBMbS9wTkJROCtIblVpOHpD?=
 =?utf-8?B?Z0VDbUttVjlFWE02R3gzU1RoVWdFR3JINldOUTh2S01Ia08yVFlQZEw5bnpu?=
 =?utf-8?Q?kMsQ+xfpwMOD9I0yiCAY2hc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C8BDEB6F0D1494AB9B5DC80079D4C58@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202899bb-47f2-4bfe-bce3-08d9fd2b728e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2022 15:35:29.5920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZiA5P+eGFCDhvqdje8m+ZAjlUzlqLW6roYOX2RXG90ZkF7BZ+mR4lOVyHQGAqai2PQ4E5BkD7m+6+33TJQDB2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBNYXIgMDMsIDIwMjIgYXQgMDM6MTM6NDFQTSArMDAwMCwgQWx2aW4gxaBpcHJhZ2Eg
d3JvdGU6DQo+IFNvLCB5ZXMsIHdlIGRvIGNhbGwgLnBvcnRfZmRiX2FkZCgpICJvbiIgdGhlIENQ
VSBwb3J0IChpLmUuIHRoZSAncG9ydCcNCj4gYXJndW1lbnQgcmVmZXJzIHRvIHRoZSBwb3J0IG51
bWJlciBvZiB0aGUgQ1BVIHBvcnQpLiBCdXQgdGhpcyBqdXN0IG1lYW5zDQo+IHRlbGxpbmcgdGhl
IHN3aXRjaCB0byBmb3J3YXJkIHBhY2tldHMgd2l0aCBNQUMgREEgJ2FkZHInIHRvICdwb3J0Jy4g
VGhlDQo+IGFjdHVhbCBmb3J3YXJkaW5nIGRhdGFiYXNlIC0gKHN0YW5kYWxvbmUpIHBvcnQsIG9y
IGJyaWRnZSwgb3IgTEFHDQo+IGRhdGFiYXNlIC0gaXMgZGV0ZXJtaW5lZCBieSB0aGUgJ2RiJyBw
YXJhbWV0ZXIuIEl0IGlzIHVwIHRvIHRoZSBEU0ENCj4gZHJpdmVyIHRvIG1ha2Ugc2Vuc2Ugb2Yg
dGhlIGluZm8gaW4gZGIue2RwLGJyaWRnZSxsYWd9IGluIG9yZGVyIHRvDQo+IGVuc3VyZSBwcm9w
ZXIgRkRCIGlzb2xhdGlvbiwgc3VjaCB0aGF0IHRoZSBlbnRyeSBpcyBvbmx5IG1hdGNoZWQgKG9u
DQo+IHBhY2tldCBpbmdyZXNzKSBieSB0aGUgcG9ydHMgaW1wbGllZCBieSB0aGUgZ2l2ZW4gZGF0
YWJhc2UgKGEgc2luZ2xlDQo+IHN0YW5kYWxvbmUgcG9ydCwgb3IgYSBncm91cCBvZiBwb3J0cyBi
ZWxvbmdpbmcgdG8gdGhlIHNhbWUgYnJpZGdlLCBvciBhDQo+IGdyb3VwIG9mIHBvcnRzIGluIGEg
TEFHKS4NCg0KVGhpcyBpcyBpbmRlZWQgd2hhdCBJIHdhcyB0cnlpbmcgdG8gc2F5Lg==
