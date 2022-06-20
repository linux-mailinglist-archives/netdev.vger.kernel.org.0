Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B9355225D
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 18:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbiFTQgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 12:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiFTQgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 12:36:21 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0BE1C91E;
        Mon, 20 Jun 2022 09:36:20 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id g8so10215070plt.8;
        Mon, 20 Jun 2022 09:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=6KRpF0L0JhSh1qLp7YyVoespt3LvQWnvsOM7gzN/eCs=;
        b=OnV04FB7r3thHqoOwsP42APFqN3Mwm1hE69j5gTpZAx/S8oxHLaChL4ITmHLfx95k+
         jnpO6pwz3heY0ow0mj8LFKPT1k/DHeAUWPZSCAy3TSmAiXuBvK/SxwuqNZHkjlROX/a6
         VJ/PKzHg6ucFoBG/InxvUOyohNAmdBun7/CDlZRHmXJ0gTdrsUngYZZeUOddorS+YUBJ
         QzXBsTrr/wZrjg42br/Vm5C5yLyNTdpmhpcod0x+MfCDHv/fNXfG4uKiHMY608n6WmfF
         G9zVa/c8Q2f6QrK0MvN4/jDdYrZrCw9wsiKBWwuXzId3ZIXJliaSV1XFEpCYhCWWF9yW
         rUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=6KRpF0L0JhSh1qLp7YyVoespt3LvQWnvsOM7gzN/eCs=;
        b=BabZzjG98TJuMDCykuUIZVpHXmuf/aHedOdojyxRZQkBhoJMSP8yGKg7J1+shHxEfY
         AvnBFGLJb3a1spHEog6mXF8N9bcdhB74jBVBTJ3i0MAchwJeStXLhoAui5kswnM7oGFT
         T/dDVVco6LRWQSenayM43jXmvMpKCH2T8l4N8gVaHQODMHCI7cjZESh54NDZLV2N2Wi1
         5zvImdxxHEZH/l/ftGnlJCbxS99Q+glxHH45BgkgS00Hmk2txVc0GB9/dM0naOu194iT
         Px8BNlKdcZM/8HJAiutKlOarIwhd7dn224M7vSTChO0VxTLIyTRLBDV7g0lOe+jxmMct
         CJEQ==
X-Gm-Message-State: AJIora/e+84A/U6EdL+uqdEoR2UDYMVlmWpt/ZhYwnGsD+a+EKWW8rZ8
        wkn/hiuiKi1x54R9t8K+Df4=
X-Google-Smtp-Source: AGRyM1sIik5hEchZgzx0CStr6urmNDu7c6hYdXeDHF3Ga9ntpQcFweUTbfrmWyqaaI9c0Np59EHtRQ==
X-Received: by 2002:a17:902:9f97:b0:16a:9b9:fb63 with SMTP id g23-20020a1709029f9700b0016a09b9fb63mr16346339plq.7.1655742979643;
        Mon, 20 Jun 2022 09:36:19 -0700 (PDT)
Received: from localhost ([98.97.116.244])
        by smtp.gmail.com with ESMTPSA id gp5-20020a17090adf0500b001ec84b0f199sm5589053pjb.1.2022.06.20.09.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 09:36:19 -0700 (PDT)
Date:   Mon, 20 Jun 2022 09:36:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org
Message-ID: <62b0a20232920_3573208ab@john.notmuch>
In-Reply-To: <YrBh4PsLY1GID3Uj@boxer>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-10-maciej.fijalkowski@intel.com>
 <62ad3ed172224_24b342084d@john.notmuch>
 <YrBh4PsLY1GID3Uj@boxer>
Subject: Re: [PATCH v4 bpf-next 09/10] selftests: xsk: rely on pkts_in_flight
 in wait_for_tx_completion()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> On Fri, Jun 17, 2022 at 07:56:17PM -0700, John Fastabend wrote:
> > Maciej Fijalkowski wrote:
> > > Some of the drivers that implement support for AF_XDP Zero Copy (like
> > > ice) can have lazy approach for cleaning Tx descriptors. For ZC, when
> > > descriptor is cleaned, it is placed onto AF_XDP completion queue. This
> > > means that current implementation of wait_for_tx_completion() in
> > > xdpxceiver can get onto infinite loop, as some of the descriptors can
> > > never reach CQ.
> > > 
> > > This function can be changed to rely on pkts_in_flight instead.
> > > 
> > > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> > 
> > Sorry I'm going to need more details to follow whats going on here.
> > 
> > In send_pkts() we do the expected thing and send all the pkts and
> > then call wait_for_tx_completion().
> > 
> > Wait for completion is obvious,
> > 
> >  static void wait_for_tx_completion(struct xsk_socket_info *xsk)               
> >  {                                                   
> >         while (xsk->outstanding_tx)                                                      
> >                 complete_pkts(xsk, BATCH_SIZE);
> >  }  
> > 
> > the 'outstanding_tx' counter appears to be decremented in complete_pkts().
> > This is done by looking at xdk_ring_cons__peek() makes sense to me until
> > it shows up here we don't know the pkt has been completely sent and
> > can release the resources.
> 
> This is necessary for scenarios like l2fwd in xdpsock where you would be
> taking entries from cq back to fq to refill the rx hw queue and keep going
> with the flow.
> 
> > 
> > Now if you just zero it on exit and call it good how do you know the
> > resources are safe to clean up? Or that you don't have a real bug
> > in the driver that isn't correctly releasing the resource.
> 
> xdpxceiver spawns two threads one for tx and one for rx. from rx thread
> POV if receive_pkts() ended its job then this implies that tx thread
> transmitted all of the frames that rx thread expected to receive. this
> zeroing is then only to terminate the tx thread and finish the current
> test case so that further cases under the current mode can be executed.
> 
> > 
> > How are users expected to use a lazy approach to tx descriptor cleaning
> > in this case e.g. on exit like in this case. It seems we need to
> > fix the root cause of ice not putting things on the completion queue
> > or I misunderstood the patch.
> 
> ice puts things on cq lazily on purpose as we added batching to Tx side
> where we clean descs only when it's needed.
> 
> We need to exit spawned threads before we detach socket from interface.
> Socket detach is done from main thread and in that case driver goes
> through tx ring and places descriptors that are left to completion queue.

But, in general (not this specific xdpxceiver) how does an application
that is tx only know when its OK to tear things down if the ice
driver can get stuck and never puts those on the completion queue? Should
there be some timer that fires and writes these back regardless of more
descriptors are seen? Did I understand the driver correctly.

Thanks,
John
