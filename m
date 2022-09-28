Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610245EE468
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbiI1Sbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbiI1Sbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:31:31 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9638467CA6;
        Wed, 28 Sep 2022 11:31:26 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f23so12445412plr.6;
        Wed, 28 Sep 2022 11:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date;
        bh=hibxCFAnwiOUhoHkrGWBM30/+8JsGDGYmW86M7LT5HA=;
        b=V+Ma5fc+2z5h1oOWwGJjR6Oc7eYNDzTjfATQtX64XkhAEXIQB8myg+nOQwZ8pC4O4m
         0NUfGSjY1xHG6RLgrGiT9bAQM+9QmBGMXgH/LOEpny6TMXOVLFWxVumlwbf8lbR5fIN8
         0C4Y2Uu5zvuYCDzuLczH6/ZYR2Wt4sCvbPvZKEKVCL1B+d51NVw6VzR80sIn1tvyPQob
         6qQUA+egi7WIanFYVSQ+otG1SMNhIuG00AFpzqnj1g4BlHLovhl58srTtgkqSTwQBZhX
         YDgW0UBek66yz1cczgdWcpIbWyec5UDlxkTRiI8DZ7BMOxVlLR0Wqr9l3BJk8ONnVBKO
         cXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date;
        bh=hibxCFAnwiOUhoHkrGWBM30/+8JsGDGYmW86M7LT5HA=;
        b=1tUybvdiaIsU5DyNlCh+zSUqH4GdhnSiph50w2zFe1dqFzIAJLdA3xWSgRXOuC09nh
         dvcYznPVLHbIaoB3YDSUWCQP9pGbRHm9MxWMDfLJzUg4pK8M3sMQpuJPHg56dShejd8m
         bDnvqEdSFPNEqsuDUAXh2wVRve4Wac5BfVR1OhsegrpIn/HJME3utbTF6/JXYAkvTK06
         nNrjDqCn98Nmkw90BZUDjxcn509ATKqqw6v77m+1ikcKGz0dYOeo0xkmWPEgJn4CRUck
         3pkzYr0g5OWw3GGnBXU7UJcJZdXWsOi+vcpMnzAWPXH4D9ODdA6O9Je8t0hGg1m6Kg16
         nzUw==
X-Gm-Message-State: ACrzQf3b/04AptvwVoEgkQtb7tiMw+vFgSU1b3NhqdiHA/FyWMQ7DM11
        opdeipSyKh1J6a17lHbSKGo=
X-Google-Smtp-Source: AMsMyM7CrVg5EFS+mqIpiFOP63JNLSBHb0QTZN/R3kvym6xTN1nENidgHlp8kZKCpN2zqytEiWQ/uQ==
X-Received: by 2002:a17:903:32c2:b0:178:2ca7:fade with SMTP id i2-20020a17090332c200b001782ca7fademr1082026plr.71.1664389886097;
        Wed, 28 Sep 2022 11:31:26 -0700 (PDT)
Received: from localhost ([98.97.42.14])
        by smtp.gmail.com with ESMTPSA id k185-20020a6284c2000000b00541196bd2d9sm4407507pfd.68.2022.09.28.11.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 11:31:25 -0700 (PDT)
Date:   Wed, 28 Sep 2022 11:31:23 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     "liujian (CE)" <liujian56@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        davem <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Message-ID: <633492fb8ddc2_2944220881@john.notmuch>
In-Reply-To: <0dc1f0f9a8064ec3abd12bdcb069aaaf@huawei.com>
References: <061d068ccd6f4db899d095cd61f52114@huawei.com>
 <YzCdHXtgKPciEusR@pop-os.localdomain>
 <fb254c963d3549a19c066b6bd2acf9c7@huawei.com>
 <6332169a699f8_4dfb7208e4@john.notmuch>
 <0dc1f0f9a8064ec3abd12bdcb069aaaf@huawei.com>
Subject: RE: [bug report] one possible out-of-order issue in sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

liujian (CE) wrote:
> 
> 
> > -----Original Message-----
> > From: John Fastabend [mailto:john.fastabend@gmail.com]
> > Sent: Tuesday, September 27, 2022 5:16 AM
> > To: liujian (CE) <liujian56@huawei.com>; Cong Wang
> > <xiyou.wangcong@gmail.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>; Jakub Sitnicki
> > <jakub@cloudflare.com>; Eric Dumazet <edumazet@google.com>; davem
> > <davem@davemloft.net>; yoshfuji@linux-ipv6.org; dsahern@kernel.org;
> > Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > netdev <netdev@vger.kernel.org>; bpf@vger.kernel.org
> > Subject: RE: [bug report] one possible out-of-order issue in sockmap
> > 
> > liujian (CE) wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Cong Wang [mailto:xiyou.wangcong@gmail.com]
> > > > Sent: Monday, September 26, 2022 2:26 AM
> > > > To: liujian (CE) <liujian56@huawei.com>
> > > > Cc: John Fastabend <john.fastabend@gmail.com>; Jakub Sitnicki
> > > > <jakub@cloudflare.com>; Eric Dumazet <edumazet@google.com>;
> > davem
> > > > <davem@davemloft.net>; yoshfuji@linux-ipv6.org; dsahern@kernel.org;
> > > > Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > > > netdev <netdev@vger.kernel.org>; bpf@vger.kernel.org
> > > > Subject: Re: [bug report] one possible out-of-order issue in sockmap
> > > >
> > > > On Sat, Sep 24, 2022 at 07:59:15AM +0000, liujian (CE) wrote:
> > > > > Hello,
> > > > >
> > > > > I had a scp failure problem here. I analyze the code, and the
> > > > > reasons may
> > > > be as follows:
> > > > >
> > > > > From commit e7a5f1f1cd00 ("bpf/sockmap: Read psock ingress_msg
> > > > before
> > > > > sk_receive_queue", if we use sockops
> > > > > (BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB
> > > > > and BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) to enable socket's
> > > > sockmap
> > > > > function, and don't enable strparse and verdict function, the
> > > > > out-of-order problem may occur in the following process.
> > > > >
> > > > > client SK                                   server SK
> > > > > ------------------------------------------------------------------
> > > > > ----
> > > > > ----
> > > > > tcp_rcv_synsent_state_process
> > > > >   tcp_finish_connect
> > > > >     tcp_init_transfer
> > > > >       tcp_set_state(sk, TCP_ESTABLISHED);
> > > > >       // insert SK to sockmap
> > > > >     wake up waitter
> > > > >     tcp_send_ack
> > > > >
> > > > > tcp_bpf_sendmsg(msgA)
> > > > > // msgA will go tcp stack
> > > > >                                             tcp_rcv_state_process
> > > > >                                               tcp_init_transfer
> > > > >                                                 //insert SK to sockmap
> > > > >                                               tcp_set_state(sk,
> > > > >                                                      TCP_ESTABLISHED)
> > > > >                                               wake up waitter
> > > >
> > > > Here after the socket is inserted to a sockmap, its
> > > > ->sk_data_ready() is already replaced with
> > > > sk_psock_verdict_data_ready(), so msgA should go to sockmap, not TCP
> > stack?
> > > >
> > > It is TCP stack.  Here I only enable BPF_SK_MSG_VERDICT type.
> > > bpftool prog load bpf_redir.o /sys/fs/bpf/bpf_redir map name
> > > sock_ops_map pinned /sys/fs/bpf/sock_ops_map bpftool prog attach
> > > pinned /sys/fs/bpf/bpf_redir msg_verdict pinned
> > > /sys/fs/bpf/sock_ops_map
> > 
> > Is the sender using FAST_OPEN by any chance? We know this bug exists in
> > this case. Fix tbd.
> 
> FAST_OPEN is not used.

OK thanks for the reproducer I'll take a look this afternoon.
