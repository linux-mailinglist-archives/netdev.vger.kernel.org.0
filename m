Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C60F34D595
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhC2Q4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhC2Q4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 12:56:34 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71A7C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:56:34 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 11so10240399pfn.9
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 09:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FS+kDQrN6lrZZPsVrfLhUW/rNJpBToUlOtxhrOX6xz0=;
        b=H+bDevEplIBgPkXiSLpFOeOm9sdu5s1lNfF174t/PrIYGQSVGLD9vaKoepsFyWfHCp
         wmrEIfzKUgNbgAUZZ+zoFiVPr6efFcBQLpFg3bKcdjr5JFzZk+fYZ8r/TouIldmFi3bH
         bpAyKuuq1r0g8K0klXfZg5RslmVcTKau3DbbfkSJbxAip21cFRotwt5WAasYzUUzGC6v
         CVOD1nmBEiEJrTIcTnZ4pcrR6thKHBHTZLMTES6qt+K6FjLIuHLfpP5JPiSbCOBuD/6O
         D0rLzJtOl6ithYda6/m0voR7KWS5kvXQfrDVKOq+lGspTMzPq0v54ev7Wa/XAFKbvNZs
         BMMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FS+kDQrN6lrZZPsVrfLhUW/rNJpBToUlOtxhrOX6xz0=;
        b=Aj8KBSFjpqXftG0NxRys8+MzhFskqbOXg1cZdHribGkgT8XMuAJEHvwXibl597Jpbh
         z3bGnDzRjg0GovSXZQSKQzZnf4CDqW8j5BREuFONZj0nyBVHCzjgWJ8Czne9wS3bJB4h
         KLeecdd5vRwlvX4/VUqkVUM6Nd6Y2+M2bI2eJKozZXCslejUmm3InHGJe2+i8aSUWA3D
         XHbaXJNdQ04JM6QuNM6/gjkOB54aWlLMT2sfrvQKyJ0qBgiI7eVRrJcgZa3kBNBlmBsY
         s4vtUvOJ2l/tGJr4v5QBIB66jm39zMTZI5EPs5BTOmLZeOJQ68MaRftYYERMK+zwEVTm
         Ehqg==
X-Gm-Message-State: AOAM532YtxMlFlh4TNF82+L5UcANuBAEYf2N5D9g2fiJS5G6yFDSNafs
        a/IbLYPKt5R9tIr/3yV/irWCI6e7Fis=
X-Google-Smtp-Source: ABdhPJw8Efb05rTzDJSiB84KQA2naE4GjXalihYAyNriqdU9HGtTuX2THv8+mo0BvQpucKN9VjSRNg==
X-Received: by 2002:a63:f91e:: with SMTP id h30mr25020168pgi.117.1617036993901;
        Mon, 29 Mar 2021 09:56:33 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d1sm20414pjc.24.2021.03.29.09.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 09:56:33 -0700 (PDT)
Subject: Re: [PATCH 1/1] net: dsa: Fix type was not set for devlink port
To:     Andrew Lunn <andrew@lunn.ch>, Maxim Kochetkov <fido_max@inbox.ru>
Cc:     vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
References: <20210329153016.1940552-1-fido_max@inbox.ru>
 <YGIFYiYSGAnrjOiD@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4e0053f3-39b6-b13b-1545-91beb5d1f49a@gmail.com>
Date:   Mon, 29 Mar 2021 09:56:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YGIFYiYSGAnrjOiD@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/21 9:50 AM, Andrew Lunn wrote:
> On Mon, Mar 29, 2021 at 06:30:16PM +0300, Maxim Kochetkov wrote:
>> If PHY is not available on DSA port (described at devicetree but absent or
>> failed to detect) then kernel prints warning after 3700 secs:
>>
>> [ 3707.948771] ------------[ cut here ]------------
>> [ 3707.948784] Type was not set for devlink port.
>> [ 3707.948894] WARNING: CPU: 1 PID: 17 at net/core/devlink.c:8097 0xc083f9d8
>>
>> We should unregister the devlink port as a user port and
>> re-register it as an unused port before executing "continue" in case of
>> dsa_port_setup error.
>>
>> Fixes: 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
> 
> This commit says:
> 
>     Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
>     not treat failures to set-up an user port as fatal, but after this
>     commit we would, which is a regression for some systems where interfaces
>     may be declared in the Device Tree, but the underlying hardware may not
>     be present (pluggable daughter cards for instance).
> 
> Florian
> 
> Are these daughter cards hot pluggable? So we expect them to appear
> and the port is then usable? Or is a reboot required?

The systems need to be powered off cards replaced and then powered back
on so no true hot-pluggable scheme but cold-pluggable definitively.
-- 
Florian
