Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DADC1C559D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgEEMi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:38:28 -0400
Received: from mail-eopbgr680041.outbound.protection.outlook.com ([40.107.68.41]:21169
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728820AbgEEMiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 08:38:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ymd2QheM0awX1EQBPakXzDk2Cw+KPMZiuE9moh1rSyGy37l1MGiW5Zu/WLmiHbiKnjAE5YwdMNbp3RlLkLb0jEoFOuQM3GpUCoqbLKGM1ZHSbdoVoX55JkGX4TG4Ex/LsXrdcylf6ggLgc3ygo9h14VBpNy+5+8syd0Fppv0vheF1ituTzMeBp3FlaXLSoMqk4/bq718tswgVUvnI+Nu52036PxXCbNHlb3eNQPX2cbdRDN2L4QFTn8TU2UT9vMi1L937AE7JA4edZHDJWN8oTythDa+v+2X8BH8r1vvfPyYVMFhOawm9b8t//zWpCCsignQKQpe0jCeFvrHvLl2hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCH8mmcJgGpVXMjhw1rPMvwlijTfdzjECeja2BjWE4s=;
 b=afdQrt2kD+3qBj/RebI46pOhDXFj30WQURxefyrScx01PHYTLCr7sxOdWfjgZhehCrmgqQQbMkzRQQcJR/Lpa7ltK+WLyn7ANX27EryCuz5pBy+wOXOSDPHmvNxm/YjsrrlniC1Qx1PcKgd8OLSFcFssTXixik8bVP7Pj1VG8DBGQiorjeRAloje/oVpjud2EyaLaZSnCRV9PSnmhkAOTHqZRmlA0/sPJ6GB2hr58aeoSa5FYONd/FcQgUKdysBsHHxlJ4LV6HmnzjhaL+HdS4BkHUIK+rzBgtXeaethsDH+9CeSTiePyHFkj20V6hMGjhhli6+C0SXa8khbXUh3DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UCH8mmcJgGpVXMjhw1rPMvwlijTfdzjECeja2BjWE4s=;
 b=nfLGHYT3tjNc8N7gSmrEQd4MNDfF8oh20p0rSfwdxSv8Imfonm+4Y8TMyxDSSnDlHaMaf8vIeHZ+6XRbRHlAv0Ssouv6CUoTBpP00NPkV8CfQmldG6c4evrPFrFo8H3u1ynuGTSM4ckCmspCeMM8XCa/XxZ/XrftDtuwWds7n2c=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1824.namprd11.prod.outlook.com (2603:10b6:300:110::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Tue, 5 May
 2020 12:38:18 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 12:38:18 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 03/15] staging: wfx: fix double free
Date:   Tue,  5 May 2020 14:37:45 +0200
Message-Id: <20200505123757.39506-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
References: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::27) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by PR3P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 12:38:16 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a497b6d-5ca6-4459-e643-08d7f0f12ff1
X-MS-TrafficTypeDiagnostic: MWHPR11MB1824:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB182462102E91FB0FEBB02F4793A70@MWHPR11MB1824.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuFHG5gUtpG8MyTJnueniW1HpIIxzVVCn5pjwCIttjdz1b+qBRMU1Wv6A6CiUzSyh04zvZJpe54/ZBJBIxuO4LBnxGda4uT5JdMpH52WDxmmUKPCrs+ubeYE+wuTbBo6q45cNLcRKpSVnnakreq4RfbLFvFFF/iRT5UYGu4n83Dm39k6qW1G99TXw6coNAVmtWpDCGVqiM5NGhL9pEXx/4DV5vQn642d9aPKdSsGd3+F9bv7/8xwIESMFr857RetwWv3H5sA/m4qLkinkR5/9HmHn/RWaX02f1nAVa8OmrqLEYw56twmpC15yCAF1eLwb5zsYl0dKfNU582K3EsGaKWb3Lb0GU82/w8MU4HHd+2ICBZvemSxvm86NLnX0aoXYdx4rqmAMHmjdAkoc54XV00GywOqgOgLcAbfR6MonUZJJFz15s3cvFH7wjPEoNe+ZgNT0QpxRwKC0Q8Gs36CIpjsWmBXNFYz1WLmVCuqV2Bsr14v6Se8sAxRKvQCXKNeCx80pViLY9oRkb/1jviRuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39850400004)(366004)(376002)(346002)(33430700001)(86362001)(6666004)(8886007)(1076003)(6512007)(6486002)(66574012)(4744005)(36756003)(5660300002)(2906002)(66476007)(6506007)(16526019)(186003)(52116002)(66946007)(66556008)(54906003)(2616005)(4326008)(8936002)(8676002)(316002)(33440700001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GI52Lil0C509Jevm0prHdGsZ+F0+OWARgP12+ow9Adx099jhVni7zZnHlL2+x2rVSRDjJBYoB6cTmKQ9v6148LBOrWYOSJT9Xcsj8kG546Pjybhu6PlPnqFnuA4DXO/1cHXxX9XNVR95o4S4d6jlekgqAbQK89Okafy6X9jAegc5bEO2wTX26JEIHQBasB58za3qdCZQ0bSzG46baolzHTP5RQUa6YXm6IxtBAf0OmvZP8ELJQbLRAa/pQ1KexysFtnkoBip8V9HlVBs7Bt1pr1RoFC/vlb6c+AFXStlfNqH3gxwQAcT71gn0t8IYMd443Vyk0rDkgg4bYaPmfR5sJmSDEC3wym31DzKrMjKq/tJQguApveRG7MP1uedy0KE/bgt9X0uPc5raR5y5ayT7iKfTz0BDXIUs/syd9lejFBZMGBPPjMEw2BQOrELKIbpp1PKDB2R0zENB3O8/2LnOWSw+YarmZfGTMB09xhUiwgFqvMHt1EcFVJLdCuEX7cN+8Df+oRebXV4bHt4RL92+l72vVwUdEhIO90Hi6ec1TDpdIxrDiM7OAvygRsSq9aFhEYnXJWwMBCwrh0TGqgpnOYp44MfK8SfovsUN6jtJRBYVkNyW7H7KPMIDSWGWdvT/jKRNXWHMKiXMaBaHFBga96RoTT2O0NGk5j5ovW9mYLIcRCpUVFMz3VhS9ApMYr/jfqWpKsc5cIoCgpeKWpEOWsAoHrtkkx540E3vv2S4zTJBKYesjrfgc4AG/BEi4i1ecpDRMJKsZgYdS3mxm6reBzoQ8Xi5FdbX2iTBTc7lufreI87SfhxUP782g/YOGaM1MortdIgtJXUy7NfocWUuVraJdW4p0G9Yt9VC+1hS3g=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a497b6d-5ca6-4459-e643-08d7f0f12ff1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 12:38:18.3409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DK9wlolRBgBxKxkErqKoy6PhsuWiBEM8xefAIK2KeuPBSafbyr1RdHuDrkjB+r5oYhLXSzGz7vj2CNTBzkd5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
Y2FzZSBvZiBlcnJvciBpbiB3ZnhfcHJvYmUoKSwgd2Rldi0+aHcgaXMgZnJlZWQuIFNpbmNlIGFu
IGVycm9yCm9jY3VycmVkLCB3ZnhfZnJlZV9jb21tb24oKSBpcyBjYWxsZWQsIHRoZW4gd2Rldi0+
aHcgaXMgZnJlZWQgYWdhaW4uCgpDYzogTWljaGHFgiBNaXJvc8WCYXcgPG1pcnEtbGludXhAcmVy
ZS5xbXFtLnBsPgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWls
bGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgfCAxIC0KIDEg
ZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9tYWluLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCBiYTJlM2E2YjM1
NDkuLjVkMDc1NGI1NTQyOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKQEAgLTQ2OSw3ICs0NjksNiBAQCBpbnQg
d2Z4X3Byb2JlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCiBlcnIyOgogCWllZWU4MDIxMV91bnJl
Z2lzdGVyX2h3KHdkZXYtPmh3KTsKLQlpZWVlODAyMTFfZnJlZV9odyh3ZGV2LT5odyk7CiBlcnIx
OgogCXdmeF9iaF91bnJlZ2lzdGVyKHdkZXYpOwogCXJldHVybiBlcnI7Ci0tIAoyLjI2LjEKCg==
