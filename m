Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE2D291411
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 21:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439382AbgJQTMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 15:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437998AbgJQTMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 15:12:55 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F98C061755;
        Sat, 17 Oct 2020 12:12:53 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t21so6111973eds.6;
        Sat, 17 Oct 2020 12:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JIfVjsDKn4SaATVNn//P1puG7p7aBs4tQ9Vt/McDwTQ=;
        b=MeHJDRcXkRRYn2oKVNujZ0bE3bLyfkPd0lbdYLiaIGSj0jDnKdizyZyU+O6GVAi5O/
         kL7qC/xR1RFSdYdDkHFjTXm5B5z7jRUhcF5UPEBMwvCJUOCzzvT0qPx9iEGJGJa3w/KO
         3/Q7nMJn6csxzcKPuYCEjAHBpXjed59cMU5N23ITLOjL6aOOMPZ0GBQJcL4qBUbg+0Lg
         ZjcHKfdfI/6MLPUhye/HX59xvas1hVClyIRHsQSjnmDS0pMmgCPZQ7+rJfGBatkGjwUK
         RDWBCk3fXOOu9Rs/+fIoWRiUnKIw2BxR8PbTPvSfFHMpqmfrJxeC4w8ZCQMVXedtjLAa
         CTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JIfVjsDKn4SaATVNn//P1puG7p7aBs4tQ9Vt/McDwTQ=;
        b=CARZ41B78JkpczARuSGaZ4qwXILMfeib0cxTczq7e16vQ/1mF6j+HfU0IlKvG0NNtM
         41CCY44a0AdTBQHcw6+B6sNcjcILnPt9v9L0x612ZT+1kALayvvGFEQNmdwDrddekGVK
         b2U9HPbQs+CCv3FLjs9iq9XO4GDApaDgec4NoifEfUFZlUekVhS3US1MU+GaLWgL6/XY
         p8IVC4+iakEl6aoufZBcNLdSQYwfQbZJObVHlvaWPWi03VYQeToi1yhy+VcuQW6iJ9g/
         RAQTu74cdoc3JrTmupMQZLhqlWFrXfK1Ki6pycjJ/Oztg1mrgDlnUAYe0mR7NmpbLD5n
         8fvw==
X-Gm-Message-State: AOAM532jJkLsjGMF/eGzjB30k2HWuOAKKvEnEPtNlJgYcsd48F4UP3cj
        s9u5WuF8IzcvYPW3lRfW8W0=
X-Google-Smtp-Source: ABdhPJyqjdZATDf+JPQ2D8XUseLmg53+oz1AtIR+gC56PALUZRxC8lo9ad01A3eMsQ8q+Wxn1xvrsQ==
X-Received: by 2002:aa7:d394:: with SMTP id x20mr10500532edq.14.1602961969464;
        Sat, 17 Oct 2020 12:12:49 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id v21sm5704579edt.80.2020.10.17.12.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 12:12:48 -0700 (PDT)
Date:   Sat, 17 Oct 2020 22:12:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: dsa: don't pass cloned skb's to
 drivers xmit function
Message-ID: <20201017191247.ohslc77wkhbhffym@skbuf>
References: <20201016200226.23994-1-ceggers@arri.de>
 <20201016200226.23994-2-ceggers@arri.de>
 <20201017004816.q4l6cypw4fd4vu5f@skbuf>
 <2130539.dlFve3NVyK@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2130539.dlFve3NVyK@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 08:53:19PM +0200, Christian Eggers wrote:
> > Does 1588 work for you using this change, or you haven't finished
> > implementing it yet? If you haven't, I would suggest finishing that
> > part first.
> Yes it does. Just after finishing this topic, I would to sent the patches for
> PTP. Maybe I'll do it in parallel, anything but the combination of L2/E2E/SLOB
> seems to work.

2 aspects:
- net-next is closed for this week and the next one, due to the merge
  window. You'll have to wait until it reopens.
- Actually I was asking you this because sja1105 PTP no longer works
  after this change, due to the change of txflags.

> I don't like to touch the non-tail taggers, this is too much out of the scope
> of my current work.

Do you want me to try and send a version using pskb_expand_head and you
can test if it works for your tail-tagging switch?

> > Also, if the result is going to be longer than ~20 lines of code, I
> > strongly suggest moving the reallocation to a separate function so you
> > don't clutter dsa_slave_xmit.
> As Florian requested I'll likely put the code into a separate function in
> slave.c and call it from the individual tail-taggers in order not to put
> extra conditionals in dsa_slave_xmit.

I think it would be best to use the unlikely(tail_tag) approach though.
The reallocation function should still be in the common code path. Even
for a non-1588 switch, there are other code paths that clone packets on
TX. For example, the bridge does that, when flooding packets. Currently,
DSA ensures that the header area is writable by calling skb_cow_head, as
far as I can see. But the point is, maybe we can do TX reallocation
centrally.
