Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCDB4DCD88
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbiCQS2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiCQS2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:28:20 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAACB2028A4
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:27:02 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22HBsN6i021602;
        Thu, 17 Mar 2022 14:26:43 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3et64ktqea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 14:26:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PU0rRMUaI0efKs0I95Sja0NsBJe0LH9/4BMWXlda33zNo4ZJZtPe1NJzPn4afsfWqIou7ymnoZCWNYr6iA8gbsaqnyoPANxR40Bjy2eGbo1aA4wE5jlIs48X2+EaiLsKNeztaTTozDECJtfTUk+OXbvk4Bv7Zzv+y7HNYQXa9FKc/vWkxnIJLmOzP1Q8deIVKs/I2VtaXFNXIIPcZ6OFF9CjPaRCLcZ2yn5wa9aDO1Fpa8mjCbvuJBXZM5F7Xa242PysQDl2bxmMwbPqgXstQ8skOPxSyL9BzPLzvUoRtQ0RbQgvFU96pNtzFFN+vhe6qb5Z/kRd+G4BWBBZA40WeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o9pm9y2mMB8DbBONYb/TSu9R+2ApCq4cdaxKDwA3P10=;
 b=J/jnhLPh1iMl5PGsFbxhknhEoCqexRw1c10qzOl1EwxyZT8g1dBM96yDoiLMn12h/HRgpG5TN67k6Bh26oNrpLamRCciQsI2HVrERxzSCi8+NMIyT94MEwikoXiRDBKKCJez8TGmvIxNSsRC514wy/wxzQhULWIPTsHkVmGb7yYplc59IM+fkpqVlFfVlnzmHxrLUfhLoAvL6SYMAejUD6uwEEtEh1703Gv688FnmshNcsjr1Ox7wEYGGGcHvvj23L66HHOa/25Qh7FPwiUV/G54HqvSBP+Rof6q7Ob7ItZJ+mAw8Q7M0ZCkR0Y7q91tcZN6mYQQJd86FPW5H8C3qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9pm9y2mMB8DbBONYb/TSu9R+2ApCq4cdaxKDwA3P10=;
 b=b291BNTAnWjTTV9ZQ+yKHMuBZArq5xxO4IDeUxo9bxMGkUUNJcXsfbRLAvBzjLM2U3AZoOy8v4hrLt27uLBM9Au9RlGLJCAAMWEhXwWQnMoLK3OYT9jpJSn9MiV0lfydF4NlLy1N2KPTVCK6v6kCrKQp6Yh7JfMfnIBidXx+dnE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB4331.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:33::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 17 Mar
 2022 18:26:42 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5061.024; Thu, 17 Mar 2022
 18:26:41 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andy.chiu@sifive.com" <andy.chiu@sifive.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH] net: axiemac: initialize PHY before device reset
Thread-Topic: [PATCH] net: axiemac: initialize PHY before device reset
Thread-Index: AQHYOXgtU0zgiojauESkrij+i2hC+6zD2E8AgAAN2IA=
Date:   Thu, 17 Mar 2022 18:26:41 +0000
Message-ID: <8122f4ed485d92464d30a1d1ef4584be2dc8c99c.camel@calian.com>
References: <20220316075707.61321-1-andy.chiu@sifive.com>
         <1be44aa629465d0cb70ec26828bf70f83d55f98f.camel@calian.com>
         <CABgGipU3n8g750kQj3ZgoMwXOLQAsM5d+HDRBWoiGEcZ9-uCSw@mail.gmail.com>
In-Reply-To: <CABgGipU3n8g750kQj3ZgoMwXOLQAsM5d+HDRBWoiGEcZ9-uCSw@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b562aa9-8090-41c1-c343-08da0843af15
x-ms-traffictypediagnostic: YT1PR01MB4331:EE_
x-microsoft-antispam-prvs: <YT1PR01MB4331BFEBAD1C05DA8B054F7CEC129@YT1PR01MB4331.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TqTBWPoJTKaBq18+avJneLWJBoZ0V+xWwTF5fkmCx6veYHqfQUVg8U74XbOHKVvazsF6FWxbFp8aREL5XPEwpNO3bQLRryigpNeFF1GHgojq/88goiq32y7rWfxrxabh4O54Isz83aBWI4GOlCPHdS6rJVQCUY94nPREIdwZmGmy+ECuYwU3xIpHFDCsuxY6AvL1kOApMW1fYQ7pG7687Kvl5AGuLUG6C5SBvKX+ZoTqaxiBg3gY9Ym7zAljXBGjYPXWXR4R+E6dRQX6RNnYugQ3wjP4EInk10sbBns2Qzy7Z4117ZE3xYKxBApQq3yWdO8nOQhgjd1Byco1GP/cFlcUPgg2et/kzIZVuVWH1n1F/iDR9b20h4SBQ6ifW5lNcu2bJZ0AyHu4u1Q+ND0MKH9iYrUXa2yopiuvOJD9OzTc/uUfD9WHjfGLugy7/e3a2EsgbUx01SV6/YQ/oh3YQB0hukXtms1QUD6MZkZad0gSGPJ1HBg8+e5ABab4n2uPWJbjK357CzW6bLN6RvvTFkWom0NWUiLcC7li5G6FFh5NHuHfYQTTfnUxnbOtAevDr746bo1sHDAvJalq4xE4d4IdItEUC4vUMBrV8gjHq4UvQh0/Jh5vonxwUcmS91eaF7NAEPLzDFnzZzXjBeHT6wzEqg8c1gQf6VTOTITgW+Q6kXiU3+5/CnKqk3ivIY3/xpb8A4q6A/4UmuCQKpMDdZ+8WW0DKLpD3m7aRn6NT3iolaeg3N58d+1egNeUimaRacswBHST1UwLWQGTPSzg2U2CmAuyG+hRpgsYinB8+RQIIKpr7rE1Jq5HGQKFNfS+Dy9I9HbYE/fFcl8BajKbVFPNhIE+0Io/bifDDn5L0Yw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(4326008)(8676002)(36756003)(5660300002)(2906002)(38070700005)(508600001)(76116006)(66946007)(6506007)(66446008)(66476007)(64756008)(91956017)(8936002)(44832011)(71200400001)(38100700002)(66556008)(6486002)(15974865002)(86362001)(26005)(186003)(316002)(6512007)(6916009)(54906003)(2616005)(83380400001)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RTNxSHZmekNNblg3TWJnZ3JRZVZhV2tZMVQ0YndnRDFuVDZNZFp3aWZHYVJI?=
 =?utf-8?B?OFRIeDhPVzVUUmJBRDBFNG5QdDFwQ2dlUjZFM3JaNTZHMlRmZzFuSFVWSzBH?=
 =?utf-8?B?ZjhvbWhvbW1FbFVIWkVHdWpQa3pMVEpjTnh6MlNNSUZ5ckdNWnBFRzk5Vy9s?=
 =?utf-8?B?S1d4ampqT1hsWGpBVXUyaTBpRm03UXpUTlZuUjVCZHBRSGVMZ010N2dTMXYr?=
 =?utf-8?B?Vk1FcHpja3N5UVpYZ3U3S0dPdE9SaWtGdU5BTjEyeDM4bVlwYXc5elI3ZEFR?=
 =?utf-8?B?V0xkbFMrT3EzWGREdm81SiswRXE2cjZ3UFlzMkFJaGJEMHRZN1RzYTJlYzdz?=
 =?utf-8?B?MDRzeWc4SWI3U0U4dUhsRE1QOFRFN1lUb1lvMmFmZnlCdnRDSC9ZMXF2ckho?=
 =?utf-8?B?enJpbVVZeTkxVk5CVlpDN28yblZLb1pjWVU0UWxuZUNOUUtKekpoMEtCTStu?=
 =?utf-8?B?ODlIZ1VNc245MTduaFB3VTJqT3VkNlN0YjBMZDFCR2NUcTJLbWh0UkJHbXB3?=
 =?utf-8?B?dkFpYlhzRnZnc3Z4ZVNiSWoraGRERFNWZWMzNS84UTRyb3lBVDgrbUUzWWFP?=
 =?utf-8?B?bzJNMkQ5eHZ4L1J2NlNkY3VnM2RkdkFhTW1nMG8xbXAyemlYalFvcmJnMTBR?=
 =?utf-8?B?Zm55ZEpIUEllZ21PaUlyWVVUeDhvS2lhUmtEaVEwbHBickFJSkZQVnhYaSs4?=
 =?utf-8?B?M1hMT0NoSjcxeGZlQUE2MnR4VDNKWG9vV2p5ajJLaGU5K08wNjZzd0JvV2FW?=
 =?utf-8?B?U3p6SXJYTlc3ZGxSN3NTMWZKYlhZckxETW1uR2RFalF0OC9zU2xiVmFIZDM0?=
 =?utf-8?B?bnR0U2xuMERKNWtwMTBNWmJDR1JNdWJTd01ZdTFYbkRPR2FqQ3IvRllFWG5V?=
 =?utf-8?B?Z3ltMW1YazArVXFzbnRvNVJCV3B1Y2R1OUtnbjlxdEJSOXJzNGdNQ2U4b0xS?=
 =?utf-8?B?cjdMbmQ0VkN5OFFNQ2ozRWJlc2hpRFM1VTYrRThheDFESldIQS8wckJVdm1W?=
 =?utf-8?B?RVZzUkVLNng1cjQ5U3JKTkU0VEdTckk4UndtQVV6S2pRQVlMdDMrOGdrSmJL?=
 =?utf-8?B?cDlTdVkzc05sZWYvMm13VkFVV05JcXVqU0dQbG5qUVB6SjZrSW5wYTY4bWFz?=
 =?utf-8?B?MW5UTm9GN0o1L3FEeVl0M25TQ29NRnZ1anJjUi9zSUN1aEM3NFlXeUI5cmo2?=
 =?utf-8?B?YkVVTUNCdndPNDUrM0s2eVord1NQUTMwampxd2h3cCsrUHVKdzNzU3pQOXJi?=
 =?utf-8?B?Uy85RUVncjlDVWtSRFJnRDUraUdXNUp5SE5BMWh0UFZjdDR3R0xUQWFSaFhW?=
 =?utf-8?B?Q3Flc1pMSDh0dStUbWxhSERvVWxya0pvdmVsWGF2S0VDa1ppU24wOGR2QnB6?=
 =?utf-8?B?cHMzRWxBK1JvUDRpNmpZY0tlQ3NNYXkvdldhTFdFZS8wU24xbEZURnZzL2dL?=
 =?utf-8?B?dW9pMXlkYXpkbTlWNGhWUVBhYlJVVVVVZDJVUEVPaFJkbU00amN6UitFUmRm?=
 =?utf-8?B?WUFKMUVsSUFwZjFZVm5SMWN3V1VNQkUybFNDSUpLeVBhbTU4eWlzODloNHBp?=
 =?utf-8?B?RkJ0MGJPaEU2aUtZYjAwMW4vVjcyb2JQakxkQUlKTmc4QjJ1VVVQZ2Q0QitZ?=
 =?utf-8?B?QWhYNXhnYVJBYkJzRnBibHl6UVVTRmVhelc4NkxvMTFCM000N2NKRmR3Q0Zy?=
 =?utf-8?B?YmNLK2J6M3hOZjR1UzVOemlGajJSL0FVZXdiNzYyMWJPekZKQ1h4WEJvMTVG?=
 =?utf-8?B?L2UzRExubEhTSU1FQ0FjR3Z5TUg4Yzgxai9jWmlnWmdaUWNFL2RlOHNIb2oz?=
 =?utf-8?B?VVgra3FzN0JEWTJXWDRyZWdKcTJFZnFDSUJPcm1QTnpzSTdkWGRXKzN0SWE0?=
 =?utf-8?B?YmdPTW5JMlRPU1lFWTdrUVJrUEJiTTh0V21GZWRrTjBiMlQwV3J0Mi9oOHho?=
 =?utf-8?B?b0hjdklOdlJ0T1VMQUpvU296RzluaWtSekFSMU5ZZ2xOMWdRZTRFYlNLRDVP?=
 =?utf-8?Q?S+SLIM5OoPQLGu4aqVwDKM/U9iLbBI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4B2F27C757CC14FB7B8F4D490003C2E@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b562aa9-8090-41c1-c343-08da0843af15
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2022 18:26:41.8991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QCrU456eqQDNwCeIC95FZ7ZcEw/jp4hlitIMUOJmqRpWwFTeTytvTqxV3hhk7wNwYpG7WX3+osDnQrWVBdb/rPpRKIf4tFN0ZybcnF4LDGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB4331
X-Proofpoint-GUID: FGmtW7iLQglbMuuEWeGtsWsour5Hf-2s
X-Proofpoint-ORIG-GUID: FGmtW7iLQglbMuuEWeGtsWsour5Hf-2s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_07,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=902 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170103
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTAzLTE4IGF0IDAxOjM3ICswODAwLCBBbmR5IENoaXUgd3JvdGU6DQo+IFRo
YW5rcyBmb3IgcG9pbnRpbmcgdGhhdCBvdXQuDQo+IA0KPiBUaG91Z2ggaXQgaXMgd2VpcmQsIGl0
IHNob3VsZCBiZSBzYWZlIHRvIGRvIHRoYXQuIFRoZSByZXNldCBvZiB0aGUNCj4gTURJTyBpbnRl
cmZhY2Ugd291bGQgbm90IGFmZmVjdCBhbnkgci93IHRocm91Z2ggdGhlIGJ1cyBhZnRlcndhcmRz
DQo+IHNpbmNlIHRoZSBkcml2ZXIgd291bGQgcmUtaW5pdGlhbGl6ZSB0aGUgTURJTyBpbnRlcmZh
Y2Ugd2hlbmV2ZXIgaXQNCj4gdXNlcyBgbWRpb2J1c193cml0ZSgpYCBvciBgbWRpb2J1c19yZWFk
KClgIGZvciBidXMgdHJhbnNhY3Rpb25zLg0KPiBIb3dldmVyLCBzb21lIG9mIHRoZSB2ZXJ5IGZp
cnN0IHBhY2tldCBvbiB0aGUgcnggc2lkZSBtaWdodCBnZXQNCj4gcHJvY2Vzc2VkIGluY29tcGxl
dGVseSBzaW5jZSBgcGh5bGlua19vZl9waHlfY29ubmVjdCgpYCB3aWxsDQo+IGV2ZW50dWFsbHkg
Y2FsbCBgcGh5X3Jlc3VtZSgpYCwgd2hpY2ggYnJpbmdzIHRoZSBwaHkgYWN0aXZlIGVhcmxpZXIN
Cj4gdGhhbiB0aGUgcmVzZXQgb2YgdGhlIGNvcmUuDQo+IA0KPiBUaGUgcmVhc29uIHdoeSB3ZSBo
YXZlIHRoaXMgY2hhbmdlIGluIG9yZGVyaW5nIGlzIHRoYXQgdGhlIGNsb2NrIG9mDQo+IG91ciBQ
Q1MvUE1BIFBIWSBpcyBzb3VyY2VkIGZyb20gdGhlIFNHTUlJIHJlZiBjbG9jayBvZiB0aGUgZXh0
ZXJuYWwNCj4gUEhZLCB3aGljaCBpcyBub3QgZW5hYmxlZCBieSBkZWZhdWx0LiBUaGUgb25seSB3
YXkgdG8gZ2V0IHRoZSBQQ1MvUE1BDQo+IFBIWSBzdGFibGUgaGVyZSBpcyB0byBzdGFydCB0aGUg
Y2xvY2sgKGluaXRpYWxpemUgdGhlIGV4dGVybmFsIFBIWSkNCj4gYmVmb3JlIHRoZSByZXNldCB0
YWtlcyBwbGFjZS4gV2UgaGF2ZSBsaW1pdGVkIGNsb2NrIHNvdXJjZXMgb24gdGhlDQo+IHZjdTEx
OCBGUEdBIGJvYXJkLCBhbmQgdGhpcyBoYXBwZW5zIHRvIGJlIG91ciB3YXkgdG8gY29uZmlndXJl
IGl0LiBJDQo+IHRoaW5rIGl0IGlzIGEgaGFjayBvbiBib3RoIHN3IGFuZCBodywgYnV0IHN0aWxs
IHdvbmRlciBpZiBhbnlvbmUgdW5kZXINCj4gc3VjaCBodyBjb25maWd1cmF0aW9uLCBpZiBleGlz
dCwgd291bGQgbGlrZSB0byBoYXZlIHRoZSBwYXRjaC4NCg0KSSBoYXZlbid0IGxvb2tlZCBhdCB0
aGUgY2xvY2sgc2V0dXAgb24gdGhlIFZDVTExOCBpbiBkZXRhaWwsIGJ1dCB3ZSBoYXZlIHVzZWQg
YQ0Kc2V0dXAgd2l0aCB0aGlzIEV0aGVybmV0IGNvcmUgb24gdGhlIFpDVTEwMiBib2FyZCB0byBm
ZWVkIG9uZSBvZiB0aGUgU0ZQIGNhZ2VzLg0KSW4gdGhhdCBjYXNlIHdlIHVzZWQgdGhlIFNpNTcw
IFVTRVJfTUdUIGNsb2NrIHRvIGZlZWQgdGhlIFBDUy9QTUEgY2xvY2sgYnkNCmNoYW5naW5nIGl0
cyBjbG9jayBmcmVxdWVuY3kgdG8gMTU2LjI1IE1IeiBhbmQgcm91dGluZyB0aGF0IHRvIHRoZSBF
dGhlcm5ldA0KbWd0X2NsayB3aXRoIHRoZSBjb3JlIHNldCB0byBhY2NlcHQgdGhhdCBmcmVxdWVu
Y3kuDQoNCkl0IGxvb2tzIGxpa2UgYSBzaW1pbGFyIGNsb2NrIGlucHV0IGlzIGF2YWlsYWJsZSBv
biBWQ1UxMTgsIEknbSBub3Qgc3VyZSBpZiB5b3UNCmNhbiBkbyBzb21ldGhpbmcgc2ltaWxhciBp
biB5b3VyIHNldHVwPyBTaW5jZSBJIGFzc3VtZSB0aGlzIGlzIGFsbCBoYXJkd2FyZSBvbg0KdGhl
IHN0YW5kYXJkIFZDVTExOCBib2FyZCwgWGlsaW54IHNob3VsZCBsaWtlbHkgaGF2ZSBzb21lIGV4
YW1wbGUgZGVzaWduIGZvcg0KdGhpcyBzZXR1cCwgSSdtIG5vdCBzdXJlIHdoYXQgdGhhdCBpcyB1
c2luZz8NCg0KTGlrZWx5IHVzaW5nIGEgZml4ZWQgYm9hcmQgY2xvY2sgcmF0aGVyIHRoYW4gb25l
IGZyb20gdGhlIFBIWSBpcyBiZXR0ZXIgaWYNCnBvc3NpYmxlLCBhcyB5b3UgZG9uJ3QgaGF2ZSB0
aGlzIGlzc3VlIG9mIHRoZSBjbG9jayBkZXBlbmRlbmN5IGdvaW5nIGJhY2t3YXJkcw0KdXAgdGhl
IGNoYWluLi4NCg0KPiANCj4gICAgICAgICAgICAgICAgfDwtLS1yZWYgY2xvY2stLS0tLXwNCj4g
Ky0tLS0tLS0tLS0rLS0tXi0tLSsgICAgICAgICArLS0tLS0tKw0KPiA+IFhpbGlueCdzIHwgIFBD
Uy8gfCAgICAgICAgIHwgVGkncyB8DQo+ID4gRXRoZXJuZXQgfCAgUE1BICB8LS1TR01JSS0tfCBQ
SFkgIHwNCj4gPiAgICAgICAgICB8ICBQSFkgIHwgICAgICAgICB8ICAgICAgfA0KPiArLS0tLS0t
LS0tLSstLS0tLS0tKyAgICAgICAgICstLS0tLS0rDQo+ICAgICAgIHwtLS0tLS0tLXwtLS0gTURJ
Ty0tLS0tLS0tLXwNCj4gDQo+IGxvb3AtaW46IHJhZGhleS5zaHlhbS5wYW5kZXlAeGlsaW54LmNv
bQ0KPiANCj4gQW5keQ0KPiANCj4gDQo+IEFuZHkNCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlv
ciBIYXJkd2FyZSBEZXNpZ25lciwgQ2FsaWFuIEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNh
bGlhbi5jb20NCg==
