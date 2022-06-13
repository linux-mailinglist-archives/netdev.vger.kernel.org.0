Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA30E547DBC
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 04:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbiFMCwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 22:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiFMCwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 22:52:07 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F0D387A0;
        Sun, 12 Jun 2022 19:52:06 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g10-20020a17090a708a00b001ea8aadd42bso4723062pjk.0;
        Sun, 12 Jun 2022 19:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+syu8zXTLNzuwkgu0YpXNp+GQJj3tWOie/YgNIKS4U0=;
        b=M0eUrqzokBUgw6kx+SeIUwac//UqJb78eJPvjl4zcc7ye76BPFJyAFRItO4se0MfNB
         baIgwLhM25mHwtekNXBMrtvYAjO4pGOFwzPjWjpioSf89+x0Cd1eJbR4lYcZLUkXiRDu
         87TOZ6RXlLmR9uebqGC2BzZZwnlNrHO1qCPWtxkSvwa9eubRgcSwJYK94w2h7lPk0/mq
         oLhlyFXohWdlZt+OmlaHfOsbz0Pyw14uhedYzP8zWmCQNJSJIEf9dKfF5SccD7kyOt5p
         6ouMbiKRBT04OHIfOvNub3sIEcZ04uRA/pKQO/09k/lUrHvVtdzTexTf5WdAK/4gflB4
         NwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+syu8zXTLNzuwkgu0YpXNp+GQJj3tWOie/YgNIKS4U0=;
        b=2/zvAtLBJhqtY49qZpivhl1ibHQjWhtY6KSvjy7mROjhx5lBbuR989Xqdh4UDRKtZz
         MMSAj+B9yycNHXuGY82KmAAGCIoSguf1KkqqDzxlXR1xB91dcTFbPrnGtGf+pRy5vTr5
         va7easW1G/2jztVC2j4RP3yJ8JERpFGirCkHlAEQZGFQtaSwD1SREffeuRNsgJPXHd5P
         csvR3rvtBmYt8GaISyBvyqce9BnVOeGGk5Pdk37Dm/HHwhV9Q0ApwVoAxY1iT8cjaWtH
         x3EQdFjnWIFmRfCVBmq/9CNefWj8+1Ndzo/lk6j1EWEmQT/aoU+AHMeycAlsxGjtYN4o
         MUVg==
X-Gm-Message-State: AOAM530oTf0cRljvl1ciSleLBdrqOYef89ehmryNov1vvMFE3r4i6R5B
        bn93df3tTK+xpYKjXqHf+B8=
X-Google-Smtp-Source: ABdhPJx1eYlhYQSPfX7umirYAVUsnMFMYLEGdt9XIy8VcLdLixPOVw8G2uR3P6K9i4Hs+h6lxCZoJw==
X-Received: by 2002:a17:90b:1c82:b0:1dd:1b46:5aa9 with SMTP id oo2-20020a17090b1c8200b001dd1b465aa9mr13354049pjb.158.1655088726257;
        Sun, 12 Jun 2022 19:52:06 -0700 (PDT)
Received: from localhost ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id x16-20020a1709027c1000b0015e8d4eb276sm3732099pll.192.2022.06.12.19.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 19:52:04 -0700 (PDT)
Date:   Mon, 13 Jun 2022 11:52:01 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Srivathsan Sivakumar <sri.skumar05@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: qlge: qlge_main.c: rewrite do-while loops
 into more compact for loops
Message-ID: <YqamUSc3Y9TBwAEH@d3>
References: <YqJcLwUQorZQOrkd@Sassy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqJcLwUQorZQOrkd@Sassy>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-09 16:46 -0400, Srivathsan Sivakumar wrote:
> simplify do-while loops into for loops
> 
> Signed-off-by: Srivathsan Sivakumar <sri.skumar05@gmail.com>
> ---
> Changes in v2:
>  - Rewrite for loops more compactly
> 
>  drivers/staging/qlge/qlge_main.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)

Please also update the TODO file to remove the respective entry. The
other referenced problem instance was already fixed in commit
41e1bf811ace ("Staging: qlge: Rewrite two while loops as simple for
loops")
