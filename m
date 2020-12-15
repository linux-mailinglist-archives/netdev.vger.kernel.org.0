Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DDB2DAD76
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 13:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgLOMuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 07:50:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726156AbgLOMuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 07:50:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608036524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71TJz4jJBxi3FNWgBuXMogBmrKtRgJQf0Py8VByy0QY=;
        b=JW2DrnAiaMQxteurHppfq/f1YTUYBE97wl1CjASN40zv3vsHRsh2f2MXsRYgrg00mJhdoR
        zdxOo1TkF0TmE92bn+9652jzQwP7HsvowO2Z7x0YSXd6lU6i7WvHsnlfPKpjy442ZHi39N
        GzYQ7YcdAhvTA1oqfNkZrisctVN2uUk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-_-Tsk7aRMm2ZNTVpANZX7g-1; Tue, 15 Dec 2020 07:48:40 -0500
X-MC-Unique: _-Tsk7aRMm2ZNTVpANZX7g-1
Received: by mail-ej1-f70.google.com with SMTP id gu19so2274943ejb.13
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 04:48:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=71TJz4jJBxi3FNWgBuXMogBmrKtRgJQf0Py8VByy0QY=;
        b=HvbDD62xobrSKMQpk6t1BPFKzogx1pkFeMvzGMjibjn20oDC4ugwBxqa/lxXZgtTsn
         /z0ZCFN5lpHyIzsBUPuyY26Jgch51s9g+9GYUM3oZeJZmfTf/aaWLiq+j3ZIBe/UqsIo
         zLTPUKSbiI5TBsnoUZdVrZAfpJ3j34+SwKh+YN0sI/5cPkbAqjGMlIg20NvqvKrwV53X
         VN3f4D2E1W68WebvONytLRyXTH3OzexJVjxeRgR1KxNhvGLzXzQ9gvPu8YXbKcfSDAdV
         vH0eBeBoZvMgLBkaLufyoo7bl56JgsrP5mu2GfNTYBKrUI7fMWKrX6ITwfYEs9d5B6lv
         vU9w==
X-Gm-Message-State: AOAM531ZHZi9vCnPqfSfPx2e9RyFLznEous4PCKcIPAzEXy/aw5dIsCk
        /Aj2USL6ojV2QL8SNS6tSFBtWEF16LgTxO/u9lJKzlD/rZS5nv7DIoYJQV57962kr9nGiKUKQR5
        HfaACDMupn/kWl54Z
X-Received: by 2002:aa7:dd17:: with SMTP id i23mr2260445edv.14.1608036519048;
        Tue, 15 Dec 2020 04:48:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyW4i0eBs12UuBv1hAbzp9cwH5eerH26Zv/FHBRnZAh2dyaOq2xvRcezNZM9oglVXwzs9HqyQ==
X-Received: by 2002:aa7:dd17:: with SMTP id i23mr2260432edv.14.1608036518858;
        Tue, 15 Dec 2020 04:48:38 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id cb14sm1346737ejb.105.2020.12.15.04.48.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 04:48:38 -0800 (PST)
Subject: Re: [PATCH v5 0/4] Improve s0ix flows for systems i219LM
To:     Mario Limonciello <mario.limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com
References: <20201214192935.895174-1-mario.limonciello@dell.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <44b33670-7692-d6c1-3a65-61544ae4276c@redhat.com>
Date:   Tue, 15 Dec 2020 13:48:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201214192935.895174-1-mario.limonciello@dell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/14/20 8:29 PM, Mario Limonciello wrote:
> commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
> disabled s0ix flows for systems that have various incarnations of the
> i219-LM ethernet controller.  This was done because of some regressions
> caused by an earlier
> commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case")
> with i219-LM controller.
> 
> Per discussion with Intel architecture team this direction should be changed and
> allow S0ix flows to be used by default.  This patch series includes directional
> changes for their conclusions in https://lkml.org/lkml/2020/12/13/15.
> 
> Changes from v4 to v5:
>  - If setting S0ix to enabled in ethtool examine the hardware generation.
>    If running on hardware older than Cannon Point return an error.
>  - Increase ULP timeout to 2.5 seconds, but show a warning after 1 second.

Thank you. I've given v5 a test on a Lenovo X1 Carbon 8th gen (AMT capable)
and things work fine there with v5:

Tested-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans




> Changes from v3 to v4:
>  - Drop patch 1 for proper s0i3.2 entry, it was separated and is now merged in kernel
>  - Add patch to only run S0ix flows if shutdown succeeded which was suggested in
>    thread
>  - Adjust series for guidance from https://lkml.org/lkml/2020/12/13/15
>    * Revert i219-LM disallow-list.
>    * Drop all patches for systems tested by Dell in an allow list
>    * Increase ULP timeout to 1000ms
> Changes from v2 to v3:
>  - Correct some grammar and spelling issues caught by Bjorn H.
>    * s/s0ix/S0ix/ in all commit messages
>    * Fix a typo in commit message
>    * Fix capitalization of proper nouns
>  - Add more pre-release systems that pass
>  - Re-order the series to add systems only at the end of the series
>  - Add Fixes tag to a patch in series.
> 
> Changes from v1 to v2:
>  - Directly incorporate Vitaly's dependency patch in the series
>  - Split out s0ix code into it's own file
>  - Adjust from DMI matching to PCI subsystem vendor ID/device matching
>  - Remove module parameter and sysfs, use ethtool flag instead.
>  - Export s0ix flag to ethtool private flags
>  - Include more people and lists directly in this submission chain.
> 
> 
> Mario Limonciello (4):
>   e1000e: Only run S0ix flows if shutdown succeeded
>   e1000e: bump up timeout to wait when ME un-configures ULP mode
>   Revert "e1000e: disable s0ix entry and exit flows for ME systems"
>   e1000e: Export S0ix flags to ethtool
> 
>  drivers/net/ethernet/intel/e1000e/e1000.h   |  1 +
>  drivers/net/ethernet/intel/e1000e/ethtool.c | 46 ++++++++++++++++
>  drivers/net/ethernet/intel/e1000e/ich8lan.c | 16 ++++--
>  drivers/net/ethernet/intel/e1000e/netdev.c  | 59 ++++-----------------
>  4 files changed, 70 insertions(+), 52 deletions(-)
> 
> --
> 2.25.1
> 

