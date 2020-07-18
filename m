Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4D5224D8C
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgGRSnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 14:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgGRSnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 14:43:05 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCBFC0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 11:43:05 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n5so8285092pgf.7
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 11:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zc88jgOZUdREIriPk+t7FZ8bdyHq5yrQ2wKu5zkmIWA=;
        b=Iy4VRrDv/nqAVXNmX+xdTfW5Z4bbqxq/QK0OOsMh8m1v5FkVnStD/X1SYwJ9OThz1X
         MTD4vdHI7UCOrhIPEwblzZtbtO7THCT44aCTSD9RyZDPwTOX4ZnmdacTkAe3xes8WT+r
         Z+KKoQ0Ywjar66JjJCOEJIFG8rgch/YhV92em51u3evG5NhosPnCFc9tfSq/MEBEoAlJ
         FuK2KjaQ7WTE5rQm5yArHfIMaY5OldeBb0EPh8lcEHGIVRQfYMMkOKA3ap3PvkM10uaL
         a5CQxEJhMQG4DsnSxWTSdu9ogsj71j+sff4aFWYyfY/LNRQBdXDWhRf31NionnE/CYYZ
         7plw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zc88jgOZUdREIriPk+t7FZ8bdyHq5yrQ2wKu5zkmIWA=;
        b=GxuSUxA1+OpkzvnE6vBxfhpbwlJVHY+Ml5m+Ec79vMNF2w87hsuXpRkUYE8V8qaKQ/
         qo4n4/X3ShIwT/X+cSE1d/B+PqqDji4kqn+N1ni36IkR7yNWEsulNqUIH76/2HjOvy8C
         dAQNE4SsbUoV78qmkCAVEvxE2F96ehTvfR4gOdSRXsBAp+n8BjZ1ggOrjfAOzeklRbA8
         JSIgq9AtQyYi0dk1gguloKj7OCzyMyCbx5q7sRVYQVykGLurWyg8MYa19HFRotLqeThk
         u2sfFNAvxrGPi6ewVnACl6SFfy+ygqFG5mvYB1ncbYA4+PrrXahmuhgJ8fn2r/aF+Fon
         zuQg==
X-Gm-Message-State: AOAM531m7ChaKZ47FekpGXJ95RNPPXTT2dGhAW16Pb++t7UNpk9TM38y
        y4Du+MLxozaBuSrzA3/rhWA=
X-Google-Smtp-Source: ABdhPJyjXEBtvLNMI/ovz724bw/xU2rYxwQE7BvZ1/uAWLxXmyPPKeCa59CX37rL74UtEuCsc3Cjbg==
X-Received: by 2002:a63:1e4d:: with SMTP id p13mr12712433pgm.387.1595097784980;
        Sat, 18 Jul 2020 11:43:04 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id i67sm11540567pfg.13.2020.07.18.11.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 11:43:04 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: use the ETH_MIN_MTU and ETH_DATA_LEN
 default values
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, noodles@earth.li,
        mnhagan88@gmail.com
References: <20200718180418.255098-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <76500e90-030d-94f5-8e67-630b3ba2614a@gmail.com>
Date:   Sat, 18 Jul 2020 11:43:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200718180418.255098-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2020 11:04 AM, Vladimir Oltean wrote:
> Now that DSA supports MTU configuration, undo the effects of commit
> 8b1efc0f83f1 ("net: remove MTU limits on a few ether_setup callers") and
> let DSA interfaces use the default min_mtu and max_mtu specified by
> ether_setup(). This is more important for min_mtu: since DSA is
> Ethernet, the minimum MTU is the same as of any other Ethernet
> interface, and definitely not zero. For the max_mtu, we have a callback
> through which drivers can override that, if they want to.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
