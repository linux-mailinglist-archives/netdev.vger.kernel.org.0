Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C6355A035
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 20:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiFXRfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 13:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiFXRfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 13:35:52 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4EE5DC36;
        Fri, 24 Jun 2022 10:35:51 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id fi2so6071591ejb.9;
        Fri, 24 Jun 2022 10:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nXTYb/VEQraItz0KOWT17OhbEA5WumFVtehAd8qIQ6A=;
        b=KqQZc4eT61zcBbR54MbSIX0VEPjxWIPSw1yIYDNI/sJ62iVi1iMUgHxpSAHNdJYDXu
         fNceMYeHaxpMff83Ua+hDyx7fkp9ucFrjBF80RQP7y918PK0iYhv+7dHu2ai/uLScHPP
         2hNraQUkc4PwqnEk3g1xjdncCj/x+Co86NF9nOwfxSZsSjgcg4ac9llWTwd7G/9HKiEA
         CyB0qKz+zLpotdd9Q9EFwxchAHszm61rW2V2pC9Nj1bJxIFz+S4+mYaotrtJ831yR8jQ
         VyP+8c/illY8ciuhe+Ud71yw9lexZSSc76846MxbkbYF0oM8ZUKD0trquhymhtgVpmzW
         zhkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nXTYb/VEQraItz0KOWT17OhbEA5WumFVtehAd8qIQ6A=;
        b=ARHxb1KjKQu32DmQo8JSFZ7ti32DeopNHSJbNKAiD6FwKy+VzGSTuY45nMVfjV2ZLW
         aXEZ6MXv+uXZLh68eJSC4Q2LMy81rK5bUrT41IaKrlQZUci3rPuvHdFEjCXxog0FwRW4
         zq6d31EK6t4EUOslxr9BzgVIHz0fZ/5XMbhh26bwU/1My2GIuqD+J1hy6KXVLeOrKcHP
         foQqH5i2AFW8I5vieZGboFpgx+8zr0IWe8u2Yxhge2FCU+ZdGOiB2y2geNJWI3/eN/fc
         aCgO8xItMAOZKNqBqQizIFVcBcY8/CYPqnYwKoXdBrujenVYFggyXf1aQxoTwYcKneLN
         GQ3A==
X-Gm-Message-State: AJIora+00I24d660eB1RBwtDyf/soEejU7B99JOx8dAUQKr243nc/eR0
        +WfszQQb8TB10Rlg7CBWCOfIeRIfVWE2s6dwiz8=
X-Google-Smtp-Source: AGRyM1vxcrYxcWWrhrX6XQElP3yhG0qBUdMfa/bs3Od8y1rPB9WLRKEPUZYHWIvY4Ghbf/vUIbqs1E6QqKuUaH4VENQ=
X-Received: by 2002:a17:906:2245:b0:715:7c81:e39d with SMTP id
 5-20020a170906224500b007157c81e39dmr132301ejr.262.1656092149646; Fri, 24 Jun
 2022 10:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220602041028.95124-1-xiyou.wangcong@gmail.com> <87h74aovg5.fsf@toke.dk>
In-Reply-To: <87h74aovg5.fsf@toke.dk>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Fri, 24 Jun 2022 10:35:36 -0700
Message-ID: <CAA93jw5gnYV54=dh4191qmvZaRVz6W=RsE_S6b0nRHf5UO=CNg@mail.gmail.com>
Subject: Re: [RFC Patch v5 0/5] net_sched: introduce eBPF based Qdisc
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
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

In my world, it's inbound shaping that's the biggest problem, and my
dream has long been to somehow have a way to do:

tc qdisc add dev eth0 ingress cake bandwidth 800mbit

and that be able to work across multiple cores, without act_mirred,
without any filter magic. Getting there via ebpf as in
https://github.com/rchac/LibreQoS is working for ISPs (plea, anyone
got time to make ipv6 work there?), but it's
running out of cpu for inbound shaping on the current act_mirred path
we use that's killing us.
