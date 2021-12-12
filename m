Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5367F47181E
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 04:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhLLD7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 22:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhLLD7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 22:59:03 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A7DC061714;
        Sat, 11 Dec 2021 19:59:03 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id z6so8891263plk.6;
        Sat, 11 Dec 2021 19:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bV6REmp56v7mgL3fTAlBVeTStlABDqoXqIWoZFB0DKI=;
        b=oqqA9EXmUHJUrVrGgJaHcYvuKtzd5/Ck1I2nGsBuub3pfyZa12JYo6OTBmhrB514Ml
         ig9oLWZhoJIEWvHRg4A2ccY2bUGDhNm6T7uJnWzL1tLHo4+KLv3n7AmQA4DzyxqyQ89t
         Won8k0a6sZwBT32slAfFOC+eAjFUEbAbfvGOygD5rLtiIiW+qFGZp5sLsew+/1YPxptT
         mUNa3HP9lLYAO/F0usHbC0+lR9KwRtXTzNovM/ZcodFwLvGonw20uDtTKlQlt9+BYoZo
         s7RsEhG5ORxAFQFMEfspRJD0itJB1dPekpvAL2ELgi1Zk/N8Y6znOaRXikkqUX3CK012
         B03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bV6REmp56v7mgL3fTAlBVeTStlABDqoXqIWoZFB0DKI=;
        b=irznHUveJOxa+eBlwRP71bl/ul+SgHGFFKqb5JpgCUApKC5fCABZYM5uOcx6kaLgh1
         zL85XACNJzzDi9TazThjclblwulsozPhyh8D8FbWcqcmGMv8x+VYs4vkSW0wJ9dDHi9P
         pUJ0tEzuZtbycIofzWGkVv4Si9WKq/sKRaj6oFCuYiXaMEvsrW9sYvpyiU2V56jf1ZN7
         3GDrNO6uikabOxMHZDKy7pv7iJpjwBDQMzHfUxCqYQ+k1T0Z1TMLdMbfRF0km6OWFTkK
         f9qxMRd25i8TGRFznoXcLdPSjLz2HS850wmEjemCLvZUlXuPcf/tkVZKRrPvdOYJPMly
         TFhw==
X-Gm-Message-State: AOAM531DHrIqCAqgmqXmOCKLQQUsefTzHWaBPOd5TzQMIN7n9X2REbk5
        2BPfGtk0cHLWi6+Mu9C7nOatX/mfFqY=
X-Google-Smtp-Source: ABdhPJxMrJMhxFBDLWxhMxqrWh42U3s19F7cqE+WGRskz7vZV9iWi9r1rBY2qVPXmrarABbTrVszVQ==
X-Received: by 2002:a17:90b:3a83:: with SMTP id om3mr35198792pjb.211.1639281542870;
        Sat, 11 Dec 2021 19:59:02 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:4964:df1f:902d:8530? ([2600:8802:b00:4a48:4964:df1f:902d:8530])
        by smtp.gmail.com with ESMTPSA id o4sm3022968pjq.23.2021.12.11.19.59.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 19:59:02 -0800 (PST)
Message-ID: <667d693b-4ffc-8318-b570-78929d6db702@gmail.com>
Date:   Sat, 11 Dec 2021 19:58:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] net: bcmgenet: Fix NULL vs IS_ERR() checking
Content-Language: en-US
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211211140154.23613-1-linmq006@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211211140154.23613-1-linmq006@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/2021 6:01 AM, Miaoqian Lin wrote:
> The phy_attach() function does not return NULL. It returns error pointers.
> 
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
