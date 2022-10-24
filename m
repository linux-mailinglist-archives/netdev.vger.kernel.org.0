Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B30860B8F8
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiJXUAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiJXT7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:59:39 -0400
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811A8159D52
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:22:18 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id kt23so1410661ejc.7
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lKb3mKR4ZB9ypvbq3UuPAIWQf45BjRNY9ApC59vB0J4=;
        b=pWjt5J94sFtbDmepmTuifFjfTnxHgtukZUSNhxQBj4dCyzOPx4xG566yDRYGsacAjg
         F1wyN8vYAPuCRQcvwTZBbhHHpmuJty+P7eP+0jOGgsKIkDlcYWxIDKwM+o0RjRjWZxL5
         mvBlmvfT5J6do+sNH9N036Ky/Fy9H1R6OWhKVSc8/au5wVgCMLKDR27pOvdWj2dldwBl
         PF9ZS1oDkRhgR1Z3yT5EarAr2ZmEzOnCkOu793DVmZmYZTNxcrsFr1tv7QBijNFtEFAk
         wWa/YdVMY7qWVWV5DWcOTFFg0ysLIYxI9+EkQiFUn/ef156Qp2GjYgEnazGaS1iwuldl
         MLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKb3mKR4ZB9ypvbq3UuPAIWQf45BjRNY9ApC59vB0J4=;
        b=GcyOTfXBQnR7axJ9GF5IjdvwFKsHiqFmAt7NdVMJxggwBx+0fOtFpw62AocMdD2ab9
         eEN1Bt9CtpErFjhkXuAs0lHez6xI8CavHiXyloOtJTC5kk2WWiDYSTnJn/DtaksfH2G4
         ZSA/91xNN7yVaonmpGFZHueaGfzQiujxoMDn8n1FdaBNE7hAQJUoAa9duAgJVBAriUVX
         IU/lWVJk/jp4L9AtZqMXdX2xlexU0Yxx+T+ONG9mDPspKVn3mdPRdJ6CoyKglkxAbZ9N
         /zRh8s5DtQAhQpGaPMgP+PC8Y9XDzlvzZxVaY+GLq5ZgDM52dngnQtf9rrb15DKJWAAY
         qxmw==
X-Gm-Message-State: ACrzQf36gdrexHz+djn0XezUvFyBj8r8zI+TymvmQGmeiYakQ5A9cCCv
        9b2tiTomesn4PT+aBlwazGJove6t5e5jmA==
X-Google-Smtp-Source: AMsMyM53ycjfj5gjYa2mrkBIiDesy5qThwni3bKaXsy4CGYDpoFZGgiujw2n3p+olnOguFBfvqiqcA==
X-Received: by 2002:a17:906:15ca:b0:78d:b7b3:2afa with SMTP id l10-20020a17090615ca00b0078db7b32afamr28440603ejd.69.1666628508070;
        Mon, 24 Oct 2022 09:21:48 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id f11-20020a170906048b00b00783c545544fsm61989eja.215.2022.10.24.09.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 09:21:47 -0700 (PDT)
Date:   Mon, 24 Oct 2022 19:21:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sergei Antonov <saproj@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH v4 net-next] net: ftmac100: support mtu > 1500
Message-ID: <20221024162145.4t35ucrwpafbyhbc@skbuf>
References: <20221019162058.289712-1-saproj@gmail.com>
 <20221019165516.sgoddwmdx6srmh5e@skbuf>
 <CABikg9xBT-CPhuwAiQm3KLf8PTsWRNztryPpeP2Xb6SFzXDO0A@mail.gmail.com>
 <20221019184203.4ywx3ighj72hjbqz@skbuf>
 <CABikg9x8SGyva2C5HUgygS3r-c-_nv6H1g_CaBq-8m3rKp1o0g@mail.gmail.com>
 <Y1a4no+U1cbXAWLi@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1a4no+U1cbXAWLi@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 06:09:02PM +0200, Andrew Lunn wrote:
> On Mon, Oct 24, 2022 at 06:50:31PM +0300, Sergei Antonov wrote:
> > On Wed, 19 Oct 2022 at 21:42, Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Wed, Oct 19, 2022 at 09:36:21PM +0300, Sergei Antonov wrote:
> > > > On Wed, 19 Oct 2022 at 19:55, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > >
> > > > > On Wed, Oct 19, 2022 at 07:20:58PM +0300, Sergei Antonov wrote:
> > > > > > The ftmac100 controller considers some packets FTL (frame
> > > > > > too long) and drops them. An example of a dropped packet:
> > > > > > 6 bytes - dst MAC
> > > > > > 6 bytes - src MAC
> > > > > > 2 bytes - EtherType IPv4 (0800)
> > > > > > 1504 bytes - IPv4 packet
> > > > >
> > > > > Why do you insist writing these confusing messages?
> > 
> > Working on a better version of the patch. And here is another question.
> > Unless the flag is set, the controller drops packets bigger than 1518
> > (that is 1500 payload + 14 Ethernet header + 4 FCS). So if mtu is 1500
> > the driver can enable the controller's functionality (clear the
> > FTMAC100_MACCR_RX_FTL flag) and save CPU time. When mtu is less or
> > greater than 1500, should the driver do the following:
> > if (ftmac100_rxdes_frame_length(rxdes) > netdev->mtu + ETH_HLEN) {
> >     drop the packet
> > }
> > I mean, is it driver's duty to drop oversized packets?
> 
> It is not well defined what should happen here. Some drivers will
> deliver oversized packets to the stack, some will not.
> 
> The main purpose of the MTU is fragmentation on transmission. How do
> you break a UDP or TCP PDU up into L2 frames. MTU is not really used
> on reception. If the L2 frame is otherwise valid, i doubt the stack
> will drop it if it is longer than expected.
> 
>      Andrew

I think the general wisdom is for a driver to not go out of its way to
accept packets larger than the MTU, and not go out of its way to drop
them either. The only given guarantee is that packets with an L2 length
<= dev->mtu are accepted.

The sad reality is that some layers like DSA rely on this marginal
behavior in some cases (controllers accept packets slightly larger than
dev->mtu) and this is why we took the decisions that we took (discussion
which I linked to in the v2 of this patch:
https://patchwork.ozlabs.org/project/netdev/patch/20200421123110.13733-2-olteanv@gmail.com/)
