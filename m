Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7E5682551
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjAaHCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjAaHBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 02:01:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE78423C69;
        Mon, 30 Jan 2023 23:01:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXc1iF4KCOFTOmG6xMRCYL4Olq1u5V9p+ZNJ77xJBMoEAybz1SkYO0eWWmOf8/QQYY10erCKnMtko3eY5LzuJmMPtPt8sC4NDpPmjmxwx7CQCiItUurrOVz/EYDjWwZ3tlQC4PSGJeLMWRNFYfJmBcPe2RqQ3sDXvTR8W6y6HGPUypnw0F1ka/o0R3Uhsj8iP7utoz65yJoqRq1AR79rTSRNDijOVCaD54CgSocHO5uFQPXjh0BmFbATm0Xh6vk1rZnWXPYsLSUXn+WP7TG6vbwScX9s5v7t+piH4JNghKkFo3WYVPLUZDJvO6P7pF5MY2TOXl3r0XyY+G12SAEgYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k690ucgayuawo1gQdRagUtKssLH4+f4ueFBdocbuAK8=;
 b=Ygvgr+pYEq2v/GNRvWPFqsWC0xvQeCDvwZICVs5HxtNQm8NdmWQPMyWnCZA9KYbPxitbXNjQ/uNKw4eOClea/IC/lEpe6jss8J+Cf1l1F43cQCT3kjFPMKruhWUYsYQD/r9/oFT6Tk26Zr6kou2GLVYMDH+efDk1iLtQXewByg5/XftB89UO7XBR8MKuiw9l6cM7UBKzyNEdWIeEdZrIu+Bz8UsnqncrzBHbm6iIV9nj+sJ1Uq+f6IDcPqzMfCY4TLHOnzF9NMgYo12IXrH2gh6p5YoEvsPToIRYSSXCj88cLzvheNnnXNFsSrw0HUm+9YHFPMPq18dmPTG/sAh+Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k690ucgayuawo1gQdRagUtKssLH4+f4ueFBdocbuAK8=;
 b=lU+2e4rizsf/+K3G+F6cpRdZmgbTIb31W7XwVQ4uh/CxSy/a+hfT3lyxjfTkkpqHvlNGG0RL5yzXgJJE+w+t535vq0Q62GEtz3r/McYPn1VWIFoFcC31PKWLeFRq+038zSrcupyB6zgLSL8ndUKDU9BF+h06bxy+HigZHspz7XBKbdPQNVmCTTweFAqRQYUqFXJ0FlfXl6o0/UjrUaGwCNqJMOfGXfNmFnxHsfwswtUm1BqmWiZcuAPjONwMaTZwKyFI1MGaZWhWvec+mDw7+AVzgr7oC7+Ira0IUoIIy9E7JjmvUPPVtRLKtLDtAFqpoShlH/4in51RPH/nGuVM4g==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 07:00:24 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 07:00:24 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Bo Liu <liubo03@inspur.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH] vhost-scsi: convert sysfs snprintf and sprintf to
 sysfs_emit
Thread-Topic: [PATCH] vhost-scsi: convert sysfs snprintf and sprintf to
 sysfs_emit
Thread-Index: AQHZNOG+Jqa8rI1X/0uCNRiQJ1hWtK64GZyA
Date:   Tue, 31 Jan 2023 07:00:24 +0000
Message-ID: <5b9bb698-dbb9-60af-10ee-767d9fad83d2@nvidia.com>
References: <20230129091145.2837-1-liubo03@inspur.com>
 <Y9gbe+Pr5AcGbcta@fedora>
In-Reply-To: <Y9gbe+Pr5AcGbcta@fedora>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|IA0PR12MB7674:EE_
x-ms-office365-filtering-correlation-id: 7b1d5a54-27ff-4478-aab6-08db0358d371
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9vNHQjeVFHdOfLbV5XS++fF6rU+9AC9MDYPNhJLznbvWOpLc6FoYSpU9W4CLmaJG51yAh6XQbmbBG7yY8Orlefwbd/8Fyu9gOOgC/7KqLUBQIXZqOvhaeyykGQaqklPLD62okXF8HFHgReSXFParkgnKKcUYa+pt17Nn+3TqpuEYI8Irwx9FHcXmYVpoxzCge5JzvVboeUM/TgTAiou0pnd8RIybWdE60k5v4stVTdroPwhWIGCoLz4wXlB/t5Xv+wX000RWoiTVXJUb/qFSnIgD/fN6znbmehemFJl9IGhzZLDfU7jVgl+itoclPG7f0Ab4zgDIvaXRReS9L+OetBPo4iA//HbtgxJmwLJ8RLd9GJY+oFeUsm9/w4KKTCkJ6I/kH2QgbmF3BGKVrkCuEe39I7a+cvRAHPR7euTco0QP1Ylssj/9ER1TDvAzu+vYbFkckOFiOHeB8CatL2fzsZvjuiKbiVBHcNga2/UrKSOTIhdM6Mkd36fzgYqVV32zFnK+0JP2AHi2EjdW875TsT9Gpaj4qF1utPUfYOkTJhg5doUoNDa2dsDraZKFBQCxeTW8sD7qI1SIEJBPsR/6u+GafiwBF50ObtNptaJn7BsWCVrF+6GtjdrcuP6tIoJlTjcQxAZlpTB9epcqNZ3B1qcGo9hd6c5hJqPmLGnSM4TrPgISaVaSosUE7qKI8zWy//uOQiP2jxhmTnRWHoF1sc2kWt9TeBOdWJTRbLT6oGGev6lj9d4wUn79qgzZpigLPoE9tgErOZYoEJCig2b3Ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(4744005)(31686004)(5660300002)(8936002)(2906002)(41300700001)(2616005)(6916009)(8676002)(38070700005)(122000001)(54906003)(66476007)(66556008)(66446008)(478600001)(36756003)(316002)(4326008)(38100700002)(6486002)(64756008)(71200400001)(86362001)(6512007)(83380400001)(186003)(31696002)(53546011)(6506007)(91956017)(66946007)(76116006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWdKNXNTQzhGVk9pQWNrU0dSeHp3Vkw2cmtFWWhGODdIU2FQVzB2UU11ZXhT?=
 =?utf-8?B?dmg3cXlsa0dwMnFpMlJoU1JaVnlLWGIzejdsRHF1dFhXSXZYZlU2b3d1bTM0?=
 =?utf-8?B?NzVuMmJyeG1LZkVIYnZjNy82eWNNTnhqMnlOUFNMbEwzSUkvMG43eXQ1QXVH?=
 =?utf-8?B?K2JoTFlSbEhsWXlBYVR3bmtTSXJMU2tpNDhDQTZFN0t6QmtySmhPbEd1aEcv?=
 =?utf-8?B?cmFyS21QLzRlckMzV2c2MXNsVSsvK2d1MU0zOHp4TEN1dVZBdzlXSFVURGFK?=
 =?utf-8?B?ZTlrM0xjVDgzQVVQam1GU0xvTWVWWjlNYmRGdnFDRU42dlBWVHU5YVBvdGZP?=
 =?utf-8?B?ZkQ1SU9qWkhpTWtNOTVhVVFLYXFPdmtYV0wzd2w3WUk5ajVCNDQ5OXdYdmhG?=
 =?utf-8?B?RnM5MGtDaDhpNE14ci94K0p1RjZCOHArMTBoN1JoQytYb255U2ZwWjBtbjVX?=
 =?utf-8?B?alJ3c01Wb05sRDQ5bFRTOWlIaDZPVVZraGloNTl4WDZBU0dWZk55dFVSVkd2?=
 =?utf-8?B?V3NnbUpBSWFRMGRSbjhrRkxxT0pBRjdGSkY4em1XUWQ3TTk2OHFOQVBHbWtU?=
 =?utf-8?B?M2o2Ny9oTEoyeDYvRnZ2Yy9WWklXWVJNQlhSeThvQzdnQVFpRkdPNm8zWDBG?=
 =?utf-8?B?N2pzRU5HbG5qMjk5ZTlQV21sM2NWMDl0b1RzNW9SRjY0SGxMMmFlcm45Nis5?=
 =?utf-8?B?M0l0bXV2bWtBRzJqUVpZRXFxQmJuUEt4UEdrTS9jWks0TTdRU3B2WXJTTVo0?=
 =?utf-8?B?NkdCZitEbHI2NHVLNVlMSlpkVUoyTzV3M2F2R3EwZFlXWXNKdlBOTlBXM3Fj?=
 =?utf-8?B?aFNDL0xPRm00S2RlbkwyTmc0bXo3bXpPOFNMT3lUNkxXSndOaWdRVTNnQzBw?=
 =?utf-8?B?Y040TzJ3aEpVN3IweDRrTXNsaml1RG1oWWhPZWc3dDRCRkRZQ1lDS2hOWHFL?=
 =?utf-8?B?VVFGZWdyY0ZLbHJEd3o5M1RSdEpCMXhtYks1VU5qQk5QZk9CNkZvVWpRN1Z1?=
 =?utf-8?B?U0FTMDY2dFIzcEQ5L0RENGZXNWYvSjg5b2V6NVV3UEUvRU12UWg0Z2U1VnBk?=
 =?utf-8?B?eWVMUEFMU0dGcVJYRHFieVlFK1FpREwzK2ZrR0pnMXlyZXVhNmlZNk1XSnlT?=
 =?utf-8?B?RGpCTUhoRGo1VlEwUHA2OHpXdGMrQjFiRVJUcGd5MVREeURBWG96T2tjL2dm?=
 =?utf-8?B?aVdoN1djb2RFNktMS3RCN01PdnBqRUJzMkhQZ2k0VW9ZQ1RYZnl6UVhLRnc0?=
 =?utf-8?B?b3laY1E0MGl4WUJLV2xvQzNBcU1ZL2IvekJFR2R6TU14K0dNOHUxOHl6dXVj?=
 =?utf-8?B?ZGIzczFkOHNNRFBEZHFoa3BmQnZhUHd1bDQwUmFWWnRiTTNRUUs4N0g2eks1?=
 =?utf-8?B?ejBEdC8zWW1SYUJZNUJoRXNDaUYrbklNWld0ZElTUzlBNHEyYlZSZVR0UE40?=
 =?utf-8?B?OTVrbWQ2NDRPZGZCaUoyOXBKK2ZTQ044VlVLM0JGTkplOVpQd0JnZ3pMbWZJ?=
 =?utf-8?B?UlIxVnZIWEp4c25vMHRpNTFmZHIyTHhyTTVYZExBbEFGSU1SRzZCZ0Z2WkdO?=
 =?utf-8?B?bW5LblFqWUF3SGowYURQNTYzeUFrbDVoTmlFRVJubWxpNzM2bW1xcTdvZmtD?=
 =?utf-8?B?MnVaYnNZWitLb0FIazNFYTdSYlc0VmtXblh3T1p2ekM1TzcxSzVZa3l2aDBX?=
 =?utf-8?B?YnJLbVF5cm16WHhIbzZ0SUhZUTdwK1lKQWYySmFpeGtDelNMZVRjM04yaUtE?=
 =?utf-8?B?RVVqdmxXR1lXVFZVQnloZWdiOWxCbndiMDV0UGt2SWppVWdzeU9yUWVic2Fh?=
 =?utf-8?B?L0xtWjBNanY1bUQydlQrMS9tYmIwYVNidXlRNDVBL0tKWlAwZGdYajUrNWZS?=
 =?utf-8?B?Z2w2RGNQR0hUS0ptSWRvQmN4RGNVT2VGeWMxRjVWQ0I1bHdzWHVzemgzRU9R?=
 =?utf-8?B?ZEVMTHlkYjdpTmhPOVZaa0NvOXpXV2pHYlJLTnJDWTNuNnQ2Tzk0THY2Vk5R?=
 =?utf-8?B?cEVxNlJwS1FkazMybVlKdnZjaDJrcjZPaEpRUVd2S3ZkVDNxWjdCb0pIczVl?=
 =?utf-8?B?dWZVejFsZG5hQzVjOGdZclBJQTduR2Y4T0lhdElIdS8yNHEwOTJQT0lYWWVW?=
 =?utf-8?B?aU1jSGp0QzlUYnBWOEVWQmxvTmsreGZ4VDFTTmdOWFVNSnE5VEVVVzJtTTVI?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <433FFFBA2099694298E7EE9A08927E20@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b1d5a54-27ff-4478-aab6-08db0358d371
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2023 07:00:24.1879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wxWJkETWu/Blfl9jYQGdgcrUYGlAlmsmKB/4egVyxqiHYiFVTFEtVHwLRPWi+HT9vn06ixTFUNcuc2NmKD/vXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7674
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8zMC8yMyAxMTozMywgU3RlZmFuIEhham5vY3ppIHdyb3RlOg0KPiBPbiBTdW4sIEphbiAy
OSwgMjAyMyBhdCAwNDoxMTo0NUFNIC0wNTAwLCBCbyBMaXUgd3JvdGU6DQo+PiBGb2xsb3cgdGhl
IGFkdmljZSBvZiB0aGUgRG9jdW1lbnRhdGlvbi9maWxlc3lzdGVtcy9zeXNmcy5yc3QNCj4+IGFu
ZCBzaG93KCkgc2hvdWxkIG9ubHkgdXNlIHN5c2ZzX2VtaXQoKSBvciBzeXNmc19lbWl0X2F0KCkN
Cj4+IHdoZW4gZm9ybWF0dGluZyB0aGUgdmFsdWUgdG8gYmUgcmV0dXJuZWQgdG8gdXNlciBzcGFj
ZS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBCbyBMaXUgPGxpdWJvMDNAaW5zcHVyLmNvbT4NCj4+
IC0tLQ0KPj4gICBkcml2ZXJzL3Zob3N0L3Njc2kuYyB8IDYgKysrLS0tDQo+PiAgIDEgZmlsZSBj
aGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KDQpMb29rcyBnb29k
Lg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0K
LWNrDQoNCg==
