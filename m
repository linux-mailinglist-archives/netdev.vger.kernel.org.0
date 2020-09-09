Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DD826254E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgIICkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgIICkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:40:46 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB32C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 19:40:46 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x2so945113ilm.0
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 19:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FqeM6zgA/eQ5GCT0416iv/Rgu5njMCF5ogV4dvjr0PY=;
        b=go+hlYi1NyMbnTItQTV1uHf38EfKvCdmZFQW6AGcPBNQB/rYuuayiKCdtmTX3J6Cf7
         rRSrqPdILRkGJxQ1gHGjjRIb2wqvJh7EdSi2Vh7U+MSu8g6p6QbI4SFcXI0g13Z5Rrn1
         Cj/Wyovu6aECbxi2IcognhPcRUeYmBkK9C0TlPVL03tnlNGDUkSuSuiiyHZXSTl7Ece5
         m6Dsidc8Buc10xARjoU0gAEVA/HIvFROwTgLfH2tyNjpCwni+TGVsyXoUL3Lz/qZ9zlU
         ELvbGPiZQX37vGpABNuTVtNyWz5VPPx/o5DjVnvTkg6AwOh8gNr1idSvwdir0kQuhC8K
         Y2/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FqeM6zgA/eQ5GCT0416iv/Rgu5njMCF5ogV4dvjr0PY=;
        b=s+G703afU0rjSJfj3/Wp36C+xgutDrZ6gqvpeQAv9uJj9NstrP0dKWGXxO9xwocH1A
         FLyitiuDPKI0cYv+jfG0WEmD2r1HV02YvUFYHDMpAy1YOf8KdG7jCbmcc6WYd0jorNMJ
         f7cPHmY0MkDkAIIWuC7fGps0GRGNdWTJ0GHSmMYW9MYmmozHbup0n6lpWh8hsTfzOMRp
         A7YmTdSvHqdhP88GXwSH6FnsJ8uH0liDxAYUFZ/7zQVU5hrLmloR6b5NJjlvKFjjif/N
         0IG39FWqTvH3BFQ651P6GMwLUS3kl2DA1NaZyCbR0qM9yRDWBR+1lMnkMQQOOmNxGuGU
         AJUw==
X-Gm-Message-State: AOAM530l+DurEGqH9xxwqmhuAJk50u45XJWfRjGLCX3cEZnYtZYOV5VD
        C5DRaEcGpFCcLqrU/2XtuElFMMiAFvCc5w==
X-Google-Smtp-Source: ABdhPJzqLzwkGZMV+q8wF3QHEk3nlHxvKfJ+Fc9FaSnGnfXTxJQQ/5WOHzXrLzB7VJcUpLCtbJN/cw==
X-Received: by 2002:a92:db43:: with SMTP id w3mr1638717ilq.184.1599619245572;
        Tue, 08 Sep 2020 19:40:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id j66sm602596ili.71.2020.09.08.19.40.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 19:40:41 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3] iproute2: ss: add support to expose
 various inet sockopts
To:     Wei Wang <weiwan@google.com>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Roman Mashak <mrv@mojatatu.com>
References: <20200819211354.2049295-1-weiwan@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0ed20476-131c-9f8c-1600-1991cfcdf8fd@gmail.com>
Date:   Tue, 8 Sep 2020 20:40:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200819211354.2049295-1-weiwan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 3:13 PM, Wei Wang wrote:
> This commit adds support to expose the following inet socket options:
> -- recverr
> -- is_icsk
> -- freebind
> -- hdrincl
> -- mc_loop
> -- transparent
> -- mc_all
> -- nodefrag
> -- bind_address_no_port
> -- recverr_rfc4884
> -- defer_connect
> with the option --inet-sockopt. The individual option is only shown
> when set.
> 
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---

Applied to iproute2-next. Thanks,

