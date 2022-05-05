Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE651C17E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380142AbiEEN4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380187AbiEENzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:55:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAEC57988
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 06:51:34 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id j14so4458778plx.3
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 06:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s2D8RQZUZmTBf8FjV4yEC48mpHsSfx3jQsgI1V1sFBs=;
        b=mraHi2/gFd/BYbF3DpHjcEIv1aqcOOfu2LhcZ7nVZTbOHnMBqBPCB6ekhidwRP4gGe
         3nrS5/mEQm5vZpErgWPamYa8RKnD0AB8/Fg/VjISE/b+/X4rB2H8BHEqWqAIn7BgJk5X
         MGb9LreadJC0vIl337+D5h1eD6Zv3dxNBy4zEPsxqZvnALHw+RaWcXAsB2Lo5KQXkvhk
         fBe+wk1BEPOmzrlwUYbfTb7sdtXloQ5Jgkk7Lcub/UInkh3L2rDdiWdvf5m8VtdasBO/
         fwJF5CtfDhUl0E3t0WvcBRbb5vn8gYkXhmOYX6SOiEWDSd+M3xHtqGNA1/hqq1fspxW7
         mQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=s2D8RQZUZmTBf8FjV4yEC48mpHsSfx3jQsgI1V1sFBs=;
        b=F441qJX/P4Y0/lC8pVUgQyu7ryeZmYT0byDTHjno+1iu3th/E9fmvXbbzSNvvFGxu8
         6qBLWvdhEp9e3Q/QGdgd/TaO+X5gtcBIkyRCuFpZAUUSwtoqkeoRuXbIaywXTeX+bHM+
         jEqG1twuWfghtCvTzUHETt4aWKlV4bgVnKwYZlgPZzWAqYXyEXQgBrVrbtbNCd8zLLKw
         jM6Ht3+LnJ3vPmpGq0/2wv4fJQzaGzKCc+Ls4xVoiDMtV5GFwnzawBsOX3t169ES27hk
         r8F5pfXZx5WZyPX7j9lf5Y/IaB90NYUiiEKRiZqN722uo7RCc5M6GNZwhqi6f+MdrncJ
         jMFA==
X-Gm-Message-State: AOAM531XB7gMR8Xv5ySXccV/SHkSAiqFIJaj85q4MvxkDp2M30ubmq2E
        IkK2H/FSIsZffXRN/FPRlAI=
X-Google-Smtp-Source: ABdhPJz+RJ3HW3uQUMYL3je3z92SiFg6Qdw8BEc59k5QhqaWhDZ4CgRLTzViSJrTTUyCXgiY2UCpDg==
X-Received: by 2002:a17:902:c2d0:b0:15a:2344:f8a4 with SMTP id c16-20020a170902c2d000b0015a2344f8a4mr27569854pla.28.1651758694256;
        Thu, 05 May 2022 06:51:34 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id bf7-20020a170902b90700b0015e8d4eb21dsm1549746plb.103.2022.05.05.06.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:51:33 -0700 (PDT)
Date:   Thu, 5 May 2022 06:51:31 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     vinicius.gomes@intel.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org, mlichvar@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/6] ptp: Add cycles support for virtual
 clocks
Message-ID: <20220505135131.GA1492@hoboy.vegasvil.org>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
 <20220501111836.10910-2-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501111836.10910-2-gerhard@engleder-embedded.com>
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

On Sun, May 01, 2022 at 01:18:31PM +0200, Gerhard Engleder wrote:
> ptp vclocks require a free running time for their timecounter.
> Currently only a physical clock forced to free running is supported.
> If vclocks are used, then the physical clock cannot be synchronized
> anymore. The synchronized time is not available in hardware in this
> case. As a result, timed transmission with TAPRIO hardware support
> is not possible anymore.
> 
> If hardware would support a free running time additionally to the
> physical clock, then the physical clock does not need to be forced to
> free running. Thus, the physical clocks can still be synchronized
> while vclocks are in use.
> 
> The physical clock could be used to synchronize the time domain of the
> TSN network and trigger TAPRIO. In parallel vclocks can be used to
> synchronize other time domains.
> 
> Introduce support for a free running cycle counter called cycles to
> physical clocks. Rework ptp vclocks to use this free running cycle
> counter. Default implementation is based on time of physical clock.
> Thus, behavior of ptp vclocks based on physical clocks without free
> running cycle counter is identical to previous behavior.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
