Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B83F4CC29B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 17:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiCCQ0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 11:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiCCQ0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 11:26:01 -0500
X-Greylist: delayed 1405 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Mar 2022 08:25:14 PST
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CB549900;
        Thu,  3 Mar 2022 08:25:14 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 223DxU9j013232;
        Thu, 3 Mar 2022 11:01:34 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ejy1xr37q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 11:01:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A34aiw9sazFVMt4foXYn2GAzBadMzSiKUv4D/wvDGoF5qtwyu9GOU9jnvyXL75Bu4TQw2+7LBgXTZjDxpPFAPO1kbKvYtVu5N7s4ui+kmMzqoHA1wNsffulMIrG9OtwkNDRl4VuofIC2SXrD3uzzMgjayESRmGWB6OR84WdWvMi3cXEXcPyiEIgfaDhwhTnUocMYOaX5geCljNNMckX0WbPJnvFSkZPZtu1Pd8ZZPgTsVUrI2MBKH272bOnpIqkyZmXrma3ynHitthECKXr+gyYafWaeGqyTIjC3WRxRJmNDfEkNUOGzCp1uE3hSflNJPhoHopHwWkiI1r6eI3EgyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRO7m+6f4246by8D6l3aUP9woUe8Aj0UxyKjtXB9Keo=;
 b=WV1B8ZI3B0TpGpipEjdYXqxxyNv8WEae8ClXMO//3mkTha6DICIMQs5tMWFURGiMyJwZsNhdFUbCNufB1EN+Fx7tnxX8HWYVMkzEqOZNIwQiwZD+yFhIdcnM8xK7WE5lspajQqYgR18lLCsvIZq4u8r+O8upm5xYuCiZf2V3HXH5hMwLAPhGWe6DwGgRRzeDQBzha50MCckJbdGtQCt6vYLjqD2lU9z6suCHkP6qWcR/bafJh77Il1IeIC/Bj1mlUKm0D1g9+OocHuiPRIIT3cNvPjw0b96nAJiEFHrY34ElKrEy0ercyJXkzZHzX0uEYC7a4lntmHEXnvI3JBeDCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRO7m+6f4246by8D6l3aUP9woUe8Aj0UxyKjtXB9Keo=;
 b=MzRJ2O8/9ssrySxwpMddW0BsV7ogJ4QuJ8lI2BG0V7qPa4UD1Lf6IuEbXSjOddOdi1dJiO1a2IM31+sHPMzFJaXgN6GqM4d+j1kcXQ6zc4yvx1zVvYWIMY6y40HA4ZtK3/57pZJxkIQXJiuh4blT79olKJwiqTqxoV5c2c68whM=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB5471.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:63::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 16:01:32 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 16:01:32 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "soren.brinkmann@xilinx.com" <soren.brinkmann@xilinx.com>,
        "scott.mcnutt@siriusxm.com" <scott.mcnutt@siriusxm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH net] net: macb: Fix lost RX packet wakeup race in NAPI
 receive
Thread-Topic: [PATCH net] net: macb: Fix lost RX packet wakeup race in NAPI
 receive
Thread-Index: AQHYLNHO27PnU9X+TEKHHm/oWWSx3KytOYOAgACcvoA=
Date:   Thu, 3 Mar 2022 16:01:31 +0000
Message-ID: <2a70a890c19ea563559a6a50c6f4f538e032a02f.camel@calian.com>
References: <20220228183328.338143-1-robert.hancock@calian.com>
         <20220302224031.72fb62a9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220302224031.72fb62a9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c77ef88-22fb-4a29-cfc0-08d9fd2f15ca
x-ms-traffictypediagnostic: YT3PR01MB5471:EE_
x-microsoft-antispam-prvs: <YT3PR01MB54716A9EF9F3162DC416E99CEC049@YT3PR01MB5471.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 53oKSldiIOAIxrDDmci6E4W10yVfVEVxKVhh3DCOr5ylLPDXBTwg3cMzvB+I8LiUER6LONsYKwbD2+NLtIU3MzFeT3d4RjM1WVvoTC7TcUrG45qMcnAAH8G1yVrFss3mKkdbSmDkuuGPc6OS5x9Z0lf+pR9qM8QcSLvT0GV6cfexYjHgJ4T+RtPwc58itD+sbeArAaHwOBip/sIjwVzo4WR9b05OPp7kHOLMUB3d9S+ofTRw1x5gZpKUTaP2wE7p/JoBTzrT+GbxIKXUkXPX5OY3FXtkIG8Rdsm4ZyWkmyAf//fXXW3dBoj7HWJKsC1OgeP+TMUsfVPJpkZhuG0N2feHSO83qk+gMCfz/Z7de2PkJEG4hzgvxLM4tWRrM8twcqWMVkEEs41q0YfOlSh31wkyBu+iLn47gDto2xW6sNCRJvP5+ZjJryyzwuTfvC/U/XOXtVkTw7Mf1QVqkgqSPRn9sEYLZcBgfsVCfgrOJKr/61FKifvB3AfoWw3zW7nxtpfT+GbzZGL3peYUmMGsokPszu5UdCY/0CIIobGQQKNbqEYRNsLT2fyBlJMFL8pr7KSY+bLPw4X85FKP0DhPx2aQ4yY8lO6yymB+1hyVZFMePWUYkc0Zfp4c5+nvZ4utK3dyuns6YgszolFp1YfQ3gTDj2hTMuABW5EWJB6eQIQN6OLOnCYe87eM2dSB6MijcpYPhZmOotRZ2h9vj3ECcKEbGPpFtKhgWLjuvP9NziM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(4326008)(86362001)(2616005)(71200400001)(8676002)(6512007)(6506007)(122000001)(66946007)(76116006)(66446008)(64756008)(91956017)(66556008)(66476007)(5660300002)(54906003)(44832011)(316002)(8936002)(6916009)(6486002)(36756003)(83380400001)(38070700005)(38100700002)(508600001)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1BPMXBCQm4xVEc0TW5EdmluSWtHRmhTc1NRYnA5NnZYY3F3c0VYdWx4V3Fi?=
 =?utf-8?B?M2dTSlhLS2pQWWJOSmVISmtITlQ1ZTZLZm9vbVBySVUrNVFpM0RVd0M2NHh3?=
 =?utf-8?B?UGplbEwvc2k2MWtTRjVCWktJdjRuRGJZZC9KVGp1a01SaTZRL082VWJwQk1P?=
 =?utf-8?B?ZE5Nc1ZsS05KVUZaNzhwd0FNWjVwa1NreTkxR1loNkhNMVpobHVtV0R5WlRW?=
 =?utf-8?B?VTF1dTQ0QXR4YTdCSG9kcmN4bktpQ3hXUkhTcmcwMDRlcWhOWmJqd1FUYnZB?=
 =?utf-8?B?N0pISmFncGt5N1lDanYzUnQ1V0dFMFRsNHJrUEMydDN6Q2tjVXpZK2hPSFA4?=
 =?utf-8?B?WlVaeUtlcy9nRUxSMXVLemIvWGF3ZjBqUXBxZE1mSWNsWTFCUmxIb0E4UHJk?=
 =?utf-8?B?TC9mbVlWelptdjFwSkJNL3BOYUJWR2hCSVBsZWJTQWhPMGRnSXY1SHdjOVpN?=
 =?utf-8?B?M2tMNWZwQ3RYYTdoZENDSVpDeXIvcHY0OUpsRnY5Y254QkJPNVBPam1xdlhJ?=
 =?utf-8?B?VlhRdXBMTFhTaEJWNW05THZla0NMNVEraExER2JaaGhsRWxSZG9qbTlnNXgw?=
 =?utf-8?B?ak1hdUFEMmlJSW1oZlYxckRTOEpFTGc3dFhsVG9EMUxVelZBUVoxMkE1Z1Rn?=
 =?utf-8?B?TlY3T3BOYU5YRnBNQzRXMkZpeDJoYy8vTnJSdVYvV3VFRXhQYmVUdU1tU09V?=
 =?utf-8?B?Y1VFekVTRGx5cWY2NXVFT0dRT3JFTFVFYWlrN2c0YzBNTGY0SGpKekJSR2hF?=
 =?utf-8?B?em83TnlydTFISjQrV01vb282cEpVZFBSSE9Ib0pIczNvS1FzOUIvaW5OUVl6?=
 =?utf-8?B?bEV6R2ZSWGhVRUN2SUwyQndheXBVaGdaMlhsSTcxMSt3a2pibC9vTEF0TWJ4?=
 =?utf-8?B?TzR4YzlYTGk1KzJsZDdvbHF1R0FKNFhpTVZzSW9Oc0ZmQytFRG9hc2g1NUVI?=
 =?utf-8?B?MjBLRmlmcmhuMU1heEx6RjJobnFreVB0TVhoa0E2Uk9aUnNaeTdCb05EOWdl?=
 =?utf-8?B?QWtGUUVBSmVXTmxxOUMybnlOOUp4cG5WWmNEUXl5eWdTNmRlR0ltNnpkbjVZ?=
 =?utf-8?B?Wk1PNHo5ZGx5RVV0aG0rR2pISlBKajdaS2ZUV2t6endxMlRwZU52dHFUdFU3?=
 =?utf-8?B?c2c5VnUwOUt0MjhGaVpvaTc0cm5vVGU2NW1mSmtaV3IraHZ1dU90cE9nSmIv?=
 =?utf-8?B?SjhHVFBWaStHMmlYUVZic3FEb0NubVh2V3VQMVRPeW8rV0plNkVEQTI4WjUr?=
 =?utf-8?B?eS96bms5OFdtRHZBTzdOV20wcHJWSGM2cTF1akFRSjFQTE1DQUlPQjBMVWlI?=
 =?utf-8?B?OWY5bkVkM1NQWFo5TVNUNDdHQ0FMQ3NEYlpJaWQwdDRnaC84cjlrZ0pRMXdD?=
 =?utf-8?B?bVh4SW96ZW1IbDJhczlDY1IzWWZhbzZZVHp1Z0pWWWQvdUFjc3FNOTlySTNT?=
 =?utf-8?B?NE95aG1RR0hDN2Vtak1lbjFXVFMwMkdvYkZWT1E4TW1PYzZBTU5EV3VLNXNT?=
 =?utf-8?B?SEc4aGdQd3EyWW0rZTZWV1JITENJVTExUFdSYk0zWitQRTZSYmFpM0VpWmQw?=
 =?utf-8?B?b2F6ZDM3VTVudUIxeVRjMThjTTg3NUF2VWR4Z0paOUlUcUZDUngwMldNN0FL?=
 =?utf-8?B?RW45ZzhqNm9aQ29VNWNwUmlJL3BST2pTaENid3BWaEd3TFhMTUYzVzVkbnM2?=
 =?utf-8?B?MS9FN1Jsc1J4RExKcWUvcGlWM3JZa0tIVWhoT3ZQQjFhUVN5bG4xN1ZxMHli?=
 =?utf-8?B?ZnVkUS8xTzkzU3VRWVVYbm12Zlp5bThuWkRKY1V2Qkl2MC9PcXJWNjVMYXBm?=
 =?utf-8?B?ZHlXOVFwOGpTSVhxMzgyMVlmZk1WWXlnTGV4Mm9yNy9tNXhxTWJLdzFjVGVs?=
 =?utf-8?B?RlFDMlQzQ1Q3Q1o0bHVZbnhWWXpWNGwwKzJ0RHd3Z0tvNVNLV2NjRTB1WTJT?=
 =?utf-8?B?YWRtMHlsbzhEQi9COGp1aFVlZGw2dFhPRmwvRXFrTEZ6Zm5lOEV4bUpFd2RT?=
 =?utf-8?B?bnZMN3lsZzBHMDY2L3A3SnQ5QUNBbWdZdGh0a2VNTWhBTlBTUXhQVElub2Zk?=
 =?utf-8?B?bVJkWXUrSmFQeTQ0cHlmbDBGN01LdTc0c2FISlBaYzZZNXNZRUdNL0FZODFP?=
 =?utf-8?B?QWJJL2pnSFFzdXVURXZDaWYxVHQrRVI1SlBPcFBtK0x2dmhRNVFoakxUTUVt?=
 =?utf-8?B?ams4YVJVb1lNYTlRNGxOenFES0g0b3RyNngya3diY2Y0ZVV1Y0F6K1k2NDdz?=
 =?utf-8?Q?nfVvIyYgWq/LyvEcZhZGx4DwkwAu/RtkH+tBJW4FNQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07BAEB497AC8514180C5B10503180623@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c77ef88-22fb-4a29-cfc0-08d9fd2f15ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2022 16:01:31.9601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xgPoOSDwZmRWLIYSrpRakgsaXYQjuj1biYwcXuh7g+5YLOGG9H/xsD9LM+mMez4DTPMX9YYS4Sc43rmevg1lt75pAxu6STtbU6ycg5Jth9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5471
X-Proofpoint-GUID: kAEx6zzv17coq41lhS_PoaJZhzmTTPMs
X-Proofpoint-ORIG-GUID: kAEx6zzv17coq41lhS_PoaJZhzmTTPMs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_07,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030077
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAzLTAyIGF0IDIyOjQwIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAyOCBGZWIgMjAyMiAxMjozMzoyOCAtMDYwMCBSb2JlcnQgSGFuY29jayB3cm90
ZToNCj4gPiBUaGVyZSBpcyBhbiBvZGRpdHkgaW4gdGhlIHdheSB0aGUgUlNSIHJlZ2lzdGVyIGZs
YWdzIHByb3BhZ2F0ZSB0byB0aGUNCj4gPiBJU1IgcmVnaXN0ZXIgKGFuZCB0aGUgYWN0dWFsIGlu
dGVycnVwdCBvdXRwdXQpIG9uIHRoaXMgaGFyZHdhcmU6IGl0DQo+ID4gYXBwZWFycyB0aGF0IFJT
UiByZWdpc3RlciBiaXRzIG9ubHkgcmVzdWx0IGluIElTUiBiZWluZyBhc3NlcnRlZCBpZiB0aGUN
Cj4gPiBpbnRlcnJ1cHQgd2FzIGFjdHVhbGx5IGVuYWJsZWQgYXQgdGhlIHRpbWUsIHNvIGVuYWJs
aW5nIGludGVycnVwdHMgd2l0aA0KPiA+IFJTUiBiaXRzIGFscmVhZHkgc2V0IGRvZXNuJ3QgdHJp
Z2dlciBhbiBpbnRlcnJ1cHQgdG8gYmUgcmFpc2VkLiBUaGVyZQ0KPiA+IHdhcyBhbHJlYWR5IGEg
cGFydGlhbCBmaXggZm9yIHRoaXMgcmFjZSBpbiB0aGUgbWFjYl9wb2xsIGZ1bmN0aW9uIHdoZXJl
DQo+ID4gaXQgY2hlY2tlZCBmb3IgUlNSIGJpdHMgYmVpbmcgc2V0IGFuZCByZS10cmlnZ2VyZWQg
TkFQSSByZWNlaXZlLg0KPiA+IEhvd2V2ZXIsIHRoZXJlIHdhcyBhIHN0aWxsIGEgcmFjZSB3aW5k
b3cgYmV0d2VlbiBjaGVja2luZyBSU1IgYW5kDQo+ID4gYWN0dWFsbHkgZW5hYmxpbmcgaW50ZXJy
dXB0cywgd2hlcmUgYSBsb3N0IHdha2V1cCBjb3VsZCBoYXBwZW4uIEl0J3MNCj4gPiBuZWNlc3Nh
cnkgdG8gY2hlY2sgYWdhaW4gYWZ0ZXIgZW5hYmxpbmcgaW50ZXJydXB0cyB0byBzZWUgaWYgUlNS
IHdhcyBzZXQNCj4gPiBqdXN0IHByaW9yIHRvIHRoZSBpbnRlcnJ1cHQgYmVpbmcgZW5hYmxlZCwg
YW5kIHJlLXRyaWdnZXIgcmVjZWl2ZSBpbiB0aGF0DQo+ID4gY2FzZS4NCj4gPiANCj4gPiBUaGlz
IGlzc3VlIHdhcyBub3RpY2VkIGluIGEgcG9pbnQtdG8tcG9pbnQgVURQIHJlcXVlc3QtcmVzcG9u
c2UgcHJvdG9jb2wNCj4gPiB3aGljaCBwZXJpb2RpY2FsbHkgc2F3IHRpbWVvdXRzIG9yIGFibm9y
bWFsbHkgaGlnaCByZXNwb25zZSB0aW1lcyBkdWUgdG8NCj4gPiByZWNlaXZlZCBwYWNrZXRzIG5v
dCBiZWluZyBwcm9jZXNzZWQgaW4gYSB0aW1lbHkgZmFzaGlvbi4gSW4gbWFueQ0KPiA+IGFwcGxp
Y2F0aW9ucywgbW9yZSBwYWNrZXRzIGFycml2aW5nLCBpbmNsdWRpbmcgVENQIHJldHJhbnNtaXNz
aW9ucywgd291bGQNCj4gPiBjYXVzZSB0aGUgb3JpZ2luYWwgcGFja2V0IHRvIGJlIHByb2Nlc3Nl
ZCwgdGh1cyBtYXNraW5nIHRoZSBpc3N1ZS4NCj4gPiANCj4gPiBBbHNvIGNoYW5nZSBmcm9tIHVz
aW5nIG5hcGlfcmVzY2hlZHVsZSB0byBuYXBpX3NjaGVkdWxlLCBhcyB0aGUgb25seQ0KPiA+IGRp
ZmZlcmVuY2UgaXMgdGhlIHByZXNlbmNlIG9mIGEgcmV0dXJuIHZhbHVlIHdoaWNoIHdhc24ndCB1
c2VkIGhlcmUNCj4gPiBhbnl3YXkuDQo+IA0KPiBMZXQncyBsZWF2ZSB0aGF0IG91dCBmcm9tIHRo
aXMgcGFydGljdWxhciBwYXRjaCAtIGZpeGVzIHNob3VsZCBiZQ0KPiBtaW5pbWFsLCB0aGlzIHNv
dW5kcyBsaWtlIGNsZWFudXAuDQoNCkNhbiBkby4NCg0KPiANCj4gPiBGaXhlczogMDJmN2EzNGYz
NGUzICgibmV0OiBtYWNiOiBSZS1lbmFibGUgUlggaW50ZXJydXB0IG9ubHkgd2hlbiBSWCBpcw0K
PiA+IGRvbmUiKQ0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gQ28tZGV2ZWxv
cGVkLWJ5OiBTY290dCBNY051dHQgPHNjb3R0Lm1jbnV0dEBzaXJpdXN4bS5jb20+DQo+ID4gU2ln
bmVkLW9mZi1ieTogU2NvdHQgTWNOdXR0IDxzY290dC5tY251dHRAc2lyaXVzeG0uY29tPg0KPiA+
IFNpZ25lZC1vZmYtYnk6IFJvYmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29ja0BjYWxpYW4uY29t
Pg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5j
IHwgMjYgKysrKysrKysrKysrKysrKysrKysrKy0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyNCBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ID4gaW5kZXggOTg0OThhNzZhZTE2Li4zMzg2
NjBmZTFkOTMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9t
YWNiX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9t
YWluLmMNCj4gPiBAQCAtMTU3MywxNCArMTU3MywzNiBAQCBzdGF0aWMgaW50IG1hY2JfcG9sbChz
dHJ1Y3QgbmFwaV9zdHJ1Y3QgKm5hcGksIGludA0KPiA+IGJ1ZGdldCkNCj4gPiAgCWlmICh3b3Jr
X2RvbmUgPCBidWRnZXQpIHsNCj4gPiAgCQluYXBpX2NvbXBsZXRlX2RvbmUobmFwaSwgd29ya19k
b25lKTsNCj4gPiAgDQo+ID4gLQkJLyogUGFja2V0cyByZWNlaXZlZCB3aGlsZSBpbnRlcnJ1cHRz
IHdlcmUgZGlzYWJsZWQgKi8NCj4gPiArCQkvKiBSU1IgYml0cyBvbmx5IHNlZW0gdG8gcHJvcGFn
YXRlIHRvIHJhaXNlIGludGVycnVwdHMgd2hlbg0KPiA+ICsJCSAqIGludGVycnVwdHMgYXJlIGVu
YWJsZWQgYXQgdGhlIHRpbWUsIHNvIGlmIGJpdHMgYXJlIGFscmVhZHkNCj4gPiArCQkgKiBzZXQg
ZHVlIHRvIHBhY2tldHMgcmVjZWl2ZWQgd2hpbGUgaW50ZXJydXB0cyB3ZXJlIGRpc2FibGVkLA0K
PiA+ICsJCSAqIHRoZXkgd2lsbCBub3QgY2F1c2UgYW5vdGhlciBpbnRlcnJ1cHQgdG8gYmUgZ2Vu
ZXJhdGVkIHdoZW4NCj4gPiArCQkgKiBpbnRlcnJ1cHRzIGFyZSByZS1lbmFibGVkLg0KPiA+ICsJ
CSAqIENoZWNrIGZvciB0aGlzIGNhc2UgaGVyZS4NCj4gPiArCQkgKi8NCj4gPiAgCQlzdGF0dXMg
PSBtYWNiX3JlYWRsKGJwLCBSU1IpOw0KPiANCj4gV2hpY2ggY2FzZSBpcyBtb3JlIGxpa2VseSAt
IHN0YXR1cyA9PSAwIG9yICE9IDA/DQo+IA0KPiBCZWNhdXNlIE1NSU8gcmVhZHMgYXJlIHVzdWFs
bHkgZXhwZW5zaXZlIHNvIGlmIHN0YXR1cyBpcyBsaWtlbHkgDQo+IHRvIGJlIHplcm8geW91ciBv
dGhlciBzdWdnZXN0aW9uIGNvdWxkIGJlIGxvd2VyIG92ZXJoZWFkLg0KPiBJdCdkIGJlIGdvb2Qg
dG8gbWVudGlvbiB0aGlzIGV4cGVjdGF0aW9uIGluIHRoZSBjb21taXQgbWVzc2FnZSANCj4gb3Ig
Y29tbWVudCBoZXJlLg0KDQpUaGVyZSB3YXMgc29tZSBtZWFzdXJlbWVudCBkb25lIG9uIHRoaXMg
dGhhdCBtb3RpdmF0ZWQgYSBwcmV2aW91cyBwYXRjaCBpbiB0aGlzDQphcmVhOg0KDQpjb21taXQg
NTA0YWQ5OGRmM2E2YjAyN2NlOTk3Y2E4ZjYyMGU5NDljYWZiMTUxZg0KQXV0aG9yOiBTb3JlbiBC
cmlua21hbm4gPHNvcmVuLmJyaW5rbWFubkB4aWxpbnguY29tPg0KRGF0ZTogICBTdW4gTWF5IDQg
MTU6NDM6MDEgMjAxNCAtMDcwMA0KDQogICAgbmV0OiBtYWNiOiBSZW1vdmUgJ3VubGlrZWx5JyBv
cHRpbWl6YXRpb24NCiAgICANCiAgICBDb3ZlcmFnZSBkYXRhIHN1Z2dlc3RzIHRoYXQgdGhlIHVu
bGlrZWx5IGNhc2Ugb2YgcmVjZWl2aW5nIGRhdGEgd2hpbGUNCiAgICB0aGUgcmVjZWl2ZSBoYW5k
bGVyIGlzIHJ1bm5pbmcgbWF5IG5vdCBiZSB0aGF0IHVubGlrZWx5Lg0KICAgIENvdmVyYWdlIGRh
dGEgYWZ0ZXIgcnVubmluZyBpcGVyZiBmb3IgYSB3aGlsZToNCiAgICAgICAgOTEzMjA6ICA4OTE6
ICAgICAgICB3b3JrX2RvbmUgPSBicC0+bWFjYmdlbV9vcHMubW9nX3J4KGJwLCBidWRnZXQpOw0K
ICAgICAgICA5MTMyMDogIDg5MjogICAgICAgIGlmICh3b3JrX2RvbmUgPCBidWRnZXQpIHsNCiAg
ICAgICAgIDIzNjI6ICA4OTM6ICAgICAgICAgICAgICAgIG5hcGlfY29tcGxldGUobmFwaSk7DQog
ICAgICAgICAgICAtOiAgODk0Og0KICAgICAgICAgICAgLTogIDg5NTogICAgICAgICAgICAgICAg
LyogUGFja2V0cyByZWNlaXZlZCB3aGlsZSBpbnRlcnJ1cHRzIHdlcmUNCmRpc2FibGVkICovDQog
ICAgICAgICA0NzI0OiAgODk2OiAgICAgICAgICAgICAgICBzdGF0dXMgPSBtYWNiX3JlYWRsKGJw
LCBSU1IpOw0KICAgICAgICAgMjM2MjogIDg5NzogICAgICAgICAgICAgICAgaWYgKHVubGlrZWx5
KHN0YXR1cykpIHsNCiAgICAgICAgICA3NjI6ICA4OTg6ICAgICAgICAgICAgICAgICAgICAgICAg
aWYgKGJwLT5jYXBzICYNCk1BQ0JfQ0FQU19JU1JfQ0xFQVJfT05fV1JJVEUpDQogICAgICAgICAg
NzYyOiAgODk5OiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbWFjYl93cml0ZWwoYnAs
IElTUiwNCk1BQ0JfQklUKFJDT01QKSk7DQogICAgICAgICAgICAtOiAgOTAwOiAgICAgICAgICAg
ICAgICAgICAgICAgIG5hcGlfcmVzY2hlZHVsZShuYXBpKTsNCiAgICAgICAgICAgIC06ICA5MDE6
ICAgICAgICAgICAgICAgIH0gZWxzZSB7DQogICAgICAgICAxNjAwOiAgOTAyOiAgICAgICAgICAg
ICAgICAgICAgICAgIG1hY2Jfd3JpdGVsKGJwLCBJRVIsDQpNQUNCX1JYX0lOVF9GTEFHUyk7DQog
ICAgICAgICAgICAtOiAgOTAzOiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICAtOiAgOTA0
OiAgICAgICAgfQ0KICAgIA0KICAgIFNpZ25lZC1vZmYtYnk6IFNvcmVuIEJyaW5rbWFubiA8c29y
ZW4uYnJpbmttYW5uQHhpbGlueC5jb20+DQogICAgU2lnbmVkLW9mZi1ieTogRGF2aWQgUy4gTWls
bGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KDQpTbyBpdCBsb29rcyBsaWtlIHRoZSBub24temVy
byBzdGF0dXMgY2FzZSB3YXMgYmVpbmcgaGl0IHJvdWdobHkgMS8zIG9mIHRoZQ0KdGltZSwgYXQg
bGVhc3QgdW5kZXIgdGhhdCBwYXJ0aWN1bGFyIHdvcmtsb2FkLiBJdCBtYXkgZGVwZW5kIGhlYXZp
bHkgb24NCndvcmtsb2FkIGV0Yy4gYnV0IGRvZXNuJ3Qgc2VlbSB0byBiZSBjbGVhci1jdXQgdG8g
b3B0aW1pemUgb25lIHdheSBvciB0aGUNCm90aGVyLg0KDQpGb3IgdGhlIG5ldyAiZG91YmxlIGNo
ZWNrIiBicmFuY2gsIGZyb20gYWRkaW5nIGRlYnVnIGluLCBpdCBhcHBlYXJzIHRoYXQgb25lIGlz
DQpoaXQgb24gdGhlIG9yZGVyIG9mIGEgZmV3IGRvemVuIHRpbWVzIGEgZGF5IHVuZGVyIGNvbnN0
YW50IGxvYWQsIHNvIHRoZQ0KInVubGlrZWx5IiBzZWVtcyBhcHByb3ByaWF0ZSB0aGVyZS4NCg0K
PiANCj4gPiAgCQlpZiAoc3RhdHVzKSB7DQo+ID4gIAkJCWlmIChicC0+Y2FwcyAmIE1BQ0JfQ0FQ
U19JU1JfQ0xFQVJfT05fV1JJVEUpDQo+ID4gIAkJCQlxdWV1ZV93cml0ZWwocXVldWUsIElTUiwg
TUFDQl9CSVQoUkNPTVApKTsNCj4gPiAtCQkJbmFwaV9yZXNjaGVkdWxlKG5hcGkpOw0KPiA+ICsJ
CQluYXBpX3NjaGVkdWxlKG5hcGkpOw0KPiA+ICAJCX0gZWxzZSB7DQo+ID4gIAkJCXF1ZXVlX3dy
aXRlbChxdWV1ZSwgSUVSLCBicC0+cnhfaW50cl9tYXNrKTsNCj4gPiArDQo+ID4gKwkJCS8qIFBh
Y2tldHMgY291bGQgaGF2ZSBiZWVuIHJlY2VpdmVkIGluIHRoZSB3aW5kb3cNCj4gPiArCQkJICog
YmV0d2VlbiB0aGUgY2hlY2sgYWJvdmUgYW5kIHJlLWVuYWJsaW5nIGludGVycnVwdHMuDQo+ID4g
KwkJCSAqIFRoZXJlZm9yZSwgYSBkb3VibGUtY2hlY2sgaXMgcmVxdWlyZWQgdG8gYXZvaWQNCj4g
PiArCQkJICogbG9zaW5nIGEgd2FrZXVwLiBUaGlzIGNhbiBwb3RlbnRpYWxseSByYWNlIHdpdGgN
Cj4gPiArCQkJICogdGhlIGludGVycnVwdCBoYW5kbGVyIGRvaW5nIHRoZSBzYW1lIGFjdGlvbnMg
aWYgYW4NCj4gPiArCQkJICogaW50ZXJydXB0IGlzIHJhaXNlZCBqdXN0IGFmdGVyIGVuYWJsaW5n
IHRoZW0sIGJ1dA0KPiA+ICsJCQkgKiB0aGlzIHNob3VsZCBiZSBoYXJtbGVzcy4NCj4gPiArCQkJ
ICovDQo+ID4gKwkJCXN0YXR1cyA9IG1hY2JfcmVhZGwoYnAsIFJTUik7DQo+ID4gKwkJCWlmICh1
bmxpa2VseShzdGF0dXMpKSB7DQo+ID4gKwkJCQlxdWV1ZV93cml0ZWwocXVldWUsIElEUiwgYnAt
PnJ4X2ludHJfbWFzayk7DQo+ID4gKwkJCQlpZiAoYnAtPmNhcHMgJiBNQUNCX0NBUFNfSVNSX0NM
RUFSX09OX1dSSVRFKQ0KPiA+ICsJCQkJCXF1ZXVlX3dyaXRlbChxdWV1ZSwgSVNSLA0KPiA+IE1B
Q0JfQklUKFJDT01QKSk7DQo+ID4gKwkJCQluYXBpX3NjaGVkdWxlKG5hcGkpOw0KPiA+ICsJCQl9
DQo+ID4gIAkJfQ0KPiA+ICAJfQ0KPiA+ICANCg==
