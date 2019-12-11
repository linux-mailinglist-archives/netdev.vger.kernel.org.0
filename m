Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D656D11BA61
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbfLKReI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:34:08 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44308 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfLKReH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:34:07 -0500
Received: by mail-qt1-f194.google.com with SMTP id g17so6941828qtp.11
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=50RL1Ys/g/CuCeM3SVK9XV7OUSks1WfgsTp0U7DnZzc=;
        b=R9q/6Ou/CAHHtcuYNMyvf4w96c3glEQrds/C0aHHA8O23NQpaL1pVuygwpRFEiaeiH
         E+hnAZGJAhBAfoihTjUWB+4ehL3CJ+cPkCIElljkbCoyYcZ3iUhq8k3EamFFw3kjFjtw
         pxdcwTyUxE3juoVLeckmzhvL6n87MGvz2gGVw70MpxS0LWwcEUFHugQ+y4xQT7La8F8A
         9XWaCUi+v3IWAsfny7RVg9wWlb4Ax4IdKPwne+kKrq5wazlLNur/tfeuH0ComJrsjiq4
         t6YKn+9LXGAzpW4ecZaMBN3wCr5uQFbppYLnsq2WgIKSP85qNKWaDlWu5MnmUgRArcW1
         GaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=50RL1Ys/g/CuCeM3SVK9XV7OUSks1WfgsTp0U7DnZzc=;
        b=jOqmddkFXRlMhUBGpUf+MmHhq+kFM5C2PZLBZkL2+kA7PTn5YhuUFdrJPKcpXhB/rf
         lLkaKtJBwzujqs7Mx5VonV8CB9l44GtVsQDHvCwaZNVCCf4s+IpgQeoSSa4knrz4xW6U
         8NQcNEEXHpFSawkZKrUp85see4kKdwXEdaYeZY6Plo/kt9/qr+qFFTzBbSiIemezG+vK
         XS+kznCtxTIH6CplIDzy9mT3O6+iwFhDCNwMZRQ7ky1n3aES392lJFC9wbU3H8KEJsaW
         5HJIqNj4heffj1ASVShIcpI//fxQWlAP0Ed/IfpUZwsbnkIEzNbbzcfjviEBpJxo9yNZ
         wswg==
X-Gm-Message-State: APjAAAWKqHg5yWnnD+gyXS4wM/OV5jwRJMgRghmauuDZ+u9tYDcV7Htg
        wqm11h/7MMvItW9rVhyZJd4=
X-Google-Smtp-Source: APXvYqyN9ymuHg5wOg767UL3vWa0i7SyEyh47XEflWVmSf2F4PPYZAWok3CKdUuPEDFkNpmYyKdGzA==
X-Received: by 2002:ac8:470d:: with SMTP id f13mr3522106qtp.330.1576085646849;
        Wed, 11 Dec 2019 09:34:06 -0800 (PST)
Received: from ?IPv6:2601:282:800:fd80:79bb:41c5:ccad:6884? ([2601:282:800:fd80:79bb:41c5:ccad:6884])
        by smtp.googlemail.com with ESMTPSA id r205sm330820qke.34.2019.12.11.09.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 09:34:06 -0800 (PST)
Subject: Re: [PATCH net-next 2/9] ipv4: Notify route after insertion to the
 routing table
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20191210172402.463397-1-idosch@idosch.org>
 <20191210172402.463397-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e22981b7-8411-dd94-3f57-64f30647ec44@gmail.com>
Date:   Wed, 11 Dec 2019 10:34:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191210172402.463397-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/19 10:23 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Currently, a new route is notified in the FIB notification chain before
> it is inserted to the FIB alias list.
> 
> Subsequent patches will use the placement of the new route in the
> ordered FIB alias list in order to determine if the route should be
> notified or not.
> 
> As a preparatory step, change the order so that the route is first
> inserted into the FIB alias list and only then notified.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/ipv4/fib_trie.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


