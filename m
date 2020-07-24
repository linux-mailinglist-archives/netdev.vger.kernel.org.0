Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519DE22BD29
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 06:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgGXEsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 00:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgGXEsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 00:48:15 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFB6C0619D3;
        Thu, 23 Jul 2020 21:48:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 207so4438667pfu.3;
        Thu, 23 Jul 2020 21:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Smo1dNl05bdB/pApWLRvotLIsWnNVwAGo8qoTT70Ax4=;
        b=IC2noAvEa7YvGfX+ZVzdVqMj3h10oNZxf6iucJI1nj3FRsErqKmYzdPpAVWaxLq7YB
         NKjuR8qdIObCuZlkg2oNR1lqDaG2sOr7Ecr6jfFT1/hrj+oyZ4SlWddju46hPJfIsZTJ
         KQDibht3uAr1SGSF3V2ixE+9AsURRfGfX0T2h2SFLBdHCNJrHS+LUCfGurRPldbPh/oM
         qRZWEemJwuOqQf1f0y6RvzmT5fAPGJ1czffcvggovA89Zqc7jOKY5dxh4/g0N9CuKUF4
         FTELkRJLpib3ms1o9gHwQHS2eePOnYjDuwmnmk28hg1MZLGZ1DCc7gHKQ1WyR0aoSqSp
         pbkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Smo1dNl05bdB/pApWLRvotLIsWnNVwAGo8qoTT70Ax4=;
        b=AS7Yg8Qb2yVCU3IASRr/+t9h6Tt6Wj+NQzpiKNyFcaiKzd1Cv1nnyw7/qVxW61DA6y
         nsLHCAp3ZUFafQA4tfVjS40eUd7sGBvHyQQ17UqZkeomg9xOPuTnWBEWvTEgyaprNpm+
         5YeCf6e4k64DnAOwbsLOM38ZzGTFBBWcL3mYaFg3e/VlxqWA0NYFOxSsh31YnkEQjk1I
         DfIpVU+TjBWra5fh6ElBHGo7hfUo2jeAn1/PTGiHvcszyrce6tAXA2/c7o9QG0Xfl+w4
         tTA3tXy1aBrHSAp2ap0dKQz1dBc0YsLogdLd5F44EPxObv6Tyhq1doRudLbX5RzMxRMp
         H9uA==
X-Gm-Message-State: AOAM530dS39IKLj48S7hIARSuhrrT06LPFqkPFBCpAQsnMbrarhQRefh
        sE6h53Rf+J62TEKDmG7pUQ==
X-Google-Smtp-Source: ABdhPJy1/IvkCaVnZm/0fqm+5jyz8+iO1p3rSkyAhFdKTVC7sz4XwPorkl8mlkGD6Blouj0rjLc0Kw==
X-Received: by 2002:a63:4d3:: with SMTP id 202mr7178001pge.14.1595566095086;
        Thu, 23 Jul 2020 21:48:15 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:d0b:42f6:15cb:b8d6:d88c:7a5d])
        by smtp.gmail.com with ESMTPSA id u13sm4128828pjy.40.2020.07.23.21.48.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Jul 2020 21:48:14 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Fri, 24 Jul 2020 10:18:07 +0530
To:     David Miller <davem@davemloft.net>
Cc:     madhuparnabhowmik10@gmail.com, isdn@linux-pingi.de, arnd@arndb.de,
        gregkh@linuxfoundation.org, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrianov@ispras.ru, ldv-project@linuxtesting.org
Subject: Re: [PATCH] drivers: isdn: capi: Fix data-race bug
Message-ID: <20200724044807.GA474@madhuparna-HP-Notebook>
References: <20200722172329.16727-1-madhuparnabhowmik10@gmail.com>
 <20200723.151158.2190104866687627036.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723.151158.2190104866687627036.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:11:58PM -0700, David Miller wrote:
> From: madhuparnabhowmik10@gmail.com
> Date: Wed, 22 Jul 2020 22:53:29 +0530
> 
> > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > 
> > In capi_init(), after register_chrdev() the file operation callbacks
> > can be called. However capinc_tty_init() is called later.
> > Since capiminors and capinc_tty_driver are initialized in
> > capinc_tty_init(), their initialization can race with their usage
> > in various callbacks like in capi_release().
> > 
> > Therefore, call capinc_tty_init() before register_chrdev to avoid
> > such race conditions.
> > 
> > Found by Linux Driver Verification project (linuxtesting.org).
> > 
> > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> I agree with Arnd that this just exchanges one set of problems for
> another.

Thanks Arnd and David, for reviewing the patch.
Do you have any suggestions on how to fix this correctly?

Regards,
Madhuparna
