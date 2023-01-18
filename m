Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C97067155F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjARHsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjARHqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:46:11 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438514390E;
        Tue, 17 Jan 2023 23:14:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViqklOAwjcErYIoA83c+io9xoYGT7QjEU0GMAgTWXTuk8a1OXdK5txrjAg+rB0mSISXh/FkLtUCpjK3zRdM+++iCdl7SDLG9JC7m1R7dN8hlgD8MX6NJJarJqPQFrOowU5fFY2wzZn0D8LHcN4R9L8NrXbRNqiO4zDWBUkBRJx9sEqHOnlGyk3OCQTyZLSRsON4O114T4kC8Ibmbu2deGVa2xNwDI6hX0cn1WuRBqHV3C5RhYsOBFxi+NlmIOIlVr6aZ6AIZFIg3CTJIdrNoZ7ASaX6DUHG2x9x2CEHnwVRgiNYOYHoCMwrItz+tGoC7+TjdiNZI6+NOpwjbmF14LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tb0YZJoRjRZ4chXv/UIkZFOdm7DfOGAJ+iEbkOrjTUg=;
 b=QHoPqUTwxQ0rhdQorX6WGKaK60OXvvU2YPglxI2aG1YGfDhBTHyYAcykk6ZQmAryfALKzyDuKwcD0rNhuKpolejQfkRgul+EXoBLpaGqm3XFQcUckOrtsFfWIGbak78jzBMaloFtaBRFKRcMbvZ6FtFMMotxR7EKEAylp6Qwhv+GK1/egeyGLqOJaHOq85DoxgOWT8P3t/ZUM0YeUZRJc8VWeckw5iFWOlWZFgVaeyJRZVEnVgr1VID4zCoh0QWpOMj5KFrovYpRDHzNvnViqu49wYz954YsReDmCVOFdzBG528UjZwkZ9h85NK5Hg1/qWXkCHsRFKpBJSwTIys+qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tb0YZJoRjRZ4chXv/UIkZFOdm7DfOGAJ+iEbkOrjTUg=;
 b=GlrUQQOufrg8xOBSPneJ81eXo5p/PZojIsJbZNHEyTV6ftwqmuYd3Sc6waa1D8EnZWFkHeoBq7H0cIF4oPSkLlROJMcHRu1dBDXHUjnrGC6wbZr63H6OLUUREGxRN8irzvDZjmxXW6sAXbt6FB+Ar0t0G70+raUpjTovfOiTLm2Tz6dV+kwzJDBzl/+8wQCXrFbT1MpP2nIXudJ0d2i7L8eQQO/A6LeMdtk7R9I9Kp6wOGOCR7UtiN7aTnKOidBGfT/33lF97rqCmCacbdBAfku/bEM5wxvuMvNZfBjKkJnSMWSFRDJcJUrssf7xx4JItAL99xW91FcDE/BiQPWYxg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH7PR12MB6467.namprd12.prod.outlook.com (2603:10b6:510:1f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 07:14:30 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 07:14:30 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>, Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Israel Rukshin <israelr@nvidia.com>,
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
        Yishai Hadas <yishaih@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Thread-Topic: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Thread-Index: AQHZKauXj4Rw0vQLQUCXQK7qRIhrWq6jvjEAgAAHeoA=
Date:   Wed, 18 Jan 2023 07:14:30 +0000
Message-ID: <95692a47-09e7-0055-2006-46d085b2eadb@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <Y8eWEPZahIFAfnoI@sol.localdomain>
In-Reply-To: <Y8eWEPZahIFAfnoI@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH7PR12MB6467:EE_
x-ms-office365-filtering-correlation-id: 0d797432-849e-4401-95f2-08daf923a443
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZZE66AAyJh29WHkBldHfAvgLXVi1Mbz+Z+T3Wn4OLkNs2ZS3hIEEgfia8fNTea+WNijPdpQFOIDcbu2ErhjY6Zc2rU0acOHMW36Pys4xYvLohc67aI+poBWG0BRd71sEy54+hW+Op8Wfv4z1DxhQtt1d18U8N+EJjJm91WTluSiHLmFkt6+Q0I/8LllNsH46jnJENAcYSBPGtKL0IVLufA5VnG7GCOMndIjSWWxWmnTlXiJwKCMo85EIijF7s6Z6cVd0SFkv+TEJO+MInmfnfc5etqLcVbC4X9w49IrFD96/TCD/ODeAwW/zUUiwSwzYxzL19ExQTVGIgs1jxnWXYseu6iRjuoNiM9FV3PlMA4J04cJrzvWdFmECSLkuf4vZcfrtO0nG9LH2rA7YhgVIR94hRp3tp0HcoJO4cTuk3dXCJLsl/QHAr5qkK4IzL/IsLVIyUyLX2xEfuZWXOJqyKMUr2FkJa8FIeBv8yOGqNoqFwIF+LpfascJ853EE9H/N4ivnzMtOn/Jjd7ka6H3DN0MTmFg3SLri3vTb9Q5zgcM20Kkp0hJU3oT114ipp6rrcVV1C5G3I2iKQltZu28X+vgDN9hJ0jcP2pdzR4ectZrUMZgtlhCW4F/xXfp8rLWJON1F1MQE/+QMs+Kkd2gkf2dd7Q2tiCIc1yF1vvRHjgunWmoeByK5/acCZXT5mfhGifnLcS/Fk4a0EdeKw4FhevXXACV72GOqhezSRGfYvpr+QIOROkWfrV95OfJrsvJH39OgE/hO7yo+Qflg7NoJmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199015)(31686004)(36756003)(2906002)(38070700005)(86362001)(6916009)(66946007)(8676002)(66556008)(76116006)(31696002)(66446008)(4326008)(64756008)(66476007)(8936002)(5660300002)(7416002)(83380400001)(38100700002)(122000001)(316002)(71200400001)(478600001)(54906003)(41300700001)(91956017)(2616005)(6512007)(6506007)(186003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eU42eUZxNWt0bjVSVGNCNXdlRXlQM2l0eStmb21IMlEwSFRueTA2THRxMnFr?=
 =?utf-8?B?cndnQXRsZ08wTDB0bndWMU9NT2FCSlBVdXRaOU1mQVJ4TE1rNHRqMm9SL29E?=
 =?utf-8?B?VHc1eEJoMnEzYzhObGlkTkVKZlZwNXBZdWNzbytvQmd5Z2lhUEVyNGMvNjRl?=
 =?utf-8?B?VDR4NkFWVlNMMzh1bk5TNFJiUVNJVDMyblVPckc2bFZ6U1crdEQ5cS9uZ3g4?=
 =?utf-8?B?M3dLOTBsZkswWUhxUFlBdm16K1FjdlFDSDlLTUFCU0FrZm9ZSG40UVlhdENo?=
 =?utf-8?B?Z0NRQlZ3d0pTTk5MTWFkWHo4UW05WkQ1L3hoREk4ckZkdXZXR2xpdkZUVzlQ?=
 =?utf-8?B?ZDR4UzVVcndNa0RtRi9wNjdleHJqUWtiNU5aYmtxa3JxS29sTllvTldrbTFj?=
 =?utf-8?B?OHJCYzFEYkZwWnZiVi9SaWFQSEY4TEZoZzVxTWcyNUNrYjNOZEZrdlliY25D?=
 =?utf-8?B?L1NuNGxkbFo0TElNQmRSay9KZkwyT211TWhFRFBCcjBHNzYreGNSamlQdFEw?=
 =?utf-8?B?VGVaeGFEMFhuTGlPS3M5QVRMSHBsTnBrZTI3T2pDSHBMcTBVdDVNZXVHK3Yv?=
 =?utf-8?B?aW9QUkdxbVNoOGwrNDdNMFVSRWg1eWp6YUpIbU90OEZ3UnVxWmhhdHZGdUxR?=
 =?utf-8?B?b1dhSmVUNC9IL0tpMG1DMXpVR2pjMFl0YU9rMVJJV24wR0cvUnc3U240MWdK?=
 =?utf-8?B?YWN2QVVFakxQT0J3MG1UR2VzRmVmUUNiQ2VTdGlqeTFTQys2cDZmUVJRUUhR?=
 =?utf-8?B?UzFQQlEzaEZMSytQYzdCUGNFZHJUUFBYQld5SEdGY0ljbGhIcGVVdkk1QjJS?=
 =?utf-8?B?clU5ZzVPV0tCcis3aDNNdnNwZHBtMjFsRGFnalBaNWRsVVJ1WUp6cHRmRy9R?=
 =?utf-8?B?VCtxRFVJN2dyeVRRdkJxMVdSU2NjY2kvOW8wRTdtY05VM3NMNHRJQjFqcm9V?=
 =?utf-8?B?eGt0QmNVOUh2aW15ZVd1Wi9oZExOUFYvUWNvbHh3dkRFVzQ5RXUwbklrN0Jk?=
 =?utf-8?B?RDJHWTlCVDY3UElMemtvWjZWY0ZIcm1lK1g4aVpPVXZhcGErc3AzS0FjK2hQ?=
 =?utf-8?B?d3NjSTA3VDY2Smp6QjR4WHdaNlhCRzdGejhqY1NTeXNMdkRhMjVLM25JN3lm?=
 =?utf-8?B?RnVtbVMvSHhRdVBPTTcveFloTmtaVEtYUlB3bWpxSXBZTXp4WmpSSmx1RWZD?=
 =?utf-8?B?Sy90V1hySjdFSmVabi9oNlJlTGpJMFg2SElhbDJOWW4weEJPam1MRFBlZTY5?=
 =?utf-8?B?N0UxV2xPTytQdElLeGJqUjdUOVRHYzk2TXFTdk53M1JXWVBhKzYyb2RoRmE3?=
 =?utf-8?B?UVZ2R0lJaTRtSFcvUnloVmRnK0JmTUZhLyt2WmlzY2Z6d3MyWmdZSGRaN0pp?=
 =?utf-8?B?N3dLdmszUnFmZW05cjdWZ0EwSVhIZnFKbXB3a3N6UTRzUmd6NnhUWlBFY1JB?=
 =?utf-8?B?OHQ1TWRpd2lLdlhFaGRoN3E4NWd6YllJYjNseHJCZGVjOGZzR3pwMUordkpM?=
 =?utf-8?B?ZFdVUVVUTnlyS3dzbFp0WGhCSjYrUGM2U2Z2ZEVkRy94M2xpZTlDZ0JaQVB2?=
 =?utf-8?B?UTNhYlRmVnc3cnMzOWJhWGo2bU5vWWlrWTQyOHZNOS9FeXBpYTRGNkFWMjdD?=
 =?utf-8?B?cUV4YmhLdGYza2Npbjl3cTNBb0JtZEcrdjdZSys2OVllckh0YlVnNkpCNjVu?=
 =?utf-8?B?Z3hiaXpDYS9mUFBLelp1Zmd4bk9aV2FTRk9MbjhlNWx1NlJhcjBrZElWdjk2?=
 =?utf-8?B?NkVwL3NyU0lyd3ZOcUJxQUE2WGdtY2h6L2d4SXdLYzNtWFZKaVNVak1jTXNL?=
 =?utf-8?B?V0krUUd3R1lsUDlSOGFLN3lJUTM2YVZ1aVlkWTF1ajZLblZodXdhWGVsNXl4?=
 =?utf-8?B?TjRqU0k2US9QbnUzU2Y2NnhsbVhraWxyVEVmc1VhSkFnYjY2eFh6RGZ0Vzdk?=
 =?utf-8?B?b2JjMlJ4RE1sak1EQzAxS2FvcnJIK1lhVVBhZ3NadGxCNjhuZTlZRXFRNGlU?=
 =?utf-8?B?MXhBbm1qR3BweXI2UThpeXpVdjNJdXBJWHlsbDFySFFhZVRjaThkU21BelBO?=
 =?utf-8?B?cFZIcC9VTnd6bk54Um1xUG8zZy9WcTVKNVg5WXBjalVpRlFMdVV4NG5lbFJz?=
 =?utf-8?B?L09TbUpvVGZsSmRIV0JXUFl6ZzNxdzh1Z2pmdkFlbGdIOC8wK05tams2OE9s?=
 =?utf-8?B?WHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6046736CA13C0545BDD453ED353654D0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d797432-849e-4401-95f2-08daf923a443
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 07:14:30.1098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U2rZaaM1zhdDN5PpLHtyuYogpO8GYD73qobTW/s8Fmym5BWWoDqTcSNZfYJk3XBU5tg5l/zEh+tIJ4zAtYsQVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6467
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RXJpYywNCg0KPj4gTm90ZXM6DQo+PiAgIC0gQXQgcGxhaW50ZXh0IG1vZGUgb25seSwgdGhlIHVz
ZXIgc2V0IGEgbWFzdGVyIGtleSBhbmQgdGhlIGZzY3J5cHQNCj4+ICAgICBkcml2ZXIgZGVyaXZl
ZCBmcm9tIGl0IHRoZSBERUsgYW5kIHRoZSBrZXkgaWRlbnRpZmllci4NCj4+ICAgLSAxNTJjNDFi
MmVhMzlmYTNkOTBlYTA2NDQ4NDU2ZTdmYiBpcyB0aGUgZGVyaXZlZCBrZXkgaWRlbnRpZmllcg0K
Pj4gICAtIE9ubHkgb24gdGhlIGZpcnN0IElPLCBudm1lLXJkbWEgZ2V0cyBhIGNhbGxiYWNrIHRv
IGxvYWQgdGhlIGRlcml2ZWQgREVLLg0KPj4NCj4+IFRoZXJlIGlzIG5vIHNwZWNpYWwgY29uZmln
dXJhdGlvbiB0byBzdXBwb3J0IGNyeXB0byBhdCBudm1lIG1vZHVsZXMuDQo+Pg0KPj4gVGhhbmtz
DQo+IA0KPiBWZXJ5IGludGVyZXN0aW5nIHdvcmshICBDYW4geW91IENjIG1lIG9uIGZ1dHVyZSB2
ZXJzaW9ucz8NCj4gDQo+IEknbSBnbGFkIHRvIHNlZSB0aGF0IHRoaXMgaGFyZHdhcmUgYWxsb3dz
IGFsbCAxNiBJViBieXRlcyB0byBiZSBzcGVjaWZpZWQuDQo+IA0KPiBEb2VzIGl0IGFsc28gaGFu
ZGxlIHByb2dyYW1taW5nIGFuZCBldmljdGluZyBrZXlzIGVmZmljaWVudGx5Pw0KPiANCj4gQWxz
bywganVzdCBjaGVja2luZzogaGF2ZSB5b3UgdGVzdGVkIHRoYXQgdGhlIGNpcGhlcnRleHQgdGhh
dCB0aGlzIGlubGluZQ0KPiBlbmNyeXB0aW9uIGhhcmR3YXJlIHByb2R1Y2VzIGlzIGNvcnJlY3Q/
ICBUaGF0J3MgYWx3YXlzIHN1cGVyIGltcG9ydGFudCB0byB0ZXN0Lg0KPiBUaGVyZSBhcmUgeGZz
dGVzdHMgdGhhdCB0ZXN0IGZvciBpdCwgZS5nLiBnZW5lcmljLzU4Mi4gIEFub3RoZXIgd2F5IHRv
IHRlc3QgaXQNCj4gaXMgdG8ganVzdCBtYW51YWxseSB0ZXN0IHdoZXRoZXIgZW5jcnlwdGVkIGZp
bGVzIHRoYXQgd2VyZSBjcmVhdGVkIHdoZW4gdGhlDQo+IGZpbGVzeXN0ZW0gd2FzIG1vdW50ZWQg
d2l0aCAnLW8gaW5saW5lY3J5cHQnIHNob3cgdGhlIHNhbWUgY29udGVudHMgd2hlbiB0aGUNCj4g
ZmlsZXN5c3RlbSBpcyAqbm90KiBtb3VudGVkIHdpdGggJy1vIGlubGluZWNyeXB0JyAob3Igdmlj
ZSB2ZXJzYSkuDQo+IA0KPiAtIEVyaWMNCj4gDQoNCkknbSB3b25kZXJpbmcgd2hpY2ggYXJlIHRo
ZSB4ZnN0ZXN0cyB0aGF0IG5lZWRzIHRvIHJ1biBpbiBvcmRlcg0KdG8gZXN0YWJsaXNoIHRoZSBj
b3JyZWN0bmVzcy9zdGFiaWxpdHkgYXBhcnQgZnJvbSBnZW5lcmljLzU4Mg0KdGhpcyB3b3JrID8N
Cg0KLWNrDQoNCg==
