Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4BF20C147
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 14:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgF0Mdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 08:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgF0Mdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 08:33:33 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003CCC03E979
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 05:33:32 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d15so8922771edm.10
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 05:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ny1m3EPqen2yiuUNCB9dw/cFuam7LWG8sY4eNzE4frA=;
        b=YerTVWtn/RkhfBvIsShMpj6jVzmvFY3oN367pdGdO8raGobH67/+6ElK2AzA54gUKz
         43vZ/PBWPW1mhejQ62ijy8ZjCDbqa4CKgSJqpuFuCK3YOauXdbYBt1q5wYi0/YPWD6nM
         biEXryenvKEv1imiNbBf8epxOHdLB1IYSLS8jsTUxeNJa0sa9FVKHh4GCSN+Y8+pg8bd
         /LO6hfcn2DjLhUaHCBbAnW2CD1MCiJY1lh9frrWqr0pKtcJ8Iw9P2XUJligLgF5f2Vub
         HRuBZIOLrSY67IakMgsIg5RwHqmoUDOnyr9SqspJUdomgMRVfItvvx1MUILlAp8HLvuK
         I26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ny1m3EPqen2yiuUNCB9dw/cFuam7LWG8sY4eNzE4frA=;
        b=f+KoqoCTeCBeCrsG67J8y8Xu2ieiGL9BHXEIwLMLjtc72RwAGQVnR0eVFhesvWj//A
         h4HYxYT/jha6gGekIiywQ0vhca71fVNP6fy3WnpAzil4TMXNPTvxZ56rEnuhAiH6ruJD
         BlDyfg8AmzlRVjHMQqwMkN8/aqAMmwS+nbJhNvS6WVxTpstsbZ/LOOybkk+W/WC2WSOB
         helVM92g9xGlgidKK097tQxsKHFhTt+Yb0R20fbl5uUfcakHOVpyS/uJcNYKVyZSzt6W
         WN8Faq59er0aPE4Dl6eT3nwaWEJaTdyGiR5LfySjRBZNw764N/hW5Oz7H/LvBhp77Z64
         8Xqw==
X-Gm-Message-State: AOAM5301k95pnBQneZc3lEsoJjKOjvMJ+YHAlIsKW4JxmWZfa8rCQdGX
        TquN++71CrJVcFoGptdctfysydUe+JE=
X-Google-Smtp-Source: ABdhPJwz/OKjyjOsNK2hUoAoCcnMy8Plv6kdwYYBffkDT0ous/SKQy5aFg5AuFp6iyG1131DDk9awQ==
X-Received: by 2002:a05:6402:1ca2:: with SMTP id cz2mr7901283edb.15.1593261211397;
        Sat, 27 Jun 2020 05:33:31 -0700 (PDT)
Received: from ?IPv6:2a0f:6480:3:1:e96f:c7f:ef7f:cae1? ([2a0f:6480:3:1:e96f:c7f:ef7f:cae1])
        by smtp.gmail.com with ESMTPSA id o4sm23196014edt.15.2020.06.27.05.33.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2020 05:33:30 -0700 (PDT)
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Subject: IPv4: Why are sysctl settings of abandoned route cache / GC still
 around?
To:     netdev@vger.kernel.org
Message-ID: <dadfe9fd-a585-09d1-cb08-54d742d295fe@gmail.com>
Date:   Sat, 27 Jun 2020 14:33:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi list,

is there a reason sysctl settings like net/ipv4/route/
- max_size
- gc_thresh
- gc_min_interval
- gc_min_interval_ms
- gc_elasticity
are still around in current kernels? 

I find this just confusing and misleading.
If there are no concerns I'd like to remove those. I have a patch ready.

Kind Regards
Oliver
