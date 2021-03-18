Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9323409C2
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhCRQKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhCRQKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:10:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD49C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:10:32 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id w11so1536636ply.6
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cmmHtTSwuOWAvKcMQrYOeRPEdmFoHOWzahsTBVmwZlQ=;
        b=lroEG0/iCCyM8LCWJXXXqmFAyDiLVlkd/8OSZtJjA/lrmk24V0QuNB3C/TMLD+w9Cy
         7o30GCirfH9CCtdboIcUpkRqEQjO0Lx2e/w4jza4eIxK0P0qUJ9JY+6704MEpBzHQdI8
         r4wlWtqQNxic/+67twGzhF4R2RJgA+DzooARfPOD1TKxVOpCs+RZhmei9S1+hXloE22u
         hp3AVjmfylcjCHmdMImoOW9lGTijUIY+W2sIYrlyJeL3m+oj/Y83i9reNNjL0cGUKeKp
         CxQcDAySCegBi51am0y+VXuCRJ1UE/TaDNIJaFLjIFW4Y2ovFOgsviDo0pegvDcGiBMq
         uZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cmmHtTSwuOWAvKcMQrYOeRPEdmFoHOWzahsTBVmwZlQ=;
        b=nZ7MWGPahtRP312eO7UMunQ9QN2yt0brNJDmjvPNeZXlkhdXPIX1zk1MZq4kobnuVY
         EsY1GGQaAtFdEJ+pjbWYvyZjT3zfxgYMPfKc6zzj9qAuDr1OUTsmHYZb8XELiqMcJMj/
         Ym5ETGD6NkPAzOYwfJO6oqE4eHZ0XBUOEmJSiOeoFnbmYCW+b123mkSXGU9wGJL60mbH
         lVfUU62iGOFnNwVDFSM34DmaL592bYwQBnShVwTvwyg6RvmpLgOMIghLRcQuDMZ0R/Sk
         ZoBIoLXi8x9Qpafl9rhZZGCQVez4ZTttZJ0i3zmq2VGJrAqneCPrkGZjGP+xU0W9NCOm
         JrpQ==
X-Gm-Message-State: AOAM533/GZZE5T1N42GsmTl4qYa6vbiWjJaXw/5gCnjezzPsXDK11GLw
        n/n4xC/oF5/QkAtNO9ra4yHUL5o6Ygw=
X-Google-Smtp-Source: ABdhPJy9jLmlEDP8Y5jmoFcsTnZYM7kXLAulzokCEOnbqGfo/1dZmzSwSQkEd5wHQG/IVG3H4tqxqw==
X-Received: by 2002:a17:90a:598e:: with SMTP id l14mr4964003pji.187.1616083831611;
        Thu, 18 Mar 2021 09:10:31 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mp19sm6461438pjb.2.2021.03.18.09.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:10:31 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 4/8] net: dsa: mv88e6xxx: Remove some
 bureaucracy around querying the VTU
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-5-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cdf94a74-be16-ad15-6700-d9eb72dbc841@gmail.com>
Date:   Thu, 18 Mar 2021 09:10:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318141550.646383-5-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 7:15 AM, Tobias Waldekranz wrote:
> The hardware has a somewhat quirky protocol for reading out the VTU
> entry for a particular VID. But there is no reason why we cannot
> create a better API for ourselves in the driver.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
