Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CBA4E2FB3
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352024AbiCUSN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349502AbiCUSN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:13:57 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFC21717B7;
        Mon, 21 Mar 2022 11:12:31 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22LCIF4q017783;
        Mon, 21 Mar 2022 14:12:20 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2052.outbound.protection.outlook.com [104.47.60.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ewc33gv3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 14:12:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZ77//91UNPYhJNmfchpjDDyYzKkRYq50AeUYCQ1JP7SIOkbTuIK6bsU5YctyChvnhdTiEaLR84ddVcMDN3Ym60ARKUVRgoTOLa7RmNyxTLYNKCcrCZP3+AU/c8rq8q1J/htPpMYttBJa99ApxZxxPul2/5/ixMSammLZ33JrHdk+WYdsHw0q+/Og22YVH0sGnVWpaYFT32V1l2Agp25kDGwMjKGpQxL84vkBzqGaX6TxETBmzcPE8oeZQ0J/fjvog8jpB8Gq23zKetKru9QRS/KUCHoElyvSPxhoyCtt4Bo2XzNACAJX8USC3NuYNHBRChI5lzf6urCMGI7aXMK3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pHGC6adcbDMptgtd5a/NA0DYJeGSpSjFF542dFBKlFw=;
 b=Buaw66SC+MLRxjxku1fnC9aNMtmrDxo7KSrA0SwGqB4Z+mNwEZkW7wWtTLMXGPkkR8/e2/7s8p3l/e2Fn5RpKNhwbiD4EEE7pQmDKoyRcTFaf5je9f8lJurNuLBWsDYoLTXV34xyg5sBWv5CQKWUulMJ1QZFjlmV1EpDWMxxGg/7mhNoXfYuy95ybECfNudeqiM6CnI0D8xmBXjxGsYwmy3+00VhRtl+BMd9xhitkVxyWshqB4Mbjf0kgho2SnazFa1FyHtgBFmxCS0AO54UOrHobUHpkLUt9lCvG/qLpZ/s9eqNuxZkymVcL3vuOPOw0ChJGe7pcR1JW3yiSZ3PNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pHGC6adcbDMptgtd5a/NA0DYJeGSpSjFF542dFBKlFw=;
 b=YuwAwkGHYJaEwrNpbXLXTd5IH75crZp1AaUCeM8P0dlHW5Xgowklja+vmwiwLaRB+PY0kabCUTWcjsaLWlj/xrE9nZZ2ZDx3mudXXAV3Wsg3DDCrTBcSHJ8fLDPFaMxvmYgaHcbfe5Z1Vej/9ano2UZfoiGa94mURPk7lNEHLq8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB3958.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:4e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Mon, 21 Mar
 2022 18:12:18 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 18:12:18 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "andy.chiu@sifive.com" <andy.chiu@sifive.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v4 4/4] net: axiemac: use a phandle to reference pcs_phy
Thread-Topic: [PATCH v4 4/4] net: axiemac: use a phandle to reference pcs_phy
Thread-Index: AQHYPThSbd/ycTgAsUemBMCVYXitu6zKI/SA
Date:   Mon, 21 Mar 2022 18:12:18 +0000
Message-ID: <2ca86ca17ba694bf514cd66a68ff63e751caad7b.camel@calian.com>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
         <20220321152515.287119-4-andy.chiu@sifive.com>
In-Reply-To: <20220321152515.287119-4-andy.chiu@sifive.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ec512a6-209f-43d3-002d-08da0b665605
x-ms-traffictypediagnostic: YQXPR01MB3958:EE_
x-microsoft-antispam-prvs: <YQXPR01MB395851747686FFB9F5B312ACEC169@YQXPR01MB3958.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WCylwfP34snY/fH2EsKqLP03dXjc3WZIcnNUFweMb9auWBmNP1Shh9OVOQ7/yyXdGWg5a0VrnNY4a1umo2EpFMF0YppAJW9EiNsdg5PMpyHZYKhWUoLeB31iTAhHD0nQFUZLaWuLH2UatBRNC7ML1AaZARsbJCUzS/rTKfk8cxJNm0srjKvwqVt/Vm0ymh/ibLBoP6u1PQ0jP5wMCBiNCPXmM+8ULoCGxsQVxZTEcfw1y16Dar1HZWKa+VVf4j0UdbevR5dBMgndIAjl3pyzxP7Q9KnFLTW1oiGi+7xVWSoEnf7mWRAV+pkX16ccSboKSLeXGpGCuNDQbCs10s9GI1/VskYXIxlCzKAPqmnX4ehmMt/3tXuWoH//wnLoqjnGgyhFfW24fhgpb/D0ulCCZ4kfDjQh1JQp0Crihuc52IulwWlB9urlRf71zYbMYnnAoaN9u9RcOoM6K+EaPXuntk3ewJ/Wp/iq9LfqlKV4fcvjnvJjfcft/u0Dbx1yEokjYEq2b8Scaw0DUx59zbKJvclsIAOEzeXhFNS+VOwfB48xDgPrLbr57Pp4pdCPjHz/twQFLA5o4edBvZYVoaOxQpqqV9nnS8ug6SKAFjN7PuNBNA/MXf1k2mnUmTsbYePG6McEZpQ2mRg9dCY1CyxnVl/zl0hO2b3l4qt5kNaXVdhcO2Ez1uBJtY950SSwcUvxX2EYQRnSkpgohZ9lI/Hqu3tldSX1Jx0fGysXV4ZDT/wMl1vPcsafO/8SZZx46t+AaoyZvN8GmPCs9/RrjcxjHTfnOXoC7fFrBxqVYguXYqdVQikiTXVuRYcu1lgWuW57NSXyEvlM25ALm8/YAoMjVRXLRag0UqH7ck9r5dweE2Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6512007)(66946007)(66556008)(76116006)(36756003)(66476007)(6486002)(8676002)(4326008)(508600001)(83380400001)(71200400001)(26005)(186003)(91956017)(38100700002)(8936002)(64756008)(15974865002)(110136005)(54906003)(316002)(7416002)(86362001)(5660300002)(44832011)(38070700005)(66446008)(2616005)(122000001)(2906002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2thQS9FK0QrUWhzRUFrdjRjZDZpMjhXd3dvV0R4MXg0YVNUQ2IzemptSHYr?=
 =?utf-8?B?Ymx3VFF0S1dYcUQ3MFNoU2duUkZxeFlxK3hCalhIVk9mN2pEeTVpL0liZDUy?=
 =?utf-8?B?RUQxQVhsSGJySWsvS0djMWJrTFlyL3BRVlFJdElvRElMRzhaSElTNUJoR2Qw?=
 =?utf-8?B?bGZCMGgreW44c3kxS3JDbEswKzhsNTdEaHBOd2l4dzVJQ0NWYk5aWnhjUG93?=
 =?utf-8?B?M2d6T0pEZW4vOUI4cDV2dy81UWx0SWRFMUIvbjBIcTN4Nmh0VEhJWEZMVnFy?=
 =?utf-8?B?c04vellzQXZTV0tJV1RuZERnN2d5NkVmM05BL3ZYZFd6bnNxRVFIdk9SMGZz?=
 =?utf-8?B?ZndKSXIyYWcvSHFFYlJYMWlxYkovcEswMDhZa0VRenF1bk9Rd2doUjFOYmND?=
 =?utf-8?B?VkpSeUEraXBnK2lKUWF3c3FKUW83YkQ4emV1b3ArdGFvczVnNnFrTHdmMnBl?=
 =?utf-8?B?UFBXSHA0cFJrQlF6eEo5ZmdzOVhRU1RoeThzVXMzbkYvbW5LQlQvcEZVd2d4?=
 =?utf-8?B?Ly9EQTliY0N6azJwYmlNUVlQdjNVMWFtQUZnZnlNU2NGeXEvL00waUN4Q0FD?=
 =?utf-8?B?S2tPT1pRNVhoYzBOazZ0a29Qb0R1dnlOek5icnJmeXU0MlVaR05qUjFOUm4x?=
 =?utf-8?B?REQ0YUZGLzBVYkFhenhlZk9uZ2hFNEtMM0JxTC8xRzBpOHNndjJDNnVmWDgw?=
 =?utf-8?B?MUFRdUtLTlhoNFlmQUcxdExGZU1XcGRsbVg5SS95NVliRkREUHRBRFJUWTd0?=
 =?utf-8?B?a0FDbm0vcGVFeVNnb0JMT3BuRWcwZ2VxckorZ1BxUjJEU0MwOWltTE0wWmdr?=
 =?utf-8?B?YnI4OEZJUUhzSU1DUzBwanJkN3NnR3lDQzloQm1jdVg5eHRSc1YybzQzQnBD?=
 =?utf-8?B?L01VQkJRcW1wdkkrODRzcFN5cjhJbnVBZ3pxMlBkcUdqK3lYWXFRY1UxNkdI?=
 =?utf-8?B?M1gxcWxHR3hEK2c0YkgzUVBFVGExaXBieXBpYkxGR2lGUDA1aU5rWnBKTncv?=
 =?utf-8?B?QW81STlFTFNSdXZ0WW50S3ZtdDFtOUJwUVZlTWJtMzBYNkZRdmRoc0RUejFv?=
 =?utf-8?B?bUhsNlIrKzVtRVhHSy9DZzBpdzZKZDVRQzM1Y1RLcyt2OHFxT1ZGQ243bWhr?=
 =?utf-8?B?QWhORjJZdmpscHlUczJxU3Bha0JJQnRWTGpOUmk3UXNyVmR4bGZkOU5NU200?=
 =?utf-8?B?Zmw3MXZRd2dkeDhpRXpDRU9JRm9DVXdQTmx5MlhiOXUxbVpEUllxSm9XRVdP?=
 =?utf-8?B?UTFiVmxnK0F6ZlkxcHhCTkR2RldzV2EvOUhqUWpvZjAyUU9GUk4wYmt5Z3Bz?=
 =?utf-8?B?NnlrYytvMUVXNGlNczNydDVtcUdZSFJsK2gyNlhNNzVBa25QOXNBTnRTd0lh?=
 =?utf-8?B?d1g5cmRjZjU2ZERvSjBscGptWlJENmJxcXAzZVBvdkFvR1dsTWZ1YXcrZmF4?=
 =?utf-8?B?WnNqTEsxdTJTTDd2dzdFbm00TUdrWms5SFBQZW9WcXhJVVIrNDRPSm5KeEdJ?=
 =?utf-8?B?YzlJbWZaWC9FY21SRXRNTW5iSGNiM2lka0tJdzBQMUNxWDIzQmIybTVSeTFK?=
 =?utf-8?B?cHh1SStnMFNldFk1N2NhNklSM1dXQ1U0YnJENmZtSk5ha1VkaE4waHdlbW00?=
 =?utf-8?B?bHRJSXo2dkp4YkJrdUNDSkk3bWk0ZlVmbUdBZ0lTQnRUKzVZMDVRT09FcUkw?=
 =?utf-8?B?bFdqejkzWktDWWVOMkttaXRnRDFUUm9CVDdCZDl3RnlWWW94S2JTYWJLMU45?=
 =?utf-8?B?c0xHZGwwRTM4UGR6L0hCUGxFcHRHZ2hYNkxJSy9IVWJyRUMraXFRSzNXbGJS?=
 =?utf-8?B?Z0xaUi9qK2dBNDEwRWlTcmpWb28zeW9GRnNQK2NYZzdHb001MHdUMVJuRWxM?=
 =?utf-8?B?amI3NU5TdmtMK3VDVzBJcnJ5WTF4cUk4Yzk3bkVWcHN2d0lMZkNYM05hMDMx?=
 =?utf-8?B?ZHNlNng3eHk3UkRvcCs3M0FrNU14dWloMG5uOFN3bUN1YU54VGZiOHUwWmlL?=
 =?utf-8?Q?kQKX66GLTblH85lPsb1BCPcWzMlFbk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3849E3FFEDE933429650C95BE06972BE@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec512a6-209f-43d3-002d-08da0b665605
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2022 18:12:18.3147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2jG1tfbzK+Zd/dzWwqxoEld6MGKvp1ISUO1q5ySVj4bJw/bm6w6yc68H3VaKVdhKSIayIXpHm9g6gozqvwbvz/R31KNtwCCfA1Nh+WeOr4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB3958
X-Proofpoint-ORIG-GUID: XRQYTf-1yqq1-BFR9MuXoKyLjb8lXNbv
X-Proofpoint-GUID: XRQYTf-1yqq1-BFR9MuXoKyLjb8lXNbv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_07,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=900 suspectscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210116
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTAzLTIxIGF0IDIzOjI1ICswODAwLCBBbmR5IENoaXUgd3JvdGU6DQo+IElu
IHNvbWUgU0dNSUkgdXNlIGNhc2VzIHdoZXJlIGJvdGggYSBmaXhlZCBsaW5rIGV4dGVybmFsIFBI
WSBhbmQgdGhlDQo+IGludGVybmFsIFBDUy9QTUEgUEhZIG5lZWQgdG8gYmUgY29uZmlndXJlZCwg
d2Ugc2hvdWxkIGV4cGxpY2l0bHkgdXNlIGENCj4gcGhhbmRsZSAicGNzLXBoeSIgdG8gZ2V0IHRo
ZSByZWZlcmVuY2UgdG8gdGhlIFBDUy9QTUEgUEhZLiBPdGhlcndpc2UsIHRoZQ0KPiBkcml2ZXIg
d291bGQgdXNlICJwaHktaGFuZGxlIiBpbiB0aGUgRFQgYXMgdGhlIHJlZmVyZW5jZSB0byBib3Ro
IHRoZQ0KPiBleHRlcm5hbCBhbmQgdGhlIGludGVybmFsIFBDUy9QTUEgUEhZLg0KPiANCj4gSW4g
b3RoZXIgY2FzZXMgd2hlcmUgdGhlIGNvcmUgaXMgY29ubmVjdGVkIHRvIGEgU0ZQIGNhZ2UsIHdl
IGNvdWxkIHN0aWxsDQo+IHBvaW50IHBoeS1oYW5kbGUgdG8gdGhlIGludGVuYWwgUENTL1BNQSBQ
SFksIGFuZCBsZXQgdGhlIGRyaXZlciBjb25uZWN0DQo+IHRvIHRoZSBTRlAgbW9kdWxlLCBpZiBl
eGlzdCwgdmlhIHBoeWxpbmsuDQo+IA0KPiBGaXhlczogMWEwMjU1NjA4NmZjIChuZXQ6IGF4aWVu
ZXQ6IFByb3Blcmx5IGhhbmRsZSBQQ1MvUE1BIFBIWSBmb3IgMTAwMEJhc2VYDQo+IG1vZGUpDQo+
IFNpZ25lZC1vZmYtYnk6IEFuZHkgQ2hpdSA8YW5keS5jaGl1QHNpZml2ZS5jb20+DQo+IFJldmll
d2VkLWJ5OiBHcmVlbnRpbWUgSHUgPGdyZWVudGltZS5odUBzaWZpdmUuY29tPg0KPiAtLS0NCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMgfCAxMSAr
KysrKysrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlv
bnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGls
aW54X2F4aWVuZXRfbWFpbi5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlu
eF9heGllbmV0X21haW4uYw0KPiBpbmRleCA0OTZhOTIyN2U3NjAuLjE2Mzc1MzUwODQ2NCAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21h
aW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRf
bWFpbi5jDQo+IEBAIC0yMDcxLDkgKzIwNzEsMTYgQEAgc3RhdGljIGludCBheGllbmV0X3Byb2Jl
KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICANCj4gIAlpZiAobHAtPnBoeV9tb2Rl
ID09IFBIWV9JTlRFUkZBQ0VfTU9ERV9TR01JSSB8fA0KPiAgCSAgICBscC0+cGh5X21vZGUgPT0g
UEhZX0lOVEVSRkFDRV9NT0RFXzEwMDBCQVNFWCkgew0KPiAtCQlucCA9IG9mX3BhcnNlX3BoYW5k
bGUocGRldi0+ZGV2Lm9mX25vZGUsICJwaHktaGFuZGxlIiwgMCk7DQo+ICsJCW5wID0gb2ZfcGFy
c2VfcGhhbmRsZShwZGV2LT5kZXYub2Zfbm9kZSwgInBjcy1oYW5kbGUiLCAwKTsNCj4gIAkJaWYg
KCFucCkgew0KPiAtCQkJZGV2X2VycigmcGRldi0+ZGV2LCAicGh5LWhhbmRsZSByZXF1aXJlZCBm
b3INCj4gMTAwMEJhc2VYL1NHTUlJXG4iKTsNCj4gKwkJCS8qIERlcHJlY2F0ZWQ6IEFsd2F5cyB1
c2UgInBjcy1oYW5kbGUiIGZvciBwY3NfcGh5Lg0KPiArCQkJICogRmFsbGluZyBiYWNrIHRvICJw
aHktaGFuZGxlIiBoZXJlIGlzIG9ubHkgZm9yDQo+ICsJCQkgKiBiYWNrd2FyZCBjb21wYXRpYmls
aXR5IHdpdGggb2xkIGRldmljZSB0cmVlcy4NCj4gKwkJCSAqLw0KPiArCQkJbnAgPSBvZl9wYXJz
ZV9waGFuZGxlKHBkZXYtPmRldi5vZl9ub2RlLCAicGh5LWhhbmRsZSIsDQo+IDApOw0KPiArCQl9
DQo+ICsJCWlmICghbnApIHsNCj4gKwkJCWRldl9lcnIoJnBkZXYtPmRldiwgInBjcy1oYW5kbGUg
KHByZWZlcnJlZCkgb3IgcGh5LQ0KPiBoYW5kbGUgcmVxdWlyZWQgZm9yIDEwMDBCYXNlWC9TR01J
SVxuIik7DQo+ICAJCQlyZXQgPSAtRUlOVkFMOw0KPiAgCQkJZ290byBjbGVhbnVwX21kaW87DQo+
ICAJCX0NCg0KUmV2aWV3ZWQtYnk6IFJvYmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxp
YW4uY29tPg0KDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVzaWduZXIs
IENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4uY29tDQo=
