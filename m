Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBC91EFE09
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgFEQav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbgFEQau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 12:30:50 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BE3C08C5C2;
        Fri,  5 Jun 2020 09:30:50 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b7so3404908pju.0;
        Fri, 05 Jun 2020 09:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H+RZlOMA4Lnzf9WIg1S0cHVq67OXV25inr43LZ3CCSk=;
        b=fE+VrZ0H9U5U3njDtdC/AeoPwpj9imTedPoPeqRAjIHO7lbyaifYke5kauBsTU0hY1
         rNCENnP4iV+06cRxfxjf+SDV5dj/bU1MjddALrVhkWBwukRrLIVMzK1QKjuPCdw79YP7
         oW9tETjkNCPfoTLe3NnZvyMOKfchyGVDzCL1jCCExMNcgN9hEDZnRRkdz9lElQUxgT7O
         SLRErn9aex7xHx9sDe1FA8KEEbaItFdnUDgfZXTqoB1o9wDQ0jm09ZJ03e4iXqTrGNF7
         BwTDdQ4WeejAJdzjNnSVHh4nugyAP4MfRHdcWD2cwlol0vRA5p1MgIqagej9MKro3f1l
         MGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H+RZlOMA4Lnzf9WIg1S0cHVq67OXV25inr43LZ3CCSk=;
        b=kZNPxujc+q8coLzbO+Ztx+dWpBzUiS/UYpbe8eNbh8ZrBW8I3tczDpIdAGZX4OTLfy
         IeMCIcA5MNla6StbecWBiLdWWHVCC0PlYJem85OGzK7steE67GSnvYJboDwuG15ZZGSN
         +Xj2+rx0FTrNnWdeW4/OsAjhF1rrJoeoTWxD95SrU7fv6hbl7XbaZflMSqQv9KO/lFTA
         6AXMNah9Jc3nGUJyHDJMRy0hU0XrmX8EzeTpB5I2FqubPfuATO8EQFZqDMfruKiEBZGv
         Fz7oBOGfgKqUjZTwU7sp7un8yp4vxJc9lvhDKRFelQf/TsLnhW3BTj5spdrqLC+38oPT
         nTpg==
X-Gm-Message-State: AOAM530mhQwTk28ddUmwss0D2eXkrGDEVAgnApNeXMonBAIdLpXqWKYJ
        1cbVk/SFvz9nYFauxe3aTAg=
X-Google-Smtp-Source: ABdhPJw35bDtFt3OFfM91CvE2E7EKQr25t1KCPdxIVDd6nCKfQS7uaTHicZCj7CNCOCKcyG81i4LmA==
X-Received: by 2002:a17:902:7088:: with SMTP id z8mr10216677plk.71.1591374650243;
        Fri, 05 Jun 2020 09:30:50 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q10sm119252pfk.86.2020.06.05.09.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 09:30:49 -0700 (PDT)
Subject: Re: [PATCH net 4/4] net: mscc: Fix OF_MDIO config check
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael@walle.cc
References: <20200605140107.31275-1-dmurphy@ti.com>
 <20200605140107.31275-5-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6b8939c0-4858-07a1-acaf-b80846a466d8@gmail.com>
Date:   Fri, 5 Jun 2020 09:30:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200605140107.31275-5-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/2020 7:01 AM, Dan Murphy wrote:
> When CONFIG_OF_MDIO is set to be a module the code block is not
> compiled. Use the IS_ENABLED macro that checks for both built in as
> well as module.
> 
> Fixes: 4f58e6dceb0e4 ("net: phy: Cleanup the Edge-Rate feature in Microsemi PHYs.")
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
