Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05F23641D6
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbhDSMjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhDSMjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:39:55 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE44C06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 05:39:24 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m9so21117982wrx.3
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 05:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eU0aKj+dzmqGesj7paj0aHUJGmr/pdqiAgP/SY5GTFA=;
        b=EdB7zApS8uO/B2uBCGICYo28pDAU2+HuYnJbE18qt/U63VSQGcR8MDWjejcAKFM+Cv
         h8juKDajo2QsME9VEGQmS5m6l9uBFbEqbNdaUQg08zpIzIT9PBKnOalmhEVJTcBGm0HG
         hNklrw3WaCinHx2fbT96pG6i9pOvsehn+P8oA0StTd2laixCs5iWguPlbWXJVX7Jq8UE
         1g1Pnv3YEo4BIGYgRpNpVwW5APAbUyRkOY4R0yBVOZKB4/tOxRYar0VHMu7L33DJ9VaD
         mCuAKnS2bYx/JiNBWBHXsXjedIinmY3iC16K6a8Mh53B169jqxU1JyqQ5VlW+Bnau3Xy
         gSpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eU0aKj+dzmqGesj7paj0aHUJGmr/pdqiAgP/SY5GTFA=;
        b=bCAg4S5+Yvrclmi0WBqlekXzPPxrcEiSWK4gc6zTcMMTJi87+7YJ6cdv+O2YLVEVTZ
         EbvREc0isuG5Egib6m3NXJahYS5+PY/O1GnTdjog9vudMekQdiJSclJLbbQRCtOCB/qw
         JxMcFpfWpp3OJ/jilZO+QEJkI6LJJKRtUdo3GpbeRv2RhPj/vazmykB+WPM1mKigyPii
         Dt3/sL6Yi+RlKW4ehDrtj3l2T0+BmT+cLhTALgHBnDpYu/SLlmXg1R8cdcL2rYdzkkza
         +QrtHA3SZdwQYYKWxEOzkyTLtAMgpJ4NTRi7wYhWx9mmKeJUW6ociH0ESiJSXmqsBJgV
         SzKg==
X-Gm-Message-State: AOAM533jYt4qH9thjm1Enkpa9BIL8OIRAgRU+IfxP3O4MMmXc8mw8eQ5
        7IUVjRsG1cAnwwhuLwKIKmI=
X-Google-Smtp-Source: ABdhPJwLTCAN9ffAvee0yHQERPUntaeQjg1RfcvyKhXXtGNAqERXHFJl+kVWVRkSeDDKWPOCSbHhNA==
X-Received: by 2002:adf:db4f:: with SMTP id f15mr14388592wrj.99.1618835962882;
        Mon, 19 Apr 2021 05:39:22 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id a4sm20313395wmm.12.2021.04.19.05.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 05:39:22 -0700 (PDT)
Subject: Re: [PATCH net-next 5/6] sfc: ef10: implement ethtool::get_fec_stats
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, habetsm.xilinx@gmail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, mkubecek@suse.cz,
        ariela@nvidia.com
References: <20210414034454.1970967-1-kuba@kernel.org>
 <20210414034454.1970967-6-kuba@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <a605fafb-a685-978c-8188-45eae96cfa04@gmail.com>
Date:   Mon, 19 Apr 2021 13:39:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210414034454.1970967-6-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2021 04:44, Jakub Kicinski wrote:
> Report what appears to be the standard block counts:
>  - 30.5.1.1.17 aFECCorrectedBlocks
>  - 30.5.1.1.18 aFECUncorrectableBlocks
> 
> Don't report the per-lane symbol counts, if those really
> count symbols they are not what the standard calls for
> (even if symbols seem like the most useful thing to count.)
> 
> Fingers crossed that fec_corrected_errors is not in symbols.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I'm trying to find out whether these count the right thing or not.
Some component documentation says that the per-lane _signal_ "asserts at
 maximum once per FEC coding block".  I haven't yet been able to track
 down how the counters aggregate that, but it would seem to suggest that
 they in fact count blocks and not symbols, and are just misnamed.
Investigation continues.

-ed
