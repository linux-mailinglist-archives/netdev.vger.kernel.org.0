Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31109B2625
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 21:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388299AbfIMThA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 15:37:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388245AbfIMThA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 15:37:00 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DJXith031307;
        Fri, 13 Sep 2019 12:36:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wv1lIgRxqlcCQB9JIGkzhIIr9XSZUm1bMwSchGCuPHQ=;
 b=Ht1K+1Tv4CdYb4YnEAacxhgZgcxuNB6+CxW6073apcUaEQUBCgfEG2kVZnoCW4Abbc4o
 /VAPsiLMYQG9pEKZQc1omHu3z65CoDo9P7wyHWX0rie17m4S2nPo3S//Cu8L+E+jUjez
 Sk7wJ9yZbvO5xrzVMKJ8o6+mkA/EU7Auj2k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2v0ehf0vr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Sep 2019 12:36:55 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Sep 2019 12:36:54 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 12:36:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dprw8/FdACPIHHY+AgHiC/ydOB1lhx8bry8N3/6v6CZ7C25yqZQmYHzHUJpimXY1fHxA3NPCmBHENre3xtzE3x06wAEXXpR4JT/iGLPwMCuILIqzcpW6nSp4GsYcNE4IdcImiyGsTXXWFNZsYuY7FKgw74cUOl+LGKbdujqyyngwnMpewxb58Wq0APT9MQiBY77ljajPU1PgxPOS3/S8+QXT1dKYBibxyM6EUVi51UEUD8FJ9ooP6iWrb2sYRoftHT2kx6SILh4WFGsTiKI/nczY2vflfGLHXW/wW8arToBHqZT+1A/kfNaYaxp1Z2H6tw90Vbz5/Ci6qCMBmYr5UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wv1lIgRxqlcCQB9JIGkzhIIr9XSZUm1bMwSchGCuPHQ=;
 b=YNiNN0qS2jTd3QQBO9RDchi/q3165T4ar3UZc2DmV+m4jRLP7Gvgn0l6p5K8wiV4zVa/27Y1R/IpkBLNGiul4YkXgDzheLqwJDu2CuGfZYixMQrFiwOXPAJR69ZhlMsMVa4vpmmY26cT+98efLsFcXvmEbh0nZchkVcS3XWpYw/Y/K/x+47bOChsdALJUmlVsY4EUr1Qa01wRkk3prWIgBqiSM44/Zvi44W1+ckct0BnvndAbfpJy/niZqZh6zBjIBmbDOKY58GH2L9DqlcN+sBH9dAIGpqPD+IS/bE9M7DZorrcIGgj/kumiuY4NRCFC4pDXNxiFM5pbz9A1J4acA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wv1lIgRxqlcCQB9JIGkzhIIr9XSZUm1bMwSchGCuPHQ=;
 b=ONnmKv9cznKKzmuRHunPg6/2ttB20UEP1UGd/40VWE86VugdjbkzCueY6y24hj/1La9sNmvU4uQX17aDQ2cvfMgtTBw9Tn8ll/vSoiM4A2G6g56po2eWP/DEwGjlNkRopPpfBXZeSBiSz98v11kqC+ic0IaEd9ZiS6MXC8Hnipw=
Received: from CY4PR15MB1207.namprd15.prod.outlook.com (10.172.180.17) by
 CY4PR15MB1174.namprd15.prod.outlook.com (10.172.176.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Fri, 13 Sep 2019 19:36:40 +0000
Received: from CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3]) by CY4PR15MB1207.namprd15.prod.outlook.com
 ([fe80::f5a0:2891:cf42:dda3%6]) with mapi id 15.20.2241.025; Fri, 13 Sep 2019
 19:36:40 +0000
From:   Thomas Higdon <tph@fb.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jonathan Lemon <jonathan.lemon@gmail.com>, Dave Jones <dsj@fb.com>,
        "Eric Dumazet" <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Dave Taht" <dave.taht@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        "Soheil Hassas Yeganeh" <soheil@google.com>
Subject: [PATCH v4 2/2] tcp: Add snd_wnd to TCP_INFO
Thread-Topic: [PATCH v4 2/2] tcp: Add snd_wnd to TCP_INFO
Thread-Index: AQHVamqQ5tx5el+gREub79UMmA0m/w==
Date:   Fri, 13 Sep 2019 19:36:39 +0000
Message-ID: <20190913193629.55201-2-tph@fb.com>
References: <20190913193629.55201-1-tph@fb.com>
In-Reply-To: <20190913193629.55201-1-tph@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR1801CA0010.namprd18.prod.outlook.com
 (2603:10b6:405:5f::23) To CY4PR15MB1207.namprd15.prod.outlook.com
 (2603:10b6:903:110::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.16.2
x-originating-ip: [163.114.130.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd189a6e-742f-4e28-f9b9-08d73881b2c7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1174;
x-ms-traffictypediagnostic: CY4PR15MB1174:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1174164AD6D1A45B09A31F9DDDB30@CY4PR15MB1174.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(346002)(376002)(366004)(199004)(189003)(71190400001)(7736002)(305945005)(66476007)(478600001)(6486002)(2616005)(4326008)(6436002)(25786009)(66946007)(2351001)(11346002)(5640700003)(66446008)(66556008)(102836004)(86362001)(6512007)(53936002)(50226002)(2501003)(6916009)(71200400001)(6116002)(36756003)(186003)(64756008)(476003)(52116002)(14444005)(446003)(99286004)(486006)(54906003)(3846002)(256004)(1076003)(26005)(316002)(6506007)(76176011)(1730700003)(8676002)(5660300002)(66066001)(8936002)(81156014)(81166006)(14454004)(2906002)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1174;H:CY4PR15MB1207.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vKDzWkMdCV8f+LBwgpJAy+2mchQxeFy6MSHZkiJBhzhhdB677jD1aIcdhV1dkepatvYs0733sIiwOq/1t3en1uKit0SullrFKdz1gUgG6VxA6eiiS9v8gixBruitiT0dgMLzph/6AircHuPEAXc9z/qvqrs5elmAKm5Mm2N8IGC20ety+7RhMtcJlNc4m6efiWd23s4pQebZ4uhh5IrPDxPSO2iSBKk8YlZQyo1V9nQ8IYls+gFw5CmDPuicz9xO9dkC/COZnn0XkTGOLC2Z5P/15t6waMwQh3w1MXZBpMtGkQXqaNQ6DSnEbo0J1G3uipIL2+QYyhlwtLB3jzqkg4cxzgHAIvax3EjHMyqf00gEW1a/k5fq17etPgS/TuGyM4kguLKD7EcWn8GMwDavm22zZvHECIEAl92ZAy//RHU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cd189a6e-742f-4e28-f9b9-08d73881b2c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 19:36:39.9610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kr+P9AWNQLFvu9gpsWMeWv8dPCHcLiZLVWDE3AWogfad2mLj43FfEvJCpXksBTMH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1174
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_09:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=770 impostorscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130200
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neal Cardwell mentioned that snd_wnd would be useful for diagnosing TCP
performance problems --
> (1) Usually when we're diagnosing TCP performance problems, we do so
> from the sender, since the sender makes most of the
> performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
> From the sender-side the thing that would be most useful is to see
> tp->snd_wnd, the receive window that the receiver has advertised to
> the sender.

This serves the purpose of adding an additional __u32 to avoid the
would-be hole caused by the addition of the tcpi_rcvi_ooopack field.

Signed-off-by: Thomas Higdon <tph@fb.com>
---
changes from v3:
 - changed from rcv_wnd to snd_wnd

 include/uapi/linux/tcp.h | 1 +
 net/ipv4/tcp.c           | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 20237987ccc8..240654f22d98 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -272,6 +272,7 @@ struct tcp_info {
 	__u32	tcpi_reord_seen;     /* reordering events seen */
=20
 	__u32	tcpi_rcv_ooopack;    /* Out-of-order packets received */
+	__u32	tcpi_snd_wnd;        /* Remote peer's advertised recv window size *=
/
 };
=20
 /* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4cf58208270e..79c325a07ba5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3297,6 +3297,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *i=
nfo)
 	info->tcpi_dsack_dups =3D tp->dsack_dups;
 	info->tcpi_reord_seen =3D tp->reord_seen;
 	info->tcpi_rcv_ooopack =3D tp->rcv_ooopack;
+	info->tcpi_snd_wnd =3D tp->snd_wnd;
 	unlock_sock_fast(sk, slow);
 }
 EXPORT_SYMBOL_GPL(tcp_get_info);
--=20
2.17.1

