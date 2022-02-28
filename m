Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC184C691C
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 11:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbiB1K7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 05:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbiB1K65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 05:58:57 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B676374610;
        Mon, 28 Feb 2022 02:56:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GthkTDvgd7PYzfUxHJig+pM9eimKglIGq8FD+2HxzxIR0wMUf0UuGOHqaheXFfTQyq6bwEcU3T9EDwlcxhDzeziZOHyWbfyDIuqtCWxWBY1AJVCa8XfTTY6I5xF1U3tbtit8RmcKGMa9EYTiW3roLfJYkumhohkb1D9/Y9Uon70zmfaN/WN4oJ6uFtrdjJkPKiIRWMTSrCk62zxKzywt4zRamjuc2gkohSrPaObXD2tC+7MK2qfY/5zBQp9RFWxrMRTBQiLgqH/t+Zt4GqU+GDx1kcF+D6rTapcx+/rBwNBodKDQwPal8JRdNRPgN8WR5J9qpSLPrdeYrkVDl7FXhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q9OX/kDurxRPd0ajmQlQqrBUYsKB/8wZTZvPOdxa4OM=;
 b=obhtQiT39rRWxQmy/EAQzcxP1r9gR7WSvwIuQeTHH0OXtZeEtYVJNOkyUNLek1HvLAjaRjdlUL8bOq27xKUa1cTLSiiY+BMb6p9G6BeIm0VceSvgQfrL+pyvFZTtjp420R2mAsexz1rgtD5VLaViuTfiLhp60aFyFLQdUoE/i2/8Y+OrqgFZnEsaqgEqg1bN+rvwXw5E2YAlXiGVKO39rgzQRARr/4LlthYl9lDtqXekQUs2I8ImMvK5Wu6wlcrCARQosghENmbUUTjwvvINAmpwlgidi9z1ikkkTsvlX6WRullsJwA6J2P3c8zg6YQQQnyDxZRQTUoAPI4YBX0mUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9OX/kDurxRPd0ajmQlQqrBUYsKB/8wZTZvPOdxa4OM=;
 b=I1d0WDnk59u09RZwoWmyg+08H7ZqqnqM8fWcymyw8Uvr9eM4mXMwk1NlAW4Bkbbb5WCOP9MSwiufFJ87o69PzRPyD9nX7I94Hoet8vfHBaLewf3ZOEzKXVUDp45rLA8K1uYbI9ZgU6OYBayZmHR6+EDJZBoxYrfmMwl+FDDQXtU=
Received: from BY5PR02MB6980.namprd02.prod.outlook.com (2603:10b6:a03:235::19)
 by BYAPR02MB4053.namprd02.prod.outlook.com (2603:10b6:a02:f9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 10:56:15 +0000
Received: from BY5PR02MB6980.namprd02.prod.outlook.com
 ([fe80::ed57:1b66:1f0e:54bc]) by BY5PR02MB6980.namprd02.prod.outlook.com
 ([fe80::ed57:1b66:1f0e:54bc%8]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 10:56:15 +0000
From:   Gautam Dawar <gdawar@xilinx.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Tanuj Murlidhar Kamde <tanujk@xilinx.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC PATCH v2 00/19] Control VQ support in vDPA
Thread-Topic: [RFC PATCH v2 00/19] Control VQ support in vDPA
Thread-Index: AQHYKcSnVMRwteN51kudJKKqJrC+Rqyoo8WAgAAr9PA=
Date:   Mon, 28 Feb 2022 10:56:15 +0000
Message-ID: <BY5PR02MB6980DC90EE52FE1900F7C414B1019@BY5PR02MB6980.namprd02.prod.outlook.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20220224212314.1326-1-gdawar@xilinx.com>
 <19843d2b-dfe9-5e2d-4d3d-ca55456947dc@redhat.com>
In-Reply-To: <19843d2b-dfe9-5e2d-4d3d-ca55456947dc@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41b64356-e823-4987-79aa-08d9faa8f135
x-ms-traffictypediagnostic: BYAPR02MB4053:EE_
x-microsoft-antispam-prvs: <BYAPR02MB40530A5F961F3EFD81E3F6D2B1019@BYAPR02MB4053.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tZw7ddIaLM5VNrkkF4k0hRo6QEjAS1YcM6M3Q6uW2LeYGL9h4pStZNjXjqMTNjH76bZrCqV9+L0QSmd8+GDzwwl01Ifq+x2mYMqaXrvcPBdgGmLqifF5qlsw4axM9FwdjO+N+qWrH6d4H+1eUxMh4uYiVM6AzDl88MkZ6Ht0CrhDfxQVzBJh1otTC+lgS7VCmSitv9JO8gh0mPI/ROzEA3DAQNqR6QM0ln3K6fw/F4Bu1I6GNlMhuEkTuJGVxHt0NMglVPpk0LkoURYpC5lyhzGSNJq6bBAtWy0Ppr40QJU+fdOxQzn+fhu8DuMTYLpNNsjh8xdXulIK9He+YL7dJ007MG0p0N4oSXZ7Y0XaXnxJRTE9px+mdDM/72KbJ6A2fFi6mHLV1HlYWPw1yY9ZKvZizjl7Yji0mrPQ0hfd1h8ExXexS7tjlhVbukVeqCZG1WC+SRX0i7RNtrbfeB2sYmL0FvOPp9Id88Q/O3uxmdQcfdkfz9+REDVHuOFt4Vnllk7urSJGcfKblWP/6pMnj/hE9PF/Js7kgVcdOx193A6vNBn0e3M1q3nZzUVR9VEpqXGGTx15GQaDuje7/9lNeSISzgJNsgv5Z6GX2EtBiQJWjxRy5m/Az2E9HT2zCpTrXtWCcJFqz3yB0O3FXXXnY8jfalv8Ndx7NLCU1QhYJYHI7s9AlbnXqelM6ghgaJ6E6CVPepP9qECVPn7MvcKfCl7dI1F85fYQy5vWPbEPDZzn+S9DUSbLb07H2GEy0LBTI+GtXxqq4mDAHUpPxZrugZ/MnFDxhJVWZIWPdmJGIt/vCPcNl+A0SwAQ4wLRZksgKBp5lPAxEChfdLS67kPl8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR02MB6980.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(76116006)(66446008)(66556008)(66476007)(66946007)(7416002)(5660300002)(52536014)(8936002)(83380400001)(122000001)(2906002)(8676002)(4326008)(55016003)(186003)(84970400001)(26005)(38100700002)(71200400001)(86362001)(966005)(33656002)(316002)(6916009)(54906003)(6506007)(7696005)(9686003)(38070700005)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enI4N21PNFdqemFEWHlsR05RYzB5WURQUlBQdGNvY3Q0TTFBd09XY05SdGVn?=
 =?utf-8?B?elZtVEVKWVRqWFg1MlgyQmFxK25Dc2ExcHlGWlJJU21VV1I4MVplSW9DSUVX?=
 =?utf-8?B?WlhKNkRxcmhJT0taTHVTTE5GMmo5Mk1GbEpPYkZqaEJYQW9CbEVwR1pSWWZH?=
 =?utf-8?B?a3V0S3NhQXBJcnhxb1h0dU5SYmkrTXRFTEJSa0tZUjQ5RTRkS2VPWU9HNDZR?=
 =?utf-8?B?SG8rL3pHTWJjRHlPYys1Y1hYU0JLczU0V0J2eGVsRDhKcGM3VlVqS0FWZFJt?=
 =?utf-8?B?bEI2ZzYvZUtuR29ZbDVkclRKL2VRRzZoSUFhajFOYkFqM3pxb2ZOWmNSdHVm?=
 =?utf-8?B?SmRnT0l5OVpRTUQ4UEhURXZuak14SmQxYkJHdVBnRjFxNTdCQXRFM05YeEwr?=
 =?utf-8?B?WGd0Vlp2aVpianBFWVZhOVE1TjZVSE1RSzZNUEJzRFFSMG5xeXRnc3Q0MHFw?=
 =?utf-8?B?WERSZDFIa1JZZ0F2cVFhNDZYZ3czM0lKQzZRYysxY2diNjNxOGswbHdBSWM2?=
 =?utf-8?B?dFhmRk83dzg2LzN5RG1VRXR6S3hGUElpTUNCcWpBcG4zb1RGMnQ4OHdUSmZQ?=
 =?utf-8?B?SExoNG5tby80TTVRcTB4eGxWcTN1V3VXYnp4Q25UdFQreGY1R2gxV2JqdERN?=
 =?utf-8?B?NDYyOU1IMkhiQXVsRVpxMDIzcmpKczBsUnFHaHZTN3lUd3RZSnVsUE5KeVNq?=
 =?utf-8?B?QWo2azlrT0puZDBIUUk0NksxVnNiUVMwMkZvaXlxMzBWemFEVCsxc0Njb3o0?=
 =?utf-8?B?cEZneWF3TFRoWGd3eDNFYjZmUWM0NUJDblVib1FIWnJVajhUZWJELzBxSE85?=
 =?utf-8?B?Y3hDc09hU2J6RzE3eVZ2K05RTkdLOUJTalBnU3lkVkU1VC9NS29TRDg1U3R3?=
 =?utf-8?B?RjlZQkFkcG1NU1k3eHRobEZyRUpFa1lTNTBNMjQvSVhEZFdlV2xFeFJ3NHo2?=
 =?utf-8?B?Z1NjbGRUK1AwdEhFUEptVGFzL1REaVhST2JrZzZaSk45YmZwMzczVkdFdmtU?=
 =?utf-8?B?K3hDMmZjMmZUSWc4eCtLUXlxQi9URHJhK3lSM0ZuYWw4WExEdGJZb0Q4NWFk?=
 =?utf-8?B?K2NkOEpybDJKRCtWQXpVRlpUQ2cyTGtHTUxXTUE5QTJQem1YeG1LM2NkLzBs?=
 =?utf-8?B?NjVudVZYRkFGaGF6R1hmeW5hSVBrdkh4TTFya2VUQXlIN1dXblp3SEZoWGtF?=
 =?utf-8?B?VDNlMU1RNC90VjUyR1IrQSs5WnhhbmhGL3YzRStBSmpTdm8vdkRRazdzdzhX?=
 =?utf-8?B?QXMzQWN6Ly9nV2w4dFlLcjRiS3FHN1VZRktQTE5JZlk1T2RDU0dCS21tcUxo?=
 =?utf-8?B?T254Q1BRV2xPcCtZNWdNMzNUR2lEZmk2UDhLcmFiN2V1cDAyWkhqc2wxNCtP?=
 =?utf-8?B?UFFYbHAwYVRDN2JwUHF3bWhhOVoveVcydWI0MXpRbkJUUzBzSExQUXRKUnRk?=
 =?utf-8?B?K3UwSmtYSkx3aVYvaisycW9mQVBSYnFpcmVrY09mcHoxUytab21oOFVxSTQz?=
 =?utf-8?B?QjBCMVY3WUZ1eHUxK2tjOXdMekVBNWdORUZmS0ZVSlJrdHpPWmRqd3o0VkhW?=
 =?utf-8?B?YUxzbGNOREg5QjZpUFZxM29FbVZuNGtNVHVoYzFpQVRkeDh0aU9MZ1FmTWRV?=
 =?utf-8?B?cWtzT3g4aVJnbnBLclpMUnVFWXFmcEluRmFGWDFYOExZNnlOOEVaL0l0Nmpy?=
 =?utf-8?B?Q1lCUGczMEQxcWd4ZDJlWEpScGhVUTRMMEpDUkpjMkRHaUhlL25Ga3dNK1Fy?=
 =?utf-8?B?TGhQWHV6M0RzdVlBa2llaEVlSjhHMHdLd3pYSkJ1L2o0NVp4ZlVlWVZPQnkv?=
 =?utf-8?B?OG1oYlRLRm9rNUZHSXJxQ2g0eDVSRzFsZ3doZ2pLUlRVV2laNXN0RnNmWkJ2?=
 =?utf-8?B?a1ZlbFFCMzRIWnc4Rlhmc0JzUVFQekNMclJvYkZ1dlRRN1F2bVlpZytjZWMy?=
 =?utf-8?B?ekFYVGlLakxDVHM1QXk2YThnQ3daaTN4OGFPeVN1bFBKb1N6bjluMHNtcUph?=
 =?utf-8?B?SWxlTDFQbVk2QkJGUzJlRTBzTytoRkNPTzlDdloyN0V5elZzV21sazc3bm9M?=
 =?utf-8?B?RHFaV056eUF2bVJoMzJhMHA1SGUwWmd4NlhQM2wxMVArN3kzRk11TmEwQ1hp?=
 =?utf-8?B?Y00yNUlReHNqTU90a0RVSWc5QnlCcHhuRUNiRCtwc0Fzdy9lSEl1MGlZdkd2?=
 =?utf-8?B?b2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR02MB6980.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41b64356-e823-4987-79aa-08d9faa8f135
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 10:56:15.6649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7RmaFC6w3CoZWAdnhP7VeRntbqQANv7kMRII2s7kt1CkcfELAgG5S64rJRalOsAcGMYMgGt3Use+0ytvulVX3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4053
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5ZyoIDIwMjIvMi8yNSDkuIrljYg1OjIyLCBHYXV0YW0gRGF3YXIg5YaZ6YGTOg0KPiBIaSBBbGw6
DQo+DQo+IFRoaXMgc2VyaWVzIHRyaWVzIHRvIGFkZCB0aGUgc3VwcG9ydCBmb3IgY29udHJvbCB2
aXJ0cXVldWUgaW4gdkRQQS4NCj4NCj4gQ29udHJvbCB2aXJ0cXVldWUgaXMgdXNlZCBieSBuZXR3
b3JraW5nIGRldmljZSBmb3IgYWNjZXB0aW5nIHZhcmlvdXMgDQo+IGNvbW1hbmRzIGZyb20gdGhl
IGRyaXZlci4gSXQncyBhIG11c3QgdG8gc3VwcG9ydCBtdWx0aXF1ZXVlIGFuZCBvdGhlciANCj4g
Y29uZmlndXJhdGlvbnMuDQo+DQo+IFdoZW4gdXNlZCBieSB2aG9zdC12RFBBIGJ1cyBkcml2ZXIg
Zm9yIFZNLCB0aGUgY29udHJvbCB2aXJ0cXVldWUgDQo+IHNob3VsZCBiZSBzaGFkb3dlZCB2aWEg
dXNlcnNwYWNlIFZNTSAoUWVtdSkgaW5zdGVhZCBvZiBiZWluZyBhc3NpZ25lZCANCj4gZGlyZWN0
bHkgdG8gR3Vlc3QuIFRoaXMgaXMgYmVjYXVzZSBRZW11IG5lZWRzIHRvIGtub3cgdGhlIGRldmlj
ZSBzdGF0ZSANCj4gaW4gb3JkZXIgdG8gc3RhcnQgYW5kIHN0b3AgZGV2aWNlIGNvcnJlY3RseSAo
ZS5nIGZvciBMaXZlIE1pZ3JhdGlvbikuDQo+DQo+IFRoaXMgcmVxdWllcyB0byBpc29sYXRlIHRo
ZSBtZW1vcnkgbWFwcGluZyBmb3IgY29udHJvbCB2aXJ0cXVldWUgDQo+IHByZXNlbnRlZCBieSB2
aG9zdC12RFBBIHRvIHByZXZlbnQgZ3Vlc3QgZnJvbSBhY2Nlc3NpbmcgaXQgZGlyZWN0bHkuDQo+
DQo+IFRvIGFjaGlldmUgdGhpcywgdkRQQSBpbnRyb2R1Y2UgdHdvIG5ldyBhYnN0cmFjdGlvbnM6
DQo+DQo+IC0gYWRkcmVzcyBzcGFjZTogaWRlbnRpZmllZCB0aHJvdWdoIGFkZHJlc3Mgc3BhY2Ug
aWQgKEFTSUQpIGFuZCBhIHNldA0KPiAgICAgICAgICAgICAgICAgICBvZiBtZW1vcnkgbWFwcGlu
ZyBpbiBtYWludGFpbmVkDQo+IC0gdmlydHF1ZXVlIGdyb3VwOiB0aGUgbWluaW1hbCBzZXQgb2Yg
dmlydHF1ZXVlcyB0aGF0IG11c3Qgc2hhcmUgYW4NCj4gICAgICAgICAgICAgICAgICAgYWRkcmVz
cyBzcGFjZQ0KPg0KPiBEZXZpY2UgbmVlZHMgdG8gYWR2ZXJ0aXNlIHRoZSBmb2xsb3dpbmcgYXR0
cmlidXRlcyB0byB2RFBBOg0KPg0KPiAtIHRoZSBudW1iZXIgb2YgYWRkcmVzcyBzcGFjZXMgc3Vw
cG9ydGVkIGluIHRoZSBkZXZpY2UNCj4gLSB0aGUgbnVtYmVyIG9mIHZpcnRxdWV1ZSBncm91cHMg
c3VwcG9ydGVkIGluIHRoZSBkZXZpY2UNCj4gLSB0aGUgbWFwcGluZ3MgZnJvbSBhIHNwZWNpZmlj
IHZpcnRxdWV1ZSB0byBpdHMgdmlydHF1ZXVlIGdyb3Vwcw0KPg0KPiBUaGUgbWFwcGluZ3MgZnJv
bSB2aXJ0cXVldWUgdG8gdmlydHF1ZXVlIGdyb3VwcyBpcyBmaXhlZCBhbmQgZGVmaW5lZCANCj4g
YnkgdkRQQSBkZXZpY2UgZHJpdmVyLiBFLmc6DQo+DQo+IC0gRm9yIHRoZSBkZXZpY2UgdGhhdCBo
YXMgaGFyZHdhcmUgQVNJRCBzdXBwb3J0LCBpdCBjYW4gc2ltcGx5DQo+ICAgIGFkdmVydGlzZSBh
IHBlciB2aXJ0cXVldWUgdmlydHF1ZXVlIGdyb3VwLg0KPiAtIEZvciB0aGUgZGV2aWNlIHRoYXQg
ZG9lcyBub3QgaGF2ZSBoYXJkd2FyZSBBU0lEIHN1cHBvcnQsIGl0IGNhbg0KPiAgICBzaW1wbHkg
YWR2ZXJ0aXNlIGEgc2luZ2xlIHZpcnRxdWV1ZSBncm91cCB0aGF0IGNvbnRhaW5zIGFsbA0KPiAg
ICB2aXJ0cXVldWVzLiBPciBpZiBpdCB3YW50cyBhIHNvZnR3YXJlIGVtdWxhdGVkIGNvbnRyb2wg
dmlydHF1ZXVlLCBpdA0KPiAgICBjYW4gYWR2ZXJ0aXNlIHR3byB2aXJ0cXVldWUgZ3JvdXBzLCBv
bmUgaXMgZm9yIGN2cSwgYW5vdGhlciBpcyBmb3INCj4gICAgdGhlIHJlc3QgdmlydHF1ZXVlcy4N
Cj4NCj4gdkRQQSBhbHNvIGFsbG93IHRvIGNoYW5nZSB0aGUgYXNzb2NpYXRpb24gYmV0d2VlbiB2
aXJ0cXVldWUgZ3JvdXAgYW5kIA0KPiBhZGRyZXNzIHNwYWNlLiBTbyBpbiB0aGUgY2FzZSBvZiBj
b250cm9sIHZpcnRxdWV1ZSwgdXNlcnNwYWNlDQo+IFZNTShRZW11KSBtYXkgdXNlIGEgZGVkaWNh
dGVkIGFkZHJlc3Mgc3BhY2UgZm9yIHRoZSBjb250cm9sIHZpcnRxdWV1ZSANCj4gZ3JvdXAgdG8g
aXNvbGF0ZSB0aGUgbWVtb3J5IG1hcHBpbmcuDQo+DQo+IFRoZSB2aG9zdC92aG9zdC12RFBBIGlz
IGFsc28gZXh0ZW5kIGZvciB0aGUgdXNlcnNwYWNlIHRvOg0KPg0KPiAtIHF1ZXJ5IHRoZSBudW1i
ZXIgb2YgdmlydHF1ZXVlIGdyb3VwcyBhbmQgYWRkcmVzcyBzcGFjZXMgc3VwcG9ydGVkIGJ5DQo+
ICAgIHRoZSBkZXZpY2UNCj4gLSBxdWVyeSB0aGUgdmlydHF1ZXVlIGdyb3VwIGZvciBhIHNwZWNp
ZmljIHZpcnRxdWV1ZQ0KPiAtIGFzc29jYWl0ZSBhIHZpcnRxdWV1ZSBncm91cCB3aXRoIGFuIGFk
ZHJlc3Mgc3BhY2UNCj4gLSBzZW5kIEFTSUQgYmFzZWQgSU9UTEIgY29tbWFuZHMNCj4NCj4gVGhp
cyB3aWxsIGhlbHAgdXNlcnNwYWNlIFZNTShRZW11KSB0byBkZXRlY3Qgd2hldGhlciB0aGUgY29u
dHJvbCB2cSANCj4gY291bGQgYmUgc3VwcG9ydGVkIGFuZCBpc29sYXRlIG1lbW9yeSBtYXBwaW5n
cyBvZiBjb250cm9sIHZpcnRxdWV1ZSANCj4gZnJvbSB0aGUgb3RoZXJzLg0KPg0KPiBUbyBkZW1v
bnN0cmF0ZSB0aGUgdXNhZ2UsIHZEUEEgc2ltdWxhdG9yIGlzIGV4dGVuZGVkIHRvIHN1cHBvcnQg
DQo+IHNldHRpbmcgTUFDIGFkZHJlc3MgdmlhIGEgZW11bGF0ZWQgY29udHJvbCB2aXJ0cXVldWUu
DQo+DQo+IFBsZWFzZSByZXZpZXcuDQo+DQo+IENoYW5nZXMgc2luY2UgdjE6DQo+DQo+IC0gUmVi
YXNlZCB0aGUgdjEgcGF0Y2ggc2VyaWVzIG9uIHZob3N0IGJyYW5jaCBvZiBNU1Qgdmhvc3QgZ2l0
IHJlcG8NCj4gICAgZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21zdC92
aG9zdC5naXQvbG9nLz9oPXZob3N0DQo+IC0gVXBkYXRlcyB0byBhY2NvbW1vZGF0ZSB2ZHBhX3Np
bSBjaGFuZ2VzIGZyb20gbW9ub2xpdGhpYyBtb2R1bGUgaW4NCj4gICAga2VybmVsIHVzZWQgdjEg
cGF0Y2ggc2VyaWVzIHRvIGN1cnJlbnQgbW9kdWxhcml6ZWQgY2xhc3MgKG5ldCwgYmxvY2spDQo+
ICAgIGJhc2VkIGFwcHJvYWNoLg0KPiAtIEFkZGVkIG5ldyBhdHRyaWJ1dGVzIChuZ3JvdXBzIGFu
ZCBuYXMpIHRvICJ2ZHBhc2ltX2Rldl9hdHRyIiBhbmQNCj4gICAgcHJvcGFnYXRlZCB0aGVtIGZy
b20gdmRwYV9zaW1fbmV0IHRvIHZkcGFfc2ltDQo+IC0gV2lkZW5lZCB0aGUgZGF0YS10eXBlIGZv
ciAiYXNpZCIgbWVtYmVyIG9mIHZob3N0X21zZ192MiB0byBfX3UzMg0KPiAgICB0byBhY2NvbW1v
ZGF0ZSBQQVNJRA0KDQoNClRoaXMgaXMgZ3JlYXQuIFRoZW4gdGhlIHNlbWFudGljIG1hdGNoZXMg
ZXhhY3RseSB0aGUgUEFTSUQgcHJvcG9zYWwgaGVyZVsxXS4NCg0KDQo+IC0gRml4ZWQgdGhlIGJ1
aWxkYm90IHdhcm5pbmdzDQo+IC0gUmVzb2x2ZWQgYWxsIGNoZWNrcGF0Y2gucGwgZXJyb3JzIGFu
ZCB3YXJuaW5ncw0KPiAtIFRlc3RlZCBib3RoIGNvbnRyb2wgYW5kIGRhdGFwYXRoIHdpdGggWGls
aW54IFNtYXJ0bmljIFNOMTAwMCBzZXJpZXMNCj4gICAgZGV2aWNlIHVzaW5nIFFFTVUgaW1wbGVt
ZW50aW5nIHRoZSBTaGFkb3cgdmlydHF1ZXVlIGFuZCBzdXBwb3J0IGZvcg0KPiAgICBWUSBncm91
cHMgYW5kIEFTSUQgYXZhaWxhYmxlIGF0Og0KPiAgICBnaXRodWIuY29tL2V1Z3Blcm1hci9xZW11
L3JlbGVhc2VzL3RhZy92ZHBhX3N3X2xpdmVfbWlncmF0aW9uLmQlMkYNCj4gICAgYXNpZF9ncm91
cHMtdjEuZCUyRjAwDQoNCg0KT24gdG9wLCB3ZSBtYXkgZXh0ZW5kIHRoZSBuZXRsaW5rIHByb3Rv
Y29sIHRvIHJlcG9ydCB0aGUgbWFwcGluZyBiZXR3ZWVuIHZpcnRxdWV1ZSB0byBpdHMgZ3JvdXBz
Lg0KW0dEPj5dIFllcywgSSd2ZSBhbHJlYWR5IGRpc2N1c3NlZCB0aGlzIHdpdGggRXVnZW5pby4g
Rm9yIHRlc3RpbmcgcHVycG9zZSwgSSBhZGRlZCB0aGUgbWFwcGluZyBpbiBYaWxpbnggbmV0ZHJp
dmVyICJzZmMiLg0KDQpUaGFua3MNCg0KWzFdIA0KaHR0cHM6Ly93d3cubWFpbC1hcmNoaXZlLmNv
bS92aXJ0aW8tZGV2QGxpc3RzLm9hc2lzLW9wZW4ub3JnL21zZzA4MDc3Lmh0bWwNCg0KDQo+DQo+
IENoYW5nZXMgc2luY2UgUkZDOg0KPg0KPiAtIHR3ZWFrIHZob3N0IHVBUEkgZG9jdW1lbnRhdGlv
bg0KPiAtIHN3aXRjaCB0byB1c2UgZGV2aWNlIHNwZWNpZmljIElPVExCIHJlYWxseSBpbiBwYXRj
aCA0DQo+IC0gdHdlYWsgdGhlIGNvbW1pdCBsb2cNCj4gLSBmaXggdGhhdCBBU0lEIGluIHZob3N0
IGlzIGNsYWltZWQgdG8gYmUgMzIgYWN0dWFsbHkgYnV0IDE2Yml0DQo+ICAgIGFjdHVhbGx5DQo+
IC0gZml4IHVzZSBhZnRlciBmcmVlIHdoZW4gdXNpbmcgQVNJRCB3aXRoIElPVExCIGJhdGNoaW5n
IHJlcXVlc3RzDQo+IC0gc3dpdGNoIHRvIHVzZSBTdGVmYW5vJ3MgcGF0Y2ggZm9yIGhhdmluZyBz
ZXBhcmF0ZWQgaW92DQo+IC0gcmVtb3ZlIHVudXNlZCAidXNlZF9hcyIgdmFyaWFibGUNCj4gLSBm
aXggdGhlIGlvdGxiL2FzaWQgY2hlY2tpbmcgaW4gdmhvc3RfdmRwYV91bm1hcCgpDQo+DQo+IFRo
YW5rcw0KPg0KPiBHYXV0YW0gRGF3YXIgKDE5KToNCj4gICAgdmhvc3Q6IG1vdmUgdGhlIGJhY2tl
bmQgZmVhdHVyZSBiaXRzIHRvIHZob3N0X3R5cGVzLmgNCj4gICAgdmlydGlvLXZkcGE6IGRvbid0
IHNldCBjYWxsYmFjayBpZiB2aXJ0aW8gZG9lc24ndCBuZWVkIGl0DQo+ICAgIHZob3N0LXZkcGE6
IHBhc3NpbmcgaW90bGIgdG8gSU9NTVUgbWFwcGluZyBoZWxwZXJzDQo+ICAgIHZob3N0LXZkcGE6
IHN3aXRjaCB0byB1c2Ugdmhvc3QtdmRwYSBzcGVjaWZpYyBJT1RMQg0KPiAgICB2ZHBhOiBpbnRy
b2R1Y2UgdmlydHF1ZXVlIGdyb3Vwcw0KPiAgICB2ZHBhOiBtdWx0aXBsZSBhZGRyZXNzIHNwYWNl
cyBzdXBwb3J0DQo+ICAgIHZkcGE6IGludHJvZHVjZSBjb25maWcgb3BlcmF0aW9ucyBmb3IgYXNz
b2NpYXRpbmcgQVNJRCB0byBhIHZpcnRxdWV1ZQ0KPiAgICAgIGdyb3VwDQo+ICAgIHZob3N0X2lv
dGxiOiBzcGxpdCBvdXQgSU9UTEIgaW5pdGlhbGl6YXRpb24NCj4gICAgdmhvc3Q6IHN1cHBvcnQg
QVNJRCBpbiBJT1RMQiBBUEkNCj4gICAgdmhvc3QtdmRwYTogaW50cm9kdWNlIGFzaWQgYmFzZWQg
SU9UTEINCj4gICAgdmhvc3QtdmRwYTogaW50cm9kdWNlIHVBUEkgdG8gZ2V0IHRoZSBudW1iZXIg
b2YgdmlydHF1ZXVlIGdyb3Vwcw0KPiAgICB2aG9zdC12ZHBhOiBpbnRyb2R1Y2UgdUFQSSB0byBn
ZXQgdGhlIG51bWJlciBvZiBhZGRyZXNzIHNwYWNlcw0KPiAgICB2aG9zdC12ZHBhOiB1QVBJIHRv
IGdldCB2aXJ0cXVldWUgZ3JvdXAgaWQNCj4gICAgdmhvc3QtdmRwYTogaW50cm9kdWNlIHVBUEkg
dG8gc2V0IGdyb3VwIEFTSUQNCj4gICAgdmhvc3QtdmRwYTogc3VwcG9ydCBBU0lEIGJhc2VkIElP
VExCIEFQSQ0KPiAgICB2ZHBhX3NpbTogYWR2ZXJ0aXNlIFZJUlRJT19ORVRfRl9NVFUNCj4gICAg
dmRwYV9zaW06IGZhY3RvciBvdXQgYnVmZmVyIGNvbXBsZXRpb24gbG9naWMNCj4gICAgdmRwYV9z
aW06IGZpbHRlciBkZXN0aW5hdGlvbiBtYWMgYWRkcmVzcw0KPiAgICB2ZHBhc2ltOiBjb250cm9s
IHZpcnRxdWV1ZSBzdXBwb3J0DQo+DQo+ICAgZHJpdmVycy92ZHBhL2lmY3ZmL2lmY3ZmX21haW4u
YyAgICAgIHwgICA4ICstDQo+ICAgZHJpdmVycy92ZHBhL21seDUvbmV0L21seDVfdm5ldC5jICAg
IHwgIDExICstDQo+ICAgZHJpdmVycy92ZHBhL3ZkcGEuYyAgICAgICAgICAgICAgICAgIHwgICA1
ICsNCj4gICBkcml2ZXJzL3ZkcGEvdmRwYV9zaW0vdmRwYV9zaW0uYyAgICAgfCAxMDAgKysrKysr
KystLQ0KPiAgIGRyaXZlcnMvdmRwYS92ZHBhX3NpbS92ZHBhX3NpbS5oICAgICB8ICAgMyArDQo+
ICAgZHJpdmVycy92ZHBhL3ZkcGFfc2ltL3ZkcGFfc2ltX25ldC5jIHwgMTY5ICsrKysrKysrKysr
KystLS0tDQo+ICAgZHJpdmVycy92aG9zdC9pb3RsYi5jICAgICAgICAgICAgICAgIHwgIDIzICsr
LQ0KPiAgIGRyaXZlcnMvdmhvc3QvdmRwYS5jICAgICAgICAgICAgICAgICB8IDI3MiArKysrKysr
KysrKysrKysrKysrKystLS0tLS0NCj4gICBkcml2ZXJzL3Zob3N0L3Zob3N0LmMgICAgICAgICAg
ICAgICAgfCAgMjMgKystDQo+ICAgZHJpdmVycy92aG9zdC92aG9zdC5oICAgICAgICAgICAgICAg
IHwgICA0ICstDQo+ICAgZHJpdmVycy92aXJ0aW8vdmlydGlvX3ZkcGEuYyAgICAgICAgIHwgICAy
ICstDQo+ICAgaW5jbHVkZS9saW51eC92ZHBhLmggICAgICAgICAgICAgICAgIHwgIDQ2ICsrKyst
DQo+ICAgaW5jbHVkZS9saW51eC92aG9zdF9pb3RsYi5oICAgICAgICAgIHwgICAyICsNCj4gICBp
bmNsdWRlL3VhcGkvbGludXgvdmhvc3QuaCAgICAgICAgICAgfCAgMjUgKystDQo+ICAgaW5jbHVk
ZS91YXBpL2xpbnV4L3Zob3N0X3R5cGVzLmggICAgIHwgIDExICstDQo+ICAgMTUgZmlsZXMgY2hh
bmdlZCwgNTY2IGluc2VydGlvbnMoKyksIDEzOCBkZWxldGlvbnMoLSkNCj4NCg0K
