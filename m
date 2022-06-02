Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7270153BCCC
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237110AbiFBQtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236916AbiFBQtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:49:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAB413391F
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:49:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d12-20020a17090abf8c00b001e2eb431ce4so5317205pjs.1
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 09:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x6W9lqOABj/IuyeX/kEf3h2qYQIbL/JOqbOELG9BS8g=;
        b=MI25gcOh3o0jeE9iRB1jEklqftYxtPF+uGqvh7/9FBYYUQTIXLYZcgSQBHAmLA9xxH
         H0pWozl/YTIogFh6TwCva5aWnPO5ZmvjAdyBvbyh6vIIRLjlPd0k2KZTc9kIxQ2Ra1hE
         0/GZTBxz0kRi5dJsLcYzHvi+hhT1Z6aP/38yiEWDDcsPrrB+ys9uxake067el3jocuiS
         u2dCZHr3HZ2cyIIpCgQh8LoiA3t7S4lqkKHGCdF6je52q1hGR32piQo8QdQrL+cdguae
         rRoDFw/4khI2HwySDC42PqMLnIaBqpHohrVtyVJ6kj8RiN1+nV9uRzImY5k2pr8p71sH
         ibeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x6W9lqOABj/IuyeX/kEf3h2qYQIbL/JOqbOELG9BS8g=;
        b=DRnatDPBIQGTEaLNTBnq6+59omSJh5IYnDyZNV3RCFqgR2Db0cGk0s88mUjvKMvOER
         hm+jhRw4nmU1QLdxh3qw7iOP+cTZDXMhW8CZoBDo1z8C1AOE48XA8mGBlB+EcfAEpeRy
         Ne+Yku5T2YTjlwWKPBokQMVQbX+P8OahcuC3RziPebEI7zH1ILHnVZSq9q7aDuHEgr+P
         pzX3r33ZuDFy6KTDTPXNg3vst4NWjF3ID/7r94hKxbDBGK0b3MCPGkxK1ukTgLdAgmTU
         ZgsiRAyer0H0Uu5tjDz4m7J6OLnXbLi1yVUibhO5KBz7LMRil9wnhIfLzL7B/p9AC36c
         eFMg==
X-Gm-Message-State: AOAM531fHzG5mXFrFiCT5WEVLiPDntAVQ/j+mYdLDk9iJ8iueGgCRKC4
        3NSAs7a6aeU9zeOL+U5shbzKzzWRcj/gK3qpmH1t5g==
X-Google-Smtp-Source: ABdhPJzZbQNzSLyrWCzYUf6AavVw+4iamqCLVs6JaX/QzHUCTWUfxe7t9Tk6WIBs1yTmYTJR7utPd5kI5BaAS34u3XU=
X-Received: by 2002:a17:902:cec2:b0:166:4e45:e1b2 with SMTP id
 d2-20020a170902cec200b001664e45e1b2mr1467444plg.73.1654188551460; Thu, 02 Jun
 2022 09:49:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220601190218.2494963-4-sdf@google.com> <202206021403.M9hFZdbY-lkp@intel.com>
In-Reply-To: <202206021403.M9hFZdbY-lkp@intel.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 2 Jun 2022 09:49:00 -0700
Message-ID: <CAKH8qBsyR1tJnLcJc=0p7Qxbh+nRGX0h+bb1STS6_=qA9iFVjw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 03/11] bpf: per-cgroup lsm flavor
To:     kernel test robot <lkp@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 11:17 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Stanislav,
>
> Thank you for the patch! Perhaps something to improve:

This is a config without CONFIG_BPF_LSM and it makes CGROUP_LSM_START
greater than CGROUP_LSM_END (to make sure we don't
waste slots on non-CONFIG_BPF_LSM builds) and it screws up
(atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END) check.
I'll add an ifdef around that.


> [auto build test WARNING on bpf-next/master]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220602-050600
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: i386-randconfig-a004 (https://download.01.org/0day-ci/archive/20220602/202206021403.M9hFZdbY-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project b364c76683f8ef241025a9556300778c07b590c2)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/584b25fdd30894c312d577f4b6b83f93d64e464b
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220602-050600
>         git checkout 584b25fdd30894c312d577f4b6b83f93d64e464b
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash kernel/bpf/
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> kernel/bpf/cgroup.c:257:35: warning: overlapping comparisons always evaluate to false [-Wtautological-overlap-compare]
>                                    if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
>                                        ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
>    kernel/bpf/cgroup.c:252:35: warning: overlapping comparisons always evaluate to false [-Wtautological-overlap-compare]
>                                    if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
>                                        ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
>    2 warnings generated.
>
>
> vim +257 kernel/bpf/cgroup.c
>
>    226
>    227  /**
>    228   * cgroup_bpf_release() - put references of all bpf programs and
>    229   *                        release all cgroup bpf data
>    230   * @work: work structure embedded into the cgroup to modify
>    231   */
>    232  static void cgroup_bpf_release(struct work_struct *work)
>    233  {
>    234          struct cgroup *p, *cgrp = container_of(work, struct cgroup,
>    235                                                 bpf.release_work);
>    236          struct bpf_prog_array *old_array;
>    237          struct list_head *storages = &cgrp->bpf.storages;
>    238          struct bpf_cgroup_storage *storage, *stmp;
>    239
>    240          unsigned int atype;
>    241
>    242          mutex_lock(&cgroup_mutex);
>    243
>    244          for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
>    245                  struct hlist_head *progs = &cgrp->bpf.progs[atype];
>    246                  struct bpf_prog_list *pl;
>    247                  struct hlist_node *pltmp;
>    248
>    249                  hlist_for_each_entry_safe(pl, pltmp, progs, node) {
>    250                          hlist_del(&pl->node);
>    251                          if (pl->prog) {
>    252                                  if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
>    253                                          bpf_trampoline_unlink_cgroup_shim(pl->prog);
>    254                                  bpf_prog_put(pl->prog);
>    255                          }
>    256                          if (pl->link) {
>  > 257                                  if (atype >= CGROUP_LSM_START && atype <= CGROUP_LSM_END)
>    258                                          bpf_trampoline_unlink_cgroup_shim(pl->link->link.prog);
>    259                                  bpf_cgroup_link_auto_detach(pl->link);
>    260                          }
>    261                          kfree(pl);
>    262                          static_branch_dec(&cgroup_bpf_enabled_key[atype]);
>    263                  }
>    264                  old_array = rcu_dereference_protected(
>    265                                  cgrp->bpf.effective[atype],
>    266                                  lockdep_is_held(&cgroup_mutex));
>    267                  bpf_prog_array_free(old_array);
>    268          }
>    269
>    270          list_for_each_entry_safe(storage, stmp, storages, list_cg) {
>    271                  bpf_cgroup_storage_unlink(storage);
>    272                  bpf_cgroup_storage_free(storage);
>    273          }
>    274
>    275          mutex_unlock(&cgroup_mutex);
>    276
>    277          for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
>    278                  cgroup_bpf_put(p);
>    279
>    280          percpu_ref_exit(&cgrp->bpf.refcnt);
>    281          cgroup_put(cgrp);
>    282  }
>    283
>
> --
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
