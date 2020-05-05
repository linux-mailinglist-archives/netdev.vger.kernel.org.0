Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95301C4C9B
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgEEDPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbgEEDPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:15:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489A8C061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:15:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r4so407246pgg.4
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2dMzU2uoxf3OwT36J7yVklzeD7ZvTlXGm4t+Ee11KR0=;
        b=a7AbsoCKszypfx9h4WsAYw0+Ze478NcqOcDYBB+hAcO9qlNalos4pykOZOXbkY7+1P
         YLbr58e9Cdni7XSWFSgYwSTxAW1ArXSFspM51yCg1NHbGzWfurCoOrej8jDV7pV3Xy8G
         +JntCJteuG7/RjNthXDjUQ+70TggEyniS3y90tVadhlFvyUkqyaZrnSjEwY6Q40DMwL3
         ARxStJ/2IT2HrAYQ11rhCymLEDaAveLqKFLpL6uQ0qfK3T85ntpuNSdHnuIbFLPxDmUS
         gT3gDMt2MvOqmf2EYBdd4tdniHpGyEgK1P8TCkHGx+uonvnQpsccmMWcSAF3tMT4d89J
         OWfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2dMzU2uoxf3OwT36J7yVklzeD7ZvTlXGm4t+Ee11KR0=;
        b=Q1c+ZafE1tJWf6kvyGhMfhaf+PWvs7GtRMXu+sE3q74KY0V2FWYJYiaanNplXcdOgF
         jxrPqErRB4mamXNS9rCFnb9RGj7ECOsT6kXNcrHqJlAcwoA7Sa4XtQ4Ndr/RATNFpxE7
         I80g6ebO2UpfP9mH4lyMlY2ZMFWQ4Qj06YrQcfT6hWYieR5Na/tvrGM6ZdnB2ynOKAHN
         HnSjeWNakHSf0qOPrBO6HnCuYWCohK9/wyG60CVA/PnM+lBdpq6v/CG52lAmLPK/wq0a
         EnrcAopkRtmoHAQgL+UJPp/60UnDF83Efag2GMT0Y29j87A8aPhkyEJnOvYTKLlOpQgm
         qu8w==
X-Gm-Message-State: AGi0PuYqnpaVqj7Md0LHoBI7knVlhgXxbwg7tSue1urzE+8WHMQk4FKs
        gbT1FEuZN5ZDY2R6GJXvAhs=
X-Google-Smtp-Source: APiQypL5MYD7iz0oc2SiwYK8qdBpHD+4Myc2i7xYtM2sGN3QRxHLyL/pLDazERyfsBvqr35EilNEuQ==
X-Received: by 2002:a63:1e22:: with SMTP id e34mr1265734pge.427.1588648546579;
        Mon, 04 May 2020 20:15:46 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v9sm368469pju.3.2020.05.04.20.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:15:45 -0700 (PDT)
Subject: Re: [PATCH net-next v2 02/10] net: phy: Add support for polling cable
 test
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4a327b83-abb1-b19d-a75c-746932790e48@gmail.com>
Date:   Mon, 4 May 2020 20:15:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505001821.208534-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 5:18 PM, Andrew Lunn wrote:
> Some PHYs are not capable of generating interrupts when a cable test
> finished. They do however support interrupts for normal operations,
> like link up/down. As such, the PHY state machine would normally not
> poll the PHY.
> 
> Add support for indicating the PHY state machine must poll the PHY
> when performing a cable test.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
