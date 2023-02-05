Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB3D68AE2B
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 04:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjBEDfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 22:35:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBEDfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 22:35:01 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2923AB2
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 19:34:59 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-4c24993965eso118248177b3.12
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 19:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fcwD730JuegJS9ZrkIlmvCTSQQeySoHb1pg0TjvLj4k=;
        b=K5ih6AUOASfJQCxBzijpSTnTup+RVfJjyiSgYPmG0SCljR71HsUqWISpsex0ufKKO+
         B3yoNExk3zcU8LjbNYso/tu4uOmdrVFsc1UlCg7qOAVPFAxtBbR2pGGDluRLpHui0MMp
         XsaUOfyDJ3QYaQ1Iv56+obvzlO1e5s4H3f133F3bgwLW08NA+sJiEhGQn1F+IcM4mjZa
         YbkerwBqYs2LmuAI14bkWNGIFdHttaKJngL8XIf0OfuLWnK429kwWwQ5mOLHMZ7IlmCV
         va2BDkDfRep7MhCZGJ/7GQM4QD1Ncj6OTeXE1Dzqs66lEI+zF4WjsY7GwuROZQBkP33T
         bHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fcwD730JuegJS9ZrkIlmvCTSQQeySoHb1pg0TjvLj4k=;
        b=NbFrJ2huEZoqbNU7ECyREaOS959oSHLeTvaovC2bbEN/TQBnCcpnUQgcPq2YW1acmR
         R0SfVqV6m6ZQ8KB2UEM3193CvK5Ww3Po03P1lO9te+9vlLN5isIsB2iCULbsDHUoqQKu
         eJa6Vvn5pWOLCcLiG0g7LC0CI7n+26uuoDtWSWUHhuW8N8vQ0XkbUzn159tcVoTyQRPr
         nj+Zybxy/+VoJroKMJbtnq/6vu0kC9JqH89RqgOOsYJah8h9cJl8ycPiR47apxf889Yn
         bmNghzSx8VFoqbNApTPiJN8NNXagijqBhtMEk3REFTOOrh4W1XmwgPC2nxdzscq2vKF7
         MwwA==
X-Gm-Message-State: AO0yUKVI1fVQMX78c2wQZMzvpQobnnaug+Q0qGh7lc8mte48Ds+qFmIq
        VstOGSSuzR25a1MPMVOXMNYCKjpG4o2W9jGGt2cMA9GEMH74zQ==
X-Google-Smtp-Source: AK7set/WMVjziLschXh8TLMwDh9aQwxEyvuoYBxqceAIqUq1zHx5v9hq4fKwGe2bi4B+cgYFROlNzsvAvh028s1pXeI=
X-Received: by 2002:a0d:d94e:0:b0:526:bfed:89ca with SMTP id
 b75-20020a0dd94e000000b00526bfed89camr595368ywe.171.1675568098565; Sat, 04
 Feb 2023 19:34:58 -0800 (PST)
MIME-Version: 1.0
References: <6eca3cf10a8c06f733fac943bcb997c06ec5daa3.1675548023.git.lucien.xin@gmail.com>
 <202302050823.JwxMWCH9-lkp@intel.com>
In-Reply-To: <202302050823.JwxMWCH9-lkp@intel.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 4 Feb 2023 22:34:37 -0500
Message-ID: <CADvbK_fVBubU7cdrSa_PGGATU8WxAmjSA_F=MR2GmAATjqUqYA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] net: create nf_conntrack_ovs for ovs and tc use
To:     kernel test robot <lkp@intel.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 4, 2023 at 8:11 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Xin-Long/net-create-nf_conntrack_ovs-for-ovs-and-tc-use/20230205-060514
> patch link:    https://lore.kernel.org/r/6eca3cf10a8c06f733fac943bcb997c06ec5daa3.1675548023.git.lucien.xin%40gmail.com
> patch subject: [PATCH net-next 1/5] net: create nf_conntrack_ovs for ovs and tc use
> config: s390-defconfig (https://download.01.org/0day-ci/archive/20230205/202302050823.JwxMWCH9-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/e2bb7f965a86f833a4ae6ec28444ba328fdfc358
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Xin-Long/net-create-nf_conntrack_ovs-for-ovs-and-tc-use/20230205-060514
>         git checkout e2bb7f965a86f833a4ae6ec28444ba328fdfc358
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>, old ones prefixed by <<):
>
> >> ERROR: modpost: "nf_ct_helper" [net/openvswitch/openvswitch.ko] undefined!
> >> ERROR: modpost: "nf_ct_add_helper" [net/openvswitch/openvswitch.ko] undefined!
>
caused by:

+       select NF_CONNTRACK_OVS if NF_NF_CONNTRACK

"NF_NF_CONNTRACK", incorrect option name was used, will fix it.
The same cause is for Patch 2/5 and 5/5.

Thanks.
