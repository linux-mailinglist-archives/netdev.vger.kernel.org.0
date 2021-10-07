Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6BE425D96
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbhJGUeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242592AbhJGUeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:34:02 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABE3C061760;
        Thu,  7 Oct 2021 13:32:08 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id i20so11731847edj.10;
        Thu, 07 Oct 2021 13:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gNfNT4ZVYh2wlx8jH6qTQIgLI6I2KmqQwh/kapU5aQE=;
        b=fmpK/Uk8y8/zFkvhdtk0qWTP8q5HtULB1goDYfvUd8Dt6XvN5FGtuBGgGOKAbdKCP6
         P/qSiJZk7Pz+l78Ml9sj1WB5RwavFkWm6ZiCYEdsBgas0NTSriP8yi91z5d2X3O2f+50
         Ue+Zk733/XE17KimDCnCB3VDcVvmHFR0UGI4f0tJCQ8CEOHDWTfZlaokxBYxCvH5xQrz
         AdKovsBNQp5EtOyb7VFZGC4FVx9SmzPEqEoOeH0TyA7fZW4iBlPsVfU9/xtkTunW4S9e
         N8bdM7z4wxt7ihpbPmyzL6lb9RKWkXwnApzJbZuAqsgfuwn7hFRK46O4MDqmtvvWqwDk
         UIuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gNfNT4ZVYh2wlx8jH6qTQIgLI6I2KmqQwh/kapU5aQE=;
        b=JwcmGu+b8w6it7kcnP/jy742rqg390hgWvX4a+4EuDynd9I9p4uPnu9I+s5qyOJPfL
         LwftnIxUQPfpZ1DDkRghSJrF1duBikeYEqXiL8G+6O+a6Mz7dC7h3ucgOjIyWSsKpwfy
         vR7cIYD5I1PMjPVzYuCwQhhOifaVqTUxVr4pSk5+CyMp9XLPJ7+vD9MH3TlnIDZIRFi1
         +eRmEdoKItsl/82u4vlHe/rjtuJx8DgADgSSzI6ABz0bnGAoHXmGjX+RAkReEQVbtKxy
         TzC30paI1FA9KiaSw4hCRHTiTzofePZIXek7LwxiblX1nhkIA5uKn8NN9D/mC0XxqzVM
         zCoQ==
X-Gm-Message-State: AOAM533tKUogZQx70M+S6uLfHtuGdCl8AxlcvhCMgO0H5vVnEZ40WW/V
        64k/zWD3DZR63djfOB1+mrs=
X-Google-Smtp-Source: ABdhPJzTE3psm33CAdujVJ6nu/517WvMuODmUoGKCj5nAZK1w41/hkQsTjClAwx4cZLaVk/lNwubug==
X-Received: by 2002:a05:6402:3186:: with SMTP id di6mr9220894edb.225.1633638726885;
        Thu, 07 Oct 2021 13:32:06 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id nd36sm162139ejc.17.2021.10.07.13.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:32:06 -0700 (PDT)
Date:   Thu, 7 Oct 2021 23:32:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 net-next 08/10] net: dsa: microchip: add support for
 port mirror operations
Message-ID: <20211007203205.wpmh4uhg7epvke5i@skbuf>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
 <20211007151200.748944-9-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007151200.748944-9-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 08:41:58PM +0530, Prasanna Vengateshan wrote:
> Added support for port_mirror_add() and port_mirror_del operations
> 
> Sniffing is limited to one port & alert the user if any new
> sniffing port is selected
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
