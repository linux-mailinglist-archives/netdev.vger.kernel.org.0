Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEAB4D4945
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 22:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfJKUXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 16:23:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32670 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728783AbfJKUXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 16:23:13 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9BKEhci026375;
        Fri, 11 Oct 2019 13:22:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LV14btPbWpxm6hjL2S8hqo3SA8Ed+dZoXvoh9yM03JQ=;
 b=BrRDQc8NAtm3Gtz4KEqetFevf2L1mKJC3ZSdMhuzvR1g6s0GhgeN660mko/kHYAAFGdY
 n/V/wJpDqtHy0ofKx4Sna7OAQX0fsp0ukWXSzOv9dEMm1LlWHUZU466F4hOXDucCCWTZ
 prhSKF6yK7J6Ius+pG6xlTDUktsk7PH5ARg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhy7hh7xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 13:22:59 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 13:22:57 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 13:22:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Znb4xlsCNoyyeTXiPg4CfgPyhEmq2lwAzoB5PX7wSIjmOHsf8BoTGIR5HCUATjxdlvjvWF4LwhagiYM5FWqRAeU32L4E0yoVTM39I+XALo440ZPwB1Gv8FjWM2k+M3A6xBcE3bWCwtJ7kwonhVAJ/3PBFipXAcD4goUSeQw7flAigR4wDwZ2jeqfyq+kUfWSt5e/81oIsYV4dIudGV2Ut8N5QkEU6TT896jYUwIG1WUVaCbw0f5kvuo/fwo8GFRjwSsSHQF8ObF52IGqqrwf6SI6/Y/snKDRtyVzrk1cDd2M8K4PeX7tNJKToOSzX8FQGV0wBXxy6ipxCSrBlxHCJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV14btPbWpxm6hjL2S8hqo3SA8Ed+dZoXvoh9yM03JQ=;
 b=IGEfkHUsC0DOIS1EveVGga3gvQCRfLzQ6Z950TMj0EJdV0wubRnA+NryjQCd+qord5OZ62Qd+C16fEfcFLKoGt9fS74VPVYxV+9jthoBexCsh7kOzjjZz042tTh07IKJ+nNsBCIQ5WjpVHriv/5aj3+Mlhb+ue19PHStnqz1o5YDu+mix311LqqbZk6GvyOm1LRJid13mrK4kjUCUqLaA1X7/FrITJDE7xV/mMHoTFBsvfyfY+x7qxou4A+lIO3x+qsgnWDfE20kTPe+AfZH3NK5OPlTJVXy1DaQDvlAMTk9Z31DNMAZUbQRFCdw9FUxTUyNrUfQiwLc4ouw37pc7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV14btPbWpxm6hjL2S8hqo3SA8Ed+dZoXvoh9yM03JQ=;
 b=QPQJUBszdq/qNd7ul7LUKfle5XCDSSNJ4Oil/Qo7qfbU8H/+mRITXa7oJ8Hjstz1c4HMDBO8cX3ZBpxNrPYllZxnZlpsVH+Ur189eIL1QTM/I6UzQrnkKk3k+w7X/YziyhWWeRw7o38iv+qvGegfnFsaLT8pR6n80WbNAHBoz0U=
Received: from BN8PR15MB3202.namprd15.prod.outlook.com (20.179.76.139) by
 BN8PR15MB3473.namprd15.prod.outlook.com (20.179.73.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Fri, 11 Oct 2019 20:22:55 +0000
Received: from BN8PR15MB3202.namprd15.prod.outlook.com
 ([fe80::5016:da37:f569:9c04]) by BN8PR15MB3202.namprd15.prod.outlook.com
 ([fe80::5016:da37:f569:9c04%5]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 20:22:55 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: enforce libbpf build before
 BPF programs are built
Thread-Topic: [PATCH bpf-next 1/2] selftests/bpf: enforce libbpf build before
 BPF programs are built
Thread-Index: AQHVf+HdqXvt6Ot3gkOYA9yhXRt+uadV44uA
Date:   Fri, 11 Oct 2019 20:22:55 +0000
Message-ID: <20191011202251.fctg32cd4izhyz3o@kafai-mbp.dhcp.thefacebook.com>
References: <20191011031318.388493-1-andriin@fb.com>
 <20191011031318.388493-2-andriin@fb.com>
In-Reply-To: <20191011031318.388493-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0025.namprd16.prod.outlook.com (2603:10b6:907::38)
 To BN8PR15MB3202.namprd15.prod.outlook.com (2603:10b6:408:aa::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:ad20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34b3c082-aa49-4710-727c-08d74e88cc96
x-ms-traffictypediagnostic: BN8PR15MB3473:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB34732413D5091DF15D871B5DD5970@BN8PR15MB3473.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(376002)(366004)(39860400002)(189003)(199004)(66556008)(476003)(66446008)(66476007)(64756008)(229853002)(305945005)(66946007)(76176011)(6246003)(6512007)(9686003)(52116002)(6862004)(2906002)(7736002)(8676002)(81156014)(81166006)(186003)(99286004)(71190400001)(71200400001)(478600001)(8936002)(102836004)(25786009)(11346002)(256004)(446003)(558084003)(14444005)(6436002)(6486002)(54906003)(5660300002)(316002)(386003)(6506007)(6116002)(1076003)(4326008)(6636002)(86362001)(14454004)(486006)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3473;H:BN8PR15MB3202.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q+2NEYcfhAF1VPVMmISaTKAZQrOLWyf2tGe5qO+hFUBgyGJX+hFUPO7NQ0ijphTJf8UjwpKsmjF0pznA4RhJombRXOw2YnduGYuY250xjG7NjguANnvmVsa+PoJfi1V/saI907CVW0REU2mKCUy4k3VQ/IFHEAGccNHQ2fpIX/4qGUTPFiQzvjmOeaZExP/mKfIgffjsFYwFhAPHdCvv7/5ouU6Ii+9I1NT7L6Ut7rDHIKNyfIJZ+/TvcH/HJgndmN2szmD2pshTwUzR/hSr/vR+zlISWUAcLwzxG/8PjHIn7SDexjXAV87KZ5TGrE+k7z+jQ5/yKwSP32mMqWwm0c5GZEaWi049HbjBFdnxksIrb8h4OQblJkzykRa4ImVLhV8hE6SudJQwwF6as1p6ci01Z1dDvyKI1nbQEYYABRg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <103EB1E5D4AE1E40A80A367C28EAE92C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 34b3c082-aa49-4710-727c-08d74e88cc96
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 20:22:55.5562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3zDGOW1AS+RVFBlmengQmkbo7Uqwe5ZOehOePO6aredCQ5hMQNRJpr5RB2u38q+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3473
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_10:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=403 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 phishscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910110163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 08:13:17PM -0700, Andrii Nakryiko wrote:
> Given BPF programs rely on libbpf's bpf_helper_defs.h, which is
> auto-generated during libbpf build, libbpf build has to happen before
> we attempt progs/*.c build. Enforce it as order-only dependency.
Acked-by: Martin KaFai Lau <kafai@fb.com>
