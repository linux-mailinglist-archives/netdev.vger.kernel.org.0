Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23D06CAE7
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 10:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfGRI1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 04:27:06 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:39486 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfGRI1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 04:27:05 -0400
Received: by mail-wm1-f53.google.com with SMTP id u25so14327274wmc.4
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 01:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yw6yBfRvbKNVtcHpQQBCwswNfk96xs+63EPW5/5Qtw0=;
        b=C0pkEDLS7vfvkEihanIrfr+zmWXdAMfNkMxgwLZJxVDsNOubbn7VCUgJGg8nL6nP3A
         7Ph7f/PzEHiexT91agPBTOjj7vXFhDlppVDK4xmIKeqDHf33pFFqJa6Z9MWqFFLmBSqc
         HXH6Trpno1zGzNN3IaGzpjLIlUDqKo4nkMTgm4ENLPd49livWBFpN+DLBek420dQssh1
         o/pHdWd3gy515HzDfbEVK7q+0UTgzYJS/MOCF7iX+bQmZmayvgL3KE+WNhDeGiYrmQEV
         fMggt2cV7m09lmv50AXPSkJT/9E66OlOVvKnEqlqI29GWpUYub9DP3mI+mnLO7YMwpOz
         aRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yw6yBfRvbKNVtcHpQQBCwswNfk96xs+63EPW5/5Qtw0=;
        b=PyeZZqwMlCW5w0CGf1ukZ/ZmmCgXCcHa7HJ9MUbTK3DfVH5cNBfbBYt3J1WfLKgC74
         DMHMs7iTVUsOkYiu7ZO1rj16OV/h+z19Jf7BVNypcupNVZ5Dn0mUTDBK3l16TBFUH3WD
         ufLEG1Xgy73mo2CdCa4KsEG3hpHSC+NUBolmDUHEWb5uhbKgHos8C8Y2w8qhKQ0KWNXh
         VlleMyMJF2zq68srjXVZaJYtToMu81c4HrZXPnW9h6cQ4GXq4DWxV+q8zjhIzIt1NHWk
         yAHjqm+ZDHeaO5Ex2kIK+rGa8p7LBL/q8ZO16fCSfHx7ele2aUy2S/HSndTyYm55R1NR
         h/tw==
X-Gm-Message-State: APjAAAVDqQILKGscSdgbK4PO+j2BkR7kB25z1mGMxCpU6ps3gkQxohJd
        m6dg5EYpZ79qd3psbirco/I=
X-Google-Smtp-Source: APXvYqwFkCWmxr3KsSrk5ENbbtNuB9TNNNv41NBT2FEbrsFkYUGh5d9Kay6t06++xqldA62VxvLvOw==
X-Received: by 2002:a7b:c954:: with SMTP id i20mr41733346wml.169.1563438423851;
        Thu, 18 Jul 2019 01:27:03 -0700 (PDT)
Received: from [192.168.8.147] (72.160.185.81.rev.sfr.net. [81.185.160.72])
        by smtp.gmail.com with ESMTPSA id e7sm25713835wmd.0.2019.07.18.01.27.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 01:27:03 -0700 (PDT)
Subject: Re: IP GRO verifies csum again?
To:     Jacob Wen <jian.w.wen@oracle.com>, netdev@vger.kernel.org
Cc:     herbert@gondor.apana.org.au
References: <6cc12686-a13d-81a8-ad3c-4601397c900e@oracle.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2154bca7-17d0-3ed3-ab58-55f33cd13ac5@gmail.com>
Date:   Thu, 18 Jul 2019 10:27:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <6cc12686-a13d-81a8-ad3c-4601397c900e@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/19 9:49 AM, Jacob Wen wrote:
> Hi,
> 
> inet_gro_receive verifies IP csum but a NIC already did so and set CHECKSUM_UNNECESSARY.
> 
> 
> https://github.com/torvalds/linux/blob/v5.2/net/ipv4/af_inet.c#L1432-L1433
> 
> if (unlikely(ip_fast_csum((u8 *)iph, 5)))
> 
>         goto out_unlock;
> 
> 
> Is this a bug?
> 

This checksum validates the TCP one, which is the real cost, since we need to touch all
the packet.

We do not bother 'offloading' IPV4 checksum over 20 bytes or so, since in modern cpus,
having the cache line hot in cpu caches means the checksum is almost free.

Adding a test here would not always be a win, say for CHECKSUM_COMPLETE cases,
which we try to generalize in favor of old CHECKSUM_UNNECESSARY.
