Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5527943BC46
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239557AbhJZVXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239532AbhJZVWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 17:22:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288E2C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 14:20:31 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id np13so446943pjb.4
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 14:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BIU4JvvXz685bAYqAG5EB9to9ul2Sb5cbPDpcAshKso=;
        b=j/9NP/yX7PNEwbFDyuvcev9c8YU36v8ZvJIUNa0ydsPu0Y7DRTh6lcnlQzQ6VtNBSz
         DNDF4J727tTzXNkrg6o4ly08402riV8kCWchdbAkiOsi9jC/SlFsEPBCAeqhN6fE8HgQ
         DnXrknBucBZBSTnrg5shQOu+U3gRWRl63+SIQbE/Sq3jQmeul5MUfDIoUQjG3GsX0s40
         vlAWZP7XoW85PJivaIgzdPII/cItL3fOKe+I2XBx5QGIkEnvLa4ktONelIAQxtTn4FQL
         SsiObQW7gkzmJbJ85E7ebu5AHj6FArICGLnjVJekSAYcsq+SP4ZlHpyIG9pj96a2ccKu
         9yow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BIU4JvvXz685bAYqAG5EB9to9ul2Sb5cbPDpcAshKso=;
        b=R5a3y5l5WdpGGw5ImfFzyaRi6w8SRzzaPyEjpTzrEGSp6KraHR4tF492XYW4ZrMeBZ
         A5iE6dUsYOHx1PAsHuJDcZu/1ieoVMPiUY4j+uXxxr6HU7+7GH79eSRA2Gw4PJk68T4D
         Is5R0kE8FqmYXoCgfelqV8rMF9jsHtcjM7HELeDPJyZLGKHM2PlSvxXDerSCr7Ggx+es
         5YVBW5ODNTDSdlqMW0yJ6NOxkynti/mvFb7Q8ki/63uowUJvqMvynuXqaoJ3RfwZ4QWZ
         QfhxFqjpNs4+viBz8vYPmtQ4tR29oy3xI6kf7aQP17pU7V5mJEoOvAhAL0GUHKx0gCke
         lDoA==
X-Gm-Message-State: AOAM530+6rBPiB1glytSyt8vLEwa1/VSXwnpniIO8w3UyUqnSyZ4CtDH
        CoZ+eDb1Gx91y77p1dtxx5zCu2XZ4AA=
X-Google-Smtp-Source: ABdhPJyNgCFgDT+EA5LIqZNMp/xhbAp0MR0SpOiCq1poOr83IQXRu/5bnL7y+2ABzBG9bv8gvIs9Ag==
X-Received: by 2002:a17:90b:390b:: with SMTP id ob11mr1296616pjb.217.1635283230205;
        Tue, 26 Oct 2021 14:20:30 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f21sm25862623pfc.203.2021.10.26.14.20.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 14:20:29 -0700 (PDT)
Subject: Re: [PATCH net-next] inet: remove races in inet{6}_getname()
To:     kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20211026173800.2232409-1-eric.dumazet@gmail.com>
 <202110270409.2AuD9qTa-lkp@intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6962a637-0772-4069-c17b-d401c7ef93d6@gmail.com>
Date:   Tue, 26 Oct 2021 14:20:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <202110270409.2AuD9qTa-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/21 1:53 PM, kernel test robot wrote:
> Hi Eric,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on net-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/inet-remove-races-in-inet-6-_getname/20211027-013901
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 6b3671746a8a3aa05316b829e1357060f35009c1
> config: csky-defconfig (attached as .config)
> compiler: csky-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/337791bc53db80fb5982e0f66be795a2d37c3d8d
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Eric-Dumazet/inet-remove-races-in-inet-6-_getname/20211027-013901
>         git checkout 337791bc53db80fb5982e0f66be795a2d37c3d8d
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross ARCH=csky 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 

Apparently there is a missing declaration in the include file.

I will include this bit in V2

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2746fd8042162c68d869bcbe210cee13bf89cf34..3536ab432b30cbeac6273d0ad8affaf9f23e3789 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -517,6 +517,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 
 #define cgroup_bpf_enabled(atype) (0)
 #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, atype, t_ctx) ({ 0; })
+#define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype) ({ 0; })
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (0)
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk,skb) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })

