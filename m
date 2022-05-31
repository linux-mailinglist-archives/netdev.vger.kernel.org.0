Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68255397F2
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347733AbiEaU0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344465AbiEaU0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:26:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA5056FB8;
        Tue, 31 May 2022 13:26:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwV8wFh6L9fBCjOOlXKpTg1SyPnH+M5KaACOCLtUjMczq9IvCJqVMEW99KCXB7bO3AIZ7heP4Y+AE3H5q9Oq+6r90riscqT+erEgONgnfJMlnBNkhTJC9L73f2tRL0OjlgxLZ04qSVu0zkbnUWDp9oAb94XtHQvJqg9vOUpj2tW1USbHRkvQJMD8HP9pXey3wDt4cb3bO9bh37wsY8GB6q1RlOrZb89naav4XJnPgBI1uTGsf1murLcD9sekedeiros6UeSZ/5KjVqQt4kUTgelMoNEB2jiG4tOG6Y0Y9GWwdSl8TP9Loxj6SPcjyPBTWpdM21heqbYSpbfKx5f+hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDf5xOLYNDJ+Veig/aqvuntMCoEW9iQVxvJbQhh7CEk=;
 b=XhFQTpD3lgN1i9sc2X3vhGs3RHGjaumVk1hNXuSrULO8hTeGRKxm/0ul2z3/6XhNGEYHc7b1aRtnDlvoPjyYSh0b5JDLRnBfUk+pWbHhQGe0HEoe8luJeTLBnqwZi2x52yTaKhcd+sunBFeV2gbp3Pbt2Yu+O7ukIA4IoBdF7SlEh6o1jSjNrhffFxthmPgrH9AkMkSBjBre6xr6TeYcpOq4Z5QsPT+LxW9h6QTym3Ko//e3ipstzTSixEdjkfPaJF4r7iacwODMY371MgB7uNKgh+jNGU7XwGAfDFBn4v7Fmw4960iuf/cH7Uv7PVCqSZPD7EDjFpH0xGexO1wXKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDf5xOLYNDJ+Veig/aqvuntMCoEW9iQVxvJbQhh7CEk=;
 b=KAVegLDXmuyX3OHuNmCYFmyOluyVBPpESog69uM2MD9pRHM4Zk586kBBVGbUDkCmCryjnmJONAAxBEh+J/fYFRgtuUttPPzpJ+/bjAilsrC4lnU6znFoNiApC+++nrcKPuLwTfHaDv5ViyqSVYHmbxvzNfhzk2wO4RguQdvEgjLWwQ8VAnf2DFENRZ32FDKUkPLQOqPqQ2vrV5Y+L1VfVgXxiNofxljEtit2CKbHFENf1nz6f8I17DZYAerbYd8pevyRFw4+n4M54vLYHgM1xwFTGvwrSuGJAVOZX2pKOgLfF8urR3rQyQuYvX7SA6Ff/IUvaWL9BYG5CZ/Vg83TQw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Tue, 31 May
 2022 20:26:19 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854%3]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 20:26:18 +0000
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
Thread-Index: AQHYcP5BrBz66eonZEeOxjwIzt98aa0xHKkwgADjuYCAAFvfAIAHGkbQ
Date:   Tue, 31 May 2022 20:26:18 +0000
Message-ID: <PH0PR12MB54813940FE5AC483C4676F24DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEu1YenjBHAssP=FvKX6WxDQ5Aa50r-BsnkfR4zqNTk6hg@mail.gmail.com>
 <CAJaqyWfzoORc7V=xqdyLsdRPRYGNJBvWaPcZDhOb1vJWhbixoA@mail.gmail.com>
In-Reply-To: <CAJaqyWfzoORc7V=xqdyLsdRPRYGNJBvWaPcZDhOb1vJWhbixoA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24c60683-4034-418e-8ce4-08da4343d1d2
x-ms-traffictypediagnostic: MN2PR12MB4253:EE_
x-microsoft-antispam-prvs: <MN2PR12MB4253A9609CEC43B7E7DBF872DCDC9@MN2PR12MB4253.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7zxC4MDKHCsCUmi8aKffKapn7ivpdT5ILZSJW9qvvQMFhT6K5LQCznwXZMpHCdcXH3fRF8V5SWZFlb54c/z247GAcvTJZKwNG+uUVoN7dMCTXRWIvVpMAWWOtEAOo2248ftN6uqH0Tlcp7XjvxtoYrKLPL7JLYaqD9FYi9PUYpU2+D81CO9Yj9U+7hHwGKbtj39iJGyA4cSc9NpY96iai6S8t2hXbVdnRCLdFKVFFTaBFvYEjYM3Jl99a+cdhmrBbwrpHhbXkCNcodDf0wSjY8pZQFNc50/PJG47+lDAFOiN+nAq/JwF9DC+iwkYSo9vAM0j5E4mi+OEE74wyhUflRCk46pPSlP6XnQBQOZWpxzT1IybsjjA+v33/h12tHh39TCmMdJaObWuxLQfvSL1bRk4hezU9RmmMvN+VHlD7OUvKR6VfHWSQAcnfE3fn3EYTGrahNc+ytIWPJXf+gCYDBhwn1+twvNGYq0uLwCl2M0MTsrEIdvudoL9PUDR9u7hVAw7j0hExDOGCteLuluc/qV68pTL+ZDOWj0y97EC5NKuZUMexiKv1K0YsWlvKj8qFkqJakMk12s3GKBwwFKUXVQqbNO74z7d6VZbOrrtn/TNIRf+SVXlLfp0vKu9zIGQwf8pTypKcRTZsAl8O/SHW0N8867C5/RijsWmID3eMSVRsE+DfD6EeZ5tN8P0Dp1r4NOX5nCis3NGCAwWz8ou8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(186003)(38100700002)(71200400001)(122000001)(76116006)(64756008)(7416002)(4326008)(5660300002)(66556008)(7696005)(66946007)(66476007)(66446008)(66574015)(52536014)(83380400001)(8936002)(55016003)(316002)(9686003)(6916009)(2906002)(33656002)(54906003)(8676002)(53546011)(6506007)(508600001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkYzbk54RW9iSzJJcDFIMVZiKzJNQ3cya3paSGRNZlZ6THUxZjdaUWhpL1pa?=
 =?utf-8?B?UDRJTGJ2SmdxR3FOZmdEakNDcURFcGVUTzVtV0p2T2k5SHlTMnpRVHVkdnVp?=
 =?utf-8?B?NXBJV3FMMHBBZXY4N1lzY2syYkRtWnA1TkJwQmh6bFRNQXJyeG1VeWY5TDF3?=
 =?utf-8?B?eTBxNFlNUElhRnN4RERnOW1GQ0R1RWN0RzdXSkJ0Ry84VjJSSGtLaGZTVjkz?=
 =?utf-8?B?VmFxMDhweUtHWGphNFFEazVhbnJ4TGxVZ0NWUVlxUFJUcVZ6dzdIYmNpeXJL?=
 =?utf-8?B?RjdRTFhSSG81OXNTVWx2S3kxSGprNSt1REpOZXV0V1FlVVR6WWZpdXM3YzFn?=
 =?utf-8?B?ZXF6VGVlQnJ1K2hqWXROWjlYV0NzcU9mSk1NMXNTSlRDdmNZR05vSElFNzFx?=
 =?utf-8?B?NExxclN6aTN5ZHNYcEUrSkZLb25MN2VCa01kbWg2TmxLWFdlYjZETjc0VnVY?=
 =?utf-8?B?ZStxckl1YzQrcHV4R2ovNitabVFpakEzY3ErelJjd2NrZUhvTFF0RlBaUEhV?=
 =?utf-8?B?bm5TTmZpTzFZK0pnYUJSYlN4QnNlMEk3bFVzdDdGYlFoZlNKWnJoL00wWC9t?=
 =?utf-8?B?ajFXMXVRRjA4dUdBYWdMRms5WlFWNlN6OUY0VHc1VFZPM3g1QktaUzNEdkRk?=
 =?utf-8?B?dWJsY2MyVmRZUkRjTktYcVljM1Q3YWx5b1RvZkJUL2luUXpGWnd2OSsxU2Jz?=
 =?utf-8?B?elJxNEZMZjFLb2JEV1BIaHJxKzhxUW5WQTNzTW1hbUg4TWluaUF6NC9uVnhI?=
 =?utf-8?B?bDhmUkpXeEJnemdZUk8yamNnU24zekdsbVROeFZTM1poNys0Tm9BNTZKZlht?=
 =?utf-8?B?bGQzbzB5MGlPNXl5V1U3aWtpSlJSRHJ0MjVGa2FMKzljeVk2NXdmbHYrcUVy?=
 =?utf-8?B?SVdRSk1mMHEwb0ZYd3d3eVBXNXVOVWtxVFVOeEpBVmplR3ZhRXRwY200RW9W?=
 =?utf-8?B?Y1YzbWFFUUtKT25TMCt4MGdaNHh0bG1RSUd6Tm1xYzU2MUZMazJPY1RrWmsz?=
 =?utf-8?B?MWcxZlZ2bzFLa0x5aUtLck5JQVZDOElDbkdBTFZ4MFRKSUtQRTVYeHdqak5N?=
 =?utf-8?B?Z001MlIwMk41a3JQVmVmSDlpeldIWEc4MWEvSHZXam1UZHRFS3grVjE4M3B0?=
 =?utf-8?B?VTZxbHY4WUpMOFg0VEQ5cWJiTUJlSXZucDZRRHN4UmFXUVFNRmRBWFVlTHFw?=
 =?utf-8?B?ejlRZmVCaUY0b1ZFTTdWV0I4am5EUU5ScmlpOE43a1BzV3hkM1BHNlZRYXFH?=
 =?utf-8?B?SFdFYUE2VlZLQnpYS2NBaG1GWVZ5NEoyWDdKWnJCWm1XbGQvbDFqSHJ4Tllv?=
 =?utf-8?B?ZWxrd29VZnBCMktJM2VoTUpvVWNiZVE3NktlTy9sZVh2dlNqdnhhY0l2aWxu?=
 =?utf-8?B?TENJQnZzcFM3NEpVN2RhbXdNa2txekpNb0REUTRvWWw5eHA3V3liMWdxREF3?=
 =?utf-8?B?Q040R0U5WnQvWEFINThDRGUvZ0ZMaVIxWUVEU2diWUcwaUJHc3BiWUNQNkhS?=
 =?utf-8?B?OFpRQjJVTi9ZQjVoNDd4OWxNaTBzMzBJQnhIbkhja1pqVTFpRGRKWUxFV2tl?=
 =?utf-8?B?Qm5seERkU0RGNE9aMHNBMHkrRDRaM3Z3alZ2QVJjZmNic0NwYXZmY2g1bjlI?=
 =?utf-8?B?c0RjZWVFbzd0NllFSXRFNmRNNmNhc1dFOGZTNTZaMlA2NHVkejQ4dGpvQ2dL?=
 =?utf-8?B?RmFFcWIwOWZnWjZmaXp2M1huOE5Kb2sxNVVkZUlGSnhEY053ODF1RU9SWG5s?=
 =?utf-8?B?RFVUc2pRZEdxb0hENVdkM2lrdjRPZ1VEU2lpdDdRU1FNT1RvTmphZ3dRZnlh?=
 =?utf-8?B?aWRCdnU2KzUvT3J1SzgybFNmODhHQ3MvcWVUT1E4MXlGbTI3YmVhTWUrNFcr?=
 =?utf-8?B?OVZXYjl6dXREY3FBeXU4U0c4aDNGSVFCdEJ5SndZaGtFbzFQcnZMZ3BIRW10?=
 =?utf-8?B?YTEwbE5ZTkVFeVpYTzkyOW1BTGkrTU9xNnJNYVpiUTNSL2U1Q0JXWTFtQ253?=
 =?utf-8?B?QUhkQkUyVHQvelRVM25iZEpDTTNnSFNaWjlRQ01EZzFFZm5vZDJYMk1ZTGtV?=
 =?utf-8?B?UEttTHQ5a09BU1VjQWZKRFVEVE1Ndm96NUxEbWFJdnpIOUlPY1ZmRXZpdStO?=
 =?utf-8?B?YjZNL09VVWZpTURaNjFrWi9FUW9pV1JCanN3aURvNTVLYThmRGt3WG82cTEz?=
 =?utf-8?B?QVYxT3g5R0F1TEpjS0FYcUhwbFVUeTBXaDgyN1dGN01RZFBiNENNZlgyTEp6?=
 =?utf-8?B?WmxoN3lzQmVsYzl5TVpQY2N5Znl4MFZoUmlXREJwSE9EbzJMdGpFSWJiZ2M2?=
 =?utf-8?B?azE3OU5vUkpIYVhUYTVGU3NhTDlZVWxmb0U2YkxsQkEzSjBEcVRiUXQ0U2hF?=
 =?utf-8?Q?fIMLH5YGTD5G08zjn4ltspUkedXkjjGIudviRQkJsmvr/?=
x-ms-exchange-antispam-messagedata-1: IlLoACmmBOUstQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c60683-4034-418e-8ce4-08da4343d1d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2022 20:26:18.8296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d+rO0akrNPGks7q+ZesF56+L8o/QfC6PzpnK+tSFpB8pDXbugI4Zx1XJrcW93Op08FofzHJQzqkmfoRmBxZHZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253
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
IFNlbnQ6IEZyaWRheSwgTWF5IDI3LCAyMDIyIDM6NTUgQU0NCj4gDQo+IE9uIEZyaSwgTWF5IDI3
LCAyMDIyIGF0IDQ6MjYgQU0gSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4gd3JvdGU6
DQo+ID4NCj4gPiBPbiBUaHUsIE1heSAyNiwgMjAyMiBhdCA4OjU0IFBNIFBhcmF2IFBhbmRpdCA8
cGFyYXZAbnZpZGlhLmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4NCj4gPiA+DQo+ID4gPiA+IEZy
b206IEV1Z2VuaW8gUMOpcmV6IDxlcGVyZXptYUByZWRoYXQuY29tPg0KPiA+ID4gPiBTZW50OiBU
aHVyc2RheSwgTWF5IDI2LCAyMDIyIDg6NDQgQU0NCj4gPiA+DQo+ID4gPiA+IEltcGxlbWVudCBz
dG9wIG9wZXJhdGlvbiBmb3IgdmRwYV9zaW0gZGV2aWNlcywgc28gdmhvc3QtdmRwYSB3aWxsDQo+
ID4gPiA+IG9mZmVyDQo+ID4gPiA+DQo+ID4gPiA+IHRoYXQgYmFja2VuZCBmZWF0dXJlIGFuZCB1
c2Vyc3BhY2UgY2FuIGVmZmVjdGl2ZWx5IHN0b3AgdGhlIGRldmljZS4NCj4gPiA+ID4NCj4gPiA+
ID4NCj4gPiA+ID4NCj4gPiA+ID4gVGhpcyBpcyBhIG11c3QgYmVmb3JlIGdldCB2aXJ0cXVldWUg
aW5kZXhlcyAoYmFzZSkgZm9yIGxpdmUNCj4gPiA+ID4gbWlncmF0aW9uLA0KPiA+ID4gPg0KPiA+
ID4gPiBzaW5jZSB0aGUgZGV2aWNlIGNvdWxkIG1vZGlmeSB0aGVtIGFmdGVyIHVzZXJsYW5kIGdl
dHMgdGhlbS4gVGhlcmUNCj4gPiA+ID4gYXJlDQo+ID4gPiA+DQo+ID4gPiA+IGluZGl2aWR1YWwg
d2F5cyB0byBwZXJmb3JtIHRoYXQgYWN0aW9uIGZvciBzb21lIGRldmljZXMNCj4gPiA+ID4NCj4g
PiA+ID4gKFZIT1NUX05FVF9TRVRfQkFDS0VORCwgVkhPU1RfVlNPQ0tfU0VUX1JVTk5JTkcsIC4u
LikgYnV0DQo+IHRoZXJlDQo+ID4gPiA+IHdhcyBubw0KPiA+ID4gPg0KPiA+ID4gPiB3YXkgdG8g
cGVyZm9ybSBpdCBmb3IgYW55IHZob3N0IGRldmljZSAoYW5kLCBpbiBwYXJ0aWN1bGFyLCB2aG9z
dC12ZHBhKS4NCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gQWZ0ZXIgdGhlIHJl
dHVybiBvZiBpb2N0bCB3aXRoIHN0b3AgIT0gMCwgdGhlIGRldmljZSBNVVNUIGZpbmlzaA0KPiA+
ID4gPiBhbnkNCj4gPiA+ID4NCj4gPiA+ID4gcGVuZGluZyBvcGVyYXRpb25zIGxpa2UgaW4gZmxp
Z2h0IHJlcXVlc3RzLiBJdCBtdXN0IGFsc28gcHJlc2VydmUNCj4gPiA+ID4gYWxsDQo+ID4gPiA+
DQo+ID4gPiA+IHRoZSBuZWNlc3Nhcnkgc3RhdGUgKHRoZSB2aXJ0cXVldWUgdnJpbmcgYmFzZSBw
bHVzIHRoZSBwb3NzaWJsZQ0KPiA+ID4gPiBkZXZpY2UNCj4gPiA+ID4NCj4gPiA+ID4gc3BlY2lm
aWMgc3RhdGVzKSB0aGF0IGlzIHJlcXVpcmVkIGZvciByZXN0b3JpbmcgaW4gdGhlIGZ1dHVyZS4g
VGhlDQo+ID4gPiA+DQo+ID4gPiA+IGRldmljZSBtdXN0IG5vdCBjaGFuZ2UgaXRzIGNvbmZpZ3Vy
YXRpb24gYWZ0ZXIgdGhhdCBwb2ludC4NCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+
ID4gQWZ0ZXIgdGhlIHJldHVybiBvZiBpb2N0bCB3aXRoIHN0b3AgPT0gMCwgdGhlIGRldmljZSBj
YW4gY29udGludWUNCj4gPiA+ID4NCj4gPiA+ID4gcHJvY2Vzc2luZyBidWZmZXJzIGFzIGxvbmcg
YXMgdHlwaWNhbCBjb25kaXRpb25zIGFyZSBtZXQgKHZxIGlzDQo+ID4gPiA+IGVuYWJsZWQsDQo+
ID4gPiA+DQo+ID4gPiA+IERSSVZFUl9PSyBzdGF0dXMgYml0IGlzIGVuYWJsZWQsIGV0YykuDQo+
ID4gPg0KPiA+ID4gSnVzdCB0byBiZSBjbGVhciwgd2UgYXJlIGFkZGluZyB2ZHBhIGxldmVsIG5l
dyBpb2N0bCgpIHRoYXQgZG9lc27igJl0IG1hcCB0bw0KPiBhbnkgbWVjaGFuaXNtIGluIHRoZSB2
aXJ0aW8gc3BlYy4NCj4gPg0KPiA+IFdlIHRyeSB0byBwcm92aWRlIGZvcndhcmQgY29tcGF0aWJp
bGl0eSB0byBWSVJUSU9fQ09ORklHX1NfU1RPUC4gVGhhdA0KPiA+IG1lYW5zIGl0IGlzIGV4cGVj
dGVkIHRvIGltcGxlbWVudCBhdCBsZWFzdCBhIHN1YnNldCBvZg0KPiA+IFZJUlRJT19DT05GSUdf
U19TVE9QLg0KPiA+DQo+IA0KPiBBcHBlbmRpbmcgYSBsaW5rIHRvIHRoZSBwcm9wb3NhbCwganVz
dCBmb3IgcmVmZXJlbmNlIFsxXS4NCj4gDQo+ID4gPg0KPiA+ID4gV2h5IGNhbid0IHdlIHVzZSB0
aGlzIGlvY3RsKCkgdG8gaW5kaWNhdGUgZHJpdmVyIHRvIHN0YXJ0L3N0b3AgdGhlIGRldmljZQ0K
PiBpbnN0ZWFkIG9mIGRyaXZpbmcgaXQgdGhyb3VnaCB0aGUgZHJpdmVyX29rPw0KPiA+DQo+IA0K
PiBQYXJhdiwgSSdtIG5vdCBzdXJlIEkgZm9sbG93IHlvdSBoZXJlLg0KPiANCj4gQnkgdGhlIHBy
b3Bvc2FsLCB0aGUgcmVzdW1lIG9mIHRoZSBkZXZpY2UgaXMgKEZyb20gcWVtdSBQT1YpOg0KPiAx
LiBUbyBjb25maWd1cmUgYWxsIGRhdGEgdnFzIGFuZCBjdnEgKGFkZHIsIG51bSwgLi4uKSAyLiBU
byBlbmFibGUgb25seSBDVlEsIG5vdA0KPiBkYXRhIHZxcyAzLiBUbyBzZW5kIERSSVZFUl9PSyA0
LiBXYWl0IGZvciBhbGwgYnVmZmVycyBvZiBDVlEgdG8gYmUgdXNlZCA1LiBUbw0KPiBlbmFibGUg
YWxsIG90aGVycyBkYXRhIHZxcyAoaW5kaXZpZHVhbCBpb2N0bCBhdCB0aGUgbW9tZW50KQ0KPiAN
Cj4gV2hlcmUgY2FuIHdlIGZpdCB0aGUgcmVzdW1lIChhcyAic3RvcChmYWxzZSkiKSBoZXJlPyBJ
ZiB0aGUgZGV2aWNlIGlzIHN0b3BwZWQNCj4gKGFzIGlmIHdlIHNlbmQgc3RvcCh0cnVlKSBiZWZv
cmUgRFJJVkVSX09LKSwgd2UgZG9uJ3QgcmVhZCBDVlEgZmlyc3QuIElmIHdlDQo+IHNlbmQgaXQg
cmlnaHQgYWZ0ZXIgKG9yIGluc3RlYWQpIERSSVZFUl9PSywgZGF0YSBidWZmZXJzIGNhbiByZWFj
aCBkYXRhIHZxcw0KPiBiZWZvcmUgY29uZmlndXJpbmcgUlNTLg0KPiANCkl0IGRvZXNu4oCZdCBt
YWtlIHNlbnNlIHdpdGggY3VycmVudGx5IHByb3Bvc2VkIHdheSBvZiB1c2luZyBjdnEgdG8gcmVw
bGF5IHRoZSBjb25maWcuDQpOZWVkIHRvIGNvbnRpbnVlIHdpdGggY3VycmVudGx5IHByb3Bvc2Vk
IHRlbXBvcmFyeSBtZXRob2QgdGhhdCBzdWJzZXF1ZW50bHkgdG8gYmUgcmVwbGFjZWQgd2l0aCBv
cHRpbWl6ZWQgZmxvdyBhcyB3ZSBkaXNjdXNzZWQuDQo=
