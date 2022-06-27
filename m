Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA1255DB6A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiF0Jki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 05:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbiF0Jkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 05:40:36 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7C8271C;
        Mon, 27 Jun 2022 02:40:34 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id sb34so17843001ejc.11;
        Mon, 27 Jun 2022 02:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4bs5ngsqqRx1f04+L+uYwafgG5i+bKqIK3lficiCvxw=;
        b=Y36f5ADCzumyujivYanEu6iCETNpoIGG1d1Tu/H2yNKHxADocDxsZLzfVenAsLzEDK
         byES0B1obpd5492FO7AnuduoDDe/yLnCIuCqnc8DWQRnJ4IywyLAtOKO+Xp18DaabXMy
         yA1vimFH2FrfYKu6O3sfsoNZQQQhM50Emjn++ismXmwQPkR4uegTSJ9LfQe9iVyQlSjx
         yO+oAq8g+0FHbmrr6Lp7OVh1/Vw9BiZSLhpL8I8NNJAcyJMsJahbS73uRm5LrUzJed4C
         FuZ6K1uMHVMZaz70kEZ56BWfvCtYVIH+RKWXdsrtFj/P+zxrhKwTXGOw8l/29I6d3mZQ
         hD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4bs5ngsqqRx1f04+L+uYwafgG5i+bKqIK3lficiCvxw=;
        b=U75G//HhMCrZIf2vAyhJGTVip5cPPnsWL/Jdp9vmmTLn4Xtw/bcr48zb9k2vvbCb6e
         kmaio+0mVMQ1WCeR5LVufqhWxWizTDJOS8fvW0VxN9u9rtWp6pDE2UjKi2s+acfn7HBT
         pEWk36UFfzWAwK6iEfjEby/Ydu7zReXxA7PNxD514P43HnkusCVFOMPsLq/TjcqEvpOI
         yqIcqYwD33tLFQdJJVIFCr1bRpa5hlKf2ONf5TmSW0/dIgYt/i6SCESHRcWrgCkLlvOt
         7gX7N6RAz6LQrZNbMxHCac1O1Swj6zxRJvtYdumOSGCMtL7xjVylvJKgh4p81xpqQLf2
         P3zQ==
X-Gm-Message-State: AJIora9G5uVcZ4IZ4wcemZ8UNqGdPlmHEA3jRFY6haIbzgYsJFXAq7Ih
        fJzAEh7na0bnEIxODyFJT3o=
X-Google-Smtp-Source: AGRyM1t5a7Eou055etsus47FVrwMiE9ka2jtp4iJ5wkJsRbnfGzhImC2+yniOdas5TTKgLTpEH9ocA==
X-Received: by 2002:a17:907:8694:b0:726:31dc:47dd with SMTP id qa20-20020a170907869400b0072631dc47ddmr11997246ejc.395.1656322833024;
        Mon, 27 Jun 2022 02:40:33 -0700 (PDT)
Received: from skbuf ([188.25.231.135])
        by smtp.gmail.com with ESMTPSA id f3-20020a170906138300b006fe9209a9edsm4778703ejc.128.2022.06.27.02.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 02:40:31 -0700 (PDT)
Date:   Mon, 27 Jun 2022 12:40:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next 5/8] net: lan966x: Add lag support for lan966x.
Message-ID: <20220627094029.el2m6k6w6ypgtwqg@skbuf>
References: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
 <20220626130451.1079933-6-horatiu.vultur@microchip.com>
 <20220626141139.kbwhpgmwzp7rpxgy@skbuf>
 <20220627064612.vzz2sd7kxpxnprxc@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627064612.vzz2sd7kxpxnprxc@soft-dev3-1.localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 08:46:12AM +0200, Horatiu Vultur wrote:
> > This incorrect logic seems to have been copied from ocelot from before
> > commit a14e6b69f393 ("net: mscc: ocelot: fix incorrect balancing with
> > down LAG ports").
> > 
> > The issue is that you calculate bond_mask with only_active_ports=true.
> > This means the for_each_set_bit() will not iterate through the inactive
> > LAG ports, and won't set the bond_mask as the PGID destination for those
> > ports.
> > 
> > That isn't what is desired; as explained in that commit, inactive LAG
> > ports should be removed via the aggregation PGIDs and not via the
> > destination PGIDs. Otherwise, an FDB entry targeted towards the
> > LAG (effectively towards the "primary" LAG port, whose logical port ID
> > gives the LAG ID) will not egress even the "secondary" LAG port if the
> > primary's link is down.
> 
> Thanks for looking at this.
> That is correct, ocelot was the source of inspiration. The issue that
> you described in the mentioned commit is fixed in the last patch of this
> series.
> I will have a look at your commit and will try to integrated it. Thanks.

I figured that would be the case, although I didn't really understand
the explanation from patch 8/8 (arguably, there it is said that the
switch tries to send on the down port, not that it won't send on the up
port, which is more relevant information). But in any case, it would be
good to introduce code that works from the beginning, rather than fix it
up in a follow-up patch. I believe that the commit I referenced is a
simplification either way, since it removes the "only_active_ports"
argument from the bond mask function.
