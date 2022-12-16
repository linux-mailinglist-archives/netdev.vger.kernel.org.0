Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B05564E880
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 10:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiLPJKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 04:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLPJKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 04:10:50 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84648B60
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 01:10:44 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m5-20020a7bca45000000b003d2fbab35c6so1241527wml.4
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 01:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=joIgzW7yHhJ+R0UN++WS1zNmhq0v3y2iul/cy5OAxqM=;
        b=WEnIioPnUHzylCuXmpwcQbNZEBuQmBnBu4UVDchMDuLq6ppIB3nAuGZmYHux0gPN4i
         nv1l/kJc8M2reS/CUAx3pvGNehVUr2yMZJtgFyMny0nj0R3t4v12WiyhjC8X5R3L+ert
         QHCin9H2V1Psje+vZ7Yq9zbve7R1oquz9CcGKOcaRc3kNkZrYRf9N2mI3+lWalkvhocb
         UT/dlytv94y9v5fdaX0P3LG6dQQAyZ/ZjmNJaVEyK/u3eKiL3ww/iUsiqcojujxIIjEE
         mhEqPbJQMrB/G4emSIuSgzJgoIRd235/NuYuTC/ai4xra/YIAYP8Sq61H5/3Tr0A9fNS
         4Xew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joIgzW7yHhJ+R0UN++WS1zNmhq0v3y2iul/cy5OAxqM=;
        b=sh6vKbSWPGm9I2AejiRLuJ7HOC8mO/lqYbCm7dvSmZItWbqONn8FcAOr5bWzdTu/ne
         uagQ5nu0Dwey/Rde6QbY9SsaiLzWqJpstcUAfOgBngQKEW2Zquex+KxOmAPKCnmPGZK8
         BZ9dgVQLQjBeMHhyTPuZomsJ8vW+jMQNLLfiGljK+YJGqoMa2sL3J02B3iu6PmfGdhVO
         8Bbxv6N6mIROgRjcf3D2qZrLxDulZiEBKFri3scwylR+LHoMXFWZKFZ0xFPEWyXWs3sR
         cjr+VMHOFU0MhdYb1mu2Ur5z+YMUODZ0XTcztdkXub09JIvcsNUeM3GVhyPmd1BxmJUX
         6S7A==
X-Gm-Message-State: ANoB5pnAnb/NbFocXio2j1t36OU+ECKMm0fXDlNXkqyNm1MP/I9ZPj3H
        0PfGGPQXXTsZO4dwsQvE7yz9sg==
X-Google-Smtp-Source: AA0mqf65XJyNSKm1ueydzzp9EEgizLZ7okorWh1C3xFxycKQyHOP2qeTvLG6Yq/JrRF6CF6AfCrvMg==
X-Received: by 2002:a7b:cbd1:0:b0:3d1:ed41:57c0 with SMTP id n17-20020a7bcbd1000000b003d1ed4157c0mr24414551wmi.30.1671181843148;
        Fri, 16 Dec 2022 01:10:43 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z22-20020a05600c0a1600b003cfd0bd8c0asm1875910wmp.30.2022.12.16.01.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 01:10:42 -0800 (PST)
Date:   Fri, 16 Dec 2022 10:10:41 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, leon@kernel.org
Subject: Re: [RFC net-next 01/15] devlink: move code to a dedicated directory
Message-ID: <Y5w2EXhHyxxSxQCE@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-2-kuba@kernel.org>
 <Y5ruLxvHdlhhY+kU@nanopsycho>
 <20221215110925.6a9d0f4a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215110925.6a9d0f4a@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 15, 2022 at 08:09:25PM CET, kuba@kernel.org wrote:
>On Thu, 15 Dec 2022 10:51:43 +0100 Jiri Pirko wrote:
>> > net/Makefile                            | 1 +
>> > net/core/Makefile                       | 1 -
>> > net/devlink/Makefile                    | 3 +++
>> > net/{core/devlink.c => devlink/basic.c} | 0  
>> 
>> What's "basic" about it? It sounds a bit misleading.
>
>Agreed, but try to suggest a better name ;)  the_rest_of_it.c ? :)
>
>> > 4 files changed, 4 insertions(+), 1 deletion(-)
>> > create mode 100644 net/devlink/Makefile
>> > rename net/{core/devlink.c => devlink/basic.c} (100%)
>> >
>> >diff --git a/net/Makefile b/net/Makefile
>> >index 6a62e5b27378..0914bea9c335 100644
>> >--- a/net/Makefile
>> >+++ b/net/Makefile
>> >@@ -23,6 +23,7 @@ obj-$(CONFIG_BPFILTER)		+= bpfilter/
>> > obj-$(CONFIG_PACKET)		+= packet/
>> > obj-$(CONFIG_NET_KEY)		+= key/
>> > obj-$(CONFIG_BRIDGE)		+= bridge/
>> >+obj-$(CONFIG_NET_DEVLINK)	+= devlink/  
>> 
>> Hmm, as devlink is not really designed to be only networking thing,
>> perhaps this is good opportunity to move out of net/ and change the
>> config name to "CONFIG_DEVLINK" ?
>
>Nothing against it, but don't think it belongs in this patch.
>So I call scope creep.

Yeah, but I mean, since you move it from /net/core to /net/, why not
just move it to / ?

