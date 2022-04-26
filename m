Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C9B5101E3
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352277AbiDZPbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbiDZPbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:31:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91AB910FD0
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650986891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VkjzNymD/1c6sdb15I7+DmA5eYDHg4W6mx3iCYCm8Gk=;
        b=UHvmoOryEbrKrO2/dDwjv6eDZDaPquczfHXgGf/inC6SFNQuCnBHytbDiCZ+qDrtvoMtYb
        iCGBZnCIfG9a0PfPNDgj3XTGKHQB1JUuzru7aBYivf3n9kh2T6jMHcJjqb/9gnhdxVE2OC
        lMs/VKuh3wBQrwlDJMjxwcQHk1kv+hM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-z4-gENLkPcybTsMpDZ602Q-1; Tue, 26 Apr 2022 11:28:10 -0400
X-MC-Unique: z4-gENLkPcybTsMpDZ602Q-1
Received: by mail-wm1-f70.google.com with SMTP id i131-20020a1c3b89000000b00393fbb0718bso238318wma.0
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:28:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VkjzNymD/1c6sdb15I7+DmA5eYDHg4W6mx3iCYCm8Gk=;
        b=laLnBHF5tvBeB6VGLHB80rwTqcfiRFrfUbaPQlYbxSzsANCHRj/7JQp7gxTY7i1TSp
         6vJkH9/jd27mdXcFYMCet+j1XAuULL8qWK7P/mz416Z1UcVlp1CTeDZvf6IxQd3BNDl1
         CYXiSHqgoHTGtv+9U2E8fqSAPEowa87J7zR/vgqglQNiR1GRDt+/nEeii0TJJm9Q6JLC
         npcIJSSiWDH8SEdWNr8Om1rXnJJ07/mrZRbBtv4L7zsiP8XTMpyAoVZlJERCLGVF7BLu
         PMlRCujVqXplVgYu5VAi60/sBBCT/0TYvntI5URnjdM8WbfHwspfyheUyHsL8ZkivaIc
         a3Gw==
X-Gm-Message-State: AOAM532gwOYyROA8ABy3ux275hK87oOrQxjZhA/XN4DOAFrKwmef0fwY
        jrgevCSQuK64zPbkQp3AsH99fRbBlRQam1EEPVeBXbMAR/yuPr88NCKjIDy0TpCh+EGz5O+T9TO
        esBczak44nbwD6Yyw
X-Received: by 2002:a7b:cc12:0:b0:37c:1ae:100a with SMTP id f18-20020a7bcc12000000b0037c01ae100amr30359967wmh.54.1650986888923;
        Tue, 26 Apr 2022 08:28:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5mpdibLCTe7nAz92h0NK9cTqWmpCqlzgKFjE7C8qCSalw48etJxWnuFyyDlEJpruw2Xtt4A==
X-Received: by 2002:a7b:cc12:0:b0:37c:1ae:100a with SMTP id f18-20020a7bcc12000000b0037c01ae100amr30359950wmh.54.1650986888719;
        Tue, 26 Apr 2022 08:28:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-117-160.dyn.eolo.it. [146.241.117.160])
        by smtp.gmail.com with ESMTPSA id w9-20020adf8bc9000000b0020ac0a63b3esm11728155wra.51.2022.04.26.08.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 08:28:08 -0700 (PDT)
Message-ID: <b4df9653b93b9b0bdc8a91f5560ec027848200a9.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Date:   Tue, 26 Apr 2022 17:28:07 +0200
In-Reply-To: <CANn89iLuqGdbHkyUcTZd+Ww6vUxqNg0L4eC5Xt8bqLMDmDM18w@mail.gmail.com>
References: <20220422201237.416238-1-eric.dumazet@gmail.com>
         <2c092f98a8fe1702173fe2b4999811dd2263faf3.camel@redhat.com>
         <CANn89iLuqGdbHkyUcTZd+Ww6vUxqNg0L4eC5Xt8bqLMDmDM18w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-04-26 at 06:11 -0700, Eric Dumazet wrote:
> On Tue, Apr 26, 2022 at 12:38 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Fri, 2022-04-22 at 13:12 -0700, Eric Dumazet wrote:
> > [...]
> > > @@ -6571,6 +6577,28 @@ static int napi_threaded_poll(void *data)
> > >       return 0;
> > >  }
> > > 
> > > +static void skb_defer_free_flush(struct softnet_data *sd)
> > > +{
> > > +     struct sk_buff *skb, *next;
> > > +     unsigned long flags;
> > > +
> > > +     /* Paired with WRITE_ONCE() in skb_attempt_defer_free() */
> > > +     if (!READ_ONCE(sd->defer_list))
> > > +             return;
> > > +
> > > +     spin_lock_irqsave(&sd->defer_lock, flags);
> > > +     skb = sd->defer_list;
> > 
> > I *think* that this read can possibly be fused with the previous one,
> > and another READ_ONCE() should avoid that.
> 
> Only the lockless read needs READ_ONCE()
> 
> For the one after spin_lock_irqsave(&sd->defer_lock, flags),
> there is no need for any additional barrier.
> 
> If the compiler really wants to use multiple one-byte-at-a-time loads,
> we are not going to fight, there might be good reasons for that.

I'm unsure I explained my doubt in a clear way: what I fear is that the
compiler could emit a single read instruction, corresponding to the
READ_ONCE() outside the lock, so that the spin-locked section will
operate on "old" defer_list. 

If that happens we could end-up with 'defer_count' underestimating the
list lenght. It looks like that is tolerable, as we will still be
protected vs defer_list growing too much.

Acked-by: Paolo Abeni <pabeni@redhat.com>


