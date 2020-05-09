Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDFF1CC4A8
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 23:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgEIVJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 17:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbgEIVJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 17:09:50 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0393CC061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 14:09:50 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id n11so4829156ilj.4
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 14:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uw2e8xSDXKvDbB40xD0k2vw+FSrKLWjo3OjqNAKhaIM=;
        b=opfUyiQizRxYOrveccTApQnB+hYN2it/UnLI0nmXhRT8xxE7PQEvhPn6RiEMSekHBh
         dBLyNmbbs4v0qXMGaaJrNtsgSDftbfDs589LIGCs9IJo6zkgMo/WpQNyB+xyXivurIC1
         6kYyAN9t44OUoAxRx5ykqUEa1/YjRwDhc0vbi/nAmylQctbRSyLmdeWTZqEEcynrbmnH
         oQQLj5pvNHB6hBBOSenHG6GiViCHaAXoZSlKThO8CQRpgYsu0F2VfHT4n0Hb0whGcPF6
         NS2vjPa0xZ6UyzruP/Qg3zCR2gatt3pm2cVvnNGp84WTVk2XINLDSqYB5VMxBHVi/aF8
         rIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uw2e8xSDXKvDbB40xD0k2vw+FSrKLWjo3OjqNAKhaIM=;
        b=gHEZkwPavWPXAk+bmDQHrkZv80DVW7fud3DHQHsje+XEVhPALUs3gfJAh1urlhHufp
         UNHa6hDHcpGvZwikfJZ34xLziWXUYRUT+w9VwBqaTSiXdgFiE64OCs3NO3hLJlHq0XcD
         fYcT5uiw3MxoG9k+4VBhrjAwzIF42IaFophBFfKeevVxzmBy/jSpJTndEoIwC/3Pc8L5
         uClV9iwamQb6n0wFDqVkzHZzuSf0FkXHsYzsnJEQOys41kuY2fejvHxMIP7cKnkhBBXk
         pSKPLsxZPMWkHLkG10E9yAraQ6yL6olyykCJ1ifyF74Siyejn7Lt4zO7wfT/dPDMKQQk
         4UUQ==
X-Gm-Message-State: AGi0PuaQ8tetyqRxBSJrA7lK6w8b7dmoP7gZsKglMxdCCjKDO9fnhFLH
        YH1CF3cALjxKwsQAg+/93FgMeTLT
X-Google-Smtp-Source: APiQypI4qfkp9HlXE2oSEjGbWOzrLmarIyzwRmJ6x8SWuYqimCRfmqUI7qnuox3Jx3cwJBc+eKTNSQ==
X-Received: by 2002:a92:cd01:: with SMTP id z1mr8960671iln.182.1589058589234;
        Sat, 09 May 2020 14:09:49 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d4f4:54fc:fab0:ac04? ([2601:282:803:7700:d4f4:54fc:fab0:ac04])
        by smtp.googlemail.com with ESMTPSA id x75sm2815451ill.33.2020.05.09.14.09.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 14:09:48 -0700 (PDT)
Subject: Re: [PATCH] net-icmp: make icmp{,v6} (ping) sockets available to all
 by default
To:     Ido Schimmel <idosch@idosch.org>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
References: <20200508234223.118254-1-zenczykowski@gmail.com>
 <20200509191536.GA370521@splinter>
 <CANP3RGftbDDATFi+4HBSbOFEU-uAddqg2p8+asMMRJtgOJy6mg@mail.gmail.com>
 <20200509193225.GA372881@splinter>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <682963e4-7434-c836-6874-55cc7f83ec31@gmail.com>
Date:   Sat, 9 May 2020 15:09:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200509193225.GA372881@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/20 1:32 PM, Ido Schimmel wrote:
> On Sat, May 09, 2020 at 12:17:47PM -0700, Maciej Żenczykowski wrote:
>> Argh.  I've never understood the faintest thing about VRF's.
> 
> :)
> 
> There are many resources that David created over the years. For example:
> 
> https://www.kernel.org/doc/Documentation/networking/vrf.txt
> https://netdevconf.info/1.1/proceedings/slides/ahern-vrf-tutorial.pdf
> https://netdevconf.info/1.2/session.html?david-ahern-talk

best one is from OSS N.A. 2017:
    http://schd.ws/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf

Maciej: Basically, VRF narrows the scope to an L3 domain - devices
enslaved to the VRF device, their addresses and FIB entries in the VRF
table.
