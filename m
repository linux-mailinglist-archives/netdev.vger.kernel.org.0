Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7750540FC12
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344838AbhIQPUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:20:55 -0400
Received: from mail-mw2nam12on2053.outbound.protection.outlook.com ([40.107.244.53]:15265
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344528AbhIQPSJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 11:18:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmPVCN89W5ivjJPZcKMnXFwG4SnCfD6G+8hze7VyzVNgDP5zfv7TYqbW0eJ9JhltOniGjunVd0vaa1AzIwje/JIAlAK4blaqB1UgIvkTGoKvcc/8AP7+ous/47CnZRHIGqNMDs8PD02R6OP8l+rdLIEdxL9w/XOQu9nqpUk15v1NJQ+YJusKQYa/Mvwlzd13XaxFcw4hNgt4g0kAx6xoA4Ra225iVSTD+y80iyAf+aGb/FTuGp2SR2oXuTt4Xp2NeMKY3oWZ221lttmIPAVhrCn4suTLyEfpI0SuFMjnDfctPYykaIaPPxd9yAxcFnCp7ydr+uU5wfe7KjY8mupRQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dEk3+qj4e1ksJvrrPFbprdR/znDZKjI5IcYfuaq0J5c=;
 b=LeWwOoIu1tS0RuJH93j/BPqJ4WhUdJywqOWdV3DDobvI+UepzBbXZ9M26tTz0ibnb8n/QIhmQn0I9ee2gKjjWW0u68AJHixKYRQDne7g6arPHORYGxHCo5VEliJHRCdBabuwSXJyblJAcIdZA3SQnztDl3n8vKgRxz/Ntk0GICJViIm08yi2BtBGnGVciyvrRii6/LL0DiUkAj8jxHBT3n1ofPxgUGTy7Jv68aZhrp/zRNEXNYJfFH65/d8fcsUVHCI7n1b6uuUF5qGC1vrJ+au9oaOZGg3DAeuN7AY7YJNp7a6z43hdzRy3Iihsyq/U7Aj8s5/5Ax9eMM+933Xmdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEk3+qj4e1ksJvrrPFbprdR/znDZKjI5IcYfuaq0J5c=;
 b=Jm81Uy9mcFeZvpxjMSDNZKNE8prW/OUebXKeJQN3wPX0Rgc19DJis3h87Zb0KX+xXROqI0SMn+AdAVtKIDWgpAxNLNBenitdVWBWf9e8QiCITgn9AMxHbNRH88ANy7884KC20iQX/9fEkLD9QLrVybZrVI9328ANBeh6G5hZ7VQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4876.namprd11.prod.outlook.com (2603:10b6:806:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 15:15:09 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 17 Sep 2021
 15:15:09 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v6 20/24] wfx: add scan.c/scan.h
Date:   Fri, 17 Sep 2021 17:13:56 +0200
Message-Id: <20210917151401.2274772-21-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
References: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA9PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:806:20::34) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SA9PR03CA0029.namprd03.prod.outlook.com (2603:10b6:806:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 15:15:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab54259c-6abe-4f22-1538-08d979edf041
X-MS-TrafficTypeDiagnostic: SA2PR11MB4876:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB487623928028AA2069881D5A93DD9@SA2PR11MB4876.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wEIqF4tA5NKDUgQGC6sw6lJVaY+raPpsizFUw+x+CZEfrPwYRMrW4i/K9at5Fo+lRgt6TBAlmNhoSiIuCDZGtG04RtyjE6EnIjKzg+s/eybwi7vaM40kjOQadBIhXyZ8MYIquwmSRdmIAk3S7dAJCJGgHpKjiQ3jw7VzIQE+lHIl1qhrfk14ulMCmCoFjyak3jryQwrMw8RvDuVjFlYOB+d9sA4lxHRqH+oYLPdkbkmJ+ihwQX7AwwGMvzs8QEiioSo930ihG4uL936jrDdtQ0kjxcjdt03wXlpn/fetRe7N0f4tgEZlYyv+DA1v4Inqj4FQXlN5VPRFom7xL+3dFi//j3RaVzOFfTuJtwaMqNydNwDOTWgQmdy8x8CMRVyI2yVk5cMGZA04L8ZhjUVoLjeq9jJLBgIGOm28ISANzrvIs0eQtfmmvHEJH28w3DCc8fLYg8LUGa7t/knVccgSy7plbHolyJielCkyRTcPi6Msg6MvE3Hi/NGGUOg5qWuWmEci+xGjzejdYUnkj1YKK87QzMi1MiHTTb+y+XM8ZAkDPTGEo/cVlWTgv4MZgLUley8eTXQDDk+fmx6hDcyLx0GWiFvOBwr4UJMrEMt1L/vHFK1oWFV3J8/MbXQzivwasmlSAT9UnoqTrezmgBX4sQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(1076003)(6486002)(38100700002)(107886003)(66574015)(36756003)(8936002)(2906002)(7416002)(54906003)(5660300002)(186003)(8676002)(508600001)(52116002)(7696005)(6916009)(66476007)(66946007)(66556008)(2616005)(86362001)(316002)(4326008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0hpMmFtWUI0cHlkQnJWeFdjRFF1S2VBVmVhYWxROFB6TjJobG5SRmFLSk9u?=
 =?utf-8?B?WC9RK0Yyd2V6UkVBS0dhaGpmbDRzVlltN1hhMkdUWHNWN1ZiWDFSTGorR0NU?=
 =?utf-8?B?TWpWMm9JMjhjRkRpWTB4RUlzdzhtMWN4WUlmVzRRVTZrQklZZ1VKaVpKUmV5?=
 =?utf-8?B?TjdFVFNEQ1hQNk5kQi8yVW5sWk43WVQ5Q3BzVWd2UTJQeUlIaC9MVGZOZlpF?=
 =?utf-8?B?VlkxOFBwVXk5dGR6YldQSkZyVzBBY0hoRWd0RnVIWnppZlZLdlVHQm5HdW4y?=
 =?utf-8?B?amtJZ05FbkdqeTkyUFRMckU4UWg0emRZQUY5SW05US9SdTkwMGF3SHljTDJx?=
 =?utf-8?B?emZNSmt4TWp5UUhNdTE1QnNsRy9kOG0vdG92VGc0MkMwamd4QnoyTjV6RzlU?=
 =?utf-8?B?aUcxN1lRTHZKR1pZdUN6bE4yNTBsNHBtN1NMdDNjQnJiRGo1VzR5UzlON3cx?=
 =?utf-8?B?MnpTekpiVmxFUnNHeHhZNkJMcWdWc1JhYjd1ZnBlQXF2dkE3WVNTdHlnTERT?=
 =?utf-8?B?NnBuM3hHM0ltNTBBOGdXWE8relQrVy9rOGhBWVFSVkRBR0VoU0xnUWFwcVpE?=
 =?utf-8?B?ZGVnVWx6amdFM21ScGlPdGhWb1l0MXNmNWlBVGRzc1VqUy9ta1pDajBhcEI3?=
 =?utf-8?B?dnF0bElKWnlOSlB1QWEwQ1NZVGNFU1JqQmtiS000clpieE1rY1dQa094a1hq?=
 =?utf-8?B?d1lYaXBFZDJzWHBaandOWVJ0dlVHU2trMlBVQTRoVFUxRGd4RGZkWlhjZzUx?=
 =?utf-8?B?bDAzNUIzNVhUZWhFS0N6eXZ4NnArMytPcWh1YjU2TkVoNTB5VmRaV3h1MlRn?=
 =?utf-8?B?NkwwK1JhOVFOZDVEYlJoZHY1Q2o1VE1sN2dYanZqbWFiOW9SbUdGREU4Tnpx?=
 =?utf-8?B?WGQ5RGtWR0Y1clc4Z2x0N3pkMGZRT0xwdExOanQrdVZ4TzRlQTRBL0dDWFMw?=
 =?utf-8?B?OVJJWDZnQ0dicXdYWG1zZTlKYndMSXNiOG1rQWRWcjNTd1BJa1hXZVRyR05r?=
 =?utf-8?B?OHlyUU5QazFCWmt2L1ZWMHhFaWlmUUNCZXZlNDA2OUN4VHo2WGFxQlVVN3Vo?=
 =?utf-8?B?cW96aXRucytmYXhWVGRtZjFXVEYxNmhOM2FJVS80NkRLS2NacjJyY3p3bUJi?=
 =?utf-8?B?K0FNeDF2aVdnNWJUVUI0TE9tbkwyYllMMnhsQWVBVlF3QXJUeElUZ3NUVVVB?=
 =?utf-8?B?NllqMzhpV3ArUnFpcnBGVkRYSnI2clVpWTZGTmFMT3ozU2R2UEpPUDh5Z2Z4?=
 =?utf-8?B?dmxKQTFweUlhUkpPNTJRZkJSSnNjb3ZkYWtDTjl0d3dHOHYzWDRxQW56elZ2?=
 =?utf-8?B?VFdtNGxDR3VCaGxXZTZQZllPK0k5QlJPano4ZTJaQXZKRTAxeDFmQkJDcUVo?=
 =?utf-8?B?V0hhRHIwRFp6cm5pYVVpUWxZVld2MlNoTk16ckdVaG1Kd29jQWNrZ010ejBC?=
 =?utf-8?B?MUhPeEc5amNxMmFqcC9Ccm51TTBMS1JrS3NPVkNoWEErTmJwcXVRQmdSc2hD?=
 =?utf-8?B?NUJuMEFrNXhvY3haaVh1TzFPVEZiWjcrdzNSd2U5YUZNRFIzNWYzbWsyak9x?=
 =?utf-8?B?R3ZGcDYvRkl0YUFJZlgyOW92bDJyY0N2b0xFT2MreUR2WlFES0pQL3FYbE4w?=
 =?utf-8?B?Z0c0b1JUSXI5SjNhUmhqVUxKK2FETGQ0WklSUm90N1llcTZvbGQ1WU81ekdS?=
 =?utf-8?B?OW1rZE1Jb0dFTkQ1Z3F3Z25wb2VIN0ticnRBWTVRNkRJL01UU3VXdXNhN2xk?=
 =?utf-8?B?akpid0dyVW5NNitCOWxaL0dOU0NZYk9uTFdQUnNxbzRETG5yYVdxbTdLNWJq?=
 =?utf-8?B?Nmt1WHNybUluOUNTMit1UTQ1VENxOHlEbUZaa0VKM1ZySmk0RUV6a01xWmpn?=
 =?utf-8?Q?K2iWxeiToT9ld?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab54259c-6abe-4f22-1538-08d979edf041
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 15:15:09.7511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZZLzn5jJh9zotCoMGDsHZ5DYjeL0uQ/1Qh4bAid6XAyWT32IgdmGIgLT7x1G8FmW+Fzizdpe6f+YGemM39owA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4876
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5jIHwgMTQ4ICsrKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nh
bi5oIHwgIDIyICsrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTcwIGluc2VydGlvbnMoKykKIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uYwogY3Jl
YXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5oCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9zY2FuLmMgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3NjYW4uYwpuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLjBjYzk3ZGZhYzUyNgotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvc2Nhbi5jCkBAIC0wLDAgKzEsMTQ4IEBACisvLyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5CisvKgorICogU2NhbiByZWxhdGVk
IGZ1bmN0aW9ucy4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTctMjAyMCwgU2lsaWNvbiBMYWJv
cmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwgU1QtRXJpY3Nzb24KKyAqLwor
I2luY2x1ZGUgPG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAic2Nhbi5oIgorI2luY2x1ZGUg
IndmeC5oIgorI2luY2x1ZGUgInN0YS5oIgorI2luY2x1ZGUgImhpZl90eF9taWIuaCIKKworc3Rh
dGljIHZvaWQgX19pZWVlODAyMTFfc2Nhbl9jb21wbGV0ZWRfY29tcGF0KHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LAorCQkJCQkgICAgICBib29sIGFib3J0ZWQpCit7CisJc3RydWN0IGNmZzgwMjEx
X3NjYW5faW5mbyBpbmZvID0geworCQkuYWJvcnRlZCA9IGFib3J0ZWQsCisJfTsKKworCWllZWU4
MDIxMV9zY2FuX2NvbXBsZXRlZChodywgJmluZm8pOworfQorCitzdGF0aWMgaW50IHVwZGF0ZV9w
cm9iZV90bXBsKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAorCQkJICAgICBzdHJ1Y3QgY2ZnODAyMTFf
c2Nhbl9yZXF1ZXN0ICpyZXEpCit7CisJc3RydWN0IHNrX2J1ZmYgKnNrYjsKKworCXNrYiA9IGll
ZWU4MDIxMV9wcm9iZXJlcV9nZXQod3ZpZi0+d2Rldi0+aHcsIHd2aWYtPnZpZi0+YWRkciwKKwkJ
CQkgICAgIE5VTEwsIDAsIHJlcS0+aWVfbGVuKTsKKwlpZiAoIXNrYikKKwkJcmV0dXJuIC1FTk9N
RU07CisKKwlza2JfcHV0X2RhdGEoc2tiLCByZXEtPmllLCByZXEtPmllX2xlbik7CisJaGlmX3Nl
dF90ZW1wbGF0ZV9mcmFtZSh3dmlmLCBza2IsIEhJRl9UTVBMVF9QUkJSRVEsIDApOworCWRldl9r
ZnJlZV9za2Ioc2tiKTsKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBzZW5kX3NjYW5fcmVx
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAorCQkJIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3Qg
KnJlcSwgaW50IHN0YXJ0X2lkeCkKK3sKKwlpbnQgaSwgcmV0OworCXN0cnVjdCBpZWVlODAyMTFf
Y2hhbm5lbCAqY2hfc3RhcnQsICpjaF9jdXI7CisKKwlmb3IgKGkgPSBzdGFydF9pZHg7IGkgPCBy
ZXEtPm5fY2hhbm5lbHM7IGkrKykgeworCQljaF9zdGFydCA9IHJlcS0+Y2hhbm5lbHNbc3RhcnRf
aWR4XTsKKwkJY2hfY3VyID0gcmVxLT5jaGFubmVsc1tpXTsKKwkJV0FSTihjaF9jdXItPmJhbmQg
IT0gTkw4MDIxMV9CQU5EXzJHSFosICJiYW5kIG5vdCBzdXBwb3J0ZWQiKTsKKwkJaWYgKGNoX2N1
ci0+bWF4X3Bvd2VyICE9IGNoX3N0YXJ0LT5tYXhfcG93ZXIpCisJCQlicmVhazsKKwkJaWYgKChj
aF9jdXItPmZsYWdzIF4gY2hfc3RhcnQtPmZsYWdzKSAmIElFRUU4MDIxMV9DSEFOX05PX0lSKQor
CQkJYnJlYWs7CisJfQorCXdmeF90eF9sb2NrX2ZsdXNoKHd2aWYtPndkZXYpOworCXd2aWYtPnNj
YW5fYWJvcnQgPSBmYWxzZTsKKwlyZWluaXRfY29tcGxldGlvbigmd3ZpZi0+c2Nhbl9jb21wbGV0
ZSk7CisJcmV0ID0gaGlmX3NjYW4od3ZpZiwgcmVxLCBzdGFydF9pZHgsIGkgLSBzdGFydF9pZHgp
OworCWlmIChyZXQpIHsKKwkJd2Z4X3R4X3VubG9jayh3dmlmLT53ZGV2KTsKKwkJcmV0dXJuIC1F
SU87CisJfQorCXJldCA9IHdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmd3ZpZi0+c2Nhbl9j
b21wbGV0ZSwgMSAqIEhaKTsKKwlpZiAoIXJldCkgeworCQloaWZfc3RvcF9zY2FuKHd2aWYpOwor
CQlyZXQgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQoJnd2aWYtPnNjYW5fY29tcGxldGUs
IDEgKiBIWik7CisJCWRldl9kYmcod3ZpZi0+d2Rldi0+ZGV2LCAic2NhbiB0aW1lb3V0ICglZCBj
aGFubmVscyBkb25lKVxuIiwKKwkJCXd2aWYtPnNjYW5fbmJfY2hhbl9kb25lKTsKKwl9CisJaWYg
KCFyZXQpIHsKKwkJZGV2X2Vycih3dmlmLT53ZGV2LT5kZXYsICJzY2FuIGRpZG4ndCBzdG9wXG4i
KTsKKwkJcmV0ID0gLUVUSU1FRE9VVDsKKwl9IGVsc2UgaWYgKHd2aWYtPnNjYW5fYWJvcnQpIHsK
KwkJZGV2X25vdGljZSh3dmlmLT53ZGV2LT5kZXYsICJzY2FuIGFib3J0XG4iKTsKKwkJcmV0ID0g
LUVDT05OQUJPUlRFRDsKKwl9IGVsc2UgaWYgKHd2aWYtPnNjYW5fbmJfY2hhbl9kb25lID4gaSAt
IHN0YXJ0X2lkeCkgeworCQlyZXQgPSAtRUlPOworCX0gZWxzZSB7CisJCXJldCA9IHd2aWYtPnNj
YW5fbmJfY2hhbl9kb25lOworCX0KKwlpZiAocmVxLT5jaGFubmVsc1tzdGFydF9pZHhdLT5tYXhf
cG93ZXIgIT0gd3ZpZi0+dmlmLT5ic3NfY29uZi50eHBvd2VyKQorCQloaWZfc2V0X291dHB1dF9w
b3dlcih3dmlmLCB3dmlmLT52aWYtPmJzc19jb25mLnR4cG93ZXIpOworCXdmeF90eF91bmxvY2so
d3ZpZi0+d2Rldik7CisJcmV0dXJuIHJldDsKK30KKworLyogSXQgaXMgbm90IHJlYWxseSBuZWNl
c3NhcnkgdG8gcnVuIHNjYW4gcmVxdWVzdCBhc3luY2hyb25vdXNseS4gSG93ZXZlciwKKyAqIHRo
ZXJlIGlzIGEgYnVnIGluICJpdyBzY2FuIiB3aGVuIGllZWU4MDIxMV9zY2FuX2NvbXBsZXRlZCgp
IGlzIGNhbGxlZCBiZWZvcmUKKyAqIHdmeF9od19zY2FuKCkgcmV0dXJuCisgKi8KK3ZvaWQgd2Z4
X2h3X3NjYW5fd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCit7CisJc3RydWN0IHdmeF92
aWYgKnd2aWYgPSBjb250YWluZXJfb2Yod29yaywgc3RydWN0IHdmeF92aWYsIHNjYW5fd29yayk7
CisJc3RydWN0IGllZWU4MDIxMV9zY2FuX3JlcXVlc3QgKmh3X3JlcSA9IHd2aWYtPnNjYW5fcmVx
OworCWludCBjaGFuX2N1ciwgcmV0LCBlcnI7CisKKwltdXRleF9sb2NrKCZ3dmlmLT53ZGV2LT5j
b25mX211dGV4KTsKKwltdXRleF9sb2NrKCZ3dmlmLT5zY2FuX2xvY2spOworCWlmICh3dmlmLT5q
b2luX2luX3Byb2dyZXNzKSB7CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRldiwgImFib3J0IGlu
LXByb2dyZXNzIFJFUV9KT0lOIik7CisJCXdmeF9yZXNldCh3dmlmKTsKKwl9CisJdXBkYXRlX3By
b2JlX3RtcGwod3ZpZiwgJmh3X3JlcS0+cmVxKTsKKwljaGFuX2N1ciA9IDA7CisJZXJyID0gMDsK
KwlkbyB7CisJCXJldCA9IHNlbmRfc2Nhbl9yZXEod3ZpZiwgJmh3X3JlcS0+cmVxLCBjaGFuX2N1
cik7CisJCWlmIChyZXQgPiAwKSB7CisJCQljaGFuX2N1ciArPSByZXQ7CisJCQllcnIgPSAwOwor
CQl9CisJCWlmICghcmV0KQorCQkJZXJyKys7CisJCWlmIChlcnIgPiAyKSB7CisJCQlkZXZfZXJy
KHd2aWYtPndkZXYtPmRldiwgInNjYW4gaGFzIG5vdCBiZWVuIGFibGUgdG8gc3RhcnRcbiIpOwor
CQkJcmV0ID0gLUVUSU1FRE9VVDsKKwkJfQorCX0gd2hpbGUgKHJldCA+PSAwICYmIGNoYW5fY3Vy
IDwgaHdfcmVxLT5yZXEubl9jaGFubmVscyk7CisJbXV0ZXhfdW5sb2NrKCZ3dmlmLT5zY2FuX2xv
Y2spOworCW11dGV4X3VubG9jaygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7CisJX19pZWVlODAy
MTFfc2Nhbl9jb21wbGV0ZWRfY29tcGF0KHd2aWYtPndkZXYtPmh3LCByZXQgPCAwKTsKK30KKwor
aW50IHdmeF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjEx
X3ZpZiAqdmlmLAorCQlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVzdCAqaHdfcmVxKQorewor
CXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3ZnhfdmlmICopdmlmLT5kcnZfcHJpdjsK
KworCVdBUk5fT04oaHdfcmVxLT5yZXEubl9jaGFubmVscyA+IEhJRl9BUElfTUFYX05CX0NIQU5O
RUxTKTsKKwl3dmlmLT5zY2FuX3JlcSA9IGh3X3JlcTsKKwlzY2hlZHVsZV93b3JrKCZ3dmlmLT5z
Y2FuX3dvcmspOworCXJldHVybiAwOworfQorCit2b2lkIHdmeF9jYW5jZWxfaHdfc2NhbihzdHJ1
Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKK3sKKwlzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+ZHJ2X3ByaXY7CisKKwl3
dmlmLT5zY2FuX2Fib3J0ID0gdHJ1ZTsKKwloaWZfc3RvcF9zY2FuKHd2aWYpOworfQorCit2b2lk
IHdmeF9zY2FuX2NvbXBsZXRlKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgbmJfY2hhbl9kb25l
KQoreworCXd2aWYtPnNjYW5fbmJfY2hhbl9kb25lID0gbmJfY2hhbl9kb25lOworCWNvbXBsZXRl
KCZ3dmlmLT5zY2FuX2NvbXBsZXRlKTsKK30KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3NpbGFicy93Zngvc2Nhbi5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9z
Y2FuLmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi43OGUzYjk4NGYz
NzUKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3Nj
YW4uaApAQCAtMCwwICsxLDIyIEBACisvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIu
MC1vbmx5ICovCisvKgorICogU2NhbiByZWxhdGVkIGZ1bmN0aW9ucy4KKyAqCisgKiBDb3B5cmln
aHQgKGMpIDIwMTctMjAyMCwgU2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdo
dCAoYykgMjAxMCwgU1QtRXJpY3Nzb24KKyAqLworI2lmbmRlZiBXRlhfU0NBTl9ICisjZGVmaW5l
IFdGWF9TQ0FOX0gKKworI2luY2x1ZGUgPG5ldC9tYWM4MDIxMS5oPgorCitzdHJ1Y3Qgd2Z4X2Rl
djsKK3N0cnVjdCB3ZnhfdmlmOworCit2b2lkIHdmeF9od19zY2FuX3dvcmsoc3RydWN0IHdvcmtf
c3RydWN0ICp3b3JrKTsKK2ludCB3ZnhfaHdfc2NhbihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywg
c3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKKwkJc3RydWN0IGllZWU4MDIxMV9zY2FuX3JlcXVl
c3QgKnJlcSk7Cit2b2lkIHdmeF9jYW5jZWxfaHdfc2NhbihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZik7Cit2b2lkIHdmeF9zY2FuX2NvbXBsZXRlKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgbmJfY2hhbl9kb25lKTsKKworI2VuZGlmCi0tIAoyLjMz
LjAKCg==
