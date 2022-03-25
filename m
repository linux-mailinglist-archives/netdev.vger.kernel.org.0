Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DE44E744F
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 14:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356546AbiCYNjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 09:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354863AbiCYNjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 09:39:00 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BFDD763C
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 06:37:26 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id c62so9275465edf.5
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 06:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=73X5wIoX0yWpNKQHWG1sKmWJf/c52D6oy3rgkPG30Eo=;
        b=GZzsT1pyPgBu4kvQ3iwy/CEkkVAuFc6GBIDjJsd2gFhCt0LSHhWU3Hv16xsQIBdi7L
         54N/Ujx5HbP0UsmLSdk9oRbvr5tI0hns1AUuCzjH55Bi6Dr192GkwBVgb/pgGK8TcLmt
         EFs04zfYrklctMpvHEYS1IZUMo0dZ7OOdKHLyCxRNquCYlWNSxc732c3jSusWzynvm2y
         rro4M6g4RXFKMQQT4WsGhPJcLU5a0C0Y0xYfKg0EQOaLwyQAt1upDM68w5JST7mwT5c7
         bCv14SPMUI+vHobK2Gn4NP5QYyGt1/gvN+D2pKsjbh7/PC2Fc7YIaeJDk4bwJQeOjMyO
         cyxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=73X5wIoX0yWpNKQHWG1sKmWJf/c52D6oy3rgkPG30Eo=;
        b=ECLMqiUIsRHv2UBsfjE34M1vdwBoapZCF+C/6BwWAF4u6lDAsr9OCv4ORNF1F0KlGg
         zwEvke8cG4QwzrhVKfBnzwUIwPQSpdpSuaTjmCVqxZrtiIWMbBaUhZb38Yjg8ZUJFlVJ
         u6/nssHPoG2zgXST/phy+8Uk+P9OvW6BfvFIkCmK/VIszo5antbPSeMrm2qwcTOHM46W
         wZw+WPVtFY5tPgdNsQ4qPkgVKWezdmmAHFlNHow2Lg4IPSThsQwn9MjTVDWuH8Yz1a0w
         9G08so4PpxZqQ53G25/Jqp56uyjdGAToN5BN7KZaURNp989eT+RB0RRxkYiDuRM6VVvv
         ICPg==
X-Gm-Message-State: AOAM530dqY+Nt2sPLs39ezkPjG5NMIypd/ME10bmU61xH6VN4xQ+564M
        bchE9yvHUhiztL5peGq6scK5DYoOwZU=
X-Google-Smtp-Source: ABdhPJycm7XnP7UxuBLJ1QcUygEDCMhoDy4VO2rG7FvUEqcYnL1bkmhQ1DWVuiOStq1QkZi/ovAigg==
X-Received: by 2002:aa7:c759:0:b0:419:896:271b with SMTP id c25-20020aa7c759000000b004190896271bmr13053045eds.98.1648215444738;
        Fri, 25 Mar 2022 06:37:24 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id ks20-20020a170906f85400b006e091a0cf8bsm1396402ejb.16.2022.03.25.06.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 06:37:24 -0700 (PDT)
Date:   Fri, 25 Mar 2022 15:37:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Broken SOF_TIMESTAMPING_OPT_ID in linux-4.19.y and earlier
 stable branches
Message-ID: <20220325133722.sicgl3kr5ectveix@skbuf>
References: <20220324213954.3ln7kvl5utadnux6@skbuf>
 <CA+FuTSe9hXG1x0-8e1P8_JmckOFaCFujZbJ=-=WTJW3y1sJQNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSe9hXG1x0-8e1P8_JmckOFaCFujZbJ=-=WTJW3y1sJQNQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

Thanks for the reply.

On Fri, Mar 25, 2022 at 09:15:30AM -0400, Willem de Bruijn wrote:
> On Thu, Mar 24, 2022 at 5:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Hello Willem,
> >
> > I have an application which makes use of SOF_TIMESTAMPING_OPT_ID, and I
> > received reports from multiple users that all timestamps are delivered
> > with a tskey of 0 for all stable kernel branches earlier than, and
> > including, 4.19.
> >
> > I bisected this issue down to:
> >
> > | commit 8f932f762e7928d250e21006b00ff9b7718b0a64 (HEAD)
> > | Author: Willem de Bruijn <willemb@google.com>
> > | Date:   Mon Dec 17 12:24:00 2018 -0500
> > |
> > |     net: add missing SOF_TIMESTAMPING_OPT_ID support
> > |
> > |     SOF_TIMESTAMPING_OPT_ID is supported on TCP, UDP and RAW sockets.
> > |     But it was missing on RAW with IPPROTO_IP, PF_PACKET and CAN.
> > |
> > |     Add skb_setup_tx_timestamp that configures both tx_flags and tskey
> > |     for these paths that do not need corking or use bytestream keys.
> > |
> > |     Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
> > |     Signed-off-by: Willem de Bruijn <willemb@google.com>
> > |     Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> > |     Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > and, interestingly, I found this discussion on the topic:
> > https://www.spinics.net/lists/netdev/msg540752.html
> > (copied here in case the link rots in the future)
> >
> > | > Series applied.
> > | >
> > | > What is your opinion about -stable for this?
> > |
> > | Thanks David. Since these are just missing features that no one has
> > | reported as actually having been missing a whole lot, I don't think
> > | that they are worth the effort or risk.
> >
> > So I have 2 questions:
> >
> > Is there a way for user space to validate functional kernel support for
> > SOF_TIMESTAMPING_OPT_ID? What I'm noticing is that (at least with
> > AF_PACKET sockets) the "level == SOL_PACKET && type == PACKET_TX_TIMESTAMP"
> > cmsg is _not_ missing, but instead contains a valid sock_err->ee_data
> > (tskey) of 0.
> 
> The commit only fixes missing OPT_ID support for PF_PACKET and various SOCK_RAW.
> 
> The cmsg structure returned for timestamps is the same regardless of
> whether the option is set configured. It just uses an otherwise constant field.
> 
> On these kernels the feature is supported, and should work on TCP and UDP.
> So a feature check would give the wrong answer.

Ok, I read this as "user space can't detect whether OPT_ID works on PF_PACKET sockets",
except by retroactively looking at the tskeys, and if they're all zero, say
"hmm, something's not right". Pretty complicated.

So we probably need to fix the stable kernels. For the particular case
of my application, I have just about zero control of what kernel the
users are running, so the more stable branches we could cover, the better.

> > If it's not possible, could you please consider sending these fixes as
> > patches to linux-stable?
> 
> The first of the two fixes
> 
>     fbfb2321e9509 ("ipv6: add missing tx timestamping on IPPROTO_RAW")
> 
> is in 4.19.y as of 4.19.99
> 
> The follow-on fix that you want
> 
>     8f932f762e79 ("net: add missing SOF_TIMESTAMPING_OPT_ID support")
> 
> applies cleanly to 4.19.236.
> 
> I think it's fine to cherry-pick. Not sure how to go about that.

Do you have any particular concerns about sending this patch to the
linux-stable branches for 4.19, 4.14 and 4.9? From https://www.kernel.org/
I see those are the only stable branches left.
