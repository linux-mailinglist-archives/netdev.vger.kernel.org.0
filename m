Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0117BEA82A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfJaATO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:19:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727179AbfJaATO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:19:14 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9V0EHDV027780;
        Wed, 30 Oct 2019 17:18:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aRGa9aLjKGjDxrBZr7SrjtFY+hoKLnRWiU6AYhVGpgc=;
 b=Kytm3C14uy4kxzQYnwtO9kqCW4Tq/+oi4Nq7OQLtoH4GBvKOer461jpdQQHKkFUmsIT2
 tf02hMpZ6MhoaO55ESEjNsMOs1ALc+AzdmkxCRbqVHDV38eUary6OQ5ai6wMLLdXDbLy
 yNIMIu77xsrbvDUymgr0GCfrGEYomhcuLU8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vybreb3fj-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Oct 2019 17:18:59 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 30 Oct 2019 17:18:58 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 30 Oct 2019 17:18:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDJQyG6fIBMXH53oGc0Pjr2LB83/eCR5Gdnyd22Ovbz3cgC65YeH6ehEjD9AD0RTppSA8HtgWx3RpCXkrHUR1Um0Nh4AM9NpTsFBOXaaLEuEGtvAfWjISiF5sxAFsRqiA9/B6rE2KMpOt6o8jlGhEDBcZ9EijPiu2zQRljRA1NsF/n9/KmgnGpw3ujmfIaEqydBa9dwDEEXxDzPqjhjrDYcWo4btRSIbKFykAhqtG722Sq5yP7eN3FVmOtlkWh4mcQVgzfXvqX4kjF6KVP+ss1zdv4hpZd5/HS8j+WCy1z4xAUc+GtkfPQVhP634vInLOdBVWzOkwVDVn3Cj2ZN6nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRGa9aLjKGjDxrBZr7SrjtFY+hoKLnRWiU6AYhVGpgc=;
 b=Y3WrbQ+tLQQvqVK06p68yFke2KD3OwnrBZ4fRxRDY2K8gb/as35xVBEKAbfx5BH4UF56GsXYjUkd0z+E5j6AUOk8HkbPVZTmSeERP5/+MF1l2fPe1NMA0Z9yZKlWtm/QokoQMDihuFvWOMlP9z0dQFoNKw9H87eVuAuvmKpKZfBw7FGOCvtg5mH3WR0Xkq2DKY4FZrRDH9w1SgMfAju2y628Qz9Kl5IYzLcz+XOJcd0lJm1ykF5cyTirig5iEQdoWCNvUXWRjhWWUSlAK9oXrwVKoYsmSsieHPUNKmEbyeRSSMWr/0Nyj9Lh+ueB4DyWvhsG8OtwY++XL4mIODV3pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRGa9aLjKGjDxrBZr7SrjtFY+hoKLnRWiU6AYhVGpgc=;
 b=aklQbEEGQYzPzGKlO/sXrYbUmzut2Di1gKDNcG3ZTFxF3wdnP8TI8g+SVV9sn6qjeu7oSovyMvluSH7GCZKKsgvBCzKF22EBXZKWoNO4V5ZtRG/z6XgoJvALzgM59M3sokUGGJG/6pMiJMCkfcUux9AybLT+kcC4ucOrNyW0T90=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3390.namprd15.prod.outlook.com (20.179.21.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.18; Thu, 31 Oct 2019 00:18:57 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2387.028; Thu, 31 Oct 2019
 00:18:57 +0000
From:   Martin Lau <kafai@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: replace prog_raw_tp+btf_id with
 prog_tracing
Thread-Topic: [PATCH v2 bpf-next 1/2] bpf: replace prog_raw_tp+btf_id with
 prog_tracing
Thread-Index: AQHVj3HulwEIXpibQk+YZ4BoxrGkiqdz4qMA
Date:   Thu, 31 Oct 2019 00:18:57 +0000
Message-ID: <20191031001848.nbozv5k4qfc572ii@kafai-mbp>
References: <20191030223212.953010-1-ast@kernel.org>
 <20191030223212.953010-2-ast@kernel.org>
In-Reply-To: <20191030223212.953010-2-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0008.namprd20.prod.outlook.com
 (2603:10b6:301:15::18) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::93dd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68e0fc20-2265-4f55-099f-08d75d97ebcf
x-ms-traffictypediagnostic: MN2PR15MB3390:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB339083253598C64ED03CB46BD5630@MN2PR15MB3390.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(376002)(346002)(396003)(39860400002)(366004)(136003)(199004)(189003)(71190400001)(256004)(71200400001)(2906002)(4326008)(316002)(5024004)(25786009)(8936002)(33716001)(8676002)(81156014)(6116002)(81166006)(66946007)(66446008)(64756008)(66556008)(66476007)(14454004)(54906003)(11346002)(478600001)(52116002)(486006)(1076003)(476003)(6246003)(229853002)(6486002)(186003)(6436002)(9686003)(6512007)(386003)(6506007)(446003)(305945005)(5660300002)(6916009)(99286004)(7736002)(86362001)(102836004)(46003)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3390;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mrr2LMX0FYDicVF4UwrZcna96Jrp6NsvpKySf/OUmH1TSKXatIEAcTSWYl0pF9nRHvOohoI0tKPWftg2W2FVf5dhhg8AsdPARwvwSjUbfk/t3UT3BMoXYHyurpZJM0kjkPxXCHTG/6FxPebBdPqNoZ17lxLJbGuEWnYEUfnnLka7ZEI0CyKrlSw1Gi3sN/1dB1+Mk/lTYh29pLn8XgOJ09UvMI3Cv6oBH57rmZ6ijQZ+PBqPGmw9SKShZbO1EEoXNvt+uvs0jeHHhg4JgvJG3GAZVPXpxFqlZTmqNVQ+grVQBuffRVkHZ96oSb2hJ/cnE/thRoUPynQgwxXmxHE0Opt3pk1mFLfcIGeDsSgUDvu8leHwkxae4rK/fjaGVInByVHhXMSjKiOLEJVJl/+yDaJ9TKzKjrXyqIW3mg3J2OcXEWAyyJv0T63HT5F8dmy1
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B3509D3F3DCF3148BA6DE9D86E683D09@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e0fc20-2265-4f55-099f-08d75d97ebcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 00:18:57.5242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yav1H+ly/kW/vvj4YQI8krQ8d6BlGm9kSj5MpkeFsEw0nGZNfDvnkpO0Ekql7vq5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3390
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-30_10:2019-10-30,2019-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=976
 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 impostorscore=0 malwarescore=0 adultscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910300218
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:32:11PM -0700, Alexei Starovoitov wrote:
> The bpf program type raw_tp together with 'expected_attach_type'
> was the most appropriate api to indicate BTF-enabled raw_tp programs.
> But during development it became apparent that 'expected_attach_type'
> cannot be used and new 'attach_btf_id' field had to be introduced.
> Which means that the information is duplicated in two fields where
> one of them is ignored.
> Clean it up by introducing new program type where both
> 'expected_attach_type' and 'attach_btf_id' fields have
> specific meaning.
> In the future 'expected_attach_type' will be extended
> with other attach points that have similar semantics to raw_tp.
> This patch is replacing BTF-enabled BPF_PROG_TYPE_RAW_TRACEPOINT with
> prog_type =3D BPF_RPOG_TYPE_TRACING
> expected_attach_type =3D BPF_TRACE_RAW_TP
> attach_btf_id =3D btf_id of raw tracepoint inside the kernel
> Future patches will add
> expected_attach_type =3D BPF_TRACE_FENTRY or BPF_TRACE_FEXIT
> where programs have the same input context and the same helpers,
> but different attach points.
Acked-by: Martin KaFai Lau <kafai@fb.com>
