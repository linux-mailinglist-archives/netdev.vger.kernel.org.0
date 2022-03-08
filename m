Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4FF4D231F
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 22:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350372AbiCHVPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 16:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbiCHVPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 16:15:18 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558BB43AD5
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 13:14:21 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 228Cv5lZ023619;
        Tue, 8 Mar 2022 16:13:46 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2056.outbound.protection.outlook.com [104.47.60.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3em5n7sjta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 16:13:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1GVnFTyRC5+qyQPw7gAIm3Mdo3DhqdFAO1GWTZ2On05Djj2COTz9f6yYv/mPALrkwsw4gkciKEavtWkh5gahyzmoeErEN5nB3SzFa8JjPTiDEQjv++6g7MaCW+afTKPYZxyfNdkMDYZAEfo1WHy8zfZeYTJY3vDPEpW1LROBuQ6MP46Miqs8w0AK1ay6t7vD+Hhx3kQgkM5a6kYtSDVTwJhz9WXRYTPubp7qZNWjA9URFQLd58oTRq1k9/X+q80hFP+X13fWsR1XK1mlf+nffuipcVW14mC4qJr3rBC9STWZCvMfp5pF7N8aoXMAwitCFPWFTzTTKXSlH/e5IR8mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzKQH5pceirJdc2fEOUql/bjVM7+/uLH5DAFhY0bJ+4=;
 b=YOONZDS5bwbUC5+2xuxClgMXKlpli3ShBz37kjbs02nUgdSSig80vQN/+NyNkOYtPV5k+mboo+buVcfJXyswVMc9UdF+9nQwCzd5CGv8WCBxdanX7drvtcqWfj0gY8YAZPQY39n30Fi+ctP2Lo9WfMdTd5OTl/VSP6mlZoG8bv4w2FKv/9TcOkwSdnsf0TWS/ElkXlvkeD5KmJxTIVFdhwhRiIj0WkAujGWD0n1M5OGUalp21ssMXcljwMNxtY448YcaRi0WcAd11k9rNwZ4rDg89Ws2/ARNnGCoc4FNKPlH346ewjU/wUv3nTeF8Wn4pf00S1WFMztw9RsmeA6r+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzKQH5pceirJdc2fEOUql/bjVM7+/uLH5DAFhY0bJ+4=;
 b=Eg9kxQgv9wgdHqVNC+7LHRqTEteqRkTmjieHTXXCV/1FiXrrmUXal2PKKRUtHwtavd25E6K1ZRyOrUjkXL53zAEJmgl8E+oIVCtXgFHNHJffzrseObw5IDvSBYQ8Mqcvdd8zjpXhEawLXXtTdUs7ANitezZFiyzJKx6GOqyA53E=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB6072.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:37::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 21:13:44 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 21:13:44 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jwiedmann.dev@gmail.com" <jwiedmann.dev@gmail.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v3 5/7] net: axienet: implement NAPI and GRO
 receive
Thread-Topic: [PATCH net-next v3 5/7] net: axienet: implement NAPI and GRO
 receive
Thread-Index: AQHYMDg3ppYDH240YECH7eUdfzNO16yzf8wAgAKCjAA=
Date:   Tue, 8 Mar 2022 21:13:44 +0000
Message-ID: <4b43c54d38e60c1995501ee9a0eb84fb80fb0944.camel@calian.com>
References: <20220305022443.2708763-1-robert.hancock@calian.com>
         <20220305022443.2708763-6-robert.hancock@calian.com>
         <2013d6c1-cba7-03f2-7b56-1ab47656c928@gmail.com>
In-Reply-To: <2013d6c1-cba7-03f2-7b56-1ab47656c928@gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98cbf3d5-58f4-4075-3cc5-08da01488753
x-ms-traffictypediagnostic: YQBPR0101MB6072:EE_
x-microsoft-antispam-prvs: <YQBPR0101MB6072F8DFCD64B1BAB82CA6B2EC099@YQBPR0101MB6072.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LqPa5FPTNCJCUo4guPyi8uwX0OGzrjbByg9YNobLoUzUXwif4IQ6W8j0YciZ97CgQHF9tPcSB/MRddvFu7QIoMTpslU3jR8Ifxg+8arVP7w8YqjeMLVMZnRI6XbQ8B8pnXwOXXCdJe2JEpJrk7Omr8POFv6e6azspgZvt83RHvCbC4pupuXDhPQiqIAfQGIb3SI4hWOdVdxv+4QOC9AennzTDJX6s+6L6MFAwT6jb0RI6YZ3EUcuWI/g+vg4MdAe7Fdx4zZFKRHsBwqutmBascXZHtBBBCpRGs5boypl3pw8pDMGqF/ihQ5F8JoOf6B02UEefSYTEAXI10sHlQZAz2O97gO6y0n+Xm9ZoxectDifxmWNcOkqZpJKaqfRC7PHeoCZknXrOq+RNkqi3BHtXv/SR/mjf0XySUkqog8SdBSx4UuKPA74UvlokILobwwVVNAfdRHRBHMXtLIfja2e23q1lqoNi2ZLesTaGCU0X/ucGd4GluMOysEpPGlI05XJlwtrApBRDnOLIxzgGvU53hD2QGWTmMMwzULoFHfwQ+VT/+1v5X85X9ia4y3bs+H916fLqgh+sUC3S24qHg7b1wvvQ6U5lZJs+KRE40aX/3rwUBjHG3mEYnxoIvk0o1Wbn5iDG9x1XpQwa5RuYF0f9mJQha6rHP4KnZNoivTfjd6PG1lgLfbL0jzX0CL/Wn4OVlHR3tx41JlxpJmNypzXT1JjWmcHr9kQ/KUnyJtP7Ga5kw0G4z0CDm4htV8uL3PjW1TpS0HW0xK0/QLrbJdNIvOEScSoLGz0Pn7puPIhu6tTLd5Tp7TFj6oNjMcuBHKNIK0n8Q7wQntoTAW9RS6lcDIIpx+ZdK76kP1o3eM8Thg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(44832011)(66556008)(316002)(6512007)(5660300002)(8936002)(76116006)(54906003)(26005)(66476007)(110136005)(64756008)(66446008)(4326008)(508600001)(86362001)(122000001)(186003)(6486002)(8676002)(53546011)(36756003)(38100700002)(6506007)(71200400001)(2906002)(83380400001)(38070700005)(2616005)(15974865002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWpLTkNFN1Q1SkdRVnI0NTlHSGdveTYxczBrZjdhaXJrM1kxN04zQUt4STYz?=
 =?utf-8?B?TWxQczBiaysycGZwTHl1dmhYTVZWV0pmYnhieWllbSs4RWhaZGo0MW01K0Rj?=
 =?utf-8?B?M1VJWU1Ya25SYWdwN00wcUpFaFVYclByMVVjRzl1cndtSkdrQ2dRbndYZ0dz?=
 =?utf-8?B?Q2d5SWh0REdFNjZJVzJHTVgvclNHek1CMW4vdjFOQi9wV09QelFPeWYyN1hw?=
 =?utf-8?B?WURPTFJNUGZQdXpZQnpKT21sRGorQ1pwdmwxVjlCUjFPVjZrSkFxVWFhc2Nr?=
 =?utf-8?B?YldMQnpXVEJpYWdSODR4V1VCNWEvdUV5MXd0dFlpWldFRExvMW8vQldUTFJS?=
 =?utf-8?B?SUN6WDA0ekVRTyszZ0hsZ2xMSEhVbUpEazJ2eHEyUXUyaHF4QlFNSGZIeGhP?=
 =?utf-8?B?eWpWYzRBU3FBSWE5OHZsamgwMlhVU1JlOWNoTWNoUjVtejl0MWhrREpLQ0dT?=
 =?utf-8?B?MU00NnZxbllYYVZFVE5iNDFGZ0EyZ2ljR0diVWV1b2ZGR0xtOGJVZXVuY2Zl?=
 =?utf-8?B?ckc1bmxWWGtZcDhpZHZCR2JadzJ5cStzMVF6RFVoT3pIN0hzdDFpZEF4ZjVy?=
 =?utf-8?B?dXg3R2Jqd2g2SytpL2NabTBuem1USlp0d01PMFp1TjVTNUdPWlJqbDY4VDZ0?=
 =?utf-8?B?U0hMYmtQV3dXOGJhK3p2RnBTRy8vd1o5SHl6bVRIbXQ4UXFWdjZEaWI0VHkr?=
 =?utf-8?B?Lzdzdy9pOEpIczVwNVZ3M0NRMWxWZUFnY000SnJOeWFYUFRFcmlVczlzZnFB?=
 =?utf-8?B?OTI5YzI4YW9PVUx1UFBFajRNbG15L3IweXA3SUJpODhNbnlsbFJLazFJbU5o?=
 =?utf-8?B?ZUNLT3RnWTNheWVwNVViNCt0dER6YVFsd2tVSzN6ZmY3YVdITmJlSDMyZWJW?=
 =?utf-8?B?V002MWh2OE1HK0haaGVTem50eHFmalQyU0dBZlVmUy9zQ09VeVpBVW00b0dw?=
 =?utf-8?B?LzBCMnRYYTZ0OEVWZksyeDBwYnV5MDYxN3grL1R6a1Z5d0ZSMFlyOU50aEhw?=
 =?utf-8?B?cU1OZDR6QmovY1lhUXR1Q1JPN01JcVVHNHdFWHZmQWpNRW05UDFmeVZLdmo4?=
 =?utf-8?B?UUx4UnNSZXRLQnVWc1ArYXp3ek9VQzAzbVBESFVpeFdDbHZhZ0d4TmRGelZ4?=
 =?utf-8?B?UDQ3WDRiOVRHK09WQVhWR1hqTFd2UlJqaXBVVVhRU3RBUVI4Rm5Fa1Y0Z2Vm?=
 =?utf-8?B?SW1wcnBzUXB5QmFFbTFnYWxwRVMzU2Q5NTg1SDJzOHBpSHRxYWFxQzRWdXdI?=
 =?utf-8?B?eDZPRkNYUTZPODBFYW9ObnlqbVFUL3JUMjZwUjdwRDZCYURobmJSWTcrTThV?=
 =?utf-8?B?Q0Uwd3dISUpFVnNLZ1VyUHZSUndjdmxjSnFyUWpkRzlLa2liOS9veE93Q3NP?=
 =?utf-8?B?c2l4WDlGQXcvUEtkYVpqVEFRMDNubHdDMWxSdHhyTWdWK2c0cXpkakhhZkwx?=
 =?utf-8?B?MWVIRkUwYkw5dzROeEwxK0hRVXFFMk1tdStkTlA1Nzl4YUZLb0U2WHhYK2lU?=
 =?utf-8?B?OVIrak5BS2Jhd1ZTcHlwejBFMHBsa2tCYTA0MklCWWFSTmhmOGI3MmJuUHRq?=
 =?utf-8?B?SDBRUklGek1Qb24yVmFoYkNHSmZtTUFQMEwvTVNDWnZGQkNFQ1A4aDVwLy9Q?=
 =?utf-8?B?ZmpoYjhyYWNNZW43WGRXQjYrQ0R6by9SQk4zYVZJdU12amt2Q0Z3UDJpRnVm?=
 =?utf-8?B?ZXJGU2w3MTRiSkpmVkZ3NS9HRzJWdVdzejAxOTgrZnJUZW9UUXNyY3dpOCtm?=
 =?utf-8?B?Q3pJdzVMUGRHRHRtcDQ2Nk1GSGxrd2ZTZER3elNPUkxjbzRMZm9GejVLNThU?=
 =?utf-8?B?R1RaeXpjaXJIZlB6T2huTVBDdUM0cFVhTjVya3dxRnZ3TERscUFxNDJIc2w0?=
 =?utf-8?B?bG4zT3k1b1Jud3hISUFxNndzL2k3RHFxZVJvdC9sbzhWRk5xNXhQdUM5L3Jv?=
 =?utf-8?B?Q1BkRXQ0T1RpK01FT0kvKzA0WEZrbTNyRFlUOHgxWURtankzdzlLRkgrd002?=
 =?utf-8?B?SStQVGo1czFrRkxXR3h5UDVGdXV5bFdEWFJBeFRiYUY5YWtyajd6UFZxL1F5?=
 =?utf-8?B?ZFV5ak1raGk0WmVjUDFpWEZ1SitpYkhUOXZNTll5czlRQzBJMnk3VVBLaFJD?=
 =?utf-8?B?U2t4RTR6K1FPblNkQk9kQ1Qzb0ZITXg0Y1greWFQNHpQbGV4ZTRvYkVNUUc3?=
 =?utf-8?B?K3F5cDZaTlU5Ti9rcjZqQXo1QTRsYVNGYm8yYjRqVHBKTHVJUUdaQjhpYkFj?=
 =?utf-8?Q?Cl5wIsy3J3eIBkE3C0FrMp5lArbVl5noQGae2JhPZ4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C9230799F3CB64CA6F86F82ABBE3CF8@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 98cbf3d5-58f4-4075-3cc5-08da01488753
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 21:13:44.5061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WzXDaYUwSn5beDyz7WYS6UnNx0DslvFTFOG0r47ZRMInGMm9uu2sQeVsjpHyKFqtGcCN/IQ6ayp+fZ6cY8mCzaoQbtIw/f/58n1CCxk+WjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6072
X-Proofpoint-GUID: ZCPOxqQCSU7QwHDrYGNsw4W201-WfNXn
X-Proofpoint-ORIG-GUID: ZCPOxqQCSU7QwHDrYGNsw4W201-WfNXn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxscore=0 clxscore=1015 spamscore=0
 mlxlogscore=785 suspectscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203080108
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTAzLTA3IGF0IDA4OjUzICswMjAwLCBKdWxpYW4gV2llZG1hbm4gd3JvdGU6
DQo+IE9uIDA1LjAzLjIyIDA0OjI0LCBSb2JlcnQgSGFuY29jayB3cm90ZToNCj4gPiBJbXBsZW1l
bnQgTkFQSSBhbmQgR1JPIHJlY2VpdmUuIEluIGFkZGl0aW9uIHRvIGJldHRlciBwZXJmb3JtYW5j
ZSwgdGhpcw0KPiA+IGFsc28gYXZvaWRzIGhhbmRsaW5nIFJYIHBhY2tldHMgaW4gaGFyZCBJUlEg
Y29udGV4dCwgd2hpY2ggcmVkdWNlcyB0aGUNCj4gPiBJUlEgbGF0ZW5jeSBpbXBhY3QgdG8gb3Ro
ZXIgZGV2aWNlcy4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFuY29jayA8cm9i
ZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQveGlsaW54L3hpbGlueF9heGllbmV0LmggIHwgIDYgKysNCj4gPiAgLi4uL25ldC9ldGhlcm5l
dC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jIHwgODEgKysrKysrKysrKysrLS0tLS0tLQ0K
PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDU5IGluc2VydGlvbnMoKyksIDI4IGRlbGV0aW9ucygtKQ0K
PiA+IA0KPiANCj4gWy4uLl0NCj4gDQo+ID4gLXN0YXRpYyB2b2lkIGF4aWVuZXRfcmVjdihzdHJ1
Y3QgbmV0X2RldmljZSAqbmRldikNCj4gPiArc3RhdGljIGludCBheGllbmV0X3BvbGwoc3RydWN0
IG5hcGlfc3RydWN0ICpuYXBpLCBpbnQgYnVkZ2V0KQ0KPiA+ICB7DQo+ID4gIAl1MzIgbGVuZ3Ro
Ow0KPiA+ICAJdTMyIGNzdW1zdGF0dXM7DQo+ID4gIAl1MzIgc2l6ZSA9IDA7DQo+ID4gLQl1MzIg
cGFja2V0cyA9IDA7DQo+ID4gKwlpbnQgcGFja2V0cyA9IDA7DQo+ID4gIAlkbWFfYWRkcl90IHRh
aWxfcCA9IDA7DQo+ID4gLQlzdHJ1Y3QgYXhpZW5ldF9sb2NhbCAqbHAgPSBuZXRkZXZfcHJpdihu
ZGV2KTsNCj4gPiAtCXN0cnVjdCBza19idWZmICpza2IsICpuZXdfc2tiOw0KPiA+ICAJc3RydWN0
IGF4aWRtYV9iZCAqY3VyX3A7DQo+ID4gKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCAqbmV3X3NrYjsN
Cj4gPiArCXN0cnVjdCBheGllbmV0X2xvY2FsICpscCA9IGNvbnRhaW5lcl9vZihuYXBpLCBzdHJ1
Y3QgYXhpZW5ldF9sb2NhbCwNCj4gPiBuYXBpKTsNCj4gPiAgDQo+ID4gIAljdXJfcCA9ICZscC0+
cnhfYmRfdltscC0+cnhfYmRfY2ldOw0KPiA+ICANCj4gPiAtCXdoaWxlICgoY3VyX3AtPnN0YXR1
cyAmIFhBWElETUFfQkRfU1RTX0NPTVBMRVRFX01BU0spKSB7DQo+ID4gKwl3aGlsZSAocGFja2V0
cyA8IGJ1ZGdldCAmJiAoY3VyX3AtPnN0YXR1cyAmDQo+ID4gWEFYSURNQV9CRF9TVFNfQ09NUExF
VEVfTUFTSykpIHsNCj4gPiAgCQlkbWFfYWRkcl90IHBoeXM7DQo+ID4gIA0KPiA+ICAJCS8qIEVu
c3VyZSB3ZSBzZWUgY29tcGxldGUgZGVzY3JpcHRvciB1cGRhdGUgKi8NCj4gPiBAQCAtOTE4LDcg
KzkxNiw3IEBAIHN0YXRpYyB2b2lkIGF4aWVuZXRfcmVjdihzdHJ1Y3QgbmV0X2RldmljZSAqbmRl
dikNCj4gPiAgCQkJCQkgRE1BX0ZST01fREVWSUNFKTsNCj4gPiAgDQo+ID4gIAkJCXNrYl9wdXQo
c2tiLCBsZW5ndGgpOw0KPiA+IC0JCQlza2ItPnByb3RvY29sID0gZXRoX3R5cGVfdHJhbnMoc2ti
LCBuZGV2KTsNCj4gPiArCQkJc2tiLT5wcm90b2NvbCA9IGV0aF90eXBlX3RyYW5zKHNrYiwgbHAt
Pm5kZXYpOw0KPiA+ICAJCQkvKnNrYl9jaGVja3N1bV9ub25lX2Fzc2VydChza2IpOyovDQo+ID4g
IAkJCXNrYi0+aXBfc3VtbWVkID0gQ0hFQ0tTVU1fTk9ORTsNCj4gPiAgDQo+ID4gQEAgLTkzNywx
MyArOTM1LDEzIEBAIHN0YXRpYyB2b2lkIGF4aWVuZXRfcmVjdihzdHJ1Y3QgbmV0X2RldmljZSAq
bmRldikNCj4gPiAgCQkJCXNrYi0+aXBfc3VtbWVkID0gQ0hFQ0tTVU1fQ09NUExFVEU7DQo+ID4g
IAkJCX0NCj4gPiAgDQo+ID4gLQkJCW5ldGlmX3J4KHNrYik7DQo+ID4gKwkJCW5hcGlfZ3JvX3Jl
Y2VpdmUobmFwaSwgc2tiKTsNCj4gPiAgDQo+ID4gIAkJCXNpemUgKz0gbGVuZ3RoOw0KPiA+ICAJ
CQlwYWNrZXRzKys7DQo+ID4gIAkJfQ0KPiA+ICANCj4gPiAtCQluZXdfc2tiID0gbmV0ZGV2X2Fs
bG9jX3NrYl9pcF9hbGlnbihuZGV2LCBscC0+bWF4X2ZybV9zaXplKTsNCj4gPiArCQluZXdfc2ti
ID0gbmV0ZGV2X2FsbG9jX3NrYl9pcF9hbGlnbihscC0+bmRldiwgbHAtDQo+ID4gPm1heF9mcm1f
c2l6ZSk7DQo+ID4gIAkJaWYgKCFuZXdfc2tiKQ0KPiA+ICAJCQlicmVhazsNCj4gPiAgDQo+IA0K
PiBIZXJlIHlvdSBzaG91bGQgYmUgYWJsZSB0byB1c2UgbmFwaV9hbGxvY19za2IoKSBub3cgaW5z
dGVhZC4NCg0KVGhhbmtzIC0gdGhpcyBwYXRjaCBzZXQgd2FzIG1lcmdlZCB0byBuZXQtbmV4dCBh
bHJlYWR5LCBidXQgSSBqdXN0IHN1Ym1pdHRlZCBhDQpmb2xsb3ctb24gcGF0Y2ggdG8gYWRkIGlu
IHRoaXMgY2hhbmdlLg0KDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdhcmUgRGVz
aWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4uY29tDQo=
