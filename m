Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1898A414DC8
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 18:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhIVQLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 12:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236568AbhIVQLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 12:11:37 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF01EC061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 09:10:07 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j15so655023plh.7
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 09:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6yIzAKDKHvIM1DVT8xTcKq4w3iUCl1AEsIyruztrenI=;
        b=nmSTPvjoSOWEniS/1shEpYAKlnc+C1lnKNHQ8w6dxX2ohQPM/g56kF/76tftfl+vMQ
         aDLIwb19Q0qOt9eu8pD90BlI3G/BFw34Syra9/l4Ia/hXaMoIWFQHhUOkHkxdeWfU8YJ
         VKOWoifbn2nQVsTnZtY10kU9PCJXat1WJ9Sz5ImxyR8il8bCrEIcjZQPlFlOQXAnk1rV
         NcCEh1+wYHa2uNdUBl2oJdqbYWLxiZHqAtYBlZJ8sLD3Yw6jUOYcmabxloLYpZ7X3GQp
         X9OfBLtRp8/Q8SYn2Qp4eiNJ8bUoClhtTxSP4B6itvq3XAu6LHPCTfaz3BLKpPCava2U
         NqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6yIzAKDKHvIM1DVT8xTcKq4w3iUCl1AEsIyruztrenI=;
        b=nNVKnzX13iM0aW+KDTFLuqfncQPa6DEHz3YGkXCvICvSYJPBOKAUgwl1J8wmeuJjuy
         8N6G1MEzy4upRPS1h5Z7u1q57lDULfSMY7pTyG57LhOHYcxN6+DfJAkfuD6s12j3b9qp
         5b4J9IXx9IrZyqmo2llE4HZZQB/ZP9T0QevmAXN3yycONdXhCc/Jq/OhTz8j8ajp5tnG
         nDJHNrtdHvUtpQwbZfFirw6WMDi/Gu+pKAn7Q4V0RnkgEOV4PBfvAgbAQV1ZtqEEZPj9
         lgPz/BInnUUf6HR/kZ/9s1jRZtBzGMZsL362DhZZ11OgdJXNiR15ekO370wXDz1RqWRP
         UnHA==
X-Gm-Message-State: AOAM532F6QKm7kR30yZVxCmMBAoevJvIVpgno2cFJIL6Ra6CknqRUrNK
        Umt4JE543wgmn8J9BOtXvzo=
X-Google-Smtp-Source: ABdhPJx5KSedBZY6AK9HC8Q6APIApHbG0Cp9WmVpnVNO9SDugOuYLeWQSqySowLty7M6Ch+MYdX/ag==
X-Received: by 2002:a17:90a:11:: with SMTP id 17mr200436pja.238.1632327007465;
        Wed, 22 Sep 2021 09:10:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b3sm2911998pfo.23.2021.09.22.09.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 09:10:07 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: sja1105: stop using priv->vlan_aware
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210922144401.2445527-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2132c4bb-dac0-b2c7-50b0-31a9873006e2@gmail.com>
Date:   Wed, 22 Sep 2021 09:10:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210922144401.2445527-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 7:44 AM, Vladimir Oltean wrote:
> Now that the sja1105 driver is finally sane enough again to stop having
> a ternary VLAN awareness state, we can remove priv->vlan_aware and query
> DSA for the ds->vlan_filtering value (for SJA1105, VLAN filtering is a
> global property).
> 
> Also drop the paranoid checking that DSA calls ->port_vlan_filtering
> multiple times without the VLAN awareness state changing. It doesn't,
> the same check is present inside dsa_port_vlan_filtering too.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
