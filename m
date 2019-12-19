Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58F8212598A
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 03:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfLSCSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 21:18:47 -0500
Received: from mx0b-00273201.pphosted.com ([67.231.152.164]:61178 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbfLSCSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 21:18:47 -0500
Received: from pps.filterd (m0108163.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJ1VrJ7009510;
        Wed, 18 Dec 2019 17:36:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS1017;
 bh=TwbAGuok1bTFjqrqxzGUPHhZwIyB4jjUh+u95F+d8QU=;
 b=n6SBP5bk3x3KMKj8ghJ4i6j7/l9v1kle/7XcqO+BEx4TUJFSzZggXyxyQbhNf+VDUnTi
 S5vC8eIrl4KC3y8GYCaUTn/iDd9pne3LGVdPyJDMpms2KK3IW5R3qIFKzmlSTQEYWBOM
 BijKbOhPMP6zEXBp65zxyV6MOZDhyA0+kkt6uKK+QeBj8IRjnVM+mF6/rxIW9O4ZjUWr
 B6lXMP+z6m7DQBnkr8c3D5AxRK1mJI+oavUcsnwgoCXeHdUxPa3lya0hZPj3MlaK2UmT
 nsyDL9TkDo044AMzuYV8eVUOGscTy2dZ+fIPXUHWYVDfgHk4S5nhYArVwCzkUaEVO//a nA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0b-00273201.pphosted.com with ESMTP id 2wyvssr86m-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 17:36:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPDDwlCbqqnwbgGkjZjUUSeHDnbXutzU50LoXuKK16FYFXlzCzCMrVuoQRPABIep2hYxrk7WZpW812fPjq5zyDRvff+u/1+kuWzxSLzNeEdh9jyeRjVrC8gE8Q7EHptASRjlzeT/OVWGdVVNli9FzdaIfgB+cDOFa4XAQlMvbupLEsy6XYoHtd2bj2jkwmnt/rFSSy8OI14gmxN5q1xCZ8CJmDZlhoT825mCi0kW6W9IRYPJEtE78GGjWaJ1czihKOGAuvaCi9y1oDXqYoq2Bl/ARO8hMTPV44O5XyUCoHtYxFhIBy/tiFd+YE9LtOVqjijnLVY9RjBSdzk4ZqBneQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwbAGuok1bTFjqrqxzGUPHhZwIyB4jjUh+u95F+d8QU=;
 b=RwcXQGIXn+31tESgyUtU92VJZVspOyZ/8zyLV903W3OVZoxMZnH1cZvjeQbU0/2tg8ddCNXj04QEg7+kp7Xw+k3hu4JEw0+lumtRs/gAx38DBymyn3Y9fMSEC5DXUf1pfDnknIyl+kY2/59jxOzSP+Q6goqUM8lZe7DetJaY+4s4Zh8PkzWNdSzvwQ+3dfafRLbego11W9xpqpwIjWP5yJ5rRUd895G44zmz1SRoE10+/FEXm4RqKk4yI7ZKNCRjiauta9JzWBq3xcqK8yw8nXiXPvRI0lFsWZ1O7GWfoRk22Vfx325nRBX+gnWUhO9ZLBGa3m/PWaT1OYJ27qlLRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwbAGuok1bTFjqrqxzGUPHhZwIyB4jjUh+u95F+d8QU=;
 b=KYaE3qimoamMqoLE0bX07XJdAia+pjp/QxJXwr7urAXpEDLQnKw+e76IBU+T7tAMx2gNg/oYdRW1rKnnv8l2NrKALQcQh2GXRgE2kOzhn+Tp5DWxka0c5zzsBc+yU5RIpFLiuxdhO+IE2eC8P3uSX/TQPmgGw5ox1NH7JLVgm6c=
Received: from CY4PR0501MB3827.namprd05.prod.outlook.com (52.132.99.143) by
 CY4PR0501MB3778.namprd05.prod.outlook.com (52.132.99.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.12; Thu, 19 Dec 2019 01:36:28 +0000
Received: from CY4PR0501MB3827.namprd05.prod.outlook.com
 ([fe80::8d77:6795:84cf:dd47]) by CY4PR0501MB3827.namprd05.prod.outlook.com
 ([fe80::8d77:6795:84cf:dd47%7]) with mapi id 15.20.2559.012; Thu, 19 Dec 2019
 01:36:28 +0000
From:   Edwin Peer <epeer@juniper.net>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Edwin Peer <epeer@juniper.net>
Subject: [RFC PATCH bpf-next 2/2] bpf: relax CAP_SYS_ADMIN requirement for
 BPF_PROG_TEST_RUN
Thread-Topic: [RFC PATCH bpf-next 2/2] bpf: relax CAP_SYS_ADMIN requirement
 for BPF_PROG_TEST_RUN
Thread-Index: AQHVtgy7mRHYyb7iCEOl60RGiSf//g==
Date:   Thu, 19 Dec 2019 01:36:27 +0000
Message-ID: <20191219013534.125342-3-epeer@juniper.net>
References: <20191219013534.125342-1-epeer@juniper.net>
In-Reply-To: <20191219013534.125342-1-epeer@juniper.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.246.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 10745875-e15e-4ca7-d1cf-08d78423de1c
x-ms-traffictypediagnostic: CY4PR0501MB3778:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR0501MB3778AE9A93F6945A3DB4D045B3520@CY4PR0501MB3778.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(136003)(346002)(39860400002)(189003)(199004)(66556008)(8676002)(66476007)(66446008)(36756003)(107886003)(5660300002)(6512007)(76116006)(71200400001)(478600001)(6486002)(66946007)(64756008)(81156014)(91956017)(2906002)(6916009)(81166006)(86362001)(8936002)(1076003)(316002)(186003)(54906003)(2616005)(6506007)(26005)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR0501MB3778;H:CY4PR0501MB3827.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: juniper.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 32tIyhr17ZafpEsfC5xpnrnGrTfugq0LfGYoT5gLSIW/WjS8HTEc96BfiH3qg6A5cpx1Y4mw1FQLCoN9U3yvMQRDBNu7oti3TI6k2aX2ABOpQLeeGOtDQzkfdj3rhD+wUXEQch334xgFiG/iVpZaNgQ87yJbsUku7axafp1IhOUVMcuGJm80Kavgd19pvR1NLiL4GIzSCHlisXz3GjgrUtBWD9mWiBNF8TznjakUtrGjCVg4uqBdRX9jZx0LdyfWBb92A5nWzbTjtGBH/UjwH8R1PAiCsIh9r0YHnhaLd3XkFsS6jOtfPXvMFVTP0bW7s8ycnPARRCZ4zwaWCTXZ4HuvwU6Ox/lSze9rUL2hXEs0uRUpMpp6/2XTjooUPG8npPGfIj242mZftfAdMpMY5fyawoSNqxV5sUqwXILH3MOSEFZEEoh+I2lU6oyhY6iI
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 10745875-e15e-4ca7-d1cf-08d78423de1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 01:36:27.4624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /HPqWMsJGNSv6/CBXZ+FRB3/DukRxIlwj9laMPRPOIYgnwvTeU8jNsKuVfxa5opCKektPv/OvxZj47WmHFcF0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0501MB3778
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 impostorscore=0
 bulkscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 adultscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912190009
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a bpf_prog_get_lax() API to provide unprivileged access to BPF
programs. The new API is provided to make explicit the intent to allow
such access at a given call site, however, it is not exposed beyond the
syscall interface here as there is no plan to use this beyond
BPF_PROG_TEST_RUN at this stage. The semantics remain unchanged for all
other existing callers.

This change allows unprivileged users to execute BPF_PROG_TEST_RUN for
all BPF program types.

Signed-off-by: Edwin Peer <epeer@juniper.net>
---
 kernel/bpf/syscall.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8e56768ebc06..970aeff9a9d9 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1578,7 +1578,7 @@ bool bpf_prog_get_ok(struct bpf_prog *prog,
 }
=20
 static struct bpf_prog *__bpf_prog_get(u32 ufd, enum bpf_prog_type *attach=
_type,
-				       bool attach_drv)
+				       bool attach_drv, bool privilege_required)
 {
 	struct fd f =3D fdget(ufd);
 	struct bpf_prog *prog;
@@ -1587,7 +1587,8 @@ static struct bpf_prog *__bpf_prog_get(u32 ufd, enum =
bpf_prog_type *attach_type,
 	if (IS_ERR(prog))
 		return prog;
 	if (prog->type !=3D BPF_PROG_TYPE_SOCKET_FILTER &&
-	    prog->type !=3D BPF_PROG_TYPE_CGROUP_SKB && !prog->privileged_load) {
+	    prog->type !=3D BPF_PROG_TYPE_CGROUP_SKB &&
+	    privilege_required && !prog->privileged_load) {
 		prog =3D ERR_PTR(-EPERM);
 		goto out;
 	}
@@ -1604,13 +1605,18 @@ static struct bpf_prog *__bpf_prog_get(u32 ufd, enu=
m bpf_prog_type *attach_type,
=20
 struct bpf_prog *bpf_prog_get(u32 ufd)
 {
-	return __bpf_prog_get(ufd, NULL, false);
+	return __bpf_prog_get(ufd, NULL, false, true);
+}
+
+struct bpf_prog *bpf_prog_get_lax(u32 ufd)
+{
+	return __bpf_prog_get(ufd, NULL, false, false);
 }
=20
 struct bpf_prog *bpf_prog_get_type_dev(u32 ufd, enum bpf_prog_type type,
 				       bool attach_drv)
 {
-	return __bpf_prog_get(ufd, &type, attach_drv);
+	return __bpf_prog_get(ufd, &type, attach_drv, true);
 }
 EXPORT_SYMBOL_GPL(bpf_prog_get_type_dev);
=20
@@ -2254,8 +2260,6 @@ static int bpf_prog_test_run(const union bpf_attr *at=
tr,
 	struct bpf_prog *prog;
 	int ret =3D -ENOTSUPP;
=20
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (CHECK_ATTR(BPF_PROG_TEST_RUN))
 		return -EINVAL;
=20
@@ -2267,7 +2271,7 @@ static int bpf_prog_test_run(const union bpf_attr *at=
tr,
 	    (!attr->test.ctx_size_out && attr->test.ctx_out))
 		return -EINVAL;
=20
-	prog =3D bpf_prog_get(attr->test.prog_fd);
+	prog =3D bpf_prog_get_lax(attr->test.prog_fd);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
=20
--=20
2.24.1
