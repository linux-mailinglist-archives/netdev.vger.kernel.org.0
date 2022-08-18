Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFB759908C
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346274AbiHRW3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343803AbiHRW3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:29:09 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36724D9D7C
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:28:55 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id qn6so5721821ejc.11
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=9pli1umCdNJ2MTJcmPkK3bzui4boVrM6i5ITeI3LlAM=;
        b=htIbUcO9WOzk2YvOijuKCYSTNRiKOELWHH3ydZcwQT+TtxVreLjOyY6bF6CXhN22Z2
         W8RVrFs0ZguuwsoOb67wIXx5gYX2Lgg36bdHYwnYhTjKbPzTizkxZ0hSDh0KX2ZIeaRI
         rpytZxw48PsWv736V+6g7KFLZYqmNcSCvUzj3Iy+/jvvxQGV161Jwgcv8BiYc9zIXltJ
         BakVib6sgSC8o1Y881yXVv49tgSdUWN8XqYvD5ZjANaV0GrBHaeS2QlccskfqErflm8F
         wKi5Q/M82pzHDddwqMPT7V768c46tUqevUgyr455IdwsOM3dR6mwrR2ZQ3Z8klDBoUKh
         ovQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=9pli1umCdNJ2MTJcmPkK3bzui4boVrM6i5ITeI3LlAM=;
        b=RYUtVaVzRDZ18E3rXkAxRIY3Z8/ekfdeqdcH9cJA9RSnGDIWaWyeDrPrQi3a8AtwCi
         zqnfmQKEJecUqKDQnwk5VEWXzvWqmbdXBtCwZFSKXAwNc/qHx6G1gYPDxCukL8UF26JY
         4WtT5txiR9lTjxsvIDN8+ePCJ+57SHdFRXF2/LV+6KB33htcmURjjyQ4tkfdGDmH+psH
         E3lk1hI3vy9/mPKKi9gz7ZZt31NF6nY47ESCv/jLjuFECtmHxdZPN3vitRbFUp3A65Vj
         opsaZXlR5UYAH4nT/Iz3wyS0gtMfOnvS5dgbqh5/8kVrrPFPvt98kCntM7ue+e4b8D19
         qupg==
X-Gm-Message-State: ACgBeo0JKbRVLwhLevLgUdrKbRzRWXQEoOdRNehDpGuthpmEOqfkKWD0
        2fkAnntZCQCOKBzDZzPCDxg=
X-Google-Smtp-Source: AA6agR68wqXo7JRRLuofbkLO0MoB2rn2svNEtZlB10RDoWAcKcVDypDPYV3xjRrVJPKTc3WrcgefSg==
X-Received: by 2002:a17:906:6a02:b0:730:9f44:2bff with SMTP id qw2-20020a1709066a0200b007309f442bffmr3101586ejc.209.1660861733655;
        Thu, 18 Aug 2022 15:28:53 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id ch26-20020a170906c2da00b0073095265adesm1416132ejb.165.2022.08.18.15.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 15:28:52 -0700 (PDT)
Date:   Fri, 19 Aug 2022 01:28:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH net-next 00/10] Use robust notifiers in DSA
Message-ID: <20220818222850.mskqhmzpvz2ooamv@skbuf>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
 <Yv6z5HTyenpJ+pex@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv6z5HTyenpJ+pex@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 11:49:24PM +0200, Andrew Lunn wrote:
> I would split it into two classes of errors:
> 
> Bus transactions fail. This very likely means the hardware design is
> bad, connectors are loose, etc. There is not much we can do about
> this, bad things are going to happen no what.
> 
> We have consumed all of some sort of resource. Out of memory, the ATU
> is full, too many LAGs, etc. We try to roll back in order to get out
> of this resource problem.
> 
> So i would say -EIO, -ETIMEDOUT, we don't care about too
> much. -ENOMEM, -ENOBUF, -EOPNOTSUPP or whatever, we should try to do a
> robust rollback.
> 
> The original design of switchdev was two phase:
> 
> 1) Allocate whatever resources are needed, can fail
> 2) Put those resources into use, must not fail
> 
> At some point that all got thrown away.

So you think that rollback at the cross-chip notifier layer is a new
problem we need to tackle, because we don't have enough transactional
layering in the code?

In case you don't remember how that utopia dug itself into a hole in practice:
nobody (not even DSA) used the switchdev transactional item queue (which
passed allocated resources between the prepare and the commit phase)
from its introduction in 2015 until it was deleted in 2019, and then
drivers were left unable to reclaim the memory they allocated during
preparation, if the code path never came to the commit stage. There was
nothing left to do except to throw it away.

To discover whether the ATU is full, you either need to reserve space
for static entries beforehand, which is inefficient, or just try to add
what you want and see if you could. Which inevitably leads to encouraging
the strategy of doing the work in the preparation phase and nothing in
the commit phase.

"Too many X" where the resource limitation is known beforehand is about
the only case where a prepare/commit phase could avoid useless rollback.
It's also a case which could also be solved by being upfront about the
limitation to your higher layer, then it would not even try at all.
And do note that "less useless rollback" is different than "code gives
more guarantees that system will remain in a known state".

Sadly reality is much more dynamic than "allocate" -> can fail / "use" ->
must not fail. I think when the model fails to describe reality, you
change the model, not reality.
