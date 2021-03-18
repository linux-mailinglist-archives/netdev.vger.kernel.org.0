Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B3B3409C3
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhCRQLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhCRQLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:11:01 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C18CC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:11:01 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id n11so1746714pgm.12
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KgarJxu4epf9ZmOqZzzmA6Mm5gzlHqtt44vTxvX8JT0=;
        b=rTeGPm9tewzqRyaYC7t/bAMlaZWqn1JaWmtEVJTl+iVjkeG53ePJtJYX2VsAtJ8ogT
         VyooeI2e3sFEmNTrbDzX5U/oha/orrsYzPpVmt5z4bI2etDd6NDEdiHa1En+pYNRRNwT
         TsYFj/bo77fMh5oMwRbr6HMKO6yTcmA/Z0U2OHfRMzSL4XCPy09T1vt3BhzHHmzrKpMx
         8hw8a5eTV+/II1lcxhpeEPU3yKGmb/Nlk24o7RbjHndc2hEhz9Sf3tLifv23pOSrtEfF
         jDC7pmWzGecAJpIPMdSdymufvdfoUerF+XHsQNkGw1ZlwA7k3SbtIavobA6XSC1nLHfG
         4h0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KgarJxu4epf9ZmOqZzzmA6Mm5gzlHqtt44vTxvX8JT0=;
        b=UAgiYJbrPbFy0psIitHv5sZKWOTiKOLdJxTD8h+kokE+q5cVG1tDaY4XBx383dTeUw
         ix3LhxA34Msby50eg4ZAU9rj7M1Il/Hl/jDmFCr8K/kaZYwPslHrR8cTiAHDyrTi4kFY
         jQaTYbXnHOjiovdrccUTydCIJXEJzVw+UNtyM0bc3hNuawpv+8WNKB/fV5R7ddVGsE70
         3KU07keqlo3B7O2nOb9tLmsxpw8ci7GJs6kbj18HUxuk6EntHNTYqLe+cyNZgAfXCkaw
         NGvnIAGoF1V58ar9ywfLFj+bY5jqOji7N9LHsAqfmTk3DX3cgV5rfdn9chfW0EvkId30
         zmlg==
X-Gm-Message-State: AOAM5323N5TFaIqMFJXtyyNGru6mbdpOBod+ZDjBtgZLUphfGi/CvsOO
        1YL0drlCfF2HXC7hEjArVzLFHbkedms=
X-Google-Smtp-Source: ABdhPJx0OgZhkLiP9+aRgtQ1nlqUyp78potR7fmkxFL6cRV3aV+v2J2RLxbwt1iDTqgx3svrVmlrhQ==
X-Received: by 2002:a62:1484:0:b029:1f1:3a5d:8c23 with SMTP id 126-20020a6214840000b02901f13a5d8c23mr4892248pfu.22.1616083860724;
        Thu, 18 Mar 2021 09:11:00 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k27sm3064028pfg.95.2021.03.18.09.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:10:59 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 5/8] net: dsa: mv88e6xxx: Use standard helper
 for broadcast address
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-6-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6d8f70d2-27e1-516c-906d-6d104b2cdb4e@gmail.com>
Date:   Thu, 18 Mar 2021 09:10:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318141550.646383-6-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 7:15 AM, Tobias Waldekranz wrote:
> Use the conventional declaration style of a MAC address in the
> kernel (u8 addr[ETH_ALEN]) for the broadcast address, then set it
> using the existing helper.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
