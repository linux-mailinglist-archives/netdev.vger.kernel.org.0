Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE6E48FDF0
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 17:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiAPQuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 11:50:23 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:49430
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233677AbiAPQuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 11:50:23 -0500
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 3E21C3F1E4
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 16:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642351816;
        bh=uu9EwQyUbuYOtlXdv8X6YvDBdNAXZT2Hiy2y1K9OCsE=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=Ah6xF7eC0TWXBsxmFjXPvU/9YqyLg9qkw/JSvMksPcoP/cYbJzPpp5jwtVWtLc3lO
         ok+ELGEZbh1r+cd3JC+SsBQHUiSYvViwGmSVgKu0RwmC83eoK6LW6uU6NV7A7mrCcj
         LflY1FAMO2o7ZBIej/P8VK+KAEm54Y9SlMirn/fu0MZBoRRYnsh8wuirF/XLWuoMY/
         t3dEfBNQuLTgyzQtdunvgQpUdzQxfrOR6+iaNEPPZhVyZfi/J7gIO7dddnI7XWbxPG
         OGMZ8oLqRK9//k38WNFqJhEfVDHIf0e2cR2ReHZUNjtntLGDscXZ+fnf/aOmXFdgRr
         sVLE7l7fCQrqQ==
Received: by mail-ed1-f71.google.com with SMTP id s9-20020aa7d789000000b004021d03e2dfso1912168edq.18
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 08:50:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uu9EwQyUbuYOtlXdv8X6YvDBdNAXZT2Hiy2y1K9OCsE=;
        b=BvI+nzrbt2EjcqXT0WRU8zYRXPHb109iMYUcBWdBYBa7WRtW1QfU+82/KUEx4OMcwf
         JwIuzdvttfRRTr911up5YECov78sH3QWpv2W5whttDVqkfEWAGjPou88S89YrbCLzAXm
         vR6emaj5rDJYoo6sde3D6wOMB3jhtNT+muhEfpaZEE2Ewoq2wVg4msoTO3+DaXq83d8K
         YPfcYYKK7D7Ipl6/bU0S0wAmRv34fH3dkJOTzlRV4YEHuRMLQ/m8lTSsZuDquBEgoH1g
         DDhwAvyDLz3V5zAa5S+0MpfgWha7SD1FpYC5GRbniqu5nZnVcfAcghF54bUqJw0M1bve
         eVDQ==
X-Gm-Message-State: AOAM532+NAxQFsf6BWmpyCtUsBEpJv9wK58xXcXojQlIPkk/kCH5s72x
        E5g1fxShQp/JUG99MKr/bDd89JMmojS/ZeP/aJyi3KUnnYFwIjos3HbtUV1Dnz0qNFz6jClGy+1
        bCmkoe9EkXANLM4SzbSAqfhVuemmGjcEsnw==
X-Received: by 2002:a17:906:3e8a:: with SMTP id a10mr13816075ejj.612.1642351814957;
        Sun, 16 Jan 2022 08:50:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxTDkNNzbNUZrdQVQnZWdz82SY8ieh3/fjQzLtq01B7PHYFbyE/eHBt0M1wSkD8sdfYhWEPVA==
X-Received: by 2002:a17:906:3e8a:: with SMTP id a10mr13816070ejj.612.1642351814769;
        Sun, 16 Jan 2022 08:50:14 -0800 (PST)
Received: from [192.168.0.35] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id 7sm3585082ejh.161.2022.01.16.08.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 08:50:14 -0800 (PST)
Message-ID: <ddce0e77-2fba-716f-6a69-eeb148fe91ca@canonical.com>
Date:   Sun, 16 Jan 2022 17:50:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 1/7] nfc: llcp: fix NULL error pointer dereference on
 sendmsg() after failed bind()
Content-Language: en-US
To:     Hillf Danton <hdanton@sina.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7f23bcddf626e0593a39@syzkaller.appspotmail.com
References: <20220115122650.128182-1-krzysztof.kozlowski@canonical.com>
 <20220116134122.2197-1-hdanton@sina.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220116134122.2197-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/01/2022 14:41, Hillf Danton wrote:
> Hey Krzysztof 
> 
> On Sat, 15 Jan 2022 13:26:44 +0100 Krzysztof Kozlowski wrote:
>> +++ b/net/nfc/llcp_sock.c
>> @@ -789,6 +789,11 @@ static int llcp_sock_sendmsg(struct socket *sock, struct msghdr *msg,
>>  
>>  	lock_sock(sk);
>>  
>> +	if (!llcp_sock->local) {
>> +		release_sock(sk);
>> +		return -ENODEV;
>> +	}
>> +
>>  	if (sk->sk_type == SOCK_DGRAM) {
>>  		DECLARE_SOCKADDR(struct sockaddr_nfc_llcp *, addr,
>>  				 msg->msg_name);
>> -- 
>> 2.32.0
> 
> Given the same check for llcp local in nfc_llcp_send_ui_frame(), adding
> another check does not help.

Helps, because other is not protected with lock. The other could be
removed, because it is simply wrong, but I did not check it.

The patch fixes the report and reproducible race, but maybe does not
necessarily fix entirely the race (which maybe this is what you meant by
"does not help"?).


Best regards,
Krzysztof
