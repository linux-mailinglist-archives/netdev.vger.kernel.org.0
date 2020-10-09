Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9EB288FB4
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390088AbgJIRNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:13:31 -0400
Received: from mail-eopbgr760074.outbound.protection.outlook.com ([40.107.76.74]:48911
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390039AbgJIRNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 13:13:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odGaW+QT6zwBWxqKeeR+L0XRoIPplHJZ8AnBJh2k+k7nRnc4wCtKBcvjuzYHnNYron7OFN9k4OIYFF1p+3pJgOApWQBUBD/edHceMYzjv0iDVVjscWIV5uzPrsM1cC9/QLj+7Iti0ZLE/Kjc5WyzjC2mvXJboXQC1nb8ZLJvqEqMD71MTsz51kn2x8ytRDpzvz7oar6iipR/iY0VhZuHnP8rSriaQ6tPbedkGp3W+QPjVvVSfdfnLQu6uTWNHHLVCJxKifXCOC9KkOLZ3v5kyIjJDIUmKyM/hHUxh8oADk0Gb5BePIreLCJM0QSEWOu5TE9wCcqpZnSdG8pQ9q+oOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYYlhGzwZ5nf29iOCV3SfxyoDp2SA8k80kV08YVuKrg=;
 b=Z8VOqvqA1kotxXDoQ1yqVwTVyFyq2qPKQf2SyZ7OdrD/tOE+qOVY82keb0CEPAACQ2SxYr3r7xcXm6L87Y/52D8CMUyJuhh932mUhoufWq7LOtmao6fIsoS8+DSPYq8Vz0YQE9gadKuUHrwR1YN+XkNaNu/kCuE6er1KNrguVhZA7cpSOk+H2g/l+ETB8ogEZ7qOOEOhDskJ33hEpf9y7S7rmnbLsWHzZFLoOlesmjEco3PMR7Y32xjvWb0FXppwOkhQUdvszpyflxaGy/v2qojGN3dzAbrv8tnfrpDtSmqLnkmdev3gMGwDeXqhhzG2F/Umi7rue9PVPTmhybtCBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYYlhGzwZ5nf29iOCV3SfxyoDp2SA8k80kV08YVuKrg=;
 b=Js5QUvGRevkOaHU3I9yTh/f14zgTKbLOuHh08hMiWJn7SgFgQWQhtU0HL6ZODFWCiJoy20jFYeNe+RuL4oRTG5PIVXfHrkcn+FU7/XQfGQFnWBgxfNpJNavWCWwQLOa6fHQJCFjK4W4NI/hKFpiR1bVa5p97Cc6EYGbixLNsMbg=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3455.namprd11.prod.outlook.com (2603:10b6:805:bb::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Fri, 9 Oct
 2020 17:13:26 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 17:13:26 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 2/8] staging: wfx: check memory allocation
Date:   Fri,  9 Oct 2020 19:13:01 +0200
Message-Id: <20201009171307.864608-3-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SA9PR10CA0004.namprd10.prod.outlook.com (2603:10b6:806:a7::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24 via Frontend Transport; Fri, 9 Oct 2020 17:13:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72d09282-b570-4298-47c5-08d86c76a245
X-MS-TrafficTypeDiagnostic: SN6PR11MB3455:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB345579BDDA80FD5853D6D83193080@SN6PR11MB3455.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:346;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 14VxSr0rjZ2E8+s8lnzdK5juHgDCGM8C1GAKXZnEH0GFQDqqs/icuvNBRQ+L7H99ka1LwV4vzZiHhnysJ9ak7cJoh2WXrlgEAUCUnh94bIMt9mY7yPgMcOqgOwHx+Jbi8/UsLxttICOSRGQv5dNsPsY8rd/SuBXXZ36zEFVPlMbxVYR+usRj+3oSWUN9rqpCLXPA2A6Xk+bYAll7WOcits8ElkCLNnc1W1jkKq+J5RjXx5YCzEsizOlSW2BXXV2Vmhgi0K/MmBvJqqEFnLNaq4js9aBAtltHsLNQD3JZZFdLCTkIhWvl/5QZDfnLiFyeI+mbVHtJ7/TV7bt+8COnlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(396003)(136003)(8936002)(36756003)(54906003)(1076003)(316002)(52116002)(7696005)(2906002)(5660300002)(478600001)(66574015)(86362001)(4326008)(66946007)(66556008)(66476007)(6666004)(107886003)(26005)(16526019)(2616005)(83380400001)(186003)(8676002)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +kxWThVpH30h8AwPYpLjkpsVZ4XOBrO+H8rHYs/kVddlFzOPlO85K4dvby7ZVuPCPDWMS9dpLQvCRWqfDC2lztKSOTSVs3fQLXwElC+Agf3QGN4GjGr+eW1oqeaDVIzxKIF5XrFpCzu8Lr+kgXHU/5aqljrLWeCTFgv5nFkhIGy+ow4nWDunE+14/VKc4fouPZxs4LncBIb4AwCSbbqk/bwAwiQt9zJ8UhcriNFa5tT4SBhbI/2nvmmRTOPO25gEOjaRDzSDcQ9/yp7gws5XYCzyctHJtZ4S7tlxfCiOssZcjLHF//qfHw4U5nEbA1pVczPZ7Kmyqqc7qEXpBvyBuv7QHtCuaaKNJGoXQ6TctWH4ugiGf6PwzmF8BrRHoB3OcFIZCO7jPEhEFVayt9YTe9iFknOH1j/3zG4CnC1ONlDHO15JXR7hFkyqHt/WUqMHyatASRDRB8QsJ4TMH614veo2OZqCHyVNQTruYwuSRm40Xtv3Cy43In1oD7u4C3pd3Ic/BS30QedKIsg08FqYhtzrSlqiDruqCj90C8/n+l1zDU+7b3RTOFrKLAB4dnf9hj3k3eB5lN0/tZEIfTwmifkxgVheKYTTsFPdkJeypQaYj/BPBS4rdwFFlexIh2wjiMn+ZwrDv3Yk45D+86u8dA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d09282-b570-4298-47c5-08d86c76a245
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 17:13:26.0103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yAUMWqFeDRFcvGVhuflY+30d9uS0Ko40y4ofQMmKnp4tGqEQXXPY9uhD6rcQkKWxkeYMGmAyMeP2w0N/o1nE/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3455
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU21h
dGNoIGNvbXBsYWluczoKCiAgIG1haW4uYzoyMjggd2Z4X3NlbmRfcGRhdGFfcGRzKCkgd2Fybjog
cG90ZW50aWFsIE5VTEwgcGFyYW1ldGVyIGRlcmVmZXJlbmNlICd0bXBfYnVmJwogICAyMjcgICAg
ICAgICAgdG1wX2J1ZiA9IGttZW1kdXAocGRzLT5kYXRhLCBwZHMtPnNpemUsIEdGUF9LRVJORUwp
OwogICAyMjggICAgICAgICAgcmV0ID0gd2Z4X3NlbmRfcGRzKHdkZXYsIHRtcF9idWYsIHBkcy0+
c2l6ZSk7CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXl5eXl5eXgog
ICAyMjkgICAgICAgICAga2ZyZWUodG1wX2J1Zik7CgpSZXBvcnRlZC1ieTogRGFuIENhcnBlbnRl
ciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9tYWluLmMgfCA4ICsrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCBkZjExYzA5MWUwOTQuLmE4ZGMyYzAzMzQx
MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9tYWluLmMKQEAgLTIyMiwxMiArMjIyLDE4IEBAIHN0YXRpYyBpbnQgd2Z4X3Nl
bmRfcGRhdGFfcGRzKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCWlmIChyZXQpIHsKIAkJZGV2X2Vy
cih3ZGV2LT5kZXYsICJjYW4ndCBsb2FkIFBEUyBmaWxlICVzXG4iLAogCQkJd2Rldi0+cGRhdGEu
ZmlsZV9wZHMpOwotCQlyZXR1cm4gcmV0OworCQlnb3RvIGVycjE7CiAJfQogCXRtcF9idWYgPSBr
bWVtZHVwKHBkcy0+ZGF0YSwgcGRzLT5zaXplLCBHRlBfS0VSTkVMKTsKKwlpZiAoIXRtcF9idWYp
IHsKKwkJcmV0ID0gLUVOT01FTTsKKwkJZ290byBlcnIyOworCX0KIAlyZXQgPSB3Znhfc2VuZF9w
ZHMod2RldiwgdG1wX2J1ZiwgcGRzLT5zaXplKTsKIAlrZnJlZSh0bXBfYnVmKTsKK2VycjI6CiAJ
cmVsZWFzZV9maXJtd2FyZShwZHMpOworZXJyMToKIAlyZXR1cm4gcmV0OwogfQogCi0tIAoyLjI4
LjAKCg==
