Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035A43F5180
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhHWTqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhHWTqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 15:46:34 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED29C061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 12:45:51 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bt14so39349397ejb.3
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 12:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iUTyt9Sq6rb9u4uyHnfXAeMHOsUpoPL7KEc0A2kMp6U=;
        b=itx8FCjxAkvLYEutpLo1UzwHdmq31hSxHpDpgssoFJ4blSdGLoE4/F6qdjfFWVWpsz
         jq5uoBigT0iMBAULCdesisPiD7/G2hAxpbbS+XpCQBpApgKtCJlG9SFoBFOEXAKTu8QZ
         cfzd263dx5bUSNWJnRhng/gsXrzNc9xwCPe9/SKcfmXfrQbdc7V+bO3tKrEJK8O3KNXA
         FB4n2o3DXE5R/d7WeWU/nGjSUIC5I9hzJ17vgtZZntrTLsodMnOeBai4JBKG/PfAzcP9
         r++d+vOPzxyboeLZP4ZbzmMJHfspAtRfl/s/4/Vqr5XnSUw+7BzldbST1118s6GmZByJ
         fckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iUTyt9Sq6rb9u4uyHnfXAeMHOsUpoPL7KEc0A2kMp6U=;
        b=inK5VquC0sqpbHIGq8XBmdUBd3b1jB285+um0vEygDDCA28ZSBVk9aRdlww0hiTThz
         dItJYzm5IdrrKNkrmjS2Bp/RDd4i8/HxMFYW3puZoRdEZpfTssvmdVHyMd4jQpbhJ9Cb
         XiFAhmNn8Bf2a//Yh0EYZv9k3s+7mIJIAgbu9OkGjoMmeTFSxm26J+vlx7BA/1BbUdQk
         ZRg7oGUd1Wn5n+jWOv38uD9JB9el+d09hh3R/asISfTKZHVgfpfh9mdH3QHsotHTyX1H
         Qx4aN8PqKKinzFg8yeBUoJx1RiYQAmT2gy/uB9J7H+2iRS8i8VwlcasycT97PCUvQeVZ
         Dt8g==
X-Gm-Message-State: AOAM533vncJ2ZQeNR6pcxa9ZY3/kTTz6TdIm++BBZq5cIrqCsXUxQoIA
        YaCVkkdvbQA0RBG1NsdOhXpP4N8TrGk=
X-Google-Smtp-Source: ABdhPJxUrv7V/TaVrok43JwCmTiYlhkwjc2VmX1/oEW9lC8uLcWRe/Zc1JCqy7MaM3mYZ4moIwPOjg==
X-Received: by 2002:a17:906:3708:: with SMTP id d8mr3794887ejc.310.1629747946961;
        Mon, 23 Aug 2021 12:45:46 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id c28sm7922624ejc.102.2021.08.23.12.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 12:45:46 -0700 (PDT)
Date:   Mon, 23 Aug 2021 22:45:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 0/3] Plug holes in DSA's software bridging
 support
Message-ID: <20210823194545.5lczueo6jspu23u6@skbuf>
References: <20210823180242.2842161-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823180242.2842161-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 09:02:39PM +0300, Vladimir Oltean wrote:
> This series addresses some oddities reported by Alvin while he was
> working on the new rtl8365mb driver (a driver which does not implement
> bridge offloading for now, and relies on software bridging).

I will resubmit for 3 reasons:

- I left an unused variable:
  https://patchwork.hopto.org/static/nipa/536059/12453371/build_32bit/stderr

- After wrapping up the testing with unoffloaded bridge ports I got a
  kernel panic when rebooting the board. This is because in
  dsa_port_pre_bridge_leave we call switchdev_bridge_port_unoffload on a
  NULL brport_dev. We must only call switchdev_bridge_port_unoffload if
  dp->bridge_dev is not NULL.

- I need to correct this phrase in the commit message of patch 2:
  | In turn, having dp->bridge_dev = NULL makes the following things go wrong:
                                  ~~~
                                  != NULL
