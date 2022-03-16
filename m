Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A6B4DB9CD
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351484AbiCPU5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353547AbiCPU5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:57:20 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7B250B10
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:56:04 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22GAgQHn015706;
        Wed, 16 Mar 2022 16:55:35 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2058.outbound.protection.outlook.com [104.47.61.58])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3et64ksy3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Mar 2022 16:55:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIOKsfDjHG/H+7tjRx2KDAPDss+I9Dze3pfY//qPXkfcD+OlYFfF3WWTwztvLDmLHBTWr158R8yHOkPhEB9NQjt9YGZvnA1Zks4J3JNGZph6tQaOEWIe8JYYRAOgG5xr/c/G1EX6LrJBBrF32z0JCyegJCdUcC8FljTr2usNp1GrAOo825mJs+IQdRUZ1iN2SB8WozWmbgCBvMnDFkW6lKzc0+1L2gVwBAqqz3dhow0Q0C+gpNdf8BarPri6xACI3DrJa6PbKXDzE5MBDRXYOoHa36NfatgTyY7PIrydc83ALb8xIyJMbED4yprDLLdmpu6rbKXBbvQAaH2xqaNajA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPWTcHH2pBVgg7bHgLM2IBtyvIQlQRB7vHNel6olREU=;
 b=PHa+CFmR9BFE9ufjprWlVGzi+wSPM8iPUoDgFmzj3vhbc3jQQvCJwaZjWNlBeEYL0m8xNUIQJubIEIpeyA7ojzVK4QodqcrDnCB7TwkP8sipxJ+FgyPzaYOy0I7kvwR6VhI4dURUz+/++RQ9u7ebuX/4MzLDJrKjZFA/k5Q7KF8cIeeXN+03ZrovYh4ING1Te60oqv/bUAwCBDlUUy4Lya8yYgzlGq4RNWgvql1X/dZwf5sJeu5Tso8puREePoePsw/f3SqJDPoyHdWWQPlJGAVH0zAOZgmjar9IMdk7nndJ+W7VH5vGJqLlyhtbWDb1m8gNbGTRwg7KzXUEBsE7Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPWTcHH2pBVgg7bHgLM2IBtyvIQlQRB7vHNel6olREU=;
 b=BPcvjvbJwhy1ICAqh+OrCBsaaoRVVrg8dzBpK2ZoX3cKFbGrDSSiDrDTmwx+NFWRqW5vFEq+jyD44bwbsdKab5Nc2Qc54AP+KiQpL/91YGg8RHYwms+S6BYsY9A1ih6Sv8GiHTLIETmAAdqapEaDTpkw9yn0A01bfxtmp0i1/xE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB4375.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:10::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.16; Wed, 16 Mar
 2022 20:55:32 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5061.024; Wed, 16 Mar 2022
 20:55:32 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andy.chiu@sifive.com" <andy.chiu@sifive.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>
Subject: Re: [PATCH] net: axiemac: initialize PHY before device reset
Thread-Topic: [PATCH] net: axiemac: initialize PHY before device reset
Thread-Index: AQHYOXgtU0zgiojauESkrij+i2hC+w==
Date:   Wed, 16 Mar 2022 20:55:32 +0000
Message-ID: <1be44aa629465d0cb70ec26828bf70f83d55f98f.camel@calian.com>
In-Reply-To: <20220316075707.61321-1-andy.chiu@sifive.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d70edfd1-8a8f-40bb-6af2-08da078f4fdf
x-ms-traffictypediagnostic: YQXPR01MB4375:EE_
x-microsoft-antispam-prvs: <YQXPR01MB43752533DD5F2EA8367E52F0EC119@YQXPR01MB4375.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ijhE0sa+Ht5WApfc5HfaoZboszYTUISIKvhSPVG72G/C9/V7UWmFn16/LkAt1Ctx8OVsyzEBGmgHA/3a3HwHvAYH8QkPvPjv0GRFzz6GQweSob7xRuXj14ptf0Q5fhdNlizJwUR232IDcGQTQ+Pjch9Rg+kl0rQQfHF5CPvVo/QeV2xd2mTBqYDGd9HIPmuh91OQ6xAK+ZFmvxYNVk1Kw8l2/JWcLjtxzAv6lDUtJRyU2HBseo6t/wn4tl/SB0xVt3to9gOoRuMEunw8H57xw0lX9fcynWMi1LXRHxDhW/QjPyW+8Et7k5x5iqXCOb1nM0gIjxJU0ZAZt9KkM64k7NYXtxrzLeEOi/wRMEiOgIuv/EwsgMGwi8gXGt0C/TztzEOXdHF74N2yaoxbmCDAzq1R9osVAznF6xFaumMs/r2B1o9KgazNKMB8ePyFy45WptnQhD/Pa6/z3ReD7RqhFXk2J6EFJr4OfjpgTJziw1aVOmfGguorizx3zeaNAIKGyOGz13oxPPDNICJSbXLU5UrEq876KpE52LxqqiosfUIKMBBB4TwlbIP3hBaurEuabkGkbPxnflZuh7iPtK+3Dry0s8VccyJ0MrMSCinL5wzuWzfTE3GFaizzJ3oyLsLAxyIT/hlYwjA5SmA9KQC2oc4s+V/M+AvfAZBSVPlRDIb38lKA8z5RMcVN+mNL3+zxGVaWgjeeX9oHTFUxF6HTNxkh5wL3tvZkC11F2YQs0gUkRgry25B9lpPEqr7zdixZ07zcpPlCunVco2HhuC40YTc0tKMLGZ+CO5WidPyZCokeBCjtpkKFC7SHwVvYKY/8InJagZEfUOleL6ThlEPatanZICFRNq57D2vJ2y0/sNM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(83380400001)(508600001)(5660300002)(44832011)(71200400001)(4744005)(86362001)(15974865002)(38070700005)(6486002)(8936002)(36756003)(8676002)(26005)(186003)(2616005)(6512007)(54906003)(316002)(6506007)(66946007)(64756008)(122000001)(66446008)(66476007)(66556008)(6916009)(38100700002)(76116006)(91956017)(4326008)(2906002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1JRRFpyMXByTFlBQTgydm1qSUJ0eUcyMUNLRDk3QmNoM3pKbEpCQk9JT3RR?=
 =?utf-8?B?QytncFA5cWhuRWorZitSWVZSeUVWYmcydkp0bnVTM1FHRlFrbDhKQnZ6aVNZ?=
 =?utf-8?B?MDRGS0RaNm4vRm02OEQ3Qi9qWlJNVjhuS2dma2NHV2dCbG9CaHdFU1dUOFFU?=
 =?utf-8?B?ZVo2QS9NUldhREJud3lvVmxMbEFmZ1dYaTZ5clNUTi9vNW1iVlpkcFBaOWt0?=
 =?utf-8?B?dHJOSCtJNFJUNWVwRGxJU3pidGd4ZyttOXk0ZFFnTlNSLzJxOVhROUZwWjRy?=
 =?utf-8?B?OTlJV3Q2Y21vTWNQS0ZGdHArVk5NYkJwaEhNdFZzaTlTalI1TUxoODlMNGd4?=
 =?utf-8?B?T29iQmNiOUFBazFaNWo5Y09NZDUyT3ZxNU9IUCt3VWlyLzJzZ2krWmtHNlhn?=
 =?utf-8?B?TWVnVWlkOENKN09UOTExWmQwcEdQQWtUV0tMcGdPU1R5b0hScmh3QktyY1ZC?=
 =?utf-8?B?QmsyVmdsOEJhR25hTDg2UTByaVVTeVNEZktPeUJFcW11b3ZYMHFneTh2OHBY?=
 =?utf-8?B?dzgvdzVrVnlJZUJPR3NrZ0RSekRFYnYxWXdqemdaK3QrMUxvZ2M4TWY0ejdx?=
 =?utf-8?B?STBQUWZSa3NhclRJZW8zZEMwSGdXZm45ZnZKVDJVTWxRL2tvdWhyVi9VcWp6?=
 =?utf-8?B?V1M5bXR5OXhJYW40RlJZMVcvYkxxZXhKaFFKc2s0Y2M4TlZXaVdKZXdtUU1n?=
 =?utf-8?B?Z2pRUVN4MDNvenZ5ZE1vWThQVkIxSXR4SGQwVlBVN09lZ3Zpc2h6N3ZZM28y?=
 =?utf-8?B?YTZyTFpabWk3K3lGRUhSWmZEaFpTNUhwUm9sRW9GanYvV1lpTGVFUnVJeGRE?=
 =?utf-8?B?b09Zd0x1MnhOaGV6OXpETnZYWlpIbVdWclBOYkU3SWs5b3dIcmNWTmlwOXZs?=
 =?utf-8?B?bkF3SEN2aHpRajlERzk5b2liWmwrWndEWUZXejhhL25vQloreEQwcWVMT0F4?=
 =?utf-8?B?RlE0NjlqMFU0NWRqYm9icURxak5jYnkyYlVSTk5meDIwc1ZqYzJhaDc4Z04w?=
 =?utf-8?B?ZFAydnpjUjRzSmVjYnF5WENxb21iZk5zdkE5VjhJdXZxTDZTMjFUM3JLcVA1?=
 =?utf-8?B?ekswOXZ4Kzl1UEdkci9mb3p0SkJoVzdOcWg1V0ZmQkR5Y0k3K2JkaVU0SGdS?=
 =?utf-8?B?dURTbVZYWi9vQzhQSmhrbHo0VTNSbjRIT2lMeFdWbkpNMVF2elhsejg2bEE0?=
 =?utf-8?B?ZlZ5ckdOa1VsMVIxcldWS0FFWlllWml1VlVjWXhSTmNMYUdMdkNGZStWQXIw?=
 =?utf-8?B?L1hnM1g4UjRTaFJEMUVwQUZDQk5qNXhBOVBPcXZjY3lOTUg2bU1TdzdDUWJo?=
 =?utf-8?B?eEVPZG85Z2FiMVNEYVFyNFpPZFdtUmo4VHFyeVZsRWd2THQ5Y1J1bjFmQytu?=
 =?utf-8?B?N3dHay9IcHRvc0FhNTh2NHlDSmtKMVZueUx6b1F3cFVHY3pGbjNxZVdSdytX?=
 =?utf-8?B?N0g4bG8wL1lJMGNLajIrYjBCUTN5MDJpdzY0Yk1MQ0xNMUJBWVdPcUZhTWp4?=
 =?utf-8?B?YU04amQ1QjVmc1ZuNGtXUXViNDNmUXJER2dzd25QYzBKelEyOWx1NkJHamZu?=
 =?utf-8?B?U3laM1dDOTJXa2JhWHNTYWxCM3ZaUUVzc09HNVEzQ1hSVWpDeWxXcHNrNjJW?=
 =?utf-8?B?MWloTE0xRUh2WGRZS0NaVWRDdXpiUEVJd0lwYlAvcitiem9BOEhFT1FQZ2VF?=
 =?utf-8?B?VW5LK0IyK283WEg1d0pqUVlUUG9aY3Bna1plWG1kVmlRc29MQncvdUVoeC9Y?=
 =?utf-8?B?RVYreS91cEpBNWRUSTZpZ0k0ZlhaV3NpZnpjVHRpVWRiTHFHS2x0WEZxMmtk?=
 =?utf-8?B?b3laVkxYMUphazdDekw3eE9zU2pQeEgrTjBFNWJwRzg3SHd5NG5yTU9Qa2dE?=
 =?utf-8?B?OXFWbWZiTElUUHNDUmw3ZWFhd1dXS3RydGhoT09GZ1pMTXgrTDBYZE5jVXFl?=
 =?utf-8?B?ZTZ6eXBQY1d0ZGJsWm84Y01JY0JJR1JENnJoS3JRMitGdFk2S0czM0wvamly?=
 =?utf-8?Q?8VInx5PqgqASl3LKdvNQ516QVbDBDk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36DD0161BAE81549859283CC9D640B47@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d70edfd1-8a8f-40bb-6af2-08da078f4fdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 20:55:32.7168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fnKAmrbu2dhytbbhtbnEs3X2Hqzhqy0RRsRiOmQaps9RHAfKR0Yugm8HkLmo1p3lIJ7ftg05yr8yCtZ7/wjmGyUPVpWlJinOjHGld53OyfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB4375
X-Proofpoint-GUID: McpfOF2wLX8c1vGqLAacj_k0l2KGYfpc
X-Proofpoint-ORIG-GUID: McpfOF2wLX8c1vGqLAacj_k0l2KGYfpc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_09,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=918 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203160125
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmU6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIyMDMxNjA3NTcwNy42MTMyMS0xLWFu
ZHkuY2hpdUBzaWZpdmUuY29tLw0KKGxvb2tzIGxpa2UgSSB3YXMgQ0NlZCB3aXRoIHRoZSB3cm9u
ZyBlbWFpbCBhZGRyZXNzKToNCg0KSSdtIG5vdCBzdXJlIGFib3V0IHRoaXMgcGF0Y2guIEl0IHNl
ZW1zIG9kZC9wb3NzaWJseSB1bnNhZmUgdG8gcmVzZXQgdGhlIHdob2xlDQpjb3JlIChpbmNsdWRp
bmcgdGhlIE1ESU8gaW50ZXJmYWNlKSBhZnRlciBjb25uZWN0aW5nIHRoZSBQSFkgd2hpY2ggY29t
bXVuaWNhdGVzDQpvdmVyIE1ESU8sIHNvIGl0J3Mgbm90IG9idmlvdXMgdG8gbWUgdGhhdCB0aGlz
IGlzIG1vcmUgY29ycmVjdCB0aGFuIHRoZQ0Kb3JpZ2luYWwgb3JkZXI/DQoNCi0tIA0KUm9iZXJ0
IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQ2FsaWFuIEFkdmFuY2VkIFRlY2hu
b2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg==
