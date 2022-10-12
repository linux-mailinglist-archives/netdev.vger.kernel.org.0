Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF485FBEFC
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 03:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiJLB5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 21:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJLB5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 21:57:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2090.outbound.protection.outlook.com [40.107.237.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C31CA346A;
        Tue, 11 Oct 2022 18:56:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBv8HFHDa8m9tcDTYiSovIgKpToHsRN2bA4P3bShCKpZfyY5OYR1QO3ddz18xMuRYZrbB2Bqjm6f7njmA8qSO7k81XIu4lSuZLthelScVvaajeDZ/t1Cd2ZkfVcF7wwdsE0pMAWAfWJ7261PIukmCd2hjbJrqFaIRttrlT+yN59xi2usqQLBNnL4tOOG+XYyLkS8XSY14Py9NYY0YQowZFCz12b6qkPpnyYVUcK0OdV6mNAS+8GONVNeDMq5tOMPpxAZ8RMOnxr1DuGWAOqVSYdceRak1BLJP6f6CUSYfzQD6Z/Dw73ax10HMhO4NN7VoG0vq+LG4EGswQ8oYlNidA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5rwedtWFStY82BSKHuBV8LgPnzflQzdgcH0CNVqPfBw=;
 b=JzPcs45cpQyFNl/En3qfl9xGvsAZaqDd9WZIjSAZn7EgYoIwKPmnRBYPWF5bI2RszhT6N0PVCP5Z5a/B071rs9Z7e5ZSLR1iboTPCtnlkIJMd14IjxQxXbp8J0RGE4MuvuHPnc4xbZ2g1EYrhf8CTjXtWWCtU0t6V/5GYZ6CVRBWlhOssufwpurdFQDeyGO6n2HokFZdm4681cuTCacNiwFlrNKccXTy9sTGRfo7rbhx6xuqTANzIVebwxSF0gphLRtD8IpX47sPcTOhSlI3WYuWAALWsKmThUpV+Ww/I6GjouK7SjKYYzekbQaF9LMJdhCk+rEaEgxNfIiZuSgldg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rwedtWFStY82BSKHuBV8LgPnzflQzdgcH0CNVqPfBw=;
 b=BXQIB+W3XsSVU6A0R4iKhhOuEpR2Ggba385HOzv4n2dep95nXhB92usdsq4eT0a8J2/u2FlCB4kgGyAOhK0kaJx4Q79l/Tz/SwvbcAVVa/zF7ar3h+tDo47bzQebc+WEegi6tuIcmu19/XsBzaH+pH6h2Nw3QrYVK/K9pV4WjwY=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by MW4PR21MB2001.namprd21.prod.outlook.com (2603:10b6:303:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.6; Wed, 12 Oct
 2022 01:56:56 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::676b:75a4:14cd:6163]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::676b:75a4:14cd:6163%7]) with mapi id 15.20.5746.006; Wed, 12 Oct 2022
 01:56:56 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Cezar Bulinaru <cbulinaru@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] hv_netvsc: Fix a warning triggered by memcpy in
 rndis_filter
Thread-Topic: [PATCH v2] hv_netvsc: Fix a warning triggered by memcpy in
 rndis_filter
Thread-Index: AQHY3duWq3tilBQ2fk+eiTuNzXF6Ua4J/+9A
Date:   Wed, 12 Oct 2022 01:56:56 +0000
Message-ID: <BYAPR21MB1688C0BE9914B06E2937B6BCD7229@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20221012013922.32374-1-cbulinaru@gmail.com>
In-Reply-To: <20221012013922.32374-1-cbulinaru@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=28283416-a1e1-4c7c-87bd-00c4caa42795;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-12T01:56:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|MW4PR21MB2001:EE_
x-ms-office365-filtering-correlation-id: 649272d9-2e86-407a-59e0-08daabf50aec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zY/fP9YIrhOhLkuLcslGdci9gZ93KzVQ+xUm2nktKL/qPrNDig3IxuTPVzsu+GcGwaVBOEzJPlvVTvUKjCyQFiE6Z/S6uNC8JqoOr5L2HWRrIb7HqwizvBtmGiBrnhgG/TG5NwCkBymxDFG9HKUct5cmJ93lc8ZYwqv3hJUTymaSs14AjDbGlnnuZpoA3wYGcjwvC3ogxqAu0j4HyCN7XNGfc9ltQU4mSgigBilfpDsl0GcJ5PM3JcmyevzmMZ69Ax++a4PspxN2u1124lKiMoS0I9POFRxiX6Zo1b2ciwfoekeWxjN/9VIA9LIXfPpNRs4TmYN5h4L68vuaPat1/6evYErhS4mSOhi4kwGIpsjWt2WuZHK6yrYI+eG0luuTNXbi3dzkOJk2US+5zKHFb7w0yZPOSbss6eJe2qobzA7WHpF+p3yfFeZ13/DYxc6TUaVTadrOdW08dYHN07eBJ2uWNVndLx8Y6mKDP+PPyndkBDZKB3aQn0GcFkIo9FlPknz312B50Sy7C1P4P79C4z1ZJuPi4CRQo2ceEHsRlx6sIYih6fg5jeW/Wa7QRW/HPRwW71u+F/1wvS7JX8CR6ejcqsoBMoYIUKhnpYgkT8iMUIMEvJ851t4TUm0d2PolUTWe+NOFE31+dBIr8+eBxsy7JU4sxTeKvpXhkRukuXJFUpHQ9dP69zHH6V99hYQB21Rtwn/DOUpbFH9FS836fKyX2L1UAuOqh6Wz4hyKhjkgwHhXKdNB4h7yXCknC1UK/DIVv4xERLzWygNcOtz8MMho6KvxWpd6wsGpMz5SBuX1kFeneKtDhGrmytYirGYZbrOPfK5cJv0cfNAB5e2m+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199015)(82950400001)(83380400001)(2906002)(8990500004)(38070700005)(33656002)(8676002)(64756008)(82960400001)(6506007)(41300700001)(55016003)(7696005)(921005)(86362001)(38100700002)(122000001)(186003)(8936002)(66556008)(316002)(26005)(66446008)(9686003)(110136005)(478600001)(5660300002)(52536014)(76116006)(66476007)(66946007)(71200400001)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Df81GAsKDX1WuGU+ZdE2T/b3wRtX5xKzD9hPf6UlHH+D7ufJIUXUEb1tGnG?=
 =?us-ascii?Q?CDP+GEn2r6NeUk8Xs8Wfrncic+uqQvBSZSg4Mv3O296NnWv2HhX0DPLLdDsJ?=
 =?us-ascii?Q?qZF4XeqooIAk7o0E2Vp8slUzkfKG9ED9pk+Spl7b6xnBVOEXwzNNWCvsFcBh?=
 =?us-ascii?Q?q3+5QUAaN0VESd2qp1WUYI51d4iRjc+z7glC/k6akSbT27AsQtq+/0kq13bo?=
 =?us-ascii?Q?9tPc9TpOb1Do68+2olQ1fjZPZ6fwPgVxZjpDwdDJjLlpwlNfx1JwWnnOtX9d?=
 =?us-ascii?Q?qeG4177FCtPtZys9abQz6s/e4gY7RpHNk8pF0wlTU1AyzfckmrSmRwzznuMt?=
 =?us-ascii?Q?peM68CB6BWOUSPKncrq3zJbSfnlo3KQfR/xBWmLj5RHf3FApWXLtkIgI9aBh?=
 =?us-ascii?Q?5koVjtuQWxRZxG3Nu5XCDn8HfqX6/D/JnrTdz7quhlNmKccDD/UIQ1a7bICY?=
 =?us-ascii?Q?bRwVIRVi20aXMfZiGAfyIIu80JUdcBV/OnlKoOTIwV0bQHj5u+YhRHlo64Wl?=
 =?us-ascii?Q?mx98ayy12Wb/ODvC02WT6/DCC8lNAlLuj5kSL98kG18udJQzClEeJVcWTg6C?=
 =?us-ascii?Q?UFIYpGsrz/pF/7cJrZCpxcPDgbJlZz53+SnddFhdbFR49Ufzi5ID3m9fckxw?=
 =?us-ascii?Q?ApSLh2v7fGW2pxYAq3rCxuotzIiP+YddK0iId1R0htMLcKIdSDwb1NjcJ5uB?=
 =?us-ascii?Q?3vR8UPTX+9wsvVZrhRU0m58g6uhwas/6JGPVgJ8z1npC0poReUdTwrOcM/IV?=
 =?us-ascii?Q?02mNbApFjQfGyWWhBFHc76XnhAc/lzFk5V6J/mElx5u13VdM9s7Yx4DikLF5?=
 =?us-ascii?Q?ZDq21afZLMDrLcq/BCaSHaMKKDILQLAJaYdX1VnDksFt5EiKsj8gcT0U+Rrl?=
 =?us-ascii?Q?sYVJYeXFBd0z/ZBcuTDvqCDk/YWvNPLnDvnun2UdQxKDd8c+7HWHOLbfPazF?=
 =?us-ascii?Q?JfzRrihsyUr7pVIiedV0mZOcKpp+uYcMYeuangZyrIydpXxfkrFNQ0evKHz5?=
 =?us-ascii?Q?Lwbew4GJV5VCDU16URB7Kr1pCXCKCOOYurdJ9uCUr7v/Ux8z+ljKJRwsKtbT?=
 =?us-ascii?Q?dlveYk61ccuB/1/ayPeDhLu7+Zzg1/xdNzcBKQ5nLzwin2EQt7SmXohZGr+w?=
 =?us-ascii?Q?13Gt2hn8ZQcVTIIhjVScfVUnIkQb2fwcY4wWhcsH/azlJ+YLebxLdyOtMuSB?=
 =?us-ascii?Q?3GrboU6WtHGUw2vgc48GWCvqDnf0WX4egeUcFpvCfRC4GpRmIZ1ASLc4Id/O?=
 =?us-ascii?Q?tOuhtjCj6o+HYpis4sY65idzY1ET9xvslE1MEnKFvXDc7MEC/ntIRdRLE1Yh?=
 =?us-ascii?Q?TFrt38IsmkuQQCOmh1XMIf8JJsvH/7H4J3Vgd159EnBEriEpjmFwv36pMy8B?=
 =?us-ascii?Q?r3Xxnk586PF94f2iBds5r91dinR8ToiyYJAVoH+QSRrpTPwhvT4tbg41SSV5?=
 =?us-ascii?Q?3v0H7DGpQ351EIDjP6qedHofFhBGZzSQa027+lbfrT3hJM23mAQK6ac4YOSJ?=
 =?us-ascii?Q?PSMjCX8mTBpgRkQHctGIIqYfwlOU9GIVaqpLptunEUIre3jQNDCDdvV1CXAV?=
 =?us-ascii?Q?TkiShdg33S4wNucHkyuCPMqaEwuLvJTRkn1JCG+y6OHRoXDQLpGZnCEKNqqk?=
 =?us-ascii?Q?8A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 649272d9-2e86-407a-59e0-08daabf50aec
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2022 01:56:56.4632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9RSH/Vdu4OjoSHtALC5mAnBdUF5CAuZlBE2IkfRbJQ+N4ckqpqGLPwepJWX3vId4zoxrfe+/GjnCmHQc2EgBwqTatYrsJiLd4z8HNgxh4ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2001
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cezar Bulinaru <cbulinaru@gmail.com> Sent: Tuesday, October 11, 2022 =
6:39 PM
>=20
> A warning is triggered when the response message len exceeds
> the size of rndis_message. Inside the rndis_request structure
> these fields are however followed by a RNDIS_EXT_LEN padding
> so it is safe to use unsafe_memcpy.
>=20
> memcpy: detected field-spanning write (size 168) of single field "(void *=
)&request-
> >response_msg + (sizeof(struct rndis_message) - sizeof(union
> rndis_message_container)) + sizeof(*req_id)" at drivers/net/hyperv/rndis_=
filter.c:338
> (size 40)
> RSP: 0018:ffffc90000144de0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff8881766b4000 RCX: 0000000000000000
> RDX: 0000000000000102 RSI: 0000000000009ffb RDI: 00000000ffffffff
> RBP: ffffc90000144e38 R08: 0000000000000000 R09: 00000000ffffdfff
> R10: ffffc90000144c48 R11: ffffffff82f56ac8 R12: ffff8881766b403c
> R13: 00000000000000a8 R14: ffff888100b75000 R15: ffff888179301d00
> FS:  0000000000000000(0000) GS:ffff8884d6280000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055f8b024c418 CR3: 0000000176548001 CR4: 00000000003706e0
> Call Trace:
>  <IRQ>
>  ? _raw_spin_unlock_irqrestore+0x27/0x50
>  netvsc_poll+0x556/0x940 [hv_netvsc]
>  __napi_poll+0x2e/0x170
>  net_rx_action+0x299/0x2f0
>  __do_softirq+0xed/0x2ef
>  __irq_exit_rcu+0x9f/0x110
>  irq_exit_rcu+0xe/0x20
>  sysvec_hyperv_callback+0xb0/0xd0
>  </IRQ>
>  <TASK>
>  asm_sysvec_hyperv_callback+0x1b/0x20
> RIP: 0010:native_safe_halt+0xb/0x10
>=20
> Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>
> ---
>  drivers/net/hyperv/rndis_filter.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
> index 11f767a20444..eea777ec2541 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -20,6 +20,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/ucs2_string.h>
> +#include <linux/string.h>
>=20
>  #include "hyperv_net.h"
>  #include "netvsc_trace.h"
> @@ -335,9 +336,10 @@ static void rndis_filter_receive_response(struct net=
_device
> *ndev,
>                 if (resp->msg_len <=3D
>                     sizeof(struct rndis_message) + RNDIS_EXT_LEN) {
>                         memcpy(&request->response_msg, resp, RNDIS_HEADER=
_SIZE +
> sizeof(*req_id));
> -                       memcpy((void *)&request->response_msg + RNDIS_HEA=
DER_SIZE +
> sizeof(*req_id),
> +                       unsafe_memcpy((void *)&request->response_msg +
> RNDIS_HEADER_SIZE + sizeof(*req_id),
>                                data + RNDIS_HEADER_SIZE + sizeof(*req_id)=
,
> -                              resp->msg_len - RNDIS_HEADER_SIZE - sizeof=
(*req_id));
> +                              resp->msg_len - RNDIS_HEADER_SIZE - sizeof=
(*req_id),
> +                              "request->response_msg is followed by a pa=
dding of RNDIS_EXT_LEN
> inside rndis_request");
>                         if (request->request_msg.ndis_msg_type =3D=3D
>                             RNDIS_MSG_QUERY && request->request_msg.msg.
>                             query_req.oid =3D=3D RNDIS_OID_GEN_MEDIA_CONN=
ECT_STATUS)
> --
> 2.37.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

