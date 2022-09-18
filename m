Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820D95BBF49
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 20:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiIRSZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 14:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiIRSZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 14:25:47 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544C714023
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 11:25:46 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id l14so11966351qvq.8
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 11:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:from:to:cc:subject:date;
        bh=YPCApZbbqTZ3Onosm6u6tAM0+To/If2JINJ45SpSFb0=;
        b=Lx0ISOhMzDNycPRdwfA6aQTP6cmDHyF9jFKsGFRfR9Q2JwIEu8P8u9wvfrwLmWGn0f
         8hDF8q3zkTZnpFuwGKOZAClUSOo1F5xs30ErS+HoOrGbYVowfrnmS9pgpvdarvxLJhCq
         Tn+5HFz/uimRvj6awOH9DMVZ7ZfwZGJxho08lsZ6OY9g/lNctRzgaHPRKN/FimKCt/5u
         HRjhonIsuRdMobckcB+m+wRuLs/LnqFZFgYgM9JQsBetI/IqLZ5PfGLxzzVnWerPpdsr
         3gHbhgpzuG5yV8kwDPNH8D0OhtmkFZYfCbTY0UC8oOOLPmH8siXIhrDPI6M6S8+F/+2r
         agFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :feedback-id:x-gm-message-state:from:to:cc:subject:date;
        bh=YPCApZbbqTZ3Onosm6u6tAM0+To/If2JINJ45SpSFb0=;
        b=Lo2oYh+QKJzHj9gGf1ZwEDhA1SX9r2VQ/yYCIVA2zE8QzTDsYU7OBMhDG2v0D1NHmX
         IlHikXh/KK7KHzisa0fJIkBnLo6gI3HKP4I2YvSIewliXyXkU5o+d0iIoO4KQdMmlXhQ
         Zv2sf14d+k5pBc5XkdNhXQY9iOPi1VKT6BBX0Dl68wqzZV34fZ3SdI6VaXVs0Gxet1iN
         mPKPgXYxaB1ZGu5NwKCDHq25bFh6wLzFGzkcvJQoSVeHEN/JaRRcGdF9rddvuq0tPefK
         g2EYrc4Eo6WqwbSrM8cD2Fp9J+JgjPBd5ejDp7YKRx9+RKK+UmVOCIdhqProVtQ/DsOQ
         wvAw==
X-Gm-Message-State: ACrzQf0oyJSjb79M3HVf731V2a0+NXMAxYyc90j2tOsX5w5jRdF7aL2w
        U9RtiDVEd3KF8vnlMqb6TFo=
X-Google-Smtp-Source: AMsMyM76qOGB+4li5li2feONVNut+wJW4Cf2g2+MrSf3kgeDpn2ijR7kpKZ/g6A7w6Mu62pKAdwFfw==
X-Received: by 2002:a05:6214:3006:b0:499:1f87:dac9 with SMTP id ke6-20020a056214300600b004991f87dac9mr11952854qvb.0.1663525545416;
        Sun, 18 Sep 2022 11:25:45 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a288c00b006cbc40f4b36sm11452108qkp.39.2022.09.18.11.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 11:25:44 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailauth.nyi.internal (Postfix) with ESMTP id 3F92827C0054;
        Sun, 18 Sep 2022 14:25:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 18 Sep 2022 14:25:44 -0400
X-ME-Sender: <xms:p2InY4tuS1aSPqZv4wDTRtqDI-QZfd6NcCeAllPm1CMoXlCPzGpIlA>
    <xme:p2InY1cPiT06WXHEMCUv9QQuZF5v9W2Goq0j4Lk7dZmJaxS2mIi1A8fV50Vd5UrKE
    n4NL95XEJ6MfZP9Ww>
X-ME-Received: <xmr:p2InYzwKuOSgXZg4vvnUU8fQ4PPE5i5YT_sF58VccFMaO915EmRVBuqiQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvhedguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepueho
    qhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtf
    frrghtthgvrhhnpeejgeegtdfgudevieevgeehhfetudfhhefhlefgleefvdegveegieeh
    leevgfelgeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhshiiikhgrlhhlvghrrd
    grphhpshhpohhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthi
    dqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghi
    lhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:p2InY7OvwXd0MpEN6kH1WTjQ9lXAhNnBqzwVTmkxUuniyln1AUvOnA>
    <xmx:p2InY49lmnD-O43MqemwZCA_2FBgQDQEEtWbMZQWIgQsADcyli4I_Q>
    <xmx:p2InYzVUtsv_qIQ6tfZMzizzuQqaoTyzAof7NWelrK5n66wfAj2zDA>
    <xmx:qGInYzXejWyjNbmu3KAySxS2C0R6WWpL-6mk-jNzqRyCtdSp-fQdow>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 18 Sep 2022 14:25:42 -0400 (EDT)
Date:   Sun, 18 Sep 2022 11:25:28 -0700
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        syzbot <syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING: locking bug in inet_autobind
Message-ID: <YydimPlesKO+4QKG@boqun-archlinux>
References: <00000000000033a0120588fac894@google.com>
 <693b572a-6436-14e6-442c-c8f2f361ed94@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <693b572a-6436-14e6-442c-c8f2f361ed94@I-love.SAKURA.ne.jp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 12:52:45AM +0900, Tetsuo Handa wrote:
> syzbot is reporting locking bug in inet_autobind(), for
> commit 37159ef2c1ae1e69 ("l2tp: fix a lockdep splat") started
> calling 
> 
>   lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class, "l2tp_sock")
> 
> in l2tp_tunnel_create() (which is currently in l2tp_tunnel_register()).
> How can we fix this problem?
> 

Just a theory, it seems that we have a memory corruption happened for
lockdep_set_class_and_name(), in l2tp_tunnel_register(), the "sk" gets
published before lockdep_set_class_and_name():

	tunnel->sock = sk;
	...
	lockdep_set_class_and_name(&sk->sk_lock.slock,...);

And what could happen is that sock_lock_init() races with the
l2tp_tunnel_register(), which results into two
lockdep_set_class_and_name()s race with each other.

Anyway, "sk" should not be published until its lock gets properly
initialized, could you try the following (untested)? Looks to me all
other code around the lockdep_set_class_and_name() should be moved
upwards, but I don't want to pretend I'm an expert ;-)

Regards,
Boqun

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7499c51b1850..1a01d23abc53 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1480,7 +1480,9 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,

        sk = sock->sk;
        sock_hold(sk);
-       tunnel->sock = sk;
+       lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class,
+                                  "l2tp_sock");
+       smp_store_release(&tunnel->sock, sk);

        spin_lock_bh(&pn->l2tp_tunnel_list_lock);
        list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
@@ -1509,8 +1511,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,

        tunnel->old_sk_destruct = sk->sk_destruct;
        sk->sk_destruct = &l2tp_tunnel_destruct;
-       lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class,
-                                  "l2tp_sock");
        sk->sk_allocation = GFP_ATOMIC;

        trace_register_tunnel(tunnel);  

>   ------------[ cut here ]------------
>   class->name=slock-AF_INET6 lock->name=l2tp_sock lock->key=l2tp_socket_class
>   WARNING: CPU: 2 PID: 9237 at kernel/locking/lockdep.c:940 look_up_lock_class+0xcc/0x140
>   Modules linked in:
>   CPU: 2 PID: 9237 Comm: a.out Not tainted 6.0.0-rc5-00094-ga335366bad13-dirty #860
>   Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
>   RIP: 0010:look_up_lock_class+0xcc/0x140
> 
> On 2019/05/16 14:46, syzbot wrote:
> > HEAD commit:    35c99ffa Merge tag 'for_linus' of git://git.kernel.org/pub..
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10e970f4a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
> > dashboard link: https://syzkaller.appspot.com/bug?extid=94cc2a66fc228b23f360
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> C reproducer is available at
> https://syzkaller.appspot.com/text?tag=ReproC&x=15062310080000 .
> 
