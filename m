Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C306253D87
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgH0GNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgH0GNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:13:40 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A84C061258;
        Wed, 26 Aug 2020 23:13:39 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id i10so5106617ljn.2;
        Wed, 26 Aug 2020 23:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yCsGVzEa07QpG25wdJdogsPOJiE4mf7jTXesPysELoE=;
        b=dubMJMWFseFCK/JlFJEZLfYxiKZ6SlXQuvC6LDPHmsM/qt1zRg1Ck0pfUj9eZNgeca
         1Oed9X7K110/5xRKzFTKVqDx6SQ0KndBu5iHQZtMqB5lvLN+N446BxTQ9zvt2jrK8lpk
         NlU/omUmIKDg58VUNe0U7w4JE3Yq6DwA3bEWQ9ClLc78RoV6y/lTK3skBSwp+GXYhmgD
         b3zXayl5ujX6cmfCjOv1eKYx/qpEvG7d0RJblcqL2qCFEcC7Gd0JQGD9NHgKcdsJvUDd
         vUGfgsn0nlYe+s8aqDhU6y42xgHTpLNXUDy79h7dYOuPs4D5gzLQ8BgHU2HVNPzcoM9m
         GdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yCsGVzEa07QpG25wdJdogsPOJiE4mf7jTXesPysELoE=;
        b=Umj3bwsHFOzzut73j8C1rDCoPIkDzyv6/fuVOhTASXk6KnIrqs9SvdXrdFRFNYqVn5
         er4VwqvoHByCe2PNTcpVxk8MkdA+Ro6Qo5tGqDhAV/CFtOiejtZQ4pAjmfhvUBr/raEr
         WjCfFEoKQZ1U/KTtNi1BQVfQ8NrLHGb0rQenzBfg3jP82M8Lr3a9Fxj29MmXC72nPCE2
         FbLlrPq2pOfagmaVLpw8OhYEUvDYk+AUDgiVW4zLdR6Zs1Pae7P+Wj7ow4I7tDnYF/71
         HmeLe+13sq/sc5qXmvSmXstRtyjTHFWSM5xzJVWw7HRc2y68HUBkmS0S3pCzdbSQb6/X
         KRHA==
X-Gm-Message-State: AOAM531XIhgPsVI72CvSV2GZmxLpTzs/tFWpbSMcvsJFpIqgPRwyY4Tz
        Vlsax18NeLZHqOg9/E3qPUb5+GOYg1I=
X-Google-Smtp-Source: ABdhPJzpj2rXc21C8Y+4YKa0N4ooD3Kd3IswfRU0tkhitEzjF7/P6HGWsVaPjb6jod4eSKlGxK1Ecg==
X-Received: by 2002:a2e:8e9a:: with SMTP id z26mr8408692ljk.271.1598508817298;
        Wed, 26 Aug 2020 23:13:37 -0700 (PDT)
Received: from [192.168.2.145] (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.googlemail.com with ESMTPSA id y64sm260128lfc.50.2020.08.26.23.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 23:13:36 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] brcmfmac: increase F2 watermark for BCM4329
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200827060441.15487-1-digetx@gmail.com>
 <20200827060441.15487-2-digetx@gmail.com>
Message-ID: <ba942825-e165-68f1-00d1-81cc66ff518b@gmail.com>
Date:   Thu, 27 Aug 2020 09:13:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200827060441.15487-2-digetx@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

27.08.2020 09:04, Dmitry Osipenko пишет:
> This patch fixes SDHCI CRC errors during of RX throughput testing on
> BCM4329 chip if SDIO BUS is clocked above 25MHz. In particular the
> checksum problem is observed on NVIDIA Tegra20 SoCs. The good watermark
> value is borrowed from downstream BCMDHD driver and it's matching to the
> value that is already used for the BCM4339 chip, hence let's re-use it
> for BCM4329.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---

I accidentally missed to add the r-b from Arend that he gave to the v1:

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

