Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9512CA13E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 12:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgLALXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 06:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbgLALXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 06:23:39 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE21C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 03:22:53 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id qw4so3298211ejb.12
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 03:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sAoW9jmeU33ekfpk/N3Tsru/gF90cbc79yNaItV7LY0=;
        b=K0K/OYESg0yD0/iGYyiHxFAtVGUKHbNX1oRPL4hhqFJs60dXfuHM0HesnYb7Kstcyk
         L10o2boCoj0hv65KcbkFq4KT+VRki0vRzmFNh5nhs9yALjqMSOp/SBE1DmoaYW7OdPXM
         JvjBVhjhuHArtRz5Oa3XlNgY+boCFmh641x26L6AYsO1gVpeIa0ni262VakraAZTBr82
         hHOSi6YsACYQVPz2B4t+jqpXBJZ6IUKnbzaEAMNZH6Fw30BjilFLNOYrt784qQwbugli
         vtBpdmMq4/gaiZnOs0vdBG6mHRYwFZ15jIUYE7DBwklXtE5GbaTmu0kyJtDKvxz7b8cN
         z3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sAoW9jmeU33ekfpk/N3Tsru/gF90cbc79yNaItV7LY0=;
        b=p55gvO5XX2DRnvKGOtiSYOS7BMo0xi+CIc5woD2O2l6myjIG7NcJVIfmBb0I1Q8kmo
         3Yow0/fg4PU+VSjEP5AR7Dw+yxLg+q3SgKT1h5Cx1d3T9delgm7TOQNoAiqL2KwKJ4x8
         0zwNF/RoIrEkwDjH0Hj2A2G+RNfcqgdkzv8cE8Fjs0l62EwFxLVTwJL2NloVNxNcDQ12
         /+YuGeCai0N+H/P7tySuXvNSiAF4BvDJyUWyixFviT63vIMeeAAkGy0Yn1QWaeEBQ2A0
         KbQcbgRDs31bh/BtrjaFkthhaSCH/X19ybPAx/h8i+h4fT0TMS6iOLV1QbpKaEEwEbt7
         cgEg==
X-Gm-Message-State: AOAM533DcmQZZCPkBjy64SkXEgmSKOp02LnOSt2LJnlJ34AT7Xi7WHbK
        Lw7/xnUDuhg+id8UJpWWQPLnaA==
X-Google-Smtp-Source: ABdhPJzqgKI8QZDmNvJftIn9j28f8pseE/1ZmeajRNW7EPJZFlJW3P4D5m9tL6eYsebF9gswC7htLg==
X-Received: by 2002:a17:907:2108:: with SMTP id qn8mr2500234ejb.127.1606821771905;
        Tue, 01 Dec 2020 03:22:51 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d1sm669369eje.82.2020.12.01.03.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 03:22:51 -0800 (PST)
Date:   Tue, 1 Dec 2020 12:22:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201201112250.GK3055@nanopsycho.orion>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <CAKOOJTw1rRdS0+WRqeWY4Hc9gzwvPn7FGFdZuVd3hFYORcRz4g@mail.gmail.com>
 <20201123094026.GF3055@nanopsycho.orion>
 <CAKOOJTxEgR_E5YL2Y_wPUw_MFggLt8jbqyh5YOEKpH0=YHp7ug@mail.gmail.com>
 <20201130171428.GJ3055@nanopsycho.orion>
 <CAKOOJTw54DxitbYHW7vNVWRv9BbsdmW_ARTgpMu5HBVjkTeQ5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTw54DxitbYHW7vNVWRv9BbsdmW_ARTgpMu5HBVjkTeQ5w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 30, 2020 at 07:00:16PM CET, edwin.peer@broadcom.com wrote:
>On Mon, Nov 30, 2020 at 9:14 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
>> >> There is a crucial difference. Split port is configured alwasy by user.
>> >> Each split port has a devlink instace, netdevice associated with it.
>> >> It is one level above the lanes.
>> >
>> >Right, but the one still implies the other. Splitting the port implies fewer
>> >lanes available.
>> >
>> >I understand the concern if the device cannot provide sufficient MAC
>> >resources to provide for the additional ports, but leaving a net device
>> >unused (with the option to utilize an additional, now spare, port) still
>> >seems better to me than leaving lanes unused and always wasted.
>>
>> I don't follow what exactly are you implying. Could you elaborate a bit
>> more?
>
>Perhaps an example...
>
>Consider a physical QSFP connector comprising 4 lanes. Today, if the
>speed is forced, we would achieve 100G speeds using all 4 lanes with
>NRZ encoding. If we configure the port for PAM4 encoding at the same
>speed, then we only require 2 of the available 4 lanes. The remaining 2
>lanes are wasted. If we only require 2 of the 4 lanes, why not split the
>port and request the same speed of one of the now split out ports? Now,
>this same speed is only achievable using PAM4 encoding (it is implied)
>and we have a spare, potentially usable, assuming an appropriate break-
>out cable, port instead of the 2 unused lanes.

I don't see how this dynamic split port could work in real life to be
honest. The split is something admin needs to configure and can rely
that netdevice exists all the time and not comes and goes under
different circumstances. Multiple obvious reasons why.

One way or another, I don't see the relation between this and this
patchset.


>
>So concretely, I'm suggesting that if we want to force PAM4 at the lower
>speeds, split the port and then we don't need an ethtool interface change
>at all to achieve the same goal. Having a spare (potentially usable) port
>is better than spare (unusable) lanes.

The admin has to decide, define.


>
>Now, if the port can't be split for some reason (perhaps there aren't
>sufficient device MAC resources, stats contexts, whatever), then that's
>a different story. But, even so, perhaps the port lane topology more
>appropriately belongs as part of a device configuration interface in
>devlink and the number of lanes available to a port should be a
>property of the port instead of a link mode knob?
>
>Regards,
>Edwin Peer


