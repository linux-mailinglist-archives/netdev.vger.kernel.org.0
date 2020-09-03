Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D9C25C350
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgICOtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbgICOV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 10:21:27 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F10AC061246
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 07:21:25 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o68so2468023pfg.2
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 07:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KH+yRYxSgI9Jbg/6cCoFFbxDSmLLK6Il9BhXS+8VqDc=;
        b=Uj7JG+kEHxJAr7PjxSEI0nLi2WKARhhkw6V9njnPTzL8035LCRrmE0qYchn7lVn+Tv
         kyf/Vwj4YKr0nnuBv34Jmbmh8b5IRPd7UmPDgQAANWDGWSy8n+OtKUaLnMs2AX55O0Ip
         LmNA2LeC3pfCX4ztJPF/CK44wMnoRC0Q9JPzCaXa+tIHGUIapjc5VFmjDt5QHDUT/nQ/
         wd07gX3I5AU4iiOaDR6KSyH/r7HTsvK4Dm6ww9p1ugTWVp8oKY2hhgFvrgtn2EApfOZ+
         ak9Tzm5iOQEVFvyJUPnvSSB/CYYZfVkagp4f+y7OHp38jsh1BmcJmxelX3J8p3Z2chAi
         EHOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KH+yRYxSgI9Jbg/6cCoFFbxDSmLLK6Il9BhXS+8VqDc=;
        b=ffnuIdbaYHMK/sKnfNeT2pLkYYVBWdR+Gt/o0LocGPQGkJ8HNZBFuyKl6H34vQqXjt
         U8tuhhd37rooHgLLdXScI7zM2dZxhWf3SDamGFf8yRy6DTMww52xW4XRKDeZP9SCVnTV
         BNdxA3aKm6+oO8AGexLnCSmzv5NJDqOq3ovE6oGRZV4SXDlSCitQ3d+Rg77qVBNwqPI+
         xfpaVK+YlQJ5fySlJCgMawnLE8jgo1omQ4RCwXpFOyFRCt6OKQNavqmFmf1JYX0OVj0s
         7ml08mvVzroG9J7/c6iU3NJK+Tw0H+L6fT8+sRhEQil3Y8w0+gcYmSZKGHau0NPbSt0F
         P87Q==
X-Gm-Message-State: AOAM533+pUKnwlsC0bvZjG7W0DBq77OPL/CizywhwlK8WFLBfeDH1lWz
        QRfpPx9EU5nLJrCPo/bpZ9gCwxxMNTM=
X-Google-Smtp-Source: ABdhPJxZdD1AfeAqA7ei8ibb8JLeDhNklF2kAHlSDcIAIG16Gsb3GKEmYwpIdrZ9VjeoRS5pH17BDA==
X-Received: by 2002:a63:d157:: with SMTP id c23mr3182524pgj.281.1599142884714;
        Thu, 03 Sep 2020 07:21:24 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id lh6sm2619038pjb.15.2020.09.03.07.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 07:21:23 -0700 (PDT)
Subject: Re: [PATCH 2/2] net: dsa: b53: Print err message on SW_RST timeout
To:     Paul Barker <pbarker@konsulko.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200903112621.379037-1-pbarker@konsulko.com>
 <20200903112621.379037-3-pbarker@konsulko.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e7c7d67a-c321-f5eb-8780-50ee22a32f17@gmail.com>
Date:   Thu, 3 Sep 2020 07:21:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200903112621.379037-3-pbarker@konsulko.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2020 4:26 AM, Paul Barker wrote:
> This allows us to differentiate between the possible failure modes of
> b53_switch_reset() by looking at the dmesg output.
> 
> Signed-off-by: Paul Barker <pbarker@konsulko.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
