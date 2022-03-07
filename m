Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507884D00AF
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 15:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239578AbiCGOGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 09:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242994AbiCGOG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 09:06:29 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EA95F8F6
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 06:05:34 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id bc27so13651838pgb.4
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 06:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4COgZnp0miuQF4F2mz/bBye/0CIbPiSVj/Wj8NOJ+4A=;
        b=KO5U68g3iVYeqBQICrPu6zd5MT9aNbPREK3mMMBtglmkKx9v0YPXwb0mnrZ0E8OE0+
         t8kNGwXGQBEF0kGSLU/nmZNSqj++igvsGVxc+rW34/D+6v1Zsmsy88P9fY7FxGHiU4r2
         T5jAIiCyF7Z0sd2M/7Y85eGto3bhPvcSCxHVkKzPZxbPZN87b9UE7tpea+VR1WOgQJdL
         58ZGyJ+9BCpALYPnZQye0FbbC1OMjoHP4XXMW+8z17ujQFcPFS90yqxGaKnQYDDlvDmv
         2h6kN8JXJbroN3LYlVpa+xZXjPpiRE3JSWmzHhR37cEdV1bwBkd4FUKJbZuIK77maDQY
         mVXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4COgZnp0miuQF4F2mz/bBye/0CIbPiSVj/Wj8NOJ+4A=;
        b=vtidN920k0VkIS6TGyQkXvrFgWxNI5rYIebXDV/e1H9ThpB5+ig43UGepPcDs6kzvp
         V55w7bh2daUUoddEw0TohjKvHRm8m8XIBNoLRxj+cUTTj9nLS3DOrAxfYijdqHWbGhKj
         Q5BSz1j8YXpJUkeNH3akcD34dj3J+vENYuYLcz4Ve15Mg36K0qm/bn100bMSSFJqmhdg
         Ip2S/i66c1nLrabzcMHMEVl3XSGW2/hsgBhqEuRsR1lJdPc9dTGigDutsntfxHiExTx4
         oAwHRfCjRwHUgLG9xyjHEaDZfMqxlUJHImUFzHitsQ2dkF/qyQ6m+93/iEBIz31+9y0m
         cpsA==
X-Gm-Message-State: AOAM532ZhxLtP8helX3lbz4X8aM2t8DrgL92skG4Ll3ABIdaCcUF6IOI
        Kh2OavkXoCPfYt1okrSOZr0ctUiEXns=
X-Google-Smtp-Source: ABdhPJzZXI8ZLcJwT4SQRkT3remZotDozJF/LCHRBm0FSWH84w7Bpp3PP1Yx7lLQDI3+MHibkNS+Zw==
X-Received: by 2002:a05:6a00:781:b0:4f4:2a:2d89 with SMTP id g1-20020a056a00078100b004f4002a2d89mr12745027pfu.13.1646661934544;
        Mon, 07 Mar 2022 06:05:34 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s17-20020a17090a441100b001bc1b59fe1asm18912352pjg.38.2022.03.07.06.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 06:05:33 -0800 (PST)
Date:   Mon, 7 Mar 2022 06:05:31 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     gerhard@engleder-embedded.com, davem@davemloft.net,
        kuba@kernel.org, mlichvar@redhat.com, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, yangbo.lu@nxp.com
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220307140531.GA29247@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220307120751.3484125-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307120751.3484125-1-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 01:07:51PM +0100, Michael Walle wrote:
> Richard Cochran wrote:
> > You are adding eight bytes per frame for what is arguably an extreme
> > niche case.
> 
> I don't think it is a niche case, btw. I was always wondering why
> NXP introduced the vclock thingy. And apparently it is for
> 802.1AS-rev, but one use case for that is 802.1Qbv and there you'll
> need a (synchronized) hardware clock to control the gates. So while
> we can have multiple time domain support with the vclock, we cannot
> use Qbv with them. That was something I have always wondered about.
> Or.. maybe I'm missing something here.

Niche is relative.

Believe it or not, the overwhelmingly great majority of people using
Linux have no interest in TSN.

Thanks,
Richard
