Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA89A3C8BA2
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 21:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhGNT3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 15:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGNT3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 15:29:02 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057F1C06175F;
        Wed, 14 Jul 2021 12:26:10 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 22so5455570lfy.12;
        Wed, 14 Jul 2021 12:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5z77xaqgcAqQS574mQicaaSoe0tH1/ryQFhzvKaFXvk=;
        b=sGr1dk+k+2PVV6xOZ5MfjqYFVUsiyv0MiYKp670dHKV/DCcfb+1Mcy+z/ZCFOg0ISb
         OJdgw+OHPmhZ1iAHtoRJUvZ9SN/t+QD3JXgmsA1MWQjHce2Lxh1CGmuCDyT0BhjV+mJg
         P6Z6uXdK1TJxbHXluJl+8rGTaPpmW8x5tAIootQ2p4bz2KkiY7z9UoZr862s3wXwZJGX
         moyF6DRyj+HaCUO4DTcqb71L0l7a6Pw1vK7GIjf/xOBjic8h1Ed1NIcI5+94ptGzYlU1
         aN3JN91moEPkObC7PMc8ygt2lMtHYVQ9aD0Tm+c4gfYJ8hOltXGK7Fuw16DotiZOzuA6
         BJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5z77xaqgcAqQS574mQicaaSoe0tH1/ryQFhzvKaFXvk=;
        b=HWhcKSnau+6sTD2VcvKb3HHcifMRnoXJUCeoQR7+ru5A/WqckgqEa0N+xhzUbCfVh7
         R8LQL4zkhlfueaP6VvEYHuwIh/nzvAzYaaw3HFhvay+VblZTgHsJuFoDgyEHEAhfdd5F
         WjVraWmOQ/Xfv7iuf6B6Ez9BbhT75Rk7Kg0rCBC/pTs88w8a0qQGEmG89/i+427KX5rm
         5lwm7E9HVGYU3ftFA27MmxyHZpWq7jsNgHP0Fan8ooU58QaxKL5ruyrc+NyWpig15Pbp
         nKCsPzVSJzfmAxu5m9uid9tYw5XX0QPhE/phgVNpuhcE0GilpyP31Xv/Et8NrcQpkDPC
         7vVA==
X-Gm-Message-State: AOAM531UoxRhValRhkbJlY99oxBWyWVyJoJXfn09xFN40VuUqMNw+arF
        I2qcaYiTxGXsI9etCJowWxU=
X-Google-Smtp-Source: ABdhPJwZ7ygrDubZJW72ZUOVUjXjqomTBBMDhWMnQmbE0RJPyTMKBV546hy4a+ClkkxW2tcgw7pAAg==
X-Received: by 2002:ac2:4c49:: with SMTP id o9mr8961196lfk.212.1626290768377;
        Wed, 14 Jul 2021 12:26:08 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.80.53])
        by smtp.gmail.com with ESMTPSA id e12sm357214lji.90.2021.07.14.12.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 12:26:07 -0700 (PDT)
Subject: Re: [PATCH/RFC 0/2] Add Gigabit Ethernet driver support
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <db9c3972-8b55-e0df-3101-20aa38eba1b1@gmail.com>
Date:   Wed, 14 Jul 2021 22:26:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/21 5:54 PM, Biju Das wrote:

> The DMAC and EMAC blocks of Gigabit Ethernet IP is almost
> similar to Ethernet AVB.
> 
> The Gigabit Etherner IP consists of Ethernet controller (E-MAC),
> Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory
> access controller (DMAC).

   Do you have a mnaual for this SoC? I haven't found any...

> With few canges in driver, we can support Gigabit ethernet driver as well.
> I have prototyped the driver and tested with renesas-drivers master branch.
> 
> Please share your valuable comments.

   Commented on the patch 1/2 already, will continue with patch 2/2 review
tomorrow...

[...]

MBR, Sergei
