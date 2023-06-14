Return-Path: <netdev+bounces-10677-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87FD072FBE1
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B70C81C20CBD
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A706D18;
	Wed, 14 Jun 2023 11:03:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67086FC2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:03:37 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2132.outbound.protection.outlook.com [40.107.104.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CB6DF
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 04:03:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7gjNymo7jEr3RH2pfrEltiFvv+OZNJQDoCqI/BVk7GGS3qhelHnotsANSIR8KLJhwNbDplOZMsXSlyMvAUdM/eQzqTbenmuRPSqTmCufVRAjKIWtguOAna4y5K8GC4148UxsUv8fhgswZzrXYplPEMd5C/LxGeuYXysj+d81N+r97MfbjI16wpVP53oKT8J8MESrpmFG8P6vIdw8Hwfa3ar09P9T5jsBovbVjFtVdfch/sdeNZMtwEpWQ57AwV13BDBNPntFYXQf+4Za0kOrc1/qTbAS+Ku37Pd6nBlBwGwmK+RnPaYh7J14dq5zIpfoDCcPpJi0S1NG6Nh/1q4jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EWB3pi8Oey/gfYT7PsfPYqxzQ2qFY8JFUTCtPIOg12U=;
 b=aYTgtVXS6u+gHmFzgs/32qmjuz68ZJqmOgbKWDy+Fs4QAPrI+5ZTBP0oznBAD8ZTT+7nfOLEZ2Gt9qgPeo/vm7/qPUT+H1+yG/H1II9XtrfQMDBTTtF25zskwHLjYYlSpvOrdfeKQTFt+65qgyaTenMh1y81B2Jc9pdk+HJUs0CI+adxRFucD7xIktYWuBKBfdbxtlkGR8YYOS5NaFBdmC11Yx5P+0G9lK0DUj+SP0qjdKoAHDq91RYT+k8HoGN33MjEmGiXYvx2Zqy3tvVwZFZrdhrMlk1UZp8PYoYjevsr1pS7Oup3Rwtqu2Ziol7zylBTeuN39tMIFHxww8O8Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWB3pi8Oey/gfYT7PsfPYqxzQ2qFY8JFUTCtPIOg12U=;
 b=FTMdYLuYFBeuEE2zTcSaoLZA8wCWCLjWJY5GeaEHRfW2djwLbJ5PcCdfOOkccN7fyvTGTIoRzOTsNYgMHpQzkbkEZ8OffNcuJmXXK8KDYhRQPSXqmrFEuwTyqde+uexhhXrhXtg0S6TJQEOTzA45pzv1LLXyngxm2kZsdhb5TWM=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by AM7PR05MB6993.eurprd05.prod.outlook.com (2603:10a6:20b:1a4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 11:03:32 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::e2bd:186:9dfe:1fc3]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::e2bd:186:9dfe:1fc3%6]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 11:03:32 +0000
From: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To: Lin Ma <linma@zju.edu.cn>
CC: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>
Subject: RE: [PATCH v1] tipc: resize nlattr array to correct size
Thread-Topic: [PATCH v1] tipc: resize nlattr array to correct size
Thread-Index: AQHZnpZmSay5i65KEEOEHscxZzTZlq+KD6IggAAPqICAAAD24A==
Date: Wed, 14 Jun 2023 11:03:32 +0000
Message-ID:
 <DB9PR05MB9078EFB846AB4D096BE68FEA885AA@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20230614080013.1112884-1-linma@zju.edu.cn>
 <DB9PR05MB90781C45A3592E3962F6F3D8885AA@DB9PR05MB9078.eurprd05.prod.outlook.com>
 <6bce9e01.84f02.188b9889498.Coremail.linma@zju.edu.cn>
In-Reply-To: <6bce9e01.84f02.188b9889498.Coremail.linma@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|AM7PR05MB6993:EE_
x-ms-office365-filtering-correlation-id: ffa62eb3-9950-4537-69a6-08db6cc6fdf1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 b90MDl27A1eBQfa01Cjgr7lWzXLmZ0dxw9rOOFKWH13kUajOiEmyt3yH5FJokb8iRmBPzyGZOKeEtbbJeDPCdRTL9yAngCuViOdGV5jFJ0/+PdTU5fXZpfM5b9wI2UyVtt/GR4VIJHx2hnubPGnfMTgMpjohxT6zaGYiNbEFVsnwFVeMYOeFm3Duasti+tVF/MlR8vZWjCXrY/pH8jhwdhs09nTCzbyr57E12U7PeyL4Tj6VIiPGisPe9IG58UDNRYWJGgNjvRHsq/01IKtJ6sLUnsv1f+1T3wZ1KwLWY6eIFOA8kHPlA8XFxiI5NnC+X3SqBVweXXa/mCR+wiDQsOSuAFA1lcxWITe2n5y3gLiDi6R1hHTrNWRz3kqjz1HCkCv5DL9eSkXKkgaO/chINANSpscsgoC7fI5eZ5hX6dh/C1keGxxb9jfXEJoBaaUXvyHlaoM9znSDLE68uJ5tnNiMUKq7UPls8+AyQwftY7ccPQNbqy/oVwM2ezVFkHgRrT4IBetesv+WsrV/bEHk3nCq3fMWk96G6hR9N227cLluRqAMFJVPcMO19XB1noJH71cK+x3Xls5XQQ8PA+qDwcmUSn3r/0DQEMTsOIo1KsKlm415qkzOEgUqVizGn8Jw
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(396003)(346002)(136003)(366004)(451199021)(7696005)(316002)(41300700001)(122000001)(2906002)(9686003)(6506007)(86362001)(186003)(38070700005)(26005)(33656002)(558084003)(55016003)(38100700002)(5660300002)(8936002)(52536014)(76116006)(66476007)(66946007)(8676002)(478600001)(54906003)(66556008)(4326008)(71200400001)(6916009)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MFVWUTNKdG5TN1d3eEZxS0ZnaW9RaFJJTGFrWXkrR2hTQ1BvcVpGUTBiWElX?=
 =?utf-8?B?c3hFR0N2QlRzZWNiRjRFanFmM1VDSFJ2a2VsUG9FdzVmLzdlQVAwUzNTQ0lw?=
 =?utf-8?B?RFAvSnRtV21IYlUwR2REeElUM0t0Y1FNN0Fpc0REcmNsTDdRYTV1RW9sd3hZ?=
 =?utf-8?B?Rld5RDdYUTRueU9CME9WbWg2NVdvWUl5TVp6TGY3MGZXQ2k0emlaUTIyUWVm?=
 =?utf-8?B?c1dNREhxVFJLUXF1MkhpS0h5TjRRZkZwUEVLbFcxK21RYVAva0JtbUFyaEF1?=
 =?utf-8?B?ciszSHkyWTNRYnA0eFNzYXRRN0pzeC9DRG1TUWpQSXRjNlorYzJQc09jM1hU?=
 =?utf-8?B?UGpGLzVRY0FsVFovZW9TeUhmVllKTXgwV04wZ0JiV1loVWFmM1RnSE4vVFZa?=
 =?utf-8?B?RVdEMUVxTXpCb2RxSERMSE12SkFQOWhmN2ltQzF5bW1QbWFpTEJ1TFFXaEZq?=
 =?utf-8?B?UnNLSGc0a3p6VUk3K1NSVjZaQk9DZzkwSzZoR1hpTGhHQjg2UkNPN2FwaXVC?=
 =?utf-8?B?M2M2dVg2bEFHNjEybmxpZ2dLeTlzMkNsNTdhU2JDL0o5YmdoRUJCVXZvaFFw?=
 =?utf-8?B?aGUyMFJ2VUU5M2V1MnhBZVhZMXA3VU91U010U2xkVDVxZ2pHYjZRNmNKWEdK?=
 =?utf-8?B?dGh3SHN5SUxjTFVoTFBLQllTSDcvSUdXKzFFMWs4QmZLMzROZXVMbzhCb2V1?=
 =?utf-8?B?L3FrN2tkcVovR2QxM2M0a0ZhL1hGUlljREdlYTM0U0pyNHdpVmFnRGV2Zy9x?=
 =?utf-8?B?QzhLdWpRUiszbzRmM3cxRW90ay9oYkRKT0pXOVRySk9taHR1V2NqdXYyRHR1?=
 =?utf-8?B?QVYwc2xoVDQwZTBBZStJQW1iOGJHejgwYm1iNjJpTVoweGtYTmhadUZtM05U?=
 =?utf-8?B?RTIzL3VvcnlmeTh0WHFuTldiMitiK0l2QU1aeXI0RENYQTlnOXJjQjZPelZB?=
 =?utf-8?B?bHR5eEJ1WEZDZmpaNU05ZVFPOXZBR3AxR25JNlZrNjJlYWZGSmxUM2g5ZlRv?=
 =?utf-8?B?VDVUNkxtNU1ZUHFBaytwWkxxNkVOZko2QS9kRVBmbXhPbk53ZUhXbG5Ud1B5?=
 =?utf-8?B?aWdJYzFUWUJRNFRDZWE0d25pbVdxS2crT0s1WUhvNXBIeUpmQ0d4SGE3SHpO?=
 =?utf-8?B?eGM5b1FPOHFMWEJTK1BOWmpqeGh3bU9lRC9CS3lnaXNGVm51bldMcGl4aUtY?=
 =?utf-8?B?WmR0bGVNZTBmQkJNVFhHMTBiZkx2RGFPODB4c0NGYWlQYS9yUXJwYVU1Sy84?=
 =?utf-8?B?aS9NWmlYN2VWVFRhL0FKWEtkY0tqUURQd0w2NnZwOFZwaHlTY0JKemRnamV4?=
 =?utf-8?B?bjh0a0lISjVHalJENnlpdFJjTm1tMXVIZklCYTRpNXYxb1JPa1dDTjhJUm5D?=
 =?utf-8?B?VWtGZnNJK0ZERlRRK01YanV5cnNvSFI3MTBIK0ViOG01U29wc0hrNVVyenVD?=
 =?utf-8?B?MkQ5OE0rTUtsNDJic2FFZjYwdG1EenhFdDFyYzJVVUtZWXp3UVJCYTRLVTRC?=
 =?utf-8?B?NHpyNTZGZU1DSktEM1A4WkV3b0FoZi8rRnBLaC9TVjFTWFdFSVZDMEJ5TGVD?=
 =?utf-8?B?THg1YUdmUE9meU5DSExQUUhtaTBFSWhqRWxOaUdURlBlYWU2bCtZRERkUUtZ?=
 =?utf-8?B?ckxxaHVLQkpOMm9QOTlSY0pSMGZjTlFQOGM2ZHZQZzZKZHJXYmJCSzhrUUNk?=
 =?utf-8?B?OTRkZncxazBPMVBqUTdNVEhQZmo5NURkL3dyZVREVG9lZDAwbG4yWmR1OU53?=
 =?utf-8?B?eElXYjlKeTVOazhjUW5QNDE3YWtoTTJtT2lXbEplbkV5WW13bmdYbXlONVhB?=
 =?utf-8?B?dTljbmh2NktzTWxZbWdsekZ2bHNRNmw5T1pQb2RwaVl1OXpyZWZZSVVXajBm?=
 =?utf-8?B?WWliMW4xcU5LZ2Jqb2RuaTZ3M0IvcTREdDFscUs2bjZWTzR1eldtM2p2TFo5?=
 =?utf-8?B?aWllaC8rN3h2WnQ5d0lHYnk5dUpneklMOFR1aVdWM3dwOWpESVcxQXQ5V2ZT?=
 =?utf-8?B?aS9jdHkrWlJKellBcXcwVkRNVVlIMVQxT002bk14QXN3ZWtqMXp2dFFxcWFo?=
 =?utf-8?B?eDRiMWRVZlYwZUlpbWNQRjZqdkp5OVZzelJIeHFRZ05PNUVpenB4a2FPL3lU?=
 =?utf-8?Q?HutAf5ilmzQGMkP9HGo4RRFwi?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa62eb3-9950-4537-69a6-08db6cc6fdf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 11:03:32.2514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PMtyK8qHENuI5bp/ZpuL7P5RDu01B2wVf437ArxT/mNG+Wk2hPc7Kz3VX1D1RcI+Fv/sH+MsHse9DyV2M+PV3d//G+mYc66SiaMJSstheQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6993
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PkkgZG9uJ3QgcmVhbGx5IGtub3cgdGhlIGRpZmZlcmVuY2UgOkQNCj4NCj5TaW5jZSB0aGlzIGEg
bm90IGFueSBuZXcgZmVhdHVyZSBwYXRjaCBidXQganVzdCBzb2x2aW5nIGEgdHlwbyBsaWtlIGJ1
Zy4gSSBndWVzcw0KPml0IGNhbiBnbyB0byAobmV0KSBicmFuY2ggaW5zdGVhZCB0aGUgKG5ldC1u
ZXh0KSA/DQo+DQo+UmVnYXJkcw0KPkxpbg0KPg0KSXQgaXMgT0sgdG8gZ28gZm9yIG5ldC4gDQpQ
bGVhc2U6DQotIGFwcGVuZCAibmV0IiB0byB5b3VyIHBhdGNoIHRpdGxlLg0KLSBhZGQgRml4ZXMg
dGFnIHRvIHRoZSBjaGFuZ2Vsb2cuDQo=

