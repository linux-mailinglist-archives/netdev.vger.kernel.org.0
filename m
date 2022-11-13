Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B9C6272B8
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 22:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbiKMV30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 16:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbiKMV3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 16:29:17 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9440B13FA9
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 13:29:16 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id jr19so5854656qtb.7
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 13:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dVxoPXU1ZNqJqdFHmql+izsr21TtpvoUQ7i30aB78Cg=;
        b=elWfGVfUO/Nc+mZ7uWMkbtcYw8svdMAsGFf9n053yogTlTQYwK+GTRE4XoH8CaoLwk
         8+nFXpM+vgKkDM6X0tj6OhVcgxYBzJ8SDhMdkY7qJy3m9CQXGgKBG8SGZmb7ArADoam2
         K0RZGX0g87PVPGZbTh+LUaoQj9nj1hq5nYwmpRf1W5iTzVtvmwIxFl0ZRuWsVPKvKHJT
         i/IPrHbG57cchRho55kkBZg8FfocVusbfziq0DgrfPHNDKF5dtZFd6zPO/W4Yug6dcH4
         YzlCXYcev+6X8vc2cfo+eTnA4XEuTreksn9mrWKQWWoz1zVNhVqW1qc7slkQqLd67O+E
         FO5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dVxoPXU1ZNqJqdFHmql+izsr21TtpvoUQ7i30aB78Cg=;
        b=T5BZucV3ynvAakOD5zkWHWKx2lQ0FvVFq4jy0UZ5GnBv6wgW2R93fnPJHyxRDu4kU8
         kYw93Mlz/Q4dr+eMfWAECNGNc+2DW6dqhm4f9AEMVqOA6oTro9Vq3f6bNzCoWfaYCWz2
         0fed3ic+l1WjcdhwWyFXnnwGXyrmOonM+X23ytzuXB6gA+ibeQVH4u8IOcwF/Bg2+pMY
         u763H1yAbZOGuePVuznygdn3WsS0QxlS+he1vWxHDZdDbDXJMdkU8hYiYqc9hugF+LZO
         TLyGILupWt/Own/8fT7qlk26nl+ltdX7tNEwSoNTFkQ4e/F6Kfkm4GIlYTVVpjBTCS5E
         rhyA==
X-Gm-Message-State: ANoB5pkOb1VmoZDmp3q3cv+6hE7IEpwLsqF75AEfmdEkct4M+5OGAaic
        iioFdlXLgzEk1olqr8FdEP4=
X-Google-Smtp-Source: AA0mqf6Tgdaj9suyx8zo1JtzsCKTSsJoVfR2PMV55laaWN3C7V7F67N0yCxC9iEY5YBeQfA/3DxbsQ==
X-Received: by 2002:a05:622a:509a:b0:398:9079:69a7 with SMTP id fp26-20020a05622a509a00b00398907969a7mr9984616qtb.186.1668374955594;
        Sun, 13 Nov 2022 13:29:15 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:9605:4823:7ae3:f0de])
        by smtp.gmail.com with ESMTPSA id g26-20020ac8469a000000b003a5416da03csm4679923qto.96.2022.11.13.13.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 13:29:14 -0800 (PST)
Date:   Sun, 13 Nov 2022 13:29:13 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+278279efdd2730dd14bf@syzkaller.appspotmail.com,
        shaozhengchao <shaozhengchao@huawei.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [Patch net v2] kcm: close race conditions on sk_receive_queue
Message-ID: <Y3FhqUL1gApPhDMT@pop-os.localdomain>
References: <20221103184620.359451-1-xiyou.wangcong@gmail.com>
 <9ffe152671d4620eb1bfd443699c3143db377ca3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ffe152671d4620eb1bfd443699c3143db377ca3.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 10:13:23AM +0100, Paolo Abeni wrote:
> Hello,
> On Thu, 2022-11-03 at 11:46 -0700, Cong Wang wrote:
> > @@ -1085,53 +1085,17 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
> >  	return err;
> >  }
> >  
> > -static struct sk_buff *kcm_wait_data(struct sock *sk, int flags,
> > -				     long timeo, int *err)
> > -{
> > -	struct sk_buff *skb;
> > -
> > -	while (!(skb = skb_peek(&sk->sk_receive_queue))) {
> > -		if (sk->sk_err) {
> > -			*err = sock_error(sk);
> > -			return NULL;
> > -		}
> > -
> > -		if (sock_flag(sk, SOCK_DONE))
> > -			return NULL;
> 
> It looks like skb_recv_datagram() ignores the SOCK_DONE flag, so this
> change could potentially miss some wait_data end coditions. On the flip
> side I don't see any place where the SOCK_DONE flag is set for the kcm
> socket, so this should be safe, but could you please document this in
> the commit message?

Good catch. Indeed, this flags seems only used by stream sockets, I will
include this in the commit message.

> 
> [...]
> 
> > @@ -1187,11 +1147,7 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
> >  
> >  	/* Only support splice for SOCKSEQPACKET */
> >  
> > -	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
> > -
> > -	lock_sock(sk);
> > -
> > -	skb = kcm_wait_data(sk, flags, timeo, &err);
> > +	skb = skb_recv_datagram(sk, flags, &err);
> >  	if (!skb)
> >  		goto err_out;
> >  
> > @@ -1219,13 +1175,11 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
> >  	 * finish reading the message.
> >  	 */
> >  
> > -	release_sock(sk);
> > -
> > +	skb_free_datagram(sk, skb);
> >  	return copied;
> >  
> >  err_out:
> > -	release_sock(sk);
> > -
> > +	skb_free_datagram(sk, skb);
> 
> We can reach here with skb == NULL and skb_free_datagram() ->
> __kfree_skb() -> skb_release_all() does not deal correctly with NULL
> skb, you need to check for skb explicitly here (or rearrange the error
> paths in a suitable way).
> 

Are you sure? skb_free_datagram() is just consume_skb() which is guarded
by skb_unref() which takes NULL and returns false.


1195 static inline bool skb_unref(struct sk_buff *skb)
1196 {
1197         if (unlikely(!skb))
1198                 return false;

1027 void consume_skb(struct sk_buff *skb)
1028 {
1029         if (!skb_unref(skb))
1030                 return;

320 void skb_free_datagram(struct sock *sk, struct sk_buff *skb)
321 {
322         consume_skb(skb);
323 }


Thanks.
