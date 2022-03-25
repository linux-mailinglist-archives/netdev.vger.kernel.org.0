Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456DF4E6CA6
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 03:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349827AbiCYCwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 22:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiCYCwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 22:52:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41E1C5587
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 19:50:49 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22P0IXWb007140
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 19:50:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=uPYfSZ7kyFdbVez3ydHWj1sQm7gdagYWj4UmGhXVrAc=;
 b=HZy+DuwrB+bUnKHMyllAMviFA886obN2VFdQOileZSfJeWWrkjrEKZ53sAw+F4JjWwTE
 D3BskgY53qjsA6aBT94q5aXLzCWcrMSbjrgbRqXmqI3QYjg1UXdpHSfTMgh+D8tWM+3j
 9jK21O8HvqPL85c0wWdVvH4E5csqjcvi1n4= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f0n6vpcbu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 19:50:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYzTn6lLn+ai44qYV9BMEQj4VkArcbO9JhsvJZhylhXKtGAUHitHZ7JUTjrch2/o9N6lPa3odFPXstmcEYwLGle/X0Mm0726zmb0I5RTc2IGfkRbcYLCfREJcpFVKR+WKPAzv3G8ahurgHfXgyazypYvh9p/b5Uos0El4lwkMoOtmTiIk09Tz9f8ZfEPJg1zaWEh+U3fdf3A5A8R4MjFba4CPiRw9/QuK9t7CRQwrBVFUGwcq6Q0AARC7Se1WThAujLhAB2ZlzLno+QZPziwKJ8WgBjnt5cDRDuMBvP6QK/E26ZKPWPHXjDYMWTE8d8Kr1g3HU1/X67mGgRYGp0kOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhc6rRX/+bIbyZcxvry+OlsIF9O+GFWMhoJwchYrkWQ=;
 b=AgMbH3OAyZK3zLCrpDY0HyFuUwBQ6ZX0FSsRxCy17heJ8pY8vVa0I4sHtInig3+TOUFvkCm5PDf6QJJTFZNwBn0xsylyltMm+C+TdfFi+j//V3yWKpOEYIVU9Z97of39ZI635Ji4o2NJLcjPaL0iwmODkeQHXgYKAsg+VAzWkqkTLNugBBUv4kah8x0Ffwh/Y8hdHMdo34z92b3F1bV1m3M4XPq4XB7TbpOYOgnT2LUvGDFBIF96qsDg88343y1ebGPxLt3I/rDzzj8Z2VAyRePcvytzQWpAr+NGvxSvHlmeI318A+uUoHC4bbucc2DLcoaLBpHo0pSsZXo99AVi0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5137.namprd15.prod.outlook.com (2603:10b6:806:231::17)
 by BY5PR15MB3603.namprd15.prod.outlook.com (2603:10b6:a03:1f7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Fri, 25 Mar
 2022 02:50:46 +0000
Received: from SA1PR15MB5137.namprd15.prod.outlook.com
 ([fe80::3dfa:5b2b:a0ba:6013]) by SA1PR15MB5137.namprd15.prod.outlook.com
 ([fe80::3dfa:5b2b:a0ba:6013%5]) with mapi id 15.20.5102.016; Fri, 25 Mar 2022
 02:50:46 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "hawk@kernel.org" <hawk@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] skbuff: disable coalescing for page_pool recycling
Thread-Topic: [PATCH net] skbuff: disable coalescing for page_pool recycling
Thread-Index: AQHYP+v9rNfhpgkjFEWjkFcYD9uQwqzPYwhQ
Date:   Fri, 25 Mar 2022 02:50:46 +0000
Message-ID: <SA1PR15MB5137A34F08A624A565150338BD1A9@SA1PR15MB5137.namprd15.prod.outlook.com>
References: <20220324172913.26293-1-jean-philippe@linaro.org>
 <6dca1c23-e72e-7580-31ba-0ef1dfe745ad@huawei.com>
In-Reply-To: <6dca1c23-e72e-7580-31ba-0ef1dfe745ad@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9a83b6e-fb2e-42d4-c6f7-08da0e0a431f
x-ms-traffictypediagnostic: BY5PR15MB3603:EE_
x-microsoft-antispam-prvs: <BY5PR15MB360373F32D72DEB0CF9C4A76BD1A9@BY5PR15MB3603.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I2MjYBpp7RpH7D9SbSkrls+XJkje7Y0z6FhOo5YCC778thaTUbqNLVJmAohAL9SYU7T9QFmP5RgKlFDq6tWhvGcmAHH71k83m60zE5Z8xN4/fObVgIaCLr1+0dynPrCJTxX+tQqTJJfcfrLeqd9+QvhLOM9DvAalVqOQ964T4x4ZAf4tuOdUBs41xJ8rDyzcpyntkrcyz59GOJcMA0Pjpn0omJbNYVdqQbh2pumBuigIe3FXvSgYe0La2FWDvdoQ22LKVQzYbQnW4KiKMFVG/QN5qdqlptsdG06Iwzib1HxsSj6OxQpftex88ZBdX11028IpH2FT6+cupGwWAZLEN8tUoPwJ3fTLbaEx6pXPKP6gkqjheveNHRV80gueb93c1lGhx5ooGxCRFpIA3kw9oSeTk0CT1M9yiMrYIV4sFGaIZyio8yCOEQLuJleyC6hthHqONWnuiSgOxid9Ml3MV/I8/zUyC3vpT0v8cg7Z+Ofwvco3ie/cTlm7w5dRgjvwCrxnc2+CAV8L7IH/RjDdg1mlZt6mqvLbwXYClhrObdnyrAgXc4tJ5grXRAXC8PULglo+eXR/cWysWdKeInmUneowrlGhzGEcdV2zkFQKk5RmmNxJQDmLKral6NSz9ygLgtJHoKP52Fy+Ne3fLL9/2D1OG1AzZVXzrQbR37OH77IhmhVh+xz3Y/UjOeQSeygYmisa+kiMC26HaM7iL/dEkdlIkbXw9lXuJcMuWtSS5nbEXe8AJ6AuxECMFHpmGk/6UZgN5zLL3732Ix65YdNdQkkzGkGXVhD5qGwuU+4DbXA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5137.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(86362001)(966005)(8676002)(122000001)(54906003)(83380400001)(110136005)(8936002)(2906002)(55016003)(316002)(71200400001)(38070700005)(38100700002)(53546011)(4326008)(64756008)(66946007)(9686003)(52536014)(33656002)(66556008)(66476007)(508600001)(66446008)(5660300002)(7696005)(6506007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEdiN1pZUVNkYk1TZzBUcmFUcU9FUDZOMzBSQ0dDaHMrZDY1VXBGSThwa2hp?=
 =?utf-8?B?UlJVaG4yTk9PaE91S1doYmYrVzVwbmo4SEFvMGl6VUptSmtWR2M0ZFF0MnRw?=
 =?utf-8?B?a3AwMHNNNlUwQmlNcVpYSXdzQzc1cnpjTm9SSXJ5Zjlzd3R0ZnEzR2JYc3JE?=
 =?utf-8?B?cDFZSEhiOXNUNHZMc21Jd3hyd3Y2eE9BQk1idjgvZlBoNVBlbkVaWURhWjJC?=
 =?utf-8?B?ZGNqOFNlaXdHRDNKcTdNenhPVkRJa3Y5eE0yVjU0YXI3VitWQVZScDRZR2g2?=
 =?utf-8?B?cmJ5aTNrOHhaUUNQeEhJNm9qS2ljUWxzZzMrSk1PTllXVndnZGNQZ3FqOUJh?=
 =?utf-8?B?UGx5MWlJYUdnNWxtemVwLzBCQTcxUEJIaUw0VVhiaHNvQWx4Yy8xUTJpeXQ4?=
 =?utf-8?B?U0daQkFUY2M0dDluSEpmRGpuMkIySmsxNWdUNGJLV096N2IvUlNIemtaL1Bi?=
 =?utf-8?B?YTNPOGcvQ1pnRjAvWmNkdkd6K1NieU02RWF0U3hTSko4RVkrWWpQbXRUNnZt?=
 =?utf-8?B?RWhxQmZTVzJ4Y2lnNDhkeHRhTjNkNVZXeWR3Mmx6YmlJcnN2NzAzL252YVBw?=
 =?utf-8?B?RGNSZUdJZG1YaDNJRFI0T3pMVGtGWjllT2U0d0dQZGpZb2pMaUVMc1FJdDRp?=
 =?utf-8?B?TFRIUHJ6djhvTFZkbkRTd3VQdksxTlZPMElDTkZ3dWFPVFg0U0J4bEN6OXdF?=
 =?utf-8?B?SWVUNGhBZXVpcVVUQXpkUTZXb3BQZmR5OEEvWTIvY3F3S3lsYzIxbG1QQXk5?=
 =?utf-8?B?NFRhRVZucFhoQWNqaWxLWmdYdlZoM2xLek5YeEJnWklLcWxhRVBJbzAvT3pC?=
 =?utf-8?B?YVIzM3JFUUgvQ1ltZXNvaEVaamNOMnh2b2d4R1JTY0Z5cUZKVXo5ZkllSTNG?=
 =?utf-8?B?LzlqZTlVZUJ4RWFlNmdRYjVJQlhHRDJrMVpKNG04SVVqOWpmRGdzVFlQZnpU?=
 =?utf-8?B?L1VNSVp0VVFpRlhUM2RqNlhqMFAwQlFyOEg5eDFycjJ3OXdtLzA2Mk50Mk50?=
 =?utf-8?B?RFNBSFV1c2JvUXpNT3VWeVlEZGlsblZHKzZvcjlpa1Z6b3ZaUGpKd2wzSmF3?=
 =?utf-8?B?dmlCUXlqaStKcUhOclBtelg5NUhqT0xEM1poeGJiRktqcm5HSlJ2RHNJaTdZ?=
 =?utf-8?B?ekUzdTJyMGIrRmtaUHZ1TjdTY3VaM242Q0taVVhXYmlMcThrS1VJd3doTmFa?=
 =?utf-8?B?TG9CT1NVRzFZakgvbXRoL1I2QzlwelppZDZLUEZFN0tpSnJtd1J0VjhzeXBz?=
 =?utf-8?B?QmJYdnFjTmxtcnRMeWdIeDdYNm9aZmd0Mm9GL1pBTUYzTTJ1QVJlRU5PTjYv?=
 =?utf-8?B?Vno1MU9WNXJDNm9GRTlHNXlQTWs2WVFMbFNGaWUvb1prTi9oSkZDa0dRVEpn?=
 =?utf-8?B?THloU3k0eFI3ZkEyazlZK08vUWJ6cjhYWmdzbVN1RER1WHM5NHh3VlBseTlG?=
 =?utf-8?B?U2JmdndwdEVMQ2RJbHZkbDNnTkcybUUyQUdWcWJreFNoQ1lmeWR1RVpGcDc5?=
 =?utf-8?B?WHJLcFJQdDc2YlhRSUovSVNQaGcrQlhGUHRhZzFNZkhOL0svTXlkWC9hYnBa?=
 =?utf-8?B?SXN4cXZNaElPbWJnclhWMGJxSUJma0Qra2Y0MEVKV3Y1S1ord1JydVlGdnV2?=
 =?utf-8?B?a3REbFJ0QlRYc3RRNkVmZld6M2FRV1BZb2YvQVhsMVRjRVlwcmZQWGQ0R1g0?=
 =?utf-8?B?RFBwNm1BT05TdkRGaFhMbzRxclRHSHJqSmN5cmhtZWR0YkJ5QkVqVE1OZkhh?=
 =?utf-8?B?L3ZScGZJaHpKZnFQUm50eTgwcFdPM3UxSDdhTVc5bGszOTlNdzhBQWcxZXd2?=
 =?utf-8?B?Q2NpVk1KUWhDSXR3bTJ6KzJhSlFtbWtDZ1ZnY05wTHlPZU95Wm5vRlhDdXVI?=
 =?utf-8?B?K1N0VWw2M3FjM3pDOE5hRUtyZi9MUFVFMXJ6UDE3RHVRUEFnekNJOVZLaklR?=
 =?utf-8?B?b2ZiclFjRnRnSTZ3Tk9rZ0hBSkl2dVYyaGQwUG5oMkNmVDd2YUkyZnJnOEdo?=
 =?utf-8?B?QkNEOU5GRXdxRjFzamdhdUVQVk93U2d2NklWd2F5Qm1lSWh6T2FCREQwdm1S?=
 =?utf-8?B?OUF1aHM2R0hhbXBkV3RiMU5tVkxhWW1EUVIzVmkzRXVRZ0NjbWcxekZYRG5k?=
 =?utf-8?B?OXk1b3hCc1B5bExKUjhwZERERUtrWjJ1VWZ4enNqR3daazBvWVhDSm44VEpS?=
 =?utf-8?B?eW9SVW9YMzlaMnZUekhta2d4bzRSZVc5Mk9rVlZSdlZ0Vmc4NEw4dFFtbXBF?=
 =?utf-8?B?aDdaMUdXcnFNRXZyNXBNa0pMQzhaNnpkZkdQQnlCdmVyeVBsNjh4UzVjZlF5?=
 =?utf-8?B?TUpYUzcraTh0d2Q3VU9qY2FSbUdQRnQyQk5xWEwxVUZHelM0dlpQOS9aSjlm?=
 =?utf-8?Q?UfK8VLwiAKrI+b3JgCKWPsmTBn7hX3oturAkCxQ9CvGmE?=
x-ms-exchange-antispam-messagedata-1: grCwVGGfIW3JIQ==
Content-Type: text/plain; charset="utf-8"
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5137.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a83b6e-fb2e-42d4-c6f7-08da0e0a431f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2022 02:50:46.4026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cbzMUVf6KT9qwnHQh+3lCwGRt0ahC11SJh1nH8nAHVA31EX8TiFXN/E9HcM+sh9Q0QZY809IrFLnl32Z6qIpow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3603
X-Proofpoint-ORIG-GUID: 98PbIHEpByRnmfC22k7_mSoOg0XGjCfE
X-Proofpoint-GUID: 98PbIHEpByRnmfC22k7_mSoOg0XGjCfE
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_08,2022-03-24_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWXVuc2hlbmcgTGluIDxs
aW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMjQsIDIwMjIg
NzowMCBQTQ0KPiBUbzogSmVhbi1QaGlsaXBwZSBCcnVja2VyIDxqZWFuLXBoaWxpcHBlQGxpbmFy
by5vcmc+Ow0KPiBpbGlhcy5hcGFsb2RpbWFzQGxpbmFyby5vcmc7IGhhd2tAa2VybmVsLm9yZw0K
PiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0
LmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgQWxleGFuZGVyIER1eWNrIDxhbGV4YW5k
ZXJkdXlja0BmYi5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0XSBza2J1ZmY6IGRpc2Fi
bGUgY29hbGVzY2luZyBmb3IgcGFnZV9wb29sIHJlY3ljbGluZw0KPiANCj4gK2NjIEFsZXhhbmRl
ciBEdXljaw0KPiANCj4gT24gMjAyMi8zLzI1IDE6MjksIEplYW4tUGhpbGlwcGUgQnJ1Y2tlciB3
cm90ZToNCj4gPiBGaXggYSB1c2UtYWZ0ZXItZnJlZSB3aGVuIHVzaW5nIHBhZ2VfcG9vbCB3aXRo
IHBhZ2UgZnJhZ21lbnRzLiBXZQ0KPiA+IGVuY291bnRlcmVkIHRoaXMgcHJvYmxlbSBkdXJpbmcg
bm9ybWFsIFJYIGluIHRoZSBobnMzIGRyaXZlcjoNCj4gPg0KPiA+ICgxKSBJbml0aWFsbHkgd2Ug
aGF2ZSB0aHJlZSBkZXNjcmlwdG9ycyBpbiB0aGUgUlggcXVldWUuIFRoZSBmaXJzdCBvbmUNCj4g
PiAgICAgYWxsb2NhdGVzIFBBR0UxIHRocm91Z2ggcGFnZV9wb29sLCBhbmQgdGhlIG90aGVyIHR3
byBhbGxvY2F0ZSBvbmUNCj4gPiAgICAgaGFsZiBvZiBQQUdFMiBlYWNoLiBQYWdlIHJlZmVyZW5j
ZXMgbG9vayBsaWtlIHRoaXM6DQo+ID4NCj4gPiAgICAgICAgICAgICAgICAgUlhfQkQxIF9fX19f
X18gUEFHRTENCj4gPiAgICAgICAgICAgICAgICAgUlhfQkQyIF9fX19fX18gUEFHRTINCj4gPiAg
ICAgICAgICAgICAgICAgUlhfQkQzIF9fX19fX19fXy8NCj4gPg0KPiA+ICgyKSBIYW5kbGUgUlgg
b24gdGhlIGZpcnN0IGRlc2NyaXB0b3IuIEFsbG9jYXRlIFNLQjEsIGV2ZW50dWFsbHkgYWRkZWQN
Cj4gPiAgICAgdG8gdGhlIHJlY2VpdmUgcXVldWUgYnkgdGNwX3F1ZXVlX3JjdigpLg0KPiA+DQo+
ID4gKDMpIEhhbmRsZSBSWCBvbiB0aGUgc2Vjb25kIGRlc2NyaXB0b3IuIEFsbG9jYXRlIFNLQjIg
YW5kIHBhc3MgaXQgdG8NCj4gPiAgICAgbmV0aWZfcmVjZWl2ZV9za2IoKToNCj4gPg0KPiA+ICAg
ICBuZXRpZl9yZWNlaXZlX3NrYihTS0IyKQ0KPiA+ICAgICAgIGlwX3JjdihTS0IyKQ0KPiA+ICAg
ICAgICAgU0tCMyA9IHNrYl9jbG9uZShTS0IyKQ0KPiA+DQo+ID4gICAgIFNLQjIgYW5kIFNLQjMg
c2hhcmUgYSByZWZlcmVuY2UgdG8gUEFHRTIgdGhyb3VnaA0KPiA+ICAgICBza2Jfc2hpbmZvKCkt
PmRhdGFyZWYuIFRoZSBvdGhlciByZWYgdG8gUEFHRTIgaXMgc3RpbGwgaGVsZCBieQ0KPiA+ICAg
ICBSWF9CRDM6DQo+ID4NCj4gPiAgICAgICAgICAgICAgICAgICAgICAgU0tCMiAtLS0rLSBQQUdF
Mg0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBTS0IzIF9fLyAgIC8NCj4gPiAgICAgICAgICAg
ICAgICAgUlhfQkQzIF9fX19fX19fXy8NCj4gPg0KPiA+ICAoM2IpIE5vdyB3aGlsZSBoYW5kbGlu
ZyBUQ1AsIGNvYWxlc2NlIFNLQjMgd2l0aCBTS0IxOg0KPiA+DQo+ID4gICAgICAgdGNwX3Y0X3Jj
dihTS0IzKQ0KPiA+ICAgICAgICAgdGNwX3RyeV9jb2FsZXNjZSh0bz1TS0IxLCBmcm9tPVNLQjMp
ICAgIC8vIHN1Y2NlZWRzDQo+ID4gICAgICAgICBrZnJlZV9za2JfcGFydGlhbChTS0IzKQ0KPiA+
ICAgICAgICAgICBza2JfcmVsZWFzZV9kYXRhKFNLQjMpICAgICAgICAgICAgICAgIC8vIGRyb3Bz
IG9uZSBkYXRhcmVmDQo+ID4NCj4gPiAgICAgICAgICAgICAgICAgICAgICAgU0tCMSBfX19fXyBQ
QUdFMQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgIFxfX19fDQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgIFNLQjIgX19fX18gUEFHRTINCj4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAvDQo+ID4gICAgICAgICAgICAgICAgIFJYX0JEMyBfX19fX19fX18vDQo+ID4N
Cj4gPiAgICAgVGhlIHByb2JsZW0gaXMgaGVyZTogYm90aCBTS0IxIGFuZCBTS0IyIHBvaW50IHRv
IFBBR0UyIGJ1dCBTS0IxIGRvZXMNCj4gPiAgICAgbm90IGFjdHVhbGx5IGhvbGQgYSByZWZlcmVu
Y2UgdG8gUEFHRTIuDQo+IA0KPiBpdCBzZWVtcyB0aGUgU0tCMSAqZG9lcyogaG9sZCBhIHJlZmVy
ZW5jZSB0byBQQUdFMiBieSBjYWxsaW5nDQo+IF9fc2tiX2ZyYWdfcmVmKCksIHdoaWNoIGluY3Jl
bWVudHMgdGhlIHBhZ2UtPl9yZWZjb3VudCBpbnN0ZWFkIG9mDQo+IGluY3JlbWVudGluZyBwcF9m
cmFnX2NvdW50LCBhcyBza2JfY2xvbmVkKFNLQjMpIGlzIHRydWUgYW5kDQo+IF9fc2tiX2ZyYWdf
cmVmKCkgZG9lcyBub3QgaGFuZGxlIHBhZ2UgcG9vbA0KPiBjYXNlOg0KPiANCj4gSU5WQUxJRCBV
UkkgUkVNT1ZFRA0KPiByYzEvc291cmNlL25ldC9jb3JlL3NrYnVmZi5jKkw1MzA4X187SXchIUJ0
OFJaVW05YXchdTk0NFppQTd1ekJ1RnZjY3INCj4gcnRSMXh2b25kTE5ua01mNXh6TTh4YmJrb3Nv
dy12NXQtWGRaSmQ2Yk1zQnlNeDJLdyQNCg0KSSdtIGNvbmZ1c2VkIGhlcmUgYXMgd2VsbC4gSSBk
b24ndCBzZWUgYSBwYXRoIHdoZXJlIHlvdSBjYW4gdGFrZSBvd25lcnNoaXAgb2YgdGhlIHBhZ2Ug
d2l0aG91dCB0YWtpbmcgYSByZWZlcmVuY2UuDQoNClNwZWNpZmljYWxseSB0aGUgc2tiX2hlYWRf
aXNfbG9ja2VkKCkgd29uJ3QgbGV0IHlvdSBzdGVhbCB0aGUgaGVhZCBpZiB0aGUgc2tiIGlzIGNs
b25lZC4gQW5kIHRoZW4gZm9yIHRoZSBmcmFncyB0aGV5IGhhdmUgYW4gYWRkaXRpb25hbCByZWZl
cmVuY2UgdGFrZW4gaWYgdGhlIHNrYiBpcyBjbG9uZWQuDQoNCj4gIFdpdGhvdXQgY29hbGVzY2lu
Zywgd2hlbg0KPiA+ICAgICByZWxlYXNpbmcgYm90aCBTS0IyIGFuZCBTS0IzLCBhIHNpbmdsZSBy
ZWZlcmVuY2UgdG8gUEFHRTIgd291bGQgYmUNCj4gPiAgICAgZHJvcHBlZC4gTm93IHdoZW4gcmVs
ZWFzaW5nIFNLQjEgYW5kIFNLQjIsIHR3byByZWZlcmVuY2VzIHRvIFBBR0UyDQo+ID4gICAgIHdp
bGwgYmUgZHJvcHBlZCwgcmVzdWx0aW5nIGluIHVuZGVyZmxvdy4NCj4gPg0KPiA+ICAoM2MpIERy
b3AgU0tCMjoNCj4gPg0KPiA+ICAgICAgIGFmX3BhY2tldF9yY3YoU0tCMikNCj4gPiAgICAgICAg
IGNvbnN1bWVfc2tiKFNLQjIpDQo+ID4gICAgICAgICAgIHNrYl9yZWxlYXNlX2RhdGEoU0tCMikg
ICAgICAgICAgICAgICAgLy8gZHJvcHMgc2Vjb25kIGRhdGFyZWYNCj4gPiAgICAgICAgICAgICBw
YWdlX3Bvb2xfcmV0dXJuX3NrYl9wYWdlKFBBR0UyKSAgICAvLyBkcm9wcyBvbmUgcHBfZnJhZ19j
b3VudA0KPiA+DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIFNLQjEgX19fX18gUEFHRTENCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICBcX19fXw0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIFBBR0UyDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgLw0KPiA+ICAgICAgICAgICAgICAgICBSWF9CRDMgX19fX19fX19fLw0KPiA+DQo+ID4gKDQp
IFVzZXJzcGFjZSBjYWxscyByZWN2bXNnKCkNCj4gPiAgICAgQ29waWVzIFNLQjEgYW5kIHJlbGVh
c2VzIGl0LiBTaW5jZSBTS0IzIHdhcyBjb2FsZXNjZWQgd2l0aCBTS0IxLCB3ZQ0KPiA+ICAgICBy
ZWxlYXNlIHRoZSBTS0IzIHBhZ2UgYXMgd2VsbDoNCj4gPg0KPiA+ICAgICB0Y3BfZWF0X3JlY3Zf
c2tiKFNLQjEpDQo+ID4gICAgICAgc2tiX3JlbGVhc2VfZGF0YShTS0IxKQ0KPiA+ICAgICAgICAg
cGFnZV9wb29sX3JldHVybl9za2JfcGFnZShQQUdFMSkNCj4gPiAgICAgICAgIHBhZ2VfcG9vbF9y
ZXR1cm5fc2tiX3BhZ2UoUEFHRTIpICAgICAgICAvLyBkcm9wcyBzZWNvbmQNCj4gcHBfZnJhZ19j
b3VudA0KPiA+DQo+ID4gKDUpIFBBR0UyIGlzIGZyZWVkLCBidXQgdGhlIHRoaXJkIFJYIGRlc2Ny
aXB0b3Igd2FzIHN0aWxsIHVzaW5nIGl0IQ0KPiA+ICAgICBJbiBvdXIgY2FzZSB0aGlzIGNhdXNl
cyBJT01NVSBmYXVsdHMsIGJ1dCBpdCB3b3VsZCBzaWxlbnRseSBjb3JydXB0DQo+ID4gICAgIG1l
bW9yeSBpZiB0aGUgSU9NTVUgd2FzIGRpc2FibGVkLg0KDQpJIHRoaW5rIEkgc2VlIHRoZSBwcm9i
bGVtLiBJdCBpcyB3aGVuIHlvdSBnZXQgaW50byBzdGVwcyA0IGFuZCA1IHRoYXQgeW91IGFyZSBh
Y3R1YWxseSBoaXR0aW5nIHRoZSBpc3N1ZS4gV2hlbiB5b3UgY29hbGVzY2VkIHRoZSBwYWdlIHlv
dSBlbmRlZCB1cCBzd2l0Y2hpbmcgdGhlIHBhZ2UgZnJvbSBhIHBhZ2UgcG9vbCBwYWdlIHRvIGEg
cmVmZXJlbmNlIGNvdW50ZWQgcGFnZSwgYnV0IGl0IGlzIGJlaW5nIHN0b3JlZCBpbiBhIHBhZ2Ug
cG9vbCBza2IuIFRoYXQgaXMgdGhlIGlzc3VlLiBCYXNpY2FsbHkgaWYgdGhlIHNrYiBpcyBhIHBw
X3JlY3ljbGUgc2tiIHdlIHNob3VsZCBiZSBpbmNyZW1lbnRpbmcgdGhlIGZyYWcgY291bnQsIG5v
dCB0aGUgcmVmZXJlbmNlIGNvdW50LiBTbyBlc3NlbnRpYWxseSB0aGUgbG9naWMgc2hvdWxkIGJl
IHRoYXQgaWYgdG8tPnBwX3JlY3ljbGUgaXMgc2V0IGJ1dCBmcm9tIGlzIGNsb25lZCB0aGVuIHlv
dSBuZWVkIHRvIHJldHVybiBmYWxzZS4gVGhlIHByb2JsZW0gaXNuJ3QgdGhhdCB0aGV5IGFyZSBi
b3RoIHBwX3JlY3ljbGUgc2ticywgaXQgaXMgdGhhdCB0aGUgZnJvbSB3YXMgY2xvbmVkIGFuZCB3
ZSBhcmUgdHJ5aW5nIHRvIG1lcmdlIHRoYXQgaW50byBhIHBwX3JlY3ljbGUgc2tiIGJ5IGFkZGlu
ZyB0byB0aGUgcmVmZXJlbmNlIGNvdW50IG9mIHRoZSBwYWdlcy4NCg0KPiA+IEEgcHJvcGVyIGlt
cGxlbWVudGF0aW9uIHdvdWxkIHByb2JhYmx5IHRha2UgYW5vdGhlciByZWZlcmVuY2UgZnJvbSB0
aGUNCj4gPiBwYWdlX3Bvb2wgYXQgc3RlcCAoM2IpLCBidXQgdGhhdCBzZWVtcyB0b28gY29tcGxp
Y2F0ZWQgZm9yIGEgZml4LiBLZWVwDQo+ID4gaXQgc2ltcGxlIGZvciBub3csIHByZXZlbnQgY29h
bGVzY2luZyBmb3IgcGFnZV9wb29sIHVzZXJzLg0K
