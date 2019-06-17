Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAF1489C5
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfFQRMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:12:17 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37397 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFQRMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:12:16 -0400
Received: by mail-io1-f68.google.com with SMTP id e5so22908158iok.4;
        Mon, 17 Jun 2019 10:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MmXk6bCQQ/yW6WaBWCfFy1WSWFXgbvLR8f3bZZl67nQ=;
        b=VMar9MC/FcLt6Eun/wyqvOxXSZW8gpHu9PDDDRjRPdzK36kgfX1NtGKYydHc4/dkIa
         wDkzs4VauHPQFSEOuvb7UaUE5ws+/3aczohJ+oleP3xHVJZnlUiN7WDeREg7LzFYLkBz
         aS2AQ+rL9n8jAB/IjaSTEdLLxT0JRPNs2cGzBivvZ91+P/vCURz4FotNvIXeafX9Gl+y
         CJoY14A2RWyQkAAIpdlO6Y8yTQP5wOX1rXYse2/ErrGu3upox5ebb0/XODibZAtdja2D
         XaYSuBroxfByOWwA8MyOhb62B0PtUv23Q2+EiQ3ebyl06wetAIEYHSyedtmG+h/FDYC5
         CcoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MmXk6bCQQ/yW6WaBWCfFy1WSWFXgbvLR8f3bZZl67nQ=;
        b=NJDDhqqurKk1IXD0qIP2J1XBE16RXubNiXcoDHD2l3lWv3o/Tk+Kxcdr+DGCbz9ktv
         XETP4yh7YpS4JarU0jxTAI5MTiYvUQk/PAXX6UGCJPbKjkL1EOx7s4XR1rvU6wW4REoo
         864bYHWoTciufxlsGsFZJ2JHjix0YjcXYL+nhZHZF4i8YOsMC2sUzBHojWsHQmVJwa33
         Tgh+5OSyWBxikLf+RLUAcAphmAj5FqgRXM2qiFaOZaI/EbWQV6WTX70E7P1U5HiidhLr
         5tJyv/+tQv9HFZQiW8onnOrqSFhCqzSegfIUvqcom+K84VAG64bwHhm2ia8QqL1eCJry
         zbXg==
X-Gm-Message-State: APjAAAWe7tRM/qvQN/pVNNtSAvugDyTB/Kaybg2VUHLiIyofrpwoLP3f
        MbAQJ/OAV+eemuxSaapW+7Ft+mJd
X-Google-Smtp-Source: APXvYqwjtmFSJgFjSJVABjhJniELH8fsReN9GSlfWJG4Le4O0HODnpnxIN8ye+sK1nIYumcPr+W2gA==
X-Received: by 2002:a5d:9416:: with SMTP id v22mr17278902ion.4.1560791535371;
        Mon, 17 Jun 2019 10:12:15 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id i3sm14066947ion.9.2019.06.17.10.12.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 10:12:14 -0700 (PDT)
Subject: Re: [PATCH] fib_semantics: Fix warning in fib_check_nh_v4_gw
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
References: <20190617102119.56253-1-vincenzo.frascino@arm.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33c98309-a8d2-ecfe-7385-72769a571d9b@gmail.com>
Date:   Mon, 17 Jun 2019 11:12:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190617102119.56253-1-vincenzo.frascino@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/19 4:21 AM, Vincenzo Frascino wrote:
> Currently, the err variable in fib_check_nh_v4_gw may be used
> uninitialized leading to the warning below:
> 
>   fib_semantics.c: In function ‘fib_check_nh_v4_gw’:
>   fib_semantics.c:1023:12: warning: ‘err’ may be used
>     uninitialised in this function [-Wmaybe-uninitialized]
>        if (!tbl || err) {
>                    ^~
> 
> Initialize err to 0 to fix the warning.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> ---
>  net/ipv4/fib_semantics.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

already fixed in net; will make it to net-next on next merge.


