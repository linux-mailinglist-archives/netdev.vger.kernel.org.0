Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1284F1221EE
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 03:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfLQCZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 21:25:58 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41070 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfLQCZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 21:25:58 -0500
Received: by mail-pf1-f196.google.com with SMTP id s18so6665774pfd.8
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 18:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cvy7msiU/EIcDSl9XPhMgZQJb5Hqfp0t8LdYrFOUdgI=;
        b=bafiHx71PfwIUoJ1dg+rvCm9W9pWV0RtDTlS/i88PtZ6uHqJnMCXql6af6PatImuUJ
         2tG8mSAeFUd+kcFCkQr4RS6u5yrrs/9+Dn/J9vE6G+u7b8RInmChMDoGYCT8vgE0nzEM
         2DmwWpHmm5ef2rGXtyUx/SKjv52p6vLl19F1QvfNKC0OMEC57oVG175RtN9TtHkBZ/mZ
         IgfdScyHgKLmqBUY5bYYP86kUcezoOs18Hu9wQKy1rsRkjBUsmz4B1dgJXlMwvwtRdZe
         e7f+0s2p08RTNfEqWIZDSl1uOvaM67+82IAVPtkKQsqtiWXLfyDGn7yci5csYehFYc2E
         GA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cvy7msiU/EIcDSl9XPhMgZQJb5Hqfp0t8LdYrFOUdgI=;
        b=t+75ehL/RlnAQciiP6MVb5Zec2ETt7rX0w+MRqqZBrOQ87xUyuh5LOGBEU9qIQt9m7
         Fo6z2/iMSDvCXAH8Zle/qGn8BqmC49JWrKMtb8HwFxPCerr80ofLHPKaq6/245cyk30w
         KBHmf/NdLFPATipIGbT8tMlmez0ybpyOsjDd4dk+YfM5rdGW0AsDRyIt+4XDeerOW8fA
         UeXhfkrQBwmRRkdy9YTyQd0qtNKU8ztqSW4HwOEE1MUbc04YlsV+9PHtSTdhk47mK+e8
         +Xfx+QB6jipQjaR0cxW98iVY+CndsGi/SLWz8FbQNxEh52y+i6TMwesoegOvIE1cOWpn
         RzWQ==
X-Gm-Message-State: APjAAAX+JgUGaiMGOJ7/CGpZ53C58gZ1JKxd2ASE0wZaQswKrwbn5Lkv
        0hEXXTObK+uUyf7xg+/dIRs=
X-Google-Smtp-Source: APXvYqxZMZ/56451tfibsDssK5dnF+sOqzwoJfWaMcPgRrtAyOINAhapK0+hn9LyfpGhlMhYGA5OAQ==
X-Received: by 2002:a63:d543:: with SMTP id v3mr21874310pgi.285.1576549557192;
        Mon, 16 Dec 2019 18:25:57 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y197sm15527255pfc.79.2019.12.16.18.25.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 18:25:56 -0800 (PST)
Subject: Re: [PATCH net-next v2 02/11] sock: Make sk_protocol a 16-bit value
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Paolo Abeni <pabeni@redhat.com>
References: <20191217002455.24849-1-mathew.j.martineau@linux.intel.com>
 <20191217002455.24849-3-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <03207138-4067-d3dc-c904-e9ff4a8ed197@gmail.com>
Date:   Mon, 16 Dec 2019 18:25:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191217002455.24849-3-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/19 4:24 PM, Mat Martineau wrote:
> Match the 16-bit width of skbuff->protocol. Fills an 8-bit hole so
> sizeof(struct sock) does not change.
> 
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
> 
> Changes for v2:
> 
> Moved sk_pacing_shift back to a regular struct member, adjacent to the
> bitfield. gcc then packs the bitfield and the u8 in a single 32-bit word.
> 
> 
>  include/net/sock.h          | 4 ++--
>  include/trace/events/sock.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 81dc811aad2e..0930f46c600c 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -456,10 +456,10 @@ struct sock {
>  				sk_no_check_tx : 1,
>  				sk_no_check_rx : 1,
>  				sk_userlocks : 4,
> -				sk_protocol  : 8,
>  				sk_type      : 16;
> -	u16			sk_gso_max_segs;
>  	u8			sk_pacing_shift;
> +	u16			sk_protocol;
> +	u16			sk_gso_max_segs;
>  	unsigned long	        sk_lingertime;
>  	struct proto		*sk_prot_creator;
>  	rwlock_t		sk_callback_lock;


sk_type is no longer at a 16bit (u16) aligned location, which might force the compiler
to do extra operations to fetch sk->sk_type on some arches.

Note that I do not even know why sk_type is a 16bit field, we might be able to convert it to 8bit.

