Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599282CDB28
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501864AbgLCQZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728634AbgLCQZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 11:25:11 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B925C061A4E
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 08:24:31 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id m19so4309857ejj.11
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 08:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UIM+uGeVxPsaS5fZw4ilFEEWbCIFczxDHzdgUQd5Vq8=;
        b=Ehmaeih6Sb0r7aY9duhf6CntXli4ZdbzphHnLYbIEBbUjn9BYUcwj8eqa+A3K96SDZ
         IsNQbbcrGFxH5pvE7JiixmTFhOjJ0z+z0zUAPXuTBz17I2IusW1CRzf/mAB95yymd430
         RLOZWGdG+5HZCdAHGi+6iBlVh547QlUm8/lydchvB/AQisqRlPjzE0Bs0SeiJG27mTl0
         hu/xLwrgdoPUYnt62b6lkXSIsGHYYjJJnLZ+y+esp0qiPQ9e4k07X+eiN2lmvTpKcIcy
         mDxuY1rBoiYdEIAGyjBtb1LGgCpMHJjc2WyZBoBnDWf6GZK6RXu2H8XASmsQOROsKeRh
         WU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UIM+uGeVxPsaS5fZw4ilFEEWbCIFczxDHzdgUQd5Vq8=;
        b=OnccUbxrsbqMSCrxlJJG09VVGqRfmNxF4SQs44uSZ+avJZX6vAmHgdlWaUky706gPd
         1KCC5yB+mY50qMhT0jg4gxLHLrOBwYN+9IQ3FUAq0KjrNrW6FUpL60mbJBMj1yHuemDP
         XZu3DncOIQXbU+zFkqEwJP6cypPHcncT5hfU7EqEJ5dxZDZVajiXRP8roVFiHF03cqWC
         5jNB0mHp4TNkmWEVnLsvsothIvbU5RdIxiYH8Wm7aU8vs06z9O4TC5O1vHyTZdeidUFQ
         Vl2Le9y2tjcoGaNq3c2AAUpfSJTZgC0DEyV/TFj4rgmm/3pBvzr3wlpn8nbp2G7JtFxi
         3z3Q==
X-Gm-Message-State: AOAM530eup4U1qmj4YZXzNua+ZtS77hKaYeFrtDVX4LETs9f2YbNsoIj
        jpcmWRr0kXu+OYRycTAQLw8=
X-Google-Smtp-Source: ABdhPJxgexy398mhfUBY3z1St3rbRXCoEtw1yQE2rn01YEtoymYL+sKuLOHTHOuWo74RpHWT+esD9g==
X-Received: by 2002:a17:906:3ad5:: with SMTP id z21mr3147927ejd.35.1607012670224;
        Thu, 03 Dec 2020 08:24:30 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id h23sm1134370ejg.37.2020.12.03.08.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 08:24:29 -0800 (PST)
Date:   Thu, 3 Dec 2020 18:24:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201203162428.ffdj7gdyudndphmn@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202091356.24075-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 10:13:54AM +0100, Tobias Waldekranz wrote:
> +static inline bool dsa_lag_offloading(struct dsa_switch_tree *dst)
> +{
> +	return dst->lags.num > 0;
> +}

You assume that the DSA switch, when it sets a non-zero number of LAGs,
can offload any type of LAG TX type, when in fact the switch might be
able to offload just NETDEV_LAG_TX_TYPE_HASH.

I like the fact that we revert to a software-based implementation for
features the hardware can't offload. So rejecting other TX types is out
of the question. However we still have to prevent hardware bridging.

Should we add an array of supported TX types that the switch port can
offload, and that should be checked by DSA in dsa_lag_offloading?
