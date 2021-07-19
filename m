Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBBB3CF034
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443524AbhGSXDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388732AbhGSVBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 17:01:33 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E361EC061762;
        Mon, 19 Jul 2021 14:40:24 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso19632763otu.10;
        Mon, 19 Jul 2021 14:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3j4ZpA8y4zKamFNKMdrL0l+x5a2IeA3RXrsPFD3wK2o=;
        b=kBSQax5nsBjRZN4k3he6ReFqnSX1SuXkhIkm/RswY801ae282purX0qxHJcOvK6C4o
         NHL/JLXBnJpK+cm0OQvVjndmnV7haK8p5Mg1e1Qhhw0a0dN/t9ZYJK6LaTMtgxkxnAjC
         rxOBDCR3biaBC4eNXXdwKzKjJeeCjTBX8A78xyc5gTGqrluCn7FNd1reSGDAOwY3cORa
         cqJkDniKmo9xzBE4BpBWK8EOPrm7RL2j3BDXS1L1htLz55VW4xIQu10qM+D+KWG++Rlc
         XXWOfCde7CzJccpkbyqEmhDG93dzy5+JkZIJwfzqQQA80fmDxBbU0/ZSTe2rbhGFrhnQ
         wY1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3j4ZpA8y4zKamFNKMdrL0l+x5a2IeA3RXrsPFD3wK2o=;
        b=q2UNp5ZuaMHXUaGj6HPFO6o7oq1XVrwfR5SG1o2Lh4E6rpeH0Md1UpxGUqEQyjhj8F
         SCWkv2yoBhdl/ooQeL9C6rwcUioNXhwIEZ7+XawUpYirmQTlR8Vs1A6lxu58/YGINsOq
         ncMXDWAqOvfUMnQBjmUK0xj0L8fHCj+/WB7QudHYG5UqDDTpC/TQXETCQmnz+KcksSkZ
         185Cco81Gp6gV7Yru3xO+luAiC+prXrGBhsR69qZVuD7jGOntYSfOT2dKX2bFMjjfPp0
         JoHuFMmfnEbR7HbWAT9tX3IDTGRqZLHN82mEa81YCBG0GrSC37jpyYgAZljL+X6yaK2d
         T5Yw==
X-Gm-Message-State: AOAM532Re6ZSujowX5+w4H0xkGe2bk5bF5fXRxhYYT/DzT5E4kz3Bb3E
        wz/b0Smz2CFI7ZR2+8cpuwsnbJt/KY3PuQ==
X-Google-Smtp-Source: ABdhPJxF1JOd1Ck21E+HfBBtoqLvjFbGGL0NeE3bGKbGvlqMJgiCT3tpTR1Ux+PBrrvoZFitG1DWvA==
X-Received: by 2002:a9d:5d14:: with SMTP id b20mr20016846oti.307.1626730823723;
        Mon, 19 Jul 2021 14:40:23 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id t144sm4050540oih.57.2021.07.19.14.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 14:40:23 -0700 (PDT)
Subject: Re: [RFC] tcp: Initial support for RFC5925 auth option
To:     Leonard Crestez <cdleonard@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
References: <01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e2215577-2dc5-9669-20b8-91c7700fa987@gmail.com>
Date:   Mon, 19 Jul 2021 15:40:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/21 5:24 AM, Leonard Crestez wrote:
> I'm especially interested in feedback regarding ABI and testing.

Please add tests -- both positive and negative -- to
tools/testing/selftests/net/fcnal-test.sh. That script already covers
the MD5 permutations. You can add the uapi support needed to nettest.c
