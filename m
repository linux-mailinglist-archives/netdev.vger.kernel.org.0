Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D674FF355
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbiDMJYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiDMJYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:24:48 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78D952B01
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:22:27 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id u19so2422692lff.4
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=c2bCHm3MCZr2B3PgN7LvCqMZxNJbNpRAkdIyjksl5Ug=;
        b=RPRjQPiYcmjBFXKTRJS2jFYk+wDtGsXTaCYujYsdiqiKyXY3a8/WgUhSSgFWPZ6Ij6
         uITMAeo5+RHQzY1fZ5uBG2J0cB4CN5hjYiVU3jDWP4180NCWxygEC3KfyB+1tRgNLOjG
         DtcYZZS2DRzrUZVY0+i0CfmDE4njQI7LNddp8NPGoMH7F/cQZYQF0jHkEGzQe03+Ibcu
         2WGu6oZ0xB5XzgvlrbWAslgly0A0pOTwvDCcRZamgBrx7720H/6BhtMfzs/HmN/7EZ+t
         db1BxBVqlPlASMGcQR0KS84YEgavEzYYsPvzIcE5z2DSxfxlN3/FjlwAEj7PoqLTVzl7
         IE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=c2bCHm3MCZr2B3PgN7LvCqMZxNJbNpRAkdIyjksl5Ug=;
        b=NlZ9kZ9vqIF5RB2NfYynxQc6kRV7UoFH+a5bwvdtKIS1VEzsJHMNOJ5+HJSSWeL7sk
         sgB34jGswEuZpSkdu9/og+XPgLPvpM1dHEo2bLvJgQoZJAaWu1LE76Vu9mJJNbb8BJQ7
         LQYDkNtE7vO327YIwS+Y5IyyQfoM8TahM8NToiBVMCX2+0ZJbtMT+3nk/ZqBBgiG58U8
         zK8PY2gbCNRJLH5rnwl4BEX5vf7sxUQr4VAgS0tCPMz8djQvrk0Df3XBOi0r+XoYnECQ
         7IAKZ3It8xdmOA0QBNt7Gu0THWr4akgodeO7a2e4eS6dqPqtPEc8HQ38urrT8hEgfPZU
         JfjA==
X-Gm-Message-State: AOAM532CeeCFDDfy0RFbGkPWxRoJdhJ/MmyMkDrtdFZgBNleEi1u08t6
        lpG1Rvq8IijoLG7J3gmTJD1HN441cGe9zw==
X-Google-Smtp-Source: ABdhPJwPYaL9lcSORmKORBuUMG1Ei+S+/cBhgUhn7NOyD5UKDEaWqZqfhi3ZoFvZ/cIngny95IDLnQ==
X-Received: by 2002:a05:6512:23a0:b0:44a:3458:7573 with SMTP id c32-20020a05651223a000b0044a34587573mr28113380lfv.97.1649841744977;
        Wed, 13 Apr 2022 02:22:24 -0700 (PDT)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id f23-20020a2e9e97000000b0024921bcf06bsm3710882ljk.57.2022.04.13.02.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:22:24 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 03/13] net: bridge: minor refactor of br_setlink() for readability
In-Reply-To: <76490693-ea6d-7174-0546-b9361ab5088c@blackwall.org>
References: <20220411133837.318876-1-troglobit@gmail.com> <20220411133837.318876-4-troglobit@gmail.com> <76490693-ea6d-7174-0546-b9361ab5088c@blackwall.org>
Date:   Wed, 13 Apr 2022 11:22:23 +0200
Message-ID: <87mtgp9w34.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 21:36, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 11/04/2022 16:38, Joachim Wiberg wrote:
>> The br_setlink() function extracts the struct net_bridge pointer a bit
>> sloppy.  It's easy to interpret the code wrong.  This patch attempts to
>> clear things up a bit.
> I think you can make it more straight-forward, remove the first br = netdev_priv
> and do something like (completely untested):
> ...
> struct net_bridge_port *p = NULL;
> ...
> if (netif_is_bridge_master(dev)) {
>  br = netdev_priv(dev);
> } else {
>  p = br_port_get_rtnl(dev);
>  if (WARN_ON(!p))
> 	return -EINVAL;
>  br = p->br;
> }
>
> So br is always and only set in this block.

Yes, this is much better, thank you!  I took the misguided approach of
minmizing my change.  I'll update and include in the non-RFC patch
series I send next.
