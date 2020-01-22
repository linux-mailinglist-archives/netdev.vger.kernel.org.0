Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA2114509E
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 10:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732464AbgAVJr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 04:47:58 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40978 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730748AbgAVJr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 04:47:57 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so6044139ljc.8
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 01:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UZA8MvhgTjR1Db93Kl8ZE7I1AjnzSwS3ydOzQHANga8=;
        b=wC0p0y6lCM/wUPS/IfTODzcD7cUkMCgxGcO/Ls1M4lnxeAF25AhC2C4Vq95flX9Cqq
         xswljYa8WRGoOcWSXm2W6pX2i6tbrYZl/tb8PK/KF9zkamDnl/8pfd8ewgUZPz+/5fUN
         96AHMmL0Xyt0c2MJApHZI/9syXmJZFx4J7GGEUVjJGKldYUqhWiheRD41HKTG6nv1vZ5
         Un8WBaJ9FkkGTQC6qxUyq7cuVinhs2Dm1yIk1WWhjGE+FZDGLeYEP5xap+gN/v6mU1v2
         ErTBn5SK/sVESEgcAgTGOTxhVZ6ZhyvAtPn6ooVjh7EqlhaL+k0gItHCbJzd4la/PwJk
         2nyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UZA8MvhgTjR1Db93Kl8ZE7I1AjnzSwS3ydOzQHANga8=;
        b=Eg47u7qQXdmNVkwGqYAV1w/TRxjjthVFdwrWZ9YeWgZFTSGHx2HLwM1NwA39bPCaRl
         B8X4cS6JTbK9T2WFuqFFqznEoui66HIv+xyJCjfk5Esvc5SvOFr0fph3OuTR7kgUeCKP
         TNuyhmRdUclxjpOYPOwMfyBU+tQ6D0ugboR9kOtmOr97gtK6mzxjGI5kfkxEx5T8YMeQ
         +gXd0Gia7uDrzehTCSHtoqdtm85uSSS48XZS/axkpYLBcDa1w21hQemBakEw9aM0h7iy
         TYc8tXJ2sw7olWnyQY7sKifbwoIhnfQbPFXAFHAv97iXSAvl/7EMgk5NMZoqs6rZ4rOt
         zBvA==
X-Gm-Message-State: APjAAAWu4W3J7ze7NoKTQbS3CxD5tg9/Vuvf1qfqwsLa07zzW0hLAWMH
        ozvL+19Z+sU5iyv/se8fKuY0/g==
X-Google-Smtp-Source: APXvYqyLk8hqyXbvO8Cs28biGHLs880vO3AoEuMqCtu7rpPoP/AP/GFODe0/mn2xfn4dxkEXiyQ0Mw==
X-Received: by 2002:a2e:5357:: with SMTP id t23mr19259412ljd.227.1579686475289;
        Wed, 22 Jan 2020 01:47:55 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:468a:1e6d:e8e4:fead:7539:293d? ([2a00:1fa0:468a:1e6d:e8e4:fead:7539:293d])
        by smtp.gmail.com with ESMTPSA id r9sm23922473lfc.72.2020.01.22.01.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 01:47:54 -0800 (PST)
Subject: Re: [PATCH net 1/9] r8152: fix runtime resume for linking change
To:     Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, pmalani@chromium.org,
        grundler@chromium.org
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
 <1394712342-15778-339-Taiwan-albertk@realtek.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <62c3af7b-0e94-c069-0d35-4b5f41031a4e@cogentembedded.com>
Date:   Wed, 22 Jan 2020 12:47:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1394712342-15778-339-Taiwan-albertk@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 21.01.2020 15:40, Hayes Wang wrote:

> Fix the runtime resume doesn't work normally for linking change.

    s/doesn't work/not working/?

> 1. Reset the settings and status of runtime suspend.
> 2. Sync the linking status.
> 3. Poll the linking change.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
[...]

MBR, Sergei
