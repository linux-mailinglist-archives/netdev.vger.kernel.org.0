Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16264E60FB
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 10:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345881AbiCXJTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 05:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237756AbiCXJTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 05:19:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B69C43F89A
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 02:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648113495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iorkotW0G40J8GO23cRrWaeU/u1Wtt1tp9nGCF4xURQ=;
        b=Qb3WDic9dSYvAHQySNQuKcAPEq0olJi2ZbUqO6hEtleSnOyhs/rVXi4PibdmJrpg3er3di
        ZNL7AFRPCFzsdyyG/XEAVu/DJbqjPuL/ZHKoVRt8OsERSq2fu/WLYQJuMINU6kdaGAZn8I
        QIB8HvyGOh5dH6J8ezKMv8fH1rujAuI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-uw6yTqU2NUC1w5v2L7M8EA-1; Thu, 24 Mar 2022 05:18:14 -0400
X-MC-Unique: uw6yTqU2NUC1w5v2L7M8EA-1
Received: by mail-wr1-f69.google.com with SMTP id p9-20020adf9589000000b001e333885ac1so1463833wrp.10
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 02:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=iorkotW0G40J8GO23cRrWaeU/u1Wtt1tp9nGCF4xURQ=;
        b=fPCaLIoGSmijuhnq2GOD8Bbzn99jhnMUs9DFw9co42KDm5cBfN/Zs0fWuMMyclf4Yl
         T6PmDS3XQKe5browgLkg0R+0IZuoij/brsY3/9U4BVSqZzO2oYQCPUwrUR4uZ2+2aTK6
         4SzyrDZgJHrdZPTqjy0PCkmadsIF4+v1Rs1Ox0WewItRiV4ABGa2rjXgMVlsQrNy+/SS
         +xdfnKjDhnljzUqKpRCk5/zQ6fcPp3o1HGsGvNsHjIxoKx6kaedC7If+e0M1vv/gx0Vj
         6YI5mGijZI08p+w+A9/lOD5MeMvECjTMZFZG8G1mxUU+A+xef/zmgvC4ST6ezWLuW7Qu
         EcHQ==
X-Gm-Message-State: AOAM5301ycCUVZ0iw9jJwNngntPIod+HszQLJSLhkF6rFFoPInBSJnpc
        vz5GL08TCTA91ttYyDmTLtRgrk25qehIekZie+wBnZij7ltuJTlmKqflim/7G92U9aY5OXeVfnO
        dfwatCXdBSSI0GQEt
X-Received: by 2002:a1c:c911:0:b0:389:8f96:28f3 with SMTP id f17-20020a1cc911000000b003898f9628f3mr13166537wmb.49.1648113493019;
        Thu, 24 Mar 2022 02:18:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYOA3daQwHsNejC/isHeHlH684GMY8kRrZWVCfLBHN8EH+zZD7EmgFNST3dyCW3E+R3wxWJg==
X-Received: by 2002:a1c:c911:0:b0:389:8f96:28f3 with SMTP id f17-20020a1cc911000000b003898f9628f3mr13166528wmb.49.1648113492802;
        Thu, 24 Mar 2022 02:18:12 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id c7-20020a5d4f07000000b00203db8f13c6sm2046761wru.75.2022.03.24.02.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 02:18:12 -0700 (PDT)
Message-ID: <a188f84e4ded43f5e5e828ba8e32d7130bec80ec.camel@redhat.com>
Subject: Re: [net-next v2] net: core: use shared sysctl macro
From:   Paolo Abeni <pabeni@redhat.com>
To:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Date:   Thu, 24 Mar 2022 10:18:10 +0100
In-Reply-To: <20220323015326.26478-1-xiangxia.m.yue@gmail.com>
References: <20220323015326.26478-1-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-03-23 at 09:53 +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> This patch introdues the SYSCTL_THREE, and replace the
> two, three and long_one to SYSCTL_XXX accordingly.
> 
>  KUnit:
>  [23:03:58] ================ sysctl_test (10 subtests) =================
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_null_tbl_data
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
>  [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_positive
>  [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_negative
>  [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_positive
>  [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_negative
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
>  [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
>  [23:03:58] =================== [PASSED] sysctl_test ===================
> 
>  ./run_kselftest.sh -c sysctl
>  ...
>  # Running test: sysctl_test_0006 - run #49
>  # Checking bitmap handler... ok
>  # Wed Mar 16 14:58:41 UTC 2022
>  # Running test: sysctl_test_0007 - run #0
>  # Boot param test only possible sysctl_test is built-in, not module:
>  # CONFIG_TEST_SYSCTL=m
>  ok 1 selftests: sysctl: sysctl.sh
> 
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Iurii Zaikin <yzaikin@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
> v2: add KUnit and selftests in commit msg
> ---
>  fs/proc/proc_sysctl.c          |  2 +-
>  include/linux/sysctl.h         | 13 +++++++------
>  net/core/sysctl_net_core.c     | 14 +++++---------
>  net/ipv4/sysctl_net_ipv4.c     | 16 ++++++----------
>  net/ipv6/sysctl_net_ipv6.c     |  6 ++----
>  net/netfilter/ipvs/ip_vs_ctl.c |  4 +---
>  6 files changed, 22 insertions(+), 33 deletions(-)

Currently we are in the merge window and net-next is accepting only
fixes. Please repost this after net-next re-open, thanks!

Paolo

