Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C16711BAC8
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbfLKR5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:57:49 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:43303 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729228AbfLKR5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:57:48 -0500
Received: by mail-qv1-f67.google.com with SMTP id p2so6105039qvo.10
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X/RjxghzuF2VFzZ/TcZWP2JdkdEXFRRmdpXcHIokN4M=;
        b=lotVvy1kYQLbo33Gie7TPmQGvDrO3BrYTAIsRdB6kKyOiZYy278Wpr6iw6UKShLxlk
         lIOhZzh/3RdyU7fkt0fFZ9TjDZ7g7Xc/BzEJXmlfGK7a2qFKdMOvSh9HJB097qmewZf3
         DqVOxnnEWnaaGxhNLTk/A2kSocCEeyDSGSYjYsfe4tWXY6YSiYh2SJQQnT1NLyKln7B/
         NqoQ8osU+TtEf6HoRGegrlm73zBvGfCf2AQXy3bDZE555y+ammVGh02vBonn/SY3le+u
         F9c0v537U9yToMsAuB2gfUAnLbwHXy7UzLNHoRLMxlGRbvlEOx4TsMzCY64ebHWuC6OT
         Twag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X/RjxghzuF2VFzZ/TcZWP2JdkdEXFRRmdpXcHIokN4M=;
        b=mCtc1kZKWm75sjwAAFwGJ8ffV0szT5ENmf4YpRGCSesoPkg6dn403KdkH6bgf0AVpR
         KYV0ChZ531eH+vKyUd9aRFrJHayWBKiBdLwZYZjC7fLrKAG4+nDT7mn/4eN3vXKmdM6u
         lTQjCXLKi5ohB2dmFKlNk2YoZRGRUEu56i96pyqZcEVhLvM/pKZsetP7iOiZNStLGkXo
         TordfkQueDSt4WKBpNQGXfhZVCv/tVgI7eKMSN07aWwa8vFyQ/bqXVN73E4MhLpxhtzO
         w1N1ZtoWKa4SxA8F6FFFToSpM7t17A2sbYT26D6PrUkiKIyodseyDmJbLm73aBc73rT4
         iGaQ==
X-Gm-Message-State: APjAAAXGQTTxm05BGKjkpbss96mVuEFVpULi8GymwI9RYzkfDmHngsHb
        Pn2Q/2SdjwoNPhUP0ypZ0Z871vuniTk=
X-Google-Smtp-Source: APXvYqzc/Kah+8yOXKCH3oxwdYVpAnWZ+IWRErLDqUF81L//Xwe4WWrNgCvQwgFZKFtIwsip7pIoBQ==
X-Received: by 2002:a0c:fd6a:: with SMTP id k10mr4316211qvs.195.1576087067748;
        Wed, 11 Dec 2019 09:57:47 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id t36sm1137806qtt.96.2019.12.11.09.57.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 09:57:47 -0800 (PST)
Subject: Re: [PATCH net-next 7/9] ipv4: Only Replay routes of interest to new
 listeners
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20191210172402.463397-1-idosch@idosch.org>
 <20191210172402.463397-8-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33853025-f120-d092-cbc9-03ca49e9aecf@gmail.com>
Date:   Wed, 11 Dec 2019 10:57:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210172402.463397-8-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 10:24 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When a new listener is registered to the FIB notification chain it
> receives a dump of all the available routes in the system. Instead, make
> sure to only replay the IPv4 routes that are actually used in the data
> path and are of any interest to the new listener.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/ipv4/fib_trie.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


