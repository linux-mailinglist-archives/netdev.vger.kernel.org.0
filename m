Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F395622987
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 02:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729715AbfETA3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 20:29:25 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41093 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfETA3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 20:29:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id z3so5887535pgp.8;
        Sun, 19 May 2019 17:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hBaYYOgHBn5Iq/to9VwGy7dRm9N+B3reJ/FtJOoZbpE=;
        b=r2M4jtdbalke0beP4MXcM1cAhBkOWSLrP9AhggPcnbqfJEuQXFXXs1hVki0nIFrZkr
         CtaKjKEjNs1O+lf5KZtPkKTUEs90AlqEUheG9+qhTpFSJLJf0F1dyIGH1BtJkWUwsFG0
         6UhgtLNq63jsiqpDGLOzUstFBoOjYCtRDNBuIQvkVXsVLRn36IOzCae/fxIqZbiu1iCl
         4b2sAgIlLDxxMUpNNxZvizLZmPTozXq5mUenSB7PfpSt4GmVY01Xv3o+ziPEUKRAN0f+
         AsYXPt1X61mby+nLPEXKzKT/bMj7i/3ZpEGWFZhCVaJWc2qZXIjKg+wYkgX8sS/x2cKh
         l2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hBaYYOgHBn5Iq/to9VwGy7dRm9N+B3reJ/FtJOoZbpE=;
        b=m/2DLbWYGy2TbwVTPedXyV9KOODGXPN9lLzHNNcM0fPw6JN/afC9GoX0YK4V4lPY8m
         w/WaI1CROAP1eSUxfeSAfTR9BJMylonsmXBvo0fDTv4neJjvAiy2sWlENmEqt0HaBXYF
         +ht5kRv0XOAmAYD2VU4g6hacw8q7pM74rgyVn/2j3O83zhzZacWremQuPY4iTQpQa6Ah
         m4u796YFmjWWVeIGDFxem3LyugPbGNi1Q5kfFk9B2B5xnpMZSSpMq5923htbsEcyuzn7
         bS0nprPPexM5P2lWt3KrZZ72EnDnJIFajnfTYAPiE/J3VChQRox99gKkdxkC8Y0qLW80
         S/XQ==
X-Gm-Message-State: APjAAAU3y7eofmlO+QresrdigSv2M+qeqOc7yCc0+0pb3MvuBrK33UyS
        BpY8OYVceyf6Z6FYKAoEInR6enoR
X-Google-Smtp-Source: APXvYqzXS8Kfg7+hoCIkTxpThWBlABRdcXxloJXFPPWjqikBFnMvV6LpBzSY+vOyezOanyJ+ow9F8g==
X-Received: by 2002:a63:9d8d:: with SMTP id i135mr72466722pgd.245.1558312164132;
        Sun, 19 May 2019 17:29:24 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:319f:d85a:786b:cab7? ([2601:282:800:fd80:319f:d85a:786b:cab7])
        by smtp.googlemail.com with ESMTPSA id l65sm25918110pfb.7.2019.05.19.17.29.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 May 2019 17:29:22 -0700 (PDT)
Subject: Re: [PATCH 4.9 41/51] fib_rules: return 0 directly if an exactly same
 rule exists when NLM_F_EXCL not supplied
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Haller <thaller@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190515090616.669619870@linuxfoundation.org>
 <20190515090628.066392616@linuxfoundation.org>
 <20190519154348.GA113991@archlinux-epyc>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a36e3204-b52d-0bf0-f956-654189a18156@gmail.com>
Date:   Sun, 19 May 2019 18:29:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190519154348.GA113991@archlinux-epyc>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/19 9:43 AM, Nathan Chancellor wrote:
> Hi all,
> 
> This commit is causing issues on Android devices when Wi-Fi and mobile
> data are both enabled. The device will do a soft reboot consistently.
> So far, I've had reports on the Pixel 3 XL, OnePlus 6, Pocophone, and
> Note 9 and I can reproduce on my OnePlus 6.
> 
> Sorry for taking so long to report this, I just figured out how to
> reproduce it today and I didn't want to report it without that.
> 
> Attached is a full dmesg and the relevant snippet from Android's logcat.
> 
> Let me know what I can do to help debug,
> Nathan
> 

It's a backport problem. err needs to be reset to 0 before the goto.
