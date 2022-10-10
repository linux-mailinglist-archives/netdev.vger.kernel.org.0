Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64C5FA3F4
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 21:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJJTIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 15:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJJTIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 15:08:25 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC005AC74;
        Mon, 10 Oct 2022 12:08:24 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id u21so17146419edi.9;
        Mon, 10 Oct 2022 12:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZWQI6EaAdyld4xWyI/4YqlkKhYX2A2+TTbGbUbetgY=;
        b=bs8dQiS0WqpLHv+OnV7+mwwcm+a+DGPPnskG8ISDlRKzqXg/gzx9ebBk0KHNJTaRv0
         FNxyMmejLeZ4/iEZoAqA59guqJi5322dn2J+yVtu2dVfwPjtZ45TuUKGLjAmKpue5gru
         xPjQUNlYwc9k7Hk6t5JSMbHZQFLdnwhSDDMvSfkISmtuo6N763tELMzhXAQhraSllQfR
         lzD/K6VYszSF83BWLvaxNt06NSKoFgftAca39Zs+qv50ud25Q1vY/g03nD1BxgftW9EC
         vjSSMn3YJa8qL7N9ZN3urhtzekDIhLp2i+jSGkdwQE0TtYrkHCjKtXoCcfwFA+UkixRn
         j7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ZWQI6EaAdyld4xWyI/4YqlkKhYX2A2+TTbGbUbetgY=;
        b=AW6XLSWvRuO0jMCJKGlV0ofBAccngPNdo8bKota6MHlCxP7IzlBOOu+YCjGN9LnHQY
         KrJ2praCuw1kyEevCup+tO+lEqLWSU7FUOLagPddYlSSYNQJbW+NTMVEffNIhxqe7PFd
         Nkqv0OiCUgHobmUIDF/68Ml5dAaBNUY+/kS+Trb/zBF479j9mkMggEzOqAO+0tmla2j0
         Pm4vowAce6W0X7dixb+RCG9gAY+K1Os+ZdBvry5Pnirz6wa8EvihqtiGNJqgvNFy7+a2
         TerqTo2dzga/Tuj6jBb5ayMDgH+3CMzM82/9gLQdaQE8cCrrolPZ0hxdi28nCs5Ec9yM
         4n5g==
X-Gm-Message-State: ACrzQf3UNHZp5SWTuQgQt9YSHaaygopOxbPPpdfS7k988mp53jtzjAUc
        x5a8LreO/jU6ffWiFlHyQlY=
X-Google-Smtp-Source: AMsMyM7QTV2piy1lJlSMEFJV3mTssB40YHw8zbM4UKY9gTn2KK8AiewB9/TEvg4rxyiC7XD+0tMUpg==
X-Received: by 2002:a05:6402:520d:b0:45a:31cb:f5bd with SMTP id s13-20020a056402520d00b0045a31cbf5bdmr16366411edd.119.1665428902229;
        Mon, 10 Oct 2022 12:08:22 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id p9-20020a05640243c900b004573052bf5esm7580959edc.49.2022.10.10.12.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 12:08:21 -0700 (PDT)
Message-ID: <63446da5.050a0220.92e81.d3fb@mx.google.com>
X-Google-Original-Message-ID: <Y0QTvo45WKoO5KKE@Ansuel-xps.>
Date:   Mon, 10 Oct 2022 14:44:46 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix inband mgmt for big-endian
 systems
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
 <Y0RqDd/P3XkrSzc3@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0RqDd/P3XkrSzc3@lunn.ch>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 08:53:01PM +0200, Andrew Lunn wrote:
> >  /* Special struct emulating a Ethernet header */
> >  struct qca_mgmt_ethhdr {
> > -	u32 command;		/* command bit 31:0 */
> > -	u32 seq;		/* seq 63:32 */
> > -	u32 mdio_data;		/* first 4byte mdio */
> > +	__le32 command;		/* command bit 31:0 */
> > +	__le32 seq;		/* seq 63:32 */
> > +	__le32 mdio_data;		/* first 4byte mdio */
> >  	__be16 hdr;		/* qca hdr */
> >  } __packed;
> 
> It looks odd that hdr is BE while the rest are LE. Did you check this?
> 
>    Andrew

Yes we did many test to analyze this and I just checked with some
tcpdump that the hdr is BE everytime. If you want I can provide you some
tcpdump from 2 different systems.

Anyway it looks like this family switch treats the hdr in a standard way
with the network byte order and for anything else stick to LE.

Also as a side note the tagger worked correctly before the mgmt feature
on BE systems and also works correctly now... just any command is slow
as the mgmt system has to timeout and fallback to legacy mdio.

-- 
	Ansuel
