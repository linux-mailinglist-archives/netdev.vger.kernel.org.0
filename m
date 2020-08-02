Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDCF235A71
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgHBUTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgHBUTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:19:15 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3B1C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:19:15 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id r4so9074679pls.2
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6W6gscY3FvsT+aPvaJ6FnBOb7P7v6T/gkiPB9tDOYZI=;
        b=q9fHZDwwPLndBgmDLwU38jcuTDoBGsSghrc9P+AD4UPiiM4C5oXiMJDR22oKi5URyN
         dIDKEVZTc6fC1Fk2PhPecV+sPCQDeVNCCOnM8NfeBifV673lhV5TVMWbB01kYbi+IrS+
         FG/R2/E1Q0aCYd/tTDOmnzmTOJHqPbdH3qmowDvIChw+rfmgzAVBlNwooUmi4U5XJwWS
         FFmsHmRoVyPhNlWKh2yjNTGYl65FAtMP7YJM7Lc5x0QdkSNnIJwYn8KzeFelwg/lXyLR
         d5MY9L3HH/idr4isozXllqor/6gFRfssCmIheX/cWlEpSiFVfmqfh5BMoPVkpZDgGRvX
         D+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6W6gscY3FvsT+aPvaJ6FnBOb7P7v6T/gkiPB9tDOYZI=;
        b=EWe7ZVuTUyJmRrikIaZIYfuAtTbaVixYdrH0s60WInvFin+rtHQXNCIG2XbQ7k7n3c
         br9Y+M8bbPICqSFc15vO+TkFnqoJUgK3UZ0jmkCIGVdTWy5jKr5hR/i9AaBOX3lLVDnq
         rSYDxMrJDbpMlgo5eVVtfsvBnRcsAWPYDbIi2NDYI11KMnuTvFYQEZh1G4zYjVmClsn6
         U7ruK/lNYCPqcPvHuHjpH3/uedu8YzpTW/aC65XyMHHhNTE57iw7QtgKGVOrysYTLR/o
         yI8YIRonF3+qTzJhWR/00fsGiT6sIqCht3fU6biPkfRaVXMfQN7TKI+oLT9R6DW+nuc4
         HmJA==
X-Gm-Message-State: AOAM531i9o8MMHgv77rkivXNiXKEGqmz1TH2/yEOIerQz8hBXxWtRFt4
        TY1pCAlZ2TjdUwO0N9KdDEc=
X-Google-Smtp-Source: ABdhPJwW0Jqfl+o82E2zyEIbvTlHPbLEtQBBe/A1wZ+VHcJm3wS6cwLm+uSp4xoRRRE8yVAPBrEDmg==
X-Received: by 2002:a17:90b:4a07:: with SMTP id kk7mr2824992pjb.125.1596399555004;
        Sun, 02 Aug 2020 13:19:15 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id i196sm17116744pgc.55.2020.08.02.13.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:19:14 -0700 (PDT)
Subject: Re: [PATCH v2 4/4 net-next] net: mdio device: use flexible sleeping
 in reset function
To:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Fabio Estevam <festevam@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
References: <20200730195749.4922-1-bruno.thomsen@gmail.com>
 <20200730195749.4922-5-bruno.thomsen@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4a5f25f4-e7ae-5ab2-6991-4bc6e972b9b7@gmail.com>
Date:   Sun, 2 Aug 2020 13:19:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730195749.4922-5-bruno.thomsen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 12:57 PM, Bruno Thomsen wrote:
> MDIO device reset assert and deassert length was created by
> usleep_range() but that does not ensure optimal handling of
> all the different values from device tree properties.
> By switching to the new flexible sleeping helper function,
> fsleep(), the correct delay function is called depending on
> delay length, e.g. udelay(), usleep_range() or msleep().
> 
> Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
