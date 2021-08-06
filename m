Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9132E3E29DF
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245593AbhHFLkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245615AbhHFLkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 07:40:10 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEEFC06179B
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 04:39:55 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id s184so10920951ios.2
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 04:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jGoUnni5kxVG5IT0jTBjoGzrOp/7oT0lrp2a+08Mgi4=;
        b=AZv4+Ep0PzWeM2wPhamAKDgzx5fxr8WYldrctzjn6yYJXGS3hxVz4jkHaKY3ItVNAO
         EPY7Y3n9s0d6ON0KxmuAMZvknqqwJBKXCO5Y2Gp9LbjDYfqTAxTxTaMMzLLiU6prU0GS
         BDtaqH1pI2/eHJd8u3p1o67ZESjkBQY01SIPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jGoUnni5kxVG5IT0jTBjoGzrOp/7oT0lrp2a+08Mgi4=;
        b=gD652jjhK855HWVKZxsnKssiGXPExIcDLrdiDFyRegM8rwvI/uO1hERTOzrIz3+56G
         H1KuJdR9+L9UeNCDqPYsfW0zmWCo/hu54HbBXew3hAK7XhgqmEtuQvx/8Ql0oIshN/l0
         QGqnWHHDbtd4HEDpfqOyn0q/jWje0eIdo7UNaUR5rMtHyRKGCG9oSJ/Aa4iihIEMXBqT
         lXYIfHX3drjQUp/AFvaFoOpJ2XTB7AAIHb6/0LhhTXQsqClvJFHUUFJlavnSIrbT+31F
         rrJh9mwufm3tUIsUu+XRYnv/4Ddk0WRIMINYL/6fKho28Wf37b6Cq33ah59dtolB/Bpj
         dUGA==
X-Gm-Message-State: AOAM531R6NlpKT5OnHMaonCCDB1j5LzMxE3tUU/srDvSwLcC04d+0F2Q
        O4czqMevSC3/UOah7F1S1uvasQ==
X-Google-Smtp-Source: ABdhPJx/Zyf/TEIEmy6L+L8wXwSG/Ib64f+/Nl4tal61GcIYvndGferAMqPha8VNXmO+RFTCfhLtGw==
X-Received: by 2002:a5d:8b03:: with SMTP id k3mr78622ion.203.1628249994514;
        Fri, 06 Aug 2021 04:39:54 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id j18sm5131004ioa.53.2021.08.06.04.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 04:39:53 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] net: ipa: reorder netdev pointer assignments
To:     Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210804153626.1549001-1-elder@linaro.org>
 <20210804153626.1549001-3-elder@linaro.org>
 <20210805182712.4f071aa8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210805184148.46bc33e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <9b87849f-6008-2fa4-3d5e-2c7269f5a597@ieee.org>
Date:   Fri, 6 Aug 2021 06:39:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210805184148.46bc33e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/21 8:41 PM, Jakub Kicinski wrote:
> On Thu, 5 Aug 2021 18:27:12 -0700 Jakub Kicinski wrote:
>> On Wed,  4 Aug 2021 10:36:22 -0500 Alex Elder wrote:
>>> Assign the ipa->modem_netdev and endpoint->netdev pointers *before*
>>> registering the network device.  As soon as the device is
>>> registered it can be opened, and by that time we'll want those
>>> pointers valid.
>>>
>>> Similarly, don't make those pointers NULL until *after* the modem
>>> network device is unregistered in ipa_modem_stop().
>>>
>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>
>> This one seems like a pretty legit race, net would be better if you
>> don't mind.
> 
> Ah, this set was already applied, don't mind me :)

I really appreciate your review and feedback.  Applied or not,
it's valuable to me.

					-Alex
