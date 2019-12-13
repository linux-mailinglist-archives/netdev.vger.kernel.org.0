Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5DA111EE54
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLMXQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:16:42 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36722 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfLMXQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:16:41 -0500
Received: by mail-pl1-f194.google.com with SMTP id d15so1866317pll.3
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=601oBsr77EQhNFs/dr6ZoJ7lQityJa2544MHyzhFH/k=;
        b=j8fb6KFlWEq1GI/ePHkxyRLQwqFG1Y6N7VuuJak0tWx/RpgaMpQByfqFp9QCH/S6TO
         C8Wjzf7Aj+i3hQIl9EKJv6cT8m7kTl8uUwoag0bhXduj0nGbTLYdYL2qMe7TGd+rMF3X
         MNHqhYmbz78rE+WdtVIwCV8XDfLerkZgMVt6SbbodYYL9IMEV7BrD20CBy4jFi27pvpA
         +2nqBMNdLguwVvbp4LAeaKRFbp1fX+ySg9+FWf9SG6t3R99OyVzpa8stfk64Bb1PVpq/
         Sc57/BHCJSee8IiwAlUa6yYHz2P51exPa8Djyek30fQx9+4EGiq6nt8Rdr/9n7EL4fTH
         ynXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=601oBsr77EQhNFs/dr6ZoJ7lQityJa2544MHyzhFH/k=;
        b=WXoIg/skweu0kNSSuA2YRRHIzQHQXmrYIah4t1TAxtZwBstZuGwXQNiitXfFvQMnn9
         vD/C+YBzEc+QQbKwbVBJRxQ9DJkvxntTZXNdxsl5uxxcY8L0YVY9ndQrSCKiVklEG1VS
         LjCfY3h0Bu81V6H/7+fAbBn683UrLhg7KUT/tHE+sVqXirvEpJxKVHES+lK4QiVTiskr
         pMS4NTtz4uf1q8X0p30EXMYn9tEUEipV4p2TM0XapGFgyZhmBJIbqtibtKONMFqP6HnW
         Kf+6DD0mWuWX8VPsbDq3lyVvFTrg4fDU+VYRDMQh6EsYYm+kcBnbRBS81K1Xcv2McFMn
         Alqg==
X-Gm-Message-State: APjAAAXbnvUyxsA0xJ7WA0l41TprVy9fbQIyQY2psav1xEzBXuPwxmM9
        fL6QwPeFIGFENlfHVXvPPuo=
X-Google-Smtp-Source: APXvYqyQFpo9KwTnjf1hy/E6VrVoZ6I4EFwCtNfwhwYgoncr1SJLRFbaAJyD+apbDxp7DbATghiD0Q==
X-Received: by 2002:a17:902:aa8f:: with SMTP id d15mr1968514plr.276.1576279001377;
        Fri, 13 Dec 2019 15:16:41 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id x4sm12820722pff.143.2019.12.13.15.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 15:16:40 -0800 (PST)
Subject: Re: [PATCH net-next 02/11] sock: Make sk_protocol a 16-bit value
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191213230022.28144-1-mathew.j.martineau@linux.intel.com>
 <20191213230022.28144-3-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9a83715c-92c3-7e3e-304d-34b1d9285138@gmail.com>
Date:   Fri, 13 Dec 2019 15:16:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191213230022.28144-3-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/19 3:00 PM, Mat Martineau wrote:
> Match the 16-bit width of skbuff->protocol. Fills an 8-bit hole so
> sizeof(struct sock) does not change.
> 
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  include/net/sock.h          | 4 ++--
>  include/trace/events/sock.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 81dc811aad2e..9dd225f62012 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -456,10 +456,10 @@ struct sock {
>  				sk_no_check_tx : 1,
>  				sk_no_check_rx : 1,
>  				sk_userlocks : 4,
> -				sk_protocol  : 8,
> +				sk_pacing_shift : 8,
>  				sk_type      : 16;
> +	u16			sk_protocol;
>  	u16			sk_gso_max_segs;
> -	u8			sk_pacing_shift;

Unfortunately sk_pacing_shift must not be a bit field.

I have a patch to add proper READ_ONCE()/WRITE_ONCE() on it,
since an update can be done from a lockless context ( sk_pacing_shift_update())
