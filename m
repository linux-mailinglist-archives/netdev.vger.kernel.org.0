Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A223F7AAF
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhHYQfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240473AbhHYQfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:35:23 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3516AC061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:34:38 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t1so276167pgv.3
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6AgabvGbeQ0jotpRjTlzZslfKdS2VbF5zKq4ef0mi2M=;
        b=QHV5jfJJp3iGc5ZaoDIwGBu+D6WLy/ziP9xrUqKGBvz8R9gmbIBvYIRPGxW07gNG8b
         uHgZ6oasIy1wNRaiPcQSctIYJw5W+AW9FabjyKrei+qYPaOZvRsiJ3CNp55O5rN38Wsd
         aD/DIufc46uV8BirNWzlmhXpcvWpKXWKxvcWfl3vIVYH5BzrgQ8FVCWrF6IbEOE5YUUd
         QFs2CBnnzIm7NWkRP+MNabtnccfNNso4HsM7Yy65i8mfKtmVr3TlEV24NU0jK7yKxR98
         0Er8Z+ochaJpZAGSNEl0S7o4rY7HM9AY+XL2E4SOZG3jJDlL5pCLkIe8GfogvA7gbLV5
         1mzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6AgabvGbeQ0jotpRjTlzZslfKdS2VbF5zKq4ef0mi2M=;
        b=ui5Xgpus6Qpuj/rZknsd19+WqAwCO1Saou5JBUL2xrCSa7KZcG3HGBByleMKbuBjel
         /9fAPtJznV3QfuhHLzSmRyba1ApD/VXoHTuZdAeElFqQybRx+9Aq57ieIBDbWRfw/yoh
         Z8Jsq8/fidg4W8wICrgRZYvuosJpQp0MD5lltvk055PkBeTMK99pkVYp7x3Az/MJiCYQ
         K183UBSNpy52X/7oAveoGVqcL1v4X+o/EVMymLZv+Yv4AFFUuL/7zJwziUnGHfq/13Pm
         2RoyqKI3Q938fc4LndFHF0q70wBeSZ8J7eeAhgMjaAogPjhv8oD+ZAdzxjbwReLdnVD2
         cfRQ==
X-Gm-Message-State: AOAM533XDdfzGG/kRa0pB8f+i175nivYkNKISm3Q7NpcHjIFsJMMMBRg
        dZkxxJR2eHQshQH297ec3oY=
X-Google-Smtp-Source: ABdhPJzpz1gfNGXXue2dUHA2hIh07V51dEO5KmmlCaKucn8UCTfUJdDRAY/KngSLwmuGFjjzwVboQg==
X-Received: by 2002:a65:62cb:: with SMTP id m11mr43046027pgv.425.1629909277763;
        Wed, 25 Aug 2021 09:34:37 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with UTF8SMTPSA id t28sm302321pfe.144.2021.08.25.09.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 09:34:37 -0700 (PDT)
Message-ID: <cd749cff-9f9b-3757-4155-3a705b4b93db@gmail.com>
Date:   Wed, 25 Aug 2021 18:34:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH net 2/2] net: dsa: hellcreek: Adjust schedule look ahead
 window
Content-Language: en-US
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <20210825135813.73436-1-kurt@linutronix.de>
 <20210825135813.73436-3-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210825135813.73436-3-kurt@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/2021 3:58 PM, Kurt Kanzenbach wrote:
> Traffic schedules can only be started up to eight seconds within the
> future. Therefore, the driver periodically checks every two seconds whether the
> admin base time provided by the user is inside that window. If so the schedule
> is started. Otherwise the check is deferred.

Uber nit: this probably ought to be just one sentence starting from 
"Therefore" and ending at deferred.

> 
> However, according to the programming manual the look ahead window size should
> be four - not eight - seconds. By using the proposed value of four seconds
> starting a schedule at a specified admin base time actually works as expected.
> 
> Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
