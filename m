Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57581288FC9
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbgJIROR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:14:17 -0400
Received: from mail-eopbgr760074.outbound.protection.outlook.com ([40.107.76.74]:48911
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390102AbgJIRNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 13:13:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wb0t7e+G+YmPOUJUALP+aE7crrYqPZEGTYtSCAYXI/Qwbom8TXNtLqSrTv+A/1FgHRSuOj11ZTt36bHLdkNk18Br511Nyl02uz8Gr9auYlUEhipZpa83J6tSslahqGEmLRFR3vDfbv9Kr3N7E4hCgUxUJjQWJ8q8zFKW2bfl9VxkrFaZ+kFzBS2e0IS6dunFE3bW69d0kxUdLnJwRpZeUKnLnhw30FmoUBz3/BTOtLl/eKcZodbyAbcz4BGDswEgQGWDAVjc8qRE642ZtwVj0UARqLVndOX5NGFSW+evj7QmKLOXaIbwioAe6Hx7wR11M0UXubQUwRC69aoctlaVnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSt2vbIr2iX+8KYioDJs37B0bMyliE1X+LgFMy1ISgU=;
 b=oWio+ASIz6PIqPHcIP2st6+COKVt5wiwPL+NtgejWQ5jXSnHNuLSq/zWUfgMPjmUYOiJDD/X1STaLIGT6YU2tflRM14g4bmuzEC5zsDByviClV7zl2m7eQ+1giLOjpfprDG2yV7SwY9DSsFHGWEc2JhijQlUbvsbWoHHm7aUqzJ9yT7uttEWxRa4Z/xJMQyE4KyYjiOwoslEE+IM3wl21y4YuANUEEkSSWc2snxyFETAo3GbqVHsMXwAI+GvANJ/rw1y0dl3oGTFOYkR4EGLxMKNQssd6DLA8AEcpVp/kvRH/G5Ucws/1UoSpSKVZiofmc+f0jY5fmbmPpGx3JhXXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSt2vbIr2iX+8KYioDJs37B0bMyliE1X+LgFMy1ISgU=;
 b=o82f8+3I1koBBpNbqNeQUHFCgx8Ee/7DbiUObRSLSLbYOGG5It+M2d0pM58JB8cY0bPe7QCCbA6ScWeRvmFPXMxqLlCaDA6hAxixi0R064cZsHWxcfwj3nqDwK6Mic4SRSYZpS9WhkE3NN7Q4wQQ28tpBYFc2UcIDYxJKzGkNqo=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3455.namprd11.prod.outlook.com (2603:10b6:805:bb::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Fri, 9 Oct
 2020 17:13:29 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 17:13:29 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 4/8] staging: wfx: wfx_init_common() returns NULL on error
Date:   Fri,  9 Oct 2020 19:13:03 +0200
Message-Id: <20201009171307.864608-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA9PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:806:a7::9) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Fri, 9 Oct 2020 17:13:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88c95c4b-e0c1-46c0-eeac-08d86c76a476
X-MS-TrafficTypeDiagnostic: SN6PR11MB3455:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3455746F0DC8B5AD66BA8B1093080@SN6PR11MB3455.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:392;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6F7w/PQgjMpjhZITDYNLJKg83WogApdq/x1BcAwhMUEvuqS0BtMIfj8UwWlrfCASKWatadIvJlNHjgiVlsn/uISxRKao0AI17b+F0BWuDdXI5B71THwlP9ApEQCE80czl0cu3uXmkgZhCJbXffKFGA6lSBUr2t8CNXnL6oL2uDq535sPy+5Mg7f59dap3Pjv1yY24qwXu5sMGzg5b+mHHejKzBYGq2GsLc/piW9iGpTiZ2LAARiOGtQcD3wckrg7l0Tux8SjS6Qlw81aUDy2p6ILmHbOaMaWfNdx/hXeEI8Mmp2GgP3RzjIvtAJ7JUfKzz3DFlQq7VbbPsZb8QPG2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(396003)(136003)(8936002)(36756003)(54906003)(1076003)(316002)(52116002)(7696005)(2906002)(5660300002)(478600001)(66574015)(86362001)(4326008)(66946007)(66556008)(66476007)(6666004)(107886003)(26005)(16526019)(2616005)(83380400001)(186003)(8676002)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: P131R5G5cMUPWoR32FkNYMR9qVowtJogi/NJDntiDzN8rSQjdKmXR8rGX3w6VQ5Fwo2YagACEBHEdqosYlvmS3hPGWp6HvT3kpUttSNuiKyNzD4/8YmCzg4COMjaLGwQjdmK2mmbHzpgrKbPSLWY9IrA0adt+LR4iWMTqvqRFEADvEjaYwoZD9Gi0iAzrXtBqOGaKT7awusU5vA9hdp4ERhh57svpP14PdcsDGg8rSxZhbM+pNiSc4gGvXjsmJQuAZwPRH4CB8/YPp8Ldu+drHL1WQI6O636KVfO2nYctkhvRy+W159Mq18sXgGxF6MuEZU0uLzd0JYHNCZILs9Pve3SRrrgyhU6h707lPRuuOIFGcpoc9Gmk+oJSvMDR7LOIAZLKyNz8qZwS5gIE2j9H8qMGtfkXXI3SPL8rRoVoNA6FuIHmWXr6j1Z/ZYxcAIGicfV8F6jY+lhISbmTFPsXKYLtECh+5GpP/A8SnWw+42XZkUB1yh10Rt1Kphhe1s4oqI1ggtLD6uudVko/GxxjG1v4YVDccrBon3ZyMT2ybrFh3EuavY4xm1r4JKPeQHf6Fmye51aXfsqb89LcvL67ZoZ5vC77wMNrBIbUMTiQQnKMJ0WgG3hrQD5SWhGEhsMC+kR2ZgoACV9v2hzBSzucg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c95c4b-e0c1-46c0-eeac-08d86c76a476
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 17:13:29.6502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fh3NTCZoN1DLokwJ6xRP77qO8UIXi3ZX8tOl15CLELlDZywIGoEFNdglEqV82iesGfLlRexBUJESJ5WLM/nzIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3455
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU21h
dGNoIGNvbXBsYWluczoKCiAgICBidXNfc3BpLmM6MjI4IHdmeF9zcGlfcHJvYmUoKSB3YXJuOiAn
YnVzLT5jb3JlJyBjb3VsZCBiZSBhbiBlcnJvciBwb2ludGVyCiAgICBidXNfc2Rpby5jOjIyMSB3
Znhfc2Rpb19wcm9iZSgpIHdhcm46ICdidXMtPmNvcmUnIGNvdWxkIGJlIGFuIGVycm9yIHBvaW50
ZXIKCmJ1cy0+Y29yZSBjb250YWlucyB0aGUgcmVzdWx0IG9mIHdmeF9pbml0X2NvbW1vbigpLiBX
aXRoIHRoaXMgcGF0Y2gsCndmeF9pbml0X2NvbW1vbigpIHJldHVybnMgYSB2YWxpZCBwb2ludGVy
IG9yIE5VTEwuCgpSZXBvcnRlZC1ieTogRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFj
bGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVy
QHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgfCAyICstCiAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCmlu
ZGV4IGE4ZGMyYzAzMzQxMC4uZTdiYzE5ODgxMjRhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L21haW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwpAQCAtMzA5LDcg
KzMwOSw3IEBAIHN0cnVjdCB3ZnhfZGV2ICp3ZnhfaW5pdF9jb21tb24oc3RydWN0IGRldmljZSAq
ZGV2LAogCXdkZXYtPnBkYXRhLmdwaW9fd2FrZXVwID0gZGV2bV9ncGlvZF9nZXRfb3B0aW9uYWwo
ZGV2LCAid2FrZXVwIiwKIAkJCQkJCQkgIEdQSU9EX09VVF9MT1cpOwogCWlmIChJU19FUlIod2Rl
di0+cGRhdGEuZ3Bpb193YWtldXApKQotCQlyZXR1cm4gRVJSX0NBU1Qod2Rldi0+cGRhdGEuZ3Bp
b193YWtldXApOworCQlyZXR1cm4gTlVMTDsKIAlpZiAod2Rldi0+cGRhdGEuZ3Bpb193YWtldXAp
CiAJCWdwaW9kX3NldF9jb25zdW1lcl9uYW1lKHdkZXYtPnBkYXRhLmdwaW9fd2FrZXVwLCAid2Z4
IHdha2V1cCIpOwogCi0tIAoyLjI4LjAKCg==
