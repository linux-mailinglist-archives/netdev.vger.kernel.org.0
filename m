Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C493422E01
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 10:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfETIJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 04:09:44 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34529 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfETIJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 04:09:44 -0400
Received: by mail-ed1-f67.google.com with SMTP id p27so22529182eda.1
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 01:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hKt31xD+Dl8MzM54WFXgU95OQA9AwS6wGbeoPpSKfXE=;
        b=I2Lnt/WtkJjDLrDgWSYRJHdM95JskcT/jxH9QckQMcj/7PmrJgwgQz6Q6ftoKRwTZ9
         9vCkHGOEX5MxLnlEtV98FPcLqUiMFStugzKSpO0A48EXDefeXgWbIHhMTwzBSzmXikZ5
         CPJXahNcXca0FGjVF22eGZbd6XPVxBMapmwYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hKt31xD+Dl8MzM54WFXgU95OQA9AwS6wGbeoPpSKfXE=;
        b=PL9u9LoV6X8B/Oi4qmTjfvV7NRcE+nitTO0JmR3TcAJ4OJfGaUAI3ac9OiUGPptc9L
         4L04X/mrxasuY3ylOiGWOvBwDJs17b2sYBvIns6uxJjuszDsXpqkD7xAfPoEG2hD8vun
         J8mxrdN7Ckr+ABJzoj8CQ+FqTzvk+RMWzvsLydUj4Tz+qyujkQMxX3g/iGCp8ZAx3q5F
         5mYdPJc4eCDJsTwNfqhu0mGENvC6gf+KIHLR9khORSrcwsN1yJdpbB4Fjkze4hGiIs8F
         64H31NfOxXRo7XHWSWshMhI4+hD7nO4GIaaoYMivfBPp0uRC7nHVnTazocY3uU08GNZ2
         3GIA==
X-Gm-Message-State: APjAAAUHnaOLvcLnx5mmpAQFpAHFsSMRLxirim1oLWBSxsw2uJSy4kWM
        WC3BhcjdECqHgQpKEaeDfqDJxQ==
X-Google-Smtp-Source: APXvYqyzT9sszHOtK0V/iwAwNW8LGsXi2uW7QI5DTUVDOy96+wSa9nUb5iDqOpm++yl3P0LW/Icifw==
X-Received: by 2002:aa7:c4d2:: with SMTP id p18mr73940804edr.232.1558339782382;
        Mon, 20 May 2019 01:09:42 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id x22sm5441295edd.59.2019.05.20.01.09.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 01:09:41 -0700 (PDT)
Subject: Re: [PATCH 1/3] brcmfmac: re-enable command decode in sdio_aos for
 BRCM 4354
To:     Douglas Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     linux-rockchip@lists.infradead.org,
        Double Lo <double.lo@cypress.com>, briannorris@chromium.org,
        Madhan Mohan R <madhanmohan.r@cypress.com>, mka@chromium.org,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Franky Lin <franky.lin@broadcom.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        brcm80211-dev-list@cypress.com, YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20190517225420.176893-1-dianders@chromium.org>
 <20190517225420.176893-2-dianders@chromium.org>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e3f54bcb-8d10-1336-1458-2bd11cfc1010@broadcom.com>
Date:   Mon, 20 May 2019 10:09:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517225420.176893-2-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/2019 12:54 AM, Douglas Anderson wrote:
> In commit 29f6589140a1 ("brcmfmac: disable command decode in
> sdio_aos") we disabled something called "command decode in sdio_aos"
> for a whole bunch of Broadcom SDIO WiFi parts.
> 
> After that patch landed I find that my kernel log on
> rk3288-veyron-minnie and rk3288-veyron-speedy is filled with:
>    brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110
> 
> This seems to happen every time the Broadcom WiFi transitions out of
> sleep mode.  Reverting the part of the commit that affects the WiFi on
> my boards fixes the problem for me, so that's what this patch does.

This sounds very similar to the issue we had during integration of wifi 
on rk3288 chromebooks years ago.

> Note that, in general, the justification in the original commit seemed
> a little weak.  It looked like someone was testing on a SD card
> controller that would sometimes die if there were CRC errors on the
> bus.  This used to happen back in early days of dw_mmc (the controller
> on my boards), but we fixed it.  Disabling a feature on all boards
> just because one SD card controller is broken seems bad.  ...so
> instead of just this patch possibly the right thing to do is to fully
> revert the original commit.

I am leaning towards a full revert, but let's wait for more background info.

Regards,
Arend
