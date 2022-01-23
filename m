Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6FE4971BA
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 14:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiAWNsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 08:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236493AbiAWNsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 08:48:23 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F3CC06173B;
        Sun, 23 Jan 2022 05:48:23 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id br17so43903132lfb.6;
        Sun, 23 Jan 2022 05:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tT2QsM3sOU580118+Y+fw5XqnLQNgWoMgfe/Dm4461M=;
        b=WnZzxJs3kLiXg2qX/fHVvRJ6dSgPkl/UdgR8Ru2VwL728msT1somaEusBekyTJYtpd
         OefTD6jywZZA81pTC3dlmLrx4LG4cAk138DzYBwfY/tPgcbvTIf9gPSP3Pf6KOCat06E
         Bc08p+cZEoYERzUH0oRHJXFNTH5qrSC9DUYsE4SiwgOcm/GqDWrO+peWlUGxt4VJlgqW
         FoaOSbTHRHQ0J/8z/rWWfcqofl9tdaosurcHMMVNFhkaH+tLKD9aQTEGsZ5Me/SF7tOH
         Ukih3vmJ6ucynwyJSVEvsj6c5EKDggFn6j16XiU46zEmdj1RjpLrk/zIN7gy9+hxy0wd
         Pn9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tT2QsM3sOU580118+Y+fw5XqnLQNgWoMgfe/Dm4461M=;
        b=IRfPbZ9DMI4IPYIsdAoDh9+aal+7/i9yicygFQgVmhqjgHPPh/zQ7NWAIzPutCnF2W
         rkP09ZTWNPxWEi16B6z001y8iRhn6PvYrrxzrCo5TkYTmXPnvzIa6oZPkFRL3zzRyYCF
         zVY/LeYCpw0bJLqBmfQbZy96SbVKdr1K781MqKUOgKG+TEvey9Z9eTnvp7pPyh+xp/2U
         AytVEvmPkHe0DFKFG+WDtBGNAhuqgQMZdsNGGT19yNzAf4CvXLBTMHrq3qZfL6KWgraW
         S8zgqU+pgF62MyRhPn8MHSMQqvY1mhJrAy677JrmDygAGvJmvOCyi4GC9ICaAafVlBxa
         3boQ==
X-Gm-Message-State: AOAM530Kwv7xC6wZHTpoWKONrgmD92QKo3NHFQhbOzezZtJkZuVFrh1+
        kbvcbaMWTyQP3O2mtoHxEjA=
X-Google-Smtp-Source: ABdhPJxCat9CBAklA6IWceY3oZF62+seQ6TBE1nFUXX8xff7baTG41pFN+oo2iwzXcUMfbzMSlLDdA==
X-Received: by 2002:a05:6512:16a6:: with SMTP id bu38mr9890501lfb.168.1642945701265;
        Sun, 23 Jan 2022 05:48:21 -0800 (PST)
Received: from [192.168.1.11] ([94.103.227.208])
        by smtp.gmail.com with ESMTPSA id k14sm664406ljh.82.2022.01.23.05.48.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jan 2022 05:48:20 -0800 (PST)
Message-ID: <192d9115-864f-d2c1-d11b-d75c23c26102@gmail.com>
Date:   Sun, 23 Jan 2022 16:48:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] drivers: net: remove a dangling pointer in
 peak_usb_create_dev
Content-Language: en-US
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        =?UTF-8?Q?Stefan_M=c3=a4tje?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20220120130605.55741-1-dzm91@hust.edu.cn>
 <b5cb1132-2f6b-e2da-78c7-1828b3617bc3@gmail.com>
 <CAD-N9QWvfoo_HtQ+KT-7JNFumQMaq8YqMkHGR2t7pDKsDW0hkQ@mail.gmail.com>
 <CAD-N9QUfiTNqs7uOH3C99oMNdqFXh+MKLQ94BkQou_T7-yU_mg@mail.gmail.com>
 <CAD-N9QUZ95zqboe=58gybue6ssSO-M-raijd3XnGXkXnp3wiqQ@mail.gmail.com>
 <8d4b0822-4e94-d124-e191-bec3effaf97c@gmail.com>
 <CAD-N9QUATFcaOO2reg=Y0jum83UJGOzMhcX3ukCY+cY-XCJaPA@mail.gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAD-N9QUATFcaOO2reg=Y0jum83UJGOzMhcX3ukCY+cY-XCJaPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dongliang,

On 1/22/22 09:45, Dongliang Mu wrote:
[...]

>> Yeah, it seems like (at least based on code), that this dangling pointer
>> is not dangerous, since nothing accesses it. And next_siblings
>> _guaranteed_ to be NULL, since dev->next_siblings is set NULL in
>> disconnect()
> 
> Yes, you're right. As a security researcher, I am sensitive to such
> dangling pointers.
> 
> As its nullifying site is across functions, I suggest developers
> remove this dangling pointer in case that any newly added code in this
> function or before the nullifying location would touch next_siblings.
> 

Based on git blame this driver is very old (was added in 2012), so, I 
guess, nothing really new will come up.

Anyway, I am absolutely not a security person and if you think, that 
this dangling pointer can be somehow used in exploitation you should 
state it in commit message.


> If Pavel and others think it's fine, then it's time to close this patch.
> 

I don't have any big objections on the code itself. Maybe only 'if' can 
be removed to just speed up the code, but I don't see why this change is 
needed :)




With regards,
Pavel Skripkin
