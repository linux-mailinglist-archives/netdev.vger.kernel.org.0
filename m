Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6573B7B8F
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 04:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhF3Cgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 22:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbhF3Cgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 22:36:53 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA346C061760;
        Tue, 29 Jun 2021 19:34:22 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id w15so691484pgk.13;
        Tue, 29 Jun 2021 19:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xyUEIZGpIb1NyoL6/ECmCTQUD6rZiw2GeCIvk55fMkc=;
        b=JTeiLvPoNHljuJCxPgGR0yl0ONXcug3EO0DftgEoSPuMWVohtETSFQT67jZIsFMB55
         7dAyYOK6Yy35o4RmGUCtLp4K40ZoahCcgx+HpZFrTTjNLJkrKgxV8CgZvMxMLLcmoArn
         EX0YS9t8RTfwI6doxm4VojM6nVQwse3tmuhjhiycynjG0FsGVUeQGNeqyiiAE+tKJyw+
         JTCbwqn4MZ87vz5XHNqE5+ZKTNsKuDpFOaiDBbZtwD4IqSX62bQb+P0V9zhszRZyHAjX
         H7/3V5OP5PxjGzqckWlCePYwSzqGGaT+UZ9nocTC+og++dpmjrLGlkOTXH3XkWK/YcER
         +yUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xyUEIZGpIb1NyoL6/ECmCTQUD6rZiw2GeCIvk55fMkc=;
        b=Qi0wjLlMy61eKtF417vtyEteQCN0dl11/9NWobUbDM7qPWD8TyanboW5MaBs+TQMTq
         K0Q/WU4v3K78QWUAEJcxaAO+9KEc2mOFKggkq6gUapwjJMuJcaO4gX+1QJgxtTu4jTTj
         8GWzVCryAga01hjJeL4Bo4EbLENfkxPEYmbpsopattO3ca5yx4z1P0Rz/RWHD/w7ov9o
         mbhCT5bHtpM6PD4Lw60eyXrqnX53JJGftvGUh9uLX3guA4PvNXwiZvNCKgrZRtwf1xFH
         gppTU9CtHIuSWAAhwT2d7dZCt8z8BNG6QkGXyE2B4bJNuVi5FAp8bsut7k33QKZ5T2r0
         jnJg==
X-Gm-Message-State: AOAM531olu2BDIu+tB/hMKU8OeZy80AmhKuClhv5aRNc+QHcIOtPupF+
        K/vA0WfHS27eNYf4NrNPVIkGTqYqJZo=
X-Google-Smtp-Source: ABdhPJwfbyymmzhlGHY5wfS5TI9dKLhBfKmIkiJqamxf2F1ZSxfihIfR97wOK0VcD8yeX7PgncW7xQ==
X-Received: by 2002:a63:ff4b:: with SMTP id s11mr31635563pgk.436.1625020462030;
        Tue, 29 Jun 2021 19:34:22 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id w21sm5964589pge.30.2021.06.29.19.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 19:34:21 -0700 (PDT)
Subject: Re: [PATCH net v2] net: bcmgenet: ensure EXT_ENERGY_DET_MASK is clear
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210630001419.402366-1-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4a6b88ef-fbec-e5bc-f4d9-0abaa6ae799b@gmail.com>
Date:   Tue, 29 Jun 2021 19:34:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630001419.402366-1-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/2021 5:14 PM, Doug Berger wrote:
> Setting the EXT_ENERGY_DET_MASK bit allows the port energy detection
> logic of the internal PHY to prevent the system from sleeping. Some
> internal PHYs will report that energy is detected when the network
> interface is closed which can prevent the system from going to sleep
> if WoL is enabled when the interface is brought down.
> 
> Since the driver does not support waking the system on this logic,
> this commit clears the bit whenever the internal PHY is powered up
> and the other logic for manipulating the bit is removed since it
> serves no useful function.
> 
> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
