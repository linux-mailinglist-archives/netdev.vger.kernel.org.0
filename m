Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A88D3B7ADC
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 02:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbhF3AMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 20:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhF3AMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 20:12:05 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F384BC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 17:09:36 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c8so778239pfp.5
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 17:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2a+J8XHRlWZ/MXOKkR0mnThkSKB1NeYq9WZ7Py1I9iA=;
        b=MmMOGa9tgKGASmHsdEqeCAZPt4kNPlMjKQxJ56qBHpgKWDRJYUwdUXfabxyzzr7vPq
         59LPawGZ5ewRiklg/jLvZ/dNtHtVOJYNayQ5ITqj055lqOFl4+L6N/ldn/PXk/v/P2Y2
         Dd2FLnDM6BEta9f44jjQmJ5zUEMJDN/xcLU7/PNTeX2qRhcPJMy1lLZt2Hvq4Y5G/MMT
         z4rQ9WyK51Q+fFKbnhZEl2B8MvRruEaE28uf6Mc9lkOeMOmiDylnia3Tr0azNA3zmm57
         9ooHchLizBkUDYjJ30jw/jQsi+1XucG7h8GqXNjlDPUejDOSsfmoW1HFXiIpkajPi1DO
         nGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2a+J8XHRlWZ/MXOKkR0mnThkSKB1NeYq9WZ7Py1I9iA=;
        b=Wrz9n9nyVnGliTyeF/cuMlmTVpQtl9Rea67jbmD3xbskVCh8cP/4Q7NViCjf1/FSEg
         1qGxPSP6vt/JBDIHwETgvNoRb+MaXkjHwYaf7BSaT4lpCoaREu9GbS45o5tJ8d2xptCP
         ZWYYm/m+sJ6q5vYfYIwirwPnwad/fLQ74SspHWPtvqL0B23ioEFnmVLsVbJOBEhhIr6z
         n+8K1oKebvqPXBTy8EINHcR+IdX79sHRiPUVvt00RpA0iytdNrKVeQ/C9ZL8rCuxTjrE
         R7pxgI6fWset+koeOXNusRZ7grh02+CuLOqvsoZNlbPra7b4vbzqj49E3YF0/rhYQNAp
         +sAg==
X-Gm-Message-State: AOAM531V9Z+Wed7mgsYlf6yh3wEGiq/I6NKapwv7ZkU0NbbvTacQwwDS
        TzgXdvW2x07mx7zGNGytPgU=
X-Google-Smtp-Source: ABdhPJzjxL5zg1D5Fp2fhEDINDfpHB6os4BicwjH5fKktkM+MwGlhoB3WzG4s3asngAANnBoPVqeKw==
X-Received: by 2002:aa7:824a:0:b029:2ec:89ee:e798 with SMTP id e10-20020aa7824a0000b02902ec89eee798mr32896437pfn.12.1625011776438;
        Tue, 29 Jun 2021 17:09:36 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id i3sm21355150pgc.92.2021.06.29.17.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 17:09:35 -0700 (PDT)
Date:   Tue, 29 Jun 2021 17:09:33 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Message-ID: <20210630000933.GA21533@hoboy.vegasvil.org>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
 <20210628233056.GA766@hoboy.vegasvil.org>
 <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 05:19:28PM -0700, Jonathan Lemon wrote:
> This fits in nicely with the extts event model.  I really
> don't want to have to re-invent another ptp_chardev device
> that does the same thing - nor recreate a extended PTP.

If you have two clocks, then you should expose two PHC devices.

If you want to compare two PHC in hardware, then we can have a new
syscall for that, like clock_compare(clock_t a, clock_t b);

Thanks,
Richard
