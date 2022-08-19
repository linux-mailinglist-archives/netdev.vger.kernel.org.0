Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1629E5997BB
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347500AbiHSIho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347181AbiHSIhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:37:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E2D5FA6;
        Fri, 19 Aug 2022 01:35:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1vUvFLA10W1np5XcIkWv/stTdGSx9v9Z+qP+aAtivpwksmyzQFl2M8qxeyLEFJcNa4fscs/tkHTs9yHrTSH9ave2Ew58F8JjPSgDXEZo8yfAdbC9x6NpOw1i0xWTHh+fGZZUgKwwDzty/LQrLfY2VfblcjW9MpbSuSxVxouAoP3dXdC7QFkr3rZc/vCUY6o1na4hc5fsxBKZwwpMhm6bPG59BEVvyntQ/m6BxIr/9TyunlkAp+74VTPDf0bKa+nKJ3GW6Ho9+Vrdp1zvWZmNjZoptUewduhAcKR/uAouT/IGt11HS4KkaywjP45D/YLBKOlHCwLdfm/dwA7wzUJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZqmRHrBxfcL4TlU5UIwNAlzmikWH7UTvbJuk3jZfas=;
 b=E8Qe82gfaVY93lc+S2qGGD4yvAUZCjZXjEl8OLQGZAiN+UgmHlEhqLvBCVtLh7+OpSEhao4WkXYGi8pUW/cjdO1bVRO4JsTJo8eKycMO174RjbkuYpihhJAna8DtjuMcdAUpLv6zn0KJgdhfHp/QcQYy7l0Txgre5bWv9KBSnVJaot7UBN8R+xBTa6rEnly5gyqQAJaePKj4x3PJbYZ+X732dR9nYceSCMb+ovBIkqFi8iyarRYUSvkLsFQcSu+1YvrdUB7proq3Tp21kpQ3BdAyPLY6WXqonQ1XS0QqM/+eUcyHRC5694wVoAk4gW7LHuc5gpR/IX3tmD8OlFpOLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZqmRHrBxfcL4TlU5UIwNAlzmikWH7UTvbJuk3jZfas=;
 b=ru25hWLugn5hYFkQyZRH73WJTpP8daxvBT5FGliLc+vP7gfOZWC7JIK60UX8oDm+4IDYrKHkAg5jSc1Ltujz/JzTM7Lnihfy2RJxTB7bthe2F1hQ9U+Xb8b9QnHItoYgCIOCc7bcqvqvGGBrO3jxpUos3sKoQF8g8H61+gvQpZ31Hon3pqVN0MqZvo/5v2ImTUG9lrhm2IyfGcN20zQ3f5NmmRgSe3iZcIOctwAZuo6yudlb1VVXP36XxC7/yIp7X5lmB8NZfTqXy9oh7phx1kVdbFYvuWKOUuZIvz81q5+eaHzAFR2wYnPvrSYM9tafhgFt8fwTs0kjR9vnljjC/A==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by DM4PR12MB5793.namprd12.prod.outlook.com (2603:10b6:8:60::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 08:35:29 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::205d:65ed:1439:d135]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::205d:65ed:1439:d135%9]) with mapi id 15.20.5525.019; Fri, 19 Aug 2022
 08:35:29 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "bjorn@kernel.org" <bjorn@kernel.org>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 00/14] xsk: stop NAPI Rx processing on full
 XSK RQ
Thread-Topic: [PATCH v2 bpf-next 00/14] xsk: stop NAPI Rx processing on full
 XSK RQ
Thread-Index: AQHYT0tpbpOS7hf0yU2uZi+ifIWmea22rq2A
Date:   Fri, 19 Aug 2022 08:35:29 +0000
Message-ID: <24044113385d101cc2c3833a01d0ca93482214d1.camel@nvidia.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec4c8001-acdb-4fc6-d4c8-08da81bdc5c1
x-ms-traffictypediagnostic: DM4PR12MB5793:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K1ayKps+Ly5O7+1woUsn0yCpoqumXcWfx58uzAIYjXBe64HyCEfCAr7s2MPGOji3GalnLAvgILqLmkvIdQZmsiMMnpo6PA8tQ5+If7aZx3Ar6RkprvjqjAdQIiw4JVnXMnKvIDK2MfcRkcDyORwGx/9jauDo+gicwbqfxiX/8NR62QRId4jJPmqhEfFtk3Zn297f97IVsILagQ+0+2BsgSFij548nGuXElRm5g000V4U9Luqh4UbrJC4CBGaKNtCIFRzAd9Rah4bffkNaTp437V5zXB1hBN8xy05vv9hr5n0uxJSfKO9yp1s3km9uz2g+cInYp48gWjJxcXRrV1JvPhAWFELNcBIO4UzY+cCOdcjSbzM6NCyqRTCasXqY7+pqSk9qf5YYmN88FkwXNysk/1ViLrgRqy/3BZQMaXj2+yOuO6cSN+C2gmKhVZQmgJMEHq+JCrwBujhov2jFQoEiSsknd40EPssSg2Q+iEysoyURWfUhl1U4q0cMTGZ/DKJbgz0CWI/70dEAo68EOY7o+smHb2829CZZcUncu9Eb4vn3s0/crjqpiUxgBj0RpUk/EofyZeK4zGIbOvgrkaHjeRsKw5C64dwB4Ri0b8DxDeu0ZQHTvrpn/Yp/VgwargdGaq2QfS1Q67xwKO4qWHl9yDe6PCug7dff2zNEzFgpfR03RKwnnpnStSo8EyLnBVIHz8ZdMVMhNmhU2TdhYYA0+40HwlUA/K3FOMl39GdnsqTozMkV97cFdULnR44zEw1798733TLGg9e879PGgyPeHU1iQGdDiacSFWOmEDGqG+XAxgrlBbMIBtNQVaDrSTkO2ICugePZpgaXTsJW8zNuGPTh783m8nF8P6w1cUYt6ngtFGc5p6msYZJzUMvBkYiPoVE+OXcq4PX/7UOW1mhXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(478600001)(966005)(6486002)(4326008)(110136005)(54906003)(316002)(76116006)(91956017)(8676002)(66946007)(64756008)(66556008)(66476007)(66446008)(38100700002)(38070700005)(5660300002)(8936002)(86362001)(2906002)(122000001)(66574015)(83380400001)(41300700001)(186003)(71200400001)(36756003)(6506007)(6512007)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVJKOVdTWDUrQkZaZlR5TElXcWtXbzgvS3hURk5OTVZEUGkzTFcrYTAxbUNQ?=
 =?utf-8?B?MTJQSmdZdVM0SmRGT0t4TkJ0Z1hVVS9GeGtIbXN0WDY0bUkvL0tqK1k4Rk91?=
 =?utf-8?B?SzArcGRzRWNBdUtLUUZjYVhIK3QzelNxcHczQ01xZ3NwRVAzYStwWkQvVW9r?=
 =?utf-8?B?RXhCckhFektSaVdMZllqVmRCd2tPNlUvUHdzbnllb2JVTVUxWTNtOVgxNThR?=
 =?utf-8?B?dk5OVHh2WDYwOW1DaHVoSFNpU1F4OVVJK2lydUluNWdRMElzbzFOYVo5VDJx?=
 =?utf-8?B?VHFENzdNNUZlU1NoeVBOaDBiWURYYmYzcGVEckI3eTlDMk5LNktTTHRVWEx5?=
 =?utf-8?B?R3BWdjB0R1dSTFJhcG5md1Z0cmRKeFFjTm1WODhqaDRHeXc3ZmlhdXkzb3V3?=
 =?utf-8?B?WkJKTGMvV1lTM3BybEhuWXJ6K3JPTFZTcDFra3BKS0N4d0tBa1Z4TUNtL2FH?=
 =?utf-8?B?TVdFY0lENDR1ZWc1THIwcTc0V2FjWGFTeklpUkVIc281UG5ZK0gwT1F3bzlT?=
 =?utf-8?B?TGFkd094eXc1WGpvNHZpY1V4NEsva1NiUlZkaTdVcHNYL1VVSDBnTXdhWWFM?=
 =?utf-8?B?c0xMZFVkQ0RpNFMzeDNsUGp5cjFmS2hveXU5cDlmSE9hT2pVdlM2VWdKVlpL?=
 =?utf-8?B?RUs1UGl5aCtzWnlKQVdMZDlVM0dEd1ZhYmU5Skt3QXptZk9XMTdORnlnb0sw?=
 =?utf-8?B?SHAzeVB2T1hjc1gvWllORUdVaVhlUWVqTWVYeDNkRkdZNEhEaEVxNW5pMnRl?=
 =?utf-8?B?U0Qxdmw3OG1CcXY1MWRuZ0Zsd1Z1N2ZoS01SaTJPN1hWVU1BRjhUWEE3VkFW?=
 =?utf-8?B?TUZtUlp4WDI5QnYya0l0OHRmZWhRb1U0VlYyVUV3b3VieitVTWd3Qnkwb25G?=
 =?utf-8?B?MDJjV3crZnpoOFF0SjhCb2YwWHdOVy8rb0FERlBzcVdybVlMRitEcUNoZG1L?=
 =?utf-8?B?N0V1YUVWYjloTEF2b0lpeTF2SjAxZVVuaG5oQldDUGNLM1EyWmV3eXpxdkFX?=
 =?utf-8?B?UVZsR29oWnNKV2RYVUU4MStEMmN2QTBtaXBxMmRLczZhQ0hVVzZkS1phSWJ0?=
 =?utf-8?B?eFA4Z3JGbUVodnp2Q1NJZ054RjdtR0VENVhpK1M0U0c1c3JXZ0NDcldxbERM?=
 =?utf-8?B?Z0E0Q2VpL2VwbFgxY085UWJKYTMyNU05Zy83bDA5Wmt1UVk4Wjh5SmRHNnRB?=
 =?utf-8?B?VVZBM0ZodjlBSUIvbjZaNm1DNjVGUWpqUGdNejNSL3VPYTdLNnRJMnV5MFBo?=
 =?utf-8?B?RHJwTThXN2tDTlhadXdhU1BoLzdLMURjOUtETnJzREpBWTV4RTVMUGhtL0lL?=
 =?utf-8?B?dm1sbEYzNEd6QmxvQW5mLzRQZlNlcURXTTdvd1luOUJGZzRLZmdFQW5GWncw?=
 =?utf-8?B?OVc3dEQ4MEVGOWtScUY1Nm1IZjQwUW5pN1VkeDBIaitUbkZhTWl0cG9aTGVx?=
 =?utf-8?B?Q1RoN3JwbXJnd2Ivdktic00zQThUMHA3VCtOSnkyTXhzVVBVdTRLTG1sQmVn?=
 =?utf-8?B?TThLU0pHTWtUUVQzd05uRTUzQ1JFTTFOUmhMY0pLWGpPL0FXQ3NqOVQvYVQy?=
 =?utf-8?B?Zk5YNnJzUEh3c1Jib041NGlKMEo5Q2hKU1YzVGdPYXNzT2gvTEl2M25yRWZz?=
 =?utf-8?B?ckFuY3QvaDFRdHhMNk13dGdqUUxQYndoZUFPUEJNRWM3ZG0rWG1XY1B0Q0Yv?=
 =?utf-8?B?V2ZKWG96M0FSSmlJVUplUUpld1QrZmJLRnFrdk9sNFlicTV3SElZRHlOcFpG?=
 =?utf-8?B?b3RjbFgzL0FQbk1YMkZGZVE5eUVrbHErbVdrMlJ1TnU1SEV1aE0yWHVRdFov?=
 =?utf-8?B?ZEROYjdNeDZWTTRVZ3I3QjRhT05ManJ3YzN3SDlqWTNPWEZBVjkvMTg0MUhi?=
 =?utf-8?B?azNIZ0g4cXZkVzBNZk0xZ01qdlBFZll6eG4vWnVDWDExdEJNK2JuZG1SK25n?=
 =?utf-8?B?c0txQkpOUEp1WjNhREcyRE5kZDdCd3RNR3ZEbjl6Y2Fya0d4UWdxUUxwTVhP?=
 =?utf-8?B?V3RmbEplYXExMi8vWks2SFloNjJCV1B5eElFbG9YcjF3bXBEM2JCOFp5M2tV?=
 =?utf-8?B?cWgyUGwxQVJwQVVhNGVQNldMRk0wUUJLeFQ3ZjI1OGdsRXVqa2JGeVBqRU9p?=
 =?utf-8?B?Vi96Znd4UFNzbnZmZVZNQlg3cjVkWGNFWW1BajRycC8zVzdlWVlMV0UzZk5I?=
 =?utf-8?B?d2czYjhrckhHcHBWTGFkR08yVm8vYWhXYW5rd2crajVqTHczYmhTS2ZIZTVk?=
 =?utf-8?B?YTNRdmd1VjJXTW5pcjlRTnp1eUFnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <77EA8B52C8609348A90E8EA8073B9EC2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4c8001-acdb-4fc6-d4c8-08da81bdc5c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 08:35:29.2650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5IxGTFpigJ1H3s+2bZWNUB7HalpqnvQqAHDwLkzpyDdG6UkGln+qc8Z1yOBRXahr4BGRAtIDXIiftwcSS1nE/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5793
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFjaWVqLA0KDQpPbiBXZWQsIDIwMjItMDQtMTMgYXQgMTc6MzAgKzAyMDAsIE1hY2llaiBG
aWphbGtvd3NraSB3cm90ZToNCj4gdjI6DQo+IC0gYWRkIGxpa2VseSBmb3IgaW50ZXJuYWwgcmVk
aXJlY3QgcmV0dXJuIGNvZGVzIGluIGljZSBhbmQgaXhnYmUNCj4gICAoSmVzcGVyKQ0KPiAtIGRv
IG5vdCBkcm9wIHRoZSBidWZmZXIgdGhhdCBoZWFkIHBvaW50ZWQgdG8gYXQgZnVsbCBYU0sgUlEg
KE1heGltKQ0KDQpJIGZvdW5kIGFuIGlzc3VlIHdpdGggdGhpcyBhcHByb2FjaC4gSWYgeW91IGRv
bid0IGRyb3AgdGhhdCBwYWNrZXQsDQp5b3UnbGwgbmVlZCB0byBydW4gdGhlIFhEUCBwcm9ncmFt
IGZvciB0aGUgc2FtZSBwYWNrZXQgYWdhaW4uIElmIHRoZQ0KWERQIHByb2dyYW0gaXMgYW55dGhp
bmcgbW9yZSBjb21wbGV4IHRoYW4gInJlZGlyZWN0LWV2ZXJ5dGhpbmctdG8tWFNLIiwNCml0IHdp
bGwgZ2V0IGNvbmZ1c2VkLCBmb3IgZXhhbXBsZSwgaWYgaXQgdHJhY2tzIGFueSBzdGF0ZSBvciBj
b3VudHMNCmFueXRoaW5nLg0KDQpXZSBjYW4ndCBjaGVjayB3aGV0aGVyIHRoZXJlIGlzIGVub3Vn
aCBzcGFjZSBpbiB0aGUgWFNLIFJYIHJpbmcgYmVmb3JlDQpydW5uaW5nIHRoZSBYRFAgcHJvZ3Jh
bSwgYXMgd2UgZG9uJ3Qga25vdyBpbiBhZHZhbmNlIHdoaWNoIFhTSyBzb2NrZXQNCndpbGwgYmUg
c2VsZWN0ZWQuDQoNCldlIGNhbid0IHN0b3JlIGJwZl9yZWRpcmVjdF9pbmZvIGFjcm9zcyBOQVBJ
IGNhbGxzIHRvIGF2b2lkIHJ1bm5pbmcgdGhlDQpYRFAgcHJvZ3JhbSBzZWNvbmQgdGltZSwgYXMg
YnBmX3JlZGlyZWN0X2luZm8gaXMgcHJvdGVjdGVkIGJ5IFJDVSBhbmQNCnRoZSBhc3N1bXB0aW9u
IHRoYXQgdGhlIHdob2xlIFhEUF9SRURJUkVDVCBvcGVyYXRpb24gaGFwcGVucyB3aXRoaW4gb25l
DQpOQVBJIGN5Y2xlLg0KDQpJIHNlZSB0aGUgZm9sbG93aW5nIG9wdGlvbnM6DQoNCjEuIERyb3Ag
dGhlIHBhY2tldCB3aGVuIGFuIG92ZXJmbG93IGhhcHBlbnMuIFRoZSBwcm9ibGVtIGlzIHRoYXQg
aXQNCndpbGwgaGFwcGVuIHN5c3RlbWF0aWNhbGx5LCBidXQgaXQncyBzdGlsbCBiZXR0ZXIgdGhh
biB0aGUgb2xkIGJlaGF2aW9yDQooZHJvcCBtdWxpdHBsZSBwYWNrZXRzIHdoZW4gYW4gb3ZlcmZs
b3cgaGFwcGVucyBhbmQgaG9nIHRoZSBDUFUpLg0KDQoyLiBNYWtlIHRoaXMgZmVhdHVyZSBvcHQt
aW4uIElmIHRoZSBhcHBsaWNhdGlvbiBvcHRzIGluLCBpdCBndWFyYW50ZWVzDQp0byB0YWtlIG1l
YXN1cmVzIHRvIGhhbmRsZSBkdXBsaWNhdGUgcGFja2V0cyBpbiBYRFAgcHJvcGVybHkuDQoNCjMu
IFJlcXVpcmUgdGhlIFhEUCBwcm9ncmFtIHRvIGluZGljYXRlIGl0IHN1cHBvcnRzIGJlaW5nIGNh
bGxlZA0KbXVsdGlwbGUgdGltZXMgZm9yIHRoZSBzYW1lIHBhY2tldCBhbmQgcGFzcyBhIGZsYWcg
dG8gaXQgaWYgaXQncyBhDQpyZXBlYXRlZCBydW4uIERyb3AgdGhlIHBhY2tldCBpbiB0aGUgZHJp
dmVyIGlmIHRoZSBYRFAgcHJvZ3JhbSBkb2Vzbid0DQppbmRpY2F0ZSB0aGlzIHN1cHBvcnQuIFRo
ZSBpbmRpY2F0aW9uIGNhbiBiZSBkb25lIHNpbWlsYXIgdG8gaG93IGl0J3MNCmltcGxlbWVudGVk
IGZvciBYRFAgbXVsdGkgYnVmZmVyLg0KDQpUaG91Z2h0cz8gT3RoZXIgb3B0aW9ucz8NCg0KVGhh
bmtzLA0KTWF4DQoNCj4gLSB0ZXJtaW5hdGUgUnggbG9vcCBvbmx5IHdoZW4gbmVlZF93YWtldXAg
ZmVhdHVyZSBpcyBlbmFibGVkIChNYXhpbSkNCj4gLSByZXdvcmQgZnJvbSAnc3RvcCBzb2Z0aXJx
IHByb2Nlc3NpbmcnIHRvICdzdG9wIE5BUEkgUnggcHJvY2Vzc2luZycNCj4gLSBzL0VOWElPL0VJ
TlZBTCBpbiBtbHg1IGFuZCBzdG1tYWMncyBuZG9feHNrX3dha2V1cCB0byBrZWVwIGl0DQo+ICAg
Y29uc2l0ZW50IHdpdGggSW50ZWwncyBkcml2ZXJzIChNYXhpbSkNCj4gLSBpbmNsdWRlIEplc3Bl
cidzIEFja3MNCj4gDQo+IEhpIQ0KPiANCj4gVGhpcyBpcyBhIHJldml2YWwgb2YgQmpvcm4ncyBp
ZGVhIFswXSB0byBicmVhayBOQVBJIGxvb3Agd2hlbiBYU0sgUngNCj4gcXVldWUgZ2V0cyBmdWxs
IHdoaWNoIGluIHR1cm4gbWFrZXMgaXQgaW1wb3NzaWJsZSB0byBrZWVwIG9uDQo+IHN1Y2Nlc3Nm
dWxseSBwcm9kdWNpbmcgZGVzY3JpcHRvcnMgdG8gWFNLIFJ4IHJpbmcuIEJ5IGJyZWFraW5nIG91
dCBvZg0KPiB0aGUgZHJpdmVyIHNpZGUgaW1tZWRpYXRlbHkgd2Ugd2lsbCBnaXZlIHRoZSB1c2Vy
IHNwYWNlIG9wcG9ydHVuaXR5IGZvcg0KPiBjb25zdW1pbmcgZGVzY3JpcHRvcnMgZnJvbSBYU0sg
UnggcmluZyBhbmQgdGhlcmVmb3JlIHByb3ZpZGUgcm9vbSBpbiB0aGUNCj4gcmluZyBzbyB0aGF0
IEhXIFJ4IC0+IFhTSyBSeCByZWRpcmVjdGlvbiBjYW4gYmUgZG9uZS4NCj4gDQo+IE1heGltIGFz
a2VkIGFuZCBKZXNwZXIgYWdyZWVkIG9uIHNpbXBsaWZ5aW5nIEJqb3JuJ3Mgb3JpZ2luYWwgQVBJ
IHVzZWQNCj4gZm9yIGRldGVjdGluZyB0aGUgZXZlbnQgb2YgaW50ZXJlc3QsIHNvIGxldCdzIGp1
c3Qgc2ltcGx5IGNoZWNrIGZvcg0KPiAtRU5PQlVGUyB3aXRoaW4gSW50ZWwncyBaQyBkcml2ZXJz
IGFmdGVyIGFuIGF0dGVtcHQgdG8gcmVkaXJlY3QgYSBidWZmZXINCj4gdG8gWFNLIFJ4LiBObyBy
ZWFsIG5lZWQgZm9yIHJlZGlyZWN0IEFQSSBleHRlbnNpb24uDQo+IA0KPiBPbmUgbWlnaHQgYXNr
IHdoeSBpdCBpcyBzdGlsbCByZWxldmFudCBldmVuIGFmdGVyIGhhdmluZyBwcm9wZXIgYnVzeQ0K
PiBwb2xsIHN1cHBvcnQgaW4gcGxhY2UgLSBoZXJlIGlzIHRoZSBqdXN0aWZpY2F0aW9uLg0KPiAN
Cj4gRm9yIHhkcHNvY2sgdGhhdCB3YXM6DQo+IC0gcnVuIGZvciBsMmZ3ZCBzY2VuYXJpbywNCj4g
LSBhcHAvZHJpdmVyIHByb2Nlc3NpbmcgdG9vayBwbGFjZSBvbiB0aGUgc2FtZSBjb3JlIGluIGJ1
c3kgcG9sbA0KPiAgIHdpdGggMjA0OCBidWRnZXQsDQo+IC0gSFcgcmluZyBzaXplcyBUeCAyNTYs
IFJ4IDIwNDgsDQo+IA0KPiB0aGlzIHdvcmsgaW1wcm92ZWQgdGhyb3VnaHB1dCBieSA3OCUgYW5k
IHJlZHVjZWQgUnggcXVldWUgZnVsbCBzdGF0aXN0aWMNCj4gYnVtcCBieSA5OSUuDQo+IA0KPiBG
b3IgdGVzdGluZyBpY2UsIG1ha2Ugc3VyZSB0aGF0IHlvdSBoYXZlIFsxXSBwcmVzZW50IG9uIHlv
dXIgc2lkZS4NCj4gDQo+IFRoaXMgc2V0LCBiZXNpZGVzIHRoZSB3b3JrIGRlc2NyaWJlZCBhYm92
ZSwgY2FycmllcyBhbHNvIGltcHJvdmVtZW50cw0KPiBhcm91bmQgcmV0dXJuIGNvZGVzIGluIHZh
cmlvdXMgWFNLIHBhdGhzIGFuZCBsYXN0bHkgYSBtaW5vciBvcHRpbWl6YXRpb24NCj4gZm9yIHhz
a3FfY29uc19oYXNfZW50cmllcygpLCBhIGhlbHBlciB0aGF0IG1pZ2h0IGJlIHVzZWQgd2hlbiBY
U0sgUngNCj4gYmF0Y2hpbmcgd291bGQgbWFrZSBpdCB0byB0aGUga2VybmVsLg0KPiANCj4gTGlu
ayB0byB2MSBhbmQgZGlzY3Vzc2lvbiBhcm91bmQgaXQgaXMgYXQgWzJdLg0KPiANCj4gVGhhbmtz
IQ0KPiBNRg0KPiANCj4gWzBdOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9icGYvMjAyMDA5MDQx
MzUzMzIuNjAyNTktMS1iam9ybi50b3BlbEBnbWFpbC5jb20vDQo+IFsxXTogaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjIwMzE3MTc1NzI3LjM0MDI1MS0xLW1hY2llai5maWphbGtv
d3NraUBpbnRlbC5jb20vDQo+IFsyXTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYnBmLzU4NjQx
NzFiLTFlMDgtMWI1MS0wMjZlLTVmMDliODk0NTA3NkBudmlkaWEuY29tL1QvDQo+IA0KPiBCasO2
cm4gVMO2cGVsICgxKToNCj4gICB4c2s6IGltcHJvdmUgeGRwX2RvX3JlZGlyZWN0KCkgZXJyb3Ig
Y29kZXMNCj4gDQo+IE1hY2llaiBGaWphbGtvd3NraSAoMTMpOg0KPiAgIHhzazogZGl2ZXJzaWZ5
IHJldHVybiBjb2RlcyBpbiB4c2tfcmN2X2NoZWNrKCkNCj4gICBpY2U6IHhzazogZGVjb3JhdGUg
SUNFX1hEUF9SRURJUiB3aXRoIGxpa2VseSgpDQo+ICAgaXhnYmU6IHhzazogZGVjb3JhdGUgSVhH
QkVfWERQX1JFRElSIHdpdGggbGlrZWx5KCkNCj4gICBpY2U6IHhzazogdGVybWluYXRlIFJ4IHNp
ZGUgb2YgTkFQSSB3aGVuIFhTSyBSeCBxdWV1ZSBnZXRzIGZ1bGwNCj4gICBpNDBlOiB4c2s6IHRl
cm1pbmF0ZSBSeCBzaWRlIG9mIE5BUEkgd2hlbiBYU0sgUnggcXVldWUgZ2V0cyBmdWxsDQo+ICAg
aXhnYmU6IHhzazogdGVybWluYXRlIFJ4IHNpZGUgb2YgTkFQSSB3aGVuIFhTSyBSeCBxdWV1ZSBn
ZXRzIGZ1bGwNCj4gICBpY2U6IHhzazogZGl2ZXJzaWZ5IHJldHVybiB2YWx1ZXMgZnJvbSB4c2tf
d2FrZXVwIGNhbGwgcGF0aHMNCj4gICBpNDBlOiB4c2s6IGRpdmVyc2lmeSByZXR1cm4gdmFsdWVz
IGZyb20geHNrX3dha2V1cCBjYWxsIHBhdGhzDQo+ICAgaXhnYmU6IHhzazogZGl2ZXJzaWZ5IHJl
dHVybiB2YWx1ZXMgZnJvbSB4c2tfd2FrZXVwIGNhbGwgcGF0aHMNCj4gICBtbHg1OiB4c2s6IGRp
dmVyc2lmeSByZXR1cm4gdmFsdWVzIGZyb20geHNrX3dha2V1cCBjYWxsIHBhdGhzDQo+ICAgc3Rt
bWFjOiB4c2s6IGRpdmVyc2lmeSByZXR1cm4gdmFsdWVzIGZyb20geHNrX3dha2V1cCBjYWxsIHBh
dGhzDQo+ICAgaWNlOiB4c2s6IGF2b2lkIHJlZmlsbGluZyBzaW5nbGUgUnggZGVzY3JpcHRvcnMN
Cj4gICB4c2s6IGRyb3AgdGVybmFyeSBvcGVyYXRvciBmcm9tIHhza3FfY29uc19oYXNfZW50cmll
cw0KPiANCj4gIC4uLi9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfdHhyeF9jb21tb24uaCAgICB8
ICAxICsNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV94c2suYyAgICB8
IDM4ICsrKysrKysrLS0tLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vf
dHhyeC5oICAgICB8ICAxICsNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vf
eHNrLmMgICAgICB8IDUzICsrKysrKysrKysrKy0tLS0tLS0NCj4gIC4uLi9ldGhlcm5ldC9pbnRl
bC9peGdiZS9peGdiZV90eHJ4X2NvbW1vbi5oICB8ICAxICsNCj4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2l4Z2JlL2l4Z2JlX3hzay5jICB8IDUyICsrKysrKysrKystLS0tLS0tLQ0KPiAg
Li4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svdHguYyAgIHwgIDIgKy0NCj4g
IC4uLi9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYyB8ICA0ICstDQo+
ICBuZXQveGRwL3hzay5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgNCArLQ0K
PiAgbmV0L3hkcC94c2tfcXVldWUuaCAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDQgKy0N
Cj4gIDEwIGZpbGVzIGNoYW5nZWQsIDk5IGluc2VydGlvbnMoKyksIDYxIGRlbGV0aW9ucygtKQ0K
PiANCg0KDQo=
