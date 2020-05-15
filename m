Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FECF1D484C
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgEOIdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:33:53 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:6138
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbgEOIdw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:33:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdIOnV5VNtUB1bQ1AT1aeNVIkXMLpDzVY5oun90WeimDGHhbXvjvDOBZpFF7xDUS7NJdRVMfSpEwHVnM9EsWG/8D9kRY79rWTncZ9JhYxcJJLcPszVdBHqiAjKqgGPZJAIgWgHsVIWWCUz/VKwUSY2rXfuYjXIdL8NTpDxK1MaEmIi8bE6h3/bhF7kTiMa8pvQ7TEzmR75dIJdFUOZDes1D6x6H/EmK64NTGDhqeNFMBuS4r8pm4H3DS9y50wJ38o4kT9UmpXBr+qiMmNC69/CELb7wT8THHBPNIHCmA5s4ylRkK0OAugh4mieLI1HZOdSbCV5m+NXD/2wx+nDgDNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owEGYhDSPe8g3K0oc3QVvoWe3aGkmULc3RgqcpbwuGY=;
 b=IXZb7RyvJSkNawg7aiw33XZ0GWpjPo1S3LOIYXG4G6sAvDWzA5pcIaWuRJlXZviTQKKHXs8pyGg1dGz1Kqo/8cdWt5AvjxkhJipONtAO+yj1eWLYNw7T5H+bHf9QSIQmLikBsAg/H7Mq5AHjIIEYJLQ9oORJtyghLaN7CZ1im9JNSDF5qhsYMAo89jJNbH4kSeX/Dw0Xac5yO4XKn3BaWnxXR8aVrK+Wbt25eeAWjrboIPPjanboL+VWorJM6PXm+cJ47fjW+XdYpNCzm5ghVF64oKQ7w1/gxu/P0L67TloszDv8uwRSUeLB8h1fjxYQczIc/gheOuY8Ddlg4uh+KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owEGYhDSPe8g3K0oc3QVvoWe3aGkmULc3RgqcpbwuGY=;
 b=nrh0u21klYdHp7mW2pYWvN+rIjsMupKwmW2qrFpKlgMwIjp8gjWd618boFy7vgFGCHfGBZCY3X/OGymscxE0ztMXnzulG7cfl10InHEXbJGd6t99u+n8EPWWn3Om/Pq8m0S3epQryqRDMRI+ZLIQI0SYCT3KdmlutwK8b/mNy4g=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:33:49 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:33:48 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/19] staging: wfx: various fixes
Date:   Fri, 15 May 2020 10:33:06 +0200
Message-Id: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:33:46 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1e8fdda-aff3-424f-b887-08d7f8aab037
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13100F1A2F6713341100664393BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u96AVyk29oa23xL4BstrTo/8lcg9nRjqdMp8EANhYdgNLqqGDmZ3D5O0z7kxcPMmtxta5g7fSxVYnJfAyZ1hE9DdG444CPuJ3fU74VXlK9y8Qk7MYjmEpzZivOPWjcAlXYFy/IwJQEowK7Gopkb5Gf9O/j4HDihFIXpaJ8NbF93v5GB/j3z1IxFTvwTdvHc46+BMVn+3S7TqEoc5UqEnoM1ZTywpi8yFQ9INtgoZDD5e32bG7zFRBw+jmjV68DlGsDNiffhlIR/5f14BCVk/4w9va9FiyNUHt5V+WcbkVLftUpgnGaMaEmDhPsywEA/oNzrDlufZKMKwa5Ntc23DldZ8R02dAd4thmXS0kZvCG2Cu46xHLcFTKz+9nkn3qohOKhbE7c3pUc3kT0VnQjaPLDYy1QiBmGpoM8R62pCoIZVNy7eDcupONh0GZZ7PlYS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RenaLXUOcCN+ALqP0q+A10RMwExeovE9hbR3ZUYX9uwuzOI5x4LvPHsf8158DNWTHDqWmkNvPXKl1CGnMmmYbg0xZ9gFfpX54vki88Zy3V9cwnum0xKX1kmVbhTVxqvBAQKZIQNyhjVM+uh3MDn+0JDpZJZwFLkGs3S1L9kbtzFncIiimJj4S2Nj9JWvwIVdXC0LMsQohjqeoPkAkQHV2U1f0LK5LIOx1JYJYNkznma8rIyG2+tobyVQoBACW7/LuY5FproObWg9gij0qB/2zvSojnMggGE7La1d/vPAkq+inj+DS4cEFuu+Fs6SKXxjkCyWVHBNsUY3zDIyAn4hX87S1W+eStlnSt2Nco3wPGMfOhLBKEUVw4XpLE10wFSMVEL9IydXwEKIClyW3hqGma+vs3eYWXUmuPMZVPP0X6c2quxr626chDeiL8AGyQiat4h/cnAL16y05/0vpkBaXjuwZGmTLPZ+gmR5SEyQ8GU=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e8fdda-aff3-424f-b887-08d7f8aab037
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:33:48.2914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJfU9cjhjHN3Z4/IlW04FvJc4W4KHxZXnct+GKWC+xNX6aXMNm+lDQOoLXc85XuukNBFMWLdDCvK8G7NXCuYJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGVs
bG8sCgpUaGlzIHNlcmllcyBjb250YWlucyB2YXJpb3VzIGNoYW5nZXMuIFRoZSBtb3N0IGltcG9y
dGFudCBwYXRjaGVzIGFyZSB0aGUKMTMgYW5kIDE0IHNpbmNlIHRoZXkgZml4IHR3byBmdW5jdGlv
bmFsIGRlZmVjdHMuIFRoZSBvdGhlciBwYXRjaGVzIGZpeApydW50aW1lIHdhcm5pbmdzICgxLCAx
NywgMTgsIDE5KSwgaW1wcm92ZSByb2J1c3RuZXNzICgzLCA0LCA1LCA3LCAxMCwgMTYpCmFuZCBk
byBzb21lIGNvc21ldGljcyBpbXByb3ZlbWVudHMgKDIsIDYsIDgsIDksIDExLCAxMiwgMTUpLgoK
VGhpcyBzZXJpZXMgaGF2ZSB0byBiZSBhcHBsaWVkIG9uIHRvcCBvZiBwYXRjaCBzZW50IGJ5IERh
bjogInN0YWdpbmc6IHdmeDoKdW5sb2NrIG9uIGVycm9yIHBhdGgiLiBXb3VsZCBJIGhhZCBpbmNs
dWRlIHRoaXMgcGF0Y2ggaW4gdGhpcyBQUj8KCkrDqXLDtG1lIFBvdWlsbGVyICgxOSk6CiAgc3Rh
Z2luZzogd2Z4OiBmaXggd2FybmluZyB3aGVuIHVucmVnaXN0ZXIgYSBmcm96ZW4gZGV2aWNlCiAg
c3RhZ2luZzogd2Z4OiBhcHBseSA4MC1jb2x1bW5zIHJ1bGUgdG8gc3RyaW5ncwogIHN0YWdpbmc6
IHdmeDogY2hlY2sgcG9pbnRlcnMgcmV0dXJuZWQgYnkgYWxsb2NhdGlvbnMKICBzdGFnaW5nOiB3
Zng6IGZpeCB2YWx1ZSBvZiBzY2FuIHRpbWVvdXQKICBzdGFnaW5nOiB3Zng6IGZpeCBjb2hlcmVu
Y3kgb2YgaGlmX3NjYW4oKSBwcm90b3R5cGUKICBzdGFnaW5nOiB3Zng6IGZpeCBpbmRlbnRhdGlv
bgogIHN0YWdpbmc6IHdmeDogZml4IHN0YXR1cyBvZiBkcm9wcGVkIGZyYW1lcwogIHN0YWdpbmc6
IHdmeDogc3BsaXQgb3V0IHdmeF90eF9maWxsX3JhdGVzKCkgZnJvbSB3ZnhfdHhfY29uZmlybV9j
YigpCiAgc3RhZ2luZzogd2Z4OiBjYWxsIHdmeF90eF91cGRhdGVfc3RhKCkgYmVmb3JlIHRvIGRl
c3Ryb3kgdHhfcHJpdgogIHN0YWdpbmc6IHdmeDogZml4IHBvdGVudGlhbCB1c2UtYWZ0ZXItZnJl
ZQogIHN0YWdpbmc6IHdmeDogcmVuYW1lIHdmeF9kb191bmpvaW4oKSBpbnRvIHdmeF9yZXNldCgp
CiAgc3RhZ2luZzogd2Z4OiBtZXJnZSB3Znhfc3RvcF9hcCgpIHdpdGggd2Z4X3Jlc2V0KCkKICBz
dGFnaW5nOiB3Zng6IGZpeCBwb3RlbnRpYWwgZGVhZCBsb2NrIGJldHdlZW4gam9pbiBhbmQgc2Nh
bgogIHN0YWdpbmc6IHdmeDogZml4IFBTIHBhcmFtZXRlcnMgd2hlbiBtdWx0aXBsZSB2aWYgYXJl
IGluIHVzZQogIHN0YWdpbmc6IHdmeDogZHJvcCB1bm5lY2Vzc2FyeSBmaWx0ZXIgY29uZmlndXJh
dGlvbiB3aGVuIGRpc2FibGluZwogICAgZmlsdGVyCiAgc3RhZ2luZzogd2Z4OiBmaXggZXJyb3Ig
cmVwb3J0aW5nIGluIHdmeF9zdGFydF9hcCgpCiAgc3RhZ2luZzogd2Z4OiByZW1vdmUgZmFsc2Ut
cG9zaXRpdmUgV0FSTigpCiAgc3RhZ2luZzogd2Z4OiB0cmFjZSBhY2tub3dsZWRnZXMgbm90IGxp
bmtlZCB0byBhbnkgc3RhdGlvbnMKICBzdGFnaW5nOiB3Zng6IHJlbW92ZSBmYWxzZSBwb3NpdGl2
ZSB3YXJuaW5nCgogZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rpby5jICAgfCAgIDMgKy0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jICAgIHwgMTEwICsrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZndpby5jICAgICAgIHwgICA4ICstLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyAgICAgfCAgNTcgKysrKysrKysrKysrKystLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaCAgICAgfCAgIDIgKy0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4X21pYi5jIHwgICAyICsKIGRyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jICAg
ICAgIHwgIDE3ICsrKy0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgICAgICB8ICAgNyAt
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgICAgICAgfCAgMTEgKysrLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyAgICAgICAgfCAgNjkgKysrKysrKysrKy0tLS0tLS0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuaCAgICAgICAgfCAgIDEgKwogZHJpdmVycy9zdGFnaW5nL3dmeC93
ZnguaCAgICAgICAgfCAgIDIgKwogMTIgZmlsZXMgY2hhbmdlZCwgMTgyIGluc2VydGlvbnMoKyks
IDEwNyBkZWxldGlvbnMoLSkKCi0tIAoyLjI2LjIKCg==
