Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4227748BBEE
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 01:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347268AbiALAek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 19:34:40 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:14479 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347263AbiALAek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 19:34:40 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 19:34:39 EST
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BM2Oil009275;
        Tue, 11 Jan 2022 19:24:22 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2058.outbound.protection.outlook.com [104.47.61.58])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgp68rwjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 19:24:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fP++6oCsgqGs96n8bhC6og2nrmuVeC5XG9B4aU2Kl2A3VC2ZFFzfpuFk8OyYUnaVt52eMCP30N+C6eeTDrt1QdOUY0mwlFKmIElLaXi+avZuwxgTyq+s/lga9smjd+ybX6e2gZAuOBVTDRCRR7jOT1P1d0lNjaNiU68cw2PrClIirGvEoaQ7MfQ+KEBwEaqihcrXS9QFJS4gWOhbtBCDm/6kqDCorikta3U9uePvR2M/1kqhuXMUGhwSFBTkv1TMpczTs7GaQGJClSLVKnTP3DsnQCSGozwwxMxgmiYvKLKCA4V3RatPRzFTIqZEHtZoj5tUXp+E6bX8uGJstGP8tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjXutx+JYF4oNAQqbAQ6mUyFWqgmtr8MV9OVqgzi8XA=;
 b=VIH7AWWWKr1/95arayp06er4OsHhi3BWeMQFpFWddKIuoxp5my3YL6ZUpsM8bddYz+LjbLq4h5dmkviNWBLNUnE1Pddmx9QMQkC5l+124Vz5KhE090uU67/FWLZW52oiV1SUm5omDiTPsSCo8gcf+R2M+YzUzQRUOVo2rskjixp2KJshCSe6hd8z2yqFMrpkWfgjj7zePlKfttTFbLdI/ZPYdnFh4qjjYlGLAt4ZDx7FWOdSFakkP/KDuhJ6eaV9V3h9L172cZC7jeNKDu9Uf97YrZj6x32wNpwPlUGYkQLDh53MZ5hUmNORNE4v2zQtk2feVAFBqt3Z4Emt0zWWXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjXutx+JYF4oNAQqbAQ6mUyFWqgmtr8MV9OVqgzi8XA=;
 b=D2dZ+elKWKJhIr4GhVAYXUzpJDTc6/UE3iQW2SvU9s+f9+ZnN5dbbEqG/b1xohIowqaO+lgzRRHw5CxJTEsCBfyHzPAolRLEUS/lhdNXakQEBW9qaJ9ZBXzrDrC/NItx6DYIk3PQxPE3osoXgNTG4qKeUUF79c0IvgmRC1PBzgo=
Received: from YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:4d::14)
 by YTOPR0101MB1468.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:1d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 12 Jan
 2022 00:24:19 +0000
Received: from YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4441:49c3:f6d1:65ec]) by YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4441:49c3:f6d1:65ec%9]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 00:24:19 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 3/3] net: phy: at803x: Support downstream SFP
 cage
Thread-Topic: [PATCH net-next v2 3/3] net: phy: at803x: Support downstream SFP
 cage
Thread-Index: AQHYBzXzwJpm3scMIk+a8Fqy3F92nqxehFAAgAACvQA=
Date:   Wed, 12 Jan 2022 00:24:19 +0000
Message-ID: <b862855b23f676454d5243a9a922da1c7c6e09a9.camel@calian.com>
References: <20220111215504.2714643-1-robert.hancock@calian.com>
         <20220111215504.2714643-4-robert.hancock@calian.com>
         <Yd4dZiQVinhUSwkO@lunn.ch>
In-Reply-To: <Yd4dZiQVinhUSwkO@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5388384-4c4b-4264-90c5-08d9d561dff1
x-ms-traffictypediagnostic: YTOPR0101MB1468:EE_
x-microsoft-antispam-prvs: <YTOPR0101MB14684900F28309C871AADB1DEC529@YTOPR0101MB1468.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UKvhGbZ9aWBkvHLe4TTaHVe3CAuqvIUsY/d4AByq40K5f24qm1+dy3xFJtp5H+WN/ov0au+C2mAtMCPZ/7JfhBI/re8yZB4KA3ihjHFjnrohGOnrYzoPt1dJIhFRL40K6Ii9w73FHg+LocRwIbnEmF6iUu5v4MyVzouLI8MKZ/hxRRht3V4uKsJMwQS0EtrrfpHiY3Zugy2ZjjkYLtry2lUUrgvBrRN2nBOqfVgct06NK2+/DM9SxwWzV/IImZUdCAvtSp1KYdt+hdauGKPunEdt5LFmgvt643T3aKxTAtpi00epf8YIUPxeP0wneEaFLO4MgKCkzpUf/FQup8TiO5oNwDvZKvDHYPF7VaaMnd7IHEzi+WVUHinkbJ+KlMK6QsiBiVKERe3L3AMu1zwTKjsoA3lzpVDMuQmJ08t1beJ5LqnuGLejq9DKwcSt3vPw/AUyudNZWSNoBCXJiQrcDCAwqmQu4d7vkaYa8daypNSJGmcBOWyyozByooHo04CQOJ3J6wu6omdaR817JqaPgNuYQWB7pcwOekRUNPlmaGI55GfgxlVYc1laE/fMyj8NYxNEt3h8fXJnj52s5yQL63QyA/Ns0g8ioYqtAUwngpFT18Eb5kZZyTN9AyaxJhY8Vme2EMeeVQ9QuBRk3JUdbm9/qEQD0T9cknouFci4WK8/R+EW0/m2DfmRorXaHShhCNRf/qGS2V4ePJhOAe8hQk9LjYZ98LrsIXkNiuOlxnHNu/fMjJhyiI98XXvbWXUJqpOPAT8anL6ZdFpfr/qUePuqO70cMwU9iqAq92H+5EYdcvuNawA3GQeIe8IxvdtxpTVLpZWhcAx5cb9jlN9sD8touGdZ2r3QnhocgjkUykQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(66476007)(66946007)(122000001)(66556008)(2906002)(6916009)(91956017)(6486002)(316002)(66446008)(76116006)(6506007)(71200400001)(38100700002)(186003)(508600001)(26005)(36756003)(15974865002)(6512007)(54906003)(44832011)(4326008)(2616005)(83380400001)(86362001)(38070700005)(8676002)(8936002)(5660300002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVpDTWhVeUVqZDNlS3VTTkM1cnRaUUpPNEVuelh6SStoL0hITXlFd0RBQnVJ?=
 =?utf-8?B?cWs2R0h5dXIwR1dOZnhrZExhaUpKYlVGM0tNcXU3Wk5JdmJCN05oRURLTjcw?=
 =?utf-8?B?TGpJTTEyT0pCMXNpcnFUc0ozSUlZUTNHNlcyOWtvUEVhbS8yVVNpMjFwcElS?=
 =?utf-8?B?Ujg5Nis1aVNMK0xmZUVWWnpNTXNkSHk0QVk1a1BnaDgySnRTUE5vbzJqYzJx?=
 =?utf-8?B?SkVacnhwRXdUMFcrL0xKRFpZeUFTa1J0R25BRVM3UHk3b0FKS3hxdGZuQ0Fy?=
 =?utf-8?B?TThaWk9obHh5cHNaSlIwQjBDdlQvK2JvWFl3SmUzcStqRE9iSWo4U1FvYXFm?=
 =?utf-8?B?YzlqWGkzWnhXNjdheUJOek1MTVlmMSs1TkNuN2NwSzNuUFgzdlZLdUxNbGE2?=
 =?utf-8?B?Uzh1OXRuUUl1ZHpoOXNtSFpibGZsK0FRTkJlRXJLcTVmZnJCamJjYVRmcVl6?=
 =?utf-8?B?SXVKQ2hvckF5VERDVlpsWWJwOVVHN0Y4SENicHZlYXZseTBLVmZoU256NUxN?=
 =?utf-8?B?NFBISFExMnBFWjBrSDBDMkZKLzBpWXZwcHFHeUNPVFdEZGhaZ0w4LzhwajV6?=
 =?utf-8?B?SmxOVHFENDRkWEJZSlBZMVRPU2RuMi83ZHUvNUYzZElPaEE1dlNBdzFEeGZH?=
 =?utf-8?B?L1Z4NzlmWlhMbUpjUmJoNWIvRXkyNC9XODZrUkhDMzE2WVlqK3FZVi9Tem9r?=
 =?utf-8?B?Z1U4eWJRb3BZWld6ZUlrZENnVE5NK0wvZHdBTVEwcmR2b1RFSnlwSzBnZllj?=
 =?utf-8?B?NFpiOXVjYlBJcndFaG1zRzRBeEpiTVc4ME5XQytEWFZ2cEF5ckwvMVY1VSth?=
 =?utf-8?B?WWQxTmNYWVh0dGpRVTI4SFZQeURPNnZDN1NwRXZWRUIvUjBMZWZTWnNnVlRZ?=
 =?utf-8?B?dGhqV0x1aHZWbnZXdXBDY2dIVjNUcXl2clZqUEUyYWxtVitZbTZyT0UwYVdR?=
 =?utf-8?B?SjkySGhzUHN0cjl1cUNvSW1vVm04YmR3SDhmT2xMdGl4cFprdjNvRkwzN0ZB?=
 =?utf-8?B?MGZGUHA0UEhRY3d2YThxcDhYMDhKUVFURUpKMzNCZ01iTWRqWGZGWmIvTloz?=
 =?utf-8?B?eXk5MUVoWVkzRVFXbEVSK3puUGV6NUttWmlMaG1vbDdOVXJGSlVGRHNWcEkw?=
 =?utf-8?B?RHB5NFZHWVVIMEREN24zMTd0UUtreDNUcWtUMDBHZTJwREcvQkRsVzJYTHc2?=
 =?utf-8?B?eVRXRDgwajNyQ3c4T0Rad0xaRnJNaURoQ0h1aGQ1eTJ0TGM0d2dLOWNSa3dU?=
 =?utf-8?B?UUhpSEdKN1d5U0IyQkUzU3hyUVJ2STZzUnVTUERXaVpHMVRET0d3V1Q2UGRq?=
 =?utf-8?B?aG1EOHhaRDdFcTlPK1g4dzFVODc5NlMrWGQ3TFRqOXQwN2FLbnhlQUhaWE1u?=
 =?utf-8?B?dDFlTmZhRUFxYjE2QUw2Rm4xT0ZzZ2hIWTRiQjdFZ2dIZTNWcWZRQlVKZEpX?=
 =?utf-8?B?TXFJS1FrZEptdWVNbFljOW1oa0s1ZnZuSTNESEJESzRyczZvN0FPRHloUUU0?=
 =?utf-8?B?clIzQ0N2WER6WndMRjZLTlNub28yWFRyYWpadVhTb1Z0OUs1WEIvZFNLZ0xG?=
 =?utf-8?B?b0hzOUN4R2NwT3NsZ2FwUDg0dHFBaXNsd2dWUUMvaTI4RkdUOFlYd3lrbG11?=
 =?utf-8?B?YlpiUmRyY0FGUHoyRURheHE4b1dmY1FuckVYQlRnZjNXNnhFQmk2eEQxMUti?=
 =?utf-8?B?N1hWOEdITG1KOGhQQWRyMjN4SFFBVGhRajFvVGc5TWpYazNjUmgyeWZ6czVo?=
 =?utf-8?B?QUc5UEx3bEd5MnpXV0dUdytpcjU5WDRYSmNJYVp5RlB2aFg2RUdwQjdWekg4?=
 =?utf-8?B?WEluakw2V0NUSnVSdEJkMDg0dk01akxncmNZRHBrN0xkZm5tSURVRTA2M1pR?=
 =?utf-8?B?VTVpUDJ3OEdlellnNjRTZXloTDFKc3hiQmZvVm9SR3JpWmF6STJDU3MwV2tF?=
 =?utf-8?B?SEFwMXVnanN5SXpKSVdEa0wycUtEcWF5eTZ2dVN2RXQ2aUZGa3lLVHlvNldS?=
 =?utf-8?B?RDZscUlvQWg5cFVyakNNa21LbllkMnkrTk1PKy8xTGJYR2VPbm03NEUwaU1u?=
 =?utf-8?B?blp1UXMrYVZLTVk5dEhiYXpud1RTMUtFNXk5WEY2Y0xGaURiTGJuWGlMSkU5?=
 =?utf-8?B?WUlaU2JhWDlzRGxDTHNQK2x3R0s1eWh3S3M3TmRtanpJQXBWTEhTRGMzSWtC?=
 =?utf-8?B?WW4wVitnTVBaY296SW5uaWxzS1Brbmx6RlAwc0t6b3YycVVvVVlQMUlpL29z?=
 =?utf-8?Q?G9YCKVP0QxoaH3h66uNq8l/QSevEPLpzW7T2Wg8xI8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12F270B6DB6E14468C35BE35E034DF5D@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c5388384-4c4b-4264-90c5-08d9d561dff1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 00:24:19.4392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VbS/PGcCaTXi7wY1bliwFhVa1/JyAdGBSR8OzVlMVkGu/slS+Za7pgwybHqirfd0H3jTKAyRT8cixKrl1uVi4Ps0x47pug4Ll6cwwf+pgp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB1468
X-Proofpoint-GUID: y3Wfl4c2K-hTsfc4esInnGzszJZrda77
X-Proofpoint-ORIG-GUID: y3Wfl4c2K-hTsfc4esInnGzszJZrda77
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 clxscore=1015 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=653 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAxLTEyIGF0IDAxOjE0ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gVHVlLCBKYW4gMTEsIDIwMjIgYXQgMDM6NTU6MDRQTSAtMDYwMCwgUm9iZXJ0IEhhbmNvY2sg
d3JvdGU6DQo+ID4gQWRkIHN1cHBvcnQgZm9yIGRvd25zdHJlYW0gU0ZQIGNhZ2VzIGZvciBBUjgw
MzEgYW5kIEFSODAzMy4gVGhpcyBpcw0KPiA+IHByaW1hcmlseSBpbnRlbmRlZCBmb3IgZmliZXIg
bW9kdWxlcyBvciBkaXJlY3QtYXR0YWNoIGNhYmxlcywgaG93ZXZlcg0KPiA+IGNvcHBlciBtb2R1
bGVzIHdoaWNoIHdvcmsgaW4gMTAwMEJhc2UtWCBtb2RlIG1heSBhbHNvIGZ1bmN0aW9uLiBTdWNo
DQo+ID4gbW9kdWxlcyBhcmUgYWxsb3dlZCB3aXRoIGEgd2FybmluZy4NCj4gDQo+IFRoZSBwcmV2
aW91cyBwYXRjaCBhZGRlZDoNCj4gDQo+IEFUODAzWF9NT0RFX0NGR19CQVNFVF9TR01JSQ0KPiAN
Cj4gU28gaXQgc2VlbXMgaXQgaGFzIHNvbWUgc3VwcG9ydCBmb3IgU0dNSUk/IENhbm5vdCBpdCBi
ZSB1c2VkPw0KDQpBY2NvcmRpbmcgdG8gUXVhbGNvbW0sIHRoZSBBUjgwMzEgUEhZIGhhcyBvbmUg
U0VSREVTIGJsb2NrIHdoaWNoIGNhbiBlaXRoZXIgYmUNCnVzZWQgaW4gU0dNSUkgbW9kZSBvbiB0
aGUgTUFDIHNpZGUsIG9yIGluIDEwMDBCYXNlLVggbW9kZSBvbiB0aGUgbGluZSBzaWRlLCBidXQN
Cm5vdCBpbiBTR01JSSBtb2RlIG9uIHRoZSBsaW5lIHNpZGUsIHNvIG9ubHkgMTAwMEJhc2UtWCBt
b2RlIGNhbiBiZSB1c2VkIHRoZXJlLg0KU28gdGhhdCBtZWFucyBubyBTR01JSSBzdXBwb3J0IGZv
ciBTRlAgbW9kdWxlcyB1bmZvcnR1bmF0ZWx5Lg0KDQpJbiBwcmFjdGljZSwgaXQgZG9lcyBzZWVt
IHRvIHdvcmsgd2l0aCBtb3N0IG9mIHRoZSBjb3BwZXIgbW9kdWxlcyB3ZSBoYXZlDQp0cmllZCwg
dGhvdWdoIGluIHNvbWUgY2FzZXMgKGxpa2Ugd2hlcmUgdGhlIG1vZHVsZSBkZWZhdWx0cyB0byBT
R01JSSBtb2RlLCBvcg0KMTAwMEJhc2UtWCBtb2RlIHdpdGggYXV0by1uZWdvdGlhdGlvbiBkaXNh
YmxlZCkgd2UgbmVlZCB0byBkaXNhYmxlIGF1dG8tDQpuZWdvdGlhdGlvbiBvbiB0aGUgaW50ZXJm
YWNlIHRvIGdldCB0aGUgbGluayB0byBjb21lIHVwICh0aGUgbW9kdWxlIHN0aWxsIGRvZXMNCml0
cyBvd24gYXV0by1uZWdvdGlhdGlvbiBvbiB0aGUgY29wcGVyIHNpZGUgcmVnYXJkbGVzcykuIE9m
IGNvdXJzZSB3aXRob3V0DQpTR01JSSwgMTAwIG9yIDEwIE1icHMgc3BlZWRzIHdvbid0IHdvcmsu
DQoNCj4gDQo+ICAgIEFuZHJldw0KLS0gDQpSb2JlcnQgSGFuY29jaw0KU2VuaW9yIEhhcmR3YXJl
IERlc2lnbmVyLCBDYWxpYW4gQWR2YW5jZWQgVGVjaG5vbG9naWVzDQp3d3cuY2FsaWFuLmNvbQ0K
