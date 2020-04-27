Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBD81BA3BB
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 14:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgD0Mli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 08:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726390AbgD0Mlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 08:41:37 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C063EC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 05:41:37 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c2so3809065iow.7
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 05:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M89KwlZ4ljss/09BgKc62lASV+ddSc4558KC/5nIKBo=;
        b=H/G2rbXF85WcA2irYNcnwfylPjrK/ymj5xxcAsH8H1pP8KGWE4O6uuh2bJL2BOLdSH
         B76G++wsTIHMHKpbAda8lS1b9GUWCV+tn56gNNzTyvgw7sWzsj97AIO3rYHOb4gKRBDD
         PCXZZu60BHoQgGSmW8QuNcKuuHDUpVMHgZj9sM9kuzbTZr4zAlZomIFz6DhS+9Q7v4+u
         zSZLkdQ7jweoq9D3aiZgFmkfculLYG1/wFRzTyZxFq1FhJ6rAfY7v2ZkWQGCTSNM/Jti
         hZnIOoNCunYI93FgVM1KcofqOuFPI6r176Yp6aX75nU0hLjmm4Lj3stOwFSxoeX1lNoY
         orfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M89KwlZ4ljss/09BgKc62lASV+ddSc4558KC/5nIKBo=;
        b=tjxcE7ctcwHVBvNGrW8WIH6yI94nipOQLJub1pQrNvogMMABpobxNoMAvvxBQO3FZf
         /EiHaRmE9uK9Pk9KTCm4ZTVzM0ZM4uMOMQvkYKFEsNlajX2vC4u8rs8+eh+79MHNewQD
         UVkN/jZME0UpHBI8pXESa1DMFH5MTC4Wd4DT++PrIBm/8NNEqpi7ywN+NK7zWi/SDGLh
         iyOexNWBGoeOxgXylCZIUyfG0mPrrg0b3Jgp7uBKA4FIwoprzxA6wKDSMm/Bur8qxvK3
         gYIm87QAXX7IoEkiNN4Dw/yS+d3eA90+LGJMdFYPbN9o9MJ5rOd//LFUNST9tjDEPCnv
         0ImQ==
X-Gm-Message-State: AGi0PuZ83UiKs5tCaSAJQNR+qMmpoIjHsbm8X8PRuHO4NhhVmgN6yDmw
        RqEL7ZVbJ5713/y+nXEdL9Hy/VA+
X-Google-Smtp-Source: APiQypKqTs/gpUfBW1S1xYYG47R9N4aKh2bVpIgrPZNZsk53LbKfr80sI4Q2xiR75MBTfHPXv5G6BA==
X-Received: by 2002:a5d:9244:: with SMTP id e4mr1904421iol.133.1587991297205;
        Mon, 27 Apr 2020 05:41:37 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id r3sm4522156iot.0.2020.04.27.05.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 05:41:36 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/3] net: ipv6: new arg skip_notify to
 ip6_rt_del
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
References: <1587958885-29540-1-git-send-email-roopa@cumulusnetworks.com>
 <1587958885-29540-2-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ab6f2435-04b5-c2d9-3592-cc4f452f7fc1@gmail.com>
Date:   Mon, 27 Apr 2020 06:41:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587958885-29540-2-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/20 9:41 PM, Roopa Prabhu wrote:
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> Used in subsequent work to skip route delete
> notifications on nexthop deletes.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
>  include/net/ip6_route.h  |  2 +-
>  include/net/ipv6_stubs.h |  2 +-
>  net/ipv4/nexthop.c       |  2 +-
>  net/ipv6/addrconf.c      | 12 ++++++------
>  net/ipv6/addrconf_core.c |  3 ++-
>  net/ipv6/anycast.c       |  4 ++--
>  net/ipv6/ndisc.c         |  2 +-
>  net/ipv6/route.c         | 11 +++++++----
>  8 files changed, 21 insertions(+), 17 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


