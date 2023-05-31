Return-Path: <netdev+bounces-6879-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7500F7188C7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 722D11C20EF2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE5318AEA;
	Wed, 31 May 2023 17:48:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F91171C4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 17:48:38 +0000 (UTC)
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42389125;
	Wed, 31 May 2023 10:48:37 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VGsG4Z023669;
	Wed, 31 May 2023 10:47:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=oEZz0qZYR9f4j/geFm0+Cdw9p6IOyJfzmSROsBD/Vsc=;
 b=EHGU/yxutJCMGeDUL6HizSpF5nGXRJ0IgNQpg8tNbnAOlH3H+QCW76/nDdCe2Cj48+db
 RGCOFruXpAWPfudrsme1nW4jQYSsehJwF0d5rnSMa4rcHZ4tGYaY8Q4ibDtn4a02V1BS
 VeZox5nbVtbigezIagKWi67c6hU52ZFSl0Nyb2+onssnH3q8jiHQZJ9uzVCJ3TSHaMNw
 Byvo90rDdl232W74Z+p/ZsNol18ces00qAS77GGg9jzw8cIrK1WxtTvsV6cK4heo6aSt
 P/UVW6KYYX+QXf1y7VSnG1653x7rksSyfkPy0fSBjvuB3lXr/erKBrqmhj7d+wRqxoIG Hw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3qufyfaj8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 May 2023 10:47:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwGULf29ADT+6lCF8PNVMQzNCb5w8uKemivHFiT7nNkHUcVD3sI8Bdk/iTYLF8FsF3lK4YEJS26N9As96fC4ad8fBs8vSJwTK8+hwpK8eahsFHWZNDXbw+xbftetNbDvMWTR31sCDDR6zPjrTQ9NrDSr/gUfX7uIRbjEbg/xUKL7nolLF3yEM2sRxqCkqfkCj/XJasHtVuRUWn3n0lu5j3RGTd4/7iK75+bv72vYEK5dx0z1zCQy/iOi6TitfttEGmKFUQhGp8o5rbdS6utl+ktuMtb2r+SR9RAf6f9P5/g27iS4629iD8KuP8dBFX1T7QWBv1mPfxhOa15zIO6YMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oEZz0qZYR9f4j/geFm0+Cdw9p6IOyJfzmSROsBD/Vsc=;
 b=QuqsbU+/ZTT2hBmWhDXFdLbXOAKwgTggS8Lc4QBKg5oGOQpQ2Pm69jz7YsCjc0XlOc/5u8vK6hjmTJtqVtNHKfTHn2J2HZjEt14Xqbla6e7hFy8ymxpGkKuRlFLXqMQy0+cO5Ulimxxc2+8Uy2RbolXToHpueMfa90H5tEtL7pTFV1lUK7lWZxT4wf3fPcNDvhPqDTBmtGDXP1cr6m7kK2LUl+r2MlRicgbJ3dmszjwk6fUN8hjMShVJBnUG/XbCmp5hmYsILEQ7ZtTaAj2rM96OKlBgmZDGvu92YbbucbVX/WrHk0M6Wnd0Aj3+ivycKDpxCBTKvFKdMMQ297wf7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oEZz0qZYR9f4j/geFm0+Cdw9p6IOyJfzmSROsBD/Vsc=;
 b=w5//hxrWj7N5Qj4SSoPGFTj/UDYLvvOIU48yChT4Wl434twGMCEYg1LYk1Cj9cyU1u+llz2a49yAfJ89sMrZfMYIOGp4UWJNS2pZRnDBqvrgf1aA+ycwUXYGecJnZWyYZ6AYUMYT3bKTOmxGm0F68sCBwSxvVIIqhy40kYaQNw9dhF71A7m+/RX9feYqDhCjbIWYEUfudupB4vGFVv2duiHU7xhBkzo/ioGQYltYmOMMKSH8B5WRqxac2GugSiRPPUkmJpU2nOZOLmZCk64JaxP6G4d+IJm9x/q3YtoRRK/RRd2n6NZcwl/cx9RDMM++oXGHttly4wl9OAMVbRo3lg==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CH2PR02MB6630.namprd02.prod.outlook.com (2603:10b6:610:7d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 17:47:26 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 17:47:25 +0000
From: Jon Kohler <jon@nutanix.com>
To: Eric Dumazet <edumazet@google.com>
CC: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Richard Gobert <richardbgobert@gmail.com>,
        Menglong Dong
	<imagedong@tencent.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        John Fastabend
	<john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel
 Borkmann <daniel@iogearbox.net>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Qingqing Yang <qingqing.yang@broadcom.com>, Daniel Xu <dxu@dxuuu.xyz>,
        Felix
 Fietkau <nbd@nbd.name>,
        Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] flow_dissector: introduce skb_get_hash_symmetric()
Thread-Topic: [PATCH] flow_dissector: introduce skb_get_hash_symmetric()
Thread-Index: AQHZk+RxmdTXxpqVM0m0KZDS1nnqo690pFCAgAAD0oA=
Date: Wed, 31 May 2023 17:47:25 +0000
Message-ID: <30861EDF-D063-43C7-94A7-9C3C5ED13E54@nutanix.com>
References: <20230531172158.90406-1-jon@nutanix.com>
 <CANn89iLE1d=MuSMTisEbLh6Q_c4rjagd8xuRj0PC-4ua0pDRPA@mail.gmail.com>
In-Reply-To: 
 <CANn89iLE1d=MuSMTisEbLh6Q_c4rjagd8xuRj0PC-4ua0pDRPA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|CH2PR02MB6630:EE_
x-ms-office365-filtering-correlation-id: 85db4e99-f620-4fb3-8f75-08db61ff1888
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 /HprFA5Z6jFLHmZIUJXgDavx8FPxskasoFfYBSCgtTmB0l4ZRduT+mUvLNUkKoRdQ4kbeTCpTvR/bilfKTkdWa2j2J0DL7TqWkaH8Quq3jsInteb7NwgPk+rXNK5IZOEMuUOaPGn2ae5zKJPNrqHTKsmhECHKxnnk/cJmJ9Y9y4xfFmIZ87vHEUlB/4GO/7ezkDmE+p+6TENdDGNqkXR8cVecVktBIR2vaCYAyoD/t0UIhgADQnCu2g1UxE6QuAuVC4knZmhMmzUFrMLt+zGoqP5ktkv4jw0ZuIL3/Go9zVXlqLOaJ7IbFmJUxW5VCBX5XSbL+GZSh4PW869CPrXyjffddM3eWKIxtaaN09H8guX9bLfV/PfDslMhDoV98C8SJXLEx6JbE+M/L0DlwYv4OZoozzEBVRCoZJEwEM4G4bLXDDRKzgmVn80Snx90eeNKUVp9Knkss6wWmsongAWiwUlS8tUvjdVVPNwIuign17gD+ida+6kmn4YQqKOyM94+NuskLd4KyC7Vz0n+h7EoNO68UxNjKtxYFbkODHo5+jN5GvfGmcErvYc/wyiGaAwIkFTC25YdRIcvXzA39291v8OCsSSG2cO418OhfaBuia68sTLJvrkSB0BWGaeYNbATDkyqGwwi1/cabfzSOYkNg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(41300700001)(6486002)(316002)(38070700005)(86362001)(6512007)(2906002)(186003)(36756003)(53546011)(6506007)(8936002)(8676002)(33656002)(7416002)(5660300002)(2616005)(478600001)(122000001)(38100700002)(54906003)(6916009)(4326008)(66946007)(91956017)(76116006)(71200400001)(66556008)(66476007)(66446008)(64756008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?T0xEYW9NMklwSlRVUURzMlZjTHc5ZVA0SEw3NW1JSERpQXNvZm1aL2txTmIx?=
 =?utf-8?B?WXdRdmpmN0R1K0JuZmF2TEZGZTEyOXpnaVRkSXo0YmRzb00xQTVrK0lDUEpj?=
 =?utf-8?B?MC9PakhDRk9QNUpZK1lRTTdrVkgzQlVwT3U5NTQ4dkZIZjRhV3pqdEs5U0E0?=
 =?utf-8?B?R1ZpaWZRMjAzNmlUTlRQWURIRytYQWRWTGJHL3BtS1Q0aVRpNmR5L2xmRXZp?=
 =?utf-8?B?WC9kY3o0eUs2SU45OE1LYzJwaGwzcVQwT3dVWjYwL09GdnVHaDRxZnZxajZz?=
 =?utf-8?B?cm8vdm52K3hBdi80ckZsVG10SS84L3hWd3IrM2ZJYm44YThSOTRYeFdjaXVZ?=
 =?utf-8?B?NXdDRVJwckJaOU90d2FudHhaRjBJOFlvM3JSY1hvWUlIZlNpVUx4N016eUFN?=
 =?utf-8?B?Y0R6dDg1bC9XS0JQcmQwWlZtZml6SXMweHB2R0ZEQzF6aGNhb2JVa1hmVjNa?=
 =?utf-8?B?RXZWdml0V2dnVzk5dktxUGludzNPRFcxYTQ2VjY3MUk3amJBcGo5NmkxRUV4?=
 =?utf-8?B?QjFHRlVBdzlCZW1IQllZQW04dHpldXovQWZzekVuT0NwWE0raUF6clVGWkp1?=
 =?utf-8?B?SlUzdzdrQ2VxTUlGWWF4RVppR2toV0kxM2Z4NTFRMmlET2c3aU9hVkMxTmRn?=
 =?utf-8?B?QzI2SHNIWkNYWUR1anFwVFFXWkpJb1AyakcwY29lOEdRaDlYMFNpSzBDczdI?=
 =?utf-8?B?M1Rib2VHWS9UTlIwQWRJZkoyZjVDdTFIV1NQaGJ2d1Jna2UxeEdYYkpCeXFr?=
 =?utf-8?B?dU1OOTcyRTZ4Z0krTXp0QXRNTVZuZENCZ09GRHRoazdYSGxycmRLOS9aVk1L?=
 =?utf-8?B?Z0llTmltdytONkpKV1JNenl0dERXV2MzRGVXN3JnSXBjUGdmckQ0c2ZtaEl6?=
 =?utf-8?B?aVZiMDFGZkxobC9XMWNleEh5OGF4RzVGbTdGbUVJMkVjeWpRd1QzMXhLaWk1?=
 =?utf-8?B?SDJod1FueHZuZE9WU21SbjFTQW1NcXJMMGgyTVArK2VmOE9NVUM5QlBVMEZz?=
 =?utf-8?B?SmdXM1ViWXloT3hQTHhUcjFpUmFlSU8wL0R2T085SStSeklodEtLQUNjZDRM?=
 =?utf-8?B?RUF1Z0JCOU1TbUdLWE1ydHZYeDYzQlZVVko1MVFMTlZoYk0ySEdtbHcrUCtT?=
 =?utf-8?B?QmI3TldLUHdwNEdHTmZSck92aUZxVmNYc1dtbm1aQ1lURXNaaWc3N2tLdTI3?=
 =?utf-8?B?cTJvTHNqajlnMlEySWk4SjB1dEloYmpCSElGN2x5NURIMTR3M3VleHhuZkQy?=
 =?utf-8?B?emkzYjlSUk03NG9RSjcvUnJtQ29kSjJBMFVaZGpjcnZOWG1UZU1xYlR5dHlv?=
 =?utf-8?B?Yjh2dHI2b0l2TUhKV3V6UThyOXhWdkRhZ1BqejBhOHR6cTVKZjdnV21YV3gw?=
 =?utf-8?B?NE94dWgrVitwbTBzSy9sQlJtc1dyb0F3R0RBRThlVzdhSXBMc2VkTzNTRnh1?=
 =?utf-8?B?RSszZDdzYVBRL3NTb3lUdlIrOFl4YmVQd3ordlEzM294V1BUVFF3SytKZU9G?=
 =?utf-8?B?QzB6NGtZT2NJeDl1ejV5TExHRnZRTk81dUk2dThPVGxuNDVLMldoRDlSZUYv?=
 =?utf-8?B?clVhL0lMdDlLM3lORUh3aXd6N1B3UG5EZ2lhcmZUbncrWWpsSy9MRmp1QnNG?=
 =?utf-8?B?cVFNOUlXNlIwU29DT2xUM3J2alZOd0hSMFlETUgwQUxtZzVTZ3N0dHA0UGN4?=
 =?utf-8?B?QmVTdG1RL2pTTnZHKytvTkhhUXd6bURvOVVuRTRYZFM5c1VyNnhQK0xiRnRN?=
 =?utf-8?B?VFNIQlpyY0taQXAvOWhsUnN6SG81MW1GQkgyYWw0STNZNFBxNit0R1lpckI3?=
 =?utf-8?B?Z2dBY0tvdThDUWxScUpZalZlOFY0VUNCQWRRQVNzdmlZTjE0S1ZmOUNFaloz?=
 =?utf-8?B?dGtaV3dLeVlISmpvbDZQS2VpQ3dJZm92TGtpSjBvUm1uTkJnemZ5eG4wRlN4?=
 =?utf-8?B?enZiQndsVFJRQW54U2Z2d1pMaExjMHI5RHluVkdINEdVNTMzWjJCbzIreWlI?=
 =?utf-8?B?UUdjaUNnMlgraVdHeWV2aUFsUjQrcUQrWVgyWlEzSUFYemllakVHdHlIcnBP?=
 =?utf-8?B?VVJkODdKYmpxUU5XM2ZGSTBBU0VEVFpUVWxRVmJjRWM5encrWHhieXB3aU85?=
 =?utf-8?B?NnFITzA5K2grYU9mQmJBVm9TZUZkcnYrR0hmQm8waldXRjBuMGluMWswcnVy?=
 =?utf-8?B?MThXUXRsbTJiZWVBV0cxcDVkR1M0Yytkb3lZTm9wMmFEZGZaYlBXRGlKckZH?=
 =?utf-8?B?ZUhmTXd3b3I1NjFDZzFLYm55YnhnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <378C8E3DEB1B674DA4F288CA1F556DA2@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85db4e99-f620-4fb3-8f75-08db61ff1888
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 17:47:25.9038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /sZY5SFo7eR5i1dq3wvBzU6/zU+9NajywkQqUYQuZuX+S+MOQADyhFr83ApGSFNeNjeCVXKXRbwBv46T/y4Vlbs/bLRX7+jEkqHUu3SWQAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6630
X-Proofpoint-GUID: DNj_pxSHeE8IOF1jBPAPNcCqGH-4Ea40
X-Proofpoint-ORIG-GUID: DNj_pxSHeE8IOF1jBPAPNcCqGH-4Ea40
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_12,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gT24gTWF5IDMxLCAyMDIzLCBhdCAxOjMzIFBNLCBFcmljIER1bWF6ZXQgPGVkdW1hemV0
QGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBNYXkgMzEsIDIwMjMgYXQgNzoyMuKA
r1BNIEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4gd3JvdGU6DQo+PiANCj4+IHR1bi5jIGNo
YW5nZWQgZnJvbSBza2JfZ2V0X2hhc2goKSB0byBfX3NrYl9nZXRfaGFzaF9zeW1tZXRyaWMoKSBv
bg0KPj4gY29tbWl0IGZlZWMwODRhN2NmNCAoInR1bjogdXNlIHN5bW1ldHJpYyBoYXNoIiksIHdo
aWNoIGV4cG9zZXMgYW4NCj4+IG92ZXJoZWFkIGZvciBPVlMgZGF0YXBhdGgsIHdoZXJlIG92c19k
cF9wcm9jZXNzX3BhY2tldCgpIGhhcyB0bw0KPj4gY2FsY3VsYXRlIHRoZSBoYXNoIGFnYWluIGJl
Y2F1c2UgX19za2JfZ2V0X2hhc2hfc3ltbWV0cmljKCkgZG9lcyBub3QNCj4+IHJldGFpbiB0aGUg
aGFzaCB0aGF0IGl0IGNhbGN1bGF0ZXMuDQo+PiANCj4+IEludHJvZHVjZSBza2JfZ2V0X2hhc2hf
c3ltbWV0cmljKCksIHdoaWNoIHdpbGwgZ2V0IGFuZCBzYXZlIHRoZSBoYXNoDQo+PiBpbiBvbmUg
Z28sIHNvIHRoYXQgY2FsY3VhdGlvbiB3b3JrIGRvZXMgbm90IGdvIHRvIHdhc3RlLCBhbmQgcGx1
bWIgaXQNCj4+IGludG8gdHVuLmMuDQo+PiANCj4+IEZpeGVzOiBmZWVjMDg0YTdjZjQgKCJ0dW46
IHVzZSBzeW1tZXRyaWMgaGFzaCIpDQo+IA0KPiANCj4+IFNpZ25lZC1vZmYtYnk6IEpvbiBLb2hs
ZXIgPGpvbkBudXRhbml4LmNvbT4NCj4+IENDOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQu
Y29tPg0KPj4gQ0M6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4+IC0t
LQ0KPj4gDQo+IA0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvc2tidWZmLmggYi9pbmNs
dWRlL2xpbnV4L3NrYnVmZi5oDQo+PiBpbmRleCAwYjQwNDE3NDU3Y2QuLjgxMTJiMWFiNTczNSAx
MDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbGludXgvc2tidWZmLmgNCj4+ICsrKyBiL2luY2x1ZGUv
bGludXgvc2tidWZmLmgNCj4+IEBAIC0xNDc0LDYgKzE0NzQsNyBAQCBfX3NrYl9zZXRfc3dfaGFz
aChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBfX3UzMiBoYXNoLCBib29sIGlzX2w0KQ0KPj4gDQo+PiB2
b2lkIF9fc2tiX2dldF9oYXNoKHN0cnVjdCBza19idWZmICpza2IpOw0KPj4gdTMyIF9fc2tiX2dl
dF9oYXNoX3N5bW1ldHJpYyhjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsNCj4+ICt1MzIgc2ti
X2dldF9oYXNoX3N5bW1ldHJpYyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiKTsNCj4+IHUzMiBza2JfZ2V0
X3BvZmYoY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYik7DQo+PiB1MzIgX19za2JfZ2V0X3BvZmYo
Y29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwgY29uc3Qgdm9pZCAqZGF0YSwNCj4+ICAgICAgICAg
ICAgICAgICAgIGNvbnN0IHN0cnVjdCBmbG93X2tleXNfYmFzaWMgKmtleXMsIGludCBobGVuKTsN
Cj4+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9mbG93X2Rpc3NlY3Rvci5jIGIvbmV0L2NvcmUvZmxv
d19kaXNzZWN0b3IuYw0KPj4gaW5kZXggMjVmYjBiYmMzMTBmLi5kOGMwZTgwNGJiZmUgMTAwNjQ0
DQo+PiAtLS0gYS9uZXQvY29yZS9mbG93X2Rpc3NlY3Rvci5jDQo+PiArKysgYi9uZXQvY29yZS9m
bG93X2Rpc3NlY3Rvci5jDQo+PiBAQCAtMTc0Nyw2ICsxNzQ3LDM1IEBAIHUzMiBfX3NrYl9nZXRf
aGFzaF9zeW1tZXRyaWMoY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4+IH0NCj4+IEVYUE9S
VF9TWU1CT0xfR1BMKF9fc2tiX2dldF9oYXNoX3N5bW1ldHJpYyk7DQo+PiANCj4+ICsvKioNCj4+
ICsgKiBza2JfZ2V0X2hhc2hfc3ltbWV0cmljOiBjYWxjdWxhdGUgYW5kIHNldCBhIGZsb3cgaGFz
aCBpbiBAc2tiLCB1c2luZw0KPj4gKyAqIGZsb3dfa2V5c19kaXNzZWN0b3Jfc3ltbWV0cmljLg0K
Pj4gKyAqIEBza2I6IHNrX2J1ZmYgdG8gY2FsY3VsYXRlIGZsb3cgaGFzaCBmcm9tDQo+PiArICoN
Cj4+ICsgKiBUaGlzIGZ1bmN0aW9uIGlzIHNpbWlsYXIgdG8gX19za2JfZ2V0X2hhc2hfc3ltbWV0
cmljIGV4Y2VwdCB0aGF0IGl0DQo+PiArICogcmV0YWlucyB0aGUgaGFzaCB3aXRoaW4gdGhlIHNr
Yiwgc3VjaCB0aGF0IGl0IGNhbiBiZSByZXVzZWQgd2l0aG91dA0KPj4gKyAqIGJlaW5nIHJlY2Fs
Y3VsYXRlZCBsYXRlci4NCj4+ICsgKi8NCj4+ICt1MzIgc2tiX2dldF9oYXNoX3N5bW1ldHJpYyhz
dHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPj4gK3sNCj4+ICsgICAgICAgc3RydWN0IGZsb3dfa2V5cyBr
ZXlzOw0KPj4gKyAgICAgICB1MzIgaGFzaDsNCj4+ICsNCj4+ICsgICAgICAgX19mbG93X2hhc2hf
c2VjcmV0X2luaXQoKTsNCj4+ICsNCj4+ICsgICAgICAgbWVtc2V0KCZrZXlzLCAwLCBzaXplb2Yo
a2V5cykpOw0KPj4gKyAgICAgICBfX3NrYl9mbG93X2Rpc3NlY3QoTlVMTCwgc2tiLCAmZmxvd19r
ZXlzX2Rpc3NlY3Rvcl9zeW1tZXRyaWMsDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAm
a2V5cywgTlVMTCwgMCwgMCwgMCwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgIEZMT1df
RElTU0VDVE9SX0ZfU1RPUF9BVF9GTE9XX0xBQkVMKTsNCj4+ICsNCj4+ICsgICAgICAgaGFzaCA9
IF9fZmxvd19oYXNoX2Zyb21fa2V5cygma2V5cywgJmhhc2hybmQpOw0KPj4gKw0KPj4gKyAgICAg
ICBfX3NrYl9zZXRfc3dfaGFzaChza2IsIGhhc2gsIGZsb3dfa2V5c19oYXZlX2w0KCZrZXlzKSk7
DQo+PiArDQo+PiArICAgICAgIHJldHVybiBoYXNoOw0KPj4gK30NCj4+ICtFWFBPUlRfU1lNQk9M
X0dQTChza2JfZ2V0X2hhc2hfc3ltbWV0cmljKTsNCj4+ICsNCj4gDQo+IFdoeSBjb3B5L3Bhc3Rp
bmcgX19za2JfZ2V0X2hhc2hfc3ltbWV0cmljKCkgPw0KPiANCj4gQ2FuIHlvdSByZXVzZSBpdCA/
DQoNCk5vdCBkaXJlY3RseSwgYmVjYXVzZSB0byB1c2UgX19za2Jfc2V0X3N3X2hhc2ggcmVxdWly
ZXMgc3RydWN0IGZsb3dfa2V5cw0Kd2hlbiB1c2luZyBmbG93X2tleXNfaGF2ZV9sNCgpLiBfX3Nr
Yl9nZXRfaGFzaF9zeW1tZXRyaWMoKSBkb2VzIG5vdCANCnRha2Ugb3IgcmV0dXJuIHRoYXQgc3Ry
dWN0LCBzbyB3ZeKAmWQgZWl0aGVyIGhhdmUgdG8gcmVmYWN0b3IgdGhhdCAoYW5kIGl0cyBjYWxs
ZXJzKQ0Kb3IgaW50cm9kdWNlIHlldCBhbm90aGVyIGZ1bmN0aW9uIGFuZCBjb25zb2xpZGF0ZSBk
b3duIHRvIHRoYXQg4oCcbmV3IG9uZeKAnS4NCg0KSSBwbGF5ZWQgYXJvdW5kIHdpdGggdGhhdCBl
eGFjdCB0aG91Z2h0IGJ5IHRha2luZyB0aGUgZnVuY3Rpb25hbCBndXRzIG91dCBvZg0KX19za2Jf
Z2V0X2hhc2hfc3ltbWV0cmljLCBtYWtpbmcgaXQgYSBuZXcgc3RhdGljIGZ1bmN0aW9uLCBwbHVt
YmluZyB0aGF0DQppbnRvIF9fc2tiX2dldF9oYXNoX3N5bW1ldHJpYyBhbmQgdGhpcyBuZXcgc2ti
X2dldF9oYXNoX3N5bW1ldHJpYywgYnV0DQp0aGUgTE9DIGNodXJuIHdhcyBiYXNpY2FsbHkgdGhl
IHNhbWUgYW5kIGl0IGZlbHQgYSBiaXQgd29yc2UgdGhhbiBqdXN0IGEgDQpjb3B5L3Bhc3RlLg0K
DQpBbHRlcm5hdGl2ZWx5LCBpZiBpdCB0dXJuZWQgb3V0IHRoYXQgZmxvd19rZXlzX2hhdmVfbDQo
KSB3YXNu4oCZdCBpbXBvcnRhbnQsIHdlDQpDb3VsZCBzaW1wbHkgc2V0IHRoYXQgdG8gZmFsc2Ug
YW5kIHRoZW4gcmV1c2UgX19za2JfZ2V0X2hhc2hfc3ltbWV0cmljDQppbiBhIHRyaXZpYWwgbWFu
bmVyLiBJIGNvdWxkbuKAmXQgcXVpdGUgZmlndXJlIG91dCBpZiBMNCBmbGFnIHdhcyBuZWNlc3Nh
cnksIHNvIEkNCndlbnQgdGhlIHNhZmUobWF5YmU/KSByb3V0ZSBhbmQgY29weS9wYXN0ZSBpbnN0
ZWFkLg0KDQpIYXBweSB0byB0YWtlIHN1Z2dlc3Rpb25zIGVpdGhlciB3YXkh

