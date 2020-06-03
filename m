Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53F81ED672
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 20:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgFCS7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 14:59:52 -0400
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:26097
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725922AbgFCS7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 14:59:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLXvdNOOrYN/k9GKX35+kE34slizgTjzHR4eDtQ5QQNPwn1ku3mDZk1J0y3baaE2XoJrLB9W6fVwA7DHnOkCDOh58sVug3r5aNPnXL3XFLD02kgbdLIUBgzPU3mjSQmcU4vRiHTE61SBMvXAgn6mxQAPRyfKGL7nUbEOZItX/EnQZKwX8lJKMS+sxsyugdiys5V84/+glYapfkXB9f3c+v6QCGTnUcuyUO79waAus6OxLPk+7KZWkyDEwjf/JOYS4N/pjKteJTPze+ESMLObNTmKyfWkXUE0MaUp3qBCcMiTmUuTVn8CRnUB53tqIfuCi1+CpA2FG0eJ4uIaIzUf/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93st7wZPdQcmiupQ3gdLiLR/NJ8pDHNqHwxAU4ShjUA=;
 b=UBi/5TZhA8ZKz8lK4A0JdlbjntlA8k1CDqAUWoL9fUviPqTNkU3zxn2FG3behK4lolwGggofM96DBUY91H11SWvzm94x0bJAoLnDyzT9SIjB+NEzuHnhyLP3qwJAxM8depSF+QdLiuJi7wfyNBExK1VT2IuQ97rtIh9srG2EEW1R+bXGd1groEKRvzjsl8B3HlVrcr2eNm7hMalHJY2J0cTdzZLra+FgWdBBcHCQcThzeMwbDsK3bcOYTPlRevgeU4UbXo02/EuRMgoN8iFVqUHNgeYa10FNveEyGlUOOUhySMQ/XU/PrkhcgTk8r69DdNpTAvlv1F3ame30lW6iMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=inf.elte.hu; dmarc=pass action=none header.from=inf.elte.hu;
 dkim=pass header.d=inf.elte.hu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ikelte.onmicrosoft.com; s=selector2-ikelte-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93st7wZPdQcmiupQ3gdLiLR/NJ8pDHNqHwxAU4ShjUA=;
 b=RHipTpxLfpf6roqUpn1bp7tPHEN1LbSHj72i3XACaGPBJH3wIkZ5CgJUUEZEfFBW0UYWw4jcBR0CF9ort5Z0ROcrXz8xMazcur3RFnrzxbKnGJidZRTqoqXI6LISDGtZ/KJs17b41y3YjfbR0JSr/UonPLeKj90W1Ty68KqlxNY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=inf.elte.hu;
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::20)
 by DB8PR10MB3449.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:e5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Wed, 3 Jun
 2020 18:59:47 +0000
Received: from DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53]) by DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::285b:6f31:7d11:5c53%5]) with mapi id 15.20.3066.018; Wed, 3 Jun 2020
 18:59:47 +0000
X-Gm-Message-State: AOAM532A6+r65W/e/c2UY9qC6w7OoE75abLF442ikAL4Os32A/glVfgR
        LzNEKOatoiogtFwv2mMX7hpYlGYPX1DfFBq9a/A=
X-Google-Smtp-Source: ABdhPJw7K2xxVVx/fiKFdsHQykGsOYSzQvL/4Ao2Mm0YqwAQ4b5Okm1S5m6znSxmLvGKg6OH3XabqS2hZzWV/aQNf/4=
X-Received: by 2002:a1c:4857:: with SMTP id v84mr522503wma.96.1591210783733;
 Wed, 03 Jun 2020 11:59:43 -0700 (PDT)
References: <20200603081124.1627600-1-matthieu.baerts@tessares.net>
 <CAAej5NZZNg+0EbZsa-SrP0S_sOPMqdzgQ9hS8z6DYpQp9G+yhw@mail.gmail.com>
 <1cb3266c-7c8c-ebe6-0b6e-6d970e0adbd1@tessares.net> <20200603181455.4sajgdyat7rkxxnf@ast-mbp.dhcp.thefacebook.com>
 <3573c0dd-baa8-5313-067a-eec6b04f0f36@tessares.net>
In-Reply-To: <3573c0dd-baa8-5313-067a-eec6b04f0f36@tessares.net>
From:   Ferenc Fejes <fejes@inf.elte.hu>
Date:   Wed, 3 Jun 2020 20:59:32 +0200
X-Gmail-Original-Message-ID: <CAAej5NZZ8NE2Ya4zPC=F3rWEULWXhb1oecp5=1=SEG7Hpqc4NQ@mail.gmail.com>
Message-ID: <CAAej5NZZ8NE2Ya4zPC=F3rWEULWXhb1oecp5=1=SEG7Hpqc4NQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix unused-var without NETDEVICES
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
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
X-ClientProxiedBy: AM4PR0101CA0075.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::43) To DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:ab::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mail-wm1-f43.google.com (209.85.128.43) by AM4PR0101CA0075.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Wed, 3 Jun 2020 18:59:44 +0000
Received: by mail-wm1-f43.google.com with SMTP id r9so2938580wmh.2;        Wed, 03 Jun 2020 11:59:44 -0700 (PDT)
X-Gm-Message-State: AOAM532A6+r65W/e/c2UY9qC6w7OoE75abLF442ikAL4Os32A/glVfgR
        LzNEKOatoiogtFwv2mMX7hpYlGYPX1DfFBq9a/A=
X-Google-Smtp-Source: ABdhPJw7K2xxVVx/fiKFdsHQykGsOYSzQvL/4Ao2Mm0YqwAQ4b5Okm1S5m6znSxmLvGKg6OH3XabqS2hZzWV/aQNf/4=
X-Received: by 2002:a1c:4857:: with SMTP id v84mr522503wma.96.1591210783733;
 Wed, 03 Jun 2020 11:59:43 -0700 (PDT)
X-Gmail-Original-Message-ID: <CAAej5NZZ8NE2Ya4zPC=F3rWEULWXhb1oecp5=1=SEG7Hpqc4NQ@mail.gmail.com>
X-Originating-IP: [209.85.128.43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c28e045-74d4-4b01-7b8b-08d807f047bb
X-MS-TrafficTypeDiagnostic: DB8PR10MB3449:
X-Microsoft-Antispam-PRVS: <DB8PR10MB3449E03C8FF188D54B9B7B97E1880@DB8PR10MB3449.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKLaV46la+OLs2ihA7NBvdAPyzhFSv5hy9WF0F8msjOh4EE3p1NaWKzUhtfK40+JN6sidBszmQ3+PPF7mueFeESCZpoNnJrIZrbIi6SbKTv3ypanib3Y8zs19oOwCslAkjv4LLtHx1l/1e28U+/axG1Qh4x1QVgrOSNzNRlZkbfClMIkTua03lPDaGWHhog7LEmJphJHaCro7L3EzebghCHEWE/TXMQMtUH94NfPGYDOXD3QS1w+S6v3K8eQd8FKEn6IE8GGnhViagHiH1DSrNYEjH2Tiw9lHl9zb1+i/yN55Z7x1Uv9/4dOwKXq86Wyv621uWtZsxH1h/0iBOvLlCU3HXcTW3n4CqTAqH/EdA+ooNcWZJAaPS9b/VpqFnsXnsIGucFwgBbC1tXxVaB/GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB2652.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39850400004)(376002)(346002)(136003)(366004)(66556008)(66476007)(186003)(66574014)(66946007)(86362001)(83380400001)(26005)(8676002)(8936002)(9686003)(6862004)(42186006)(52116002)(55446002)(4326008)(53546011)(478600001)(450100002)(6666004)(2906002)(786003)(316002)(5660300002)(15974865002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yEs1Sseit496NOEHruUO7KZbxZ0tuXihkqKiPmCNBOqTEEguZd2f4O5+RGtANi9AdO08iZJBsmibgKTKjfk3Bzbtvcz640ZIqkqCVBc6Wkecv8Q0Wk6FIgC7Br4fAPLN6wNJIxVWTI6WrPXcyPqQateEfqZuNuWoqdF/LFkF0bGePK4IuQv+RrUInHqTBlxuhnCMg5VN4yyzpZ2sa2Vk941NQ8hwkI0QDsqfZWUKjnbRUg1zgqwUkhIyhJyZ4K7B5fskWfQAvTOEn/C9z4rpN6p1bJp09pTVPDEcMVQ0+blpfQLKj/FSHOQMxCHWwjHj+RcL118PkF1Scr389Ms91g0mbWe5j/iPSeSjktaLdtBd8S34JHCVH/WPaGH2i6ZXj/BbkjIl6jWDX3wqzZTV5wHCSIL/RFsYBSQplQmHYPFIzCYVe2KnuIEG1v2KfEdmTH+h6FG1QNosEMiPNO1iboG+/V0VPxfvmkGZYBpiTGo=
X-OriginatorOrg: inf.elte.hu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c28e045-74d4-4b01-7b8b-08d807f047bb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 18:59:45.1758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0133bb48-f790-4560-a64d-ac46a472fbbc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y23FamjUEpHjtt/lb1c9q5iu/X2IuK7CdyhVxYNeJp1eSiihkwqyXnv+pXSGpPlXdxuf3TqPCJxtIL3/GgD3sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3449
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Hi Alexei,
>
> On 03/06/2020 20:14, Alexei Starovoitov wrote:
> > On Wed, Jun 03, 2020 at 11:12:01AM +0200, Matthieu Baerts wrote:
> >> Hi Ferenc,
> >>
> >> On 03/06/2020 10:56, Ferenc Fejes wrote:
> >>> Matthieu Baerts <matthieu.baerts@tessares.net> ezt =C3=ADrta (id=C5=
=91pont:
> >>> 2020. j=C3=BAn. 3., Sze, 10:11):
> >>>>
> >>>> A recent commit added new variables only used if CONFIG_NETDEVICES i=
s
> >>>> set.
> >>>
> >>> Thank you for noticing and fixed this!
> >>>
> >>>> A simple fix is to only declare these variables if the same
> >>>> condition is valid.
> >>>>
> >>>> Other solutions could be to move the code related to SO_BINDTODEVICE
> >>>> option from _bpf_setsockopt() function to a dedicated one or only
> >>>> declare these variables in the related "case" section.
> >>>
> >>> Yes thats indeed a cleaner way to approach this. I will prepare a fix=
 for that.
> >>
> >> I should have maybe added that I didn't take this approach because in =
the
> >> rest of the code, I don't see that variables are declared only in a "c=
ase"
> >> section (no "{" ... "}" after "case") and code is generally not moved =
into a
> >> dedicated function in these big switch/cases. But maybe it makes sense=
 here
> >> because of the #ifdef!
> >> At the end, I took the simple approach because it is for -net.
> >>
> >> In other words, I don't know what maintainers would prefer here but I =
am
> >> happy to see any another solutions implemented to remove these compile=
r
> >> warnings :)
> >
> > since CONFIG_NETDEVICES doesn't change anything in .h
> > I think the best is to remove #ifdef CONFIG_NETDEVICES from net/core/fi=
lter.c
> > and rely on sock_bindtoindex() returning ENOPROTOOPT
> > in the extreme case of oddly configured kernels.
>
> Good idea, thank you!
> I can send a patch implementing that.

Thanks again for helping me out in this one, I'll be more careful next time=
!

>
> And sorry for the oddly configured kernels :)
> It's just used to test the compilation of the code related to MPTCP.
>
> Cheers,
> Matt
> --
> Matthieu Baerts | R&D Engineer
> matthieu.baerts@tessares.net
> Tessares SA | Hybrid Access Solutions
> www.tessares.net
> 1 Avenue Jean Monnet, 1348 Louvain-la-Neuve, Belgium
