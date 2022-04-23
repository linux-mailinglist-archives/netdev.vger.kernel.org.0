Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE0D50CA85
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 15:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbiDWNVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 09:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiDWNVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 09:21:02 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22F42118BE;
        Sat, 23 Apr 2022 06:18:05 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id b188so12021768oia.13;
        Sat, 23 Apr 2022 06:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JYVMgf42zZyHE8ws9U4WUn0NjIwADExX69tWsxjM9Gg=;
        b=iYUmtX0ojjTY3J8G+AbIyjc3LvimrenBMym8O0PEtf+oAjW0c93j2yItsMEDa6J/HD
         bz8fNUPHjyer2Z0/KLxgtmkvNTfdf7ztx+kzKvj0hy0OFv85iGiYcZ2TDG2KQc1zGNaE
         4WAdBCCCzkqeKgzyM81M5qVEmwGBm+xMh0Qd2eY8AWPJPotrPTzCmDCL3fHQSE1kWzin
         69gCIzhe+GwnPlKDMDftlVhjlapFBoSd3bP+b52ZBYWwAL/W8G8rysrS/XUVDK/vHpYH
         MDRJ0+yzYdWBB3Fa2k/b7/eMTwFBU1TZcAICzJ7dnwOHVpVFW0ozj2/uLldMc7Fhw/hG
         VBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JYVMgf42zZyHE8ws9U4WUn0NjIwADExX69tWsxjM9Gg=;
        b=e2jWwvREtl7KXsb4aEWCoxTi4JwKc2CitMroa8OotobKxB2mIqcNC7JOo1a2aownaU
         3brE0N4JDwtvXUB/8M6WV0eeJgyhGHmkAVUp3N1IY708Etqs3LW4xXBsOBEIYAun+6Uz
         +s1mOeTgIgdw5B1r5L9fodaXjfDdfL4XvTk6V7VpQFS/scuaOR6Cd+KL6gCOxc7vIKwY
         /sgifzrjGPeXWsVV3Y4HwntIZShdDKetblK/E+ibkv5c6rETa+UoptsE6s53LfIapVku
         lN9HBpt9l0WrQTA3l0Zd72VcPCfmO7TpS3L13nztXYD1qtXDbTicbymDT4qXhmEEKd66
         9SpA==
X-Gm-Message-State: AOAM530Nd7ykeLCdjSWm6UMtwToWMBf9pSKA/K6INp/ruWTWnTNqJFL7
        eKLhBCV6lRCm1sOLp/uWILKOVUiAMwg=
X-Google-Smtp-Source: ABdhPJwk+OuAoKwdhBlVTpO06hBNngkHd3nR4OkRAGq1oeYLtttjFODYIQ4uEDfs+GTHpKjIu8vyng==
X-Received: by 2002:a05:6808:2386:b0:322:c9bb:4994 with SMTP id bp6-20020a056808238600b00322c9bb4994mr4375174oib.49.1650719885209;
        Sat, 23 Apr 2022 06:18:05 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f016:fcfc:a063:e36a:1c56:cc6c])
        by smtp.gmail.com with ESMTPSA id n66-20020acabd45000000b002ef6c6992e8sm1773407oif.42.2022.04.23.06.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 06:18:04 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 07365200024; Sat, 23 Apr 2022 10:18:03 -0300 (-03)
Date:   Sat, 23 Apr 2022 10:18:02 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: check asoc strreset_chunk in
 sctp_generate_reconf_event
Message-ID: <YmP8irnHklLbGNXZ@t14s.localdomain>
References: <3000f8b12920ae81b84dceead6dcc90bb00c0403.1650487961.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3000f8b12920ae81b84dceead6dcc90bb00c0403.1650487961.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 04:52:41PM -0400, Xin Long wrote:
> A null pointer reference issue can be triggered when the response of a
> stream reconf request arrives after the timer is triggered, such as:
> 
>   send Incoming SSN Reset Request --->
>   CPU0:
>    reconf timer is triggered,
>    go to the handler code before hold sk lock
>                             <--- reply with Outgoing SSN Reset Request
>   CPU1:
>    process Outgoing SSN Reset Request,
>    and set asoc->strreset_chunk to NULL
>   CPU0:
>    continue the handler code, hold sk lock,
>    and try to hold asoc->strreset_chunk, crash!
> 
> In Ying Xu's testing, the call trace is:
> 
>   [ ] BUG: kernel NULL pointer dereference, address: 0000000000000010
>   [ ] RIP: 0010:sctp_chunk_hold+0xe/0x40 [sctp]
>   [ ] Call Trace:
>   [ ]  <IRQ>
>   [ ]  sctp_sf_send_reconf+0x2c/0x100 [sctp]
>   [ ]  sctp_do_sm+0xa4/0x220 [sctp]
>   [ ]  sctp_generate_reconf_event+0xbd/0xe0 [sctp]
>   [ ]  call_timer_fn+0x26/0x130
> 
> This patch is to fix it by returning from the timer handler if asoc
> strreset_chunk is already set to NULL.

Right. The timer callback didn't have a check on whether it was still
needed or not, and per the description above, it would simply try to
handle it twice then.

> 
> Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
