Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13651520AFD
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiEJCNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiEJCNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:13:12 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAE728ED32
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:09:16 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2ec42eae76bso164377597b3.10
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 19:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fv6X+Zc0p2gwoXCIeXKw33tCkpwcCdlPnPRrEK2hqbE=;
        b=q5CtSyrZa2Efxc9UT8pnEvDqam33uRo6sj0j/jGlFzrF4KpOwxWB0O59AtfVxS7jBK
         VJtmLTuzAiaep4hHRRQM9e9aDfnIAmDqKB84LD+gdISkPQbH6+Cdcn6jr+bAJYtZu/Sm
         1S2c1CsJO9CfitIkvMBCMx8LIDGYxmCZjyZ7wb4vyoyiYI9XntJnM4TpmIj3K0lYo0mJ
         +PHpT4VqP9tKckxoKysNJ0uGtQlGZN8jNaZAFsbZ96KMfey2ZcXS1DxeF3s7PUYeomiw
         Ao1uECYEDTVR7oncTollYJSmLMG/lTEa1uVyMojBuSnRQP+DZqfCUuwjZNX78/MNxu3A
         Q0Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fv6X+Zc0p2gwoXCIeXKw33tCkpwcCdlPnPRrEK2hqbE=;
        b=BUtzR6acanypqLnCdu2BS73W08ULvg4kmD20kzwdXRF7NBbLInQTEhC/PS4yImFr2x
         CMkzmcrEZIWI7APh0z2qbf+mVV8J65s8qoaO00JaesyBCfAbT9yksHRVocLuXgxQPiz9
         LblfsC5JF5/7T/eaIkTqxNP+oeVZ/aXDpg1PbLAXu2B89AJ8g6OrEdfZa7JFSve0jtoz
         RjXJygymSvR8Rd1lAh0Nq8og2Yr8NMu0vM20plwnyfz/uw6Bzvk1XP/phoSeRjCRAlzp
         m4+SQ+nd7T4D6gJnvA1jwGt/XNnuAVPc6V0SXZCjM86ecNzLJiWvh09Q5xiI0Kbuvgh/
         BHiw==
X-Gm-Message-State: AOAM530mRP6WrW+a75ptTZLPa2q4c8rHPvsr7oHTfsNWUz0Kepmtg3EW
        EJE4iknxcRsIuofg0Y+mD1bRL5Wueq1ERvscCYE/bg==
X-Google-Smtp-Source: ABdhPJySlWJDcyOnZ3wfCzTkbYSwbpeC7HpgHCOUI66GMKJf5uDOsy8PGKvHoYoCLYu/zvB4E35pbgIBW0LttuW0/FE=
X-Received: by 2002:a81:1d4e:0:b0:2f7:be8b:502e with SMTP id
 d75-20020a811d4e000000b002f7be8b502emr17382058ywd.278.1652148555603; Mon, 09
 May 2022 19:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220509222149.1763877-3-eric.dumazet@gmail.com> <202205100923.RHeXqtNd-lkp@intel.com>
In-Reply-To: <202205100923.RHeXqtNd-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 19:09:04 -0700
Message-ID: <CANn89i+uKcuJDxfZ7zNHrrj3QKHojfdv42S+DbFhFAeO-DCcSA@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 02/13] net: allow gso_max_size to exceed 65536
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 6:36 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Eric,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/tcp-BIG-TCP-implementation/20220510-062530
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9c095bd0d4c451d31d0fd1131cc09d3b60de815d
> config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220510/202205100923.RHeXqtNd-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/8f9b47ee99f57d1747010d002315092bfa17ed50
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Eric-Dumazet/tcp-BIG-TCP-implementation/20220510-062530
>         git checkout 8f9b47ee99f57d1747010d002315092bfa17ed50
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/net/inet_sock.h:22,
>                     from include/net/ip.h:29,
>                     from include/linux/errqueue.h:6,
>                     from net/core/sock.c:91:
>    net/core/sock.c: In function 'sk_setup_caps':
> >> include/net/sock.h:389:37: error: 'struct sock_common' has no member named 'skc_v6_rcv_saddr'; did you mean 'skc_rcv_saddr'?
>      389 | #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
>          |                                     ^~~~~~~~~~~~~~~~
>    net/core/sock.c:2317:72: note: in expansion of macro 'sk_v6_rcv_saddr'
>     2317 |                              !sk_is_tcp(sk) || ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)))
>          |                                                                        ^~~~~~~~~~~~~~~
>
>

Alexander used :

+                       if (sk->sk_gso_max_size > GSO_LEGACY_MAX_SIZE &&
+                           (!IS_ENABLED(CONFIG_IPV6) || sk->sk_family
!= AF_INET6 ||
+                            !sk_is_tcp(sk) ||
ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)))
+                               sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;

I guess we could simply allow gso_max_size to be bigger than
GSO_LEGACY_MAX_SIZE only
if IS_ENABLED(CONFIG_IPV6)

So the above code could really be:

#if IS_ENABLED(CONFIG_IPV6)
                       if (sk->sk_gso_max_size > GSO_LEGACY_MAX_SIZE &&
                           (sk->sk_family != AF_INET6 ||
                            !sk_is_tcp(sk) ||
ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)))
                               sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
#endif
