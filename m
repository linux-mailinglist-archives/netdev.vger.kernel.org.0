Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9F55E9566
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 20:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiIYSZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 14:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiIYSZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 14:25:37 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3FF23174;
        Sun, 25 Sep 2022 11:25:36 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id g23so2979459qtu.2;
        Sun, 25 Sep 2022 11:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Y5lbC2x0ceJ688VGU9QpEgBd+bctZyQjMYnLj58Loks=;
        b=TVmyNRK0NVFnYYp1HRLoSlFzhEQvdyDxkP2/JLLtk8QZIq3u2NGh3u48jfOGTz3Qha
         QCHLhrf2aUFa/SlL43EKJUbyxN1eHayXZwJpCcN38Ua5v7Nm01xO7AG4GLfdmaWRYdLa
         UB8sSd86Qnw6pjEpDmI6w2YfXP50WjcQqzsdXdso/qBGEzgScngFgMl++P7bW3fJrGfG
         XkWjaUBxjPPkxXv4Ue+qpOeKxt52YB5IGus5DaPqXcUjlGnuUAV8NsCbwcdSBY1/f5IG
         +96bcOSfFdPnDBdD+ZG/iwH7Bvce8lZkSJJ1x3ZKoVJolqKo5Z/uA9X9GGJ/kjPby+rC
         LNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Y5lbC2x0ceJ688VGU9QpEgBd+bctZyQjMYnLj58Loks=;
        b=rMPztLJ+omTV4warhP4zdaLZCN7rxzh0aIdPwLuDLZ1w6etAMULfTPRHaFSecmmmPD
         Y/3XAu981OnIEg7acpGCyVmsImzsNWi9eQ+fuM5Hn2f4H8/H0B/Q/9M+G0d/1A7Jq07b
         3OFcwwUrlydyS891WDsWASV6WVaOuqdyB5OjcVj4EbL7+J3JALXqK3wY9++69MRgiO4t
         V4HrnF/4HkJVZnKrt1s01sUklupARI+k5UqzL4UKKy5e6OvLn03YZ29KyXOxcD+Gkz//
         QbxsrjWm1TnpRdno28lVvLM5NDVxBb43jAFk/UB+FzsFSKpHQiHKrpgyPtVL5W8KiU7s
         9Gbw==
X-Gm-Message-State: ACrzQf02SXYEERctYiZgT0k0gVq3i6XY2IKEaXNyjuIVBRyIIfXX0oly
        XmJDjgj1nkHlk2SfZ4VnZoU=
X-Google-Smtp-Source: AMsMyM4qY1UyJk5ve7In2btB6YMKCSM/MizL+1mDMmNTquWb6PAntevHtN3tRQEdfu3UMfTipDnYuA==
X-Received: by 2002:ac8:5906:0:b0:35c:e7ab:e0bd with SMTP id 6-20020ac85906000000b0035ce7abe0bdmr15127030qty.349.1664130335209;
        Sun, 25 Sep 2022 11:25:35 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:9061:9095:558c:ce69])
        by smtp.gmail.com with ESMTPSA id d20-20020ae9ef14000000b006ce5fe31c2dsm9917085qkg.65.2022.09.25.11.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 11:25:34 -0700 (PDT)
Date:   Sun, 25 Sep 2022 11:25:33 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     "liujian (CE)" <liujian56@huawei.com>
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
Subject: Re: [bug report] one possible out-of-order issue in sockmap
Message-ID: <YzCdHXtgKPciEusR@pop-os.localdomain>
References: <061d068ccd6f4db899d095cd61f52114@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <061d068ccd6f4db899d095cd61f52114@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 07:59:15AM +0000, liujian (CE) wrote:
> Hello,
> 
> I had a scp failure problem here. I analyze the code, and the reasons may be as follows:
> 
> From commit e7a5f1f1cd00 ("bpf/sockmap: Read psock ingress_msg before
>  sk_receive_queue", if we use sockops (BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB
> and BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) to enable socket's sockmap
> function, and don't enable strparse and verdict function, the out-of-order
> problem may occur in the following process.
> 
> client SK                                   server SK
> --------------------------------------------------------------------------
> tcp_rcv_synsent_state_process
>   tcp_finish_connect
>     tcp_init_transfer
>       tcp_set_state(sk, TCP_ESTABLISHED);
>       // insert SK to sockmap
>     wake up waitter
>     tcp_send_ack
> 
> tcp_bpf_sendmsg(msgA)
> // msgA will go tcp stack
>                                             tcp_rcv_state_process
>                                               tcp_init_transfer
>                                                 //insert SK to sockmap
>                                               tcp_set_state(sk,
>                                                      TCP_ESTABLISHED)
>                                               wake up waitter

Here after the socket is inserted to a sockmap, its ->sk_data_ready() is
already replaced with sk_psock_verdict_data_ready(), so msgA should go
to sockmap, not TCP stack?

> tcp_bpf_sendmsg(msgB)
> // msgB go sockmap
>                                               tcp_bpf_recvmsg
>                                                 //msgB, out-of-order
>                                               tcp_bpf_recvmsg
>                                                 //msgA, out-of-order
> 
> 
> Even if msgA arrives earlier than msgB (in most cases), tcp_bpf_recvmsg receives msg from the psock queue first.
> The worst case is that msgA waits for serverSK to change to TCP_ESTABLISHED in the protocol stack. msgA may arrive at the serverSK receive queue later than msgB.
> If msgA befor than msgB, 
> 
> If the ACK packets of the three-way TCP handshake are dropped for a period of time, the OOO problem is easily reproduced.
> 
> iptables -A INPUT -p tcp -m tcp --dport 5006 --tcp-flags SYN,RST,ACK,FIN ACK -j DROP
> ...
> iptables -D INPUT -p tcp -m tcp --dport 5006 --tcp-flags SYN,RST,ACK,FIN ACK -j DROP
> 
> Best Wishes
> Liu Jian
