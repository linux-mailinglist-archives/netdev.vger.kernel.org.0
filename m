Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C82366A4A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 13:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbhDUL7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 07:59:02 -0400
Received: from mail-bn7nam10on2115.outbound.protection.outlook.com ([40.107.92.115]:45537
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239498AbhDUL6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 07:58:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLk2bHdOxsmrHLEIqfQ6FZXRg3UUcWz8DRaNX95G1l2hb4riv2n0+HQn8NKMve4WNXNlfabpmhzkwXG0jgiS1aJZrt0QM7XFu0v3hIO7CQZ7DOQTv5Ayx+/Qh9YQUUFc67osIq6Qc5lRB1lbwlhN7FifuYBZA/RCwu30x1wtD2dWBFwsDkRbDwgy+PTktb54IvOzrkZlSeMSJvmaY7IXbdfHZJ0d4BKVXAgdM+6z8tHCnoqDMliA65ZUwT10GRad1Yi1j58cLcFMhTErUuAhkn/oO85voF3AQE0ei5ddE3uZbjUyh6KA6Sg+7znZ2rekdQPBnMmnNHvpeemnaKz8uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WWcd1J4U8jP57RzKSdcVBpVAUzwawTQv1ToOMAYlJQ=;
 b=FrFSGbT8qfLG7Pnbev4BnjhgLVJXXYQ3rNcQtMCRvwUE2zMtVivpb4NeiF12oYjjt7jABJ/w+uP3uFu4t7JAIRXtjoZlVuc6hkJi2lN9DovoJALYozuunHHXkrJOCE0vQ9fNutAYeuBxnPFHo4d2ikoBVybJDHh0UVjGeU+vmyKBw1bIP/D5toUzJ53Z9Iqm94h7GhD9mBDoX5M1eKCg39YZDVc3Kv+ZjVHEDR3RqKfE0oaC1X6ellqMTnY5rkU/FGAqXYJhCp7jKrXnyI26D2Uadg71FOzvM2+nfIeOPgaxXizQ/S/R6smn4UXZi1yvD2t5Zi1V0m387YN2uUizeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=northeastern.edu; dmarc=pass action=none
 header.from=northeastern.edu; dkim=pass header.d=northeastern.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=northeastern.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WWcd1J4U8jP57RzKSdcVBpVAUzwawTQv1ToOMAYlJQ=;
 b=RlKpSBviFbdURQImCoeeiN4CUONyj3qJRvcqTaETDTww49Fs+Dr5le15gBQxfSqNsurbMqwKVXhV0YpSElEcviCDbB4bu4sLByrxFS3nKHbipSw6bnoGabtjOhfbm8rtfENbZGgFMVxXANkkOnGR3xkHeVr3rpC3Do1SJ328O8g=
Received: from DM6PR06MB4250.namprd06.prod.outlook.com (2603:10b6:5:1e::11) by
 DS7PR06MB6888.namprd06.prod.outlook.com (2603:10b6:5:2d1::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.21; Wed, 21 Apr 2021 11:58:08 +0000
Received: from DM6PR06MB4250.namprd06.prod.outlook.com
 ([fe80::708f:a249:7dad:9d00]) by DM6PR06MB4250.namprd06.prod.outlook.com
 ([fe80::708f:a249:7dad:9d00%4]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 11:58:08 +0000
From:   "Shelat, Abhi" <a.shelat@northeastern.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Thread-Topic: [PATCH] SUNRPC: Add a check for gss_release_msg
Thread-Index: AQHXNqWYV4bM4K+6E0KzF42Hl+sk0A==
Date:   Wed, 21 Apr 2021 11:58:08 +0000
Message-ID: <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com> <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal> <YH+7ZydHv4+Y1hlx@kroah.com>
 <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
In-Reply-To: <YH/8jcoC1ffuksrf@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.20.0.2.21)
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=northeastern.edu;
x-originating-ip: [24.147.105.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 965b4d4e-66d7-4405-637d-08d904bcbadd
x-ms-traffictypediagnostic: DS7PR06MB6888:
x-microsoft-antispam-prvs: <DS7PR06MB688808FBFE2D57EFBCADB78CFD479@DS7PR06MB6888.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6AIVdHD/o9upeD5BgCZn/c6CQaQwYMyA1Ct0BrwLrGmuTW6fq0UDuKVKvIMEeF+uWL0AuGzNO4kEdonkvzOhueJd0il9Cd60NDqa7Xkb7akXhiO87Bpi6vO6HcYi6JZrU57bgn+017BujmxO0yKCa8CkJmzkjg4kn/UD6vJ+20TR2PFfdQX9PydlzZjds71lk9WK+FBX83nVfxSll8Tca3A+woRj+zjhOX9ZssDfpYfDHjxgebkMyGyHky1Q2Ex0O/BkmXfV+6Zat81Id4k6XHpQYndeNUVxSuvimkaJF+L4/UuWBCqUIBmbJd2BBfysvuOVu4n+7NgYTmguBxYaMeAoH4PmO+TNXnOJyipONQrBX9iC5aP+cGCdQC1WZkN8+uz7cpbDt4IRIvUHcyVGHp0eQknYEP7Jr8/XIafGrkO6lO1xKNmMRl2C9AVDCyKRdduVmcjfQTtT/jhBZzXUOzRnozmKQAuxC78vOXolEPq1eJYviUDdUSZFWsYKA74ioDvoV6ddAIZjAdP9p/83bf8tjmAgBnBaomTCUAE8NVoiJ1XtvDQCOlOWoaUqtEcM2/pTk76Ma5WkfZwROfTDykXCM1jesi/6+7ZVGyteSi8fSxzmVgIRenMjtgfsaKGk4hgHSsjYbYTzCuVHC1e4ppTEe6CQ+UhnenIGJpT7CO9sYYWE4ehi7fJwzjXgYfBQrcbVXQej8iR9+65O//Lml1M5OM7EIDRaUXow/bXdhMM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR06MB4250.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(786003)(66946007)(76116006)(316002)(5660300002)(91956017)(8676002)(64756008)(75432002)(66556008)(71200400001)(478600001)(2616005)(86362001)(6486002)(966005)(6506007)(66446008)(66476007)(83380400001)(54906003)(6916009)(186003)(38100700002)(33656002)(2906002)(26005)(6512007)(8936002)(122000001)(4326008)(7416002)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?czhXZTJnVnJhQUp2RHU5NEUvalp4Z2lheFVXazMzWWd5RUFLU0VQOUFvUFZy?=
 =?utf-8?B?dlpQU1lvdmd0SHVhWU9rUzlVZnZJc2VxQXU1OVZEbDVxbkk0Qi8rRXBFNkJo?=
 =?utf-8?B?ZnN4V1A5QXQxeUM1NndVQ280N0k2dzJwZzNYU0EvMUxCRHRMaHZTb3o3SHhu?=
 =?utf-8?B?TE01bDNaNHBmZml3a2ZIZDdsYzJjblc3OGRrdCtXZmx1aVFTWDhYdTVCdHFD?=
 =?utf-8?B?QjQxZ0RXRDRtY3lnM2lmMlFoQUE1VnJpeEI2R2NsTi8zK3VIaFQrMEtWbFAr?=
 =?utf-8?B?ZUIyQTMyMVFBVzNGSkdVankrMElTU2ZEUE9GZThyOWdKNnU2NlZjdTlRK00r?=
 =?utf-8?B?aTMvS1dxYmx1RTdTLyswZUpTRkMwNzJwVjJrTUcyc0toTU96a2NyR2NzNi9I?=
 =?utf-8?B?bXg0Q3JPRkdVN2dwcjliUjl3TTA2Z0RwNEJEMlprcFZHOGxHMDRjNk9DNEEv?=
 =?utf-8?B?WjFzRFhMWldNTHk3Qm5IOW55WFgrSExrclNQbzl1VjhKTVFweU8zWTg0d0F0?=
 =?utf-8?B?QTJyaU0wQ3JvbE8xRTBlaklYU0ZjcWtadFM3eGhDSlZ3QU5rVmNyUTcvN0pp?=
 =?utf-8?B?TmhBK0RPdm1HVmVVSXIzcmxwekM1ZCszRDh1Q2xnaEFXWHVqblNrQ2lYNFFv?=
 =?utf-8?B?MUNFUzNFL2tTRUlQbHgzU08yR1NjYkd0b2laZ2xZbVdMUEtDdm12N0N0YTdJ?=
 =?utf-8?B?c0xmd3ZXdkxLZmhubXlXWDNUaEhiRzJuTGpMdFZSZXl4T1JJZy91SWFUblBZ?=
 =?utf-8?B?SDYzWHI1eS8zTkl5L0xUa0pOK1hZaFFCeUNVenRuYktMWndqZ0ZtNkNDQnFi?=
 =?utf-8?B?blNxOGFFaU0xbWVFYUlUUlUxWjhwYkxQQWN4WXV2ZmZyV0ZJcDhnanJMRlNT?=
 =?utf-8?B?WVVEUlYzUW1WV25DZ0VxUTlNb0xyUDByNkp6Z2VrSXBPUWVWMWlyOXpYcW0v?=
 =?utf-8?B?dCtqSS9ySkE5V3cwRjZaTkloM0FvVWF4V3FpSmw1b3AyOEJ0blBOTmdzb1po?=
 =?utf-8?B?T3lrWnNwQytkQThqVzB2NXh5dDduNjBJQjVsYVFIaGtlOGpSblhtSllQNnNw?=
 =?utf-8?B?Zk1GR2d2eXFqaGJsUFNhejA2VThzWWdsSHA4eW5rNitBTlc4cFRXY2hrYnNo?=
 =?utf-8?B?M0NERlVDNjRJaVJTQUs5dFZxU0draG93SmZuMG5JRE5xWktrWFFrTGp5RE9B?=
 =?utf-8?B?RTYrR0p0eGRMbDkzK2lSV0dEMnJ1OHVPc0hIU2lEK3FFSnlsN2xteGQ1MldR?=
 =?utf-8?B?eWRDMG84K2VlYktBdmJtL1BQSmhCRnh1cTNJVi9kSGc4WkxZNis2VjErZHFN?=
 =?utf-8?B?N2tGY2FIaG5KY1M3M2NUZHRKdW9xTDdxUlRiUUFuU0wvclhDR1FTTnpuY3B0?=
 =?utf-8?B?bXVlYXQwbVFyVWdzYXcvUEZCZlNPVG56VGZLRmQwc2JER3VjcW9Fb0dJYjdn?=
 =?utf-8?B?S3JtNXFqcTQzQVpmY0V2VFBwRFNFMHJxaEY1ZWdlWjhxQU1lTEtKY2xrQ05x?=
 =?utf-8?B?MUhJTjJCSDR1RlRaOC91TWh5Tjc2YUZpaGhHdjFQSy9xbmpIbndXNGtYYmhl?=
 =?utf-8?B?SFcyQnovdjVnVXFGVXhNUGpMdDJ4MlpPU1U4MTBJTE13ZWtNYlFEdjFYQzZt?=
 =?utf-8?B?eE05NHhNcmxndDJQZ0xWcmV6TnZhZ0FDMXhmMTE1MkpSM1VUZnZ3dENBZmk0?=
 =?utf-8?B?M0w2U2FIUk5VdldFdTdXK0VUUWFMOEw4QThYZlEzdWpOQlJRbjU4aW9oTExk?=
 =?utf-8?B?NmhIYlhvc2drVEFkU0hiSW5lTkhTTDNiazdyQWxHbE5QWkFYYkswNncrTGli?=
 =?utf-8?B?L1dZdzhMTHFSMSswRitydz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B22015C0CB9A442A7E7F8D6D41B7CDA@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: northeastern.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR06MB4250.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 965b4d4e-66d7-4405-637d-08d904bcbadd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 11:58:08.4669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a8eec281-aaa3-4dae-ac9b-9a398b9215e7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jFW97S91zyYi2iTlKBzr3y7Iac7jdjV05m/OCcvHrbtOWoRciMV8m70HGfsMZa9WwPApOD3kjW2f3MhQ6EX5pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR06MB6888
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pj4gDQo+Pj4+IFRoZXkgaW50cm9kdWNlIGtlcm5lbCBidWdzIG9uIHB1cnBvc2UuIFllc3RlcmRh
eSwgSSB0b29rIGEgbG9vayBvbiA0DQo+Pj4+IGFjY2VwdGVkIHBhdGNoZXMgZnJvbSBBZGl0eWEg
YW5kIDMgb2YgdGhlbSBhZGRlZCB2YXJpb3VzIHNldmVyaXR5IHNlY3VyaXR5DQo+Pj4+ICJob2xl
cyIuDQo+Pj4gDQo+Pj4gQWxsIGNvbnRyaWJ1dGlvbnMgYnkgdGhpcyBncm91cCBvZiBwZW9wbGUg
bmVlZCB0byBiZSByZXZlcnRlZCwgaWYgdGhleQ0KPj4+IGhhdmUgbm90IGJlZW4gZG9uZSBzbyBh
bHJlYWR5LCBhcyB3aGF0IHRoZXkgYXJlIGRvaW5nIGlzIGludGVudGlvbmFsDQo+Pj4gbWFsaWNp
b3VzIGJlaGF2aW9yIGFuZCBpcyBub3QgYWNjZXB0YWJsZSBhbmQgdG90YWxseSB1bmV0aGljYWwu
ICBJJ2xsDQo+Pj4gbG9vayBhdCBpdCBhZnRlciBsdW5jaCB1bmxlc3Mgc29tZW9uZSBlbHNlIHdh
bnRzIHRvIGRvIGl04oCmDQo+PiANCg0KPHNuaXA+DQoNCkFjYWRlbWljIHJlc2VhcmNoIHNob3Vs
ZCBOT1Qgd2FzdGUgdGhlIHRpbWUgb2YgYSBjb21tdW5pdHkuDQoNCklmIHlvdSBiZWxpZXZlIHRo
aXMgYmVoYXZpb3IgZGVzZXJ2ZXMgYW4gZXNjYWxhdGlvbiwgeW91IGNhbiBjb250YWN0IHRoZSBJ
bnN0aXR1dGlvbmFsIFJldmlldyBCb2FyZCAoaXJiQHVtbi5lZHUpIGF0IFVNTiB0byBpbnZlc3Rp
Z2F0ZSB3aGV0aGVyIHRoaXMgYmVoYXZpb3Igd2FzIGhhcm1mdWw7IGluIHBhcnRpY3VsYXIsIHdo
ZXRoZXIgdGhlIHJlc2VhcmNoIGFjdGl2aXR5IGhhZCBhbiBhcHByb3ByaWF0ZSBJUkIgcmV2aWV3
LCBhbmQgd2hhdCBzYWZlZ3VhcmRzIHByZXZlbnQgcmVwZWF0cyBpbiBvdGhlciBjb21tdW5pdGll
cy4NCg0KQWxsIHJlc2VhcmNoZXJzIGF0IFVNTiBtdXN0IGNvbXBseSB3aXRoIHRoZWlyIEh1bWFu
IFJlc2VhcmNoIFByb3RlY3Rpb24gUHJvZ3JhbSBQbGFuIFsxXSwgYW5kIHRoZSBVTU4gd29ya3No
ZWV0IFsyXSB0byBkZXRlcm1pbmUgaWYgYSByZXNlYXJjaCBhY3Rpdml0eSBuZWVkcyBJUkIgYXBw
cm92YWwgaW5jbHVkZXMgdGhpcyBxdWVzdGlvbjoNCg0KPT09PQ0KV2lsbCB0aGUgaW52ZXN0aWdh
dG9yIHVzZSwgc3R1ZHksIG9yIGFuYWx5emUgaW5mb3JtYXRpb24gb3IgYmlvc3BlY2ltZW5zIG9i
dGFpbmVkIHRocm91Z2ggZWl0aGVyIG9mIHRoZSBmb2xsb3dpbmcgbWVjaGFuaXNtcyw/IFNwZWNp
ZnkNCndoaWNoIG1lY2hhbmlzbShzKSBhcHBseSwgaWYgeWVzOg0K4oCmDQpDb21tdW5pY2F0aW9u
IG9yIGludGVycGVyc29uYWwgY29udGFjdCB3aXRoIHRoZSBpbmRpdmlkdWFscy4gKCJpbnRlcmFj
dGlvbuKAnSkuDQo9PT0NCg0Kd2hpY2ggSSBiZWxpZXZlIGlzIHRydWUgYmFzZWQgb24gdGhpcyB0
aHJlYWQuDQoNCg0KWzFdIEh1bWFuIFJlc2VhcmNoIFByb3RlY3Rpb24gUHJvZ3JhbSBQbGFuDQpo
dHRwczovL2RyaXZlLmdvb2dsZS5jb20vZmlsZS9kLzBCNzY0NGg5TjJ2TGNWM0Z5TXpKS1luSkdl
REEvdmlldw0KWzJdIEh1bWFuIFJlc2VhcmNoIERldGVybWluYXRpb24NCmh0dHBzOi8vZHJpdmUu
Z29vZ2xlLmNvbS9maWxlL2QvMEJ3NExSRTlrR2I2OU1tNVRibGR4U1Zrd1Rtcy92aWV3DQo=
