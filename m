Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4871E53AD60
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 21:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiFATbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 15:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiFATb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 15:31:28 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2047.outbound.protection.outlook.com [40.107.236.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253E623B15C;
        Wed,  1 Jun 2022 12:30:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZUmJq+KzAKk6WsceR6byLtpxkPPkPVFTCVtbhxVBHCugGch71bf1A7V3zd05xeT3i48Do9yRpxjXv9rqxv1P2uuUrM3WIkOhd31OmgYxOCKelKUOEWK17XUEQBOQRsoeSC063hof5oETwR7oOtylBGeymr+ck/anNkjMuvc6cHDxc91BAJMqBjxnVwzaOHb32C/jJITYyU1vruDtRv0Skks14uvHZChAFvereXYkMNQ9xbtgJjQTDsG2f3Jpzk2fYH334DTxTCpFq8HxYV2+m+asHHx8e9aRWP587WO1mDxJDxTaVp1JMcblPz0wkM3ZTy3ABn95WYnwWot0Xjm6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUGdgS6YOb5R2KtjFfimDzKscFqbhlM6s4mFdzUi2ew=;
 b=aYzthLvcGcFlgihK6d1gZlKe+vNlquyEDbCUiYh4yACVBWHaMY8Mo6IaoV+66ZqUu25xDsvUtfn31GXwlNxCwHmyHTA05n261YtN/c/O1sECAbEh6rYKWqh6YZDRs6ThhfPCooD2mPNpSv8Se6v63v65MxFy0aqVvAxbrYJkpjubthdYPSoA8SeqaSWcex7MaIeSeuamGDo+oWH0EyfJgAcwFcNRqQn2CKLE8i3m4OZNG5Ys77qic1k6NzHWkIqTTo3ejPNUKkbVM4z2lpgxlQOF9qjnFefu3LdEqgofk1Eoqf40z54UItpdBYepj8aCLFTxZwYXljsI4XzA2vwoIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUGdgS6YOb5R2KtjFfimDzKscFqbhlM6s4mFdzUi2ew=;
 b=jjs5UOSbzMdfHvpxYA2/OVWJr7TIOMQrItyHCBvsgx02EdIYl6cUrxMvmh44ydqqLhUwSbn8NwiS5JOP8/UMY7Z+Exp3mduh18IKMKcp9fcCwwrVypPRSf1EJHjO1fAjX+KFxiN3AU+cSalcEnXNJXySd+UMj0feRoCotDYaOiNbaqbNTB4IaWnjsBZBqCHfLY0PwogBSQ0aFaCdpyHDSxf18ccKtubeY41UhPTxIegfJNrYewMEeI7dwvxNADBKiLjWWjHzftn+GUf0Gna+sDyVAJeHrmrEiV2M941VkeP/IAXTZCBRfBtK5huQ8uKpkfJjBcTvs3SBiXSqAsO8gw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MN2PR12MB3422.namprd12.prod.outlook.com (2603:10b6:208:ce::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.18; Wed, 1 Jun
 2022 19:13:44 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854%3]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 19:13:44 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Martin Porter <martinpo@xilinx.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Cindy Lu <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: RE: [PATCH v4 3/4] vhost-vdpa: uAPI to stop the device
Thread-Topic: [PATCH v4 3/4] vhost-vdpa: uAPI to stop the device
Thread-Index: AQHYcP5Qf4lW3kaa0E617S417Ydfxa06bIgAgAADLwCAAHvukA==
Date:   Wed, 1 Jun 2022 19:13:43 +0000
Message-ID: <PH0PR12MB54819A5DC204CED360C3BA86DCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <20220526124338.36247-4-eperezma@redhat.com>
 <20220601070303-mutt-send-email-mst@kernel.org>
 <CAJaqyWcK7CwWLr5unxXr=FDbuufeA38X0eAboJy8yKLcsdiPow@mail.gmail.com>
In-Reply-To: <CAJaqyWcK7CwWLr5unxXr=FDbuufeA38X0eAboJy8yKLcsdiPow@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6250a9a3-216d-4174-51e0-08da4402d88c
x-ms-traffictypediagnostic: MN2PR12MB3422:EE_
x-microsoft-antispam-prvs: <MN2PR12MB3422A21E2A2E51B136814508DCDF9@MN2PR12MB3422.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTjD+EdKkw7pOkvqkZckQjSU+AKWiBwemwXKMbez4z/dqEIHSIiDJP/7xbgKdNFTLx1uv3YLLw6vNqIEdQa8fEo309fXZw/xdhtZ5p4p7VMPKtDTX/DeKs2F82gNWqm4YnMNOjWbHwIlU3TcFiEtdGDaSqIxqPViFHT2vp6RWnWhFs7QA73IEjSyWQ8Cgxy7Nh73YHxYikZkC6xmunfWpnvRNlv5hiDS8SntkaYdTIbYctMSxTMNRWFYnynsBG4t8LEKWEXT6HyrUh4mZo3bA+/X25A+mykdIrbOlnwkx0E87nfcdJCCLtu1I/ctk1pO14hUSGnwQylRmg0+keyeLi0ryYRURwBVYcsJZ1WhgVXeNl+rM8/MigV5SxXSrwlp3c8kbWrcoK1lGCk7rPt1s4VBk/m9OdBleHR9Tiy2iys+pRlgq5XL4rVYZN2YJb4z1Xb0w446jqKsL0TNQh/JJ5tWjOitO+N6R7gNDLClM/QQLpLQk7NCITUzrc1fo48a+Y3nWKjch4+SO6/K45Egkuvi4LmdVR37W1UDJIK0m1TM3qnSNhupdRftaKHGQ0gzMKZcxFJQUYzVnO9ccuSkakjzjewiO0SSeQ8qXCmabRM2q2rjnU3In6RPjfCFluZ+B8ITGutkaxR79/MMAK94ag0g3aYuXjOofIzgf7YCooJXFkNTS1m6i24tEBWwx6pU6Qb7XX1c7/B+sHntWy9jVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(52536014)(6506007)(7696005)(66574015)(38070700005)(86362001)(2906002)(53546011)(4326008)(38100700002)(110136005)(54906003)(8676002)(64756008)(66556008)(66946007)(66446008)(76116006)(71200400001)(55016003)(7416002)(316002)(83380400001)(9686003)(186003)(508600001)(8936002)(122000001)(33656002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEVnZXZCSitzVFVycXJaM1EveTN1bVZYRjJPMjB6aDU2UGlXdlF0OFFtdC8x?=
 =?utf-8?B?elV0VGRJU1JhMUZReGhsR3dGMGl3bVg4Mk1xNEQzV3hTKzA5SGlDNVdvMVZG?=
 =?utf-8?B?ZHdxVUxVaTVxanpCMG9FY1FpeDlqMHlRMnl3NEMzWWlGWExPK1FWck5RNnZr?=
 =?utf-8?B?Z29oc2YwcUw3dENyalpVTVB2dFMwSVBSSXhkcFllZXV5NUhvc2g5V0pRaWwr?=
 =?utf-8?B?dG1aQ0Y4anlNVElZVUIwclhXSCtsNUxvcmRRb01rZW1yUFk1Q3FacUNSZXcy?=
 =?utf-8?B?TmZBZkRRQk4zd2YvOFFSVDdDNm82REFWQkl4WlNwYjZvL0Y0WjVPdXZuWVJQ?=
 =?utf-8?B?WTBBTU9ESklyRmducFpvUWx5Tk8xWS9BeWF6ck1QK2UwWmhqeDFLY0krYkRC?=
 =?utf-8?B?TFpUVnpQZUlTOUkzZkt2Z1o0MU92NDM1UjlqK1NIR280T1hoSWtyTmh0L21n?=
 =?utf-8?B?cDVNc1h3bnp6OWYzUUNSbzZBVW9YRmUrU0hmbkZlOHVtT09jem1iZjF6dkdS?=
 =?utf-8?B?dlp3dWpXM1ZURnQ1NmY2WXZUcVI0enlENitSdE9WVVhXU2VFZXB1V1VCNEMw?=
 =?utf-8?B?dkYvcTZpRVIxTit6WXVTSHJ0Z0dEL1NCM1BpajI1T0lXN1dPakVBeHM2WjFI?=
 =?utf-8?B?WlpQdUJaQWpQbHNFb0JHWmdYc0RaOVJaSXlEdFVjTXhVT1E0SnFHM0F2d1ZC?=
 =?utf-8?B?enVqTlI1SkY4UEtjMFF3SGZUWDRIZ0UxZ3lRUVRQOVRQWFJYRHg2TWphb1Vm?=
 =?utf-8?B?RW0vaTFhY0VRbUdMNWQwMG9GYS95S3ZvTFNwc0kzZG8wek5OaERsMGFuY0cz?=
 =?utf-8?B?OW01eHF6VVBTeWtPSHYrZ3pXaWU2bUpBRFNqZHZxR3Z3b01xS21iSnJQUy93?=
 =?utf-8?B?b3BiSGc4dTh6cDJpWXNzcGlzdmx3OHhJV3pGN053K0kzQVFKQlJwVTJaNjJW?=
 =?utf-8?B?NUJNSUlZYndhVDJ0bFAxYkUrRU43Nm14VkdBNUhYUWtYZFE2OUk0dkw2ZFdN?=
 =?utf-8?B?R3EwUUsyZFlndnc3eUdmQUZ0T0luc0NNbzhrNjRWa1BMcW1nQ3dkc3QyZ1U3?=
 =?utf-8?B?Z21XczNKbzZSczNweStYaTVnY2tveTBRMFB4Z1I5OTY2aSsvblgyMm9OZTNT?=
 =?utf-8?B?clMrenY5a29FQnQ0V3o1MnNIa3hlMlBMMVpsZWxJS1g1d3o1akU0UC9FdGxC?=
 =?utf-8?B?Ulp0NVI3eUtPeFdoTVBQRjFoNk1VdzF6NHdlR0FtQU1SRHJGSjQ4MUZPYWhJ?=
 =?utf-8?B?WEc3VUYwWG9wdmorelpNNzdST29yWHhZaUpyT2JHL2dQQ1NOMTBESHd6UU5k?=
 =?utf-8?B?L2NzUXdnQ25yQ2tJd0M1bzVqemJjY0xhZWJRcTFkeUEyMENkNXFlNWhrWjB1?=
 =?utf-8?B?NzdWMnI5M3NhanZjR2FkcWVCazNjUkc0OTc4dzMvcjl6bEdNRkF3RFcveDJo?=
 =?utf-8?B?emwrRWY3SmRYNFRsUUk4MlZseERCWnkyVVlHclJMMzA4bU5rSXlTTlkyVk13?=
 =?utf-8?B?empuQ2dacTRaWXUrd2QzS0tKL0dhbzBiTy9haDRHQkpHVUpmUmF0Mm81Szg0?=
 =?utf-8?B?Q3plZXBNcVVzMU4xMEg0eTIwd3FIZ0RYcmQyRXR3RHpuNC9BNm9aMzZzZkc3?=
 =?utf-8?B?Nm4yV081TTA3NGhQWjlWT2tYS2M5S0U3QVlkRFltZUpMQ3ZxcFM3OGhDaXVq?=
 =?utf-8?B?eW1JdnlXUmxqT1lhYjhnaUtCb1FoRGdRTzU0SWpUd1hvUkFnb2tvVXk0VE9j?=
 =?utf-8?B?eW1ORUFuTXUySi9WaEthOWJuVGg1d0ZRRFdOT1ZDek9aUlFkZEd1U3p5elBK?=
 =?utf-8?B?S0tlcHhsendBNVBJeUhjLzIvRmpHTVdUQnlxZmVIRHVweVJiT1l4L2w0L2Jo?=
 =?utf-8?B?WmxLY3ZEd3FNZWxCWmRrWm52Q2tQNEZjT0c5cW44bmhDLzdtWGh5LytGTVRs?=
 =?utf-8?B?d2RYVTlzRWh6RzhQZEVjdTlnR0FHbGJ1Mll0d0txcjJlNlpybHV5Njd2N0Nh?=
 =?utf-8?B?SWs0SVhJWC9jMnhKMTRxbFJJcTB4Z3RwSGl3Tll6WjNGbHpGeVZwTWl3OTM1?=
 =?utf-8?B?NjFNUlQwOFdNWjVDeVB1NG5uYUo3QzlRVjNzZ0cxTktDS1VIbVhmRVV3SVhB?=
 =?utf-8?B?SGlpYU1EWG95TVF3REwzcUZmL1VlaEdoUXFvWUtuWXlURzJqb05UVHFieWwz?=
 =?utf-8?B?MTV3ZUdXdDZqZktscEI3WDE4WkdpSEFqZ2FkTHZkZURWaVBkS1J6RzR6QWE3?=
 =?utf-8?B?dXQwSmJXSFkzTVRjWVA3VWV5aGpzcC9CTDgrWUp5Vnd1R2NZSk4xcjZibGpo?=
 =?utf-8?B?cjBwRTd4MXdzTHNzWVROODdxdGpyNjQyZ2NXQnc4RG1nS1ZVa2lhbGVPZU1U?=
 =?utf-8?Q?e8LbXWw5BYVQTPn15CBV4nJQYmwoYb1fu2JLwDkAlONmQ?=
x-ms-exchange-antispam-messagedata-1: YGg+AxM5gXBnjw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6250a9a3-216d-4174-51e0-08da4402d88c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2022 19:13:43.9732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H+R4wngvdtgy/bMlWy5tFJfdTiGMBK6OHN1GuM7/y3qH4sT1zulcGgmvS9PjuQmuEnKpurY4nRd6CyyXDXQ+lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3422
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
IFNlbnQ6IFdlZG5lc2RheSwgSnVuZSAxLCAyMDIyIDc6MTUgQU0NCj4gDQo+IE9uIFdlZCwgSnVu
IDEsIDIwMjIgYXQgMTowMyBQTSBNaWNoYWVsIFMuIFRzaXJraW4gPG1zdEByZWRoYXQuY29tPiB3
cm90ZToNCj4gPg0KPiA+IE9uIFRodSwgTWF5IDI2LCAyMDIyIGF0IDAyOjQzOjM3UE0gKzAyMDAs
IEV1Z2VuaW8gUMOpcmV6IHdyb3RlOg0KPiA+ID4gVGhlIGlvY3RsIGFkZHMgc3VwcG9ydCBmb3Ig
c3RvcCB0aGUgZGV2aWNlIGZyb20gdXNlcnNwYWNlLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IEV1Z2VuaW8gUMOpcmV6IDxlcGVyZXptYUByZWRoYXQuY29tPg0KPiA+ID4gLS0tDQo+ID4g
PiAgZHJpdmVycy92aG9zdC92ZHBhLmMgICAgICAgfCAxOCArKysrKysrKysrKysrKysrKysNCj4g
PiA+ICBpbmNsdWRlL3VhcGkvbGludXgvdmhvc3QuaCB8IDE0ICsrKysrKysrKysrKysrDQo+ID4g
PiAgMiBmaWxlcyBjaGFuZ2VkLCAzMiBpbnNlcnRpb25zKCspDQo+ID4gPg0KPiA+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jIGIvZHJpdmVycy92aG9zdC92ZHBhLmMgaW5kZXgN
Cj4gPiA+IDMyNzEzZGI1ODMxZC4uZDFkMTk1NTVjNGI3IDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJp
dmVycy92aG9zdC92ZHBhLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvdmhvc3QvdmRwYS5jDQo+ID4g
PiBAQCAtNDc4LDYgKzQ3OCwyMSBAQCBzdGF0aWMgbG9uZyB2aG9zdF92ZHBhX2dldF92cXNfY291
bnQoc3RydWN0DQo+IHZob3N0X3ZkcGEgKnYsIHUzMiBfX3VzZXIgKmFyZ3ApDQo+ID4gPiAgICAg
ICByZXR1cm4gMDsNCj4gPiA+ICB9DQo+ID4gPg0KPiA+ID4gK3N0YXRpYyBsb25nIHZob3N0X3Zk
cGFfc3RvcChzdHJ1Y3Qgdmhvc3RfdmRwYSAqdiwgdTMyIF9fdXNlciAqYXJncCkNCj4gPiA+ICt7
DQo+ID4gPiArICAgICBzdHJ1Y3QgdmRwYV9kZXZpY2UgKnZkcGEgPSB2LT52ZHBhOw0KPiA+ID4g
KyAgICAgY29uc3Qgc3RydWN0IHZkcGFfY29uZmlnX29wcyAqb3BzID0gdmRwYS0+Y29uZmlnOw0K
PiA+ID4gKyAgICAgaW50IHN0b3A7DQo+ID4gPiArDQo+ID4gPiArICAgICBpZiAoIW9wcy0+c3Rv
cCkNCj4gPiA+ICsgICAgICAgICAgICAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiA+ID4gKw0KPiA+
ID4gKyAgICAgaWYgKGNvcHlfZnJvbV91c2VyKCZzdG9wLCBhcmdwLCBzaXplb2Yoc3RvcCkpKQ0K
PiA+ID4gKyAgICAgICAgICAgICByZXR1cm4gLUVGQVVMVDsNCj4gPiA+ICsNCj4gPiA+ICsgICAg
IHJldHVybiBvcHMtPnN0b3AodmRwYSwgc3RvcCk7DQo+ID4gPiArfQ0KPiA+ID4gKw0KPiA+ID4g
IHN0YXRpYyBsb25nIHZob3N0X3ZkcGFfdnJpbmdfaW9jdGwoc3RydWN0IHZob3N0X3ZkcGEgKnYs
IHVuc2lnbmVkIGludA0KPiBjbWQsDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB2b2lkIF9fdXNlciAqYXJncCkgIHsgQEAgLTY1MCw2DQo+ID4gPiArNjY1LDkgQEAgc3Rh
dGljIGxvbmcgdmhvc3RfdmRwYV91bmxvY2tlZF9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAsDQo+
ID4gPiAgICAgICBjYXNlIFZIT1NUX1ZEUEFfR0VUX1ZRU19DT1VOVDoNCj4gPiA+ICAgICAgICAg
ICAgICAgciA9IHZob3N0X3ZkcGFfZ2V0X3Zxc19jb3VudCh2LCBhcmdwKTsNCj4gPiA+ICAgICAg
ICAgICAgICAgYnJlYWs7DQo+ID4gPiArICAgICBjYXNlIFZIT1NUX1ZEUEFfU1RPUDoNCj4gPiA+
ICsgICAgICAgICAgICAgciA9IHZob3N0X3ZkcGFfc3RvcCh2LCBhcmdwKTsNCj4gPiA+ICsgICAg
ICAgICAgICAgYnJlYWs7DQo+ID4gPiAgICAgICBkZWZhdWx0Og0KPiA+ID4gICAgICAgICAgICAg
ICByID0gdmhvc3RfZGV2X2lvY3RsKCZ2LT52ZGV2LCBjbWQsIGFyZ3ApOw0KPiA+ID4gICAgICAg
ICAgICAgICBpZiAociA9PSAtRU5PSU9DVExDTUQpIGRpZmYgLS1naXQNCj4gPiA+IGEvaW5jbHVk
ZS91YXBpL2xpbnV4L3Zob3N0LmggYi9pbmNsdWRlL3VhcGkvbGludXgvdmhvc3QuaCBpbmRleA0K
PiA+ID4gY2FiNjQ1ZDRhNjQ1Li5jN2U0N2IyOWJmNjEgMTAwNjQ0DQo+ID4gPiAtLS0gYS9pbmNs
dWRlL3VhcGkvbGludXgvdmhvc3QuaA0KPiA+ID4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L3Zo
b3N0LmgNCj4gPiA+IEBAIC0xNzEsNCArMTcxLDE4IEBADQo+ID4gPiAgI2RlZmluZSBWSE9TVF9W
RFBBX1NFVF9HUk9VUF9BU0lEICAgIF9JT1coVkhPU1RfVklSVElPLCAweDdDLA0KPiBcDQo+ID4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHZob3N0
X3ZyaW5nX3N0YXRlKQ0KPiA+ID4NCj4gPiA+ICsvKiBTdG9wIG9yIHJlc3VtZSBhIGRldmljZSBz
byBpdCBkb2VzIG5vdCBwcm9jZXNzIHZpcnRxdWV1ZQ0KPiA+ID4gK3JlcXVlc3RzIGFueW1vcmUN
Cj4gPiA+ICsgKg0KPiA+ID4gKyAqIEFmdGVyIHRoZSByZXR1cm4gb2YgaW9jdGwgd2l0aCBzdG9w
ICE9IDAsIHRoZSBkZXZpY2UgbXVzdCBmaW5pc2gNCj4gPiA+ICthbnkNCj4gPiA+ICsgKiBwZW5k
aW5nIG9wZXJhdGlvbnMgbGlrZSBpbiBmbGlnaHQgcmVxdWVzdHMuIEl0IG11c3QgYWxzbw0KPiA+
ID4gK3ByZXNlcnZlIGFsbA0KPiA+ID4gKyAqIHRoZSBuZWNlc3Nhcnkgc3RhdGUgKHRoZSB2aXJ0
cXVldWUgdnJpbmcgYmFzZSBwbHVzIHRoZSBwb3NzaWJsZQ0KPiA+ID4gK2RldmljZQ0KPiA+ID4g
KyAqIHNwZWNpZmljIHN0YXRlcykgdGhhdCBpcyByZXF1aXJlZCBmb3IgcmVzdG9yaW5nIGluIHRo
ZSBmdXR1cmUuDQo+ID4gPiArVGhlDQo+ID4gPiArICogZGV2aWNlIG11c3Qgbm90IGNoYW5nZSBp
dHMgY29uZmlndXJhdGlvbiBhZnRlciB0aGF0IHBvaW50Lg0KPiA+ID4gKyAqDQo+ID4gPiArICog
QWZ0ZXIgdGhlIHJldHVybiBvZiBpb2N0bCB3aXRoIHN0b3AgPT0gMCwgdGhlIGRldmljZSBjYW4N
Cj4gPiA+ICtjb250aW51ZQ0KPiA+ID4gKyAqIHByb2Nlc3NpbmcgYnVmZmVycyBhcyBsb25nIGFz
IHR5cGljYWwgY29uZGl0aW9ucyBhcmUgbWV0ICh2cSBpcw0KPiA+ID4gK2VuYWJsZWQsDQo+ID4g
PiArICogRFJJVkVSX09LIHN0YXR1cyBiaXQgaXMgZW5hYmxlZCwgZXRjKS4NCj4gPiA+ICsgKi8N
Cj4gPiA+ICsjZGVmaW5lIFZIT1NUX1ZEUEFfU1RPUCAgICAgICAgICAgICAgICAgICAgICBfSU9X
KFZIT1NUX1ZJUlRJTywgMHg3RCwgaW50KQ0KPiA+ID4gKw0KQSBiZXR0ZXIgbmFtZSBpcyBWSE9T
VF9WRFBBX1NFVF9TVEFURQ0KU3RhdGUgPSBzdG9wL3N1c3BlbmQNClN0YXRlID0gc3RhcnQvcmVz
dW1lDQoNClN1c3BlbmQvcmVzdW1lIHNlZW1zIG1vcmUgbG9naWNhbCwgYXMgb3Bwb3NlZCBzdGFy
dC9zdG9wLCBiZWNhdXNlIGl0IG1vcmUgY2xlYXJseSBpbmRpY2F0ZXMgdGhhdCB0aGUgcmVzdW1l
IChzdGFydCkgaXMgZnJvbSBzb21lIHByb2dyYW1tZWQgYmVnaW5uaW5nIChhbmQgbm90IGZpcnN0
IGJvb3QpLg0KDQo+ID4gPiAgI2VuZGlmDQo+ID4NCj4gPiBJIHdvbmRlciBob3cgZG9lcyB0aGlz
IGludGVyYWN0IHdpdGggdGhlIGFkbWluIHZxIGlkZWEuDQo+ID4gSS5lLiBpZiB3ZSBzdG9wIGFs
bCBWUXMgdGhlbiBhcHBhcmVudGx5IGFkbWluIHZxIGNhbid0IHdvcmsgZWl0aGVyIC4uLg0KPiA+
IFRob3VnaHRzPw0KPiA+DQo+IA0KPiBDb3B5aW5nIGhlcmUgdGhlIGFuc3dlciB0byBQYXJhdiwg
ZmVlbCBmcmVlIHRvIGFuc3dlciB0byBhbnkgdGhyZWFkIG9yDQo+IGhpZ2hsaWdodCBpZiBJIG1p
c3NlZCBzb21ldGhpbmcgOikuIFVzaW5nIHRoZSBhZG1pbiB2cSBwcm9wb3NhbCB0ZXJtaW5vbG9n
eSBvZg0KPiAiZGV2aWNlIGdyb3VwIi4NCj4gDQo+IC0tDQo+IFRoaXMgd291bGQgc3RvcCBhIGRl
dmljZSBvZiBhIGRldmljZQ0KPiBncm91cCwgYnV0IG5vdCB0aGUgd2hvbGUgdmlydHF1ZXVlIGdy
b3VwLiBJZiB0aGUgYWRtaW4gVlEgaXMgb2ZmZXJlZCBieSB0aGUNCj4gUEYgKHNpbmNlIGl0J3Mg
bm90IGV4cG9zZWQgdG8gdGhlIGd1ZXN0KSwgaXQgd2lsbCBjb250aW51ZSBhY2NlcHRpbmcgcmVx
dWVzdHMgYXMNCj4gbm9ybWFsLiBJZiBpdCdzIGV4cG9zZWQgaW4gdGhlIFZGLCBJIHRoaW5rIHRo
ZSBiZXN0IGJldCBpcyB0byBzaGFkb3cgaXQsIHNpbmNlDQo+IGd1ZXN0IGFuZCBob3N0IHJlcXVl
c3RzIGNvdWxkIGNvbmZsaWN0Lg0KPiANCg0Kdmhvc3QtdmRwYSBkZXZpY2UgaXMgZXhwb3NlZCBm
b3IgYSBWRiB0aHJvdWdoIHZwLXZkcGEgZHJpdmVyIHRvIHVzZXIgbGFuZC4NCk5vdyB2cC12ZHBh
IGRyaXZlciB3aWxsIGhhdmUgdG8gY2hvb3NlIGJldHdlZW4gdXNpbmcgY29uZmlnIHJlZ2lzdGVy
IHZzIHVzaW5nIEFRIHRvIHN1c3BlbmQvcmVzdW1lIHRoZSBkZXZpY2UuDQoNCldoeSBub3QgYWx3
YXlzIGJlZ2luIHdpdGggbW9yZSBzdXBlcmlvciBpbnRlcmZhY2Ugb2YgQVEgdGhhdCBhZGRyZXNz
IG11bHRpcGxlIG9mIHRoZXNlIG5lZWRzIGZvciBMTSBjYXNlPw0KDQpGb3IgTE0gY2FzZSwgbW9y
ZSB5b3UgZXhwbG9yZSwgd2UgcmVhbGl6ZSB0aGF0IGVpdGhlciBWRiByZWx5aW5nIG9uIFBGJ3Mg
QVEgZm9yIHF1ZXJ5L2NvbmZpZy9zZXR1cC9yZXN0b3JlIG1ha2VzIG1vcmUgc2Vuc2Ugb3IgaGF2
ZSBpdHMgb3duIGRlZGljYXRlZCBBUS4NCg0KVk0ncyBzdXNwZW5kL3Jlc3VtZSBvcGVyYXRpb24g
Y2FuIGJlIGhhbmRsZWQgdGhyb3VnaCB0aGUgc2hhZG93IFEuDQoNCj4gU2luY2UgdGhpcyBpcyBv
ZmZlcmVkIHRocm91Z2ggdmRwYSwgdGhlIGRldmljZSBiYWNrZW5kIGRyaXZlciBjYW4gcm91dGUg
aXQgdG8NCj4gd2hhdGV2ZXIgbWV0aG9kIHdvcmtzIGJldHRlciBmb3IgdGhlIGhhcmR3YXJlLiBG
b3IgZXhhbXBsZSwgdG8gc2VuZCBhbg0KPiBhZG1pbiB2cSBjb21tYW5kIHRvIHRoZSBQRi4gVGhh
dCdzIHdoeSBpdCdzIGltcG9ydGFudCB0byBrZWVwIHRoZSBmZWF0dXJlDQo+IGFzIHNlbGYtY29u
dGFpbmVkIGFuZCBvcnRob2dvbmFsIHRvIG90aGVycyBhcyBwb3NzaWJsZS4NCj4gLS0NCj4gDQo+
ID4gPiAtLQ0KPiA+ID4gMi4zMS4xDQo+ID4NCg0K
