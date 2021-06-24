Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458DB3B259F
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 05:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhFXDqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 23:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhFXDqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 23:46:05 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC0EC061574;
        Wed, 23 Jun 2021 20:43:46 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e33so3589652pgm.3;
        Wed, 23 Jun 2021 20:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Fwh833srj12QAX2haTEqWT0V0OlCa/leSx47S6U0FNE=;
        b=hGxnyq2XiX8H7w5esy1UtDOY5y32a+0A8lBcJDwanK1YH2UuuZcdJ+D6VykggYGIzt
         Mx8F6o3dxXLtxrEwFENljHNFiI97JyhNIhq9aFK5NC5qr9pPep1c0zmflW5UaTxXnrOo
         iEWH64hPZhu/c4qTuJ7sg85UupzGMZ6cwU/9ZPayY9zgPCRLWvoQXqyKPzbywMQ3sD+6
         +a9NTOa+NtDaBQHvYM6hqIJf569nnMeEIhXKdQVZ76vC7WbLB9pI0Eeh64+CBZhX4kcs
         khumk8pQZ4NX6VwjXhQ9yel4I4NcLIkBF0MkOjRfNcgsOLRbp666M1VupC2XAbbm6/8N
         bjVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Fwh833srj12QAX2haTEqWT0V0OlCa/leSx47S6U0FNE=;
        b=YBCz6UH3+1OTEm8TUD7QLyDH9Gr+k/JSb2UqgECX1GiCBGq05fPz86qyGR6VJ+xWOy
         durs4D6tqlchtQdEyRrcGtuzExzfBD3xrvk69yHTweUfLxWPQmfVHJ+9D5HUNrYE4DqB
         Ec2eV9uTngO6LgsokyyrCzphvsgYVWSI6vcTdhY7KcscVXNIIANPRy9Tr7hRf3iMziuD
         zsW5Vjyq5PbzwBOHXDOoUPzCKagQXeERfiyM7rjajAb5LQH6uiqza2F3L4r91ACeVYdL
         eBd6koLxGBN2cxId+KHwVZWhhXIn7vVCPp+cBE6MD2D4+Z4UwOoUedKFMqI/S6wQwYsV
         j8dw==
X-Gm-Message-State: AOAM530zRO6qcUDCLnJ1HoGK4n/cfBKhc4tZm9y0LMyCv5jibGdrktzZ
        UdmmCbJqN4ENFioKmMVSesqfBe3Z4G0=
X-Google-Smtp-Source: ABdhPJzblbgMHSmmEfohmmRVc6UZo66eh5zRAnZw8CihxH8rp9ppLVtbHAibTU2w535Ss9nONxBEEw==
X-Received: by 2002:a05:6a00:1acd:b029:2fb:81a4:b06 with SMTP id f13-20020a056a001acdb02902fb81a40b06mr2907867pfv.36.1624506226222;
        Wed, 23 Jun 2021 20:43:46 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 11sm1103686pfh.182.2021.06.23.20.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 20:43:45 -0700 (PDT)
Date:   Wed, 23 Jun 2021 20:43:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] ptp: idt82p33: implement double dco time
 correction
Message-ID: <20210624034343.GB6853@hoboy.vegasvil.org>
References: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
 <1624459585-31233-2-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624459585-31233-2-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 10:46:25AM -0400, min.li.xe@renesas.com wrote:
> +static int idt82p33_start_ddco(struct idt82p33_channel *channel, s32 delta_ns)
> +{
> +	s32 current_ppm = channel->current_freq;
> +	u32 duration_ms = MSEC_PER_SEC;

What happens if user space makes a new adjustment before this
completes?

After all, some PTP profiles update the clock several times per
second.

Thanks,
Richard
