Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A14D274C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 12:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfJJKiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 06:38:50 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46280 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfJJKiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 06:38:50 -0400
Received: by mail-lj1-f196.google.com with SMTP id d1so5611713ljl.13
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 03:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZGSaWef+bdyCC9cQ5Unrg0JNLTnmmQZqX8CLFRU/ONI=;
        b=Ei//wfIokYWxKcg7ghpcSMm3CqlvCzEzFWtVS8dQnFvC43fifIKx4G9GMxzGAhuaSo
         6FKm9nHT1uo8HoemKYyBjck04R32O1BVfmN14gLJdVEbeZoAjZyhmSZCLv+yJ8w+buWb
         q9ZCRyvR3A8/9r48lMaM6kEikRc9FKN4xrzRY997OnvY8brtN3qq8S8+Pj0VZuccuDO3
         2Lr7rMSrIHEnmFn68amTPPRSDmC3oHN4VozeDRDRaO/4mAGcPOSR52obyQJJvzW6lHXH
         W/hem1znm/hq4gQcy0ajKeOtiO6wML6DsAZ7n4BwQKDslL8wHK73x6AFb873jGvQGhT3
         k6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZGSaWef+bdyCC9cQ5Unrg0JNLTnmmQZqX8CLFRU/ONI=;
        b=h9fWHQStPABUfAYiKf4iDX0PWhvHWyq2vEPhqOEtpPlYlg0ySosAYQefuP8aYFOtPA
         qUJiooQfqoMNSTDCCdxteEqzU+iwXWN4DjBLuxo4G7WvPB8Y/4Qew6nu4dYFnPOtdsRA
         /P84Frks3xNddi9X5N/ZCZlARW/JAgv+xvegfTvNc7x2vgmKibDogiwR/xDejykcN0Qh
         q4RZ0E6UCmGfI2QyUUa510QsgeLI/8EcndYOao9Zn6CueKcTAfHYPd48NKk7nT9LYrBT
         KAwg4SBea+JwWqeUoP7k5y73DWZ45wbbHZ+axA9w1I/DUiBk5Heo2ynRrmLpej+O2rsS
         t6+Q==
X-Gm-Message-State: APjAAAW5es+bBYX83TTWy3g+UWIV3DR+zeZw210L6PgV5zfLlV1Kczd5
        iuz1mISOB61styDVgB3XUVsHqQS2xok=
X-Google-Smtp-Source: APXvYqzqAnLoV0JG/5n5g+g9nrvbmAeLy1+4AnahibrC31gbFXACn/k3IMfJhKPzNOpjbKK6uNsfFw==
X-Received: by 2002:a2e:a41a:: with SMTP id p26mr6097807ljn.49.1570703927898;
        Thu, 10 Oct 2019 03:38:47 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:8a1:87e7:7d41:872a:af43:22d? ([2a00:1fa0:8a1:87e7:7d41:872a:af43:22d])
        by smtp.gmail.com with ESMTPSA id b10sm1129929lji.48.2019.10.10.03.38.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 03:38:47 -0700 (PDT)
Subject: Re: [PATCH net-next] net: usb: ax88179_178a: write mac to hardware in
 get_mac_addr
To:     Peter Fink <pedro@pixelbox.red>, netdev@vger.kernel.org
Cc:     pfink@christ-es.de, davem@davemloft.net
References: <1570630549-23976-1-git-send-email-pedro@pixelbox.red>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <b5250213-7751-a3be-46fa-cfbdf28ccd1e@cogentembedded.com>
Date:   Thu, 10 Oct 2019 13:38:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1570630549-23976-1-git-send-email-pedro@pixelbox.red>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 09.10.2019 17:15, Peter Fink wrote:

> From: Peter Fink <pfink@christ-es.de>
> 
> When the MAC address is supplied via device tree or a random
> MAC is generated it has to be written to the asix chip in
> order to receive any data.
> 
> In the previous commit (9fb137a) this line was omitted

    It's not how you should cite the commit, here's how:

<12-digit SHA1> ("<commit-summary>")

> because it seemed to work perfectly fine without it.
> But it was simply not detected because the chip keeps the mac
> stored even beyond a reset and it was tested on a hardware
> with an integrated UPS where the asix chip was permanently
> powered on even throughout power cycles.
> 
> Signed-off-by: Peter Fink <pfink@christ-es.de>
[...]

MBR, Sergei
