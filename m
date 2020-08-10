Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58362407EC
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgHJO4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgHJO4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 10:56:11 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4E2C061756;
        Mon, 10 Aug 2020 07:56:11 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k13so4990704plk.13;
        Mon, 10 Aug 2020 07:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ewxZsA2sOKsYvtVwAS6LdLqeVgx5AXOVS7mYEisKyOo=;
        b=TcjsJ2MnNMsEBg3Tm7czoe3hzZLz8q9xyHzKW1xxJOG/99Gje2jsohx2Eos6AFSsfj
         MkKEgG9f1yciUHnN2cs3WkibpmTTRGdR1qL8RQTytz1CdkycyBAUwlobys0gkeKu7RgJ
         UD3ywrx1HmYJKAwUhXyIfHb34s8li2nqXGMIfy4mC2XLoaoUImo1RoH1IbqqYlFKRW4A
         nOXGkfXooupWbLdROt3IhtANCH7Z20KV7CEs0QmkJSH6psEuDvZPcXm4KMNEKqMX2nJc
         oYvi/MtOlrhb1Sv86YpYOToFsBxCYeMwzolzRNN/2+LN6DHlNlaNBegYrwPitL3tJ3U9
         R8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ewxZsA2sOKsYvtVwAS6LdLqeVgx5AXOVS7mYEisKyOo=;
        b=jADACSWHR2WJR4IYYBHLJKvS2N7PB5zF/oKFr72p7xtSlsUCJN5ARVFG3bHJaNAu7/
         gh6bgT1ffOZZdTuegph9wZIz4j2zKxs0h+SJXnuM2tUWuvhrXzpEWgL0iQkX9lkLKkT9
         PnY2Ug7/hhWfQBo+r2h6k8vHcmo28AquKWwv7DQk/aCKr0J6wkoFGtk6PO7e1fq7OZ47
         mMKwrkpBIyD2VlVrX2kHfzHmvUjWeHCKrPwV+iyBRtLYlMo4QLyTydmeka6zMCh3v3Q5
         t5Fa1QWeWcSdyHhMWWwza7A87pO5PrcBKlAehM3ll9IGct3JsVOjvkEVdj/Q7cQR7z39
         KOpg==
X-Gm-Message-State: AOAM532BEJoa21gcPoA163EHvcaBVrQe8iZMP7QkJQG8Y0wyduS8c5F7
        nmw+ytuQRGQ5hH35dh0GoXE=
X-Google-Smtp-Source: ABdhPJy5OpDtINvGIeTTw1imy9XHYqjGHJ6nYPjRzqXk66t/mQSKFM1YgwrIVwUIP1hUjlrNdIYyoQ==
X-Received: by 2002:a17:90a:8589:: with SMTP id m9mr28316923pjn.109.1597071371386;
        Mon, 10 Aug 2020 07:56:11 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 3sm19857146pjo.40.2020.08.10.07.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 07:56:10 -0700 (PDT)
Subject: Re: [PATCH] bpf: Add bpf_skb_get_sock_comm() helper
To:     Jiang Yu <jyu.jiang@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        zhanglin <zhang.lin16@zte.com.cn>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ignatov <rdna@fb.com>,
        Quentin Monnet <quentin@isovalent.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc:     opensource.kernel@vivo.com
References: <20200810131014.12057-1-jyu.jiang@vivo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <315a12d8-abd9-f9d3-a1b2-bcec8598a984@gmail.com>
Date:   Mon, 10 Aug 2020 07:56:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200810131014.12057-1-jyu.jiang@vivo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/10/20 6:09 AM, Jiang Yu wrote:
> skb distinguished by uid can only recorded to user who consume them.
> in many case, skb should been recorded more specific to process who
> consume them. E.g, the unexpected large data traffic of illegal process
> in metered network.
> 
> this helper is used in tracing task comm of the sock to which a skb
> belongs.
> 
> Signed-off-by: Jiang Yu <jyu.jiang@vivo.com>

fd can be passed from one process to another.


