Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2661144A82
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 04:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAVDoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 22:44:09 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43795 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgAVDoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 22:44:08 -0500
Received: by mail-qt1-f193.google.com with SMTP id d18so4558547qtj.10
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 19:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u8J7RdnMYJIXDkRUegynAZIRwvzwtdVYAaTUn3j46y8=;
        b=mfJEjjL8rDpcEOlGFatjhAekqYtJ+pLL2U1/+W5Zj+GrZDwdPpRKxa+lA9MfQE/kAZ
         8cZZ3mHcTu+jS4mlXtGEoi54UenrABm/fmdsoH6mUPgRLCVyNc4rbCuMJQ1yeMSy6zju
         SpGzF6pbVzGz0xPvMPj+yv+sS711g98p2GjJtRrsZYMrr2+k110+hVa08groh0ErSc0p
         qC90tkSGmbJdnxZVZeNkILWc7aFfneKo4Y+Vgnx1oNtwQaNgEhZHg0U9QppR2Wecqet0
         lz8jhtOkMOtmVhToD79cpaWB4fm0bflm3e9/jlFJQ6+pnNCSHQfjlAZqYUgkryvvgdAH
         8qBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u8J7RdnMYJIXDkRUegynAZIRwvzwtdVYAaTUn3j46y8=;
        b=km0s/AcJF4lE5mLZd/tvH5NSrDxtKyEpYvFXGotF8MFWgoJKvr4fBwmhGdXGVkQXsG
         C+Q5hwGKAdH5Ew/6PnAQJmIbgvn39XWCAeQ6ZhkiuoQoYt9AtsX2C1R+F9CWz24IwSCh
         vqcLGuWZNicbcSw19ryGFqUPCQv5dFXZa45EJDM8V9brlMOX56r9YGCzC7a+ftnNpdz1
         4nWD0gyiAf4tPKDAmPw5z7/sXrCbryx4AoEUxAt5Us3lcFyOwhP0YeluJ9HWox8rPxTG
         Lc56xvVwPAvOUtYiXPa9Sa0xT/yj3Q3Hfs2jMSAPs+9jU4dT/NKxryhr4gbDgKCO6EUw
         0eDA==
X-Gm-Message-State: APjAAAUFl6iwVLZmznDQ6UO6K6C8Wjf6oSyycduPrsun/QxsNqYKs/hH
        1IdUGzo0k/3qJyauC9iPlXQyJ1ExGRc=
X-Google-Smtp-Source: APXvYqxu+8eeQTL4+P0GAv19EH/s5X8lB8gxBSK9Aet+4VNmbavQgncgLupRy0cF6PeL4opVAuGoOQ==
X-Received: by 2002:aed:2584:: with SMTP id x4mr8343778qtc.343.1579664647777;
        Tue, 21 Jan 2020 19:44:07 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:8177:51f2:6c2d:fef5? ([2601:282:803:7700:8177:51f2:6c2d:fef5])
        by smtp.googlemail.com with ESMTPSA id c6sm17954613qka.111.2020.01.21.19.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 19:44:07 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2] ip: xfrm: add espintcp encapsulation
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <110d0a77532fcd895597f7087d1f408aadbfeb5d.1579429631.git.sd@queasysnail.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <275a3423-d0b9-be41-0efc-9919398e043b@gmail.com>
Date:   Tue, 21 Jan 2020 20:44:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <110d0a77532fcd895597f7087d1f408aadbfeb5d.1579429631.git.sd@queasysnail.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/20 3:32 AM, Sabrina Dubroca wrote:
> While at it, convert xfrm_xfrma_print and xfrm_encap_type_parse to use
> the UAPI macros for encap_type as suggested by David Ahern, and add the
> UAPI udp.h header (sync'd from ipsec-next to get the TCP_ENCAP_ESPINTCP
> definition).
> 
> Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
> v2: add udp.h header and use the macros
> 
>  include/uapi/linux/udp.h | 47 ++++++++++++++++++++++++++++++++++++++++
>  ip/ipxfrm.c              | 14 ++++++++----
>  ip/xfrm_state.c          |  2 +-
>  man/man8/ip-xfrm.8       |  4 ++--
>  4 files changed, 60 insertions(+), 7 deletions(-)
>  create mode 100644 include/uapi/linux/udp.h
> 

applied to iproute2-next. Thanks


