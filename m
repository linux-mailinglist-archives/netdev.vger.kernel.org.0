Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572905EB2EE
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 23:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbiIZVQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 17:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiIZVQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 17:16:14 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4A073305;
        Mon, 26 Sep 2022 14:16:13 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s26so7665239pgv.7;
        Mon, 26 Sep 2022 14:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date;
        bh=rRT+OkAAhjLoiWNBuCG4sTsHyASMrgBByhNlqKZBCHs=;
        b=iR2byfWUuFQLG6wpAcciFeGGBozQu5PX/spgbxYqphz6VyYYc+LI3It+2LLSVFnKPy
         Qk2etlB8Rgaw7VDhUsvIgXDnNRlWLeEIcrMV5pAy8zEVKWRqsEB455PhZUtzh6BEXD7y
         4m1D9Hn2MEIHBhx6hqZRBmqJq+aipSt1jfsR0vg0jC5KsRRnbcVbveY7gL0gDoaFMXIo
         7xV0O+PdE7tOlI43B7e6/NDqyTUCWdCfhEo3Xp6Tc9uN1WalRkxrG+TZUaz+IlVab+Yv
         pIAJEgW9Kv9NeKhAfXmDn/9swYM8+CWltIYeOzzueDxZwJorgMU44hU2JCcM7Lot+XPF
         6usQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date;
        bh=rRT+OkAAhjLoiWNBuCG4sTsHyASMrgBByhNlqKZBCHs=;
        b=64ZUGxa0mHeh3JUW3h7fJ0iGgeC6HGdGlnutJhjia3i7w6bmPpWu+QbGr7h7pWJeaT
         +FZCRnrRhF0+JoI893P+/fESvzTYfyOyTyfqpP/E32GNZ57/dxBUgs20TyyHXQxgltAi
         kw/00Aac5OWTk/CVJcDX/ndIoPBtKYaiLVw0uF3BVrbV386vQaIFl+iqBRhsaNpBotUY
         CDjysqj7l7e9KO6bQL0+I8N2uCDrC0gON92AyQmDvc0bw5QuEcn2VCr6eIEf7fP8GUsc
         2phGVyepqWlbhAE6Nn4aiqsIpThqDfgAuGNyGJgia7GM7BNhl19mK9omhniaankcqKPH
         ez0w==
X-Gm-Message-State: ACrzQf3vzNdUcq4OE69Nnkzfb5LroxaiGWszhGIKQEkP2VPCV/P/HKyh
        NVWaxgDKiQARnNwewJT02D4=
X-Google-Smtp-Source: AMsMyM5IDprnUed2O2q7famJYKUWw3FYbKQLOxERaC9MG2P7W+CeNTxGaB5Bef9n4Ak5IIDkDtJXDw==
X-Received: by 2002:a63:1215:0:b0:43a:827d:dd with SMTP id h21-20020a631215000000b0043a827d00ddmr22154155pgl.98.1664226972630;
        Mon, 26 Sep 2022 14:16:12 -0700 (PDT)
Received: from localhost ([98.97.32.109])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b0016c50179b1esm11798925plx.152.2022.09.26.14.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 14:16:11 -0700 (PDT)
Date:   Mon, 26 Sep 2022 14:16:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     "liujian (CE)" <liujian56@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        davem <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Message-ID: <6332169a699f8_4dfb7208e4@john.notmuch>
In-Reply-To: <fb254c963d3549a19c066b6bd2acf9c7@huawei.com>
References: <061d068ccd6f4db899d095cd61f52114@huawei.com>
 <YzCdHXtgKPciEusR@pop-os.localdomain>
 <fb254c963d3549a19c066b6bd2acf9c7@huawei.com>
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
> > From: Cong Wang [mailto:xiyou.wangcong@gmail.com]
> > Sent: Monday, September 26, 2022 2:26 AM
> > To: liujian (CE) <liujian56@huawei.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>; Jakub Sitnicki
> > <jakub@cloudflare.com>; Eric Dumazet <edumazet@google.com>; davem
> > <davem@davemloft.net>; yoshfuji@linux-ipv6.org; dsahern@kernel.org;
> > Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > netdev <netdev@vger.kernel.org>; bpf@vger.kernel.org
> > Subject: Re: [bug report] one possible out-of-order issue in sockmap
> > 
> > On Sat, Sep 24, 2022 at 07:59:15AM +0000, liujian (CE) wrote:
> > > Hello,
> > >
> > > I had a scp failure problem here. I analyze the code, and the reasons may
> > be as follows:
> > >
> > > From commit e7a5f1f1cd00 ("bpf/sockmap: Read psock ingress_msg
> > before
> > > sk_receive_queue", if we use sockops
> > > (BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB
> > > and BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) to enable socket's
> > sockmap
> > > function, and don't enable strparse and verdict function, the
> > > out-of-order problem may occur in the following process.
> > >
> > > client SK                                   server SK
> > > ----------------------------------------------------------------------
> > > ----
> > > tcp_rcv_synsent_state_process
> > >   tcp_finish_connect
> > >     tcp_init_transfer
> > >       tcp_set_state(sk, TCP_ESTABLISHED);
> > >       // insert SK to sockmap
> > >     wake up waitter
> > >     tcp_send_ack
> > >
> > > tcp_bpf_sendmsg(msgA)
> > > // msgA will go tcp stack
> > >                                             tcp_rcv_state_process
> > >                                               tcp_init_transfer
> > >                                                 //insert SK to sockmap
> > >                                               tcp_set_state(sk,
> > >                                                      TCP_ESTABLISHED)
> > >                                               wake up waitter
> > 
> > Here after the socket is inserted to a sockmap, its ->sk_data_ready() is
> > already replaced with sk_psock_verdict_data_ready(), so msgA should go to
> > sockmap, not TCP stack?
> > 
> It is TCP stack.  Here I only enable BPF_SK_MSG_VERDICT type.
> bpftool prog load bpf_redir.o /sys/fs/bpf/bpf_redir map name sock_ops_map pinned /sys/fs/bpf/sock_ops_map
> bpftool prog attach pinned /sys/fs/bpf/bpf_redir msg_verdict pinned /sys/fs/bpf/sock_ops_map

Is the sender using FAST_OPEN by any chance? We know this bug exists
in this case. Fix tbd.
