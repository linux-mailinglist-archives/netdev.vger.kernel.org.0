Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D4249C20F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiAZD1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237131AbiAZD1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:27:38 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24835C06161C;
        Tue, 25 Jan 2022 19:27:38 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q63so17370266pja.1;
        Tue, 25 Jan 2022 19:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=V0UVDCg60iNlU3TXYumhUCU+eIfgZKaQYAacKYvjuTA=;
        b=URPGAF1+eebmy5yheslwAMSi5NlPFd6ImLfIKDXEHBcYg1D8/qsNA3o/MN1KPRpvfG
         xcS/Yqa1h7WbVvvxVXWAPsg3mKEujoKVsHQmD6nK3KP+h899TCQo/irNvXz7s/sXkvi+
         erj8N4IZEC01ArcrgcTTBoFmTJFU+YkHSWx8NwBet60vp+j6K7FrlQRH4GgIhw7gWZaN
         LJyw1uDRVnatWlPEN98nCY3tBHCC//71CQX5PCdjuSxbFSNuWpyZYhmynmGU0aExT7C1
         UsUp9TuDl7sBHnHcVJTlVIB2hx/l1MMJavEpQVlgoo/a1XD0Mv8K3f3ZMF2CG+87nUAD
         19lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V0UVDCg60iNlU3TXYumhUCU+eIfgZKaQYAacKYvjuTA=;
        b=E8Tg1zFVWywmZkFYf1I+RIXTC4FpA1Vq9iDPIS4C24WkRoYoLDD+nvRVGjmTUv7lcb
         VS+fj2chyLEakJQih6UubKIl+ePOt553A1/tl5avLBgXWEEC71PxenpcbXiG7ISc2CwQ
         Gw7K7Kjm+IZmZMB968hNd5Gl4lKhWwqRQPjWMxxXlVj79AZUL1DRHNBAzIcSLqB4BDQc
         TUXnlk6wVPFI3ScWOVNjKpGwBzAgE6VXbVSl+VobtiQBYruaDGSeuituhOY980VyawwS
         0Aw/J2VT+eRLdPWyrNLZPT82kdMVAlua+T1xYDsEf80QVVxUnnFhWeCUaIHY39Qppocn
         LAwg==
X-Gm-Message-State: AOAM530YKnxaew3/NfMKEE3w3P5cE+/PbgGmSWATGJQxPlegGlD3D7rl
        KgTrZKXu3NbmyfhQHTd/SPs=
X-Google-Smtp-Source: ABdhPJwS7HD+choTy2WvuofXSADGNgsJZVcIfmHdI0NgrDZAPR7P6TOA/cc2SpDc3b+pugS25KVrdw==
X-Received: by 2002:a17:902:e843:b0:14b:339c:f427 with SMTP id t3-20020a170902e84300b0014b339cf427mr16115095plg.108.1643167657671;
        Tue, 25 Jan 2022 19:27:37 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l10sm396846pff.44.2022.01.25.19.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:27:37 -0800 (PST)
Message-ID: <cba946ff-5ba4-b2af-118c-b1d0a7669450@gmail.com>
Date:   Tue, 25 Jan 2022 19:27:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 02/16] net: dsa: replay master state events in
 dsa_tree_{setup,teardown}_master
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-3-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In order for switch driver to be able to make simple and reliable use of
> the master tracking operations, they must also be notified of the
> initial state of the DSA master, not just of the changes. This is
> because they might enable certain features only during the time when
> they know that the DSA master is up and running.
> 
> Therefore, this change explicitly checks the state of the DSA master
> under the same rtnl_mutex as we were holding during the
> dsa_master_setup() and dsa_master_teardown() call. The idea being that
> if the DSA master became operational in between the moment in which it
> became a DSA master (dsa_master_setup set dev->dsa_ptr) and the moment
> when we checked for the master being up, there is a chance that we
> would emit a ->master_state_change() call with no actual state change.
> We need to avoid that by serializing the concurrent netdevice event with
> us. If the netdevice event started before, we force it to finish before
> we begin, because we take rtnl_lock before making netdev_uses_dsa()
> return true. So we also handle that early event and do nothing on it.
> Similarly, if the dev_open() attempt is concurrent with us, it will
> attempt to take the rtnl_mutex, but we're holding it. We'll see that
> the master flag IFF_UP isn't set, then when we release the rtnl_mutex
> we'll process the NETDEV_UP notifier.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
