Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5983119AA74
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbgDALIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:08:10 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:6024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732299AbgDALEx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:04:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pk/2UwYSZf0B50QLgcFDU0VB/yRWHdyhG4+uJenrjkaOsuXMZ8AtCSQg3OYOIvEBCe7vVePE35QFXB15uFCfc1AiV2+eDSox8W5+laAMZZbm+k95mgADI2oQJU04u3embjJ2k5ac9P/hdbo0syFg+iWr+3eu9Qh/ReELxGi0F2NvraS51mugW4ShHL0/dzyOOmzY8RL46QO8Mv2YFb7jx1nj7z5/21JnypqeCeI5xEQLVdnOaDJebdpFmV0BSSMY6rvdVfTjJhiMteI7vBnd9WAf3bk49TCnGveBGEorbtr+fAId+nTiHO6suLjkZPbeJIM0Y/mVOm+squc3b4s1kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elWr9kqCLKIQtMXJG2yerf++exc0/sxLlm3itODnK0Q=;
 b=DMWbS7RN5I2X/Lv/v6tHn5HbbKjYWMXTyi9ZQrdATmcdzsxbqjgP4TE4kqEYJF6Iqyg5WWIboayJE0zeg3KETHXiDHQXZE5NvhOPAo/LAsKfgV9b8xUerDK0PDUkrIJchLNMyGYJXhMcFuKI9Vh0qfJrqrzUc8bCnX8nBdzweyvo4k7xKAjZEn3GSppexxbrc/TldQDVV6Ce26Ab8qXe49eqie/uU2Auv0j98FIkGGkpAJ6Yi7k9gpHmmMWQ+5R+1BOPaVjhxgTWEOFwyNKk9MipKpsknCIFPvbTEDVPtx2HDN+UcrqHMVP48If3KxdB/ruugMXEDHPyjgG9sB0LVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elWr9kqCLKIQtMXJG2yerf++exc0/sxLlm3itODnK0Q=;
 b=fiaS0vLEt0Y77Ublwuc63p1Wv5lwA9QLjSpseagDXy1btpNYjMvqLh72E9X8+3lVkiJwGYWgP+Ier0oj+L/wZmmG8BZiJ+R+OlAvUqYq7n6P7BydhezDcLl7I/yxHtPdjyDO+htE2vXTgxR9Xp7f7E1TMAkn9eHuDaLA9FklF9A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:32 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:32 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/32] staging: wfx: drop useless queue_id field
Date:   Wed,  1 Apr 2020 13:03:39 +0200
Message-Id: <20200401110405.80282-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:30 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cb5b941-49c3-45f5-a747-08d7d62c74c6
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285856AD167C56EED646D6493C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:517;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(5660300002)(86362001)(4326008)(66574012)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FjUcVrc19b77UE/LiC27DwDMgUwvkJbR+aRlrppbIQWcwLFhBWuaaUA1RkuvGH69gAHm7gDeuHBBEeNLQfJybiMimVOvP2U6d+PZ4frMwvto3CT50JxQNGAMSxngPKg3fOmwpghaYDjnrzMuJTgnoPiCFJxvnwoCkCk+o40exdj8KZFVi99L2X8jDqOzCARVb4fGvxsjzovj7v5CYNzKSpMMsZSXihQ/9YZMgOSPgichLuBmJ38DMwWvUavcPMDWjrRC2IlzwltgwZPD+c+mG9UYFTWmMLEEMDrvNjmrYr5vuvpYDoYhyfEvYr1EhWgym3iMEinPWDdkRyOcoV2iT+WeNDb354AXmPlu8gfhtQ1jl4E6PyQEsUofVJzU+3f99VZ4eoHSCTgptB73wq8/eRpSNT1743ieSAHpHbKF4gJzclQItXNmk3faQtTUE+dK
X-MS-Exchange-AntiSpam-MessageData: 1fVJeU1LCqREDUVC00LynFiDFG/9UjDT2vtZteXmP4A8ahTBmJ9cLlfAoRclG5MpXYi3CKxytpP66u94/lg9UhJxACE+EmVEv/Dl69W5tLktn+C/SkWIEPR+c8YVIEmUk94lq3cyq2HXVuk5DkS+6rFrOBE0VO/nEctfBs5u7A2Fxf0yqpdrXTy/E9eRq+g2JFXAESEUAE7M8RxNMtW9+g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb5b941-49c3-45f5-a747-08d7d62c74c6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:32.4984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tLrsWnjKSwbpKVtnFYVZgJqRtpll81G5EzGF0ybC0YPNksrA6tFN4GZ2c3wQYeoJclR86mwwOmFXlTV2Y0oNSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkIHF1ZXVlX2lkIGlzIG5vIG1vcmUgdXNlZC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1l
IFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L3F1ZXVlLmMgfCA0ICstLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaCB8IDEg
LQogMiBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3F1ZXVlLmMKaW5kZXggNzEyYWM3ODM1MTRiLi4xZGYzYjZmMjhjNjcgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVl
LmMKQEAgLTEzNCwxMCArMTM0LDggQEAgdm9pZCB3ZnhfdHhfcXVldWVzX2luaXQoc3RydWN0IHdm
eF9kZXYgKndkZXYpCiAJc2tiX3F1ZXVlX2hlYWRfaW5pdCgmd2Rldi0+dHhfcXVldWVfc3RhdHMu
cGVuZGluZyk7CiAJaW5pdF93YWl0cXVldWVfaGVhZCgmd2Rldi0+dHhfcXVldWVfc3RhdHMud2Fp
dF9saW5rX2lkX2VtcHR5KTsKIAotCWZvciAoaSA9IDA7IGkgPCBJRUVFODAyMTFfTlVNX0FDUzsg
KytpKSB7Ci0JCXdkZXYtPnR4X3F1ZXVlW2ldLnF1ZXVlX2lkID0gaTsKKwlmb3IgKGkgPSAwOyBp
IDwgSUVFRTgwMjExX05VTV9BQ1M7ICsraSkKIAkJc2tiX3F1ZXVlX2hlYWRfaW5pdCgmd2Rldi0+
dHhfcXVldWVbaV0ucXVldWUpOwotCX0KIH0KIAogdm9pZCB3ZnhfdHhfcXVldWVzX2RlaW5pdChz
dHJ1Y3Qgd2Z4X2RldiAqd2RldikKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVl
dWUuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaAppbmRleCA4OGVlMmJmNTZkMTEuLjIy
ODRmYTY0YjYyNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuaApAQCAtMjQsNyArMjQsNiBAQCBzdHJ1Y3Qgd2Z4
X3ZpZjsKIHN0cnVjdCB3ZnhfcXVldWUgewogCXN0cnVjdCBza19idWZmX2hlYWQJcXVldWU7CiAJ
aW50CQkJbGlua19tYXBfY2FjaGVbV0ZYX0xJTktfSURfTUFYXTsKLQl1OAkJCXF1ZXVlX2lkOwog
fTsKIAogc3RydWN0IHdmeF9xdWV1ZV9zdGF0cyB7Ci0tIAoyLjI1LjEKCg==
