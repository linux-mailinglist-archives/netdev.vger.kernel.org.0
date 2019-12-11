Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4AB11BA94
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbfLKRqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:46:14 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:36980 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729524AbfLKRqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:46:14 -0500
Received: by mail-qv1-f65.google.com with SMTP id t7so6101796qve.4
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R0P0Y1a/Xb4Yphy7cYArxGYogHcENsqlChHMdlK9fz4=;
        b=nYrZLGmOcau5Wd9l29nWfc0Q2LHZnqoQqzi19iOMn/Hd2z0pYoKdbpPvKnbQ5jr8zV
         OIwGzdWzOm88nAgFnrbf3tEyrzyCrU7S/62/PRqLsgyNnXxJRHeLZv8GAhwlYo3dPwor
         nx0oLtsPuRhtZ60bBgrmiD7YRZ2GGZed+Tj2G4zgAutqdEqasA4s5K7IGewHiAjPYmGU
         zTO9LSXhVFxrJIixQ42Hm30BlAIGMQJ43bxBvq03Xn7zezEa8vTZBEqtrDJ+b35Q0uwL
         Sr5xLHWIlOO28m7EnBAX27B1iSW9rBFYIzSbMCySptdtMiw2cwgzQJ2ttUH8YylNktEN
         POhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R0P0Y1a/Xb4Yphy7cYArxGYogHcENsqlChHMdlK9fz4=;
        b=tEUrUSxT6hONl0sp/XboZkC9lgdAjJ80WjQnE1RuPUTt2FcWGxXRLRdBtJeukpJR93
         AKmTIhHaE0CDJ3PBJ0lfADtmKmXVHTI9LKdhmf0OXIORrnDGfWt/LRW5PO5LoGWFp4Oo
         RvVyer13fiGWhirciDKhJDfuvbtwfC2/W8kSi9gebzWVK+0iYpoVA//JCaO5cm8NB1KB
         pTGq7vVIlPbfQXikWKOzOne5qSMkgSYf34afaHcukph+HyD17mAMLerTyFMiw7CEFqEM
         H0u64zHv9gQnmVhckG0aRoOiW1BHICdtY2tuqaZYkEMsQNu0PV52PyQWBHT9YLgni+Iu
         vmNw==
X-Gm-Message-State: APjAAAWPVmWSqAwWLGee5qA3GnSJXqkdES3mhfUUqyEqxvXAqw3K63SR
        7zuO0NsCIxJMuGoqDikguF8=
X-Google-Smtp-Source: APXvYqyhnLZphIa9i7MaHLOSgz+SaM2JEi8RNNySlhicNnVSwETGCQDSKmpO3swrTR+r5bDtYpFXOw==
X-Received: by 2002:a0c:9c86:: with SMTP id i6mr4191604qvf.214.1576086373235;
        Wed, 11 Dec 2019 09:46:13 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id r41sm1126654qtc.6.2019.12.11.09.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 09:46:12 -0800 (PST)
Subject: Re: [PATCH net-next 6/9] ipv4: Handle route deletion notification
 during flush
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20191210172402.463397-1-idosch@idosch.org>
 <20191210172402.463397-7-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7ad891f6-a096-2795-2e7f-5eefc710503b@gmail.com>
Date:   Wed, 11 Dec 2019 10:46:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210172402.463397-7-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 10:23 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> In a similar fashion to previous patch, when a route is deleted as part
> of table flushing, promote the next route in the list, if exists.
> Otherwise, simply emit a delete notification.

I am not following your point on a flush. If all routes are getting
deleted, why do you need to promote the next one in the list?

> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/ipv4/fib_trie.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 2d338469d4f2..60947a44d363 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -1995,6 +1995,8 @@ int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
>  				continue;
>  			}
>  
> +			fib_notify_alias_delete(net, n->key, &n->leaf, fa,
> +						NULL);
>  			call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL,
>  						 n->key,
>  						 KEYLENGTH - fa->fa_slen, fa,
> 

