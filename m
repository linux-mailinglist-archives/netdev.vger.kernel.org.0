Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148F42CB198
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 01:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgLBAe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 19:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbgLBAe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 19:34:27 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BB4C061A04
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 16:33:46 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id b2so239166edy.13
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 16:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vfu54yV2bF5QdJ4IAvcifv0suGW48W1qQyz5UP9gmS8=;
        b=MCmXLdW/psSeiVmopjgvPY6DLBjtBHAaOmioauzec4Ifaa+3KhP30URtxYtR5wRjjX
         pYrfzf8qDjRZUdX5HFz4pRqXY8/sPZ150tK86I3J4DPncXv6QLejUgpBWMmZlDkyqyju
         a6I6BpAoBGrOcxwEpqoViyAvRIgy2sXTZyvRDbD8N2CmuyRPJ6mdU4JVXnFh7GDLposg
         G1u4kl2+/9n2w89KgcyKjW2/hbfG8WvZGsnuDq3iK0IIGGV3x1COd6P0j5f4pfluomHQ
         B0bmqKUbDTyBdPsWBIwRqtfIhn5Xv4/XYglkqJwcvqlD2jyA+VuV0x8nla1s3O32jmDe
         arww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vfu54yV2bF5QdJ4IAvcifv0suGW48W1qQyz5UP9gmS8=;
        b=o+5V1swvpyPwWXUzMmLXJ6w0fvLGgJtV+RHoHRY3COELJSmf/eXA8tAp0f+i1zsnqS
         meoCAsfNSH6SLaOCAGYQWC5ZQTFSlBX1ep4l4gcbiEWWXtCcaNdvuoMJEuEacAPx+mDV
         Aqihb4NJSdS6mzJ6FAI9bn0EF8oBz7p0hKmZSUlFdbTPbhcG75/WEsax1kpJQTWN4JNJ
         9Sj20SOVkI6ltykk/hrU5Xd2+woCSScemitcDqnmH4LYl/zgLaau8Hm8jHkt59fDfIK9
         SO47D1FVAAOmKuqyOj0h5gAkyFqgYOX3rVm4+JsbB4abfq23LE6eKtIgBWvGZgZ3ZTpr
         RAmg==
X-Gm-Message-State: AOAM530hRV0H1igwc2qRlHR4IXFR+k+aP9nxyZf6l39KlAHdRJnrIGKJ
        n+OqsRP1P+wWVgQpqWTRWbU=
X-Google-Smtp-Source: ABdhPJwr/s9w9nKZuoDQV2CaarmWUAuq+nFkQLzZyTOOVbCzR4Wni4UKXN4xyxH8rtXp0BzIPoL2ug==
X-Received: by 2002:aa7:d514:: with SMTP id y20mr179176edq.384.1606869225383;
        Tue, 01 Dec 2020 16:33:45 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id lc18sm29045ejb.77.2020.12.01.16.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 16:33:44 -0800 (PST)
Date:   Wed, 2 Dec 2020 02:33:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: tag_dsa: Support reception of
 packets from LAG devices
Message-ID: <20201202003343.llgw7cm54g5xtpdz@skbuf>
References: <20201130140610.4018-1-tobias@waldekranz.com>
 <20201130140610.4018-5-tobias@waldekranz.com>
 <20201201212427.sewnqf7muxwisbcm@skbuf>
 <87sg8p6tw9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sg8p6tw9.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 11:31:02PM +0100, Tobias Waldekranz wrote:
> >> +	if (unlikely(!dsa_slave_dev_check(skb->dev))) {
> >> +		/* Packet is to be injected directly on an upper
> >> +		 * device, e.g. a team/bond, so skip all DSA-port
> >> +		 * specific actions.
> >> +		 */
> >> +		netif_rx(skb);
> >> +		return 0;
> >
> > netif_rx returns an int code, it seems odd to ignore it.
>
> This is exactly the same treatment that the return code from
> gro_cells_receive gets just a few lines down. They return the same set
> of codes (NET_RX_{SUCCESS,DROP}).
>
> Looking through the source base, there are a few callers that look at
> the return value (the overwhelming majority ignore it). Actions vary
> from printing warnings (without rate-limit, yikes), setting variables
> that are otherwise unused, or bumping a counter (the only reasonable
> thing I have seen).
>
> But looking through enqueue_to_backlog, it seems like there already is a
> counter for this that is accessible from /proc/net/softnet_data.

And also, more obviously, in ndo_get_stats64 (ip -s -s link).

Ok, I think you can ignore the return value.
