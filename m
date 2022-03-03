Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838F34CB3C8
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 01:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiCCAb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 19:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiCCAb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 19:31:58 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A3CBB0B8;
        Wed,  2 Mar 2022 16:31:14 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id j24so3346337oii.11;
        Wed, 02 Mar 2022 16:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GpygpwvbCIq+atpVl63RWzRvcyI5EavhzcTuik774Ps=;
        b=JvVrqIL7vzw0G6nRRxEgqgpC6cTRdpQpXoay6Ud9ZFckp0lsTXrzUYdjBcOT/9c/5M
         rkNVazOGOXapDtD2QAz8puQBAsgatFqRr4Zb5ThiBvAv+XQHq1MMQa+C1ACCHFVU6J+n
         ydxncHn/0DZuW0cnNkv8GF3AVz8Ka+dPmimbmtPzx48HHCli+h+XK8n/1ogXLyBSuEpo
         kS/wmitAcLBXFDorXnrw3ydxMvgdgz2Afk5gysrrs6A+Ux2QCPX+jxRO10LD4rXFn1NG
         BTukeCSL6XpgBkvT5KSz7p5tkRVi7cxLYsp6ZC5fgRCTgnYoH9s1DyEbZL1FXxFY/aQN
         5Myg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GpygpwvbCIq+atpVl63RWzRvcyI5EavhzcTuik774Ps=;
        b=KtfS0mQEuY7FwPOKhkFt/AADLNp/o8daO02JT4H12vvPJCAIvg816jsZPIpUaBaO6K
         MziUonxG1teiDoj7zfzu73gQaXAQWnPM8wkz/dFPC5ffRm0P6AHh9aoxs0cljC65BoZe
         HlNLiHs6xZzscjLZkyU2JKfApy1RaD+nMNyEWkDAWNY8WugWw1s9AikkrTX/LQeiqnB9
         8gVHDRv5uAk04j822L3cQa+6p+m0rhc2MSr1sY2GA6qOV9R59yJ2qKTx76epX4AGQ2pD
         qTasDBNOTUDvBBGCO8hw8yLF7B2XarFSYiZOmPwDjIv6hDwVHI6inRr44f5EZf8jn2ua
         Wd+Q==
X-Gm-Message-State: AOAM533dNZfRTS4kdJlSnU03gN8I/lVqB9GAL7puNpJEV49nJiSW+rbh
        O3YlQaTvtBEQ/ycVxDWHllE=
X-Google-Smtp-Source: ABdhPJzOmby5kJNvG96Otw79hmNwElZlOiUPp/M4i9hDC8SfzCAoCiqr8Vn6ePK3RDnwnH+kwdNhig==
X-Received: by 2002:a05:6808:488:b0:2d4:fb86:6fed with SMTP id z8-20020a056808048800b002d4fb866fedmr2306266oid.133.1646267473666;
        Wed, 02 Mar 2022 16:31:13 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:17f1:53ec:373a:a88a])
        by smtp.gmail.com with ESMTPSA id m21-20020a056820051500b0031d0841b87esm242331ooj.34.2022.03.02.16.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 16:31:13 -0800 (PST)
Date:   Wed, 2 Mar 2022 16:31:12 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     wangyufen <wangyufen@huawei.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com, davem@davemloft.net,
        bpf@vger.kernel.org, edumazet@google.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/4] bpf, sockmap: Fix memleak in
 sk_psock_queue_msg
Message-ID: <YiAMUECNKtephFSh@pop-os.localdomain>
References: <20220225014929.942444-1-wangyufen@huawei.com>
 <20220225014929.942444-2-wangyufen@huawei.com>
 <YhvPKB8O7ml5JSHQ@pop-os.localdomain>
 <43776e3f-08c0-5d1a-1c2b-dd6084a6de33@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43776e3f-08c0-5d1a-1c2b-dd6084a6de33@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 09:49:12AM +0800, wangyufen wrote:
> 
> 在 2022/2/28 3:21, Cong Wang 写道:
> > On Fri, Feb 25, 2022 at 09:49:26AM +0800, Wang Yufen wrote:
> > > If tcp_bpf_sendmsg is running during a tear down operation we may enqueue
> > > data on the ingress msg queue while tear down is trying to free it.
> > > 
> > >   sk1 (redirect sk2)                         sk2
> > >   -------------------                      ---------------
> > > tcp_bpf_sendmsg()
> > >   tcp_bpf_send_verdict()
> > >    tcp_bpf_sendmsg_redir()
> > >     bpf_tcp_ingress()
> > >                                            sock_map_close()
> > >                                             lock_sock()
> > >      lock_sock() ... blocking
> > >                                             sk_psock_stop
> > >                                              sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
> > >                                             release_sock(sk);
> > >      lock_sock()	
> > >      sk_mem_charge()
> > >      get_page()
> > >      sk_psock_queue_msg()
> > >       sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED);
> > >        drop_sk_msg()
> > >      release_sock()
> > > 
> > > While drop_sk_msg(), the msg has charged memory form sk by sk_mem_charge
> > > and has sg pages need to put. To fix we use sk_msg_free() and then kfee()
> > > msg.
> > > 
> > What about the other code path? That is, sk_psock_skb_ingress_enqueue().
> > I don't see skmsg is charged there.
> 
> sk_psock_skb_ingress_self() | sk_psock_skb_ingress()
>    skb_set_owner_r()
>       sk_mem_charge()
>    sk_psock_skb_ingress_enqueue()
> 
> The other code path skmsg is charged by skb_set_owner_r()->sk_mem_charge()
> 

skb_set_owner_r() charges skb, I was asking skmsg. ;) In
sk_psock_skb_ingress_enqueue(), the skmsg was initialized but not
actually charged, hence I was asking... From a second look, it seems
sk_mem_uncharge() is not called for sk_psock_skb_ingress_enqueue() where
msg->skb is clearly not NULL.

Also, you introduce an unnecessary sk_msg_init() from __sk_msg_free(),
because you call kfree(msg) after it.

Thanks.
