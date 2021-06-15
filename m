Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0763A764D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 07:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFOFPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 01:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhFOFPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 01:15:38 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BBEC061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 22:13:33 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ce15so20288004ejb.4
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 22:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zBluklgTMc/Uw2SUbhlHlxNUQrJuHjtLqb4c08vReFY=;
        b=m3J06Z8B8hXA4ArgylSzs1eaQ0pqCTRaBAPcJt86PEXgMhECQFoHcvl61zIBo8K7TR
         lcEZSp3G5pZJV8W0Xk4Ranhrf+svixKh8LdtbTWXfWXVX046Cf5DawdLYz7KXo+1GxrT
         w5pO1eF3+8FOQkGYIZ+skOQY57Sk+s4fwy77EfNJ1rLSssT6v/1tnW5B6p6SLHSRBuHh
         9l1KkDWLxOvF7XvTYjvBme3aA5w9wgRvipkIk9C5+qlIRcVevOXI49zffg4yrtL+LrIZ
         tA7dXGkuRPB4OURbI8+Hy8ZuHs0tSIsFXAc6wwrtTlhmkBc8ac3/Or6rlRCPTe5sch94
         FlqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zBluklgTMc/Uw2SUbhlHlxNUQrJuHjtLqb4c08vReFY=;
        b=NMVHK4+k4ptb5x3hFy/JF0HXHaf6ppY+2QJlfIqkwyfbNqN43gV4bAMgf6hQWVI2Ok
         EeC9CVzrV6pBXNVYQuTGlUa/lh70vZQA1O+164m2JboPpf3GmzVZq4LryMlFuGUM7V8t
         A1nIzbvQkRFs6tX4OyaXogqXoP/nMMlKd7pbqL39/hD6HcaMLS+BodbuocVlJ4drqMJ9
         MH02O6j7Z3rCgPK0P0j8HChZ0/3S7Obash2cnin39HA27gQ8MJFFhjme1AgsyaVuOwBB
         Nqoiwh6TeKquusIgfG6bZm9a2xVrqQgJJaNUkU3a7eEbqroUbkDcYpZepR0Q/F5bBH4/
         sYBw==
X-Gm-Message-State: AOAM531TyX6Neax18n3KSbi8YUG366kAjhTFVJOYt801Sdq7AGJ4JumN
        5gWu1u3pDD8+8TMdqG1Q530=
X-Google-Smtp-Source: ABdhPJxqesoDzZxhFIKalMycmOXqmvEFz/OlnO39prMRNH4jbM+YUJDYx+qbBCCmsnqiLirstRxKFw==
X-Received: by 2002:a17:907:20f7:: with SMTP id rh23mr19307936ejb.414.1623734011919;
        Mon, 14 Jun 2021 22:13:31 -0700 (PDT)
Received: from localhost ([185.246.22.209])
        by smtp.gmail.com with ESMTPSA id z63sm11168636ede.36.2021.06.14.22.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 22:13:31 -0700 (PDT)
Date:   Mon, 14 Jun 2021 22:13:24 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, jacob.e.keller@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] ptp: improve max_adj check against unreasonable
 values
Message-ID: <20210615051324.GC5517@localhost>
References: <20210614222405.378030-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614222405.378030-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 03:24:05PM -0700, Jakub Kicinski wrote:
> Scaled PPM conversion to PPB may (on 64bit systems) result
> in a value larger than s32 can hold (freq/scaled_ppm is a long).
> This means the kernel will not correctly reject unreasonably
> high ->freq values (e.g. > 4294967295ppb, 281474976645 scaled PPM).
> 
> The conversion is equivalent to a division by ~66 (65.536),
> so the value of ppb is always smaller than ppm, but not small
> enough to assume narrowing the type from long -> s32 is okay.
> 
> Note that reasonable user space (e.g. ptp4l) will not use such
> high values, anyway, 4289046510ppb ~= 4.3x, so the fix is
> somewhat pedantic.

But still important to defend against fuzzing!
 
> Fixes: d39a743511cd ("ptp: validate the requested frequency adjustment.")
> Fixes: d94ba80ebbea ("ptp: Added a brand new class driver for ptp clocks.")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Richard Cochran <richardcochran@gmail.com>
