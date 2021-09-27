Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560FD41954B
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 15:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbhI0No7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 09:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbhI0No6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 09:44:58 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C4EC061575;
        Mon, 27 Sep 2021 06:43:20 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 67-20020a9d0449000000b00546e5a8062aso24441007otc.9;
        Mon, 27 Sep 2021 06:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3HB/k/I8QIn61ekO+bGy12NdBrVnuuc7rW3xgyTXOkM=;
        b=VMdzJOTMPuyYImQkcriovhY8uaX/CTuVP3a+mcriuHSJ/BHIWtMTaPiE5si3BJy54W
         apvKBtQ0p1nmPcVZaLZOx2Te6rW5sPSsK9YnFyyegNnUKR5zF9/cD2hm35NhhzHF8/nd
         RVymoZR/pWlVnxH/jOJVEXwsEgO9eVf6Ll233WFVu/QPdDsfDTFaiCRcioRdD88Yrzu9
         0D0nTwp+MBlHsjsgOS6lNpi69emqPr/jJs1ff762IY3EK94sjzx7RoEXf5CyCQ87BC1A
         9FpvEtllJifTeaxQOazInhBtqM6ahAe3UFTZmPkm3ifta2LTuM1db2N1WWzHcPs1Pn//
         1UrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3HB/k/I8QIn61ekO+bGy12NdBrVnuuc7rW3xgyTXOkM=;
        b=ZHCzuene99ZElMqnfM3Hdx85K9VAZkc/qd3V5C4oc5KmbVQnTcKNWZhrMSMamWZ/FB
         Rd/QWL/TpK0TaJuSfNnQO9/UrzsfioYCEbMQv3oCdGzonkAiFxwzbid9WwjAtYjtzDI9
         bxczwDRzcb3VLIJqIPNhFRmkZAJdyXt6xBWS0DZ2YkFhdUBZ9zS/EF0+vzdEZnjT+SSm
         G3UM7VGMf0hjXvULhccMYXaqy23RL19mE/rYfGqACpxyg+gScJwthsppgQ1HVA9Biq+U
         HXLK1/YzdDjDnDhacMdLvfZfWFzUEn5hRf7vR+MGZWia+pyD2QR9kQaQRlASr1bNkZlw
         czcA==
X-Gm-Message-State: AOAM5319VCNynaXmLGzb0WGLhm0EP9w0EsSN9P1xPFWhs8j0JpjdyHoV
        LzHq/isiYdZzTIsFBAcBln2XrO/iFcOcEQ==
X-Google-Smtp-Source: ABdhPJxAkbVx4BQS9zLZUK5bRuTjTgvXhbNu7syGeBKaa3ntgxnYnlYpkm+fYXRGbhq5OTNu9dEAEw==
X-Received: by 2002:a05:6830:793:: with SMTP id w19mr76512ots.23.1632750199971;
        Mon, 27 Sep 2021 06:43:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id p9sm3728198ots.66.2021.09.27.06.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 06:43:19 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/3] net: ipv6: check return value of
 rhashtable_init
To:     MichelleJin <shjy180909@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        johannes@sipsolutions.net
Cc:     saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        paulb@nvidia.com, ozsh@nvidia.com, lariel@nvidia.com,
        cmi@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <20210927033457.1020967-1-shjy180909@gmail.com>
 <20210927033457.1020967-3-shjy180909@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f1e72a4a-3a85-71d9-81cc-8ca835565a50@gmail.com>
Date:   Mon, 27 Sep 2021 07:43:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210927033457.1020967-3-shjy180909@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/21 9:34 PM, MichelleJin wrote:
> When rhashtable_init() fails, it returns -EINVAL.
> However, since error return value of rhashtable_init is not checked,
> it can cause use of uninitialized pointers.
> So, fix unhandled errors of rhashtable_init.
> 
> Signed-off-by: MichelleJin <shjy180909@gmail.com>
> ---

Reviewed-by: David Ahern <dsahern@kernel.org>
