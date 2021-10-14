Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC8542DA3C
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 15:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhJNN0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 09:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhJNNZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 09:25:56 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83275C06174E;
        Thu, 14 Oct 2021 06:23:51 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id i12so19447544wrb.7;
        Thu, 14 Oct 2021 06:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dn8qntTXephimx3LoXkKaClxMq8rV7tTytuW+aAxGys=;
        b=TG4gKWLEl1HWM00/cvFeOgDj8WQYP1KCzXTGjFb7rZem/+WkoOb/xrGrkjvQRt7diq
         zd8viGl3L5J9hmO2rGfQHR1gaQlNNR6UTGuKzPZLn8Xs5/JuRGRrK0ZWgPiDSpWLdPHv
         DFfuIRHxQyvIHvztCAbcge5bZnpVDD1Lftk2hgMHufVFAFu3yOYsLA8ylcyzbkxTjEPV
         XObLkUZnCoisWw1iprA8xD93a1QCc/ClQ0rqa/f/+wAVOssgskUwMkvT3YdnPlViC02L
         gDuC6t1ugWwTWQNrILpaLsLBd9Eu0phGP8FW0E0kdaySSPMPPrCdltzLOlh+sqzFadVf
         /iyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dn8qntTXephimx3LoXkKaClxMq8rV7tTytuW+aAxGys=;
        b=KQ1JJeejln5y16AuGmJqk1l9QmQEk1Xs2LNBtuZ01WvpPFq8xrPRMD1u5Fjw+NXI2B
         i35dS81CYeKTT7xo/wPsuPk30YnSaO9z3K6Kt4t1JID3mV8syYuDdkvCbMv8IXWQyUe6
         8xTvjajNTMtt+r6I0yCaVFS3bpapvlRkduZf8v0eVpPwABN3SOjD9qAnioaAhXwqKnch
         UWDNBMoPdPIRH/W87/PyH/XW8kOrASAID4+AKOrhrhwc6MCBQ00hnL528Rd2WQw1C7kI
         wpESH5e/QjqiK4Bv6zVrk2WcLYt5gU4jsusfjoNPJK936fIW0LZjAAQRuihvoSiWnPzu
         7piQ==
X-Gm-Message-State: AOAM530pxnQNORO4BbDUE8chc+8oxJ6EO5BpTpM9DD/1zOGk2NwxdnKp
        D6VzygugXimulbf3ruyXUuIba6//3IU=
X-Google-Smtp-Source: ABdhPJwSNoISoB6WHeruIs45RWZovGTfzvBYWEZ6vwQ1mL+wE7qCVNKa0oLduAeRRzzdMAyifMikeA==
X-Received: by 2002:a05:600c:1c88:: with SMTP id k8mr5782455wms.169.1634217830036;
        Thu, 14 Oct 2021 06:23:50 -0700 (PDT)
Received: from debian64.daheim (p200300d5ff0f7400d63d7efffebde96e.dip0.t-ipconnect.de. [2003:d5:ff0f:7400:d63d:7eff:febd:e96e])
        by smtp.gmail.com with ESMTPSA id f186sm7823662wma.46.2021.10.14.06.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 06:23:49 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1mb0i5-0009Kt-2o;
        Thu, 14 Oct 2021 15:23:49 +0200
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF
 selection
To:     Robert Marko <robimarko@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
References: <20211009221711.2315352-1-robimarko@gmail.com>
 <ba520cf0-480e-245b-395f-7d3a5f771521@gmail.com>
 <CAOX2RU7VaxdU3VykTZER-pdpu6pnk3tbVrBmkGU=jPQo6rL3Xg@mail.gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <0180909b-1c62-208d-3dce-7ac34dbd584c@gmail.com>
Date:   Thu, 14 Oct 2021 15:23:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAOX2RU7VaxdU3VykTZER-pdpu6pnk3tbVrBmkGU=jPQo6rL3Xg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/10/2021 14:01, Robert Marko wrote:
> On Thu, 14 Oct 2021 at 13:54, Christian Lamparter <chunkeey@gmail.com> wrote:
>>
>> On 10/10/2021 00:17, Robert Marko wrote:
>>> Some ath10k IPQ40xx devices like the MikroTik hAP ac2 and ac3 require the
>>> BDF-s to be extracted from the device storage instead of shipping packaged
>>> API 2 BDF-s.
>>>
>>> This is required as MikroTik has started shipping boards that require BDF-s
>>> to be updated, as otherwise their WLAN performance really suffers.
>>> This is however impossible as the devices that require this are release
>>> under the same revision and its not possible to differentiate them from
>>> devices using the older BDF-s.
>>>
>>> In OpenWrt we are extracting the calibration data during runtime and we are
>>> able to extract the BDF-s in the same manner, however we cannot package the
>>> BDF-s to API 2 format on the fly and can only use API 1 to provide BDF-s on
>>> the fly.
>>> This is an issue as the ath10k driver explicitly looks only for the
>>> board.bin file and not for something like board-bus-device.bin like it does
>>> for pre-cal data.
>>> Due to this we have no way of providing correct BDF-s on the fly, so lets
>>> extend the ath10k driver to first look for BDF-s in the
>>> board-bus-device.bin format, for example: board-ahb-a800000.wifi.bin
>>> If that fails, look for the default board file name as defined previously.
>>>
>>> Signed-off-by: Robert Marko <robimarko@gmail.com>
>>> ---
>>
>> As mentioned in Robert's OpenWrt Pull request:
>> https://github.com/openwrt/openwrt/pull/4679
>>
>> It looks like the data comes from an mtd-partition parser.
>> So the board data takes an extra detour through userspace
>> for this.
>>
>> Maybe it would be great, if that BDF (and likewise pre-cal)
>> files could be fetched via an nvmem-consumer there?
>> (Kalle: like the ath9k-nvmem patches)
> 
> Christian, in this case, NVMEM wont work as this is not just read from
> an MTD device, it first needs to be parsed from the MikroTik TLV, and
> then decompressed as they use LZO with RLE to compress the caldata
> and BDF-s.

For more context here (it's unrelated to the patch):
There is more custom code than just the mtd splitter.
I do fear that this could be turning into a dreaded "separation between
mechanism vs policy"-proxy discussion with that in-kernel LZOR
decompressor/extractor and the way that the board-data then has be
rerouted through user-space back to ath10k.

---

As for the proposed feature: Yeah, back in 2017/2018-ish, I would have
really loved to have this "load separate board-1 based on device-location".
Instead the QCA4019's board-2.bin is now bigger than the device's
firmware itself. From what I can see, there are also more outstanding
board-2.bin merge requests too, though some those are updates.

Cheers,
Christian
