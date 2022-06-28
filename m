Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFDC55F06A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 23:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiF1VgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 17:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiF1VgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 17:36:17 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3D12ED69;
        Tue, 28 Jun 2022 14:36:15 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id n8so5448738eda.0;
        Tue, 28 Jun 2022 14:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HUL3dhmazHACLWg3Jqji+i1NZvZ2c9MkkehxgzHYnVo=;
        b=LnQ9zYXKPe1cHsHner0sFmNa+CG2mooABLHzHPnG37uphSLEvIijDwftPXJ/8zhoUL
         4UBB93mISsMj1X4pSTIDhAqwW+03KqzSdqgyUBNgX3ooqDGbh9RxUh/q5GS19pcBt33s
         Te7lWmiBrsbBXZWNLuKamC6ZKm99bAXkSu3MF9XdB4ED0aVjPT6hv/jEts794NVkmQtG
         E8wyWTEDACK7jRIVI2Gn0FlaUd7e1Ls+WoXeY0DIDz82GuNQc0J9ETNCOefAy/ndaQsr
         2ZX2mKd0L39oiJlg6/ryprq2+TUQx24Kdx0FuTOgRuFFRLgfKJmWOQdpDTC7zdbygdFW
         qEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HUL3dhmazHACLWg3Jqji+i1NZvZ2c9MkkehxgzHYnVo=;
        b=DCuJWRs4lalSho49UBGXhswU30w6DK32JsUjOb9Igw5+JhiEptzpWGJZJzgko/TfvM
         ZeJPbUO1Slx5OHZ5SkLqRqo73O55IUZweOTONBNKyEy/iiFyV6GivxqYxqyqkW1CRPbK
         E1IaUU6nLqU0W2b90aSf7RDVlwjvA3X4zflu6rfKwvQc12oCRFJI8Rv+GcxVaV0aOBx6
         u0WlYBHaI/i5YjSnJPyqNNJjzYGj6d3SvWL1iTnoSDgL2sUUTMCaoMv+PuEyu8pI2CE+
         SWIHpZo6/qwn9XXilunKLTFIT6o1sMY+iG4JSEPGI252z9QAsbSp9FmyYTsHTcA4HeNi
         OyHQ==
X-Gm-Message-State: AJIora8lbqpvgSVnAVX0qTq5kTQ5kfn8VnAiSWeri4/NsqaPE0KnAcSM
        q+ok3FnIO2bO4Yw1mFh5ucg=
X-Google-Smtp-Source: AGRyM1vpHdR+++4F6Rzrttu7QmIXX746plknU+annn8p6oKDODgOjJeco4YhMOrhhevHCXQCd1MXQg==
X-Received: by 2002:a05:6402:d05:b0:425:b5c8:faeb with SMTP id eb5-20020a0564020d0500b00425b5c8faebmr74752edb.273.1656452174287;
        Tue, 28 Jun 2022 14:36:14 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id lu4-20020a170906fac400b006fec69696a0sm6817919ejb.220.2022.06.28.14.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 14:36:13 -0700 (PDT)
Message-ID: <c84bdaec-3691-de84-95a5-d600e4b7ac2f@gmail.com>
Date:   Tue, 28 Jun 2022 22:33:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC net-next v3 05/29] net: bvec specific path in
 zerocopy_sg_from_iter
Content-Language: en-US
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
 <5143111391e771dc97237e2a5e6a74223ef8f15f.1653992701.git.asml.silence@gmail.com>
 <YrtfMr+waxp37ru9@ZenIV>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <YrtfMr+waxp37ru9@ZenIV>
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

On 6/28/22 21:06, Al Viro wrote:
> On Tue, Jun 28, 2022 at 07:56:27PM +0100, Pavel Begunkov wrote:
>> Add an bvec specialised and optimised path in zerocopy_sg_from_iter.
>> It'll be used later for {get,put}_page() optimisations.
> 
> If you need a variant that would not grab page references for ITER_BVEC
> (and presumably other non-userland ones), the natural thing to do would

I don't see other iter types interesting in this context

> be to provide just such a primitive, wouldn't it?

A helper returning a page array sounds like overshot and waste of cycles
considering that it copies one bvec into another, and especially since
iov_iter_get_pages() parses only the first struct bio_vec and so returns
only 1 page at a time.

I can actually use for_each_bvec(), but still leaves updating the iter
from bvec_iter.

> The fun question here is by which paths ITER_BVEC can be passed to that
> function and which all of them are currently guaranteed to hold the
> underlying pages pinned...

It's the other way around, not all ITER_BVEC are managed but all users
asking to use managed frags (i.e. io_uring) should keep pages pinned and
provide ITER_BVEC. It's opt-in, both for users and protocols.

--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -66,9 +66,16 @@ struct msghdr {
  	};
  	bool		msg_control_is_user : 1;
  	bool		msg_get_inq : 1;/* return INQ after receive */
+	/*
+	 * The data pages are pinned and won't be released before ->msg_ubuf
+	 * is released. ->msg_iter should point to a bvec and ->msg_ubuf has
+	 * to be non-NULL.
+	 */
+	bool		msg_managed_data : 1;
  	unsigned int	msg_flags;	/* flags on received message */
  	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
  	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
+	struct ubuf_info *msg_ubuf;
  };

The user sets ->msg_managed_data, then protocols find it and set
SKBFL_MANAGED_FRAG_REFS. If either of the steps didn't happen the
feature is not used.
The ->msg_managed_data part makes io_uring the only user, and io_uring
ensures pages are pinned.


> And AFAICS you quietly assume that only ITER_BVEC ones will ever have that
> "managed" flag of your set.  Or am I misreading the next patch in the
> series?

I hope a comment just above ->msg_managed_data should count as not quiet.

-- 
Pavel Begunkov
