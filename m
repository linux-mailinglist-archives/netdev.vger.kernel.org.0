Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523BB20EA99
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgF3BCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgF3BCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:02:37 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42E1C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 18:02:37 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t4so3017937iln.1
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 18:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XeuAEJ6F4qGbUXxI3k7ZEhXMPuXG1rflAk7Rajdg7vc=;
        b=fEBFm8o8Xd0YzPQyeY9SaA872zwIod+qVof7Ablh9IF29NSS9oDY203eC7GBqGb0br
         gzAmC+uDgwy6EBBd0x9dt2p7NyTFZ4e7IudoVWp5+x2CpRb3R5svfA17dPLQzOeTxyTr
         ks+2qxSSeXIpU+HlIwuYRhymluxxx8HUORPaJwLl1zN/7Rxe0o0XJQ6c8UT4RIWQYe2G
         wweV/I8TOKrslqueyDf/49VXtpmsL06/vW9s8eph3pfQOzIGfyQx7nuld7tTJ7B6Hv1F
         SgwwkmE64vpHjJLB03iahhJXGv7aulyQrftY9KcPCUJd1Ir0uIbIiXRpG+eH5K7pRVei
         0Lbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XeuAEJ6F4qGbUXxI3k7ZEhXMPuXG1rflAk7Rajdg7vc=;
        b=ZgiqqoENfwUtl+AAcBrSzS0FSX/kI3viwzIKvJvHVyI/5p+wRLg+uXlqMJMV3xfHNN
         +SZDFtecukLmzAK9DoyQAPbyOT9QpwOcynq2Sm45zd00FQGUQ0CmzF4LYCrRHrNHElx9
         IEZ5GM0NRoy9wGZVpMZcvkJ4ktl3dab0xSqIxninDCUv3FYcHqACOMBK8iNdhNu63P/q
         2SIt4pX38WpKjqtDHcaD5ErLX0jX1JugfMhVTiNf/7tz8OVGJSI6aOAQYFCZnTF5YVjs
         ztONL+oDkTs6d158EpPEpq8cVMg+nb1dWixS0qTD5rVtvcPUDOmsVGtbf1e1+rtWD6cC
         rOfw==
X-Gm-Message-State: AOAM532zBGMFy6aheR7NhfkA/pO1KrdJ4mw1kGiv4APHCBSCYI6T0gF4
        pjFcZRM3bZ/aNAAaEHks14OfAlu6u8I=
X-Google-Smtp-Source: ABdhPJx9186hwjMiBQNNLPoIbe4pAfgxSYxb9AWbMLIA6uTup2bfwKI2mKj6DW6FN4b2yDKuUD5N/Q==
X-Received: by 2002:a92:bb57:: with SMTP id w84mr248609ili.104.1593478957059;
        Mon, 29 Jun 2020 18:02:37 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id s12sm908503ilk.58.2020.06.29.18.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 18:02:36 -0700 (PDT)
Subject: Re: [PATCH net 2/3] net: ipa: no checksum offload for SDM845 LAN RX
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200629212038.1153054-1-elder@linaro.org>
 <20200629212038.1153054-3-elder@linaro.org>
 <20200629171046.4b3ed68c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <bada706f-779b-9a53-0d92-c0b79f99f723@linaro.org>
Date:   Mon, 29 Jun 2020 20:02:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629171046.4b3ed68c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/20 7:10 PM, Jakub Kicinski wrote:
> On Mon, 29 Jun 2020 16:20:37 -0500 Alex Elder wrote:
>> The AP LAN RX endpoint should not have download checksum offload
>> enabled.
>>
>> The receive handler does properly accomodate the trailer that's
>> added by the hardware, but we ignore it.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> For this net series - would you mind adding Fixes tags to each patch?

Yes.  That hasn't been my practice in the past; I guess I'll add
it to my checklist...

I will fix the spelling error in version 2.

					-Alex

> 
> Also checkpatch sayeth:
> 
> WARNING: 'accomodate' may be misspelled - perhaps 'accommodate'?
> #10: 
> The receive handler does properly accomodate the trailer that's
> 

