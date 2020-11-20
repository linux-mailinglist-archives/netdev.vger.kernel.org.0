Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404E12B9FF1
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgKTBqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:46:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65034 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726674AbgKTBqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:46:20 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK1k3Gi024537;
        Thu, 19 Nov 2020 17:46:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HBhsQJjkkhUxBItPwCwN6JO7EvNcZMRAeIfyt5p9FmE=;
 b=N8WQi0ZHSiuQAYXf+XRcfBmLBioWzbSkIF4dt8wWO1jd9xXCWx9AaMRdhiX2neSQzkgS
 JOPWhYGtACZv/A3qMMVzMWZZ8vASelq5qp/r5Rn16LZjl+iurDn+GdZqhAAd+3hSzQom
 v8CABXl4v8FxJaNaWzM6HeOeC5ML484sb38= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wjmxfex2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 17:46:04 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 17:45:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kpny7ZC4qsoZ/sN65ZxUazHL6ADULfl1pOhM2eq6UV0LSaQPp+6bKRCmgn4ohPcsnakrIsdfVTFgeF2SQJFGG+T1TWZ+V+e4Jv/fNJWM66qyDfKczJPdupRXgc5vtepsHXGcWUVKKv86/cFJUIk+GzsD+nFl1IhiE2sT4yZpdgmbbLURO0pb/xqgBWRdc1pbF/Oyg3rQSQSMETRhCb9emcUE9KCpvSUKu/U7X8Ti7a41Cu6qktC33efFfek/w6i3ozSiMsjc0mDz05k1mXr1dy8ci1LnFxSQGgjwYJc3tjy1OaUs2KLEZr6YqOZzas1G8+yXlDfxufTzZKIJhWhMew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBhsQJjkkhUxBItPwCwN6JO7EvNcZMRAeIfyt5p9FmE=;
 b=LeJP9hMaIcqjBmmrwzyRm0BA1QwrKgclUEyMOeIH/QCz3s9n1S5C1VmYR0QVbjfh21wt3J7vime0eo7zXnV9S3O7JrvlKh5Whm31HqW7aRNU1RxNxvzawV8EE2oCOOv6rdF6Fh1HeuKurxPLHOwc0bDC3oXRW0gquePBvpxe2TCO4bOoSOkAUR2W/uiMn6gRJ/Djn9FWQ5Y8uw1LL0CcdU2plGTEliBJm73jY0EhAawT0zHp7iPBHAy8WbiHUTfCVeL1W4VsGGHk38b/3VePOPVRgAQz4OqVj17MyVbsXq2OOqp1RxkCsr8yYQ0p8V+pW2Raknezb3nEn+9GMwaBcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBhsQJjkkhUxBItPwCwN6JO7EvNcZMRAeIfyt5p9FmE=;
 b=BZqIy4GzerjI7T0eTUb7sNpnOEd5GFUBHZTcAkw8pj/xX3U6FXTWCTQfPJQ52gU2JsuSzx4jr8T06pUsgaS3TuJnkROU4Pfh72ImoyZa3ANYh+rY9qLAxOC0Uh6SqWjxokBDw2NSE0Bs1H3Yih8ZrjltahR6/Ff1Sx+y3uChCqQ=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2838.namprd15.prod.outlook.com (2603:10b6:a03:b4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Fri, 20 Nov
 2020 01:45:26 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 01:45:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Roman Gushchin <guro@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v7 16/34] bpf: refine memcg-based memory
 accounting for sockmap and sockhash maps
Thread-Topic: [PATCH bpf-next v7 16/34] bpf: refine memcg-based memory
 accounting for sockmap and sockhash maps
Thread-Index: AQHWvprWKWJMGOSLekm8nG3vnGVeE6nQQGyA
Date:   Fri, 20 Nov 2020 01:45:26 +0000
Message-ID: <316DAE42-F3D1-4854-A95F-C1E7B9D36B2B@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-17-guro@fb.com>
In-Reply-To: <20201119173754.4125257-17-guro@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c090:400::5:f2e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9d157e1-fa96-4f62-8063-08d88cf5f40d
x-ms-traffictypediagnostic: BYAPR15MB2838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB28387465220A5B1941D6A41CB3FF0@BYAPR15MB2838.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BKpBZ2kQha24npixpeO5+/Joq3FZgXNNWfXMJlHMS1yqQnOspZ+CIwVl3/nZHVj+Psslqvc81BURW7RT+N68yz1X6rTYb0Mn2bRVkIPq8W5HwoIlDzNSeY0cIgn04qHJxkjocbXubFxVjfw9vpTcQnRsiKQYJn6l/d03Q01t4hC69jvvT9iib5aymzSjuB7svJEu0d9/bFQq25XZOedKLgHEOPyufoi6BzXNNfiC31+bR0kG9dTQhOvmyVL+2TaG0ptu/BQeZbpSgVfn0wpD8JtVxIgEdkCtN2kJtF32Oo8WnKHLvcfseXZCAKkyrpNylpZiMse0GeNybT5DTUrrUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(136003)(366004)(5660300002)(2616005)(66446008)(33656002)(6512007)(4326008)(54906003)(64756008)(6862004)(76116006)(66476007)(316002)(6506007)(8676002)(37006003)(66946007)(558084003)(91956017)(71200400001)(6486002)(186003)(53546011)(8936002)(2906002)(83380400001)(15650500001)(36756003)(6636002)(66556008)(86362001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ZYB9oA8G+XUvfVwgq5+lV343/+Kl47sZDEIVyQdNqVE/yQmoJfEIVpMNUUFZQXlsSgaU5AH0sl95I5PCG5f4S1a03jY9HM3hz80EOJaP3g3ie1eeh3KAzLV0Ze2hUc6dwmAaHLWgZTI8UAZLzhF6Q0/BgpBqqm7KI3mMrYq2kKWSWgpMUMGU+USKPaWExBIjjw9tQyBZUMQ9cdn5AhpeBWNtNdOxlVk0g6m0ppMFy/ZN/oT8eP6w8Ywz/WvtPCOWmaXDHMzn8JlNeWEoMsfH7DmbnsedgXU3AwSH9PI1dNPDQHuZSIN9A8ghNY68oRkfNeuueJdqP4aKyj9PS8NbhaUh2VWlfD8uPIL2VCpkLnH/8U4O1yrXaZNX3PvbFSU1wdQWqUC6tObAFY+LLx+8T+qe8sdAyRAbtd2pXGYDMnEOT4/lBYR3A0hqgHCuEHYyHLb2zdJoL687/5QqP4kT73d5PupgUlbSZMsXq0MPmCkOKrUpnVe8jDCfZN/OpKIbuDsqIEd+yCP1L4wYU6g5LmHYkqxCD9ITC5V+kqWe/hK0mAdCYPZtOKxxlEuFVTVxp7vVV9BxeQ9Bwg9zLb5cQTlv9o0a2AbQ27lYfoPtgQecDubmmQvvVTCoM3pLXIwMVG7Iqfd+qeFtrGSSRC61rKgtOiM1zoXLGO0nH+nZVhOdygnpkISdKCT/iUH/N0xb
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E404FE063BA8A40A598244A8DF13879@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d157e1-fa96-4f62-8063-08d88cf5f40d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 01:45:26.1707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LVer4+xzzEdERQ4bdxRuacHFQqTFZheB3pfXakUxLj+De4yFHa374jPUjT5h6O0AmI9Stcme+Mrzk6Vh3/My8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2838
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxlogscore=909 malwarescore=0 adultscore=0 clxscore=1015
 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 19, 2020, at 9:37 AM, Roman Gushchin <guro@fb.com> wrote:
>=20
> Include internal metadata into the memcg-based memory accounting.
> Also include the memory allocated on updating an element.
>=20
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

