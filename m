Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC35D8126
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388153AbfJOUfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:35:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34488 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728737AbfJOUfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 16:35:40 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FKSPex021349;
        Tue, 15 Oct 2019 13:35:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=a7vQ8MR4cG6/KzIG5Q5Nzz2nUWEkFNLI8QgxDyh7cnU=;
 b=HxUYUrfuWg/GDsP7d4Ln/mZ6202GafM1Kyh9YTQgfKPMqWFs3HCsUpjPK2blRJy5+A+M
 +RNd/94I+mHlkS4ladOTip0mtfCM9G7Rp1r6euol+E/awOhdTpAI1nqOj7Xa+WP4475N
 Bqy2DeY5EqeubisAjIZFebgoQg+5yCqaUBA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vna13ubee-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 13:35:08 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 15 Oct 2019 13:34:50 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 15 Oct 2019 13:34:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuIZ4S+sNyYm8mgKrBBJ9R75XNfNx5dipLDQH8ByYuCZwC5vYNXzX5nwdhxHv44ApZ8eCW/WpoAv3GV0v6MxOVNKVlfQ5GWwiByDutWYNWNX+V2sC1TAQAVd6h9pD1zbLEQylc74iMh+2meaZn4dmAX27w8IgkgyhiDyxA1f/61BGCqsBCY+WCHecBBEroXaUOotLkpsO33b6nmKq1CdXWv6VgA7LtFt2sNqmSSnnhh4k1R5g/kbB0JDEQzXBoXbpiHDSjyBrL0JRMd+5Zv3RHT1LWfzM4Ca+Of4kwkASSNVMcdSo+VUErjTmO+Bqces84OhcvOqAJV0hTsaCC84hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7vQ8MR4cG6/KzIG5Q5Nzz2nUWEkFNLI8QgxDyh7cnU=;
 b=lo1x3wgw4Xted5W7sZi9XB9d9A2Ux3sKSJDj4v2MV0gpfegaxMgMWcQPUcaAgN8tPI+2wnLOna9t9mi5HuGQjgctFAUslXyhLO9psYE2hyRTwPJkWBvVqryVhs9CJ4dbanu6Y27d1ctUgLXQHdjI6ak9Pn1CG3N8TryUgV8mH0Gedk/sMCZ0rM5N/x6pHs4VLoECFUGPkrDj0t7ZQ8S/fTN9sEHhAjwrCtMtp++z1NpQHy4nR8PokWQeC9AGvoZ0NKBWcNS/arFOWnESDSQpErh3DzHa8EwVzJtXkuvV7VFt/4sgPdPV/61kEb1R3G4bwacptyYCjiavSYFyDelLng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7vQ8MR4cG6/KzIG5Q5Nzz2nUWEkFNLI8QgxDyh7cnU=;
 b=hBurzq8EiM5ThF8GLDlZfno005eR3nvfUCi2/zwjhktEh4ij4qTuOvt431syFnRnOIan5753fRWB4N1cAlzYVZLs2wh1FpWcxGcMXSuLqPMRkQ7Zvko3QXSVUs7xKgShKdYBfEkrb+EJeQulgtz1eNsgNvGsMTMXyONk7yTv2LI=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3200.namprd15.prod.outlook.com (20.179.21.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 20:34:49 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 20:34:49 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow __sk_buff tstamp in
 BPF_PROG_TEST_RUN
Thread-Topic: [PATCH bpf-next 1/2] bpf: allow __sk_buff tstamp in
 BPF_PROG_TEST_RUN
Thread-Index: AQHVg4bLB4hf08bSXkSHgnnryd8qBadcKOGA
Date:   Tue, 15 Oct 2019 20:34:49 +0000
Message-ID: <20191015203439.ilp7kp63mfruuzpc@kafai-mbp.dhcp.thefacebook.com>
References: <20191015183125.124413-1-sdf@google.com>
In-Reply-To: <20191015183125.124413-1-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR2101CA0035.namprd21.prod.outlook.com
 (2603:10b6:302:1::48) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:e6c4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c38375a6-4372-4b1e-1677-08d751af1fd2
x-ms-traffictypediagnostic: MN2PR15MB3200:
x-microsoft-antispam-prvs: <MN2PR15MB3200CBCB218C6786F9912248D5930@MN2PR15MB3200.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(366004)(136003)(376002)(396003)(189003)(199004)(386003)(6506007)(4326008)(4744005)(14454004)(256004)(102836004)(25786009)(478600001)(71200400001)(52116002)(1076003)(66476007)(76176011)(66446008)(66946007)(305945005)(64756008)(66556008)(99286004)(54906003)(229853002)(7736002)(6916009)(86362001)(9686003)(6512007)(11346002)(6436002)(6116002)(46003)(2906002)(186003)(486006)(476003)(6246003)(71190400001)(6486002)(8936002)(5660300002)(81166006)(81156014)(8676002)(316002)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3200;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: blwPvgXENbds19ZDqIrc7hosxHRwoFsuOAmCqT6cz1hLSUGR6NteSoyiLHbxM9zjfbGrhyQtXyTbjdXwK81gvkyzJq3csCmxULGcUsjM4rJnoZShhPuYkN8pI926zJ3S+gXNOHXG+PyNdrJpg19QSvZxXiO/thWHV37GFI57zSWaZSwJPScxlgpEHrrMaYuJ0yYubBri/jhX1cS3oxjbDT7KVl6vwKEjAOprq7cSPdsdA3cwbs8GCnyutnQ6n+mExSptM/KcNg2e3umCj7zn18sEvb9nu0UHkg6r9eyzZViisd3pXlUaYqZ3Ey6Yo+NIH47BAsy6gBIVWZMJGF27q0vvTqAAOyFYvPPqK9p0AqhmG8P/KdkvHrw47WmpTbMzw6s20OLkUgvnZMHoqVHuRt8SViYNbXOzNyyKrCVarpE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9F40777E9FE8B44BE927DD7412C632E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c38375a6-4372-4b1e-1677-08d751af1fd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 20:34:49.3402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1OftrSGvo0oLVWzUCRu+Fb4NoANTH3sVw8gTkR0b7tvIELmlexwFyFHkwfMPrNQ/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_06:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 mlxlogscore=833 priorityscore=1501 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910150175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 11:31:24AM -0700, Stanislav Fomichev wrote:
> It's useful for implementing EDT related tests (set tstamp, run the
> test, see how the tstamp is changed or observe some other parameter).
>=20
> Note that bpf_ktime_get_ns() helper is using monotonic clock, so for
> the BPF programs that compare tstamp against it, tstamp should be
> derived from clock_gettime(CLOCK_MONOTONIC, ...).
Please provide a cover letter next time.  It makes ack-all possible.

Acked-by: Martin KaFai Lau <kafai@fb.com>
