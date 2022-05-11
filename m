Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAAD523F04
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 22:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiEKUlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 16:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347876AbiEKUlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 16:41:10 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8331681FE2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 13:41:07 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BIJatt003766;
        Wed, 11 May 2022 16:40:41 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2172.outbound.protection.outlook.com [104.47.75.172])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3g02sg0m69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 16:40:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4L1X/yDPZeIr1CLYMk2ColsLidqpHmlyeQMhOESLjkrcH8vx9Z2f5CB7RB4g+tiDJnmFmqQGl7d4SHAH19h61XKqvUVyKTZ8N4ezciuLHAs7JhXKfNwy79EA6u2DAgQ+QPJpkHLaKWNKB4JKLzDCjWIeAOluUrKVbwjTt9Sn89ksYzC9VCQ4/cvxwPwJCuf8Cc7xyotcGvHjNjoMouh0R/8neJotB4Z7kVvEhhBMVqxsPyJQgFAldt86aOJi+LBcMTXk/z9ZEMtVuPLBOwT7AYYW7DPx5aAc/NINA1ZWeh02p88+W4mYkvT32nPCBUfmvghRzRHRgaRnO9YqP0TBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZh9VI9zVxWLdmxjPrnd+uBST5ZMW+WtzgBtKVPwv78=;
 b=FfcJ2xRYCkKMCDiF2Ol1+aGUYTTmG6xfWPxfrsx/OK+XGSiyKwZsncsCFsmoUK0JpQVRjp/I+65Zy+625UcLGAnivFkTZ5ThI6tefJrJ2/cbHVRD20HQikTvBpGZGvBA2tcKqD8b1MnBq4jjeZmT6djERjDBSgEBOqZQOJYQLuOHX/Bq/68uUNwFMWPZndfEVQZkQTcJm5ZMqSuohNw1r0dKEg0JTxANreTrEyUfIBx1ayKO2JdlMnwUssC0Ua+8rYLQYzcLiNvT9XeN5vvEAaFgOO2Sz6tHym89SZSEKllG2KCfi4uKKzFgP7yFke3B1WB6Y5JZCK9cyDBDuujO8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZh9VI9zVxWLdmxjPrnd+uBST5ZMW+WtzgBtKVPwv78=;
 b=f8aNgXpCraIOnpyYJmhpkTNgcXozm5WOA9+gX2WREGvZILEyxfCOpuSoyiwa64JYX5N7PVe4jXb/9XgiYzPi/Eg/F9Rpx5f1WaJRM/41pDSXRhUoF7uqUWHJxk9mbx+d0I7Han1DDnj9WPZZPrbG2QAkjGR0D9nndyJBHNuN3UM=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:1e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 20:40:39 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4%6]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 20:40:39 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v6 1/2] net: axienet: Be more careful about
 updating tx_bd_tail
Thread-Topic: [PATCH net-next v6 1/2] net: axienet: Be more careful about
 updating tx_bd_tail
Thread-Index: AQHYZWc01/0NuPfCUkaZau7eah4lE60aGLcAgAALOAA=
Date:   Wed, 11 May 2022 20:40:38 +0000
Message-ID: <9a35372eee962f4dd557a2e7e53047732e7b2ba4.camel@calian.com>
References: <20220511184432.1131256-1-robert.hancock@calian.com>
         <20220511184432.1131256-2-robert.hancock@calian.com>
         <20220511130028.3e2edb35@kernel.org>
In-Reply-To: <20220511130028.3e2edb35@kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48b9d246-f9db-4cbd-94ed-08da338e824a
x-ms-traffictypediagnostic: YQXPR01MB4435:EE_
x-microsoft-antispam-prvs: <YQXPR01MB4435F47F26B8F90501CAD77DECC89@YQXPR01MB4435.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uUbOYFDPhAMXeGCQH1+ZtCwl/uPTV+UtnIiumrz12oNC+ZXobH/y/EqVKf1nE6Ygf9FWq9o47ltRQAQHW5893CuYJhRHe6u83bPivIlvEypNAoBKl1bozpDw+3uyHRmA5fVa3PUr2lKPOf44G74SM8237FFYaZ1MvwnDC6Vicu/HxnA9u6qO1M4cza7zu9zc9Fb2XU1Z2RudVjp40QoSRMNf7EbnXyudkVrP48WG/cKbz2PtaM/BTev1JtcRFJwvNHP/eXTqWDJoz7I78kEjZ086WAwe+7aXgf2N9a5Trflb8nj+hc9nOEvP5/AC+/VqK0NFWqcp7Uj+m3R1NwEy7x9K2eIjKwBnJ/XeEu86fgKZU0t17OEnYC6fjkg+XlTbY/DARgcU7poTxk8eqNaQiP+mawqpZVUsoRV2hj2lmd/0I9CyNDO+MKkaB9TBNNYlodYqbz77F5cGfNEBRh59dB+laqs4rZh8A5OJcyIMDsxz6l2qoVHhNVRBNTJrn7UdfXJa9sMabR6ofZPaepUaVR1yKtDN7DE19ZM4BII5IcfUfuZ96Q56uX1VaA/QyJGkYIPY+n23uJht8umpM80ZnDtKZzGynD3st/zJN4IUCXcITwILHqYAXm7O4FPS01mhLC2OdKvgu5w0uo+TdabBDueuSgKAFtiSZf8H5QRBPy3pUjIW1wnPysb0U90gYmAXxYkolsTehXISGHTigeQHB+5BYzRkqC5iqJpeg+Qwn/o30wtBsIw0lKJ1npFsYu0eORxAJ5fzAdX82NdT+Aa7Yqbix4Rme4KwIga8U/QbftANLYTYi2YNjhLl/VbgFmJ6+W20XsRCBKNE+OHSFT+cDLIQLBSeudBSssvVin7JrWM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(186003)(83380400001)(38070700005)(71200400001)(8936002)(38100700002)(2616005)(44832011)(6916009)(86362001)(316002)(6512007)(54906003)(15974865002)(26005)(4326008)(2906002)(122000001)(76116006)(64756008)(8676002)(66446008)(66946007)(6506007)(66556008)(66476007)(6486002)(36756003)(508600001)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVpuZFlERzhtVzBxRG41THVHR3YwMmpQSXM0ekplRUw0bWhJNnMzWlIxRDNs?=
 =?utf-8?B?Vkt5ZU1KYUtVVHBRZ3BhUHRPWlUwMTcrd0VjV0U4dXV3OWY5T2I3a1RienZj?=
 =?utf-8?B?cFBFQk9mMThLVXB6Qi9RaFlYbVZXaDl2dWxrR0RkV0ZoTTVHVWtkVG96QW9F?=
 =?utf-8?B?b0NVZm5KMmJVbW1WemY0RnN5RGZvQzJhSmZkbFFRVWMvRmtFNXZrcmtvVkIv?=
 =?utf-8?B?S1VuWUhYTkFhVm9WK0RHZWR1R1IxS1VmWGJWaGlYYzkvM3pMbWtJbzZXT0Js?=
 =?utf-8?B?NmdzVithQy83RlBaQVdOTmxNdWNQZUU2bHJGbkVFY3J4YUl1WDlSNkREbmNx?=
 =?utf-8?B?VTVHOG0xQnJpenptSDJTR1J3RWR3dlppci83MnhtUy9zOVFpZEd3eGFxZXg5?=
 =?utf-8?B?anlIdWZqQ0lRYWlSUHZmSmNmMXJkS3NNM2NBSlNCbytBcGtCSE9RYTRndG5m?=
 =?utf-8?B?UUZCTXlsS3J6dTFZaXRXZUJVeHEzMjArWUVpMHRKMkRhejJuczl1YWlhVS81?=
 =?utf-8?B?dXk5OHc5Sm5uMzl3MkF0ckowWjNaR0xaKzVTZkVLOG9lRi8rdEFlR01SWnN6?=
 =?utf-8?B?bEVmZUIyUTVmSldTQXNKUG9KSmkyT2NqT1hmZXQ2dTV5Nmt6NWtEMjRTVDYw?=
 =?utf-8?B?NGxCUVA0Y3dNbm41NWdsc2JlMVlrbEI4Tnpwc09iZGZPZEIvV1VzVXNacU1a?=
 =?utf-8?B?QnFMSitjaEJqY2ZxcXY1WnZXcks3SGs0cUJFRmdKUGM2Wm9UbGF0cU9ZT2dE?=
 =?utf-8?B?WVdlL2RJMzRoamJTN1p5K09mVXdzYmtpdVYyTlpOZHIzNmFzeFBHeTNXck5i?=
 =?utf-8?B?QmhWenVMTXVLSmppS0IxMFE0ZFJSb0hISjZFV1RuOG9ZQkM1eUFCSFlnMVNT?=
 =?utf-8?B?K1VaVm1ZaGtSYWd3UzltcFpTS3NKcjlYK2JYdDZCRVNZdHU1SXVBSGxhc2Vh?=
 =?utf-8?B?T0JzY05EK081S1ovOU5rUWlpSXlRcXpLN3g1cFZubnBmTFdZV1JBVFExQVNE?=
 =?utf-8?B?VnEvWlJSWlFDeWN6Q1ZlajlpNVNmeXJKYW5hNGpLYjN2SzVxWk1IVzMvZ0pX?=
 =?utf-8?B?SEFTbnZIamRZUzNDU1dDeUxudk9XTEhadXVEbkVrbEwvcEMrWWxKVkg2ZExZ?=
 =?utf-8?B?aXR6RWwzRlQvbnNVK1kxSXlUSzJWZDZaSm0vTDMrZlA2dE95UDBZb1NVS3BR?=
 =?utf-8?B?ei9XYzhoYTF4S3k2ejdCRU1hcHNhT1N3QlcrNVVjZWtxK0d6cTVnZVNNdVMy?=
 =?utf-8?B?M2RPenVNZEI2eWNyaWw1bGZMWXBQRndkbzkzd2JOQXdydERSMlBpUlgwQlpV?=
 =?utf-8?B?elVjVHFsc0dqYlZ4bW9lSHZ5UzUyQlpxeFZkYTZJZlhlZERJYzEyY1ZHeUwr?=
 =?utf-8?B?RXhpMTN1NmJBQU1kd2UyRVI1ZlIvL005NnZMM2UxcmFmeWhrNFRTOWZpZndB?=
 =?utf-8?B?bVdWTUZWRFRndEYrK2h6N2hHSWg1WDBqb2pGZFB2V29KQ0d5TFg2TzN6bVho?=
 =?utf-8?B?YUxwU2V4U2R1dDR4QU9hTmlFOTdFNVdxTUhHM0RLbFNodEtVMEF1Tm1FTWx5?=
 =?utf-8?B?ZzFHMi9ubHBFK2VqV0tKaU16VjNTMEl0Nkh6RldJTDhwVS9qa29oZGUrbXFB?=
 =?utf-8?B?ODE4OUhzQ0ljY1JxU0FianJWVDVzcVhDT1E5Sm9tQ1diWkpxVnBrcFUvNTNr?=
 =?utf-8?B?TlZrVHVJVUt0azNPUWVSNFpFR1FXdnRvWTh4M1pFRk9GZVN4bUZ4aVJKSnYw?=
 =?utf-8?B?WDdvaStPYlZYQUx6VFkrZ3dIYUo0VFpMdEIvYWM5R0V3MkoxRkFDTlNya2JB?=
 =?utf-8?B?S05ueU1uQ1JzeTVIcUJBK013YWtPRWEwbXNMYXJ2Skx6OU84dnlUUUlRV1l0?=
 =?utf-8?B?NWZkRjVGdi9uZXNrVHhNcXRPNU1GWUFaWnBONmJsbHRab0htSUwxdFVlVkUv?=
 =?utf-8?B?RTJGY25hWlRiZ2xtUHJNeGROb25SNUQ2WjJqbHpILzFneEwzRkRnMVRJeXkz?=
 =?utf-8?B?MStXWVNKRWVFc2Ewa2NneEFSMzNhT0ZRVlRNbll4WWU0UGovbytFR1F3Y0xT?=
 =?utf-8?B?RnZMVXlzT0pDTVNwM0xYbGw2ekJ1TUdTSTA1N0NhZS82VGE2ZXB6aXdWRzNE?=
 =?utf-8?B?M3NRVjk1dUtQWXNPOWd1Wm4vVzJxRi82UFRTZjFna2huaXErQVR2MTZxRE9L?=
 =?utf-8?B?dDVYMW9OZHdXMGpSZTJQL25LTlIyV2xlUncwUWJxcUpuNnRXQ2h5aU5oSlht?=
 =?utf-8?B?bVd3aFg1bVRBd2V2SXdUa0pJNUtjYzVlNnNnYVRyUWZOemxrditXdHowWjg4?=
 =?utf-8?B?TVRDbVFoMUVxNG9sMDRoRktGK01ZcktYSS9aSThoeEhBVmRmWTRpa0NoTnk5?=
 =?utf-8?Q?RFmyI2Jsd5wkmF/cXDOnVEP/yNrAewWn8U8iK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8030EF41C73A3649A45F7AE5C46FC006@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b9d246-f9db-4cbd-94ed-08da338e824a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 20:40:39.0019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: idkjHlAUbdUrXiKZV16Cr3ats0cJom6XBTyP4GRMtaU70hjKsrLMDUA6Jm4ySLkTD7VFTgJYjzoieruUSHhpk7WPWw20Hb7rfV6hFds2upc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB4435
X-Proofpoint-GUID: J-nZ2lPf0lsQBo0HFl-vFjBRszC-9v9P
X-Proofpoint-ORIG-GUID: J-nZ2lPf0lsQBo0HFl-vFjBRszC-9v9P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTA1LTExIGF0IDEzOjAwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxMSBNYXkgMjAyMiAxMjo0NDozMSAtMDYwMCBSb2JlcnQgSGFuY29jayB3cm90
ZToNCj4gPiBUaGUgYXhpZW5ldF9zdGFydF94bWl0IGZ1bmN0aW9uIHdhcyB1cGRhdGluZyB0aGUg
dHhfYmRfdGFpbCB2YXJpYWJsZQ0KPiA+IG11bHRpcGxlIHRpbWVzLCB3aXRoIHBvdGVudGlhbCBy
b2xsYmFja3Mgb24gZXJyb3Igb3IgaW52YWxpZA0KPiA+IGludGVybWVkaWF0ZSBwb3NpdGlvbnMs
IGV2ZW4gdGhvdWdoIHRoaXMgdmFyaWFibGUgaXMgYWxzbyB1c2VkIGluIHRoZQ0KPiA+IFRYIGNv
bXBsZXRpb24gcGF0aC4gVXNlIFJFQURfT05DRSBhbmQgV1JJVEVfT05DRSB0byBtYWtlIHRoaXMg
dXBkYXRlDQo+ID4gbW9yZSBhdG9taWMsIGFuZCBtb3ZlIHRoZSB3cml0ZSBiZWZvcmUgdGhlIE1N
SU8gd3JpdGUgdG8gc3RhcnQgdGhlDQo+ID4gdHJhbnNmZXIsIHNvIGl0IGlzIHByb3RlY3RlZCBi
eSB0aGF0IGltcGxpY2l0IHdyaXRlIGJhcnJpZXIuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTog
Um9iZXJ0IEhhbmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+ID4gLS0tDQo+ID4g
IC4uLi9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYyB8IDIzICsrKysr
KysrKysrLS0tLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDEw
IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+ID4gaW5kZXggZDZmYzNmN2FjZGYwLi4y
ZjM5ZWI0ZGUyNDkgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54
L3hpbGlueF9heGllbmV0X21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hp
bGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4gPiBAQCAtODA3LDEyICs4MDcsMTUgQEAgYXhp
ZW5ldF9zdGFydF94bWl0KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdA0KPiA+IG5ldF9kZXZp
Y2UgKm5kZXYpDQo+ID4gIAl1MzIgY3N1bV9pbmRleF9vZmY7DQo+ID4gIAlza2JfZnJhZ190ICpm
cmFnOw0KPiA+ICAJZG1hX2FkZHJfdCB0YWlsX3AsIHBoeXM7DQo+ID4gKwl1MzIgb3JpZ190YWls
X3B0ciwgbmV3X3RhaWxfcHRyOw0KPiA+ICAJc3RydWN0IGF4aWVuZXRfbG9jYWwgKmxwID0gbmV0
ZGV2X3ByaXYobmRldik7DQo+ID4gIAlzdHJ1Y3QgYXhpZG1hX2JkICpjdXJfcDsNCj4gPiAtCXUz
MiBvcmlnX3RhaWxfcHRyID0gbHAtPnR4X2JkX3RhaWw7DQo+ID4gKw0KPiA+ICsJb3JpZ190YWls
X3B0ciA9IFJFQURfT05DRShscC0+dHhfYmRfdGFpbCk7DQo+IA0KPiBUaGlzIG9uZSBkb2VzIG5v
dCBuZWVkIFJFQURfT05DRSgpLg0KPiANCj4gV2Ugb25seSBuZWVkIHRvIHByb3RlY3QgcmVhZHMg
YW5kIHdyaXRlcyB3aGljaCBtYXkgcmFjZSB3aXRoIGVhY2ggb3RoZXIuDQo+IFRoaXMgcmVhZCBj
YW4ndCByYWNlIHdpdGggYW55IHdyaXRlLiBXZSBuZWVkIFdSSVRFX09OQ0UoKSBpbg0KPiBheGll
bmV0X3N0YXJ0X3htaXQoKSBhbmQgUkVBRF9PTkNFKCkgaW4geGllbmV0X2NoZWNrX3R4X2JkX3Nw
YWNlKCkuDQoNCk1ha2VzIHNlbnNlLCBjYW4gZml4IHRoYXQgdXAuDQoNCj4gDQo+IEJUVyBJJ20g
c2xpZ2h0bHkgbXVya3kgb24gd2hhdCB0aGUgcm1iKCkgaW4geGllbmV0X2NoZWNrX3R4X2JkX3Nw
YWNlKCkNCj4gZG9lcy4gTWVtb3J5IGJhcnJpZXIgaXMgYSBmZW5jZSwgbm90IGEgZmx1c2gsIEkg
ZG9uJ3Qgc2VlIHdoYXQgdHdvDQo+IGFjY2Vzc2VzIHRoYXQgcm1iKCkgaXMgc2VwYXJhdGluZy4N
Cg0KSSBiZWxpZXZlIHRoZSBpZGVhIGlzIHRvIGVuc3VyZSB0aGF0IHdlJ3JlIHNlZWluZyBhIGNv
bXBsZXRlIGRlc2NyaXB0b3IgdXBkYXRlDQpmcm9tIHRoZSBoYXJkd2FyZSAoaS5lLiB3aGF0IGRt
YV9ybWIgZG9lcyksIGFuZCBhbHNvIHRoYXQgdGhlIGxhc3Qgd3JpdGUgdG8NCnR4X2JkX3RhaWwg
d2lsbCBiZSB2aXNpYmxlIChiYXNpY2FsbHkgcGFpcmluZyB3aXRoIHRoZSBpbXBsaWNpdCB3cml0
ZSBiYXJyaWVyDQpmcm9tIHRoZSBJTyB3cml0ZSBpbiBheGllbmV0X3N0YXJ0X3htaXQpPw0KDQo+
IA0KPiA+ICsJbmV3X3RhaWxfcHRyID0gb3JpZ190YWlsX3B0cjsNCj4gPiAgDQo+ID4gIAludW1f
ZnJhZyA9IHNrYl9zaGluZm8oc2tiKS0+bnJfZnJhZ3M7DQo+ID4gLQljdXJfcCA9ICZscC0+dHhf
YmRfdltscC0+dHhfYmRfdGFpbF07DQo+ID4gKwljdXJfcCA9ICZscC0+dHhfYmRfdltvcmlnX3Rh
aWxfcHRyXTsNCj4gPiAgDQo+ID4gIAlpZiAoYXhpZW5ldF9jaGVja190eF9iZF9zcGFjZShscCwg
bnVtX2ZyYWcgKyAxKSkgew0KPiA+ICAJCS8qIFNob3VsZCBub3QgaGFwcGVuIGFzIGxhc3Qgc3Rh
cnRfeG1pdCBjYWxsIHNob3VsZCBoYXZlDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFy
ZHdhcmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4u
Y29tDQo=
