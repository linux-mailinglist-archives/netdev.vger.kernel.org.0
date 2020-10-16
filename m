Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC2B29075E
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 16:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409087AbgJPOl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 10:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408915AbgJPOl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 10:41:59 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB3EC061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 07:41:58 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lw21so3537402ejb.6
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 07:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8xjnefrWmLPixJGXON6GHeT9VeSRG2r1UKfC37c3E9A=;
        b=tXBF5dy+KVEyJ26skMKNMeJ4ONaclyRSmqLGZT2VBnMtJugb4/gc2L0KMqNfieOZDJ
         TQvZ1r7gmWwf8Qaw6gs5gjHx39TDYoesV3kQ4ubAIDUgt+g7/ZxHJoeD8nagWjKB/1md
         2deq8XFLSbHL1Yc/CwdvFZ3m+pjNpr9VcNyMsPQrreFdp66NTOdGrqE+1ZE1uETvTKzt
         zfA7nAT5HN8C5WVcGkNoolsl8natVTXcgwaxe4wbGb8C5CeNLYymbavkEL/zRId13EOO
         tVmM9/PZIRXEd04CyZBpQLU7nB9DagSQaWJG2hlNlYr7qXyklm0SRG8lzSzcOvti0BjD
         qvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8xjnefrWmLPixJGXON6GHeT9VeSRG2r1UKfC37c3E9A=;
        b=FCCFxZ/tv9qyu7B9wQlnU5iv5yf9YKjpy3/yRP/UhbkokiwYGqouK5rUnT0eUAOLCp
         vt+W/0No88qG2SHdbmJpTT20YRtJVaDdcli7hIKYp7chCjbyysg2OerF478PwJhditte
         GUy8DcrH4mzcXRGxPJAtrefiXmtdb29oIW4YNf3eS3LbRQyXw5WK8CHFji7UIunA/+/F
         GTrsPiMShfnKXQx4oLqpifytIuW/hRacMBnUV8OG92ZJYvdoUffgaz8q6OyzXzxep4Gw
         b4rtt2tA6e7AAdhwXt5INShdNeCz4ytMHr/eZCmbUfMmjWIOuKxOTxI/XOUkPH7+bbwc
         bfhw==
X-Gm-Message-State: AOAM530zBixfHo27cCpvsKeZH9kOlm4NUCZO9d/c7EOAjCXCAyKgLRM3
        Ng8PyAl0W8sA70DOi517wLU=
X-Google-Smtp-Source: ABdhPJymNXHcAkH7IhpoPjvmcvqYCMDLqHPCKZ/9KwNU/LIL/kvEMRa6sMuoBoOLjjXIjB5Tms0YTw==
X-Received: by 2002:a17:906:54c7:: with SMTP id c7mr3998698ejp.21.1602859316869;
        Fri, 16 Oct 2020 07:41:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:51b3:5acb:4e57:82fe? (p200300ea8f23280051b35acb4e5782fe.dip0.t-ipconnect.de. [2003:ea:8f23:2800:51b3:5acb:4e57:82fe])
        by smtp.googlemail.com with ESMTPSA id e17sm1745749ejh.64.2020.10.16.07.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 07:41:56 -0700 (PDT)
Subject: Re: [patchlet] r8169: fix napi_schedule_irqoff() called with irqs
 enabled warning
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mike Galbraith <efault@gmx.de>, netdev <netdev@vger.kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
References: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
 <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
 <20201016142611.zpp63qppmazxl4k7@skbuf>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a3c87f21-7e49-99a5-026f-4a24e0cb7a86@gmail.com>
Date:   Fri, 16 Oct 2020 16:41:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201016142611.zpp63qppmazxl4k7@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.10.2020 16:26, Vladimir Oltean wrote:
> On Fri, Oct 16, 2020 at 01:34:55PM +0200, Heiner Kallweit wrote:
>> I'm aware of the topic, but missing the benefits of the irqoff version
>> unconditionally doesn't seem to be the best option.
> 
> What are the benefits of the irqoff version? As far as I see it, the
> only use case for that function is when the caller has _explicitly_
> disabled interrupts.
> 
If the irqoff version wouldn't have a benefit, then I think we wouldn't
have it ..

> The plain napi_schedule call will check if irqs are disabled. If they
> are, it won't do anything further in that area. There is no performance
> impact except for a check.
> 
There is no such check, and in general currently attempts are made to
remove usage of e.g. in_interrupt(). napi_schedule() has additional calls
to local_irq_save() and local_irq_restore().

>> Needed is a function that dynamically picks the right version.
> 
> So you want to replace a check with another check, am I right? How will
> that improve anything performance-wise?
> 

