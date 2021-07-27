Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438A03D7A67
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhG0QB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhG0QB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:01:58 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF69CC061757;
        Tue, 27 Jul 2021 09:01:58 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id u7so9302205ilj.8;
        Tue, 27 Jul 2021 09:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=omdrfMzyUfcw+e0x5XFdGzr+bU01eyAbX2ypAQPtaCw=;
        b=OWiCCgraBaFlHhGg/o75KOPmu5rYZdTHG6kRtq0jqUG5tRlHq7+nn7Q8DZS14Tu58e
         ee+npZzmH5rBCCxGOTai9trHfVzK3g0EXSQgpGabRiWodaiQtN+rErYJzzVSpdyUsmpj
         QkMqhugvA5UPw1TzNjwLbq0RFIbTuJ/wRBAes/ZlVyxpvOm+ojxhTACVBh53qh8xLgEp
         TD7y0LQ+eWNEjDmnG+IqEE5TyeNgb26V7LE98i0TxsrsJpwVXbkmSzCuD/IzPPPixpHM
         poWN+EQ2LsHFOlo5EVzOd2JJM9I4pXY7DsQgjwO4lXdsxV8d9NSEfen9Zya/fdqYWw4Y
         4r9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=omdrfMzyUfcw+e0x5XFdGzr+bU01eyAbX2ypAQPtaCw=;
        b=Y40xYBCOma/epLguk16LADExJqDCKhQoBqSD2PuOWvoDJJysmUW3VE59OV8DmcazSR
         ugF1rDxWFRNtmOXR/AAFzPRQhpXgkPFWTUDymFY9Gb6ZEWRMApXcnJ94efYHoREwlI1z
         3o2xe3tcS36pI0n2ZAR8VZ9ok2+0A4w0xe1vh4gQz7l71mjzTnWPXg4LL7ombNxPwABO
         Rtm48dNjeb2cGZeaHkTFZ6+S/LHNmfKk08dRLD187hJCHPBW5sNNuu+5vpk77Sx8kHqa
         NZ2ZbP/QHO0U4EJnwvuf0JkOa32GwJKDBppvZV4Adxh6/q+3lp2woWX2yWPqFfAKE1la
         AiVA==
X-Gm-Message-State: AOAM531KL41ujnTGg7T5eeCyiXTvSU4jSVOtXEOxywtjwBV7X9IRO6uR
        7W4XY9ds0kMKaQyHJu0OhLc=
X-Google-Smtp-Source: ABdhPJzhJ2BMlii62SwyzQ1BL4I+BGvXV/UeLu+cGlONdM47bXxdhGuwvtvX2aNuBRG5C/xakaHmtw==
X-Received: by 2002:a05:6e02:dcd:: with SMTP id l13mr17449199ilj.300.1627401718304;
        Tue, 27 Jul 2021 09:01:58 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id w8sm2006132ill.50.2021.07.27.09.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:01:57 -0700 (PDT)
Date:   Tue, 27 Jul 2021 09:01:50 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     jakub@cloudflare.com, daniel@iogearbox.net,
        xiyou.wangcong@gmail.com, alexei.starovoitov@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <61002dee75048_199a412083e@john-XPS-13-9370.notmuch>
In-Reply-To: <20210727043205.24ldyis5g5yvg4mm@kafai-mbp.dhcp.thefacebook.com>
References: <20210726165304.1443836-1-john.fastabend@gmail.com>
 <20210726165304.1443836-4-john.fastabend@gmail.com>
 <20210727043205.24ldyis5g5yvg4mm@kafai-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH bpf v2 3/3] bpf, sockmap: fix memleak on ingress msg
 enqueue
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> On Mon, Jul 26, 2021 at 09:53:04AM -0700, John Fastabend wrote:
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -285,11 +285,45 @@ static inline struct sk_psock *sk_psock(const struct sock *sk)
> >  	return rcu_dereference_sk_user_data(sk);
> >  }
> >  
> > +static inline void sk_psock_set_state(struct sk_psock *psock,
> > +				      enum sk_psock_state_bits bit)
> > +{
> > +	set_bit(bit, &psock->state);
> > +}
> > +
> > +static inline void sk_psock_clear_state(struct sk_psock *psock,
> > +					enum sk_psock_state_bits bit)
> > +{
> > +	clear_bit(bit, &psock->state);
> > +}
> > +
> > +static inline bool sk_psock_test_state(const struct sk_psock *psock,
> > +				       enum sk_psock_state_bits bit)
> > +{
> > +	return test_bit(bit, &psock->state);
> > +}
> > +
> > +static void sock_drop(struct sock *sk, struct sk_buff *skb)
> inline


Thanks will fix, bit surprised I didn't get a build warning for the typo.
