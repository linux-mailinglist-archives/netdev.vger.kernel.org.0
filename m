Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462F44656FB
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245521AbhLAUVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238230AbhLAUVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 15:21:03 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B3AC061758;
        Wed,  1 Dec 2021 12:17:42 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id l16so54875281wrp.11;
        Wed, 01 Dec 2021 12:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bZLA4Cc1gP5Q5im8BpOiaRiaj3XtOM5lk5oHTlIAmW0=;
        b=ZVZ+DEdS+bicoTkpu0maw3d+X/nOU8wwm0AQ5C3EEUC2pj3o7s7HHj/V3oY0XKYodk
         TsDXu+Wz1g1nDlI5nwcn5LXOY50HXdbFCm7FnWBj4EkjOMVxBVC78vNKRIMjoRaqTSH5
         zEwZL7lYGKar8s2j4I52Qv3RtsR2Ab+yhKe/F7U0AZD6hjEeuD7VYaznuTmc7ISoAt6V
         0KwrDr2RjP9rq9E3HYIYyDYUqKcBirbaZzm2Zq4uQJmAbvdvH4Q5Z75NS6r/13tyOGDL
         efJ4Ysx1KKpxIAqW1rCN8LJoaZSDZHOiV6qgYzWxZOkRnj0gnefy4hLXl3z8xcDTDfkJ
         3fqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bZLA4Cc1gP5Q5im8BpOiaRiaj3XtOM5lk5oHTlIAmW0=;
        b=aunLLUqN3AyRTPV3yYpOf00hDXVGePUWs+2DODBQLdoHEMqBQiCr4UQO5dsE/A9cB7
         +ZJPq0MdI9l5rBKv08iJtYjxsLVnRwL8WG07r+D0Jf+Zojh/vpQ6Zl7nEueTT2wWJfxn
         q5XZDqqXg5jkd1H2A7aERC9gLvlK5nmpZw14HT8Zqhn1cgf9nvPI8qYn7FMh1wJ9n1Im
         l2RA5OVERjVNxnSSss/XG3P2xFEj9mcQCkvCs2/I1xhIcmft1aL058hhxD0SrVEMAB82
         YYHiZSJq0lq9JRHqb7KqyKt86zfIPmjlTSYLiqXsoENcQtZ8PvTJbiPJbN4a3KG+GZ4r
         qihA==
X-Gm-Message-State: AOAM530hFg0MvXC5o5nRMSJuAwoVf/EGsz0w9hIO1+HcyUFK1Z1zLK5A
        zUstQKbnUMbXbhVswr70C6E=
X-Google-Smtp-Source: ABdhPJwD6JDD0zm0cHanRMt7tWmYrkBb4yRD+fKjnOQ1VT+EIXc++sg6IJ5LgSfXGPRY1RQKuRG2rA==
X-Received: by 2002:a05:6000:2a2:: with SMTP id l2mr9226808wry.110.1638389860790;
        Wed, 01 Dec 2021 12:17:40 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.129])
        by smtp.gmail.com with ESMTPSA id f15sm332710wmg.30.2021.12.01.12.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 12:17:40 -0800 (PST)
Message-ID: <d4ef96a8-94e7-bd9d-b3b9-f4f8e85373e4@gmail.com>
Date:   Wed, 1 Dec 2021 20:17:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 05/12] net: optimise page get/free for bvec zc
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <72608c13553a1372e7f6f7a32eb53d5d4b23a1fc.1638282789.git.asml.silence@gmail.com>
 <20211201192043.tqed7rtwibnwhw7c@bsd-mbp.dhcp.thefacebook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211201192043.tqed7rtwibnwhw7c@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 19:20, Jonathan Lemon wrote:
> On Tue, Nov 30, 2021 at 03:18:53PM +0000, Pavel Begunkov wrote:
>> get_page() in __zerocopy_sg_from_bvec() and matching put_page()s are
>> expensive. However, we can avoid it if the caller can guarantee that
>> pages stay alive until the corresponding ubuf_info is not released.
>> In particular, it targets io_uring with fixed buffers following the
>> described contract.
>>
>> Assuming that nobody yet uses bvec together with zerocopy, make all
>> calls with bvec iterators follow this model.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
[...]
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index b23db60ea6f9..b7b087815539 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -666,10 +666,14 @@ static void skb_release_data(struct sk_buff *skb)
>>   			      &shinfo->dataref))
>>   		goto exit;
>>   
>> -	skb_zcopy_clear(skb, true);
>> +	if (!(shinfo->flags & SKBFL_MANAGED_FRAGS)) {
>> +		for (i = 0; i < shinfo->nr_frags; i++)
>> +			__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
>> +	} else {
>> +		shinfo->flags &= ~SKBFL_MANAGED_FRAGS;
>> +	}
>>   
>> -	for (i = 0; i < shinfo->nr_frags; i++)
>> -		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
>> +	skb_zcopy_clear(skb, true);
> 
> It would be better if all of this logic was moved into the callback
> under zcopy_clear.  Note that this path is called for both TX and RX.

Yeah, can be done and removes the extra if from non-zc path.
Thanks!

-- 
Pavel Begunkov
