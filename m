Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2EF343DB7
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCVK0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhCVKZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 06:25:39 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C891AC061762
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 03:25:38 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id a1so20366045ljp.2
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 03:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=BNpbhkpWxvRD4s0rKc0kS/zu20HOAYLd5FaU7tpZIbY=;
        b=H7Bw476kMpokOGMbl0/mhGOypjDnqSOFvkPi4XbOtdGlU5scaVM8w9SZvd8a3dh4Fe
         a6EU2uwpm08C9NMnG9IVPzdlj8Gw+cvXLHzZp6rHNn527NQc1ksDbxtF9txdafq27AY5
         Hi0/PwFoxnf5pOZ7uzn9jvz6RxUfZH91cUJNj8zJ3uCEXu2Km9RUwaFtIQoIZ/m06CP6
         6Tt6PVjbzdih5S7RLP1pBiAHZdZos9CXJtWBAKatyCI88wdDqItzTyFNdSTdLEQkrsO5
         E3y1OY0MiKnC69TwtAqL9n7AwT/zX7azJJhy68brXGZUGzWWUHDhzNXZnpIFIs/6LsCW
         xlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BNpbhkpWxvRD4s0rKc0kS/zu20HOAYLd5FaU7tpZIbY=;
        b=ChB3DcvNQBvPNq6r26XVXph8WF8u/SoaPdfDcSuJrXJVg5NaOW3UmFZUWKx1khOMZl
         AW1G1DgVi8qnTc4y8lz6lKkNUbNGlkrAkBjtXAEO/jzT/d/cSkN/49JuqIM+hXTdUMHP
         oYn5D+QYjvBggKW7ikLD7gLLoPQluqZZchF9P9NxjWaZ+RXuRWSGrrB1vxoAlvV+weW+
         nRpkZJ+xxyX95ke+ihDlg0wTYf3+GkeOPYijwuJdW/wZ4QPRzG7ZusdMJWHx4qzpdCm5
         Hd0vMTriCDd3+aU6kVD08xZSfDvhPmF8Z9IbG3kOf7vhKBL14qHErbmfX8NIuY2mj6tV
         XHGQ==
X-Gm-Message-State: AOAM532Siem9/UJ4WVXEGO4m1QFTjVOWNUsSfrtrfCwdBMzjDThBPP6F
        4ioSxkVVImgvXVg2PWiPeEh9Hg==
X-Google-Smtp-Source: ABdhPJzF9i6/20cRJAGueFcYXoDG+YjASeeOEKPSmi0jwcQJLAxxOXXseHWIrLmeQE4pQuy6eifDig==
X-Received: by 2002:a2e:b17b:: with SMTP id a27mr9437202ljm.62.1616408737317;
        Mon, 22 Mar 2021 03:25:37 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j15sm1522505lfm.138.2021.03.22.03.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 03:25:37 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 02/16] net: dsa: pass extack to dsa_port_{bridge,lag}_join
In-Reply-To: <20210318231829.3892920-3-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com> <20210318231829.3892920-3-olteanv@gmail.com>
Date:   Mon, 22 Mar 2021 11:25:36 +0100
Message-ID: <87blbbo57j.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> This is a pretty noisy change that was broken out of the larger change
> for replaying switchdev attributes and objects at bridge join time,
> which is when these extack objects are actually used.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
