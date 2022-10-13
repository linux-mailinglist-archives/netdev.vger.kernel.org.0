Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75735FE383
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 22:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJMUwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 16:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiJMUwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 16:52:09 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9283D32DA9
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 13:52:07 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ot12so6535534ejb.1
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 13:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Ua2pyR2RXrZSoFLziseD0y4VLxWwGSmbAF9fIZqn7t0=;
        b=t40RR9oDpBYTG23J6NgBk2i4Egsa19IbkYa3W0cox3NokLbJ0Ih4dirumyjunRD7zS
         ZYuXFKve9SJYdwkrx+K+86ffsk0ngbeohzGKhElq7nWfUL1aouUgRbLWFI/65qbGupI/
         zKOQeBmVDYQuPvuh9qsheu7BbXYrg6WxxRbjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ua2pyR2RXrZSoFLziseD0y4VLxWwGSmbAF9fIZqn7t0=;
        b=A/82zwyrZ7fsHKdcEDH2Gl2zclzSy7mYyr0wkQ3iLTkOcm/cS/HsZPI6xUc/YMAu5S
         0UfSadaXMRL7jHtqDrzWIY3ogRUKdTztgLMhP+GY84Wz6cT/RZac8Yf01cRKExWgLiCk
         Oi46QNHsBIYCmwqtH7WkFC6806JqiEieu38Ul2PzaHc4ZqaKmqksW4LvZz+3ijWGXZr3
         iYPOQ2ET3na5LZxewIMUzeIk2Q6sw6ACCtkUPf4yxnCuwOMOjCyEQ+/ju9bV25yIFhk9
         JcXvuVmuEUCuSX3OyO7ZyYDqiLL03TjewVBYujSu9m66PzW3W/NttXJd4VvQGoPgMmWI
         O/9A==
X-Gm-Message-State: ACrzQf1V312ckUyG7A+8bbcab4k2iDfl9P4lUDVxA/TmeUacevkpr8mY
        W964Igrvf5Ze1Bsdw0Z21nTPuw==
X-Google-Smtp-Source: AMsMyM60S5hCOmlxJOf1765NN6g7CVJ/ljJ87Ia5lGawADbbKflnYFXWX2wfm65nwacHKCspJ0qyFQ==
X-Received: by 2002:a17:907:94c7:b0:78e:1c4f:51f9 with SMTP id dn7-20020a17090794c700b0078e1c4f51f9mr1244290ejc.200.1665694326062;
        Thu, 13 Oct 2022 13:52:06 -0700 (PDT)
Received: from cloudflare.com (79.191.60.152.ipv4.supernova.orange.pl. [79.191.60.152])
        by smtp.gmail.com with ESMTPSA id p6-20020a05640243c600b0045b4b67156fsm456398edc.45.2022.10.13.13.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 13:52:05 -0700 (PDT)
References: <Y0csu2SwegJ8Tab+@google.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     sdf@google.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Subject: Re: Lockdep warning after c0feea594e058223973db94c1c32a830c9807c86
Date:   Thu, 13 Oct 2022 22:39:08 +0200
In-reply-to: <Y0csu2SwegJ8Tab+@google.com>
Message-ID: <87bkqfigzv.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stan,

On Wed, Oct 12, 2022 at 02:08 PM -07, sdf@google.com wrote:
> Hi John & Jakub,
>
> Upstream commit c0feea594e05 ("workqueue: don't skip lockdep work
> dependency in cancel_work_sync()") seems to trigger the following
> lockdep warning during test_prog's sockmap_listen:
>
> [  +0.003631] WARNING: possible circular locking dependency detected

[...]

> Are you ware? Any idea what's wrong?
> Is there some stable fix I'm missing in bpf-next?

Thanks for bringing it up. I didn't know.

The mentioned commit doesn't look that fresh

commit c0feea594e058223973db94c1c32a830c9807c86
Author: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date:   Fri Jul 29 13:30:23 2022 +0900

    workqueue: don't skip lockdep work dependency in cancel_work_sync()

... but then it just landed not so long ago, which explains things:

$ git describe --contains c0feea594e058223973db94c1c32a830c9807c86 --match 'v*'
v6.0-rc7~10^2

I've untangled the call chains leading to the potential dead-lock a
bit. There does seem to be a window of opportunity there.

psock->work.func = sk_psock_backlog()
  ACQUIRE psock->work_mutex
    sk_psock_handle_skb()
      skb_send_sock()
        __skb_send_sock()
          sendpage_unlocked()
            kernel_sendpage()
              sock->ops->sendpage = inet_sendpage()
                sk->sk_prot->sendpage = tcp_sendpage()
                  ACQUIRE sk->sk_lock
                    tcp_sendpage_locked()
                  RELEASE sk->sk_lock
  RELEASE psock->work_mutex

sock_map_close()
  ACQUIRE sk->sk_lock
  sk_psock_stop()
    sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED)
    cancel_work_sync()
      __cancel_work_timer()
        __flush_work()
          // wait for psock->work to finish
  RELEASE sk->sk_lock

There is no fix I know of. Need to think. Ideas welcome.

CC Cong, just FYI, because we did rearrange the locking scheme in [1].

However it looks to me like the dead-lock was already there before that.

[1] https://lore.kernel.org/bpf/20210331023237.41094-5-xiyou.wangcong@gmail.com/
