Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB29C52928D
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348754AbiEPVJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349201AbiEPVIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:08:13 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07D84A3F2;
        Mon, 16 May 2022 13:50:04 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id j28so5867876eda.13;
        Mon, 16 May 2022 13:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MfY1a6o6LRsipUi6Oijv1/30tnszerh5iJfHfrszphM=;
        b=HXCoMAoc53CH06c5TEuusqJXTGrlUt2VdqVGKB5lfJbhmEPPWp9HR6Dnyqc/DfmV7L
         Su8cjxcCGeU8dPA2kBVA8ha8yaB3hf1ElZfRFAn8kNIZdEBFGwz8YvI7sE2lYsDJrFzr
         a8WOfU7PNsseJdhf3loYxl6FkL4uJJ2THSUtbNFfuDwITDN3Miy3L0437UHFEdFxAlJW
         LBTD/JW0ECrTidnG0ITqaGuzSnJmq8X6pN3qFM/CGuAvUB3QrgCOA0MMFnfw6e1Sw6Xs
         +MqxtMeuvvdbX/jy4DRSbREuPnERScrhcsrxMVa1XmHl32QD/v1WgMlfWZK7lFpVnsCT
         mCYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MfY1a6o6LRsipUi6Oijv1/30tnszerh5iJfHfrszphM=;
        b=jWSOmcupHka+jp3E2e/mpVjZ/gv1dNAEWpWdmB2+oSGitmSLaPlk1DowW22unZLrnv
         cgE2X82XH2OCA58fLDE5cniY+HQO7oy3YBM8gMyLF6Cts3u/ZtW4sexLQPjnzw5FXGP7
         PUE/ktUJJsYRjVpW+RrUHcrkavybZGvJQjvQVVPq4WeZbBPlHgUi15fqyh99CKi4Oebz
         JkNX0h+LrvxEbQg8fuiPZm5cgFXw41zYaVxRMpqpD1dq7oAyOtoX1LqT3GKdl+LsjwQO
         hK21f3usN+jr6xXm8FkVbjDQ07YYHTQVkMFHj8UDz0r2C+RP1wX1Hdz8i9+EOKY3KdZK
         PiBw==
X-Gm-Message-State: AOAM531KmLQnlMdkDFVRY5uvLfiUWsS8UsWaBfQQETeE2/MmRLFJBI6Z
        4TIaLl3kAo9cDZNIHJK+GPo=
X-Google-Smtp-Source: ABdhPJwIpOzi7l6lLCM7TPf+IYhZrYJ9g0Gna0wLZavYvqZJBYFGgt9gp9+fD8TF4d8iq/yRn2za7Q==
X-Received: by 2002:a05:6402:4414:b0:419:28bc:55dc with SMTP id y20-20020a056402441400b0041928bc55dcmr15461714eda.130.1652734203375;
        Mon, 16 May 2022 13:50:03 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.232.74])
        by smtp.gmail.com with ESMTPSA id mm8-20020a170906cc4800b006f3ef214df0sm165586ejb.86.2022.05.16.13.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 13:50:02 -0700 (PDT)
Message-ID: <212de77f-6ad1-e012-9b49-8b5cebaded63@gmail.com>
Date:   Mon, 16 May 2022 21:48:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v3 00/10] UDP/IPv6 refactoring
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <cover.1652368648.git.asml.silence@gmail.com>
 <b9025eb4d8a1efefbcd04013cbe8e55e98ef66e1.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b9025eb4d8a1efefbcd04013cbe8e55e98ef66e1.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/16/22 14:48, Paolo Abeni wrote:
> Hello,
> 
> On Fri, 2022-05-13 at 16:26 +0100, Pavel Begunkov wrote:
>> Refactor UDP/IPv6 and especially udpv6_sendmsg() paths. The end result looks
>> cleaner than it was before and the series also removes a bunch of instructions
>> and other overhead from the hot path positively affecting performance.
>>
>> Testing over dummy netdev with 16 byte packets yields 2240481 tx/s,
>> comparing to 2203417 tx/s previously, which is around +1.6%
> 
> I personally feel that some patches in this series have a relevant
> chance of introducing functional regressions and e.g. syzbot will not
> help to catch them. That risk is IMHO relevant considered that the
> performance gain here looks quite limited.

I can't say I agree with that. First, I do think the code is much
cleaner having just one block checking corking instead of a couple
of random ifs in different places. Same for sin6. Not to mention
negative line count.

Also, assuming this 1.6% translates to ~0.5-1% with fast NICs, that's
still huge, especially when we get >5GB/s in single core zc tests b/w
servers.

If maintainers are not merging it, I think I'll delay the series until
I get another batch of planned optimisations implemented on top.


> There are a few individual changes that IMHO looks like nice cleanup
> e.g. patch 5, 6, 8, 9 and possibly even patch 1.
> 
> I suggest to reduce the patchset scope to them.

-- 
Pavel Begunkov
