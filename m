Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F74529906
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 07:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbiEQF03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 01:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiEQF01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 01:26:27 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53DE6580;
        Mon, 16 May 2022 22:26:25 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i8so2458216plr.13;
        Mon, 16 May 2022 22:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2WVonoFPACFUipe4NbRFbFN0nIUqkUG23uCq63i0slg=;
        b=kWZOdkG/WGjrNsg4LLI2XmwxAcqNqCArzdhqe6iMtZ69KhpjYOk6+iLNRtw4FykbJW
         umAmEN1y/7dY+S2CpIK5IDV3KFRO/D/VoKoAOF5x7rtB7+knZFi/IbSax8K+zOLTJ8Sy
         j8Jdgmnq4lmjtczodGEUHEaAWpFA4QLQjYzPzhdNnmb+RVi4rmwULabWH18XkTgam++L
         2+5++P4tk66RWklGfQ0bbgxya3lFy2QuVkK2VMiq3i7vpvGdU+nZ3+7t7Dqrx0sA8n2O
         k08NdQ3RhIEEqne4RqD952G79A2HidPPhIP7VPiErqQA62wzMo5XEvwGFzmA+ibCBq9I
         gXHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2WVonoFPACFUipe4NbRFbFN0nIUqkUG23uCq63i0slg=;
        b=nauF18OdH/OSO0x4uCF6DaEGqDi5OTD5QrDHvZLztJMw6v3T7jhJbVRTFgwWCm2JL2
         ojH+RMOltb7Rby8VaTzzrCyqGjAUlH+FJcBMLATTeWTVIGv4lnqanClBBcOutxfhcoCi
         R8w72XNr9HL0LblCqEWgRJlwabtRKyXpqdNffrjifY2C1yMri2dymQHE0B+L1LTgVufD
         91Si8v7waPGCsK482kWfXy5FVjX5gd/+AGioMXxVGbWYXU5+EYu9Eyd/7u1fePpm4YRs
         lx9q4ueczggRjP2a5ALtlZOUy91CH4Segy5PD4XNXQiGcsdDr0dts6UrN/6finFcKKdk
         uOaA==
X-Gm-Message-State: AOAM530y5f6W7xiomkFkPc/dzYfrRPZ7HmwB+i5041CwdFIEudloxmuw
        52OnbnEVnxl0FYxAbi0L8mSz3hTDF1Lu7UwaWec=
X-Google-Smtp-Source: ABdhPJxK1Sb9OABVsqLNuytHUY1ylQaSlSN1Hel7uikdJalz39L2h+1JgEOmorQh2bp5PA3zlxmdvjWvP0sIBL27BX4=
X-Received: by 2002:a17:902:8c8f:b0:15e:ab1c:591b with SMTP id
 t15-20020a1709028c8f00b0015eab1c591bmr21116189plo.171.1652765185372; Mon, 16
 May 2022 22:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-2-mathew.j.martineau@linux.intel.com> <20220517010730.mmv6u2h25xyz4uwl@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220517010730.mmv6u2h25xyz4uwl@kafai-mbp.dhcp.thefacebook.com>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Tue, 17 May 2022 13:26:27 +0800
Message-ID: <CA+WQbwvHidwt0ua=g67CJfmjtCow8SCvZp4Sz=2AZa+ocDxnpg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/7] bpf: add bpf_skc_to_mptcp_sock_proto
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> =E4=BA=8E2022=E5=B9=B45=E6=9C=8817=E6=97=A5=
=E5=91=A8=E4=BA=8C 09:07=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, May 13, 2022 at 03:48:21PM -0700, Mat Martineau wrote:
> [ ... ]
>
> > diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> > index 8b1afd6f5cc4..2ba09de955c7 100644
> > --- a/include/net/mptcp.h
> > +++ b/include/net/mptcp.h
> > @@ -284,4 +284,10 @@ static inline int mptcpv6_init(void) { return 0; }
> >  static inline void mptcpv6_handle_mapped(struct sock *sk, bool mapped)=
 { }
> >  #endif
> >
> > +#if defined(CONFIG_MPTCP) && defined(CONFIG_BPF_SYSCALL)
> > +struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk);
> Can this be inline ?

This function can't be inline since it uses struct mptcp_subflow_context.

mptcp_subflow_context is defined in net/mptcp/protocol.h, and we don't
want to export it to user space in net/mptcp/protocol.h.

>
> > +#else
> > +static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct so=
ck *sk) { return NULL; }
> > +#endif
> > +
> >  #endif /* __NET_MPTCP_H */
>
> [ ... ]
>
> > diff --git a/net/mptcp/bpf.c b/net/mptcp/bpf.c
> > new file mode 100644
> > index 000000000000..535602ba2582
> > --- /dev/null
> > +++ b/net/mptcp/bpf.c
> > @@ -0,0 +1,22 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Multipath TCP
> > + *
> > + * Copyright (c) 2020, Tessares SA.
> > + * Copyright (c) 2022, SUSE.
> > + *
> > + * Author: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> > + */
> > +
> > +#define pr_fmt(fmt) "MPTCP: " fmt
> > +
> > +#include <linux/bpf.h>
> > +#include "protocol.h"
> > +
> > +struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk)
> > +{
> > +     if (sk && sk_fullsock(sk) && sk->sk_protocol =3D=3D IPPROTO_TCP &=
& sk_is_mptcp(sk))
> > +             return mptcp_sk(mptcp_subflow_ctx(sk)->conn);
> > +
> > +     return NULL;
> > +}
> > +EXPORT_SYMBOL(bpf_mptcp_sock_from_subflow);
> Is EXPORT_SYMBOL needed ?

Will drop in v5.

Thanks,
-Geliang

>
