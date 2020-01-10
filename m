Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCD01373E9
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 17:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgAJQnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 11:43:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31048 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728500AbgAJQnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 11:43:52 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00AGcMCC006241;
        Fri, 10 Jan 2020 08:43:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=o1xYxfd0dG0e83Rgq36t0TKv8/MPPtFj6WE0qHORQgY=;
 b=cIcbuRIDLNrDWeIdDwr+6Hi7pEy5A/T4g7y6eCE9wsIqCa/9oqRTqGa3WfXBJT8vcAtj
 pkxyMsd8V2GHjuh8fmxBRXd9Mp8lbmBxNA/dsLWQB/knr7oc/VgxJ8jZpdqovmA5WqP5
 iTCa2Qv9p+pYfTi7GP/gDBuyS5y5nPfLdkU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2xenyt28bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Jan 2020 08:43:36 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 10 Jan 2020 08:43:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcVxZVLNN5DF5q4bujOaMu4JvC9veqb5tuxHAKRwytJAAbSvfXWCvx3OAfl7t9asulWfNq82DfVZhViYrCfuxJKXm0XTGBKGYyO/81VqXiM/kFjHgazh0RrVL3D1nFU3o/kzP8wqDPcDu9Ad0RuR83/nOGzN2G8nSwni64D9XaBFKvpKiRdOrDJ6hItbYiKDJ87sVxWieUkh40WnbIpsRYnX6gVkY0XVZ2pv/4pFsdrzhNhos45CzaMY3/J0A3LDs0jm1rUm8hLhQfhssJ62oquFngEvWPfhHdvooluuQzLDqIInppUpkre7PeiCnZtir6kWKNp5Fbnsp1aZ0ayNKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1xYxfd0dG0e83Rgq36t0TKv8/MPPtFj6WE0qHORQgY=;
 b=nxXx7XidlcSmJD9nOTKb+iSe6/2Nxa86b6f5eV8122dc3J+ZJOZj5V08/mR1NAbeDArZQSd5aGFcRAnlk23s3BjdA49J3rCHb98wRl/oAeuMls5g1PkLzOE9fWcK+Uz3u2fi4vfol261NH3eH4d9jd0D0f3dPO4/Zy0Jow3pLB0bIs09coJP+icAUj1kc3gIrCjp+n1UIMvot2oI8A1EC32D6lxBF0UqYPy9cLl1BijtvxFUju+dtX8ngtvaWDi3d84VjGBE4QuKCIMpnIst9s89YgrAA7pPfc5n7J52anB7rq7M9nbR7ivHEKoREfwCS4ugN43Hv0nlf6Vr3ZmawA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1xYxfd0dG0e83Rgq36t0TKv8/MPPtFj6WE0qHORQgY=;
 b=aLKMI/g3jzXE25vSQJJ1cJssxVyiQqs6dag91tUhOHr1qpUktImM7jqbFJ6WcRyBaOZixrnkXKHXf/MfNAXBzxRZzxJPfwEJPM8oVVNcIDiyBMbhhhE/xK6ELDvIKEeL6v9BO5dq80jlveqzvS60V8drr4dU+m/ASJRhsLpcy9E=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2525.namprd15.prod.outlook.com (20.179.146.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 16:43:34 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.011; Fri, 10 Jan 2020
 16:43:34 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::3:1c91) by CO2PR04CA0002.namprd04.prod.outlook.com (2603:10b6:102:1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend Transport; Fri, 10 Jan 2020 16:43:31 +0000
From:   Martin Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Joe Stringer <joe@isovalent.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf v2] net: bpf: don't leak time wait and request sockets
Thread-Topic: [PATCH bpf v2] net: bpf: don't leak time wait and request
 sockets
Thread-Index: AQHVx7l9Y1n5XH7dBkG8DtIR/ncd4KfkGrgA
Date:   Fri, 10 Jan 2020 16:43:32 +0000
Message-ID: <20200110164328.aosamgjk5hfw7r7d@kafai-mbp.dhcp.thefacebook.com>
References: <20200109115749.12283-1-lmb@cloudflare.com>
 <20200110132336.26099-1-lmb@cloudflare.com>
In-Reply-To: <20200110132336.26099-1-lmb@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:102:1::12) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:1c91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e6952c5-1bf8-4f0e-7a11-08d795ec3a97
x-ms-traffictypediagnostic: MN2PR15MB2525:
x-microsoft-antispam-prvs: <MN2PR15MB2525D8E553A2DD517D061830D5380@MN2PR15MB2525.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(39860400002)(346002)(376002)(199004)(189003)(186003)(86362001)(52116002)(16526019)(4744005)(2906002)(7696005)(5660300002)(8936002)(316002)(55016002)(1076003)(478600001)(66946007)(8676002)(66476007)(66446008)(54906003)(71200400001)(9686003)(4326008)(6916009)(81166006)(6506007)(66556008)(81156014)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2525;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XqHvqAZpsr6LcgmehUmu6sFRIrLwAw7lJNHtT7jRBshQaRe/rOwtNTxIFPEl1gaVDISxtY0sEyMIFYqT3YPGB7df0TqlqwBvxLJoo8VtdXVA8yHa17jhR2S6cpB/taROUIXLJhx5GqsDanZ3iTzgvyl1jmPsrXtpm/CbAOjGuT4vadqxU/MS2IKChW7Gd5V3nAulI0I/wG2UxfPsLf7FMnkytXoL7lWArOZ4hTLygsCLAsDPkNw4vX/vURsQFcnfw2wVFARf9srBkVFbslmTgmNWdbrqxTqRS8tCxMIUjONR7k3PMuHiug7ecYMpyJtETEZ5hQR6PTvZcBfWdCrICNFSDFjM+F3+p1xp15h+Yrhm/gOLcU4anALnVcEui5lrGog/acpJ7uTc/RUMprTtC1kdjCDNHup10vnnXcfeUD2plPlvQJOZmKagV/EZk/PF
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <14142DC13E473641B35938A3DD763512@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e6952c5-1bf8-4f0e-7a11-08d795ec3a97
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 16:43:32.6029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CBeNMzfr0YFSaGt8AleV5q4/i8K86wv/aNf2IIn1u0DECH567GnfbuuqSK4LaGqh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2525
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=480 spamscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001100138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 01:23:36PM +0000, Lorenz Bauer wrote:
> It's possible to leak time wait and request sockets via the following
> BPF pseudo code:
> =A0
>   sk =3D bpf_skc_lookup_tcp(...)
>   if (sk)
>     bpf_sk_release(sk)
>=20
> If sk->sk_state is TCP_NEW_SYN_RECV or TCP_TIME_WAIT the refcount taken
> by bpf_skc_lookup_tcp is not undone by bpf_sk_release. This is because
> sk_flags is re-used for other data in both kinds of sockets. The check
>=20
>   !sock_flag(sk, SOCK_RCU_FREE)
>=20
> therefore returns a bogus result. Check that sk_flags is valid by calling
> sk_fullsock. Skip checking SOCK_RCU_FREE if we already know that sk is
> not a full socket.
Acked-by: Martin KaFai Lau <kafai@fb.com>
