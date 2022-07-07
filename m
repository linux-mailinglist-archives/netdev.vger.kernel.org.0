Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E18F56AAF1
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbiGGSjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiGGSjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:39:11 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF024271D;
        Thu,  7 Jul 2022 11:39:10 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x184so7734503pfx.2;
        Thu, 07 Jul 2022 11:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xk4jif5w/j4QtqfSLIsfZH63Xsd+XRgDGsOnmU7ibig=;
        b=RrW536JT8xzuxyMjuf/Guz76azv1oh8lBOOlhG34EUvP2M12CHvP/fGsuUWkdf/nFl
         CHeRZf2jqrZWmE9IkG8pEEYDZ+AmzeocyG5RP9tx+k6kHd2co8EoUcwSDWVlmrcVCDb3
         7UkgotkgXjdaRZe6l8WOIleiCaj6p3Tst4aaRV2o9ijt8PnmQ66MWHlZdcy1IoERhBTL
         e74xmi2JfuniNvTEc9LOGuHvkHsc0Y5E6NQkG4+F76mPR+lD3sfMvvd6O2t+C1TDpsjU
         WtrIlIgRAWHqpMu+dt5O9rCRv7duBonOn9z+/q0c6k+JHK0/rq00gVzMVSC72xfBcedO
         vzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xk4jif5w/j4QtqfSLIsfZH63Xsd+XRgDGsOnmU7ibig=;
        b=HAOHtpmOVnPZZW2igb5FwLzmgfg9RqHD/x8Y8N2aOp51W8eq8Efo4ZVDmBouXG9MnK
         nCPDYXdgstIRiNixWDdZNicWiVWmpo3fK7pNWgH0RH+Mmto4BrFG8gdqEUNWm2nMKQXW
         ILjU8PNHb88mAfNhvEdz85gDWAsoh8/WGCW6Z2T+zInXtLciL82hCNxqzYhMBMBSuyzE
         ZxO37CxV6IHT3fdd2lhEQhTyieLoYpClMblXwESAs+7qWHONcMOylnun22l1N7jlmq74
         S/8G/HCGzwcPTAdmaRXXAeahjiEcvgR5yvYoAg9N0dfda+pFnGCxqxsFkOIDvrQXzzjo
         qnDg==
X-Gm-Message-State: AJIora834EWEr+4Nbw8kr3R6AsInKqzaPsKrNV/Fr5johsjdP4g276Et
        LOwkD+y8vOFbvzG+E20/NtWapekHvNJDBV69OhE=
X-Google-Smtp-Source: AGRyM1uPuQyr0jXfAty/PA/vMsGjFedz5NPQ5R2yTQDxTX0fWG+sBPIX8CbplOONr8/Hdm0jj/141gNpF3PZRzk2dno=
X-Received: by 2002:a17:903:1c4:b0:16a:73fd:3c6c with SMTP id
 e4-20020a17090301c400b0016a73fd3c6cmr53782275plh.115.1657219150361; Thu, 07
 Jul 2022 11:39:10 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b06e5505e299a9b6@google.com> <CANn89iLuGKyVcNAAjvwWk8HoJrNgZ5HM4itXEsnqzU=+xZLKOQ@mail.gmail.com>
 <CANn89iLvG0QBVkdhbC-x59ac=B=j+ZxXitBGanBo+8ThMJGG1g@mail.gmail.com> <YsW7EP45TloIyEtv@pop-os.localdomain>
In-Reply-To: <YsW7EP45TloIyEtv@pop-os.localdomain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 7 Jul 2022 11:38:59 -0700
Message-ID: <CAM_iQpVBHvO=4quf6yCbst5JNxg7GNb1hOYjmhF9HkHeR_hEaQ@mail.gmail.com>
Subject: Re: [syzbot] WARNING in sk_stream_kill_queues (8)
To:     Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Wei Wang <weiwan@google.com>
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

On Wed, Jul 6, 2022 at 9:40 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> I will look into this tonight.

The following patch could work. It uncharges the sk mem before passing skb
to recv actor but still keeps skb->sk.

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9d2fd3ced21b..c6b1effb2afd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1749,6 +1749,7 @@ int tcp_read_skb(struct sock *sk,
skb_read_actor_t recv_actor)
                int used;

                __skb_unlink(skb, &sk->sk_receive_queue);
+               WARN_ON(!skb_set_owner_sk_safe(skb, sk));
                used = recv_actor(sk, skb);
                if (used <= 0) {
                        if (!copied)
