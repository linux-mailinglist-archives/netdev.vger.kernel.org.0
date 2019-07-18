Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426A46CF97
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 16:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403763AbfGROVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 10:21:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35977 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390345AbfGROVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 10:21:04 -0400
Received: by mail-io1-f68.google.com with SMTP id o9so51761675iom.3
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 07:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hkZ9r2YZdJZ/Wyu1ekSiigPT2RrlJcMtq5jKa4P1/JU=;
        b=L3UEwR5i0GoRAblPYbhOR3RrUoLbLRBgXxc/dzSVpG+SrAou1KYgz9Of7G56VBAqHn
         Azu77CfAgEO/KuzdY3j6ksOIKPJyZiMzG3/J+HT7O93JZ2i/h9MFVzTqn8qFbCNTRmYJ
         1jeykHnpJgl2LQJAqjS1XpxF1rnLPJqUp21yQhFmSfyd2FOUXJGJoJv0tJF5N64wDbrk
         g8iy1DB32B9SsZ7ujfKZFNsBAAnZoQtWphCycFf4FaE5v8Aglba3hO6SV0YrPEjaYBp3
         lCugTXuIwCJ2+OE4QpN5gulJeP3TOJ8jKhpygGer5TxvlId13f69KYKuBXGjpe2YlLTW
         dajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hkZ9r2YZdJZ/Wyu1ekSiigPT2RrlJcMtq5jKa4P1/JU=;
        b=X047q+mTCGFks8p8HG4nA3uuI/jMD4TlPNKrvMRR87wsBM3NqC/CNYIgfA2eFacCuR
         Ahni8HOoNbKIDm7AVcvV3Zs7OkKFO6pWO2Ag7mE8zZ7nm19qtYSNRgrtNpdWmhBo7Ogz
         njVD7Wdq96/XrJIyBBeNBLrAYR5uJfntDV+LWMo2uRp9DLfbxnbKkCf4TG7mZR04SQuH
         P7kXeUnotnWqfil8dQl+7LX4oloxUmk/fUocTbkW/fOzADnoDFa+zQS3gtPyiiBoWZXK
         XD//lyIW9geq9ccI+cBI5Un0FEELviiw+DzoVvVr5cdQE6Gy60i6zT+0wl96rmErDaGl
         TW5Q==
X-Gm-Message-State: APjAAAWHrNHI+qAVIgQ5LZgL2/ArALk48HAepQR/TdUc/xQdAYzfNsE7
        ndE6cQxvP2YQNNkel2cLQtLqj60I
X-Google-Smtp-Source: APXvYqwhcv1nR0fkbhV8TqN9u1VsRzcOUyds4lZMvBOIlSog0q7NO7bJVtP5B8zOnJUYjlpXpNAYfA==
X-Received: by 2002:a5d:87d6:: with SMTP id q22mr40701069ios.2.1563459663311;
        Thu, 18 Jul 2019 07:21:03 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:54f6:cf0:7185:650f? ([2601:282:800:fd80:54f6:cf0:7185:650f])
        by smtp.googlemail.com with ESMTPSA id p3sm30103538iom.7.2019.07.18.07.21.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 07:21:02 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: Unlink sibling route in case of failure
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20190717203933.3073-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f6dacc3e-7b20-2441-dd7d-99d3983bddc3@gmail.com>
Date:   Thu, 18 Jul 2019 08:21:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190717203933.3073-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/19 2:39 PM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When a route needs to be appended to an existing multipath route,
> fib6_add_rt2node() first appends it to the siblings list and increments
> the number of sibling routes on each sibling.
> 
> Later, the function notifies the route via call_fib6_entry_notifiers().
> In case the notification is vetoed, the route is not unlinked from the
> siblings list, which can result in a use-after-free.
> 
> Fix this by unlinking the route from the siblings list before returning
> an error.
> 
> Audited the rest of the call sites from which the FIB notification chain
> is called and could not find more problems.
> 
> Fixes: 2233000cba40 ("net/ipv6: Move call_fib6_entry_notifiers up for route adds")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: Alexander Petrovskiy <alexpe@mellanox.com>
> ---
> Dave, this will not apply cleanly to stable trees due to recent changes
> in net-next. I can prepare another patch for stable if needed.
> ---
>  net/ipv6/ip6_fib.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 

Thanks for the fix, Ido. I can help with the ports as well.

Reviewed-by: David Ahern <dsahern@gmail.com>

