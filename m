Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20813563B23
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiGAUah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiGAUaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:30:35 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97ABA564FF;
        Fri,  1 Jul 2022 13:30:34 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s27so3360800pga.13;
        Fri, 01 Jul 2022 13:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=t/Xde3nxkyQ96D2oze2R0Uw9k23+k7vYnS+3QBos+9c=;
        b=CtUZGlZ2dRMn7WyIHQiDj+t+KvXl1CHWHrqUQJ+/IeeOiANaU5RZVEZYhm8ieCCQ4/
         BeGFEe1fiAc9Do0SsByy5XTu3XMr3Gq+LQKI5SQubaeY0qBVD863fychTeNfZkrk2kTp
         yeocAx8m3BkYddvpUJ4DGGpm7iK7qojBvGSejB5P8jGClITMnyiZv7zI0WmuPiRsptOO
         UsZEisXGj1WpCBXofu34PWZ5C4t8amFzKjmQMttsEmrARIobZXiuddemtOyy4xqrgkax
         80v8hYmHVnGS9hRX2WEcNOxN5urU+olIKQgk7sFufc2HA0LG9NJJ24/l2LwdcqORXVpN
         UwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=t/Xde3nxkyQ96D2oze2R0Uw9k23+k7vYnS+3QBos+9c=;
        b=BkCcQvXawtmHuVWr29uoRqEZXLTmYSYhtTWXXiD2CLANVfp5vdU0f01xXyUWle5D1w
         fbqJo8tKE5/wo6JMKTxY4zHVqluH+Xaw5WXBIpi/BZTskP2jefeY55IKEAc+7M55j0i0
         2cmz40av0Ve2RzaXA82U51Zbk0vv0EOqyPqnmRLJdRhEV0foW5bcghdVchsBIGU0dano
         RE+wouYeUIBJHwE8trnsCegzuq/uBalMZkPWu0FfKIAa+KQ2w0s6rUAZRnA403myhnGO
         NnMhJ3FuwJGDinWmsRi3SDIMgvF5ivrOgE9AAcOL1snIwSth3aPpIHT/dXHFmq4cAmR0
         UJ9Q==
X-Gm-Message-State: AJIora+zvQaqc/wez4uEvKVARHUpwmbSEoNc7hVPbh2yS+63fw0QxUuL
        p3wv0c0ntb7aHat29PWNV5zdDqdyjSs=
X-Google-Smtp-Source: AGRyM1tieiu0IHw/DBK/9SNoekq7iCcI/CqeXCwcYD9airzczViI9shEvAoeWAl1b5BT8MkR4SLMlA==
X-Received: by 2002:a05:6a00:16ca:b0:525:a5d5:d16f with SMTP id l10-20020a056a0016ca00b00525a5d5d16fmr23069165pfc.9.1656707433968;
        Fri, 01 Jul 2022 13:30:33 -0700 (PDT)
Received: from localhost ([98.97.119.237])
        by smtp.gmail.com with ESMTPSA id iz19-20020a170902ef9300b0016378bfeb90sm15976159plb.227.2022.07.01.13.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 13:30:33 -0700 (PDT)
Date:   Fri, 01 Jul 2022 13:30:31 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        jakub@cloudflare.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     liujian56@huawei.com
Message-ID: <62bf59673fafa_2103720852@john.notmuch>
In-Reply-To: <62bd50d459166_54c3b2089f@john.notmuch>
References: <20220628123616.186950-1-liujian56@huawei.com>
 <62bd50d459166_54c3b2089f@john.notmuch>
Subject: RE: [PATCH bpf] skmsg: Fix invalid last sg check in sk_msg_recvmsg()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Liu Jian wrote:
> > In sk_psock_skb_ingress_enqueue function, if the linear area + nr_frags +
> > frag_list of the SKB has NR_MSG_FRAG_IDS blocks in total, skb_to_sgvec
> > will return NR_MSG_FRAG_IDS, then msg->sg.end will be set to
> > NR_MSG_FRAG_IDS, and in addition, (NR_MSG_FRAG_IDS - 1) is set to the last
> > SG of msg. Recv the msg in sk_msg_recvmsg, when i is (NR_MSG_FRAG_IDS - 1),
> > the sk_msg_iter_var_next(i) will change i to 0 (not NR_MSG_FRAG_IDS), the
> > judgment condition "msg_rx->sg.start==msg_rx->sg.end" and
> > "i != msg_rx->sg.end" can not work.
> > 
> > As a result, the processed msg cannot be deleted from ingress_msg list.
> > But the length of all the sge of the msg has changed to 0. Then the next
> > recvmsg syscall will process the msg repeatedly, because the length of sge
> > is 0, the -EFAULT error is always returned.
> > 
> > Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> > Signed-off-by: Liu Jian <liujian56@huawei.com>
> > ---
> >  net/core/skmsg.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index b0fcd0200e84..a8dbea559c7f 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -462,7 +462,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
> >  
> >  			if (copied == len)
> >  				break;
> > -		} while (i != msg_rx->sg.end);
> > +		} while (!sg_is_last(sge));
> >  
> >  		if (unlikely(peek)) {
> >  			msg_rx = sk_psock_next_msg(psock, msg_rx);
> > @@ -472,7 +472,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
> >  		}
> >  
> >  		msg_rx->sg.start = i;
> > -		if (!sge->length && msg_rx->sg.start == msg_rx->sg.end) {
> > +		if (!sge->length && sg_is_last(sge)) {
> >  			msg_rx = sk_psock_dequeue_msg(psock);
> >  			kfree_sk_msg(msg_rx);
> >  		}
> > -- 
> > 2.17.1
> > 
> 
> Looks correct to me, but I'll test it tomorrow and add a reviewed-by and
> tested-by then. Thanks!

Still testing but adding ack.

Acked-by: John Fastabend <john.fastabend@gmail.com>
