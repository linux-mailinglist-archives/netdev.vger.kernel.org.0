Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673DD1F47CE
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389371AbgFIULc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731802AbgFIULb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 16:11:31 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F14DC05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 13:11:31 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id n9so25071plk.1
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 13:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Zx/VCKRiyi/4hcuXFzZBFZ7r4XlDXVNcoz/8+OOF5/w=;
        b=RfrdJnnTX5HJDXWmv+Uk2n9IhZda/qegu2Cnm3Fqz40XH6obghrjrRYhJyp719ZuKk
         sY/TpKURjWRQU8a9VqPNvJaIsGFPLF8gpSEQOYq5griKlC032j8ruskvm30W+5qjkPjM
         jTc/H0PsWFCMXrM1XUQ+xLUpqX1MbMG8up9Xkt1w9aM8jlN1d9oSkT2kAy5pn8Bvsrsv
         IP1Z08AorDXmFrjbc+wus2nff/fxaMTFaLAXBNMCXONoEsKtqrANe4/fzYkJ+7V3d37Y
         Bnm5QBUj1oxDOYGxciqyVJ4vDbw2B4Ob0D9rvX66xrnpxrdICKuPyF5uMd5+1W+7IFU5
         3pXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Zx/VCKRiyi/4hcuXFzZBFZ7r4XlDXVNcoz/8+OOF5/w=;
        b=WM20PemaFboDA2BiOT7Fh4iPP8iOhrFSzKMlULs7drBALfOiC6PF0HKsU8gmW2xKus
         0xT6/jdDCWZK2ozqslOOoLl/mlM0+9xjguRd6W8LGWj6YHDxbmzclhkETl5AOT55dCCX
         7VRYq3XX+9S45+TTZCCB76r/f2oW4b+RyWB0MTK10j47ZbkBMbvkOTfN17gbFr7IFBbX
         1eguOfB/c8mhRNN+TFLVQTaDOr3xWvvPblYfLel6OfcHD+P9YIzir1C1UgOcTLh9usbD
         Wt01Im65yLfQIyk5hZChkNPGduCK0a6xI1O/UGE5PwA8jjdb26ZHHx1sj8rJP15pELhr
         hRsQ==
X-Gm-Message-State: AOAM5320UoX9NooFQdbgpF7sNwVKIHhB1ML3ga1KsxerMyiBloRBBa1Y
        9j/fZXaCoVk/uuEpQrEpW/eMeTHbEX0=
X-Google-Smtp-Source: ABdhPJw3JqVVvN1yYE+CipUzYaSGGxpUsyZUBsjSa2AqRhmBCrlxoUFS3/iI9fnMwN/FbvR/qIX6pg==
X-Received: by 2002:a17:90a:6706:: with SMTP id n6mr6931353pjj.13.1591733490196;
        Tue, 09 Jun 2020 13:11:30 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id z85sm10593650pfc.66.2020.06.09.13.11.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 13:11:29 -0700 (PDT)
Subject: Re: [PATCH net 1/1] ionic: wait on queue start until after IFF_UP
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200609034143.7668-1-snelson@pensando.io>
 <20200609.124709.1693195732249155694.davem@davemloft.net>
 <99c98b8c-f8c3-b1be-9878-1ad0caf85656@pensando.io>
 <20200609.130637.1015423291014478400.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <9594f97d-bfc8-6322-ba6e-5a838d1dbde0@pensando.io>
Date:   Tue, 9 Jun 2020 13:11:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200609.130637.1015423291014478400.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/20 1:06 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Tue, 9 Jun 2020 12:51:17 -0700
>
>> On 6/9/20 12:47 PM, David Miller wrote:
>>> From: Shannon Nelson <snelson@pensando.io>
>>> Date: Mon,  8 Jun 2020 20:41:43 -0700
>>>
>>>> The netif_running() test looks at __LINK_STATE_START which
>>>> gets set before ndo_open() is called, there is a window of
>>>> time between that and when the queues are actually ready to
>>>> be run.  If ionic_check_link_status() notices that the link is
>>>> up very soon after netif_running() becomes true, it might try
>>>> to run the queues before they are ready, causing all manner of
>>>> potential issues.  Since the netdev->flags IFF_UP isn't set
>>>> until after ndo_open() returns, we can wait for that before
>>>> we allow ionic_check_link_status() to start the queues.
>>>>
>>>> On the way back to close, __LINK_STATE_START is cleared before
>>>> calling ndo_stop(), and IFF_UP is cleared after.  Both of
>>>> these need to be true in order to safely stop the queues
>>>> from ionic_check_link_status().
>>>>
>>>> Fixes: 49d3b493673a ("ionic: disable the queues on link down")
>>>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>>> What will make sure the queues actually get started if this
>>> event's queue start gets skipped in this scenerio?
>>>
>>> This code is only invoked when the link status changes or
>>> when the firmware is started.
>> If the link is already seen as up before ionic_open() is called it
>> starts the queues at that point.
>>
>> If link isn't seen until after ionic_open(), then the queues are
>> started in this periodic link check.
> I'm saying if it happens in the race condition you mention that you
> are protecting against, where running is true and IFF_UP is not.
>
> The link check is periodic?  It looks like it triggers when the
> link state changes to me.

Yes, the link check is triggered by the periodic watchdog 
ionic_watchdog_cb(), every 5 seconds.

sln


