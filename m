Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E162E0D94
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 17:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgLVQww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 11:52:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbgLVQww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 11:52:52 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E202CC0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 08:52:11 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id x13so12457428oto.8
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 08:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Lsxfg/MHpfImMr5AQfh/SI+s6IoY5r2reO8TKxpL24=;
        b=YEcqF7fmXWAzKS4RK5smHcP2G7ELu80nWD38H7W23VAGTyri91uxMrm3eb74OKPLbZ
         jfa0jtCLb2s8RpC76psfrSM3ah1L1d3AUXO6im7Eb3WndRTRZvHbFSlcCSGhpoZCqW5y
         ObsUvcHSDli2Ngb+1WRr5bZIfTCj17EdW19ip97KEKiHxEo5MKbKRDpTkVs1gnjQ43Uf
         VOIiMGEGP4M3B/ECO2djzdu52hH81vs99E+ozncB/0b4McTYKZW4MaaOqeqouuwu7gGA
         n/yPArWmJgXI6+lWmPU9vV6B+OB1nxnimntS4gYeshBgEasekSxtJf9/so8RfohuKXKN
         XwJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Lsxfg/MHpfImMr5AQfh/SI+s6IoY5r2reO8TKxpL24=;
        b=GM5qzEoCdX9fEHs0JKxiUwdGWdXApJa3fPK97OhZX+R2JHaaE3SZyc1SYStI5NXntj
         vhgbONCQorDxgg52Etez8atmUZ/4/olc9HzRbq3rrKVx87CZ6zN8cQxi9ePUk7Y6OUo7
         6ZFhu4CY2D5fH7hhhVGvEF3gs/42De9XvIOp/vZznm1SgvDCk+8/QgsukptoZML4S0dM
         L5V11Oiiuy3ux0xjtkNEtLbVCzwh4fZ08LC6vAVY5EogqdkhAosjqdE+Onze2jCNS2xj
         OpuZAHc1ndsJcjCdBeZxhts3y7EyvgI68eDejpCIjVBCRVH9t5GBIt2oJ9weS1ILvis1
         fixQ==
X-Gm-Message-State: AOAM532jbJv0615cV0OZcD2PPyiYBHdHmplQCz/f3E1d4F7jvY3upRz/
        3CK4hp6S3im9aBXrcX2L1lOs5ivqYis=
X-Google-Smtp-Source: ABdhPJycj7VfhbErRlT2syDqFSazvPy3RF5yNtRZBHtzk20mrslAMvm2l21Bx9p4Zt9zShpi9oxtqQ==
X-Received: by 2002:a9d:1425:: with SMTP id h34mr14018311oth.230.1608655931247;
        Tue, 22 Dec 2020 08:52:11 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:84d8:b3da:d879:3ea8])
        by smtp.googlemail.com with ESMTPSA id d10sm912164ooh.32.2020.12.22.08.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 08:52:10 -0800 (PST)
Subject: Re: [PATCH 03/12 v2 RFC] skbuff: simplify sock_zerocopy_put
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        edumazet@google.com, willemdebruijn.kernel@gmail.com
Cc:     kernel-team@fb.com
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-4-jonathan.lemon@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <aefbc3aa-c538-1948-3a3a-a6d4456c829b@gmail.com>
Date:   Tue, 22 Dec 2020 09:52:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201222000926.1054993-4-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21/20 5:09 PM, Jonathan Lemon wrote:
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 327ee8938f78..ea32b3414ad6 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1245,12 +1245,8 @@ EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
>  
>  void sock_zerocopy_put(struct ubuf_info *uarg)
>  {
> -	if (uarg && refcount_dec_and_test(&uarg->refcnt)) {
> -		if (uarg->callback)
> -			uarg->callback(uarg, uarg->zerocopy);
> -		else
> -			consume_skb(skb_from_uarg(uarg));
> -	}
> +	if (uarg && refcount_dec_and_test(&uarg->refcnt))
> +		uarg->callback(uarg, uarg->zerocopy);
>  }
>  EXPORT_SYMBOL_GPL(sock_zerocopy_put);
>  
> 

since it is down to 2 lines, move to skbuff.h as an inline?
