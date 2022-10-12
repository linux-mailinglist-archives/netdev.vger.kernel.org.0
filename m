Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742215FC687
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 15:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiJLNb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 09:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJLNby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 09:31:54 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD58C1D80;
        Wed, 12 Oct 2022 06:31:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id w18so11563876ejq.11;
        Wed, 12 Oct 2022 06:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=440OAvPp6jpvC+cHwk3GXF5FrYW0sETANLJf2TwXc6M=;
        b=SYJ3XYD0kST/ooAbwEU/DkumUXHC7/OTxKNj7X2LS+UK9QkVWLqCxeBYYk+tDTHfMY
         /WXn3mzroSuuxQaqeW/4bvyRL+J2+GHeYiuaKfknTFBhYq4+rH/jZ/KXV3/F7QGQA+Kb
         thMjyTUWkzCJDQ2/Z31rXugKrQ+gHEZSHDNfsxjiJRf9ILUGT6NRDdIqxenL02rcY8rx
         mCSShNedpHSJsIPKfj9HTAdCdSoAutb2vdZpUORQMf9duwMMI5fmFEd48hz4d4BB00cy
         n0qE6YGHXChhLQiNfmY897HUY6manN8dPeoJHSsy5CfQ3WKlm+N2hG7xkyPmXbZiB1Ky
         llnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=440OAvPp6jpvC+cHwk3GXF5FrYW0sETANLJf2TwXc6M=;
        b=o+aad9LQZc97z3g5qKIqFRdnTMm6P3JweTpmjXS+MQqtTYHa+xJ5bE2d9r2QnjCChX
         KvJlD0SPaff9nLOEF4XD9jHTgYGSw1UF0WZi1hsXKcBW95A2KdwDRnyoZasuuLoeMpX0
         pThVCFyqvYL35uSREt9YcVCftSF54u3yp+hHpmUSVPxrAO/qa3cgwnA3lE61LQL9NIAb
         6OzZuPC322pmwyohHYWIj86ksGjDWTpMP3GwYLGRMwVuj7hctbzW0mGQhkgCuFgXDqRM
         Jg4zr5gDvbc7Jn4YuyacDedj8ullZjfvCas3YRIOkltc54sWWxpV7KSN5/sBSCBMdzc6
         yNhQ==
X-Gm-Message-State: ACrzQf0MFPf4PI/l4w21d1r/ws+67Qwj/QpBij7PGcEPusRYXKTOXPn3
        xhjtnKjvRkONfyZ9A2tnHgo=
X-Google-Smtp-Source: AMsMyM4Z0q203MhmgEfKASMNY7Hp0BMajrk+VkG58OIljwpKDlMxVkfRJai/GkupltHMMFHnPBo1tw==
X-Received: by 2002:a17:907:948e:b0:783:91cf:c35a with SMTP id dm14-20020a170907948e00b0078391cfc35amr22604972ejc.366.1665581512285;
        Wed, 12 Oct 2022 06:31:52 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id l18-20020a1709063d3200b0071cef6c53aesm1325154ejf.0.2022.10.12.06.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 06:31:51 -0700 (PDT)
Date:   Wed, 12 Oct 2022 16:31:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Message-ID: <20221012133148.6apqbip3kvnjuafu@skbuf>
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
 <Y0a2KD9pVeoYkHkK@lunn.ch>
 <6346b921.a70a0220.64f4e.a0bc@mx.google.com>
 <6346ba28.050a0220.f0e18.949b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6346ba28.050a0220.f0e18.949b@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 02:59:17PM +0200, Christian Marangi wrote:
> > > Humm...
> > > 
> > > This might have the same alignment issue as the second patch. In fact,
> > > because the Ethernet header is 14 bytes in size, it is often
> > > deliberately out of alignment by 2 bytes, so that the IP header is
> > > aligned. You should probably be using get_unaligned_le32() when
> > > accessing members of mgmt_ethhdr.
> > > 
> > > 	  Andrew
> > 
> > Should I replace everything to get_unaligned_le32? Or this is only
> > needed for the mgmt_ethhdr as it's 12 bytes?
> > 
> > The skb data is all 32 bit contiguous stuff so it should be safe? Or
> > should we treat that also as unalligned just to make sure?
> > 
> > Same question for patch 2. the rest of the mib in skb data are all 32 or
> > 64 values contiguous so wonder if we just take extra care of the
> > mgmt_ethhdr. 
> > 
> 
> Also also... Should I use put_unalligned to fill the mgmt_ethhdr?

Documentation/core-api/unaligned-memory-access.rst section "Alignment vs. Networking"
says that the IP header is aligned to a 4 byte boundary.

Relative to the IP header, skb_mac_header(skb) is a pointer that's 14
bytes behind, right?

14 bytes behind something aligned to a 4 byte boundary is something
that's not aligned to a 4 byte boundary. That's why Andrew is suggesting
to use the unaligned helper for accesses (both put and get).

On-stack data structures don't need this, the compiler should take care
of aligning them and their fields appropriately. The trouble is with
pointers generated using manual arithmetics.
