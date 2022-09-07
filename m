Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886D05B0B77
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiIGR16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIGR1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:27:55 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999D483BC9
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 10:27:54 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-11e9a7135easo37748145fac.6
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 10:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=ZpiDUvRJLxeUvIjtNYCl3pTiQ4ajeqiapj4/fVCzmuc=;
        b=cZT3IhevrB4xI/iZfQn/Qa0cxEaDDuNHlFYHg5XdegJ0TmvzQceLHiwIdxFg4ns6bQ
         wEyQ/ObrPO8K/ay0TsiHWUPuKWvBqwvp/l+sZ7cXhiIdCTb8Vp+r4PQdlj5+gYVomQI4
         SPAqecE+OP3EEiCE6aeONB8T9LAecmoq9bm1Kbp1VRtVOg2qe6ZbkmUmpEbGrtY+rcQG
         uZhnjOy5vRr92xs+GULDfanle7XOyZCrsY6B/UVtP8sGXurQwQTnpQ/A+k1dqf0QBjpC
         nVqObHXRVQoO4c92n4592KKug8OlC0JuHl77TssEfGfZuZKCSZDyxfEfq4qA1nCCOzY6
         Cexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ZpiDUvRJLxeUvIjtNYCl3pTiQ4ajeqiapj4/fVCzmuc=;
        b=COWbMHgHi9NuskDRVbzRYlT9VHppjAJzg6rBmm6qwix1rzWJLUNwAuq/8PmCnuGokn
         oJFJ71/68nV3s3s8KLPclYeH+8GAxwONfbSWfnOmejgKg0ta7tmcbIdQvpeVnVzqaTSn
         0Yw6xL9hODrRxuiDPEmdWKoB3nh1zZdoSe3rcSrbNuCiGjQYFP05ta6KH6fXZTHm/A+B
         IFQor9IlDz9NzvofqgNxsMy+pg/N5lGBAQPMzFqaW6HhMBuRJyaO+ifgopDrEqiX1eqy
         IXF+HYDGh8VnTEI8yIlOUOX34HwoAHvT+kXxyCEv7dKEwxX5cuAEnBfH/u2d6MZ5xuD4
         G4+A==
X-Gm-Message-State: ACgBeo3c/y7Kh0jtVhHKq642MQjFF2R8E2h30QKAtnSSGeADKQAdAyOp
        ZJm9Hy6hExnnxxnCd5yT1LE=
X-Google-Smtp-Source: AA6agR58N0Z4ZiDgasVV9q7iqOfB2tt0DoRM2gmRfC3lPAuEV5plfegqI9CbhtoFGO2tEUXCtu5Q1A==
X-Received: by 2002:a05:6870:309:b0:10c:8b6f:d0f with SMTP id m9-20020a056870030900b0010c8b6f0d0fmr14676951oaf.221.1662571674014;
        Wed, 07 Sep 2022 10:27:54 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:43a8:b047:37c3:33fe])
        by smtp.gmail.com with ESMTPSA id z125-20020aca3383000000b00326cb6225f8sm6666985oiz.44.2022.09.07.10.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 10:27:53 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:27:52 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] sch_sfb: Also store skb len before calling child
 enqueue
Message-ID: <YxjUmCi2UvA8/vRs@pop-os.localdomain>
References: <20220905192137.965549-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220905192137.965549-1-toke@toke.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 09:21:36PM +0200, Toke Høiland-Jørgensen wrote:
> Cong Wang noticed that the previous fix for sch_sfb accessing the queued
> skb after enqueueing it to a child qdisc was incomplete: the SFB enqueue
> function was also calling qdisc_qstats_backlog_inc() after enqueue, which
> reads the pkt len from the skb cb field. Fix this by also storing the skb
> len, and using the stored value to increment the backlog after enqueueing.
> 
> Fixes: 9efd23297cca ("sch_sfb: Don't assume the skb is still around after enqueueing to child")
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
