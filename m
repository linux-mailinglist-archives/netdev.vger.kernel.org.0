Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB476DC9E5
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 19:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjDJRU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 13:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjDJRUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 13:20:55 -0400
X-Greylist: delayed 889 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Apr 2023 10:20:53 PDT
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84392114
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 10:20:53 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AAgONf017834;
        Mon, 10 Apr 2023 13:05:19 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2176.outbound.protection.outlook.com [104.47.75.176])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3pu56692q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Apr 2023 13:05:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=II/HhvAlpBtjPUNSMdbi3wFZwowPujC9utSO/vU6l3MZW66lNbXLXYNJONzrvZJcH3c0ngz0wg8rXru1CfnPdn80icLyOAlPGravSu1bgeso7s/tAaYLWLLD690S0hdKdVJ2Mcwj3/8xVuRP/1pOGk0iahBl6HhoZV0gOKLzH7bBOzHhMs68H9K5ZpAhC8g7KZL0W25Z2k7DInvddNZ2P0fcrDB/yyUhMludxCMNhx80Sr8bFC5Zq2jfnYs4j3B3bt7752/9njulJoI5UwgydFCQ3TF4XSDZKZrL887wvQbnK2TQDb544CfxfDyExU9rIr4lAc1uFYc7IuM6moki2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7daVHu0MDaseqen5B3+zZDlh3Jck9vkDH8MqZHeQYvc=;
 b=IqsehKWA2aU1ogHIOtQERWLEJ7f94ii/TNrfaPMuBhBHwquP5noUoq8POdO2hYdvkUeyKiK/Jcdix7bz1rgEYUW90Bku7H8rXl12pOiSzhteBOu5kEQ7gJhQrPpC/czMpsB5vUBjQf+8na//ac+GL4fYEJNcGTdeCPZja2HOAu4qGhG3Kz1Cf2E4qVSXzNITKSipqS7+dYwkLpi1gdqrVP5m0xrRpM555NvyLd6Y408m1Vhe8GnRa5rTzeDvxNCsjYwp+ThlDKkUFkKcAgbfgXGJSWSGJ9+YhshlEvAJ0oBP9yT/5YtvzX6Rg0dR564EJi8EpA+2/9xkenYJyAh2xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7daVHu0MDaseqen5B3+zZDlh3Jck9vkDH8MqZHeQYvc=;
 b=rtaJYOYthM6hbOCorMXs/xStP78LQ1w9HIPFV3ITsq9YzdQSdp2E7mCUI8p1rlG2MsOZThbmsNBG0ismlcJevKiupETMSMAlMrca/PhHGUEZKN/qjNx09YblElWPRcrl18glv7g1O1ZqEFi2gjrsjCkqA9/1M4E4E8dxlD49eEM=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT2PR01MB5678.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:56::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 17:05:17 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6fe:504a:acc7:19d9]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6fe:504a:acc7:19d9%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 17:05:17 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "ingo.rohloff@lauterbach.com" <ingo.rohloff@lauterbach.com>
CC:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "tomas.melin@vaisala.com" <tomas.melin@vaisala.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "harini.katakam@xilinx.com" <harini.katakam@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/1] Alternative, restart tx after tx used bit read
Thread-Topic: [PATCH 0/1] Alternative, restart tx after tx used bit read
Thread-Index: AQHZaZip8Nu0fmRUUESltXR0JxXJMa8kygaA
Date:   Mon, 10 Apr 2023 17:05:17 +0000
Message-ID: <4a25cee610a8d54e491b863b1b6b6ff117fa9b0d.camel@calian.com>
References: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
         <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
In-Reply-To: <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: YT2PR01MB8838:EE_|YT2PR01MB5678:EE_
x-ms-office365-filtering-correlation-id: 423da36b-858c-4be8-a631-08db39e5c27d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +ZgPZ2Ppmn8g35vBYwMkAT45pv6EC/+hXc9vsOp625dYtJ8yJKsfpx23/ZcbknE08hlwIrU75UDAo0o1py77P9UyoJEOgUZTC6nzU+Nnv0rofYFg9aQA4ksEZzjIOfjXs0rMvmgh6/ExJPVwKpfUtiKrte08HqMplDKvI8ZjXmAE5CjPOO8fvaXSYqLuDsarMFyzML/TMiT7QGnXMQx3iN3CQwsw3CfMVAmyGAox5AFKfzkZcuchMANYltkTAnXWSDVIvVNLHL3VM7P9loHrFeFJuBHsWRS4iFMZso+IZkbCzTzM1Qwv1m96WnTRCnAyTn/3sb7jd72Kfp6vBSHU6ApGWRROSDjtxMNvmbotZVySSL3LeU5jqOfikgQco7/oZAtfswxAgcU1Pb4ZLaWWV9McH84t/rDpl5mSfmGj3MD00xNUCjYLWNEuc4LZQw+Zso95KZHhyOSOavChEsP4cS9EOPLCYKEHvGJKknq0N3pkTbxy12o5n2K1C9KhYOkbWnvQKyQ7LIjxpVSm//x+uHfRTOkohnEUmWfKNCVaCqOJ1dPWnX4shEY80+C4eGJIxV9P7rNcL5RMrZAzueeynFl/1/UNocf7V0PV8aJynFgMDY/iku1RMtx7WzVfGnLJ2p1KUW0kmCyApbzU4+bbRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199021)(71200400001)(478600001)(86362001)(15974865002)(83380400001)(36756003)(122000001)(38100700002)(38070700005)(2616005)(6486002)(2906002)(91956017)(54906003)(316002)(186003)(6512007)(6506007)(26005)(44832011)(66476007)(41300700001)(66446008)(8936002)(8676002)(6916009)(66556008)(64756008)(5660300002)(76116006)(66946007)(4326008)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0tFb250WFNOenRROWgzTmtRV0NCN2lHUmJrYTJFUFhkMUErZUFJQkpqUmxC?=
 =?utf-8?B?SnVVbi94K3RJTEtIZ1BuaU1TQ1B6aEQyY0s4QWFRa0ppa3dkMk5GYnJsWUVG?=
 =?utf-8?B?VnBpb1BjSm9WcDhoYkRjZlhOWCtqM2x1VlZtRE9NdlljQm1TZmxwUC91WS91?=
 =?utf-8?B?Z2ZYczdaM1YweUZKRno3K0RkanpqL3ZjRGVpY29WY01xRlljVDJ0MDBYMWdo?=
 =?utf-8?B?eVJUa2I5bEtxRzFuQkEwUnMwNEhxcVNDMFlYUW5kUFdrb3Q4d1lQdnBHbmNh?=
 =?utf-8?B?L1JBMmdQYlgvL2NEc3ZpMjJFbndtcE1UbnhKZGNrN1FBdXlESHppK1B4YzF5?=
 =?utf-8?B?c1ozaU1pZ2ptZk00NzVPRnBNZ0kwdkl3ZCtoQUtPM0ladHpvbnp5RDZDL0lV?=
 =?utf-8?B?VkJoQTRtMVQ3bmxXcFdOZ01pd2ErMCsxbFIzZTFLWSttdW5HRDlJb3V6ZnVu?=
 =?utf-8?B?eEVPYUdidDM5a2ZodEprVUNZZksvU25LVkk2VjE1aDNjVzIxbERZUE5KMGds?=
 =?utf-8?B?cXlwT2M2RWk0VmxKZkJEVDhOQW00eXNNQ3h5dzlqL0oyMVNGTHFSMThPbk9M?=
 =?utf-8?B?bnd1Y0ZFMWJsMUF6eVFVZmIxdnQwVVlFN3QwRTZuV2VTWGJIY0FRTGVIL0k3?=
 =?utf-8?B?QkFpNGc0NGRjZ1V5K0RwUjVTUUhWV0JiZm14SjNzR3dCZjdUTk5WcHVyVnRI?=
 =?utf-8?B?cnlWNlBVR2s1akVIeE00OVhsNXdMbXhyUzZlWUVqM1R1TmtmRnVzNjlKWlBF?=
 =?utf-8?B?dDllaGhKYTJFVDB6T0xiMEhEOTJKK2dVTThka1VQTWZLSVJ2SHp5ekdaN2NP?=
 =?utf-8?B?WktRak0vMGJKV29qVVhIdUlIV2pQYmVpeGl2M3FSeHUyMk5zVW94VnBqVWZr?=
 =?utf-8?B?WVFRU0h0WnpLRCtFNXRaa2FwTnM0V3ZBMzQwck9wWWpIdVFxTDlVTXpsK1du?=
 =?utf-8?B?ajN2ejFlaTNIV1VmTGtxVHYwSjhZNCsyWG1SNG1JMnR6UDZjbjhxNnZDM2Z4?=
 =?utf-8?B?bzgrc0phSkh3M2tVQm80VC9vTXdhWm5oT3pJdlVlNTJkdTc0bCtSR0tNTW42?=
 =?utf-8?B?Z3RtWE5EVmlYQUtFVXRrZDlMZ1I2cjlKV2llNk0zektiNk03cldvcDRGQUEy?=
 =?utf-8?B?Um9nZEYrN0ZuTkNGSXp1WnNoTmxvaXY0SHY4clBmUVhWUEJpWVVROWtEWUNS?=
 =?utf-8?B?ZE5XTVJieDRIL0VPNUtVcXJxUllSSml1NzVhS3liNlBER0FnNWpJTXB3dUND?=
 =?utf-8?B?T3VmMmdRNkpjTm1zOWt5eEU0MDMvbzE1ZVEyK0dCYk4rR1ZFRzBnQkI2VkJI?=
 =?utf-8?B?REprMDVzaFlqQ09RMWxwSFFoWjNNTktCTVgyRUFRWnVSLzlyMHFQOVB4ZXRs?=
 =?utf-8?B?QWlzeStuaHdRK1F1bk4wbEU2WHZ0Skw5VTdKREFJYWJFa21hZU9JOXVlaUpK?=
 =?utf-8?B?K3JDL3dtYnkrK1VLd3BRMFd1T3FXU1hNTnlFdTR5WW5CQVJMMnp4NUE3L1Bp?=
 =?utf-8?B?RFB3RkRMNkU2eGJ6MkhiOHBWWHI5N0xMLy9rbHhwM0xSRUoyRmNuNmNuSUdV?=
 =?utf-8?B?RzhGVmZoSkRoQ1M2T2FHNXVFby9qRjc2T2swc3JUMzIydWMvdGFzNkx3dC9m?=
 =?utf-8?B?Yk41em1WY2xnWGV3cHNLU2YrczdHVHRkT2N2SURYa2IwSjRuVTc1R0ZOeDFP?=
 =?utf-8?B?SG5HVDZ0Qm5wRC9LVmk2NEJvTXI4UmhQZkZ3bnAyNnkwa3g0eTcxc3ZDdmxW?=
 =?utf-8?B?emtMSlJXWDF2blUxa1hwc0w0V3NPek9jR2VBaEc2ZWthT3U0NXluK2VqZ3Nw?=
 =?utf-8?B?VjVUSTBwKzJEK05kNkhFY2pqam10WVh1UUlkeTBGZEdudzlETkl1ektrUHZB?=
 =?utf-8?B?bnhuakxRSWlnNFkvRlBwWlVTNU5VVTJoNWhsYnI2SGM0S1AyQzIyNVFlakJ3?=
 =?utf-8?B?dThnbDViQ2xxemdZeWZ0c2RNelZLQ25IVGNGZzlpVnBreDhLTGI2Y3lZQndG?=
 =?utf-8?B?MkgxUjZ6OFhFaE50Yk5yaXQxQlNEemNlRmsxRkgzc0szSXMyRk44anZxUzhX?=
 =?utf-8?B?S3J3bW1JUTcvbWl5UENSem9XbW9RSG0vVUF0YUgrWkw5b2JpU0tWMHRJNVRI?=
 =?utf-8?B?U0duT1k5NFFHdi9PaHRaRmV2TVc4V3NZYlYwSTNITEM2a1QvK0FsZm9ETEMr?=
 =?utf-8?B?NVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47A52FC956EC5F47899B824749DCBE6E@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?d0V3a09kN2huUDl0eUd2TEthZ2hXV1hJSzFiRlZ6SlhtVXBqY01JNVZKb01O?=
 =?utf-8?B?QUIyY2RtbldFUTVFWUltOUhLeXZBNTNGaTdaVS9RUFQ0dmxJUEdBeFNVNThx?=
 =?utf-8?B?a292V2dFWWMxM0J3ak9yOW85U3FTakFxN3pHVDU4c2xwU0pJaE9wU0VmTUJk?=
 =?utf-8?B?ZWkzaWEzaTlOTDd6TWUrYTZxQ1BVY05FS0dzNWxqSldXQzJrNzUwOStCYzRl?=
 =?utf-8?B?RWozSUt0ZlVSdFYwK0hQWjZZazJVMzBCNmp4eGNZMURJQ3lHV1l0elA5d0hC?=
 =?utf-8?B?emV3L2dmekJHdkszVGpaQS9aUVJyWHhrTk9tSlJaMkh2WGovcVFjLytrK3hs?=
 =?utf-8?B?UDVmRFdQaFZLelF5RkxTeE5MRjc4WDE0cHc4dHlOeHpQWGZDVzMybVVSUmJV?=
 =?utf-8?B?RmJGMUZ6WEpVOGZBV1J0dGNGZE5uNkJZNTBGNGJJSlhlcCszMkh2Z1k2TSsr?=
 =?utf-8?B?ajM0akdDUlV4KzYvdjlaRHZNNzhaT0dyUWRjZjUxVTM1R3BJdzhZbTRlenNC?=
 =?utf-8?B?R3BmK25TNnFDRGIzdys0QW9kc2NSNnM2eE5Hb2R1M0JHWXJlQ2dpU0tDYW15?=
 =?utf-8?B?OVdLWE92dXB1M2N5a1NKdkdmc3lMYVliOFFGd01mc0Z3U3RxWEFoMlVtSVM4?=
 =?utf-8?B?UHZwN0NEMFVyWWVxUFV3V29sdUNHOTVTQUVucndqcHYzUzhGS3hCUTZTa0Y5?=
 =?utf-8?B?VkVsa0h1WFZjaHJ0bzBFYlVyZlQyRE54VTgzOUllZlM4SmNPdjhEQVhxVXIx?=
 =?utf-8?B?bnFLcXBKY3ljcnkvWmFSUlVZd0xiNk0vTmNYWk1PaUE0a1Eyem5zdE40Q1Jm?=
 =?utf-8?B?ZW5ZZWREaUFLdk1aQXV2UEdLUGYvWnVnaVJXbWczbVRrYW9UVmVXYnlRemVq?=
 =?utf-8?B?aVNWUkJ1WUVaRTZqbUZLcmxJSHNPNTVqTE0vVkIyUzl0STBIaWJOU1V1dUp2?=
 =?utf-8?B?Z0pHc2oxZ052ZVlPWTBNeGt2Mk1Obk1qSW9EMDRBLzVuVzJ2YkVpUks3bDV2?=
 =?utf-8?B?UkdTSVN6WW9TSlFGRVVldTlueWJFN0tVU0dYNVdxRyswdzRzcTJ6ZVpaTFg2?=
 =?utf-8?B?UlJ4ZXl1YWxlckNIYWhrNjdYRDdOWTk3eUxXQVlHV09nMXBBSDVYMzIxY2pC?=
 =?utf-8?B?bVN0dVN3S253TjNOaSthbk9nSy9jbmR3ckJ0VVU0czZkbGtZd1BXSitReHUv?=
 =?utf-8?B?bG5acHRZZmdQbGUzYzlMZ0Q1OVJ3clhSNzg4aDBTTEVydGV3eU9mTjBTQ1Zq?=
 =?utf-8?B?QlZVWnM1SFpCcG9mK3hFTW5UdFhhWWJJMmttL2x2a1phTjJPRXNKQ0ZySExq?=
 =?utf-8?Q?boidBiemg2H08=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 423da36b-858c-4be8-a631-08db39e5c27d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 17:05:17.5938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dHOPdqXrRuc9vu6mmIQsOwUwpa3z3+gTBfj0LfdQD9pukyeaH9sfPTtio3KSvkn0KEVoZUJvZ9ubWSLiXSlwJkX6WB27q+RcTHuY8ey0hLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5678
X-Proofpoint-ORIG-GUID: mXhbSymakVZegsFGB4_FW7Ign-T3_7J1
X-Proofpoint-GUID: mXhbSymakVZegsFGB4_FW7Ign-T3_7J1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_12,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 clxscore=1011
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304100147
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTA0LTA3IGF0IDIzOjMzICswMjAwLCBJbmdvIFJvaGxvZmYgd3JvdGU6DQo+
IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2Fu
aXphdGlvbi4gRG8NCj4gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSByZWNvZ25pemUgdGhlIHNlbmRlcg0KPiBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZl
Lg0KPiANCj4gSSBhbSBzb3JyeTsgdGhpcyBpcyBhIGxvbmcgRS1NYWlsLg0KPiANCj4gSSBhbSBy
ZWZlcnJpbmcgdG8gdGhpcyBwcm9ibGVtOg0KPiANCj4gUm9iZXJ0IEhhbmNvY2sgd3JvdGU6DQo+
ID4gT24gV2VkLCAyMDIyLTAzLTIzIGF0IDA4OjQzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90
ZToNCj4gPiA+IE9uIFdlZCwgMjMgTWFyIDIwMjIgMTA6MDg6MjAgKzAyMDAgVG9tYXMgTWVsaW4g
d3JvdGU6DQo+ID4gPiA+ID4gRnJvbTogQ2xhdWRpdSBCZXpuZWEgPGNsYXVkaXUuYmV6bmVhQG1p
Y3JvY2hpcC5jb20+DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gT24gc29tZSBwbGF0Zm9ybXMgKGN1
cnJlbnRseSBkZXRlY3RlZCBvbmx5IG9uIFNBTUE1RDQpIFRYDQo+ID4gPiA+ID4gbWlnaHQgc3R1
Y2sNCj4gPiA+ID4gPiBldmVuIHRoZSBwYWNoZXRzIGFyZSBzdGlsbCBwcmVzZW50IGluIERNQSBt
ZW1vcmllcyBhbmQgVFgNCj4gPiA+ID4gPiBzdGFydCB3YXMNCj4gPiA+ID4gPiBpc3N1ZWQgZm9y
IHRoZW0uDQo+ID4gPiA+ID4gLi4uDQo+ID4gPiA+IE9uIFhpbGlueCBaeW5xIHRoZSBhYm92ZSBj
aGFuZ2UgY2FuIGNhdXNlIGluZmluaXRlIGludGVycnVwdA0KPiA+ID4gPiBsb29wDQo+ID4gPiA+
IGxlYWRpbmcgdG8gQ1BVIHN0YWxsLsKgIFNlZW1zIHRpbWluZy9sb2FkIG5lZWRzIHRvIGJlDQo+
ID4gPiA+IGFwcHJvcHJpYXRlIGZvcg0KPiA+ID4gPiB0aGlzIHRvIGhhcHBlbiwgYW5kIGN1cnJl
bnRseSB3aXRoIDFHIGV0aGVybmV0IHRoaXMgY2FuIGJlDQo+ID4gPiA+IHRyaWdnZXJlZA0KPiA+
ID4gPiBub3JtYWxseSB3aXRoaW4gbWludXRlcyB3aGVuIHJ1bm5pbmcgc3RyZXNzIHRlc3RzIG9u
IHRoZQ0KPiA+ID4gPiBuZXR3b3JrDQo+ID4gPiA+IGludGVyZmFjZS4NCj4gPiA+ID4gLi4uDQo+
ID4gPiBXaGljaCBrZXJuZWwgdmVyc2lvbiBhcmUgeW91IHVzaW5nP8KgIFJvYmVydCBoYXMgYmVl
biB3b3JraW5nIG9uDQo+ID4gPiBtYWNiICsNCj4gPiA+IFp5bnEgcmVjZW50bHksIGFkZGluZyBo
aW0gdG8gQ0MuDQo+ID4gLi4uDQo+ID4gSSBoYXZlbid0IGxvb2tlZCBhdCB0aGUgVFggcmluZyBk
ZXNjcmlwdG9yIGFuZCByZWdpc3RlciBzZXR1cCBvbg0KPiA+IHRoaXMgY29yZQ0KPiA+IGluIHRo
YXQgbXVjaCBkZXRhaWwsIGJ1dCB0aGUgZmFjdCB0aGUgY29udHJvbGxlciBnZXRzIGludG8gdGhp
cyAiVFgNCj4gPiB1c2VkDQo+ID4gYml0IHJlYWQiIHN0YXRlIGluIHRoZSBmaXJzdCBwbGFjZSBz
ZWVtcyB1bnVzdWFsLsKgIEknbSB3b25kZXJpbmcgaWYNCj4gPiBzb21ldGhpbmcgaXMgYmVpbmcg
ZG9uZSBpbiB0aGUgd3Jvbmcgb3JkZXIgb3IgaWYgd2UgYXJlIG1pc3NpbmcgYQ0KPiA+IG1lbW9y
eQ0KPiA+IGJhcnJpZXIgZXRjPw0KPiANCj4gSSBhbSBkZXZlbG9waW5nIG9uIGEgWnlucU1QIChV
bHRyYXNjYWxlKykgU29DIGZyb20gQU1EL1hpbGlueC4NCj4gSSBoYXZlIHNlZW4gdGhlIHNhbWUg
aXNzdWUgYmVmb3JlIGNvbW1pdCA0Mjk4Mzg4NTc0ZGFlNjE2OCAoIm5ldDoNCj4gbWFjYjoNCj4g
cmVzdGFydCB0eCBhZnRlciB0eCB1c2VkIGJpdCByZWFkIikNCj4gDQo+IFRoZSBzY2VuYXJpbyB3
aGljaCBzb21ldGltZXMgdHJpZ2dlcnMgaXQgZm9yIG1lOg0KPiANCj4gSSBoYXZlIGFuIGFwcGxp
Y2F0aW9uIHJ1bm5pbmcgb24gdGhlIFBDLg0KPiBUaGUgYXBwbGljYXRpb24gc2VuZHMgYSBzaG9y
dCBjb21tYW5kICh2aWEgVENQKSB0byB0aGUgWnlucU1QLg0KPiBUaGUgWnlucU1QIGFuc3dlcnMg
d2l0aCBhIGxvbmcgc3RyZWFtIG9mIGJ5dGVzIHZpYSBUQ1ANCj4gKGFyb3VuZCAyMzBLaUIpLg0K
PiBUaGUgUEMga25vd3MgdGhlIGFtb3VudCBvZiBkYXRhIGFuZCB3YWl0cyB0byByZWNlaXZlIHRo
ZSBkYXRhDQo+IGNvbXBsZXRlbHkuDQo+IFRoZSBQQyBnZXRzIHN0dWNrLCBiZWNhdXNlIHRoZSBs
YXN0IFRDUCBzZWdtZW50IG9mIHRoZSB0cmFuc2ZlciBnZXRzDQo+IHN0dWNrIGluIHRoZSBaeW5x
TVAgYW5kIGlzIG5vdCB0cmFuc21pdHRlZC4NCj4gWW91IGNhbiByZS10cmlnZ2VyIHRoZSBUWCBS
aW5nIGJ5IHBpbmdpbmcgdGhlIFp5bnFNUDoNCj4gVGhlIFBpbmcgYW5zd2VyIHdpbGwgcmUtdHJp
Z2dlciB0aGUgVFggcmluZywgd2hpY2ggaW4gdHVybiB3aWxsIGFsc28NCj4gdGhlbiBzZW5kIHRo
ZSBzdHVjayBJUC9UQ1AgcGFja2V0Lg0KPiANCj4gVW5mb3J0dW5hdGVseSB0cmlnZ2VyaW5nIHRo
aXMgcHJvYmxlbSBzZWVtcyB0byBiZSBoYXJkOyBhdCBsZWFzdCBJIGFtDQo+IG5vdCBhYmxlIHRv
IHJlcHJvZHVjZSBpdCBlYXNpbHkuDQo+IA0KPiBTbzogSWYgYW55b25lIGhhcyBhIG1vcmUgcmVs
aWFibGUgd2F5IHRvIHRyaWdnZXIgdGhlIHByb2JsZW0sDQo+IHBsZWFzZSB0ZWxsIG1lLg0KPiBU
aGlzIGlzIHRvIGNoZWNrIGlmIG15IHByb3Bvc2VkIGFsdGVybmF0aXZlIHdvcmtzIHVuZGVyIGFs
bA0KPiBjaXJjdW1zdGFuY2VzLg0KPiANCj4gSSBoYXZlIGFuIGFsdGVybmF0ZSBpbXBsZW1lbnRh
dGlvbiwgd2hpY2ggZG9lcyBub3QgcmVxdWlyZSB0byB0dXJuIG9uDQo+IHRoZSAiVFggVVNFRCBC
SVQgUkVBRCIgKFRVQlIpIGludGVycnVwdC4NCj4gVGhlIHJlYXNvbiB3aHkgSSB0aGluayB0aGlz
IGFsdGVybmF0aXZlIG1pZ2h0IGJlIGJldHRlciBpcywgYmVjYXVzZSBJDQo+IGJlbGlldmUgdGhl
IFRVQlIgaW50ZXJydXB0IGhhcHBlbnMgYXQgdGhlIHdyb25nIHRpbWU7IHNvIEkgYW0gbm90DQo+
IHN1cmUNCj4gdGhhdCB0aGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiB3b3JrcyByZWxpYWJseS4N
Cj4gDQo+IEFuYWx5c2lzOg0KPiBDb21taXQgNDA0Y2QwODZmMjllODY3ZiAoIm5ldDogbWFjYjog
QWxsb2NhdGUgdmFsaWQgbWVtb3J5IGZvciBUWCBhbmQNCj4gUlggQkQNCj4gcHJlZmV0Y2giKSBt
ZW50aW9uczoNCj4gDQo+IMKgwqDCoCBHRU0gdmVyc2lvbiBpbiBaeW5xTVAgYW5kIG1vc3QgdmVy
c2lvbnMgZ3JlYXRlciB0aGFuIHIxcDA3DQo+IHN1cHBvcnRzDQo+IMKgwqDCoCBUWCBhbmQgUlgg
QkQgcHJlZmV0Y2guIFRoZSBudW1iZXIgb2YgQkRzIHRoYXQgY2FuIGJlIHByZWZldGNoZWQNCj4g
aXMgYQ0KPiDCoMKgwqAgSFcgY29uZmlndXJhYmxlIHBhcmFtZXRlci4gRm9yIFp5bnFNUCwgdGhp
cyBwYXJhbWV0ZXIgaXMgNC4NCj4gDQo+IEkgdGhpbmsgd2hhdCBoYXBwZW5zIGlzIHRoaXM6DQo+
IEV4YW1wbGUgU2NlbmFyaW8gKFNXID09IGxpbnV4IGtlcm5lbCwgSFcgPT0gY2FkZW5jZSBldGhl
cm5ldCBJUCkuDQo+IDEpIFNXIGhhcyB3cml0dGVuIFRYIGRlc2NyaXB0b3JzIDAuLjcNCj4gMikg
SFcgaXMgY3VycmVudGx5IHRyYW5zbWl0dGluZyBUWCBkZXNjcmlwdG9yIDYuDQo+IMKgwqAgSFcg
aGFzIGFscmVhZHkgcHJlZmV0Y2hlZCBUWCBkZXNjcmlwdG9ycyA2LDcsOCw5Lg0KPiAzKSBTVyB3
cml0ZXMgVFggZGVzY3JpcHRvciA4IChjbGVhcmluZyBUWF9VU0VEKQ0KPiA0KSBTVyB3cml0ZXMg
dGhlIFRTVEFSVCBiaXQuDQo+IMKgwqAgSFcgaWdub3JlcyB0aGlzLCBiZWNhdXNlIGl0IGlzIHN0
aWxsIHRyYW5zbWl0dGluZy4NCj4gNSkgSFcgdHJhbnNtaXRzIFRYIGRlc2NyaXB0b3IgNy4NCj4g
NikgSFcgcmVhY2hlcyBkZXNjcmlwdG9yIDg7IGJlY2F1c2UgdGhpcyBkZXNjcmlwdG9yDQo+IMKg
wqAgaGFzIGFscmVhZHkgYmVlbiBwcmVmZXRjaGVkLCBIVyBzZWVzIGEgbm9uLWFjdGl2ZQ0KPiDC
oMKgIGRlc2NyaXB0b3IgKFRYX1VTRUQgc2V0KSBhbmQgc3RvcHMgdHJhbnNtaXR0aW5nLg0KPiAN
Cj4gRnJvbSBkZWJ1Z2dpbmcgdGhlIGNvZGUgaXQgc2VlbXMgdGhhdCB0aGUgVFVCUiBpbnRlcnJ1
cHQgaGFwcGVucywNCj4gd2hlbg0KPiBhIGRlc2NyaXB0b3IgaXMgcHJlZmV0Y2hlZCwgd2hpY2gg
aGFzIGEgVFhfVVNFRCBiaXQgc2V0LCB3aGljaCBpcw0KPiBiZWZvcmUNCj4gaXQgaXMgcHJvY2Vz
c2VkIGJ5IHRoZSByZXN0IG9mIHRoZSBoYXJkd2FyZToNCj4gV2hlbiBsb29raW5nIGF0IHRoZSBl
bmQgb2YgYSB0cmFuc2ZlciBpdCBzZWVtcyBJIGdldCBhIFRVQlINCj4gaW50ZXJydXB0LA0KPiBm
b2xsb3dlZCBieSBzb21lIG1vcmUgVFggQ09NUExFVEUgaW50ZXJydXB0cy4NCj4gDQo+IEFkZGl0
aW9uYWxseSB0aGF0IG1lYW5zIGF0IHRoZSB0aW1lIHRoZSBUVUJSIGludGVycnVwdCBoYXBwZW5z
LCBpdA0KPiBpcyB0b28gZWFybHkgdG8gd3JpdGUgdGhlIFRTVEFSVCBiaXQgYWdhaW4sIGJlY2F1
c2UgdGhlIGhhcmR3YXJlIGlzDQo+IHN0aWxsIGFjdGl2ZWx5IHRyYW5zbWl0dGluZy4NCj4gDQo+
IFRoZSBhbHRlcm5hdGl2ZSBJIGltcGxlbWVudGVkIGlzIHRvIGNoZWNrIGluIG1hY2JfdHhfY29t
cGxldGUoKSBpZg0KPiANCj4gMSkgVGhlIFRYIFF1ZXVlIGlzIG5vbi1lbXB0eSAodGhlcmUgYXJl
IHBlbmRpbmcgVFggZGVzY3JpcHRvcnMpDQo+IDIpIFRoZSBoYXJkd2FyZSBpbmRpY2F0ZXMgdGhh
dCBpdCBpcyBub3QgdHJhbnNtaXR0aW5nIGFueSBtb3JlDQo+IA0KPiBJZiB0aGlzIHNpdHVhdGlv
biBpcyBkZXRlY3RlZCwgdGhlIFRTVEFSVCBiaXQgd2lsbCBiZSB3cml0dGVuIHRvDQo+IHJlc3Rh
cnQgdGhlIFRYIHJpbmcuDQo+IA0KPiBJIGtub3cgZm9yIHN1cmUsIHRoYXQgSSBoaXQgdGhlIGNv
ZGUgcGF0aCwgd2hpY2ggcmVzdGFydHMgdGhlDQo+IHRyYW5zbWlzc2lvbiBpbiBtYWNiX3R4X2Nv
bXBsZXRlKCk7IHRoYXQncyB3aHkgSSBiZWxpZXZlIHRoZQ0KPiAiRXhhbXBsZSBTY2VuYXJpbyIg
SSBkZXNjcmliZWQgYWJvdmUgaXMgY29ycmVjdC4NCj4gDQo+IEkgYW0gc3RpbGwgbm90IHN1cmUg
aWYgd2hhdCBJIGltcGxlbWVudGVkIGlzIGVub3VnaDoNCj4gbWFjYl90eF9jb21wbGV0ZSgpIHNo
b3VsZCBhdCBsZWFzdCBzZWUgYWxsIGNvbXBsZXRlZCBUWCBkZXNjcmlwdG9ycy4NCj4gSSBzdGls
bCBiZWxpZXZlIHRoZXJlIGlzIGEgKHZlcnkgc2hvcnQpIHRpbWUgd2luZG93IGluIHdoaWNoIHRo
ZXJlDQo+IG1pZ2h0IGJlIGEgcmFjZToNCj4gMSkgSFcgY29tcGxldGVzIFRYIGRlc2NyaXB0b3Ig
NyBhbmQgc2V0cyB0aGUgVFhfVVNFRCBiaXQNCj4gwqDCoCBpbiBUWCBkZXNjcmlwdG9yIDcuDQo+
IMKgwqAgVFggZGVzY3JpcHRvciA4IHdhcyBwcmVmZXRjaGVkIHdpdGggYSBzZXQgVFhfVVNFRCBi
aXQuDQo+IDIpIFNXIHNlZXMgdGhhdCBUWCBkZXNjcmlwdG9yIDcgaXMgY29tcGxldGVkDQo+IMKg
wqAgKFRYX1VTRUQgYml0IG5vdyBpcyBzZXQpLg0KPiAzKSBTVyBzZWVzIHRoYXQgdGhlcmUgc3Rp
bGwgaXMgYSBwZW5kaW5nIFRYIGRlc2NyaXB0b3IgOC4NCj4gNCkgU1cgY2hlY2tzIGlmIHRoZSBU
R08gYml0IGlzIHN0aWxsIHNldCwgd2hpY2ggaXQgaXMuDQo+IMKgwqAgU28gdGhlIFNXIGRvZXMg
bm90aGluZyBhdCB0aGlzIHBvaW50Lg0KPiA1KSBIVyBwcm9jZXNzZXMgdGhlIHByZWZldGNoZWQs
c2V0IFRYX1VTRUQgYml0IGluDQo+IMKgwqAgVFggZGVzY3JpcHRvciA4IGFuZCBzdG9wcyB0cmFu
c21pc3Npb24gKGNsZWFyaW5nIHRoZSBUR08gYml0KS4NCj4gDQo+IEkgYW0gbm90IHN1cmUgaWYg
aXQgaXMgZ3VhcmFudGVlZCB0aGF0IDUpIGNhbm5vdCBoYXBwZW4gYWZ0ZXIgNCkuwqAgSWYNCj4g
NSkNCj4gaGFwcGVucyBhZnRlciA0KSBhcyBkZXNjcmliZWQgYWJvdmUsIHRoZW4gdGhlIGNvbnRy
b2xsZXIgc3RpbGwgZ2V0cw0KPiBzdHVjay4NCj4gVGhlIG9ubHkgaWRlYSBJIGNhbiBjb21lIHVw
IHdpdGgsIGlzIHRvIHJlLWNoZWNrIHRoZSBUR08gYml0DQo+IGEgc2Vjb25kIHRpbWUgYSBsaXR0
bGUgYml0IGxhdGVyLCBidXQgSSBhbSBub3Qgc3VyZSBob3cgdG8NCj4gaW1wbGVtZW50IHRoaXMu
DQoNCkkgd291bGQgaGF2ZSBhIHNpbWlsYXIgY29uY2VybiB0aGF0IGEgcmFjZSBjb25kaXRpb24g
bGlrZSB0aGF0IGNvdWxkDQpoYXBwZW4uIEkgc3VzcGVjdCBpbiBvcmRlciB0byBmaXggdGhpcyBw
cm9wZXJseSB3ZSB3b3VsZCBuZWVkIHRvIGtub3cNCm1vcmUgYWJvdXQgaG93IHRoaXMgcHJlZmV0
Y2ggbWVjaGFuaXNtIHdvcmtzIGFuZCBob3cgc29mdHdhcmUgd2FzDQpzdXBwb3NlZCB0byBjb3Bl
IHdpdGggaXQuIElmIGl0IHdvcmtzIGFzIHNpbXBsaXN0aWNhbGx5IGFzIHlvdQ0KZGVzY3JpYmVk
LCBpdCBzZWVtcyBsaWtlIGl0IHdvdWxkIGluZXZpdGFibHkgY2F1c2UgYSBidW5jaCBvZiBoYXJk
IHRvDQpoYW5kbGUgcmFjZSBjb25kaXRpb25zIGFuZCBpdCBtYXkgYmUgcHJlZmVyYWJsZSB0byBk
aXNhYmxlIGl0IGluIHRoZQ0KY29yZSBpZiBwb3NzaWJsZS4NCg0KPiANCj4gSXMgdGhlcmUgYW55
b25lIHdobyBoYXMgYWNjZXNzIHRvIGhhcmR3YXJlIGRvY3VtZW50YXRpb24sIHdoaWNoDQo+IHNo
ZWRzIHNvbWUgbGlnaHQgb250byB0aGUgd2F5IHRoZSBkZXNjcmlwdG9yIHByZWZldGNoaW5nIHdv
cmtzPw0KPiANCj4gc28gbG9uZw0KPiDCoCBJbmdvDQo+IA0KPiANCj4gSW5nbyBSb2hsb2ZmICgx
KToNCj4gwqAgbmV0OiBtYWNiOiBBIGRpZmZlcmVudCB3YXkgdG8gcmVzdGFydCBhIHN0dWNrIFRY
IGRlc2NyaXB0b3IgcmluZy4NCj4gDQo+IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9t
YWNiLmjCoMKgwqDCoMKgIHzCoCAxIC0NCj4gwqBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNl
L21hY2JfbWFpbi5jIHwgNjcgKysrKysrKysrLS0tLS0tLS0tLS0tLQ0KPiAtLQ0KPiDCoDIgZmls
ZXMgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKSwgNDQgZGVsZXRpb25zKC0pDQo+IA0KPiAtLQ0K
PiAyLjE3LjENCj4gDQoNCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNp
Z25lciwgQ2FsaWFuIEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg0KDQo=
