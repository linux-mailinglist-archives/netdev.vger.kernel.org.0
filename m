Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CE653592E
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 08:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244860AbiE0GOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 02:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244785AbiE0GOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 02:14:08 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE0B5DE70
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 23:14:07 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z15so4532892wrg.11
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 23:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zv9Yor57SCXr4Teonzd2nsW+ipnEzx2c6o77fSo9blY=;
        b=iKRL3jF1Xn4pefekjYe4Q2+Q5cwBJvd3g36hK5+h1EiRblHf8Cwqbzfy1y85zQUXVO
         sO9b88m47HOOoqUQxqloP+aq4SW7dSfPNpTl+MJVHPhC+InftY65Ikhqr+NMwDS3MvK0
         y5+rgNJ8Veru5Q/AtmQt+h9iFvTgo5Au9iUaL2D6Msl7OGRsoMEQT24pbD45M/ucVngD
         AmNXHnoyjN/fhKBP2xbkPBC+i37VBmrLmScuCJFhyezUiwGapGhG3zEv74o5qPwtDtRM
         HTZu+++bCv55QG8C53BxVo5UL43b6zBbsQgLE/Ll5BciY4I3bqF8te+773Xd7uoFM5dq
         mXHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=zv9Yor57SCXr4Teonzd2nsW+ipnEzx2c6o77fSo9blY=;
        b=SgX1rZRtVZ5EStoyGV1LVVhnOrSB2PqtrRhwkqZdN0gPZ6LomAEdbppI8TR8gjIjck
         aqujKDEBMRXBIdHTntPJq+aPgHGh5J0ZNYwPviU6DfLfVeo1a+9rjIEd0/bwJJOB9qbQ
         gXTeBow/OVKs0E+gbIJd7q01FG9LxX86WXcurvkSih3Q8s6qEtHp60MBuBbw2izeryEk
         6fq1IoMQ/UqPIa2hpW8ehAHppeRpgmyzYvL/UahPdlAkN6uI/StWCNhtzPs5PARcVyUa
         gnHbm05nsM9NscRUzNqMl/YrelHScvcIAXRBBqQBJts67VPRKM9fwlFpVMTjIEOdzSjq
         bLnw==
X-Gm-Message-State: AOAM531CjGSej1H2pzZnKG+7r+wpht963rzfun15i9M6j48rbsOxDPmX
        PghbAlaCYykMdqW4obhkNHc=
X-Google-Smtp-Source: ABdhPJyHF6WeBhCTQQxJIwS6FrxlSBv0r72nu4PiA9Tu4U6zvwnOQhZ++CXveMhLXnWHUPdGMXmPOA==
X-Received: by 2002:a5d:6041:0:b0:20d:8e4:7bb8 with SMTP id j1-20020a5d6041000000b0020d08e47bb8mr33203742wrt.652.1653632046180;
        Thu, 26 May 2022 23:14:06 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id 129-20020a1c0287000000b0039748be12dbsm1123252wmc.47.2022.05.26.23.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 23:14:05 -0700 (PDT)
Date:   Fri, 27 May 2022 07:14:03 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     Tianhao Zhao <tizhao@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>, amaftei@solarflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] sfc: do not initialize non existing queues with
 efx_separate_tx_channels
Message-ID: <YpBsKz3BD5ABcRxn@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>, amaftei@solarflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org
References: <20220511125941.55812-1-ihuguet@redhat.com>
 <20220511125941.55812-3-ihuguet@redhat.com>
 <20220513110723.dorpu2wgrutcske2@gmail.com>
 <20220513123716.nuizgafnuanyj2na@gmail.com>
 <CACT4ouf7P=jq8RM+3WOCVKhNi6mBAunuw65zgTHmHmzw8v-fqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4ouf7P=jq8RM+3WOCVKhNi6mBAunuw65zgTHmHmzw8v-fqg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 05:36:49PM +0200, Íñigo Huguet wrote:
> On Fri, May 13, 2022 at 2:37 PM Martin Habets <habetsm.xilinx@gmail.com> wrote:
> >
> > On Fri, May 13, 2022 at 12:07:23PM +0100, Martin Habets wrote:
> > > On Wed, May 11, 2022 at 02:59:41PM +0200, Íñigo Huguet wrote:
> > > > If efx_separate_tx_channels is used, some error messages and backtraces
> > > > are shown in the logs (see below). This is because during channels
> > > > start, all queues in the channels are init asumming that they exist, but
> > > > they might not if efx_separate_tx_channels is used: some channels only
> > > > have RX queues and others only have TX queues.
> > >
> > > Thanks for reporting this. At first glance I suspect there may be more callers
> > > of efx_for_each_channel_tx_queue() which is why it is not yet working for you
> > > even with this fix.
> > > Probably we need to fix those macros themselves.
> > >
> > > I'm having a closer look, but it will take some time.
> >
> > It was easier than I thought. With the patch below I do not get any errors,
> > and ping works. I did not have to touch efx_for_each_channel_rx_queue().
> > Can you give this a try and report if it works for you?
> 
> Martin, this is working fine for me. Module loads and unloads without
> errors, and I can ping and run an iperf3 test also without errors.
> 
> How do you want to do it? Should I send this patch on your behalf
> within my patch series? Or do you want to send it yourself first?

IMO you did the hard work so I did not want to steal your thunder.
Please send it as part of your series, I'll Ack it.

Martin

> >
> > Martin
> > ---
> >  drivers/net/ethernet/sfc/net_driver.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> > index 318db906a154..723bbeea5d0c 100644
> > --- a/drivers/net/ethernet/sfc/net_driver.h
> > +++ b/drivers/net/ethernet/sfc/net_driver.h
> > @@ -1530,7 +1530,7 @@ static inline bool efx_channel_is_xdp_tx(struct efx_channel *channel)
> >
> >  static inline bool efx_channel_has_tx_queues(struct efx_channel *channel)
> >  {
> > -       return true;
> > +       return channel && channel->channel >= channel->efx->tx_channel_offset;
> >  }
> >
> >  static inline unsigned int efx_channel_num_tx_queues(struct efx_channel *channel)
> >
> 
> 
> -- 
> Íñigo Huguet
