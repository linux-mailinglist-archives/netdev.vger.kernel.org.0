Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E674E56AF
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 17:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbiCWQoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 12:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239053AbiCWQoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 12:44:37 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67C7BA
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 09:43:04 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22NAmJKo017463;
        Wed, 23 Mar 2022 12:42:49 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2177.outbound.protection.outlook.com [104.47.75.177])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ewa9vk1q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 12:42:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3gs6L1KN5n6neNaiq6Hbwqblpp72tPi/HUq1y+2Ji0BTKpE9ek1Djepqz50p/goaVIzsiWBvRQnjF+pQmr2sLGV0V+IpYBQl3VeI2oSVob693FrsnhgH8FeDrseVhPJFq0O8v/fK5slTdZyCN8gPEf549MO1p5x1ToUbsCjooRz2BnzGeVjxfcfYf0t49yMz6G0R1kJ/3sOPbMQQlIbb4JDZyVJwABqUXXhxycDshhTWRy0Ppzdg9ZKYap1v+meeOQ9wDzCyjW+O1Tyn/c0r7aL58NkuHJoBHmYGa/hxs8Q198BL60oPCwTfs1+JDLGFu7IG/gyyJqTJYQT0tLz1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4J5NRtCRS/kIQMIJo4HKL8fHZHoYZCF8z0KDM/FPwzI=;
 b=TNhb9GF5SQtNclY7QC30vgaI62zQyG3MxlHV2LEUXVaCjcr87Zu1f9rRiATgGFRHBa9R1zDq84doCK6H+590SvF/rIje/5sSc5CR01wtsnqDBORszTJVs3oWZVvwdONMsa/AHCRlqLjVp8Y3RX30BRLWC6NN5TDKM1mMe56Hydafy1K0r/73QOi5F4b/wUd8oHXCjah0bFqYzEM91i/aMq2yYBSv+NP8O1NIWUgY81hDzl1+Tg8wBqirgpdQ22+vJRSN7NlCBYFc9Yy+tyZ+q/6gAFVzKAk6AioU5+yzcs+86SiLzGK+3uvjlgk4xtAXBm8d6sMAv9elYKLaWy8pgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4J5NRtCRS/kIQMIJo4HKL8fHZHoYZCF8z0KDM/FPwzI=;
 b=vLGhC+gkkqtC2mmHU9LqtibJfyMpW4hJbAKt7WOIsRRG4vSz0+VNLE6PI4soZxP1dtpxRUp5EG6iIfTehg6/xaR3Cjmw45y9ldlsyafBx1lt406kWfn9PqW3pFvdmObArCDHC0NBaRg8u++CIPpZY5Ys3EtOVb9eLPbk+wFfLfA=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB8270.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:51::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Wed, 23 Mar
 2022 16:42:47 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6106:5129:86c9:d3dc]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6106:5129:86c9:d3dc%2]) with mapi id 15.20.5102.016; Wed, 23 Mar 2022
 16:42:47 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "tomas.melin@vaisala.com" <tomas.melin@vaisala.com>
CC:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] net: macb: restart tx after tx used bit read
Thread-Topic: [PATCH v3] net: macb: restart tx after tx used bit read
Thread-Index: AQHYPszAkBu8xKiwVkelLx73dmNAJKzNLHIA
Date:   Wed, 23 Mar 2022 16:42:46 +0000
Message-ID: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
References: <1545040937-6583-1-git-send-email-claudiu.beznea@microchip.com>
         <20220323080820.137579-1-tomas.melin@vaisala.com>
         <20220323084324.37001694@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220323084324.37001694@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b024f03-6307-448c-fb8b-08da0cec293d
x-ms-traffictypediagnostic: YQBPR0101MB8270:EE_
x-microsoft-antispam-prvs: <YQBPR0101MB827055FDF1465936F3662CFDEC189@YQBPR0101MB8270.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E+JfznOsJ7XHeX2PL4+zQV1Lt5gePkJ8YH+SC4TyKDAbvVWJF7JBWg9dKP+uwjAbWIL2gYPYwhShKiWOs5LzpKXNNK5rAGETv7Hna8nkOkJJQczRgMRLvO/hQaUo0Mt1MJTVK9idlo/i5qznk5lSIqAtYHelgapRMOugX7HYNd16v8UjJxLeAj6pZAuMI0WvAx1Nv9h6A3orpArvEv4mZokz0H/r4IHhy6vUU61bVQYqd6FXR9U4zNU0suYMkTRWF6MinD6W0m5Rkt2KxKggIpY42Qsa8hsaY7WHk0byGHT380t3MpozKFXJ7lZBCcjufchTvKDxuf+lXz+Dohs8+h5tlB4yiHFMhQDO0F5CSzgxJrxNhqYwptdCozGLs0oJfyP6eGXMQg5FMjIuBLU0cUCGkxcbhh9wO6i4Em5JaSufAZhMcERZILnUHuxcwJYrZ2SMsFWSszsjBjweeFG73soCEx64yb8JwreNHHHaZinNdrQ8+SExZ/WwmOw3sqAS9lfmco9FperzEdI1aWsfsvqoRT3LKNktArX8jvqqjDgZc2m4u23zmjPmc+aUxlOu4xi7sV8JOc1yOqYwsGiHhs4vsJ9EOVSsJknSYokk+oxTy7kIJdCb2Sr46eiNyrqzFTEdVUuWGllGeIZ3KPqR40NHkUUzSXZyCnFsY0MlmOkqpL2o62CGEJLsDPPIyLDih4fDltWPkOvPJUjGpAxs1K9Gt40kkKaUocQqw3mcjBbuRj0eP9HJwXdL8PWT7tZhSYSZqTqsyAfdPN79g3AwnxtI8NCQiylqo+wIvSlU6aLc4OSVd9/bY3NiXUdLWX6U3ioWi9b+3zBkk/FbN4JwzJ9ya9VUBu00kLQgYFMLAI4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(38070700005)(54906003)(6512007)(6486002)(508600001)(186003)(26005)(15974865002)(8936002)(36756003)(44832011)(5660300002)(66476007)(66446008)(76116006)(38100700002)(110136005)(122000001)(86362001)(71200400001)(64756008)(8676002)(4326008)(91956017)(66556008)(2616005)(6506007)(83380400001)(66946007)(316002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnNYUFBjdUpYMzhpRExSaXdSby9Pd0Jlb1pvODR6WTF4a1pXd3YwR3RFSndu?=
 =?utf-8?B?RmlpVkVuMW96dG9HZC9DSkVXd2M4S3IrZ2FhaFUyN0hUQk93N3g5OXVBdFNn?=
 =?utf-8?B?cFNpRFJUTHBOWGRaTU9qRVNoRGtPRXRqUFJDNlA5emlIY1lVR1FKT2dmZVlQ?=
 =?utf-8?B?TmFZbzhXK1pxdXBPRWlRMjlHenRhNTFzU0pmODZTVHZzS2dwUHBTVi9GcUFJ?=
 =?utf-8?B?c3NBT3NUN2h0Y0FrOE5Ic29hSHdLZE5jWGdRQ0xxOGU4dU5OVVdFMkdSaytM?=
 =?utf-8?B?K1VUZW9ZU0d4OU8ySWltM3JCeGlvc2NDU1pFbEpQMkNKTk5WcVY5ejEvajhw?=
 =?utf-8?B?K2FPKzF4VGZSZTZ2QWgzYU1FSWFvSjc0Zkd0NU9aRDY3Zk1qdUUzRnh5NG5Y?=
 =?utf-8?B?RmRUVjU4c3BEQzN2NGhuOUVVUWp1MEdSS2o0R2VuSWdIRmxSYm9hV1RPZzJM?=
 =?utf-8?B?NHQvbWdrMmwyMWF4emxPNU5WMi8xcWtUaE9vMkdmejJDVnRWZU1kczVrWUFD?=
 =?utf-8?B?dVhpeTdwT1RPVDRjSHJ0azhlVS9MMDdmTTdBR1VPUmFGbncxNnkxUG9XOHl1?=
 =?utf-8?B?UmUybWt4THkxNWZ1UzRvbjd3M2g2UGFhSVpBT2JxY1MzUnV5YUVmcUx6Y09n?=
 =?utf-8?B?RzNDRDJEL0lwRTVhR0FSZ2k1YjM5ZDdFR3U2NTFvcGpjZGpqZzdtZnVsQUg4?=
 =?utf-8?B?Yy94K09oN0s0YnV0RkplTVNubjQ1M21QbWNPYWZnUVBUZ0RJQ0NaRlNDWHBX?=
 =?utf-8?B?VTE2ZEV6NkZYUmV5SStYa09IMEZpY3kyNzNuZXRMZHRTQ2RhZVB3WHJPK0E3?=
 =?utf-8?B?SStMaGdKNS84MG5VQzZjU1RwYS9mRFQ5VVhwK0k4Um9wZXFIZHhaY2pmd1dt?=
 =?utf-8?B?eVhwQ2RWWTNCTzAyNHFzczdNQ3puNWxWaW1qVGhScTJxbEN3NHhsOU1vUzJB?=
 =?utf-8?B?aTQzdkY4a20wK0kyMzI3RDNzMDRiZStrYzY0TFZYZnduRXQ1Q3NHbTFjWlJs?=
 =?utf-8?B?bFdCOGQwcS8rcXJuRlhrdVIyV29zVXpOS0U5SjBpZEFlK3hpVU1vVmN0Wkha?=
 =?utf-8?B?Q2tzNGxMNUIxUHNTcy9uWk0rYk11U2pQTFFZek1WZSt3WW1PdDBuUGY5dnAr?=
 =?utf-8?B?ODVaNStvbFU0K3hoTU1CZEFaSDlsL0VCOEhRQVlVY3J1WlQ0VEk0ZVo4TUVT?=
 =?utf-8?B?RmhDQzJWNHhVenRVQUZYSXpnM2hYNWdrMmRTU21obW5OUldtTS9LNTdTUUxN?=
 =?utf-8?B?d01HM3Y0dTZiN0l0MHFvSWxOTHJ1MHhJYiswZWM5YW5XdERETS9ydFNIVU5h?=
 =?utf-8?B?bjlVQmJ5VmJaUEQwbVJvbC8yK0NrZTg5SU5FcjhmRmZwTHJVbXp0aXAvUHlM?=
 =?utf-8?B?V1poUEVud1k4ekEremFrWXdtMHgrbkFsYS9vZDhvZnpuMm5WNFZDVi9WanRx?=
 =?utf-8?B?eG82cndUd014cklhNWRqbUdtTDIrVkVuc3FucU51Ni9lTHZxaWRNZUVLa1Nq?=
 =?utf-8?B?Q1llOXR2UXh2cStkbzMvd3YrZCt6ZjVkdDU2YmxSUEQrcUYyOVJmTTYzSWsr?=
 =?utf-8?B?VFlqeVNDazVaU3RBVzZKeWpCNVdFaVJ4RjhyQWZVV0N6NlMweStEQllRczBt?=
 =?utf-8?B?RWZRdTdsU1M1N3dNNUdlVXh0RnVlYXVjVXlBbU1GczQ3RXhWa2s1QWNvMWUv?=
 =?utf-8?B?VkF5aThWQVFjdTRqeFVCTnE5TVRCTUNsWk9Gd091N0kwcjk5U1l6VEt3T1Nx?=
 =?utf-8?B?bFVnWm0zT1lFVTl6WlBXbC9PK2hzVVVuNWlCOE02TnZ6cDRWYzc4Qmp0bFBL?=
 =?utf-8?B?VGErcHRXbkVONXJmTUp0aTJmVFpJZ05Fd1I5UG1aWGZwR1pPclJYMmRVdkc1?=
 =?utf-8?B?Mmsyd3N5T0svL3pjcVRCcnJWKzFkcUhnMi94ODB2cFZrbSs5alpjY3orMCt4?=
 =?utf-8?B?dFhHMVlRUGhtVS9XZUxZRWlnYnVQRjdueXRMQmJ0aVVVd1pLSy82RlZRQ0xO?=
 =?utf-8?Q?MiZow+L8loRBIZNHRi6HQmCRwavcS4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BDE9BD473DC7E41BA9F08708B29ABA3@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b024f03-6307-448c-fb8b-08da0cec293d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 16:42:46.9620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GithKBFMteBjeTY8a06RSNVFMVTooIl0ArVRtgT7m8hkoLfMpE45SJtcm4RFKZnuykYRZrHjc8y/0QRyOckgBdvEEByIl/pZR0Xb5/vWb2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB8270
X-Proofpoint-ORIG-GUID: lV6c7jPcLtzWivbJD_7ZKGstFu4Lubku
X-Proofpoint-GUID: lV6c7jPcLtzWivbJD_7ZKGstFu4Lubku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1011 mlxlogscore=769 impostorscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAzLTIzIGF0IDA4OjQzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyMyBNYXIgMjAyMiAxMDowODoyMCArMDIwMCBUb21hcyBNZWxpbiB3cm90ZToN
Cj4gPiA+IEZyb206IDxDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tPg0KPiA+ID4gVG86IDxO
aWNvbGFzLkZlcnJlQG1pY3JvY2hpcC5jb20+LCA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gPiA+
IENjOiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4sIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnPiwNCj4gPiA+IAk8Q2xhdWRpdS5CZXpuZWFAbWljcm9jaGlwLmNvbT4NCj4gPiA+IFN1Ympl
Y3Q6IFtQQVRDSCB2M10gbmV0OiBtYWNiOiByZXN0YXJ0IHR4IGFmdGVyIHR4IHVzZWQgYml0IHJl
YWQNCj4gPiA+IERhdGU6IE1vbiwgMTcgRGVjIDIwMTggMTA6MDI6NDIgKzAwMDAJW3RocmVhZCBv
dmVydmlld10NCj4gPiA+IE1lc3NhZ2UtSUQ6IDwNCj4gPiA+IDE1NDUwNDA5MzctNjU4My0xLWdp
dC1zZW5kLWVtYWlsLWNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+IChyYXcpDQo+ID4gPiAN
Cj4gPiA+IEZyb206IENsYXVkaXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29t
Pg0KPiA+ID4gDQo+ID4gPiBPbiBzb21lIHBsYXRmb3JtcyAoY3VycmVudGx5IGRldGVjdGVkIG9u
bHkgb24gU0FNQTVENCkgVFggbWlnaHQgc3R1Y2sNCj4gPiA+IGV2ZW4gdGhlIHBhY2hldHMgYXJl
IHN0aWxsIHByZXNlbnQgaW4gRE1BIG1lbW9yaWVzIGFuZCBUWCBzdGFydCB3YXMNCj4gPiA+IGlz
c3VlZCBmb3IgdGhlbS4gVGhpcyBoYXBwZW5zIGR1ZSB0byByYWNlIGNvbmRpdGlvbiBiZXR3ZWVu
IE1BQ0IgZHJpdmVyDQo+ID4gPiB1cGRhdGluZyBuZXh0IFRYIGJ1ZmZlciBkZXNjcmlwdG9yIHRv
IGJlIHVzZWQgYW5kIElQIHJlYWRpbmcgdGhlIHNhbWUNCj4gPiA+IGRlc2NyaXB0b3IuIEluIHN1
Y2ggYSBjYXNlLCB0aGUgIlRYIFVTRUQgQklUIFJFQUQiIGludGVycnVwdCBpcyBhc3NlcnRlZC4N
Cj4gPiA+IEdFTS9NQUNCIHVzZXIgZ3VpZGUgc3BlY2lmaWVzIHRoYXQgaWYgYSAiVFggVVNFRCBC
SVQgUkVBRCIgaW50ZXJydXB0DQo+ID4gPiBpcyBhc3NlcnRlZCBUWCBtdXN0IGJlIHJlc3RhcnRl
ZC4gUmVzdGFydCBUWCBpZiB1c2VkIGJpdCBpcyByZWFkIGFuZA0KPiA+ID4gcGFja2V0cyBhcmUg
cHJlc2VudCBpbiBzb2Z0d2FyZSBUWCBxdWV1ZS4gUGFja2V0cyBhcmUgcmVtb3ZlZCBmcm9tDQo+
ID4gPiBzb2Z0d2FyZQ0KPiA+ID4gVFggcXVldWUgaWYgVFggd2FzIHN1Y2Nlc3NmdWwgZm9yIHRo
ZW0gKHNlZSBtYWNiX3R4X2ludGVycnVwdCgpKS4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1i
eTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+ICANCj4gPiAN
Cj4gPiBPbiBYaWxpbnggWnlucSB0aGUgYWJvdmUgY2hhbmdlIGNhbiBjYXVzZSBpbmZpbml0ZSBp
bnRlcnJ1cHQgbG9vcCBsZWFkaW5nIA0KPiA+IHRvIENQVSBzdGFsbC4gU2VlbXMgdGltaW5nL2xv
YWQgbmVlZHMgdG8gYmUgYXBwcm9wcmlhdGUgZm9yIHRoaXMgdG8gaGFwcGVuLA0KPiA+IGFuZCBj
dXJyZW50bHkNCj4gPiB3aXRoIDFHIGV0aGVybmV0IHRoaXMgY2FuIGJlIHRyaWdnZXJlZCBub3Jt
YWxseSB3aXRoaW4gbWludXRlcyB3aGVuIHJ1bm5pbmcNCj4gPiBzdHJlc3MgdGVzdHMNCj4gPiBv
biB0aGUgbmV0d29yayBpbnRlcmZhY2UuDQo+ID4gDQo+ID4gVGhlIGV2ZW50cyBsZWFkaW5nIHVw
IHRvIHRoZSBpbnRlcnJ1cHQgbG9vcGluZyBhcmUgc2ltaWxhciBhcyB0aGUgaXNzdWUNCj4gPiBk
ZXNjcmliZWQgaW4gdGhlDQo+ID4gY29tbWl0IG1lc3NhZ2UuIEhvd2V2ZXIgaW4gb3VyIGNhc2Us
IHJlc3RhcnRpbmcgVFggZG9lcyBub3QgaGVscCBhdCBhbGwuDQo+ID4gSW5zdGVhZA0KPiA+IHRo
ZSBjb250cm9sbGVyIGlzIHN0dWNrIG9uIHRoZSBxdWV1ZSBlbmQgZGVzY3JpcHRvciBnZW5lcmF0
aW5nIGVuZGxlc3MNCj4gPiBUWF9VU0VEICAgICAgICAgICANCj4gPiBpbnRlcnJ1cHRzLCBuZXZl
ciBicmVha2luZyBvdXQgb2YgaW50ZXJydXB0IHJvdXRpbmUuDQo+ID4gDQo+ID4gQW55IGNoYW5j
ZSB5b3UgcmVtZW1iZXIgbW9yZSBkZXRhaWxzIGFib3V0IGluIHdoaWNoIHNpdHVhdGlvbiByZXN0
YXJ0aW5nIFRYDQo+ID4gaGVscGVkIGZvcg0KPiA+IHlvdXIgdXNlIGNhc2U/IHdhcyB0eF9xYmFy
IGF0IHRoZSBlbmQgb2YgZnJhbWUgb3Igc3RvcHBlZCBpbiBtaWRkbGUgb2YNCj4gPiBmcmFtZT8N
Cj4gDQo+IFdoaWNoIGtlcm5lbCB2ZXJzaW9uIGFyZSB5b3UgdXNpbmc/IFJvYmVydCBoYXMgYmVl
biB3b3JraW5nIG9uIG1hY2IgKw0KPiBaeW5xIHJlY2VudGx5LCBhZGRpbmcgaGltIHRvIENDLg0K
DQpXZSBoYXZlIGJlZW4gd29ya2luZyB3aXRoIFp5bnFNUCBhbmQgaGF2ZW4ndCBzZWVuIHN1Y2gg
aXNzZXMgaW4gdGhlIHBhc3QsIGJ1dA0KSSdtIG5vdCBzdXJlIHdlJ3ZlIHRyaWVkIHRoZSBzYW1l
IHR5cGUgb2Ygc3RyZXNzIHRlc3Qgb24gdGhvc2UgaW50ZXJmYWNlcy4gSWYNCmJ5IFp5bnEsIFRv
bWFzIG1lYW5zIHRoZSBaeW5xLTcwMDAgc2VyaWVzLCB0aGF0IG1pZ2h0IGJlIGEgZGlmZmVyZW50
DQp2ZXJzaW9uL3JldmlzaW9uIG9mIHRoZSBJUCBjb3JlIHRoYW4gd2UgaGF2ZSBhcyB3ZWxsLg0K
DQpJIGhhdmVuJ3QgbG9va2VkIGF0IHRoZSBUWCByaW5nIGRlc2NyaXB0b3IgYW5kIHJlZ2lzdGVy
IHNldHVwIG9uIHRoaXMgY29yZSBpbg0KdGhhdCBtdWNoIGRldGFpbCwgYnV0IHRoZSBmYWN0IHRo
ZSBjb250cm9sbGVyIGdldHMgaW50byB0aGlzICJUWCB1c2VkIGJpdCByZWFkIg0Kc3RhdGUgaW4g
dGhlIGZpcnN0IHBsYWNlIHNlZW1zIHVudXN1YWwuIEknbSB3b25kZXJpbmcgaWYgc29tZXRoaW5n
IGlzIGJlaW5nDQpkb25lIGluIHRoZSB3cm9uZyBvcmRlciBvciBpZiB3ZSBhcmUgbWlzc2luZyBh
IG1lbW9yeSBiYXJyaWVyIGV0Yz8NCg0KLS0gDQpSb2JlcnQgSGFuY29jaw0KU2VuaW9yIEhhcmR3
YXJlIERlc2lnbmVyLCBDYWxpYW4gQWR2YW5jZWQgVGVjaG5vbG9naWVzDQp3d3cuY2FsaWFuLmNv
bQ0K
