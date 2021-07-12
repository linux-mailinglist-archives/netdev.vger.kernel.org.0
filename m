Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334463C4114
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 03:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhGLBqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 21:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhGLBqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 21:46:54 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9FBC0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 18:44:07 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id u11so22319456oiv.1
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 18:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=87XHT5oVDH2rUpFSmje16J+rEtId447I9o2YqnnRyAI=;
        b=JcNtIgP7keH2nwWZXfswqYgzpcZek2wuOaebJYpoEyXNFdkP0SIrc1PLrzPdwhPlDo
         tIjuvpSzeW79j8vQmXR2U3c+m/WMP9sCgDzkZ57eHYmYqIm0HmM/D3tKwJEVD2VQG+8Z
         sPsM5uqe99fiMd8Nx6dWdu6fpwCp45OMUUGkubum5gbTsd/VzZa9UNS1zG4qyWPUfogD
         AtPGAh2sXIIgOvaif1SRrs8CBV+5WZgVi1AMd9lLj/39F656fT13mtAd28h7JPrbMzQy
         QG5AR+LT1uHjruS0So+XNcWRNrlG3JGF3FSmEk9aDUDlFx2mOf8j8OTQD1E7WTjjtHmy
         FFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=87XHT5oVDH2rUpFSmje16J+rEtId447I9o2YqnnRyAI=;
        b=c2xip53yFgPjIk/zFZsWbGQyuogrgteLR+fpktsU/KR11nc397Z+hI5fwzsRLI9ZQA
         r7I3O2fOrlvzXri6Tisq/rq11KkT+ogQbts1irRmYNndcUQOt5R5W0eTDb5tWh5STKyC
         VeOEtk0JgSKErzzh451uNx/3Gmv2YC0C4T2iGIGK2tKvAxQOu994aFoOJ4r9GuzLXLTb
         tXDN/dcLwV4DlFA8M/X37lEITnlGHIsbRHEzFxYt+zlgwHqTzSKEcRRWzd42/93MigHt
         XDW1klN73cvuHNbfPP2ClwyJweUtyui7AI3XUzxQ0p++BC/d+ULiqWT9juGvmKzfM4+e
         j4Dw==
X-Gm-Message-State: AOAM530fmzrupx0JXET9jCLGYo7A4pvZGSc8OLKaG4Ci9L0+PzR6CatD
        s+qRcskwXKXxzhNATRNKaZQ=
X-Google-Smtp-Source: ABdhPJxyqwdrIofFEOL9NL/R2Opd2Bvy1cjyi/tq0X+APSXVgwGK/qzPC91uaODjoikxVY0ZoyZVKQ==
X-Received: by 2002:a54:4593:: with SMTP id z19mr2443696oib.47.1626054246209;
        Sun, 11 Jul 2021 18:44:06 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id v13sm2255415ooq.30.2021.07.11.18.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jul 2021 18:44:05 -0700 (PDT)
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool
 op
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        toke@redhat.com
References: <cover.1625823139.git.pabeni@redhat.com>
 <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
 <20210709125431.3597a126@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f99875f7-c8c2-7a33-781c-a131d4b35273@gmail.com>
Date:   Sun, 11 Jul 2021 19:44:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709125431.3597a126@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/21 1:54 PM, Jakub Kicinski wrote:
> On Fri,  9 Jul 2021 11:39:48 +0200 Paolo Abeni wrote:
>> +	/* accept changes only on rx/tx */
>> +	if (ch->combined_count != min(dev->real_num_rx_queues, dev->real_num_tx_queues))
>> +		return -EINVAL;
> 
> Ah damn, I must have missed the get_channels being added. I believe the
> correct interpretation of the params is rx means NAPI with just Rx
> queue(s), tx NAPI with just Tx queue(s) and combined has both.
> IOW combined != min(rx, tx).
> Instead real_rx = combined + rx; real_tx = combined + tx.
> Can we still change this?

Is it not an 'either' / 'or' situation? ie., you can either control the
number of Rx and Tx queues or you control the combined value but not
both. That is what I recall from nics (e.g., ConnectX).

