Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48512C8A95
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgK3RPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgK3RPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 12:15:12 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8764C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 09:14:31 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id l1so17178661wrb.9
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 09:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WvRF0VlGWbsw/DSFrU47JjHZExXHuzP7r+bYZQyvEF0=;
        b=pSuntXo2Flev7uaT+/GfV6ZqUn5yBEXBCW2ZnWznXu/zQvxB163Xj2qeY3YKz4zy2A
         /clpGOka2/zQCyd6xloba1KSY3IkAXoHVwgRkrCfMZQVv8OfxnbCoUxEiLsBsbez2j5Z
         tvev11K/Chc9oEVVpsDLliwthoupV6VomETj51wmiyYZjv8cSWyXJXUI5+sMFRh6apQ8
         oahCuj/PHgee6oAnvMTRVRZGkPpMDY2HjURAp5FunsSdGLsVz23gBD3axDxKv6hDSSfB
         yLp2jCPfHVOx2Y+hV8rF9GJY8wY4jTRSKYa8NxTCcJKAuWvPEh9w12LzVTa0roR1OVsl
         O/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WvRF0VlGWbsw/DSFrU47JjHZExXHuzP7r+bYZQyvEF0=;
        b=odNFqib/gtmXdyMO4a/BhdpqSbfMZHE1LvpjX9TkKrnO3EWylxtFc2APA+let5tvNW
         oKF8iH36iv5WjLJ1zhfe7JsHdV5e7eFFZ7TbUUdtF3lP8Y7MtPbplPzlbAg2mavPG43x
         PGvR4LHeANBn57YtyC5iCicqiD88NEbKYXBzxWFFjw/JlFMbD1soeTV7yheFZjaXW2V5
         UYAh2kXAlGM+Ll2prWCqH6cNvglZoJ+xakbgGyGehNErO83wm2RoNP1BkyFnnrFtifV+
         x9qZb+ZYrZwqZ/wWFEKDxlP9RQBJVv9/KPmBHHiHyU1STk6Mpr69THFgeyyJrFtPpn8R
         ejaQ==
X-Gm-Message-State: AOAM533i1qrkS8gCE3VmSH+bdUFf0/BVOi6KW8BMXoNo6YVM1Ustw49f
        n3AomEXb7+q9ToseSPLqxYQE5w==
X-Google-Smtp-Source: ABdhPJwrY2GEzB4H/AlhznC40KFHmGXY2acY+d80KAH3jAya5raDyK1E8H3omtRR1HfFfbsReSFb9w==
X-Received: by 2002:adf:e444:: with SMTP id t4mr29779843wrm.152.1606756470301;
        Mon, 30 Nov 2020 09:14:30 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id n128sm26569060wmb.46.2020.11.30.09.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 09:14:29 -0800 (PST)
Date:   Mon, 30 Nov 2020 18:14:28 +0100
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
Message-ID: <20201130171428.GJ3055@nanopsycho.orion>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <CAKOOJTw1rRdS0+WRqeWY4Hc9gzwvPn7FGFdZuVd3hFYORcRz4g@mail.gmail.com>
 <20201123094026.GF3055@nanopsycho.orion>
 <CAKOOJTxEgR_E5YL2Y_wPUw_MFggLt8jbqyh5YOEKpH0=YHp7ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTxEgR_E5YL2Y_wPUw_MFggLt8jbqyh5YOEKpH0=YHp7ug@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 30, 2020 at 06:01:43PM CET, edwin.peer@broadcom.com wrote:
>On Mon, Nov 23, 2020 at 1:40 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
>> >Why can't this be implied by port break-out configuration? For higher
>> >speed signalling modes like PAM4, what's the difference between a
>> >port with unused lanes vs the same port split into multiple logical
>> >ports? In essence, the driver could then always choose the slowest
>>
>> There is a crucial difference. Split port is configured alwasy by user.
>> Each split port has a devlink instace, netdevice associated with it.
>> It is one level above the lanes.
>
>Right, but the one still implies the other. Splitting the port implies fewer
>lanes available.
>
>I understand the concern if the device cannot provide sufficient MAC
>resources to provide for the additional ports, but leaving a net device
>unused (with the option to utilize an additional, now spare, port) still
>seems better to me than leaving lanes unused and always wasted.

I don't follow what exactly are you implying. Could you elaborate a bit
more?

>
>Otherwise, the earlier suggestion of fully specifying the forced link
>mode (although I don't think Andrew articulated it quite that way)
>instead of a forced speed and separate lane mode makes most
>sense.
>
>Regards,
>Edwin Peer


