Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CE459974F
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347699AbiHSIUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347470AbiHSITl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:19:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F74E727E;
        Fri, 19 Aug 2022 01:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660897153; x=1692433153;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BIYd2KecOPCcP9AaLcwIXR471o4JmtkvGBMeOSmxjsQ=;
  b=Ri8kZyH3vghVE8/NLOz48r4z9sAZQfnfYfLA6YS+6PAwG8vmMvELbZuA
   OO3NwBEpvSpECWxikGoTRNb6mgQAB9m5jGDIDuFxSAk5A2G2lq/WP/uMm
   1Hd/+aLGgjmLTmCgouI346d5iQSmziX/2Ao5xSKlT+DaBhgQz9UcoM11N
   4VOkG4HCxE+6ZT7bXLxtHbI7YwKpxdSF12cUcmu7qBDBC34BfeoS08NXD
   UlNubmM9xU9HJaqLS+9wVtkM9/5OCTDTsPvjWeH1n4ncZZH+nq2slK1eU
   aKglNqH6cigRNFT4H49rwdPc6kE4bAPTKGnHGPqQrHODg/VmCdbc1wPjQ
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="176898884"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Aug 2022 01:19:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 19 Aug 2022 01:19:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 19 Aug 2022 01:19:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiNtDtjo+QRehCoAn+jQ3Ls1HxPoLGTs7XB1jZozynDtHPQ4AHpRbjRHqdBd0ruxdmKlBJSpEBV4vfckos8RjjJPygBzu/anP8ciEJQUIDePfBofXPtj80CYxpIyWuILH/5xXbx+thrbYS1CxayAWEo7zu+t0Ta//O1d6r/hHhjJdZp4xdse7U/yxRjdqyZyGHLDa5rgInfml3zy9tUY1ewszl4jbKi/cvZKoYKgucTXh2ZNfyXHmRXR4ri22DbkfeWHQ7W/b7Pw+phK6EGOcgdLoeNZORT/xX5X9ha+kexpBXQH+UnpovOL1R44LSvhrJSzbb8QjzZGRdOwvHWL7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIYd2KecOPCcP9AaLcwIXR471o4JmtkvGBMeOSmxjsQ=;
 b=HHHTBzZVj/T//6HLMuOFDZeSAgm6Ofw0tccQqbwTUpqUc2YQUvB052TBBh+cWIzTqull/WtNJQRRqoh8JJMyB2S5agsBEJnQRyX87r0GJMzCf73cTKnN7DXtka2wiRHWHOxeds548ctWs/ALq9DEm9rGY62u0zXD5d93qnR/b1a4eZW6bfCdE89Pv57uzFpsIRBvISqbJbPdA69+hCehP/+bDZIt+Rcw5GFTi6Tt8QrMaEooN6+RJXBQYW5xGdLyihKZul02srp5SKNiQABF2tkVEXX6Jewiavx8BhbWC/5PFWgHVjqrkdpJFFkNxjQzhzKuPHLhkU1zIypwOowp+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIYd2KecOPCcP9AaLcwIXR471o4JmtkvGBMeOSmxjsQ=;
 b=bivdXucvOZtaC68PzqCvRe85EsCUEhnCe3JT7vps/YGtN/hu9/WridsGZxFIrZ8VyGorzeL2jQpSNK6a9csOWmMvtc7ky08KZF7h6T6akuEE0F+bclAJ9VRtx+I2vpZDyd3IoD23ebT2xdtCvp3RZkR9V4uPceDK1jDsT01HrLI=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by DM5PR11MB1706.namprd11.prod.outlook.com (2603:10b6:3:b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.18; Fri, 19 Aug 2022 08:19:06 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::7c6d:be4a:3377:7c4a]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::7c6d:be4a:3377:7c4a%5]) with mapi id 15.20.5525.011; Fri, 19 Aug 2022
 08:19:05 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <harini.katakam@amd.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <richardcochran@gmail.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <michal.simek@amd.com>,
        <radhey.shyam.pandey@amd.com>
Subject: Re: [RESEND PATCH 2/2] net: macb: Optimize reading HW timestamp
Thread-Topic: [RESEND PATCH 2/2] net: macb: Optimize reading HW timestamp
Thread-Index: AQHYs6RZOM1LVlOeGkec9uBJ0c6jXQ==
Date:   Fri, 19 Aug 2022 08:19:05 +0000
Message-ID: <8cd2b49d-4edd-0fe9-a5dc-af2905a90951@microchip.com>
References: <20220816115500.353-1-harini.katakam@amd.com>
 <20220816115500.353-3-harini.katakam@amd.com>
In-Reply-To: <20220816115500.353-3-harini.katakam@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 786523f7-7d52-4969-7a2c-08da81bb7b92
x-ms-traffictypediagnostic: DM5PR11MB1706:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0eQIMyxKgElDdK5Ob+Wg1oo0zqcF7szs01wcNkbouBPAoLhisFAFEH7GOBhWN7xwAuOc6kv64zqBXobU2KB8gQZ4XK64FcSS9u0Mphq+ke2yYQqSgvKUIyOhpNa4kXB0zdsTaUlaEVdfj/NRD16ZGJVgAhP9k2bMf+Pks45VO9fxZQZK57i+EvUTZC/sJIwxbMG1U75WD9mV84ogtI6l8sS+aboGfcUJtzok/TxXLsXZDQsD6bixnfVGNjqudih1pRoNKdd9k4tUDuLd3xgIe4+vnUEUoJjYgrnOgrZXQ7LF75j4ZrFTIR2zUy32DCT0V1t80ezwNo/92ZqTFJwFr9XCOuty30rezgiKX95qpiCcjNbFl8+vnMUbYdb5yEodurzVplCH3Z3YNlz9MpbamNuQQE6M68+N1yCZML0yugE2DJCjj51aWRXKBFpRXJNBQ4B6vGTFVMuTB8HFVRgjI2GMmD1K59PRd1rmcMj5GYM9xktF5G4Sc8WFsDgO6SfxekQo5B++HBSq5W/oxvkdcwacGJwEpxJZdIWulA30l7+/H75hZa8nOFmGWDMifqmtEOnjk5+6mzG7RsljVn614mHSdPQrcRCi2ZJP1BqYLLrycJAlJ2Rsmq5a6JvS8+hmEZgwLFUgUs1fZ9Tx6MFz9odoZxjOH1Oo76Fuok52ne8K3hIXMkhmtovR5n8tHUJy4UrTsbOFRLGVKl64tdxIzY6mzRYGtljinXlKoW13Lm2r+1TbRR5tWG5r04owKX1vNEx5Hgh8griHF0PhxjaEM9cSQr7GoaP0qUJ0M9CowVPe7yt8HNqW4EZQ9TC0mrdbJgEI+lSLFC1lB7ggSEQJXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(136003)(39860400002)(366004)(83380400001)(38070700005)(122000001)(38100700002)(316002)(478600001)(6486002)(7416002)(41300700001)(54906003)(8936002)(110136005)(5660300002)(2616005)(71200400001)(186003)(2906002)(6506007)(53546011)(6512007)(26005)(8676002)(76116006)(4326008)(66446008)(31686004)(66476007)(66556008)(86362001)(31696002)(66946007)(91956017)(64756008)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDZyaEQ3Q2kzS3JxUERFaVIwOUtZUDc5NmxRaVhSY2VEMGdaVFBaMWxtNzJT?=
 =?utf-8?B?NmovNWNXdE4wYmV4TXVYRXlhS0h5S2RlUlhzVzBWWUp0RERQYUpIMklWUWEx?=
 =?utf-8?B?S3BhdUZ2bFZQeGMvZjRKTGNtWWU5S0QyM2NJVGJ4Z1NxdlVES0FWVURWWFVX?=
 =?utf-8?B?MmhYMDFtMklwSGdTWWk0RVE4eDFQZktIc3NoYllvblJYRit2MFk1MFhLR0VD?=
 =?utf-8?B?WGpzZTBPSEVsMEc5N3hjMi8xSWwyeGMxMk1Nd3FjY3pEa2FwaS9LZSt6MFJH?=
 =?utf-8?B?ZUV5YmxOc3BRRmFmUWFOTmczWmRxMHlwb00vdlZTWk9BQzRsUjg3eHpqZExY?=
 =?utf-8?B?eUlyTjNUSWkxZXIxcVV3dGNZT2FHcmUvalk5bWM1bGtXdUJJd2R2Z3BZVkF2?=
 =?utf-8?B?UGN2WUdpZWNyeFZQb3dZN3ZOM1FZcVZGYzJJaEZ6Sk52Z09aV3g3RUlZTlAr?=
 =?utf-8?B?QXJDcUY0NitWa0lyWmQ1ZFRQWU1tUStkZ3E1Und4WW1wMDI4YUZjRnlldTFD?=
 =?utf-8?B?SjB6aWNNb0poYUc5b2JTbFlNbS9xWG05bGF1d1c1alo0T25QYUUxYU1nV0Qr?=
 =?utf-8?B?RGJpdGZvZ1hDVjRiU21wS3R4bFE5V21lY3JOcE1DS1hMTVNNUy9CVUlNRnht?=
 =?utf-8?B?L3ZpNXg3Z0s2OXVLaGw1S01kbG9OOTJXVHAzNVNaL09IU2hLU0RCYmxWZ0pt?=
 =?utf-8?B?WHJTMlJFeElzZnVXK085U3Znby9JZzBONk94TFJ4d2xLMTFJaHpLczVMR3RO?=
 =?utf-8?B?SXhrREY2ei9zc3hyZWkyL1RtU29USGVLU1F2VDVibmJJeXBkand2bU1zNnhv?=
 =?utf-8?B?VlNPYXhsMlB5bUNBN2d3aHFuV2N6UjlRL1lxWjVOVWprdjhkOTlOK1I0NG9k?=
 =?utf-8?B?MkJrSXBIOWdNSUNhc3VDeWxKbkJadC9nZzNvaU9WU0ZWekFiRVRFK3NNMzNZ?=
 =?utf-8?B?YkpXeEFyWTFFcXFIditjeDk2Q090WC9CdWlFVzF2bTRoM1gzQkNtR0VORW9W?=
 =?utf-8?B?Vm9SSVpsWnR5YWRoV01GRnE4SEhqNGpsYXpzdElTbWRuWk52V0xadUd5b3dM?=
 =?utf-8?B?aGNYNWZYWEdraVhwM3VxNDhmYmh4ZHYvYkdZZW1mdUVhSXZ0ZkxJWUxTTnhi?=
 =?utf-8?B?ZHJmb3lDZEtmNFBURklCWDIwb2cxZkcreVVVVkNkS0I4Vm8vckVlcUxQNUEv?=
 =?utf-8?B?NldVMU1YaXMyT01DaEIveTF4VTlyRU9zMkxZdTJtK2k5bThxSHJHTUgrYWV4?=
 =?utf-8?B?amFrMGx1R3gzQ1pqdkY4QUpIenhPMUpFU1l0MzFDVjErYTN1VXdFZDZLdlY0?=
 =?utf-8?B?L0pncTZwVy9TN2J1VEIydzFPNFlYY3BFSGkzcTNhNWJKYXp2azhPRXRhQ1Z6?=
 =?utf-8?B?OVpXR0xvZEF5KzcyS1BwcGRtdm9sRXE5QWNaL0dRMCtkRWZ4WnFhbitSYVZY?=
 =?utf-8?B?OUs5bW1KaUpLQmpNZ0lTYjVmZm9nNzJteFgzMG9XdUxEL1hjN2ZXV0MxY29k?=
 =?utf-8?B?NnBVKzZMcHdrenl3Y3VsOTJMbU1FSnR4NTR0N1VTdGV2VFNlL3RsMlVTR1VW?=
 =?utf-8?B?SEJ2bVhIeWZESHZVL0ZiODdPVDBqdkVqTUkreTJQZFV3WTlDbDc4Smd5by9J?=
 =?utf-8?B?ZkNvUFhUSUtpTmgvb3pSTHJHSHZoNERrUkc2RnoxZ0ZRd0k2MFlvbDRSRlhQ?=
 =?utf-8?B?WG13QlBzNFYxNUhwZjhtcWlaUHAxL2ZIcXpKYlh2enpuOTFhNG50MFl0dU1u?=
 =?utf-8?B?d0lyYnpHVEhiZkdGV3k4VGt0b1N4ZXpCSjFPaEhjdE9CMDdqKzkyQ3NsZ0JK?=
 =?utf-8?B?TmNuVUF2ZDFyZHE4ai9lY0t5UERzM3ZBRTUzdjg4eEhkYWZzS0cwdHNZN1gr?=
 =?utf-8?B?bjdJYXhFK2NUVXYrVG9yTHFYRGFKMHROMXpjQXI2c0xJQVpieWt2L3ZUTU5P?=
 =?utf-8?B?ZFlZNFJvY2JzVS93NHI0TEx4cVR5WGdwbEdEcTFmeks3SlRyVFpmenBQblQ2?=
 =?utf-8?B?L0hrWHA0TkFvaGJqbGhzN1RoQ3hiN215dEVxU3RhTng4Q3AwK2RFcXBxcFhu?=
 =?utf-8?B?bXc0K0tTSFIwY2xLMWNBejQ4Y3lGY2oxRW5MU2NVUHBtUzBaVWZyV0xzVXdk?=
 =?utf-8?Q?x5vZGtB4aZDQTdFJ2vLpsikZY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DDCEC5E8342C5347A80D04796D625AFE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 786523f7-7d52-4969-7a2c-08da81bb7b92
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 08:19:05.8254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wbK3LG4YQ617o36wtbcxZdaHMAfATTlxibo8oDfCRpPATwosh/tsCTvrkYwK354CKdeodcyQOWDY7u/8iOquvLO6r3mFvnhTHe6QUglQv7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1706
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDguMjAyMiAxNDo1NSwgSGFyaW5pIEthdGFrYW0gd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRnJvbTogSGFyaW5pIEthdGFrYW0gPGhhcmlu
aS5rYXRha2FtQHhpbGlueC5jb20+DQo+IA0KPiBUaGUgc2Vjb25kcyBpbnB1dCBmcm9tIEJEICg2
IGJpdHMpIGp1c3QgbmVlZHMgdG8gYmUgT1JlZCB3aXRoIHRoZQ0KPiB1cHBlciBiaXRzIGZyb20g
dGltZXIgaW4gdGhpcyBmdW5jdGlvbi4gQXZvaWQgKy8tIG9wZXJhdGlvbnMgZXZlcnkNCj4gc2lu
Z2xlIHRpbWUuIENoZWNrIGZvciBzZWNvbmRzIHJvbGxvdmVyIGF0IEJJVCA1IGFuZCBzdWJ0cmFj
dCB0aGUNCj4gb3ZlcmhlYWQgb25seSBpbiB0aGF0IGNhc2UuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBIYXJpbmkgS2F0YWthbSA8aGFyaW5pLmthdGFrYW1AeGlsaW54LmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogTWljaGFsIFNpbWVrIDxtaWNoYWwuc2ltZWtAeGlsaW54LmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUB4aWxpbnguY29t
Pg0KPiBBY2tlZC1ieTogUmljaGFyZCBDb2NocmFuIDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+
DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX3B0cC5jIHwgOCAr
KysrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2Jf
cHRwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfcHRwLmMNCj4gaW5kZXgg
ZTZjYjIwYWFhNzZhLi42NzQwMDI2NjEzNjYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2NhZGVuY2UvbWFjYl9wdHAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9j
YWRlbmNlL21hY2JfcHRwLmMNCj4gQEAgLTI0Nyw2ICsyNDcsNyBAQCBzdGF0aWMgaW50IGdlbV9o
d190aW1lc3RhbXAoc3RydWN0IG1hY2IgKmJwLCB1MzIgZG1hX2Rlc2NfdHNfMSwNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHUzMiBkbWFfZGVzY190c18yLCBzdHJ1Y3QgdGltZXNwZWM2
NCAqdHMpDQo+ICB7DQo+ICAgICAgICAgc3RydWN0IHRpbWVzcGVjNjQgdHN1Ow0KPiArICAgICAg
IGJvb2wgc2VjX3JvbGxvdmVyID0gZmFsc2U7DQo+IA0KPiAgICAgICAgIHRzLT50dl9zZWMgPSAo
R0VNX0JGRVhUKERNQV9TRUNILCBkbWFfZGVzY190c18yKSA8PCBHRU1fRE1BX1NFQ0xfU0laRSkg
fA0KPiAgICAgICAgICAgICAgICAgICAgICAgICBHRU1fQkZFWFQoRE1BX1NFQ0wsIGRtYV9kZXNj
X3RzXzEpOw0KPiBAQCAtMjY0LDkgKzI2NSwxMiBAQCBzdGF0aWMgaW50IGdlbV9od190aW1lc3Rh
bXAoc3RydWN0IG1hY2IgKmJwLCB1MzIgZG1hX2Rlc2NfdHNfMSwNCj4gICAgICAgICAgKi8NCj4g
ICAgICAgICBpZiAoKHRzLT50dl9zZWMgJiAoR0VNX0RNQV9TRUNfVE9QID4+IDEpKSAmJg0KPiAg
ICAgICAgICAgICAhKHRzdS50dl9zZWMgJiAoR0VNX0RNQV9TRUNfVE9QID4+IDEpKSkNCj4gLSAg
ICAgICAgICAgICAgIHRzLT50dl9zZWMgLT0gR0VNX0RNQV9TRUNfVE9QOw0KPiArICAgICAgICAg
ICAgICAgc2VjX3JvbGxvdmVyID0gdHJ1ZTsNCj4gKw0KPiArICAgICAgIHRzLT50dl9zZWMgfD0g
KCh+R0VNX0RNQV9TRUNfTUFTSykgJiB0c3UudHZfc2VjKTsNCg0KSXQgbG9va3MgdG8gbWUgdGhh
dCB0aGlzIGluc3RydWN0aW9uIGNvdWxkIGJlIG1vdmVkIGJlZm9yZQ0KDQo+ICAgICAgICAgaWYg
KCh0cy0+dHZfc2VjICYgKEdFTV9ETUFfU0VDX1RPUCA+PiAxKSkgJiYNCj4gICAgICAgICAgICAg
ISh0c3UudHZfc2VjICYgKEdFTV9ETUFfU0VDX1RPUCA+PiAxKSkpDQoNCmFuZCBnZXQgcmlkIG9m
IHNlY19yb2xvdmVyIGV4dHJhIHZhcmlhYmxlIHRodXMsIGluIHRoZSBlbmQsIHRoZSBkaWZmIGNv
dWxkDQpsb29rIGxpa2UgdGhpczoNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2NhZGVuY2UvbWFjYl9wdHAuYw0KYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2Jf
cHRwLmMNCmluZGV4IGU2Y2IyMGFhYTc2YS4uZjlkYjQ1MDFiOTk1IDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX3B0cC5jDQorKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2JfcHRwLmMNCkBAIC0yNTgsNiArMjU4LDggQEAgc3RhdGljIGlu
dCBnZW1faHdfdGltZXN0YW1wKHN0cnVjdCBtYWNiICpicCwgdTMyDQpkbWFfZGVzY190c18xLA0K
ICAgICAgICAgKi8NCiAgICAgICAgZ2VtX3RzdV9nZXRfdGltZSgmYnAtPnB0cF9jbG9ja19pbmZv
LCAmdHN1LCBOVUxMKTsNCg0KKyAgICAgICB0cy0+dHZfc2VjIHw9ICgofkdFTV9ETUFfU0VDX01B
U0spICYgdHN1LnR2X3NlYyk7DQorDQogICAgICAgIC8qIElmIHRoZSB0b3AgYml0IGlzIHNldCBp
biB0aGUgdGltZXN0YW1wLA0KICAgICAgICAgKiBidXQgbm90IGluIDE1ODggdGltZXIsIGl0IGhh
cyByb2xsZWQgb3ZlciwNCiAgICAgICAgICogc28gc3VidHJhY3QgbWF4IHNpemUNCkBAIC0yNjYs
OCArMjY4LDYgQEAgc3RhdGljIGludCBnZW1faHdfdGltZXN0YW1wKHN0cnVjdCBtYWNiICpicCwg
dTMyDQpkbWFfZGVzY190c18xLA0KICAgICAgICAgICAgISh0c3UudHZfc2VjICYgKEdFTV9ETUFf
U0VDX1RPUCA+PiAxKSkpDQogICAgICAgICAgICAgICAgdHMtPnR2X3NlYyAtPSBHRU1fRE1BX1NF
Q19UT1A7DQoNCi0gICAgICAgdHMtPnR2X3NlYyArPSAoKH5HRU1fRE1BX1NFQ19NQVNLKSAmIHRz
dS50dl9zZWMpOw0KLQ0KICAgICAgICByZXR1cm4gMDsNCiB9DQoNCj4gDQo+IC0gICAgICAgdHMt
PnR2X3NlYyArPSAoKH5HRU1fRE1BX1NFQ19NQVNLKSAmIHRzdS50dl9zZWMpOw0KPiArICAgICAg
IGlmIChzZWNfcm9sbG92ZXIpDQo+ICsgICAgICAgICAgICAgICB0cy0+dHZfc2VjIC09IEdFTV9E
TUFfU0VDX1RPUDsNCj4gDQo+ICAgICAgICAgcmV0dXJuIDA7DQo+ICB9DQo+IC0tDQo+IDIuMTcu
MQ0KPiANCg0K
