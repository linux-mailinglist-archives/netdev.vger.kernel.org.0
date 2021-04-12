Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6585735D0AF
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbhDLTAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 15:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbhDLTAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 15:00:15 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30B4C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 11:59:56 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id bx20so15198367edb.12
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 11:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=axo8c4zn8VeFsjk6vl0sx8Tu6RIp9tOt+xdzAgThhEI=;
        b=D1/lTuVcN6ifAuepuPTpBEopJztxN6FOH6JfhuMQPODRgpu5KyAEt0XMA34XtwJq2v
         jPREcWZb1BvuMHuh8z8G9qLtt72RtaEdfCnhbf7Gb5XTGAYwRKnGy5EvUDoJC3KGaQ+j
         dxoa+yttPllHKZT7kS83Q0X0AoCeqH1xSOmURkjJEcVn81P09A117Rja1+xPbo5HfK8x
         0kMnRrF3HkrbLDJojGKK7KaL8whSNDWXoRUwp3CHlAnqFMRTIjpFSS7TJrDJhrMfFRCU
         6H531e/2S67j9mbfTbtwYyp5dcxiQyPFZ8W1Zoarmi0pNuRfzreMyZeDCj8AGj6jhfLA
         IYXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=axo8c4zn8VeFsjk6vl0sx8Tu6RIp9tOt+xdzAgThhEI=;
        b=XN8SUuc1bfYPFYzCtr+zsAmd+xTo7n/FVpOdEKqqu6ZWyfBxA1KE0IEupN5UKn7qEX
         7Voxb9BuWbNwa1sI9Ns8GYxpiI3YfkSY572ybkezayhkVrmtJrfIK1HuAe8iOTFRvxRa
         08To7LwhJ50GVrHOZpQ3a2buAVeSkmlxEhf6+LJL1Igdw3JuD0scUBe3ZuDT11jt3RmX
         fBBagXONzepTWw7+GgWyF7xSpzFe/2pTVO+ysYniLeldGNbjYFcu/SZGsG2tZFghQaLC
         ud7QSuvaVX7S0BpRnGBEWNKNjVDBzV7BBsm6siwF6upmqCXepxRduatzeSRdBAXY6Xd2
         QnDQ==
X-Gm-Message-State: AOAM533JQg3/ys8tdH/hiPXN0lxkpe9FXqRXbh4Gr6EElPBw811eRQGP
        JDDbKM1fl2ho5mqtwWiC+OY=
X-Google-Smtp-Source: ABdhPJxEJJHr0O+zMeut8Fm44cX/QtktMcrTxTqyTeZE5QZVJsT1rFxf0FGwC85uJDbVFlnBX4bsbg==
X-Received: by 2002:aa7:d7d1:: with SMTP id e17mr20666853eds.84.1618253995628;
        Mon, 12 Apr 2021 11:59:55 -0700 (PDT)
Received: from [192.168.0.129] ([82.137.32.50])
        by smtp.gmail.com with ESMTPSA id g22sm6423542ejm.69.2021.04.12.11.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 11:59:55 -0700 (PDT)
Subject: Re: [net-next, v3, 1/2] enetc: mark TX timestamp type per skb
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
References: <20210412090327.22330-1-yangbo.lu@nxp.com>
 <20210412090327.22330-2-yangbo.lu@nxp.com>
From:   Claudiu Manoil <claudiu.manoil@gmail.com>
Message-ID: <d9021cef-873d-6238-6201-698850444bdc@gmail.com>
Date:   Mon, 12 Apr 2021 21:59:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210412090327.22330-2-yangbo.lu@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.04.2021 12:03, Yangbo Lu wrote:
> Mark TX timestamp type per skb on skb->cb[0], instead of
> global variable for all skbs. This is a preparation for
> one step timestamp support.
> 
> For one-step timestamping enablement, there will be both
> one-step and two-step PTP messages to transfer. And a skb
> queue is needed for one-step PTP messages making sure
> start to send current message only after the last one
> completed on hardware. (ENETC single-step register has to
> be dynamically configured per message.) So, marking TX
> timestamp type per skb is required.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
