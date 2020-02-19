Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B226164865
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgBSPWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:22:51 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42834 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgBSPWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:22:50 -0500
Received: by mail-qt1-f196.google.com with SMTP id r5so435801qtt.9;
        Wed, 19 Feb 2020 07:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=80jC7mm6ENiYivWinnfWz8y04hWlzmZYkrE9zSqrG+g=;
        b=DNI7RRbs5np4aFKQEb6jIAiEOoY7sWKOK93w1Sa4c1mugsDJiElW3eqCjVvLa0cHUV
         De/RV3sic7P42bJet/IyjMIMwlC+ydJQdKltUak7qDZobDXMRzvrW7YA7N5YGdJgXHdt
         0DDC/abGiuXnMzFf7zInMzDcwxP9eoI/VIrwR4ma7PinkvAEKmKcG7UKD1z/vjhpZKFZ
         tCxPyXG8Vhvb8tGXqQ0Fs7+7VPO3Y65RA9WPEwSfrHD6873zO+bYKjkBy1vJsxtERZLR
         ZlPb6Ld+a/dUCiP/VoN6FWPXc62WrQPrfv3H7uCTrWn3+uPSMZMFHI6iNZwTkYTHkPjp
         7Wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=80jC7mm6ENiYivWinnfWz8y04hWlzmZYkrE9zSqrG+g=;
        b=N0TFdG3wFyu4xSDvEpVS96SZc+b/ldIqqN5gbkk5kqXPDZDEqbXFKaUMR/uiDeFqa8
         hVP0fSzbVjK8bsgF6sulmvGzTM02r1ZYe3MMbLR4+C1nBG3dE/qFhdU/SmKlyAaAx65E
         sGAVReqM88AN5YR3HXpL2ntZxXymYeDzcDwhJVuh/SrDhd+3h+wyi+m2rffG+ucXwhVG
         ziwv2s+sUPNGPLP13x4fo+nhDMK5CbHajU3MLeRKo/3ETI92pvgSYDlZp1bHqVxV3xat
         VDZIZ7fI7N3vz5U+Vet7mY9Djk45I2fxZSZssD8EM0/+LMXFtTdKBI1M00QVzjOF2FlO
         aNag==
X-Gm-Message-State: APjAAAXG/54EL1tK8mxLMcEMNR7AThym7tsHh9PlBYPpZO501QQ5eLGH
        aDbT4HLaB2h4XNCu0fZg5hI=
X-Google-Smtp-Source: APXvYqzJerrYieyaEgKN4U+5zDpmfDyEMO+0UFQrbwNA0AMkEXxmu5rGwbbWkMRpuHmGmXG1EjKbyA==
X-Received: by 2002:ac8:1415:: with SMTP id k21mr22848245qtj.300.1582125769278;
        Wed, 19 Feb 2020 07:22:49 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::2:e7ce])
        by smtp.gmail.com with ESMTPSA id z21sm1139339qka.122.2020.02.19.07.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 07:22:48 -0800 (PST)
Date:   Wed, 19 Feb 2020 10:22:48 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-rt-users@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Mark timer used by delayed kthread works as IRQ
 safe
Message-ID: <20200219152248.GC698990@mtj.thefacebook.com>
References: <20200217120709.1974-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217120709.1974-1-pmladek@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 01:07:09PM +0100, Petr Mladek wrote:
> The timer used by delayed kthread works are IRQ safe because the used
> kthread_delayed_work_timer_fn() is IRQ safe.
> 
> It is properly marked when initialized by KTHREAD_DELAYED_WORK_INIT().
> But TIMER_IRQSAFE flag is missing when initialized by
> kthread_init_delayed_work().
> 
> The missing flag might trigger invalid warning from del_timer_sync()
> when kthread_mod_delayed_work() is called with interrupts disabled.
> 
> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
