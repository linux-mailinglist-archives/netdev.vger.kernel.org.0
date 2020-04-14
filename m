Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D011A775E
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437658AbgDNJbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437642AbgDNJbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 05:31:16 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99435C0A3BD0
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 02:31:15 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id y4so5522776ljn.7
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 02:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8uG4dJWnyuDs9G6brOdxkLBHDpZch3L/EKvphV354JY=;
        b=jCTDelEXN66muh0z/bW5KYlGYxXFsTV9dLnkiHnyCL37EOSRtzvZ88jDaERV0kjEog
         nSdmiG/PoGQ6wbQ+p7bW1+JI7ADPPadfqWkmNP2qO/yc+CRUFMwp8x7JwBk9M5mRhmMJ
         kqFrWjnauSFdjOh+dYDUJHJUbTSFputRKW2sIzPgvQDU6OM5se3SvcnEv+ugWxngmR+s
         gxdQQRko3hJtspNI0n8tIiRKC/do7KJmI6ihGYEedxiTEm47Du2CKUVj2xjkx6IEDTQD
         hQ6Hht6YpZ6cw0ax51SlZwglxO5PtjLuOyYH9lTe/Fe1S+5mB7CTZYGn0ETShzSxjEos
         UBsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8uG4dJWnyuDs9G6brOdxkLBHDpZch3L/EKvphV354JY=;
        b=V9qmKknYYSBYbQGVPSoVeT96J19rPIRIpH/0hc1vMtJySRbWf193AbhFAMDBkIeygk
         XrW90w2ZLyTbVckPy+4BW4fIim2/leFUo29G5k9qqvHTBVoNvpYwB1FI+vmdpjpML16r
         Pt5CA14tyNxzRdnm9LOtb4pJC7L5vzbEiArMUH180FjudVahCh4kZJfARmMgGpzYjBNF
         vRJrE20i9dKabKtNsVJ5w1h15/NGMJn640k1nWhMaJPYebrvut7ZwBWVTU0rx76xmCQY
         +GEMte+J51morHAi48Pz/unUWttMjosAVCjaGLryJx0BrILfqlY9/7d+gTp1wQ/kvD+L
         769g==
X-Gm-Message-State: AGi0PuYQZFF5Cv/tsKQEsL0edAMOTbN/2xGiRpqfv6xSxZ3AE8SrqNHu
        NEK+CEmMnAZxy+Gbxixpf8CFdqwKIUNteA==
X-Google-Smtp-Source: APiQypIqkeHuJ3H16SdzrG3CXsqAkyijRqflbQESK2lHBAq+BkQf9o4RRvJ4C7XaLw4t2Lat5PLyVA==
X-Received: by 2002:a2e:86d8:: with SMTP id n24mr5811793ljj.129.1586856673625;
        Tue, 14 Apr 2020 02:31:13 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:8bd:2988:acbb:39d2:5ec0:3556? ([2a00:1fa0:8bd:2988:acbb:39d2:5ec0:3556])
        by smtp.gmail.com with ESMTPSA id r20sm6704489ljk.42.2020.04.14.02.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 02:31:12 -0700 (PDT)
Subject: Re: [PATCH net v2 2/2] net: dsa: Down cpu/dsa ports phylink will
 control
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20200414003439.606724-1-andrew@lunn.ch>
 <20200414003439.606724-3-andrew@lunn.ch>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <1057e139-a078-f411-b399-64b8c9181b2a@cogentembedded.com>
Date:   Tue, 14 Apr 2020 12:31:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200414003439.606724-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

   Only a couple grammar bugs... :-)

On 14.04.2020 3:34, Andrew Lunn wrote:

> DSA and CPU ports can be configured in two ways. By default, the
> driver should configure such ports to there maximum bandwidth. For
> most use cases, this is suficient. When this default is insufficient,

    Sufficient.

> a phylink instance can be bound to such ports, and phylink will
> configure the port, e.g. based on fixed-link properties. phylink
> assumes the port is initially down. Given that the driver should of

    Should have?

> already configured it to its maximum speed, ask the driver to down
> the port before instantiating the phylink instance.
> 
> Fixes: 30c4a5b0aad8 ("net: mv88e6xxx: use resolved link config in mac_link_up()")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
[...]

MBR, Sergei
