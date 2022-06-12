Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53120547B68
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 20:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiFLSIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 14:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiFLSIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 14:08:05 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2049.outbound.protection.outlook.com [40.107.96.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8ECB1DF;
        Sun, 12 Jun 2022 11:08:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdUezFz9mIe7GaZ2bFuZHtlBgxNwm4bWFtuKruHqnMUw3QKL0D8DZFEhXVvFmoIkC8V05dj6EgSi1lr3UwaLwmWBfq6bpE9hzjIk/02QVW3fP5Fp1kOh6uSwhILXeIVCQz4wZj8xiCC6j4xDyHB37AaQnIKEzWzilC8uVR6UViAZUemb+kmgRyVEXvoPBRlIPKuz6GBAtUcVbb4Awdmfhj+aFLWvEqc5XUQd/GCkm4nFgexXewoIhp3SOLr9XhdivxUQKapG0tMBkU4cENSv5lfihGlr9TfMo2DigwEK/RxPSWDoeXt1MeWaK/VCocfIz77v29VvhbyXWdqkREssxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVyJVaAirM1Whq7sz1bBmYq/C/JFmkQ7RkzL+tToFzA=;
 b=lR9FUkGbNx3muJpSYpoJ/8YbXG10MD036rrWRX5bVxQeGi61/mvbBrIkPKHbAzUCxVdp7TusGcbNeRsyWkTuLBs/QD1ynoQ87MXHIYk0abd54nw7taRLojYctTIXLgH/a6vO4bFkJdmsF/pmyEWuUYp1eD1iHB1Ca+8rwRTS1FHCvNkKKncEppCtk7L527UadGIuVunoJIJ+TXMR+xpfK8JAlZvAnaRxHjUi0CMewZjmJSwkvnhim0pC2Cf3Cz7DAIs+Kt0Mqeed/vR323fMrIQJ84mrq3nPwtAei6dk8GYUR7mk9SCS9MtUE55fTL9TWyyDvPRAorT/7/3/azPTog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVyJVaAirM1Whq7sz1bBmYq/C/JFmkQ7RkzL+tToFzA=;
 b=JjepXGOB5osSXxVVQNTUFADICxmKiSR50ax1n3lpWKcgd29B344CAgQBjUD4Vc3z6xsJAxZEdgrOy8O+6hv1HTDi0rl54UjdpvoWlQO0r2yze1K4EOPsvzHhv9NBYUtBbSFX+1ZHCHUbVu0ZtHi/RlHQ8MkH3mBLJ1CovTINYlhEX7gNtZrUGPPhWyVcGDJvuM5eMWM0ftieWiuvDxgeLkiMCgFlrDlrh2A4KSUXLhyG9ff8wZV/Ufn+GtFt4fhX6ywlQnN9wbOlU1LuHj4CFFaXLevmNBBMeF4UMmsPupVjlgfh/IqcE9EmAik4II/cSVq9PDOHwuUQ94fDcu1J6w==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM4PR12MB6350.namprd12.prod.outlook.com (2603:10b6:8:a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19; Sun, 12 Jun
 2022 18:08:02 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8c53:1666:6a81:943e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8c53:1666:6a81:943e%3]) with mapi id 15.20.5332.019; Sun, 12 Jun 2022
 18:08:02 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Dawar, Gautam" <gautam.dawar@amd.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vdpa: allow vdpa dev_del management operation to return
 failure
Thread-Topic: [PATCH] vdpa: allow vdpa dev_del management operation to return
 failure
Thread-Index: AQHYdzWCFlBft4OJgU6WbdwBNZYD461FMSUAgAAlyoCAAAMLQIABWhYAgAVqxWA=
Date:   Sun, 12 Jun 2022 18:08:02 +0000
Message-ID: <PH0PR12MB54810E6652F03788A4975BE6DCA89@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220603103356.26564-1-gautam.dawar@amd.com>
 <CACGkMEs38ycmAaDc48_rt5BeBHq4tzKH39gj=KczYFQC16ns5Q@mail.gmail.com>
 <DM4PR12MB5841EB20B82969B6D67638AF99A49@DM4PR12MB5841.namprd12.prod.outlook.com>
 <PH0PR12MB54814B1D6E884E50E5C26786DCA49@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsdMzLb+JtdZ7vTmMb=jU7PpM5GaJT1uD6t_tty46x2OA@mail.gmail.com>
In-Reply-To: <CACGkMEsdMzLb+JtdZ7vTmMb=jU7PpM5GaJT1uD6t_tty46x2OA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9eee9864-c990-4be4-3720-08da4c9e7db5
x-ms-traffictypediagnostic: DM4PR12MB6350:EE_
x-microsoft-antispam-prvs: <DM4PR12MB63509952B0AE9EA0579E4D02DCA89@DM4PR12MB6350.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cnBWgFR9e3mK+6xQccUvIquiJMkEOCdzNFpAxKo9L09D46M31APx7PclHZqKW32uA4nP6mQZP19YLbALB3Q6PFCJ5T9rRsbi6HRt8nN7O40BWvKP4e5429VGnvCLqK1n/pdG7IARuJPcCyxPsW6l7bJFhRORlfyqQr2etnr8IRcHo3RuqCOcWReSl7ycnY1Nb7QreK/eFBeUAbRYURoUnilu5oCp/yQMQe4Wu1RtHBv/WpE/nkAadLAIom8l6goMi9Q4yz+C8rPE0Q1PsVB94CCZfZKloyWA4Spmmr+uLfn7C02iyI4x/gwGRWF8WojlfZWQSjSsCuZmWuw0NQbbRIeUcF1PR+bxiSUQ8hrstKGBup+cX9hxtoPmqtsKT/gWIkuTEMA1fSwxyS4QK7Z2WdRGPdaptFsIo66VIWWBLx5FGIzkr3WTMA5yUq37QUBYzEnvZbecM6h3gO/aeDnkv7TdRqdErpxqhJ9F4PH6n8tCiLaU4TW8GBiBNNSNNQnGS4ExIV81kzNXxMNjuyArnqOXVHKf4Q6Dn9hG5UUVfQC6cMI4V9MclFPWEqOgSAtgVq1eYTt3tu54n4T4fyn9JoU0eTe7I/3+MhGeOMnNec/t+8LU34uU/plV1YN9/6X3P5++hPEV9ZgWzscSWRZKo8TiqO+qGzK4SLarlaRT/+5J4a2Wgkuf+fk4HLt20xxtglB+Q5fLkO4B4O25+Yxul5xQ0kgWWfQShBdBxPQa1JDBdpNpt9Doe0+xbXajP3G5krcPFj2xnqL+L6ImkFzOzaGBiGji/a/YD7560XDJpLM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(38100700002)(26005)(9686003)(5660300002)(7696005)(6506007)(33656002)(2906002)(7416002)(52536014)(55016003)(8936002)(66946007)(76116006)(71200400001)(122000001)(508600001)(8676002)(86362001)(4326008)(66476007)(66556008)(64756008)(66446008)(38070700005)(83380400001)(966005)(186003)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QS9SUVdDZjlPN3lZRjNKMzhwcDNJdERlRVZ0RkxQU25IdjlGekVIUnFVL2FP?=
 =?utf-8?B?KzExYjFIekRPazNKalJiUW9pV2J1Nk1qNnpkcmtZc1FoRTFwVmg2K1d6WExO?=
 =?utf-8?B?cHAweXpuaUpkSzNhRTNQUWNOMko4aVcwMVpTNk5HNzZwTVNLb1BVN0xML2lJ?=
 =?utf-8?B?L0pINkZjMURDazdTYi9jSDREWXh4U25JZThkcmFlRmFpSkJiK3ErU3M2WDRt?=
 =?utf-8?B?SVZBK2hLWS9SYTZRVElWczZ4WmZtS0VCS2F5bktjd0ltbkJzdWJNL1pETS9Y?=
 =?utf-8?B?SkRwQ2YxRUMyUlRMcWNlQ00wOHU3bW0rWG1kVTAwTGMvc2YvRGI5ZDc0b1c4?=
 =?utf-8?B?SS9Nb3hRdjJUNklTSjBmMExmMTNBQVhuOGdYcVhiL1VtQXRaaThXTWozeVdP?=
 =?utf-8?B?TzVrNy96dEhkdFBVdy9XVzJ3b3lubVVpckxsVEtuOVlFOWhIamE1UlRETmZv?=
 =?utf-8?B?SFgybmVvK3E1OFlMb2tEOS94aVpxWVlTT2NYNENYa0cvWUNjTHJsalFvWnd5?=
 =?utf-8?B?VWFVa2J4bTJBS01ZUWpaQWJkQ3NxVmo4aEtPbzlqaytYTHMvTEpuaVRJMHI3?=
 =?utf-8?B?Slg5eURXQUlNcXNiSkh1NWdEblBxckxPUFNLTS9wc1B1cWZEZnhuSzZ2dlZl?=
 =?utf-8?B?NXJaSVRDTXVPdko1dWxRS0x4OEVNU3UrZHdaMVc5Tk5CZEZYTU1jV1ZDUmZk?=
 =?utf-8?B?V0l6SmpnMFFTMmJWTStaMVQ3OHdZcEdOM2Z1eVR1ZnhLSDk5cmRJa25wR2Q0?=
 =?utf-8?B?VlJobXRxalpGbFp3TEFWSVFXTG5vRlY5dzViV3JsOEdhSHY2SS9oS0Vzbk82?=
 =?utf-8?B?MlBDNi9tNEN5WkRieTV4ZFdpcnVvQ3BXZ0FxU1hvL2xXNmVtZUgrc2FZSTVV?=
 =?utf-8?B?ZG1sc1JkOGNVNEFvZVpnY3N4Vm5rSEtGZ2k4ZVlOZFF2OVhKWjdPSmZKQzdP?=
 =?utf-8?B?Rm9jYk9PWkdsSk04aEZPMUxKOVVlR1hqUmtuaDcrSFFJbHZVSFRUcXZvdGt6?=
 =?utf-8?B?bG8xL1lvazIvWkxjZmxSZWZmK1NFcFFMb2tBb2V6dlllY2pwNWsyRVhDaVFa?=
 =?utf-8?B?NEJLMHBYenQrSXM3SzB3K3hzV1BJMXZwa1Z5YUdnUmFsd3RBM1duZVpvcHpX?=
 =?utf-8?B?azMxRHJia3ozN0l6T0NkRkRzajFNNWRGa1NHTW45dHJoVUVpeHdVc3E4bTl2?=
 =?utf-8?B?SXJKSXB2cjBkWm04OHVQMW9nSEJhdHJUUjU4dlZhU3J1Z0JUWUY0R0xJYlVz?=
 =?utf-8?B?N2JWNEdNT21jc1RYSkRkU2JiQTVuVGRwcjFJbGFPV01xRnFVeWRzT3VlUVcv?=
 =?utf-8?B?QnEvVHlyQWpKWEpHTmdDaytvVTlHL1ZrY1BTSUdZc0c1Vm9Ta0xEZk0xUE1H?=
 =?utf-8?B?MVJWNlVpUHFCenBnMHNEM1N4NHpkNE1wRkwwajdya0pVaTU5TUpQUG9pQXh6?=
 =?utf-8?B?TEk5cFV2cW9hRkhFUzlsdmNhdVF6VStVU2VzNnFTckxxVEQyOFlzYmRKZk5q?=
 =?utf-8?B?MUREaEVGYVhZaWJSbDlyMXhpbWlDa3RLWlpYdXdpeWM4MnozYXAyZ250TVMr?=
 =?utf-8?B?aTFBckxnN0pOZ3RxTTd2SlNCUDRGeUIzWGh3QnllMlREcXdHWVN6ajZpVlRC?=
 =?utf-8?B?M3B5TGJYeFU1THlxV1VDUUFNS2g1c3FZdmo3R0IrcXFMcE9mb1dzVHlObEI3?=
 =?utf-8?B?c0ltR1VvTkkvSmt5U2hyWDVGNWJzRHNJcmFJeURvMHBtRjJQRnJDVFFPWFBl?=
 =?utf-8?B?TWdFV0IwNzJWM08ycDR3ZDNMS29DN1FySDkxQ1BySlpqcFZEenBiTnBCZHA2?=
 =?utf-8?B?d0RQaWlCWmhUNDBnY1hBY08vZW85T0ZHbDhUS0x6VFVqcFBIdVF4OHNYRm1N?=
 =?utf-8?B?YWxWdEp0d0M0ZElibUw5K2FCL051Sm0vaGpGazgzNVk4VHlvYzAyZHFkVDJC?=
 =?utf-8?B?TnZFcmY5ek5ybnZ3SEtMMFphaFNTeVJZZkN2RnVuSXpYTG1jYkNOY1NXdlRv?=
 =?utf-8?B?S0lJRTV3SnduRWYzbHl4elNuMWVtWGpSN0JERjlISnBlM21TTU5tbzYzSDJT?=
 =?utf-8?B?aDNYZ2ttcTVJaUhnSWJFY3hDalUrYUZibDhsTHpNblhtTWs3WWtsUVY2ZEEv?=
 =?utf-8?B?N2ZQb2lMN2RGV0RsVjFnclhkNDgxdHVaQ1NQU0xqMjZoM3NiUmpsbThWZ01B?=
 =?utf-8?B?eWU0bFNtQnFnbWtVYjdrc0QzWU5tUW0xVFlkT0YvQXRRZklsdzI2c1RnUzVp?=
 =?utf-8?B?MXNMMzVCSmNGSlJxeitPcTE0ZlpkaG5hZE5sMEprbHB0QTNkeEcyM3FzdDZH?=
 =?utf-8?Q?8NYii942dTXq30nUFz?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eee9864-c990-4be4-3720-08da4c9e7db5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2022 18:08:02.3293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6o2aNX6VhaGM74MmXSZA9ueUMh/fzk8QOEbzQMZ0ASPQCjdLQk/QI81T1dEsHGj88Ljng2vSSwouQM0W1ANfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6350
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1
cnNkYXksIEp1bmUgOSwgMjAyMiAzOjE5IEFNDQoNClsuLl0NCg0KPiA+ID4gVGhpcyBpcyB0byBh
dm9pZCBzaWRlLWVmZmVjdHMgYXMgbm90ZWQgaW4NCj4gPiA+IGh0dHBzOi8vYnVnemlsbGEua2Vy
bmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjEzMTc5IGNhdXNlZCBieQ0KPiA+ID4gZGVsZXRpbmcg
dGhlIHZkcGEgZGV2aWNlIHdoZW4gaXQgaXMgYmVpbmcgdXNlZC4NCj4gPiA+ID4NCj4gPiBVc2Vy
IHNob3VsZCBiZSBhYmxlIHRvIGRlbGV0ZSB0aGUgZGV2aWNlIGFueXRpbWUuDQo+IA0KPiBJdCBy
ZXF1aXJlcyBhIHBvbGwgZXZlbnQgdG8gdXNlciBzcGFjZSBhbmQgdGhlbiBRZW11IGNhbiByZWxl
YXNlIHRoZSB2aG9zdC0NCj4gdkRQQSBkZXZpY2UuIFRoaXMgaXMgaG93IFZGSU8gd29ya3MuIFdl
IHByb2JhYmx5IG5lZWQgdG8gaW1wbGVtZW50DQo+IHNvbWV0aGluZyBsaWtlIHRoaXMuDQo+IA0K
WWVzLCBJIHJlbWVtYmVyIGhhbmcgd2l0aCBlaXRoZXIgdmZpbyBvciB2ZmlvLW1kZXYuDQoNCj4g
QnV0IG5vdGljZSB0aGF0LCBhdCB0aGUgd29yc3QgY2FzZSwgdXNlcnNhcGNlIG1heSBub3QgcmVz
cG9uZCB0byB0aGlzIGV2ZW50LA0KPiBzbyB0aGVyZSdzIG5vdGhpbmcgbW9yZSBrZW5yZWwgY2Fu
IGRvIGV4ZWNwdCBmb3Igd2FpdGluZy4NCj4gDQo+IFdlIG5lZWQgdG8gY29uc2lkZXIgc29tZXRo
aW5nIGRpZmZlcmVudC4gSSB1c2VkIHRvIGhhdmUgYW4gaWRlYSB0byBtYWtlDQo+IHZob3N0LXZk
cGEgY291cGxlIHdpdGggdkRQQSBsb29zZWx5IHdpdGggU1JDVS9SQ1UuIFdlIG1pZ2h0IGNvbnNp
ZGVyDQo+IGltcGxlbWVudGluZyB0aGF0Lg0KPg0KUmlnaHQuIEl0IG5lZWRzIGEgZGlmZmVyZW50
IHNvbHV0aW9uLiBBcyB5b3UgZGVzY3JpYmVkLCB2aG9zdC12ZHBhIGNhbm5vdCByZWx5IG9uIHRo
ZSB1c2VyIHNwYWNlIGludm9sdmVtZW50IGluIGZyZWVpbmcuDQpSZG1hIHV2ZXJicyBkb2VzIHRo
YXQgZm9yIGRldmljZSByZW1vdmFsIGNhc2VzIHRvIGRldGFjaCB0aGUgdXNlciBzcGFjZSBpb2N0
bCgpIGNvbnRleHQgd2l0aCBsb3cgbGV2ZWwgZGV2aWNlLg0KDQo+ID4gVXBwZXIgbGF5ZXJzIHdo
byBhcmUgdW5hYmxlIHRvIHBlcmZvcm0gdGVhcmRvd24gc2VxdWVuY2Ugc2hvdWxkIGJlDQo+IGZp
eGVkLg0KPiANCj4gSSB0aGluayB3ZSBwcm9iYWJseSBkb24ndCBuZWVkIHRvIGJvdGhlciB3aXRo
IGZhaWxpbmcgdGhlIGRldl9kZWwoKS4NCj4gV2UgY2FuIGNvbnNpZGVyIHRvIGZpeC93b3JrYXJv
dW5kIHRoZSB3YWl0aW5nIGZpcnN0Lg0KPiANCkxldHMgZml4IGl0IGFzIHlvdSBoaW50ZWQgd2l0
aCBTL1JDVS4NCldlIGRvbuKAmXQgbmVlZCB0byBhZGQgVUFQSSBmb3IgdGhlIGZpeC4NClVBUEkg
YW55d2F5IGRvZXNu4oCZdCB3b3JrLCB3aGVuIGRyaXZlci9zeXN0ZW0gbGV2ZWwgZXZlbnQgb2Nj
dXJzIHN1Y2ggYXMgZGV2aWNlIGZhdGFsIGVycm9yLCBzcmlvdiBkaXNhYmxlbWVudCwgc2YgcmVt
b3ZhbCBhbmQgbW9yZS4NClZob3N0LXZkcGEgc2hvdWxkIGJlIGFibGUgdG8gZGV0YWNoIGl0IGZy
b20gdGhlIHVuZGVybHlpbmcgZGV2aWNlLg0K
