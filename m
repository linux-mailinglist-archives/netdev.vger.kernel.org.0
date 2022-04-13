Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EB2500046
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiDMUyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiDMUy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:54:29 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F1318B18
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 13:52:07 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id m8so3667880ljc.7
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 13:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DG8nz6f2B2IIhDSF14I+uK0cH5G8fS9ZI36LzK48Qjk=;
        b=r+fDtw/16Vb35gtzTpF3OTKDl2jQiNLvYrgql7NH9Q9/o7viKVggRinlozcv1KfzjD
         cK/p4tLf7WvPovROyB/4lTlY4i5SshO9JqgUjf/AygQ2hYP/jrhdzQCojB+Yl25EudpV
         8JArYFURnjw4SJRTWyhDClX9AuEaO7cB1FiCBatlivTm5VCMER0tibdeFBat4+JUTcAR
         Y6VoR4p60YbYM8/XktyFRbBwp7wv5gvlSb7oFnpGd+gCtWVePHr9TGxAOr5GRygm07TW
         wa5ylKb2/7kFI83XxUwfamhaaoDy9iYNN+4olSqgJwucPAGCscw53m2UTpO3+CGuDkxR
         k22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DG8nz6f2B2IIhDSF14I+uK0cH5G8fS9ZI36LzK48Qjk=;
        b=X7yYMRzzNYcES5IViaJEMiNlpqyCRf88dotilK/yac3fZ6xrLN5vT6ETMqGYnICSeV
         CDGWNJXX/OPZ1/6SpZ9KTGfNN1aEdaoJ2/aiM+JVgAr1IwxMpo7p6T6mScDj2CIs3d5y
         HlH7HMACohE9nb5/Rizyx2wpsRwWvX2Qz4J7MaBt89dv8nUBOxDqMEuPwEkzgjDAWco2
         tqQbeF+yQUYacLi3sbABQYjcpu39StzgGJt4xwpDAo7R/KhMX/B8JCljByfb0FABXm0v
         0D7ngWz7XI+p4UbCnZIlgTp9l9z2Iwf9My5nrdjbuh+lzKWYzmRuMquVuYE8RAp1Vrg5
         63pA==
X-Gm-Message-State: AOAM530oImW9FH2sfeNd+PoYg7fvambVevIFq025xWunwVAu5WztMIy/
        DfJ9vCd1CF553zYadKzvk3vTzMMA/lUhspZ7blWENgxk+TfTD5pm
X-Google-Smtp-Source: ABdhPJz4mhVMMG6V1qKuAMK0lh/gJBCIK5aEc2vGYYtO4FAUU5DsXJTSZCMRpVRVzPW8otxlepNkTcj+uc6dNLiICY0=
X-Received: by 2002:a2e:7213:0:b0:24b:4487:9049 with SMTP id
 n19-20020a2e7213000000b0024b44879049mr20991412ljc.96.1649883125393; Wed, 13
 Apr 2022 13:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220403175544.26556-1-gerhard@engleder-embedded.com>
 <20220403175544.26556-5-gerhard@engleder-embedded.com> <20220410072930.GC212299@hoboy.vegasvil.org>
 <CANr-f5xhH31yF8UOmM=ktWULyUugBGDoHzOiYZggiDPZeTbdrw@mail.gmail.com>
 <20220410134215.GA258320@hoboy.vegasvil.org> <CANr-f5xriLzQ+3xtM+iV8ahu=J1mA7ixbc49f0i2jxkySthTdQ@mail.gmail.com>
 <CANr-f5yn9LzMQ8yAP8Py-EP_NyifFyj1uXBNo+kuGY1p8t0CFw@mail.gmail.com> <20220412214655.GB579091@hoboy.vegasvil.org>
In-Reply-To: <20220412214655.GB579091@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Wed, 13 Apr 2022 22:51:54 +0200
Message-ID: <CANr-f5zLyphtbi49mvsH_rVzn7yrGejUGMVobwrFmX8U6f2YVA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/5] ptp: Support late timestamp determination
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, yangbo.lu@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I'm thinking about why there should be a slow path with lookup. If the
> > address/cookie
> > points to a defined data structure with two timestamps, then no lookup
> > for the phc or
> > netdev is necessary. It should be possible for every driver to
> > allocate a skbuff with enough
> > space for this structure in front of the received Ethernet frame.
>
> Adding 16 bytes for every allocated skbuff is going to be a tough
> sell.  Most people don't want/need this.

Most people are not affected because they use drivers which do not
support cycles. Those drivers stay the same, no 16 bytes are added.
For TX those 16 bytes are not added, because SKBTX_HW_TSTAMP_USE_CYCLES
is used to fill in the right time stamp.

For igc and tsnep the 16 bytes in front of the RX frame exist anyway.
So this would be a minimal solution with best performance as a first
step. A lookup for netdev/phc can be added in the future if there is
a driver, which needs that.

Is it worth posting an implementation in that direction?

Thanks!

Gerhard
