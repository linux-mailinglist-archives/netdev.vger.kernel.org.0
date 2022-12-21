Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36205653598
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 18:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiLURuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 12:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiLURuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 12:50:02 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7090AB3D
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 09:50:01 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so3096674pjj.2
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 09:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0okM7NEH56GTLxrsjv/YOjxBUK47FbcHwJd4q/7wuwc=;
        b=r4lH5LeYghxEzkjEKOKSPOpc0vK/et2vfbW3dmlbnk1REJkKOzQCA7hZrEHp6jCUqQ
         uMJHyNonZmLJWeOsaPh8IiXXI6tLhq7z8kSNqDJ+oQZRQGJX0cyNX0IaHBCW+DYp3t93
         Gxlk5v/1xidZpNvOumnvx+saJ+5LfMkfrLGqhgvMymffdrOpbTxOE3Ecf6f7b0F8h4RZ
         GXlB0T0uHmd6e9ako0won5PJYZ1goLhR0GXU2L5bRMcAN8f1sMRFGX7KdYYaqqrxesQX
         GJutFsZ6/FN9ThNzO/TwSunRd983i4FVpU2pOmyyeq/OWFNJxHtp2TA0OzDLy1zRB+f4
         J/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0okM7NEH56GTLxrsjv/YOjxBUK47FbcHwJd4q/7wuwc=;
        b=qVtXx1y7KB+q10qD3SI2aNAoFdI38hjmhpSpCG1sn9faSSgGoxekJFqWkRYE6qVVGD
         SYuS9DRsMWbnfg9C2UGCvdgz7MLLZ9MISFc3KRGWaFjZ3D0sMIJhDjJaIEOLbDJYc5CZ
         rgaflKDniQZ6/I+Kg2rypgIFsJeUzZLbJNEeSeCXYqrCvPF/3LG2iI7rkO+6zOJG9WJT
         oFIebT5f2poQ88qL5zOLBBbkn6mS32QK1KKDrf/zrJrz24PvbGJpC4iQph4lusUSQB8H
         0g8z62oOs3hg+8P050FbNHZIRmsWdpv0mn7bxPyXmuab9GKNXUoqLAEURVPjWKFzHtJm
         Z2Ig==
X-Gm-Message-State: AFqh2kq02jVs2BE2WL9ejkAWclbepIaCYsifpcbWdYvzRQA0vdOMvLiT
        Ddq1U3mNaivbcv9WLp38f/jJuTu8hZfxyYTi6yjWwA==
X-Google-Smtp-Source: AMrXdXt4va1LWYg05e9TZvMFRB9O6tjGCTg8ZU2ZeuInrCz0REtR64vqnk18LhwpYQQR7Wx7cI12zyqbtLeerbbvgIo=
X-Received: by 2002:a17:903:2696:b0:189:e426:463e with SMTP id
 jf22-20020a170903269600b00189e426463emr121651plb.134.1671645000756; Wed, 21
 Dec 2022 09:50:00 -0800 (PST)
MIME-Version: 1.0
References: <20221220222043.3348718-8-sdf@google.com> <202212211311.e2ZWQLue-lkp@intel.com>
In-Reply-To: <202212211311.e2ZWQLue-lkp@intel.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 21 Dec 2022 09:49:49 -0800
Message-ID: <CAKH8qBtJgxqUvbf9DVr-eXF_rRF58fpfQsvFFt5bdQ+UZC+D5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 07/17] bpf: XDP metadata RX kfuncs
To:     kernel test robot <lkp@intel.com>
Cc:     bpf@vger.kernel.org, oe-kbuild-all@lists.linux.dev, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 9:44 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Stanislav,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on bpf-next/master]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/xdp-hints-via-kfuncs/20221221-110542
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> patch link:    https://lore.kernel.org/r/20221220222043.3348718-8-sdf%40google.com
> patch subject: [PATCH bpf-next v5 07/17] bpf: XDP metadata RX kfuncs
> config: ia64-allyesconfig
> compiler: ia64-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/f0946bf20669262734baef03ae12ef189c9c9292
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Stanislav-Fomichev/xdp-hints-via-kfuncs/20221221-110542
>         git checkout f0946bf20669262734baef03ae12ef189c9c9292
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash kernel/bpf/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> kernel/bpf/verifier.c:2084:5: warning: no previous prototype for 'bpf_dev_bound_kfunc_check' [-Wmissing-prototypes]
>     2084 | int bpf_dev_bound_kfunc_check(struct bpf_verifier_env *env,
>          |     ^~~~~~~~~~~~~~~~~~~~~~~~~

Oops, this should be "static int bpf_dev_bound_kfunc_check" :-(



> vim +/bpf_dev_bound_kfunc_check +2084 kernel/bpf/verifier.c
>
>   2083
> > 2084  int bpf_dev_bound_kfunc_check(struct bpf_verifier_env *env,
>   2085                                struct bpf_prog_aux *prog_aux)
>   2086  {
>   2087          if (!bpf_prog_is_dev_bound(prog_aux)) {
>   2088                  verbose(env, "metadata kfuncs require device-bound program\n");
>   2089                  return -EINVAL;
>   2090          }
>   2091
>   2092          if (bpf_prog_is_offloaded(prog_aux)) {
>   2093                  verbose(env, "metadata kfuncs can't be offloaded\n");
>   2094                  return -EINVAL;
>   2095          }
>   2096
>   2097          return 0;
>   2098  }
>   2099
>
> --
> 0-DAY CI Kernel Test Service
> https://01.org/lkp
