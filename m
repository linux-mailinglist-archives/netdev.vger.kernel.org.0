Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37A64F693
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 17:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfFVPgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 11:36:00 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:36308 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbfFVPgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 11:36:00 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so154160ioh.3
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 08:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UiSSfSB0BJJLMfacmdxJ2fSanXoz8qvP6og2pUxtT5I=;
        b=T2sQ+3ZV+WS/rSuyHg5QE5V40rIorhrS9UlS8ax08PJ+sMpkIAA8Oki5/nEmUd3KjP
         axFlKuacZ75ImzHWVPp2XOqml8xLewr/6dFnM00Cw07q+MgzF+BkqyM3utV6VCi3Ijro
         r2sxdASRIoepQJy/Uw3/wyVqQx6SAXY05nYgQoWUv+ttNgS+vKn40ZUoL2FHkMnYnoCc
         3mvQ9M7IRE09lgpzf1boGWSDoXNRQg+3Yp/nxp78l7lwwguWEaBCWXqCwOS7Z24fabNA
         F14T1VNolUEBU1sTHMfSLqt38O+jwdKrf4q84WUx94nNzPbCaQWfc5tEiq/cwJKrwOLd
         b20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UiSSfSB0BJJLMfacmdxJ2fSanXoz8qvP6og2pUxtT5I=;
        b=nua2hr3RsqG859VkfOEedSlN53ZSmDxvDCx1mCjKd+MAVbkxkLsj3hoBmBinWgH9J7
         BTwPEKdExtwEHTeogW6x7C3+2bLq9cFmVqREpdWBUtcTfKSfykqMgMI1WFsMqLPOW6pQ
         zvVPg2fhtiM902EnAjOar+aE4GM9ntl1KwnGgphsHBcPHl+TDO4pEUw75IPE7iPV7R30
         MIrpP4f+yU8gKV/CbqboGDpq+CG6G3OabL6kQe8K2fmF1ixak03qvjKoyo5n8q1EjAlT
         XKY8BFCJ4maUffwQgKjIzzYCSwaSjyOubIEujw1qhfmT7QNFOGCPmKkjH4ZbNmt1ig2r
         Vjjw==
X-Gm-Message-State: APjAAAWRpn0DHCI89jN3CUnhe09xeJyDl4NsaKykLhotQE1cuRWrxDoZ
        CQr2+EdEu8l+fmwQn6tArauSB5pn
X-Google-Smtp-Source: APXvYqwDZyHAQoUfet+FObQSAuc8cxT045D58f/BcG0whu2zVSEY+/kwv+JjMTgknxuaNWopqxetVg==
X-Received: by 2002:a5e:c241:: with SMTP id w1mr30781896iop.58.1561217759235;
        Sat, 22 Jun 2019 08:35:59 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:198e:d534:dcaf:d5c9? ([2601:284:8200:5cfb:198e:d534:dcaf:d5c9])
        by smtp.googlemail.com with ESMTPSA id k26sm4695760ios.38.2019.06.22.08.35.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 08:35:57 -0700 (PDT)
Subject: Re: [PATCH next 0/3] blackhole device to invalidate dst
To:     Mahesh Bandewar <maheshb@google.com>,
        Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
References: <20190622004519.89335-1-maheshb@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5441f3f1-0672-fbb1-e875-7f8ceb68d719@gmail.com>
Date:   Sat, 22 Jun 2019 09:35:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190622004519.89335-1-maheshb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/19 6:45 PM, Mahesh Bandewar wrote:
> When we invalidate dst or mark it "dead", we assign 'lo' to
> dst->dev. First of all this assignment is racy and more over,
> it has MTU implications.
> 
> The standard dev MTU is 1500 while the Loopback MTU is 64k. TCP
> code when dereferencing the dst don't check if the dst is valid
> or not. TCP when dereferencing a dead-dst while negotiating a
> new connection, may use dst device which is 'lo' instead of
> using the correct device. Consider the following scenario:
> 

Why doesn't the TCP code (or any code) check if a cached dst is valid?
That's the whole point of marking it dead - to tell users not to rely on
it.
