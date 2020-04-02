Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C3519C118
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388155AbgDBMbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 08:31:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53724 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388045AbgDBMbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 08:31:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585830709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b1iuEwMOCbdyBg0ZzUREMNzB1yA2no/SoVc43YelAqs=;
        b=eq/9l7IADwcqzJU2V68DmlmZBTMDedJOSOXIIEfXJRddZ9Pu35RM0tkRTPLzIxG6EW1r9e
        wCXl3r9dvLKETHQWA7wRVhZcjRNuAI7y4YO/PqWYb4NCOrlM/OHW95scPB963/gyTAo5lW
        EQJfBirD/vQQBFXGaM6b5L4DJOMYEJo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-ul-yVuLeOY6H2-7kqOHzuA-1; Thu, 02 Apr 2020 08:31:44 -0400
X-MC-Unique: ul-yVuLeOY6H2-7kqOHzuA-1
Received: by mail-wm1-f70.google.com with SMTP id o5so1343703wmo.6
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 05:31:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b1iuEwMOCbdyBg0ZzUREMNzB1yA2no/SoVc43YelAqs=;
        b=uK/V9wrGe5elfUqKa4eCe6ppdrGxw8bGhiAVEAnPn/XJXecYDGXdLivtR9nsA43eFt
         9Qr1khlQjmih+wNDOe3xaPjdDUszfuuRUeUsdpRzTMWjfRfERlhnXP8HBmEM5fzqWlga
         vrZAZwsVegIhDUSEbiroWFfkR9lQo8RFI1JsT3PM3PR4+sQruYx0DNwLYpszKNgVpEoo
         xZilLiPb1B4lguh8BbKpauiYQ+nxuN5ouBQdYiv7Wlf+aYpw2/OmscHvLuIn2VnYxu2i
         fs7AJy1sUvrMboiUOum0IUnNYTfpRcrGNIODwrGfSzSMLmS64AT5fF+oXpj3nWLxDpMj
         za1A==
X-Gm-Message-State: AGi0PuYUlxJSZ6yMyVr97LKi14UJdfeLqmFJrpz36GhRtCTSEbAloXT2
        NnHMEzBUT+bhWJ8FQgcbupCoYLdAfvefxDGkvCfm0W2R6rSEeNVRP0W8Ig1PZkszpgKQjkRHZou
        PtQHhFvd1ki3WSg8B
X-Received: by 2002:a1c:5502:: with SMTP id j2mr3329005wmb.93.1585830703576;
        Thu, 02 Apr 2020 05:31:43 -0700 (PDT)
X-Google-Smtp-Source: APiQypKeJkvlyzlxZHIlUhPY1uR/INkbvzSshkiu5u15mWxi8/IcJgopTZ/QYSyOkrZueWFFXMQn6g==
X-Received: by 2002:a1c:5502:: with SMTP id j2mr3328989wmb.93.1585830703329;
        Thu, 02 Apr 2020 05:31:43 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id h81sm7629471wme.42.2020.04.02.05.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2020 05:31:42 -0700 (PDT)
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: bump up timeout to wait when ME
 un-configure ULP mode
To:     Aaron Ma <aaron.ma@canonical.com>, jeffrey.t.kirsher@intel.com,
        davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sasha.neftin@intel.com
References: <20200323191639.48826-1-aaron.ma@canonical.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <4f9f1ad0-e66a-d3c8-b152-209e9595e5d7@redhat.com>
Date:   Thu, 2 Apr 2020 14:31:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200323191639.48826-1-aaron.ma@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/23/20 8:16 PM, Aaron Ma wrote:
> ME takes 2+ seconds to un-configure ULP mode done after resume
> from s2idle on some ThinkPad laptops.
> Without enough wait, reset and re-init will fail with error.
> 
> Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
> BugLink: https://bugs.launchpad.net/bugs/1865570
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>

I have been testing this bug because this is being reported against
Fedora 32 too:

https://bugzilla.redhat.com/show_bug.cgi?id=1816621

I can confirm that this patch fixes the problem of both
a X1 7th gen as a X1 8th gen no longer suspending after
a suspend resume cycle.

Not only does it fix that, before this patch the kernel
would regularly log the following error on these laptops
independent of suspend/resume activity:

e1000e 0000:00:1f.6 enp0s31f6: Hardware Error

These messages are now also gone. So it seems that the timeout
is really just too short.

I can agree that it would be good to better understand this;
and/or to get the ME firmware fixed to not take so long.

But in my experience when dealing with e.g. embedded-controller
in various laptops sometimes the firmware of these devives
simply just takes a long time for certain things.

This fix fixes a real problem, on a popular model laptop
and since it just extends a timeout it is a pretty harmless
(no chance of regressions) fix. As such since there seems
to be no other solution in sight, can we please move forward
with this fix for now ?

Regards,

Hans





> ---
>   drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> index b4135c50e905..147b15a2f8b3 100644
> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> @@ -1240,9 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
>   			ew32(H2ME, mac_reg);
>   		}
>   
> -		/* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
> +		/* Poll up to 2.5sec for ME to clear ULP_CFG_DONE. */
>   		while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
> -			if (i++ == 30) {
> +			if (i++ == 250) {
>   				ret_val = -E1000_ERR_PHY;
>   				goto out;
>   			}
> 

