Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A291E2874
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388882AbgEZRS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:18:58 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:48578
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729597AbgEZRSw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:18:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hRzlxiSjIBzjbJDcqdmQP9dRH+PoW1Rojf0vnwguNPsygXIBJAwiao1zVbXNS4CPZvWsPb/wf2U5gkC3LL7+EJMtqw44TeMpXfwBl4k34YHUb0lRv8P5BHOOCuarv9LqoRT2N1sckWDI+Pocvc6S94NxsD5IhuDwHcdexz0eVGfyj1kiTTzYt5p4oJanE3p1fkwnTkqk3ZJMdInF0G/GJWBgkQQhEksMmKXdZC38qwjrzIvGq/VPAp+9IiS0QWbucQF3ew/RUbY2MqCdnogRj+gPvJoPYwNY4ft0IaE8lDHaeEsHOsRE5c0aedULl0s4xSX5FQaIhK5+0tbikkdryg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsTm/QaoE2NdtXYonMZIxlYJijuapxWK1NonVnqHTHs=;
 b=b/YvXAiOszusnEJDFeJA0XTBug659fjBwwduJp3uNgP+q7GZGoDeCI+txCZYtlNGbrTMeNsTuEoLoaB791r4+NdmLLDKfy9fflSHe+1jF0+bnA3laEQMi4ZdDNnTfl9cQ4FTFfy4p/PvabfHAU5TV+UeqJe+wnIGABprp5DVG2Uk8UUrNqcD+PO53cI8jw8nnzmUiKH0nSJqfWb8dV0hbQIHGexG4zS0MiGfhzhxCgW0Emtzs3vIvsN/KQsf9Nrea5uhDb0tkcWPrOI2TFAUDOKZTOOHrv4Gzez6JKi9xYb6LmnrjNpslyuSMwlDbCalmlJmB4A1yJtS0HfXGwn8SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsTm/QaoE2NdtXYonMZIxlYJijuapxWK1NonVnqHTHs=;
 b=M0rCfHWIjocOTHA7QBeVvUJoGakzuEjlo0t8yMO4Q/IxKbIJmvLrNZgzGRjUFIsJZdJxp/kPIXEztmt54qTJZ0nC+fVVaFF1oxRxhvtCtzE68u6lTxnKACrYoFKwvCo9YEHnPtWj4TIWmunr83sIpMgE+e9QDE5czsGaG8daH1I=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2750.namprd11.prod.outlook.com (2603:10b6:805:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.25; Tue, 26 May
 2020 17:18:45 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:18:45 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/10] staging: wfx: drop unused function wfx_pending_requeue()
Date:   Tue, 26 May 2020 19:18:14 +0200
Message-Id: <20200526171821.934581-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
References: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::20) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0007.eurprd01.prod.exchangelabs.com (2603:10a6:102::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 17:18:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4be2500-4ded-403c-3c7d-08d80198d8a6
X-MS-TrafficTypeDiagnostic: SN6PR11MB2750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2750AE6EECD9726DFE93EB5F93B00@SN6PR11MB2750.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:88;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9+X8Rw9PQaUKm5qJB6UNbTMhdgzF4cqSHcPjxyutkfF1OUlvCYImOhfXnkSLDXUW0HTpYojMrSYt4jjcF8wH9CVUkDPoEWID5WnYLRGFONnFYscW41DLNEORnnRf91ixGNUNFwTVuKNbMwoeVZChj2WzrCkc5zjvkuzZNrhetP/FZSLb9E/sMpJ/nFMrwBJIh8oDFznq/67Xs8mFeo7pMK6PoP1IL5pp0gUuAq1JSydAqhymXhshv9nUflsPpI6iEwO12Yh1D0XJvo3Wao4iCng1sKRIDOxV50Ntofg5Gm0IUycfrAWQQxIcEb4+XlaAMqCtnwOZpvKykI2r+ZniQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(4326008)(6512007)(316002)(8676002)(8936002)(2616005)(6486002)(2906002)(107886003)(1076003)(86362001)(6666004)(186003)(16526019)(5660300002)(66574014)(36756003)(54906003)(66556008)(478600001)(8886007)(6506007)(66946007)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RVhVY6vN1XgdfhvcDOg1A+OiGT3boOFlZZMr4FWq5WM/ObCAgZLrGDCkDXQfYxIbNubNvAC5XkQIFiPxYGGO/+f2xKM9LIlY+L6oQnXc/zhcaplEYZPhIkRP8FMSbH5fIFgGnZyZMF00TZJ1keHGEGLXGbI0exA07+o9uHGt9JPbMSLksqk6d4X/2fJnWJ1kAHvbxpNJ+kksQzHl4pDWvpnoDmhMBYGjzG5heUpzAkMePzEe8vLOUcAvT7isgel5eYs6o6CDLgkl4v628l6rub9JuT5VTMx7k9nQyCwKDqQs1tziOeYd4wgPgeKfKQaxsQZ+wDkvsWl6BF5mwikM78xj8JnkYY1rFztU5vTx0Otiled+/R8g0a/W6w8BYlOSk+s9Z6O4xWqRZDkKR25I3w9Zj1AnclkMgxCMLCU+hrXxte+IiASI50pjWxXRn5TvRM9Dr7I+UARRJSqve78QEk6HkDywYWf8QW7gKcAa18pMwJrcnYAVAddbaOq5Iizdr9UIc99szB3kq1QP6AbqOWm0C8FrK8lWfpPpzNXCSt4=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4be2500-4ded-403c-3c7d-08d80198d8a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:18:45.5714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UeXzHJ1/cVppIMF4u4GdrWQbQ05ftf5CeoPF+9bUwcnA8FS2VySWFH2wpLVXXOIKMxsFN7N8Py0HEA76f0bWbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2750
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZ1bmN0aW9uIHdmeF9wZW5kaW5nX3JlcXVldWUoKSBpcyBub3QgdXNlZCBhbnltb3JlIHNpbmNl
IHRoZQpjb21taXQgN2E0NDY0NGM5Mzc5ZSAoInN0YWdpbmc6IHdmeDogaW50cm9kdWNlCndmeF9z
ZXRfZGVmYXVsdF91bmljYXN0X2tleSgpIikKCkZpeGVzOiA3YTQ0NjQ0YzkzNzllICgic3RhZ2lu
Zzogd2Z4OiBpbnRyb2R1Y2Ugd2Z4X3NldF9kZWZhdWx0X3VuaWNhc3Rfa2V5KCkiKQpTaWduZWQt
b2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0t
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIHwgMTMgLS0tLS0tLS0tLS0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9xdWV1ZS5oIHwgIDEgLQogMiBmaWxlcyBjaGFuZ2VkLCAxNCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggMjZiMTQxY2JkMzAzNS4uMzI0OGVjZWZkYTU2NCAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvcXVldWUuYwpAQCAtMTQzLDE5ICsxNDMsNiBAQCB2b2lkIHdmeF90eF9xdWV1ZXNf
cHV0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogCQlza2JfcXVl
dWVfdGFpbCgmcXVldWUtPm5vcm1hbCwgc2tiKTsKIH0KIAotaW50IHdmeF9wZW5kaW5nX3JlcXVl
dWUoc3RydWN0IHdmeF9kZXYgKndkZXYsIHN0cnVjdCBza19idWZmICpza2IpCi17Ci0Jc3RydWN0
IHdmeF9xdWV1ZSAqcXVldWUgPSAmd2Rldi0+dHhfcXVldWVbc2tiX2dldF9xdWV1ZV9tYXBwaW5n
KHNrYildOwotCi0JV0FSTl9PTihza2JfZ2V0X3F1ZXVlX21hcHBpbmcoc2tiKSA+IDMpOwotCVdB
Uk5fT04oIWF0b21pY19yZWFkKCZxdWV1ZS0+cGVuZGluZ19mcmFtZXMpKTsKLQotCWF0b21pY19k
ZWMoJnF1ZXVlLT5wZW5kaW5nX2ZyYW1lcyk7Ci0Jc2tiX3VubGluayhza2IsICZ3ZGV2LT50eF9w
ZW5kaW5nKTsKLQl3ZnhfdHhfcXVldWVzX3B1dCh3ZGV2LCBza2IpOwotCXJldHVybiAwOwotfQot
CiB2b2lkIHdmeF9wZW5kaW5nX2Ryb3Aoc3RydWN0IHdmeF9kZXYgKndkZXYsIHN0cnVjdCBza19i
dWZmX2hlYWQgKmRyb3BwZWQpCiB7CiAJc3RydWN0IHdmeF9xdWV1ZSAqcXVldWU7CmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmgKaW5kZXggMGNiZTVmNGIwNmYyNC4uMGMzYjcyNDQ0OThlMyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUu
aApAQCAtMzgsNyArMzgsNiBAQCB2b2lkIHdmeF90eF9xdWV1ZV9kcm9wKHN0cnVjdCB3ZnhfZGV2
ICp3ZGV2LCBzdHJ1Y3Qgd2Z4X3F1ZXVlICpxdWV1ZSwKIAogc3RydWN0IHNrX2J1ZmYgKndmeF9w
ZW5kaW5nX2dldChzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgdTMyIHBhY2tldF9pZCk7CiB2b2lkIHdm
eF9wZW5kaW5nX2Ryb3Aoc3RydWN0IHdmeF9kZXYgKndkZXYsIHN0cnVjdCBza19idWZmX2hlYWQg
KmRyb3BwZWQpOwotaW50IHdmeF9wZW5kaW5nX3JlcXVldWUoc3RydWN0IHdmeF9kZXYgKndkZXYs
IHN0cnVjdCBza19idWZmICpza2IpOwogdW5zaWduZWQgaW50IHdmeF9wZW5kaW5nX2dldF9wa3Rf
dXNfZGVsYXkoc3RydWN0IHdmeF9kZXYgKndkZXYsCiAJCQkJCSAgc3RydWN0IHNrX2J1ZmYgKnNr
Yik7CiB2b2lkIHdmeF9wZW5kaW5nX2R1bXBfb2xkX2ZyYW1lcyhzdHJ1Y3Qgd2Z4X2RldiAqd2Rl
diwgdW5zaWduZWQgaW50IGxpbWl0X21zKTsKLS0gCjIuMjYuMgoK
