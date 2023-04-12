Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FD36DF8B4
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbjDLOho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjDLOhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:37:38 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021016.outbound.protection.outlook.com [52.101.62.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152768698;
        Wed, 12 Apr 2023 07:37:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bd+34VTX9FH+hGKQkWs8DStzkZiZjUGqFeY7qWR2M/k+aF6gnHBoM+Ta3ZP3bZgSZzyvLF28SNmnr54jvgZP68gi4ROJjjnvIdP+BNdRkXG3ZTFb/xW89N7qD1fvVlHhtbj08NIQC6AHNumMFZTPiB6qGWoU9aNeAhbeTsXnmhW5/1KS5JLIMJRIXq0ekDGwCDIr2XE6Q5qFcqdxSqox3mgd9DcOAS5i+uw76G2jUdINac5SYBHzPMfhkUtV7Kht5MvsnXqwduzgmLu6Uo8TH1VQB09W3F/GaN/s0Hh8F0+NFFsbnZl7NL7u5YO497HeowdQsv5R/euUhIvI5xEVvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcTofPYs37C+OEAU9VG0SyhF2Wawsvy/Z8V9gQFmA1s=;
 b=E9hz6ghi3GJwCyEjtAjzoafpx2Aocvq0qleLHGThfHfZk+WDOxhGMqJ8qisCjUATYdwahps8e2dWoGTrPgGbo8GYFulSQGJ1+lG+K9QloUsrCL/H97h2UMnUqJv42jPZEiXWtrjk1bCSakh6d5L0S1SEefCpWdweL+JY/xXIU2WO0v9aM+0nBr+GOPkTUpRbAy+ufcGsU6sK/ENWzxuBcVLqF4gr14kfzNo59wLwuj3Wgq2TJI28IKEf5hdhyvbUEAIXR5rlv2Rels9/mfn/Q72T408tgGOu1ry+6RvaTaLo4gdnq5N87Tlny66/RAzeClkW31dD+lKT8h2XsbWwFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcTofPYs37C+OEAU9VG0SyhF2Wawsvy/Z8V9gQFmA1s=;
 b=TB9NKwYeskSZebiMe03atxpPSw65jyYj4JX1ffQdmGKRqCuqDw/H6xcXF7Euh9mJMm+pxyhdxXYHzaCeRKuYhq2IUxoZDn0f+R/Z3YAaPE78IUFfb4gBlmHRy9u2n09G+beDM67UwGWPU+do1LkQjoi9lWm813VTgmf27zkzvWU=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by MN0PR21MB3051.namprd21.prod.outlook.com (2603:10b6:208:373::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.4; Wed, 12 Apr
 2023 14:36:51 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787%7]) with mapi id 15.20.6319.004; Wed, 12 Apr 2023
 14:36:50 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2,net-next, 3/3] net: mana: Add support for jumbo frame
Thread-Topic: [PATCH V2,net-next, 3/3] net: mana: Add support for jumbo frame
Thread-Index: AQHZaZQnxROziUF5Y0WOz7nRutZXm68mwyKAgAEB0bA=
Date:   Wed, 12 Apr 2023 14:36:50 +0000
Message-ID: <PH7PR21MB31164D341A191550B4B20848CA9B9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
 <1680901196-20643-4-git-send-email-haiyangz@microsoft.com>
 <7287f315-0ac9-eef1-850f-8d8a91effe3d@intel.com>
In-Reply-To: <7287f315-0ac9-eef1-850f-8d8a91effe3d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6bbb35f7-ca6d-4002-951f-af7ca635aede;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-12T14:35:40Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|MN0PR21MB3051:EE_
x-ms-office365-filtering-correlation-id: 82f0ff0d-20e8-4c4b-4688-08db3b635a50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SrI1V0MtGu1AT+bXsJjCfmtWKJbnzSOfefoKr5PMVdIbpFqlVnoeOciL28QTALBZAyVUrdZ1sE5Unnus1E5ejZLDrPqn1jUuU7KB+j1MTmLM8Frmap+4JdS6oWxhUHyfcmsuJtWkA6hb7zHRscErrpUugP6/CTeQHfvKVgq3MMYSuuiipjfyncOLoosognynw2mSS9aZmfAbVWQLdEPVBB+rfMKNqzepLE/cA9gnw2TqxOKvUTCV2rt278+STQv9P5y4XJymOQ0/30cv09NWS5sBVjFGWLJscyyZ9h1D0W+ti3+WBwiLxyYldF/l0RzqFR4Ifc6dUBOOdcB6rFLzYoK7zUWHqIuubb/hIZGWKsSLjM+uUlEGNEZRNpcyYqq+LSaCZDbxLSGB0ZuinfykpNYd4UHv7DND90LIk0JbvY/v+HosRhHfPuUVqDnKY+2pcyybHRT9JlAjqRUeCa07zG5Y9K2uWuDguU+6CGclCGcNPZuFN8n75Mu2HB8+pAP+2cX3I56/Ot1kpOLLi3accKRnry5Pa0uRsLLJ93RB/MEcnrWCV3Fw06+b3Zun9TObRqz58Ct5NSGVJ/AlTxkobi9C36v/MJermoI9gJK+PxNuCznP7elsaCeb8lmTNiPfMVhsbPRTH8bJi92PpZ64HNYPcn2weRtlt8WpMsBwD28=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199021)(5660300002)(54906003)(7416002)(10290500003)(478600001)(71200400001)(7696005)(786003)(8936002)(52536014)(316002)(41300700001)(26005)(110136005)(53546011)(66946007)(66446008)(4326008)(64756008)(66556008)(66476007)(8676002)(76116006)(6506007)(9686003)(2906002)(186003)(83380400001)(8990500004)(122000001)(82960400001)(82950400001)(55016003)(33656002)(86362001)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEtUenUyTXpveCt2ZW9PTGUrMzZteXJiVmkzTVE1U3U0TlBPNWZnYXFQd3do?=
 =?utf-8?B?dGxQMkd4OFVIdEo1eTZpajR0NTIzamRnMEJ0eCttZUZIUEJrUGk3K1ZKZzZZ?=
 =?utf-8?B?ODFEK1kwelNHcmZENGY5a0F2L05JU1pxMmV5VGxxUUJ4RTYyRE80Q0VyRzQz?=
 =?utf-8?B?aEFlK3J3WnhZL2EwVWtlcU4vZ3lHd29YUDZnMUlHZnh2eXFKeVVyVXVzMDZy?=
 =?utf-8?B?VW5FR3RuUzJQeFlIT1FXbVZweTYwQWNCNTQ4VzFkZEZVSzVtQWNwWStMV3Rj?=
 =?utf-8?B?T0NCOXYrQUdKcm85eElrbm9RcHFVV1FaYW5WdEI3eXNXU1RYYXpCUGJySkpv?=
 =?utf-8?B?VGtObS9iajV6MVB2NjUyWlJRdUFRZllnS1V0TFl5aEw3b09oaU1UbUxKQmVG?=
 =?utf-8?B?YldNQm5VWVNETnBsbndYSm9VYmkyQjdhbEFHNVN6eE5pOGpJdDZyVmF3Q0tG?=
 =?utf-8?B?QVpqUUdIYTF1aHAxRzMxZitMcnFDdkx5OFp0MTRpY043K0ZXZHBaL0lHL3h3?=
 =?utf-8?B?bHZqUk1TbjByR2JSMnppdmdOc24vTS9kZDJRbmc0RU5CVEw3aTBzUERPaEVH?=
 =?utf-8?B?Yys4NHlXRGdNVGRNMWpTODNuSDdibUlFdXFYYlFoTVRrZDBZQjd3aUZKM3Iy?=
 =?utf-8?B?R1RJWDJVV0hnS1AzV2luYnZOUGlwZ0pCWVdjc1ArbXlQUldoeGxocWYwYXow?=
 =?utf-8?B?aFFldUM0cVBDRnU2TCt0UUJZOTVPcW9jeVZvdXdKNE1CTnJSYVhGWVdubjZa?=
 =?utf-8?B?T0pyYlZLeTZsaEI5eXJFOExISFVBQU1YUmlzTW9vWWZYUGJBZVpKWWN3NEVX?=
 =?utf-8?B?SU5HUWE3K2JYWnp6N2JVMU9QVVArRzdabTZqVVc5OVl5VHhENXNQTHIyaDZw?=
 =?utf-8?B?WU1xNk90ZTN1Ly9YQktoWmNHMHlSc050Vy9WdjJ2WmpxVTRVMWVTTTZ5WGJs?=
 =?utf-8?B?RTRDVlR4V1d0aThraS9XQ0tqdi9qYUxnVE41RUhRamx0NUhuNzk3OENiamJz?=
 =?utf-8?B?RFEvcVdTYms3VjhNVkJodWdWOU5paFF3T1VtZDFKU1RqVzRwcDNEeDBUWGVU?=
 =?utf-8?B?ajFhSzNyTEIyN0U4Zm9YNzRnbkkwaHJWcm1JV1ZrRDNycHEwY1JyaTVFWC9L?=
 =?utf-8?B?Mkg1YlFxUXI4V0R3N0lTNU9RY3EzeVNGclZWZmtXNU5TOHcweU04aDYxWlBr?=
 =?utf-8?B?OGp5Wi9ydkpjcHN5c0tOL0dnRUp2cTBLKzRTNFpPMmhIYkYwUnZKZWJ0NWVW?=
 =?utf-8?B?bTRyZWY4Q1FuQjRaRDgyUDNiV0IzcEdmWkZjTm92QmdwMXA4VTNVaExPbkRV?=
 =?utf-8?B?djhDaUpKQUlaSktJUG51MjhId1NEWjB5UTJjZEsydXMyWGc3MjdIMDZnUElH?=
 =?utf-8?B?blNwUEFUckdNM3dDV3ZDc2lVNFZ5MjRUdGZaT05jdnU3L1dQcVlqdUdXVzM0?=
 =?utf-8?B?dWxIUC9sZ2Fwa05rSTJUN202Q21yV1F1T0x6YjdSZVRZNGFES2J5TnpBTGtr?=
 =?utf-8?B?NnlrYmVLQS9ITzJuSXFBRmIvNUdOVThYTVpWUklCc3VZV21vVy8xVjJ6VWJ1?=
 =?utf-8?B?TlhwT0VIOTNCRlJEWDNySkdiYXVya2tYVy8vazBXRUdRSTA5ZU43NGU2TS8v?=
 =?utf-8?B?WU43ellXWTBJT2xVM2duQ1U0b3lSVjhSaU92MjZKK25Kbm1xTmI3dEtsSmYy?=
 =?utf-8?B?d0dKR3R4Y3RuY3MyY294eFpMdW80M01SdkRtREdla3pVU1gxRnQxZDVBdHo4?=
 =?utf-8?B?UTZjUjczOVpNaWMrbkswd3hyWklheE5MbmJPUEpyKzNacXBHSytIUlF1WGhs?=
 =?utf-8?B?UmxZTXpOZ29zODNKWmRzd2tNRmxWNzdmVWJ4ejBjM2N5S1l5VWdiWkJBY3Fr?=
 =?utf-8?B?cnNCM0swMzFNRWNhOVRBenZoSW1kNXRsaStlMGQ0VFpGWWN2a2M1WE1jdW5C?=
 =?utf-8?B?akhvMXdUYS9NNDAzM08vWWsxOG9zWk1VQm1mSnBKREdSaFdiWHBPVDZ6TVU1?=
 =?utf-8?B?cVBJakdSOGFiR1ZWOTgxdDZTVEZxRDRoSjFZUHMwM2pUTHFPT3dXVkxDT0ox?=
 =?utf-8?B?OTY2VEN6YlorMHljN0tTdyt1UWZIbFZoNU12MUVBY2RVNEh6SEQ5QU5iSVJk?=
 =?utf-8?Q?0jT/vEzNVBDiWwpkiZ2h/KN4a?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f0ff0d-20e8-4c4b-4688-08db3b635a50
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 14:36:50.5464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8y/AqyGegLi/oZa2i8RJt6daXA3fgs/Wx4hw83nI9i33Nrh4bAC4O5mCC+XjJG7qIZ4nifPqMNRCdEA/prbH+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3051
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFjb2IgS2VsbGVyIDxq
YWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEFwcmlsIDExLCAyMDIz
IDc6MTMgUE0NCj4gVG86IEhhaXlhbmcgWmhhbmcgPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBs
aW51eC1oeXBlcnZAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+
IENjOiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPjsgS1kgU3Jpbml2YXNhbiA8a3lz
QG1pY3Jvc29mdC5jb20+Ow0KPiBQYXVsIFJvc3N3dXJtIDxwYXVscm9zQG1pY3Jvc29mdC5jb20+
OyBvbGFmQGFlcGZsZS5kZTsNCj4gdmt1em5ldHNAcmVkaGF0LmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsgd2VpLmxpdUBrZXJuZWwub3JnOw0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtl
cm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBsZW9uQGtlcm5lbC5vcmc7IExvbmcgTGkg
PGxvbmdsaUBtaWNyb3NvZnQuY29tPjsNCj4gc3NlbmdhckBsaW51eC5taWNyb3NvZnQuY29tOyBs
aW51eC1yZG1hQHZnZXIua2VybmVsLm9yZzsNCj4gZGFuaWVsQGlvZ2VhcmJveC5uZXQ7IGpvaG4u
ZmFzdGFiZW5kQGdtYWlsLmNvbTsgYnBmQHZnZXIua2VybmVsLm9yZzsNCj4gYXN0QGtlcm5lbC5v
cmc7IEFqYXkgU2hhcm1hIDxzaGFybWFhamF5QG1pY3Jvc29mdC5jb20+Ow0KPiBoYXdrQGtlcm5l
bC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRD
SCBWMixuZXQtbmV4dCwgMy8zXSBuZXQ6IG1hbmE6IEFkZCBzdXBwb3J0IGZvciBqdW1ibw0KPiBm
cmFtZQ0KPiANCj4gDQo+IA0KPiBPbiA0LzcvMjAyMyAxOjU5IFBNLCBIYWl5YW5nIFpoYW5nIHdy
b3RlOg0KPiA+IER1cmluZyBwcm9iZSwgZ2V0IHRoZSBoYXJkd2FyZS1hbGxvd2VkIG1heCBNVFUg
YnkgcXVlcnlpbmcgdGhlIGRldmljZQ0KPiA+IGNvbmZpZ3VyYXRpb24uIFVzZXJzIGNhbiBzZWxl
Y3QgTVRVIHVwIHRvIHRoZSBkZXZpY2UgbGltaXQuDQo+ID4gV2hlbiBYRFAgaXMgaW4gdXNlLCBs
aW1pdCBNVFUgc2V0dGluZ3Mgc28gdGhlIGJ1ZmZlciBzaXplIGlzIHdpdGhpbg0KPiA+IG9uZSBw
YWdlLg0KPiA+IEFsc28sIHRvIHByZXZlbnQgY2hhbmdpbmcgTVRVIGZhaWxzLCBhbmQgbGVhdmVz
IHRoZSBOSUMgaW4gYSBiYWQgc3RhdGUsDQo+ID4gcHJlLWFsbG9jYXRlIGFsbCBidWZmZXJzIGJl
Zm9yZSBzdGFydGluZyB0aGUgY2hhbmdlLiBTbyBpbiBsb3cgbWVtb3J5DQo+ID4gY29uZGl0aW9u
LCBpdCB3aWxsIHJldHVybiBlcnJvciwgd2l0aG91dCBhZmZlY3RpbmcgdGhlIE5JQy4NCj4gPg0K
PiANCj4gV2hhdCBoYXBwZW5zIGlmIFhEUCBnZXRzIGVuYWJsZWQgYWZ0ZXIgTVRVIGxhcmdlciB0
aGFuIFBBR0VfU0laRSBpcyBzZXQ/DQo+IFdpbGwgWERQIGZhaWwgdG8gZW5hYmxlIGluIHRoYXQg
Y2FzZT8NCg0KWWVzLCBYRFAgcHJvZ3JhbSB3aWxsIGZhaWwgdG8gZW5hYmxlIGlmIE1UVSBpcyB0
b28gbGFyZ2UuDQoNClRoYW5rcywNCi0gSGFpeWFuZw0KDQo=
