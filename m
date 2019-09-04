Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5E41A7CE6
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfIDHjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:39:12 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:34333 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbfIDHjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 03:39:11 -0400
Received: by mail-wr1-f44.google.com with SMTP id s18so20110274wrn.1
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 00:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=O24WUm2SHjCUp3nfiJu2C00yeuq1HwCwXI0nqaVJozU=;
        b=Ax+1nqKD6kfGuBOYXwk4ycttrKAxBk/3f8Z2AccXHR4MBdJJgHaSkjwfTmHk8ACUGy
         BGSCLUGfsSBrFWOdbx48GquLmWjFIFqkAGydRpbCFm1XywhT8iA6sjAnorUGBnq8iCVG
         fY5/5ZI2rVdjureWrLjHwuvS/5ajib6FeTzgjASu2ufGoB7FKDPAqbUJif4IpJBe9uHf
         u0X3RA9GW07Rc0evb2i3ulcj59ifMN0eszeq6peYv5D0B6tsk1JYuuFJlUgEN4zDOz+4
         kqnnsUamW04FYWfEtjK29GG/PRnZWLO/ioblEJ0wnzVqa8/l4qGF02WIymivuxrcPH6w
         OzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O24WUm2SHjCUp3nfiJu2C00yeuq1HwCwXI0nqaVJozU=;
        b=snq/vCEJIT2f/nvYvl7+sWDbr8q1V020VcPFXRDd7nIEQdfRZuAFdaez9UYrG8qyoI
         E+CwnjXQL+QmREcxZ3wPkeHzGKsOyZbSMsWhY/fEFmZ8f+IskUCSrvx9T9nWSCyVJ3LA
         yhZkbmY4g/6moI4xZAEiWnRKMh7eGt7q/4sbw9W+FimBWf9WRAxmvspkWH/lnYqzFtLU
         Jd+zOC7p4kQ4wxJTb82uI7Vtz2MGyu1YNODjnymwkneyECACMXTlnwzy96d+OsaaNP8s
         EqpP2V0E00c0FVifQ2RtZ3GbgVaenRmlw5TQumwWTuC0Hjg4UbYO6uFNsfSGzkcKyMcI
         rcpA==
X-Gm-Message-State: APjAAAUzDirkQ7H+ZH0Pz7XPrs9iKVZeQxAvI9nr+wdJs4tLUrme1YBL
        hrWTooQiFaY8xdKQjfrhob71IOfA
X-Google-Smtp-Source: APXvYqz0Oyl84xrHHs0W1C7MjrOJUw2Xl8VATmWZnAEMoeTJgzsRN8l16l8xrmhBmD8rVVrJYM4hTg==
X-Received: by 2002:a5d:4b41:: with SMTP id w1mr8526036wrs.23.1567582749379;
        Wed, 04 Sep 2019 00:39:09 -0700 (PDT)
Received: from [192.168.8.147] (83.173.185.81.rev.sfr.net. [81.185.173.83])
        by smtp.gmail.com with ESMTPSA id n14sm66611615wra.75.2019.09.04.00.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 00:39:08 -0700 (PDT)
Subject: Re: rtnl_lock() question
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Netdev <netdev@vger.kernel.org>
References: <29EC5179-D939-42CD-8577-682BE4B05916@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3164f8de-de20-44f7-03fb-8bc39ca8449e@gmail.com>
Date:   Wed, 4 Sep 2019 09:39:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <29EC5179-D939-42CD-8577-682BE4B05916@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/19 11:55 PM, Jonathan Lemon wrote:
> How appropriate is it to hold the rtnl_lock() across a sleepable
> memory allocation?  On one hand it's just a mutex, but it would
> seem like it could block quite a few things.
> 

Sure, all GFP_KERNEL allocations can sleep for quite a while.

On the other hand, we may want to delay stuff if memory is under pressure,
or complex operations like NEWLINK would fail.

RTNL is mostly taken for control path operations, we prefer them to be
mostly reliable, otherwise admins job would be a nightmare.

In some cases, it is relatively easy to pre-allocate memory before rtnl is taken,
but that will only take care of some selected paths.
