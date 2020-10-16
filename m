Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9F5290596
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407894AbgJPMxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406441AbgJPMxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 08:53:04 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D01C061755;
        Fri, 16 Oct 2020 05:53:02 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a1so1463677pjd.1;
        Fri, 16 Oct 2020 05:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FUtQA0qUOVYE5VMj3cW7CapQKG9ojRqmAnqdA0LyCGo=;
        b=vCXhQdQ3ztQPt5becxg794HJUjDegq7SsbB8nMOJtcMdHGFVWDzVZ1P7DbouMNp34+
         /9riFPGA07BC2xndwiMfNsgtn6iivyjmOtb4vcanx0bCNmWwfS5oyttzERJ3r64L7HHK
         OOir14GM2lJMLvmLs4iwK6GOtC0ZYWim5C2rf6chEjeWPxDYll9yd9eOEWXeFqdb+p8b
         LF+P2Kh8TwirUNnL+i664tkjfkKfHl0pTZYmuzpGF1iXwJL5sfp9HX34oZ2mz9Nrbbot
         PMLXCMCXAiCAK/zIoZcWdboUL2WgJdEQaf7L8yoBrkUtFcrR57Z1ykTb6a9iTZmdJT4J
         phyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FUtQA0qUOVYE5VMj3cW7CapQKG9ojRqmAnqdA0LyCGo=;
        b=d9+X/Zani8hpdM5yDCOpoOaR8Iqr1DknFbZ9TOQDKDN+8x02eHbxnmoQywk2NwMqzA
         tdP+n6gGVSzLGA5BcF25KsLgy/e8AcgmHU5/kavCUByiP3YOXTE2PccmeIjNC59K6vHN
         8M0PXv1LHXh1NEXWmapq2oOAQz6WYB+s7HBLDJGCb0badBaYXUMLdpEw8ysq8uQI86kA
         kdovUCGZ2HuiZ5meTuABKNb/yBL+giaTUORqQaPGmhqstvOU9YBTTqNOnfOq5ile3Jbr
         zPPMdmX5XzdPOpPURU9Nc//mnFg+hmp4aHXgitsC5ZCiE++WtYB+hHMVNrvgpa22Hqr0
         mpZg==
X-Gm-Message-State: AOAM5323Jl66aNk4tnLvTEpPgHV/i4FO/XU7QEYJ6cng1x211hZz0Vc4
        vWlJxeEJeopba02YljExHI8=
X-Google-Smtp-Source: ABdhPJzY3RkwsN6x7PhOlOHBSwgLqFLWfkyjtm1ufhmdyNT3hSPhVUnNDEcbUZsj6CIatDIUAKRjHQ==
X-Received: by 2002:a17:902:a715:b029:d3:c2b4:bcee with SMTP id w21-20020a170902a715b02900d3c2b4bceemr4059331plq.22.1602852782314;
        Fri, 16 Oct 2020 05:53:02 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 190sm2904499pfc.151.2020.10.16.05.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 05:53:01 -0700 (PDT)
Date:   Fri, 16 Oct 2020 05:52:59 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ptp: get rid of IPV4_HLEN() and OFF_IHL
 macros
Message-ID: <20201016125259.GA19213@hoboy>
References: <20201014115805.23905-1-ceggers@arri.de>
 <20201015033648.GA24901@hoboy>
 <939828b0-846c-9e10-df31-afcb77b1150a@gmail.com>
 <2135183.8zsl8bQRyA@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2135183.8zsl8bQRyA@n95hx1g2>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 09:04:38AM +0200, Christian Eggers wrote:
> IPV4_HLEN() is only used for PTP. Is there any way to use "normal"
> infrastructure as in the rest of the network stack?

You answered your own question...

> It looks like PTP code
> typically has to look into multiple network layers (mac, network, transport)
> at places these layers may not be processed yet (at least in RX direction).

here!

(The pointers in the skb are moved around as the skb flows through the stack.)

The original, per-driver, un-refactored callers of that macro (at
least the ones written by me) used the macro carefully.  Also, I think
the recent re-factoring that Kurt implemented preserves the correct
usage of the macro.  Any new users must, of course, use it carefully
while parsing the bytes of a frame.

I agree that the macro is perhaps not the best possible solution, but
it is not the worst either.

Thanks,
Richard
