Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC37826EE1E
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgIRC0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgIRC0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:26:20 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70D7C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:26:20 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so2553923pgl.2
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BrUSnC0mCUZoH0wH/VmytCO2ZixRYVdUsUsdAtZKRYg=;
        b=JK3ZJye7UR2kXVIgYMGtq5hpUmeEfbHAjKIu2e1qlSmZ7FJxonkz4ygV243syJDbVi
         xdZu0UqzwPLDOsJAPTXEiB5BZwKKpcgHuBPkA2CJdbVxSUnnwWMVzCQ4WwlUMpxWYDJC
         PnQN2Z5CKEtZ2Hf75oZMhggNTGGmQ2kiUQVBumUmk1fB6ndJE+/iDE7oGhQneHm6R2wo
         6bTFwExG6E00yFjnyaJXOOJoZPmckXcwymUXWs0MM/Ss5tVgEqzZxYfZWGOn6x8UtVqP
         Oa2Mxd6Q9lFUbsz1VglkYQo3T5d0g3F7EfsUzpvs55M17y+wCsZj7XmljUMWmv6CqidZ
         QP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BrUSnC0mCUZoH0wH/VmytCO2ZixRYVdUsUsdAtZKRYg=;
        b=b6pVQdb/pJSA4QFt+yvD9e/gVRoNR9+/OCYTkq0Iwwsoem2d/qCo2ZDbNs/CKv6a9q
         hRfVEGoHdMc0qMcEKq+NjEvb3TYGjqhYCh2JmdlhPZxZxG2Ql4xJ7HQnPi9plx70ndHM
         JzuWZL1M6CVTNli8PrF9EWbuswecmtKp+a0qTIoqVVn9hi6vXUgVWOSzJvjEBwQGCVh6
         rMJXFfokKXtgsqI+smi0+YaJal60FnNZ1f67dZD2md4nub5EdkCT5RJ8qnzx5J8v2SIj
         OhQcQ9gJhCZ5VRaVL3hXoXhroV59SiZbRjmhMG0BupBy9OU1RcqBSxNHKtbXPmgcI+0h
         qUsw==
X-Gm-Message-State: AOAM5313Mqg7xfVSgL4MDmhVBJc4YekPBMYNeztq8hC8lvKUVkR+C6Ih
        SLRxvqr0kTE79cPSX0HWQ+U=
X-Google-Smtp-Source: ABdhPJx/2BegA8CHCrgdPiglfnUqOciJlzrBbk0UOIyGiVf9j4sqtrQbIaCL//LdN7slX0SJY5R3TQ==
X-Received: by 2002:a62:26c1:0:b029:142:2501:35ef with SMTP id m184-20020a6226c10000b0290142250135efmr13195512pfm.79.1600395980287;
        Thu, 17 Sep 2020 19:26:20 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b10sm980230pgm.64.2020.09.17.19.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:26:19 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 6/9] net: dsa: mv88e6xxx: Create helper for
 FIDs in use
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20200909235827.3335881-1-andrew@lunn.ch>
 <20200909235827.3335881-7-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e48aa0b9-72f8-a967-c896-88ba53617dbc@gmail.com>
Date:   Thu, 17 Sep 2020 19:26:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200909235827.3335881-7-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 4:58 PM, Andrew Lunn wrote:
> Refactor the code in mv88e6xxx_atu_new() which builds a bitmaps of
> FIDs in use into a helper function. This will be reused by the devlink
> code when dumping the ATU.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
