Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157651E014F
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 19:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387838AbgEXR5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 13:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387656AbgEXR5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 13:57:37 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812CFC061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 10:57:37 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 124so1515422pgi.9
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 10:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8DjxVOIa5bw7yl/epsJiYQNESVWu77B9rCn6odPAW+I=;
        b=iF2RCsKVFEeO7ROSv2K61FgJ/1pTAyMU65BmwdCirU0LNVqFqsfy3LmY9tdGYoGbbD
         I795RIfnVRjGBcE5i8pGJ05l6Yd6jDFnJ06x0Xz9cR03LJpJUz5ZaJrbb/EEUDMpoJD2
         o8q3+e5sKCzldRFiKJ+symfL/Tkg9gOddG5QK7keTkyneHZNMjTN15KzuCnfjpWq+tpd
         FayuhVD8/4cJY+fZLlH9kW//mXKgp9C/Dgm/DLjg6JgvPcdiAWZuUEW+WNm3mFnpTXRy
         u02V7dIt4PUsM5CrqEJNnRhpEGO7qghFJUGfvY7IcIvJr4MZYgj6vLTCADVn5tWcYfNp
         fIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8DjxVOIa5bw7yl/epsJiYQNESVWu77B9rCn6odPAW+I=;
        b=rAutUZvXSFpVBKzsxPVWMJCqTgiBQRRlvGlsGlOVGyiYDJegRR9PXMDNbqyl+E1MrW
         FpU1ojw0S4trEK5dC77L/pwh7v9k9R4ibU0Zs9wDtJRbEOdQYrA0qGRaoupwDoOM4Iff
         ln2o8zWgdsxWtaaGjkgNigzk20HHChe9cJJf1oEneAjKP+hpxU+iLQ6CxgaGP0pjf7cA
         3c0MAUDtHgpnNtVHLj6WYRJZi9VZGLFMbSzrl++p+PqWNeOOFjaQVez22yUJab8ttvX0
         Kv5QOZemEF7cuwbBNfZoyaiWwnFQgAf/Q0+siNEnsOG70+vFTQ5eUrkZTM9WSdghIxvB
         m4Lw==
X-Gm-Message-State: AOAM533AU4prlZ+bNubg875qv2nLjwSufb1hUSfHqK5WtROywh49R2Oh
        03WRebE/8CLDEa3PBF7RBY065/D3VeE=
X-Google-Smtp-Source: ABdhPJyTQPGbcK/JHkxFkiiXEZpf0NgLWtTrfTQaYqKxQeNN/uYjdy5QkkA3qhvqsJdIFQy4Xc0vRw==
X-Received: by 2002:a63:3609:: with SMTP id d9mr22893006pga.354.1590343056753;
        Sun, 24 May 2020 10:57:36 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id l1sm11803765pjr.17.2020.05.24.10.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 10:57:36 -0700 (PDT)
Date:   Sun, 24 May 2020 10:57:33 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [PATCH net-next] Let the ADJ_OFFSET interface respect the
 STA_NANO flag for PHC devices.
Message-ID: <20200524175733.GE22416@localhost>
References: <20200524132800.20010-1-richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524132800.20010-1-richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 06:28:00AM -0700, Richard Cochran wrote:
> @@ -147,8 +147,13 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
>  			err = ops->adjfreq(ops, ppb);
>  		ptp->dialed_frequency = tx->freq;
>  	} else if (tx->modes & ADJ_OFFSET) {
> -		if (ops->adjphase)
> -			err = ops->adjphase(ops, tx->offset);
> +		if (ops->adjphase) {
> +			s32 offset = tx->offset;
> +			if (!(tx->status & STA_NANO)) {
> +				offset *= NSEC_PER_USEC;

Oh man.  This should check for ADJ_NANO instead.  V2 follows soon...

Thanks,
Richard
