Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8530F57F5C2
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 17:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiGXPX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 11:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiGXPXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 11:23:20 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2072.outbound.protection.outlook.com [40.107.95.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E1811C0A
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 08:23:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrW3d+zWZZi+SgLEQ8lCAsfA0j7kUoymU7q9PQ+WSY6B/2X+8gpl4lcC5kBZAsBoqqwDXq0C81JwgjbwA4vpoFvjal4YHPBQgJbIvw7O2x3wrJTI4LZWoI/C6pyz+7HrR4m7mfEYyE70XizaapVGslf4zqQDOGruDh7qp8Uq1DBKMgeiWXw8VNf2vzcU7kEscVRBlUM1zq7nNw3KrWqTuZbOBJXkpj6vbLxHVnon2FanPm7Db53KnfYEd8V4Uf/ypk0G9EBuHetI4CiR5pc+KOy/IgfXlX4V5wJpjTsoWu8cBnTW3CmgYX1junep4NUlHWXwcl4Ezu8m5kU0dpby6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3G2jpUldrdOQ7FzITxs6e2Dzp1hq9eNU4RSh9k2Bq/E=;
 b=Q/reU5qLjymriIsLwVPKiayhdF4SHMTneFnNv6kKbbvujN13UOVqJTfDCDfJRjrRMR99td9z974ronliaOojKsvgkTepw8iKeiWzYBuO4gyo9oQpmVuq1z0KFc9eYH17KrbNALYzUT3rtyzXETJOyTdYjKNIDPNAkUXqFC2NNiGMJ5BPOC5ahUzJgLDNN8kJfSgKtlZu8rOqzb6HHRPhed44PJeH8lk5BEtj7kPG9gPE0laxQVaBlOCLmHuTW0Wq53cI3gJkk4oegsKFj7Vg5FtvnbwZ2021EqGE7uRFUKvbQb4EhvvKiGEYcA/jgV1BGvnm4vsnfuAo7rY4EDIrOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3G2jpUldrdOQ7FzITxs6e2Dzp1hq9eNU4RSh9k2Bq/E=;
 b=T0dq+nG4k+R9v+ZsBWWlIz96RrSWIbFSEzLDY/ftpwA9SyXaVcwatvjSfaxvo3B6JKrYpGg7FknIYlFfZ1naAnGXHM0sZSLyJD9FeTn8cWrjuSj7+QFZ4+nKDIaTbdEyvjiexVWmnd5g8cfPEbXoRcQOQe9eGvNrCOrKBBnN7BXdmzGl9x24aY+zMIL0j3zvb7MerEeoQ6QUWuCGa0wawNTUTUDwfHs6pQ4oWYypYZhXRF2/dvXdlJbaqfqiFhaIpO/huCFc4az89vc49XTV09d+egzdxpkqQzznkStw9DFmi+lX80/QaYPLRc24CiDmj906NZ1blno94jkz1WpvaQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BN9PR12MB5291.namprd12.prod.outlook.com (2603:10b6:408:104::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 15:23:18 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5458.023; Sun, 24 Jul 2022
 15:23:18 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYjU+MYrbSKcBokU6ni+IvOk3zwK1qDqQggAOY1gCAAIePkIABQJ6AgABBuVCAAFRBAIAAAK0QgACeU4CAG08FgIAB1AMg
Date:   Sun, 24 Jul 2022 15:23:18 +0000
Message-ID: <PH0PR12MB54813E8367D561ACFAAF3B99DC929@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e8479441-78d2-8b39-c5ad-6729b79a2f35@redhat.com>
 <PH0PR12MB54817FD9E0D8469857438F95DCBE9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1e1e5f8c-d20e-4e54-5fc0-e12a7ba818a3@intel.com>
 <PH0PR12MB5481862D47DCD61F89835B01DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
 <a59209f3-9005-b9f6-6f27-e136443aa3e1@intel.com>
 <PH0PR12MB54816A1864BADD420A2674E8DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
 <814143c9-b7ab-a1c7-c5e2-cff8b024fc2f@intel.com>
 <cbd81bad-b188-2895-4606-326eac36b02f@intel.com>
In-Reply-To: <cbd81bad-b188-2895-4606-326eac36b02f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e88b8a93-e48b-4d64-748a-08da6d886fe4
x-ms-traffictypediagnostic: BN9PR12MB5291:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gk+4bYvoYVlME+0/2aB8hk/qnRwFxjmSm8McR1QbkJdZ65nz63O17wRHynxgP7ZAK4vUSvtbyqdIzDqGVIDgbH36Ck/mCzFwvh84pjQ4n4ZHIdG8o6RJLepLSkVqSttFGuHTXxUPGQA5rohUHiC924czztnny3uRTE8PKGnBtH1N8gORGwgwVtT/aYGwrpr3LgVVgSATDwER0VVFUwOdPISt1AcTiBCYNOOs8cbg6FPX8uworGAzq78LX0lhQ3jVjMHxrI3iIpLYnJ//+hF/nNPcZqm7mfRj0yKR0QI0a9UBhtZDXYdUXKbwmxqeXNcLCZAeFHVP4xiEVpxgtDOiSTGEbzl1jRZt0gHdgGlkan3s/bmjMgswUv8cPFGDZpgmj0/qbzWdcPJcKcbZNiKieGX3Tge1QOCs7E+6UuFfcxv79YeePIMY9p7qK2mThpDD5DD/Evjp57WxzUYH+98JOzrkL2oV2fvHdsdz3EARctpquPGIvW0uicwiSf5UwnLeyqhK6jwza/qU8Bu5qmFNadUur+hdeYwGjFPUCIZUoi71vXhCy9VwNh6YHvo3mi2GcpFCCbBt2Sc4X4JivKyaGjWL0EYi8Ww61CAGMCsd13S5jsm7F95eTOuCoiGo7nXL/KR/NanaejdZAQfNvks0WQoElHn2h4AeQwDJgz9SWtFBhmJUvCPZEfXn+Ah6z2P3YumyUTgsseiU1BbJmB1qlIj7zu9cg9dfhseXtEeBR4CcLa4db6Yknyl0nUB7b3/2ePSqq0DSud5ns2Lean+bnSYXHh1RvIg0gyRgrkmRDlLdWkuJ3GzEvfs2zJdjX1H7HWJ/KGEwS8gBtCtwTxiKUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(316002)(54906003)(110136005)(41300700001)(26005)(9686003)(6506007)(7696005)(53546011)(71200400001)(478600001)(76116006)(55016003)(2906002)(66946007)(66556008)(66476007)(4326008)(66446008)(5660300002)(8676002)(64756008)(4744005)(52536014)(8936002)(38100700002)(122000001)(38070700005)(33656002)(86362001)(186003)(83380400001)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDh5ekJQanBTMjRYZ2lkeS9pcXNGRkxmeW9hVFI0OXJYdzh0RXdmK1Zkd1Zv?=
 =?utf-8?B?Z3VWL1RJdUNZMlRtYXBqUHdqSEZGNWt0RzVraC8rY0pIQW9tUHlCa0h2TWl2?=
 =?utf-8?B?UHJqUEF6Z1BROGJ2REpwbmFWMnZyMS8zRmc0TUF1c2NPSUpOZndaVHRlOVBS?=
 =?utf-8?B?a0x0YVdCUDNSY0lXZXlPaW9OK2VFaGVsdHoraGdleHJZVnhWVGh1bHlTaWpH?=
 =?utf-8?B?MlBLUmVaR21RTG5zZzRpNmRwTHE2RmFFNEppejBwQ2cwU3g0aWVCK0RFL2or?=
 =?utf-8?B?Rkw4U1F6SnBaRnlIUXZtUTBxRVlzL0I2RHVtWG9VcjJUUVRHOHVSUzlPdHMr?=
 =?utf-8?B?KzA0azZSbXNwdGVQaW1hTUR1VDI1WmwrQ1ErRmc3WG0xZTNOMldQaXpKMkpD?=
 =?utf-8?B?ZnNnYTFjK2FQVEJIUGhSL0lKQjlySkN1aDNqT24zTVZhVnNJWExrTDRTU1Rq?=
 =?utf-8?B?cDJ4SVhRendDS3J1d0h2NUtrT3MrQzZORktpOC9iZExZN1VVaHg0UERZUDli?=
 =?utf-8?B?MlVMcnlKUURNVDhocE5HTDhhaDlaeGpOQnRiWnRGc2ZWZWM3RDRWVGg0WXdw?=
 =?utf-8?B?TFhnTTFCRU5mQWdnbzJaMjY3ejBCUUpRZ1crSXZscFUwdTNWR0dOamd0cEtx?=
 =?utf-8?B?aWF4SWpSamg2SUtheGpVNE4vZlptYlF6WE5USFdzU1ZpUWMrQ1VqSkdjZzBw?=
 =?utf-8?B?UmN3MnVJMGR2VGI5S0xIbVZaSXZBVWQvT1RiZTdIUGIycFNuM09ObC9xdUpo?=
 =?utf-8?B?OURTS3pJRXkwZXNCazJHcGZqbndMN0tsdWFLU2NieUh6K3FFaU8wQ0Q3VGg5?=
 =?utf-8?B?bUp1aXVpc3NRTEp1Z0dOSnNNWkZGdnRWSHMwZEI0RnRLUThGdUtrcE0rWlVM?=
 =?utf-8?B?K2hhYjNZTHFQNS9icEcrUHBrMzFZbkxXMGptakZZMFVZYXVINFY0cmZXcE5h?=
 =?utf-8?B?allhVnNydENMNTNSdWJ6UkpaSzhsZENSV2lNV01kYWc0ODhzdGdBTStvVWs2?=
 =?utf-8?B?TUxPalVnY0pOemU0bE05OHBXanNwUTh2WCsrbndFdjZXOU15d0Jkb2tsaElB?=
 =?utf-8?B?b3BnSFFqVlYyMDArT1NuOXUrUmhYakZjYUdTN0kwSTNVenBsWUU1NnBJM1BM?=
 =?utf-8?B?SGd1ZUxTNkl1OHRjd0E3QjZONnhNTGhTQUgrZHlpaG12M3lZcG9QMjNtRk5J?=
 =?utf-8?B?RzhkL0g1d2R4NXdXQ0VmanpwQlIrUHhTWUFTb2F3SjlOVXFsbTNUNmdEbjBM?=
 =?utf-8?B?RlNoaXBIaElQODFmaEhVQzJYcXgzUzF4d3hLTWxodzhLNjUwK2YwcDZ3Wkty?=
 =?utf-8?B?cjBVekNjRHVuOG1EUHNlUU01VWFIVkRnNUFCMEtVSXZIUjRPenlaaE9laC8y?=
 =?utf-8?B?VmEwVTJsQzdFempVbkRhWERMbzkrRTdoZVQzRk00L3JlNW5UN1A1MEdnYW0r?=
 =?utf-8?B?MnhmSmFaMUJyeE5iUzh2Y2xBeXNrbTV0dFd3RkVvZVBWT1MxR3BpNVdpUFdF?=
 =?utf-8?B?aDRnczlma1BzSEM3NzdkaEtlbFhJaUNBSUJieUJJNysyVk00SDE0MEZwV1dJ?=
 =?utf-8?B?VDNOd1dZeDdCY2dnMG92dDVRSHRmVlVKUFZRYy9LWk42ck1VbDlQOW9DQ242?=
 =?utf-8?B?Nk1hdHVUSXBkZXprRVNGVTFqM2RTMHc0SjV4V0FSdzEreU1LNzIxMXZYa041?=
 =?utf-8?B?Ulh0RVZVMUgrU2IrOHVtOG9ZLzR5dFdTLzg3UU1keVg1azdTbGxoN0kvTC9D?=
 =?utf-8?B?NDU2ZTFRenlsNnpVdUttRCtwWWdhY1U1Wm5YSUFtMDBIaEJoRjBDK3cyQkhT?=
 =?utf-8?B?QkUzUElvWjQzNUpQcUlUb0lLTkxxTTBRSWFiOVlUVExaNVk4WHp0TDU5TmYx?=
 =?utf-8?B?UzhQTld2VHVZYnc4NHprZDMvWis5am1Sb29nRTl5VUsrcFRId0lFcTRpQ09F?=
 =?utf-8?B?bTUwRGRZT3R5c3R2cGsvb2JYSytUM2VzVlZscmVLTC8yeFJkeUJBb3BJYitr?=
 =?utf-8?B?L20zTTd1UEFDQnBhczNmTUlEWVVBZkR6QkphTVBtd2hvbi9QYmkyYjRIVklx?=
 =?utf-8?B?eEpmNjBYelNaMmRtbThDdnVoUmR2NVU4TThSOFBuNmhxSDdTZm9hZlRteGdn?=
 =?utf-8?Q?g/sE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e88b8a93-e48b-4d64-748a-08da6d886fe4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2022 15:23:18.6412
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WJj9gbj3kuU3mO7iUE1ASwk6FqaAS+3gT/6o7LE3NktsWuS3GqnBUEPF70T9HuWFhzpmcNjT2TIiIe8X2RNOXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5291
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFpodSwgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+IFNlbnQ6
IFNhdHVyZGF5LCBKdWx5IDIzLCAyMDIyIDc6MjcgQU0NCj4gDQo+IE9uIDcvNi8yMDIyIDEwOjI1
IEFNLCBaaHUsIExpbmdzaGFuIHdyb3RlOg0KPiA+DQo+ID4NCj4gPiBPbiA3LzYvMjAyMiAxOjAx
IEFNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+PiBGcm9tOiBaaHUsIExpbmdzaGFuIDxsaW5n
c2hhbi56aHVAaW50ZWwuY29tPg0KPiA+Pj4gU2VudDogVHVlc2RheSwgSnVseSA1LCAyMDIyIDEy
OjU2IFBNDQo+ID4+Pj4gQm90aCBjYW4gYmUgcXVlcmllZCBzaW11bHRhbmVvdXNseS4gRWFjaCB3
aWxsIHJldHVybiB0aGVpciBvd24NCj4gPj4+PiBmZWF0dXJlIGJpdHMNCj4gPj4+IHVzaW5nIHNh
bWUgYXR0cmlidXRlLg0KPiA+Pj4+IEl0IHdvbnQgbGVhZCB0byB0aGUgcmFjZS4NCj4gPj4+IEhv
dz8gSXQgaXMganVzdCBhIHBpZWNlIG9mIG1lbW9yeSwgeHh4eFthdHRyXSwgZG8geW91IHNlZSBs
b2NrcyBpbg0KPiA+Pj4gbmxhX3B1dF91NjRfNjRiaXQoKT8gSXQgaXMgYSB0eXBpY2FsIHJhY2Ug
Y29uZGl0aW9uLCBkYXRhIGFjY2Vzc2VkDQo+ID4+PiBieSBtdWx0aXBsZSBwcm9kdWNlcnMgLyBj
b25zdW1lcnMuDQo+ID4+IE5vLiBUaGVyZSBpcyBubyByYWNlIGNvbmRpdGlvbiBpbiBoZXJlLg0K
PiA+PiBBbmQgbmV3IGF0dHJpYnV0ZSBlbnVtIGJ5IG5vIG1lYW5zIGF2b2lkIGFueSByYWNlLg0K
PiA+Pg0KPiA+PiBEYXRhIHB1dCB1c2luZyBubGFfcHV0IGNhbm5vdCBiZSBhY2Nlc3NlZCB1bnRp
bCB0aGV5IGFyZSB0cmFuc2ZlcnJlZC4NCj4gPiBIb3cgdGhpcyBpcyBndWFyYW50ZWVkPyBEbyB5
b3Ugc2VlIGVycm9ycyB3aGVuIGNhbGxpbmcgbmxhX3B1dF94eHgoKQ0KPiA+IHR3aWNlPw0KPiBQ
YXJhdiwgZGlkIHlvdSBtaXNzIHRoaXM/DQpJdCBpcyBub3QgY2FsbGVkIHR3aWNlIGFuZCByZWFk
aW5nIGF0dHJpYnV0ZSBhbmQgcGFja2luZyBpbiBubGEgbWVzc2FnZSBpcyBub3QgcmFjZSBjb25k
aXRpb24uDQo=
