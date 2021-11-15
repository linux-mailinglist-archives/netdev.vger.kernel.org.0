Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D03C44FFDF
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 09:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbhKOISZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 03:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhKOISI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 03:18:08 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2B4C061746;
        Mon, 15 Nov 2021 00:15:10 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id e7so19144045ljq.12;
        Mon, 15 Nov 2021 00:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vjZtW2yOA4ipiduDRxx2P8rLLSDU/9rSfz8tUGlqKdo=;
        b=ODeM+eDuFwz+njRiCpqbRTdsL13vUAE3/GTm3khgg6Y5cmejzpF68G2QLf6/Q6dQYQ
         y2Gr7HuH3UjcrRy++bBkmjuAIidGVXCDw03NO9YIfMRHnhz6o8yNV79xFr1JZqOrCgmL
         oGtK/rmwpU8FAxjhNrd0JT1Z8fM0S9yRsg7lVm2PhOaOHHD3jQ5tsGwtubH/W70INg+P
         UVPGBpYxdaGEYN7XG1rBI+QmH6iYn+ZATQRfeHzC8v1tIrrUE54/1DyjH202IuFqPOJ5
         b8Vd/GDHdd1q/OM0lV8ibkainzL2hstoX9J1CXlykJbGCVKzZ6LsSwYe2qH1z1FiDMA7
         7lbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vjZtW2yOA4ipiduDRxx2P8rLLSDU/9rSfz8tUGlqKdo=;
        b=u1tVjHsC4HW1tDzWhqg9nJG6DroJ25bpa/OnyHaqEsLLurd0LPa3FU8oueQGXDQzLP
         MBHRxSkflCx+7P8bWzfHz7itUgBU4cv7AZqq/dxhl+zDo9E+xHs/lo+hQo7wtH/eoF3h
         O/syIv0v1Tav5MGpRAMLn0QQItxNImBBPZr1zjb9/prokV+Arm0GoHHtpS+xlnbLrGni
         fSJ5e3/Vgi8l14C7e+0oxqr8h+fVkNylb6HCynH6kXrA9p82CDZvmd+5Lzp/NRqgTrc6
         U2Dbt7JA2KkINoHG54Qf4on0qWy0nUozwOEUFLgBOvGg+roA/naPo2c4HgkRFQNXiydH
         9G5w==
X-Gm-Message-State: AOAM530rrT2KFV7xKnDDztl+dPSu8pNsdpdIGDHHChOZR8WFwWc0ou3H
        R56Px6tbv7Wzfs/OnN1Vl6nypWsO/88=
X-Google-Smtp-Source: ABdhPJzMME3J70IDo9VX+mChVcZPS1XKxbNyKJOdMlu12dcqBLC05aeTVi+arQIxcWROqbMP+pQGFQ==
X-Received: by 2002:a05:651c:2102:: with SMTP id a2mr37611576ljq.112.1636964108672;
        Mon, 15 Nov 2021 00:15:08 -0800 (PST)
Received: from [192.168.1.11] ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id z41sm1496917lfu.100.2021.11.15.00.15.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 00:15:08 -0800 (PST)
Message-ID: <7a98b159-f9bf-c0dd-f244-aec6c9a7dcaa@gmail.com>
Date:   Mon, 15 Nov 2021 11:15:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2] can: etas_es58x: fix error handling
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>
Cc:     mailhol.vincent@wanadoo.fr, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
 <20211115075124.17713-1-paskripkin@gmail.com>
 <YZIWT9ATzN611n43@hovoldconsulting.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <YZIWT9ATzN611n43@hovoldconsulting.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 11:11, Johan Hovold wrote:
> Just a drive-by comment:
> 
> Are you sure about this move of the netdev[channel_idx] initialisation?
> What happens if the registered can device is opened before you
> initialise the pointer? NULL-deref in es58x_send_msg()?
> 
> You generally want the driver data fully initialised before you register
> the device so this looks broken.
> 
> And either way it is arguably an unrelated change that should go in a
> separate patch explaining why it is needed and safe.
> 


It was suggested by Vincent who is the maintainer of this driver [1].



[1] 
https://lore.kernel.org/linux-can/CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com/



With regards,
Pavel Skripkin
