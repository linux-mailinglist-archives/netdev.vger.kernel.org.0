Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3A84B3B23
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 12:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbiBMLaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 06:30:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235444AbiBMLaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 06:30:16 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89BB5B3FD;
        Sun, 13 Feb 2022 03:30:10 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id w8so12197232qkw.8;
        Sun, 13 Feb 2022 03:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MAfft3qmYdHyDeHQqAY1bu6qA/uvI67RzIoiDqXVrwg=;
        b=bJ6080+aUdvRvFz0f0PQnVLJEF40Ek9bt8KCHIsuVt6xt8GbHOrSGrc8mtz3x4x5AS
         o379rTSUeYP36W3e17qd1u7HNhpmGlrWGRgvVo31AYxBd8GOF5EOOH83bhE73rWFBlQM
         +g3hyhhTOd0bS7bFKNKSbqktHZkrw7I2N+4Heccob7U45ivu5viRm5V9rZrFR1wI/jHU
         B1s7yYVjNECHk9X8uaoEDqPMfqGr5kSiOA9melqEGr2retLAMXTqjDUP+Wh58uaujSO1
         HZ3COllqO85dAskowHBj9eUEYgjW3wMmyOQ4X4clVzhtfza46sZqZPBQOgsNl53yx6Y/
         QlpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MAfft3qmYdHyDeHQqAY1bu6qA/uvI67RzIoiDqXVrwg=;
        b=Bq4HDD779mQ3v9fBxRiswK3NxIGBnI5l5bKPUHfF3y6dqrlijkYqQ4FfxNMNMIij2r
         KmRV5jcxdIJb9Q5gYiUrtL5zERRcT+yDk/NA/kk3D7WOCoVKinkQ/ItsGQl2iZixby6M
         /h81I4N088jitObbt9UZHeKQvrwetjUXEb7hY2disLjOeJooGqQWGHcK6CVqcJBZGBMI
         2PHrbod587EGQh3JCcNEDx2f8i3dAFEw49Plk+34ccKKbuiKQY1fAAWkP6OZiiYSu0KS
         0oluax8wSMSmBezZgQjW09Irw7K3B3Pg/tzC2mKXotkhTKDwYVVsXIi0StKPdzA8WHBV
         27gQ==
X-Gm-Message-State: AOAM530Oj7B7IBDSp2wpOqvHtdOI5yNxuWVlUSSM3L8SN5zSyfg8AUFG
        GeNYPdK6PsWcqMqsKfRRtj6T1JjZF2R756J0ql8=
X-Google-Smtp-Source: ABdhPJy57se/vYMqokc4V9TzL0l5qGn0UBkIUYmwiJBtxO1RhqSAoE3wEiMMzcnbF0k5TBRZODlex4E53uhxsyLoYcc=
X-Received: by 2002:a05:620a:4111:: with SMTP id j17mr4600052qko.451.1644751809986;
 Sun, 13 Feb 2022 03:30:09 -0800 (PST)
MIME-Version: 1.0
References: <20220211121145.35237-2-laoar.shao@gmail.com> <202202112213.WGiJCCYD-lkp@intel.com>
In-Reply-To: <202202112213.WGiJCCYD-lkp@intel.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sun, 13 Feb 2022 19:29:34 +0800
Message-ID: <CALOAHbD03Dpok4148_n7OgJKN6iM5kSrhfAALcfaX16c4u=eXA@mail.gmail.com>
Subject: Re: [PATCH 1/4] bpf: Add pin_name into struct bpf_prog_aux
To:     kernel test robot <lkp@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 12, 2022 at 1:59 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Yafang,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on bpf/master]
> [also build test WARNING on net/master horms-ipvs/master net-next/master v5.17-rc3 next-20220211]
> [cannot apply to bpf-next/master]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Yafang-Shao/bpf-Add-more-information-into-bpffs/20220211-201319
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
> config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220211/202202112213.WGiJCCYD-lkp@intel.com/config)
> compiler: arceb-elf-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/6cd35bc70f99caee380d84f5ba9256ac5fe03860
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Yafang-Shao/bpf-Add-more-information-into-bpffs/20220211-201319
>         git checkout 6cd35bc70f99caee380d84f5ba9256ac5fe03860
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash kernel/bpf/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    kernel/bpf/inode.c: In function 'bpf_obj_do_pin':
> >> kernel/bpf/inode.c:469:24: warning: ignoring return value of 'strncpy_from_user' declared with attribute 'warn_unused_result' [-Wunused-result]
>      469 |                 (void) strncpy_from_user(aux->pin_name, pathname, BPF_PIN_NAME_LEN);
>          |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>

Thanks for the report.
I will improve it to avoid this warning.

>
> vim +469 kernel/bpf/inode.c
>
>    437
>    438  static int bpf_obj_do_pin(const char __user *pathname, void *raw,
>    439                            enum bpf_type type)
>    440  {
>    441          struct bpf_prog_aux *aux;
>    442          struct bpf_prog *prog;
>    443          struct dentry *dentry;
>    444          struct inode *dir;
>    445          struct path path;
>    446          umode_t mode;
>    447          int ret;
>    448
>    449          dentry = user_path_create(AT_FDCWD, pathname, &path, 0);
>    450          if (IS_ERR(dentry))
>    451                  return PTR_ERR(dentry);
>    452
>    453          mode = S_IFREG | ((S_IRUSR | S_IWUSR) & ~current_umask());
>    454
>    455          ret = security_path_mknod(&path, dentry, mode, 0);
>    456          if (ret)
>    457                  goto out;
>    458
>    459          dir = d_inode(path.dentry);
>    460          if (dir->i_op != &bpf_dir_iops) {
>    461                  ret = -EPERM;
>    462                  goto out;
>    463          }
>    464
>    465          switch (type) {
>    466          case BPF_TYPE_PROG:
>    467                  prog = raw;
>    468                  aux = prog->aux;
>  > 469                  (void) strncpy_from_user(aux->pin_name, pathname, BPF_PIN_NAME_LEN);
>    470                  aux->pin_name[BPF_PIN_NAME_LEN - 1] = '\0';
>    471                  ret = vfs_mkobj(dentry, mode, bpf_mkprog, raw);
>    472                  break;
>    473          case BPF_TYPE_MAP:
>    474                  ret = vfs_mkobj(dentry, mode, bpf_mkmap, raw);
>    475                  break;
>    476          case BPF_TYPE_LINK:
>    477                  ret = vfs_mkobj(dentry, mode, bpf_mklink, raw);
>    478                  break;
>    479          default:
>    480                  ret = -EPERM;
>    481          }
>    482  out:
>    483          done_path_create(&path, dentry);
>    484          return ret;
>    485  }
>    486
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org



-- 
Thanks
Yafang
