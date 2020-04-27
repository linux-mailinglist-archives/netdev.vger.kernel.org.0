Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD1F1BA522
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgD0NmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:42:21 -0400
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:27104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728091AbgD0Nlg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyYOQ7bAVzSSajIbQmParbHG4LolEZxkyKbYjNssleEX33vYXNHhuSgHTvcCrlU2jAymr2HV7MoUOhCCfZe6JYafPu7+S/r90okjoTIelFf/YtBRyQic7NsYoSvSjLh2LvLi09ZvxIIZrtiJ4qSP4hcG9h2kfRLwQRvoJcunqenn6CbENeyNvxMUb2po7N5jd0lgL+Tt7tTe1HMpWIQqFalmwNyxrDT7oOEKd/SpGaiAcDfFukbpI/TbCt5pmSXNGoFnKGr71BR5NC/lwiHKCkM9aGZTYz4XPf00WiC2V4SO+2HN7AP8ld1R/DafamlTZCrao2AQVnHjUJ6YJFwFLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfI8C4D8XYBn/gT5TXywrCOmodway3QLz7Dgr0sbX2k=;
 b=U8guohqWx0M+oFeBsOfxR1zKJRWgM/0pWWYQsDHc4GQVGNR8OEWbpkWOEX9mn9V/SnlMOYZ0nCmQIbGsLNjxAwxElld6y0PVSXhxZyuREh53AOQGBY8QjE9UBlMoYfHkZidECGnxqzKPlbyiIzUZ06mCWOhlWCLCT7jmEMYGltA4Jc4j45LyJ4sEzdN3rE/mj1ua+ZbGaDLyYYrLU99F/XrjzboLkY8+FDvfeGFcvyVRN+ewweEGzA12SHGVLCmmlag1VmIFWOGvfqTysfw35TW6GkHUD0tOVSoTOM5YqVRP4ai8ntx6RBfV3Z69rggFBIqYLeDx8frRdX4CiFxfzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfI8C4D8XYBn/gT5TXywrCOmodway3QLz7Dgr0sbX2k=;
 b=Ff/YWolOkqVBA9bZHrShvlIj8N4OIQMheysvqWUii/WAD2ugfYTdJkMW0dmJdYRR5iCRRNq/5+lvnyXBA1zBgM+bHjmqrGl779HalOiO0PTjoEjC1fOfjKmI2yEvjeHyJWWPHCkxvD69WAQuBVxJpJTpZEplbbo/IXkNMs6ZnvA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:34 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:34 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 13/17] staging: wfx: also show unnamed counters fields
Date:   Mon, 27 Apr 2020 15:40:27 +0200
Message-Id: <20200427134031.323403-14-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
References: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::28) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:31 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a248b770-01dd-44ea-a825-08d7eab0b37e
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1424399E6E493A064C4DC17393AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R8kUwl0W/kr5VWMsES+E4RocR6Cf+I43flKzR2YP9XPLjB/RFwpOzOyH96lrk4B4r/k7is8DoMS8EEdBXAHU5JjSi5bAbahsS5UkpeyKS/bzDCoUTogd3HyDtzQ9JFFT7qB1lzdTsW1TSe7uBg+750tnr8AZyAX9cplBgwXVo6QTpKd9wO7N5hNxycn/ToDyxQcz5lgD/GSYsZ2sK7uJ6tdl4l4GabpCOXLqYX8aLp4FfvSIQcgVyCPoDdbj/n5m1H0EgDoOV3+tQO7JZcSogw2m5oXmVbeZocqG0wO+e130i57mHClLJ6nw8JHVrtFYXJRlpF3hq7wtcGuNUHY/kGSA/M5WkXkyC7a9IwSbpxENf5JYOxRq5wL34ZYGUUZ5o2GYCCkDthqQ8/qlOffa4n1kJ7kXlnFyAuN+Z2kFeEklldSorXS3W/H7TCiq9zHY
X-MS-Exchange-AntiSpam-MessageData: nTTjR9kxOOcXL3gmL4VOyv2RaKPPLhQ4fnYqY6vvu3jqqJQbWumcPx8RLrUL4fH1YBLOPBW5o3tMr5jIqbJTVcG4cZvoWRfqSVYarlSrhCtt5tO02Y5hwiVfK/1Sr0ZGKPrK1BiPDHIbKzjSHpjVtw0fL/9tG9G6YC91IlO6jF/l1a4LYxPxfqbE47jI1crPNveA46LGc0567KB6VHaNS5gojPL3KNnWvmGgS+kpjsFTSwwBv2equJ9MB7vOiUqwBSGuu94rEfwLCrxIu4CFkhCaGbIk88Q3yK7vgsJOsQrTm12tH0vSG8yJmE3afQyQnoWljF2Z677q/k/icTzjgwaQCvmscDJ8AWwQx9aT4ifagxmGjVclv/dg8HpPU1vg/G1u5ItkY8DeUkDd7cnO4wrbEHJ58sPF/F2Z/R8uVk6KVcoltwZszTnJd5ophphqc0qbTUbpom9A8jyWlMeM4nfcWZ6U+g13c06+zEb9OVfuf3RpEOs8JTpLjA9wZSkR0x0Qaj8+kPy16AYFiGx5/jjl28gBdvI2rfEU+PLARPD+B3Yy3pMzGsmH6qyYxJXrYnRtnT67mow5xysUsQMuEm7aPL3tyfe4/55dnvkYQN8vokD2KYKDWV0G9g0KURyUWrjURGIM3fEzaOLrKqapieaq0YAYLADQPSp5sp4u1OqbOniqUreqbdmhQLrNdoQICrvcGJNRpaQAYzUv32fzUaCqFJiansa5NlquTeueeCfVaa4vvjJ4uZ1kINltEA3mxYQAeaTf4oEAlxWx4qEopGenqY3wzuKQxEdg72YUearWsAan3q5ZTkp5o2AnXDSfU+vA8R1fnNcNSRQ3FdU6Fs7MxK5SLSl/xEBlLsKFsPM=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a248b770-01dd-44ea-a825-08d7eab0b37e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:34.5409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrmbRQpZy9T25MSTA4Gr16aVwgIUBRLRBR4/xrJ0z3XgSjIsPxwdlfRNOggWcwSk95iWLJkUZcqxW+yt3y4bTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdCBoaWZfbWliX2V4dGVuZGVkX2NvdW50X3RhYmxlIGNvbnRhaW5zIHNvbWUgZGVidWcg
aW5mb3JtYXRpb24KYWNjZXNzaWJsZSBmcm9tIHRoZSBkZWJ1Z2ZzLiBUaGUgc3RydWN0IGNvbnRh
aW5zIG5vdCB5ZXQgdXNlZCBmaWVsZHMgYXQKdGhlIGVuZC4gSW4gb3JkZXIgdG8gc3VwcG9ydCBm
dXR1cmUgZmlybXdhcmUgdmVyc2lvbnMsIHRoaXMgcGF0Y2ggYWxzbwpzaG93IHRoZXNlIG5vdCB5
ZXQgbmFtZWQgZmllbGRzLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYyB8
IDYgKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5j
CmluZGV4IDRkYzRmNmEwYjkyYi4uMmZhZTZjOTEzYjAxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2RlYnVnLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jCkBAIC0x
MTIsNiArMTEyLDEyIEBAIHN0YXRpYyBpbnQgd2Z4X2NvdW50ZXJzX3Nob3coc3RydWN0IHNlcV9m
aWxlICpzZXEsIHZvaWQgKnYpCiAKICN1bmRlZiBQVVRfQ09VTlRFUgogCisJZm9yIChpID0gMDsg
aSA8IEFSUkFZX1NJWkUoY291bnRlcnNbMF0ucmVzZXJ2ZWQpOyBpKyspCisJCXNlcV9wcmludGYo
c2VxLCAicmVzZXJ2ZWRbJTAyZF0lMTJzICUxMmQgJTEyZCAlMTJkXG4iLCBpLCAiIiwKKwkJCSAg
IGxlMzJfdG9fY3B1KGNvdW50ZXJzWzJdLnJlc2VydmVkW2ldKSwKKwkJCSAgIGxlMzJfdG9fY3B1
KGNvdW50ZXJzWzBdLnJlc2VydmVkW2ldKSwKKwkJCSAgIGxlMzJfdG9fY3B1KGNvdW50ZXJzWzFd
LnJlc2VydmVkW2ldKSk7CisKIAlyZXR1cm4gMDsKIH0KIERFRklORV9TSE9XX0FUVFJJQlVURSh3
ZnhfY291bnRlcnMpOwotLSAKMi4yNi4xCgo=
