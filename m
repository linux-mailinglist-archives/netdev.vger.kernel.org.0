Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0D6612B1D
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 16:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJ3PC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 11:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJ3PC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 11:02:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF8162EA
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 08:02:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDVjGVpHypkMdzBIMtue4EYwPYcjinJYLU9+Jbn7s2nZAdtv1v8PJVHb6DibOvN+0eZzsqeRuDmqyPZLUd7vVmB9jyyZciRlBF8oGN9UvJhw+XfDIJZSy2LeqSerP6VZNtd+h1Z7fbGoa5lx05eraxk6CuOTy6XsFTyc4nTtVmsKSa8FrCqCTvvgtj5TfyQggV3QgiU3MV7tkrnkdEqUeWVkGtLzMVd/E3r22sxvzcgY0jP0nP3xJhTR7VSb9KciF90U2xiGhpDtjD2Az9ezsDm9K55fHLoQHKUFKqXvKtGwy5OQNIVHNpYPWjvcIbN1mD8FF8lVanEMktCpFOLSaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M49pqEhyr9KfF/VSz8U3N1uCmSBqHDUgXC1xVykMQ70=;
 b=XGOCUTUWp+fGIe93pjxnataCn7MbIX9gmZE+aaggzkaX7D0SLYRUQkRy4JjYYAbcvm5Wni6hwlACOWZ04s4nYKmsebwkrWHldRYF5OTVaPdMvfD8oMCku2bLMI3EjiwHtgOBYAC7r5/DVEnrfsfm+c+df2yVyjNKqTx5zCAego4Ar3tLxmoOg+5JBcDgh23r0rH3wPZDb6tnIjg0roJP98AQIau+3x6BJ2pExLFsCGBoQumpIZ0a69NBWh0HAFyDU+jVKd/RFVJsYP7Ai3kG8/uk5ykz0ZyuhQhf4/dDyyFtxa7FetSPtuTJUNr7QwaijmAdRr5+UqExDTyNvKjHHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M49pqEhyr9KfF/VSz8U3N1uCmSBqHDUgXC1xVykMQ70=;
 b=re+Oda3D6y62uKpI2taaQDTm4J1b9iX8TxJmqlLnV++ujhxztgue/kDJFr/D7oBViuBi8t4KWnUQbbDx5xtItB8QbisYAAcshRGiP5md9plZpF8NzycrkP6UysGoyAAnvuQrtMlSkrHlo2Lj1MdNfBH2x0eAkwRgPWBM6Ys9ted1Od/PezsCjCjZvBNGSNtZu6r57/1BE7mOmr6Pjjes3XqJcF1G+PbwPrYIO1WBywDEqYJV9/1tResND9gqKO4tXAbZJNwCKNmB6gKCouqL3IIB76A4ANuVafVx1rp+Szqzdg5LTtrpVV/SZJg0fjT4Wk6LPr+Ad0Z+dyaXpw/SUQ==
Received: from DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24)
 by PH0PR12MB5452.namprd12.prod.outlook.com (2603:10b6:510:d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Sun, 30 Oct
 2022 15:02:21 +0000
Received: from DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::62:69e2:aa46:bd27]) by DM4PR12MB5357.namprd12.prod.outlook.com
 ([fe80::62:69e2:aa46:bd27%6]) with mapi id 15.20.5769.019; Sun, 30 Oct 2022
 15:02:20 +0000
From:   Raed Salem <raeds@nvidia.com>
To:     Raed Salem <raeds@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: RE: [PATCH net v2 1/5] Revert "net: macsec: report real_dev features
 when HW offloading is enabled"
Thread-Topic: [PATCH net v2 1/5] Revert "net: macsec: report real_dev features
 when HW offloading is enabled"
Thread-Index: AQHY6YXtLFHhb+jWK0G17LhWcxI2yq4mm9GAgAA8bKCAADHCkA==
Date:   Sun, 30 Oct 2022 15:02:20 +0000
Message-ID: <DM4PR12MB535741462D5FC1D5F4014896C9349@DM4PR12MB5357.namprd12.prod.outlook.com>
References: <cover.1666793468.git.sd@queasysnail.net>
 <38fa0a328351ba9283ecda2ba126d1147379416c.1666793468.git.sd@queasysnail.net>
 <Y14yD7i53usq1ge8@unreal>
 <DM4PR12MB53577F725385E1E025E46545C9349@DM4PR12MB5357.namprd12.prod.outlook.com>
In-Reply-To: <DM4PR12MB53577F725385E1E025E46545C9349@DM4PR12MB5357.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR12MB5357:EE_|PH0PR12MB5452:EE_
x-ms-office365-filtering-correlation-id: 5a61cfc7-fe61-449c-d1ba-08daba87beaf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R8mzDi8mwLus+Lw+dxMyfm8cscxmutEEX2V03H8+Jy9xp1Vr4isJhd+9+FWQNBjGQ8X/kD/xWPk13pWAm00Jodz9XOhxaW5nwDmnHgYULc3tX/9VKPwl5zWqFsZZ9jssn8ArLibiRtcxsDH9ca4H4j/0PbSUpPRDRuQBKghFmQO6J/Wy2HtZffxsQgBOY/GhkI/nSB7S8ke9Ix2z+3XFxzpJGdkQGP0ymWgCN+UsOGJPerjLfC+J42JBlXeiyix77y+3JeuMPxhD+qfNBpEq4gY0K5Egfb/eicr5AobZbPd921WWCKbGQOWOpGgC9xN/AHsN+wCmYfIOLW0k8/Lr/q9T9Jpb4bjjxflDJv2ohk7sNIHT16oDd50qgPsG5/9RMuy0fImCR+r4VUSjqtWZRzgba/U0mJ9TIGIgIfeY8wkGBItQGcgakEOV+BcISdt+jmZx4qZ2t2xuI6DT4jwA0JNVUIlqZT/MUZFvXUiWTf/c5aT0iER8uCitcoJKGYybufMeLgUNEgmOeE+PVUbC9bCbybmsyhYBhwrAEio6ht4rqD5+yejaM721x08wvp5Iw6wJ0pjjAT8z/nBfl2nzo8XL0EhmNdK/3Eppg+btXLA4XmGePygvWrHwDYtZDBt8YKKLXb+/wsAtoqQKgMb2g9tmClUoQt929yq0SzCnOQj69V6bUbpxZUh8kTEygQhKl53AlwQs8ONeM7/0NWKjUCn/1sf2pxUPakZww27bdSbJz22IQ+rRDnH2ffXmEI8w6jnDYmgT1nCY9ARPnQ88kw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5357.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199015)(38070700005)(86362001)(122000001)(38100700002)(55016003)(33656002)(71200400001)(2906002)(478600001)(316002)(4326008)(8676002)(64756008)(66446008)(66556008)(66946007)(8936002)(76116006)(5660300002)(110136005)(66476007)(52536014)(6506007)(41300700001)(54906003)(7696005)(2940100002)(186003)(9686003)(26005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2ZXWnN5ZUZBZmlrd0l4L3RQcDNEUWZCNnRiU0ZiRnVzMk5vc1owcWdic3hL?=
 =?utf-8?B?QVZ3eTRRYlNrQmdIQ2RxUjBFa21DUUN1eDQvWll2VlhMV040N2E3aWVEUi9V?=
 =?utf-8?B?R1VEd2s2dGhpaDk2T3dwNjI1cHNUNkdpRWlzK1o0ajFwSmxIU3I5WVdFQ0JW?=
 =?utf-8?B?SXJXVDl4K0NXUUE1dUl0UVI0MGRSZWhBY0pDTnM0N3VZTm0vSE0rREMzMkxq?=
 =?utf-8?B?TmhLNFo3Tk1CSHA4VGY4TldjM0lYL0llQlNCVVVhSllnTlNCTFovUU8xZWhC?=
 =?utf-8?B?UmdBdUxPT05SQXNFUE9DampLb29uZzYzT1g2TVVlc0ZoZjhRY1I0bGpLZ2sr?=
 =?utf-8?B?NHdrVHVsL2hGenJIZFV6aEl2TWVLRFMwVGdNczVYVHpacDVaZ1V6TFlFMGVM?=
 =?utf-8?B?U0p6QjB6QmNKR2U4a0ZFdmc5dnNQUmMxeU4wZWd5RlJpc09pSFgxald6VHhT?=
 =?utf-8?B?TmZndWN5MW9iSHFzd0xJZm5mVzdHRnAyYUlKbWpLN1hNK3dLV25NeFJjaUdl?=
 =?utf-8?B?RWc4THRJS3hJb01jLzBmUzBjQ3VGTk83YU1QNXZLOHRIWVMraU82d2ZxaDlO?=
 =?utf-8?B?ZmgvR3NGRG84Z002TWtjMzJNclJHMkR1WS96c0g2REx2dkdiSjk3VnhnWDha?=
 =?utf-8?B?WThZT0E2STNjVGFVbjY3TkNkbTVaRE1PTlFnSHNvZmZON0VNWEpmdWhxVmp5?=
 =?utf-8?B?cjR2OGZXZ3FpbGdkaTBzQlRrR0c1ZU5NS1hVVmdXODhSdVR1eTZ3dm0zeUF0?=
 =?utf-8?B?c0R6NnlHMGlqbExDbkJzS3FwSlBmUlQ1eTNIais2MW5pNGJkOVNJclZRMnk0?=
 =?utf-8?B?YkgzTHNWdlc0TExCeStIUHJYRXlEUG1BbWwzZ3g0REhBdGR0VzF2VHZuR1dr?=
 =?utf-8?B?STVkYkVsclIvYWJIb2dpMEZmRWFOZFV4NlRMaTVLRW9FMDNLaFpMSGd6SVda?=
 =?utf-8?B?c0hwTEUzWnJjaU41c296b0FkQmR3azFMOWRqRTltczVtS0xxYW1ldy91VU9D?=
 =?utf-8?B?dE1CbktrRlphK09WemJ6ajdSZ24xYjNvSnZkWVo1OTVJMXB1WTBiTEw1Slht?=
 =?utf-8?B?UkNuQ3Mzdk5GRStONUUwa0RadVJNeWJTUEhFZEw1L2ZwT3RPbU00WWZ3aHR4?=
 =?utf-8?B?VGg5R1ROM1B4T05qMStUQlY5eFRXMW5SWC9MWVQrUmpNTU5acy9aSjc5cTIx?=
 =?utf-8?B?d3NrcUdjQjFRRUVwODgreDFNbzBtandpd0d1TExleGZOMjFEYU91ZFNrZ243?=
 =?utf-8?B?VThtUVpwL0hTWGQvczFKaG9xaDJGOHplMEo2amRsNm9GbVIwVnYrakV0dElw?=
 =?utf-8?B?SjVPbzRXT3BVTE5IWE5RSmhReUE1TXpyUW9Ed09ZYU1BeUlQZzRqWVgwNDFC?=
 =?utf-8?B?ZTJNcTUwRm9XQW9WcC8vT0pLdDRucWFHdEZ1WkJYNWpaYXhhczVzNENzRVRr?=
 =?utf-8?B?UEhBc2ZsdjMwV1MzWUlLZU1hR2J2YnJIT3VJZlpaWFRsNlBhOWhlNVZLMlNn?=
 =?utf-8?B?cjlTVUxWRC9GdERKK1hYZEprKzRtc0RaQUVldCttM2lkWGdOS3NrM1pFVldy?=
 =?utf-8?B?cm1mc29YS3hILzBsdW1ld3lTRmtFbk94OGpPMlNvOEtuUndJbng3L2Vsam1S?=
 =?utf-8?B?VlZiaHhKSjI1ckEwT3YzUXNuREZubnZpbzduTWhnVmgxT0ErdHYxNlkzYmQw?=
 =?utf-8?B?UU5mRUtjYmpLL2krb2pnbW9QTjdSQ1Nvck81cjlKTU5nTlhRcjh2L0VkVGwv?=
 =?utf-8?B?SDJabTFaUm1VRi9JYmZPcGg4NGsrSnExc3pMWFNqbHA0YzAwaExMQmxIdVJa?=
 =?utf-8?B?ODFGVzJwNXNUUXhhcWd4RURCaDlpdmZZTHBlelBiUE96b3RUbXduVThFWGVm?=
 =?utf-8?B?NFdEU0QvMFlPb2JyT2k2YVpMemdaVmJndExJcE5lZE5MVVlwNzdUQXQzNExx?=
 =?utf-8?B?SndkQ1drSUhTT1p6NTFHQ1pqdGtVL2x2dmlic1owa3JjZWxKTkkxeitBWHor?=
 =?utf-8?B?K09BVlFLajI1S2UzZE4rbmhHYVlJSlVxV3g5RHdCUk9jOXo1eUpBeGc1SE5M?=
 =?utf-8?B?OExZTk9HamNYcFkveVdIM05GLzM2OFlrdWozSy9Ya0RaQ21MWWlRZVZPemZH?=
 =?utf-8?Q?ZedI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5357.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a61cfc7-fe61-449c-d1ba-08daba87beaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2022 15:02:20.8252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fiwhGDFyfFJpSKJY6XaC6z30iT5ZmxjZVPpjutKVyvOmFtocFK1IKGwbR+go8Ws/xsWYRSPGl58r/ZeInq38PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5452
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pj5PbiBXZWQsIE9jdCAyNiwgMjAyMiBhdCAxMTo1NjoyM1BNICswMjAwLCBTYWJyaW5hIER1YnJv
Y2Egd3JvdGU6DQo+Pj4gVGhpcyByZXZlcnRzIGNvbW1pdCBjODUwMjQwYjZjNDEzMjU3NGEwMGYy
ZGE0MzkyNzdhYjk0MjY1YjY2Lg0KPj4+DQo+Pj4gVGhhdCBjb21taXQgdHJpZWQgdG8gaW1wcm92
ZSB0aGUgcGVyZm9ybWFuY2Ugb2YgbWFjc2VjIG9mZmxvYWQgYnkNCj4+PiB0YWtpbmcgYWR2YW50
YWdlIG9mIHNvbWUgb2YgdGhlIE5JQydzIGZlYXR1cmVzLCBidXQgaW4gZG9pbmcgc28sDQo+Pj4g
YnJva2UgbWFjc2VjIG9mZmxvYWQgd2hlbiB0aGUgbG93ZXIgZGV2aWNlIHN1cHBvcnRzIGJvdGgg
bWFjc2VjIGFuZA0KPj4+IGlwc2VjIG9mZmxvYWQsIGFzIHRoZSBpcHNlYyBvZmZsb2FkIGZlYXR1
cmUgZmxhZ3MgKG1haW5seQ0KPj4+IE5FVElGX0ZfSFdfRVNQKSB3ZXJlIGNvcGllZCBmcm9tIHRo
ZSByZWFsIGRldmljZS4gU2luY2UgdGhlIG1hY3NlYw0KPj4+IGRldmljZSBkb2Vzbid0IHByb3Zp
ZGUgeGRvXyogb3BzLCB0aGUgWEZSTSBjb3JlIHJlamVjdHMgdGhlDQo+Pj4gcmVnaXN0cmF0aW9u
IG9mIHRoZSBuZXcgbWFjc2VjIGRldmljZSBpbiB4ZnJtX2FwaV9jaGVjay4NCj4+Pg0KPj4+IEV4
YW1wbGUgcGVyZiB0cmFjZSB3aGVuIHJ1bm5pbmcNCj4+PiAgIGlwIGxpbmsgYWRkIGxpbmsgZW5p
MW5wMSB0eXBlIG1hY3NlYyBwb3J0IDQgb2ZmbG9hZCBtYWMNCj4+Pg0KPj4+ICAgICBpcCAgIDcz
NyBbMDAzXSAgIDc5NS40Nzc2NzY6IHByb2JlOnhmcm1fZGV2X2V2ZW50X19SRUdJU1RFUg0KPj5u
YW1lPSJtYWNzZWMwIiBmZWF0dXJlcz0weDFjMDAwMDgwMDE0ODY5DQo+Pj4gICAgICAgICAgICAg
ICB4ZnJtX2Rldl9ldmVudCsweDNhDQo+Pj4gICAgICAgICAgICAgICBub3RpZmllcl9jYWxsX2No
YWluKzB4NDcNCj4+PiAgICAgICAgICAgICAgIHJlZ2lzdGVyX25ldGRldmljZSsweDg0Ng0KPj4+
ICAgICAgICAgICAgICAgbWFjc2VjX25ld2xpbmsrMHgyNWENCj4+Pg0KPj4+ICAgICBpcCAgIDcz
NyBbMDAzXSAgIDc5NS40Nzc2ODc6ICAgcHJvYmU6eGZybV9kZXZfZXZlbnRfX3JldHVybg0KPnJl
dD0weDgwMDINCj4+KE5PVElGWV9CQUQpDQo+Pj4gICAgICAgICAgICAgIG5vdGlmaWVyX2NhbGxf
Y2hhaW4rMHg0Nw0KPj4+ICAgICAgICAgICAgICByZWdpc3Rlcl9uZXRkZXZpY2UrMHg4NDYNCj4+
PiAgICAgICAgICAgICAgbWFjc2VjX25ld2xpbmsrMHgyNWENCj4+Pg0KPj4+IGRldi0+ZmVhdHVy
ZXMgaW5jbHVkZXMgTkVUSUZfRl9IV19FU1AgKDB4MDQwMDAwMDAwMDAwMDApLCBzbw0KPj4+IHhm
cm1fYXBpX2NoZWNrIHJldHVybnMgTk9USUZZX0JBRCBiZWNhdXNlIHdlIGRvbid0IGhhdmUNCj4+
PiBkZXYtPnhmcm1kZXZfb3BzIG9uIHRoZSBtYWNzZWMgZGV2aWNlLg0KPj4+DQo+Pj4gV2UgY291
bGQgcHJvYmFibHkgcHJvcGFnYXRlIEdTTyBhbmQgYSBmZXcgb3RoZXIgZmVhdHVyZXMgZnJvbSB0
aGUNCj4+PiBsb3dlciBkZXZpY2UsIHNpbWlsYXIgdG8gbWFjdmxhbi4gVGhpcyB3aWxsIGJlIGRv
bmUgaW4gYSBmdXR1cmUgcGF0Y2guDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBTYWJyaW5hIER1
YnJvY2EgPHNkQHF1ZWFzeXNuYWlsLm5ldD4NCj4+PiAtLS0NCj4+PiAgZHJpdmVycy9uZXQvbWFj
c2VjLmMgfCAyNyArKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+PiAgMSBmaWxlIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRpb25zKC0pDQo+Pj4NCj4+DQo+Pkl0IGlzIHN0
aWxsIG15c3RlcnkgZm9yIG1lIHdoeSBtbHg1IHdvcmtzLg0KPkkgdGhpbmsgaXQgd29ya3Mgd2hl
biB0aGUgb2ZmbG9hZCBlbmFibGVtZW50IG9uIHRoZSBtYWNzZWMgZGV2aWNlIGlzIGRvbmUNCj5h
ZnRlciB0aGUgbWFjc2VjIG5ldGRldiBjcmVhdGlvbiBzdGFnZSBpLmUuOg0KPklwIGxpbmsgYWRk
IGxpbmsgZW5pMW5wMSB0eXBlIG1hY3NlYyBwb3J0IDQgVGhlbiBpcCBtYWNzZWMgb2ZmbG9hZA0K
PiRNQUNTRUNfSUYgbWFjIEkgdGhpbmsgdGhpcyBwYXRoIHNraXBzIHhmcm0gY29yZSByZWplY3Rp
b24NCkZ1cnRoZXIgY2hlY2sgaXQgc2hvd3MgdGhhdCB4ZnJtX2FwaV9jaGVjayBmYWlscyBpbiBi
b3RoIGNvbmZpZ3VyYXRpb24gZmxhdm9ycywNCmluIGZpcnN0IG1ldGhvZCBiZWNhdXNlIG9mIHJl
Z2lzdGVyX25ldGRldmljZSBjYWxsIHRoZSBzZWNvbmQgbWV0aG9kIGJlY2F1c2Ugb2YNCm5ldGRl
dl91cGRhdGVfZmVhdHVyZXMgY2FsbCwgaG93ZXZlciwgdXNpbmcgdGhlIHNlY29uZCBtZXRob2Qg
KHRoYXQgIndvcmtzIikgbWFza3MNCnRoaXMgZXJyb3Igc28gdXNlciBzcGFjZSBpcyBub3QgYXdh
cmUgb2YgaXQsIGhlbmNlIHdoeSB0aGUgc2Vjb25kIG1ldGhvZCB3b3Jrcy4NCj4+DQo+PlRoYW5r
cywNCj4+UmV2aWV3ZWQtYnk6IExlb24gUm9tYW5vdnNreSA8bGVvbnJvQG52aWRpYS5jb20+DQo=
