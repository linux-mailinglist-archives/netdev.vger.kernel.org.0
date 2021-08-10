Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BCA3E56B1
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbhHJJWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238896AbhHJJVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:21:45 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB782C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:21:23 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id a5so4453184plh.5
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HumO565XqpArfFnKf3DqlF9xXZ+1zUxgjeBpq2C/Zis=;
        b=iywp07O09DDTHwh5gEb2V5j0BUh8BJlN0ib4gfLbxoPlNq4X0AqD4th+UPIhn/0kBi
         NWf1ZF9XPw+x/L6KfYy5dN1cn3SpwuwJcB7HUwNb6VJmCAx7V9U3YZExvW0s93c1kRNw
         YgeqPbTIE92Z9JNUdeq+k4yKt2X5qycAA+tXWw4BllCwf4pFK7RWKAF/4smpGnc8r6JH
         6LO3b+ORa4RR9S92QXn+BI6+zLwObVRmmL52y+/2F02gWwgYnc8SIsy9JpY6I68yIp9Q
         9JOhLasooKGjpPyBgwgQXvApKbpWozjAsPYtdwRKp7/AtFjqwPcgYcsRcmrkAkBD4gJD
         fNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HumO565XqpArfFnKf3DqlF9xXZ+1zUxgjeBpq2C/Zis=;
        b=nAxXJig7ClQhvUrS3pkhvkc39WkqnOLC5Igm5UjNYHIZKiZqHxSfzy5Isdj+/MPPV/
         u3l3TSQqPD/5QSsWCX2nz6UM9Yp7luKHbxq/BTb1IhocRS7dFNcEAedBKTdt28rHM9EF
         Bnq2W5drm4bQwIKtuYDVKH8Bnp2F66fbG3pmUfInvjaP+N+9C1mjHbJU1TQpZpmUkGjo
         ycQUY1S61npKb0eAnHCTHjqQUqY9C4PKrxsV7u0XfblX4kJR6B7KGtSwlHkTDpQn0L+a
         7MGLCfA9ZADz9iZ1ZOaE5PLLef4qync5bg23Aw3q4s5utZKBSmwCciSv0TbZRmgR2F03
         /oWg==
X-Gm-Message-State: AOAM5314L3/GTFTNU5JeE2Nz1KX41L/ndt4W3f3cCVhyJtKGaGjp24oj
        CJJFmDH3qAiocu3znl+3r3k=
X-Google-Smtp-Source: ABdhPJx3wT5PKi8TY3umYvWqQySVySrK/p4FzzvuOgx9HduxIXo69KkaAcWeJ3tcCakXIMKhIhpFXQ==
X-Received: by 2002:a17:90a:4ecb:: with SMTP id v11mr29970788pjl.63.1628587283465;
        Tue, 10 Aug 2021 02:21:23 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with ESMTPSA id g26sm27120493pgb.45.2021.08.10.02.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:21:22 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: create a helper which
 allocates space for EtherType DSA headers
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
References: <20210809115722.351383-1-vladimir.oltean@nxp.com>
 <20210809115722.351383-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6d26885e-6900-14dd-34ec-425b8e2f1752@gmail.com>
Date:   Tue, 10 Aug 2021 02:21:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809115722.351383-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2021 4:57 AM, Vladimir Oltean wrote:
> Hide away the memmove used by DSA EtherType header taggers to shift the
> MAC SA and DA to the left to make room for the header, after they've
> called skb_push(). The call to skb_push() is still left explicit in
> drivers, to be symmetric with dsa_strip_etype_header, and because not
> all callers can be refactored to do it (for example, brcm_tag_xmit_ll
> has common code for a pre-Ethernet DSA tag and an EtherType DSA tag).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
