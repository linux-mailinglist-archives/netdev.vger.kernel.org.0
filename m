Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595F54C9C28
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 04:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbiCBDaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 22:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiCBDaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 22:30:23 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DFFB0D17;
        Tue,  1 Mar 2022 19:29:40 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id o7-20020a056820040700b003205d5eae6eso12644oou.5;
        Tue, 01 Mar 2022 19:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6Q0bxE67I8y0tNyscEgKpcVLyNoRx4Y38uQCKmsrJXs=;
        b=Y947JocD2+sMdok3nZr8cn9CnXm1HJHtBdilWI7XGsiHzz0gnVNoW6s9GlC6DCPo8f
         Hs3+xo9n5QzmKwx5UOu6jbuBvVKgaIU3IhRp1TzH8GXoPgxc/s4KMu4HP/nhYi3apncQ
         zu1Cd7RJbcX1Jh9Kq4Dw/CMTQj7hvtBi/A/ags+MJPqUdzC2yREUAe73YJIy4Ir1H+/n
         kwv9pmdrPZtlff3xH41ULkhMu4ZWblUt2VDr37uoq0gVboVn8LE//4Qwily7fjxzhlkC
         vSGnK+i4ktzKLhZ93hsvIEitS0vDTkgD5mmRr3i3cJkYp126CL78a0tUShM2xg5HLb4f
         0wDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6Q0bxE67I8y0tNyscEgKpcVLyNoRx4Y38uQCKmsrJXs=;
        b=A38/NL5lbkPEOH9Bd80aq66uLBk8Is3f/3lAsqXYw36WubMLcJnWLX90HPUlwLLCqt
         cOFaGAVwYGxghNANTi09VSiX+xLM/t1qVIhJGgNjGuHfsPvc+Vo9i9cV8obzj2UMH73D
         /4FLWwlyTzI4Z5UiVH4kGclHqUFU89XQEQWUnvlUspvHDLMoNvMYxlPFFUs1QdogrSQN
         kDb/5JCj4H4QHH0Hr1c1+Qrd9uSZEeRLlGJiVFynrC0yzOGJ9MoQ3gZodN+aOXSitiv/
         OETgWp79WC5kVpngaovw+JnDl7TH4XAPabBpXaBJMkaK78B1Aw75ME1gmzeRfGCByH+8
         WpzA==
X-Gm-Message-State: AOAM531eBlOKwH4SP1yHW8lM+xYJl40qs7lFT24mdIqUYKbLvrl8rNfJ
        6prMhxoXkdHwtAFH1p0rmtA=
X-Google-Smtp-Source: ABdhPJy17OB73gebQWHaD3DcjnRxBmx0KdCe+tnIIJ0DXj+s62oFSr9rFn+6UqsMBVq99jXvVqMUKA==
X-Received: by 2002:a4a:e865:0:b0:318:4b66:ffe0 with SMTP id m5-20020a4ae865000000b003184b66ffe0mr13923364oom.80.1646191780103;
        Tue, 01 Mar 2022 19:29:40 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.59])
        by smtp.googlemail.com with ESMTPSA id kw10-20020a056870ac0a00b000d75f1d9b87sm1061411oab.52.2022.03.01.19.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 19:29:39 -0800 (PST)
Message-ID: <2071f8a0-148d-96fa-75b9-8277c2f87287@gmail.com>
Date:   Tue, 1 Mar 2022 20:29:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH net-next v4 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Dongli Zhang <dongli.zhang@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
 <20220226084929.6417-5-dongli.zhang@oracle.com>
 <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8
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

On 3/1/22 7:50 PM, Jakub Kicinski wrote:
> On Sat, 26 Feb 2022 00:49:29 -0800 Dongli Zhang wrote:
>> +	SKB_DROP_REASON_SKB_PULL,	/* failed to pull sk_buff data */
>> +	SKB_DROP_REASON_SKB_TRIM,	/* failed to trim sk_buff data */
> 
> IDK if these are not too low level and therefore lacking meaning.
> 
> What are your thoughts David?

I agree. Not every kfree_skb is worthy of a reason. "Internal
housekeeping" errors are random and nothing a user / admin can do about
drops.

IMHO, the value of the reason code is when it aligns with SNMP counters
(original motivation for this direction) and relevant details like TCP
or UDP checksum mismatch, packets for a socket that is not open, socket
is full, ring buffer is full, packets for "other host", etc.

> 
> Would it be better to up level the names a little bit and call SKB_PULL
> something like "HDR_TRUNC" or "HDR_INV" or "HDR_ERR" etc or maybe
> "L2_HDR_ERR" since in this case we seem to be pulling off ETH_HLEN?
> 
> For SKB_TRIM the error comes from allocation failures, there may be
> a whole bunch of skb helpers which will fail only under mem pressure,
> would it be better to identify them and return some ENOMEM related
> reason, since, most likely, those will be noise to whoever is tracking
> real errors?
> 
>>  	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
>>  					 * device driver specific header
>>  					 */
>> +	SKB_DROP_REASON_DEV_READY,	/* device is not ready */
> 
> What is ready? link is not up? peer not connected? can we expand?

As I recall in this case it is the tfile for a tun device disappeared -
ie., a race condition.
