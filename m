Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94A0321AB8
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 16:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhBVPDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 10:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhBVPDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 10:03:18 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742A2C06174A
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 07:02:36 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id h25so8727266eds.4
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 07:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8uDLeQs8XfRHy1pQxb/hoYg4CMvrJPfF8knqrqeG9GI=;
        b=rqTW+Jr+SI6iZtbr8isvzl2VowBCjPZoN+8SkqCGlGsILFCxCHAfDkeKAeadlFx/5D
         Abab3TShOyPNM8qdqo2xUec3kU2r9UxTTSCVwnv494l4OT4BGW9FkfUkrx8YY1sA0wa9
         GtoHAMfEn2/rWCQKAheD6f3Gx7R+O0bsW4xLlxwVhF6iLGWjQJILQfxN0mMocWgC/L+a
         Pswh8DRw9zYVr1nzY0QX0QM+BMZn9ds6+A/CY6b1ZXZQx+pGwnwZhC9Ff5MjIRB0vNP+
         ITzEb9Ciki3eFQQMIwlSadpAVs2TS6dlUX2ULNi+urYraVXk/MUhU8KwRyRYhmnFAe9I
         ywCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8uDLeQs8XfRHy1pQxb/hoYg4CMvrJPfF8knqrqeG9GI=;
        b=dujN8hpJm3wJzejn1sb++E5wrB+TDkUUQViI2KUhEx9tfviLcUHKZkyxIxNdaEh9Wy
         jgluvtyyDQ9WgHO6xmEXepTL9iTg3y7u6RG5BBIwDIy29f4XLFUFHY1WYVgWRlsG1rcY
         mSwGz7mBC9DOoYgHCDxgRkYcYzVKkBcWbOKOvvb6IyaLkhqtW5CXgJjryy5Z6axycpR9
         zOhTN4TIdzWnkGpsq6nLQmZBvkbS52IU17vtiaSheFcIUETO2Hp+dNCaSzrIG5ydI+ih
         T6kewF8ZBPEXCb40oyyKWigp1mt5lkZIbB84zwtDm0JMRSH/FpBOwAqybZ5ssyZD6vHu
         hUtw==
X-Gm-Message-State: AOAM533kd6NjpOM/FgvYBialjzerdhBIOm7Fxa09HDrKzGPr2irkDANI
        Cmh5VNc5WpxHJjuBR150kAT54pFgqo4=
X-Google-Smtp-Source: ABdhPJwVlxkp9293s7ESFljeLypGl3Iz2VQn8Ol3XCuDKgbXsR1i7At7q8WIC+i4key/rHh+2JfUsw==
X-Received: by 2002:a05:6402:1341:: with SMTP id y1mr21475584edw.123.1614006154985;
        Mon, 22 Feb 2021 07:02:34 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id k22sm12244341edv.33.2021.02.22.07.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 07:02:34 -0800 (PST)
Date:   Mon, 22 Feb 2021 17:02:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [RFC PATCH net-next] selftests: net: dsa: add a test for ports
 matching on notifiers
Message-ID: <20210222150233.j5l5u43psfcjgbva@skbuf>
References: <20210222120248.1415075-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222120248.1415075-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 02:02:48PM +0200, Vladimir Oltean wrote:
> +/*  CPU
> + *   |
> + * sw0p0 sw0p1 sw0p2 sw0p3 sw0p4
> + *                           | DSA link
> + * sw1p0 sw1p1 sw1p2 sw1p3 sw1p4
> + *                           | DSA link
> + * sw2p0 sw2p1 sw2p2 sw2p3 sw2p4
> + */

Ha, that's one idealistic view of reality, where sw1p4 is connected to
two switches at the same time...

I'm still working on this, I'm using it to review and improve the
notifiers that we have today. I just posted it to get some comments
regarding the best way in which we should present this development tool.
Should we add all notifiers from net/dsa/switch.c or should we leave
just this "test" one, and the developer is responsible for copy-pasting
the code they want to test into this C program?
