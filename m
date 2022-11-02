Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A1E61664D
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiKBPhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiKBPhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:37:09 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14C825C6E
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 08:37:03 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v1so25093215wrt.11
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 08:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rL3LIVF7Jfq8i4UyDH3ak/nwYJdIXqz7MUDtnOTbsUs=;
        b=ZKj2eZo9CX8Z5jHbTe2m6XuC2TGZitdRxis5YVCnyJA4BV3dweoNswzD8CRqn3kTP9
         f43ZOzdAnPrB82IU7L4PGeMgUArFHxn1vXBui3CqvSjcuknyTnDJI3m5O9EAjqwXilPq
         ja/HN5xhxN0qyjrCGYmNnyP5Iucx7gCRQYXo3kotqiQG7KcYboUIjA1BGrXQkYe5dCIu
         LUSmwDK8qVH3kIxgtd8Ijb40YTevdXBSdPZ9Mcx51wlM2cGQJTaRldoOmKaW3VN9a8PE
         Z0ZKk1pI7VPtMkLtQeV+AedyEBkBDR1+XrZ4j5y2bAKMD4kP9vuBExecIcOIYrLWRKKJ
         0Qew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rL3LIVF7Jfq8i4UyDH3ak/nwYJdIXqz7MUDtnOTbsUs=;
        b=LI8Lkq8INX0MUECO4VrI1qWHTGj1laK4Nk2qJiTPpHG0jr07LXNfV89R+6Yni6Qesr
         5fnNFEVTwKNPBKr39oEVeEuZ7KkBKuQuOl+dffK0SUw3sHV7u2KOm02eNT9IQd77iAqA
         5+WBxY2m5MnhJJA4Gu9YSsUsHKLJ3Xkdbh1gz0ezshX2xwf2of8BMFtrBV1p6l0zb5lj
         IYTIii2hPMu+hUedfY+LFV5ohRw3L+SsmMVArRm31hXzp0AzQj2zrATqeu3sJyf33bkC
         UVVTla0GAC0S4VPSOh0Y0ypfEZjLcBoVNzxXpq+R84xKEOeLcIHNY4NFX61ETp2WeMSV
         QUIA==
X-Gm-Message-State: ACrzQf1OlT0Yx1Gsa4uygtqcYTxue1brOXxscynI66DLc7Lt7EghncHB
        4Ijd7po7NFlCzC0Z1r+9dt+aSw==
X-Google-Smtp-Source: AMsMyM4tOtpYMzqOXSv57vEH5QjpFn3CKnCOs8w3uei8a7REctKaEx094B5a54tdM+I7OXC5bdtjNg==
X-Received: by 2002:adf:f8c3:0:b0:236:9c97:6f6b with SMTP id f3-20020adff8c3000000b002369c976f6bmr15207512wrq.548.1667403422376;
        Wed, 02 Nov 2022 08:37:02 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p13-20020a05600c358d00b003cf4eac8e80sm2641916wmq.23.2022.11.02.08.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 08:37:01 -0700 (PDT)
Date:   Wed, 2 Nov 2022 16:37:00 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 13/13] net: expose devlink port over rtnetlink
Message-ID: <Y2KOnKs0fsDNihaW@nanopsycho>
References: <20221031124248.484405-1-jiri@resnulli.us>
 <20221031124248.484405-14-jiri@resnulli.us>
 <20221101091834.4dbdcbc1@kernel.org>
 <Y2JS4bBhPB1qbDi9@nanopsycho>
 <20221102081006.70a81e89@kernel.org>
 <20221102081325.2086edd8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102081325.2086edd8@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 02, 2022 at 04:13:25PM CET, kuba@kernel.org wrote:
>On Wed, 2 Nov 2022 08:10:06 -0700 Jakub Kicinski wrote:
>> On Wed, 2 Nov 2022 12:22:09 +0100 Jiri Pirko wrote:
>> >> Why produce the empty nest if port is not set?    
>> > 
>> > Empty nest indicates that kernel supports this but there is no devlink
>> > port associated. I see no other way to indicate this :/  
>> 
>> Maybe it's time to plumb policies thru to classic netlink, instead of
>> creating weird attribute constructs?
>
>Not a blocker, FWIW, just pointing out a better alternative.

Or, even better, move RTnetlink to generic netlink. Really, there is no
point to have it as non-generic netlink forever. We moved ethtool there,
why not RTnetlink?
