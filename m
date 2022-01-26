Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4349C211
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237132AbiAZD2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiAZD2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:28:10 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E1DC06161C;
        Tue, 25 Jan 2022 19:28:10 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d7so21222195plr.12;
        Tue, 25 Jan 2022 19:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=bw+612EkD6lKhovasyhewKKPgB3AQUWv6mFICa+za7M=;
        b=ld1oT4He9bXUyBbjHg1R/+5DNQaZ+bXzlJOztmMPSZXhp9bsCdJFHwyhQev5pRJKaC
         bk/3+WpYbm56QwEix25xJwmpgYvTHhzfXIIm8FMbphg74XJQjBVL1ilbUoHzNggz819+
         KPRKdBIhXkccf362Ju71D6Fpq0Rrhf90WvKkvM0Mgo/Sfma/js0hNoCNNp8jeRIr89lb
         /DoiG2iPrPAm2oZb+nRbSY9n1bxeleECRd3C9GQPRymRK86oRHpY+mf99/inPd4f037y
         zPzdcoPCc+aEAPMAYvmuKI1L8ABbxl/VYEbOR2u2EgLDIHEa5Uk3UWTZCMV0ECmNczwW
         EhCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bw+612EkD6lKhovasyhewKKPgB3AQUWv6mFICa+za7M=;
        b=A6B3i9iLdLGuAdtkcfQv4akAMS1AoVtIS5d5dfYEHaJSfim0PgiQ2HmQXnW4w76KRv
         X+O51w5youaZ+7xREb2IJET/JPcSA7C7WdLN8qWL43F0rGUYZaRZI0ebXHyXfDT/wpuC
         fTcM1BZ5SrMoTJFMh13uNfmykfVM6gLdazeSHfW9DVAPQ0Nxm8xZWHgLSDvbvJtCPD9n
         8PopefHDLsyhaU+ibZBu/8JOTZI1+tpIUE98mZqThykrq5vWEpmyBYSlGpttmdECpZ6C
         ozL93xMO9mw3u9P6Zihtp/UDU/3KNJqOjznwxB7o71gl7F0Uk/yUA2PTldwEffjrNvgx
         Dxqg==
X-Gm-Message-State: AOAM531d29nWeVSrqcJRsBV8fvc2l9qiqupb/NK6Fj8VdacfW6D0A4Ku
        LGTWRHld7WjzwjGFqBhfodGaeGYCrGY=
X-Google-Smtp-Source: ABdhPJy57Pu/PtYgCZQySDmzqVqoqcXJnaz9q+1GsPW5ygjit3En6V5gAF7wcIv8U5dYKEBZCmjMog==
X-Received: by 2002:a17:902:d48b:b0:14b:53c9:da09 with SMTP id c11-20020a170902d48b00b0014b53c9da09mr11251672plg.1.1643167689854;
        Tue, 25 Jan 2022 19:28:09 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w15sm15771970pgk.78.2022.01.25.19.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:28:09 -0800 (PST)
Message-ID: <0dd95c31-d54e-0879-619a-e3fa701e5779@gmail.com>
Date:   Tue, 25 Jan 2022 19:28:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 03/16] net: dsa: tag_qca: convert to FIELD macro
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-4-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-4-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> Convert driver to FIELD macro to drop redundant define.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
