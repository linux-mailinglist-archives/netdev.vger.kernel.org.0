Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A979F2A2EE0
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgKBP7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgKBP7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:59:48 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EA5C0617A6;
        Mon,  2 Nov 2020 07:59:46 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id u62so15427551iod.8;
        Mon, 02 Nov 2020 07:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QHc5JlbGMGNH8jfu5HfM3y6Jxs12eZUqvDoNPmYM6oM=;
        b=LEO/F0VAoAbGE5kQERs06DsV9hfdxIlml6+GcQ8V6NnWOD7wxa1APW3IaM3ygkUw9H
         TcqFr/nNb4zvtBOqWpvrHUlTlPtZlQHTTB1IU2DmH1y15w5rzOx1mxKkeWHZpG63DfpT
         YgoSNXPPW4+eWFblfmK+u65TYDE/Efy3puqtf2fdTF75mZ5LH1xPEOkaj4FzHmvZjgeb
         GTp5Pwd74suni80+Q6V9UOzQsqa3UBCNhCj3XbVKvFKizNqqD+914wqXe+9LOmIv8JIv
         gGBer39wCXzt1R2WMmOnkrsPeu2uMAYXCgcdXljpxcqAvPDA/KuZejP+yItA1au99h4H
         umAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QHc5JlbGMGNH8jfu5HfM3y6Jxs12eZUqvDoNPmYM6oM=;
        b=Gbaj9fcyr0XryhTSs0WDOJ1ljglfzbMHmeep8wk8abszonlZEy7RFxu4ZbbveQUxDY
         Z/jGuvMme0gQ8f0SokMbP9GaUqgFrLrnV4kAgTXDItuKYnZsun1mCZcNgOLvS3xMI/Fn
         TIM7SkKqh64XHtey6vq4wDDOtzMVIis5Ctv2brxosKJOGXWQ9MnVEzFmvnoEGJOCQTyF
         MqXjasl2a9GdKP+DcAMDRcpKJ0spG/Gl0n43f5dO8/9XgrzgrTfFj6/JeqHQ7XMhawdJ
         Es6RpIOED5wXTbhnHVFLJqbn7MHAsN9I9QQaZyG8PuTXRLTEaYPJSw9dlRSWNy7Gp2yZ
         e2KA==
X-Gm-Message-State: AOAM532qD5GT/heJTylv0ZxJMGfBMkOAJcaR32A47sIH+UbXsT3C+7qC
        TAjpwuHNfYPi6sDqpnCJj8Y=
X-Google-Smtp-Source: ABdhPJzooQlhU3fqop+yLJyaH8zRPdUYL4aVHH/HpdEMprnDJZs04CBo3yF2WpP9pHurLA5swn/93g==
X-Received: by 2002:a02:cd15:: with SMTP id g21mr4338615jaq.25.1604332785808;
        Mon, 02 Nov 2020 07:59:45 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4ca9:ddcf:e3b:9c54])
        by smtp.googlemail.com with ESMTPSA id l17sm9153011iol.30.2020.11.02.07.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 07:59:44 -0800 (PST)
Subject: Re: [PATCH bpf-next V5 2/5] bpf: bpf_fib_lookup return MTU value as
 output when looked up
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
 <160407665728.1525159.18300199766779492971.stgit@firesoul>
 <5f9c6c259dfe5_16d420817@john-XPS-13-9370.notmuch>
 <20201102102850.1dc3124a@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dd0d1a41-1d1d-5104-0fa0-42241f5a960c@gmail.com>
Date:   Mon, 2 Nov 2020 08:59:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201102102850.1dc3124a@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/20 2:28 AM, Jesper Dangaard Brouer wrote:
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index e6ceac3f7d62..01b2b17c645a 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -2219,6 +2219,9 @@ union bpf_attr {
>>>   *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
>>>   *		  packet is not forwarded or needs assist from full stack
>>>   *
>>> + *		If lookup fails with BPF_FIB_LKUP_RET_FRAG_NEEDED, then the MTU
>>> + *		was exceeded and result params->mtu contains the MTU.
>>> + *  
>>
>> Do we need to hide this behind a flag? It seems otherwise you might confuse
>> users. I imagine on error we could reuse the params arg, but now we changed
>> the tot_len value underneath them?
> 
> The principle behind this bpf_fib_lookup helper, is that params (struct
> bpf_fib_lookup) is used for both input and output (results). Almost
> every field is change after the lookup. (For performance reasons this
> is kept at 64 bytes (cache-line))  Thus, users of this helper already
> expect/knows the contents of params have changed.
> 

yes, that was done on purpose.

Jesper: you should remove the '(if requested check_mtu)' comment in the
documentation. That is an internal flag only -- xdp is true, tc is false.
