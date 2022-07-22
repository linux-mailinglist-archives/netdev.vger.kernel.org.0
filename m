Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2809857DC50
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbiGVIZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbiGVIZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:25:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188DF182;
        Fri, 22 Jul 2022 01:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658478305; x=1690014305;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0KBnTfq9Y82EJSFnfeaMs6NFwINHec+S6FSXodysQ3o=;
  b=1poPGRX/LSrsQVbnO5MhfcHKv5H6rY5VkS4AZ9/lvfAjKUHSuUZrBkjV
   njNcycz4fYvYyWPpXe/k9B1bsXU2qoForO6FSpnfOQ6y9a4Z4Eg0KjYaw
   fGxIjLWvH0c6E05IGQIdfwgyDtpvZJTD8ls5qua1X+l390M97OV/ljbzr
   /iOp9rI29ZmpnxHe3FuxIRRDF5HKLUd6ykW7HsqvVrcR/l2EajB3A25pw
   fkCjfNCxy/+zcZaurzRGD/nKheBMZYw2cCpRTONJMlXwtDAwV3YxS437/
   tadEnG8KRdD6LL8heNXNQPhmed7IoF/z9Ogve5FtbqrlxZAlOpUoh/5/Z
   w==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="173378474"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2022 01:25:04 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 22 Jul 2022 01:25:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 22 Jul 2022 01:25:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDm1Ovw19M7ifDCf2h5lbOWnF3Jj2drpo5MVQDh09VK46qNcfgQ+qqLscCysxNEOMC1trWptnstoSGyj7iiG8lYGPoqrhc3OFThxjXD0cC/vinMfZOdljwUjqrDapt3JmrZNDIZmy0+JEffF+Y2OyPOkTEzhz6kBzKRO357C5ZMBiWBnSZ3tOOchQaaWtjdrLDTzQzOnWlTqUhKEthqi9uF+KIVRCIIeXM2zfuVJsDlgpIVk9gBFv62qHM1+5IW2YvN5fa9OhJoCietaVwubrdlGMRWTEx8TnkTquMyDbnTTBFtcorqXIvVaxxBCG+q/AIFe6JtjT8ENJlKJ7KuLuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KBnTfq9Y82EJSFnfeaMs6NFwINHec+S6FSXodysQ3o=;
 b=nV6qJ1Ug3DaHpM1y/I5sE8tbe26LnHwUqppu0b6E0L8s5shYLQr/LijtdxoIb/R7lxokJbY9oU3Hgqm/LnIwYMRIWFAwpqLMDyMfyf9iSZgSqiGuIN7gVnc/CRYp+/mI5bYcFUL+U8D5JR2ygoxZ1bjthXtPmPUq8wHE851SMDMCEBJp9WVVH5U1mpeSOuiUP4CFAYNIR5f+shJtup0rEG5hOHaJnqB4G1GgkYSR6wDVE1Vlpc9FAZQOqAUcCtjAFJcF7DdvtVSR+9MbmuMNPnsWaAWRk0BRSu5bFKUt7SIh0drz49gGcIfydjN0jMeH55HKjlVPymUZpk5y/jLGSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KBnTfq9Y82EJSFnfeaMs6NFwINHec+S6FSXodysQ3o=;
 b=KWnU6anpgf/RxQpFS0XSR1tASC+uhD85LHPR2bbvfQdrLIwaN73dUvfGg2yh870EibXB3BgSf6E8rjr127TMoaJwjHHPfycVLtgQtjB/FFdnqxVLGbd1PfLuWotDoaMGjX5EFz+P9VBYiZ9gsiDeWlfNdS9cnN0qJ6zacFIokEc=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by BL0PR11MB3201.namprd11.prod.outlook.com (2603:10b6:208:6b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Fri, 22 Jul
 2022 08:25:01 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c%8]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 08:25:00 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <harini.katakam@xilinx.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <devicetree@vger.kernel.org>, <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH 2/2] net: macb: Update tsu clk usage in runtime
 suspend/resume for Versal
Thread-Topic: [PATCH 2/2] net: macb: Update tsu clk usage in runtime
 suspend/resume for Versal
Thread-Index: AQHYnaSIoc2DDpwwwUqlmmTwePsUVw==
Date:   Fri, 22 Jul 2022 08:25:00 +0000
Message-ID: <ba2a4652-31b0-e2c1-94cd-2552efef4f15@microchip.com>
References: <20220720112924.1096-1-harini.katakam@xilinx.com>
 <20220720112924.1096-3-harini.katakam@xilinx.com>
In-Reply-To: <20220720112924.1096-3-harini.katakam@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bb73f11-f24d-40f0-637b-08da6bbbab9a
x-ms-traffictypediagnostic: BL0PR11MB3201:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8w05GGEQPtt0rEghG2rPccThFk5DI4y9ltDnTw8AHAJRQxz2edRGNpVt77Y2a5zyfDeCH/Fh4owN/LwpGm36z1jujhMhYGjYezx1r2/gh9m0sAT1+3jgBsJYnXrfHFE5oa6tjq+mv+jcOAbd2HJHO0Z2Yl0bt4SoFqEcWIWguYiXkEznKGbD4eHEiFyHjD7UdOan/lw9V9kZpdfuKXe0lbLQaIaYhfpzDcr+NLIp0Dwlc4rYjcDdDf+BAep5IH8Zdh3zQkdgRX5IqrR2+Smxeaik8BLuT2Qh5BCWalrViyT+xEqFsr07vrYuK5afyn/tcTDriH+89SS1U+/Rdt/pD67KMftoM54FeuKQKJETNZeKWN4lYfp/R5JYerJA/jSK4iOJwlv1V8eRNBn1Cz/dzxUl+c1umOb9r90ienmQ0RQoswXZePw1qhgNFG4Zgnnxe2D1teQ8fjIIPRDXzcGUyUtlsOuBjSNzEL1ZM4rfl+hHzRw/B4OocoEfiKsRemTjmwYnmlR7crdQ4W2fKyQ7hZ2k5SgH5M1drkEMjh9x0p7ZYicaiQp9a9iyDheWVBd7Z5a/3q5kgVWx41+vUaaqyCFu8TsoeRxdBLeFao5jfqUiqk3sHnqNVKnmKTjtuRMgczcMBW5JwbtDcqg4RnIqDtLfAOhPQ2dd3rFe7WHCzGvJ8goIp5rtibKAmjcWg+2sFnaVgMGTddnAXUJWZVg6Q8Bqimtt2DtCN/C2eZPs+vcZzgOfmxbYht0mascDbFcTS0Bs0u6rGVWOKCB7t2J2rZ3fdcbL8h8uXqP4343EGftSfgY35Q+iPDs+2q886m8/oMxPBjaW5Yu2epXS8X+ZWjkgTY7ZPemuWDVSrsTcIMU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(346002)(396003)(366004)(6506007)(6486002)(2906002)(26005)(76116006)(91956017)(38100700002)(71200400001)(8676002)(4326008)(53546011)(64756008)(66476007)(66556008)(66946007)(122000001)(86362001)(6512007)(38070700005)(5660300002)(36756003)(8936002)(66446008)(110136005)(83380400001)(316002)(186003)(31686004)(2616005)(478600001)(54906003)(41300700001)(7416002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEJGY2xzSWFKbDIyMnVRZ0EzK1JRWWM5dEhvQjN3cFRBMEhHaHVxcENQTXpB?=
 =?utf-8?B?dTRHL092WUc5cTR2Y2FVb1ZIK2s2RVVlYWlabTIrMSt5UTNoTmdZdWNqcXdO?=
 =?utf-8?B?Z0ZFcnBZVmlySGd4VHVzVkxTbHZzY1hrc3RIWDB2cjZhQnA3dHVlTXBmdGZG?=
 =?utf-8?B?UXZCVkhUWnl3SGRjQXZGclpxTG1jejJDbWoxTUMzbGJmZnJ5T2k2cjQ3ZTZY?=
 =?utf-8?B?M2poNlR0ajRZTDBzUFRvV1NWM2dWaHZEaCsxcjZMU2NGRkhSaFZCd0hnQnpk?=
 =?utf-8?B?U1N6QTB0QUpEUVkyMlJ4OC96VkM3ZTI2OGhkbGJlZy9GODJab1M4aUZOMEl1?=
 =?utf-8?B?RWM0bDJRNjRJUEN5YUJhdU1CSnpscWFYNmFnMHBIWkxIZGRqUDNhcnRLTXp2?=
 =?utf-8?B?Y25jM2wzQTJqY2o1dXFxK0FOMmh5YVdHVC9qNUExdXJ4eUd0ZmFub3AzOEpK?=
 =?utf-8?B?SHdiMXZueEpBN2gwakptTDBnL3lNWkYxeU9QVmxZMXR5bHFjRUZBU1ZWQk43?=
 =?utf-8?B?SHdYN0VBcHBLaDJVb0owL1dwNzF4TXVvTjdRV1VVNGdHZldQSnBJM3RNRXdN?=
 =?utf-8?B?QytWNHdkY05tSjhFeVVwS0dObXdzQ05iamU5VGdUR2ZndFBXdWdYTk91OFU0?=
 =?utf-8?B?d2ZJN1hWU2kyQTdGd3ZQeDliRWQ5MGpGcGVVZjMrN3h0Y2I4bmNjZyt0R0R0?=
 =?utf-8?B?Wk1Wb2YwMXYyQTJtRmpGK2tCTmZLYWE5M04wdWNWM3FrZGkxSUlHRVN1cUxO?=
 =?utf-8?B?K1ZCc0kzeDJJaEhqdmRvYlZHTXZIekU2cG9OTHA2UTdjUUZ1bjF4RmNxUWd2?=
 =?utf-8?B?REhkWjVVbk5XRnNhbFF6T3RNanl5c2J0dWplckZVUnZSNlZGVnZBekdmR2dp?=
 =?utf-8?B?TDRBVXZHTW91SWtrUlRyMGdqMGhZVkVzOUtseGRENUF4bDJmYjZZUisvQTFW?=
 =?utf-8?B?ZUhQdHlCRVNqT2srREVuOE9ERmROejlRL2FwMHJBZmFjTWZUKzNHNkovamVl?=
 =?utf-8?B?aG5QSjJhWis0Mnd5T2orVGZ5RERFbkdqM2tkVlVzWjVzRm56ekZRaExjdlpH?=
 =?utf-8?B?dzBodVJVMVpxUlY5QTNWd1YzT1BJRTFCYzJMa28vUENKazV2blllNm5aRFgx?=
 =?utf-8?B?VlkwdGxXa1RNeHJ6djVKbHJ4a3JzSWlxR3FXYmZSWkJpU09QU0pXTVVsK0cy?=
 =?utf-8?B?ZThhcHhyOVJMMDlXdEs1bmhqbkJWdnlVeFhETWhyQVJzTWNiU2RFM0hwb2xU?=
 =?utf-8?B?dkl6cllqek9jMEk1VXRZcjAxQ2ptRmE2blpwd0xqUVd3QWtJL3Z3ZHZQWEQ3?=
 =?utf-8?B?SUVZbzQ2ai9KVStnMWVNNUpmeHRIQkNwR1k1dGQwRHlOd3lmK2x3YnRTSTRw?=
 =?utf-8?B?ejNxZDdWdmpMbGt4eGZkcE9kbnZ5Z2FLM3JXa0pKZ3dIMC9jRjBnZm5wd29h?=
 =?utf-8?B?VHE3eGlDU2FxM0lkemhNcEt4VWZ5VnA1M0NocytIcnI1RmtIcFZ0UGRyYmMz?=
 =?utf-8?B?RDExRDl4eWpkN1JUL0pPZGhobC9BeHVuSGNIVFlwWDBsdmlDMk1ocXFMOHYv?=
 =?utf-8?B?T2tid2g3ODhNUmJ6MzlrcldoUXc4d241MU8yWm81SmtFMGt6WEZ3WmlDamQz?=
 =?utf-8?B?c2FtcFBJalRjQklWVUg3TFpHdkFhcVJpZFgyQys0NjJpK0svejRzV2dteFdw?=
 =?utf-8?B?RU1CUVA2UWE1b3ltUEpjVVN6TGw1WVpVNmg4TTB1cXlMN0pBYjJwVDFVNlFv?=
 =?utf-8?B?eEhFbEhmUXVuQWlZTnJibHJxREhYSTlld3pJMkVaNG5OMkhGN2ZvaUFkMEtH?=
 =?utf-8?B?d2xGTE5sTHlPbk9PL0VXanVzNTB1eEtMZzdhczJaOGdWRmVxUkZpWVNzclpa?=
 =?utf-8?B?WnJnVTJ2N1RXc3NUMGZNVDd5MXZnY3B1ZVBpbnpCRi9ETkh5VFVMK1pUZW81?=
 =?utf-8?B?VHhHdlNJblFOL2p4RHRwcmtUSVEvQzI4OGpMTWl4YUR6Y3FEZHJTK1liRU1K?=
 =?utf-8?B?d1NnZFNUcG5rWmYvVXBkZDduajdObUFFd3lneE5kVjVuVFN1TDhpQW41V3p2?=
 =?utf-8?B?MlV2dkJuTWNHdUkzWFozWFVUZzErVXBscDFNd0NqQmhiK3BaTXQ2SEVUQXRG?=
 =?utf-8?B?TzhSMDQ0UExKb0hrQll6M0xhaGJHUE9VYmVtZXowaklORE5yUW9CL0tFNk4r?=
 =?utf-8?B?enc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <962C85AF58E3D144934E14C114ECBCA8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb73f11-f24d-40f0-637b-08da6bbbab9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 08:25:00.8268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a7W4t7t4tE+ubKnwgKnWvbB8XaKMJW0MG1Olm+MBm1eRyyxyxB7vHnXCo4RzF+wR2yS/z5D9vCN+LwVdpyFxCpmC3EwlKgPco0gTEmtd1es=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3201
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAuMDcuMjAyMiAxNDoyOSwgSGFyaW5pIEthdGFrYW0gd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gVmVyc2FsIFRTVSBjbG9jayBjYW5ub3Qg
YmUgZGlzYWJsZWQgaXJyZXNwZWN0aXZlIG9mIHdoZXRoZXIgUFRQIGlzDQo+IHVzZWQuIEhlbmNl
IGludHJvZHVjZSBhIG5ldyBWZXJzYWwgY29uZmlnIHN0cnVjdHVyZSB3aXRoIGEgIm5lZWQgdHN1
Ig0KPiBjYXBzIGZsYWcgYW5kIGNoZWNrIHRoZSBzYW1lIGluIHJ1bnRpbWVfc3VzcGVuZC9yZXN1
bWUgYmVmb3JlIGN1dHRpbmcNCj4gb2ZmIGNsb2Nrcy4NCj4gDQo+IE1vcmUgaW5mb3JtYXRpb24g
b24gdGhpcyBmb3IgZnV0dXJlIHJlZmVyZW5jZToNCj4gVGhpcyBpcyBhbiBJUCBsaW1pdGF0aW9u
IG9uIHZlcnNpb25zIDFwMTEgYW5kIDFwMTIgd2hlbiBRYnYgaXMgZW5hYmxlZA0KPiAoU2VlIGRl
c2lnbmNmZzEsIGJpdCAzKS4gSG93ZXZlciBpdCBpcyBiZXR0ZXIgdG8gcmVseSBvbiBhbiBTb0Mg
c3BlY2lmaWMNCj4gY2hlY2sgcmF0aGVyIHRoYW4gdGhlIElQIHZlcnNpb24gYmVjYXVzZSB0c3Ug
Y2xrIHByb3BlcnR5IGl0c2VsZiBtYXkgbm90DQo+IHJlcHJlc2VudCBhY3R1YWwgSFcgdHN1IGNs
b2NrIG9uIHNvbWUgY2hpcCBkZXNpZ25zLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGFyaW5pIEth
dGFrYW0gPGhhcmluaS5rYXRha2FtQHhpbGlueC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFJhZGhl
eSBTaHlhbSBQYW5kZXkgPHJhZGhleS5zaHlhbS5wYW5kZXlAeGlsaW54LmNvbT4NCj4gLS0tDQo+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2IuaCAgICAgIHwgIDEgKw0KPiAgZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDE3ICsrKysrKysrKysrKysr
Ky0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiLmgg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2IuaA0KPiBpbmRleCA3Y2EwNzdiNjVl
YWEuLjhiZjY3YjQ0YjQ2NiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2Fk
ZW5jZS9tYWNiLmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiLmgN
Cj4gQEAgLTcyNSw2ICs3MjUsNyBAQA0KPiAgI2RlZmluZSBNQUNCX0NBUFNfTUFDQl9JU19HRU0g
ICAgICAgICAgICAgICAgICAweDgwMDAwMDAwDQo+ICAjZGVmaW5lIE1BQ0JfQ0FQU19QQ1MgICAg
ICAgICAgICAgICAgICAgICAgICAgIDB4MDEwMDAwMDANCj4gICNkZWZpbmUgTUFDQl9DQVBTX0hJ
R0hfU1BFRUQgICAgICAgICAgICAgICAgICAgMHgwMjAwMDAwMA0KPiArI2RlZmluZSBNQUNCX0NB
UFNfTkVFRF9UU1VDTEsgICAgICAgICAgICAgICAgICAweDAwMDAxMDAwDQoNCkNhbiB5b3Uga2Vl
cCB0aGlzIHNvcnRlZCBieSB0aGUgYml0IHBvc2l0aW9uIHVzZWQ/DQoNCj4gDQo+ICAvKiBMU08g
c2V0dGluZ3MgKi8NCj4gICNkZWZpbmUgTUFDQl9MU09fVUZPX0VOQUJMRSAgICAgICAgICAgICAg
ICAgICAgMHgwMQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9t
YWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4g
aW5kZXggN2ViNzgyMmNkMTg0Li44YmJjNDZlOGE5ZWIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBAQCAtNDczNSw2ICs0NzM1LDE2IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25maWcgenlucW1wX2NvbmZpZyA9IHsNCj4gICAgICAgICAu
dXNyaW8gPSAmbWFjYl9kZWZhdWx0X3VzcmlvLA0KPiAgfTsNCj4gDQo+ICtzdGF0aWMgY29uc3Qg
c3RydWN0IG1hY2JfY29uZmlnIHZlcnNhbF9jb25maWcgPSB7DQo+ICsgICAgICAgLmNhcHMgPSBN
QUNCX0NBUFNfR0lHQUJJVF9NT0RFX0FWQUlMQUJMRSB8IE1BQ0JfQ0FQU19KVU1CTyB8DQo+ICsg
ICAgICAgICAgICAgICBNQUNCX0NBUFNfR0VNX0hBU19QVFAgfCBNQUNCX0NBUFNfQkRfUkRfUFJF
RkVUQ0ggfCBNQUNCX0NBUFNfTkVFRF9UU1VDTEssDQo+ICsgICAgICAgLmRtYV9idXJzdF9sZW5n
dGggPSAxNiwNCj4gKyAgICAgICAuY2xrX2luaXQgPSBtYWNiX2Nsa19pbml0LA0KPiArICAgICAg
IC5pbml0ID0gaW5pdF9yZXNldF9vcHRpb25hbCwNCj4gKyAgICAgICAuanVtYm9fbWF4X2xlbiA9
IDEwMjQwLA0KPiArICAgICAgIC51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+ICt9Ow0K
PiArDQoNCkFsc28sIGNvdWxkIHlvdSBrZWVwIHRoaXMgbm90IGIvdyB6eW5xIGNvbmZpZ3MgdG8g
aGF2ZSBhIGJpdCBvZiBzb3J0IG9mIHRoZXNlPw0KDQpPdGhlciB0aGFuIHRoaXM6DQoNClJldmll
d2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg0K
DQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIHp5bnFfY29uZmlnID0gew0KPiAg
ICAgICAgIC5jYXBzID0gTUFDQl9DQVBTX0dJR0FCSVRfTU9ERV9BVkFJTEFCTEUgfCBNQUNCX0NB
UFNfTk9fR0lHQUJJVF9IQUxGIHwNCj4gICAgICAgICAgICAgICAgIE1BQ0JfQ0FQU19ORUVEU19S
U1RPTlVCUiwNCj4gQEAgLTQ3OTQsNiArNDgwNCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2Zf
ZGV2aWNlX2lkIG1hY2JfZHRfaWRzW10gPSB7DQo+ICAgICAgICAgeyAuY29tcGF0aWJsZSA9ICJt
aWNyb2NoaXAsbXBmcy1tYWNiIiwgLmRhdGEgPSAmbXBmc19jb25maWcgfSwNCj4gICAgICAgICB7
IC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxzYW1hN2c1LWdlbSIsIC5kYXRhID0gJnNhbWE3ZzVf
Z2VtX2NvbmZpZyB9LA0KPiAgICAgICAgIHsgLmNvbXBhdGlibGUgPSAibWljcm9jaGlwLHNhbWE3
ZzUtZW1hYyIsIC5kYXRhID0gJnNhbWE3ZzVfZW1hY19jb25maWcgfSwNCj4gKyAgICAgICB7IC5j
b21wYXRpYmxlID0gImNkbnMsdmVyc2FsLWdlbSIsIC5kYXRhID0gJnZlcnNhbF9jb25maWd9LA0K
PiAgICAgICAgIHsgLyogc2VudGluZWwgKi8gfQ0KPiAgfTsNCj4gIE1PRFVMRV9ERVZJQ0VfVEFC
TEUob2YsIG1hY2JfZHRfaWRzKTsNCj4gQEAgLTUyMDMsNyArNTIxNCw3IEBAIHN0YXRpYyBpbnQg
X19tYXliZV91bnVzZWQgbWFjYl9ydW50aW1lX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2KQ0K
PiANCj4gICAgICAgICBpZiAoIShkZXZpY2VfbWF5X3dha2V1cChkZXYpKSkNCj4gICAgICAgICAg
ICAgICAgIG1hY2JfY2xrc19kaXNhYmxlKGJwLT5wY2xrLCBicC0+aGNsaywgYnAtPnR4X2Nsaywg
YnAtPnJ4X2NsaywgYnAtPnRzdV9jbGspOw0KPiAtICAgICAgIGVsc2UNCj4gKyAgICAgICBlbHNl
IGlmICghKGJwLT5jYXBzICYgTUFDQl9DQVBTX05FRURfVFNVQ0xLKSkNCj4gICAgICAgICAgICAg
ICAgIG1hY2JfY2xrc19kaXNhYmxlKE5VTEwsIE5VTEwsIE5VTEwsIE5VTEwsIGJwLT50c3VfY2xr
KTsNCj4gDQo+ICAgICAgICAgcmV0dXJuIDA7DQo+IEBAIC01MjE5LDggKzUyMzAsMTAgQEAgc3Rh
dGljIGludCBfX21heWJlX3VudXNlZCBtYWNiX3J1bnRpbWVfcmVzdW1lKHN0cnVjdCBkZXZpY2Ug
KmRldikNCj4gICAgICAgICAgICAgICAgIGNsa19wcmVwYXJlX2VuYWJsZShicC0+aGNsayk7DQo+
ICAgICAgICAgICAgICAgICBjbGtfcHJlcGFyZV9lbmFibGUoYnAtPnR4X2Nsayk7DQo+ICAgICAg
ICAgICAgICAgICBjbGtfcHJlcGFyZV9lbmFibGUoYnAtPnJ4X2Nsayk7DQo+ICsgICAgICAgICAg
ICAgICBjbGtfcHJlcGFyZV9lbmFibGUoYnAtPnRzdV9jbGspOw0KPiArICAgICAgIH0gZWxzZSBp
ZiAoIShicC0+Y2FwcyAmIE1BQ0JfQ0FQU19ORUVEX1RTVUNMSykpIHsNCj4gKyAgICAgICAgICAg
ICAgIGNsa19wcmVwYXJlX2VuYWJsZShicC0+dHN1X2Nsayk7DQo+ICAgICAgICAgfQ0KPiAtICAg
ICAgIGNsa19wcmVwYXJlX2VuYWJsZShicC0+dHN1X2Nsayk7DQo+IA0KPiAgICAgICAgIHJldHVy
biAwOw0KPiAgfQ0KPiAtLQ0KPiAyLjE3LjENCj4gDQoNCg==
