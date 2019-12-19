Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02212125991
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 03:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLSCYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 21:24:46 -0500
Received: from mx0b-00273201.pphosted.com ([67.231.152.164]:59492 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbfLSCYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 21:24:45 -0500
Received: from pps.filterd (m0108163.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJ1VrJ6009510;
        Wed, 18 Dec 2019 17:36:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS1017;
 bh=eELr4+bNIK4ZDRfTRiePDyXosDYb3eZP0xXL9SOf9DE=;
 b=EhhuKEcq7ZsoX8VB5UwP3Xihwjh1mo0we0oSMbbG9WfT2UjHRtrs5APtiByfVuupdOfT
 YaKFDN7cVgFWZqqjnaJmbvR4+9NltCa3boKNDavV1Fi38HNJrfJYmv7ehx7Nu38iCu+i
 6n4UKurnCT6bJMn4/7m+1splujU7Lgt7A3XQmiLjnBHkmHflixF6Pe7QCcDAqubQPHbv
 BLVA1fbCKYBBSfT86qIqClJ0sxdL4y1xoLdITkh+cFdslS9speB5CjC9v5sCNUGXjt1Z
 0SwvMX1RM9u5hBMTLd1/0eGPIINo7//HgUwztfIqCsWR7FkQs5X0Nvl/rm7z9B1a0LcJ YQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0b-00273201.pphosted.com with ESMTP id 2wyvssr86m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 17:36:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9amcYj2AEGOl5yyXz/dbgeOLH7g5khlZdMoV5lrTqEjwUzjGL9XiaPeNGF4gmyU7ODSgP5FWDarLgMX08weWNX0B4B/45iXri5degDHxpRqDZ8PF/5GS5mr32/Yh1B2IGTGOQ4pV5prLcOttPiVz1wRm8rGQulZNemqodXH22ZSBY6o8tKp0N41/tH/CZaNNRoV2xJA2aM7Y+dB8eS00Z5cW0ryxJ+Szw+edY8ggEgaqY/EX+GSiXjqdlWe+eTKqWM7xmS3i7E79HyWutwAn4Nox69j7+ts0v9te+Sp+825mqNZ2Wt4662YnKFSHlT266WhPE+1+R8uQyH6I/BvOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eELr4+bNIK4ZDRfTRiePDyXosDYb3eZP0xXL9SOf9DE=;
 b=lsVtTsma0iUsSQOTwwT08pRXBS3bXLcbgQTWQQMoWkWSOoqgWteaFVhwABdwYq5egvKGhBNn3RrCzUsf/1IPL1Y9IuYLtvvAd9/JEbkeOe/UY9NQK+Clcy7ygD3gGUj4ea1Sc/UiPsCroEx4P1IyaVpTI+9uFOkhxfi7/YlV1yE0m6g+AFl9drQtfm3ie1gu7UK4G4IMAprgR0Sp1YhY+Ldvn5hUjNL0Kj7phlzg+YDAfrbtHTCdl7ShmxwdNGvaCyqBMyO98CMn0UNBn1I87QN9jZgEWo3jWlqLDzRcj01l6N2u1uGYDIwxpY+jeW5ZhgDMnsLhpLONkB4VBNoEDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eELr4+bNIK4ZDRfTRiePDyXosDYb3eZP0xXL9SOf9DE=;
 b=YZnri1fqLsYWjbdq4pQ9FNL4Ga6te+AxiOdLNwpwUFOn+BYC1fu1sK9I3u02Q1eUrIvbMqOikso3zRvRK9XbmRJaOZtpUKV01HFnKy8heJGeuJChNqukF0uC9FXXb6Y1JxQAvQfKI3AeUC0DOnGi+QEvYTKRx1ko61dLn1XMteM=
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
Subject: [RFC PATCH bpf-next 1/2] bpf: defer capability checks until program
 attach
Thread-Topic: [RFC PATCH bpf-next 1/2] bpf: defer capability checks until
 program attach
Thread-Index: AQHVtgy7FOhx/YJYL0eKPXFartRsPw==
Date:   Thu, 19 Dec 2019 01:36:27 +0000
Message-ID: <20191219013534.125342-2-epeer@juniper.net>
References: <20191219013534.125342-1-epeer@juniper.net>
In-Reply-To: <20191219013534.125342-1-epeer@juniper.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.129.246.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 98052c69-21c5-4072-de72-08d78423dde2
x-ms-traffictypediagnostic: CY4PR0501MB3778:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR0501MB37788C8AA42A0B6E1C9277B0B3520@CY4PR0501MB3778.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(136003)(346002)(39860400002)(189003)(199004)(66556008)(8676002)(66476007)(66446008)(36756003)(107886003)(5660300002)(6512007)(76116006)(71200400001)(478600001)(6486002)(66946007)(64756008)(81156014)(91956017)(2906002)(6916009)(81166006)(86362001)(8936002)(1076003)(316002)(186003)(54906003)(2616005)(6506007)(26005)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR0501MB3778;H:CY4PR0501MB3827.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: juniper.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nSdLwt3Pp7Qyky3XgimCAKkWL89kTGclARAk99aVQNmBUvMgtQWvVFpueZMccRwBPfNV/Wq75Go60gfS+waY4bDTmn5Sh+mf2Td5odqcRcmZ+q/Fv+nV7R1+R+0/ZpLugGd/twNDJzTP1UvUoGJkNRtzwh5yIaRe6mozi2+0KmgzaPkUEKlFXHFV/wFpJ/L9f9N7mO513ipkvbcKoHBvpinV5xcd+Ld5ATML2f+BGtHB9e/B7LJcqjM4YjhlKu2jTaF+Am1eOtwc6F1dBSOLggzuA0aAqAm3f/jMkwlau1nLiTZJHWcAvAdbUD3eUQbzOOLr6dXCuuGfvcwCrDxtSm25MfrXFfO8Js9ram5yyLdj2Y4vDrfME+pXfWREmQKLaPeg4i2UVoS+MpiHACpTWlSwT8lf0kUUc2oh2Tac5gfqIbPunmduNWa6m7r13YLL
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 98052c69-21c5-4072-de72-08d78423dde2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 01:36:27.2169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G+TKStfpWZREk3wFxOCytNDuaYUPgOtQIRzSybuaXKmflHbWARnOz1sn5K9TPImOdmt/rqyMkIHzF2etMPvk/w==
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

The intent of this patch is not to change the effective permissions
required to run a BPF program of a given type in the kernel. The
actual check, however, is now deferred until attach time. For
example, an XDP program will fail to bind to a device with EPERM if
the program was not originally loaded under CAP_SYS_ADMIN.

This is achieved by remembering whether the program was loaded by a
privileged user within the BPF program's context. The upshot of this
is that BPF_PROG_LOAD is no longer a privileged operation, thereby
exposing access to the verifier to normal users for all program
types.

Signed-off-by: Edwin Peer <epeer@juniper.net>
---
 include/linux/filter.h |  3 ++-
 kernel/bpf/syscall.c   | 11 +++++++----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index a141cb07e76a..1957eea62bed 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -534,7 +534,8 @@ struct bpf_prog {
 				is_func:1,	/* program is a bpf function */
 				kprobe_override:1, /* Do we override a kprobe? */
 				has_callchain_buf:1, /* callchain buffer allocated? */
-				enforce_expected_attach_type:1; /* Enforce expected_attach_type checki=
ng at attach time */
+				enforce_expected_attach_type:1, /* Enforce expected_attach_type checki=
ng at attach time */
+				privileged_load:1; /* Loaded with CAP_SYS_ADMIN */
 	enum bpf_prog_type	type;		/* Type of BPF program */
 	enum bpf_attach_type	expected_attach_type; /* For some prog types */
 	u32			len;		/* Number of filter blocks */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e3461ec59570..8e56768ebc06 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1586,6 +1586,11 @@ static struct bpf_prog *__bpf_prog_get(u32 ufd, enum=
 bpf_prog_type *attach_type,
 	prog =3D ____bpf_prog_get(f);
 	if (IS_ERR(prog))
 		return prog;
+	if (prog->type !=3D BPF_PROG_TYPE_SOCKET_FILTER &&
+	    prog->type !=3D BPF_PROG_TYPE_CGROUP_SKB && !prog->privileged_load) {
+		prog =3D ERR_PTR(-EPERM);
+		goto out;
+	}
 	if (!bpf_prog_get_ok(prog, attach_type, attach_drv)) {
 		prog =3D ERR_PTR(-EINVAL);
 		goto out;
@@ -1733,10 +1738,6 @@ static int bpf_prog_load(union bpf_attr *attr, union=
 bpf_attr __user *uattr)
 	if (attr->insn_cnt =3D=3D 0 ||
 	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INSNS=
 : BPF_MAXINSNS))
 		return -E2BIG;
-	if (type !=3D BPF_PROG_TYPE_SOCKET_FILTER &&
-	    type !=3D BPF_PROG_TYPE_CGROUP_SKB &&
-	    !capable(CAP_SYS_ADMIN))
-		return -EPERM;
=20
 	bpf_prog_load_fixup_attach_type(attr);
 	if (bpf_prog_load_check_attach(type, attr->expected_attach_type,
@@ -1749,6 +1750,8 @@ static int bpf_prog_load(union bpf_attr *attr, union =
bpf_attr __user *uattr)
 	if (!prog)
 		return -ENOMEM;
=20
+	prog->privileged_load =3D capable(CAP_SYS_ADMIN);
+
 	prog->expected_attach_type =3D attr->expected_attach_type;
 	prog->aux->attach_btf_id =3D attr->attach_btf_id;
 	if (attr->attach_prog_fd) {
--=20
2.24.1
