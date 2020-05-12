Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23A71CF880
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbgELPEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:04:51 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:45896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgELPEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:04:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSdsgPOWEvufnSyxNmR8KkInYndb8xWZllP7sBz0Bjvb48NOCGMwO/QQhGn0LIHIxYTsZ6JZN4xT1cSwlHGd6u4uYqB5Zrkko4dkiPlfMMDQf3/HCO73BJppB9Y0bhzIoy2P6XyiP8c2Qj15Y/I04w/LHSmrxGj8VFAY6X4bOgjmJZvo7PakXP+yiSdVEnRAUdXmX5sO7afstdPW1C5o3B6ZI8SiVK2w3EqR5mmBnksLAAXlHbk6DqjZ3c3M+k+ZgTdDPlL35fIgB/ZoaIgpje5jmaYSmsL4/fxGVAJ91mRjMmjNI+3C05FD1RyajvHGZD5QE2HQ9Fr1xJMKY0WsfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q94uY3wIDAIJbStr9gu9gHlUoS5rWPgP9Bsj/iZkXP4=;
 b=AEXy55pmjEp6LuWI/5Y8hfjIGMAA70jo5RF8VvTo5Rx1UaYaDQNJNBDxIk2FUnyyfQ9Z0krRmd9gpRwtXabujmgUdC3g4GpKlZI8S1WRESloDC5/+iLgXRat8Vn5kdwDzSO4LeHpOjIMfC4HjVdPXS0k6eRIR4+19cTe2I51SiMaZ6ymqxgSJSuT5CMXXClw+YGCscXlgInRb/m0BkE8u16c0fQmBrqQNxXjJZQg3dzz/5wlQ+NWDEoEVDi3k66HFfemLaWiXBbdxUXE6/3wJix3X7QvE5WGqjJd9+z/GaZqCrO3DMzpfE+X8h3s4YbDbb2xAoE+1UNaO+zFt4YOzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q94uY3wIDAIJbStr9gu9gHlUoS5rWPgP9Bsj/iZkXP4=;
 b=jnUZVjAJ9L8I6wRekqiptSLmQEihFhp9jZBxXgUP7IrQdmf1Kd9/eQPNThTbpJ/KUUUs0GYUEZ31JV7B2gzxgqT+nkui9TYR0G5qQYuQ0rnXW3XFYcbDFGwTgsHurDHTSRIIgE1ZkoUW8Z+NxRuzrnm2VH2KGsc9Xr1Cfdq+rrw=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:04:40 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:04:40 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 05/17] staging: wfx: fix output of rx_stats on big endian hosts
Date:   Tue, 12 May 2020 17:04:02 +0200
Message-Id: <20200512150414.267198-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
References: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:4:4c::13) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:38 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d29f5e09-9661-4cd7-bb0b-08d7f685cb36
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1741DEE2F9612FFE5AF6030C93BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:339;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Sj7ehGfJwg1deZiPSLBLQqHPmkeVDIq99Fy2HXmoXTjN7U2R4+47HmOCEfLsWDO2i+qBKk4yLu3wDkIrfwq6jb3Ft2csPR7Jq8TN/u3Q9lXAv2gFMN2aUagLgFOzj9nk5EqCG7CmOx2mYW1Ep8UkCNE2qA4XizpzuUPyjH1vFCbFmSmdtbRWmg6uSqFGjUpPu5CLOKeF9Z9bVDNMa30PZsRnLoaWXdUAazLquklpNKW9b3nEQl9y3YRUt/6j+nWvEY86nj0Suj6fuxaG7kksanqysoYSSxMWKQihJGAMP+ygS79/2rGdyVv/VWfVFqDgU+Y+5Ef1iJ6GH2J28kdsNPXJIh7FR8tTIZpW6HCmAzvkV6DrRT2SS4QGp9jeZcuOFWdPfB5nb0QLe0eEBxpzwfMnQkstbboJpHwoal4AhpmjC6cbNIUWIsdfcxk1e3pY2mRt71JI4yB+wVb94KkVP5rLeBHrVMbWhbq0mRyKgeHw2XZB2Ke+GLskTC7LIdD3x1knom996y/buNxHaTXww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6ojtYiK/oD/v5MoaUzGYcTxON6cFloKwHwa+LbJPpFqNWHtCd/wVGf91RZwCo9LJa9KuvfbCAI8lmko/O3fTztSjJFkyik6PkjRPJ3Dkct1GMMX3Gwtr0YIZ19IHcOhSJHpnP3g2pyOkfi0nLVWKL7cOFQ3U6DkDeDA0L9esZJhW+t66EHyJFeDKET6srP62cdg51+Yeht5X0sIuPoF9Cc/oWpayKSMzmMx3/fuwJ0E+BCdLFNDkYV3/3oUUoLcKOfr3ACYzVDFs8Kb5YYiOukaVn/svRv8BlHTEfCiqwFn+230lKIuzaLSVNtpyJEmhE89fq3nJO15GFjUeN1KNIx7KO0kMZ4nJytTNWH0Rbahl/bWQd45pxLROpHJG2RDqKuto+9XU2KQ4fnJG2bjweoGLYDC+UyqBnDNXftMMFaGW90rWArmXXILzlVl1zbXTWo7zphCPKOnfoZfrB/zcXqZAEb9DnztZ7dA8F7pr2SM=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d29f5e09-9661-4cd7-bb0b-08d7f685cb36
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:39.8978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivdpbbHyLD4Brp5wqjyrN0veiql6iSk71NrQAg5BZYFVK1oNMZT96U+vKTRuzRQ9atSSbOrFvVCtfTCqXaqcCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdCBoaWZfcnhfc3RhdHMgY29udGFpbnMgb25seSBsaXR0bGUgZW5kaWFuIHZhbHVlcy4g
VGh1cywgaXQgaXMKbmVjZXNzYXJ5IHRvIGZpeCBieXRlIG9yZGVyaW5nIGJlZm9yZSB0byB1c2Ug
dGhlbS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMgfCAxMSArKysrKysr
LS0tLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2RlYnVnLmMKaW5kZXggMmZhZTZjOTEzYjAxLi44NDZhMGIyOWY4YzkgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvZGVidWcuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Rl
YnVnLmMKQEAgLTE1NSw3ICsxNTUsNyBAQCBzdGF0aWMgaW50IHdmeF9yeF9zdGF0c19zaG93KHN0
cnVjdCBzZXFfZmlsZSAqc2VxLCB2b2lkICp2KQogCW11dGV4X2xvY2soJndkZXYtPnJ4X3N0YXRz
X2xvY2spOwogCXNlcV9wcmludGYoc2VxLCAiVGltZXN0YW1wOiAlZHVzXG4iLCBzdC0+ZGF0ZSk7
CiAJc2VxX3ByaW50ZihzZXEsICJMb3cgcG93ZXIgY2xvY2s6IGZyZXF1ZW5jeSAldUh6LCBleHRl
cm5hbCAlc1xuIiwKLQkJICAgc3QtPnB3cl9jbGtfZnJlcSwKKwkJICAgbGUzMl90b19jcHUoc3Qt
PnB3cl9jbGtfZnJlcSksCiAJCSAgIHN0LT5pc19leHRfcHdyX2NsayA/ICJ5ZXMiIDogIm5vIik7
CiAJc2VxX3ByaW50ZihzZXEsCiAJCSAgICJOdW0uIG9mIGZyYW1lczogJWQsIFBFUiAoeDEwZTQp
OiAlZCwgVGhyb3VnaHB1dDogJWRLYnBzL3NcbiIsCkBAIC0xNjUsOSArMTY1LDEyIEBAIHN0YXRp
YyBpbnQgd2Z4X3J4X3N0YXRzX3Nob3coc3RydWN0IHNlcV9maWxlICpzZXEsIHZvaWQgKnYpCiAJ
Zm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoY2hhbm5lbF9uYW1lcyk7IGkrKykgewogCQlpZiAo
Y2hhbm5lbF9uYW1lc1tpXSkKIAkJCXNlcV9wcmludGYoc2VxLCAiJTVzICU4ZCAlOGQgJThkICU4
ZCAlOGRcbiIsCi0JCQkJICAgY2hhbm5lbF9uYW1lc1tpXSwgc3QtPm5iX3J4X2J5X3JhdGVbaV0s
Ci0JCQkJICAgc3QtPnBlcltpXSwgc3QtPnJzc2lbaV0gLyAxMDAsCi0JCQkJICAgc3QtPnNucltp
XSAvIDEwMCwgc3QtPmNmb1tpXSk7CisJCQkJICAgY2hhbm5lbF9uYW1lc1tpXSwKKwkJCQkgICBs
ZTMyX3RvX2NwdShzdC0+bmJfcnhfYnlfcmF0ZVtpXSksCisJCQkJICAgbGUxNl90b19jcHUoc3Qt
PnBlcltpXSksCisJCQkJICAgKHMxNilsZTE2X3RvX2NwdShzdC0+cnNzaVtpXSkgLyAxMDAsCisJ
CQkJICAgKHMxNilsZTE2X3RvX2NwdShzdC0+c25yW2ldKSAvIDEwMCwKKwkJCQkgICAoczE2KWxl
MTZfdG9fY3B1KHN0LT5jZm9baV0pKTsKIAl9CiAJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5yeF9zdGF0
c19sb2NrKTsKIAotLSAKMi4yNi4yCgo=
