Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818A54E9681
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242441AbiC1M1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242429AbiC1M1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:27:43 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002AB4D247;
        Mon, 28 Mar 2022 05:26:00 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t13so10887934pgn.8;
        Mon, 28 Mar 2022 05:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fNWn9Z6ADbA6o5al6zBEcDZHutfYeq1Ua+09g55SEsY=;
        b=hyBsvFRAnDqXrnLe4zFp4A2phxS+MEVlGv6dFSwVAUKGGNJJMPum3KENT/JYpT8UZN
         W9uk5uwXYo32qvMACevncJ9Xn4x4LXEVpu6j0dl7ZYYwVGlB3FHgUEtUVKX0VbcgfOBb
         RSE2w1igMssWSdJD+ZTWW6aOgohp2IiH0bXuHTNSI4AmvGtF3I5Mc92U7QpNTpdbGv05
         YfOWR6z5Qi44+BK+88HrJzwMPLcVchF4XRbMrN11TkAOg+P/VhBi0YyA2gCcudEDnbRL
         hLq1c6hCoC66+u7SIVXLFZo3N9OG4FunNx53k6GESjQyaLCgnKPAQLCfZVLH90e6hwMK
         jP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fNWn9Z6ADbA6o5al6zBEcDZHutfYeq1Ua+09g55SEsY=;
        b=wRVa7ZonpwvgD656WX0QORG/gIOXj4asxNxHwYVBctXwSOzEz33OePb+UeE5fxmOIP
         EM+rh7DWwDROB1mUppA0Eat++9XXpE7qkWllX6C9xOB53+28bTlTzzCF9ibaozi0LKG0
         OPbObTapC9cMt+71pkNRkdVmkYQRyKG+2f33FWkngSU3L6nVrKZrNSsTBIkfjq2Cv2I9
         55V9J0p42Ew9ReSTd1ViFryQGrirwKDKO9XQmeYR4U9dQgfBZ0OPbwLUWyE3KYfc640p
         09p2U/akSiWWsPmeIBc+2GB1GAlAiruvEQVh+RxJKEiHp6KWzM+JlhUvsVWmywxkMiL6
         vFLQ==
X-Gm-Message-State: AOAM530s8LD9OM/o8oWAYkTBuqMtVyrhCHQsHyGJz8tp2GiQ8Vryx2cl
        /dkfBcRVUmVaHsAuHG8uP5c=
X-Google-Smtp-Source: ABdhPJxApUNNiWFzC8FfcO15afbiVATmwPDG03/UfTbCcUEDLdun03ylQ3CN3oVib23+GpUNHZU0dw==
X-Received: by 2002:a65:6cc8:0:b0:382:1b18:56a9 with SMTP id g8-20020a656cc8000000b003821b1856a9mr10162480pgw.347.1648470360429;
        Mon, 28 Mar 2022 05:26:00 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id m18-20020a639412000000b003820bd9f2f2sm13301496pge.53.2022.03.28.05.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 05:25:59 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     chunkeey@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, kvalo@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, netdev@vger.kernel.org, pabeni@redhat.com,
        stable@vger.kernel.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] carl9170: tx: fix an incorrect use of list iterator
Date:   Mon, 28 Mar 2022 20:25:51 +0800
Message-Id: <20220328122551.936-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAAd0S9CR=PjEskWAi132qWB5WL1yZwzOBfV-y5m2ERzc3L_qcA@mail.gmail.com>
References: <CAAd0S9CR=PjEskWAi132qWB5WL1yZwzOBfV-y5m2ERzc3L_qcA@mail.gmail.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Mar 2022 23:40:46 +0200, Christian Lamparter wrote:
> On Sun, Mar 27, 2022 at 8:10 PM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
> >
> > If the previous list_for_each_entry_continue_rcu() don't exit early
> > (no goto hit inside the loop), the iterator 'cvif' after the loop
> > will be a bogus pointer to an invalid structure object containing
> > the HEAD (&ar->vif_list). As a result, the use of 'cvif' after that
> > will lead to a invalid memory access (i.e., 'cvif->id': the invalid
> > pointer dereference when return back to/after the callsite in the
> > carl9170_update_beacon()).
> >
> > The original intention should have been to return the valid 'cvif'
> > when found in list, NULL otherwise. So just make 'cvif' NULL when
> > no entry found, to fix this bug.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 1f1d9654e183c ("carl9170: refactor carl9170_update_beacon")
> > Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> > ---
> >  drivers/net/wireless/ath/carl9170/tx.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
> > index 1b76f4434c06..2b8084121001 100644
> > --- a/drivers/net/wireless/ath/carl9170/tx.c
> > +++ b/drivers/net/wireless/ath/carl9170/tx.c
> > @@ -1558,6 +1558,9 @@ static struct carl9170_vif_info *carl9170_pick_beaconing_vif(struct ar9170 *ar)
> >                                         goto out;
> >                         }
> >                 } while (ar->beacon_enabled && i--);
> > +
> > +               /* no entry found in list */
> > +               cvif = NULL;
> >         }
> >
> >  out:
> 
> hmm, It's really not easy test this.  There are multiple locks, device
> states and flags to consider.
> the state of the protecting ar->vifs > 0 (I guess this could be > 1.
> There's no point in being choosy
> about "picky choices", if there's only one), the main virtual
> interface as well as cvif->enable_beacon
> and ar->beacon_enable don't change on a whim.
> 
> But it it is true that this function gets called by the firmware as a
> callback to the TBTT,
> so it would warrant any protection that is possible. Whenever a bug
> can happen or be
> forced in this case: I don't know, I can't do experiments until much
> later (easter :( ).
> But it's better and easy to err on the side of caution.
> 
> Note: That "cvif = NULL;" will certainly break the beaconing for good
> (for the remaining
> lifetime of the main interface). The driver would need to be stopped
> and restarted before
> beaconing would work again. A safer choice would be to return NULL;
> That said, if the
> bug can happen, the driver/firmware would be in a bad state at that
> point anyway.
> So a call to carl9170_restart(ar, ...there's no code for a
> driver/firmware mismatch yet) will
> be necessary in the hope that this was just a temporary glitch.

Thank you, i have resubmitted a v2 patch as you suggested: just return NULL
to fix it. Please check it.

--
Xiaomeng Tong
