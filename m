Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA252B9FC6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgKTBdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:33:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54122 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727086AbgKTBdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:33:44 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK1JEQA011019;
        Thu, 19 Nov 2020 17:33:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7ecTIH1CpCG0Pyp5YVcSEQvYxXRZ4WamPLbLSpJUBks=;
 b=GaQccL0tt7A60Gu0UfRKBhHViC0yDy1JbyQJxPpidDZOhnD4o3HcoKTpaNl6v4pGsFWk
 6vs7Hi0JqZkhrE0CWgtZtBziacArmgVmucbdBDIrpaRL8ayaJHGd96SpjwYTPeIdilW1
 ofxAFedxnggWi7oKGgNvid5vWAQAGQux/Kc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wbepu26x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 17:33:27 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 17:33:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zm5Ls8BSYjVlS0+pPIvkj8IDRYkyptzDdYwX4h/w74xVdVAiqrx0Ggg7b33kK6/ZU6tJUiHiOcVznCRsS6Kw4ENM5b05+++CY9/v2Cf/u//aGGubO43Uzd7YeBcyPEMnXP0g4VI0GrpElLgtxpzdvdpStBnZ2Rum9N2urXUIz327ePWTyXzfGQuoXDYpK4X5l1OJN7R9GKKj7UMpFL8tjrAQ3a2LDo3zTRxypyT47b02J0jAaJLpQfYAc7IM0ldjk0Ma1QBvaaLy2DAZ4aUtDcU2NLdMW5gj6ZlTEFed4OnroXj89grIj3i75LHze2yFAISZMwyk8Zr4Y7NPK52D3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ecTIH1CpCG0Pyp5YVcSEQvYxXRZ4WamPLbLSpJUBks=;
 b=WmxD+2RECViWkL/GN3zlQ3kLv0LlXAiFWWiuJtr1w0S+Ypes3p7HQ0WPZeHMk8JHGOfjhKouuRKbbb5bshfwe7wwNNtV2dAA2xZjsTsljQwEngK6gtcM60VfdoPXf5O3pxLwmgUGdkx8oZS80rYO+yDzXNZqNHYo61+xM2gP/h6y/CyQNzWn4KULH/lqjwAVrAVP7yvcOdmqoAZIIW5XDOmnqUvkGvLdNq3NZKTRNzG9jGY1VmtSuRFd95ZyH7E7VUaEf8f0V4iouvPRlgmAPrtpdySjeT2WVEkN0/DR+cP6joj243QyvNrh1KUt8vpGmBwguCsvMpp1Bp+96D7+GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ecTIH1CpCG0Pyp5YVcSEQvYxXRZ4WamPLbLSpJUBks=;
 b=FGKcJaXT6zB/sNvN+TgFCCmJfOWzbVw52al8EcmdZXmLeukoK84Nlan/NgPkEAsb9e9TCeACNbiXDfmV0jCJouIQN4mkUG5OotZ6ij84qgyyZu7oFYzi3ecHo+8tw4m2hImf/MGkP1YnZHDz+cleKSWvGACAwPHllAbUE8ljZLs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB4118.namprd15.prod.outlook.com (2603:10b6:a02:bf::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Fri, 20 Nov
 2020 01:33:23 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 01:33:22 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v7 09/34] bpf: refine memcg-based memory
 accounting for cpumap maps
Thread-Topic: [PATCH bpf-next v7 09/34] bpf: refine memcg-based memory
 accounting for cpumap maps
Thread-Index: AQHWvprVcDrfb3rXkUufXd+Cb3ra/anQPQ4A
Date:   Fri, 20 Nov 2020 01:33:22 +0000
Message-ID: <B7CE40F7-90EB-466B-AD5F-566772B51D31@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-10-guro@fb.com>
In-Reply-To: <20201119173754.4125257-10-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f2e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a66021e9-ade7-4f50-517a-08d88cf444f7
x-ms-traffictypediagnostic: BYAPR15MB4118:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB4118EDE5D9E114BA2BF29D76B3FF0@BYAPR15MB4118.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 224ovU5vyC26qDq4CmDS59k488AXEtESQ+DkHZWTbyAwjPt4aVGAsqkjOR88Czt1NmZ5ULom9DdRmNVBw7vRa0cg2/bhEp2wy9xf/hAj5WR/Z8Vlsh4dS3Alrs+mELEo5POrqDF3eJaYbdS0da7uR3MSElyV8/4iCkFJ0PTvE3tSztmZOvKHZEcUeUv7P9agFSKWZv9cCJN6cn7fugwsZK1Zc3Yg0QwG5R5pVYI5z6WgK4g5dipPeUZnmnkBHe4CJkHNBr615eZtvY2JI+d6K7J6LGVNhB0nNn6xRKICeSTTixa8V+ScI+ERhYp981mPydsdQ1clMFzodE/pdgkV1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(366004)(39860400002)(8936002)(2616005)(4326008)(6512007)(6506007)(8676002)(5660300002)(478600001)(33656002)(66946007)(53546011)(66446008)(91956017)(66556008)(86362001)(66476007)(64756008)(36756003)(76116006)(2906002)(4744005)(83380400001)(71200400001)(37006003)(6862004)(186003)(54906003)(15650500001)(316002)(6636002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xZf0rwuuEKp0GD2joxa9O5VUMP2NKRE+lKSSUGe8sLIYqNvqAJsgM30zNvM57m04VqbjArZGcBpx+ypcjhGG+tdd6VEjx/6RfGvjTZTEYdC8Fi26j3T3PW+sIjncJvep5xMD7b7Bjx/ClayQnlmS+BlBPkSFOJ29A6OyQg/ESXx8vj1f/yY6nCkK7YIsd42PA7u4XYmf/bk3MFreEgx9XgDnGT3HD1JReO48fSwiIK0rrnw0Ss58OdUc5ljf0k/TRRvsrobq3wV0/G7h9RuPjyNL22tXIs8z0ZbJRv9QOKKI4ExDhSb2wy35cR/22TcOqUWDOprRnuZlHVqr0hiJdU+AFfl2nYV6oLXj5L/WCyDe6bMydjqsn0neNGwXzSjlevrSlRo9s8QsDr4BWtR6B8B1RFtZGVtsSV0lr/84eX0wQHR1c/4t/Uht80CDj2xwxdQufwoA9KkSs8NORYZ0rcvx5SwhDM2ED6+r9/VMT10Wf52TYwy3rC6ZZNpqJ9M2G7QFash8+CkYV6DFOaq9HdnK4KToIpXJ5HUq5kAPWTDtsCIp10uuwxyQMO69Yfa8kxlADMyawAd1yYZg3DMpG5iJ7sGIN9d53G7Opev7QRCwIaefqn0+ZGiQUCupW/C6hbY1w0wCU54C9b7GRJR8VILQTZ+RhnAIxChTqTDpwUX0ILOnRgJzMVU6dRPsGax+zyqTz+qE0mqzezCXJttBG7DdfbY9lCGcaFNkaXsGmKLz9XyL9xhoCm3udf+7+Lkhj9hu6I/LbQIhzo2jhKzqltspKOtHmSVuNRbIpPp2V0CKuF/yPRROoDutEwvXxL2/9N1DZNBIOqc/uWP+ditydpk+GC17stcxmgP1SgZ8OjTAxhN54HeB1MqahtYI66OASDrxbe8h/ynaTiHEQq68LVpDrAC/6rasiVFjPbK2Lfs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29B9ADD0A0591A45BE2DB3483729DCBA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a66021e9-ade7-4f50-517a-08d88cf444f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 01:33:22.8923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /KqAzuXxzXYEcn67PnV1FyTgTo+A7FfodFwZynrz2lTkBnVLYNFG5KwYFlRDA+l7G+OqsibaI45gMogcGDrw3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4118
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=838
 adultscore=0 phishscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200009
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 19, 2020, at 9:37 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Include metadata and percpu data into the memcg-based memory
> accounting. Switch allocations made from an update path to
> new bpf_map_* allocation helpers to make the accounting work
> properly from an interrupt context.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

