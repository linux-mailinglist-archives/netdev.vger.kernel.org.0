Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 207D81E340D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 02:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgE0AbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 20:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgE0AbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 20:31:19 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69586C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 17:31:19 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id p4so10398502qvr.10
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 17:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uIp0501mG3+8ATxnA4TxYZmA6hz0mrHIWE9JDA6LiYw=;
        b=olrYooBjXi6S+f2JUAvySajwthmEIu27lEW00jJ5JfZDiRCxa4Q5qA50iAv36cOlCd
         3qZMjF6/PXfKzL0m6D33VUPbrheScryZzGZG3H58q6zpSGpHLl4np+pQl8XTEFINTAee
         7KICEU9lhOVQeeZgv2O0/+Qg8LV6TP/F0IsuGOPSz3vqzpBFlgqVjKcH6UN+BFDsis9J
         0bbNt//wUB42UJGKGaUi5CtaHoQATbXetwsRDvjbRmEu3/JTA8dPj/nSCCo9fy9HwbSD
         8mz1uv9ZYjq2h2aPBWX+/EjQuqAE6aWUmpFQlFIaSzz38LGNOE+mhpdszKnfnSymwE9x
         gC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uIp0501mG3+8ATxnA4TxYZmA6hz0mrHIWE9JDA6LiYw=;
        b=kFN/rcBtf+qbiVbFAfEurkvp4htNBqp/2hMZc5pGuZymuuuEqgA9VZrVvd1EgNcvbw
         juxAtzfbCzbb4ZGoqsTbm0nPHd080nilNGlXmwlz4auVU7yG8HHGGPeQTV5+1VlbBu+x
         zgFi494GZl70gcwXugHdJ1mtTSGH2gew62yhCDn+OYhEHnCaspQDQ0YIsDHlWz0Kqnx0
         U5x3L/w/0ZvzQ369snNxnkHpB07mDxb90FEfdzeoSspPwDptOZ7gzn5mCNr4JyNJON+U
         SXMyCt647hKFS+wIC2JxQ84ZwTTlkHGiNvtfxkRvfF1qfhrVHdEUGCO6Ep44OqHYla2S
         GoCA==
X-Gm-Message-State: AOAM533gtU+YRr7GGMc7pBw36E9FVv/RTMf004zXTlNgc0rAnaL7I/UI
        2c4wEmhwOyTIczBIl9AxGbaH68gf
X-Google-Smtp-Source: ABdhPJxcYPRAMuEX66jBlcHCxab1wyg4uObm0ydf3lCsnSPpg5qcBru+RSViPwuW31MHDSRdML+quQ==
X-Received: by 2002:a0c:b516:: with SMTP id d22mr253029qve.88.1590539476132;
        Tue, 26 May 2020 17:31:16 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id u41sm1181263qte.28.2020.05.26.17.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 17:31:15 -0700 (PDT)
Subject: Re: bpf-next/net-next: panic using bpf_xdp_adjust_head
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "brouer@redhat.com" <brouer@redhat.com>
References: <8d211628-9290-3315-fb1e-b0651d6e1966@gmail.com>
 <52d793f86d36baac455630a03d76f09a388e549f.camel@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ee9e514-9008-6b30-9665-38607169146d@gmail.com>
Date:   Tue, 26 May 2020 18:31:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <52d793f86d36baac455630a03d76f09a388e549f.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 3:23 PM, Saeed Mahameed wrote:
> Anyway I can't figure out the reason for this without extra digging
> since in mlx5 we do xdp_set_data_meta_invalid(); before passing the xdp
> buff to the bpf program, so it is not clear why would you hit the
> memove in bpf_xdp_adjust_head().

I commented out the metalen check in bpf_xdp_adjust_head to move on.

There are number of changes in the mlx5 driver related to xdp_buff setup
and running the programs, so it is the likely candidate. Let me know if
you have something to test.

Thanks
