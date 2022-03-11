Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78154D6674
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350386AbiCKQhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345690AbiCKQhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:37:23 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2063.outbound.protection.outlook.com [40.107.101.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41471C65C7;
        Fri, 11 Mar 2022 08:36:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPThfuVR7mYc3wnD5T7jgXIPbJcp1diWGHZm867vDlo/2HzNdftLB/X1+5+gQvHGLqVIBg/EiMzQsuYSrpDGM3KPhhI6CTqVkTlh86t9VYcfFD01LHDmwenxdhXQMV1/YFZPnZWqGKIA5KAadO31uHLplRrDW9rKhf/E97yluBc+EWNuDCHK2ojK0NQrlDZRBcp4EoYpNny2WRvNxA8S54u+TT5TPCpMwITKIbGDUMN0KLmi0AZzq0kQp2E2dfaJ72LO9COJSCaVZEdLSdmtzC+rYhaeiuzAeQKKQvoPNje2rRH1ti7TJ9mYrzQVPab6aSLt7YWxN5YO4h/Vs3Jiow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sRSyxSBF+rGJOFVLtA6y1NsBb34l/EdkieaiqUgcEs=;
 b=KdcLnSGL44oEyhYHHOezdt2ejxWc+rYkhxr5mfDvy24tSawd8CxnCCe+RcQZ5Oz4Fhos+THpiDR3IGyPrjKgvJvoS2OIPUKqarD6j3w/EytB3WNsWnNqwL6N4jelE0fxvqNZN5aAWhT+w/G4Klx0gUsicE+QZjFl6S8xR/vzaQTo19KJM2KygE98xVXnoXyWhM60HWtBmVYnwWPJt3xTrZhI4XY2WIJyz5nMvS2+VasVN4K6dzzeFSQngYZUgiaxZPODpfdhIyvwcTWAhzomHzo3kyRW7ZCgex1uQvKUpc9VyF6jJCHd4vxvh4n48mgS/NehlwjT/XXwdkxN13UFYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sRSyxSBF+rGJOFVLtA6y1NsBb34l/EdkieaiqUgcEs=;
 b=K1JfwAXKMeYINMv11wKdNyjkszNDVySCAuGwRjEaJUh4kRI2sw92KXyI8L+STvOPMdCQ3GbobKXKVuRJ7I/jWz2y7NtTr78Txzp0o897GFj/BplUtp3cISAutmiZ78+gsRPZxsQjrrT8aG6WFq0M/LTbXccBhHVFA50Xt2nb2WDAYcPoAKdSfXH8KvXvfbEfX7e2vALtzyK8EnvHDVwGhv+O25CcQu0/zAnnSB0u3+yFMSPPaZu+7COhDOHIiGTxDgZlmhKAQK2tMegpoTS8Jj6n6y6ltYH0UiXVr6IUq3N8Bt2C1XZJ2ERDW1uxxzTUux5Owikydlz03dkwDy2lkw==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN8PR12MB3073.namprd12.prod.outlook.com (2603:10b6:408:66::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 16:36:19 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::698a:be42:9ca2:bb4f]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::698a:be42:9ca2:bb4f%6]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 16:36:19 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: RE: [PATCH bpf-next v3 4/5] bpf: Add helpers to issue and check SYN
 cookies in XDP
Thread-Topic: [PATCH bpf-next v3 4/5] bpf: Add helpers to issue and check SYN
 cookies in XDP
Thread-Index: AQHYKZEIZ876oRailk6qPfc0r7EgGKymwCiAgBOy65A=
Date:   Fri, 11 Mar 2022 16:36:19 +0000
Message-ID: <DM4PR12MB51509E0F9B1D2846969A6A72DC0C9@DM4PR12MB5150.namprd12.prod.outlook.com>
References: <20220224151145.355355-1-maximmi@nvidia.com>
 <20220224151145.355355-5-maximmi@nvidia.com>
 <20220227032519.2pgbfassbxbkxjsn@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220227032519.2pgbfassbxbkxjsn@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41d42446-aa09-45fe-9df0-08da037d451b
x-ms-traffictypediagnostic: BN8PR12MB3073:EE_
x-microsoft-antispam-prvs: <BN8PR12MB3073CAFD1A77938AC114145ADC0C9@BN8PR12MB3073.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 30+RKP7EDPawnCmdB78T9+WU2a2lAE8kagY8HPRFmAWosX/bywPU6TZB4s2lO6ax3woQOIw+VY5W+OZ58qt2+vldH9qwHYNqToId5P+T4Nsi1QzzqrF6HQfZbfyg4xyQIjIcbKRfnVRj6xYwgIarAsHaikepnbTdHDn4BKBrsn0z3Dg36O2gDYn7XmMjq79yEJ05j5jTER7V4tkHNSqNuPGFJDPycps4+UDx9BtYWxDbR+GDQL4bsbK3fXNbKvqVNDimVKldTKMyG2YUcbIXaNEyelVaBjEw/8L3GE/HVgnfUrztxeMyNP9U54ls2s7dDE2jPULw6hLfdR5/Zx0wZFNTQEPzuqGXwAfkfxg5Fi+diTcPeJ24TVBSrIsMfZF5FE9K0B2+ZmPs94S55ULTT5IvbPM9TfzmGpaRHphjgoZsLcKegXBXHN/TP/L4ItTSEtUYy9xQtgLPo6mSied3QVpxwlOcjiduHfo+I8JHrbVCDiX6ra+oQJf6BKcOknGSYTMQqD+Rk1E4BUcSvPfhLnvKlAc1xmjIW9exx4Dhq0WWZKxq4DLGYx89iWsn+svAd3Vuj8lpfLkjIPH8q3UQgDL9lZUzr7iWuxSTjFxNQsJpcIU/8jww7A+4B6VlkqyrY7IsUvMi1nrgALnPqsq2znLW7M8GIpCdZv/b0Lw0579I89KIScoOM2dBvdXW/FXV9AKSffTRNSdwmQGieZxWew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2906002)(76116006)(54906003)(508600001)(6916009)(9686003)(38100700002)(6506007)(316002)(71200400001)(38070700005)(7416002)(122000001)(64756008)(66446008)(66476007)(5660300002)(26005)(186003)(55016003)(66556008)(66946007)(8676002)(52536014)(33656002)(83380400001)(86362001)(4326008)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?u6P5aigl06wQUKLhau4RfjS6E+fTDJkreI77sEUowMwWGosNkr790jXgyy?=
 =?iso-8859-1?Q?toyQ06BlHIm7VBzT82nU520FyndHg4bq++oi3rEFRxuEZcmS3n8ooawzN0?=
 =?iso-8859-1?Q?AVvHxPRbejL8qrl603nvuMP/ujCC0SZoC2sbK4ZT0T26ZTdhcX7McenkfV?=
 =?iso-8859-1?Q?LBC1lpWTJYrancvE9ZnT3cTLc5nYPbbHaKLEe+DiIvBPTcE3w5lRnVa9nQ?=
 =?iso-8859-1?Q?0Vq22Q3QnqKvBtZ8TrHiPb8TZDpApvQfObb8nvbpno6otNAInTsIYb2V9z?=
 =?iso-8859-1?Q?DxKlt6QZ2+hHNk2NM0J9msipkuC3YGkuJTFTR/PF6m84dY6VjZGT11eSXt?=
 =?iso-8859-1?Q?S51MgISJFizSo1t24uNK/3FfECT/uqeyhqDBv6qsI5Wftl1A5i1Tpz0XG4?=
 =?iso-8859-1?Q?9U/MeCFhWXhT8d769tBA97iR5kiGyJBVk8Vb2m8wbps90uBDHrw6eklRDG?=
 =?iso-8859-1?Q?el5xsslKuhM/qj4LLmM5kMasvMvd/8UN4PIZ2RFX5h8f5sg9EhG9ZGg0b5?=
 =?iso-8859-1?Q?wL829oY9Loz+5KwDY9kvmlhI3VNSlI42lOvmxlElg5Hbigjo+5M1ceARXd?=
 =?iso-8859-1?Q?HmKmthz/bfub0iBxlQ8yLbs4x206lFUeS7leoJ1QVFqSz1t0JeD8inqBSV?=
 =?iso-8859-1?Q?auHLlvLBKnrHyadCkYDXWanmpPRtg84WN8/Jnfz16SD+eLVpaJLaYPkGYF?=
 =?iso-8859-1?Q?BibLAd31AClUF1JVs0UfkpSR/+61cZvHSCfZ3gSUYdhr2iwlFkPLGj9rML?=
 =?iso-8859-1?Q?tD8eMCt3o6+Wi9lYZpxOcmtfc6G1xo+8cQMcrkzEuMRPmclYzgbpx+lNYx?=
 =?iso-8859-1?Q?Coi192A8QW+U5L31/hilWEnfh/hFB1I8oZFH6GV5+sciuvwEw0tR8b1T6S?=
 =?iso-8859-1?Q?ICsrY/yeWDWLnm7kNkFThn/qvZU0rPkEmMGZn53eK28JtHFGC5dbZwZDgf?=
 =?iso-8859-1?Q?+loHlLsKwwk8vb6H8WN+Fs6nTpJbBg9ItFBdTm5EIFWjhJdGeOpxFjM9AK?=
 =?iso-8859-1?Q?qGrduCWFwM/iDTaerch+vbX+bGDzayvmZCpdt4Fx1rcZzuPPhrHhOBgDj4?=
 =?iso-8859-1?Q?JBPScwoDc5tyD4Gr195oB/15V3viO7Era50YP3K7aKmfTgneqjnZZxIZFV?=
 =?iso-8859-1?Q?vBHZ3Dvv2IpvIyHrCTKIhxoG5gJ1PLx39LaC31yrU14we79v7TjaSuWYfP?=
 =?iso-8859-1?Q?y7A3VoDIlEQjuev9WPRbqMvmPfQh0bArJ89UxMnVTBSEO+IGg9j0ePTMQU?=
 =?iso-8859-1?Q?Mwms5O9xYgwaG+wYbDu9zVjnTHgQ63ElCW5rnTbCaVzgUXPCBmOq7fW1Aq?=
 =?iso-8859-1?Q?uf/blsfnEBK2ypjFSxrx12yiQaZ8g7RkE0LMQodcUpZ2H5QZ4Dmf/6tfNN?=
 =?iso-8859-1?Q?OQaWwuWCu0jGA27KGSinhLlue5ctxw4sIMF+Bd9C4TgSAjsUIQ9SS6dyj4?=
 =?iso-8859-1?Q?+JAPno9it20r6jeDI254QGQRpQCREaeOYn4Xs8KERlqzka0QsWfaRx1tpm?=
 =?iso-8859-1?Q?mxiCbAyRPIwYzdLS5nlnRd?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d42446-aa09-45fe-9df0-08da037d451b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2022 16:36:19.0329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6uPJHMFkDkr+KIIQRFFfJgnwsDLb+IaQwUfZBMCQYTf6aY0K0r1zyU0ziGzuFNLk20kCLwmXou9dU9xMhJNQOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3073
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Sent: 27 February, 2022 05:25
>=20
> On Thu, Feb 24, 2022 at 05:11:44PM +0200, Maxim Mikityanskiy wrote:
> > @@ -7798,6 +7916,14 @@ xdp_func_proto(enum bpf_func_id func_id, const
> struct bpf_prog *prog)
> >  		return &bpf_tcp_check_syncookie_proto;
> >  	case BPF_FUNC_tcp_gen_syncookie:
> >  		return &bpf_tcp_gen_syncookie_proto;
> > +	case BPF_FUNC_tcp_raw_gen_syncookie_ipv4:
> > +		return &bpf_tcp_raw_gen_syncookie_ipv4_proto;
> > +	case BPF_FUNC_tcp_raw_gen_syncookie_ipv6:
> > +		return &bpf_tcp_raw_gen_syncookie_ipv6_proto;
> > +	case BPF_FUNC_tcp_raw_check_syncookie_ipv4:
> > +		return &bpf_tcp_raw_check_syncookie_ipv4_proto;
> > +	case BPF_FUNC_tcp_raw_check_syncookie_ipv6:
> > +		return &bpf_tcp_raw_check_syncookie_ipv6_proto;
> >  #endif
>=20
> I understand that the main use case for new helpers is XDP specific,
> but why limit them to XDP?
> The feature looks generic and applicable to skb too.

That sounds like an extra feature, rather than a limitation. That's out
of scope of what I planned to do.

Besides, it sounds kind of useless to me, because the intention of the
new helpers is to accelerate synproxy, and I doubt BPF over SKBs will
accelerate anything. Maybe someone else has another use case for these
helpers and SKBs - in that case I leave the opportunity to add this
feature up to them.
