Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5316F51C626
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381512AbiEERhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 13:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbiEERhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 13:37:47 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2898517F0
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:34:05 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245BQw7L015244;
        Thu, 5 May 2022 13:33:40 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2168.outbound.protection.outlook.com [104.47.75.168])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fv4370et9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 13:33:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0LWTnKYomH0PmGf32VLSEtD4iBNylALVr5mn2AzStorMecSRmedYYj+8rHtaszbY9KaVUN+V3pqMRZn8++Pr84wP7VYt8b7uBAgghLbKy+j6s5Htyu/eg2bXBGJAGUbAe/ZozxwRaBQL8dBOSsT4ZZeJGu5Yqo4Ms/9dxIeBPF84eGDTU07+vKaidjQuEEPhCXh5dupdNdjCEwqJsjhUDUlcuUn6OUGaCMwoX8xq1a1hUws4BRDu9KCe+Vf7VJpERV9Z8pmKjdu43QERTP4oaJMjzr8E3yPpOc/Y+ScLrMM91zMI7KKTUNSEtfBs5jAPCjBqRnMp+ptSxtcLaSjiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KV8mpYCGY17cF11l3od/PSO+leZ0SQc9qrPSjRPMs1o=;
 b=d7R70Eiik3CJbqOoCWBWQBmkrGr7CZpy5h3H84aMumlCpZzdZQ+MpOPWieAKWHpCsE2EvtonsnDBgy82tipDQckoArM/EJF6/Vchz3icVxt0qG0Q/q7Vy0b2CG1TEdqVDbIGPrnAckgvIn56pTI1vbX1RVP5S/X8K6d6Yx1ubn4aoDeYBeBxCdorBGm0ENfBlU/JhLxKspCEVexnPq/Evwa0Vqpy/VL/ZnFTIYtxX1M5kTmxfFLsEBAF/TOSaroqor44QY273M5P27O4tU5XlRjjnPko6xBeZMoYPrV8fjzMZtqyiSeDs/lHEuVPuBRXPaeIXQ9A7q/Latj66Spsbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KV8mpYCGY17cF11l3od/PSO+leZ0SQc9qrPSjRPMs1o=;
 b=wxZQwZgUZTA8+JKIvEfNd7jtYYEB//MXhORokCZ0jSaXwfum0jz6WxeGAIxxH0FqZ6ptb5bl1/ZmkzNKPKStfK2EnZgcwTHjbYcKckUM6A2Mx4dRvue93qcZIXuNwD9tbzNe/hvyAQNWAtAq8Y3dqcXkYHqfPBbRGG6YCZFAVyE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YQXPR01MB6170.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 17:33:39 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 17:33:39 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "radheys@xilinx.com" <radheys@xilinx.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "harinik@xilinx.com" <harinik@xilinx.com>
Subject: Re: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Thread-Topic: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Thread-Index: AQHYXBiAdPySYflEJ0exYZgZgYcAxK0PlYFNgAD+0AA=
Date:   Thu, 5 May 2022 17:33:39 +0000
Message-ID: <5376cbf00c18487b7b96d72396807ab195f53ddc.camel@calian.com>
References: <20220429222835.3641895-1-robert.hancock@calian.com>
         <SA1PR02MB856018755A47967B5842A4C4C7C19@SA1PR02MB8560.namprd02.prod.outlook.com>
         <20220504192028.2f7d10fb@kernel.org>
In-Reply-To: <20220504192028.2f7d10fb@kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78d09a35-f30e-4115-83cf-08da2ebd6434
x-ms-traffictypediagnostic: YQXPR01MB6170:EE_
x-microsoft-antispam-prvs: <YQXPR01MB61701B1A35E68A1C68BEC167ECC29@YQXPR01MB6170.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +8qGKiBmM8pABEaH4y9zLhJCyst3UXy4j6mLNyZpHLNEGjDR8vERtzt6dGLNd6z29evL0uLyuSJ/RGIHuNDO7K3rJJyC9nzw8KSzKGmX9C3hhyufd2cXcjBB9UfWi3CdpiP6Lf73gG5OsRiEgX6vjdasw9Yh9BKx311sX161rbHdORcA/v2n5r8kNBvMEYV+FbTQNBycW/wg/JeA6uPOdwOwc5aYX4AKMDKF6+kaxiZnt7agXWSNiXiLsg5q70gO/+0tiy7CmhdOOkacU7OAP0H5yu3LECRKckTCS4IWeJVfKUzG6/2LlURuPWDQVLBNtmJkRi8aOKsFMuYNbK/5b+7BBfvQYMn8bi8Bf42+ELMXp+2khfdKZdIvPgDYPR+5xZBT5k4bwrmW574O8ULIbhHyribHT4YdekMPNtroWn544l2JWXO1A65PMEEoeTdA8ou70GcswBjAeQylr52KGzL8ExNyNAlbnWTb/kZvcreiXpFf6OLgfuB+jlfXm7g87gGzjBKo2fcPHhHWlWWzDtLs2XedesJHrDdKDWpnqpcHB5uxSneYK9ns3Xi9UOtR7/Hc6mh/dmMjrZHlTrAGEIL5MnoO4gFjpT3MAPZ7832fRbumrGzPrrYQRqkrDaFcT0ARIiJfCS6fdiq1c6HfRZUOrcTkYsvVWzv+CG3aCRnSYWJSaEx/IR4zvtG8IFTMUAIZ1r4yXUKIObESrauvnd2AS80YaicclFqnfzUD8QWUlRfXIAsdvJorlB/7RGor+xFgPpTTxEM1sEf2i9B2VTVDjfReZeOlr041t4TMYt1bPhtE4V/QaAKkbHWM8GLMhAMYOcx6Eplhey1F7FYEAMoIUpMpYEIt1o/9L6ZBqi8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(6486002)(8936002)(508600001)(5660300002)(44832011)(36756003)(15974865002)(2906002)(76116006)(2616005)(26005)(186003)(66556008)(66446008)(64756008)(66476007)(86362001)(316002)(83380400001)(8676002)(4326008)(6506007)(54906003)(110136005)(6512007)(38070700005)(38100700002)(122000001)(66946007)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGxyQW0yb0x2TTgzdTJDTk1oWmpTUlJFWE9GNFcwS3hOU1U1SEZsaVQ0L0Ja?=
 =?utf-8?B?TTgzcTlkY0JOa0wweDd0aHN4dm5qUUpPcHA1Y1Z3MHRYY0ljVnE3eWt3ZGxs?=
 =?utf-8?B?d2JNSlRDcTFYZmhaZC9JK1RPYnIvSG5wc0RKZ0h6RERzZzZnV2p2L3lscU82?=
 =?utf-8?B?bWllNDMra3d6bGFGKzU4MUFCVU5XS1picVdqRHpxNEI3V2RydHlJY2d5RXlj?=
 =?utf-8?B?ZTNJVGo1NnowbGFxMkt4enVXTjNpNS9rZmd3RjNiaUtWSFNJMnQyNUxONWMw?=
 =?utf-8?B?a0R4aGljVFl6RThKQWJmbUNqK0N5MU1DK013aXF3NmhuNUJ2a3YzUDhNYVIv?=
 =?utf-8?B?andnWW54K0IvZUV6TmVPY0tWOUptNk92NTRJbXE4N0t4ZGVCcDAyQ2xrWS9P?=
 =?utf-8?B?bHdEdnhkbEJENFFYSXBBbmZLbmxTUjlONWsrZ2F1dytqbGFnQnJtT2VCWWVr?=
 =?utf-8?B?L2locVRZNE5CMmZBR05aTUkxRGgrQzFQMUY3Q29HNHp5OWMwbUMvUFEzOENs?=
 =?utf-8?B?eG5qQm9CbE0zL2thMVBqS3M2VnVRU2lBTFpON215T25XWERodUR1aEV3SXQr?=
 =?utf-8?B?NkIrSnIvU2lFK0NqZFR5MTgwT1piYkY2WlREbnJPWmtwVHZFT2s5ZlplN0Q4?=
 =?utf-8?B?dWQxUG9XdjVzSlRiTHBHMWRTNnNuZ0FRNithc0NudU1KSFlod0F3cGY0MnVk?=
 =?utf-8?B?NG5rNlNmcWRIRldjOGk2NnFkTTgzMXhiblBmRmszSjNMc0Y5YUV3Q2pWRnBR?=
 =?utf-8?B?ZWRQUzdDQ2V1bThraEcxZjF0QVc0V080bTJ6MTI0MldQZTlCVnkwaFk3UVhp?=
 =?utf-8?B?TllneFQvVzBJMzl5N043WXMyTGMrZDVDK1c4djB3YVF0TG8zZk5RSXRaWHl5?=
 =?utf-8?B?OHZ3ZlovRG5rRUk4ZmtRNUd0cjB0dUVremFRYmZxNnlDUTRSRTFWYTgrbUlz?=
 =?utf-8?B?ZURYMEVZK1Z0K2ZsZ2EzSHg2b1NiMXlxK2J4b2lacXhvRjNJN21oaHByWXNN?=
 =?utf-8?B?Vm9sTXB5V0VmSXZMVHI4dVp6VHR1b1V6TzNIVHZ4UmU4ZU9IVElLNURWY29p?=
 =?utf-8?B?MVI4OHBZSXJDMTJabmNxaWZ6WFVxOHl5VHIvYWEyK0FQczhraDlmdXVOOHVH?=
 =?utf-8?B?dnBXbkp0cm5NNzdkaktGQlpGQUxGNmRZak0wblUvSVNBUi96RTM5QjluTk1I?=
 =?utf-8?B?aTNrTG1UL09WSFpWNkMwc0phNHhLNW5Xd3RYdE5XeXp2RHhZL3NHbVJ6aTFG?=
 =?utf-8?B?UVZabCs2M0tKbG1nOEprZE9GeWVMeEZ5SnYyeEw4SEQ4anVCVXdaOFBJTmU3?=
 =?utf-8?B?ZW1zVTdtMXBPUWd1QVQwY3ZTMEtmWWRFamtQOEpBSCtPamZNSUVONnpObUdk?=
 =?utf-8?B?TUhsT1JFVGJRSjdZMHZKV25EOFVLclExb0RiYVV3MGF4K2N2Q2Y3VFVDL3hU?=
 =?utf-8?B?a2NMVU9RUTBlbXByY0dqMHdvWUFZd3BBUE1kRUQvRGhudStDRzV4VkswYlN4?=
 =?utf-8?B?U3RMU0ttUnNDdlpGS3B1bVozZ1VUN2U0QmpLVmZ5cXJUQ3FlUVBqZHlzZTV2?=
 =?utf-8?B?YmtwVUdiQy93WXYxcGlMd2dlUlFNbHZsSVJZaklVeks0MFZockU4QmQ3Z3V0?=
 =?utf-8?B?M2pVVW9JNENVR2k4L3VSQU5CMHpUN2V3Um9mbDRwR2ZaeVpnZUdCTmpBNGhz?=
 =?utf-8?B?cGJUZUxHdXJWVFM4MVJMUkVzTEQrYUNqVjlSRi9TTSsvYUJKTFVtUjllQnU4?=
 =?utf-8?B?NFV5YklOV3lrWFkxQjdzQWVtelRqbGdHNjh5YlFrQ010VlFYaVFVQjUxYlB2?=
 =?utf-8?B?QTEzMGRvdVZ1SjZLOElUV2RBQk5qZW1jRkVoMVZydXRpRmltZzU3ZUhIQ1NO?=
 =?utf-8?B?TnRsZ2lmbTFsVVNId1Byd0Y1Q01DYVhUVTgzTmMwSlNhNHJoTkRXclNuK2U3?=
 =?utf-8?B?MkZueCtYVDZiQ09HOFdreHZhTTVJQ0hNNmZBL0hFTzFXY29ubVVEMTVGSlpw?=
 =?utf-8?B?MTdqRWd1N1NpTzl0KzI3UUZhVjJvZmg0QXZJRjNock1NdmVGNm5uWnFWOHM3?=
 =?utf-8?B?MTBxcUxqQ1BMbzVuZXo0d3lmR2ZEV2U4RWJRRkMzc3JhSXBMSUZtRTFRMVdM?=
 =?utf-8?B?TXduclo5Y1MwSGxvRlNneElDN1RDdUhLWDVWMnZKUG9yN3lnSzFUcGxRK1ds?=
 =?utf-8?B?R1I0ODBWSmtPMTB6d2MvVy9QRzlOR3dZKzBpRm1PaHFMOUFBOS90ZkRiUUxp?=
 =?utf-8?B?NGNRNnN2MFV0N2lVR2hycUh3REJ6aUduSmppUXFJWTlacTNZY2hSbUEwd05w?=
 =?utf-8?B?Z1NSUkZLekhoWmhyN1k1OG1JT0VGVmRIYWgrR2xabmxhZ2ZpZk5ZeHBIOTVE?=
 =?utf-8?Q?UTJGacjk8Pa+cbm8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F598C5D7953AD4A83242B3AE0B6E9F0@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d09a35-f30e-4115-83cf-08da2ebd6434
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 17:33:39.0581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ijLxvmtDe4OlFLkTZ3U8mLWuo8MJV7vrR3FAa1mjvV5LFG3HwrCaGriXvAH3OzFgGq+WumxtUoDH2svGeONm4xkA5R5vxK0wmPU5P3axdMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB6170
X-Proofpoint-ORIG-GUID: wuZmd0TTZsI0G2-WeCcfm3YakBJlGR0f
X-Proofpoint-GUID: wuZmd0TTZsI0G2-WeCcfm3YakBJlGR0f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_06,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 spamscore=0 mlxscore=0 mlxlogscore=418
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050119
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTA1LTA0IGF0IDE5OjIwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAyIE1heSAyMDIyIDE5OjMwOjUxICswMDAwIFJhZGhleSBTaHlhbSBQYW5kZXkg
d3JvdGU6DQo+ID4gPiBUaGlzIGRyaXZlciB3YXMgdXNpbmcgdGhlIFRYIElSUSBoYW5kbGVyIHRv
IHBlcmZvcm0gYWxsIFRYIGNvbXBsZXRpb24NCj4gPiA+IHRhc2tzLiBVbmRlciBoZWF2eSBUWCBu
ZXR3b3JrIGxvYWQsIHRoaXMgY2FuIGNhdXNlIHNpZ25pZmljYW50IGlycXMtb2ZmDQo+ID4gPiBs
YXRlbmNpZXMgKGZvdW5kIHRvIGJlIGluIHRoZSBodW5kcmVkcyBvZiBtaWNyb3NlY29uZHMgdXNp
bmcgZnRyYWNlKS4NCj4gPiA+IFRoaXMgY2FuIGNhdXNlIG90aGVyIGlzc3Vlcywgc3VjaCBhcyBv
dmVycnVubmluZyBzZXJpYWwgVUFSVCBGSUZPcyB3aGVuDQo+ID4gPiB1c2luZyBoaWdoIGJhdWQg
cmF0ZXMgd2l0aCBsaW1pdGVkIFVBUlQgRklGTyBzaXplcy4NCj4gPiA+IA0KPiA+ID4gU3dpdGNo
IHRvIHVzaW5nIHRoZSBOQVBJIHBvbGwgaGFuZGxlciB0byBwZXJmb3JtIHRoZSBUWCBjb21wbGV0
aW9uIHdvcmsNCj4gPiA+IHRvIGdldCB0aGlzIG91dCBvZiBoYXJkIElSUSBjb250ZXh0IGFuZCBh
dm9pZCB0aGUgSVJRIGxhdGVuY3kgaW1wYWN0LiAgDQo+ID4gDQo+ID4gVGhhbmtzIGZvciB0aGUg
cGF0Y2guIEkgYXNzdW1lIGZvciBzaW11bGF0aW5nIGhlYXZ5IG5ldHdvcmsgbG9hZCB3ZQ0KPiA+
IGFyZSB1c2luZyBuZXRwZXJmL2lwZXJmLiBEbyB3ZSBoYXZlIHNvbWUgZGV0YWlscyBvbiB0aGUg
YmVuY2htYXJrDQo+ID4gYmVmb3JlIGFuZCBhZnRlciBhZGRpbmcgVFggTkFQST8gSSB3YW50IHRv
IHNlZSB0aGUgaW1wYWN0IG9uDQo+ID4gdGhyb3VnaHB1dC4NCj4gDQo+IFNlZW1zIGxpa2UgYSBy
ZWFzb25hYmxlIGFzaywgbGV0J3MgZ2V0IHRoZSBwYXRjaCByZXBvc3RlZCANCj4gd2l0aCB0aGUg
bnVtYmVycyBpbiB0aGUgY29tbWl0IG1lc3NhZ2UuDQoNCkRpZG4ndCBtZWFuIHRvIGlnbm9yZSB0
aGF0IHJlcXVlc3QsIGxvb2tzIGxpa2UgSSBkaWRuJ3QgZ2V0IFJhZGhleSdzIGVtYWlsDQpkaXJl
Y3RseSwgb2RkLg0KDQpJIGRpZCBhIHRlc3Qgd2l0aCBpcGVyZjMgZnJvbSB0aGUgYm9hcmQgKFhp
bGlueCBNUFNvQyBaVTlFRyBwbGF0Zm9ybSkgY29ubmVjdGVkDQp0byBhIExpbnV4IFBDIHZpYSBh
IHN3aXRjaCBhdCAxRyBsaW5rIHNwZWVkLiBXaXRoIFRYIE5BUEkgaW4gcGxhY2UgSSBzYXcgYWJv
dXQNCjk0MiBNYnBzIGZvciBUWCByYXRlLCB3aXRoIHRoZSBwcmV2aW91cyBjb2RlIEkgc2F3IDk0
MSBNYnBzLiBSWCBzcGVlZCB3YXMgYWxzbw0KdW5jaGFuZ2VkIGF0IDk0MSBNYnBzLiBTbyBubyBy
ZWFsIHNpZ25pZmljYW50IGNoYW5nZSBlaXRoZXIgd2F5LiBJIGNhbiBzcGluDQphbm90aGVyIHZl
cnNpb24gb2YgdGhlIHBhdGNoIHRoYXQgaW5jbHVkZXMgdGhlc2UgbnVtYmVycy4NCg0KLS0gDQpS
b2JlcnQgSGFuY29jaw0KU2VuaW9yIEhhcmR3YXJlIERlc2lnbmVyLCBDYWxpYW4gQWR2YW5jZWQg
VGVjaG5vbG9naWVzDQp3d3cuY2FsaWFuLmNvbQ0K
