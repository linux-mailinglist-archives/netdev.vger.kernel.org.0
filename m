Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A21350AB91
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442516AbiDUWkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241336AbiDUWkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:40:40 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8493D43EE4;
        Thu, 21 Apr 2022 15:37:49 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s14so6842346plk.8;
        Thu, 21 Apr 2022 15:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TGnA1HghBHzaSRRxb3yDXY7uSkV0l4dlxYm07Mzp3eI=;
        b=dFLWUJYXH3dFISAztAecv3Yf1mdemauc2q2OxHs3xuKtNlSr8LppwaIILxfTl/CNyR
         kr3THRthZfoHqEj/5OGLdycki5BRTSoCriRigD1l0TtUqzKqN6uI3LzFSDvVctO3E1RE
         NCAtYPJ4GhVtCp3b/XFDm4PNopKSQONjpmTayoBiOEG7uwfZm/v745lmKWTdqS0mmKGO
         t58jj8zjJLgWKNup0fbSpaSCt5i1Ec+cPtsCYrHiVS3VT5hRArzMIlfGmVnBBqpGcYCJ
         iMwDqG7VnTYEDh46pkMd9Lk8zPW49PsPzUD5sN9IxcfZCtjbqN7VbItpzPg0+jwGmXnc
         PYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=TGnA1HghBHzaSRRxb3yDXY7uSkV0l4dlxYm07Mzp3eI=;
        b=bBv45CFsheNbKCWBxLWUX7fevJ1HpvNDF0xtl1Qf8PpR//dzL3/AUl3RMRrVpT6oEH
         bxM2aq0bNBE4InSQYX6Ir5HKBNYhRZPPftX3YYWX2O+iWxC5NxomPc5TlpLvY2M8J7YR
         NJikwukYBF6HpT9Ak6vgWLIe48Q8trudnxAn/fbZYa4m+ZllTxtKwlMegHtAm+O100Zl
         Is2IrYe3ZQRaHG1ZNGQHcU/T2H/n2gpuEB6xgv72om4k2HaEg0oZYbgZoDyPLJy9F57z
         mf9p4IZqiaAuh2wAJv0+fPPE2aXkzVZovLTAPszLyYY57yMIeoem83NFxA5Hr0Wvp5Xy
         Faww==
X-Gm-Message-State: AOAM533oJDeHuzZakzs86R+xkbnV/3TR2dKfg9+i6BThUptOMqjZPpM6
        0vKnuMebVd1nP6P96iSSjtQ=
X-Google-Smtp-Source: ABdhPJyNyMh4f9ttsXoUCQvgvV3/EczKj7xpB1seRJ+GIVxpp3qneANx5XSejTG4GOcpcOVRgP+Mfg==
X-Received: by 2002:a17:90a:1d0e:b0:1cb:50ec:27f with SMTP id c14-20020a17090a1d0e00b001cb50ec027fmr12881829pjd.195.1650580668980;
        Thu, 21 Apr 2022 15:37:48 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:15fa])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004f7e3181a41sm143768pfc.98.2022.04.21.15.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 15:37:48 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 21 Apr 2022 12:37:46 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Bui Quang Minh <minhquangbui99@gmail.com>
Cc:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        cgroups@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] cgroup: Kill the parent controller when its last
 child is killed
Message-ID: <YmHcuuhKYfjI8nXA@slm.duckdns.org>
References: <20220404142535.145975-1-minhquangbui99@gmail.com>
 <Ykss1N/VYX7femqw@slm.duckdns.org>
 <20220405091158.GA13806@blackbody.suse.cz>
 <bdd4104d-390e-74c7-0de1-a275044831a5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdd4104d-390e-74c7-0de1-a275044831a5@gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 09:58:01PM +0700, Bui Quang Minh wrote:
> @@ -5152,12 +5153,28 @@ static void css_release_work_fn(struct work_struct
> *work)
>                 container_of(work, struct cgroup_subsys_state,
> destroy_work);
>         struct cgroup_subsys *ss = css->ss;
>         struct cgroup *cgrp = css->cgroup;
> +       struct cgroup *parent = cgroup_parent(cgrp);
> 
>         mutex_lock(&cgroup_mutex);
> 
>         css->flags |= CSS_RELEASED;
>         list_del_rcu(&css->sibling);
> 
> +       /*
> +        * If parent doesn't have any children, start killing it.
> +        * And don't kill the default root.
> +        */
> +       if (parent && list_empty(&parent->self.children) &&
> +           parent->flags & CGRP_UMOUNT &&
> +           parent != &cgrp_dfl_root.cgrp &&
> +           !percpu_ref_is_dying(&parent->self.refcnt)) {
> +#ifdef CONFIG_CGROUP_BPF
> +               if (!percpu_ref_is_dying(&cgrp->bpf.refcnt))
> +                       cgroup_bpf_offline(parent);
> +#endif
> +               percpu_ref_kill(&parent->self.refcnt);
> +       }
> +
>         if (ss) {
>                 /* css release path */
>                 if (!list_empty(&css->rstat_css_node)) {
> 
> The idea is to set a flag in the umount path, in the rmdir it will destroy
> the css in case its direct parent is umounted, no recursive here. This is
> just an incomplete example, we may need to reset that flag when remounting.

I'm generally against adding complexities for this given that it's never
gonna be actually reliable. If adding one liner flush_workqueue makes life
easier in some cases, why not? But the root cause is something which can't
be solved from messing with release / umount paths and something we decided
against supporting.

Thanks.

-- 
tejun
