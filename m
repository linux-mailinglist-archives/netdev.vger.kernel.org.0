Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEEC1AFE96
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 00:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgDSWWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 18:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgDSWWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 18:22:19 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91102C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 15:22:17 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id v7so8755037qkc.0
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 15:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=URk2hd+qkFAM4NkLlOT8SCtnPtO2ARf2SZ6uiRAO7vM=;
        b=kn1knbvs4f6mSULNAIjrXPwnt0N+Ov3AHS7a3nfhDi0mo6Byf5ArczvZ3wOdQatfBA
         pu4tcZPU3UBVtfOYz9iH+yv1PkfTUx8pK/j/nnHcHaHrUZq99x+EXVbDT9uWqs/6u6kH
         v4V10x9p+VtH80HzTCzqv8jt0XzdJXP4UAw8xihLJKGa9xeivtOEz0lY0Voa1UliXVyM
         eib3uaZkY1EA3oPHfYvJ4dU8F1uA3y5jCNIA/PnhLWaS1+OMCMGSW+J2m8z4jJhW1jVG
         JfhNV7KT7zQBp8Y9mBZM5JVd+4CA0m87oZ5FbkgU1+SCxXQwzZSkAfOnJm9fXfsrRZx1
         6llw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=URk2hd+qkFAM4NkLlOT8SCtnPtO2ARf2SZ6uiRAO7vM=;
        b=cIwn0peSB1iByR4XR9bdO9cmai96oGc1ugTfNbjI1P6JDmUiXocNikcBgnFOUr2Brz
         rN3XFRG4G8GlVlnICCHcLUxatDEG7gJqry8sN3YMgAHij6UEWkHEggEZIL7j1xYXgc0c
         Z6BeryhyyhFbzeA8JOfCQKqUwd1vY+pAQl5okTXhVs25HbS1uZNq62sSIZAxg1Bfev7K
         ZAhHo9GMR9KvEOYQ7/Nb69RF51/ujXWqnUwzO0uiiUyxxIEG4SNG981eFcN7GuZjjKFU
         9n4DR45ZlAhBl4N68IU4v13hFJXaHo7XbFpFetBaui7a/Qy+g0BA542OcXMVnNxfitgS
         pD7g==
X-Gm-Message-State: AGi0PubqXbEXuDplu3k4L1qpkUas0dyTB7ZE8KfkTvtJv45Ya0iRg8Ni
        94fGIt+K5p6CHNPmKWbA9qZQnihM
X-Google-Smtp-Source: APiQypLBwwDuMXiaEHDM9sV2SyDL1GtKMVR4VesjvSKzPAqT04M9UnLDbBezEsk1RlckQNxuzy6zOw==
X-Received: by 2002:a05:620a:556:: with SMTP id o22mr13853377qko.166.1587334936716;
        Sun, 19 Apr 2020 15:22:16 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:1168:6eff:89a1:d7f0? ([2601:282:803:7700:1168:6eff:89a1:d7f0])
        by smtp.googlemail.com with ESMTPSA id h13sm20848483qkj.21.2020.04.19.15.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 15:22:16 -0700 (PDT)
Subject: Re: [PATCH net-next] selftests: pmtu: implement IPIP, SIT and ip6tnl
 PMTU discovery tests
To:     Lourdes Pedrajas <lu@pplo.net>, David Miller <davem@davemloft.net>
Cc:     Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        Sabrina Dubroca <sd@queasysnail.net>
References: <20200419091651.22714-1-lu@pplo.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <390e8d41-ae16-7ba7-a8c4-993038e619cc@gmail.com>
Date:   Sun, 19 Apr 2020 16:22:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200419091651.22714-1-lu@pplo.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/20 3:16 AM, Lourdes Pedrajas wrote:
> Add PMTU discovery tests for these encapsulations:
> 
> - IPIP
> - SIT, mode ip6ip
> - ip6tnl, modes ip6ip6 and ipip6
> 
> Signed-off-by: Lourdes Pedrajas <lu@pplo.net>
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  tools/testing/selftests/net/pmtu.sh | 122 ++++++++++++++++++++++++++++
>  1 file changed, 122 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
