Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D4A663C36
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjAJJF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbjAJJFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:05:41 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0AF217
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:05:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jym3LrKSTF43YXrfsuBmd0ILuqnhmWEhnqov3sZAG2U7uGWD0BNCYEzmYkaXja0zeDCtPpOHQJxwotqtr7uhorLgjs68eslDsZt4oNu2OfmUGyebKalvex6ASoaGWpreL7JszWJbyvViVjmJiWca9yTu5oDgdZryRPQ/e3ulA4Dd8BN7/979P2kwAyXCjmr28P/k+nBUosjOgoBcquU2/XveE1x8jt4Q5/LXC3gRdbK1XJE+bcK3j+Ad736J45DZiYIEbDFjnj7/FPccRgj+8a6X1z7zG1ZthdShTAwwePzdul4ja7emgZvJVms9h0//ZcVWXKghUJL/mZadtpDI6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOPGN1MMc37bYdUB/QGXzPTF1HdSg/E0cF1BeTaKDyk=;
 b=c/+Bu+vjaz69FlP77oZW9yzs8jTVxrClqboCU2+7LatW6Rg9vRlibnb2mn6MUcpVA3buj4B2ql+/Mv/Jyrk7XhBzoyKykc98tQ1WZHDjcOTPJaOUJ7eM3qFg2uDjyNShfLJ7tHzwLAai3Zgw3XDiw+7ragoDgiYY70ShWj5iJk2YlCygdn9HknWySNLk1MLz+RC4Wy9N/Poz/io3VABOiGZO2Q6Lxy5dzvew/vuJodF3KY8mIQ/loPAFiXsJ9urMl0c5uh8HcIQU3N0dHUbvuCqWRVsJ0cCZ/NywRmnmuZcmsV4+gKPEhFFd4+xvHgQRMuNpF9w74GJMFbzwmSRgBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOPGN1MMc37bYdUB/QGXzPTF1HdSg/E0cF1BeTaKDyk=;
 b=RRq0GQIoHMX8OaglMLio1qZku3TZcNtU7Wg3Dpl064jwc6Ssl9HIfbOanYtdnYYtzTIXod5+w1t0n7wfXTRHd5uFFzThUjxgIG0sGYor/lNcjKF2k6iJ+KXHwcMKiWvn+1FCGQ6iZTep7A8lt3+L4CciSta2g4RQh3A9IAoJ5pE3q+loatkgAcp6F09M901Eiu/GzpRF7w/1FT77W1eeJX/kyz2/pYFbNk4L52wPcWQAPA5QQJca+52g4m2es/cWQ1tbqTJK4ND1maj6WDT1VSPJ0D8bGHr+A0mjbs//UqPkSZmenssX4O5M2LcgmcTQIHvsLw+fCnajQRHH1a4RQQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DM6PR12MB4467.namprd12.prod.outlook.com (2603:10b6:5:2a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 09:05:36 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 09:05:36 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Antoine Tenart <atenart@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH net-next v7 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Topic: [PATCH net-next v7 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Index: AQHZJAhJyueBLm2iTkmPls9erLR5/66WMhYAgAElHICAAAXEUA==
Date:   Tue, 10 Jan 2023 09:05:36 +0000
Message-ID: <IA1PR12MB6353C7C5FA91CAB18B267444ABFF9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230109085557.10633-1-ehakim@nvidia.com>
 <20230109085557.10633-2-ehakim@nvidia.com> <Y7wvWOZYL1t7duV/@hog>
 <167334021775.17820.2386827809582589477@kwain.local>
In-Reply-To: <167334021775.17820.2386827809582589477@kwain.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DM6PR12MB4467:EE_
x-ms-office365-filtering-correlation-id: 5131b12f-b6f4-43e8-19ac-08daf2e9d640
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dRrzDeLkJjl1eXqx2fCcWzeb9+LZa9gEd2hr2TMeY/2ueKxdDGP8A98fCo1uE/u+PQEUqLGFpx3JgtjIVNrOMW0lHcqE4VQR5iJr2Qqdn53lcHGiA402OvBY3CBKNcMbY0TYH8TOkVuEP6vexU8n9R3kWJtxYys6obpyJgft7aCxbCvzzyoXKMsvQT9tc5/67DSJ4XR9+D+gUypz3VmD25R+bUYTER7o6UM72vU7Pb2pAv5b9Fh75ETRisfsvXop4m0JzLrqjmNoTObLVA3zbb9eY/GT/KwkdvSdLGFGRj4naYYNpbgsBXKI8Mx6e/mThkwXeGOTy5qHEBlvAJKzp4NYHvbLFZeS8dyXjVp5rjx/SpGuj/i5xtrcCCQYLNzsy2wpcHQK2ShA/bsnQGzNbbvkXjvbA5BBLXCRqgBitsKSHmaIpGE1CLGU7bdoJN+DpdV0FBlBPDXuQ1QAtFW4hp5CEGoUkGZ6HVZwix5QOHHyf+5uB7k0m9LPepywtJakE5G4qMMzqTwwMaZKLsZAXL7srVL1pn04vbAFua4QvXNY9E32mVu+rGtIU1isVfrSiKgykS2KXAD40TDy9QcjZum5jUfN269dmdLYwR8MudKUFpkQ17byBon7q4QujQW1tAL+sfBsWGNbq1gNPBdjep67Afbad6WrzcFvfcWLPi58Ek+CWxT4aCOiXqbQOzR9hrGJgMoKzZo2zu6u2omm+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199015)(5660300002)(186003)(26005)(8936002)(9686003)(7696005)(38100700002)(8676002)(478600001)(52536014)(83380400001)(38070700005)(2906002)(54906003)(110136005)(64756008)(66476007)(55016003)(66556008)(316002)(66446008)(66946007)(71200400001)(76116006)(33656002)(4326008)(6506007)(41300700001)(86362001)(53546011)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmNIMUtjQzJTQlJWcnc3aUp6L2Q5WUl0R3ZiYVNJbWt0MWV4aFJpMTNsdnNl?=
 =?utf-8?B?cmdzQjE3UW1PaGZGOE1QOXBlS2x1KzMyUm04Mm55ejRjMjVmTWRjY0hpZGww?=
 =?utf-8?B?WHNSMDNVY1puZVNlRmROREp4N3hHaFdZWUw0NE1VTXFyTGRuUTdTUno0R3o5?=
 =?utf-8?B?WWFjeGZmSkZmK1c3QVByQTl4V3J4QVhRdGxZcjFKNjk4STVpUWZPbzNxd09I?=
 =?utf-8?B?NkhMZURVYS91OWlDNWFQYmVxL2R0Ky9FTmU5a1FoZ1hrMEQrZzhBQ3hlZk1H?=
 =?utf-8?B?Zm9mY3FNK2hTZ1JqbEpCQ1N6YnNWNnZrVnJ0VzJycE9SSXBGN0pGZnJUYUpm?=
 =?utf-8?B?eGFiby9GelNaL2hDUU9mTStOMTJybVJXK0N0OFpwM0lsTG0yUmUrRW1GVWhk?=
 =?utf-8?B?MVN6bFpsQ0NEL3NuS1Mrb3VNdXN3SWRXTWYya0wxQ01jblZNelRBc0Y4N2My?=
 =?utf-8?B?NC9VaXdlM0RpampCeFNXUTZYYkNFZkVTWlNUai9FajhxR3IxL1BWWGlSdElW?=
 =?utf-8?B?UmpyNEhQamNkUXE0VUNJV2RvRjEwK0hYemVlK3hYRkhzKy9PWXVSWEhsTUpL?=
 =?utf-8?B?UlNYeklDRy9ITUoyQ1RIRERrb2lTdDRDUDl0SXVDenRsOWx6cjdWQUtkckZh?=
 =?utf-8?B?dlA2eGV1Q0g2YllEUWliQTNCV1FYTW0rcUR6Q0pGT25ib0dDdUgvcUZmOER2?=
 =?utf-8?B?NmpObFdhTks0aDFhTmdtKzNqeXpsSWkyR291bmlodnlhUlF4MWNuQ2tqSmwz?=
 =?utf-8?B?S3JGUGFDSmxPNmpJYStSYlpDeWpZNEY0dnBVc1R1em1nTnlmUmhPdXRrcEty?=
 =?utf-8?B?aStRdWs1QnUxSHMzZzB1T2FyaEg0RGdRL21oYnBFOTZjTzFLQWFQeis3akhJ?=
 =?utf-8?B?N0FGVlFnaWgyS3hPM3llQjJOL3JJcHpLSXU3bTdXa3FyZUFxZlBDQlJiZ3R5?=
 =?utf-8?B?b0pKcHk1U29xN1p2Z3VlZFBBeDBhQlMrVHl6c2VHa0lwSmsrSEJqMC9lV2Vh?=
 =?utf-8?B?VHM5NFRQczRTVnUvNVVQbGRiMm14bHRGb0s1TW4veDZHanRkNEltQzl5ZVF5?=
 =?utf-8?B?Q0JKTEhzaDd3MnFkeXVPQkdaWDdsWHhacGI5TjFXMDE2UUhMaGVTU3NYL0x1?=
 =?utf-8?B?NkpIUmlHb2FGWEZCQXZzY2ZxTzdNd0s0ck0xSjRUSHlwVDRoZCs4VmVUcGJJ?=
 =?utf-8?B?ZnNQaGFGbk1qcEViL0F4K3BzdVJJQ2ZzYXc0aXdJYWtxdTVob0IrdlBtMkVX?=
 =?utf-8?B?ckwzaGMrSkJHZlh3VlA0RDhya1M1WVlZRFpWT1hrb2hCb0QxTnNFd2ZZSW1Y?=
 =?utf-8?B?WXNLcXJkdzBmbmM0MUorV0VxVmdCTVREM1BUMzAwYzMvVCtBd0VBRmY3dzNG?=
 =?utf-8?B?QnJUdHpHdXY3M2gvTlNoV2lxRG5lay9MWUNCNmI5MEp4czVmNGtCdUxuUG4x?=
 =?utf-8?B?ZWt5bnk2a05FS3NKNS81aVhoYk1EYmdnQ0dwODBISXVDMktJYmdtSHc2MHFQ?=
 =?utf-8?B?dVZyWDEramVIWXNEUXBkZGpzTlFLeVhRUWQ2VXh5WGsyd0I5ME5PR3hIRldV?=
 =?utf-8?B?OWFGWE14cXViVUkyMnlPU0J5NTFWcDhRYmwvbUV6dTRDNnE3dzhLSzgySldz?=
 =?utf-8?B?a2lOeW91UWlqazBiSFJkRlZEaU9jWFY2bzhLcmtkT3V5SGdBVWl6SjU1L092?=
 =?utf-8?B?VHR4ZThoREFlRVhFclJ6WVY2UUJMVW9jd3lDODRTbXBHZ3RNdzNNUnM2QXZI?=
 =?utf-8?B?MDZwL1JvanhwWnVOZitocHNwMk9DQnNTL09sYzZtZDdCREtrcFBFcDRta1U0?=
 =?utf-8?B?ai8zZitYNlh0Y3k4T3FqV2o1bVAxanF4eGptM0hrV0cwNTZMVXBYd09lcllF?=
 =?utf-8?B?b2JXRklITWM1RE5JZWdMeVI1bGpsdm5aZ2gybGVrWGc1RFB0SFJRTTRiM2Nz?=
 =?utf-8?B?WDJBdit4cmFYY1RTQThkMnNyWjBpVzBDbUh5MlFFR3FFWHpGR2dPNmJUYjNG?=
 =?utf-8?B?N000dCtJc2M3MEJGRjE1MSt4VlJxUHQwNzRmVXhod0FBTGlheHdXemhFYUI0?=
 =?utf-8?B?R2NWV1h3c1MvZXorSnZjMmtkMUhweHArN1p0QVBEQXBualhoS1VUNGJJUjNN?=
 =?utf-8?Q?ABTBjOCO1A+0ktd4YZ1GA+OA1?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5131b12f-b6f4-43e8-19ac-08daf2e9d640
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 09:05:36.2016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0a/xZWb5ibZTWgSdKEV5+8l50ztzwGIGqBl7yB2YrlaRigiZcKpxgBzUyt7fnzGakFGizEl2sHT18P95v1oiqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4467
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW50b2luZSBUZW5hcnQg
PGF0ZW5hcnRAa2VybmVsLm9yZz4NCj4gU2VudDogVHVlc2RheSwgMTAgSmFudWFyeSAyMDIzIDEw
OjQ0DQo+IFRvOiBTYWJyaW5hIER1YnJvY2EgPHNkQHF1ZWFzeXNuYWlsLm5ldD47IEVtZWVsIEhh
a2ltIDxlaGFraW1AbnZpZGlhLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFJh
ZWQgU2FsZW0gPHJhZWRzQG52aWRpYS5jb20+Ow0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVt
YXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVuaUByZWRoYXQuY29tDQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjcgMS8yXSBtYWNzZWM6IGFkZCBzdXBwb3J0
IGZvcg0KPiBJRkxBX01BQ1NFQ19PRkZMT0FEIGluIG1hY3NlY19jaGFuZ2VsaW5rDQo+IA0KPiBF
eHRlcm5hbCBlbWFpbDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0K
PiANCj4gDQo+IFF1b3RpbmcgU2FicmluYSBEdWJyb2NhICgyMDIzLTAxLTA5IDE2OjE0OjMyKQ0K
PiA+IDIwMjMtMDEtMDksIDEwOjU1OjU2ICswMjAwLCBlaGFraW1AbnZpZGlhLmNvbSB3cm90ZToN
Cj4gPiA+IEBAIC0zODQwLDYgKzM4MzUsMTIgQEAgc3RhdGljIGludCBtYWNzZWNfY2hhbmdlbGlu
ayhzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqZGV2LCBzdHJ1Y3QgbmxhdHRyICp0YltdLA0KPiA+ID4g
ICAgICAgaWYgKHJldCkNCj4gPiA+ICAgICAgICAgICAgICAgZ290byBjbGVhbnVwOw0KPiA+ID4N
Cj4gPiA+ICsgICAgIGlmIChkYXRhW0lGTEFfTUFDU0VDX09GRkxPQURdKSB7DQo+ID4gPiArICAg
ICAgICAgICAgIHJldCA9IG1hY3NlY191cGRhdGVfb2ZmbG9hZChkZXYsDQo+IG5sYV9nZXRfdTgo
ZGF0YVtJRkxBX01BQ1NFQ19PRkZMT0FEXSkpOw0KPiA+ID4gKyAgICAgICAgICAgICBpZiAocmV0
KQ0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIGdvdG8gY2xlYW51cDsNCj4gPiA+ICsgICAg
IH0NCj4gPiA+ICsNCj4gPiA+ICAgICAgIC8qIElmIGgvdyBvZmZsb2FkaW5nIGlzIGF2YWlsYWJs
ZSwgcHJvcGFnYXRlIHRvIHRoZSBkZXZpY2UgKi8NCj4gPiA+ICAgICAgIGlmIChtYWNzZWNfaXNf
b2ZmbG9hZGVkKG1hY3NlYykpIHsNCj4gPiA+ICAgICAgICAgICAgICAgY29uc3Qgc3RydWN0IG1h
Y3NlY19vcHMgKm9wczsNCj4gPg0KPiA+IFRoZXJlJ3MgYSBtaXNzaW5nIHJvbGxiYWNrIG9mIHRo
ZSBvZmZsb2FkaW5nIHN0YXR1cyBpbiB0aGUgKHByb2JhYmx5DQo+ID4gcXVpdGUgdW5saWtlbHkp
IGNhc2UgdGhhdCBtZG9fdXBkX3NlY3kgZmFpbHMsIG5vPyBXZSBjYW4ndCBmYWlsDQo+ID4gbWFj
c2VjX2dldF9vcHMgYmVjYXVzZSBtYWNzZWNfdXBkYXRlX29mZmxvYWQgd291bGQgaGF2ZSBmYWls
ZWQNCj4gPiBhbHJlYWR5LCBidXQgSSBndWVzcyB0aGUgZHJpdmVyIGNvdWxkIGZhaWwgaW4gbWRv
X3VwZF9zZWN5LCBhbmQgdGhlbg0KPiA+ICJnb3RvIGNsZWFudXAiIGRvZXNuJ3QgcmVzdG9yZSB0
aGUgb2ZmbG9hZGluZyBzdGF0ZS4gIFNvcnJ5IEkgZGlkbid0DQo+ID4gbm90aWNlIHRoaXMgZWFy
bGllci4NCj4gPg0KPiA+IEluIGNhc2UgdGhlIElGTEFfTUFDU0VDX09GRkxPQUQgYXR0cmlidXRl
IGlzIHByb3ZpZGVkIGFuZCB3ZSdyZQ0KPiA+IGVuYWJsaW5nIG9mZmxvYWQsIHdlIGFsc28gZW5k
IHVwIGNhbGxpbmcgdGhlIGRyaXZlcidzIG1kb19hZGRfc2VjeSwNCj4gPiBhbmQgdGhlbiBpbW1l
ZGlhdGVseSBhZnRlcndhcmRzIG1kb191cGRfc2VjeSwgd2hpY2ggcHJvYmFibHkgZG9lc24ndA0K
PiA+IG1ha2UgbXVjaCBzZW5zZS4NCj4gPg0KPiA+IE1heWJlIHdlIGNvdWxkIHR1cm4gdGhhdCBp
bnRvOg0KPiA+DQo+ID4gICAgIGlmIChkYXRhW0lGTEFfTUFDU0VDX09GRkxPQURdKSB7DQo+IA0K
PiBJZiBkYXRhW0lGTEFfTUFDU0VDX09GRkxPQURdIGlzIHByb3ZpZGVkIGJ1dCBkb2Vzbid0IGNo
YW5nZSB0aGUgb2ZmbG9hZGluZw0KPiBzdGF0ZSwgdGhlbiBtYWNzZWNfdXBkYXRlX29mZmxvYWQg
d2lsbCByZXR1cm4gZWFybHkgYW5kIG1kb191cGRfc2VjeSB3b24ndCBiZQ0KPiBjYWxsZWQuDQo+
IA0KPiA+ICAgICAgICAgLi4uIG1hY3NlY191cGRhdGVfb2ZmbG9hZA0KPiA+ICAgICB9IGVsc2Ug
aWYgKG1hY3NlY19pc19vZmZsb2FkZWQobWFjc2VjKSkgew0KPiA+ICAgICAgICAgLyogSWYgaC93
IG9mZmxvYWRpbmcgaXMgYXZhaWxhYmxlLCBwcm9wYWdhdGUgdG8gdGhlIGRldmljZSAqLw0KPiA+
ICAgICAgICAgLi4uIG1kb191cGRfc2VjeQ0KPiA+ICAgICB9DQo+ID4NCj4gPiBBbnRvaW5lLCBk
b2VzIHRoYXQgbG9vayByZWFzb25hYmxlIHRvIHlvdT8NCj4gDQo+IEJ1dCB5ZXMgSSBhZ3JlZSB3
ZSBjYW4gaW1wcm92ZSB0aGUgbG9naWMuIE1heWJlIHNvbWV0aGluZyBsaWtlOg0KDQpBY2sgLCBJ
IGNhbiBkbyB0aGUgY2hhbmdlDQoNCj4gICBwcmV2X29mZmxvYWQgPSBtYWNzZWMtPm9mZmxvYWQ7
DQo+ICAgb2ZmbG9hZCA9IGRhdGFbSUZMQV9NQUNTRUNfT0ZGTE9BRF07DQo+IA0KPiAgIGlmIChw
cmV2X29mZmxvYWQgIT0gb2ZmbG9hZCkgew0KPiAgICAgICBtYWNzZWNfdXBkYXRlX29mZmxvYWQo
Li4uKQ0KPiAgIH0gZWxzZSBpZiAobWFjc2VjX2lzX29mZmxvYWRlZChtYWNzZWMpKSB7DQo+ICAg
ICAgIC4uLg0KPiAgICAgICBwcmV2X29mZmxvYWQgY2FuIGJlIHVzZWQgdG8gcmVzdG9yZSB0aGUg
b2ZmbG9hZGluZyBzdGF0ZSBvbg0KPiAgICAgICBmYWlsdXJlIGhlcmUuDQoNCndoeSBkbyB3ZSBu
ZWVkIHRvIHJlc3RvcmUgb2ZmbG9hZGluZyBzdGF0ZSBoZXJlIGluIGNhc2Ugb2YgZmFpbHVyZT8N
CndlIGdldCB0byB0aGlzIGNhc2Ugd2hlbiBwcmV2X29mZmxvYWQgPT0gb2ZmbG9hZC4NCg0KPiAg
IH0NCj4gDQo+IFRoYW5rcywNCj4gQW50b2luZQ0K
