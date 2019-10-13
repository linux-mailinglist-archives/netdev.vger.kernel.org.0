Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB14D5806
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 22:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbfJMUUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 16:20:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36914 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfJMUUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 16:20:30 -0400
Received: by mail-pg1-f193.google.com with SMTP id p1so8832284pgi.4
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 13:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TXhlQpufX/va8sP8FSOaJGZ194vaKQPcY4MrY2DLV7U=;
        b=lc9ozKIRORPxXdO1fQ/JFWAMM4NBpt4MtsTckYYiwvt7t3n3/C9axHDda7liLs2zHR
         Dxx/DQnOkR/WhCkbmgd/K+bsRBC1Abo2d8YtO+k3AgMYJCPLJrYvKBVQLK8JwtMWxKHI
         5ryQdPuJDAKI4exrN1Rp0HvxyHtDo5zbDyE4xK+eUzbfasGvByOmul+PH1h4SXB9u2kj
         JjnAI32QzeES6xI0OI4njni+rR8//mt2z2ocBAPvYTtkGWTJ36zbpbPRGn+qylPFh91y
         mGlepTNjqCrhlpLa08ex3Zv36b6CvUb4OhZ6NsFuk2uZS4aj1z3TtOK+AGRy0gpJ3F9a
         DcSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TXhlQpufX/va8sP8FSOaJGZ194vaKQPcY4MrY2DLV7U=;
        b=RmrYjsz9fuR9/pwoQs2B+o5Al2AmL0r0CeEAkeb3RxbQaTXahJC4edJQ2dZbKZukfa
         lpx3jfcOr1OEuNdyysGGbRPLVqnGVCSu4esGcr0eTeH6VzneH+F6AzKqa/LvqqvWDc1L
         9upMKHOl2E7SWhQjhckPPpZRvUkT/Ywh9Chid2w665EPxhoahJWnLWxX5PCwWB2rohne
         sd6pW9+skUYrJ3qgY9Y90Bg1bwGhwU6HWqjxcd3vmj89x3Z/e7AzZ0UtVvYzFfthnwwH
         BNeh1QCsnKNQnLlRn4eU1AeVS5qVRZrcF+K/OOyNj0U09tRVhyDC7SnfZWzMQTVPfsT/
         H+Mg==
X-Gm-Message-State: APjAAAU/kVnAenkXOauUaaKg3d8YkTVhhrFFSzGK7/8p9FGpAcdHeN2y
        3naf4a8qdtgOkH0vDaG/frE1XDDM
X-Google-Smtp-Source: APXvYqwTid7Zzc+sGGfs1N4tOMfDwua3Mml6Jsci29SkxBSokpjjTHYd27MLxNHXKDM90K0fBi+LYA==
X-Received: by 2002:a17:90b:d90:: with SMTP id bg16mr32388306pjb.143.1570998029586;
        Sun, 13 Oct 2019 13:20:29 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id j24sm15997315pff.71.2019.10.13.13.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2019 13:20:28 -0700 (PDT)
Subject: Re: [PATCH] net: core: skbuff: skb_checksum_setup() drop err
To:     Vito Caputo <vcaputo@pengaru.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20191013003053.tmdc3hs73ik3asxq@shells.gnugeneration.com>
 <52dfe9f3-cc54-408d-6781-3bc0a86ebae8@gmail.com>
 <20191013201716.dwxfbr5kbueexomw@shells.gnugeneration.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <41da7b75-689f-9065-dec8-931ff9b4b91c@gmail.com>
Date:   Sun, 13 Oct 2019 13:20:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191013201716.dwxfbr5kbueexomw@shells.gnugeneration.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/19 1:17 PM, Vito Caputo wrote:

> 
> Except there are examples under net/core of precisely this pattern, e.g.:
> 
>

We do not care about having consistent code styles.

linux kernel has been contributed by thousands.

Each contributor has its own preferences.

We do not want to enforce very strong rules.
This is all cosmetic.

The real things we care are the backports we have to do every day.

Having these 'cleanups' in the way make our life miserable.

