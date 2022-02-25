Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84304C51B1
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 23:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiBYWoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 17:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiBYWo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 17:44:29 -0500
X-Greylist: delayed 697 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Feb 2022 14:43:55 PST
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E516218CD5
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 14:43:55 -0800 (PST)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21PC21ku004787;
        Fri, 25 Feb 2022 17:32:05 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2058.outbound.protection.outlook.com [104.47.60.58])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ee8dxhap0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 17:32:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEtmVl+xcc8FDlQSJn4fvLXgi7CxNn9bNE/HEYSoZsc4FxHHMrKaem/wuuF09ZW32MmvBPDmy0lRjM4mJu5c/jTlkD9nv3NATi6jSLTuatdzIXTmnx1dqfk7461JhMZCQ/iHQsaP8YX2H5RjzgZrl+P4vnAKpEW3dUXPkXmrHP00WMrBxBNucr9PmwxF+z66DlNBhXT1iMN0b4QYnMzsOG48nRhZKHApVLYoXmy7IHHaMAXJCDMWTswgBGVSDwVIFFULX6METOHs9WujBY1knxscCZk+fNCtdoKpnPSyNfPw0OJTkh/dvfetS9HM9B/W4Vxbe+98RT9j5WdETIxBVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4sv31j9fnQOUZ1/Wk10AqfjGAVxvu7Jpe3kf/kkhVE=;
 b=nAfO3bxZ8alIq982RUiPqftBeka12UqgqtkuMztnTBPw05E4FksqQH4db/xjUkZKSaSXfztY0yKWaEg4ATD9PaR63difLEbWvoAvxw4DbaUZLwCfgI/GdKaWxsOultg+fHL37ftsh1BzsU7AENeILQPYLPZ9yVwKpvfAD6rl80bS+T/4tVas2GzyNOtp98YH8fD6/G7aSB04FYq4gFX9i3bcmrGM9S/yKWgO1gVK2ZIExIuPpvT7musVsPnl7+j9wrpAAkBB8kawjjZ7GY8zzREfZgalt/Sa/8lnmuZj9Q0Klhpeas7Qh9SlbQicWEXu2J7YqrIzvRIxaM04/NjHAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4sv31j9fnQOUZ1/Wk10AqfjGAVxvu7Jpe3kf/kkhVE=;
 b=iQm23GvAugKe6OLPc8ajp/Kadw2ETo24hzd0dtreiNGvznJoXr7Fw9QXBwdQGKxIXv4PnkUnS41bsF5bc9XS6uc7+r7Jpds73hc8hLs9wUJQz2tIkDn34oTn0QwCjbcuQwCmj9tXpkeoNH56ZMz1KRp4YnuEXl0Jv8RJnDzZ2dc=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB8729.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:c8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 22:32:03 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5017.022; Fri, 25 Feb 2022
 22:32:03 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RFC: possible Cadence GEM race condition in NAPI polling
Thread-Topic: RFC: possible Cadence GEM race condition in NAPI polling
Thread-Index: AQHYKpeCmKF9N5FVqUO2TJsa95J1og==
Date:   Fri, 25 Feb 2022 22:32:03 +0000
Message-ID: <7330510cf1d9be810f7c168b79ce0693d5839e6d.camel@calian.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81a47481-835f-457c-44fc-08d9f8aea55f
x-ms-traffictypediagnostic: YT1PR01MB8729:EE_
x-microsoft-antispam-prvs: <YT1PR01MB87291F1C69A0F7D5EC83D3B4EC3E9@YT1PR01MB8729.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cUjfOCs1HGxPuzbvR/hN1KX/EjxGAeV4z3Ba1rQEVyVi8l6EhJXWqlZrMRyRyRPKxwMjBye0eq3ncw3b8s6xJx05b4xp3StujUxcPE0E4h3MEQeLsAKGuWCkzYZkVLIibbuajg3Pr7gLSdf/StTK6OQfg387S1+nOqYpMi3g1BGpyR6uoHI6uuJU1r9EPt1DiAEZaQaQkLbonLI9zXNUIqVuQB12D3rPmPEn8YjNxwSLIJoQJ1nFq88DP7KEisMR70iAU4IPXP0YWXb5fLZHZICOX43PH9ZYAHbaHZKnvXCLUZPDagmqYUc4rjynlWb5RQhlJxhUdsy7EJ8D+kQAriyI8FDepaIqWH5UDAdQe3QICX8ShLXQO7sV/+9RF+ZAdgXcwqrz1YCjMnAeYnqmon13PRutwsZHybFUDIK3UGVZYTcFv8JauC1RtfT3fV324lDxgKEOpumcCeKN7URi9bJx7zYOa62RxgxYXQjCm1ogIlahOH1Eo0H6cd32S9aMDbwQiEZeOAqVjdL4vjMj2GVmI8FSTo7RXKK8FP+2fjOX131uVIpCpklW70xRwvhTvQq99Pf0jh7BAd/+jd2idyLZybxzHlFxOooqpy7f53dBsyxDbtnG4W7LzofYI5DpvaEmL9fF9xVFYdiSt1mschw6lhZE5tt/s/jnoGGp83WE0/w3w4l5wX57VC+TPHYkpLrI2Pw85oZM1a30TTzBelx18FB0tRGk06Yi3X5gh5KvFCkN2rRUKYvS4ZmXp6FDGaSWS5k0wYf22XRmXPVgGUv6E/nF4alRRB7Ny8ukTKwBcwtDWvK8Iuhuv7KlFhul9li5H9CGwcw/ttmtKdKm6OKnlqd82GbYdRuBapOWgM8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(6512007)(6486002)(6506007)(2906002)(122000001)(86362001)(508600001)(38100700002)(15974865002)(8936002)(71200400001)(44832011)(4326008)(5660300002)(54906003)(38070700005)(186003)(26005)(36756003)(2616005)(316002)(6916009)(76116006)(83380400001)(64756008)(66556008)(66476007)(66946007)(66446008)(91956017)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2hwK0FaVG52eXpjWTVQM3huMkM0S2RvZTdCVEhBU1EzVVJjNUJjQU9zZ2Zw?=
 =?utf-8?B?U0xBaVZMSkhFV2ZpcmZURiszMVo5SXZZcWlCZ1lDQUVEdVAvTzY4V3pXVnN6?=
 =?utf-8?B?SGhTMExnTWF3MTNNd0gyVHpHQkt6SXZNSk1QV1g2bldoWk4vQmFYTHE4a2d0?=
 =?utf-8?B?anphMFRUL1ppeVJuMzBZY25tVzJTN05QU1VWVUZqWlpIeHh3K1FPQ3BOM0xZ?=
 =?utf-8?B?OHk2NkpObnI0NHVCWEdJSmlIMTZDdmlKcVRBYWNQQkdIQ003d2J2L3l6Wkd2?=
 =?utf-8?B?N1dGM1BFU05LR3FyVk5LaDU1VE1PRHJubEFOamtGSUpMeXYwL1g5SUdFaXh1?=
 =?utf-8?B?amhNQitMR2ZDK09BdkVrdlVsT1BzNmhxVFJ0eWRPMTVVSVlsOENQMERUZXJH?=
 =?utf-8?B?ZW9NcXF6ODd3WUhLRzRJUW9vMy83M3lRaXFGeUYwWE4zNEhrR3F5cFhSclRw?=
 =?utf-8?B?SkZMenU0YmdyUUkxREJwR0tIZVMxU21ZV3p6QTRCTnRQU2JzcDZQaXluN1RG?=
 =?utf-8?B?cW1xVFptMUxNT3pWL3dvTUx1d2k4WGU0MnJFNnpoZlZhb2dUWUdOK29kTFgr?=
 =?utf-8?B?RDNvYXM1M0MvRWRUUGY0bzFsL3N6YjNiTHhtR09UbjBONXNqY1o3NmI5WCtP?=
 =?utf-8?B?YysvZDEvQmlaUkJkYWpxeTNDcHgzNEZpOXVRalc0Y1ovL2YxMWhjeFNkSXhT?=
 =?utf-8?B?RVRtNWtzaU5rZzRkbTIydUFNYTg3SVJKTm5TblROcjM5NkVYTmNKa2pCL2Nl?=
 =?utf-8?B?c1NNTVFoWEhhejFiTG1sOTJPU0dhRTRIWWIwNk1CWnV0WE9EM3dKd1dUSkM0?=
 =?utf-8?B?c0M0NG50SU93dnVwbm9ZNW9YZnpKOGYxWUJoVE11UERoTTVhdnpmSWVBMkFZ?=
 =?utf-8?B?NmhlSVpVc3AwRS85b00yRzZaZ0ZsTTBxeVhPd1B1eWZEWkRMOXdhUHNVTXE0?=
 =?utf-8?B?WVV4SThnQnNRN2FrdXFXbmgvcnk2b2liakp1WFd3bmZ3eHFuVW05ZGFScHlH?=
 =?utf-8?B?VytaM0FqTGZmNWRod21BOWs0MnFEK0JWRW1SMjlDc0xoalh5UDJkMHhtWmFJ?=
 =?utf-8?B?WkhyK29BcEJVeU40K2hFNVdZdXdqNko3VEVJK29GZW52aG1RVWlyNkd5aEhG?=
 =?utf-8?B?b1VnbjBTU0F0elFJNmFWcFROcklScUZIZmVGeThyTnR5VG54UTNRZ3dROXlX?=
 =?utf-8?B?UGxLYVl1dVBJRmRmK1Y0Y0tkY3ZjT0RWZHQxRVBCZUF0VHEwcmMyV0orTjUw?=
 =?utf-8?B?L1NkdE0zUFNwcExMRjQ3UFdESDBZSnhzV0RBMnc0dmg4b2s0V1R5TzVoTUE4?=
 =?utf-8?B?REwxNW80aXh0RVk2dm9LOWxBb3hhaVlxVFdhanB0TGZIZjFjajdTaUFqNThO?=
 =?utf-8?B?WkVack5wS2I5dUZTQWF2MmJNRGpPS3BPQlhVMUhndGxEcHV4c0RVMkFFcitX?=
 =?utf-8?B?R09rNVpDSmpjZWlLSitzK1FRelBMK3hmUDBKZTlyajFPL1lpVHMyYkhzZnZy?=
 =?utf-8?B?MTMzR3VNcTVnanAyZWFyMlJ4a3hDN05QQXN3MEFoVmRta1ZORVl1L2kyK3ZR?=
 =?utf-8?B?ckJ4dHFyaFhrYUljTDlST1BZZWZxaW1Kckd3TkkrYzY4ZEFWeWl5VHhoNklJ?=
 =?utf-8?B?SWhqT0pvUkVEbmdiUGsvS0NaZ3ZhZllOMFFYWWtlbWpYTDJoZ0dNR3Y3dmJn?=
 =?utf-8?B?RE15Ymo1MWZiZHBqSHNqVjBnbUpsZnBnYS9wbVNyV3lGUjVGN3hyTlM5WW9V?=
 =?utf-8?B?NVB4M1YybDArbjVxUlBOSGt0WlRDVC9nb3BOYVJzOVJyVWdjQ2xyTW03cy96?=
 =?utf-8?B?ZjNjQmpUc0VrM1puSllSd2RWZEhFdGQ5eEVQYnBpdXY4ekxHeWNsQzR1bjAx?=
 =?utf-8?B?c3pOVUNDWXZ5RTlON01XWEtZVkNVQ0gyTEhKcVh3OXVaNmM4ODJTZXhSd08r?=
 =?utf-8?B?clZRbldsVTFiODgra3ZNQXdLK3RBWVV4dzZLNUlIeU50U2d1LzY2T21RQUp4?=
 =?utf-8?B?aVRxckF6L3ZYQ0d2OXBlV3JoRTlsM2lmeU5BSSs0di9HWGZ3Qm9YTXpEd0dW?=
 =?utf-8?B?d3d1U3dtTnRhMlJZUkZVem4rYkxMaUdUaEhjb1FyNWF4a2YwS1BXd08yNWFo?=
 =?utf-8?B?STJQSjNVb2Y0QUhjSFR2SHAxbzljUHVVNWJkWm90d0V2cjdWQm1DaTFIV1l6?=
 =?utf-8?B?Y1dKRFhjRFAvc3U5NVd4RG1XU3d6d3pKNytVcTRrNEg0dVp3VnI4WXVwTUUy?=
 =?utf-8?Q?RXunfutyjLFPNZZwdu/15dwiJ3Ikzw6w8dsTYapD6o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28C1C87595C13445A36634ED48257202@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 81a47481-835f-457c-44fc-08d9f8aea55f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 22:32:03.1660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZWtcYgB7G728aD8LkIOh5Qo7Vg0FrjuujdWkORVg85FSERmXJ5RESosjdiKSf0LkA3BmUBGhlbWLjWlFinBYZNvq0XrBod12/mqDAHR5bY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8729
X-Proofpoint-GUID: kSDzHRiSKa7nyMjOUtS-amJcwWgryg-G
X-Proofpoint-ORIG-GUID: kSDzHRiSKa7nyMjOUtS-amJcwWgryg-G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_11,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 clxscore=1011 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=439 impostorscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250123
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWxsLA0KDQpXZSd2ZSBiZWVuIGRlYnVnZ2luZyBhbiBpc3N1ZSB3ZSd2ZSBiZWVuIHNlZWlu
ZyBvbiB0aGUgWGlsaW54IE1QU29DIHBsYXRmb3JtDQp3aXRoIHRoZSBHRU0gRXRoZXJuZXQgY29y
ZS4gVGhlIHByb2JsZW0gd2UncmUgc2VlaW5nIGlzIHRoYXQgaW4gcmFyZSBjYXNlcywNCnJlY2Vp
dmUgcGFja2V0IHByb2Nlc3NpbmcgaXMgZGVsYXllZCAtIGxpa2VseSB1bnRpbCBzb21lIG90aGVy
IHBhY2tldCBzaG93cyB1cA0KYW5kIGNhdXNlcyB0aGF0IHBhY2tldCB0byBhY3R1YWxseSBnZXQg
cHJvY2Vzc2VkLiBUaGlzIGhhcyBjYXVzZWQgdGltZW91dHMgdG8NCm9jY3VyIGluIGEgcG9pbnQt
dG8tcG9pbnQsIFVEUC1iYXNlZCByZXF1ZXN0L3Jlc3BvbnNlIHByb3RvY29sIHdoZXJlIHRoZXJl
IGFyZQ0Kbm8gYXV0b21hdGljIHJldHJhbnNtaXNzaW9ucy4NCg0KT25lIHN1c3BlY3QgZm9yIHRo
aXMgc29ydCBvZiB0aGluZyBpcyB0aGUgInJvdHRpbmcgcGFja2V0IiBwcm9ibGVtIHdoZXJlIGFu
IFJYDQpwYWNrZXQgbm90aWZpY2F0aW9uIGlzIGxvc3QgZHVyaW5nIHRoZSB0cmFuc2l0aW9uIGZy
b20gTkFQSSBwb2xsLWJhc2VkDQpwcm9jZXNzaW5nIHRvIHJlLWVuYWJsaW5nIGludGVycnVwdHMu
IExvb2tpbmcgYXQgdGhlIGNvZGUgaW4gbWFjYl9wb2xsIGluDQpkcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jOg0KDQoJc3RhdHVzID0gbWFjYl9yZWFkbChicCwgUlNSKTsN
CgltYWNiX3dyaXRlbChicCwgUlNSLCBzdGF0dXMpOw0KDQoJbmV0ZGV2X3ZkYmcoYnAtPmRldiwg
InBvbGw6IHN0YXR1cyA9ICUwOGx4LCBidWRnZXQgPSAlZFxuIiwNCgkJICAgICh1bnNpZ25lZCBs
b25nKXN0YXR1cywgYnVkZ2V0KTsNCg0KCXdvcmtfZG9uZSA9IGJwLT5tYWNiZ2VtX29wcy5tb2df
cngocXVldWUsIG5hcGksIGJ1ZGdldCk7DQoJaWYgKHdvcmtfZG9uZSA8IGJ1ZGdldCkgew0KCQlu
YXBpX2NvbXBsZXRlX2RvbmUobmFwaSwgd29ya19kb25lKTsNCg0KCQkvKiBQYWNrZXRzIHJlY2Vp
dmVkIHdoaWxlIGludGVycnVwdHMgd2VyZSBkaXNhYmxlZCAqLw0KCQlzdGF0dXMgPSBtYWNiX3Jl
YWRsKGJwLCBSU1IpOw0KCQlpZiAoc3RhdHVzKSB7DQoJCQlpZiAoYnAtPmNhcHMgJiBNQUNCX0NB
UFNfSVNSX0NMRUFSX09OX1dSSVRFKQ0KCQkJCXF1ZXVlX3dyaXRlbChxdWV1ZSwgSVNSLCBNQUNC
X0JJVChSQ09NUCkpOw0KCQkJbmFwaV9yZXNjaGVkdWxlKG5hcGkpOw0KCQl9IGVsc2Ugew0KCQkJ
cXVldWVfd3JpdGVsKHF1ZXVlLCBJRVIsIGJwLT5yeF9pbnRyX21hc2spOw0KCQl9DQoJfQ0KDQpU
aGUgY2hlY2sgb2YgUlNSIGFmdGVyIG5hcGlfY29tcGxldGVfZG9uZSBpcyBhcHBhcmVudGx5IHJl
cXVpcmVkIGJlY2F1c2UgYml0cw0KYmVpbmcgc2V0IGluIFJTUiB3aGlsZSB0aGUgY29ycmVzcG9u
ZGluZyBpbnRlcnJ1cHQgaXMgZGlzYWJsZWQgZG9uJ3QgY2F1c2UgdGhlDQppbnRlcnJ1cHQgdG8g
Z2V0IGFzc2VydGVkIHdoZW4gdGhlIGludGVycnVwdCBnZXRzIHJlLWVuYWJsZWQgKGkuZS4gdGhl
DQpwcm9wYWdhdGlvbiBvZiBSU1IgdG8gSVNSIGlzIGVkZ2UtdHJpZ2dlcmVkLCBub3QgbGV2ZWwt
dHJpZ2dlcmVkKS4gSG93ZXZlciwgaXQNCmFwcGVhcnMgdGhlcmUgbWF5IGFsc28gYmUgYSByYWNl
IHdpbmRvdyBiZXR3ZWVuIHJlYWRpbmcgUlNSIGFuZCBlbmFibGluZw0KaW50ZXJydXB0cy4gSWYg
YSBwYWNrZXQgaXMgcmVjZWl2ZWQgYmV0d2VlbiBhIHJlYWQgb2YgUlNSIHdoaWNoIHJldHVybnMg
MCBhbmQNCnRoZSB3cml0ZSB0byBJRVIgdG8gZW5hYmxlIHRoZSBpbnRlcnJ1cHQsIHRoZSBzYW1l
IHByb2JsZW0gY2FuIG9jY3VyIHdoZXJlIFJTUg0KaXMgc2V0IHByaW9yIHRvIGVuYWJsaW5nIHRo
ZSBpbnRlcnJ1cHQgaW4gSUVSLCBjYXVzaW5nIG5vIGludGVycnVwdCB0byBiZQ0KcmFpc2VkLg0K
DQpTb21ld2hhdCBjdXJpb3VzbHksIGluc3RlYWQgb2Ygc3RhbGxpbmcgYWxsIFJYIHRyYWZmaWMg
ZnJvbSB0aGVuIG9uLCBhcyBvbmUNCm1pZ2h0IGV4cGVjdCwgaXQgc2VlbXMgYW5vdGhlciBzdWJz
ZXF1ZW50IHBhY2tldCBhcnJpdmFsIG11c3QgY2F1c2UgYW4NCmludGVycnVwdCB0byBiZSByYWlz
ZWQgZXZlbiB0aG91Z2ggdGhlIFJDT01QIGJpdCBpbiBSU1Igd2FzIGFscmVhZHkgMS4gVGhpcyB1
bi0NCnN0YWxscyB0aGUgcmVjZWl2ZSBwcm9jZXNzIGFuZCBjYXVzZXMgdGhlIHByZXZpb3VzbHkg
aWdub3JlZCBwYWNrZXQocykgdG8gYmUNCnByb2Nlc3NlZC4gVGhpcyBhbHNvIHNlZW1zIHRvIGhh
dmUgbWFkZSB0aGUgYnVnIHN1YnRsZSBlbm91Z2ggdGhhdCBpdCBoYXMgZ29uZQ0KdW5ub3RpY2Vk
IHRodXMgZmFyLg0KDQpUaGUgZm9sbG93aW5nIHBhdGNoIHNlZW1zIHRvIHJlc29sdmUgdGhlIGlz
c3VlOg0KDQogCXdvcmtfZG9uZSA9IGJwLT5tYWNiZ2VtX29wcy5tb2dfcngocXVldWUsIG5hcGks
IGJ1ZGdldCk7DQogCWlmICh3b3JrX2RvbmUgPCBidWRnZXQpIHsNCisJCXF1ZXVlX3dyaXRlbChx
dWV1ZSwgSUVSLCBicC0+cnhfaW50cl9tYXNrKTsNCiAJCW5hcGlfY29tcGxldGVfZG9uZShuYXBp
LCB3b3JrX2RvbmUpOw0KIA0KIAkJLyogUGFja2V0cyByZWNlaXZlZCB3aGlsZSBpbnRlcnJ1cHRz
IHdlcmUgZGlzYWJsZWQgKi8NCiAJCXN0YXR1cyA9IG1hY2JfcmVhZGwoYnAsIFJTUik7DQogCQlp
ZiAoc3RhdHVzKSB7DQorCQkJcXVldWVfd3JpdGVsKHF1ZXVlLCBJRFIsIGJwLT5yeF9pbnRyX21h
c2spOw0KIAkJCWlmIChicC0+Y2FwcyAmIE1BQ0JfQ0FQU19JU1JfQ0xFQVJfT05fV1JJVEUpDQog
CQkJCXF1ZXVlX3dyaXRlbChxdWV1ZSwgSVNSLCBNQUNCX0JJVChSQ09NUCkpOw0KIAkJCW5hcGlf
cmVzY2hlZHVsZShuYXBpKTsNCi0JCX0gZWxzZSB7DQotCQkJcXVldWVfd3JpdGVsKHF1ZXVlLCBJ
RVIsIGJwLT5yeF9pbnRyX21hc2spOw0KIAkJfQ0KDQpIb3dldmVyLCB0aGUgZG93bnNpZGUgaXMg
aXQgYWx3YXlzIHJlLWVuYWJsZXMgaW50ZXJydXB0cyBldmVuIHdoZW4gaXQgZW5kcyB1cA0KZGlz
YWJsaW5nIHRoZW0gYWdhaW4gc29vbiBhZnRlcndhcmRzLiBBbm90aGVyIHBvc3NpYmlsaXR5IGlz
IGEgImRvdWJsZS1jaGVjayINCmFwcHJvYWNoIGxpa2UgdGhpczoNCg0KCQkvKiBQYWNrZXRzIHJl
Y2VpdmVkIHdoaWxlIGludGVycnVwdHMgd2VyZSBkaXNhYmxlZCAqLw0KCQlzdGF0dXMgPSBtYWNi
X3JlYWRsKGJwLCBSU1IpOw0KCQlpZiAoc3RhdHVzKSB7DQoJCQlpZiAoYnAtPmNhcHMgJiBNQUNC
X0NBUFNfSVNSX0NMRUFSX09OX1dSSVRFKQ0KCQkJCXF1ZXVlX3dyaXRlbChxdWV1ZSwgSVNSLCBN
QUNCX0JJVChSQ09NUCkpOw0KCQkJbmFwaV9yZXNjaGVkdWxlKG5hcGkpOw0KICAgICAgICAgICAg
ICAgIH0gZWxzZSB7DQogICAgICAgICAgICAgICAgICAgICAgICBxdWV1ZV93cml0ZWwocXVldWUs
IElFUiwgYnAtPnJ4X2ludHJfbWFzayk7DQorICAgICAgICAgICAgICAgICAgICAgICBzdGF0dXMg
PSBtYWNiX3JlYWRsKGJwLCBSU1IpOw0KKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKHN0YXR1
cykgew0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBxdWV1ZV93cml0ZWwocXVldWUs
IElEUiwgYnAtPnJ4X2ludHJfbWFzayk7DQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGlmIChicC0+Y2FwcyAmIE1BQ0JfQ0FQU19JU1JfQ0xFQVJfT05fV1JJVEUpDQorICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcXVldWVfd3JpdGVsKHF1ZXVlLCBJU1IsDQpN
QUNCX0JJVChSQ09NUCkpOw0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBuYXBpX3Nj
aGVkdWxlKG5hcGkpOw0KKyAgICAgICAgICAgICAgICAgICAgICAgfQ0KICAgICAgICAgICAgICAg
IH0NCg0KVGhhdCB3YXkgdGhlIGVuYWJsZS9kaXNhYmxlIG9ubHkgb2NjdXJzIGluIHRoZSBjYXNl
cyB3aGVyZSB0aGUgcmFjZSBpcw0KdHJpZ2dlcmVkIGFuZCBub3QgZXZlcnkgdGltZSwgYnV0IGlz
IG1vcmUgY29tcGxleC4gVGhpcyBzZWNvbmQgYXBwcm9hY2ggaGFzbid0DQpiZWVuIGV4dGVuc2l2
ZWx5IHRlc3RlZCB5ZXQsIGJ1dCBpdCBzZWVtcyBsaWtlIGl0IHNob3VsZCBhbHNvIHdvcmsuDQoN
CkJvdGggYXBwcm9hY2hlcyBjYW4gcG90ZW50aWFsbHkgaGF2ZSBhIHJhY2Ugd2l0aCB0aGUgaW50
ZXJydXB0IGhhbmRsZXIgKGkuZS4gaWYNCmFuIGludGVycnVwdCBpcyByYWlzZWQgZHVlIHRvIGEg
bmV3IHBhY2tldCByaWdodCBhZnRlciBJRVIgaXMgd3JpdHRlbiB0byBlbmFibGUNCmludGVycnVw
dHMgYWdhaW4sIGJvdGggdGhlIElTUiBhbmQgdGhpcyBjb2RlIGNhbiBlbmQgdXAgZG9pbmcgdGhl
IHNhbWUgdGhpbmcpLg0KSG93ZXZlciwgYXMgZmFyIGFzIEkgY2FuIHRlbGwgdGhhdCBzZWVtcyBo
YXJtbGVzcy4NCg0KTG9va2luZyBmb3Igc29tZSB0aG91Z2h0cyBvbiB3aGljaCBhcHByb2FjaCB3
b3VsZCBiZSBiZXR0ZXIgaW4gdGhpcyBjYXNlPyBPcg0Kc29tZXRoaW5nIGVsc2Ugd2UgaGF2ZW4n
dCB0aG91Z2h0IG9mPw0KDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVz
aWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4uY29tDQo=
