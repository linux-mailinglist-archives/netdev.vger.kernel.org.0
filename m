Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E56B5A8126
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiHaPZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiHaPZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:25:02 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F21C1277D
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:25:01 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s11so18829817edd.13
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=VqtbMFJE4CqO1zuwitVhlJCRoapgI0wUfKm1zo8dyeY=;
        b=Us0v51cqO0LxgThAO8cqOmOzLZUCMuFwr3rRp4yzuod2UL5E5CubAPwcGSsWdg/wlL
         BR0EdEn8kUO4WVzlJEfJp2DQkA7WBzBsVMds2pOrAvOLWb4PyfjwBIkFircOZ8VbCF/k
         QV++rMZ55rm19skg7MtgryonxGj/cPBwgzet9iD9qmtAvhJc/1q/rAXhKnE94UozPj4a
         CGV6OahNIrevaBS+KKx0Q+Sn8vbE/4gkBs+8wU4rmvLY2ZewXAXsXB5hs1i+iGbO/W/t
         WeesbGsrVDVJo2bVl9fyURIBYpGTW1ST0vng5su8hNy68Be3d2eA3ZnpMkjRD51so4Z+
         jqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=VqtbMFJE4CqO1zuwitVhlJCRoapgI0wUfKm1zo8dyeY=;
        b=mJxwgg4IMmntNMsUOSywpD8M2mk82N19i40EeO6/GxDKUFety+zvtUGfY+R6cJ8wwX
         fPQFyKy5idz35MqVyOYtxryEQGzqZtltk2NBDqJ9qOOdECQsZ3e7JUV4bKaqdQIB4dPH
         PahA7zMAzT1Y/PCP8i9faA44jd0QlQByrYobBQUEkR9qKYx1mJlrhdF6Vv/2sCOukNq5
         /LE/ncji6mvjsxz3JkoI1ZU9vs/rWGCe0J4AF/bFWJ5CnN0NpEY0evlaRCWDgCi+G8eB
         stX+LCJKNt5+EQgGp09s76zmwZMhLyrBsRsHIK4+URh1XQTjHgN7yWOBjadmlq1NDF1I
         p4qg==
X-Gm-Message-State: ACgBeo0EwwWiLQpGdn/QreRei4WBNaTCjtl5t5/DeQUm/eeD6k5LAqvZ
        JAAg6pmOF3NzWlQ8tzdHjhk=
X-Google-Smtp-Source: AA6agR7Zdp9ErInVRo7AxAG8+RF8RIRc7r5MqS0Ihh4BfvP2B13lDPihsjOpvKkgLeaOsjnjitC3GA==
X-Received: by 2002:a05:6402:3507:b0:448:b672:55ee with SMTP id b7-20020a056402350700b00448b67255eemr8160709edd.107.1661959499673;
        Wed, 31 Aug 2022 08:24:59 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id c25-20020aa7d619000000b00447b5c37768sm9121539edr.42.2022.08.31.08.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:24:58 -0700 (PDT)
Date:   Wed, 31 Aug 2022 18:24:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 2/3] dsa: mv88e6xxx: Add support for RMU in
 select switches
Message-ID: <20220831152456.4ph25o75etwd5ayy@skbuf>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-3-mattias.forsblad@gmail.com>
 <20220830163515.3d2lzzc55vmko325@skbuf>
 <12761041-1c44-9d56-b24b-b12af142a923@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12761041-1c44-9d56-b24b-b12af142a923@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 08:12:09AM +0200, Mattias Forsblad wrote:
> Please elaborate why this may pose a problem, I might have missed
> some information.

Because as I said, you need to enable it over the CPU port connected to
the master which goes up and is operational, and you don't have this
information at probe time.

> > If you decide to rework this using the master netdev, you can use
> > dsa_tag_protocol_overhead(master->dsa_ptr->tag_ops). Or even reserve
> > enough headroom for the larger header (EDSA) and be done with it.
> > But then you need to construct a different header depending on whether
> > DSA or EDSA is used.
> > 
> 
> So in the new version a la qca8k we need the 'extra' parameter to
> see if we need space for EDSA header, thus we need run through the tagger.
> We can discuss that in the next version.

"thus we need run through the tagger" -> is this a justification that
you're going to keep the tag_ops->inband_xmit?

You don't _have_ to, you already have access to the tagging protocol in
use via chip->tag_protocol, you can derive from that if you need the E
in EDSA or not, and still keep everything within the switch driver.

> > Could you please explain for me what will setting skb->pkt_type to
> > PACKET_OUTGOING achieve?
> >
> 
> I though it was prudent, will remove if it's not needed.

I honestly don't know what it does.
