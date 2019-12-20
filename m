Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC20127F47
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfLTP3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:29:09 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40891 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTP3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:29:08 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so9784338wrn.7
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WTvZUoSWMSNKMHTGH4126mxenNh2hHlcTMmEH/wjPt4=;
        b=j1e+Q/Db9C7aA4YKD1uuFgKzFRODxmsPXqtmAEW+XZ8VnL7Kins7TDZAKxX/s4PXYJ
         z+bFlosTTMJUY6XStYwdY4xVrhspqmguOizAhvPc0kNWq99AuP6picLY0FFiESUvEK1f
         X/if7J+oV1DX4JyfXCaViZbX7Q2uOTUoxpnP+3sGp+ikIc+KGPsf/og/6kAnEDvpZChV
         BEro+ELDScuvj2qmzswosR6j22j7YZbMcmjXyVBpHP5QGI1mDAH43SctNayFoPaqK/dq
         egrqX1A4H0DLsrjDnsHA8Vu0ZjnlDBCap8wKma8pBpCOlz+GkqZxqQ2XUC0H0EMexpW8
         SU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WTvZUoSWMSNKMHTGH4126mxenNh2hHlcTMmEH/wjPt4=;
        b=VcKS8OKg0NGQp/gUWVROFHEdurRFHoKwNv/9h6frHUopkPNk0MQ4y0vb24baHw5kCT
         oCxdvVVXkiRqgVJHMfUO2s7WAodHnor9hJc3nd3hr8mC/SlClZn/1DBvOIz21B3pRPzC
         SLxpSJt4KoOVXnYXzY7vlsrCdHlUXZsOoP2+VL9PM3tGEfpqdRGw5MKw/Q+X+wmye0h4
         LZaX/BDYqWzLuD3F0rIh5tZP0fYQVjG2T1XU7yfDcmbRbZar8ofvq3hlmPpRJB31RcHq
         hZHNsDtzWmQw1v8PyM6hPZhBqWXQs2T9rOVeXN/i9ER++8he0MHM8p3xVvyjOUrySjp6
         6Qsw==
X-Gm-Message-State: APjAAAVh0p+QIWsTlz2L7qdafyCL5nUM1IIsu9QKxVlydfvQEfCPqwmp
        Zvw0ZoPjN+KsmT+iFmliI40=
X-Google-Smtp-Source: APXvYqwhpsQlzkgOVOGcGgW42nTMn+ZGYxmq6l1Jgjdz6x6CWzhvoiUne2JxJAbtwsUybIRGGBe51Q==
X-Received: by 2002:adf:f98c:: with SMTP id f12mr15228510wrr.138.1576855747029;
        Fri, 20 Dec 2019 07:29:07 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id f127sm8655408wma.4.2019.12.20.07.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:29:06 -0800 (PST)
Subject: Re: [PATCH net-next v5 10/11] tcp: clean ext on tx recycle
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Florian Westphal <fw@strlen.de>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-11-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5b17ec8a-3ee2-7167-8702-4f14a9b6e016@gmail.com>
Date:   Fri, 20 Dec 2019 07:29:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219223434.19722-11-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 2:34 PM, Mat Martineau wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> 
> Otherwise we will find stray/unexpected/old extensions value on next
> iteration.
> 
> On tcp_write_xmit() we can end-up splitting an already queued skb in two
> parts, via tso_fragment(). The newly created skb can be allocated via
> the tx cache and an upper layer will not be aware of it, so that upper
> layer cannot set the ext properly.
> 
> Resetting the ext on recycle ensures that stale data is not propagated
> in to packet headers or elsewhere.
> 
> An alternative would be add an additional hook in tso_fragment() or in
> sk_stream_alloc_skb() to init the ext for upper layers that need it.
> 
> Co-developed-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

