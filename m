Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC1346D5F6
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhLHOqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbhLHOq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:46:29 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A857C061746;
        Wed,  8 Dec 2021 06:42:57 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y13so8987131edd.13;
        Wed, 08 Dec 2021 06:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=52QE56s4fsZrosTAFipj2Y1uY3A08fcUY1wjgKokxbw=;
        b=YvJmD0dlJtAnKpHk1Bkoo7I2csLtwhYEeLHcv39OxAym4U1chhsXNMqmqJEUIIbz8c
         JOT/22Jl6X/CZ0i25qWVFgJpsYNOVcgP148FSLX9psK7iZkHW5oYj9UPBXzQ7Q/42Gui
         ubSBOnIyegYiQUpBoiI3bBGWEBFEerC1zHCCYvILv4Ykz4AZhtDpXSE0J8N/07YGC9O+
         A8aEA6BuL2fXlH0oQPL7WXBDoHkLyDsJyJ7gjYNCOIuqZLgFRaUNW4lrTSD1M+N7GsIx
         symUUrnE42wOGTHmHFFrTwWPyT2zJhxjqpokKdRQinzh7DgcNyq+Of66XWTa+X4jeQ+I
         +7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=52QE56s4fsZrosTAFipj2Y1uY3A08fcUY1wjgKokxbw=;
        b=bWwEt0YYKaG0dM8w8J11KooX1xPW81JOKp6kuFpFp3NX+D/E4EQbGOdwYbOjgRMrY6
         E/GfecSbgo9pRZrk8d3AzJImdG2YCd3M3DQNlI77F7KRrkveC5iGYR4tTvaDwApWkm7b
         LQfSYeZGJCUgIjGGGI3TNC+2F0oQxo6GX0tj8UGyszuyq7UfGNx0x/NldX028YFxWxpD
         wANWBGRe5exgmAVEYD4XPLkY+og1I6booJYyaxqEU6Vey4K8+dKWwKQnwVbTtvUOolYy
         +si8jwwfiI/saiHNozRos3Lc0xNvfDctWFQjtmPYkK9ZWxqjXT2Z70Khz376YAgUTuJS
         ilDw==
X-Gm-Message-State: AOAM532nZdKLnAbutUc36+lo1OFSVpBqS38Cpj02uMq0yZBWaeNsobuJ
        XtDy5uVVpKP9fmxf2YYtpG0=
X-Google-Smtp-Source: ABdhPJwEuuCIuc0HRRKNwOY/xQ1YGn1SQ10/EHvHdRbDnqD5w9GfmMA+pAg1uy54qEs0+/fF/hPcmQ==
X-Received: by 2002:a05:6402:5158:: with SMTP id n24mr19812370edd.230.1638974575926;
        Wed, 08 Dec 2021 06:42:55 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id i8sm2540725edc.12.2021.12.08.06.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 06:42:55 -0800 (PST)
Date:   Wed, 8 Dec 2021 16:42:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH v2 7/8] net: dsa: qca8k: Add support for
 mdio read/write in Ethernet packet
Message-ID: <20211208144254.sisj4sglcpzmkwz5@skbuf>
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
 <20211208034040.14457-8-ansuelsmth@gmail.com>
 <20211208121850.b2khmvkqpygctaad@skbuf>
 <61b0bf59.1c69fb81.9d656.8423@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61b0bf59.1c69fb81.9d656.8423@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 03:21:11PM +0100, Ansuel Smith wrote:
> > None of these structures need to stay in the data structure shared with
> > the tagger. They can be in qca8k_priv. The tagger should only see the
> > function pointers. It doesn't care what is done with the packets.
> > 
> > >  };
> 
> Ok so the handler should access these data by reaching the qca8k_priv
> from the dsa port. Correct?

Yes, this is exactly what I think, the tagger should be stateless with
regard to the completion, if it can be stateless. Only with stuff
related to the tagging protocol itself it can be stateful, things like
sequence numbers if you need them, etc. But the MDIO access is payload
as far as the tagger is concerned.
