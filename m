Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CC165BE63
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 11:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjACKrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 05:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbjACKrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 05:47:35 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F95E204
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 02:47:34 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id s5so43231226edc.12
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 02:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=21yLEaaakxWiWeQWh4n8tNscRMMgg959oH6cwCJj+eA=;
        b=CMAqr31tsUUtUKcTbEfZTIqkLikhq+stLNx9ZIQsAtx22lw2WkvGYdXOQIgo3xQ82L
         axX/Skao6j1fQsE3015MXwxdLpHFOZIU2Gta49Azl4I+PY5OcPcQDvy6MRpD91UCopxt
         s95TzUi4mW1dsAKcXLrsA+7tdx1wmsT0v7yuU5T1DTCuxKmLWDLhayxlI6QdCOMpfDpE
         ARzAujvzTNP70Wk5i+y7Oacag0iltJm7zrG0AbtxkOdebTez3MlI3uMD59g7pWu0yqjz
         cEKjMDgK8Jvj18b2tDJ6J2e7RO1C7VhZS03z0rUT23hNLZMIN4NcmntJ4PDgaaXtjG2m
         E2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21yLEaaakxWiWeQWh4n8tNscRMMgg959oH6cwCJj+eA=;
        b=HAtETaFjPtnbH3bKfuN5qaMCoXbAIPcoCo0dG7x/KbDoe71IzNgkXyzwe/tswI98rv
         Ntmd1/lagmDjSviNp9POyL2HgEsB2XQpfh7DASYuGprh4nP+fXHsjxt1wnxQoQiUJi0F
         n3aAAyFNsoQo5sMy0t4kpSJhvNw89z0L7vkOu+9HzNsZbr9yp3RtkU9r/3L0gZNfDldf
         1rE2ho72ib5zPxru8N+Pm4zlfSACtEoHYV/2o4TA6E6dsEe1qtGH73/QihzUNjdTQQp2
         7nZK470HwANmRNRE6umhyrjUTqVg9T/sWtjcv4BcZwIgBizEa2P1PSXhKCotNSnobbUZ
         8kwA==
X-Gm-Message-State: AFqh2kqmXMQbq39SMtNMXYT9w0UOY/+XxS2UICOaqaj4hpPReEiH/BQK
        41qsm7v7td3tkeRBayclVUDCCoO3eK8=
X-Google-Smtp-Source: AMrXdXtQCYSXblM1l4Y9wC9Tl4zcUFsjbilYOyUGuCNaoNE4tjY4N5D0JWOEFKoutLV3QANt5R6WLg==
X-Received: by 2002:a05:6402:5418:b0:474:a583:2e1a with SMTP id ev24-20020a056402541800b00474a5832e1amr36507958edb.12.1672742852449;
        Tue, 03 Jan 2023 02:47:32 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id x11-20020aa7cd8b000000b0048eba29c3a0sm861892edv.51.2023.01.03.02.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 02:47:32 -0800 (PST)
Date:   Tue, 3 Jan 2023 12:47:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: Crosschip bridge functionality
Message-ID: <20230103104729.2prje3skt42dkl44@skbuf>
References: <Y6YDi0dtiKVezD8/@euler>
 <Y6YKBzDJfs8LP0ny@lunn.ch>
 <Y6YVhWSTg4zgQ6is@euler>
 <20221224005934.xndganbvzl6v5nc3@skbuf>
 <Y6dKlkg6ZueQ1E61@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6dKlkg6ZueQ1E61@euler>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 24, 2022 at 10:53:10AM -0800, Colin Foster wrote:
> > That being said, you need to broaden your detection criteria for cross-chip
> > bridging; sja1105 (and tag_8021q in general) supports this too, except
> > it's a bit hidden from the ds->ops->crosschip_bridge_join() operation.
> > It all relies on the concept of cross-chip notifier chain from switch.c.
> > dsa_tag_8021q_bridge_join() will emit a DSA_NOTIFIER_TAG_8021Q_VLAN_ADD
> > event, which the other tag_8021q capable switches in the system will see
> > and react to.
> > 
> > Because felix and sja1105 each support a tagger based on tag_8021q for
> > different needs, there is an important difference in their implementations.
> > The comment in dsa_tag_8021q_bridge_join() - called by sja1105 but not
> > by felix - summarizes the essence of the difference.
> 
> Hmm... So the Marvell and sja1105 both support "Distributed" but in
> slightly different ways?

Yes, the SJA1105 and SJA1110 switches can also be instantiated multiple
times on the same board (under the same DSA master, forming a single tree),
and have some awareness of each other. The hardware awareness is limited
to PTP timestamping. Only leaf ports should take a MAC timestamp for a
PTP event message. Cascade ports must be configured to forward that
packet timestamp to the CPU and not generate a new one. Otherwise, the
forwarding plane is basically unaware of a multi-switch DSA tree.
The reasoning of the designers was that it doesn't even need to be,
since non-proprietary mechanisms such as VLANs can be used to restrict
the forwarding domain as desired. The cross-chip support in tag_8021q
follows that idea and programs some reserved VLANs to the ports that
need them.
