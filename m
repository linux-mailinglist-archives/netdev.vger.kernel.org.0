Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF9859E3F0
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244643AbiHWMmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 08:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243434AbiHWMlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 08:41:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FEF9F0C1;
        Tue, 23 Aug 2022 02:51:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIW+nG4d/+p+4RTRi2zvBHgRS4wvmyTeFDvG7DFf/0NgK2/pazwCJbbTjKc57KtJAlgaatkEdDTl+G3EEmrKMy5So3dVNkCwJGe4MeANqaOmuti0b5XXNBAo0MYw2THf1KtNwQjm/v5ph3dazrT6aLwqEm5gONpPJLo55wi8Q+vjxBaGasHV+8eDBCiS9pUGGzXXjedKop+ZgOcXlJKSDTGfsckJC7ihacdn5rzLpXsOjvkfFeDz+kFfboZre1f6/1HG/K5JSs6aHWkZFMtVLEzyzQU1LJB5KxtWLfob4do5zXeRdK2XUXkGeV/Avk5DfYwwViHEjtIsFt6gIhH+jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPY5HbNM1ZJSi+7jnc5axw9gYkss8o7JOaCqi4Ks6Sg=;
 b=QAxs7DAtEeGlgQYBt9hxxRyqRvBWyghdkbNTPXUgb9ewat07jHaO1xFbRSi+4BeC/btwYkhNs9ZdUXTyBpzH+V+oYiCg3Lx1GmFPEjkllNLBu4ZAw0UdMbj7sBXSFEZ0gmAZUg6Kzm1DVGC0BqIYmdm65tT9xNhkxwymBP+uDJO3yhkceNeHc0oecXFAi/6ZgxaRXBl31GFARutlhFn1g9BzEftoY5UnQGF/oUIxXZ9+kEEMqpbfagMWrBS4AzXPLXB/eBhcZmzSXJe7JzT64LLP67zF/Xwbvn7pKZWbAADqA45hOXq3cLgwB6jYOS4DJgXiSyeHzRfvfyl7B8dwrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPY5HbNM1ZJSi+7jnc5axw9gYkss8o7JOaCqi4Ks6Sg=;
 b=shooXw3vZEAj97f1AD+aYQXzpPpUz8cOPU1hnsauL/BdIuCxrrsNF8Wu69DYmSYZUJU6eufh8LCPOKZO9QyGL8kpXuT88Z9PmKWl0FjxYl/LDfHyiueXQr6ceMwXRDGw87CdmaARg9WfCpjjs40bWM7vlhokML5nlnHnwrMGGkMCa/GsYjdh8jkveeKrcHBYAaSni5f7KJdD1tKD//DaE6OpeOliSw9jTGACk6/q27En/56Y9arpxTPGQ0r/IKekjyxyaVbdELVLYTq9L5rrLoeNBu6TsTDvSd8NekREYhHi81Y4q4qtTxXXGYnqFNxJ0Jh67Cee6WrLSLe1Qax4Rw==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BYAPR12MB3045.namprd12.prod.outlook.com (2603:10b6:a03:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Tue, 23 Aug
 2022 09:49:43 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9004:5ecd:2616:2150]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9004:5ecd:2616:2150%7]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 09:49:43 +0000
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
Thread-Index: AQHYT0tpbpOS7hf0yU2uZi+ifIWmea21TECAgAfAfYA=
Date:   Tue, 23 Aug 2022 09:49:43 +0000
Message-ID: <93b8740b39267bc550a8f6e0077fb4772535c65e.camel@nvidia.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
         <f1eea2e9ca337e0c4e072bdd94a89859a4539c09.camel@nvidia.com>
In-Reply-To: <f1eea2e9ca337e0c4e072bdd94a89859a4539c09.camel@nvidia.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 569739a9-71a4-406c-d57f-08da84ecce3b
x-ms-traffictypediagnostic: BYAPR12MB3045:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cqxKP8sUA7tSAfhPkZIJLEV1lf60zZHpXSLvSAzxWmuwypIAEeumEoo2fBon/ONYHhyYTPnBjLWgB7GD6LOKWN1SOBHr0E/KuV2vKVKVsWQ+pMyFINK0qHNBSdnR1VHMotm42RWRQ/VUOA0Fm+H6Y13d+3nEJaCHXDPz9bUFaKhI7i5s3PyXgG8QJ8WIwmqaJU1snM+eh1oTYPVYUYRkvYDRAMDY1/Wn4gWkAeinY4dSW4sXf9rgUfdnlOmgYs8vhCau5MNJckD0YFRP4LOm99exd0ycbVy+KTAXndsh63qCRK1H4TW7GcYzEhmYY+3hcB5EwspLKmS+87C2EyHDfOvNTxosVMlVUHmn6N7LyUqc1ST5mZDVn0EE48Sm5DNM7zEOREVqIh2VjU286148ZCw2hsUlhQggOlE1da5YJmMnNycN27mB9A8POsbB+0QqywU2nhmUkk0zLbUGAj4cPBNmTaHnOAq8IxqlmaDfcY/YnpTHITgHxhJIDQHT/FrWMPDqIYtu4Gk647wAV+6BGZnNGIGrxBjaF/L9dZfMQUVnjQjTPvAg6cWF4+AJrORnv8KXH1yXwX9g1iYYHJLM7uSfrzvDHh+Z2IRAHyQNZB8+I15zLJN7e3nUXl5lClIqsM5yU2In5y0Mb8QkTCOGZZBwXzJxwM2FOuUGk3iSt23Y4Z6s5w23oYujs3Uv9qKAo/JgXxwR2EXvLOj/l6+uKMg1N6fCJDaXLyzRuksazgcxb1ndcf+HzJeLevDublizmq56yN4AqahEUZ5mmM7pMP7PJw54h9T/9ArusQtc6JcqDq60wBBjTTq10rYPdPl52349G+5ojLzemZs3tDdG7yFT0agJQfr7IGf4CzKr1q6UzWwhSNXLyI7Mrr6DIsu1EzK0FdJofD+I1e0fbJ+lDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(2906002)(110136005)(54906003)(86362001)(6486002)(966005)(6506007)(6512007)(2616005)(71200400001)(478600001)(66574015)(186003)(83380400001)(316002)(8936002)(5660300002)(38070700005)(76116006)(91956017)(66946007)(4326008)(122000001)(38100700002)(66556008)(66476007)(64756008)(66446008)(8676002)(41300700001)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1FtNmFpbWljSDFWTk9MeWh2MGpPa2lkbFhLQmZVR0J0YXpuazcxQzRGUXZG?=
 =?utf-8?B?L0FPTnlEU29GS283NmIyR24yeU84VGZHem5NTmZxWjJvRnhxTlhuM0licWUv?=
 =?utf-8?B?cFBIQ2RTMzBySE83WWlWb2F0c1RXbnI3dFB3cVlYR3p0OTN2UTVvODFHZEx3?=
 =?utf-8?B?ZmpHdkUyZDF2cXllaHlKcldRWlZTZmQzRE5kRUt4MXdqait6bkVqYm1zTVlL?=
 =?utf-8?B?MDJ6QXkwM3BPV0tNMEViL3oyekNjajAvNVd1azQwZXkxMkVOcTlwdm05MnNL?=
 =?utf-8?B?ZU5UK1ZudEczNjFJUXhqS2lrNVpSTlNla05tbTY0QkpRT1RtWWRlUEErb0dw?=
 =?utf-8?B?WHBINlQzYzA4YUhCcEtkdWVPcy9LY0JDSS90alp0aXJzOWp5L0UrOXZrRENo?=
 =?utf-8?B?Uk1sMDFBQ3FtcE9iczJubzlOSkRsS09MZXBLdE5PV05oa3dxTFNXTThHTGZH?=
 =?utf-8?B?Vkp2bUJESEI4Q0R4b0l2WkJlbTVDWWdrRGJsVzVjVEh2K2JWVlIvdUxjZXVx?=
 =?utf-8?B?UHFSYlhwajFTR3FkWGZGbkFSc3NHUzk2VFBIQ2FpcDJHY1ZhaGxGaG54ZXBX?=
 =?utf-8?B?ZTVSbXpBT0Y0OGlPT1ZGZHJZK1ZKMG1iek1wYnpmY0o4RW4zektpbFN2cU0z?=
 =?utf-8?B?MTJRbkJXdm4ydWM0NDExZGdUM1hNLy9CNG96eHZxY0tUcXorL2VFdTFjTXFW?=
 =?utf-8?B?M3YrV2hlTTVGRHFKWFJZWDRLczJIeC9UemVDNC95Tjh6OE1oSnlGamQ0MFBl?=
 =?utf-8?B?by9na21WOTFNaUNEai9MdnpvWGw2VEFQc0I4VHdKVytMaTVtemVNK0Y2b1p0?=
 =?utf-8?B?RjBOckxvZUlITWxGaTZOWE94aW83MG4rQURXcTdwWjFpWFc1dHNBRG5ObDdy?=
 =?utf-8?B?bkdDbzJzZDc2YzFEM1hyajVyYW8vRzlPRWJiRkMvRnBod21TZlZjcEtaRmVy?=
 =?utf-8?B?enl2OTgyUEF1MDBHMTdEcWx2a0o4TEVLcThzSGdKUmZiM0taQSsvVXBMRVBJ?=
 =?utf-8?B?SzlOUHNxTmxPZ3pDck5TYWdMNDMweldnL3IrczVpdlN0Wk9lNnEvZFhSNE5R?=
 =?utf-8?B?T2ZoVTdMTExrV2tWajRTS1VjN0JobHQzZ05JbTRKSnJlMHJJQUZON01CYUVS?=
 =?utf-8?B?bllySDh3dkM3K1RSZHhlNGhlM1NJdlZoQlpJQWhWSnByMlViQk1uT3pob2M0?=
 =?utf-8?B?eDJheE90SmRrOFZVRkZaS1ROaU9LQlJLbWxZOUJxZHR4UFVueDlGc0ZvT3Q1?=
 =?utf-8?B?TmMzMElGQWU2VVlmUVBWbXR3dUpiZXFsTWhZbkNZMVV0a1RKNUZreEEwQnJm?=
 =?utf-8?B?THhnN25UNnltY1N1NnMzMXBoNTVybnJYNmRNWGZTeE1mVDBiSmM2c0xxYUo1?=
 =?utf-8?B?TnFPSGxyaUIwVzF2aU01L3JXQ0YvQ280bjUzdVByUGVqM3E4WGlEL1p5NW1E?=
 =?utf-8?B?c3ZERnRRQ3Q1a0p0amtHZi9UYXVrNUEzbHh5QWhmeGRMRGpnM3J1OU9yRlFX?=
 =?utf-8?B?M0t1dVF0WFVuOTh2ZCtOWUkwajBCUEhQUGl4WTRLT01GL2ZLYkZyVDBvNG93?=
 =?utf-8?B?TDdJNVkxY0FvWnFLeHlqVE1KWDVzRVlWaE9nMWVIZ3hKN1c1YXl5b1ZiQ0F1?=
 =?utf-8?B?VHJMK0lOWFhGdU1ZMU44UUh4SU1GM1ZrTXFmaVFLVzUrMTl4UjV1OU82bDlU?=
 =?utf-8?B?RldvRFAxcXNmUjBkZTRpT0tBeGlmMmN6WjRLZWpxTEhUWk5zcTRGUDVlNzdO?=
 =?utf-8?B?dUpUWnJwNG5XWVNDM1BlYzRMZldGREFNUXhjaXcvenVnTzFMaDJlNno5Sjl3?=
 =?utf-8?B?aUFZSFNiTXZwRmJZd2ZTRm5iWlBvT25NUno0eURFazRFSE53cnpXS0ErSjJD?=
 =?utf-8?B?b2UxTVZDV2I0dUErY2Z6WkFEeEtEekIzK1VtY3pIN3BkcEdMZzJOVmFtY1Yx?=
 =?utf-8?B?VEdPZ01FdTNQbUxwem95ZDFLSlVJS3ArdXM0d21RTi8xTUx1cEhXL2RHL0lP?=
 =?utf-8?B?eVQ5QkdMSnp0TE42dC9oTUUwZTlwcWJpbXJVaHNnYjVEa0p0c1JZcTdIVkJx?=
 =?utf-8?B?aTRRL3F6TGxkN2pHcGdsYXNkMkVQeHFJb1VRSnlLQ2RiK3BvbzBOanVRRktv?=
 =?utf-8?B?L1hESHljL0s0NEgxQWlwWE9MNzYvLzg2bHJ0aW1qN0hTaEtjb0h1bjFNWFVT?=
 =?utf-8?Q?LwubmmoQgwgmRYU3IOu5QS5vZsa1kFaQxKl17kM8BGhA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3CA581F4BC72041A99FDF65AB4AF86C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569739a9-71a4-406c-d57f-08da84ecce3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2022 09:49:43.3053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LAEKuQVnpeIPd3Cq5JyW4oiygPoe9J1xam2wbO6LnH1NfUOdzdrGelqpuhYyQX1SWRoboLC1FeCawyzqL6QvdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3045
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW55b25lIGZyb20gSW50ZWw/IE1hY2llaiwgQmrDtnJuLCBNYWdudXM/DQoNCkRvZXMgYW55b25l
IGVsc2UgaGF2ZSBhbnl0aGluZyB0byBzYXk/IElNTywgY2FsbGluZyBYRFAgZm9yIHRoZSBzYW1l
DQpwYWNrZXQgbXVsdGlwbGUgdGltZXMgaXMgYSBidWcsIHdlIHNob3VsZCBhZ3JlZSBvbiBzb21l
IHNhbmUgc29sdXRpb24uDQoNCk9uIFRodSwgMjAyMi0wOC0xOCBhdCAxNDoyNiArMDMwMCwgTWF4
aW0gTWlraXR5YW5za2l5IHdyb3RlOg0KPiBIaSBNYWNpZWosDQo+IA0KPiBPbiBXZWQsIDIwMjIt
MDQtMTMgYXQgMTc6MzAgKzAyMDAsIE1hY2llaiBGaWphbGtvd3NraSB3cm90ZToNCj4gPiB2MjoN
Cj4gPiAtIGFkZCBsaWtlbHkgZm9yIGludGVybmFsIHJlZGlyZWN0IHJldHVybiBjb2RlcyBpbiBp
Y2UgYW5kIGl4Z2JlDQo+ID4gwqDCoChKZXNwZXIpDQo+ID4gLSBkbyBub3QgZHJvcCB0aGUgYnVm
ZmVyIHRoYXQgaGVhZCBwb2ludGVkIHRvIGF0IGZ1bGwgWFNLIFJRDQo+ID4gKE1heGltKQ0KPiAN
Cj4gSSBmb3VuZCBhbiBpc3N1ZSB3aXRoIHRoaXMgYXBwcm9hY2guIElmIHlvdSBkb24ndCBkcm9w
IHRoYXQgcGFja2V0LA0KPiB5b3UnbGwgbmVlZCB0byBydW4gdGhlIFhEUCBwcm9ncmFtIGZvciB0
aGUgc2FtZSBwYWNrZXQgYWdhaW4uIElmIHRoZQ0KPiBYRFAgcHJvZ3JhbSBpcyBhbnl0aGluZyBt
b3JlIGNvbXBsZXggdGhhbiAicmVkaXJlY3QtZXZlcnl0aGluZy10by0NCj4gWFNLIiwNCj4gaXQg
d2lsbCBnZXQgY29uZnVzZWQsIGZvciBleGFtcGxlLCBpZiBpdCB0cmFja3MgYW55IHN0YXRlIG9y
IGNvdW50cw0KPiBhbnl0aGluZy4NCj4gDQo+IFdlIGNhbid0IGNoZWNrIHdoZXRoZXIgdGhlcmUg
aXMgZW5vdWdoIHNwYWNlIGluIHRoZSBYU0sgUlggcmluZw0KPiBiZWZvcmUNCj4gcnVubmluZyB0
aGUgWERQIHByb2dyYW0sIGFzIHdlIGRvbid0IGtub3cgaW4gYWR2YW5jZSB3aGljaCBYU0sgc29j
a2V0DQo+IHdpbGwgYmUgc2VsZWN0ZWQuDQo+IA0KPiBXZSBjYW4ndCBzdG9yZSBicGZfcmVkaXJl
Y3RfaW5mbyBhY3Jvc3MgTkFQSSBjYWxscyB0byBhdm9pZCBydW5uaW5nDQo+IHRoZQ0KPiBYRFAg
cHJvZ3JhbSBzZWNvbmQgdGltZSwgYXMgYnBmX3JlZGlyZWN0X2luZm8gaXMgcHJvdGVjdGVkIGJ5
IFJDVSBhbmQNCj4gdGhlIGFzc3VtcHRpb24gdGhhdCB0aGUgd2hvbGUgWERQX1JFRElSRUNUIG9w
ZXJhdGlvbiBoYXBwZW5zIHdpdGhpbg0KPiBvbmUNCj4gTkFQSSBjeWNsZS4NCj4gDQo+IEkgc2Vl
IHRoZSBmb2xsb3dpbmcgb3B0aW9uczoNCj4gDQo+IDEuIERyb3AgdGhlIHBhY2tldCB3aGVuIGFu
IG92ZXJmbG93IGhhcHBlbnMuIFRoZSBwcm9ibGVtIGlzIHRoYXQgaXQNCj4gd2lsbCBoYXBwZW4g
c3lzdGVtYXRpY2FsbHksIGJ1dCBpdCdzIHN0aWxsIGJldHRlciB0aGFuIHRoZSBvbGQNCj4gYmVo
YXZpb3INCj4gKGRyb3AgbXVsaXRwbGUgcGFja2V0cyB3aGVuIGFuIG92ZXJmbG93IGhhcHBlbnMg
YW5kIGhvZyB0aGUgQ1BVKS4NCj4gDQo+IDIuIE1ha2UgdGhpcyBmZWF0dXJlIG9wdC1pbi4gSWYg
dGhlIGFwcGxpY2F0aW9uIG9wdHMgaW4sIGl0DQo+IGd1YXJhbnRlZXMNCj4gdG8gdGFrZSBtZWFz
dXJlcyB0byBoYW5kbGUgZHVwbGljYXRlIHBhY2tldHMgaW4gWERQIHByb3Blcmx5Lg0KPiANCj4g
My4gUmVxdWlyZSB0aGUgWERQIHByb2dyYW0gdG8gaW5kaWNhdGUgaXQgc3VwcG9ydHMgYmVpbmcg
Y2FsbGVkDQo+IG11bHRpcGxlIHRpbWVzIGZvciB0aGUgc2FtZSBwYWNrZXQgYW5kIHBhc3MgYSBm
bGFnIHRvIGl0IGlmIGl0J3MgYQ0KPiByZXBlYXRlZCBydW4uIERyb3AgdGhlIHBhY2tldCBpbiB0
aGUgZHJpdmVyIGlmIHRoZSBYRFAgcHJvZ3JhbQ0KPiBkb2Vzbid0DQo+IGluZGljYXRlIHRoaXMg
c3VwcG9ydC4gVGhlIGluZGljYXRpb24gY2FuIGJlIGRvbmUgc2ltaWxhciB0byBob3cgaXQncw0K
PiBpbXBsZW1lbnRlZCBmb3IgWERQIG11bHRpIGJ1ZmZlci4NCj4gDQo+IFRob3VnaHRzPyBPdGhl
ciBvcHRpb25zPw0KPiANCj4gVGhhbmtzLA0KPiBNYXgNCj4gDQo+ID4gLSB0ZXJtaW5hdGUgUngg
bG9vcCBvbmx5IHdoZW4gbmVlZF93YWtldXAgZmVhdHVyZSBpcyBlbmFibGVkDQo+ID4gKE1heGlt
KQ0KPiA+IC0gcmV3b3JkIGZyb20gJ3N0b3Agc29mdGlycSBwcm9jZXNzaW5nJyB0byAnc3RvcCBO
QVBJIFJ4DQo+ID4gcHJvY2Vzc2luZycNCj4gPiAtIHMvRU5YSU8vRUlOVkFMIGluIG1seDUgYW5k
IHN0bW1hYydzIG5kb194c2tfd2FrZXVwIHRvIGtlZXAgaXQNCj4gPiDCoMKgY29uc2l0ZW50IHdp
dGggSW50ZWwncyBkcml2ZXJzIChNYXhpbSkNCj4gPiAtIGluY2x1ZGUgSmVzcGVyJ3MgQWNrcw0K
PiA+IA0KPiA+IEhpIQ0KPiA+IA0KPiA+IFRoaXMgaXMgYSByZXZpdmFsIG9mIEJqb3JuJ3MgaWRl
YSBbMF0gdG8gYnJlYWsgTkFQSSBsb29wIHdoZW4gWFNLDQo+ID4gUngNCj4gPiBxdWV1ZSBnZXRz
IGZ1bGwgd2hpY2ggaW4gdHVybiBtYWtlcyBpdCBpbXBvc3NpYmxlIHRvIGtlZXAgb24NCj4gPiBz
dWNjZXNzZnVsbHkgcHJvZHVjaW5nIGRlc2NyaXB0b3JzIHRvIFhTSyBSeCByaW5nLiBCeSBicmVh
a2luZyBvdXQNCj4gPiBvZg0KPiA+IHRoZSBkcml2ZXIgc2lkZSBpbW1lZGlhdGVseSB3ZSB3aWxs
IGdpdmUgdGhlIHVzZXIgc3BhY2Ugb3Bwb3J0dW5pdHkNCj4gPiBmb3INCj4gPiBjb25zdW1pbmcg
ZGVzY3JpcHRvcnMgZnJvbSBYU0sgUnggcmluZyBhbmQgdGhlcmVmb3JlIHByb3ZpZGUgcm9vbQ0K
PiA+IGluIHRoZQ0KPiA+IHJpbmcgc28gdGhhdCBIVyBSeCAtPiBYU0sgUnggcmVkaXJlY3Rpb24g
Y2FuIGJlIGRvbmUuDQo+ID4gDQo+ID4gTWF4aW0gYXNrZWQgYW5kIEplc3BlciBhZ3JlZWQgb24g
c2ltcGxpZnlpbmcgQmpvcm4ncyBvcmlnaW5hbCBBUEkNCj4gPiB1c2VkDQo+ID4gZm9yIGRldGVj
dGluZyB0aGUgZXZlbnQgb2YgaW50ZXJlc3QsIHNvIGxldCdzIGp1c3Qgc2ltcGx5IGNoZWNrIGZv
cg0KPiA+IC1FTk9CVUZTIHdpdGhpbiBJbnRlbCdzIFpDIGRyaXZlcnMgYWZ0ZXIgYW4gYXR0ZW1w
dCB0byByZWRpcmVjdCBhDQo+ID4gYnVmZmVyDQo+ID4gdG8gWFNLIFJ4LiBObyByZWFsIG5lZWQg
Zm9yIHJlZGlyZWN0IEFQSSBleHRlbnNpb24uDQo+ID4gDQo+ID4gT25lIG1pZ2h0IGFzayB3aHkg
aXQgaXMgc3RpbGwgcmVsZXZhbnQgZXZlbiBhZnRlciBoYXZpbmcgcHJvcGVyDQo+ID4gYnVzeQ0K
PiA+IHBvbGwgc3VwcG9ydCBpbiBwbGFjZSAtIGhlcmUgaXMgdGhlIGp1c3RpZmljYXRpb24uDQo+
ID4gDQo+ID4gRm9yIHhkcHNvY2sgdGhhdCB3YXM6DQo+ID4gLSBydW4gZm9yIGwyZndkIHNjZW5h
cmlvLA0KPiA+IC0gYXBwL2RyaXZlciBwcm9jZXNzaW5nIHRvb2sgcGxhY2Ugb24gdGhlIHNhbWUg
Y29yZSBpbiBidXN5IHBvbGwNCj4gPiDCoMKgd2l0aCAyMDQ4IGJ1ZGdldCwNCj4gPiAtIEhXIHJp
bmcgc2l6ZXMgVHggMjU2LCBSeCAyMDQ4LA0KPiA+IA0KPiA+IHRoaXMgd29yayBpbXByb3ZlZCB0
aHJvdWdocHV0IGJ5IDc4JSBhbmQgcmVkdWNlZCBSeCBxdWV1ZSBmdWxsDQo+ID4gc3RhdGlzdGlj
DQo+ID4gYnVtcCBieSA5OSUuDQo+ID4gDQo+ID4gRm9yIHRlc3RpbmcgaWNlLCBtYWtlIHN1cmUg
dGhhdCB5b3UgaGF2ZSBbMV0gcHJlc2VudCBvbiB5b3VyIHNpZGUuDQo+ID4gDQo+ID4gVGhpcyBz
ZXQsIGJlc2lkZXMgdGhlIHdvcmsgZGVzY3JpYmVkIGFib3ZlLCBjYXJyaWVzIGFsc28NCj4gPiBp
bXByb3ZlbWVudHMNCj4gPiBhcm91bmQgcmV0dXJuIGNvZGVzIGluIHZhcmlvdXMgWFNLIHBhdGhz
IGFuZCBsYXN0bHkgYSBtaW5vcg0KPiA+IG9wdGltaXphdGlvbg0KPiA+IGZvciB4c2txX2NvbnNf
aGFzX2VudHJpZXMoKSwgYSBoZWxwZXIgdGhhdCBtaWdodCBiZSB1c2VkIHdoZW4gWFNLDQo+ID4g
UngNCj4gPiBiYXRjaGluZyB3b3VsZCBtYWtlIGl0IHRvIHRoZSBrZXJuZWwuDQo+ID4gDQo+ID4g
TGluayB0byB2MSBhbmQgZGlzY3Vzc2lvbiBhcm91bmQgaXQgaXMgYXQgWzJdLg0KPiA+IA0KPiA+
IFRoYW5rcyENCj4gPiBNRg0KPiA+IA0KPiA+IFswXToNCj4gPiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9icGYvMjAyMDA5MDQxMzUzMzIuNjAyNTktMS1iam9ybi50b3BlbEBnbWFpbC5jb20vDQo+
ID4gWzFdOg0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIyMDMxNzE3NTcy
Ny4zNDAyNTEtMS1tYWNpZWouZmlqYWxrb3dza2lAaW50ZWwuY29tLw0KPiA+IFsyXToNCj4gPiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9icGYvNTg2NDE3MWItMWUwOC0xYjUxLTAyNmUtNWYwOWI4
OTQ1MDc2QG52aWRpYS5jb20vVC8NCj4gPiANCj4gPiBCasO2cm4gVMO2cGVsICgxKToNCj4gPiDC
oMKgeHNrOiBpbXByb3ZlIHhkcF9kb19yZWRpcmVjdCgpIGVycm9yIGNvZGVzDQo+ID4gDQo+ID4g
TWFjaWVqIEZpamFsa293c2tpICgxMyk6DQo+ID4gwqDCoHhzazogZGl2ZXJzaWZ5IHJldHVybiBj
b2RlcyBpbiB4c2tfcmN2X2NoZWNrKCkNCj4gPiDCoMKgaWNlOiB4c2s6IGRlY29yYXRlIElDRV9Y
RFBfUkVESVIgd2l0aCBsaWtlbHkoKQ0KPiA+IMKgwqBpeGdiZTogeHNrOiBkZWNvcmF0ZSBJWEdC
RV9YRFBfUkVESVIgd2l0aCBsaWtlbHkoKQ0KPiA+IMKgwqBpY2U6IHhzazogdGVybWluYXRlIFJ4
IHNpZGUgb2YgTkFQSSB3aGVuIFhTSyBSeCBxdWV1ZSBnZXRzIGZ1bGwNCj4gPiDCoMKgaTQwZTog
eHNrOiB0ZXJtaW5hdGUgUnggc2lkZSBvZiBOQVBJIHdoZW4gWFNLIFJ4IHF1ZXVlIGdldHMgZnVs
bA0KPiA+IMKgwqBpeGdiZTogeHNrOiB0ZXJtaW5hdGUgUnggc2lkZSBvZiBOQVBJIHdoZW4gWFNL
IFJ4IHF1ZXVlIGdldHMgZnVsbA0KPiA+IMKgwqBpY2U6IHhzazogZGl2ZXJzaWZ5IHJldHVybiB2
YWx1ZXMgZnJvbSB4c2tfd2FrZXVwIGNhbGwgcGF0aHMNCj4gPiDCoMKgaTQwZTogeHNrOiBkaXZl
cnNpZnkgcmV0dXJuIHZhbHVlcyBmcm9tIHhza193YWtldXAgY2FsbCBwYXRocw0KPiA+IMKgwqBp
eGdiZTogeHNrOiBkaXZlcnNpZnkgcmV0dXJuIHZhbHVlcyBmcm9tIHhza193YWtldXAgY2FsbCBw
YXRocw0KPiA+IMKgwqBtbHg1OiB4c2s6IGRpdmVyc2lmeSByZXR1cm4gdmFsdWVzIGZyb20geHNr
X3dha2V1cCBjYWxsIHBhdGhzDQo+ID4gwqDCoHN0bW1hYzogeHNrOiBkaXZlcnNpZnkgcmV0dXJu
IHZhbHVlcyBmcm9tIHhza193YWtldXAgY2FsbCBwYXRocw0KPiA+IMKgwqBpY2U6IHhzazogYXZv
aWQgcmVmaWxsaW5nIHNpbmdsZSBSeCBkZXNjcmlwdG9ycw0KPiA+IMKgwqB4c2s6IGRyb3AgdGVy
bmFyeSBvcGVyYXRvciBmcm9tIHhza3FfY29uc19oYXNfZW50cmllcw0KPiA+IA0KPiA+IMKgLi4u
L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV90eHJ4X2NvbW1vbi5oICAgIHwgIDEgKw0KPiA+IMKg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jICAgIHwgMzggKysrKysr
KystLS0tLQ0KPiA+IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV90eHJ4Lmgg
ICAgIHwgIDEgKw0KPiA+IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV94c2su
YyAgICAgIHwgNTMgKysrKysrKysrKysrLS0tDQo+ID4gLS0tLQ0KPiA+IMKgLi4uL2V0aGVybmV0
L2ludGVsL2l4Z2JlL2l4Z2JlX3R4cnhfY29tbW9uLmggIHwgIDEgKw0KPiA+IMKgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfeHNrLmMgIHwgNTIgKysrKysrKysrKy0tLS0t
DQo+ID4gLS0tDQo+ID4gwqAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay90
eC5jICAgfCAgMiArLQ0KPiA+IMKgLi4uL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1t
YWNfbWFpbi5jIHwgIDQgKy0NCj4gPiDCoG5ldC94ZHAveHNrLmMgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICA0ICstDQo+ID4gwqBuZXQveGRwL3hza19xdWV1ZS5oICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfCAgNCArLQ0KPiA+IMKgMTAgZmlsZXMgY2hhbmdlZCwgOTkgaW5z
ZXJ0aW9ucygrKSwgNjEgZGVsZXRpb25zKC0pDQo+ID4gDQo+IA0KDQo=
