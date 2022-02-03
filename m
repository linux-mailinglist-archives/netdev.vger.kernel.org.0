Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4BE4A83FD
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350584AbiBCMnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239402AbiBCMng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 07:43:36 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86119C061714;
        Thu,  3 Feb 2022 04:43:36 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id ee12so4876075edb.8;
        Thu, 03 Feb 2022 04:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZuZJs1zE4Ez+MlZnQ2Y+AadC4VemLnPQssUlFlxFwbg=;
        b=iwUjmhqq7amn1v0Sm+25uR5TqQkzCUI5nMeS4wLYa9Uzc9wfvhJK5U/VoMVE6T5lPS
         dB5fXMXFk/MtRI1WzGo0ufxrQZHPhS+buHt73WpWEMEEtASTqc2bz/qNRHM295B7oOYE
         OSwtDk8t1NujNFP2o7Vz+ae93A2yBu19gSP7gpp+cT3cOCQuPBlIuJmpPZtw4vaxLZCF
         HmJ+EdAcwzfDBlkUUUL4+4jDyUZsVqzdT3a2MMs59y/aIpf7w+Exa9pRfpk/hiRzFcmc
         GFg4gRZvlWv5yH5Xpu80gUO4Z441oI4bJDFxCfS+r25FqqxNqqrOmDX0wFGqLX7CRlHj
         AC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZuZJs1zE4Ez+MlZnQ2Y+AadC4VemLnPQssUlFlxFwbg=;
        b=MHOcgxnwNljTuLdrWDnZPwNJOtXIyo31ZRNu5dVqhvOo87kEwr352t8yPHkDeaZjTc
         3qAUNoX/nZv/2Nm2YYXY/t9sdQ3S2Dvd7I90VUESmFHE8iLuFsm4fUpqeYcjMSLzRl+Y
         w5+VsdZkbwES8Y7sdwpZ0Vp8zyi41Dzp3R+POG7PrL23VleMSnTC/CSewyFDFw6FciYS
         0TtMh1Uoxo+x7thFEEZmyN6uIVCvQ2Il5AsmjG8NR0uGl/b/lzaMqJlfbTq+QQbRIMff
         jUvKmqZGFDRke95RTJX+WqsE4ORaRwc2D7xLVHq1fB8yYiNR9P5pWMQ4wYJ1/drflotx
         RVJg==
X-Gm-Message-State: AOAM5330y/lu9QB7XXz6NbuIXnUXoylGhdwR0MJxzCBfKCPQrVejHFYf
        4wSn9IgKyvkZRS8XGhUfjcQ=
X-Google-Smtp-Source: ABdhPJwqoD35XdUbI76J8z80Y8ON2EuU7WdpiDU91FQN+gwRNjAd04t6TzyD+o2G0yUOFCfkqb+ZoQ==
X-Received: by 2002:a05:6402:143:: with SMTP id s3mr34782426edu.7.1643892214975;
        Thu, 03 Feb 2022 04:43:34 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id gv34sm16774820ejc.125.2022.02.03.04.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 04:43:34 -0800 (PST)
Date:   Thu, 3 Feb 2022 14:43:32 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/5] net: dsa: mv88e6xxx: Improve isolation
 of standalone ports
Message-ID: <20220203124332.g6fydb4zh6wlvbbu@skbuf>
References: <20220203101657.990241-1-tobias@waldekranz.com>
 <20220203101657.990241-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203101657.990241-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 11:16:53AM +0100, Tobias Waldekranz wrote:
> Clear MapDA on standalone ports to bypass any ATU lookup that might
> point the packet in the wrong direction. This means that all packets
> are flooded using the PVT config. So make sure that standalone ports
> are only allowed to communicate with the local upstream port.
> 
> Here is a scenario in which this is needed:
> 
>    CPU
>     |     .----.
> .---0---. | .--0--.
> |  sw0  | | | sw1 |
> '-1-2-3-' | '-1-2-'
>       '---'
> 
> - sw0p1 and sw1p1 are bridged
> - sw0p2 and sw1p2 are in standalone mode
> - Learning must be enabled on sw0p3 in order for hardware forwarding
>   to work properly between bridged ports
> 
> 1. A packet with SA :aa comes in on sw1p2
>    1a. Egresses sw1p0
>    1b. Ingresses sw0p3, ATU adds an entry for :aa towards port 3
>    1c. Egresses sw0p0
> 
> 2. A packet with DA :aa comes in on sw0p2
>    2a. If an ATU lookup is done at this point, the packet will be
>        incorrectly forwarded towards sw0p3. With this change in place,
>        the ATU is bypassed and the packet is forwarded in accordance
>        with the PVT, which only contains the CPU port.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
