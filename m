Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AE51ECC0F
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 10:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgFCI5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 04:57:18 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:4291
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725355AbgFCI5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 04:57:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FklOQ3IjJAxVJdqD4UMjJVK2vFvQzKsP4CJUcu0nPOsgwQ6J8u4vUp+Bq294M0jpMbW5dmKLhH6/BY45lR+W/CtBMpyF3Dfeo4Ihd0PuXv8u9cJZ/uejKuBe8xL9t5vdnzqKpL4STKWoqInN0vp5dG7sruDHbQKW0J9TGX7Nuy3g5YgUVW3ZMbkO7wK7eUCOjzhFbkgEDq96tIBKqirXfL12M0rHYJOFrTUPnY6I47cGF2JISJRyJ2alFpnciadk0DdEyCvlhQKmJGd5LFBznko1ZsajCmAb/H+1qyhFVqAbgGGmz4MMr9ttgp40SFnobZf4C2uEiSVDVamlJ74dcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvP0dHfX/oijnNdIW3yrl1gFiwhssLSJuCzyAUSMqw8=;
 b=dl29wcm23xNkrmtu9LeujE39QN5G8jU2hRF+oNhECq3S3+0JZYaHBYC0UrfNAVoXTIhBH7Z1SA4J5zT1SmEEZbTkjtqajqlDN9t6VMiz7OZ5TGgPg8WS1N1mq1ceoWj/vuvs7G0glbUegztcpzMYsa0urAtKKK5rl1RK7GbRB8Wh+ESZQRWeZZLToR881urAJrfARBTgM40T/wCUBLbviZ2xowhbY46sX7UfVjQazQZs3xtZiPZkUf8tdgkcF52OlivCf/0hxyCIxH6DAvi5Iu9Wfo1Ob+BqG5KFLhAlhDOLtBmPMxEsgX/fev+cBZjQqRh3PEo5YUaBDkI4YMJXVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvP0dHfX/oijnNdIW3yrl1gFiwhssLSJuCzyAUSMqw8=;
 b=L9pqg2Zl9zAI0ixeC741r00HO0UJiUFO0CXsBl7tMehyA+/ZAd2bkPVQFhMI9qnLXMZc1kfeh1+LPnMVVm5rywjuc+llKD5Zu+Zor2eatfBqB4Vlqd5tn3S/i1nssP+i/xcxOY+Fq151wKKRKFIwkkbgh9ntqolMuR43/TUqreE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=inf.elte.hu;
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::20)
 by DB8PR10MB2747.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Wed, 3 Jun
 2020 08:57:11 +0000
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53]) by DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53%5]) with mapi id 15.20.3066.018; Wed, 3 Jun 2020
 08:57:11 +0000
X-Gm-Message-State: AOAM532hdP2uEOAQzpRN51R2nrqJq0gHIn97umyGo2z7nQCyVCcXJ+fn
        SY50GcQGNtUiwiSi6o5X4zyWDFtHjq0YWQVFlBg=
X-Google-Smtp-Source: ABdhPJw7urgTHj26DM8qQt95LRO0NI6I1DVaX2dR1OlyLFf3Rivu6DHQ1QJ1TNHah2lIgDdjkINOgPKWCNKUFo6qcX4=
X-Received: by 2002:a5d:522f:: with SMTP id i15mr7728389wra.339.1591174626823;
 Wed, 03 Jun 2020 01:57:06 -0700 (PDT)
References: <20200603081124.1627600-1-matthieu.baerts@tessares.net>
In-Reply-To: <20200603081124.1627600-1-matthieu.baerts@tessares.net>
From:   Ferenc Fejes <fejes@inf.elte.hu>
Date:   Wed, 3 Jun 2020 10:56:55 +0200
X-Gmail-Original-Message-ID: <CAAej5NZZNg+0EbZsa-SrP0S_sOPMqdzgQ9hS8z6DYpQp9G+yhw@mail.gmail.com>
Message-ID: <CAAej5NZZNg+0EbZsa-SrP0S_sOPMqdzgQ9hS8z6DYpQp9G+yhw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix unused-var without NETDEVICES
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM0PR05CA0076.eurprd05.prod.outlook.com
 (2603:10a6:208:136::16) To DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:ab::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mail-wr1-f43.google.com (209.85.221.43) by AM0PR05CA0076.eurprd05.prod.outlook.com (2603:10a6:208:136::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Wed, 3 Jun 2020 08:57:08 +0000
Received: by mail-wr1-f43.google.com with SMTP id x6so1412087wrm.13;        Wed, 03 Jun 2020 01:57:08 -0700 (PDT)
X-Gm-Message-State: AOAM532hdP2uEOAQzpRN51R2nrqJq0gHIn97umyGo2z7nQCyVCcXJ+fn
        SY50GcQGNtUiwiSi6o5X4zyWDFtHjq0YWQVFlBg=
X-Google-Smtp-Source: ABdhPJw7urgTHj26DM8qQt95LRO0NI6I1DVaX2dR1OlyLFf3Rivu6DHQ1QJ1TNHah2lIgDdjkINOgPKWCNKUFo6qcX4=
X-Received: by 2002:a5d:522f:: with SMTP id i15mr7728389wra.339.1591174626823;
 Wed, 03 Jun 2020 01:57:06 -0700 (PDT)
X-Gmail-Original-Message-ID: <CAAej5NZZNg+0EbZsa-SrP0S_sOPMqdzgQ9hS8z6DYpQp9G+yhw@mail.gmail.com>
X-Originating-IP: [209.85.221.43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96f95926-4dc8-474e-029b-08d8079c18a2
X-MS-TrafficTypeDiagnostic: DB8PR10MB2747:
X-Microsoft-Antispam-PRVS: <DB8PR10MB274739FBA7C216C672F73E2CE1880@DB8PR10MB2747.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7/31U5mLXsklC5l6hs1NbPZIxpsVjqerXB2qhnu781QH+9+CAzvut/62rtOEiYjyEVfpv49uUJRv8Y2BHcQLP0R0EnYQCIeVvFQRlwERycgK4Ev843mlaKaMydBLXCDj73vmZUqYWAOrgzpu7wqcvOAkI90tOir14ikQstPn19ZmVycF1CsSmcag0tUCxWvkiSaW9pPH1S7FgRLeDDsZBW5aMD/oNl6XoRqKSu2DHE0rdOSFYbZ2HARO1T2cmqZFLtEM1E5eI5UeonkjdshJASDSQXSh2uYCZ7IogaxSr7a4OmNaHCnoqN/vTNEYROJVv7/3WTc4+gphWm1+HJZ+9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(39850400004)(396003)(136003)(26005)(55446002)(6666004)(42186006)(66574014)(786003)(4326008)(8676002)(6862004)(450100002)(316002)(83380400001)(52116002)(8936002)(54906003)(186003)(66476007)(478600001)(2906002)(66556008)(66946007)(5660300002)(9686003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sY/lQSwrJmZtUhTGNOMQFEOHV0s96INb3tyAXjVG/yFn7L3dwgdlTHxN3y4lTIb0jzo+cjlXDNKpCcjRw1SzdJaFVlvYU7mleMr0xx7Zk1AFyxf71QSc6XtaVeIqJqvTEjtuVZL+D8CB+Kb+eMV7ttcmUGrHrWdihOmdQbh050nhUeruhW0xCWSoDqs+hURtlWqLhy/1BUN2n8wvy9uASZJerABgg7gbvFpozGDFP2UasARA/ZGhLmalxbrAq8z/hAlmoWajNYwF3cphv4S/U1EvlVgUpjzbRdwsq9H0FYKngzpI1t0Eb5enHFI2xHyls3rDpRm8wBV1+4seKseODfSGs0ZK+i4B8UxRISQdfC19p9F2UNxQZ5GNLO7gO2KnX+H6vLr3tEH1EYu7wKoW11aMkPC9+nqjIRofMaTwmguIpPf86OttWaRkUwBbioHdP1fGXyjGOoIjee69Zk9ckOTkfdKCjrov5tAbnHjcx44=
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f95926-4dc8-474e-029b-08d8079c18a2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 08:57:08.4397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnTT9DcA9StyXr5TunIyIpiZ7cvb5VlGJZfh9nK5EC8frOOdxuuv1mIkbXTO76jsdEZUnCp+yTLzIBdLJk+XQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB2747
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matthieu Baerts <matthieu.baerts@tessares.net> ezt =C3=ADrta (id=C5=91pont:
2020. j=C3=BAn. 3., Sze, 10:11):
>
> A recent commit added new variables only used if CONFIG_NETDEVICES is
> set.

Thank you for noticing and fixed this!

> A simple fix is to only declare these variables if the same
> condition is valid.
>
> Other solutions could be to move the code related to SO_BINDTODEVICE
> option from _bpf_setsockopt() function to a dedicated one or only
> declare these variables in the related "case" section.

Yes thats indeed a cleaner way to approach this. I will prepare a fix for t=
hat.

>
> Fixes: 70c58997c1e8 ("bpf: Allow SO_BINDTODEVICE opt in bpf_setsockopt")
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> ---
>
> Notes:
>     This fix currently applies on net-next and bpf-next only. Except that
>     net-next is now closed and -net will get commits from net-next after
>     Linus' pull.
>
>     I hope it is fine to have picked [PATCH bpf] and not bpf-next (or net=
).
>
>  net/core/filter.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index d01a244b5087..ee08c6fcee1a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4286,9 +4286,11 @@ static const struct bpf_func_proto bpf_get_socket_=
uid_proto =3D {
>  static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>                            char *optval, int optlen, u32 flags)
>  {
> +#ifdef CONFIG_NETDEVICES
>         char devname[IFNAMSIZ];
>         struct net *net;
>         int ifindex;
> +#endif
>         int ret =3D 0;
>         int val;
>
> --
> 2.25.1
>
