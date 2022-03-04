Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3324CDB43
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240956AbiCDRtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiCDRs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:48:58 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE493F8B4;
        Fri,  4 Mar 2022 09:48:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhrGaQPTtf8omxXaCQDEEnORSQhntNbh1xyugbIJWb9oVVGbMNjwwPIX9d9rF1lP7297HA5knszdZxWQv3iqgyKi6MkTEiuRibXzDzFZe/byLFaIweGYYscbdb8aH30jWzovMqR83mJCwd/DYee4MlAUoUrRNkcf0HBYdTVd11+WXwZkuNJ39wBw3XuNYYawfzHflccG0JXSvrhRrhonU965RGetvVORGR45f896rKZjaMiBuHZ1oXSdcVrzrL5wZlnzfxpHmukXE0CmgobWCtwAIXKJ3rrBKYsAX2Vl9YlCj3a3q59YV+fy6SGACvzASLxIkXqiDiBq4EcC+DUkxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cBFLgDjGTH9JmvWmidbym4a0JAbK135/UKow3jv2yk=;
 b=gxLRUU91weQ0eR+4QKoS78XdYsvCICdM8DxLs6227rYls0TipQY8tkB8SjoTARjBoQR4dXDQr22n8ZPlXnrfmLrPQwOp2Sa5HFY1v+J/OiTDDxsVe7uYCDqAprWK4va8U5RCbHKOr0CQJ3JKovrkE/FBy6TjU87Tl0IHa41wM6/5eJWlpwDa89+EUsNfAUwhUmr7X/Ir+5U9opa6QlBE5ez41gJbqXUoMETcTJtbaUG/0gk0hXqhpO8lfdrqmhv/d/0sV3nJx0zbETzT6zD8Bo3SK09P4otbjd+vcx/2AT0uc7196iOmoRFQiXiNlWCvQD4hKCyGbaHVcQ1erqWWWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cBFLgDjGTH9JmvWmidbym4a0JAbK135/UKow3jv2yk=;
 b=belu9NVY6aUT9EXkHbY4JBVrLvKgqGnk8x/aHwE41buuojdbnU2EC41zx5KTNkqlWisNAyg2tVLKKJZUkb04eyp3uVlPV3ByPu6a22IAKTJVgNi6+7JjkoIo5oAr1lu5AA+z9p6Re4zv1WxMTxagzIqsmh5M1Nlx6BsdGdh1UHY=
Received: from BY5PR02MB6980.namprd02.prod.outlook.com (2603:10b6:a03:235::19)
 by DM6PR02MB6777.namprd02.prod.outlook.com (2603:10b6:5:210::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 17:48:04 +0000
Received: from BY5PR02MB6980.namprd02.prod.outlook.com
 ([fe80::ed57:1b66:1f0e:54bc]) by BY5PR02MB6980.namprd02.prod.outlook.com
 ([fe80::ed57:1b66:1f0e:54bc%7]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 17:48:04 +0000
From:   Gautam Dawar <gdawar@xilinx.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
CC:     Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Tanuj Murlidhar Kamde <tanujk@xilinx.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC PATCH v2 07/19] vdpa: introduce config operations for
 associating ASID to a virtqueue group
Thread-Topic: [RFC PATCH v2 07/19] vdpa: introduce config operations for
 associating ASID to a virtqueue group
Thread-Index: AQHYKcUXN1Yu2JcoGU2J8RpDZAmR5qyvCCiAgACEKxA=
Date:   Fri, 4 Mar 2022 17:48:04 +0000
Message-ID: <BY5PR02MB6980F29C0225A4C12371D147B1059@BY5PR02MB6980.namprd02.prod.outlook.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-8-gdawar@xilinx.com>
 <CAJaqyWcAT05-MtOZkyiyNezSzEEmyyDdps0aWm7PMuyS4jqNdA@mail.gmail.com>
In-Reply-To: <CAJaqyWcAT05-MtOZkyiyNezSzEEmyyDdps0aWm7PMuyS4jqNdA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c74093d-1c0e-447a-88c2-08d9fe07227c
x-ms-traffictypediagnostic: DM6PR02MB6777:EE_
x-microsoft-antispam-prvs: <DM6PR02MB67773BF33FC72F131D0801D1B1059@DM6PR02MB6777.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tPdxIIXoY1gtizguqu/GQpg584ed7C14X7mZfpbSRnqwXLrc/G9wx3KshgfbHIZaJ3Ce6eCzBDU2ums+wSqcWIpnQZIG+lWLkykgUrcYtt3ExBKSV/HKGfH5+aLQBTt4osWR2ncKeNLG88OJHVlCe9syLfWh/yxEyI/62dgdtoc9kEN20wQrx7uPbzTAbyVGraJZc/zvVY+dn/xmKAkQxAI7AW4240wae3LrodlBfpLaaGQYyOfb22kLjyb4Zfk4/8X/xON2qQZ3+GLNQNVCoFgnDCaelcKkQC2rozH3ZX8IT1g0IlUqkwJ2RqoqKa4L053haoCgCVOvEikM4Xd9uKj+qLGwUz5+4aYlfIpG3baWd7qAGs3PzAuGyh8xC/5Ylur6pdfIrItlIuD+XAU6FWzmsKe9jJ2YrhjVvt4b6iQOZBXiA9OCPK4iXcVrEhL4XsQ/MSFfyEncyAoqR83QGcyILJDZatZRriJU9eaMdqJnTEVunFZqLw6VdTGESyYI4CvEWI+020J+YqBsVlgH+fmHllf9A1ORDq3pmQV9Sxd2c/hXT368JWFSwaEEd4Rfeu6pxOpdlj+OB0FHEA+pXkg+b2ZPAxlDaTds+77cExJFBXfM/EQzsjzpcAwmkuS5uauB9+a2cdRPLoatbPpQaCNk0BtaaZ4lKL3acrRdx1BZNABpTmsr7EijaOdAY+UvKfMBR5U0nwscxj2amUU4vA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR02MB6980.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66446008)(83380400001)(55016003)(38070700005)(2906002)(86362001)(66556008)(66946007)(76116006)(52536014)(8676002)(64756008)(316002)(6506007)(122000001)(9686003)(5660300002)(4326008)(66476007)(53546011)(508600001)(26005)(186003)(71200400001)(7416002)(6916009)(54906003)(38100700002)(8936002)(33656002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmRvQm5hdVNMSm50b3ZmNFJRekY4SjFpKzZLZnlXellaRHBNdHdRQlhadFM4?=
 =?utf-8?B?M2NBUWVENDJvcGN1OGhtNFc0Y1ZHQUFHM2Iwak1Xb004N1lBUkxnSURiNUs4?=
 =?utf-8?B?QVQ5MndvT3htNTJENm9KNFcxK05PajZybG5Sd1JSLzhhSEgwcGdvWXJKS1RR?=
 =?utf-8?B?TjVvVnEvYndzRzlEUDB2QVUxSE43NHRhOE9NMDRxbFp6UnR6NFl3OEkwMEVS?=
 =?utf-8?B?Yk1LYmF3M1NlVWtyTnJwVlpBbko5QlNQUTZITXM1eHJPMkR1ekk4a3k0UU9D?=
 =?utf-8?B?UGRSM2hwZnp3VXJueHdOaUY3Tmw5eGJmbXBDendsc3RQKzBQUzZRWGhXb0pG?=
 =?utf-8?B?NHhBaGQ3bm5XSzFIZS9FSldsRko0YW5MZ21TViswcEZKK3NxNzQ5R2pMUEpj?=
 =?utf-8?B?UUorelV5M1JNeUJhcURuRmtibTFJbmVYYXYweUNMcVI1Yk12V3lrZENINjNH?=
 =?utf-8?B?WTNVOWNFb3JKSlpvN2JyQ3lXWm5ZWUttZmQ4MnhST2JaLytHangrd2w3alRK?=
 =?utf-8?B?azZIUDBvL0JOU0tZNHZWeXZndnNOaE54cUdsWER4S2pDamx1RHZ6TTlBeU1p?=
 =?utf-8?B?UTl1MkpSbTlhMUtMM2VqYlNiTHlCL3k0Y3VGTWh5Wkx1REZSUmVHNXRCcGJV?=
 =?utf-8?B?Uk52dHdBTk9sS1hFMjJiaDdxM29HOWNwR3N6aGpmTk41U2cyNmtkVDZoendK?=
 =?utf-8?B?VnRkbmZNMWt0K3F2OWlMQmI3ZjRKTjJPNzI4eU8zaTZiS1ZVaWlITWh4STND?=
 =?utf-8?B?ZHZ5S3d3NVlDVENsUjJkTWhselVMYkZPOWxwdFhUT1pWYXh5MC9LSW1ST3kv?=
 =?utf-8?B?SXpEdk1ZNDBJSXRScnFicjVudXZEaGFjbW96N1BFSFpDU2drd1VodENyRDhp?=
 =?utf-8?B?OStnakhmblp4QjU0S1dGeTgva1JjMzE4VC9mcnFyK0I3RzcyRXhOMEJpOE0z?=
 =?utf-8?B?Q2FQYm5FN1RYNmFKakRXR3BtRjBNa3Q1UE1MbDhCTDJLYytZQTJrMEdZemcy?=
 =?utf-8?B?T2dxK2hmVmZDWXBLSzlnbEExV3dCOEx0c0g2bTArZlg0STZ5Yzc4U0Q5NDl0?=
 =?utf-8?B?N1dBWXBrUjZreW9nVkVreUVsOXpIT2c1MFVzYnJic0hFQUl6c3NENTdjcVZw?=
 =?utf-8?B?ZktrWXZ0NmhLdkJ5K0pjM0s1eFc0VXZiZlVZT29lbEhkcFZSbmZnQktCRnY3?=
 =?utf-8?B?QWNmUENEaTVTdE1iWjVUUkZIckx0OXozTHF5NmtyVzRWOHNRb24zWm1JUFBx?=
 =?utf-8?B?cnVTbVJralUrMWFEa3NTU2RqR3c2VmxzQ0JycXAvcUJwY1BhWUNpTWZNcWkx?=
 =?utf-8?B?OW5uOE9SdkdVYS9UYkE3b2RCZzZRc1B2RHBsNjA1NmxTcEZobkZFZG5TR1Bz?=
 =?utf-8?B?YWpJNHAyamFhQUQwSG1NTTNsZm5xd2RpS0VubmJkOEN1VVdRVHVhQkJZYUhn?=
 =?utf-8?B?VHRMYTFjYVVtbFlwMVRQc3hzQ2g1OUtzc2lhajRCYU41b0RyZ1YyZkp4MUpO?=
 =?utf-8?B?THhFU1NPeWd2dHUzclFGZ0VkbjRCUG9zS0NwNGNuQzI3eXh1WFBnaW92MjFP?=
 =?utf-8?B?RWRzV05oWTl3bWZnb1NrSUo3WUl4RCt6bmhiUHBpN054cVAvcFQzSmJHVy9y?=
 =?utf-8?B?dXZZOUU0VXhCWmNrZnNGbGhJc2NyOFMweVhaZHZrdGZIcllzVXB3QnZBeXBw?=
 =?utf-8?B?UG16WWZ5dVJSOC83dURQUlNpdkJlMVBpOGFjQWFOZ2VvcUorYXVVUVEvZjZW?=
 =?utf-8?B?MVFZNVNOdy90VUtyUUExNmtTME9NSmY3Q0I2UmJSTHFWVDgrWUlqeTZIUnFB?=
 =?utf-8?B?ck1hUTdLdVgxT0c3NUhXWVViTDFtaWhab1E3Q1NkTVNtOUVncEpLejBEa3dN?=
 =?utf-8?B?VEY1MG5iengwVWVwc2lLTS9zMzJxUzFMQkpKc1l6NnlrK21xdzRBcWlCb1g0?=
 =?utf-8?B?ZGplempHNTlMKzdTbnBpMnhqL3kyNkNJS2xxYXo4TmliK3ZxbEIrQmFzVGx3?=
 =?utf-8?B?bmExRXdDWGNKdlo0UmE5eVpaRndjWHpKdXphMFlsZTEyT2t3VUcxMFVod0lu?=
 =?utf-8?B?eFNYQlF4TmV5RTJHQlkvOWVMZ3dmU0ZGV00vMFlIRjFoNW9BcTVhMU0zNnhT?=
 =?utf-8?B?TlNPdjFzdWdrVmFYbDdSdjBlaHM4WEpiR29vVVJRa1ZYRnQ3SDFJbzgyTjRu?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR02MB6980.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c74093d-1c0e-447a-88c2-08d9fe07227c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2022 17:48:04.3324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wE5tAcZFhQ7J9wGaLXr57DE43PnSJiZsvKoKolVVZ+vrPZX8ZBLGjoaGq7gqRpFkTcTAPbpQ8r/g2uQCIidceg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6777
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEV1Z2VuaW8gUGVyZXogTWFydGluIDxl
cGVyZXptYUByZWRoYXQuY29tPiANClNlbnQ6IEZyaWRheSwgTWFyY2ggNCwgMjAyMiAzOjI1IFBN
DQpUbzogR2F1dGFtIERhd2FyIDxnZGF3YXJAeGlsaW54LmNvbT4NCkNjOiBHYXV0YW0gRGF3YXIg
PGdkYXdhckB4aWxpbnguY29tPjsgTWFydGluIFBldHJ1cyBIdWJlcnR1cyBIYWJldHMgPG1hcnRp
bmhAeGlsaW54LmNvbT47IEhhcnByZWV0IFNpbmdoIEFuYW5kIDxoYW5hbmRAeGlsaW54LmNvbT47
IFRhbnVqIE11cmxpZGhhciBLYW1kZSA8dGFudWprQHhpbGlueC5jb20+OyBKYXNvbiBXYW5nIDxq
YXNvd2FuZ0ByZWRoYXQuY29tPjsgTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNvbT47
IFpodSBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT47IFN0ZWZhbm8gR2FyemFyZWxs
YSA8c2dhcnphcmVAcmVkaGF0LmNvbT47IFhpZSBZb25namkgPHhpZXlvbmdqaUBieXRlZGFuY2Uu
Y29tPjsgRWxpIENvaGVuIDxlbGljQG52aWRpYS5jb20+OyBTaS1XZWkgTGl1IDxzaS13ZWkubGl1
QG9yYWNsZS5jb20+OyBQYXJhdiBQYW5kaXQgPHBhcmF2QG52aWRpYS5jb20+OyBMb25ncGVuZyA8
bG9uZ3BlbmcyQGh1YXdlaS5jb20+OyB2aXJ0dWFsaXphdGlvbiA8dmlydHVhbGl6YXRpb25AbGlz
dHMubGludXgtZm91bmRhdGlvbi5vcmc+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBr
dm0gbGlzdCA8a3ZtQHZnZXIua2VybmVsLm9yZz47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNClN1
YmplY3Q6IFJlOiBbUkZDIFBBVENIIHYyIDA3LzE5XSB2ZHBhOiBpbnRyb2R1Y2UgY29uZmlnIG9w
ZXJhdGlvbnMgZm9yIGFzc29jaWF0aW5nIEFTSUQgdG8gYSB2aXJ0cXVldWUgZ3JvdXANCg0KT24g
VGh1LCBGZWIgMjQsIDIwMjIgYXQgMTA6MjUgUE0gR2F1dGFtIERhd2FyIDxnYXV0YW0uZGF3YXJA
eGlsaW54LmNvbT4gd3JvdGU6DQo+DQo+IFRoaXMgcGF0Y2ggaW50cm9kdWNlcyBhIG5ldyBidXMg
b3BlcmF0aW9uIHRvIGFsbG93IHRoZSB2RFBBIGJ1cyBkcml2ZXIgDQo+IHRvIGFzc29jaWF0ZSBh
biBBU0lEIHRvIGEgdmlydHF1ZXVlIGdyb3VwLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBX
YW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBHYXV0YW0gRGF3YXIg
PGdkYXdhckB4aWxpbnguY29tPg0KPiAtLS0NCj4gIGluY2x1ZGUvbGludXgvdmRwYS5oIHwgMTAg
KysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKykNCj4NCj4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdmRwYS5oIGIvaW5jbHVkZS9saW51eC92ZHBhLmggaW5k
ZXggDQo+IGRlMjJjYTFhOGVmMy4uNzM4Njg2MGMzOTk1IDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRl
L2xpbnV4L3ZkcGEuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L3ZkcGEuaA0KPiBAQCAtMjM5LDYg
KzIzOSwxMiBAQCBzdHJ1Y3QgdmRwYV9tYXBfZmlsZSB7DQo+ICAgKiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgQHZkZXY6IHZkcGEgZGV2aWNlDQo+ICAgKiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgUmV0dXJucyB0aGUgaW92YSByYW5nZSBzdXBwb3J0ZWQgYnkNCj4gICAqICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB0aGUgZGV2aWNlLg0KPiArICogQHNldF9ncm91cF9hc2lk
OiAgICAgICAgICAgIFNldCBhZGRyZXNzIHNwYWNlIGlkZW50aWZpZXIgZm9yIGENCj4gKyAqICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICB2aXJ0cXVldWUgZ3JvdXANCj4gKyAqICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBAdmRldjogdmRwYSBkZXZpY2UNCj4gKyAqICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBAZ3JvdXA6IHZpcnRxdWV1ZSBncm91cA0KPiArICogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIEBhc2lkOiBhZGRyZXNzIHNwYWNlIGlkIGZvciB0aGlzIGdyb3Vw
DQo+ICsgKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUmV0dXJucyBpbnRlZ2VyOiBzdWNj
ZXNzICgwKSBvciBlcnJvciAoPCAwKQ0KPiAgICogQHNldF9tYXA6ICAgICAgICAgICAgICAgICAg
IFNldCBkZXZpY2UgbWVtb3J5IG1hcHBpbmcgKG9wdGlvbmFsKQ0KPiAgICogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIE5lZWRlZCBmb3IgZGV2aWNlIHRoYXQgdXNpbmcgZGV2aWNlDQo+ICAg
KiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3BlY2lmaWMgRE1BIHRyYW5zbGF0aW9uIChv
bi1jaGlwIElPTU1VKQ0KPiBAQCAtMzIxLDYgKzMyNywxMCBAQCBzdHJ1Y3QgdmRwYV9jb25maWdf
b3BzIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICB1NjQgaW92YSwgdTY0IHNpemUsIHU2NCBw
YSwgdTMyIHBlcm0sIHZvaWQgKm9wYXF1ZSk7DQo+ICAgICAgICAgaW50ICgqZG1hX3VubWFwKShz
dHJ1Y3QgdmRwYV9kZXZpY2UgKnZkZXYsIHVuc2lnbmVkIGludCBhc2lkLA0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgdTY0IGlvdmEsIHU2NCBzaXplKTsNCj4gKyAgICAgICBpbnQgKCpzZXRf
Z3JvdXBfYXNpZCkoc3RydWN0IHZkcGFfZGV2aWNlICp2ZGV2LCB1bnNpZ25lZCBpbnQgZ3JvdXAs
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCBhc2lkKTsNCj4g
Kw0KPiArDQoNCk5pdCBhZ2FpbiwgYW5kIEphc29uJ3MgcGF0Y2ggYWxyZWFkeSBjb250YWluZWQg
dGhlc2UsIGJ1dCBJIHRoaW5rIHRoZXNlIHR3byBibGFuayBsaW5lcyBhcmUgaW50cm9kdWNlZCB1
bmludGVudGlvbmFsbHkuDQpbR0Q+Pl0gV2lsbCBmaXggdGhpcyBpbiB0aGUgbmV4dCByZXZpc2lv
bi4NCg0KPg0KPiAgICAgICAgIC8qIEZyZWUgZGV2aWNlIHJlc291cmNlcyAqLw0KPiAgICAgICAg
IHZvaWQgKCpmcmVlKShzdHJ1Y3QgdmRwYV9kZXZpY2UgKnZkZXYpOw0KPiAtLQ0KPiAyLjI1LjAN
Cj4NCg0K
