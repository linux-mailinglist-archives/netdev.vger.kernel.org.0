Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D2042E164
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhJNSgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhJNSge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 14:36:34 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D105C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 11:34:29 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id m20so4887526iol.4
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 11:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9xQtrFZotgR3le8osZ4Uq3of6O65EJqiWkJjIhPu55U=;
        b=l5E6fSgrRX2RMYgdzk+CD+jX/Rqwsv4iVSaMHZnu96Na9EH3AU/LkOKyXmRXTXjWU4
         Mbezma0rNqvbfJMwJzJ7+dSvqVyfFtPd19LJQq47/Np023fXQFzx7z+Hc0pxfXPDlHQm
         EAF5NU28bZVDRJ9lXTTNheT6nz5o8KK3XqtAY8VnJvrD7NkDDU9dOhUkvaxEVKv5vip3
         1gIMVnob6Jjnvzs2FXZmLhYvEPoYYzpw1vtvRYuY9USFcG5ZxdYVHshstB3phDwJc28s
         Hqk5luNlAwZNnEHYyOGS7yS9tMuwsGFBRK0bc7cWsz22l9OVvT5MkbMMYngzs06uokbD
         F29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9xQtrFZotgR3le8osZ4Uq3of6O65EJqiWkJjIhPu55U=;
        b=2LvWbJE+l67kQGb/FGqpBpWY5fQHqAhiM9kZ2k9ponZc6kkq2mOfQRib048UAJsV5H
         n9VHJsTQpmbFJ1+bg0cm1ko3euvMza5KPLErnwLWJgRefhEHoLVVd2R/sbI4dOdxHw2X
         vFfyy8I95Lw/f70521civHpXcPuYoAQZx4SdEA0tE+QkbqjEMorIRq3S4/C5lWDyvdR6
         Vzr0977sNacZyMV/KWJ+wccKdE2qLoXRgwwVtMxjZnOVAoIsrmUJTp8INnxNDoegX9aw
         k88tiWAiE7K/aUmDzn2OpAnE2OdgpflRayooIdfDwvwD4qrGWIMzdj7gESqE+nV5FS2A
         NbjQ==
X-Gm-Message-State: AOAM531Tp1PTC+0F9HWWYB+qvFpM4Jy4xUPEjJ+Fxb9iBn9FO5mbefHC
        q9kmYaQvesKSB6BKgraXsMR0m/RQN5f07Q==
X-Google-Smtp-Source: ABdhPJwbHowJUgzCxwqTSHlFRIHAvXjRoqOSQ/QOoz0RfVMI7EGAlOTqecFLTUkjUI2wmyVoBDiE5g==
X-Received: by 2002:a05:6638:190f:: with SMTP id p15mr5279321jal.108.1634236468953;
        Thu, 14 Oct 2021 11:34:28 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id l18sm1564128ilj.12.2021.10.14.11.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 11:34:28 -0700 (PDT)
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
References: <20211013222710.4162634-1-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1d503584-e463-3324-140a-14c86521cd59@gmail.com>
Date:   Thu, 14 Oct 2021 12:34:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211013222710.4162634-1-prestwoj@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 4:27 PM, James Prestwood wrote:
> This change introduces a new sysctl parameter, arp_evict_nocarrier.
> When set (default) the ARP cache will be cleared on a NOCARRIER event.
> This new option has been defaulted to '1' which maintains existing
> behavior.
> 
> Clearing the ARP cache on NOCARRIER is relatively new, introduced by:
> 
> commit 859bd2ef1fc1110a8031b967ee656c53a6260a76
> Author: David Ahern <dsahern@gmail.com>
> Date:   Thu Oct 11 20:33:49 2018 -0700
> 
>     net: Evict neighbor entries on carrier down
> 
> The reason for this changes is to prevent the ARP cache from being
> cleared when a wireless device roams. Specifically for wireless roams
> the ARP cache should not be cleared because the underlying network has not
> changed. Clearing the ARP cache in this case can introduce significant
> delays sending out packets after a roam.

how do you know if the existing ARP / ND entries are valid when roaming?

