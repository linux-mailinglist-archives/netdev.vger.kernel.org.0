Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399B3124D93
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLRQ3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 11:29:35 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35389 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfLRQ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 11:29:35 -0500
Received: by mail-qk1-f195.google.com with SMTP id z76so2427605qka.2
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 08:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IZJ7dNbiyiB8db+nAwRnYeXdQX2GlN4DaIcyjs5yc18=;
        b=ot12EiYWP1zFRpNPAU0C/DYPa8RCfSE6lu5OMEaI5Rh5+hzP4fuMSHCwRanyovW5tu
         3dyM/HqDzjEEx4IN0TTf+qgeRAI+x0BP5JIQnXGHccwxtfFjy1SH2ya5wgZezD9WWUL3
         E5iZk8fHe5P9usfHdKm+Q/L6Bi0G1XFK+H7H1hEBsgBcpg9nJ6BEMSu+nFWTQt+bV8Ai
         QlusiThaVT+EKIfZ6RUrSm/8ZuFf2W8pssX4GkwT3MY5LQw12jmPkG8iYHu2hqgyTh3Z
         a8b8YLYLRPQ2om4KjApyvXjT++nrlbZ6O5tdhRfm9V8yhQS2QLE4pUNKkHZ6fJC+0N8M
         iE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IZJ7dNbiyiB8db+nAwRnYeXdQX2GlN4DaIcyjs5yc18=;
        b=bSfzlcvJZsC+8pfUunal5rEtLOYWPm50wXnNUJwLTNjD2LJdTlVk/SJoy91+Mrk/nf
         7BQH1ngqfSDvN4wAi5mjTBqBx9lmw568R2oICQdhEDngISLchX1xfCd2WydTAq3pfRkI
         0fP/GoyUcEDrKHkmOsk3QYKnL9qT+xWQKSzUslIN89C5MbLtd/2oP/2ybO4W+s1oXli8
         776+f3y8EWwBpC82zuYMNtOYbTJVIVhg2eUybutCDi01f4rmsdy4gAT2Mq/Yje7B9JDd
         awGl1NPlJ5ZPAPCnew9wc8TnN001h9aGhzuJPzPWAqEfRqTa9kfc7Nv1qX7DJ+X2IZHM
         JQzA==
X-Gm-Message-State: APjAAAWOrIfFVlE5Wb93oGzcKeCPTepvi43FybMVRMsckJNC6ow4+hFO
        27veckhMCPORcRWei8XsTAYjyO4Gg0s=
X-Google-Smtp-Source: APXvYqzltLjlWU9o8/ChXmc+88SOmBTqv6Dt0FD03Ssq8wuPUTvjCqRVVhi8UhoG/CKWjr76yocmtw==
X-Received: by 2002:a37:a197:: with SMTP id k145mr3348781qke.486.1576686574290;
        Wed, 18 Dec 2019 08:29:34 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:500:94:a756:23cc? ([2601:282:800:fd80:500:94:a756:23cc])
        by smtp.googlemail.com with ESMTPSA id r20sm875314qtp.41.2019.12.18.08.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:29:33 -0800 (PST)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-12-prashantbhole.linux@gmail.com>
 <20191218110732.33494957@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c1088bff-e86c-a3c7-6132-eeee23b80a75@gmail.com>
Date:   Wed, 18 Dec 2019 09:29:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191218110732.33494957@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/19 3:07 AM, Jesper Dangaard Brouer wrote:
> 
> You have not configured xdp.rxq, thus a BPF-prog accessing this will crash.

yes, I had a note in my early patch about this. The current XDP context
is definitely Rx focused.

> 
> For an XDP TX hook, I want us to provide/give BPF-prog access to some
> more information about e.g. the current tx-queue length, or TC-q number.
> 
> Question to Daniel or Alexei, can we do this and still keep BPF_PROG_TYPE_XDP?
> Or is it better to introduce a new BPF prog type (enum bpf_prog_type)
> for XDP TX-hook ?
> 

That is one of the design questions: can the Tx path re-use the existing
uapi for XDP or do we need to create a new one.
