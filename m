Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F395B2545
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 20:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiIHSCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 14:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiIHSB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 14:01:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808EBF10DF
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 11:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662660116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rec3e1xO+/lfC9NYVlLPNP8AcM8i5/2lja30cN6ZSbE=;
        b=fow7XozgJmWajs2O3kc6cm7/kDMU7edi1XoZUYkYIZDHbI9Tfb5kfqlZbnWeCKjiu5PLcF
        cVze9KUhSVK60uS/9voTV07i+Io2TF+n6XFTiTnytaEta0v4viXBYGxaXZWBJ4kw7AQgB/
        JBJncYIznTkuv7FKaTMaQ/QeAGKjXMU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-159-dhk0VPecPLWXT0DKDbSK6g-1; Thu, 08 Sep 2022 14:01:47 -0400
X-MC-Unique: dhk0VPecPLWXT0DKDbSK6g-1
Received: by mail-qt1-f199.google.com with SMTP id ci6-20020a05622a260600b0034370b6f5d6so15176793qtb.14
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 11:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=rec3e1xO+/lfC9NYVlLPNP8AcM8i5/2lja30cN6ZSbE=;
        b=gSbBv0JRoidgQ2VL+p1tVNRoa9D3x6M6gnxTCdVbaDE9Rq7s68XDxHp2Oe1jeaBxDq
         QUkIA4Gs4TsjF+vebcd6xX5UWgQPoFqJJUsnw5oA8myMcsQJ4M9MuNhaDTNoXR61PbU/
         53/+OHClf8kaZdn0zckZuhC30+dauZNpBHdkYI3bb12XBY0jB1uhEdvTffe65uR32GeZ
         prANeRURXfBJis8wIdwKAS6m90wNxtpNRCC94oTsHZmAsf6SUsgFoDIoH8ZZIanNeRT5
         K0B+1v7ehWlrgbZJ4XeG05je+W/DHDu2Bh1QjrSQUaQ8/Vvk1mkZY7LBOPnxyHiJP//n
         lfNQ==
X-Gm-Message-State: ACgBeo3E0dxFcl5yvJ6ObhU89T6pbJURoPcVVIn5lMQ/ld5+9gAI88Vs
        zcoFG4jTrDJA73YzAWl/qw6FfzpBHIVn/J+3o4q7IE6ddU3lVTYclvDH6MNfUW0CQtbwVrkcM1H
        zhuR/6RtPnDjvYqSC
X-Received: by 2002:a05:6214:c66:b0:499:2f1a:1cec with SMTP id t6-20020a0562140c6600b004992f1a1cecmr8279237qvj.93.1662660107273;
        Thu, 08 Sep 2022 11:01:47 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5SrROjS8cVb29mFGztmJb04rbrRJmMyuaSF8EqKZYHelvrLJNn7tccUS8I/7ZSvPM5hVqgcg==
X-Received: by 2002:a05:6214:c66:b0:499:2f1a:1cec with SMTP id t6-20020a0562140c6600b004992f1a1cecmr8279201qvj.93.1662660106948;
        Thu, 08 Sep 2022 11:01:46 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id n3-20020a05620a294300b006b953a7929csm18385620qkp.73.2022.09.08.11.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 11:01:46 -0700 (PDT)
Message-ID: <f3f867cf6814510817b253e6aca997cdd3acc48a.camel@redhat.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Date:   Thu, 08 Sep 2022 20:01:42 +0200
In-Reply-To: <cf264865cb1613c0e7acf4bbc1ed345533767822.camel@gmail.com>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
         <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
         <dcffcf6fde8272975e44124f55fba3936833360e.camel@gmail.com>
         <498a25e4f7ba4e21d688ca74f335b28cadcb3381.camel@redhat.com>
         <cf264865cb1613c0e7acf4bbc1ed345533767822.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-09-08 at 07:53 -0700, Alexander H Duyck wrote:
> On Thu, 2022-09-08 at 13:00 +0200, Paolo Abeni wrote:
> > In most build GRO_MAX_HEAD packets are even larger (should be 640)
> 
> Right, which is why I am thinking we may want to default to a 1K slice.

Ok it looks like there is agreement to force a minimum frag size of 1K.
Side note: that should not cause a memory usage increase compared to
the slab allocator as kmalloc(640) should use the kmalloc-1k slab.

[...]

> > > 
> > If the pagecnt optimization should be dropped, it would be probably
> > more straight-forward to use/adapt 'page_frag' for the page_order0
> > allocator.
> 
> That would make sense. Basically we could get rid of the pagecnt bias
> and add the fixed number of slices to the count at allocation so we
> would just need to track the offset to decide when we need to allocate
> a new page. In addtion if we are flushing the page when it is depleted
> we don't have to mess with the pfmemalloc logic.

Uhmm... it looks like that the existing page_frag allocator does not
always flush the depleted page:

bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
{
        if (pfrag->page) {
                if (page_ref_count(pfrag->page) == 1) {
                        pfrag->offset = 0;
                        return true;
                }

so I'll try adding some separate/specialized code and see if the
overall complexity would be reasonable.

> > BTW it's quite strange/confusing having to very similar APIs (page_frag
> > and page_frag_cache) with very similar names and no references between
> > them.
> 
> I'm not sure what you are getting at here. There are plenty of
> references between them, they just aren't direct.

Looking/greping the tree I could not trivially understand when 'struct
page_frag' should be preferred over 'struct page_frag_cache' and/or
vice versa, I had to look at the respective implementation details.

Thanks,

Paolo

