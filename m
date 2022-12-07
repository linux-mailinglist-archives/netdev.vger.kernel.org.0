Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A71645CF4
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiLGOyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiLGOyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:54:50 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409D45FB8A
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:54:46 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m19so25201138edj.8
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QKicXosdLffIMQdFy7P5BP6sAtNP4dRLIXsGUY39Kyk=;
        b=0/eBZg+5a4iI2+M+uMWiEEeA9cngeL1dc0bMPC8mzK0a8LcUPh1/icfUJiiTSZvfnz
         EYw4IlzoqCSS9nRwh/eH9UZDhoqGeZ8lVlyP0Naa/Y6KlkdVcHwg7uyWZsHYIlyCGwmr
         HZ80u/uYbcVPlQv/x52o984uKsuw/oDFIfYpjJSELvAsNgrYh4Dz9W/vdNfMFHKpE8Dw
         6sma/snycCdBGJNJoIzkLHFmtkGI5m2uXCZtkT7Caw2OCxRs8ufvtOeSU9nqM8L+nxlk
         shxnNrLtv5CDMex2XhxF7Nf6z7jTnIXHxEzhZVsax2ltvX3Yq6rl4OVisjHLcl98x3VU
         XQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QKicXosdLffIMQdFy7P5BP6sAtNP4dRLIXsGUY39Kyk=;
        b=znHSEVZdmH8ZlZN3BwApzHNA6MfkO7zp1XC+b+z55mICpTMFIEah8Ww79luk4s31aU
         dXfyaUi04VdMszc4rrLOXDy7WzbbpTFWMWpEsIUOTid5Z3o+esj5OR9OIwpEDeBfWqVk
         ODoi5yADEwfOTvdOPmnVxWozdavnYH+GtPKe8PeMUSk9j2c5eQ76kODo9NygbAo9RG/N
         XTsEZqeI8r5Deix+FPdFyjy43moSU0HUiGsQQZwenSS7XeFhik5Z8DSUlzVH4H53x/x5
         0kOt9U4wNcjAg92KXF6/tjl8nrVOaJtvdwwX79ngjFh6t1JDy3UWYCsundbh0PwUWmt1
         RTMQ==
X-Gm-Message-State: ANoB5pmQVWWRSR1recQgFarxn/8aib+xXJPGz50csV0Xhk63AqDQxEGy
        ubPYtv8Id6bAPBQyEPux/Ag2NabjoOqnhVnLsIg=
X-Google-Smtp-Source: AA0mqf6/1h7J92uqbNR2MSjVihfKJ7WjTMETtb36zs8jUt96/m3xpJ1e9ZcERdBCTrxKPmBQj/IX/A==
X-Received: by 2002:a05:6402:1802:b0:461:72cb:e5d with SMTP id g2-20020a056402180200b0046172cb0e5dmr73565643edy.410.1670424884820;
        Wed, 07 Dec 2022 06:54:44 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i5-20020aa7c705000000b00463a83ce063sm2264011edq.96.2022.12.07.06.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:54:44 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:54:43 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, davem@davemloft.net
Subject: Re: [PATCH net 1/3] mISDN: hfcsusb: don't call dev_kfree_skb() under
 spin_lock_irqsave()
Message-ID: <Y5CpM4bpi0YD+FPk@nanopsycho>
References: <20221207093239.3775457-1-yangyingliang@huawei.com>
 <20221207093239.3775457-2-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207093239.3775457-2-yangyingliang@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 10:32:37AM CET, yangyingliang@huawei.com wrote:
>It is not allowed to call consume_skb() from hardware interrupt context
>or with interrupts being disabled. So replace dev_kfree_skb() with
>dev_consume_skb_irq() under spin_lock_irqsave().
>
>Fixes: 69f52adb2d53 ("mISDN: Add HFC USB driver")
>Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
