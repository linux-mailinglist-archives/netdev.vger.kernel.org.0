Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD751D5F78
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 09:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgEPHre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 03:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgEPHrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 03:47:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBAEC061A0C;
        Sat, 16 May 2020 00:47:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a5so1991328pjh.2;
        Sat, 16 May 2020 00:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QEmYgazlmGE+HVz5b0KPrHTAIyObPJ2uGnNP555qmvg=;
        b=fadS0LiNyTjvPnIgjA2gokqqwwfzBqwVEa5+3y5/WxoFcfATlTi6zgn4PJ3sQ+XxG5
         BU24UKftzshOk1bT7YZeRXwWZ1MfAXWNai33Gb7zg/eKy8yFem7CGzuHcUakKppbH2w6
         HsGt/EWILBUTh68uHEMxUMcgcHJxJJ2K7qFQknS5La+vf+14a2zFo6HdwZaAVQmPFNJ1
         ZF9TCjfP6KldE/BfX+ByPkm3jQR3MP1lXm1cTPpXgQldx5CFr0Z5UOkSr0h4DT2i38j0
         Jfz+UbB8PxjozBCuAP8BGUeWNLA9Ot8MSQOmDkxTORv38nXFOfVa1Ir9fc9742SmUrEY
         Hc7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QEmYgazlmGE+HVz5b0KPrHTAIyObPJ2uGnNP555qmvg=;
        b=E8gq3DWcUQK6XLpdUAPJoNWYQY6BvVbybzai+mYTtctk3AjEf+8ybUGXOfiZO//RmI
         HzgVcgldqcq1MebUBjv7DPdytnAkdJK9z7XKw1ZPMZSBPWNwSz5agjzq+ehtPopW3svm
         oR9ReN8E+nEYZ7iNCVQcovUQ5s9HC9VrOgc1R0BolfNoRgwcm8q3neDCBUAt56Vqws9Q
         mPu29f6aSSP+Hsbh3HUQLm0GSJrj3jJtZ87RZEFuEMiMwvvg/1lFCCOb3E/VjYRbuhtD
         c8qmTonDrnv79iPeObKVkj9NQQVemjpDI2Kf4ma9LTPdsQmuWEGHAET0u/21hEIjivOT
         b2TA==
X-Gm-Message-State: AOAM531a8EFcOTeDc21eLJfweZcErQwuyBQizW0Lmc8E+zWwczDY3VQ/
        YBGIcKpo2fIFm4aoKuvB1g==
X-Google-Smtp-Source: ABdhPJxKwvgM4CAxg4IySwm43iKqjxFfg1ZE/dIQ/ZT9bCgRaAn0NtphOJEoQyjVxkURCcB2Ja0chw==
X-Received: by 2002:a17:90a:246d:: with SMTP id h100mr7154695pje.21.1589615253057;
        Sat, 16 May 2020 00:47:33 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:13a5:a61b:b5d4:b438:1bc1:57f3])
        by smtp.gmail.com with ESMTPSA id n69sm3257645pjc.8.2020.05.16.00.47.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 May 2020 00:47:31 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Sat, 16 May 2020 13:17:24 +0530
To:     David Miller <davem@davemloft.net>
Cc:     madhuparnabhowmik10@gmail.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        frextrite@gmail.com, joel@joelfernandes.org, paulmck@kernel.org,
        cai@lca.pw
Subject: Re: [PATCH] Fix suspicious RCU usage warning
Message-ID: <20200516074724.GA13822@madhuparna-HP-Notebook>
References: <20200513061610.22313-1-madhuparnabhowmik10@gmail.com>
 <20200513.120010.124458176293400943.davem@davemloft.net>
 <20200514070409.GA3174@madhuparna-HP-Notebook>
 <20200514.125011.743722610194113216.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514.125011.743722610194113216.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 12:50:11PM -0700, David Miller wrote:
> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> Date: Thu, 14 May 2020 12:34:09 +0530
> 
> > Sorry for this malformed patch, I have sent a patch with all these
> > corrections.
> 
> It still needs more work, see Jakub's feedback.
>
Yes, I have sent the v2 of this patch.

Thank you,
Madhuparna

> Thank you.
