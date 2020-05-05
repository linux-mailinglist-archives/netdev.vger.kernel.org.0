Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786291C4CA6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgEEDYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:24:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62453C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:24:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u22so221304plq.12
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MlEIOdG0xxrc6L2coR6FXm3xbvB3ua+KHRqiMiVJzdo=;
        b=Pntko0dY16p/UpsQDnrtJORuFVHHJmmBHMjcdDUHZtCvD1Yvzntb6NEpKoZXYYBp51
         oip9kEgQMa9JFZ6JBixekdOUw3A/fo+cqSNOrZauRfupHTheFS61XxCifNIUPBwuWiKP
         hk9WdFxyi1pToZep+RSx0NdmyNqkAd010WW1u8isYY/V4sj/PV/cVsOgm0iIWFFgQvWz
         iAsAF1sMGywAEkd0bwMdtEfUjCSsTz8lcYfs+YrlUTgZTM+Ce4kKkUE/lBBz1f7WHOfP
         FPFVQxhdYYmx5YTNFvjLj/EmE0ixNxrnHsrUCrjZNZMBglNkp5H4Kvsdcv/54hfZ6bRV
         Osjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MlEIOdG0xxrc6L2coR6FXm3xbvB3ua+KHRqiMiVJzdo=;
        b=d1yI1uOzcRt4jHR/XnM/ua85bGZYAyRQlEhPvbViOloYIvJWGFbwd9YQqEjW7FFA/h
         reRjtK/CjKETm8kSenCTdGAXoX4qc9VPb9uUHnOpkaf/U6MGyUaeokswP+r7xSLuwc5w
         1xMDAIEpBXckmEXpKt7dP/feoGL9Z/Ih8nvcnJ1d5ljPbfXg9n+kOFj3l00+8ujS5luy
         lTFqWgyC3FgMA5dr/tPRGGd0e7IGe3SdxPIRRLqKkB4lq1uRA50cA/qITmleq1utsA58
         4Tbqma1iWzBkLiUY5ajhct8cncwyxLDdifVANATvSyKj77TpMMkgnFvf6yq76M72tBlF
         vJAw==
X-Gm-Message-State: AGi0PuZAjqK/kZGYcdjFwBDCoHVFPUwEszfoW8GbATXkTakODxSWu1vu
        tlTMotd08sx/tRzDDA/9Jdg=
X-Google-Smtp-Source: APiQypKHM5JBf+gNh8ktcfl6Z9CdWFgv5Eh3uTKKVHGo/a7pwEqX1RnNIgx+YxH7ezPyq+3OfZ2HKg==
X-Received: by 2002:a17:902:9693:: with SMTP id n19mr863018plp.277.1588649059923;
        Mon, 04 May 2020 20:24:19 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 19sm500903pfj.74.2020.05.04.20.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:24:19 -0700 (PDT)
Subject: Re: [PATCH net-next v2 08/10] net: phy: marvell: Add cable test
 support
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-9-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <01b22e98-02cb-fddc-6063-aaf87d528e4d@gmail.com>
Date:   Mon, 4 May 2020 20:24:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505001821.208534-9-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 5:18 PM, Andrew Lunn wrote:
> The Marvell PHYs have a couple of different register sets for
> performing cable tests. Page 7 provides the simplest to use.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
