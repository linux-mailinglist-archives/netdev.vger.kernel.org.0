Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F983DF08A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbhHCOn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236213AbhHCOnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:43:10 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B00C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 07:42:56 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id v8-20020a0568301bc8b02904d5b4e5ca3aso8682240ota.13
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 07:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s8RwTlA68Z6kNirI2g3EC42JHl+/0Sk0guQl8I/CFuc=;
        b=A/wJz33K3weIHdwVhbOYPhuq1cKb20zYBqwuYMPRan1WfX/zz9t0wF5ksUhdOyBinu
         F/iknFITpD5tw2ZA5Dttr6pD8VcBSfnl6zZWjjp76H8SnaGQY+Z7lRBrg04DjgEF3iZu
         PETkeGSYuKxeo3vTA9ObpyjAGCfSPqtTy0IrSvO/6FfGotC2Q8GjbdpywVNZ8BePAW7g
         I4kBHVV8o/CqJHcpl7qhQOIRoIkyHzb7iRsDlibgBWjaON2pOWHVCn6ClCZ1c17jyLzz
         DhLhD/k3UE8l4Cy6HACrC6AJ1ZjvdSWUbeRvhXZKItcXd47u++Uj2Oq5jVwQGSDn1114
         hICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s8RwTlA68Z6kNirI2g3EC42JHl+/0Sk0guQl8I/CFuc=;
        b=gftKG2fK9o7dIbYil+ApSarfdNni7wZMeb/Qw3vrWponSJuaxaguwjS+IWdt3Obr5F
         2Etj5qgd+u5lAMkVOnFdlZG4ID+MLChztPteQQSqyw/+ONhVzmWhiNbwnc2mdC+OP2mi
         bdMxqAhEEy3Dqq4Ll2LzQ3jK1f3UdsqMkRiZ755c5F8wzoPACnnqzeYi5QxQUEHloMtj
         3aWhMc0X6AXgNGwhYObS75F5fYBkOz4K7TMhsi9wf/MTbKbI7S4i2mgTkDY+O5mOh04G
         5x4oqH5dutrBbha0I2PZ2wqudwCmuIvV9HtYkl0kUENnSSPGoa5LtT969Bqdk+evye8o
         zAKA==
X-Gm-Message-State: AOAM533gy5rycl8rGrji4CjZ/UdgWRsLtIsYv3gIXEyqoWFE/wyky1qY
        tYakes8OmH3L5BMc/jQcWLexu5Gbt08=
X-Google-Smtp-Source: ABdhPJwN0l1urNTrvf6UfGDps0k/xT1CzgSYCXCBE7hR31ucm5PKdOMC1fKm3jYn+GBhKid/GVeLvw==
X-Received: by 2002:a05:6830:204e:: with SMTP id f14mr15418735otp.238.1628001774710;
        Tue, 03 Aug 2021 07:42:54 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id g16sm2263431oos.31.2021.08.03.07.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 07:42:54 -0700 (PDT)
Subject: Re: [PATCH net-next] net: decnet: Fix refcount warning for new
 dn_fib_info
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
References: <20210803073739.22339-1-yajun.deng@linux.dev>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <02d31301-5f7c-07db-4aa0-e40b16fac038@gmail.com>
Date:   Tue, 3 Aug 2021 08:42:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210803073739.22339-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/21 1:37 AM, Yajun Deng wrote:
> fib_treeref needs to be set after kzalloc. The old code had a ++ which
> led to the confusion when the int was replaced by a refcount_t.
> 
> Fixes: 79976892f7ea ("net: convert fib_treeref from int to refcount_t")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/decnet/dn_fib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


