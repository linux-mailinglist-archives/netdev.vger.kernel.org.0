Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE80B117C94
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 01:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfLJAnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 19:43:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39982 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727329AbfLJAnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 19:43:20 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBA0d86i027551;
        Mon, 9 Dec 2019 16:43:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1V4TFVBU6RqwxzXelntcyW99CG/tzsd90qTA6HsUzls=;
 b=SbDUmKtmGRCiTQoDaqO6iQA0Z/WDeVOIEFG6ytpAIW0bkG3zQSSxOxtAto563Dd2qExX
 PC1qlMrWUCvmZH1IxS8Z4591RwVBcpagOqKOFB7qwCbpQdGaQwzaEwCfDQf2hkrfgNVi
 Wa94TP8Qh5eOs7qzldQyZ6HDrEf78TiWXYM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrvye7uu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 09 Dec 2019 16:43:01 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 16:42:59 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 9 Dec 2019 16:42:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJZ1F0vmQOucp1nZrtgQ5HDEumm4Js8RX0S6RolW/LEvZrCqqkQBMCw2xwLwBCCcc2jtwHmtH0brKWtXep5O+8Ag4KNkAX++eFED+CHQSuN/16dOeZP5ugR0A/F1n4kCjtAKOt9T9F3AI/hthKYC/NW7QsVvRKcFh/NZj0tmD58ZIlTGcoDhXMQgKmyz7vqJz6CTpfM04/RtE3jdG4V+ZQzcmSct+DsGAldWQsFfyqIeaIETqDur2BQBOcGLXFueiUzehFFR2Au3FNxTKfcgboBudpojPhc7T1vpXJSn4AFbAKGYnVOFZ3fhlTyci6Qo2ppKhK/CmHxA+KSWpcXlhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1V4TFVBU6RqwxzXelntcyW99CG/tzsd90qTA6HsUzls=;
 b=YGj3JC3z6CyJQ6XJPU/HJHiz+YXDgz/J6nIRmNe5E3M8A8ENaRXQdCObZoVssTeq2MtveOGvP35NLjE5zqRA4f31rRBsmGDbRUnY17EKelptsz74u/JXaIkVKfrfWz/Uhv8rF9nc38j8WMBMvc48IdHP5ACpFd8hqeOV5xpTsqrbRQvtSqZLkijpMp9slJPbfV0rEb8tYdsNLTJNR5ptLwHQSOWXVWIIkn/4SrpBEjAAb+i1IySNQ6/YwyOuei7katM9VtU5nBq81KAwmu+qJY+MpnDNqm4nvt5LceQbP1y+fea4mIymTG4kfZrVHFkjFStHxXPsV1viV1WR68nulw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1V4TFVBU6RqwxzXelntcyW99CG/tzsd90qTA6HsUzls=;
 b=Q+uYz7A4exmHEenMWhZiA9tpjpE3bCG79dK3n56Fyewi5eb1rcfcTgYdAqdpLrBtrshqFSCmfiBqPOyFSbI/UHS9phVlfFDzkM9wGTKRL7TtuozawvX9UBZH13EguV1adFhdFRDT3Zu5B+tb6q3I36uRyBhTr6Y/c/8evYsizp0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3392.namprd15.prod.outlook.com (20.179.20.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 00:42:58 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 00:42:58 +0000
From:   Martin Lau <kafai@fb.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next 02/12] xsk: consolidate to one single cached
 producer pointer
Thread-Topic: [PATCH bpf-next 02/12] xsk: consolidate to one single cached
 producer pointer
Thread-Index: AQHVrmZI+YQrK/QS9kuzCSZeM0rJpaeyiLcA
Date:   Tue, 10 Dec 2019 00:42:58 +0000
Message-ID: <20191210004254.m5cicj3tkc2bhlrd@kafai-mbp>
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
 <1575878189-31860-3-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1575878189-31860-3-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1601CA0015.namprd16.prod.outlook.com
 (2603:10b6:300:da::25) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:ba63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78ba0c1c-0c07-4938-c5f7-08d77d09e70c
x-ms-traffictypediagnostic: MN2PR15MB3392:
x-microsoft-antispam-prvs: <MN2PR15MB33927D6A45505D20E02730B9D55B0@MN2PR15MB3392.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(366004)(346002)(396003)(376002)(136003)(52314003)(189003)(199004)(305945005)(478600001)(71200400001)(71190400001)(186003)(6506007)(52116002)(5660300002)(9686003)(1076003)(8936002)(6916009)(66446008)(81166006)(64756008)(81156014)(86362001)(66556008)(66946007)(6512007)(6486002)(66476007)(2906002)(229853002)(54906003)(8676002)(316002)(4326008)(7416002)(33716001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3392;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VeJMcRr6ZKuo0b/nePUkf17HooXEjHKQBk7xTAUWPbp4NN/kTg0R6oVt9+9/XkD/q0L0FYHPDxCTNKfvwi/n03OM998tLvvpwu003Xh7J2/NHMGwCPVxhgONiZa3JMfsQ1qmGh1+FZi1L4EvZakG4Vusg1xAjQ0uQ0TJlMFvAMHjQyxnLENnH5KPiyFn5Zde92H0sZ23haQdpX97iMjO4tI47tdbFWZWLS0jtK639LoQZ80HZyYPlaDzfyQnldOXByiMZH3uifmhfzHtXQFtkrHs4snogPqCrJl7Bt6WzBLBNCCmhG3YVSPXBbSwZnsOTi1QlsjfUtP12uFpKpLdFBwIqs9Rl5yT2ahh1tRMICqLYMZrgGL0lZvbS298ia2QTWWDnuEeMypd1a/zhaslR4CSvOUVkNZ/3BFxR2M14HGzBBcY9TFrwu+s36OmAAEe+pndoYMSQResAH7LIS5KEsl8DxOlebPwAeKNYcrZMnnIKucXRGMj71CvndbJ9/mg
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9391CEA730FFB140AC2D472B7AFAA89C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ba0c1c-0c07-4938-c5f7-08d77d09e70c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 00:42:58.3734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V9XF+efLu16IrLmQ73nRru9N3twwgONzNoXDOXKKAY7x4abraV+8Bs2BO5Qvjioc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3392
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_05:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 clxscore=1011 adultscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=352 suspectscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912100004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 08:56:19AM +0100, Magnus Karlsson wrote:
> Currently, the xsk ring code has two cached producer pointers:
> prod_head and prod_tail. This patch consolidates these two into a
> single one called cached_prod to make the code simpler and easier to
> maintain. This will be in line with the user space part of the the
> code found in libbpf, that only uses a single cached pointer.
>=20
> The Rx path only uses the two top level functions
> xskq_produce_batch_desc and xskq_produce_flush_desc and they both use
> prod_head and never prod_tail. So just move them over to
> cached_prod.
>=20
> The Tx XDP_DRV path uses xskq_produce_addr_lazy and
> xskq_produce_flush_addr_n and unnecessarily operates on both prod_tail
> and prod_cons, so move them over to just use cached_prod by skipping
prod_cons or prod_head?

> the intermediate step of updating prod_tail.
>=20
> The Tx path in XDP_SKB mode uses xskq_reserve_addr and
> xskq_produce_addr. They currently use both cached pointers, but we can
> operate on the global producer pointer in xskq_produce_addr since it
> has to be updated anyway, thus eliminating the use of both cached
> pointers. We can also remove the xskq_nb_free in xskq_produce_addr
> since it is already called in xskq_reserve_addr. No need to do it
> twice.
>=20
> When there is only one cached producer pointer, we can also simplify
> xskq_nb_free by removing one argument.
