Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E752F25B5C5
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgIBVRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbgIBVRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:17:17 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C89C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 14:17:16 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a9so777478wmm.2
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 14:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1pwSFxqvycKxJQO/AHpUkGwc2QTfPZQNd7dZ8PUxGBE=;
        b=ASPx+ynnMslgRMP4rf+uzrCFdA6Wx15INpf+xDXeRDTxdBm3XvWZo+vzudDETiGUze
         wd6Wu49RJu54SNtJrB56+C+y4oUmGww5oy2fxhpjGq4bhp8Pit4Px7TlcTnI44c9TlBQ
         umtfI0tenpgNXpoDmFsHYw9P2mTtHxerNP1pSy2C7naYrXPAYBrn8tEyZrif0DEmexfH
         41YdgsQgeQbdqFxw8b2oFSrIt85Of4HXHb6ZaX3hOJVQ1I/tUA6SbTHaiqiSmigW5lGR
         l+n2kDe0EBYwCXKSkID3HyJ/3WBXVc7BA/7zq/SjVAPHNR8GgKmtwWusjZ+Khi+u5QsZ
         A0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1pwSFxqvycKxJQO/AHpUkGwc2QTfPZQNd7dZ8PUxGBE=;
        b=YInSdM3Yr3hqyliD2rYT1HYbruWdKuEnbfkOpvQC0pBhlI2sp0rgtd0q0pETsaVITJ
         4VsyMG4KpN2IWGY0ZWV/+ufnyv/2PppxIi0TnKQaMaCeNXRrfqNfJJ/qFmkBFzzFLawa
         qC3UkE+oly7vbDhWNmICAzwXfsTJGC6wwBqPOUcdK6qQ3ItAQMRSMnnVDShOMbqEILXn
         tLF1ChRrRo4SKrWV2h+AZcIthU60Ednx6dOTMm5YoZSa7y0OobZ/pQYeYvoz05hYslvE
         DPpdBkue6NeaDFkaMuMMIBw7ArYFO9bXpHCK4Yt5PkBUof3gxV+eDOvAMUF1oiJ4vGZ7
         zKWA==
X-Gm-Message-State: AOAM531fxhO+TzPS8Am0zdlaWA8jfLxKmXoGCJMJKfad7VJATjZt9tIC
        TmMtpyTzDsLWYeLz57U3oK6qI2Iw5VQ=
X-Google-Smtp-Source: ABdhPJzE661x3f60qKXg8nKUIErQ+hWw6l0quTekQEegchAqAfP5POm954YNRMQ712NdfewVQLiMYw==
X-Received: by 2002:a1c:234b:: with SMTP id j72mr62192wmj.153.1599081435250;
        Wed, 02 Sep 2020 14:17:15 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.70.17])
        by smtp.gmail.com with ESMTPSA id q12sm1234268wrs.48.2020.09.02.14.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 14:17:14 -0700 (PDT)
Subject: Re: [PATCH net-next] Sysctl parameter to disable TCP RST packet to
 unknown socket
To:     Mihail Milev <mmilev_ml@icloud.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com
Cc:     netdev@vger.kernel.org
References: <20200902195656.7538-1-mmilev_ml@icloud.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <543c135d-0076-4293-f668-54091962626a@gmail.com>
Date:   Wed, 2 Sep 2020 23:17:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200902195656.7538-1-mmilev_ml@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/20 12:56 PM, Mihail Milev wrote:
> What?
> 
> Create a new sysctl parameter called tcp_disable_rst_unkn_socket,
> which by default is set to 0 - "disabled". When this parameter is
> set to 1 - "enabled", it suppresses sending a TCP RST packet as a
> response to received TCP packets destined for a socket, which is
> unknown to the kernel.
> 

Well, I am not thrilled by this patch...

1) This seems hacky to only focus on RST packets, while it seems clear you
want to be able to use a user-land TCP stack.

2) No ipv6 support in your patch, this is unfortunate.

3) I do not see how you prevent another program using kernel stack conflicting
with TCP listeners/flows of your user space TCP.

