Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E58338FC3
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhCLOWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhCLOWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 09:22:34 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EE0C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:22:34 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id c10so53596896ejx.9
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x00L4ypjQvflBM+ls+7UW8AaP6IEJEOU+og8wpHgukc=;
        b=KQiyeopfgTXh9G7P1XfCSIKL89+dTpSQzkRpcqe+9fKWbs6k9QElAtS9YKmvjR/DVU
         pMRtCUlzW3Whd6s2AkxyCqRcSvVFyanpIcRDdHLFrerFjahc9ClBpZ1lyHYGWNh38eux
         Gc143xfAwfyBbKKi6ITSAF3cKD5xJdB5FTXx8WGOq/HDY7+u3BjZkAbGdibqYqWNPST3
         gA6obkgakLCH7LBxdW7rLnyQJvTwc8m+TVnZ0jDEGBU8GbP1oHSOVdrvW6iDaBKbBiDV
         XqcVsXiyI4lf8y7EcvPx0oAhE2pbcQm0/p9S8rIUeWn8cHydX0oB1h6AiV4WyYvpOzPJ
         pfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x00L4ypjQvflBM+ls+7UW8AaP6IEJEOU+og8wpHgukc=;
        b=TY9hjfurwhHh7vXfqlu3s+Zu7GJXyvX6jheUQR51WzYEzc5pZIZVRxep1WlA9DG44/
         Jkwl8fl9ruEoT5SUWkbuFMhUq7ft4PMwMN/rtRhDujGB6TrIy6nd1m1p7KsMtVR8+HKF
         kVfTdSgI9eAaLnxHuBi3/soVWpzTLtPESA/zP/neEigerChW2fIEIhcMwg8+JLcPPykY
         BwI+H5Tx9XcKp721fwuiWAz5iAZ9K676ettNfmWBYzQ3GbGbN8t4TILXiJsE0YzBGKlg
         VKkiE/xkfZfkdjOYOVecnqrs2B901pH7Rv8niZJWReLrP/3L6/jJ1CFG1bV8hazfcLxP
         t/Wg==
X-Gm-Message-State: AOAM531QJvs27yViJsVhuEUExq5QHFwcisZfF9wkzKLbZ6oEsIbnzuN5
        P+mgOOQMof2L7LRL/BbhuS+Ob5U1GBZovQ==
X-Google-Smtp-Source: ABdhPJzKJym8jhGTgO6emut9iGQFGoGosy8pErqjn0gyLHb/arekfaQ8Q7cBmXT3OX42rS+woRw5Tg==
X-Received: by 2002:a17:906:3850:: with SMTP id w16mr9017717ejc.286.1615558952837;
        Fri, 12 Mar 2021 06:22:32 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id p3sm2768473ejd.7.2021.03.12.06.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:22:32 -0800 (PST)
Date:   Fri, 12 Mar 2021 15:22:31 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 net-next 0/3] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210312142230.GA25717@netronome.com>
References: <20210312140831.23346-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312140831.23346-1-simon.horman@netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 03:08:28PM +0100, Simon Horman wrote:
> This series enhances the TC policer action implementation to allow a
> policer action instance to enforce a rate-limit based on
> packets-per-second, configurable using a packet-per-second rate and burst
> parameters.

...

Sorry, I missed CCing a number of interested parties when posting
this patch-set. I've added them to this email.

Ref: https://lore.kernel.org/netdev/20210312140831.23346-1-simon.horman@netronome.com/
