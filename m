Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D101F12B7C6
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfL0Rvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:51:31 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40931 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbfL0Rva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 12:51:30 -0500
Received: by mail-pl1-f195.google.com with SMTP id s21so9240075plr.7
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 09:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jZOPCY5LlG7am99M0UhbJQOO/tWX0tzEt9s1wi2Ebi0=;
        b=UwAKMkHNxCpvoWzZ/PtRHXMFN7rGyScPADZ0T8htIj9z77X2WClVF8l1ksv2wY8qHy
         nXp9BT9coNoKPw/jM4uTl5mSHVE2VjIpT1wpkyasqVklZpPWvFii+koJGB2BcLE10R7c
         w3o8Ths9mcN8PpYiw4RjvozZ41ubdPqeIQST71JxzlB+HE2ahvbcXfsUB2ATMEO3T26D
         iQRFLCXhbuZjozTqWfm3ehuQAd3KCDJ5l6vcrYFAcxC1w33EWyLdNhuzwBLzShbd4Krw
         IUPb0hTb+OPTVKPaKBGkujf0oFbQ8CKwiWICXlOtHzvYzqn3nhmXA7D+b0W0tT6K2+2t
         LoAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jZOPCY5LlG7am99M0UhbJQOO/tWX0tzEt9s1wi2Ebi0=;
        b=lGCx4okhYWdxPhYbuKwg92a6U1QJeChRzenYXHu+f8WLH4W/+aNE4NyPaP4sTPXRpH
         AdFL9234IX8NUQx7ifm8O6HIcRQyYJRtVpYPseyMN9NT8XmRLTXMm5phPtARDcAhGIup
         fS4UHn4HTiLD2UXJ22Pn+euE5j7lHH+IQs0dD+aUlD06KCjHi9J168D483qEoQEcwoJm
         YEXLsJtjwZLIqson2PRF7XLETNBjFkcA+6oJtkN4IWL6mz7yzyJAhrmHbCsrt3LTlVuE
         B81UvKKJf1tPADyAEj2jtHfgNujxc3tu+2gRF75c0DykPKKKaRE4Ie0rRO3h5KuX5+Vk
         Rh9A==
X-Gm-Message-State: APjAAAXf5IX5SNY9/aFawPtKdGxKFH/RjBjUGiuQ3+zsyolrd56PIAWx
        FRRuSp/11z2EZ8gGy04xg9k=
X-Google-Smtp-Source: APXvYqz4oAgGV1GvlKOgZxd6gQg09Sa279HHXQctWKM3GY4UBOz7DA3Qs1qVRJ4Od/reVLp4k4pgNw==
X-Received: by 2002:a17:90a:db48:: with SMTP id u8mr27177936pjx.54.1577469089359;
        Fri, 27 Dec 2019 09:51:29 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m3sm37672743pgp.32.2019.12.27.09.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 09:51:28 -0800 (PST)
Date:   Fri, 27 Dec 2019 09:51:26 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: Deny PTP on master if switch supports
 it
Message-ID: <20191227175126.GE1435@localhost>
References: <20191227004435.21692-1-olteanv@gmail.com>
 <20191227004435.21692-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227004435.21692-3-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 02:44:35AM +0200, Vladimir Oltean wrote:
> Why? Well, in short, the PTP API in place today is a bit rudimentary and
> relies on applications to retrieve the TX timestamps by polling the
> error queue and looking at the cmsg structure. But there is no timestamp
> identification of any sorts (except whether it's HW or SW), you don't
> know how many more timestamps are there to come, which one is this one,
> from whom it is, etc.

IOW, you can only get one HW time stamp from the stack.  This is a
fundamental limitation of the so_timestamping API.  If user space
really wanted multiple HW and SW time stamps, then some new way would
have to be invented, but it would be lots of work.

IMHO, as a practical matter, multiple time stamps would be interesting
from a profiling point of view, but less so for synchronization
applications.

> So it is a fact of life that PTP timestamping on the DSA master is
> incompatible with timestamping on the switch MAC. And if the switch
> supports PTP, taking the timestamps from the switch MAC is highly
> preferable anyway, due to the fact that those don't contain the queuing
> latencies of the switch. So just disallow PTP on the DSA master if there
> is any PTP-capable switch attached.

I agreed that MAC time stamps are not very useful when there is a PTP
switch in front.

Acked-by: Richard Cochran <richardcochran@gmail.com>
