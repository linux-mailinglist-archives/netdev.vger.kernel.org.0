Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6086D2EB221
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 19:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbhAESKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 13:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729942AbhAESKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 13:10:03 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385B7C061574;
        Tue,  5 Jan 2021 10:09:23 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id i18so155106ooh.5;
        Tue, 05 Jan 2021 10:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nmq2kO+cPiy9e4NtZSH/IyPsbZqoQN4eANbVVttJ7u0=;
        b=slqfY5NQrlxZOi2kJWnFSyJ0vPpoxCEASYXVsitmOdheK2fkS6kJb++dUPmzDeleHX
         +tJqRzFpL7enjDy/p+mMseAnutWeB9cvx3bPnKfiUkJHNPU1dOFs5IthwPi0h6ENb2+m
         Fp0iqW2hjoJDs9zVNb3Gyd7xMgazMxUg3z6J7+dvW8Wr0rCf0X0jSdwzz5rdjBbzD2Fr
         TUWPNr0cCBeNQOk2uZtjMO68gOAw59pQ28v+R9hYPUj+x2nb58uizA62dX0nDbeT4F3Q
         uO3kbePp1CKZNVaLKDTV+MECG9iO5+KqflJMjKr7yMgDVTxSeERRmMxBUohZZYCoNFVw
         rTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nmq2kO+cPiy9e4NtZSH/IyPsbZqoQN4eANbVVttJ7u0=;
        b=hy9WdDnTNFJmMi22I8YVydsMbk5H8cuO/ipO0Bju+hphfKn34t3+luoDcwvWlyGU5d
         zIq/clwgrfsLa/iD4Vr+NPiOU3zX2GMUt2+htjwGL9+i7ho8KMmnLiwJJY20UgFedpAx
         MghwWr/H8mojolkhl2EEByLU82Dk8YN2lHqU1qcuWE0cBWB6s7sra+1roPquW4C9taqw
         6SDpLL/3eNipacSbYiqt9S5pvsZ4XPiv65oVcdGENf6SirdUn7p/yiaHnUQD8KDiHUFl
         SCdBztyc+PgYvKIz+6t2vrxgonNj8MtpDZQ65Y/beRk+NLNyvlSAaZFyedEK0UYi4A+N
         ea6A==
X-Gm-Message-State: AOAM53378jNFAa9LKmo2PIHlq4VONgXtdKu0dJDEQMd1hc88m0Y9nHSB
        BA4C3Pg5jqZmt8a1mitqGnrrZGNNlh0=
X-Google-Smtp-Source: ABdhPJyso5TnB8RJCeGVVhYq4/0FP00Z97b6JIqP28Y6OSmwW8OTe2EVVtRLRLrSOp7Uad2flGco4Q==
X-Received: by 2002:a4a:c387:: with SMTP id u7mr162083oop.89.1609870162361;
        Tue, 05 Jan 2021 10:09:22 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id x72sm32967oia.16.2021.01.05.10.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 10:09:21 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word association
 defautly de-faulty
To:     Joe Perches <joe@perches.com>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Julian Calaby <julian.calaby@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, zhengbin13@huawei.com,
        baijiaju1990@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20210105101738.13072-1-unixbhaskar@gmail.com>
 <CAGRGNgX-JSPW8LSmAUbm=2jkx+K4EYdntCq6P2i8td0TUk7Nww@mail.gmail.com>
 <X/RD/pll4UoRJG0w@Gentoo>
 <CAGRGNgVHcOjt4at+tzgrPxn=04_Y3b16pihDw6xucg4Eh1GFSA@mail.gmail.com>
 <X/RQeqAikxaCO2o0@Gentoo>
 <d6ee8f44f9ca285f17bdec972bcd0abb89fe64d6.camel@perches.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <23353e52-8a50-2024-e5b0-591d4e2f720e@lwfinger.net>
Date:   Tue, 5 Jan 2021 12:09:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <d6ee8f44f9ca285f17bdec972bcd0abb89fe64d6.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/21 5:55 AM, Joe Perches wrote:
> On Tue, 2021-01-05 at 17:11 +0530, Bhaskar Chowdhury wrote:
>> On 22:24 Tue 05 Jan 2021, Julian Calaby wrote:
>>> Hi Bhaskar,
> []
>>> and your change is just making this comment worse.
>> really??? Not sure about it.
> 
> I agree with Julian.  I'm fairly sure it's worse.
> The change you suggest doesn't parse well and is extremely odd.
> If you _really_ want to just change this use (and the others),
> I repeat his suggestion of "by default".

I agree with Julian and Joe. Your suggested change makes it worse!

To match ALL previous commits/patches for these drivers, the subject should be 
"rtlwifi: <driver_name>: Fix description of usage of own bit in descriptor"

For all drivers, that comment should be written as:
         /* By default, a beacon packet will only use the first
          * descriptor and the own bit may not be cleared by the hardware
          */

Larry
