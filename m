Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095853778F7
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 00:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhEIWPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 18:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhEIWPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 18:15:30 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB92C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 15:14:26 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id s20-20020a4ae9940000b02902072d5df239so612785ood.2
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 15:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aZMMbughA0LOhf4F25EEO8MQJFrxp/CEFel6ntQUmpg=;
        b=oQ+3QFkI0v0B7LUof8+Fyq6Yj0c3yNBQ9uqFi+gzZo1GOtSvPjJZDzPt78fqZcVdHP
         2RE2iSPcpzKt753wzZ0/VjqrUEn7PZiriMskehLfU19GIYIzGg062mmHRH6a3TcZtWJD
         h0kFfUft/YpZoHiInBWGoGFFdt0aYgSmVJAmKsPutsxLz1aqj+4ew6CftyNM3K0bVsua
         eT8j4/SkUdAJkwJZl8eyqvJmlXxOvuG6FHQQkiC9bVP70xjPORa4iwGdrAJ0wRjknAfy
         M9+c+1bHj7yg15XYOD4lDmMjXbJL/HD5oraM0mX4rO/xgb/Q8ltw8MUKzToRDjvFpz34
         cBIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aZMMbughA0LOhf4F25EEO8MQJFrxp/CEFel6ntQUmpg=;
        b=Ccv/aqEiHplUlh+cpMenz72qSyd445Z1MJzH8MzJCK9rkpVGOIOabW1ubZiIvWoVWY
         mz2+UEjmYeHOE7bpnhdKwkLsRptwS21Xl5AyOtjplwCP45Ji54J/+4YNS22sSTs4nP4U
         eE4ldCI0+/TjZ4gYI37HQNrl9ci1QAe7TrmiuXm+PlyivLF5K3Tvwf+CN7Hs9Ti+eC9C
         4oTcPpVdw9rPgx4D1aq0XxHZuMhTkq3AjlYK/7G7eklSv97Es9rS9P+PvcMV39CEWFZl
         mRRFHQsdhxKnlOACruLz6TqP+A8h3eVj/0GOn5Rqbh3NGXzq3p9U3nXtphMBBxCmHgdL
         EeiQ==
X-Gm-Message-State: AOAM533l4QirQP97F0u2V7V6SeE8elkT0lbkcbCWz9r5wO2W/LRVUBT1
        hs5k03/QNDbZUM5m9OpDQShac85TvSA=
X-Google-Smtp-Source: ABdhPJxMh9EgXPr15hw+IPwpRklDqD5tg1aMOuQpssjSttTCAjebvXUJume+GSd4Pmz3Q63UJptVbg==
X-Received: by 2002:a4a:b50b:: with SMTP id r11mr16710111ooo.64.1620598465975;
        Sun, 09 May 2021 15:14:25 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:5d79:6512:fce6:88aa])
        by smtp.googlemail.com with ESMTPSA id p22sm2791313otf.25.2021.05.09.15.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 15:14:25 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc: htb: improve burst error messages
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <2cf5c0b12a53f37fee1f7af9ccc3761cbda6c030.1620297647.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e87317d8-6c43-3a9a-0265-971b1c6a5bcc@gmail.com>
Date:   Sun, 9 May 2021 16:14:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2cf5c0b12a53f37fee1f7af9ccc3761cbda6c030.1620297647.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/21 4:42 AM, Andrea Claudi wrote:
> When a wrong value is provided for "burst" or "cburst" parameters, the
> resulting error message is unclear and can be misleading:
> 
> $ tc class add dev dummy0 parent 1: classid 1:1 htb rate 100KBps burst errtrigger
> Illegal "buffer"
> 
> The message claims an illegal "buffer" is provided, but neither the
> inline help nor the man page list "buffer" among the htb parameters, and
> the only way to know that "burst", "maxburst" and "buffer" are synonyms
> is to look into tc/q_htb.c.
> 
> This commit tries to improve this simply changing the error string to
> the parameter name provided in the user-given command, clearly pointing
> out where the wrong value is.
> 
> $ tc class add dev dummy0 parent 1: classid 1:1 htb rate 100KBps burst errtrigger
> Illegal "burst"
> 
> $ tc class add dev dummy0 parent 1: classid 1:1 htb rate 100Kbps maxburst errtrigger
> Illegal "maxburst"
> 
> Reported-by: Sebastian Mitterle <smitterl@redhat.com>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  tc/q_htb.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 

applied. thanks,
