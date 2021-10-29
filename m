Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7182943F3E5
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 02:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhJ2Aat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 20:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbhJ2Aas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 20:30:48 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DC5C061745
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 17:28:20 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b12so8753247wrh.4
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 17:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mSeyR1j+Ai42oFLeIWTXj/VqqxtGGIf4/+Gmw0CPXl8=;
        b=KBG3boAfNHiAG3Cwkjmg1ck0vlZywg77y8rBtYM5L28jQH40vPAzlrpJyc7mYA1wSR
         YKS+tDD4+p2xq08MACp8b7Uhxs8gPQiOF5TRaQetj7rL0DZcO7NKejNh9z8mXFlSX+JR
         fezlGECn8ue9W+j0gYcs9EYMfwEt2RXxxVtpo9WtAaiIVgPtn1S9k2Ph1EoBrvkhklIU
         zFMPlRWx0WS3g/iAPh7s5CRWqzNJLBaHC9ISA1b4GxBZi0H1bt4CIhcxKsmtvYmDeeqr
         fQidqIBrl2W2xqitepoRFd0jnAJ/pdgx3FbuOIS1E5c6ALcfjsQmU4W+x9ZlvQk2HC3Y
         mFbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mSeyR1j+Ai42oFLeIWTXj/VqqxtGGIf4/+Gmw0CPXl8=;
        b=XNobjP2iiDQout9K2E8gJlXCazz8zsbbOvzvEiZxTPFP5sP8FxTMm20TBdUvhcK630
         BH+rd25gYd64O/vfjSZV83adWDOq8hyEfTZQkRgEfjyviisARYyGoA/rwfrYCzD+F1LD
         0CeNRlii7VHL6CNwHoe0qhZ+0wa9aUNngxrLi/QGS8HY1JrBgxbQ4EL0gU2PtaJCNIz5
         4tu/iXxIhjtHvLPa7GxBjP6mNyoiyqp77b/jrCOu6hcJFzlT0rTyNEZOH5UvrfpvaU7K
         s6EShU21rE8MmF0hlEmqcgpkLAD83Q1ehf4ZGIFpvZoWuukEWlMXBcC4JReYGISaws6W
         yOSw==
X-Gm-Message-State: AOAM530CiLCYnbHIqBO7AQ5wOfW1m0dSJ6wVC+wp1EI2//Z2zV93Rmrv
        NidV1DK9YTMR1LKWhC8GMxlXWg==
X-Google-Smtp-Source: ABdhPJzUvkKf706MUq4TucvYI8qKJ0DKgxnthUONvly/4RkpOWSiI4kcJ3KzQRcFhWz8ds7DgfySyg==
X-Received: by 2002:a5d:63cd:: with SMTP id c13mr9520358wrw.224.1635467299285;
        Thu, 28 Oct 2021 17:28:19 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id l22sm245415wmp.34.2021.10.28.17.28.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 17:28:18 -0700 (PDT)
Message-ID: <b3473977-5bb6-06df-55c3-85f08a29a964@linaro.org>
Date:   Fri, 29 Oct 2021 01:30:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 2/2] wcn36xx: fix RX BD rate mapping for 5GHz legacy rates
Content-Language: en-US
To:     Benjamin Li <benl@squareup.com>, Kalle Valo <kvalo@codeaurora.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211028223131.897548-1-benl@squareup.com>
 <20211028223131.897548-2-benl@squareup.com>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
In-Reply-To: <20211028223131.897548-2-benl@squareup.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/10/2021 23:31, Benjamin Li wrote:
> -		    status.rate_idx >= sband->n_bitrates) {
This fix was applied because we were getting a negative index

If you want to remove that, you'll need to do something about this

status.rate_idx -= 4;

---
bod
