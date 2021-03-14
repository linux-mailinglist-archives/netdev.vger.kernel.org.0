Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2859833A233
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 02:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbhCNBlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 20:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhCNBlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 20:41:23 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD29C061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 17:41:20 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o10so18332089pgg.4
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 17:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BRA6bXYmV8FweMMkwxkbvOMmTEfk9WEd+nrzyfjwTYo=;
        b=MV3Ni6LlyziBcYNihcfCyrT/WXDEKXws7Hyj4Wh17jP3fKGTrmJdU1morQqTVRTlUE
         Z2r5keuxZ/HxVUerEdzhXwHN5gqgQUEfT7eF9jPGK9XloGyZS25bKUsorSf2Cg/UzUnu
         WxQUwYBfSs7/7mAaJ2gPuO6z3h6yyOcnfdVYcFn0rheo6kQ8CsBhu2weCdg4MUAJRo1M
         htvcTQWxu0dlIt0c0GVtgRwuYI1cRhKiTPTunHS/ALbQweBQS1vBD7lorB+CcVKMQitt
         Ifm5PaLbFTwg2JbwxQ1Xk5GHgTlAZFq82IScoxFmeLxHKLuYuQ++k9fh3/eKNkKPEp3T
         shxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BRA6bXYmV8FweMMkwxkbvOMmTEfk9WEd+nrzyfjwTYo=;
        b=HLKZ8xUiClvOyKo9p/Ic3oVIlr9AufwuHAMgB8HxeHlOCYXZ7sBmJ8i9ACHOXVDSht
         Lp49vMsVIyMaO4RDjjSxwJdwl6toLfioUySbccn9h5bhH5cvkjfYWek/YX334v6p+XaV
         uDuyTssRF/YfQVB2lnbSChqm6T0td2BrcvWK+SX/+eP0eloZwseJ35ZyBrKkGlVIW5lv
         rH8aGXg7cik7Whl1PyIkKZ0aBSmkUpo5YGw73j1d9DwM+Di1eQSCE5Hr69lJk0/bnVOp
         k6g6hjhip4IaZKV3uHeqrnGUYUJfu/C8XBlohDiL2xymV/uI7ZHCbSjGWRYm4yaAlDgY
         ljBg==
X-Gm-Message-State: AOAM531W6VjoehnPhelS9RmMTH2Yf7/YK9HD49IW5sLjrW9rrTI1Kk/Q
        ndwTAr98bh/GfOaPPbzd9KANhl8ybKM=
X-Google-Smtp-Source: ABdhPJwkZkpV+5Jor4uX27on42TBeRwqob3aZglRSTLREkaueMo0E8bHpVPDekzOfut9J2X6tdgIqg==
X-Received: by 2002:a63:e44a:: with SMTP id i10mr17400120pgk.404.1615686079550;
        Sat, 13 Mar 2021 17:41:19 -0800 (PST)
Received: from [10.230.29.33] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g3sm10068744pfo.120.2021.03.13.17.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 17:41:19 -0800 (PST)
Subject: Re: [PATCH net-next v2 3/4] net: dsa: hellcreek: Move common code to
 helper
To:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210313093939.15179-1-kurt@kmk-computers.de>
 <20210313093939.15179-4-kurt@kmk-computers.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4d1a776d-18af-9d54-1f63-a9ed409c2782@gmail.com>
Date:   Sat, 13 Mar 2021 17:41:17 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210313093939.15179-4-kurt@kmk-computers.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/13/2021 1:39 AM, Kurt Kanzenbach wrote:
> There are two functions which need to populate fdb entries. Move that to a
> helper function.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
