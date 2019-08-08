Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D2085A50
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 08:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbfHHGMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 02:12:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46206 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730694AbfHHGMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 02:12:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so93648350wru.13
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 23:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U0s/TE2KV6UWHDtgqwRw1jB8OvUt1IQe30q53AHk1hk=;
        b=H3CQAuen1EN6ba8KcVUfBquRIXKgMyFmmG0Oe5AklCEic1U0eG2IYi1ZcprGtsDQtq
         F+EvOHn+chHntsC+hMgberUR8vB3J4C70a7JF6//uj0erRQreyGPPADQXI8NG8mehwY9
         vPB0SjugZyUOsE8IaWFoC8sUmKTYhHpZbygOHihRGalsTM3M1mkCFCgbFaPYc8vweO2v
         B55ygvboV1r2AReCiszkvZewhQ7noQtzzhogWtATaQkVlrBggDiNvw3zMkvHp9G3gEa/
         R/YmDxDWTRkZrkkRD1OCbt17sa3lmzexV1ammBJHm6uZSaPdw743617t3TE34pQbGV5O
         wt1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U0s/TE2KV6UWHDtgqwRw1jB8OvUt1IQe30q53AHk1hk=;
        b=XeoYCpzQanu9QkGpLHWsTjnXA6Ez7rPl5as8Rt+r/rLDmT8CtgFVK8u4p2mg4NN5QM
         fZO6GKB8WA3m6boeh2VtQ0qY6eF6Hl4I8mUGOrvlFZ4Abo1GXUnjrmLA55vhHG2DYCh6
         3RNpW86RtRfwAqhf+O+zn1uSyBcFa2T7pfO2qyu1MwEZdpZ6eAKi36N7pRKj5Da9ZTDA
         Y9asSF8GzQphNYLAZfl/vPcHYlZppDsfpMpteKm3OzB/12XQa3oYm1S817kKbXBnfACk
         avKMdUu+25VBPgrWM3hSyXGBWDzbk8NsL595x+k/nuj4cpiDJODAgdQ9MTI1azXicD/3
         xpGg==
X-Gm-Message-State: APjAAAUnatvQ/xRqlCiWco5ngxNMIpwdDAiAZS3xveVgKJa1ZVmbQPaY
        XUjanz9DGrTNh4MHer+JKHQ=
X-Google-Smtp-Source: APXvYqxkmwm8HYzroVBYOTrzQiJ2VWw+/UnCk4GK9eBTIIqLoX8iwmfeCjlji9FzaiCK4Cy6sNGtew==
X-Received: by 2002:adf:ed0e:: with SMTP id a14mr15171502wro.259.1565244766283;
        Wed, 07 Aug 2019 23:12:46 -0700 (PDT)
Received: from [192.168.8.147] (72.163.185.81.rev.sfr.net. [81.185.163.72])
        by smtp.gmail.com with ESMTPSA id b203sm2250184wmd.41.2019.08.07.23.12.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 23:12:45 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] tcp: add new tcp_mtu_probe_floor sysctl
To:     Josh Hunt <johunt@akamai.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, ncardwell@google.com
References: <1565221950-1376-1-git-send-email-johunt@akamai.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a3a69a9d-5e30-77c4-02e2-c644bfdab820@gmail.com>
Date:   Thu, 8 Aug 2019 08:12:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1565221950-1376-1-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/8/19 1:52 AM, Josh Hunt wrote:
> The current implementation of TCP MTU probing can considerably
> underestimate the MTU on lossy connections allowing the MSS to get down to
> 48. We have found that in almost all of these cases on our networks these
> paths can handle much larger MTUs meaning the connections are being
> artificially limited. Even though TCP MTU probing can raise the MSS back up
> we have seen this not to be the case causing connections to be "stuck" with
> an MSS of 48 when heavy loss is present.
> 
> Prior to pushing out this change we could not keep TCP MTU probing enabled
> b/c of the above reasons. Now with a reasonble floor set we've had it
> enabled for the past 6 months.

I am still sad to see you do not share what is a reasonable value and let
everybody guess. 

It seems to be a top-secret value.

> 
> The new sysctl will still default to TCP_MIN_SND_MSS (48), but gives
> administrators the ability to control the floor of MSS probing.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
