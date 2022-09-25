Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0C45E916F
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 09:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiIYH3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 03:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiIYH3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 03:29:42 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADC3E09D
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 00:29:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6i31AmHIIStDMOv6sJs1ngEUZ+5XaMO4Ca2DOmSipYodNDgoCkQvtqSTeBmYhnCJYA+pNO7hzhCG6lMV5802DBUht5QCnB2tDjblnW+rUXlh831DyTgCFP60PzKDb9JwEXCuSYzLihsPEXDJ79isTSjJjZTR28V6Ci7jUc09FH3f5n+WOWCSG6AzP8kRCV+u422GU0/cOxofSHqvh31wqMSDEWAg1xP9FPTF8nXbNKHu4965HW5KY5mLtENeClPOBilUdfrSeeYX/uyQakjXebK2yPfjrVoPP6Yh709/SkAPjYpOJnqVyu1mHOWCVSANj8iXeuqbJHcbK90FbkI+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6bvlRt5p4j2JJvntMBXRAnFGB39TVKn6C5Im4k/SWk=;
 b=i936+qUO1XJHGwBFEkVnTpxyxTHx4KHzBaPnDT6eIz15C2E8k+1Bp+hVvcVrw4oFa1gTngXH5Su5FGCWRTLNePU3bxF0JqNci1muhBth/lA9Xzn3mue7qN3VfuEqkmD7iCWHAEhkcyU53fkehINNDnxvVgcGZXPtpywEl3WdmBStU2aSasj13KTBQqrDUbb7Kma/KMnMRjr5JL8o+AUWyzisY2mGNescqZ2/SsSCEvPLxxnUSJh5xF2vbC1u4T+oF6txZJRit+Aaqt4sXVeiTtXMUdRl7XTAQwu7mo4a1FiLWOmzp0S0wqdS1RKKEnMmJh5HNUpfo25pJO71v1O3+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6bvlRt5p4j2JJvntMBXRAnFGB39TVKn6C5Im4k/SWk=;
 b=BYm50EF2pJt3B1WLWKGVFpgigx0dyLI4G8oTSwt9j+bvMWomb0rb40TfLb5bemQeVqaB1unwc4jDLKDgKT8D/y/mBcUzzHC3/sgpInVlOHi+7ElZqrcPgmmNtDa+l0Z97lZRrte8OEQsFsJprYErEddH29SQ+bKyJHtFNp2aqArzgq8UPqP2ksVPRSyTzLk81h2DgfNSuFIttf09N5b16p31vwWDegzBMT4afZbXdc1nk8wv3E78GVpdTADufbmBO26SWu1vfRbRiVo1dwRBrsZA/BgJrzySRDrYikpre42iRT20lWMIaSDj7mcqC7Qg/Mic2f/Gc99xEYJ2C/UPeg==
Received: from DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24)
 by MW4PR12MB6826.namprd12.prod.outlook.com (2603:10b6:303:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Sun, 25 Sep
 2022 07:29:36 +0000
Received: from DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066]) by DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::ec0e:6950:ee5b:8066%9]) with mapi id 15.20.5654.024; Sun, 25 Sep 2022
 07:29:36 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Lior Nahmanson <liorna@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [PATCH net-next] macsec: don't free NULL metadata_dst
Thread-Topic: [PATCH net-next] macsec: don't free NULL metadata_dst
Thread-Index: AQHYzywB/fmQ+Wfw8ECBN4a/ZTpbza3vwm2w
Date:   Sun, 25 Sep 2022 07:29:36 +0000
Message-ID: <DM4PR12MB5357EB2AF3F1AA4184DBF7B2C9539@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <60f2a1965fe553e2cade9472407d0fafff8de8ce.1663923580.git.sd@queasysnail.net>
In-Reply-To: <60f2a1965fe553e2cade9472407d0fafff8de8ce.1663923580.git.sd@queasysnail.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5357:EE_|MW4PR12MB6826:EE_
x-ms-office365-filtering-correlation-id: 35827583-574b-4eeb-edd7-08da9ec7b31d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W0OkN70YPlGwe6mCEMUNE40dx9tp4z8v6UMwExo5Z1lBjB3fTYhooTJZ6ehQAwD3sckdh0KnlXbRhBawiSUTiV50d3pyiPWSLrhgbit82dc3dsCIr1vDIOkl+U7LJ9IrynUV4Xouw37E6DLLkL5ZyvOEixBVczo8gEDKO8ORApVnI0dU636BpolUM4I6w9Fz+g+c8mBs8c1axHVwF91/ZSoA+DfAlmJeJerqgXjdQBTO5d1eIEzhyrjE8zGRm3yp5bWQ0FOYWLyCRrjdVY3RxFnU53fnC8JbXtxLLQRyylj++swwYCGJuMbwi7/G5JFwoPmnAglJszmAkbdUemZOxWz0wy0pdRBgWadJj8Xc04ofSG2Ch5+1I5KeCuqL3wkp4BvDqeyAMKeX9Zmdpz0hwQjY7C9p9Jc2g0plJIn0YSOUsEvJEIUwavdDsZou7l2RkIRABvfPPQfBcCm4+RlFH+VKSjbqSjI5YlLBMlHJDW5t4GACUtMtF78jfLd8OpdyUzEAYSPspVFRI5r/ldULAu5+IJGnRECp1kXq788ihFZz3fsh44XTLbihk13jH/krTXntDcZdPoe4afHr0z5tmEtf94h3R91eEKwaZt/eyF8fJCerUXqd3J6z/uvJOvo1rVanetisSIjibfFEi9ve6mMhJU8bY2RbnYPPOGfDcTOGAPNZ8HWSt5xVZhXheTfvd8WoJ4VNliAbtFZJRCVpS7JgC8RV6tMahHDwV6i9LzgvZmVu097FtFbynMeLXTg0Nx1U490vQSaNoxJX5Dd95A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5357.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199015)(76116006)(122000001)(33656002)(186003)(38100700002)(66946007)(66556008)(66446008)(64756008)(66476007)(4326008)(8676002)(316002)(478600001)(52536014)(6506007)(7696005)(38070700005)(55016003)(86362001)(5660300002)(83380400001)(54906003)(110136005)(8936002)(71200400001)(107886003)(2906002)(9686003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3ZHcU1aZ1Y2ZmN5VGtvQnJib3JTSHFKRlNJUXJCRFYxaGVhMGdzU21zWnVs?=
 =?utf-8?B?KzhHaDU5UGZpMytldGdKNEEvd09DRFAvZkNPQlhtRHNrcGcxRGlSUFlTbUxs?=
 =?utf-8?B?cko1VHpvSXhUb0hqcDkyUjNiZFpsdXBZM2E0U01sOFQ0dWsxV0JCUnY1ZCty?=
 =?utf-8?B?QU80RDVSRDFLdlJlcU9jbXl3RFBpY0hJdlZMUTRrcnlmWTZvempkQWtlZStV?=
 =?utf-8?B?MXB5RDFTV3VLemEyNFM1QjdTSkZmU09naVNIUHFRZ28xby96M3Byc1B5WXJ6?=
 =?utf-8?B?MFBTcTR4c25WbHRqQWl2L1NUd3Y0dTlVQ2pWUjRIeW5COGJralhENkluR1p1?=
 =?utf-8?B?YXJ1R3ZqWklDUjBhOU9OVldLejBkeXQrYkYvcUVCUGxYMTR5YVR6bnJndENQ?=
 =?utf-8?B?cFpIdzJlUkk5VWprd2ZsWldyWVBpaVVsajc3dVZQWkNpU25wRllENDhJNzM0?=
 =?utf-8?B?Mnc2WnIxT3dmOFBLY1VVRnVWOTZHaDh2YWVQNlFQRXNFZVBLVDBEeVcybXNl?=
 =?utf-8?B?Wm1PanNtK0t5SURzMHJ3TzZFU0hma3ZoMnlNSGFSQ0ZYdDRuWjIzdXdvMUxx?=
 =?utf-8?B?VkFxRlV2d3lNbmVYaXBoa1lHTjlJWHdBK1dTMEZnS1h1WWtiVGt4cU1ML3Nu?=
 =?utf-8?B?UXZqMXhLTnZXS0EvaktGYzdFSkhkWXQxanV6MithSmJza2xKUDlCNFRzSE1G?=
 =?utf-8?B?WEFINkJ4YmtNaDVZTTZoWjhyNWlzNi9yajRVREdKa0JPeXNqYmhHSllpdXV1?=
 =?utf-8?B?OEFHNmZkK1FURTNINC9zRkpHbjNTcWJVU2tqZkNad1ZiZ2JFVWg4ZEp6aWRY?=
 =?utf-8?B?Zk9ZREFlNU9VZEtNQ2ZPNUVoVm96Q2M1eXpPRkt6OVNvM0xndEQ2bmV0YkZp?=
 =?utf-8?B?L3dNc2ZtRUNqbmZYZ1p1L0R3aW45QytjMTlsOHVoT1B5aU01NTBQS0tQRFYr?=
 =?utf-8?B?ZzdFUGtaQnhaOC9qa3YzZFRJdW9SNTdCaWFUMW1ZWnY4dDZUWGFkT0RoaTRl?=
 =?utf-8?B?cTNsS2MyekhaQUs1OFd5d3hjSUhORDI4VmQ5VnhIWjY0cVBlNlovTUN2TTZz?=
 =?utf-8?B?MzFucVdqQTluQ0hqakwzU2NOeXhuTWwwVTVrK0QzT0JMSmJWanU5TjZKWDEz?=
 =?utf-8?B?aXNaMUljeUU4cGZtaXNoZE5TZmErbGxYcHZJOU1PMHdXUmEyVnNSNTJwbjQr?=
 =?utf-8?B?aFJ4aUltR1lRYjkrdllORWNXQThmcTBKZE9FR0gxbUhpek5wMjBJYnNkSFli?=
 =?utf-8?B?M3VSamhhNnc0NWNWRzF2RnlYQ2dFK2l0eElHVVg4aHpWbUdkbGlvWTJaTlp0?=
 =?utf-8?B?aWo1TzErdloxWjJWNGVvUGFPMlI3b3AyRG1ZclNtY2J0SGdDdmFGeklXMURk?=
 =?utf-8?B?bzgyRWFPMHI5SENOczc2MytJWGRIOTdjL2tWaFN5cHNuVytyL2NlOUpoaHkz?=
 =?utf-8?B?TVUzRy9lOXIwM0lOaDBCNnYxZkFZcVlxMGUyRnhtZC9rM0tHckhONkF3R3Vq?=
 =?utf-8?B?bnJzMVMrVjRzOVNGZUpWSEt4elMrUzMzYjhnc0xScHRxODhWdldlazVLTHNJ?=
 =?utf-8?B?ZXFsWXY2bHc3Wkx0SjdxTmVqQ3BhMERaYnYwS3I0VnE3WWdnTXIxQmVWeS9S?=
 =?utf-8?B?Q1FiUzN0cUhiZW5hUlFoNTF4QVpac1RyYnFzZHMrVnZrTmJYd0lyWVZpdzFY?=
 =?utf-8?B?ZmUrSUJGYUFQbnloY0xpa0FiZWRKbmRLNnlLb0FVTTZmbThnbzIvTGl0TTBa?=
 =?utf-8?B?V3dNN0M2Um9sNGp4VXM0SUFyQ1lTUzE5S1VkZDJrL3ZsS1F2Q3h2RExpV3l5?=
 =?utf-8?B?RHRpUm45alpMQTZkMHZRSUs2WkpieVlZSnNLTEkyTXVKNFFoVXN5ZUJkNytP?=
 =?utf-8?B?dGJRaDRoWTE0MFQ0N2dCYmNNVHVwd2M2elVzZFUxMjBtL3RFaHZBbnViQWhY?=
 =?utf-8?B?aEpKODFpNVJYbzNoSitXZmhZVjdUVWFlRjNQS1V3cllLb1ZhKzVKc0Z1MHRB?=
 =?utf-8?B?TXk0emZoYnpoWDVmYjlYNkxUVEUrSjl5RmNBTnNZd0J6Qmx2MzBudlh3eTRO?=
 =?utf-8?B?eTZyV2xTZ3RSbE85cDdkUEpUd2Q3OGlRNUZ2YXQxVUtHY1h3QTFoUExMNzBt?=
 =?utf-8?B?TW5aeVRvUy9oWnV0TmhySkZYdlNMMm5lQjRobWhDbmtGejBQbEVMTXRCcTc3?=
 =?utf-8?Q?TlKUC+Waovw1vv4iYvAkqwY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5357.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35827583-574b-4eeb-edd7-08da9ec7b31d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2022 07:29:36.6641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BbxDfhqRvV1a/VvDnVNycfpr0E7r9aviYMv7oRR4RNl3i+ppYY9w3hHb9CCnYhdXR5NEEyGNgIeLz0CJT42rGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6826
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PkZyb206IFNhYnJpbmEgRHVicm9jYSA8c2RAcXVlYXN5c25haWwubmV0Pg0KPlNlbnQ6IEZyaWRh
eSwgMjMgU2VwdGVtYmVyIDIwMjIgMTI6MDcNCj5UbzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0K
PkNjOiBMaW9yIE5haG1hbnNvbiA8bGlvcm5hQG52aWRpYS5jb20+OyBSYWVkIFNhbGVtIDxyYWVk
c0BudmlkaWEuY29tPjsNCj5TYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG52aWRpYS5jb20+OyBTYWJy
aW5hIER1YnJvY2ENCj48c2RAcXVlYXN5c25haWwubmV0Pg0KPlN1YmplY3Q6IFtQQVRDSCBuZXQt
bmV4dF0gbWFjc2VjOiBkb24ndCBmcmVlIE5VTEwgbWV0YWRhdGFfZHN0DQo+DQo+RXh0ZXJuYWwg
ZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4NCj4NCj5D
b21taXQgMGEyOGJmZDQ5NzFmIGFkZGVkIGEgbWV0YWRhdGFfZHN0IHRvIGVhY2ggdHhfc2MsIGJ1
dCB0aGF0J3Mgb25seQ0KPmFsbG9jYXRlZCB3aGVuIG1hY3NlY19hZGRfZGV2IGhhcyBydW4sIHdo
aWNoIGhhcHBlbnMgYWZ0ZXIgZGV2aWNlDQo+cmVnaXN0cmF0aW9uLiBJZiB0aGUgcmVxdWVzdGVk
IG9yIGNvbXB1dGVkIFNDSSBhbHJlYWR5IGV4aXN0cywgb3IgaWYgbGlua2luZyB0bw0KPnRoZSBs
b3dlciBkZXZpY2UgZmFpbHMsIHdlIHdpbGwgcGFuaWMgYmVjYXVzZSBtZXRhZGF0YV9kc3RfZnJl
ZSBjYW4ndCBoYW5kbGUNCj5OVUxMLg0KPg0KPlJlcHJvZHVjZXI6DQo+ICAgIGlwIGxpbmsgYWRk
IGxpbmsgJGxvd2VyIHR5cGUgbWFjc2VjDQo+ICAgIGlwIGxpbmsgYWRkIGxpbmsgJGxvd2VyIHR5
cGUgbWFjc2VjDQo+DQo+Rml4ZXM6IDBhMjhiZmQ0OTcxZiAoIm5ldC9tYWNzZWM6IEFkZCBNQUNz
ZWMgc2tiX21ldGFkYXRhX2RzdCBUeCBEYXRhDQo+cGF0aCBzdXBwb3J0IikNCj5TaWduZWQtb2Zm
LWJ5OiBTYWJyaW5hIER1YnJvY2EgPHNkQHF1ZWFzeXNuYWlsLm5ldD4NCj4tLS0NCj4gZHJpdmVy
cy9uZXQvbWFjc2VjLmMgfCAzICsrLQ0KPiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pDQo+DQo+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L21hY3NlYy5jIGIv
ZHJpdmVycy9uZXQvbWFjc2VjLmMgaW5kZXgNCj42MTdmODUwYmRiM2EuLmViY2ZlODdiZWQyMyAx
MDA2NDQNCj4tLS0gYS9kcml2ZXJzL25ldC9tYWNzZWMuYw0KPisrKyBiL2RyaXZlcnMvbmV0L21h
Y3NlYy5jDQo+QEAgLTM3MzQsNyArMzczNCw4IEBAIHN0YXRpYyB2b2lkIG1hY3NlY19mcmVlX25l
dGRldihzdHJ1Y3QgbmV0X2RldmljZQ0KPipkZXYpICB7DQo+ICAgICAgICBzdHJ1Y3QgbWFjc2Vj
X2RldiAqbWFjc2VjID0gbWFjc2VjX3ByaXYoZGV2KTsNCj4NCj4tICAgICAgIG1ldGFkYXRhX2Rz
dF9mcmVlKG1hY3NlYy0+c2VjeS50eF9zYy5tZF9kc3QpOw0KPisgICAgICAgaWYgKG1hY3NlYy0+
c2VjeS50eF9zYy5tZF9kc3QpDQo+KyAgICAgICAgICAgICAgIG1ldGFkYXRhX2RzdF9mcmVlKG1h
Y3NlYy0+c2VjeS50eF9zYy5tZF9kc3QpOw0KPiAgICAgICAgZnJlZV9wZXJjcHUobWFjc2VjLT5z
dGF0cyk7DQo+ICAgICAgICBmcmVlX3BlcmNwdShtYWNzZWMtPnNlY3kudHhfc2Muc3RhdHMpOw0K
Pg0KPi0tDQo+Mi4zNy4zDQpBY2tlZCBieSBtZQ0K
