Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A94394CF2
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 17:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhE2PdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 11:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhE2PdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 11:33:13 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD87C061574
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 08:31:36 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u7so3052404plq.4
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 08:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mbOepCu063jWhSqrLEB9cQeXrixzOI1CS6gsORfSq5k=;
        b=q8zZtbhX4ydDGr251EkKMGq0pyhlRaJKG+AqB5qMhQSc1c68QJ/YJBq7zELFI+Isc3
         dXmzNJ9DesgFvrd9tkYEoyf0gNUESL7dxLMj5nC66YS92/2/1gOgf2dflefZB8aruuD3
         P1cL9ne4sBz60f8EY/A6onGD44hG86E9S+ZWYzgwloxe+0KjlaPkO38ltA4HXN9sD8qK
         5uClDUT7+XIgUcbLT7g6BsVtgL/y1Ia6XsmS4yHBvtQZucUNI9lXHcNidcRvQOfiKMFz
         8mNNN61KkMzaTnuoRMf7c+bS2KC8JfNQprW/waU1rbDVATout7JzOUcHIS4exhsfYSDL
         RtYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mbOepCu063jWhSqrLEB9cQeXrixzOI1CS6gsORfSq5k=;
        b=og3Odijr7zUfuaj8DE19xc0s4fOuIoOqHpEt7z+ohH3OZAm2t9FVw0W9uCkAoJnepf
         2zyz8DBFNb3MfK3K3EHTKvD+rLDBk/Npf99VEz8ivTm7FYIUSWswQoVSB3NkdIBcwANF
         esk6kPlPVA7iBX4r7LoygEjA/B5BziN9q+BvYK3R5ybF01kJxYTc79w5drWhPhUnx41h
         L528YzNvVsplDPEkEd3CGQWeUH7rPfiLCD/yYWgJEaUStxp53sxxj6DIPLv78nz+gSVU
         +kIgjunysKMFaaqC1yktnjxl+qr1vKsI7n3hXgw7BKbxB3F+Mz2xnZbMh9fULg1S55pj
         Y7rQ==
X-Gm-Message-State: AOAM531CLGRB1Gy6Bye3jljwwISG20fvH/Gqp4zv3UxwKFSO+2G9IBY2
        /SkkK2xHyFZaQW206gY4dTo=
X-Google-Smtp-Source: ABdhPJx/RTliuqS/Ixf1ikp8BwXgtxcszYXercDdi7WZSCLKLRahY9ftAWE6KNlTBX8z+b5yUbCvOw==
X-Received: by 2002:a17:902:c60b:b029:f1:55a:7fe1 with SMTP id r11-20020a170902c60bb02900f1055a7fe1mr13008099plr.33.1622302295832;
        Sat, 29 May 2021 08:31:35 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c191sm6909754pfc.94.2021.05.29.08.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 08:31:35 -0700 (PDT)
Date:   Sat, 29 May 2021 08:31:33 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next 6/7] bnxt_en: Transmit and retrieve packet
 timestamps.
Message-ID: <20210529153133.GB13274@hoboy.vegasvil.org>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
 <1622249601-7106-7-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622249601-7106-7-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 08:53:20PM -0400, Michael Chan wrote:
> @@ -319,6 +383,7 @@ int bnxt_ptp_init(struct bnxt *bp)
>  	if (IS_ERR(ptp->ptp_clock))
>  		ptp->ptp_clock = NULL;
>  
> +	INIT_WORK(&ptp->ptp_ts_task, bnxt_ptp_ts_task);

Instead of using generic work, consider using the PHC kernel thread.
See ptp_schedule_worker().

Experience shows that under heavy workloads, work can be delayed for
unacceptably long periods of time.  The advantage of the kthread is
that the admin can use chrt to give the thread appropriate priority.

You could also use the kthread to perform the period time reading from
Patch #4.

>  	return 0;
>  }
>  
> @@ -333,4 +398,9 @@ void bnxt_ptp_clear(struct bnxt *bp)
>  		ptp_clock_unregister(ptp->ptp_clock);
>  
>  	ptp->ptp_clock = NULL;
> +	cancel_work_sync(&ptp->ptp_ts_task);

Thanks,
Richard
