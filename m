Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52C2102B50
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 19:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKSSCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 13:02:01 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34835 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfKSSCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 13:02:01 -0500
Received: by mail-wm1-f65.google.com with SMTP id 8so4845970wmo.0
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 10:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FJIR98qVsgbShc5G2RA5DnCEZgGLXnH4L9AuD6f81Qc=;
        b=mA29pZDnqWR/xR9PnSipDX073vuwChSuFcqN0msjx7dH1+e24Hwt6YLLqun4HXjPYE
         s+46ax3wrq2BXAJSewTqvUOMES/LKygO/CQDaLPtSkT55Cl3hHPAXA1t/99h26LVLv4s
         aqBIhCYE+1HWQlyksnsjYrIBMGJ8ht3IHoJ1cGgRTDpm3OZDsy/ywhsTOZh3xe9oJ0R7
         uNsTwL/TSRl6cBXPLOX6qvVYqhyR1zrH/mg2dJF67Nu8udkWPDZrCTPXeMs69m713n6U
         x3EDEKlIW1Z7tOTDYyTg3bCuc4M3yqd5sPiuO/Q63gVJBeohaKwm7/F0tHx000Ya0vA/
         F19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FJIR98qVsgbShc5G2RA5DnCEZgGLXnH4L9AuD6f81Qc=;
        b=cnDNzG1ESgAu0k1jGW7+wrQ2pq4Cr7SMBk4935hDxgKxu1qYfkA6xtQahyGpMWkdTB
         HUhj7HmD348/O38orDwlnc4N7arZz6+EVYonIg/aV79WXthEuii0/fzkJ4nIjNEFkTCn
         Xlyk4j2SM1xwEwoG6AB+vvupzSgLBeBlg1PgGAz5+dYOFAzDCXkA8Xvh51hU9DDF98l0
         xUFKqyvbqoLzlmNQQPZUqZ/d/3rbYNkxOHslfsHzjSebkfs0fFsrvd5onMruIAQcsRDB
         NZrz2D0VDZr3Y+V6ZKIJ5Ar6x8vIJKqgrYRZcRkL2v1V8syee+D0SIHU113jkManyqfK
         /qqw==
X-Gm-Message-State: APjAAAU7yk44MCielK0QeHjVCn03c16R00P24Gqq+LDQ8grDEqN8a7fX
        vchkpaNxAvnyTe3gjuaCOAflRT3D
X-Google-Smtp-Source: APXvYqyhO5eMwLcoFP3yXT0wUpxXLsPLy80ED6liwJ546Dk13seQ3H/vFiGehxzBn5C5E6AWIvqV/Q==
X-Received: by 2002:a1c:38c3:: with SMTP id f186mr7531279wma.58.1574186518685;
        Tue, 19 Nov 2019 10:01:58 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:3d1b:d01b:2d1e:33a9? (p200300EA8F2D7D003D1BD01B2D1E33A9.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:3d1b:d01b:2d1e:33a9])
        by smtp.googlemail.com with ESMTPSA id 83sm4077738wme.2.2019.11.19.10.01.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 10:01:58 -0800 (PST)
Subject: Re: [PATCH net] r8169: disable TSO on a single version of RTL8168c to
 fix performance
To:     Corinna Vinschen <vinschen@redhat.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, David Miller <davem@davemloft.net>
References: <44352432-e6ad-3e3c-4fea-9ad59f7c4ae9@gmail.com>
 <20191119090939.29169-1-vinschen@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d1b1b896-87a2-5f3b-469a-825abfacce5c@gmail.com>
Date:   Tue, 19 Nov 2019 19:01:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191119090939.29169-1-vinschen@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.11.2019 10:09, Corinna Vinschen wrote:
> During performance testing, I found that one of my r8169 NICs suffered
> a major performance loss, a 8168c model.
> 
> Running netperf's TCP_STREAM test didn't return the expected
> throughput of > 900 Mb/s, but rather only about 22 Mb/s.  Strange
> enough, running the TCP_MAERTS and UDP_STREAM tests all returned with
> throughput > 900 Mb/s, as did TCP_STREAM with the other r8169 NICs I can
> test (either one of 8169s, 8168e, 8168f).
> 
> Bisecting turned up commit 93681cd7d94f83903cb3f0f95433d10c28a7e9a5,
> "r8169: enable HW csum and TSO" as the culprit.
> 
> I added my 8168c version, RTL_GIGA_MAC_VER_22, to the code
> special-casing the 8168evl as per the patch below.  This fixed the
> performance problem for me.
> 
> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>

