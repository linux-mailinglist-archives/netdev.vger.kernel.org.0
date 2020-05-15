Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A541D5568
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgEOQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726379AbgEOQAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:00:08 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88DCC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:00:08 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f15so1044334plr.3
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 09:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D1QUEkD3fhiHhXYxvGrmYPkHL3GA+r0J9n0oDb20bH0=;
        b=atyVrudm4RnFirz6YG8rlY2QUHAJVHLbRD+peqU0r48HJuOOd9jSkdSMmiO8HcHin9
         bXJ7mWOeQ1E+l9zeleX6ZgbNfhyxWQ+Tb69GQIWn2xzr4z7ZsCwZENUrocLkakW4Rm44
         tRRT80SfnZDR/b4gpO0Blo20I4VDgp/QK9MLz+QNJv0KkgDlna0pIrX7nOxmZprXexYv
         qfpDZv1XWMcxMKEsGH6SWSKEVv0QWY8JQC52Tuk37qQau7sq6MCtM+BHc7XEIHwhnK9i
         1ZTH08Q/52Z6e06m6wnk5Q0mfnSMECV6BECApFkuqjqr62wn5nYmLbjUDTy3BaGsC2C8
         04jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D1QUEkD3fhiHhXYxvGrmYPkHL3GA+r0J9n0oDb20bH0=;
        b=bKrueBVQBypKKeg6PLUNxQ5b0Ru1Eykug/k3g64E/5PlyVFHg29uxwVKysqsdcGGdu
         SWolv6W7zSUCwI8AxdhwrkLyh5OUKExUWH3Uw4LFU6oXZDyy7Nbo5XQ8rguGDiRGggjU
         dxFta6jK8Sk3ZXDQpL64fYyjWkzUYzFUVfGd49LYm0H3cpAN6vfdwJkhgePq+RwbpSbZ
         etjHWiT5RGVP3JTQUphHCuWQ5NahCDAp17cJBhDi0+3Koi05TOrzj3u4asse9xZnvka5
         IijI85A0HIepieYd3EwPCKVEKkRzBVANXSQXhrwFWjTb8imhJZo5vW6t9AD3vNsR1uc/
         wOcA==
X-Gm-Message-State: AOAM531ycxVjHwQAAys0CNg/RKycbCHvd9/jWhH9eN5qhtnPsp1pVQVv
        wIqupU7BJwPQBrCzGaB0lb4jSwB+
X-Google-Smtp-Source: ABdhPJxTbKPg74atYU0rDE3FunlayKk8riPEqflODvkp0fHr3Az4H4R20AFAraKVDjWPF+wi6LB1aw==
X-Received: by 2002:a17:90a:21cf:: with SMTP id q73mr4241768pjc.230.1589558408233;
        Fri, 15 May 2020 09:00:08 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e11sm1967680pgs.41.2020.05.15.09.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 09:00:07 -0700 (PDT)
Subject: Re: [PATCH net-next] net: core: recursively find netdev by device
 node
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch
References: <20200515095252.8501-1-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8489eb0e-136e-bd91-a4a0-a551d4126339@gmail.com>
Date:   Fri, 15 May 2020 09:00:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200515095252.8501-1-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/2020 2:52 AM, Tobias Waldekranz wrote:
> The assumption that a device node is associated either with the
> netdev's device, or the parent of that device, does not hold for all
> drivers. E.g. Freescale's DPAA has two layers of platform devices
> above the netdev. Instead, recursively walk up the tree from the
> netdev, allowing any parent to match against the sought after node.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Humm, yes I tried to solve this differently before within the Freescale
FMAN driver before and it failed miserably, so I suppose this is as good
as it can be:

a1a50c8e4c241a505b7270e1a3c6e50d94e794b1 ("fsl/man: Inherit parent
device and of_node") later reverted with
48167c9ce0b91c068430345bf039c7be23fa2f3f ("fsl/fman: remove of_node")

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
