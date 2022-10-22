Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB7C608F74
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 21:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJVTvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 15:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiJVTva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 15:51:30 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B263069194
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 12:51:29 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id r19so3642407qtx.6
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 12:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EFWVfoQvAvIDm0JhTVg7aF1PtZeCNPSZpK0fAlLWmsU=;
        b=kqzqkxbrpGHjDDKnBDlehMOQpIfPtF58QPmMxZG9/AUDV8PK6MYd6HXT3y8jvKP4G3
         dOu6NhuYXvq1WJsRlCSbDV01Sa0UBFBtapxC9Papee8TSLWYo/75hNd7+MkHWcb4F0d5
         6/ybXvifF9ONkIsmcrZnldQZqQoTqpjpG4xyvXtlDOPQnZvjyUYikpLpr/7TLnJDbQs3
         BBLQuTvla4dUwX3CBQSJlEsWYiakPge1OF9WkgQkyvkAjo3cOMfY8o87l2rGAyeOwGO9
         FYbSDf59BOVD+rJz7h3oH7iWyQHdUBJGKL8JQ4I0ktqLvfNgMPpmvF9NyQxdBMLONbXd
         e7EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EFWVfoQvAvIDm0JhTVg7aF1PtZeCNPSZpK0fAlLWmsU=;
        b=1ewr5vJGPjKE0uwauwPsitu+qeuO6f57qdj/Fk5qeGn02U086mNPURarfbDyYHeylM
         PinvfcgSXELVRuJcePMHMEWDFxGXDYBEJfgBVX7mrY0K1OeRrBmWST8NIjCPI+kpRDUo
         8z0YK9EW00tgC6tzHM7whssqIXjAOcHRz9KjJB+peJu+eEemRikYoXVaWDgIxVCWrW2P
         JQsFtE/gYB7tfOKYO1kHgmjqVzsM2R2dEOJhxyQL4Kv2ABvcJ/xKoDN7LYfAL3DpvDro
         nSktvLLINB2GRiCUqo5DLBXCxWwvXQO5mZAr6PxVsuX4VP2er35uaXhCFA5ahziiXsMN
         6SQw==
X-Gm-Message-State: ACrzQf0shmics9byrJ/Vs+E6LMoC8bu7pt0imJwPCkFPdfEUpWf7Ixe6
        KiQggcKU3K7ElmEOx5Bqld07/YJBmfM=
X-Google-Smtp-Source: AMsMyM5kAFFSQeFy47aSg69FlHL5K3E0pyeXD+6NdPLJmw3kyyCTguke0/wzfkPQTwcV+gDiJFdD7g==
X-Received: by 2002:a05:622a:3:b0:39c:e2d9:2fa2 with SMTP id x3-20020a05622a000300b0039ce2d92fa2mr22115416qtw.582.1666468288858;
        Sat, 22 Oct 2022 12:51:28 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:189b:ee4:2fdd:7993])
        by smtp.gmail.com with ESMTPSA id fe5-20020a05622a4d4500b00342f8984348sm10126574qtb.87.2022.10.22.12.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 12:51:28 -0700 (PDT)
Date:   Sat, 22 Oct 2022 12:51:26 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     "J.J. Mars" <mars14850@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Confused about ip_summed member in sk_buff
Message-ID: <Y1RJvsTpbC6K5I9Y@pop-os.localdomain>
References: <CAHUXu_WyYzuTOiz75VfhST6nL3gm0B49dDMjgkzEQ0m_h4Rh1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHUXu_WyYzuTOiz75VfhST6nL3gm0B49dDMjgkzEQ0m_h4Rh1g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 02:29:26PM +0800, J.J. Mars wrote:
> Hi everyone, I'm new here and I hope this mail won't disturb you :)
> 
> Recently I was working with something about ip_summed, and I'm really
> confused about the question what does ip_summed exactly mean?
> This member is defined with comment Driver fed us an IP checksum'. So
> I guess it's about IP/L3 checksum status.
> But the possible value of ip_summed like CHECKSUM_UNNECESSARY is about L4.
> 
> What confused me a lot is ip_summed seems to tell us the checksum of
> IP/L3 layer is available from its name.
> But it seems to tell us the checksum status of L4 layer from its value.
> 
> Besides, in ip_rcv() it seems the ip_summed is not used before
> calculating the checksum of IP header.
> 
> So does ip_summed indicate the status of L3 checksum status or L4
> checksum status?
> If L4, why is it named like that?

The name itself is indeed confusing, however, there are some good
explanations in the code, at the beginning of include/linux/skbuff.h. I
think that could help you to clear your confusions here.

Thanks.
