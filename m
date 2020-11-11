Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E6F2AE54B
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732475AbgKKBFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:05:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51764 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727275AbgKKBFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 20:05:47 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB0ml4K004752;
        Tue, 10 Nov 2020 17:05:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8t4tps61ndG+dgKwK5vAAQ4K0ctTtlAF8SAj6bNQffk=;
 b=WNhT/qIbBqIfG+Jl9hPuL4XTiqWiO5rVthXXHtyjafkMQRyVBVfZylfsUE0HyOVqbuh0
 YkJVwmGPo+21JA29BfJRaQFlEjJ/kRTpa8qKfs48jmiElKoGy5Sa+WvanNVIfZ8eb9/8
 t8lFbEfiIWeH48b5lqlu7t4yYPtWI9rP35k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34r2au94kw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Nov 2020 17:05:27 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 17:04:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGtp3uXfLUax0oEU3krbhGkqckoBrRK3tQkpZOdAuqI0nHqxzEEYEIGjL+Q0Is/O1Nlq22ExWWrhnh6x+k6z51u5hQqiaHhMHZ0yAEJDUAy74uN5s0L/0r+seruEIvSt7ctbNp4+h/RYyevmneYjc+1xq8IhZfDB10MISXojEFmnOaTBWLL3oHtO+5TCyrUVpRI/1poKN4Od00QROYoSU/OCG3uHb9p6V+Dku4zLu2VmRpc1XgvrUrhQ8gaRaVLDpo/fTpGluhi+qaGj6zxFLHf5JmFL+EzUdTmdTUJT7huq4hHcsQCPTlJvVBukBUSZ3hTY6tVhp/KJ9ehqzIqOWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8t4tps61ndG+dgKwK5vAAQ4K0ctTtlAF8SAj6bNQffk=;
 b=glyDuZlGucO9R5WTDLugd4jbziWbnJuDkNZJypUYgUceMvBQfqmvJq0iWnzPIwWFEex7h2bZZ3/CLQ6HYmCVDNH06+wRyAhNecguSP4OjEiXux10ujH8KSwSeVM5K8WTtHuGHGpzomKU3ecBr9Th5L3BlJQmaGrbTZ+/41jKJOqHKk7jEK0vQv564h9Lz+Tou7K36imJYl/FCqlDsY9xxzYIXXUWO+1ZWjArJFoU0PeSAyKKLc4gtaCdH+b2odnhCCFB9zhjZmmO+es4j/SWV2FJG3YYDrFOl7QYrfziHWR5gWbXoyC1OrGwQzvydQVH6RTHQhN5qHzeVrdK15SabA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8t4tps61ndG+dgKwK5vAAQ4K0ctTtlAF8SAj6bNQffk=;
 b=eTjkiJHWfscENw2R2BPdYxYPjoNqEg95cz29Ryw4ZHb7IuEgS/OSm4LqmhV94JcLL+dp7OhKVcBiD9Vckxc98cUAkXumUraWRsM5+OmudapAXVy0P5yHTDIOji9tz0+nDp+w6Y5PYvgljxoSAtcmGSofgnFZcLihiFXotcIPkdc=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3047.namprd15.prod.outlook.com (2603:10b6:a03:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Wed, 11 Nov
 2020 01:04:53 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 01:04:53 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF
 is enabled and pahole supports it
Thread-Topic: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF
 is enabled and pahole supports it
Thread-Index: AQHWtwBl0rtpue6+O0iiiyvLLCxW2anCH1EA
Date:   Wed, 11 Nov 2020 01:04:53 +0000
Message-ID: <B51AA745-00B6-4F2A-A7F0-461E845C8414@fb.com>
References: <20201110011932.3201430-1-andrii@kernel.org>
 <20201110011932.3201430-4-andrii@kernel.org>
In-Reply-To: <20201110011932.3201430-4-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1f7d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a32ac7cf-8e1b-415a-a893-08d885ddcc45
x-ms-traffictypediagnostic: BYAPR15MB3047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3047AA238D556F86F6FF6F96B3E80@BYAPR15MB3047.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:118;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YXOOZE1ao8Eb50jh7qbD+6mVH3lYmZdPCtvhI2jMwGWYlGnDV65clTdf6/mXu5S+2YWeUuZw1kVZJ74JxGDrCyK7J3kSpK7DecXNtmwmRL6sbRsBd/naveF4ICnoq1hO7kUZnb1CZW6bYEFQ2yS77Gn7qo/kmwgDj4zA/lzBLZzGA38H1qYPNAOJxR5eR+PT2Lh7/lT/Jsi2w3s0u58OQwz6o3cJyoqhiKWP+8yuld/OrfHfyRuRmGYU9QUV7cGhsV+FLgOUeEDFGMVGsPxPd3vWI4xQHMxMZnv4uJHwf+8ctZrjI6djLdJ7kZqGXSDX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(366004)(39860400002)(6916009)(7416002)(36756003)(186003)(2616005)(53546011)(2906002)(33656002)(71200400001)(66446008)(478600001)(54906003)(6512007)(5660300002)(86362001)(66476007)(64756008)(76116006)(8936002)(6506007)(316002)(91956017)(4326008)(66556008)(8676002)(6486002)(4744005)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ds6BQpmWqN6/27K23wcQrON3e6QJYLNerXUi40DY00PSUgli1aC+XtSmRf50l5U5WjrE2URMqMJM1+tWrVLDsD3nVf+HjKRSAZ0R+TA//0NEWXPFiqDeilcsVUfk7+XSUH+cSmUZbeGGJb5sVoKeCdp5p/97t4Gh7kjvJS3jm2gzaaZGSNeHuPTqA1Yq2QKkqY3ONpo+IFQHmwhd1l2DKGP3Uw04C8eTHUpjoscdibUb1bqGwOVwdOn/2cIlYdFivLh07voCnIG29SKAmXi3XIgJL7+EaOyFnjkmii+h2/6FOhy0vW7B8GMUuQliT5UcBZSAbbCnIq7P1Cr5lN7rLyVMvKC5bfqU8l/4f46DKx3oLXDobCYK9zLGrl9pYcFmTpyVh68Sl2p18vKY4slrGbnfa5ePVtRTAjvyRsW1k7nyv7yJd9UemOGq3GHfwOAFoSApNFoc65lcz+EgSm2yaobIBaqg4neKPp7fKFGhheM/ozBhwOugHe+5YdCef7JUE3GPNIkhpZI2LID38OprKFdjdp0vkT6bQmpHz1sFG22pqDbQFxwmSB1gDUge7t0/pCMpCQ3zMT80kwFc0BkxhqM9ODbexrkKeSadxACSEwq7LsT9sRNIy2zI/iihD92DLEz6kDZ1XbhkP+BS2h566+ggf+XlDWA24hf/JcjYHj2xSkLtDIQK6TC3T1IVvnvhSSbL1ByFMjcpZuh14HRg/SWM3zJQQK6VG2kUNkKimcSETN7MxE9y0/CJ3NNdP/DCcEblxYGZGapubYvkqqBYve7XuUWPKkdq+I2/RTqDx4mrVulX8YSdnHsAkB77TU2YpDUlrpwKpMZS1FdtC0Z16wrqbK4aCRk4jzdmis/FtD5bY+8AZ9/emo+rFT7rLPUnY0REyvjxTBxvqnrProK0fB4Gqf76IHRBGqc8TTVdXgU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF973C7D635A1A43AC567AA503D2F36A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a32ac7cf-8e1b-415a-a893-08d885ddcc45
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 01:04:53.3779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6qynP8IRSmmaXrlpI9vHVYGPmBKFt9NkcXlD4apc3lf8asD3DLqDFE2PHEbtXCHnLHIuws01PH3ZA9tyjVZtMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3047
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_09:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 9, 2020, at 5:19 PM, Andrii Nakryiko <andrii@kernel.org> wrote:

[...]

> SPLIT BTF
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> $ for f in $(find . -name '*.ko'); do size -A -d $f | grep BTF | awk '{pr=
int $2}'; done | awk '{ s +=3D $1 } END { print s }'
> 5194047
>=20
> $ for f in $(find . -name '*.ko'); do printf "%s %d\n" $f $(size -A -d $f=
 | grep BTF | awk '{print $2}'); done | sort -nr -k2 | head -n10
> ./drivers/gpu/drm/i915/i915.ko 293206
> ./drivers/gpu/drm/radeon/radeon.ko 282103
> ./fs/xfs/xfs.ko 222150
> ./drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko 198503
> ./drivers/infiniband/hw/mlx5/mlx5_ib.ko 198356
> ./drivers/net/ethernet/broadcom/bnx2x/bnx2x.ko 113444
> ./fs/cifs/cifs.ko 109379
> ./arch/x86/kvm/kvm.ko 100225
> ./drivers/gpu/drm/drm.ko 94827
> ./drivers/infiniband/core/ib_core.ko 91188
>=20
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>=
