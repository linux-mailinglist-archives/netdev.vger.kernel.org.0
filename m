Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F55E229D7F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbgGVQuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:50:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbgGVQuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:50:13 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MGmHJS007200;
        Wed, 22 Jul 2020 09:49:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=J3+xwDxPN77G/rViLHn7ZtFXMQahU6psfQPIvQFn5yc=;
 b=hxQyyKjIqBx4B3UXIl9DcPtuXI3RIMPMvdxqcEAwJpyu2J50k9by2/eIKZH0VAN0JP0i
 9g9MebwcWJtAmPm3V0xAY5IKHgOiuK05PfFG61F1A+ZeR+IUlHw9Yzs7/rMuF4Vu/d0n
 iKHZZI4vQgxuBs0c/BVAbMGk5ySS24UU5aU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32ch29fru2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jul 2020 09:49:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 09:49:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGF4wVBfW8pieR9J+bvQGVEZrBqjlWvFsx+smayDBaJNS06P1DiYtwl6rR6MMnS/8HnbDhAIsXJk1nJeNk78VqLJn44uvjogqsxUvAhEly3L4dbS9wgzOpLRfX1FyLh36xLs+cb+MABlJfpyKMt0h2dMd6RLGVV5Bam4sEGKB9ScDbiS4BTMrB8P/cGQcJkb9PLRqGEYPYUWcW9OeY6ksfi0/j5VUoMOH2seBy9VoRhu5K5YLCAVMtY9RkJsgDgFfZbUs7wa4FDKMkjMk3duvwU3Myu8Vt1H4AoroAoIQWuL4OpABnJPs98EBQr8mWymrVrp7CbkuP8MLGjWjAt55Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3+xwDxPN77G/rViLHn7ZtFXMQahU6psfQPIvQFn5yc=;
 b=P3Nu0JR0jKYzllOLPGmwVv5xyLj6AxO+hpMhk6KiM8wkawUItaM4kLH7FFjQCr41yBkRFvlyeVoJeoHMX3igGy3rcUbttlBIuBQpHUH8KiluFSGPN+TRoCUGDUGQNDGxy8Fh3XzCzHO+HTNRO5ae9FELQO7sIbi5f+YL50GiFWEyd5uU9+zkPkOLusb+VejE0CcI9EVeVmy5W2/on1eWqmjm17dM6FLZ7K3gPTkPWdZXheN5HZB10zLFFrj/g4KLF0obq7rZUwq5rfa39dBkh208ZXUagC80LByLLg+ta+GUwqo+vASC0Kcj/6do3dgnIVkAYdvErCAvLd7BUFie3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3+xwDxPN77G/rViLHn7ZtFXMQahU6psfQPIvQFn5yc=;
 b=CpXPexA5qwnn+50vKQUPguiZn6CMTB8mUbwcYi98Z/mKSUM4uAFKTloIne+6bNmJ2fW8qSmAeifofTqiW2+nzrCyzItXeXtZq4ogo9JdTaVWh4XbPOx2AKDPICpa4mDcuhIqpJzZiZRfPRlmmO/6zfMR8lqo4QhDGVl6sci8TcY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3618.namprd15.prod.outlook.com (2603:10b6:a03:1b0::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 22 Jul
 2020 16:49:47 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 16:49:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: separate bpf_get_[stack|stackid] for
 perf events BPF
Thread-Topic: [PATCH v3 bpf-next 1/2] bpf: separate bpf_get_[stack|stackid]
 for perf events BPF
Thread-Index: AQHWW8VAnRb4OqAgyEOVqqMnP7xn/akSbY+AgAA6uICAARzyAIAAE3IA
Date:   Wed, 22 Jul 2020 16:49:47 +0000
Message-ID: <1BF0973C-E2E5-49E3-B3F9-80FF7D6727B2@fb.com>
References: <20200716225933.196342-1-songliubraving@fb.com>
 <20200716225933.196342-2-songliubraving@fb.com>
 <20200721191009.5khr7blivtuv3qfj@ast-mbp.dhcp.thefacebook.com>
 <42DEE452-F411-4098-917B-11B23AC99F5F@fb.com>
 <20200722154010.GO10769@hirez.programming.kicks-ass.net>
In-Reply-To: <20200722154010.GO10769@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:974f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86c77395-e5d6-440a-2b3d-08d82e5f3e84
x-ms-traffictypediagnostic: BY5PR15MB3618:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3618B4E70F8757A308796D26B3790@BY5PR15MB3618.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wAUdgx69PZbSwX7Rheqb7DOByQsO4t2qdQdiZ+QuzCWkUiA32kvutXh9xL5hIaZPRmHbrhowzzt31gLm4iMGBAECypJzur+wfH906N8WAHSpho/RITmztSL2JddZTxbTP3qkp7nda8sCUx5ECudHiqmH91R25tW6MrDowpK7T15rWV+BAVnM5mpR+GRuRTIIgmV2uZ4CpNra4x63BMUynUczrpWzU4yBwX/qX9lLaoPHDHgCXBNGRc4MUvc3/3ynWm/5AC8bq453IgMR5YqgIFWVc91IWj5UcB0XUn3WT0R1iYHVgkF897YpI6avzq3V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(366004)(396003)(136003)(346002)(6512007)(4326008)(316002)(54906003)(53546011)(6916009)(6506007)(7416002)(71200400001)(2616005)(478600001)(5660300002)(33656002)(36756003)(83380400001)(8676002)(2906002)(8936002)(6486002)(186003)(76116006)(66476007)(4744005)(66446008)(64756008)(86362001)(66556008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AeQUrM11ZuFEWzYzceRspRkAxw/JWEc+Xs/80EGtAL4yc+VhYw02sVfox6oh1/FLaN8IWHZu54BoJnWvC9oa8o0OuICbe46OimNaM1Q32aOvBCT0NbJy3YObY0EcaQj/h4IZdqB7ETPhdamQeMBs920gxBPJVQOlcjz4OpECR02sxriF4sIxt1K5cLRF+aSe7MkWH/h1cCQ1TvQmol6JxhBXxJx6ZkRKft5Jd3LaX9mvQJ5rOSbch6/dUXMAgUOXoU6zEoGc4KK+CwxKqbptGxiRRU07jscH7m1ZAGq9DChWg5sxEHX9+r8/gM8H7rJuS+NemcbD+mMft8mk7rr28LCwM+VCvKiGUDXaW8zmrEgXAEECdvcEPKglJDs38ksPPtRzV+cDsSwJSNC8t44SLJLaAPw5LHc0BDq8JIDSmfRxlq081QsGpkqylAlotgHikArMwZFsjaWIwOEN/yjXyWNI/YMK3ualcEMkrMLeRrr5fa9AlOjB1v+seexhde+WwwDSqkzcxwEeR3Ge2tb+VA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BB5DB8B693F4B5438482C3F1564EB19E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86c77395-e5d6-440a-2b3d-08d82e5f3e84
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 16:49:47.7435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dSpKJGvFsavqFRwbEPWv4oy2CcYRA99eQE1MX7JvP7YTOKEOyMrcLrz6B3vGMC151dJxUtu9ImT81rrWzC91og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3618
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_10:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220111
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 22, 2020, at 8:40 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> On Tue, Jul 21, 2020 at 10:40:19PM +0000, Song Liu wrote:
>=20
>> We only need to block precise_ip >=3D 2. precise_ip =3D=3D 1 is OK.=20
>=20
> Uuuh, how? Anything PEBS would have the same problem. Sure, precise_ip
> =3D=3D 1 will not correct the IP, but the stack will not match regardless=
.
>=20
> You need IP,SP(,BP) to be a consistent set _AND_ have it match the
> current stack, PEBS simply cannot do that, because the regs get recorded
> (much) earlier than the PMI and the stack can have changed in the
> meantime.
>=20

By "OK", I meant unwinder will not report error (in my tests). For=20
accurate stack, we should do the same for precise_ip =3D=3D 1.=20

Thanks,
Song
