Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C9566D39E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 01:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbjAQAba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 19:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbjAQAb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 19:31:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA7C2886E;
        Mon, 16 Jan 2023 16:31:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPRT4RxL/yKJ7lBittGlx9YTxldADAEWq204A0friLn8TSj4i3n6E/5u1kLV/zBO0EoJVKxAqyYfz7ZLcETvF2EorNhH4xXUotpFQ0YsmD1krdcI84l6Hh4ndYTv1xa7akDjZmou0DzekKjticoAv1sK20MGGBk2URU7hFL39Ug+QO78Dz8DfCKARIIFuPPfvQCjdYYvrRc0KzVH6Mj22eJnMZ3BUsOgzzudxiaL50kHmE19paTenGvBIooQni4vLhqDZyDBRNGAugRchxPAcqsmGPQlNHJauCY9geiyT5QL0JGkp4KLqYaghbCGFVRqHBXxPFqmoI6MqEHLmoIWFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D13cpUPDWVPFB1CJshF2IBtCKb3RO7UY1tX2ORD5O4Y=;
 b=oTXFR5YZ1qEW0bZVC2LoT/CE3cF1yfNzRn//oxq65i4R+I4AkNojbawtFGdwLZ5ufc3dpDIO4SUNh+EZ48MVNkyZzmpaT5fi3IAS75WrGMCZutpWS7hvCGF3ORu0g76smHK1kz6GvM6KOKG6J5fE+97QbvJpLIFgazMbTV+LIELjMljw27Z6KVYFd57oa6L5IZyuSomPXDsheMboCvOj8Yfyr/q7Z3i8OkP8Yy/vklQN4iGrWPdYuN/Jclf+GNveLlM7FWj/dx5NK12taeHdGUbEK7VJ4RRtR88Bu1F+/LozQFUrYsTzHTvaqTe72Fe0jLKds1kyp8ZKjTOYU2kGMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D13cpUPDWVPFB1CJshF2IBtCKb3RO7UY1tX2ORD5O4Y=;
 b=qS9u9gQLSzXBAPO+8AT5o6Z8oxmvzYNQ4bIyMAbPKJTIQSysrnsSzf5gavmcTZA4HRDMhvDOP0Q7e/FueHNs/BcuSrm6u48tIe3VJP333eMbzJFkSHAdjoKlzbXrkuPdWo0VS99U8BhoqeMMPz2SSxl3OX9Fvr0PlzueZ3+e4RfgqQKew3RYQYksI9wMLxrIeTdqzf4NhHdMkRWToeNE37+XV5G+sjrwURYhJ1gu6v02zsJFuRzRKACec8YFec8aJ+a5R0UsPsM7fz7qbNmbIexK05Wje/HtchY8iAwpjC345zZhRD5jFu8v9Xg6kTKKRdF9Uk9Bl7QComU1n2t1nQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:389::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 00:31:23 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5986.022; Tue, 17 Jan 2023
 00:31:23 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Israel Rukshin <israelr@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>, Bryan Tan <bryantan@vmware.com>,
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
Subject: Re: [PATCH rdma-next 12/13] nvme: Add crypto profile at nvme
 controller
Thread-Topic: [PATCH rdma-next 12/13] nvme: Add crypto profile at nvme
 controller
Thread-Index: AQHZKaytERU2LmOXwU2MWs0vBNPRVK6hwrIA
Date:   Tue, 17 Jan 2023 00:31:22 +0000
Message-ID: <52fef455-fd7a-225f-c03f-b214907ce03b@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <efc8dc5952baa096a14db1761f84a5ab2e76654a.1673873422.git.leon@kernel.org>
In-Reply-To: <efc8dc5952baa096a14db1761f84a5ab2e76654a.1673873422.git.leon@kernel.org>
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
x-ms-office365-filtering-correlation-id: d5b45c2b-1db8-41ed-f9fa-08daf8222931
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LtJcb1zJlnOBdhmM7TJwyL11UlQWR4bC7V0FzE66ojgpDAHZWEhbzhgyxdMKolu2prkSsjMKOZ6hWNAFgZnkFDnldNSXyaBTr8ghLYt6RHczaPTupzdCQU9dK7KrafMnTAyD4Pt7ct8M0/TkFgopxvtjr66csAUI66utfXfFp6ql4hdDtm4rMfOS25Y9K0bvJGkdQR0UuDfPlVSgULPgJHDdeltaLhuEVmgJHHMOBB+u4VP26b7QxKqs6WS7Sdp3SyNkKBSDiIbtknTcNAKHsmTSvxkeWJXiBheMoR0yHj3t4pvZX2BzO58mxzx52Re4l/+0PEyzwT2IH2dk+twYbUoOYA13Gkp1RmR0ZBY8us/lCkpb4XpFRaBSEKqO7yXAKggrMdb+fjbMpKHh2f0Oxa6oyZhaKUhu79675eSJ5ZikgBXZ5UvhNKoflPeu2B2I5cpb95fET7mtTTj/cTdcVnciZR1ZPZDN3YF/WR2JPKYIXKrXZjBhCUKM9S3VUskMMvw5i6LGzXSAfOIQhEeFYTrOSpJ4sbgXs27vYGTSGM5MxjfaKEZYXt8PPOxIGaAp0LPGCKRxUobJQQoGpafMYcgVhyPFvcnFoX1f7hOtV3HFL5FPSkdBeN1Z+b88uM3RcfZ4fWz7/BJZqTrDE9LmJgzmZcTMWfQ3vMONTe99Xhdxhg62fxYb0evwuCI6vEMXDERAA9oV4vb7RoIiy1EvYNrU5v9GUUT8c0PHAZRsw77HGgiMB4tcxaAxZpewWbSmkxxVakoDCSSoCLUFxEz8jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199015)(7416002)(36756003)(2906002)(107886003)(6506007)(76116006)(122000001)(5660300002)(8676002)(31686004)(4326008)(8936002)(91956017)(64756008)(83380400001)(66446008)(6636002)(38100700002)(6512007)(478600001)(41300700001)(38070700005)(6486002)(186003)(66476007)(66946007)(31696002)(66556008)(71200400001)(54906003)(2616005)(86362001)(316002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmErdUlwYmFvL05ndndzcmQwWDNOL0htdGpIa0oxVmc2L240NVRJUVg2ZGpq?=
 =?utf-8?B?Q0U5dVZSTkpMV2dVWEUvcUZwQ0ExbVBHMTFoZzM0bjVIdHIxUEpDTzBBSnpC?=
 =?utf-8?B?d0NXNVJMNVRrRTdKVG1HeWhWUjdyS1pQWWtOT05HaXpob0ZEcjZrUlhzZFhu?=
 =?utf-8?B?OXB1c2VobUtuM21uUVc5M1RtYmgzNnRvcThPbzFrN1ZlZlFWc24rclllZHl4?=
 =?utf-8?B?U2l4MkxCQ0w0cll4eEF2WVVsZ3oyaEhSdXllNG5PNG5XWkhMdXROWmxkSkxR?=
 =?utf-8?B?UEJZTGZ6Nk9TdmdtWU9NQmN5WXNZNGR3eWhhQ1c0cWpWVHBhMThrRjduazZk?=
 =?utf-8?B?SE5UOEx6eFhZdDFZZWZ1alBsWHBoZkxwNkN2OHRjU0tuazkyRlo3cU1BS3Fs?=
 =?utf-8?B?SjBUcDRJVGhCNHRkc0twZjFkM0J6RjNLa2lXTldJUHQ4bXlDT09NMzZNdnky?=
 =?utf-8?B?Sjk5M0hhaStLUC9MQWtwNkVINzE5bExZbk43dFBiVVFWbkRYaURzWkY5NGJa?=
 =?utf-8?B?VS92bEZkejhEK3BVbEpuUEdPUEx5RSsrUUh2TG5OWE9UK3VvdFJyVW1rMUZF?=
 =?utf-8?B?STJWSjVqYzJmY3o4ZkVBSVY1NDQwcWdzM250R3ExS2Y3Z3hNd2FpZlozSkVk?=
 =?utf-8?B?cUEwOHozbVBWNzgvdENheE5LaDFBbmhycEJpd2xoNkNHZ21aTG5mUVJvRFlt?=
 =?utf-8?B?dVpLZGpRZWlpbHE0YW9obDBrVTNLdVRvdy9UWG5HUGdNYi9mNDl0V2U1NDRs?=
 =?utf-8?B?SlJVYmFKakh3VnZNYTZwK0hIdTlqaG9RajVUVVNWaWMvMFcyWkgxUmVVbkls?=
 =?utf-8?B?RjZUTXZzM0pQOSt0T3prMnV0WjdXRjVpT2VMNkVlTE1vU2VQb0E3TUJqZ1V5?=
 =?utf-8?B?RU5BUDlFNjhTWTdTWXZ6ajVFWmF2K3d2ZEFDeXlSMUxvRExER1A4c3c4WTNQ?=
 =?utf-8?B?cGRUWnkyNDZPVjZXWGMwTzZsSGlrTHMwVTBqbnEzODZVRGtqdlovK2VpRjVU?=
 =?utf-8?B?WTJUb2FybTQrRGpDUmo1UW9vOGlIV1dEQXdsOFFxakZRcEJPcjVIQkQ3alNF?=
 =?utf-8?B?NnBqcXdGRC9aaWs2MFpva1BrczhjdXRsNzhTME90TWt2MVFKeHR1blQ3bXQy?=
 =?utf-8?B?b1luWlVIRkVaaTVXaG1zZHdmd2ZqQVdkVUp5RHN2NE5vLzU5d1pMbjAxZ0JJ?=
 =?utf-8?B?QXFESVhSQ0oyVy9lT1RsMmNlem5PMTRTZWxsRno2bzNrUmw3RnhzK002Tjh0?=
 =?utf-8?B?bDdCQ0RXOFVCREYyeUxXblpCUjltVUJ6SUVRUmVVUGx4QWJBNktOaUdGdjBP?=
 =?utf-8?B?ck1WMWc2L216UG1pR0tjdXd6aXRzVTJLSk93L1RBVTNLckhnRVlySk1pYitC?=
 =?utf-8?B?YkRNSkV1L0UrR0RQbkNScytGdk1DZE5uMk0vek1lc1FidVJ3b1JkRXlPemxv?=
 =?utf-8?B?VG1lZjlXaytIYmU1ajNjOVVyRUpLODZDZDhkcWNDSE1ScGd1UEUyQjcxWkRQ?=
 =?utf-8?B?NERCZk0yYnRFb2pyQkhla2lkcjczV28xbXZwMlNoT2t1NUJGS0crOUtHdkhC?=
 =?utf-8?B?cHcwNm5EbWdDeE1yaVhtVFlPQ0YzUVloTkoxdElDNHJHNjVMS2FtVWtLdzFo?=
 =?utf-8?B?MGs4UkNGNlhCcjl5L1E0WDU1Y2xESmRzV05wUDV2SW5EYy80MU0wVDJUeXF5?=
 =?utf-8?B?N2l0NVY1czJPZVFsSU5HTlNuODBvSU9qUEttV0V5Vk00RE41SUN1bERYbEJS?=
 =?utf-8?B?a3FXamlhd0VpeUkzTlJkU1dualE0d3Q1cUhMbjk2TGo1WlhSb1pCdjVvcWcy?=
 =?utf-8?B?YVhPRmxnZ1dnc1BCYmw1aVRlbGdSVzgwS3BQRWh1elNNQzlOSmdZSUZ5a3Vm?=
 =?utf-8?B?VG5rSUpMN29Ga3JWM011ZlU4SE4vK205bFliaHhqTkhKYUFud2dZZEllQXFs?=
 =?utf-8?B?NHdjZWdLdHdzVEtPTkgrQXY4L20ycG1NS0pYaXZ5Tjg2UG1wNm0vTE0xb042?=
 =?utf-8?B?aUlNMTZOVTVSSFdFcUlDbTJvZHdDbEVpSTJaak43MWhwWnpmRmRIMm9BUXNW?=
 =?utf-8?B?Zk8rTWxwOEdvWDdiemZwWng2Q2M1clVuUnp4MnE5cFhxSjB0SXo5bmdUNTFt?=
 =?utf-8?B?dFpkWVBqVCtmaFJpcWhjSHhUSE9pV3Y0dFdLc0d1MTVpdUxqckdFY2dQTG94?=
 =?utf-8?B?S1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E61E4732E77AF498790074B6E30FDC3@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b45c2b-1db8-41ed-f9fa-08daf8222931
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 00:31:22.9751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5XU3CHaLYAJykBMeYBbzvIKZTQRgPNaZYz4x1HwCQZjfABZUpjlMG6Vdn9O7We2cRCm21gu+ywhdts2nKNvzSg==
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

PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9udm1lL2hvc3QvY29yZS5jIGIvZHJpdmVycy9udm1lL2hv
c3QvY29yZS5jDQo+IGluZGV4IDUxYTk4ODBkYjZjZS4uZjA5ZTRlMDIxNmIzIDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMNCj4gKysrIGIvZHJpdmVycy9udm1lL2hvc3Qv
Y29yZS5jDQo+IEBAIC0xOTI4LDYgKzE5MjgsOSBAQCBzdGF0aWMgdm9pZCBudm1lX3VwZGF0ZV9k
aXNrX2luZm8oc3RydWN0IGdlbmRpc2sgKmRpc2ssDQo+ICAgCQkJY2FwYWNpdHkgPSAwOw0KPiAg
IAl9DQo+ICAgDQo+ICsJaWYgKGN0cmwtPmNyeXB0b19lbmFibGUpDQo+ICsJCWJsa19jcnlwdG9f
cmVnaXN0ZXIoJmN0cmwtPmNyeXB0b19wcm9maWxlLCBkaXNrLT5xdWV1ZSk7DQo+ICsNCj4gICAJ
c2V0X2NhcGFjaXR5X2FuZF9ub3RpZnkoZGlzaywgY2FwYWNpdHkpOw0KPiAgIA0KPiAgIAludm1l
X2NvbmZpZ19kaXNjYXJkKGRpc2ssIG5zKTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZtZS9o
b3N0L252bWUuaCBiL2RyaXZlcnMvbnZtZS9ob3N0L252bWUuaA0KPiBpbmRleCA0MjRjOGE0Njdh
MGMuLjU5MTM4MGY1Mzc0NCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9udm1lL2hvc3QvbnZtZS5o
DQo+ICsrKyBiL2RyaXZlcnMvbnZtZS9ob3N0L252bWUuaA0KPiBAQCAtMTYsNiArMTYsNyBAQA0K
PiAgICNpbmNsdWRlIDxsaW51eC9yY3VwZGF0ZS5oPg0KPiAgICNpbmNsdWRlIDxsaW51eC93YWl0
Lmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L3QxMC1waS5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L2Js
ay1jcnlwdG8tcHJvZmlsZS5oPg0KPiAgIA0KPiAgICNpbmNsdWRlIDx0cmFjZS9ldmVudHMvYmxv
Y2suaD4NCj4gICANCj4gQEAgLTM3NCw2ICszNzUsOSBAQCBzdHJ1Y3QgbnZtZV9jdHJsIHsNCj4g
ICANCj4gICAJZW51bSBudm1lX2N0cmxfdHlwZSBjbnRybHR5cGU7DQo+ICAgCWVudW0gbnZtZV9k
Y3R5cGUgZGN0eXBlOw0KPiArDQo+ICsJYm9vbCBjcnlwdG9fZW5hYmxlOw0KDQp3aHkgbm90IGRl
Y2FscmUgY3J5cHRvX3Byb2ZpbGUgYSBwb2ludGVyLCBhbGxvY2F0ZSB0aGF0IGF0IGluaXQNCmNv
bnRyb2xsZXIgYW5kIE5VTEwgY2hlY2sgYWdhaW5zdCB0aGF0IHBvaW50ZXIgaW5zdGVhZCBvZiB1
c2luZw0KYW4gZXh0cmEgdmFyaWFibGUgY3J5cHRvX2VuYWJsZSA/DQoNCmUuZy4gOi0NCg0KCWlm
IChjdHJsLT5jcnlwdG9fcHJvZmlsZSkNCgkJYmxrX2NyeXB0b19yZWdpc3RlcihjdHJsLT5jcnlw
dG9fcHJvZmlsZSwgZGlzay0+cXVldWUpOw0KDQo+ICsJc3RydWN0IGJsa19jcnlwdG9fcHJvZmls
ZSBjcnlwdG9fcHJvZmlsZTsNCg0KeW91IGFyZSBpbmNyZWFzaW5nIHRoZSBzaXplIG9mIHN0cnVj
dCBudm1lX2N0cmwgdW5jb25kaXRpb25hbGx5LA0Kd2h5IG5vdCBndWFyZCBhYm92ZSB3aXRoIENP
TkZJR19CTEtfSU5MSU5FX0VOQ1JZUFRJT04gPw0KDQotY2sNCg0K
