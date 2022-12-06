Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADCA643E11
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiLFIFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiLFIFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:05:49 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CE11A390
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 00:05:45 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id m18so2700188eji.5
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 00:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5s1Mkx2mkgfnuULoTHA359Ui9dRw1Uq4cQGOrjlBNjw=;
        b=sRH5XSPuVtbLbFvMDJ58Y20zWngdede7stlqQ+4fgGBBJhwBJs+Bltc6s+VRxM16io
         1/hY6e79rrtxdjvg9geSofOnKBhy7sOHQGQmH+FjWovubYCB+bk0qJiyij1LAVt5QQXX
         ldzzU6SWQ2+QK6a2/I9T4+KgJmfm0MzXWn8+SsrctZhDUhIkDfa0EqRaglkFm8rDYi45
         6b4VhxGabUoIFFdo9SeLVYcWfH/n9WvH7tEuqHLli869WpaHLSzZ9dIW+IYvYScZoxk2
         5qoH7IOu2HPU/4rpgu8he684uidsScAUTZsFsCW7YzDs70YdqIUOCo40EsCeZ3MDL6bO
         h9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5s1Mkx2mkgfnuULoTHA359Ui9dRw1Uq4cQGOrjlBNjw=;
        b=dKM9hPlw76Dq+2qcukKvw39d1GHUubIXqeOMd8wpN4I97umhut/y5g5i89vyi6Jaha
         ZrAv0SoZl4Okzdc761qNJIl11MrtFa8+hlNgacDX/zmre6MQ02S+OVKZgdayBCrll1mg
         /HSQy47a4oSp57f+c4mFvJ0Y36m4KArXW64rgk6CwyfJ8psqhHvYiutbC8ETCohaFdv9
         +CzLGW19hbm8KTcb42rIvLjBC+WctwObVMzWIh9+Wot8PlFVIeVuAJCanrQYtWPqFVm1
         /QiQ3+RYOVAzKYu+kIuBCSsZeOstqgRLxC2FqCHVh+AqFT5aN6kAzMAOFf0RMN+1zFis
         UcZg==
X-Gm-Message-State: ANoB5pmeKyUJYGkG7wXhQJgLfIWplKlw3GjqluzdMDm3zunMgP4Vtb7h
        JfrmXy7dczroECT/l9/crCc4yg==
X-Google-Smtp-Source: AA0mqf5XP+2AD8+HN8tqPYT5IK5AK7mVJ9T3zU3MlGJv3UEVxP3udvf3rv72791SRqseXo/0NUsM3g==
X-Received: by 2002:a17:907:8d1a:b0:7ae:6ffe:a118 with SMTP id tc26-20020a1709078d1a00b007ae6ffea118mr71626627ejc.250.1670313944392;
        Tue, 06 Dec 2022 00:05:44 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e23-20020a1709062c1700b007305d408b3dsm7054521ejh.78.2022.12.06.00.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 00:05:43 -0800 (PST)
Date:   Tue, 6 Dec 2022 09:05:42 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, LiLiang <liali@redhat.com>
Subject: Re: [PATCH net] team: prevent ipv6 link local address on port devices
Message-ID: <Y4731q0/oqwhHZod@nanopsycho>
References: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Dec 05, 2022 at 06:46:05PM CET, lucien.xin@gmail.com wrote:
>The similar fix from commit c2edacf80e15 ("bonding / ipv6: no addrconf
>for slaves separately from master") is also needed in Team. Otherwise,
>DAD and RS packets to be sent from the slaves in turn can confuse the
>switches and cause them to incorrectly update their forwarding tables
>as Liang noticed in the test with activebackup mode.
>
>Note that the patch also sets IFF_MASTER flag for Team dev accordingly
>while IFF_SLAVE flag is set for port devs. Although IFF_MASTER flag is
>not really used in Team, it's good to show in 'ip link':
>
>  eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>
>  team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>
>
>Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
>Reported-by: LiLiang <liali@redhat.com>
>Signed-off-by: Xin Long <lucien.xin@gmail.com>

Nack. Please don't do this. IFF_MASTER and IFF_SLAVE are historical
flags used by bonding and eql. Should not be used for other devices.

addrconf_addr_gen() should not check IFF_SLAVE. It should use:
netif_is_lag_port() and netif_is_failover_slave() helpers.
