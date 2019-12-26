Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4149A12AF66
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 23:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLZWsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 17:48:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38854 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726277AbfLZWsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 17:48:03 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBQMjhps023797;
        Thu, 26 Dec 2019 14:47:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Ep1iHOx3Kvez7nzo857YWPq1a25Uz6KE7On7aD97I84=;
 b=aVMqTsfwsrZBskuV6fQSaE1eQl8JZQ8yHKq4lNPXOGRpqFznqcTTKaJhH8bXH68IasWN
 zIqJ+z0+IAy83N+9LVhmEP4pDHVONY6IZ0GJqsuZ/yGkmihHNF8H0ESX8x3qJ/l1MKeg
 XqycpxxeTRLJRHY8p+bp4O2YM+GNsobngRQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2x50yu11hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Dec 2019 14:47:48 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 26 Dec 2019 14:47:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDwghdn/4CQSFEY9CDn8Mud/h/GLZGx+L4sHKEJTUcHdmMg0AX0UOzuSYIsfX4c426MI5hqRNzP/YCcP1ZgV+X5pLUET5A2tZvWp3LdUEM5x5N7AHEAnsdU/GH/tgJit0ChRy8TC6k3OSZFTUzeiyC3XknachEnVyfcqfDgEJjSQ5h5zpj9UdQxj+1+8KieahOzFA4fT/y4MdVLtcwNjU2CRTIFxzlp5IPNd7nJStqHGMsqX7UIaArOLwTWeBnR3mOBxWbsxWL8y/CzKfWL2MWLkiAv1zJngoaNVp6+4r6wLPBclBFl1SNbiRCaIh3Nlev0lv4ourXmKBJ9KlttWFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ep1iHOx3Kvez7nzo857YWPq1a25Uz6KE7On7aD97I84=;
 b=fgrIAhXeWC2O4Mgb/cCoj2NsXgTAmEpjCbqthv0wpBV2pvYbGAuXDfb9bqLnTHhuyM6XwU7GDRgldkV9n39v+rjhQlA/UpS0dPzxS+OpLwrAOJiGo00hE0BH29E9AXYSz9/mu33DlqJkjZlhYbHFs6NyeELE9/Vf61Ge5BxtCGeMoFIITyihAjABDrB9R11IHKmg6zjEQCXo4BxEBH9W/jdEPujbTuf+brtbOwbqBeSgdz8D7w/U/YSQu6dXuNa6OG3fZJjgtl001tWoquWj9nhgW0YdVpcA6pCPE28pM3xjmxtmUdJFLEb0eaR50QnBfe/Mt6DAHIwHwGq4wKKs+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ep1iHOx3Kvez7nzo857YWPq1a25Uz6KE7On7aD97I84=;
 b=cvn/hl1LiUnzBbANwJ2dqBO5yb7riJMIlN9Ua/UHc9QlrfmotDdcaEBRRvLUuV2wCLtjQCOemmChWaWLGKcz89tDCzzHyb1RqRROedTj9wHS9KeeZzTmVmDS2fUK/2mTlDEQXQ/N5ObEvvF5hsC6kkLN17XjurC0UivCU7RKT/0=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2528.namprd15.prod.outlook.com (20.179.146.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Thu, 26 Dec 2019 22:47:40 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Thu, 26 Dec 2019
 22:47:40 +0000
Received: from kafai-mbp (2620:10d:c090:180::a2c3) by CO2PR18CA0049.namprd18.prod.outlook.com (2603:10b6:104:2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Thu, 26 Dec 2019 22:47:39 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 10/11] bpf: libbpf: Add STRUCT_OPS support
Thread-Topic: [PATCH bpf-next v2 10/11] bpf: libbpf: Add STRUCT_OPS support
Thread-Index: AQHVt8eUp0GELJabT0Ky3SXmWIsfAKfIJfWAgATnaoA=
Date:   Thu, 26 Dec 2019 22:47:40 +0000
Message-ID: <20191226224735.7q3ry3k6avxftpxv@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062617.1183905-1-kafai@fb.com>
 <CAEf4BzY5wopSFj2B2_Q9VtNGoGtzyZ7MOUv1oDugCXma1kk3UA@mail.gmail.com>
In-Reply-To: <CAEf4BzY5wopSFj2B2_Q9VtNGoGtzyZ7MOUv1oDugCXma1kk3UA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0049.namprd18.prod.outlook.com
 (2603:10b6:104:2::17) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a2c3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b177a816-2817-46a0-a1bc-08d78a559cc2
x-ms-traffictypediagnostic: MN2PR15MB2528:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB252854FA1BBAAE3653E9E098D52B0@MN2PR15MB2528.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02638D901B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(136003)(396003)(366004)(199004)(189003)(6666004)(8936002)(2906002)(54906003)(71200400001)(66476007)(186003)(16526019)(8676002)(478600001)(86362001)(81156014)(316002)(81166006)(55016002)(6496006)(1076003)(66556008)(64756008)(66946007)(66446008)(9686003)(5660300002)(4326008)(4744005)(6916009)(52116002)(33716001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2528;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3i8Ji+zrLKLqZxmmODnFbDlP/IW/LIe4K1V05s/hnTd/+JnzcENHBvRC2IVfbPbNsOcT9O5EDHUzwliInmT3akQLvwlFal82NY/yEyaZ5+R+VldtuCUKu0hYqzNIX7gjgxJQtinSWrAHbGM+NCxKnBWOg/NEVZnbkXlKBq/H8M99cwA1STDxzRnjkutSTJJB8FroUU4tkiQ13pbOA2kFSLSrgbANKp21MubK0J/ox/YiCQFANS4xxrF5gxh6MJZoDNI9CEO4qw+l2bGXsgMx3j5IrvhkoPhINb+ZjkAxSgDCaPrErbqybNu7lqgMMmmpzfFmPAVhld4UkvcfaGhwTz4AheTVURaFNhNkQYoy0E34FbhA7scBS0y1gOWJDdLjxz6jo/A3kFscuoqba+AgBkjQZf5lpZZ2Vs2KqZURIqw85eUE1FkxNQxxw2+dlg8U
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8A6C74F39D2B8D499076CC4CF39EB33B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b177a816-2817-46a0-a1bc-08d78a559cc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Dec 2019 22:47:40.5037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n41gfL6S4hicMLMlDlcZJzu7AE/Gr67AWWD+zPA5HU31LdNJ8WIvgL8qEIHz4m6v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2528
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-26_05:2019-12-24,2019-12-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=890 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912260201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 11:54:17AM -0800, Andrii Nakryiko wrote:
> > -       for (i =3D 0; i < obj->nr_maps; i++)
> > +       for (i =3D 0; i < obj->nr_maps; i++) {
> >                 zclose(obj->maps[i].fd);
> > +               if (obj->maps[i].st_ops)
> > +                       zfree(&obj->maps[i].st_ops->kern_vdata);
>=20
> any specific reason to deallocate only kern_vdata? maybe just
> consolidate all the clean up in bpf_object__close instead?
I think it is the same as why the map fd is closed here.
kern_vdata is allocated at load time, so it seems more
logical to me to deallocate asap at unload time.
For example, if user calls bpf_object__load_xattr()
and one of the load steps fails, bpf_object__unload
(but not bpf_object__close) is called before returning.
