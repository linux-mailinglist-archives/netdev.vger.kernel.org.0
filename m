Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FCC2CF03
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfE1S4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:56:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53372 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726463AbfE1S4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:56:41 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4SIsHro023853;
        Tue, 28 May 2019 11:56:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ADzXdPObJkOAPNzVng/sbYIJk1d4fO/RIrIuSx4eGqQ=;
 b=D9U7qQG4aTXXDuMJQr/E3CgaHz79JyYlnNh7qgSk6yex6HGVttqyHgXnaz7/mB4KEfOI
 oBOM53oQo6B8G4XimZFOZBrspmk1mHGnu8H0RL+AmiYkXKsf5nQioRO1nBzjx2flg5F/
 bjtT9sGqMPaxHt7FbL0eoFvr8SNtxX0SHxc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2ssaeyg1sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 May 2019 11:56:18 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 28 May 2019 11:56:17 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 28 May 2019 11:56:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADzXdPObJkOAPNzVng/sbYIJk1d4fO/RIrIuSx4eGqQ=;
 b=tGz0qAOWKuau1JAkzm7hAlfDdsm8VywGItkKOrq93zlTUyFz6iOK+90BHYxbYPi8kbQozWgckU1yxq3CQ0nYes8mp8l4uPFkyrUjrOyKE6/gDOf5r6R7npK3J9lOMegbseIeto9jM8ApdrZMHkf2bmuR7CqWwqf5oZJBshld9tk=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB2581.namprd15.prod.outlook.com (20.179.155.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Tue, 28 May 2019 18:56:15 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 18:56:15 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v3 1/4] bpf: remove __rcu annotations from
 bpf_prog_array
Thread-Topic: [PATCH bpf-next v3 1/4] bpf: remove __rcu annotations from
 bpf_prog_array
Thread-Index: AQHVFYNmup+GUWu8Ukqw7FTqAmfZeaaA4wIA
Date:   Tue, 28 May 2019 18:56:15 +0000
Message-ID: <20190528185605.GA20578@tower.DHCP.thefacebook.com>
References: <20190528182946.3633-1-sdf@google.com>
In-Reply-To: <20190528182946.3633-1-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0090.namprd15.prod.outlook.com
 (2603:10b6:101:20::34) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3dca]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d09b454-305f-456d-19bb-08d6e39e2902
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2581;
x-ms-traffictypediagnostic: BYAPR15MB2581:
x-microsoft-antispam-prvs: <BYAPR15MB258139202B22F795AFF66CE5BE1E0@BYAPR15MB2581.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:125;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(396003)(136003)(39860400002)(199004)(189003)(99286004)(6512007)(9686003)(316002)(8676002)(73956011)(64756008)(386003)(71200400001)(71190400001)(6486002)(54906003)(66446008)(66556008)(66946007)(76176011)(478600001)(52116002)(6246003)(6506007)(8936002)(229853002)(81166006)(81156014)(66476007)(102836004)(305945005)(486006)(46003)(86362001)(476003)(11346002)(68736007)(446003)(1076003)(2906002)(6436002)(4326008)(53936002)(25786009)(256004)(6916009)(14444005)(14454004)(5660300002)(33656002)(186003)(7736002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2581;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Bx4Wp5fHGtp3pG9sy4qEmNrO81YgiXMXNRUtVmQHgfzkkjny4Ly801Hh+ZNvp4aBhnwqaCHQYb7K+OYmcnGuRbz2CDLCjj3jQpX3+l8YY1o11NEXsKrapPn8wrB/OtZzSvR5F6NuWEjUF03+/QoZ8KM7q5bQCc0n0YYc/l+D9Gz1CKDHxdJY8RRV4+enuQrtylomsH0hdJlqkgLe6AoFp/taBsBzbiqoilmHylN4PaMZkvn6d4FUcAqWT1JOAIZpgN28QGoDqJgWAZTTl/nnheobnmjbQNpGs2mEX4q+SamcTgMdWvfhcTE6vIrrOpDUG/QsL6KdgFZeqIWtitVyquieKmv2eB09Z9SxRbIf4bMXQkFVgA1yL8UgZOKo2RWQdVqgLMC8b/fD4kC9jf/rdLBL5Bdo4533F/3FFWTBWHg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <61ADBCE7AEB8D949B870BC58FC60E352@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d09b454-305f-456d-19bb-08d6e39e2902
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 18:56:15.6452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2581
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280118
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 11:29:43AM -0700, Stanislav Fomichev wrote:
> Drop __rcu annotations and rcu read sections from bpf_prog_array
> helper functions. They are not needed since all existing callers
> call those helpers from the rcu update side while holding a mutex.
> This guarantees that use-after-free could not happen.
>=20
> In the next patches I'll fix the callers with missing
> rcu_dereference_protected to make sparse/lockdep happy, the proper
> way to use these helpers is:
>=20
> 	struct bpf_prog_array __rcu *progs =3D ...;
> 	struct bpf_prog_array *p;
>=20
> 	mutex_lock(&mtx);
> 	p =3D rcu_dereference_protected(progs, lockdep_is_held(&mtx));
> 	bpf_prog_array_length(p);
> 	bpf_prog_array_copy_to_user(p, ...);
> 	bpf_prog_array_delete_safe(p, ...);
> 	bpf_prog_array_copy_info(p, ...);
> 	bpf_prog_array_copy(p, ...);
> 	bpf_prog_array_free(p);
> 	mutex_unlock(&mtx);
>=20
> No functional changes! rcu_dereference_protected with lockdep_is_held
> should catch any cases where we update prog array without a mutex
> (I've looked at existing call sites and I think we hold a mutex
> everywhere).
>=20
> Motivation is to fix sparse warnings:
> kernel/bpf/core.c:1803:9: warning: incorrect type in argument 1 (differen=
t address spaces)
> kernel/bpf/core.c:1803:9:    expected struct callback_head *head
> kernel/bpf/core.c:1803:9:    got struct callback_head [noderef] <asn:4> *
> kernel/bpf/core.c:1877:44: warning: incorrect type in initializer (differ=
ent address spaces)
> kernel/bpf/core.c:1877:44:    expected struct bpf_prog_array_item *item
> kernel/bpf/core.c:1877:44:    got struct bpf_prog_array_item [noderef] <a=
sn:4> *
> kernel/bpf/core.c:1901:26: warning: incorrect type in assignment (differe=
nt address spaces)
> kernel/bpf/core.c:1901:26:    expected struct bpf_prog_array_item *existi=
ng
> kernel/bpf/core.c:1901:26:    got struct bpf_prog_array_item [noderef] <a=
sn:4> *
> kernel/bpf/core.c:1935:26: warning: incorrect type in assignment (differe=
nt address spaces)
> kernel/bpf/core.c:1935:26:    expected struct bpf_prog_array_item *[assig=
ned] existing
> kernel/bpf/core.c:1935:26:    got struct bpf_prog_array_item [noderef] <a=
sn:4> *
>=20
> v2:
> * remove comment about potential race; that can't happen
>   because all callers are in rcu-update section
>=20
> Cc: Roman Gushchin <guro@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Roman Gushchin <guro@fb.com>

Thanks!
