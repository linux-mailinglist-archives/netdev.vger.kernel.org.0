Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8091A264FC0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgIJTut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIJTu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:50:27 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186DEC061757
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:50:27 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id l126so5316718pfd.5
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oCc2CWmgF3gVqnZpdZXUMsZijDpMaSjrdDkdU0em8fs=;
        b=QsSFsdormqYf0DS7TPOcm73Zxu//DicFtmDmRThZBy8S23qGTYT5EB0UlI5KnnuyCg
         tPIe44F0GrK9eVjZTwk6IqFywTgXFGNZlIxrKFTBmlnHVwaWYl3truAPYsciz21hSdp5
         qVqJl/IxDRiEyrJMuy8IVvXgYuEOHy3uEd2LF/etZUxkTXPQ0skFHGVGi40fgNdfB945
         jadl4rXeaR1uboFLMmo/mi5RDI/QWPGG2wZ/mFgYGy2v/YfG74lXZhju/NziVWWhRr4Z
         Y8XE4mHBHmxY7OtvvcMB/TKEoYjmxTAznfkvbij138GH52ACK+nXlSt2dlIjDUY4FK/m
         kyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oCc2CWmgF3gVqnZpdZXUMsZijDpMaSjrdDkdU0em8fs=;
        b=sowMHU3seaDdQuerKn6Kfe/4lva0AjDtprbg2bOe1Mj6NlbOqNP4gsEpIAlVe7mv9t
         yMDpRQAkQ402ptRK0oYgO8X3rvxLaBUf0UAPmvEoGBBeOTmd1P3m5MW8ybqRi2l9L7be
         RkY8uoBGzoSVDTb7+HX20q6YUYG2tZEl94FFx9xcxZKIsiCo7ZgOMpWT0jVu1kiB0vCr
         czHtdVCpAeYBYGzzB9cx+hx9nwEkXbLbeumHhYvmlirfhuMJWHi8Poz8XBOox2AeQ8pP
         vY2qwWmGMnW9E5pNdOQ3U7qgIcKDXTSnPGNXpkFDtzzaqbpSCryH4SKHIMSskTWetJMj
         LXbg==
X-Gm-Message-State: AOAM532L30tgGUxpk5umluCu304kv53O81hBjogIJRssAqXWJGPganuJ
        XltAK9PhsIXI1GLps6VVVL3ew3hoklc=
X-Google-Smtp-Source: ABdhPJyScxh7/JjCEXr0zVSbtldMi0GXnuBpA6THaVe5aa72INReRNqXD0Ccm7cEoZ0ZH80POwV1kA==
X-Received: by 2002:a63:344f:: with SMTP id b76mr5578782pga.388.1599767426202;
        Thu, 10 Sep 2020 12:50:26 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y5sm6344869pge.62.2020.09.10.12.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 12:50:25 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: tag_8021q: setup tagging via a
 single function call
To:     Vladimir Oltean <olteanv@gmail.com>, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20200910164857.1221202-1-olteanv@gmail.com>
 <20200910164857.1221202-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5f365b25-62f5-e88a-c0fd-944e47fc965d@gmail.com>
Date:   Thu, 10 Sep 2020 12:50:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910164857.1221202-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/10/2020 9:48 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There is no point in calling dsa_port_setup_8021q_tagging for each
> individual port. Additionally, it will become more difficult to do that
> when we'll have a context structure to tag_8021q (next patch). So
> refactor this now.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
