Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1227F282BCF
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgJDQXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgJDQXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 12:23:38 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC489C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 09:23:37 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 34so4135242pgo.13
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 09:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FsPzic/sXAiUE8fsTaUpO+P6/ryYEx3pNlnV52APzJg=;
        b=bAFyt5fiz5eTHTCsKgkIB2b/hlU2zDXXxpKwmrt/XN5alJK6hxwNA4KVms/qvUZmJv
         DaPwoJTluzhJ8uo+uYMrddwVPbtHaAaiPenXx/T1hb/Sw6J8o2k8sJTL14nkPcGwec2E
         B3OcmTQdDbjQ13J7k9UIV+so3AE2y7+wXbtv3MmRNvifVDTQk+5swJM5ko/mpKOBd6dN
         ACKyb9yhSCZmjS0j26UgzwkcGhwaFAjGsxgoxRRrEXXXbiEqdrfXFX9PR7LKFXQskEe/
         330xQOe0sgD+YSBFMvOeaX9pNHpavL9JbGKT6kvw3iYqgEzDFQF9od1Wg2zcNAVzzh6L
         k9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FsPzic/sXAiUE8fsTaUpO+P6/ryYEx3pNlnV52APzJg=;
        b=V/0PO7nFxNev1G5yWZolpLoz+T1G9YvwsaOSJWidS4Sj00BLzl9aFpLJHqGLp79RPx
         WXLEolSr8CYGgNXDy1ybO8cgyFLVveenVkSYreW8lfAMBSyvtRXrZQeQh30FgaMK+Cex
         qza0hEZ7lnL7KW75XEC/nX3vKuvHO0rPD4MuP157Ss+pkPtMGh5acBdjLcsLYaY4iAWN
         ri7LZ02vP+TJ3kywTWPbW9NPblgx7fM+VJLwvFTNpQiSrGmmLSQ9Dk/dxsNUrd3CXx9k
         EvsWnVv7VWFbec4u2gaPvNdaKrvvO69sJLSE+Mdjz3YpA97c81xMP1LipJZMY9cXdRV4
         baIg==
X-Gm-Message-State: AOAM530ITbwdVscMydzSUIN0td5+TTUm692FtaCyoEmUAlxO6WHUgDrf
        JZvBaXwnCwihRfm9qsqQOpA=
X-Google-Smtp-Source: ABdhPJxmUgOwzolpdlAqF6ctO7RkyN6cd+b8Siaokr7bvD7DhhnwV3eVjuqNdLgeuZ5GkIGO49Z1wQ==
X-Received: by 2002:a62:7d91:0:b029:13e:d13d:a061 with SMTP id y139-20020a627d910000b029013ed13da061mr8268961pfc.39.1601828616140;
        Sun, 04 Oct 2020 09:23:36 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z4sm9167131pfr.197.2020.10.04.09.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2020 09:23:35 -0700 (PDT)
Subject: Re: [PATCH net-next v3 5/7] net: dsa: Add devlink port regions
 support to DSA
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20201004161257.13945-1-andrew@lunn.ch>
 <20201004161257.13945-6-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0996b29f-ff62-cfc4-20ca-df2246b9d949@gmail.com>
Date:   Sun, 4 Oct 2020 09:23:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201004161257.13945-6-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2020 9:12 AM, Andrew Lunn wrote:
> Allow DSA drivers to make use of devlink port regions, via simple
> wrappers.
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Tested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
