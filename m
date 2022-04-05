Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200394F3DAF
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383478AbiDEUFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452913AbiDEPzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:55:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CB6E29DC;
        Tue,  5 Apr 2022 07:58:07 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m16so409786plx.3;
        Tue, 05 Apr 2022 07:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iE/Y9WscNLHu6w2KEIZCPXwIElVoVHM0BzES9hjgoSw=;
        b=phlbuxVtZrq+ny/cBitrnv1EdI2+ifY+dU7QMLrWR4vTUYhhs5DmvkW8pGnjEt00dY
         aeztRgO/rJiLIbsJOMkp2X5p+zBpqygo3MmguP1fKSF3+Lf8WmwLmYa414Z6tbkq7PtB
         ZlM8l2daOyMhZ2URU1jsuj+cAFosdKMB1hJVwUE82ZFfIxAwOpVLrf4SjgSs9s9MuxmX
         RLSMFtHho+fNSTZvCXpwoVQPSjCeD+aUdFQhTpIpZuUCgFohEgx7bCH/+TM6bTLv0uvp
         1FIYjib+PWttI6jjFrcNZVQV5hky9BB97FMuLw/RLCV3Wb1dJv9c8ovyUbgUvR0hSBfX
         5MtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iE/Y9WscNLHu6w2KEIZCPXwIElVoVHM0BzES9hjgoSw=;
        b=4Y8cYfRBm59eJPxQZU/tfjiJh2iYvkFpS2w6Cw3TAkdNcCX3u2LyUo8GMWZH//+OjG
         cLXm69gDW4ukUPmtV0q2ivaUkRyYS9m9doGmGeiz1AVNqZX+/Q26DJZZ2EgmmYsCiz0k
         oR7b3xh0wRbVgeziLHhj14Sn38b2G5N9NX+GD80/KAwh6dTMesB13cAeHTsZLVs80sBD
         gnhpf3ZMB8uVT7fXozx1w/CFPj/L8078T8gSwsf2pT3B/aekQuFjYMaC+sv08R6at7ll
         UdhbQ1uBFcUfMWwE8PXXpZhWEHOhtMAXB8s/o2Mweyu84JALipPluLf0R99rlDUSedmX
         d7dg==
X-Gm-Message-State: AOAM531EBN1gGfLY4w/4kxFsWIlTw99VuukBrtP/UG1HjS/FqVmClVRL
        l6gcNM6UWywcb7Chrcj3pdQ=
X-Google-Smtp-Source: ABdhPJzFpTmAHMEddWr7RNGzwiIMRPlsV5EWgeWLor8A7Szuf1ubXoh5DmZkW0YKEv0eiO9ET3XgJw==
X-Received: by 2002:a17:90b:1e0e:b0:1c7:5b03:1d8b with SMTP id pg14-20020a17090b1e0e00b001c75b031d8bmr4558131pjb.121.1649170687106;
        Tue, 05 Apr 2022 07:58:07 -0700 (PDT)
Received: from [192.168.0.115] ([113.173.105.8])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a000b4a00b004fd9a6a2a39sm16660710pfo.184.2022.04.05.07.58.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:58:06 -0700 (PDT)
Message-ID: <bdd4104d-390e-74c7-0de1-a275044831a5@gmail.com>
Date:   Tue, 5 Apr 2022 21:58:01 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] cgroup: Kill the parent controller when its last child
 is killed
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>
Cc:     cgroups@vger.kernel.org, kernel test robot <lkp@intel.com>,
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
References: <20220404142535.145975-1-minhquangbui99@gmail.com>
 <Ykss1N/VYX7femqw@slm.duckdns.org> <20220405091158.GA13806@blackbody.suse.cz>
From:   Bui Quang Minh <minhquangbui99@gmail.com>
In-Reply-To: <20220405091158.GA13806@blackbody.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/22 16:11, Michal Koutný wrote:
> On Mon, Apr 04, 2022 at 07:37:24AM -1000, Tejun Heo <tj@kernel.org> wrote:
>> And the suggested behavior doesn't make much sense to me. It doesn't
>> actually solve the underlying problem but instead always make css
>> destructions recursive which can lead to surprises for normal use cases.
> 
> I also don't like the nested special-case use percpu_ref_kill().

After thinking more carefully, I agree with your points. The recursive 
css destruction only does not fixup the previous parents' metadata 
correctly and it is not a desirable behavior too.

> I looked at this and my supposed solution turned out to be a revert of
> commit 3c606d35fe97 ("cgroup: prevent mount hang due to memory
> controller lifetime"). So at the unmount time it's necessary to distinguish
> children that are in the process of removal from children than are online or
> pinned indefinitely.
> 
> What about:
> 
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2205,11 +2205,14 @@ static void cgroup_kill_sb(struct super_block *sb)
>          struct cgroup_root *root = cgroup_root_from_kf(kf_root);
> 
>          /*
> -        * If @root doesn't have any children, start killing it.
> +        * If @root doesn't have any children held by residual state (e.g.
> +        * memory controller), start killing it, flush workqueue to filter out
> +        * transiently offlined children.
>           * This prevents new mounts by disabling percpu_ref_tryget_live().
>           *
>           * And don't kill the default root.
>           */
> +       flush_workqueue(cgroup_destroy_wq);
>          if (list_empty(&root->cgrp.self.children) && root != &cgrp_dfl_root &&
>              !percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
>                  cgroup_bpf_offline(&root->cgrp);
> 
> (I suspect there's technically still possible a race between concurrent unmount
> and the last rmdir but the flush on kill_sb path should be affordable and it
> prevents unnecessarily conserved cgroup roots.)

Your proposed solution looks good to me. As with my example the flush 
will guarantee the rmdir and its deferred work has been executed before 
cleaning up in umount path.

But what do you think about

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f01ff231a484..5578ee76e789 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2215,6 +2215,7 @@ static void cgroup_kill_sb(struct super_block *sb)
                 cgroup_bpf_offline(&root->cgrp);
                 percpu_ref_kill(&root->cgrp.self.refcnt);
         }
+       root->cgrp.flags |= CGRP_UMOUNT;
         cgroup_put(&root->cgrp);
         kernfs_kill_sb(sb);
  }
@@ -5152,12 +5153,28 @@ static void css_release_work_fn(struct 
work_struct *work)
                 container_of(work, struct cgroup_subsys_state, 
destroy_work);
         struct cgroup_subsys *ss = css->ss;
         struct cgroup *cgrp = css->cgroup;
+       struct cgroup *parent = cgroup_parent(cgrp);

         mutex_lock(&cgroup_mutex);

         css->flags |= CSS_RELEASED;
         list_del_rcu(&css->sibling);

+       /*
+        * If parent doesn't have any children, start killing it.
+        * And don't kill the default root.
+        */
+       if (parent && list_empty(&parent->self.children) &&
+           parent->flags & CGRP_UMOUNT &&
+           parent != &cgrp_dfl_root.cgrp &&
+           !percpu_ref_is_dying(&parent->self.refcnt)) {
+#ifdef CONFIG_CGROUP_BPF
+               if (!percpu_ref_is_dying(&cgrp->bpf.refcnt))
+                       cgroup_bpf_offline(parent);
+#endif
+               percpu_ref_kill(&parent->self.refcnt);
+       }
+
         if (ss) {
                 /* css release path */
                 if (!list_empty(&css->rstat_css_node)) {

The idea is to set a flag in the umount path, in the rmdir it will 
destroy the css in case its direct parent is umounted, no recursive 
here. This is just an incomplete example, we may need to reset that flag 
when remounting.

Thanks,
Quang Minh.
