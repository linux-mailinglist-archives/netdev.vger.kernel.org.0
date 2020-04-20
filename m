Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F4D1B10FD
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbgDTQET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:04:19 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:42592
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727920AbgDTQER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:04:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZ5vUgrUldN8fiZncsSU1r/HoDKjE5VyKKEQyp2jC8JQ8T6GLkRKUWjYUrCnmvRhDOSuBnp3OxBFaMYiTRquX5m/MBE4rIt+SrIB7vfhLwo5MmvZNn9jvJNKaTrl+Kgg3kD6wFdPP3eBYb3kN+8l3r2MZ4ZD0TKuElwvknaIysg2rY2SBmqopX8gyEIvJqiMuNYfUULsQHw1RCcekYdymUfTvbLwLnoHllwQEC20MjBTIMt2PdwSjqtVjFmyesSriOKmv7ZM11Bp4+mTs8hqOxNEoopxScFeYGbyMEl8266tUFUyUk9CcZ1ofZDrNiHV2C+fl6N6OP/77KspXbtA1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJ/Ej4m1vIl/mpXVcyvZcEkqsdUqm5hoblIo2TO5OSY=;
 b=Ipb1+s5+wSAPGQZ+5pjxqBLc5tVzOCckSW+JvU9acjIZn147vp+WOCjuGrCIb8NfSxDFQDbBwth7DB5yp6SY7cgwrsJtFYJiVCt3l0CpJr7e1ehiggaGOlj0H14tBSEAcgnAaiC08v3LA1thQn/spyaPz7FH/Dm2P45SA6SBnGr8bWmDuRhJsgKn1FFFa1CuhXc6SXJJP3dmTvCPAn8TNfv0a0E+2ZcXYiUlC46gg5+hgERGHeet2QhBoORvpLL3TqU8mF1nbgQnPcC8U33JxOaqXw0BB9o3UaOSDmWuJfLT3ZNeI7Kdy5+lu8h7ydj3GS+RYQmbsPUgwOYIim5U+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJ/Ej4m1vIl/mpXVcyvZcEkqsdUqm5hoblIo2TO5OSY=;
 b=IKrq8beuVkFSJK23WoqopFOsOkwX3Ztfgn6T8IWVSvvhBE6xKgsOe+uu+ahgRzYp8x0tRVWU4UxdeesNZNCrH4K7GVNvsdSSjs3AEu2m6xkm/pDL4H3bRCKNVBLduEujpEJi3O+MzJKG+cuqSQkJoWPzn2Cn0TSzFKBoahPWV4E=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1792.namprd11.prod.outlook.com (2603:10b6:300:10b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 16:03:34 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:03:34 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/16] staging: wfx: drop useless attribute 'bss_params'
Date:   Mon, 20 Apr 2020 18:02:58 +0200
Message-Id: <20200420160311.57323-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
References: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:5:74::42) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:03:32 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc4af28a-7637-4bf0-668a-08d7e54460e3
X-MS-TrafficTypeDiagnostic: MWHPR11MB1792:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB17923CDC608E5ADBB36105F693D40@MWHPR11MB1792.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(39850400004)(346002)(376002)(366004)(396003)(136003)(66476007)(66556008)(186003)(66946007)(4326008)(86362001)(16526019)(107886003)(6666004)(81156014)(7696005)(478600001)(52116002)(8676002)(66574012)(54906003)(316002)(6486002)(1076003)(2616005)(36756003)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TlBon4EJdeYyK7cjbd1ggKW0+0aUU7jU3nEKI+3PdO6Ih28ks0ko9MAfSgGGoogW31WU3yCZAfP1dftsWF7udmqBtmfvjV10dlmuoDqi5CFXTx7Q6jgVBljquccam0nJeEXlKLEkZnkwuCa8gErDIIOT+eqy7pwy4VBQlct9AKW1IDS77hph3rJ4TZW0f7H2jAfP1f6p2P07RuPisXnhe17BaTcJEPbf+q3AcIpf9JQFjevXKEYXT+z8a8cga9joSYrmZ1FoiSt2HGaPHgjLymuUINyArRSqf1K5YSBW0ZBH3U1bs8wzIYgb3N5bYG18MHaRq1SFP/PhuLkcmoePTcQQHYIrtVCXAFt1dNVvRephjnfRxq0GamvdHw5SQzIrOXt2FlFNqgU7QJNAWpk+O30YGTjK33YDfU80y9qNxJX2Adcwl1eSt/RGecw5Fpwj
X-MS-Exchange-AntiSpam-MessageData: kIyb/OzdFxoau20xdAbUwmVBgkgWJflpEN0Wl88mQ9e3RGmgmNfbOogDR/5BJhpEztasbz6j1yLjLeP9CH6or1crCjObJ44bPj9Ib/ttra807dhtHLsUKH1EXOpqfq/zjHpjAJG/zVgulNobq6QIaH4wFwbkFukCguD09lJp9TjkQDRwGcRnr/DpZOx7xU5beeo3CvJ38nL/TSvJHwVrSzTXtSQOe/Udxd2YviNn5wMvjgn2A7Zgc588Um7RvfqiPd+NfpzNu+gNzNthykrCxw7otdJ7rT0aBjwlb6ys1ZZNfkwwYX6fma/9A9NcocJ09j5rpAfux3mAqZ4hAIQt1zGTprwWb7HxjS/4ZxG8YrhySKjRYgj7L+jhfhoLnRrB4OCPBa5JohljqyDRZt01SWPRKTTfnbnPyxKCwn6Vhqu57J0Pd2LNhxCk1rKBHPcEodCPpz1okYk/QYOT2kHxDE2F8X1kb9KWVfn7R5k1HAFbM08ezt7/3fBTWt+1b74QZYIgXXM+KY4rWqEFJSGnGbxv/2lo5LcI5X+S3MwNrBgOCPIT78Fej4yBfQN9BQR9IOgj+9g4nWmWw+GSFZbue9U3Rh8q69JbUTLfSu7SR0DPBX8YD4UECbY3qfH9UrMFDKVNXRZlFGtk1Fn74fGy+93EVj+Uof4PjgczRZFfI/eerSAAyjnqwcTwWMTRdJ9O8KHXkkqr3FaPp/wnevmHfWVaoooz3x8Wj/QfMU5HuZAhNkf4+Q3RNc4BvEtI9BgwL96DjyBfrrOSC7y2L9BSdPXcWGFvp9KpgSHmaNNVWN8Nltqim0AbXT/aQlpk0aAsWtZWwHkoY1rTotIoyt7mZTS74zEl7F2CoQEOb/5dyX8=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc4af28a-7637-4bf0-668a-08d7e54460e3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:03:34.5755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/HsCdRYN6tyEAeEeXNCIC/FBzVYO/fclLpjgKnYNBmkoVtCXGRKn3IDa8/B8/BYUblIdgMbSHXKahjm7GXRNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lu
Y2Ugd2Z4X2Jzc19wYXJhbXNfd29yaygpIGRvZXMgbm90IGV4aXN0IGFueW1vcmUsIHRoZXJlIGlz
IG5vIG1vcmUKcmVhc29uIHRvIGtlZXAgYSBjb3B5IG9mIGJzc19wYXJhbXMgaW4gc3RydWN0IHdm
eF9kZXYuIEEgbG9jYWwgaW5zdGFuY2UKaW4gd2Z4X2pvaW5fZmluYWxpemUoKSBpcyBzdWZmaWNp
ZW50LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAxNCArKysrKystLS0t
LS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCB8ICAxIC0KIDIgZmlsZXMgY2hhbmdlZCwg
NiBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IGNhODQ3MjRl
NTMxYy4uMjI1M2VjMmJkYmYzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTM1NCw3ICszNTQsNiBAQCBzdGF0
aWMgdm9pZCB3ZnhfZG9fdW5qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCXdmeF9mcmVlX2V2
ZW50X3F1ZXVlKHd2aWYpOwogCWNhbmNlbF93b3JrX3N5bmMoJnd2aWYtPmV2ZW50X2hhbmRsZXJf
d29yayk7CiAKLQltZW1zZXQoJnd2aWYtPmJzc19wYXJhbXMsIDAsIHNpemVvZih3dmlmLT5ic3Nf
cGFyYW1zKSk7CiAJd2Z4X3R4X3VubG9jayh3dmlmLT53ZGV2KTsKIAljYW5jZWxfZGVsYXllZF93
b3JrX3N5bmMoJnd2aWYtPmJlYWNvbl9sb3NzX3dvcmspOwogfQpAQCAtNTM0LDE1ICs1MzMsMTYg
QEAgc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJ
CQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICppbmZvKQogewogCXN0cnVjdCBpZWVl
ODAyMTFfc3RhICpzdGEgPSBOVUxMOworCXN0cnVjdCBoaWZfcmVxX3NldF9ic3NfcGFyYW1zIGJz
c19wYXJhbXMgPSB7IH07CiAKIAlyY3VfcmVhZF9sb2NrKCk7IC8vIHByb3RlY3Qgc3RhCiAJaWYg
KGluZm8tPmJzc2lkICYmICFpbmZvLT5pYnNzX2pvaW5lZCkKIAkJc3RhID0gaWVlZTgwMjExX2Zp
bmRfc3RhKHd2aWYtPnZpZiwgaW5mby0+YnNzaWQpOwogCWlmIChzdGEpCi0JCXd2aWYtPmJzc19w
YXJhbXMub3BlcmF0aW9uYWxfcmF0ZV9zZXQgPQorCQlic3NfcGFyYW1zLm9wZXJhdGlvbmFsX3Jh
dGVfc2V0ID0KIAkJCXdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2Rldiwgc3RhLT5zdXBwX3Jh
dGVzW3d2aWYtPmNoYW5uZWwtPmJhbmRdKTsKIAllbHNlCi0JCXd2aWYtPmJzc19wYXJhbXMub3Bl
cmF0aW9uYWxfcmF0ZV9zZXQgPSAtMTsKKwkJYnNzX3BhcmFtcy5vcGVyYXRpb25hbF9yYXRlX3Nl
dCA9IC0xOwogCXJjdV9yZWFkX3VubG9jaygpOwogCWlmIChzdGEgJiYKIAkgICAgaW5mby0+aHRf
b3BlcmF0aW9uX21vZGUgJiBJRUVFODAyMTFfSFRfT1BfTU9ERV9OT05fR0ZfU1RBX1BSU05UKQpA
QCAtNTUyLDE1ICs1NTIsMTUgQEAgc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0
IHdmeF92aWYgKnd2aWYsCiAKIAkvLyBiZWFjb25fbG9zc19jb3VudCBpcyBkZWZpbmVkIHRvIDcg
aW4gbmV0L21hYzgwMjExL21sbWUuYy4gTGV0J3MgdXNlCiAJLy8gdGhlIHNhbWUgdmFsdWUuCi0J
d3ZpZi0+YnNzX3BhcmFtcy5iZWFjb25fbG9zdF9jb3VudCA9IDc7Ci0Jd3ZpZi0+YnNzX3BhcmFt
cy5haWQgPSBpbmZvLT5haWQ7CisJYnNzX3BhcmFtcy5iZWFjb25fbG9zdF9jb3VudCA9IDc7CisJ
YnNzX3BhcmFtcy5haWQgPSBpbmZvLT5haWQ7CiAKIAloaWZfc2V0X2Fzc29jaWF0aW9uX21vZGUo
d3ZpZiwgaW5mbyk7CiAKIAlpZiAoIWluZm8tPmlic3Nfam9pbmVkKSB7CiAJCXd2aWYtPnN0YXRl
ID0gV0ZYX1NUQVRFX1NUQTsKIAkJaGlmX2tlZXBfYWxpdmVfcGVyaW9kKHd2aWYsIDApOwotCQlo
aWZfc2V0X2Jzc19wYXJhbXMod3ZpZiwgJnd2aWYtPmJzc19wYXJhbXMpOworCQloaWZfc2V0X2Jz
c19wYXJhbXMod3ZpZiwgJmJzc19wYXJhbXMpOwogCQloaWZfc2V0X2JlYWNvbl93YWtldXBfcGVy
aW9kKHd2aWYsIDEsIDEpOwogCQl3ZnhfdXBkYXRlX3BtKHd2aWYpOwogCX0KQEAgLTg0MSw4ICs4
NDEsNiBAQCBpbnQgd2Z4X2FkZF9pbnRlcmZhY2Uoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0
cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCiAJSU5JVF9XT1JLKCZ3dmlmLT51cGRhdGVfdGltX3dv
cmssIHdmeF91cGRhdGVfdGltX3dvcmspOwogCUlOSVRfREVMQVlFRF9XT1JLKCZ3dmlmLT5iZWFj
b25fbG9zc193b3JrLCB3ZnhfYmVhY29uX2xvc3Nfd29yayk7CiAKLQltZW1zZXQoJnd2aWYtPmJz
c19wYXJhbXMsIDAsIHNpemVvZih3dmlmLT5ic3NfcGFyYW1zKSk7Ci0KIAl3dmlmLT53ZXBfZGVm
YXVsdF9rZXlfaWQgPSAtMTsKIAlJTklUX1dPUksoJnd2aWYtPndlcF9rZXlfd29yaywgd2Z4X3dl
cF9rZXlfd29yayk7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCmluZGV4IDI3NDdjN2NkZjRkMS4uNTQ4NGU3YzY0YzNj
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvd2Z4LmgKQEAgLTg3LDcgKzg3LDYgQEAgc3RydWN0IHdmeF92aWYgewogCXU4CQkJ
ZmlsdGVyX21jYXN0X2FkZHJbOF1bRVRIX0FMRU5dOwogCiAJdW5zaWduZWQgbG9uZwkJdWFwc2Rf
bWFzazsKLQlzdHJ1Y3QgaGlmX3JlcV9zZXRfYnNzX3BhcmFtcyBic3NfcGFyYW1zOwogCiAJaW50
CQkJam9pbl9jb21wbGV0ZV9zdGF0dXM7CiAKLS0gCjIuMjYuMQoK
