Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3B02C0265
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgKWJka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgKWJk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 04:40:29 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405CCC0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 01:40:29 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id h21so16579410wmb.2
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 01:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tGsmN+GKaX7yYJkwfaBxmDkjMYGs2JFf+vI7xCtXl+c=;
        b=Ipo/cMAQ0WeveU8fNhd76pL0nqY6B7mRDA7/pjLLrJNoGJmMhgr1aq6rG3o8B90y4/
         sUzKAyfnPd7J7x8yidEqCb0AWbt2/s2Q+woNHiFpy1RRG7T7vaSG1g0mC1N9K45omEzR
         piKmOEGFku9pwIdHhqBKR5OECjje61vFWp5Q6A/+USricHVkfcmue5w3Fcafhxq2W35C
         G3PK9IFe2uKJ6gsssS1lkZXJakVbyUPWb0n8QwNriS32nAkGyVMTf5Up3IoLO2wEkyMV
         MmjPi1dHY5BfyqjJdnht5K2/9aSaM7Zoj16dAls90pRW4tqpXzTyK64bHeQNUpwuql6A
         zRZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tGsmN+GKaX7yYJkwfaBxmDkjMYGs2JFf+vI7xCtXl+c=;
        b=V6MWx7/x8KwgZsETrcNc/o8bdNHSYLRjJnzY7Zzg3jVIlpMQ5YpYZh8T+Y/eEeiBrR
         a8HmHqVLZEW2XQqCO+JQmm91N82of3L8ZRpba6ZC1Xi96viU+pmNU23tq/da0bxmWRCT
         zHs2uClaElwfZ8oQ5bVQ0QM5eCsVPnEZqe1GU5OeT2a5iRCsddW+CNnT5iiEhe/F5odN
         bi1A/3A7qvvvlWYDUH8UpypCVAbJENhUE+i6XSIjFQPII4nvPqG42OP5U48dSzr0Cl+9
         pj7G/c/AMTEvXKJ55dVw8eWzZHw7AU4Cn3Yscmbety2QiXNEhkwLVdm+3SS25r2BHAI2
         Y9QQ==
X-Gm-Message-State: AOAM532kznZTzQc79mLG437OvHBpJxfjeIj6VM6zj8TKXpevlQWJrWlN
        oRy46ZjwFe7cUqiWBbwpZ9xZ1g==
X-Google-Smtp-Source: ABdhPJxPGevhCi533Bj22BTAiWRzndS9Y8wMAOe97w1sXurxVvRQb1K1zDhAqE/t1baES6L7DkkmhQ==
X-Received: by 2002:a1c:b487:: with SMTP id d129mr23614025wmf.38.1606124427984;
        Mon, 23 Nov 2020 01:40:27 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id e1sm15211664wmd.16.2020.11.23.01.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 01:40:27 -0800 (PST)
Date:   Mon, 23 Nov 2020 10:40:26 +0100
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
Message-ID: <20201123094026.GF3055@nanopsycho.orion>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <CAKOOJTw1rRdS0+WRqeWY4Hc9gzwvPn7FGFdZuVd3hFYORcRz4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTw1rRdS0+WRqeWY4Hc9gzwvPn7FGFdZuVd3hFYORcRz4g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Nov 19, 2020 at 09:38:34PM CET, edwin.peer@broadcom.com wrote:
>On Sat, Oct 10, 2020 at 3:54 PM Ido Schimmel <idosch@idosch.org> wrote:
>
>> Add 'ETHTOOL_A_LINKMODES_LANES' attribute and expand 'struct
>> ethtool_link_settings' with lanes field in order to implement a new
>> lanes-selector that will enable the user to advertise a specific number
>> of lanes as well.
>
>Why can't this be implied by port break-out configuration? For higher
>speed signalling modes like PAM4, what's the difference between a
>port with unused lanes vs the same port split into multiple logical
>ports? In essence, the driver could then always choose the slowest

There is a crucial difference. Split port is configured alwasy by user.
Each split port has a devlink instace, netdevice associated with it.
It is one level above the lanes.


>signalling mode that utilizes all the available lanes.
>
>Regards,
>Edwin Peer


