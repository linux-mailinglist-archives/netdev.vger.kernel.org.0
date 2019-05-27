Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1065A2BA98
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 21:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfE0TP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 15:15:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34188 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfE0TP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 15:15:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id n19so10034195pfa.1
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 12:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G36wGaaAm1M5Hqyj1VpNiTW4Z6a184kyZaxGblS6PQ8=;
        b=c3NcpjKj4X8Dily7ptFk3zDnR0kx1fbGXQuLZaIjjJUMNe8FXpvvwRojP6LMORqom2
         xPDxQRTLduhqqWfJoBVKGl7qxhL7DWUKbMFzlq65uemcnaAPeUoWE3iGySzJ3j0XBZbP
         uaRYYla15UnZilXYSN/rxkb01OFaWUmsc/O+BXp2FT/7mcduVaCyrU9+cwUd/H47HDC8
         +uk6B0K1VcTX8JG5NiIAQ1vI2ypDjxH4lxqxSEXUxptDcTGmNExbjFaKIYgUMOxeeT2w
         pckLEcsCPZtuN1LEGYUaRrA8mA5YWStABHRsN4SXWBXeB52wOQN4S0XpPVBP44xm3rB+
         RSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G36wGaaAm1M5Hqyj1VpNiTW4Z6a184kyZaxGblS6PQ8=;
        b=oO3kPXcCIqo/m50BMIQeuOI3f3R8cgC6ray3GKZjrAHTQFieqSdkbX8tnvH1EG/9hn
         nUCuth87MHH2TUX/adrhUBmW65OVdqbvSm4PPhqyezW1LDlsRDllKI8s7tdOueG2+wak
         JDPe2AurvKsSshdJTUl9HmhlgeLyHmbY+9IifD1f0gIm8wzjVuhEokhSPkviDDjrhXZ/
         6Ef62Gm0cwMwbuGRbTdYbdpualE0fYdr9Wpq6pxHMZdH3LpvVDIVyfF0SkppP6Twjq7y
         c3+UvNwW2jZIlmnqdkO7IAqpsnbNCB9HpuxxD1+LZY5i4+eDALfv7PgNO4OR69kX4xVW
         OjmA==
X-Gm-Message-State: APjAAAUxSX4+fAI6zZdn1WL3xIKUWxgL784RzhkQWkqwOeqDSnzYWffS
        0xQ3sZhroEHSe8K6FaavyVU9iOnO
X-Google-Smtp-Source: APXvYqw8oxNDlLladSch7cBS2noxVXSETmVkF1tkwZb93yB0fwGgG53P8NeaS9yeMTyFFisRcwd2GQ==
X-Received: by 2002:a17:90a:b396:: with SMTP id e22mr536054pjr.76.1558984557957;
        Mon, 27 May 2019 12:15:57 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id t7sm12049112pfh.156.2019.05.27.12.15.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 12:15:57 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] net: phy: dp83867: do not call config_init twice
To:     Max Uvarov <muvarov@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net
References: <20190527061607.30030-1-muvarov@gmail.com>
 <20190527061607.30030-4-muvarov@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <5e26e2c8-a11d-93bb-17b8-22a6b8aae314@gmail.com>
Date:   Mon, 27 May 2019 12:15:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527061607.30030-4-muvarov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2019 11:16 PM, Max Uvarov wrote:
> Phy state machine calls _config_init just after
> reset.
> 
> Signed-off-by: Max Uvarov <muvarov@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
