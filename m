Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E44751CA70
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385789AbiEEUTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385841AbiEEUT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:19:26 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5346A15A32
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:15:45 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245I4blk000990;
        Thu, 5 May 2022 16:15:29 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2171.outbound.protection.outlook.com [104.47.75.171])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fv458grjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 16:15:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eAepYCdk+ua7pSdCa8jkHuuQSqtWv5IcRZlDROu9RP3F7VaQax6+Q5k92/nm8r8GqO1R0JRxPKx2N82c/KggOI+hOHTK1ya59SwXiW2llnq6WKRxx87EvVpdTYaMFZSrDzuwen1R0NNJ+oDndjGZXCkBxStivjMTCK7ujxvJhHjp7JmfvSJvi8gCEO3RmEWD6/Io0SRK/D7w4D5wpEFvhInELGtgcrJ33ddIPadxCqfyjZtES9Pa4O9lC9OVPHWyQHymOLjI3eruCmyNLm4IaASOiFlO93OJJtXNuNXmK58Acuzs4yAFSBRFqU/XJxyQBPkgzyFmhpzlYmyYn2kg2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YM2cTwLj2tpf2rCWEQWK9FGlu4IDfOuxpGLg7upMEyc=;
 b=bXpe4+kwDmigxftGBFTKMik9erdzFWV1rts/W01v68nfm3tzBxhouSGI8lWPdfWwaScRKHbG1wiv2JRczL+STe7IO/aZIKfZ3V6wn5eG+TNK83MDD2oKWZ3wEsbjMdPJrMhPcc34/rD/6TCzyO/2+pZ5TNTXITmgZw1yUPk3SFYlJxYStdMJLL+1c9IOTwBxu19JxGv/88IQv+qcFiF+Cu10biIakVEvvo3krSMMtFe0RQIcLU6ivkLSwwIwq/fdK45N3fa2oax50/FWrqZNXUF2GK0FLVE0HUbeODEl1zvK1xzsdM55/hjtDKthWjifO8jIeUsVHDtK0re6HnixRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YM2cTwLj2tpf2rCWEQWK9FGlu4IDfOuxpGLg7upMEyc=;
 b=hthPo1XcnpYowFoD1/e3iZw7NAEQrip1AU5mVA45NSUWqsuFNaO8ysZ/f3sDoZqwST1hpR7tW0ezkMFQKPokVBhKk7duYgcxu+gyq4gqVsMygWQCce9yu0ERn1CrXV/gHsqrdM8r39fepYIdYE6E5wXdJCculX8mbkoaPPAuvMU=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YQXPR01MB4005.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:53::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 20:15:26 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 20:15:26 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "harinik@xilinx.com" <harinik@xilinx.com>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "radheys@xilinx.com" <radheys@xilinx.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Thread-Topic: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Thread-Index: AQHYXBiAdPySYflEJ0exYZgZgYcAxK0PlYFNgAD+0ACAAAmugIAADYUAgAAWAQA=
Date:   Thu, 5 May 2022 20:15:26 +0000
Message-ID: <6137b9b1e2c469d5e04705b6d6cc44ba1403a4ff.camel@calian.com>
References: <20220429222835.3641895-1-robert.hancock@calian.com>
         <SA1PR02MB856018755A47967B5842A4C4C7C19@SA1PR02MB8560.namprd02.prod.outlook.com>
         <20220504192028.2f7d10fb@kernel.org>
         <5376cbf00c18487b7b96d72396807ab195f53ddc.camel@calian.com>
         <20220505110817.74938ad8@kernel.org>
         <c714f499a07bc764c8f34c85cac596c3494b53e7.camel@calian.com>
In-Reply-To: <c714f499a07bc764c8f34c85cac596c3494b53e7.camel@calian.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8509638-809c-40c9-33a6-08da2ed3fe3c
x-ms-traffictypediagnostic: YQXPR01MB4005:EE_
x-microsoft-antispam-prvs: <YQXPR01MB4005BE5607C3A0F16FBF8A4EECC29@YQXPR01MB4005.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aeXYk8CYHnGGE8Zsx8XgP/U4i+JQPui/pA2iZwVtHHNTq2Rr0GgFb5UrVs/uLIF7HMm9DxnlqWvlL4hjubUdQIQhXvc1xotzjoPkwFRM9X35HTD49hYih+A7LsHsoS9Sius1ojx6vx9nPtlsX4wt2hQPyPKOw54EL2sqBqao8hC/Li4INTQs3T+wKRn/8QNLPgwXU9srlpiVqQPxP6xhYIg4Qee0oxxjg4ykRYOaBg2S+zWxk/5UyT4Cr6vCE7fTPBR2bXVQe0/Joj8PhlrPE5luXhLovFOQ0rOfo8DKE0UGs2UD8HHN5Arbk7np5e3IKFTvRmTGE9T6wBkjPFHerXcn5oALxf3YQV+sn+qqGUpI9wojM7MkDdFfRL3PiZRGyO1SKEbj3sEFa8GKNfEsLgoXyCXcuRCaGFNw2XzG5Ievr75fduVS8p6/AFr1J/9nkSCjRDfmdZcgO0LZGNsyx3SqzAFDR/0E4n1LipfgDpO5I+aF0MxxVNAS3yskvS6P3u2vwuM3NXtzKF3MWuaaPP3U8Bc/3sh1cZyEYrLebye5Ju7SvGJCvsoS2P1hCYc9SXzD+fJzjtt8skfcguFdWCTtAN3yQnblZtyps24QE98Tyjhh/1k+edMnIzSEcN5RFndBz76QLO/QQH5l+t2BPkCZPrbFqOhJ4AdhqaZ36qFBCQiLmuS61lTdn0bK521y5wLgJ/A+FPbpfvLNmnI69eC25KEU0e5CytDUY4UuBct4CyCkTP8jbW4eVPeFi3HQ6Qh1N+2gz7NAgwq083kQ9SO+X02E7AQaatV6/V57yIPD0zTJ6w9L59lx+Ol+5e1Ad/vgJh+sUMAHDrlQl8sq76eojReW9EM7yjbafhFRK9I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(6506007)(54906003)(26005)(6512007)(316002)(6916009)(44832011)(2616005)(508600001)(15974865002)(186003)(6486002)(36756003)(71200400001)(4326008)(38100700002)(76116006)(66946007)(38070700005)(2906002)(64756008)(66446008)(66476007)(66556008)(8676002)(122000001)(86362001)(83380400001)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVJPN1A4NlN2Vkt3QXZmalh4akVoaDVSMEZVc0JaNG9TZ2I5QzFYNFJtVTRB?=
 =?utf-8?B?emJTaVl2citEcmwxQjRWRzlnd3BFUVZqaEREcWViaHBqRlhUK1lUTm1oMTRx?=
 =?utf-8?B?S0JnUENycVZnWllzK1prMVhKNFdHalNGeDl4TGUzWjlMazhhN1BtUVFuaWth?=
 =?utf-8?B?YmIwSkZvdmJyQnJnMllBZ3BNQWU2UmFINy93RkU1b0plNUVRUXkwcVdHSE4w?=
 =?utf-8?B?NXVRQU1sNFdXSGl5SzhwUFpBOGJWSnFqcEdTUldMTStaMGwyREJYWVhtRCtO?=
 =?utf-8?B?WXRzQjFXaktGd3NNL29ZYWsrQ0hxYzZBYWh1bUlvaHFsNy9XbWxDSkV1NmRE?=
 =?utf-8?B?VXo4RSsvSHRQRDNWOXRKTmFYUlozRCt5Q1hpd1k1RTQ5NjhiTFV6c1BNSEtw?=
 =?utf-8?B?SEpvSWc3QytOQ3JCTE9WemYwM0dKVU1ZSC8rNlErd1laVTBlNWlwWTdFaE8y?=
 =?utf-8?B?bDJoRjlCMXdlOUFxUldtQUZyekJyWWkvc0l3c1lTQjhOT28ydUJ2OUd4Q1lN?=
 =?utf-8?B?dUNJYlF5T3ZCajU5NEt6SFpSc3lzZjBoN3dvbmZ1eXdINWk3UWlsZ1pvMFVB?=
 =?utf-8?B?TlpJUFdkNWEvQlJaOHlVUFlsQXBJak9aSHdiaWtxSzI5ZEJHZnFUbncvekx6?=
 =?utf-8?B?VGlwNnZDQmxhQUwxSVBKOWc1RjJHeHV2aVJicjRvdC9kbElXaGNBSFpRN1d5?=
 =?utf-8?B?UnBGMjVranZBeENKL0FjRlJJNmlKK2g2N0lHWTI0WExLSmZEUks5d3N2UWgx?=
 =?utf-8?B?Q3cwNjFmdzgyRzU2T2NrTVQ1eTBOY2xuQlhMNFRVNStIYkoxcXFrL1VGZS9X?=
 =?utf-8?B?aDRrdC90aGI5OFR5U3U3SE5XeHhCdFJ4MURMZkVCZytZLy9ENHF0MUhVYW9U?=
 =?utf-8?B?OThoTFAwQ1FEc3kwVmNvL2txajZaTnFxK0dxck9xWTJVdjhwMW5EaEpnQzkr?=
 =?utf-8?B?UkFSazBJVUJOTEZabFExdWZuVGxNRktUY01neFBGclI3L0lJZVFBdGJhVnJI?=
 =?utf-8?B?czJnR3NTTG85aFFIUStDc0wwSTNNM3MzL2U3Qy9SN24wTDdtRVhRbktMUzU1?=
 =?utf-8?B?Y2dEdTZXR0lGZERKb2JUTXBlTm5XcTlRa0NzV1NPaUU0SlowY2Yrei95NWcy?=
 =?utf-8?B?d0g2U0RuM3dhc3ZoOVZ0Ri9SR0VBZytFeXlqVVFnTlJXZnVqaVBtemdSNFBX?=
 =?utf-8?B?NWQ5L0dQQWFMSHBmZVIyOUcwNlh3ci9TWFJFcUFUTXpuaWNianZTY0JRQk1r?=
 =?utf-8?B?V1g0cnVMUW1GVWtUZHQ5ZzVueXhKMVdaS2ZRK0lUYldYdG0wc0Rla2FYWWRR?=
 =?utf-8?B?NFZCeGMrMG9IZWN0a0RrU0Z1cGdxQU43YXpOWFZJYm5tZk10TFBiaHFlMkEz?=
 =?utf-8?B?RExxSy9kUVhSbUVzRzQ3NnZ5aTBsWDBSNG52RG9ZdnJOWkxWbVYwc3FJcnJa?=
 =?utf-8?B?Q1RKLzR5RURsSlhOMnNYaTYxUkJmZGtCRUJTdU9RQks2NXlJVDBFckVaSGRa?=
 =?utf-8?B?NGUxUE82RUxiSWRBNW5KZWxXVGp4ZXFQY2xLL0hGRE9CS2JIb2FMVE9GNlVQ?=
 =?utf-8?B?SXZ5WHJYRjgrWDgxU01McDBRRG5jb0xxbEtsVmZHUFNNUmlnMHk5MC9QQ3gy?=
 =?utf-8?B?djJQWEl4SGJ4MkhzcUEweEpFZUVCVmZReUtNLzBvL2hxMThiUFgwNk1nN2FJ?=
 =?utf-8?B?d3lIdXd5Mm5SMjVhT2ZhczBuVFduN1lVaFI3TlEwZjJxZ0tmdTFIdkNpS2wr?=
 =?utf-8?B?UEpqMk83cGFqQVVja3hBQ0w5a2EraGc2aFl4NkRGUDc2dFlWbmtjS2Iwc0du?=
 =?utf-8?B?L0tldVBpcGxEU1hhdHpldnZqUWNGK1pwTHpLT1A3Y1RSVnl4S2wyQlkydTdr?=
 =?utf-8?B?MkZxa3ZLWHpvOWgrMDVidTFjV2N2c01GODdYTHlObWVXVHlBREZPTTIxM3Jh?=
 =?utf-8?B?L0NiOW5hd05CblpuMlExa3hINmVPeEcvelFuZjdoV2NaNE4ydDJXSVlTKzNr?=
 =?utf-8?B?aEJkdUlJTFIxcmY4R2d1dHRMbVMvVlFXVStPRWE4VTkxZ0hTTStLVExJR0NR?=
 =?utf-8?B?TmUxREtBWGdhMEVjODg4azFGYmNIc2VXYWtRbTJUWXZoQnY0Vzk2bzcwUmpI?=
 =?utf-8?B?eHJCUXgybjM1azM0U0c1bXRtamI2aDQvM0JzZVkwdzZYOGhCbDBwckYvazBS?=
 =?utf-8?B?emdGSjR2cHdmSGJSNVNUQnIrajI5UVF4Q1JidHY5cExtTHJ4Y2FRdnlyM0xp?=
 =?utf-8?B?cXBQT29NWFVwRkZDRHE3MHFnTzJGWmN0OVVGZkhhZkV1RVAra09MYTdQeXZI?=
 =?utf-8?B?Z04rTjVIQVVzc3BjRXU5enBtUzM4a1IzN2tXN1RGa1N1SndVei9LbGkzOExk?=
 =?utf-8?Q?mQRiEsRokumg7i4w5hedRHLlN2VRx1Q03goJR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E7DEF3293B9C5428592C624A8C22566@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b8509638-809c-40c9-33a6-08da2ed3fe3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 20:15:26.4369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cfBWpEWzdKHNkBoV9p1GfbNSiNpenNEcMA9ixYoV/I/PEaqmb2Sen9/cSrbUcRVq76IVh43nFPda2wrQciZVmQK8ia9rnQJYNRalTTZOszM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB4005
X-Proofpoint-GUID: 281bolqpYEvLkapfxpnEn9k7joWyjwqy
X-Proofpoint-ORIG-GUID: 281bolqpYEvLkapfxpnEn9k7joWyjwqy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_08,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxlogscore=755 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050132
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA1LTA1IGF0IDEyOjU2IC0wNjAwLCBSb2JlcnQgSGFuY29jayB3cm90ZToN
Cj4gT24gVGh1LCAyMDIyLTA1LTA1IGF0IDExOjA4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90
ZToNCj4gPiBPbiBUaHUsIDUgTWF5IDIwMjIgMTc6MzM6MzkgKzAwMDAgUm9iZXJ0IEhhbmNvY2sg
d3JvdGU6DQo+ID4gPiBPbiBXZWQsIDIwMjItMDUtMDQgYXQgMTk6MjAgLTA3MDAsIEpha3ViIEtp
Y2luc2tpIHdyb3RlOg0KPiA+ID4gPiBPbiBNb24sIDIgTWF5IDIwMjIgMTk6MzA6NTEgKzAwMDAg
UmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZTogIA0KPiA+ID4gPiA+IFRoYW5rcyBmb3IgdGhlIHBh
dGNoLiBJIGFzc3VtZSBmb3Igc2ltdWxhdGluZyBoZWF2eSBuZXR3b3JrIGxvYWQgd2UNCj4gPiA+
ID4gPiBhcmUgdXNpbmcgbmV0cGVyZi9pcGVyZi4gRG8gd2UgaGF2ZSBzb21lIGRldGFpbHMgb24g
dGhlIGJlbmNobWFyaw0KPiA+ID4gPiA+IGJlZm9yZSBhbmQgYWZ0ZXIgYWRkaW5nIFRYIE5BUEk/
IEkgd2FudCB0byBzZWUgdGhlIGltcGFjdCBvbg0KPiA+ID4gPiA+IHRocm91Z2hwdXQuICANCj4g
PiA+ID4gDQo+ID4gPiA+IFNlZW1zIGxpa2UgYSByZWFzb25hYmxlIGFzaywgbGV0J3MgZ2V0IHRo
ZSBwYXRjaCByZXBvc3RlZCANCj4gPiA+ID4gd2l0aCB0aGUgbnVtYmVycyBpbiB0aGUgY29tbWl0
IG1lc3NhZ2UuICANCj4gPiA+IA0KPiA+ID4gRGlkbid0IG1lYW4gdG8gaWdub3JlIHRoYXQgcmVx
dWVzdCwgbG9va3MgbGlrZSBJIGRpZG4ndCBnZXQgUmFkaGV5J3MNCj4gPiA+IGVtYWlsDQo+ID4g
PiBkaXJlY3RseSwgb2RkLg0KPiA+ID4gDQo+ID4gPiBJIGRpZCBhIHRlc3Qgd2l0aCBpcGVyZjMg
ZnJvbSB0aGUgYm9hcmQgKFhpbGlueCBNUFNvQyBaVTlFRyBwbGF0Zm9ybSkNCj4gPiA+IGNvbm5l
Y3RlZA0KPiA+ID4gdG8gYSBMaW51eCBQQyB2aWEgYSBzd2l0Y2ggYXQgMUcgbGluayBzcGVlZC4g
V2l0aCBUWCBOQVBJIGluIHBsYWNlIEkgc2F3DQo+ID4gPiBhYm91dA0KPiA+ID4gOTQyIE1icHMg
Zm9yIFRYIHJhdGUsIHdpdGggdGhlIHByZXZpb3VzIGNvZGUgSSBzYXcgOTQxIE1icHMuIFJYIHNw
ZWVkIHdhcw0KPiA+ID4gYWxzbw0KPiA+ID4gdW5jaGFuZ2VkIGF0IDk0MSBNYnBzLiBTbyBubyBy
ZWFsIHNpZ25pZmljYW50IGNoYW5nZSBlaXRoZXIgd2F5LiBJIGNhbg0KPiA+ID4gc3Bpbg0KPiA+
ID4gYW5vdGhlciB2ZXJzaW9uIG9mIHRoZSBwYXRjaCB0aGF0IGluY2x1ZGVzIHRoZXNlIG51bWJl
cnMuDQo+ID4gDQo+ID4gU291bmRzIGxpa2UgbGluZSByYXRlLCBpcyB0aGVyZSBhIGRpZmZlcmVu
Y2UgaW4gQ1BVIHV0aWxpemF0aW9uPw0KPiANCj4gU29tZSBtZWFzdXJlbWVudHMgb24gdGhhdCBm
cm9tIHRoZSBUWCBsb2FkIGNhc2UgLSBpbiBib3RoIGNhc2VzIHRoZSBSWCBhbmQgVFgNCj4gSVJR
cyBlbmRlZCB1cCBiZWluZyBzcGxpdCBhY3Jvc3MgQ1BVMCBhbmQgQ1BVMyBkdWUgdG8gaXJxYmFs
YW5jZToNCj4gDQo+IEJlZm9yZToNCj4gDQo+IENQVTAgKFJYKTogMSUgaGFyZCBJUlEsIDEzJSBz
b2Z0IElSUQ0KPiBDUFUzIChUWCk6IDEyJSBoYXJkIElSUSwgMzAlIHNvZnQgSVJRDQo+IA0KPiBB
ZnRlcjoNCj4gDQo+IENQVTAgKFJYKTogPDElIGhhcmQgSVJRLCAyOSUgc29mdCBJUlENCj4gQ1BV
MyAoVFgpOiA8MSUgaGFyZCBJUlEsIDIxJSBzb2Z0IElSUQ0KPiANCj4gVGhlIGhhcmQgSVJRIHRp
bWUgaXMgZGVmaW5pdGVseSBsb3dlciwgYW5kIHRoZSB0b3RhbCBDUFUgdXNhZ2UgaXMgbG93ZXIg
YXMNCj4gd2VsbA0KPiAoNTYlIGRvd24gdG8gNTAlKS4gSXQncyBpbnRlcmVzdGluZyB0aGF0IHNv
IG11Y2ggb2YgdGhlIENQVSBsb2FkIGVuZGVkIHVwIG9uDQo+IHRoZSBDUFUgd2l0aCB0aGUgUlgg
SVJRIHRob3VnaCwgcHJlc3VtYWJseSBiZWNhdXNlIHRoZSBSWCBhbmQgVFggSVJRcyBhcmUNCj4g
dHJpZ2dlcmluZyB0aGUgc2FtZSBOQVBJIHBvbGwgb3BlcmF0aW9uLiBTaW5jZSB0aGV5J3JlIHNl
cGFyYXRlIElSUXMgdGhhdCBjYW4NCj4gYmUgb24gc2VwYXJhdGUgQ1BVcywgaXQgbWlnaHQgYmUg
YSB3aW4gdG8gdXNlIHNlcGFyYXRlIE5BUEkgcG9sbCBzdHJ1Y3R1cmVzDQo+IGZvciBSWCBhbmQg
VFggc28gdGhhdCBib3RoIENQVXMgYXJlbid0IHRyeWluZyB0byBoaXQgdGhlIHNhbWUgcmluZ3Mg
KFRYIGFuZA0KPiBSWCk/DQoNCkluZGVlZCwgaXQgYXBwZWFycyB0aGF0IHNlcGFyYXRlIFJYIGFu
ZCBUWCBOQVBJIHBvbGxpbmcgbG93ZXJzIHRoZSBDUFUgdXNhZ2UNCm92ZXJhbGwgYnkgYSBmZXcg
cGVyY2VudCBhcyB3ZWxsIGFzIGtlZXBpbmcgdGhlIFRYIHdvcmsgb24gdGhlIHNhbWUgQ1BVIGFz
IHRoZQ0KVFggSVJRLiBJJ2xsIHN1Ym1pdCBhIHYzIHdpdGggdGhlc2UgY2hhbmdlcyBhbmQgd2ls
bCBpbmNsdWRlIHRoZSBzb2Z0aXJxDQpudW1iZXJzIGluIHRoZSBjb21taXQgdGV4dC4NCg0KPiAN
Ci0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQ2FsaWFuIEFk
dmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg==
