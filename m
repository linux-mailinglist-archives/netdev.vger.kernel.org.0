Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13815FC0DF
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 08:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJLGpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 02:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJLGpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 02:45:35 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2051.outbound.protection.outlook.com [40.107.215.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B983FEDA;
        Tue, 11 Oct 2022 23:45:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VE4Numc+YEVtyEfnoVayRLhVLIWVvTjEWDRyTbBkthSuPe5Y0hokjZuGGo6lIuuUmydVxsNUm1nUjF4YvmJgwNc/APvdGCEjCl9029BCVXtyB918yms+TeX1zv2ix9uNJ0Pm9C4sT6yiapKFFtaPkuZWt0OZRSZU9FXII5d3KH8ZVcZLL/mY1mrWtdroUkQOqhPJ8oQw4Ej8EMCeVgjc94sbUgFrPqejYAinZSY6YjsoW4lwkUjTrfPJvFAjFTQzvx/hmssrZHdT3ZaJwMQqjzjM4fXiakBEPLzmeO26NzB6PRptwaAFEkrnZoHc/lk/N+M1zdQyZRlMULjuRRMG2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IYDn+GlyKY7GUbBdyKN5oAXEy49M2rvI+hc79ot/GHw=;
 b=jOfIVJ1e+IAIYFCKWEEEEz5d0c1rvcGkBbc+42gEMUTnYS72V9e0mFfJUtLzSb73WW3sJwHdJRiEWPiJymgb+5qqx3ixYT0Srt0Ytg3yZdqOsD9GCK4201nBD6oD3koP4FRyVuBDqHYwvicx8BsqXnnqUTgXNmeyejqOQ/E9/nh1Go/6XwSf2OkO1w8UJxv0LSc9Y1DdHeI33FemqHpmZrund5FHLG/j3ZvcfS+GirlbYPSSeMFDyEHxHDXWxc44y6HstGgeHydCkqy+V5ybvQVJWUl46kkXpNzIPWfbTadeyWmaW1nSnIt8D14gzH1xnGj6cB+63CS2NQP588qWNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYDn+GlyKY7GUbBdyKN5oAXEy49M2rvI+hc79ot/GHw=;
 b=Eug6iL9wIkoL+a0SytiL0uZsMppS91tyLn1EsxV6TH5sGvfBrguVvz/W3ICzE3l2NvYGLvWGcCGYA4mXsZCXW9ASjktW6yh/Mc2i70gmO4b7ILO1gpXetT8NMZxxcXk3/ffdrXf/DCWjU22UMBv1lNWicJf9QKWFBPYGtmHb4317v5RIFiX1dtRokD+xF3iTWz5K/BlTFSBo/TiHERlid/KskUH8dHa/99sQnqhvo3eELA/xykmWroGUm0qrTIlsIcBHJ35AQB6ppv0IByDAjd4Xt52k32l45jc4EnUnXBfJ0gZ0mdPi9TxoeVs0FGMtNl1tCeZqizhr0T0jUlTJIA==
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
 by PUZPR06MB6101.apcprd06.prod.outlook.com (2603:1096:301:115::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 06:45:28 +0000
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::aa83:33dc:435c:cb5d]) by TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::aa83:33dc:435c:cb5d%6]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 06:45:28 +0000
From:   Angus Chen <angus.chen@jaguarmicro.com>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alvaro.karsz@solid-run.com" <alvaro.karsz@solid-run.com>,
        "gavinl@nvidia.com" <gavinl@nvidia.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "wangdeming@inspur.com" <wangdeming@inspur.com>,
        "xiujianfeng@huawei.com" <xiujianfeng@huawei.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: [GIT PULL] virtio: fixes, features
Thread-Topic: [GIT PULL] virtio: fixes, features
Thread-Index: AQHY3MyiiKqJa7Fnx0Wd1nXI+hxoOK4KTBsAgAAFF+A=
Date:   Wed, 12 Oct 2022 06:45:27 +0000
Message-ID: <TY2PR06MB3424C10AC28421199B02905D85229@TY2PR06MB3424.apcprd06.prod.outlook.com>
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au>
In-Reply-To: <87r0zdmujf.fsf@mpe.ellerman.id.au>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR06MB3424:EE_|PUZPR06MB6101:EE_
x-ms-office365-filtering-correlation-id: b217f570-d8fb-4609-847c-08daac1d5960
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kb9OEi2MuW5zZg78f4Lp/ZXrndPPUfcLN91DsQ5NZYac9zamFhoqMyr574UUMjTkfH6r4G9LlXP3fNO89HYc6lRdtGXzdMs5vofpYJHGMll+wtyP8aq2xz/yYse1mNb4Mukg6wbmC6GluPZ/dJk2BrZOspTyVYHLYQxzAIEMapLIe6/rbEFpi8tj7YnJHf95hwN1n1hdLI+IYfMRkQI91anCw0Ai/x2EtEuU0NrIkrflbRsy3Fe26mGeinU+RIPcZAmQjYKAHEjTE38xktjo+OiQtiRwBComHt3hsBz/1JuGXX5afl5JxbAQ5qODpv4nibMDAM3wyizHnmaGfFWwT8N1ZNFlD802u2PaM8mx+M0KI3CN4UT3OJ5tdYxrYbP3TbYwIIpmxSdBgDqjeLlV39xNP/G3LrMOw8s8KMq6yLf7QUAM04dmlMBKM1BW8IZiIoZeQLAWL9l8FMHV8xkmOO0DWfHQ/u1KoX1UKea65C/oLqBzoaZ5MmeFURpJtCCfUSC86cN5h0P/2vaJcoP+qNbxvyfC5Cd9GVlZFHje4P/fTyc0+S6vURVnmifVbRIjTP7XTM6H2KZuUgca7d7cBjZziqDMnFpRuSQiK5wSeAQyaFbc91LPZVsONrdX2lKjHfh5iamu0oHGY467KXJhLf6cBtYnFLgdxP0CY/itsWEiHa6nMsa4dqmnvSD6ttZafMAEK/1zJzlrUYt2jZhjRS9jLvk3EAkMJg82w8YJlMeuyTbTfj6ZGx4fCSWr5hMAcrLMXN2n9Bvqe84O/qwveRD66uprjI1mIJvJIoPIqWg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3424.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39840400004)(346002)(376002)(136003)(366004)(451199015)(966005)(38070700005)(66476007)(33656002)(86362001)(38100700002)(66556008)(122000001)(64756008)(4326008)(76116006)(316002)(71200400001)(66946007)(66446008)(8676002)(55016003)(5660300002)(41300700001)(54906003)(2906002)(9686003)(44832011)(110136005)(52536014)(7416002)(8936002)(186003)(83380400001)(478600001)(26005)(7696005)(53546011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlpYUm1sZUY0UHo2NVdYOG5aM1lMTmpUd3EyVVhpbWEzQUc5Njlvb2FMdHFa?=
 =?utf-8?B?RHlzY0dja2t1WWx4MldBQXp1NlVvdUtwUlNLbXhnRWtudDRMU204Ylg3WjYw?=
 =?utf-8?B?UTEzWjJRZ2lYLzNvWnJMREVneUwyMmJzci9PNlYzcS9oa0FUVUMyakNJZWFm?=
 =?utf-8?B?NklOckgxWFAzYkdoUGJwdjRJR0Jtd014ay9saCtZaUNkOUtVL1pCRlVSRkJZ?=
 =?utf-8?B?MnhhNWx2YkdSUklkZFBTdDlmVGlzN3duU3c3U1B0VXE3SzU1dzI2a291bkQ3?=
 =?utf-8?B?QmN4ZW4vbmdqSWwwVEZMbXplRWRndy9TVXNlNlhwMVBCOTAzTENxUWxSQ3RC?=
 =?utf-8?B?MXJ1TE5uZWg0c01CQzgxWVBNdDZpV2krcjZ1MURDZGFzRDNycEkwNTk3Kyts?=
 =?utf-8?B?UkhVbXZ5RXJ2cUR1Z3R5emZaNkM2c3N6b1c2YzM5czB0QWdoL2UyMlZCZ2J0?=
 =?utf-8?B?QlkxRjlqV0pFd09lNmY4UE1wU1FGNDdEL3F6elBwZUpDdmZ5blo4QkdnVjJn?=
 =?utf-8?B?MXE3NFh0TUtIWlp4TVNqbmFBMnFGSVdZTGN1L2UvVWQ5a3pkY1Q5aEVxMW1K?=
 =?utf-8?B?S3dMN1NMYXNRVUZiNGMyMzEyV0d0Ri9QanZQT3JHMHBUbHZDaTMwd24vdkU5?=
 =?utf-8?B?U3EvWmZTenNjNUJjSkg3MGZHVkVvWkRFSVZ6cWE2MDg1RDVLYUlSMllZditv?=
 =?utf-8?B?QzlSWitmTU11b2kxbitKMHVwei9tT2o4d1hpTU9pZy96SEhENHoybk5oME14?=
 =?utf-8?B?WFE2OC9NeUFrRDN6L1RqQjYrYVQ0R0hIN3N2eGE3REJNN1NhYjluN01xaGxH?=
 =?utf-8?B?cWc4cU01WTdmNVJPa3lJbHdaN0wydkZCTTVyN0J0YmRaRnArT2NBdHFKakFF?=
 =?utf-8?B?VFRWYlJkdHltNEpSVjg1aDViQUlGUThhQ29KN1REVUhpUlR6T3AyUVY0Wmtq?=
 =?utf-8?B?dlhrNnVoRlFzVWdkQ2VHcFN5TEdrS1BpN0dpQVVZblorZm41Y0VoUkFpMUhQ?=
 =?utf-8?B?Z0NVVThZczhXTkp0Z2EvbUc4SkRmRCtvM0pvTS9uSFRZZjF0U0JGWm5BNUUw?=
 =?utf-8?B?bTQ4UnpnNnQ5M280eWFseVFjUUV5QkZhMXVjS3lnUER0MktnMmZNdjA0S3lL?=
 =?utf-8?B?VFYxNCtuTlFob2NoRjRwSVZ5VmNlSkx6bXRhSWhmeGwyNmxZUytKMDM1VU40?=
 =?utf-8?B?SWtpVGtwYmxUTzNhYWxQMStBY1BYTktTT2tsSFhSbXVLQjM5cTZHN2NrbnRk?=
 =?utf-8?B?WVhmMEtjQUJyM1JRMGUwdUxJY1FwbUZBQm1QRzZvMkRKdkxYRS9PKzVSRjRa?=
 =?utf-8?B?NmFFbVhEZTNWL0RwM0xQWGlidlMvWTdiM3B0MitGR0xWemhiQUZxQUhyQ1BZ?=
 =?utf-8?B?RDBCeU5mWGpIOHdUeWNZMjkxSVlvOXB6UEU5MjNBb0FYWG1jTlhqQUs3TXVU?=
 =?utf-8?B?L2FiM2lPZGtOYVlaMlVlZmJuNktUbTUvYTZLa0VXeFVrVzQ1SE9ZZHZpbzRG?=
 =?utf-8?B?TGNTUWVLQUhwVVVtZ3ZqM2Zsb05aR0NyeGxuMkZiVGo5eG11RkJlZ083elA4?=
 =?utf-8?B?UjRjUjZiV1ZpM2pQMDRsaG9VajUrZGRoQ04vbEVDbGYrRVhPK2xXeVRycTIx?=
 =?utf-8?B?UHBIL202dklpVkhVakVBZk16ajJvWldYVmcwNzdKbW0vNkw0MklDcWJrTHY5?=
 =?utf-8?B?WDE5NFV2K1VRd1FFNU93dHgrTkFCQ3FCYlEzTVQ4UjAvTTN5eVdEUzlCbWQx?=
 =?utf-8?B?UFpzYWpuMkNTODZyMXpLUUlWc1F1QVVKN1kxSlljdnNkSHh3dFFTYW96VU0x?=
 =?utf-8?B?dGxPcGJGY29QN0Z2RXBQS1JQTEJjU2hyS0lrRHB1R3VNU1hLLzgzRUp5QzJn?=
 =?utf-8?B?TmM5THM4L3U4UElHL1YvcEdETGJPZVlPT2pUTFVscG9Udnh2bEIzcjFiZFpL?=
 =?utf-8?B?d2pldXpOaU5hZTN0Z1BnRHI5QXY5SkZEenRPcGNPU2N1U0R4NTcyM3RGR1J0?=
 =?utf-8?B?VVRJOCs0UmoySlVVZDBDakhlN1BLbDkwcnhsazZkQmhDYlExc05EODF0YlN5?=
 =?utf-8?B?MmQyQjB1aVNPem9XNlg0cFpWYjdVendCVlpJMjdxMGd0NUN0UkJjeXpjU3dB?=
 =?utf-8?B?ZFhyaGNkZ0xxZDczN0o5cTJEalBZOTJEWHQvV0R3dW1jaTZaZnViQkpNcm5H?=
 =?utf-8?B?cGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3424.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b217f570-d8fb-4609-847c-08daac1d5960
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 06:45:27.9560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Qry11shPxrsDCMvJSQRAZ0RXOvDwW1GhAe+Ah0e5DwMAiOwXxwECp5ygkCdD/o3biNMQnV9dpwkPdIths8ozGZGK6cmaJ0NbemREvVvuR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB6101
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWljaGFlbCBFbGxlcm1h
biA8bXBlQGVsbGVybWFuLmlkLmF1Pg0KPiBTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIgMTIsIDIw
MjIgMjoyMSBQTQ0KPiBUbzogTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNvbT4NCj4g
Q2M6IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LWZvdW5k
YXRpb24ub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOw0KPiBhbHZhcm8ua2Fyc3pAc29saWQtcnVuLmNvbTsgQW5ndXMgQ2hlbiA8YW5n
dXMuY2hlbkBqYWd1YXJtaWNyby5jb20+Ow0KPiBnYXZpbmxAbnZpZGlhLmNvbTsgamFzb3dhbmdA
cmVkaGF0LmNvbTsgbGluZ3NoYW4uemh1QGludGVsLmNvbTsNCj4gbXN0QHJlZGhhdC5jb207IHdh
bmdkZW1pbmdAaW5zcHVyLmNvbTsgeGl1amlhbmZlbmdAaHVhd2VpLmNvbTsNCj4gbGludXhwcGMt
ZGV2QGxpc3RzLm96bGFicy5vcmc7IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3Vu
ZGF0aW9uLm9yZz4NCj4gU3ViamVjdDogUmU6IFtHSVQgUFVMTF0gdmlydGlvOiBmaXhlcywgZmVh
dHVyZXMNCj4gDQo+ICJNaWNoYWVsIFMuIFRzaXJraW4iIDxtc3RAcmVkaGF0LmNvbT4gd3JpdGVz
Og0KPiA+IFRoZSBmb2xsb3dpbmcgY2hhbmdlcyBzaW5jZSBjb21taXQNCj4gNGZlODlkMDdkY2My
ODA0YzhiNTYyZjZjNzg5NmE0NTY0M2QzNGIyZjoNCj4gPg0KPiA+ICAgTGludXggNi4wICgyMDIy
LTEwLTAyIDE0OjA5OjA3IC0wNzAwKQ0KPiA+DQo+ID4gYXJlIGF2YWlsYWJsZSBpbiB0aGUgR2l0
IHJlcG9zaXRvcnkgYXQ6DQo+ID4NCj4gPiAgIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L21zdC92aG9zdC5naXQNCj4gdGFncy9mb3JfbGludXMNCj4gPg0K
PiA+IGZvciB5b3UgdG8gZmV0Y2ggY2hhbmdlcyB1cCB0bw0KPiA3MTQ5MWM1NGVhZmEzMThmZGQy
NGExZjI2YTFjODJiMjhlMWFjMjFkOg0KPiA+DQo+ID4gICB2aXJ0aW9fcGNpOiBkb24ndCB0cnkg
dG8gdXNlIGludHhpZiBwaW4gaXMgemVybyAoMjAyMi0xMC0wNyAyMDowMDo0NCAtMDQwMCkNCj4g
Pg0KPiA+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCj4gPiB2aXJ0aW86IGZpeGVzLCBmZWF0dXJlcw0KPiA+DQo+ID4gOWsg
bXR1IHBlcmYgaW1wcm92ZW1lbnRzDQo+ID4gdmRwYSBmZWF0dXJlIHByb3Zpc2lvbmluZw0KPiA+
IHZpcnRpbyBibGsgU0VDVVJFIEVSQVNFIHN1cHBvcnQNCj4gPg0KPiA+IEZpeGVzLCBjbGVhbnVw
cyBhbGwgb3ZlciB0aGUgcGxhY2UuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFMu
IFRzaXJraW4gPG1zdEByZWRoYXQuY29tPg0KPiA+DQo+ID4gLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+IEFsdmFybyBL
YXJzeiAoMSk6DQo+ID4gICAgICAgdmlydGlvX2JsazogYWRkIFNFQ1VSRSBFUkFTRSBjb21tYW5k
IHN1cHBvcnQNCj4gPg0KPiA+IEFuZ3VzIENoZW4gKDEpOg0KPiA+ICAgICAgIHZpcnRpb19wY2k6
IGRvbid0IHRyeSB0byB1c2UgaW50eGlmIHBpbiBpcyB6ZXJvDQo+IA0KPiBUaGlzIGNvbW1pdCBi
cmVha3MgdmlydGlvX3BjaSBmb3IgbWUgb24gcG93ZXJwYywgd2hlbiBydW5uaW5nIGFzIGEgcWVt
dQ0KPiBndWVzdC4NCj4gDQo+IHZwX2ZpbmRfdnFzKCkgYmFpbHMgb3V0IGJlY2F1c2UgcGNpX2Rl
di0+cGluID09IDAuDQo+IA0KPiBCdXQgcGNpX2Rldi0+aXJxIGlzIHBvcHVsYXRlZCBjb3JyZWN0
bHksIHNvIHZwX2ZpbmRfdnFzX2ludHgoKSB3b3VsZA0KPiBzdWNjZWVkIGlmIHdlIGNhbGxlZCBp
dCAtIHdoaWNoIGlzIHdoYXQgdGhlIGNvZGUgdXNlZCB0byBkby4NCj4gDQo+IEkgdGhpbmsgdGhp
cyBoYXBwZW5zIGJlY2F1c2UgcGNpX2Rldi0+cGluIGlzIG5vdCBwb3B1bGF0ZWQgaW4NCj4gcGNp
X2Fzc2lnbl9pcnEoKS4NClllcyx5b3UgYXJlIHJpZ2h0Lg0KPiANCj4gSSB3b3VsZCBhYnNvbHV0
ZWx5IGJlbGlldmUgdGhpcyBpcyBidWcgaW4gb3VyIFBDSSBjb2RlLCBidXQgSSB0aGluayBpdA0K
PiBtYXkgYWxzbyBhZmZlY3Qgb3RoZXIgcGxhdGZvcm1zIHRoYXQgdXNlIG9mX2lycV9wYXJzZV9h
bmRfbWFwX3BjaSgpLg0KPiANClNob3VsZCBJIGp1c3QgcmV2ZXJ0IG9yIHN1Ym1pdCBhIG5ldyB2
ZXJzaW9uPw0KPiBjaGVlcnMNCg==
