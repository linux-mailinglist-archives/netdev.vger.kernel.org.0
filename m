Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A09B6090D6
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 04:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiJWCqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 22:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJWCqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 22:46:31 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C683213D28
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 19:46:30 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id m6so4373712qkm.4
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 19:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4i51PJ9VgqBLKpdx9sPDZ4sore9gWcit4rjaa1kuwD4=;
        b=pQ3Z4wwn9TX18JmvGrhfoUvZsd4hSqvwLWb9II4rUpcaT8AGR0qoM39mt3IYXbdUau
         vIuqtILxTylk3VrTLq59lPDDG8DoXZhIV/kAlpAFAZLepf2ybG9IQzcsvwd0Wohn3X7l
         YOy2bXK9KgzGuW8XSYVSR88J0C6tdprD727o4uLJMhUMe5u9OBHI9Qi5eKCFqzEFOm4s
         skE9gPdbhfaAeWos1mOUGT32GD+lgcHCpjnI2T+JgvxOzA2OHtckSxyU2bcodlTMFZc9
         x6tnygr/thRkro17J6bppzbXaKsNRaffJJDj2x2rz6Ndv3ZpuS+ijdAu8c8z5FYF2AwU
         H+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4i51PJ9VgqBLKpdx9sPDZ4sore9gWcit4rjaa1kuwD4=;
        b=e/8CHD2BSm8tswwVofAyePNIp3uHO+NRO7KyHlL8YcBUttLYe3Ae/O9ntcm+d4UtZ7
         bj9qPWy2c3HY4N606/1hWKx7tZBewtRDdX7EpPJ4CMHhD4pAi1+Niuo33KxL24Z3uTP8
         4oCKf6viacy0qk4k5P88oymWfkql0FatTbjvSs5m1LwUbDxqm+6KrP9mXf5U6kUv+asW
         2aZ6MhB5ylf8WrGiHxF9T9EBXdXtzkh5KoEh0J0XJtmWpZK6GEp+oS6R6hw1gWR0PFgL
         k5Mf1DVLnZLPnSRBLOwZVbdTibOcFk4toG7+XKhdzlpUeetqk9dbHX1nR0YtRAm6aEYO
         twxA==
X-Gm-Message-State: ACrzQf0tPUScyZd0++A+dwgKWFQU1Ug+EzajOVLy+GWImR9GIvWmKJE7
        wswJ9BdbOSCtHPVC0RrypLA=
X-Google-Smtp-Source: AMsMyM7iVF8pw9hMT0W+/JeeZuO7UubRxJaf2lvHz2tytQWh+t93vwet2vz9yBGzvFnMGrbvTtDNVg==
X-Received: by 2002:ae9:f707:0:b0:6e7:2317:8318 with SMTP id s7-20020ae9f707000000b006e723178318mr18177302qkg.571.1666493189955;
        Sat, 22 Oct 2022 19:46:29 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:2e02:af9:d9bc:69c5])
        by smtp.gmail.com with ESMTPSA id v2-20020a05620a0f0200b006cfc1d827cbsm12866967qkl.9.2022.10.22.19.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 19:46:29 -0700 (PDT)
Date:   Sat, 22 Oct 2022 19:46:28 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net 2/2] kcm: annotate data-races around kcm->rx_wait
Message-ID: <Y1SrBJUOKkpEHiPz@pop-os.localdomain>
References: <20221020224512.3211657-1-edumazet@google.com>
 <20221020224512.3211657-3-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020224512.3211657-3-edumazet@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:45:12PM +0000, Eric Dumazet wrote:
> kcm->rx_psock can be read locklessly in kcm_rfree().

Copy-n-paste typo here.

> Annotate the read and writes accordingly.

I wonder why not simply acquire mux->rx_lock earlier?

Thanks.
