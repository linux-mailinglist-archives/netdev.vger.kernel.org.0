Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1825686AE
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfGOJxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:53:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34447 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbfGOJxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 05:53:15 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so13896559wmd.1
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 02:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b6+idN83FThVkn8Abc4MJr6ChvYkKFkoaBEL50cdLrs=;
        b=TlpRYwUS3LXIuvmNKnvGtcjuKL9XN/dM7BF8MjUJ4Zo1eHt43vwsbkpi+MBRv9bJSy
         JCHlLt3FvBWg+pKcQmqAvUpwP+6lf5zOYSsVxQjE2V/4KsBm4m5E8wS00RUCYpGycR3W
         MWExlKaD4sb9cUKFJkpL3mzPlCPZKzAZATi07kPw0mwRxWNtnzmXX0YvsWbNuSBoNqbL
         /Ups3NaLluBmRSoET2ksJyKoDe3iJaxNUal8xhzEwL0gYuhkAFXGBqrAnfs4uCrZ5hBK
         dRP4Mfu+46pPZv3AV+nhsRBcRZJETYNw9Yp7n7yOBpyaqY0UD300F7FD8ZeHXvyqTQVX
         KSPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=b6+idN83FThVkn8Abc4MJr6ChvYkKFkoaBEL50cdLrs=;
        b=Hp9LLXCHnHi06CJcTqbZ95OYe7DdVmgUngyDeZBNQSKLYn+6pxtzdy9h017PgU25nf
         6VzrIyYtU9CV+u08McNFwIzdUfcPadN++Dl7L4iynxWSFBOrM5LTiAjYINO0RFnYtTCy
         DHHg0iI1Syok0EiDGOOoZ/VRiG27Xs+JH8iXd/oBqXoiD2rsjK0NrAkL73IfE3Nwt8MF
         VZQ4YUrCSmt9n3T/Bv7T+zbRc0W2PLi9RSE9slTpmq8TSrq8IBpl/XJGMwZ/nVs3QfuP
         MYIjauVuT8O4M5iYvmC/hynU12d8P/CmlpQuGyRvpvi4KR9Yv01nKkWX5DU3y0UDa1hb
         Lpqg==
X-Gm-Message-State: APjAAAXdC5kKkzS92gQ1qI1PrfLXyAl2FUIzBb3eT4uo7KuT8I8tCHGp
        0Mfex7AoiZzaPt0Q16DjILoWDs95vHA=
X-Google-Smtp-Source: APXvYqwvVCQ5JWHpCcMv42uEp+Doq+9P2pSv2YR+dd6dD9CIB0cBVZm4NzYOuA7xWwgqvr15bnXwhA==
X-Received: by 2002:a05:600c:1150:: with SMTP id z16mr23097886wmz.168.1563184392984;
        Mon, 15 Jul 2019 02:53:12 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:c118:a958:bcb2:844f? ([2a01:e35:8b63:dc30:c118:a958:bcb2:844f])
        by smtp.gmail.com with ESMTPSA id b8sm15282577wrr.43.2019.07.15.02.53.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 02:53:12 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec] xfrm interface: fix list corruption for x-netns
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Julien Floret <julien.floret@6wind.com>
References: <20190710131137.4787-1-nicolas.dichtel@6wind.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <c4b2d775-82d0-0569-6cb7-c1598dba9a2a@6wind.com>
Date:   Mon, 15 Jul 2019 11:53:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710131137.4787-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 10/07/2019 à 15:11, Nicolas Dichtel a écrit :
> dev_net(dev) is the netns of the device and xi->net is the link netns,
> where the device has been linked.
> changelink() must operate in the link netns to avoid a corruption of
> the xfrm lists.
> 
> Note that xi->net and dev_net(xi->physdev) are always the same.
> 
> Before the patch, the xfrmi lists may be corrupted and can later trigger a
> kernel panic.
> 
> Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
> Reported-by: Julien Floret <julien.floret@6wind.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Tested-by: Julien Floret <julien.floret@6wind.com>
Please, drop this one too.


Regards,
Nicolas
