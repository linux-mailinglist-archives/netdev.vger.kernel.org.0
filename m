Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231254A9ED1
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377488AbiBDSRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237969AbiBDSRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:17:39 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F903C06173D
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:17:39 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso6841584pjt.3
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BfFZIQTRH2UUsr3td2AHbdYy6Sul28JyqcO6oZD6K/Y=;
        b=R8LlpGdQfsJpJ367KMkVW3O4NW2+lXtmKHm8fztzosq8QoOmY/h1A5bNXMAcrWd3IB
         /WWykBUYTThRQ0MlY+1xp0zxTMgNsKwCXi7UUYJRaJrXnc7gARUlm3GY9uNF21ciBXYz
         21URdcLsz0kGxhPEl2/qzOZgh+FPd0jB01YMZLjZh9gJ3AHl8T0ucFMkOWIlAvzVh+fT
         Y+Fg9Z2fjoYZOqu1m2MetZNS/ErTdb2XcvDjjzpz0mKHddvy3wzfO/Vs+9F7kIKloCeF
         efxYBtZMOmaZ91Wbcmyt7XGDV6GCE4ZZA2oXXDSA0agvXsUlf8CG+4oZz62L9saD2yZ9
         +9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BfFZIQTRH2UUsr3td2AHbdYy6Sul28JyqcO6oZD6K/Y=;
        b=lJ2Vk5vpj0tq3/akxgOWjoW/xe6CBpDX56Sp4mV5R6jGfzjmMGiGTrHNd2lj6AUugD
         9qwguMQ8n/BGOFfKBuO95ewjJSAMJ7Rs9dLnDKAptb69rqcgcr3pz6ul4C16tm4qDRE+
         klD/iTV8fGYafB5Cltk7GMXBr/yBBGOgJbMmwHMP4bmnllyHxgpMbHN+41bAuFM2/Vih
         n2aiSRmW9BNlAQy7s++Kcd/mPcSYdK5I6Lw85QRRVDzm23Qr5+6VOfFuHpZb8YPwRm+S
         /l3kyJ6v0nFji9UoMwwbFEU/A8pwd0VVaRrneEL9rdS1FjpAxhJS2RMW/UTwzoWHtRnz
         Lp8Q==
X-Gm-Message-State: AOAM531NZwHcbcR8d0N6qIJS2QuUkUO2PeSIvqbTaHIOxSu7UuV8mnyz
        61bt7WsqvKpUUcqVcU0LpXyR1Q==
X-Google-Smtp-Source: ABdhPJzkR7WtvFG7sjCXEhla5WRLWlR1KKgFyoXvDgI208wW4XYOiDs+2nlVVFcGgmRPEPvJEvSR7w==
X-Received: by 2002:a17:902:c215:: with SMTP id 21mr4306910pll.134.1643998658710;
        Fri, 04 Feb 2022 10:17:38 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id 8sm13328025pjs.39.2022.02.04.10.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:17:38 -0800 (PST)
Date:   Fri, 4 Feb 2022 10:17:34 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Geliang Tang <geliang.tang@suse.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH iproute2-next] mptcp: add the fullmesh flag setting
 support
Message-ID: <20220204101734.1a560400@hermes.local>
In-Reply-To: <49c0f49f6aabf0f55a16034b79d30fbceb1bc997.1643945076.git.geliang.tang@suse.com>
References: <49c0f49f6aabf0f55a16034b79d30fbceb1bc997.1643945076.git.geliang.tang@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Feb 2022 11:29:03 +0800
Geliang Tang <geliang.tang@suse.com> wrote:

> This patch added the fullmesh flag setting support, use it like this:
> 
>  ip mptcp endpoint change id 1 fullmesh
>  ip mptcp endpoint change id 1 nofullmesh
>  ip mptcp endpoint change id 1 backup fullmesh
>  ip mptcp endpoint change id 1 nobackup nofullmesh
> 
> Add the fullmesh flag check for the adding address, the fullmesh flag
> can't be used with the signal flag in that case.
> 
> Update the port keyword check for the setting flags, allow to use the
> port keyword with the non-signal flags. Don't allow to use the port
> keyword with the id number.
> 
> Update the usage of 'ip mptcp endpoint change', it can be used in two
> forms, using the address directly or the id number of the address:
> 
>  ip mptcp endpoint change id 1 fullmesh
>  ip mptcp endpoint change 10.0.2.1 fullmesh
>  ip mptcp endpoint change 10.0.2.1 port 10100 fullmesh
> 
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>

I don't see  any parts in here to show the flag settings?
