Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB104465644
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243784AbhLATYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240750AbhLATYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:24:20 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D5EC061574;
        Wed,  1 Dec 2021 11:20:58 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id o4so50653110oia.10;
        Wed, 01 Dec 2021 11:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=koZ0b6nl3s2fzAgfm0qGxpJFId/Sep4OPopoU1+xfLg=;
        b=gP3MDOzAOzPK23tyx4hY7QrQ3ksi5PTsuN7H+PIVJ4k1Arseh+RYNyX2OmrvjjenG2
         Gvnzm99Y5feMZqAqUvhP/T6fZWmiS7qfuwW9XglFCD/mQeEXQyML91wlk1FnyAhrL5dh
         CumJx18MDQzA68CMClVlIX5pwRe0r3s/s/IRF4y69O1sPmEhVYr4XF9+P/vk+6taJjOE
         3L4F9K5tuqyqVdZfKnUC1MBhE4yGNY55xdlwhISps4mn6HuakaW7Pe6IqXqxlHS+pfrZ
         LLmK5pRgAN70+4+N8nnz5E9itTLi3oM3QO6JuSpjoTIdPGKEI21gZ/Ffl139tw3ozrSf
         D2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=koZ0b6nl3s2fzAgfm0qGxpJFId/Sep4OPopoU1+xfLg=;
        b=LRpvKP/m76fFevI76+aNco19JXPV+1bJVqdFYitehPAcufn7FvXz6a9f07HgzW7dAW
         cXx2dusAYUWqttvoPvgzZykdjEumkEb0Ixjuj1rmnGKnNkKaZKS9aV9iZegV8rUlNTf9
         +cNae/wyKpaUwTtZjPf7yHwZnX62g19VzYZvhy51DAw7AKibct0qmDZd+iPRMAgWb2mI
         62InMUSEhMo5e8OiuoXj5DE35s9iQWsxjsfbnq9LtQmYFbERe0kmeGt3BioYnHuOQ4wA
         BLdhnTHU7r+ok0mrxelZbIS+obWhWDjakwhG6rQp5sbIc+Hlc8tPVdEMBszE+rcigHuR
         fNFg==
X-Gm-Message-State: AOAM533nB67VORpPLupinfMwHwcVHs88ItOgzVX9+jf/K+Fi9ACYGnqf
        wJ8ad3qvzOMLR6Ydu40zCSs=
X-Google-Smtp-Source: ABdhPJzSt9l+Lvm2Z7PLVkUw0itt+1FsGQhintNOwH5/M3Kc6EE+Srg4/fIbkFYFAXqJzfc7oZuBqw==
X-Received: by 2002:a05:6808:2111:: with SMTP id r17mr194476oiw.118.1638386458066;
        Wed, 01 Dec 2021 11:20:58 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bl33sm401914oib.47.2021.12.01.11.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 11:20:57 -0800 (PST)
Message-ID: <0b92f046-5ac3-7138-2775-59fadee6e17a@gmail.com>
Date:   Wed, 1 Dec 2021 12:20:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
 <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
 <c4424a7a-2ef1-6524-9b10-1e7d1f1e1fe4@gmail.com>
 <889c0306-afed-62cd-d95b-a20b8e798979@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <889c0306-afed-62cd-d95b-a20b8e798979@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 12:11 PM, Pavel Begunkov wrote:
> btw, why a dummy device would ever go through loopback? It doesn't
> seem to make sense, though may be missing something.

You are sending to a local ip address, so the fib_lookup returns
RTN_LOCAL. The code makes dev_out the loopback:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/route.c#n2773

(you are not using vrf so ignore the l3mdev reference). loopback device
has the logic to put the skb back in the stack for Rx processing:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/loopback.c#n68
