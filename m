Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4424A66D3A1
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 01:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbjAQAdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 19:33:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbjAQAdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 19:33:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516A82A145;
        Mon, 16 Jan 2023 16:33:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXPWWaOgJclINj+HCL3IscILcbh5sdIFhHD43Q98j7r+XDfXQu9wXcaSWrif0lby4J9J2d63ECo7AeYPEsHONIeTpwJaCYuGP3h8ub+cuYE2yzLYCCy8/P+UxDiGS/G0n13vogimbhYIjRAcIpANgwBBzhH/FneYWiAgchInuGj5Rg+zRE3/OMT6KzuJWMtDyxdhDduTFl7jUcjyUvOP/hUr2zJoABJT75K50VGN1zdte15izxPaiGvImP6v3scfNPhDOdJJa/7l9WRUiIJ9wwZwEynmSDJmGz3S/WQMjTVVv72uP6RTwzWMUK0UGkdCJTPZq/aXxwQB2FvIWl92Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeO6BRRgbB97O2Q2C3oBmrQdi8ULJsoXXm1jTu5FUwI=;
 b=ZLwLj+xu7E+jqia0ZHQSVFQnthiU7GS5umUej2fD9Gei8spVEq42ENiQoSvqWX5R/K845Mek/LA1c3VF0FXGJpOn/baSrLidIRlNiwcwIRntLF7o53w7tuxyV8ZjFQkzJIpQyOFe4Ti31HiA0voswY4VdtyK7cIQhae8/jP/Vx5Bc8Wf1HL/pYqj3AnzwqPil1yaFARk8Q9rzJ39WHlULM+p0OGJ5fm+a6oQHFJvvo37nPkt6X0fj1LyjPIUGdWhL7A+dJwcPssCY6q2f1/VWSt8Yl0g9no7byeQnDqnwL2zqWiQ5ZKIj8vDEB/vsC0bv7DzDqySw5WNCtbuh5OVKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeO6BRRgbB97O2Q2C3oBmrQdi8ULJsoXXm1jTu5FUwI=;
 b=SbkK0lxh/rTN2sBi3brGfXNug2PnnkrfixeDA9h0a1NpfFxTYYGl1VYWuuqsYHgHYg5VCwsxxlStZj9Hp7TKw2f+SroHjr+9cQDY6J4QLzvVl0xhqM2NkZLcflAxDCEWVHwdDeuApRHV8DxDGiRYMOeqBWkHsp5xd4TtU4nfqjq/6TyyUSEZW8qNz6fseVgeFxhywg7UimO2SsS64MwmTiwSfBdZEbplEZY61EtmzcsPbLMmDufRPlTBK5sWt7dT27e5quajJ/1QyjcSzCZ02gc6KNTusLM9t3Xc3iLxJ2LubziRkKV91WgD41IjjOjSRkXpg4n9zW/iEqAde4KmpA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:389::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 00:32:59 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5986.022; Tue, 17 Jan 2023
 00:32:59 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Israel Rukshin <israelr@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" 
        <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 11/13] nvme: Introduce a local variable
Thread-Topic: [PATCH rdma-next 11/13] nvme: Introduce a local variable
Thread-Index: AQHZKaxHVD5zkyAsbECelDFns/Z2ka6hwyeA
Date:   Tue, 17 Jan 2023 00:32:59 +0000
Message-ID: <c095c9a9-0e77-c8ab-d34e-f4ab42b11938@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <cf5bc542e014f465f7ae443e52e70def2993aef1.1673873422.git.leon@kernel.org>
In-Reply-To: <cf5bc542e014f465f7ae443e52e70def2993aef1.1673873422.git.leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DM4PR12MB5390:EE_
x-ms-office365-filtering-correlation-id: 9edea2fe-6b61-475f-84c6-08daf82262c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b65imYg05CXSnDvYIgqOdJ3Tpa7wbtlbqzCtQk04gBHjk8H5cgtu2ri8F0KxCVGccx9zGtGN0L2eONSY7zQC1SbR5UgASjKN+v0p0xxx2fICulVDvXxcdyQi/r4VpDHC+jUqNP97wTcW51L3B/3SZOG+oeHMTb1pmk6Sa4h2sEukN1noRRWhtynbbvIJ+CydkvA52rPtMCUNUGtiEMAO1/lmk8kWiNdiJcBEpwBnbXdo3WPJMM9iJDUSo6cW4zpMEZXAbZwffovJhUNCrrwf2H3bzc1APKDdaKK4dm0KucnDVk91CbBsZ5bc+s/YETmNyAzPsNKzLFy/P+ExZQg7s9Z32j0Up+JvhojRQ2kFcymuCCL7/MH2sDujbPOvp0ZWWhXStDNn2TzZKj0CgfPoINp66A7Rg62BuDVX9nqr7lelbNECm4FlP0wTc0MFSXanbEI3Z5Z9toBMpAqZ7uaLpLgTAap/U0wmDSPnjSqSnsUVXlqwsm7r+OwMld1AExWd07RhEQ3O7ZM7ZTPgnT/1+sWSev9HGbfZa2/OkgclEnhTAqvMgNXlL4ro4SOVioicKTEdai7FhaDRf8PjFXxNXVZ16x1ANlF1O1NAY56GqrIx+ZSpKta7+MyBZD6r46J+bmyCaqaMrdu/dfszz9/nc9L5diGjBLbO95s1PLW0NpjkM9XHMzBV/vXRAd2LivgnJVTYqbLynOcR3P69RAKPGQ+HhD0s7o0F9VbzUnzqHoIEhwMdqme33Agt2C+RSm6JNrhzI42/6hir723tzzCMFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199015)(7416002)(36756003)(2906002)(107886003)(6506007)(53546011)(76116006)(122000001)(5660300002)(8676002)(31686004)(4744005)(4326008)(8936002)(91956017)(64756008)(83380400001)(66446008)(6636002)(38100700002)(6512007)(478600001)(41300700001)(38070700005)(6486002)(186003)(66476007)(66946007)(31696002)(66556008)(71200400001)(54906003)(2616005)(86362001)(316002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UU5Ecm4zbCtkSG4xYm9qRDdyZ3NCbnZ1ajc0OGZ1ZFBIUVJvd2M0cGg5KzhG?=
 =?utf-8?B?K25mWkhNcFpJSzhzQVl2U3pORktIMllheDhqZHFCdGVUdHUvejdTdFpBS1R2?=
 =?utf-8?B?TkMydVVwdWFaK0s2bXowY2VyQW1Ma3g1OTI2eEFRMHZLb3gzRklLZjYrdXpI?=
 =?utf-8?B?VlMrTFJYMC9CaHE0T01kclpBRSsrWGdGZ0VqY0k3UHJSQzZ0a1lkQkV6WHl1?=
 =?utf-8?B?c3BTSzFUTFhtcjdiV25iNjY1am9YaUtlOVpqNnhWUTJhOUxNNDkzWXBOcG85?=
 =?utf-8?B?RXhFNFhtNmR4RlFwcW1VbU55K3p0TEF5OFoxNy9aYXI4OUtoOUIxeDQrVFR2?=
 =?utf-8?B?UHY5ckVvRUFGUnNacGVodW0yZzdwMUR3eHpxaGNzVk9mN1NiakRSdkhZOFNW?=
 =?utf-8?B?eEhWMjlub3dyQ21WQ3VRWW5CZ3k5TDk1c3Fod3A2bVVjQ0U2T2txcnZpMnk2?=
 =?utf-8?B?Z3FPWTBhQVh0MUxhbmVOYXZEdGRVbHVWRjQvdUw5MjdPczRHVkdZZUh5QitB?=
 =?utf-8?B?OXYrQUo2aXdNVmJsblowVmY4TnZkZG0wenAvMFpYN1RsQ00wT0dYemltb1hr?=
 =?utf-8?B?ZDQyVUtOMnhUOEhqSkNDeFZEYzMwSE1kS3hZcmdpa1dtM2JqT3hCWFkyTVpP?=
 =?utf-8?B?K3F3aXJKZW0yc25oWGtkWWl3b3czZmtEcTd0b1ZYcFBCV0kxRDIvY09DZm1J?=
 =?utf-8?B?VGhybGxSd25oR2dSeEFJN3VOS0ZQZ1FGbFRMS3RJVmVWNnhnTzk5SmNtOEhG?=
 =?utf-8?B?OUZIR2VkdEFyYk1PQk9NdUJGMEZsUWVJWVBGeXhORzkwVXkrYXl5RlhiWnFO?=
 =?utf-8?B?b3prR0d6alFGTnJnY2JMRy9ReGRZSG0rVmVOR1ZsbTdKRjFzQ2pFaUVVSHlQ?=
 =?utf-8?B?UGRpdW9GU3o5bHRWVTJybzRHZ2hxaGx0aW05SnVXUDhQUGdvWHo0Y0xscUlo?=
 =?utf-8?B?cEtJM2Y4aytjNDU5cEh4YkI2RmUvVW8reXN6K1RQMDBxQ00wNnZISi9jY1Vm?=
 =?utf-8?B?MXk1d1BqdXNtQ05BdGtqb3VjRFYrRHRlZVQ4QXJJWFdJQk5UcTVrMTFzZTJR?=
 =?utf-8?B?S3FwQUo3TitYRFp3RlFCbWRLTHVxcjM3alhva25wVXliQ2xFYnl0RlpZU1U5?=
 =?utf-8?B?L2RyVTdrd3F0V0x5Rzh6UTlqN0RpcHZpdkVpaFNra3FFZTZSaGVvN2dTUkVT?=
 =?utf-8?B?U3VpaXZjQlh2S21sd1o3ZXVJd0lzdmZJenR3M202aTlRa1NpZlpEVW1Md2ds?=
 =?utf-8?B?Yk1hbGkvVFd4bk1EMmd1Um84WkNrMVpWckpPbjhpNUdLcjVWOEtkK0lTU0VR?=
 =?utf-8?B?d0hOSlNFUHdhRDN4dHppdWs0MjFrZ2pEV1hyb1ljenpUZlp0VjRvV3M4dDN0?=
 =?utf-8?B?am1ON0ZyUE5KSWRRelZyc0VEb3hVL2t6QjVMOEdiTFJRcU84eXJXNnFka1hI?=
 =?utf-8?B?MngzOGJRK0pxZXBYWktXZ0x0a1h2WUlwb29SK2k3YzROeDIwNEdyUGI0MHBm?=
 =?utf-8?B?UXA4VTV1dEIrUlRVZjVyVlJyQ0RrQWp5Z1Q1TWRvbTU5blNEcnNHYVZmd3Yr?=
 =?utf-8?B?SkZWMjlSa3FSVGVrZmtUVVcyWVRPTHNyR0RYTS95N3J0WEhiRmVJWkJHS1RO?=
 =?utf-8?B?bG5YQXFkYmdBQ2l6WmxHdnFkbFRJS2RuSG1WL2loR2pCNU9MVWVoQThpczhk?=
 =?utf-8?B?VVU0OUlOMUFPckxNQXBCNWpsSUJ6MkM1R3o0QVhGaTBsYlZydGxjKzAzZnMy?=
 =?utf-8?B?YVVvMmx1QlV6eUthTWgrblBpNzlPKzI4UTBxdURyYmV6L201V3pMUUFEK2Qz?=
 =?utf-8?B?bHFNMGJGYytpSjRXd3hlUFREOWtmYXJZeHd0U1N6alVJV1hFR2wxbFhBS0Nx?=
 =?utf-8?B?YjlXTnE4Z0tvZHdDbWVwbHVkZDkyclc4SkhTT01MMG5yRU5BTjhQbWd5dTlZ?=
 =?utf-8?B?anpxQWJHeVF6Y1RSaDZLb1hmLzVjOXNTWkNxYTBUM3YxTFBlRHVTUkt1Q0Jh?=
 =?utf-8?B?MHZhcW9HR3VTZ1VuQ1dlbVRZalkyKzZUR1ZQaG9IRThVUHgySnlZdWVXWXpF?=
 =?utf-8?B?SEFWVHRsL3U2eDNSYllwY2UzcXVSTzg0TS96ejVNKzZzblR4VHF3aFFLU2Z4?=
 =?utf-8?B?dDN3MDZsRWJFU3VGV3Fta25oNi9MRmRrdkQ1YVdMaXprMWc4UlR5THNyRkJw?=
 =?utf-8?B?MFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <835BEEC0E72A5943AE3BFF7EE05AED0B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9edea2fe-6b61-475f-84c6-08daf82262c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 00:32:59.5787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q7JRV1qOyyndDLMlraLaxsqhYfBL9zDsMHoX5Fn2jFz/gwIK1Y/8AUk2zzejCLjgVl5PhlgFriSzf8XREv5oDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5390
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8xNi8yMyAwNTowNSwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPiBGcm9tOiBJc3JhZWwg
UnVrc2hpbiA8aXNyYWVsckBudmlkaWEuY29tPg0KPiANCj4gVGhlIHBhdGNoIGRvZXNuJ3QgY2hh
bmdlIGFueSBsb2dpYy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IElzcmFlbCBSdWtzaGluIDxpc3Jh
ZWxyQG52aWRpYS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IExlb24gUm9tYW5vdnNreSA8bGVvbkBr
ZXJuZWwub3JnPg0KPiAtLS0NCj4gICBkcml2ZXJzL252bWUvaG9zdC9jb3JlLmMgfCA3ICsrKyst
LS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYyBiL2RyaXZlcnMvbnZt
ZS9ob3N0L2NvcmUuYw0KPiBpbmRleCA3YmU1NjJhNGUxYWEuLjUxYTk4ODBkYjZjZSAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9udm1lL2hvc3QvY29yZS5jDQo+ICsrKyBiL2RyaXZlcnMvbnZtZS9o
b3N0L2NvcmUuYw0KPiBAQCAtMTg3MCw2ICsxODcwLDcgQEAgc3RhdGljIHZvaWQgbnZtZV91cGRh
dGVfZGlza19pbmZvKHN0cnVjdCBnZW5kaXNrICpkaXNrLA0KPiAgIAlzZWN0b3JfdCBjYXBhY2l0
eSA9IG52bWVfbGJhX3RvX3NlY3QobnMsIGxlNjRfdG9fY3B1KGlkLT5uc3plKSk7DQo+ICAgCXVu
c2lnbmVkIHNob3J0IGJzID0gMSA8PCBucy0+bGJhX3NoaWZ0Ow0KPiAgIAl1MzIgYXRvbWljX2Jz
LCBwaHlzX2JzLCBpb19vcHQgPSAwOw0KPiArCXN0cnVjdCBudm1lX2N0cmwgKmN0cmwgPSBucy0+
Y3RybDsNCj4gICANCg0KSSBkb24ndCB0aGluayB0aGlzIHBhdGNoIGlzIG5lZWRlZCwgZXhpc3Rp
bmcgY29kZSBpcyBtb3JlIHJlYWRhYmxlIGFuZA0KZ2l2ZXMgbXVjaCBjbGFyaXR5IHRoYXQgd2Ug
YXJlIGFjY2Vzc2luZyBjdHJsIGZyb20gbmFtZXNwYWNlIHNpbmNlIHdlDQphcmUgaW4gbnZtZV91
cGRhdGVfZGlza19pbmZvKCkgd2hpY2ggaXMgbmFtZXNwYWNlIGJhc2VkLg0KDQotY2sNCg0K
