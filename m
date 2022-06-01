Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD33F53AD7A
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 21:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiFATbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 15:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiFATbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 15:31:51 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3627854692;
        Wed,  1 Jun 2022 12:30:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ade78DQAw9LHtuON8CZwoc45S+6bTl/KjADCM4uaVMzJQS377dTE9eizUXBiTtEoQvFB5X+9cBiBKXawO7zV4p/6xIrOJ9+XZMzZtzZJI7Cyg5ESgB57Bzn5BE+imqm1opsY5QqBFsTG5P5p26J7le3x9wd8l6IWjZiMgLDaCZ7wstV+ado/02MJGlvVdKWu7FVoLMtNMmFll+J7Wqake2jACQziZIP2R229kREuhIIdhXXmTPSjN9vgryWdQFQ/T/CuCqQN3wro5+xwMPrsHCUdZr/pRoo+9BRG7H9qLSj9DXmWiWN8GeCmfzE1yxUKmdmvNy26F3kwsOaNr3og1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOi5gE4JGz7wt/S10r9yT1vkI9PFr/Q8HjucJesFT4w=;
 b=IP12MDIVeHu4375S9KSMLOCnb9pUwLv1TdM1eEnQ5h4Y46evnm7/fu/oEEjyRv4EHWKtzWwYLV/+xYJfl6DrrXof22TSJLwMmn7no6UqZE2JBz1jzFCoIStVy03VL1sTPk7/ZK0mJiQCopC3q8qnDP0AxJqjAKdUp0jKV9/XEoLS1xGtO5i2+OBfuUmAKF7oPk/QPsyYs7MaYEedt6qoVnW60Y+WrM2YGrtVYFnDEdJyAlr1LLNKuQzsuMx0GSiu3OUgahwFKzDy1rDufsjNGMDHeEbrS3//5yuf9bnfBsug4fYSo7SCIq++COpbFvQanqnMTBV6MBHVPhA+MemS9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOi5gE4JGz7wt/S10r9yT1vkI9PFr/Q8HjucJesFT4w=;
 b=fRBYy4yBmcNJlAAutibmlAgh5nAIMgvYDuEpt9qtu9scYKhZr4xAcKTn/xLkaKYU4qLPJBwwlhITRn9bfiAFw0y4Vt3XB3qPcf4B8kU4TcbIROc+wFz23EsW5xHcD6JkLWANjpAqwlobQ6Yip4k6HMOfaCvLM1sZ5wbjEYyiN5sSL2ZIoA9N6Q7iNrrVA2CVkViinE9hqtf95rzzSRIzGeuFYhpJR/LmZxwn8JzbIhYWwcg7u5V+k7pirq/9DMQ4R3QT0kyAom2pu1pUNwAW7K9UHoJQ68d2xhg87bCdDGBFin1eo1glwPyT6aqTn+/yAaZAaAV4Cs2VCI+cy1HnLw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM6PR12MB4370.namprd12.prod.outlook.com (2603:10b6:5:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 1 Jun
 2022 19:30:08 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854%3]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 19:30:08 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: RE: [PATCH v4 0/4] Implement vdpasim stop operation
Thread-Topic: [PATCH v4 0/4] Implement vdpasim stop operation
Thread-Index: AQHYcP5BrBz66eonZEeOxjwIzt98aa0xHKkwgAFx+gCABD0SgIACqRJggADjAwCAAKFokA==
Date:   Wed, 1 Jun 2022 19:30:07 +0000
Message-ID: <PH0PR12MB5481DFD45D7B27A4E4783B8BDCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org>
 <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
 <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CAJaqyWe7YFM0anKLJvvRja-EJW5bwmb1gMGXnC62LVMKrSn3sw@mail.gmail.com>
In-Reply-To: <CAJaqyWe7YFM0anKLJvvRja-EJW5bwmb1gMGXnC62LVMKrSn3sw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9fd2d7a-c6d0-47a6-a170-08da44052316
x-ms-traffictypediagnostic: DM6PR12MB4370:EE_
x-microsoft-antispam-prvs: <DM6PR12MB4370676E5466D7A8D98963CADCDF9@DM6PR12MB4370.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hYUpgvGd5fsE7wEJuZoBdU4H7b3oJqe2VEXBwYGNjWMp9mYw7Iw83VW81ggxXmqeHKyCoR+dpyeF65g6RQTOBUvStc54Eir+1fpx5ms9xhnxCeVB5wFF3NNdAGEjHVX0YQufoG5QUnkIiVj3M+Fs25cnZXaoxO5qVD/0R81otF2UrME1aD1eELBQmSJMkLBCmV5P8Hp0mcgiCj+jgT0a5UyaGQL1bWkb4DZJ3KKr2WhEPPuGitlsmoY4qUfI3H1kNoehS1dNtH2xr6AdLdpBTm3h1B+uHj+bWH1oeXCs2SXmLYwjlalkpe3QfVKyx+sFVoquj3fPirruD79IufTa4Xb7SjE9YC+6g05mzDNb9mCtek/UxXMw7ij6uQX0IeijvOG79wFRvBQivz+MxQrWjrmlAApkfL8Gw04i99S2FepdABWAEn5E9Myd2QUnGeQ+OMrcQSxxQVOAJLlfzCH21F3gO/7izTi0vmSH2dpU3WMnI2tmqejEVez2dbzomJmjBcl+413WoaBsnp8vHDx7Yrdte43TXPhnuJ97u3IAd2gz00yqoXAd3FZrdZm5Svt295iAGP+BXodrpnWUBcRFWaPktkCCifmMucLJp9sKn5C9p8wiCnd2cNZleftznfExFvYfxe2j8CeHXCvRtNGa7wDBSOztW9sKJyvP3JaahFHw37n5X/4XJeOCnVi9SU5rCY33EjaUoxED11io5KJJ4UQhuTXglPqFzg6sP9Rll804W5FNWLIzpOFPy7DJ0+8imxgswzc6fL3LrU3VESRMEZihHVFD4cfDGOsKCH8SjIw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(66556008)(7416002)(53546011)(5660300002)(33656002)(66946007)(6506007)(86362001)(52536014)(7696005)(966005)(9686003)(2906002)(508600001)(122000001)(66574015)(71200400001)(38100700002)(55016003)(186003)(83380400001)(38070700005)(6916009)(54906003)(8676002)(4326008)(316002)(66446008)(76116006)(66476007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2J0bWFaK3l1Q0UvaEZEdHF6VXFQMXJmcGx6UDR2aWtkSUxEUEFSVCtFQXE2?=
 =?utf-8?B?VWkwN3hyVHlkaXRZdVZVL1JiRUg4RHRnVlRjNVJuaHh5QVg2aGgxZXlSbWwz?=
 =?utf-8?B?ZWxaYTdSK1FJdzVrNkI3N1ZUUm8wUmhodFdzQ3VKWEZqdjNZWWNVcEwrUVFI?=
 =?utf-8?B?blM5dUJzU2xrUUxFd0h1YWZtZm9YYys3dXFYOFR5Z0RVOTR1L1JEMFZOcHNR?=
 =?utf-8?B?ZGRsSzFFSEpTRFhEU0FuazgyRzc0aGFJeWE5K3AzaXIzZGZWYmxacEFtZ05i?=
 =?utf-8?B?bVRSaDYzLzl2TnpLNkJiSHRlK1NFMzd2WVBQeTdhd0NNS2ZDTTNqVVlrTktY?=
 =?utf-8?B?eGkwdVpXNFJ4YnpMZFFvUUwzQWljUVdYQTk5UjFnSEFuYjd5WS9IMjVBWitS?=
 =?utf-8?B?UzRnUXZSVHJ6SGxaRGpiK3NIaEttbTNSTS95RFk1Z3F5WEFhQWpJZWtWQ1FG?=
 =?utf-8?B?WUJ3SjZLcVBtSTFVRDYvL2VIbWNaS2RYUGdrd0RDblYzN2M2MC9hRVAzSm4v?=
 =?utf-8?B?T1U0TDd1SC9GbEk5QTBHNW5HdVlSR2ZTQnpzZ1NMK2VPUUZuUFJHODRUT1Ra?=
 =?utf-8?B?SXh5Z2tPWEN4TVFmdm1OSFB5VHEyYy9QMk8rRG0wa3htUmNOdlFjcDVuNHkv?=
 =?utf-8?B?SThkRndpWWkxWVlUUXpXQ2JINlNRVTZjR3lxOGJEWitEbnBkc1VZcE5XVU9S?=
 =?utf-8?B?TDZKaHJSdndiY2dPS0VNU0lmcVFXdlNLdEliUXo2MlBTNjFIMmRYNnpVdHh2?=
 =?utf-8?B?WWg0MnBDTHZhMUdXeTRQL2ZDOFBTanBXNFAxa0x5alREdm5iakJtVUxXUWRL?=
 =?utf-8?B?dkZvNVM2VHBMVlkyZXhFazFBMklrRGFQcnc0emtKMXpjc05MZFZEMkNLZUkz?=
 =?utf-8?B?dmd0aExzMlJNRHRRUko4dTBRemMwRXpGZHRZUkFtVnBJaUlVZm9LNHN3MWUz?=
 =?utf-8?B?VWl5ZytUK3ExMVlPanJnTjZKVGl3b3g3TlN3MGpWOE0vUjNGT0k0QWUzSDkx?=
 =?utf-8?B?cGc2Tm8xRVVlTk8rY1o4dCtGYXZxSFNueHVydUcvZk5sR2c5SEhqTTVEUzlj?=
 =?utf-8?B?cVJkNzJ4TDd0Um9EMnlJWEJMVlpLenZaN29IMld3L0IyTG5TZWwyNkhlOUtG?=
 =?utf-8?B?ZUEvTDA3YlFtYnFoNUk2d2dHamtxRWlzYU9FWE1ITFZOaDNmUGFOMi9tQ1Ro?=
 =?utf-8?B?aU1oY2p2R3V0RWNGd2x0eWZTUFdFS3RsN09ZdlQxRUMzdUVxNE55RVJKUk0v?=
 =?utf-8?B?Y2k2dUpQNnZ0eUF4S0g0cERTUmdHRERCTXp3QjJxYkhuOVAxSkdob2VWM0xk?=
 =?utf-8?B?RmlRU3lCMzZiakt5Umx6bmN1TEx0YzlBKzNQWG85QWRxdXdlOFMvMnJhUTlh?=
 =?utf-8?B?Y0pvd29pdmpjK3NTTTBHUWE3OW02bEx5L21GOEdzY1E1SVRmMGtaaFlhcVBl?=
 =?utf-8?B?YnVscFp4WjVvc3FTTy9SbmpvTTZ1cmUrZzdjMDZ2M0xJQXM2RWU5bFdreWRr?=
 =?utf-8?B?K3J3VlBPQ1pOOVR4dmI3ZTFjSHJaTXRpVXRZUjl3eHR5YWh1VFpCb3dDQ3lY?=
 =?utf-8?B?YmR0ZXB6a1FTZWY4c2pwS0VVdlBBRS9kR3VXY2tXaGFFeGh1Zzc2V0xkaVZY?=
 =?utf-8?B?OVRTYVVhVndLdFdkKzVXR0o4YXkyY2FFN210T1B0eDlTWVFCcTVkSVNkYmhD?=
 =?utf-8?B?dkNiL3c0NEJJSnNIYm44d3h0cjdCS3pQekRaaTNvcW9UMnRZODFaemlmcXZQ?=
 =?utf-8?B?N1VsQ3dkU052SVdhdVMzRXVsNW55WG8yeWpQN2tyZVNVdW9IWVpMVE9TY0I2?=
 =?utf-8?B?U1ZOa3hRQmhQbVUxTjdPblhiNWRGS2YxNm1ybjRvWHlEeUl4YUVUOVdUVERU?=
 =?utf-8?B?L2tSenhLVWVmUFpxc1lvT1FQUWZ2TDVMY2d1QXJvYjVPdUhRWEoxZGxkeGxG?=
 =?utf-8?B?RDY1NVFCYUpPbE5vMnl0MXhMM21xNm9YbUcwYmhUbkdtN29vY0drNWIvc2Uz?=
 =?utf-8?B?YzRhZE5hbmxDMmhzYk1kTG9SeGR3SUpVZDJzZnZoS1RWNGVIaitCSWxESmJG?=
 =?utf-8?B?RE5FcHZqOGZ0V1lMVForVmNpd1dadDRpTXRuZUxDWUpGTlFzMUk3NjZadEJi?=
 =?utf-8?B?NUxvREU3YXJKNVowZE1neVhpSDF3bDlZb0xlVnlyNTdnZzFUQW1Jb0FZbno2?=
 =?utf-8?B?cHJ4dHNJY08rTVNENmthREpDMXFCUWxBTHZqc21udjd2T0FEdWkvYU1pQjdP?=
 =?utf-8?B?TnZOOHVxZ1ZESFFRZ2NNbm9uNHVyY1ppRGc4R3pGeWpVTjNhbVpsWlN0UlU0?=
 =?utf-8?B?a1FIeE5aWVN0TE5sNklXNEpkZExnc1BOWjdyTGVRWkxpMHYwcXllVTRTTXFC?=
 =?utf-8?Q?SgtYjZ8zWyJC1+oJJuXeZSoNDROw5uxqiBX2ngWZXor+o?=
x-ms-exchange-antispam-messagedata-1: J81btKGXpsGHKA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fd2d7a-c6d0-47a6-a170-08da44052316
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2022 19:30:08.0091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ERJq/+9fhCjOWD1WGNBZhKlwlS8y74xNhWr2DoA3S4eEjyPBslgsWZvFjr5hlLV+hCLm3vxlNWo6Wi99A/LzOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4370
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogRXVnZW5pbyBQZXJleiBNYXJ0aW4gPGVwZXJlem1hQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSAxLCAyMDIyIDU6NTAgQU0NCj4gDQo+IE9uIFR1ZSwgTWF5
IDMxLCAyMDIyIGF0IDEwOjE5IFBNIFBhcmF2IFBhbmRpdCA8cGFyYXZAbnZpZGlhLmNvbT4gd3Jv
dGU6DQo+ID4NCj4gPg0KPiA+ID4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNv
bT4NCj4gPiA+IFNlbnQ6IFN1bmRheSwgTWF5IDI5LCAyMDIyIDExOjM5IFBNDQo+ID4gPg0KPiA+
ID4gT24gRnJpLCBNYXkgMjcsIDIwMjIgYXQgNjo1NiBQTSBNaWNoYWVsIFMuIFRzaXJraW4gPG1z
dEByZWRoYXQuY29tPg0KPiB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4gT24gVGh1LCBNYXkgMjYs
IDIwMjIgYXQgMTI6NTQ6MzJQTSArMDAwMCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+ID4gPiA+
DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEZyb206IEV1Z2VuaW8gUMOpcmV6IDxlcGVyZXptYUBy
ZWRoYXQuY29tPg0KPiA+ID4gPiA+ID4gU2VudDogVGh1cnNkYXksIE1heSAyNiwgMjAyMiA4OjQ0
IEFNDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEltcGxlbWVudCBzdG9wIG9wZXJhdGlvbiBmb3Ig
dmRwYV9zaW0gZGV2aWNlcywgc28gdmhvc3QtdmRwYQ0KPiA+ID4gPiA+ID4gd2lsbCBvZmZlcg0K
PiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IHRoYXQgYmFja2VuZCBmZWF0dXJlIGFuZCB1c2Vyc3Bh
Y2UgY2FuIGVmZmVjdGl2ZWx5IHN0b3AgdGhlIGRldmljZS4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+
ID4gPg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFRoaXMgaXMgYSBtdXN0IGJlZm9yZSBnZXQg
dmlydHF1ZXVlIGluZGV4ZXMgKGJhc2UpIGZvciBsaXZlDQo+ID4gPiA+ID4gPiBtaWdyYXRpb24s
DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gc2luY2UgdGhlIGRldmljZSBjb3VsZCBtb2RpZnkg
dGhlbSBhZnRlciB1c2VybGFuZCBnZXRzIHRoZW0uDQo+ID4gPiA+ID4gPiBUaGVyZSBhcmUNCj4g
PiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBpbmRpdmlkdWFsIHdheXMgdG8gcGVyZm9ybSB0aGF0IGFj
dGlvbiBmb3Igc29tZSBkZXZpY2VzDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gKFZIT1NUX05F
VF9TRVRfQkFDS0VORCwgVkhPU1RfVlNPQ0tfU0VUX1JVTk5JTkcsIC4uLikNCj4gYnV0DQo+ID4g
PiB0aGVyZQ0KPiA+ID4gPiA+ID4gd2FzIG5vDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gd2F5
IHRvIHBlcmZvcm0gaXQgZm9yIGFueSB2aG9zdCBkZXZpY2UgKGFuZCwgaW4gcGFydGljdWxhciwg
dmhvc3QtDQo+IHZkcGEpLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gQWZ0ZXIgdGhlIHJldHVybiBvZiBpb2N0bCB3aXRoIHN0b3AgIT0gMCwgdGhl
IGRldmljZSBNVVNUDQo+ID4gPiA+ID4gPiBmaW5pc2ggYW55DQo+ID4gPiA+ID4gPg0KPiA+ID4g
PiA+ID4gcGVuZGluZyBvcGVyYXRpb25zIGxpa2UgaW4gZmxpZ2h0IHJlcXVlc3RzLiBJdCBtdXN0
IGFsc28NCj4gPiA+ID4gPiA+IHByZXNlcnZlIGFsbA0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+
IHRoZSBuZWNlc3Nhcnkgc3RhdGUgKHRoZSB2aXJ0cXVldWUgdnJpbmcgYmFzZSBwbHVzIHRoZQ0K
PiA+ID4gPiA+ID4gcG9zc2libGUgZGV2aWNlDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gc3Bl
Y2lmaWMgc3RhdGVzKSB0aGF0IGlzIHJlcXVpcmVkIGZvciByZXN0b3JpbmcgaW4gdGhlIGZ1dHVy
ZS4NCj4gPiA+ID4gPiA+IFRoZQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IGRldmljZSBtdXN0
IG5vdCBjaGFuZ2UgaXRzIGNvbmZpZ3VyYXRpb24gYWZ0ZXIgdGhhdCBwb2ludC4NCj4gPiA+ID4g
PiA+DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IEFmdGVyIHRoZSByZXR1
cm4gb2YgaW9jdGwgd2l0aCBzdG9wID09IDAsIHRoZSBkZXZpY2UgY2FuDQo+ID4gPiA+ID4gPiBj
b250aW51ZQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IHByb2Nlc3NpbmcgYnVmZmVycyBhcyBs
b25nIGFzIHR5cGljYWwgY29uZGl0aW9ucyBhcmUgbWV0ICh2cQ0KPiA+ID4gPiA+ID4gaXMgZW5h
YmxlZCwNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBEUklWRVJfT0sgc3RhdHVzIGJpdCBpcyBl
bmFibGVkLCBldGMpLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gSnVzdCB0byBiZSBjbGVhciwgd2Ug
YXJlIGFkZGluZyB2ZHBhIGxldmVsIG5ldyBpb2N0bCgpIHRoYXQNCj4gPiA+ID4gPiBkb2VzbuKA
mXQgbWFwIHRvDQo+ID4gPiBhbnkgbWVjaGFuaXNtIGluIHRoZSB2aXJ0aW8gc3BlYy4NCj4gPiA+
ID4gPg0KPiA+ID4gPiA+IFdoeSBjYW4ndCB3ZSB1c2UgdGhpcyBpb2N0bCgpIHRvIGluZGljYXRl
IGRyaXZlciB0byBzdGFydC9zdG9wDQo+ID4gPiA+ID4gdGhlIGRldmljZQ0KPiA+ID4gaW5zdGVh
ZCBvZiBkcml2aW5nIGl0IHRocm91Z2ggdGhlIGRyaXZlcl9vaz8NCj4gPiA+ID4gPiBUaGlzIGlz
IGluIHRoZSBjb250ZXh0IG9mIG90aGVyIGRpc2N1c3Npb24gd2UgaGFkIGluIHRoZSBMTSBzZXJp
ZXMuDQo+ID4gPiA+DQo+ID4gPiA+IElmIHRoZXJlJ3Mgc29tZXRoaW5nIGluIHRoZSBzcGVjIHRo
YXQgZG9lcyB0aGlzIHRoZW4gbGV0J3MgdXNlIHRoYXQuDQo+ID4gPg0KPiA+ID4gQWN0dWFsbHks
IHdlIHRyeSB0byBwcm9wb3NlIGEgaW5kZXBlbmRlbnQgZmVhdHVyZSBoZXJlOg0KPiA+ID4NCj4g
PiA+IGh0dHBzOi8vbGlzdHMub2FzaXMtb3Blbi5vcmcvYXJjaGl2ZXMvdmlydGlvLWRldi8yMDIx
MTEvbXNnMDAwMjAuaHRtDQo+ID4gPiBsDQo+ID4gPg0KPiA+IFRoaXMgd2lsbCBzdG9wIHRoZSBk
ZXZpY2UgZm9yIGFsbCB0aGUgb3BlcmF0aW9ucy4NCj4gPiBPbmNlIHRoZSBkZXZpY2UgaXMgc3Rv
cHBlZCwgaXRzIHN0YXRlIGNhbm5vdCBiZSBxdWVyaWVkIGZ1cnRoZXIgYXMgZGV2aWNlDQo+IHdv
bid0IHJlc3BvbmQuDQo+ID4gSXQgaGFzIGxpbWl0ZWQgdXNlIGNhc2UuDQo+ID4gV2hhdCB3ZSBu
ZWVkIGlzIHRvIHN0b3Agbm9uIGFkbWluIHF1ZXVlIHJlbGF0ZWQgcG9ydGlvbiBvZiB0aGUgZGV2
aWNlLg0KPiA+DQo+IA0KPiBTdGlsbCBkb24ndCBmb2xsb3cgdGhpcywgc29ycnkuDQpPbmNlIGEg
ZGV2aWNlIGl0IHN0b3BwZWQgaXRzIHN0YXRlIGV0YyBjYW5ub3QgYmUgcXVlcmllZC4NCmlmIHlv
dSB3YW50IHRvIHN0b3AgYW5kIHN0aWxsIGFsbG93IGNlcnRhaW4gb3BlcmF0aW9ucywgYSBiZXR0
ZXIgc3BlYyBkZWZpbml0aW9uIGlzIG5lZWRlZCB0aGF0IHNheXMsDQoNCnN0b3AgQSwgQiwgQywg
YnV0IGFsbG93IEQsIEUsIEYsIEcuDQpBID0gc3RvcCBDVlFzIGFuZCBzYXZlIGl0cyBzdGF0ZSBz
b21ld2hlcmUNCkIgPSBzdG9wIGRhdGEgVlFzIGFuZCBzYXZlIGl0IHN0YXRlIHNvbWV3aGVyZQ0K
QyA9IHN0b3AgZ2VuZXJpYyBjb25maWcgaW50ZXJydXB0DQoNCkQgPSBxdWVyeSBzdGF0ZSBvZiBt
dWx0aXBsZSBWUXMNCkUgPSBxdWVyeSBkZXZpY2Ugc3RhdGlzdGljcyBhbmQgb3RoZXIgZWxlbWVu
dHMvb2JqZWN0cyBpbiBmdXR1cmUNCkYgPSBzZXR1cC9jb25maWcvcmVzdG9yZSBjZXJ0YWluIGZp
ZWxkcw0KRyA9IHJlc3VtZSB0aGUgZGV2aWNlDQoNCj4gDQo+IEFkZGluZyB0aGUgYWRtaW4gdnEg
dG8gdGhlIG1peCwgdGhpcyB3b3VsZCBzdG9wIGEgZGV2aWNlIG9mIGEgZGV2aWNlIGdyb3VwLA0K
PiBidXQgbm90IHRoZSB3aG9sZSB2aXJ0cXVldWUgZ3JvdXAuIElmIHRoZSBhZG1pbiBWUSBpcyBv
ZmZlcmVkIGJ5IHRoZSBQRg0KPiAoc2luY2UgaXQncyBub3QgZXhwb3NlZCB0byB0aGUgZ3Vlc3Qp
LCBpdCB3aWxsIGNvbnRpbnVlIGFjY2VwdGluZyByZXF1ZXN0cyBhcw0KPiBub3JtYWwuIElmIGl0
J3MgZXhwb3NlZCBpbiB0aGUgVkYsIEkgdGhpbmsgdGhlIGJlc3QgYmV0IGlzIHRvIHNoYWRvdyBp
dCwgc2luY2UNCj4gZ3Vlc3QgYW5kIGhvc3QgcmVxdWVzdHMgY291bGQgY29uZmxpY3QuDQo+IA0K
PiBTaW5jZSB0aGlzIGlzIG9mZmVyZWQgdGhyb3VnaCB2ZHBhLCB0aGUgZGV2aWNlIGJhY2tlbmQg
ZHJpdmVyIGNhbiByb3V0ZSBpdCB0bw0KPiB3aGF0ZXZlciBtZXRob2Qgd29ya3MgYmV0dGVyIGZv
ciB0aGUgaGFyZHdhcmUuIEZvciBleGFtcGxlLCB0byBzZW5kIGFuDQo+IGFkbWluIHZxIGNvbW1h
bmQgdG8gdGhlIFBGLiBUaGF0J3Mgd2h5IGl0J3MgaW1wb3J0YW50IHRvIGtlZXAgdGhlIGZlYXR1
cmUNCj4gYXMgc2VsZi1jb250YWluZWQgYW5kIG9ydGhvZ29uYWwgdG8gb3RoZXJzIGFzIHBvc3Np
YmxlLg0KPiANCg0KSSByZXBsaWVkIGluIG90aGVyIHRocmVhZCB0byBjb250aW51ZSB0aGVyZS4N
Cg==
