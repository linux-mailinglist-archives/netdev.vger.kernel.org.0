Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79BF12A350
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 18:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfLXRJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 12:09:53 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:34484 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfLXRJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 12:09:53 -0500
Received: by mail-io1-f65.google.com with SMTP id z193so19608630iof.1
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 09:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vRGAamQcMXbKy3Fv15WNChtAtMrARvXNc9QIJdJWPjU=;
        b=eOOPCKTmhtb4zHsURutVDA21OCAoRATfEJGywNv5Hfk34d+bUuqvwcv0vti1qnszDs
         jukD1r924JJnKaSK3QxSO2Ti9zhbGlSHkzOXqhGkBwuZlmwTcmTUVOOoRzfuwXC9s+lX
         HjGcfw2fCwPgMM0KmGEe4f4XhQF33K8T3NRClIDJPyp/Gjr+/EQgVEf2n0x2sfLz4vz5
         zU+Ara3c39Ei96lX+j7HCiWOGph91NQRgNqtN+a0SBLAFH8Hj2pcycVWs7qE4qL0M/gP
         lTpn75mOlCcTU6z/7LRDXvwXYR9Q0AqBei0dCqkCrBw65u6ho/TRKf0Hvusyw4kocuk9
         S+Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vRGAamQcMXbKy3Fv15WNChtAtMrARvXNc9QIJdJWPjU=;
        b=mvGx3oUfLt2EXBrP+IhzkRBqww/r7S9ehO2ILENYh7vtEfU1LR+dHbdQRLw+CoxD8C
         438iPhicyVNzngKliigJH7O46BnbTStn2NbaYd3hJ9pWyfKRIYYnqPZ+xHnN2+emeR4T
         7qA2AX0Q0/poXrjUvp0v/ZxkN2l41keanQtL9Uvqf+vHbfeccIztFIp0BNGQCinKHENM
         T0qw4WuufDf4Wd1GgE5jsdXhjaBLrQRjY2bSe1QahKEECDcIlyzeaeQlnBA2XXUTiY/2
         I2w3ad28iZpNKBMKBk1jxU5KWTBSWXys1Ux3spDvT/IRgOi6GefbnsYlfCvvszGlmy27
         M8ng==
X-Gm-Message-State: APjAAAUxH8Q2s19c64/XFbQBVetnTPlgnwBFFmYVCdEgUeUm9vAGqKml
        sLq71OTAa952FINcIxKyUkM=
X-Google-Smtp-Source: APXvYqy6QakhKYbvVN05MSTiTpFG6WarD36NfZir17raycYMmr+sd3M/eQRrA9EwR6kW5kV8doGmfw==
X-Received: by 2002:a6b:d20c:: with SMTP id q12mr23907752iob.143.1577207392606;
        Tue, 24 Dec 2019 09:09:52 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:859d:710a:f117:8322? ([2601:284:8202:10b0:859d:710a:f117:8322])
        by smtp.googlemail.com with ESMTPSA id r7sm7259432ioo.7.2019.12.24.09.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 09:09:51 -0800 (PST)
Subject: Re: [PATCH net-next 7/9] ipv6: Handle multipath route deletion
 notification
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191223132820.888247-1-idosch@idosch.org>
 <20191223132820.888247-8-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <36e48acb-220d-0e38-da1a-c8d11b6c9cbe@gmail.com>
Date:   Tue, 24 Dec 2019 10:09:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191223132820.888247-8-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/19 6:28 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When an entire multipath route is deleted, only emit a notification if
> it is the first route in the node. Emit a replace notification in case
> the last sibling is followed by another route. Otherwise, emit a delete
> notification.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/ipv6/route.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


