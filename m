Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55A758AA24
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 13:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240626AbiHELb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 07:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbiHELbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 07:31:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5469A1A817
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 04:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659699082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iJ2vojdH8FtOr3UJApDg2Ea8FrlKufBhz/SYWXyGjZg=;
        b=GLMRzlKtkY16uUuZd56fyvJRgnruNmqR/M8Ui3avKlL4NRen0QiQwi8DiKiVKFDKp9XW//
        4mmiPuthy8hns1SzjJHy5bvSNUy8MvpVZYN/j23BgHjI8TrlbvE8+rvaqXYNKHI42xaSrA
        r+4Cl+JYbAhy33l2khzI0IVROlik32k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-msbGWBtKM9GAzByWCUYbKg-1; Fri, 05 Aug 2022 07:31:19 -0400
X-MC-Unique: msbGWBtKM9GAzByWCUYbKg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D74DA108C19D;
        Fri,  5 Aug 2022 11:31:18 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 242A618EB7;
        Fri,  5 Aug 2022 11:31:17 +0000 (UTC)
Date:   Fri, 5 Aug 2022 13:31:15 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: export crash_kexec() as destructive
 kfunc
Message-ID: <Yuz/g8nONMJyiyrh@samus.usersys.redhat.com>
Mail-Followup-To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>, Jiri Olsa <olsajiri@gmail.com>,
        Song Liu <song@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>
References: <20220802091030.3742334-1-asavkov@redhat.com>
 <20220802091030.3742334-3-asavkov@redhat.com>
 <CAADnVQL7GH0MBhjTHA2xWXVzkDgdzk4RS9qS+DJ1+t1T8NkYxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQL7GH0MBhjTHA2xWXVzkDgdzk4RS9qS+DJ1+t1T8NkYxA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 04, 2022 at 01:41:53PM -0700, Alexei Starovoitov wrote:
> On Tue, Aug 2, 2022 at 2:10 AM Artem Savkov <asavkov@redhat.com> wrote:
> >
> > Allow properly marked bpf programs to call crash_kexec().
> >
> > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > ---
> >  kernel/kexec_core.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >
> > diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> > index 4d34c78334ce..9259ea3bd693 100644
> > --- a/kernel/kexec_core.c
> > +++ b/kernel/kexec_core.c
> > @@ -39,6 +39,8 @@
> >  #include <linux/hugetlb.h>
> >  #include <linux/objtool.h>
> >  #include <linux/kmsg_dump.h>
> > +#include <linux/btf.h>
> > +#include <linux/btf_ids.h>
> >
> >  #include <asm/page.h>
> >  #include <asm/sections.h>
> > @@ -1238,3 +1240,22 @@ void __weak arch_kexec_protect_crashkres(void)
> >
> >  void __weak arch_kexec_unprotect_crashkres(void)
> >  {}
> > +
> > +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> > +BTF_SET8_START(kexec_btf_ids)
> > +BTF_ID_FLAGS(func, crash_kexec, KF_DESTRUCTIVE)
> > +BTF_SET8_END(kexec_btf_ids)
> > +
> > +static const struct btf_kfunc_id_set kexec_kfunc_set = {
> > +       .owner = THIS_MODULE,
> > +       .set   = &kexec_btf_ids,
> > +};
> > +
> > +static int __init crash_kfunc_init(void)
> > +{
> > +       register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &kexec_kfunc_set);
> > +       return 0;
> > +}
> > +
> > +subsys_initcall(crash_kfunc_init);
> > +#endif
> 
> It feels there will be a bunch of such boiler plate code
> in different .c files in many places in the kernel
> if we go with this approach.
> 
> Maybe we should do one call:
> register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING
> from kernel/bpf/helper.c
> to register all tracing kfuncs ?
> 
> And gate
> BTF_ID_FLAGS(func, crash_kexec, KF_DESTRUCTIVE)
> with #ifdef CONFIG_KEXEC_CORE.
> 
> We have such a pattern in verifier.c already.

Good idea, thanks for the pointers. I'll do that in next version.

-- 
 Artem

