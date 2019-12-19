Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA65125986
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 03:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfLSCQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 21:16:13 -0500
Received: from mx0b-00273201.pphosted.com ([67.231.152.164]:14396 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbfLSCQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 21:16:12 -0500
X-Greylist: delayed 2370 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Dec 2019 21:16:11 EST
Received: from pps.filterd (m0108163.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJ1VrJ5009510;
        Wed, 18 Dec 2019 17:36:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS1017; bh=WZn6vKs50KNjjloFcyI628MFfJ2QaXTAd+wImg1I9uo=;
 b=YgBwLlMsrOdtoi4c0wMZYuCfzdRp33jha2BClFl/g6hnuQsq9Tuw6w7qQ0dNMBpSXc7u
 qbfMaIh6dJfkzBAxJiWNKmDpMS44mPkyEn1HZYPC3W7btWneKRT865zrULgsX2Xrtbaz
 5DSgYewrjfMCA22W9o6O8MW7bf3VI8ubOmNEmIIBNvUr2jPMbY39xilCN5DsB/b58TvK
 CJjJSvl9wpYlfNEhNnE6MEKo7/MtkdOVv8iV7S1W7XZpqtCKJJ2DyB7n35MiwuNpGF7I
 AKLqNbGfVX76FHjGwZgw6j5izieaDLZGUdvwGunY6yhafjBd+afJgbvGJij5Dyv0omuS jg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0b-00273201.pphosted.com with ESMTP id 2wyvssr86m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 17:36:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioqDp+WJB7DRPzNGV6k2Q9I1uJevvyHxB0Ohk0sULDbH2A8MwFyRyQlR/YaWipyYoa+efkEDxV96UT8jXuFHyP2YoThE6MwBGouX2c19dM16CIQTal0ojYyqkRjwm03WWDVbDH/0C0rCRschILjpEQeA8nLz4AHHhXlQbKfkq8FTp4MmTgGB+9k2djrfQnn1XSyr35ZqiTft4PQKaDmRmtUFHEBILwZXYuyqaAPbkZHQZrNfyDNz0Q5k+H5E/emMnBqWMy9wdvUO1Q5VJdY9oqBcjRI+MqzPolMJvlpHsP1L5zXSD43qhVQZe6guqD6nKmiAZbAsMdZ0Yc1ht2Wyrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZn6vKs50KNjjloFcyI628MFfJ2QaXTAd+wImg1I9uo=;
 b=RCJ8zJC2B/NtZ7lFhD0sukYr2VjgUGCDetF4n8PO8/ZCsnhdkiQv3HCqSlMAUTQftgIxBnFRGWkgjYXVZJShKg+VtVpr6HotcaVRyY4ugAxRbfuVEhwMRk327wyzZfN/wK/1Yc63Rsznw9poxnWbjAxKO6iKAEYC3sdyO7Qblp62Cfy+5FUlFnKBTRxlH4m+t0qyJpVTH3/9Z39r55la4saa/gvJscaPwYmEJzGbkfe6zyZmKyIaaz8YxTPN/LXGqQLEPzl+5dBu4E+xlOO3dvZczzOOb/bOg1CF6IaXBP6BQDpz3rq1KJ+Oj/svksLVzUXbK5ZJyg9JMhBWhv3uUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZn6vKs50KNjjloFcyI628MFfJ2QaXTAd+wImg1I9uo=;
 b=GRgvlrRELEuynBVsgZSpgCjkO9lYI6vlctqSRBzu5DE3s0dIp5KzS5EIRlmwqIb24xwfj4TwQwlDq66UzZRxGIVicZxQlQfmSd7IhOaudh3v2KmcWi5MaDJ0T70SCTX0QcZpvrw6Q24/tmMTavKy9/dkJzQrce9pjaILRXxLLsA=
Received: from CY4PR0501MB3827.namprd05.prod.outlook.com (52.132.99.143) by
 CY4PR0501MB3778.namprd05.prod.outlook.com (52.132.99.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.12; Thu, 19 Dec 2019 01:36:27 +0000
Received: from CY4PR0501MB3827.namprd05.prod.outlook.com
 ([fe80::8d77:6795:84cf:dd47]) by CY4PR0501MB3827.namprd05.prod.outlook.com
 ([fe80::8d77:6795:84cf:dd47%7]) with mapi id 15.20.2559.012; Thu, 19 Dec 2019
 01:36:27 +0000
From:   Edwin Peer <epeer@juniper.net>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Edwin Peer <epeer@juniper.net>
Subject: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN 
Thread-Topic: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN 
Thread-Index: AQHVtgy6x2wMuQ42JECcwOBV53W8TA==
Date:   Thu, 19 Dec 2019 01:36:26 +0000
Message-ID: <20191219013534.125342-1-epeer@juniper.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.246.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 245377e9-1d32-44f7-bb0e-08d78423dd7e
x-ms-traffictypediagnostic: CY4PR0501MB3778:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR0501MB3778AB5CDDB13DCE41BFA7FCB3520@CY4PR0501MB3778.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(136003)(346002)(39860400002)(189003)(199004)(66556008)(8676002)(66476007)(66446008)(36756003)(107886003)(5660300002)(4744005)(6512007)(76116006)(71200400001)(478600001)(6486002)(66946007)(64756008)(81156014)(91956017)(4743002)(2906002)(6916009)(81166006)(86362001)(8936002)(1076003)(316002)(186003)(54906003)(2616005)(6506007)(26005)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR0501MB3778;H:CY4PR0501MB3827.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: juniper.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wy3NBE8l4ytK90JKV7mOpIcH0eZ2thaXOA1Q3H18Nqvoz4zIB3CnVA+tYDeYqxPyZIGVFIePY7gXhkxy5cPcQTkc7+0TjdKyYrrOnPKu5W6iDGC/rUiMyqg2M4G9emLT/cS+8Ef1RnmgeNlAFTG33MK6KFBuNFxovNhBe5v0FIM2dDrOFU5diIqEp4kRE6CZsP6EyVl5a2ByJdr7Mu3W129bbJvRZz6nD7THSGuruxeDl2EQurKzlO1Ly5HZ+M+Ew/cJ3VCoPoWYIyQZGF6sVmGndwaNc1XcTShsQ44RY3xiS91VoNbJiuuPA8pxofk2GJ4V1ElvMRqD7xKYXi1SeZOSv6Fo3uR5NG3PygvqIBY4kRkJEq2+WQu4uUMlIaTRJD5Ep4EfU93J5qXqECeigms+KQUfQ1KDdUyuFwAM8acs/idK+XkVs/8xECqZR5D9
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 245377e9-1d32-44f7-bb0e-08d78423dd7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 01:36:26.9334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +dZANPGAd5GxwlN+gMEZh65IedzzKlEGF1HZAzbxGJqqqQfU3cCQMvrUBBjTxyE4X20oABG+XxUbZHLbczeW4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0501MB3778
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 impostorscore=0
 bulkscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1011 adultscore=0 malwarescore=0 mlxlogscore=728
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912190009
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Being able to load, verify and test BPF programs in unprivileged
build environments is desirable. The two phase load and then
test API makes this goal difficult to achieve, since relaxing
permissions for BPF_PROG_TEST_RUN alone would be insufficient.

The approach taken in this proposal defers CAP_SYS_ADMIN checks
until program attach time in order to unencumber BPF_PROG_LOAD.

Edwin Peer (2):
  bpf: defer capability checks until program attach
  bpf: relax CAP_SYS_ADMIN requirement for BPF_PROG_TEST_RUN

 include/linux/filter.h |  3 ++-
 kernel/bpf/syscall.c   | 27 +++++++++++++++++----------
 2 files changed, 19 insertions(+), 11 deletions(-)

--=20
2.24.1
