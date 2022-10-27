Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9CC60F5A6
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiJ0Kpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbiJ0Kpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:45:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E65495F7
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:45:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZogFGlBfYk6pYwWtnBanQYuMzUdvy1dtvNWMvSirJWNw+jf5nAZMZ2gojCfmwqzU24YFpiGsWhSxIvupBVjZsuXVFohup0A9ouz5hh4ukZDPTxjnQiWiaNBRTaBnuipaacVbKsSHf4Nc+eFibTabjhQDOAseaj69Sav22LJjmiwzis1gb97JvlIU+/nCuJrA3iGpOw0i6Q1PXXC1+yQhD0q4s2SGFThDQN0UGSpnTkNLyqW7VPEfJE34qM3/U5ISaMTlT2wC8HGLdmv1B3qJzsWEKPstIf5N1WcjiifrBQiayqZSfPJOlnMnUJVaEM6x/+5XU1bsgTgII3IZq38EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Noy/DEPnJCsj59b91xfJOoey+Qp3iUdqj2uAxERtzQY=;
 b=fasyob+EboHv3j2+hoGvde7NM8LztwyT2uVEPzyYlPTOEim+7W4efquYYdOWxBxda+Nbr9BpSLXCuyWpTQCJH5yBjxAc8dbJB8FfXay02DWWBm6+sMaXbgxtziE5XlyxhuSM5qKcmVwwiNzpJ8Zhyey0QVRk5j8DMA0up/cafD5s1uYtBhTdrtqLpFLv3as9CQ9ReWF2LzFOQAcOm0GYPKdvT/WVM2FdxNvr77K2ghHl9EvqN14CWSDbYBuXyMeYac/SU+cUrD7uIvf9Al/XgF6QKhz5R8HKSf4534LO8+CBMNuWgR8c73Py9qxx8Olvg/UiRUVwrnUZOOmXidXMXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Noy/DEPnJCsj59b91xfJOoey+Qp3iUdqj2uAxERtzQY=;
 b=pxlFN9R8QW/c+9lBsDEik80RaCm0C3Zp6034w+WvmuiLk0AGgiTE00GQvdD3GYQZz4ptAmmqj1+nzTgBCfSzR4buz6Hnd90n9rxDTFyjsiaXyO8lhNLqGKeejCi6bOd7WGZ6vvSRZFnNg7Arl6y1vAisze9TTEh1dK8Lm8IIH/rS+KoyAEtkdeeR5bSZLRQ10Gx5pnvLK4gdS4KliB0l/y6dWrOXTr66f+1rxI7vQOMa2xVSmT+xbmyeJqTV9TdyA9q1+PuHVHsoSuzmmsZ8IdlOHxXZQ8wyBxhNAYuQ2/DQOyRPiJ36cuAJlgtKGX/9lUfobKmyMGi6P7mb3Gb/3g==
Received: from DM6PR12MB3564.namprd12.prod.outlook.com (2603:10b6:5:11d::14)
 by DS7PR12MB6069.namprd12.prod.outlook.com (2603:10b6:8:9f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 27 Oct
 2022 10:45:31 +0000
Received: from DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7]) by DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7%7]) with mapi id 15.20.5723.029; Thu, 27 Oct 2022
 10:45:31 +0000
From:   Shai Malin <smalin@nvidia.com>
To:     Sagi Grimberg <sagi@grimberg.me>,
        Aurelien Aptel <aaptel@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "hch@lst.de" <hch@lst.de>, "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC:     Or Gerlitz <ogerlitz@nvidia.com>, Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [PATCH v7 00/23] nvme-tcp receive offloads
Thread-Topic: [PATCH v7 00/23] nvme-tcp receive offloads
Thread-Index: AQHY6HoVGvxFM+iSS0ytOpHicI1xJK4iDswAgAAAd6A=
Date:   Thu, 27 Oct 2022 10:45:31 +0000
Message-ID: <DM6PR12MB35643EF99249C97998510C51BC339@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
 <f62c517e-e25e-ad2f-cf31-cba6639735ad@grimberg.me>
In-Reply-To: <f62c517e-e25e-ad2f-cf31-cba6639735ad@grimberg.me>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3564:EE_|DS7PR12MB6069:EE_
x-ms-office365-filtering-correlation-id: 88f65abb-ab2a-499c-4e97-08dab8085e85
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ub+2tOJ2siOFEtTskiy3AIsCwW5lhf9q2nElK6LsiDYwHkbrq6wZ9zXHgT0B1Wc/fzW01TisOKL5+XcnkAva8F9S7Z9v06cGXzMjutMTbxQlGmcMAY3CWRSnXlL19xpxGDSF4kOGruJWpL1xGALR8DxwLbNNoLJ8lA2mgA36OoNBtzQAq/Gv42QBtkCCdiqVTlM7mcnAD6zd31hjbPf8fWfW/Letd8PYpxdj+jlJKHAUw2XUEFydecei4zipPiY715h2poLlymacKBtuSWpK8DhIljGyT7/HoMi32CeXeFLE51YfFco4EKetyIECbQXbMj6JIFdTb/sDxcETtqki828OeuXw8UBqSY/fM/QJ7F4AtC7dxg/CS4/lPqwqg799MggykPwUdpfSXH0FFunsLa/0DHqJIuvuaGNLha1o5nmqRI70EFTqSm9nj5iEAje+EojFG0fe9Gp2zls6w/YCJDqqCE3EAn9LP9KK8rE1WIvgieChAEY2Q0c5RAF+9YJx1sfpRq9Pb8RzBwpgKKTbDoLJ8SzRVWKpb5vlLwXRHbLumC2k7NdWkQdCvus3aw7I2dF7MHYc4ZJpOzudfrkNRM9BsPECW1tjEEUQYXYEFeoSf7PkDkhbJtBlzofAHYR0As6NAy3qd5HUhobENV80kIofbW3WTkZCphesU7bv68aKmOV86ylZjTUGSd9JPKmMCff2TVNbetY77qR8fp1sSy5K5EBRUGwJckXSSvMqlDfXLwPL53NP5cOEwNbb9OXoMwuPRbokn/s+fmEc8tfe33WXqXP0nj7l1HoOgii3enyLtcuyrOJ3spvOs4c/VtkEX2TYZVaTajUGPCVSjpzPAUen6ui1GtdZTANc420pR2SESYYmzNTt0P6wxjiFCN26OUmDCEuahd3uAR77KJSzPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3564.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199015)(33656002)(966005)(2906002)(186003)(71200400001)(38070700005)(921005)(122000001)(478600001)(66446008)(66476007)(66556008)(64756008)(4326008)(8936002)(316002)(110136005)(66946007)(7696005)(55016003)(6636002)(54906003)(76116006)(26005)(6506007)(38100700002)(9686003)(8676002)(86362001)(52536014)(83380400001)(5660300002)(7416002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3dNN1ZvZ1kwTUFjNW9nYjZmU3NlL01oY0E0Tnp4NGhmaVVZVDJIVEUxOGtE?=
 =?utf-8?B?ajVlT1JPeVJhTlAzUXlTUWtkSGFxbkVsU1lyUnVFNlgzVy93UGNJY3RaV08v?=
 =?utf-8?B?bGE2T3YwL0F0SGNFWVZkdkZMTmZVK2pJTGNvZDNtc1E1SHE0cFZ5NE1Jb25t?=
 =?utf-8?B?Z0x0VUJiVGNhN2FqUTlDQVowZVYybjlYYVRkQmlpZGxVeXBYekc4M1NyVHpX?=
 =?utf-8?B?VTRXbyswSmVDODhiRVMySWVXcHZnb1A3RFl2V3d6YmtZSW9vU3NlREJoT1FG?=
 =?utf-8?B?eWFCZC9uUDVvZGdVL01uQUNENlF2RVRkMk8xbk1DN3BDVGdFZWlJNlBJQUZs?=
 =?utf-8?B?MmpDNlh4N2JQRjZuT281UmpGemowMXdKZ1p0ZUI5UWZVNGJQR1l6VitRNy9N?=
 =?utf-8?B?Mkkxc3hqL0tKN2YxRk5nSmNmVmVFcnpla1FqN3JCdkhRcU5mWjZ4c2lKckFK?=
 =?utf-8?B?OFE5bXhncVNaWnZJb3NhZldQNkVXNXFMYnc4L2E1QitlVmZWbTVKQW10VjBE?=
 =?utf-8?B?Z1ZtYmpmVThoaStCMnNlQ09sN29KOW9Obit1VzZybHdqMmxBOGkrRFRXbDVY?=
 =?utf-8?B?TGpRZnNOaUVOVmZFQ0cyWmc5TXg3VGZIdXQ5eVNRYWNwd0VBdmgvcXJzcytn?=
 =?utf-8?B?QXNDeER2ZVBScysxTDdzUTk4WWpNT2ppTUprK0VVMTRaZWhFR0ZaZ1JXVHNN?=
 =?utf-8?B?MnJBYnY3Z3JuT2lNclp0YW1tN2p1bUxtUlFlL3Y4YlJtNWVnTWtVR3UrQmJx?=
 =?utf-8?B?TW5BbFdFNDQvZjRLZmlaVjNvczNJTWpjU1VPOUlDUm9qSzZldk1XcTA4TGlN?=
 =?utf-8?B?NkxnVEhXaTJYcjNCVXJlVkJ0N1RIT3pwSllzdTBlNzZ6MkEyZWFNUE40SHg5?=
 =?utf-8?B?MEpUWmFPdklaa1dBS1BLSnVNRVo4ZERxazNlWDk0dE0zby85TmV4U3FXdVZE?=
 =?utf-8?B?emcyZlJKN3JJV3lsNmpNY0FRaUlEUUtLMWJtZTFQTWpYMzA2SUpkbjdjQ09x?=
 =?utf-8?B?Zk1vVVNISTJqblhHOFhPcytlSzNyYU8rS2JzUmk0SWt0ZGM0VXdRSGlTMkZx?=
 =?utf-8?B?aWVjM1UzZlMyaXh4YlgxaWgxeEd0UThQL0htMDI1NzhwSGxTdDYvVzE0Q1pF?=
 =?utf-8?B?R2tPdHpla0ZQdUdHWDBpZlR4MkE2NnZzUjVJZGcrSVpra29MSFZ3TzJ5OTd6?=
 =?utf-8?B?bE5FMldqU2s3OWliamw2Tnd5R290K3ZGYjFCQ2N0SVc5Vnc0VUwxUFQvUmhr?=
 =?utf-8?B?cGNaWmo0WjN6SXdUdnVTYTJQSU1qaEZ0cERGU3E0TTczUkVBYlJVbGRzSHBO?=
 =?utf-8?B?Y1puKzU0eWpwSWwreUFNY09sc0Z0aWsrUE8wMEd4Z09MYXpRV081Q2JiaUMv?=
 =?utf-8?B?K1cvWnpnTlZEMi83bWw4d25VdVllSFlpR1NRbjNtOSsrTFdUb0xnczhIVVc3?=
 =?utf-8?B?ejJOVzhZR20zUHBtZnR4RVRsRW5iM0FsWWZmS095TXJacEo5eDJPTHdMVFpO?=
 =?utf-8?B?cWRwZDBJaHQxWWZyM2FWQThWWXg3bmIxKzFQZlV0NFU3V1RVNWxUVWtPd3hw?=
 =?utf-8?B?VzEzWmU2dEFZTkNrZVlwd1VwUElvSlZ3OU0wS0VLRmZwelpCbnZINFFzV3lO?=
 =?utf-8?B?WWFVMnF3Mkt4QzV6S0kwSy9hUW5wb2dYbFk5K1cyc29kemhlV3MxVEVHY29r?=
 =?utf-8?B?NDkxU045NGxsQlc2VUlGTmJoR0hMcW8venJRZlVKb3ZtbWhkODRvQXJ0T1NQ?=
 =?utf-8?B?UjhSTTdxdkRzaU9VTWcvYTVsQm5BR1YzL0VCdXBoR2lJN1NjYzN5Um45aEJL?=
 =?utf-8?B?blQ1Y3NKMVlISmRMSDRxTG9uaDQvNWJyaTQvU3J2Zm9vclAvOTRJUERnR0Ex?=
 =?utf-8?B?WHQwOS92RkxMQ1hVNHJXNXF3UkVab0dEbkRaUGV1c2RhekQzUmtpSFJWZ1hs?=
 =?utf-8?B?QU5GZXZDM3VoMGJJb2JwTVFucm02S0k2ckJOK1ZacFpqeml2cmpqTUlSTEhK?=
 =?utf-8?B?emFZd25HeHZYWDVYQVdoWmVLRlJDS3MrV2NBNjFMSVNUK2ROMUhReXBJb1Qy?=
 =?utf-8?B?RUZqRUgxNU8zUWphNmY3dDloblZPcXlCVnp2VWU1T29SSUhIZzNHNFR4N1o3?=
 =?utf-8?Q?u55BYRgaksB8CkDVurC2d049c?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3564.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f65abb-ab2a-499c-4e97-08dab8085e85
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 10:45:31.1234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dHXIrBSfM+c2JIiMeg8m24nnYHr5qwLls5bf/kWDJ5f407chQ5Llk/uzaVF5OCbPy1feZZERR5Zvn3yL7Md3dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6069
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyNyBPY3QgMjAyMiBhdCAxMTozNSwgU2FnaSBHcmltYmVyZyA8c2FnaUBncmltYmVy
Zy5tZT4gd3JvdGU6DQo+ID4gSGksDQo+ID4NCj4gPiBUaGUgbnZtZS10Y3AgcmVjZWl2ZSBvZmZs
b2FkcyBzZXJpZXMgdjcgd2FzIHNlbnQgdG8gYm90aCBuZXQtbmV4dCBhbmQNCj4gPiBudm1lLiAg
SXQgaXMgdGhlIGNvbnRpbnVhdGlvbiBvZiB2NSB3aGljaCB3YXMgc2VudCBvbiBKdWx5IDIwMjEN
Cj4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMTA3MjIxMTAzMjUuMzcxLTEt
Ym9yaXNwQG52aWRpYS5jb20vIC4NCj4gPiBWNyBpcyBub3cgd29ya2luZyBvbiBhIHJlYWwgSFcu
DQo+ID4NCj4gPiBUaGUgZmVhdHVyZSB3aWxsIGFsc28gYmUgcHJlc2VudGVkIGluIG5ldGRldiB0
aGlzIHdlZWsNCj4gPiBodHRwczovL25ldGRldmNvbmYuaW5mby8weDE2L3Nlc3Npb24uaHRtbD9O
Vk1lVENQLU9mZmxvYWQtJUUyJTgwJTkzLQ0KPiBJbXBsZW1lbnRhdGlvbi1hbmQtUGVyZm9ybWFu
Y2UtR2FpbnMNCj4gPg0KPiA+IEN1cnJlbnRseSB0aGUgc2VyaWVzIGlzIGFsaWduZWQgdG8gbmV0
LW5leHQsIHBsZWFzZSB1cGRhdGUgdXMgaWYgeW91IHdpbGwgcHJlZmVyDQo+IG90aGVyd2lzZS4N
Cj4gPg0KPiA+IFRoYW5rcywNCj4gPiBTaGFpLCBBdXJlbGllbg0KPiANCj4gSGV5IFNoYWkgJiBB
dXJlbGllbg0KPiANCj4gQ2FuIHlvdSBwbGVhc2UgYWRkIGluIHRoZSBuZXh0IHRpbWUgZG9jdW1l
bnRhdGlvbiBvZiB0aGUgbGltaXRhdGlvbnMNCj4gdGhhdCB0aGlzIG9mZmxvYWQgaGFzIGluIHRl
cm1zIG9mIGNvbXBhdGliaWxpdHk/IGkuZS4gZm9yIGV4YW1wbGUgKGZyb20NCj4gbXkgb3duIGlt
YWdpbmF0aW9uKToNCj4gMS4gYm9uZGluZy90ZWFtaW5nL290aGVyLXN0YWNraW5nPw0KPiAyLiBU
TFMgKHN3L2h3KT8NCj4gMy4gYW55IHNvcnQgb2YgdHVubmVsaW5nL292ZXJsYXk/DQo+IDQuIFZG
L1BGPw0KPiA1LiBhbnkgbnZtZSBmZWF0dXJlcz8NCj4gNi4gLi4uDQo+IA0KPiBBbmQgd2hhdCBh
cmUgeW91ciBwbGFucyB0byBhZGRyZXNzIGVhY2ggaWYgYXQgYWxsLg0KPiANCj4gQWxzbywgZG9l
cyB0aGlzIGhhdmUgYSBwYXRoIHRvIHVzZXJzcGFjZT8gZm9yIGV4YW1wbGUgYWxtb3N0IGFsbA0K
PiBvZiB0aGUgbnZtZS10Y3AgdGFyZ2V0cyBsaXZlIGluIHVzZXJzcGFjZS4NCj4gDQo+IEkgZG9u
J3QgdGhpbmsgSSBzZWUgaW4gdGhlIGNvZGUgYW55IGxpbWl0cyBsaWtlIHRoZSBtYXhpbXVtDQo+
IGNvbm5lY3Rpb25zIHRoYXQgY2FuIGJlIG9mZmxvYWRlZCBvbiBhIHNpbmdsZSBkZXZpY2UvcG9y
dC4gQ2FuDQo+IHlvdSBzaGFyZSBzb21lIGRldGFpbHMgb24gdGhpcz8NCj4gDQo+IFRoYW5rcy4N
Cg0KU3VyZSwgd2UgYWRkIGl0Lg0K
