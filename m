Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729B3565776
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 15:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiGDNdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 09:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiGDNcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 09:32:35 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1985F44;
        Mon,  4 Jul 2022 06:31:19 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g39-20020a05600c4ca700b003a03ac7d540so8001094wmp.3;
        Mon, 04 Jul 2022 06:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XJvEXsvyb7EsaLvwEq4/RlnBX6t07iF67aEM1xirFDw=;
        b=nOF2gUqRVne2oUKkLeHqdz53aBdnZGwCkVfgJmC8PJpR65YlceH4VzK7fOZcl9ldEd
         /kPim7luOZBe80i4UulgM8Fj78ogJbIpCiFT/RGIlxSj08fJaxqhNfM2IJz6gxnAxIh5
         c1jnaEU6AYI+vq9FciUXpCL69fm3rDgn80gqj7DBp9u+zw4VwpOvlbeg3NfLq6xfWhDL
         tzImxCBQAaHBY05ABaL8Bjnuqw/YyGKkHqDEPpOk9t+HttHP2oBd4RlJpEMh+RHVqyql
         b87rqWZ9bCby9BLA1g1WpU9EiPoaa8cW6v5FeuzkDyPxh2NL23WeQa0CEjcLO/SVj+DD
         z/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XJvEXsvyb7EsaLvwEq4/RlnBX6t07iF67aEM1xirFDw=;
        b=LiapmqMaOhBg4Vli7uKGAUJ8GTbEPpkuzF1CVSNVwJLCzuS7o9qX77owRNizTv/FPQ
         aloCO6S/m3dqRhxjP2aB4YAlbB2Lf4jSNcOCB7E5eYVdoIV0K3BcknEVcMH/LtkmFOXp
         hUo43DaX3JGAC5FqlqUdB6m0/uUhBTop5xdeFAjSf+ga46wt3JGUha3iPf9hSy/WBvYO
         DnKgM2SlUXa4E48rdgQhc22UNNiM1GuTcl1f27o+sOh2tPJCuBfey+A9WGIdmqccyeS/
         IUlQUv5VSAF7CvRuUOiA8/mQVOwSovGNuGsZlLDzqyBvHDtFmTflPFIUPmq+WzMiKGVf
         anKQ==
X-Gm-Message-State: AJIora9+3indFB73St45jjI9jQYpTBg9oMeNRKe9rUVAK40eaX985h+P
        i0WKWcKXJuq8RaGr52eR1QM=
X-Google-Smtp-Source: AGRyM1sLtjbRNfNzai9aiyAhRUqlA4wGZlZQG9X0uod3oFq2mO8PRTzF8FAuYR0i5VarKxDOV/GaRQ==
X-Received: by 2002:a05:600c:21c3:b0:3a0:3aad:7f30 with SMTP id x3-20020a05600c21c300b003a03aad7f30mr33904362wmj.190.1656941478184;
        Mon, 04 Jul 2022 06:31:18 -0700 (PDT)
Received: from [192.168.43.77] (82-132-231-162.dab.02.net. [82.132.231.162])
        by smtp.gmail.com with ESMTPSA id f190-20020a1c38c7000000b0039c5328ad92sm15989573wma.41.2022.07.04.06.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 06:31:17 -0700 (PDT)
Message-ID: <2840ec03-1d2b-f9c8-f215-61430f758925@gmail.com>
Date:   Mon, 4 Jul 2022 14:31:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC net-next v3 05/29] net: bvec specific path in
 zerocopy_sg_from_iter
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
 <5143111391e771dc97237e2a5e6a74223ef8f15f.1653992701.git.asml.silence@gmail.com>
 <20220628225204.GA27554@u2004-local>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220628225204.GA27554@u2004-local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/22 23:52, David Ahern wrote:
> On Tue, Jun 28, 2022 at 07:56:27PM +0100, Pavel Begunkov wrote:
>> Add an bvec specialised and optimised path in zerocopy_sg_from_iter.
>> It'll be used later for {get,put}_page() optimisations.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   net/core/datagram.c | 47 +++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 47 insertions(+)
>>
> 
> Rather than propagating iter functions, I have been using the attached
> patch for a few months now. It leverages your ubuf_info in msghdr to
> allow in kernel users to pass in their own iter handler.

If the series is going to be picked up for 5.20, how about we delay
this one for 5.21? I'll have time to think about it (maybe moving
the skb managed flag setup inside?), and will anyway need to send
some omitted patches then.

I was also entertaining the idea of having a smaller ubuf_info to
fit it into io_kiocb, which is tight on space.

struct ubuf_info {
	void *callback;
	refcount_t refcnt;
	u32 flags;
};

struct ubuf_info_msgzerocopy {
	struct ubuf_info ubuf;
	/* others fields */
};

48 bytes would be taking too much, but 16 looks nice. It might
make sense to move the callback into struct msghdr, I don't know.

-- 
Pavel Begunkov
