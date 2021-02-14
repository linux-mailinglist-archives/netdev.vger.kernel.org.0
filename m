Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8269431AE94
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 01:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBNAwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 19:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBNAwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 19:52:09 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8610C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 16:51:29 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id o7so2688545ils.2
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 16:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=06+Al5JPcP19AfJGmu0gozNM4X34PTHN33kaWt/Yptw=;
        b=U8hyB+Dz8PsayNnrhpwVGpx1iL543vqjtqyYWYCxQyx0L4HSnOyK66cgLyYarvmiB+
         CkIce8r0FYSddSttQsSZ4sqlwFBSFvka9mp+DJFjSnWFccOdhDw5qQvBNf7nLd8KeSaw
         nMI2jmbYmgmY2evHGDIdwVCzPk1YcSVZTVlUAiGn5FjOYnMFZ87I0yM2EJSYZ3TdmYoC
         3aVilLOoz+dojjg1ba27GCDvUVzyvn3cfC4PsKO1/hWWgLKEpNuQW4Lhw+lERf28kg7v
         dXkYrexDF9y/I8uLYSUoffErqGghmy4r/mFrG96soEwGSq0bD6PCDvWCh1ecd3yOLv5H
         1OoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=06+Al5JPcP19AfJGmu0gozNM4X34PTHN33kaWt/Yptw=;
        b=sHOdJk7aCGXpo/Jal/RMPvNDWuUCazUCJeMZ7dymVSkdPFVB5+fZ8oL243X1Fps8j5
         20xJt8t/pB9BKwK9dAzCkwbq7ss6f6HyFX2rwg87AMhlf6gJgdxTiUheXTstOiV5cs8M
         jfD9W7+hM1Q93lP5P09WdPHLbLqL/M4o78nt3HnwEAENfA6fEISIImOqvm4fyVCNz2gR
         sTuYtRJIppPVjx+LEtacTqmgpnH+Rnq0JtXNzbfsMRBckvD2+Tr5AkjI8kz3ivB4oyf7
         4x5G/egEu7FIECUnVE7BLIsZSm78r67UORKDcjhsvn9uPtgpzrtQTr6cTXY+P1UXwYOx
         2txA==
X-Gm-Message-State: AOAM530moNEe4bMoMVKsTV0b650LU8m+ampEkbiyG/Gj7rN9gaHwn2ey
        pF1/A2CiM3hkDpMkxUfds+U=
X-Google-Smtp-Source: ABdhPJyy+Ah699tgUTrZPXBbS8i0EOferdV1IQBO/gGKb6p38o3Nwj+rNzOD8uTQKYqRHSmHlgqNIw==
X-Received: by 2002:a05:6e02:152f:: with SMTP id i15mr7806977ilu.183.1613263888899;
        Sat, 13 Feb 2021 16:51:28 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id s17sm6496771ioe.53.2021.02.13.16.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 16:51:28 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ip route: Print "rt_offload_failed"
 indication
To:     Amit Cohen <amcohen@nvidia.com>, netdev@vger.kernel.org
Cc:     idosch@nvidia.com
References: <20210209091200.1928658-1-amcohen@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1a253a9d-7abe-b968-c962-0e20480b7208@gmail.com>
Date:   Sat, 13 Feb 2021 17:51:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209091200.1928658-1-amcohen@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/21 2:12 AM, Amit Cohen wrote:
> The kernel signals when offload fails using the 'RTM_F_OFFLOAD_FAILED'
> flag. Print it to help users understand the offload state of the route.
> The "rt_" prefix is used in order to distinguish it from the offload state
> of nexthops, similar to "rt_offload" and "rt_trap".
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  ip/iproute.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

applied to iproute2-next
