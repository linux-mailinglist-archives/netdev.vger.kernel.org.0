Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C48A1C7C5D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbgEFVYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728878AbgEFVYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:24:17 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577F2C061A0F;
        Wed,  6 May 2020 14:24:17 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ms17so1599417pjb.0;
        Wed, 06 May 2020 14:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qEFVXmKO5kMfWeWugqhBonvnrOemaIWnCcTFn0Q/jzU=;
        b=TVS1/yv2Sppwgh2iNN17Ti7v2bNzqatDrYGLVInJ31yQlKh6dwxguQ3peYq9/FlrA9
         S9X19MX/ODodXfx494AafbBQOJys6imFXVq4iu1GYDShHuDN6IhuX9PO/YPkxm2n9GOY
         GZy1SDwzm8mH5cZFnLKAATDHoL0w5ndeWBtoSfyN8zJhatKb0gVxuugpGKTXmPsKjXmE
         Uh5IVPAszfKuPU6at/vOcuALTm+1uGHu7YIqtq4ihVdLbWIkjQvW6l4XuzVpIx94c4D9
         rSr3SgYVlpyiGc650Vb4uGTEu7LDHSeRuE6Xs2DlZHzCSA4T4QAxXjTliCyLOEsq0SDX
         YwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qEFVXmKO5kMfWeWugqhBonvnrOemaIWnCcTFn0Q/jzU=;
        b=Nr+KizACLcuKpFm9SmtP4o0bP4dD1YBVFpurXnXmnASNEtdQUzPG8CrM/h/7Gm6+WR
         Pr2MYk886AT+Nb24JO1gfMLu/IQqUzqB5jGv4QsOMll/7+sw9B6lycGRnQxEiG1pe63Y
         p9xlFh5fyXaBJ4b5mdgYeBvxRYtP9YX9/cQduSsHN/tf4yZ8oKlXfgSRW3ch2gygmIzf
         Og8nJ95LJTo3t2M75wxfqv81rkpNoWEDRDqSkUMouniB9O3KAUYXvuIdINq+zX3GZ/Z4
         qP7FeT+dMOX3Wz2h7pewShb4Eez9kiFEoER1qUQuHSFpKoMbce6eToCurXIg0mPxvU5Q
         HQZA==
X-Gm-Message-State: AGi0PuYi7LC2C5zOWUwDezedsfUECh3AwEFcAQ/HW+ACZg6D4qKz38WG
        jw00nGW/5OmGFMYjsxfvyQTVg5kf
X-Google-Smtp-Source: APiQypLU1rrY1dsf/YEVp/nbsvlzdDdVmsxnrILCvnWZqjUGXkFJRZtCZfmeHITrkDRRWRZ4eNrgEw==
X-Received: by 2002:a17:90a:b10f:: with SMTP id z15mr12137304pjq.188.1588800256275;
        Wed, 06 May 2020 14:24:16 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm2912545pfd.54.2020.05.06.14.24.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 14:24:15 -0700 (PDT)
Subject: Re: [RFC net] net: dsa: Add missing reference counting
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200505210253.20311-1-f.fainelli@gmail.com>
 <20200505172302.GB1170406@t480s.localdomain>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d681a82b-5d4b-457f-56de-3a439399cb3d@gmail.com>
Date:   Wed, 6 May 2020 14:24:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505172302.GB1170406@t480s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2020 2:23 PM, Vivien Didelot wrote:
> On Tue,  5 May 2020 14:02:53 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> If we are probed through platform_data we would be intentionally
>> dropping the reference count on master after dev_to_net_device()
>> incremented it. If we are probed through Device Tree,
>> of_find_net_device() does not do a dev_hold() at all.
>>
>> Ensure that the DSA master device is properly reference counted by
>> holding it as soon as the CPU port is successfully initialized and later
>> released during dsa_switch_release_ports(). dsa_get_tag_protocol() does
>> a short de-reference, so we hold and release the master at that time,
>> too.
>>
>> Fixes: 83c0afaec7b7 ("net: dsa: Add new binding implementation")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
> 
Andrew, Vladimir, any thoughts on that?
-- 
Florian
