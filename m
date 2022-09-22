Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14EF5E639C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiIVNbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiIVNbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:31:08 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20138.outbound.protection.outlook.com [40.107.2.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2874FD4DD7;
        Thu, 22 Sep 2022 06:31:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvzxcxG5EbVJGp2tON8dnOEV2cJrtU4J2IVavOqRT4UrsNkLs8BlFBnnhsr0H0zf4y8POR1uOJPrU9fFgzl109cqO+TrEkmuQex7JLGjBjgt1fguZtfeNieos2oEg77iKtqWJvUs23I5UxhaXloiw5sWceSM9n5Pe8pz2Xx9T2+aQgs3HTLc0d1oQRcfxZjp1XLFdb0NZxoVP6qJGwNOQWEawGGfIMebckdMWeOMDDurVMOC+WMzbrTNozCPmjI/0mftzS2ZCjitpaCr9LGKQhmPKue5mddgCpTSeyTIgkU0OYDHW8E2T2uXMq2irrOSoC3RelBns8MohcFyyzyP7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V66tK6IDNHq+HemkS/3cs4nhqjrZRGvwmikp0ifayxw=;
 b=VO0LS5EJALqRFEHajSlA72Djjp6O4xlTe9iovSaerKIvamaJLp28Zcgvmk8ENVsmKktQDj3wVJx2zod4ETSUZiZPbsfyeszudgM7NB9KVvkZAb0ERshEDnmh7cLoMrPdtkIP6RnQIvmMsAyDj/bZrCC3/+FH3pL0V8HTCevOYn6Qws3YeEdTfADNy3VfkAWnyyTC+hBiH47JrTmwbjE/oxhLL9QSPkopGA0yBbweRoxdF4WPJbBJBAa/63KtBM7prCpYQBQQNYij29Y1k+X4awvzHflkKHl5utExfDuT0NWAz6nv8d/Jr0/z9txREo47tuwL9U5T5h9UfngG3uWaLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V66tK6IDNHq+HemkS/3cs4nhqjrZRGvwmikp0ifayxw=;
 b=Be/6UHSL4KaTWUVVqHBo2KTZLnpqzXLL6N4xeqsTh5XFlLgeXZ6cPKVpiZsQEC3rMpFiUEu+YXvh1ONENWezsx20MNi/FC+0VQDzFPWNH+PYfrk8fuidDpLRrruuWbUlgujVBR89mkchYwgCSr6R7QRUmSM5whpksGgTz8gIa0M=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB7581.eurprd03.prod.outlook.com (2603:10a6:10:2c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 13:30:57 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5654.016; Thu, 22 Sep 2022
 13:30:57 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>
CC:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Hector Martin <marcan@marcan.st>,
        "~postmarketos/upstreaming@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
Thread-Topic: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
Thread-Index: AQHYzU9sZdJlVhVGWUyliJ/pPXbpq63pTScAgAEZ+4CAAJqdAIAAPecAgAAsygCAAAgHAA==
Date:   Thu, 22 Sep 2022 13:30:57 +0000
Message-ID: <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk>
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
 <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
 <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
In-Reply-To: <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB7581:EE_
x-ms-office365-filtering-correlation-id: 5918ddb8-29a6-4b31-340c-08da9c9eae65
x-ld-processed: 210d08b8-83f7-470a-bc96-381193ca14a1,ExtAddr
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7lDrWBxzGcIu6eIO3rBkfJjsDqHUPMJxzk3Cq+IdDM7pyIbyP5DLvFUpN9rStfe+e2DHRCrlAQfu5XdZyFqSR5eWmUSE9590jBj1dGDC9GYIKmIIOXHbXpkuuuUdNRot34d9lFoTXssoXX41sXU5v653QPsuMI36HLCXA0Sfb7wPB7M4aNliNxh4N7gPodHsmCMMajAGrHX2hJUpnuipvIc0ZBghHjP3XDuK3K9H6RvGi5+0yt7yXQWmRrT6e3Ee0U2tYtvJgkSqeNk6vISWw1T7QaHMC0kmRUYkU73wz4DfE48FOLR/ND1XURu18ZB7zevCZZt4gPwb6AIpwmw3MjId4FMiWS9s5m6528bIFsswVWAgzvttFlkPAO726Iu8BNAPt+eYwQAEjwyAy4Cokb3Lviw2leNvx63N5KlYA2lXykSAGfwt8IfAxlxX3GmzWTURZl0QS0UTWjf14dt14kRN12Bpm8pyFdU7eoOP+Xe32O78Mx/RGfFNZPxV+vqgCKIvpLNXi1lyCBgSa3m3nFM5J/OcVdkQ9LirjD+gGMnI6msEMVuecWRhbjK4LumK0ZCJxQaUUBOsMWApypylh1qE6K+ueNw0PiB/3rz5VlFor+b0Xb/OpeREcNnScrcwWEJ67AwvZUJsq4bffum5u+IaazHKvniB4tgYi+1doR9hMnPWF2fa6UGhIqA1b4CtUgwl1HUwZezAsI1eY7oq8r3VovC7u2eRBnIugftMUW1IX+JgkuITtfTq36FRVAY0HiI1qrHIrvP7jY8Cm7AuRvRigENmX8IhKb7Jj+ooRQc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199015)(4326008)(26005)(6916009)(6512007)(66446008)(53546011)(54906003)(2616005)(71200400001)(186003)(91956017)(316002)(2906002)(966005)(1076003)(36756003)(6486002)(85182001)(8676002)(478600001)(64756008)(66946007)(66476007)(66556008)(38070700005)(41300700001)(86362001)(6506007)(76116006)(85202003)(38100700002)(7416002)(122000001)(5660300002)(8976002)(83380400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?andzYmRwUVVHOEtHWGNvclZhNkw0VVBHR0k3K3Z0MjM0MTliR0luZXBrUFE1?=
 =?utf-8?B?dmtBQkFKMkY4cW85TzFXN1R3R0VqS2xqdWg2YmROWUl4YktTempGNXdZUS92?=
 =?utf-8?B?TGdoNXNvLzBwdlFRZ3FiZUxIRWY2bFFZQ2dDblI0em9GYlNBa2xJbWhqUVh3?=
 =?utf-8?B?RXZrcnQyaW8yeXZ6b2NnMHJSQ0U5MStYWTdJTG9HU2NFNUkxYzN4cXRHL1pD?=
 =?utf-8?B?YTRDVmF6YVIvcmRsWS9MNDdEYXI2d2RVa2luN0l2U3FVejgxcmRNREZjRzM3?=
 =?utf-8?B?cDlCMnJ0Zmozc0s2NUgvMFVnNzU2alFGbXI5MExZS2tqR3Q4MTBWWnY2WTY5?=
 =?utf-8?B?L0ZqSkFHdUZJSDN2MndUL0FqY2hrSExxdlFCdlBCY3pMZ2lTVHEvMTBhUmsx?=
 =?utf-8?B?L0pIWkhXNXVSTU13dzdib2YraGRkUjZxR2JScjZUT3Yrby9QeEVESDcwNE5W?=
 =?utf-8?B?OGRvT1JZQVdJRGFEME01WGEvWEc0OXpja2NFSW5IbEpuUzZ4KytWeGRGNVM4?=
 =?utf-8?B?VmJnYTdIWnFCNzQ0WnRVOWZ5MjRwUi9PZkNNT1hWbEtzMzYxcDRLaGRzNHFM?=
 =?utf-8?B?WkRZTFZhRnhBV2lpMkw2aVIzTTE4SFdUL1ZtNmMzTWswcVBCaWVKV0gzYU92?=
 =?utf-8?B?MkNjWXA2dFRnRlZ1alZyRER0OFMxa0Vuc3RZNGlNRzFvbnBISXNNN0ZHVWs3?=
 =?utf-8?B?SXBaK2lyY0VzdjRyZXJjNDdBTVhqZmcrTlRLNjl6bDcrSHhqdzByK3d2aWIy?=
 =?utf-8?B?MnpiWnlVLytCdll2VGhCcElNWlczWEQyOUFqby8renNxVFhXT2tGaVE4bGxs?=
 =?utf-8?B?SDgzckRCMmh0dDZVdFZxUGJIazg1eTEyTlZ5TGNTS0FMcXZjMGVORmNRNXQw?=
 =?utf-8?B?ZlZmenhmdGVvY3p6dUpLVGRtUWRqcGViRWIwZC8yZ0FZSmJSV1dUaERJN0FN?=
 =?utf-8?B?ZTBtSFBLMmVOcEJaeEVidkFXTGZLOUJmNzdmdDYxS0FzamliS2cyMTAzSnU1?=
 =?utf-8?B?L1ZDbHo0dy8zVlJWSGptV3RJajU5UGN4RlM3anQyRm9hNWJuN05ISFk0VmNm?=
 =?utf-8?B?a0ptNFFpVWwzc0ttSHEwbUVuNXZNb1RvOWNpRHV4d1JkaFJEM0pNVWs5V2NE?=
 =?utf-8?B?TTFiWm9OaUdkcHE1Umw3bDZCaVZkUXRwei9EOVRPSWZ3ekNwb2lhdGxpb3p6?=
 =?utf-8?B?enE1a2NJNjJpaGNjVlkzZ295aS8vRTl2U2NnLzlWdEdFWXg0dkZNdGhwYXIy?=
 =?utf-8?B?ZnBtNUZJc2VjOVlOYkpRUWR1NnEweEhZemduUHZRYnlsK3FyMkZPTFNHWFRY?=
 =?utf-8?B?aGNGcGdJM3c5cHI0SGZTT3M3eUFSdnZCUFA0N2hPamQ1ajRDekkrVjl0N1E4?=
 =?utf-8?B?Ujl4ZFZYQ1RZYjZuYzU0RWR0RWpucVh4b1BlT0liQ3dFRjB1MFhXL0RwK0lH?=
 =?utf-8?B?TmZjcUwzOTI1aThvNnR6RWl4cWxOT3prRGJ0RVhHbEtMbk9ld2YrR2h2anJj?=
 =?utf-8?B?RnNZWHVpbjZ4V1MwY1ptSzVhSnJCQTg4SXBKSXR5N1VDYnBZeE1IU2ljZVhs?=
 =?utf-8?B?MWs1cmJYcHFxbGtCK3pHRVFycU9YTlZYMXRPL2Q0SnlxUDBmSXY2UzM2ci9o?=
 =?utf-8?B?bDRScGtOejczRjJJZENEMHlrTWVoL1JWWXQwby9kcFVVWStyUC81akdHSjlE?=
 =?utf-8?B?ay9lT3pqZHNYYXRZcm1wS1BWQlRIWjlDODNyMmx5QkFLU0RWMUlXWmM5ejJu?=
 =?utf-8?B?aGlIdWxwR0lNQ01rSnJlWUxESUJrdUtMNlZWTUZkaGpsV2dFQk5mY1dJa1NG?=
 =?utf-8?B?S0x3R3ptd3ZMbkV2WXN6WjRJOXpybUx0UlNzbENkZXNtWkZycEZieG9tUzVp?=
 =?utf-8?B?OU14L212Rmx2SVp4V2cvbzAvclhabHJ1bE8vc1BBY2NoanhYdFZoV0dKMDhr?=
 =?utf-8?B?VGZsR2M3bmUvNCtqdldicGUxM255UmIvaWxVNlZjbzBlS0xQamdzUXl4aVli?=
 =?utf-8?B?ektJeEZaT09vTXpacTk3b2ViMVpOd1FGZk5oTFdMVzg1M0RLU0NUbUhvOUVV?=
 =?utf-8?B?QlhsZDRzODlJYzA3UGVTQ0NWaWVvd0ZqRURaZ0IydFNObCtoL3V0QUxlTHli?=
 =?utf-8?B?OExRUlI0Qml0OFBmRVBzMVRWODVGYjZ1VmpsZVVnM1ZmRTIrRTZ0cjJXaWhW?=
 =?utf-8?B?RHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F25B7FCCFBF39439C3F8912047CFEDC@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5918ddb8-29a6-4b31-340c-08da9c9eae65
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 13:30:57.0667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uZFOJebic7MigXlBn6yDW5LXSYw6/RL7xLKt7WDVsDwe8aJx7T57G+gozgTG6H1u53qLXagjVNAZ8BW5qWOieg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7581
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBTZXAgMjIsIDIwMjIgYXQgMDM6MDI6MTJQTSArMDIwMCwgTGludXMgV2FsbGVpaiB3
cm90ZToNCj4gT24gVGh1LCBTZXAgMjIsIDIwMjIgYXQgMTI6MjEgUE0gS29ucmFkIER5YmNpbw0K
PiA8a29ucmFkLmR5YmNpb0Bzb21haW5saW5lLm9yZz4gd3JvdGU6DQo+IA0KPiA+IEFsc28gd29y
dGggbm90aW5nIGlzIHRoZSAnc29tYycgYml0LCBtZWFuaW5nIHRoZXJlIGFyZSBwcm9iYWJseSAq
c29tZSogU09OWQ0KPiA+IGN1c3RvbWl6YXRpb25zLCBidXQgdGhhdCdzIGFsc28ganVzdCBhIGd1
ZXNzLg0KPiANCj4gV2hhdCBJIGhhdmUgc2VlbiBmcm9tIEJSQ00gY3VzdG9taXphdGlvbnMgb24g
U2Ftc3VuZyBwaG9uZXMgaXMgdGhhdA0KPiB0aGUgcGVyLWRldmljZSBjdXN0b21pemF0aW9uIG9m
IGZpcm13YXJlIHNlZW1zIHRvIGludm9sdmUgdGhlIHNldC11cCBvZg0KPiBzb21lIEdQSU8gYW5k
IHBvd2VyIG1hbmFnZW1lbnQgcGlucy4gRm9yIGV4YW1wbGUgaWYgaW50ZWdyYXRlZCB3aXRoDQo+
IGFuIFNvQyB0aGF0IGhhcyBhdXRvbm9tb3VzIHN5c3RlbSByZXN1bWUsIG9yIGlmIHNvbWUgR1BJ
TyBsaW5lIGhhcw0KPiB0byBiZSBwdWxsZWQgdG8gZW5hYmxlIGFuIGV4dGVybmFsIHJlZ3VsYXRv
ciBvciBQQS4NCg0KQXQgbGVhc3Qgd2l0aCBJbmZpbmVvbiAoZm9ybWVybHkgQ3lwcmVzcyksIGFz
IGEgY3VzdG9tZXIgeW91IG1pZ2h0IGdldCBhDQpwcml2YXRlIGZpcm13YXJlIGFuZCB0aGlzIHdp
bGwgYmUgbWFpbnRhaW5lZCBpbnRlcm5hbGx5IGJ5IHRoZW0gb24gYQ0Kc2VwYXJhdGUgY3VzdG9t
ZXIgYnJhbmNoLiBBbnkgc3Vic2VxdWVudCBidWdmaXhlcyBvciBmZWF0dXJlIHJlcXVlc3RzDQp3
aWxsIHVzdWFsbHkgYmUgYXBwbGllZCB0byB0aGF0IGN1c3RvbWVyIGJyYW5jaCBhbmQgYSBuZXcg
ZmlybXdhcmUgYnVpbHQNCmZyb20gaXQuIEkgdGhpbmsgdGhlaXIgaW50ZXJuYWwgIm1haW5saW5l
IiBicmFuY2ggbWlnaHQgZ2V0IG1lcmdlZCBpbnRvDQp0aGUgY3VzdG9tZXIgYnJhbmNoZXMgZnJv
bSB0aW1lIHRvIHRpbWUsIGJ1dCB0aGlzIHNlZW1zIHRvIGJlIGRvbmUgb24gYW4NCmFkLWhvYyBi
YXNpcy4gVGhpcyBpcyBvdXIgZXhwZXJpZW5jZSBhdCBsZWFzdC4NCg0KSSB3b3VsZCBhbHNvIHBv
aW50IG91dCB0aGF0IHRoZSBCQ000MzU5IGlzIGVxdWl2YWxlbnQgdG8gdGhlDQpDWVc4ODM1OS9D
WVc4OTM1OSBjaGlwc2V0LCB3aGljaCB3ZSBhcmUgdXNpbmcgaW4gc29tZSBvZiBvdXINCnByb2R1
Y3RzLiBOb3RlIHRoYXQgdGhpcyBpcyBhIEN5cHJlc3MgY2hpcHNldCAoaWRlbnRpZmlhYmxlIGJ5
IHRoZQ0KVmVyc2lvbjogLi4uICguLi4gQ1kpIHRhZyBpbiB0aGUgdmVyc2lvbiBzdHJpbmcpLiBC
dXQgdGhlIEZXIEtvbnJhZCBpcw0KbGlua2luZyBhcHBlYXJzIHRvIGJlIGZvciBhIEJyb2FkY29t
IGNoaXBzZXQuDQoNCkZZSSwgaGVyZSdzIGEgcHVibGljbHkgYXZhaWxhYmxlIHNldCBvZiBmaXJt
d2FyZSBmaWxlcyBmb3IgdGhlICc0MzU5Og0KDQpodHRwczovL2dpdGh1Yi5jb20vTlhQL2lteC1m
aXJtd2FyZS90cmVlL21hc3Rlci9jeXctd2lmaS1idC8xRkRfQ1lXNDM1OQ0KDQpBbnl3YXksIEkg
d291bGQgc2Vjb25kIEhlY3RvcidzIHN1Z2dlc3Rpb24gYW5kIG1ha2UgdGhpcyBhIHNlcGFyYXRl
IEZXLg0KDQo+IA0KPiBUbyB0aGUgYmVzdCBvZiBteSBrbm93bGVkZ2UgdGhhdCBjdXN0b21pemF0
aW9uIGlzIGRvbmUgYnkgY29uc3VsdGFudHMNCj4gZnJvbSBCcm9hZGNvbSB3aGVuIHdvcmtpbmcg
d2l0aCB0aGUgZGV2aWNlIG1hbnVmYWN0dXJlciwgYW5kDQo+IGV2ZW50dWFsbHkgdGhleSByb2xs
IGEgdW5pcXVlIGZpcm13YXJlIGZvciB0aGUgZGV2aWNlLiBQcm9iYWJseSBiZWNhdXNlDQo+IHRo
ZSBmaXJtd2FyZSBjYW4gb25seSBiZSBzaWduZWQgZm9yIGV4ZWN1dGlvbiBieSBCcm9hZGNvbT8N
Cg0KS2luZCByZWdhcmRzLA0KQWx2aW4NCg0KPiANCj4gWW91cnMsDQo+IExpbnVzIFdhbGxlaWo=
