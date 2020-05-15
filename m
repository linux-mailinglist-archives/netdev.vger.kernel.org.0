Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6269D1D487B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgEOIej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:34:39 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:6138
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728329AbgEOIeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWtqyw7OvG5ftZl1C0XP4XTKLOHDiLvz0CuBcAfu3DzRKN4LImU6AS5eE+naT+1NNwW11RFehVCE9v7bJcxVOxp9q9AGfjic1xUaT5cE3M4CuLIlfhCcMda9DdFqv9lgK/Ob75audjfv9UJOW2luuvIrX1ilK3JtcuMPkQ+snxU2VD+4pZqZ+5TeppOC1KQoYCSckoVemw/lzdKh9yn1wyKzvwUe8Nq6hH+t/LoyXz8n4JUAKwlUPYBjryk1woWz/jpqFV0ILg55QOBAzxRrScmPi+p3gjllhOMDfvUPIxTXt6LfqN2tfdrfp8IwPZd8TvHgJA3swJR9LdPKatvqWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gA6OR2oUdWaDAB+nq0jkFBd0As9cc8QT1KEc72rsWyI=;
 b=MXDflFDbTZYSKFTtxQ455I/NoPena4MJvhW9fWddVaqsI1BtFztnpEBYa5+22AnWAfzt6ZxeEvzrdafiAlEcuBTec9vSUhI9fs3YlWoVd5eAtsASjGIDkTRhxbqNEDpbUQZPq4sBc++7CTdrg2QV51Pp2QbV/GoINB/DomOtSU5SllhpHv2xJNp2bk0O60efOsZ0p/P1fvbvlJRmtfUdhVx51t+C7/OQNs8R4w7QMkzplyylmcvrdUG7emZ1Jktyg9vBMQBhDUhtFY9MHw3TQ3vVKzeG+zA+zJ6Fq1I+leFC6+oPPLgUCDNIZvnjKszyMB43Tr2p4Qh22Yebae4tUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gA6OR2oUdWaDAB+nq0jkFBd0As9cc8QT1KEc72rsWyI=;
 b=fK2cOhFHvMI/w+md359s94GT4tK6+C/GDcFNUzWDXjLSVrbpAEffxY3pmnLlmvMcaZ2AKpE24fc5z7cwO21CyKZvPvZtxY2HFE0YNqc6+CpuOgTH6+rlArBtpaKbDWemIvLuoJ6bI1pCxIlY6mmQ3dzNHFyIAU6Uu4unqP40t0U=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:20 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 17/19] staging: wfx: remove false-positive WARN()
Date:   Fri, 15 May 2020 10:33:23 +0200
Message-Id: <20200515083325.378539-18-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:19 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fca40e28-9172-474d-31d1-08d7f8aac3a4
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13100FDBFA9D9676CFDFC1AE93BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kxc2GBEh10E5AJW0iZM2sKa/aAboNACW5nEFI7ZU541QOQas0dJxZr2MVqnwmoMl+33iwg2InHhTUNCEzIiQ3mjrzZxozg0A1WiaOEfjLvZzfevxSYE++jbes1SLh7eEXxUzly4buSnOvKyY/Cr74j6t31PG1uaxNhEGwsonIAG2NGAGNEIIk65HFyMFGBO5GjYBuDWYUHbuoGGddasi9VQau4EX+GQl2Ppp/s73/S0XmBgl0cUwstKE2jBpkIEaFX3AihlxiXV1MqccRNBXEAheQX+ka9VGKW8mAtovGK3pQrA1d0vfqtCiRZThk7C+mWw558C1ZZYoFhON8L/urW2grE0+hP2OSRvyHPVY9nXKcuGbNiYig/OlYBuBhza7GXQWXWMUqP3o6BfGvqhJR4igY6UW/dW9I1PQILE78Yie1bZ13gmM9w/jHnNPvSDS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bWwi66Q7D7gg5SHogjpjj51ZFAbIHFjzY7yjT4Bd7ydF66bOBFnQTqeD5NXDPw9foPRVpPvuXqe4HwBndo5mBdKKycgD+2ne9czKwNkhOMicx3Ij8EZE5J5Fyk1tgh0C26y+g9k19mSrCmBKi4ih/io2amd2Ol3SUqTBFr5KsIvy8l8KjsBLHSIidZIFnzhe0Z4RrOF69xoYsha0bazGQSrO2oGy9PEQAFt+gnyhh4Vqs+0JLQqhZmLr3vsuUe5BM8StCpYukZMjP+kPUlqSPuZLb4v6kzNdky3yZtpJSiyLe1axOW9XGxioaLdKbJGxZKHBPmIs19cTRS+7VoxTgm0be2bBCx76PBZFJxjtwMMpTPzXlmamBI+Qdlgekq+PcJ8bW1HPbuqSIBgCYFXDkIZcn3k723J+DH6T5YX01XLiRF0jGQobdI/4j00MzrjIXfQm5RZ7gQZJwMqpPCATQXhy0LovPTHYPUysLR/5SxI=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fca40e28-9172-474d-31d1-08d7f8aac3a4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:20.7670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBFOxPy+qeww3kRKJnJBRhsyotDZp5GaMNTJ6aNuwNUO3W0tkPSmKC3nTUoPkgICeXWTfy+HF1GJtvZklA3Gww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZ1bmN0aW9uIHdmeF90eF9mbHVzaCgpIHdhaXQgZm9yIHRoZXJlIGlzIG5vIG1vcmUgcXVldWVk
IGZyYW1lcyBpbgpoYXJkd2FyZSBxdWV1ZS4gVGhlbiwgZm9yIHRoZSBzYW5pdHksIGl0IGNoZWNr
cyB0aGF0IHRoZXJlIGlzIG5vIG1vcmUKcGVuZGluZyBmcmFtZSBvbiBhbnkgQUMgcXVldWUuCgpI
b3dldmVyLCB0aGVyZSBpcyBhIHJhY2UgaGVyZS4gSXQgbWF5IGhhcHBlbnMgdGhhdCBoYXJkd2Fy
ZSBxdWV1ZXMgYXJlCmVtcHR5LCBidXQgdGhlIGNvdW50ZXJzIG9mIHRoZSBBQyBxdWV1ZXMgYXJl
IG5vdCB5ZXQgdXBkYXRlZC4gU28sIGl0IG1heQpwcm9kdWNlIGZhbHNlLXBvc2l0aXZlIHdhcm5p
bmcuCgpUaGUgZWFzaWVzdCB3YXkgdG8gc29sdmUgdGhlIHByb2JsZW0gaXMganVzdCB0byByZW1v
dmUgdGhlIHNhbml0eSBjaGVjay4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxq
ZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVl
LmMgfCA3IC0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVl
dWUuYwppbmRleCAwYzc5OWNlZGQxMDEuLjI2YjE0MWNiZDMwMyAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwpA
QCAtMzAsNyArMzAsNiBAQCB2b2lkIHdmeF90eF91bmxvY2soc3RydWN0IHdmeF9kZXYgKndkZXYp
CiB2b2lkIHdmeF90eF9mbHVzaChzdHJ1Y3Qgd2Z4X2RldiAqd2RldikKIHsKIAlpbnQgcmV0Owot
CWludCBpOwogCiAJLy8gRG8gbm90IHdhaXQgZm9yIGFueSByZXBseSBpZiBjaGlwIGlzIGZyb3pl
bgogCWlmICh3ZGV2LT5jaGlwX2Zyb3plbikKQEAgLTQxLDEyICs0MCw2IEBAIHZvaWQgd2Z4X3R4
X2ZsdXNoKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCXJldCA9IHdhaXRfZXZlbnRfdGltZW91dCh3
ZGV2LT5oaWYudHhfYnVmZmVyc19lbXB0eSwKIAkJCQkgIXdkZXYtPmhpZi50eF9idWZmZXJzX3Vz
ZWQsCiAJCQkJIG1zZWNzX3RvX2ppZmZpZXMoMzAwMCkpOwotCWlmIChyZXQpIHsKLQkJZm9yIChp
ID0gMDsgaSA8IElFRUU4MDIxMV9OVU1fQUNTOyBpKyspCi0JCQlXQVJOKGF0b21pY19yZWFkKCZ3
ZGV2LT50eF9xdWV1ZVtpXS5wZW5kaW5nX2ZyYW1lcyksCi0JCQkgICAgICJ0aGVyZSBhcmUgc3Rp
bGwgJWQgcGVuZGluZyBmcmFtZXMgb24gcXVldWUgJWQiLAotCQkJICAgICBhdG9taWNfcmVhZCgm
d2Rldi0+dHhfcXVldWVbaV0ucGVuZGluZ19mcmFtZXMpLCBpKTsKLQl9CiAJaWYgKCFyZXQpIHsK
IAkJZGV2X3dhcm4od2Rldi0+ZGV2LCAiY2Fubm90IGZsdXNoIHR4IGJ1ZmZlcnMgKCVkIHN0aWxs
IGJ1c3kpXG4iLAogCQkJIHdkZXYtPmhpZi50eF9idWZmZXJzX3VzZWQpOwotLSAKMi4yNi4yCgo=
