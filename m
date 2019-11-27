Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7F610A77F
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 01:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfK0A2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 19:28:06 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:45521 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfK0A2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 19:28:05 -0500
Received: by mail-pj1-f67.google.com with SMTP id r11so1241665pjp.12
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 16:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mHU6lubUhvPWuQH4ceFqF5c+Zs46iyvSbwZN1EMKWDM=;
        b=IwfrQMzc8DWuRCVmPftrch9rCXxjFoY4q0S25Hm7z6pz/PjRdGRNDQlYX3SnuE9zYJ
         FKUU5KW1aMzt9AirguJquPGGYqY1S1XIg35DSv/OmuhQNSTgjESHSjtWKybmf00MuXjs
         IdppkNzKG1k+bSusSE11c1G2KWnsnd81/KaqRDKWx3olcQZDwV4MOEr16wTEHL8DYWK4
         l87T0HNH1F/9i8x7uFz5n1dmKTt9SsgX4iISTzQZDjZhfq4cZRZm/UEfusYJa90IQE46
         KkP3pKtVRd5E68rvUcqunpbnuq1l2csWMLrF1gxQy0QW4YuMhWk2g8Fxw1CDvut41oYK
         LVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mHU6lubUhvPWuQH4ceFqF5c+Zs46iyvSbwZN1EMKWDM=;
        b=dzT1Juiaf/zGhmsMAgdjCPpfKThf/kWwXxngBvKAmI0meTWq5XnDHEHdcyKAuxxnbz
         JeN5GVQJyoQ6/whUm665xBQTU2jBjctr7t23uf046Tv+l+fLIsw0gYeoiX6DyVjsW1kt
         hPsz00Ree8usZrPIZd01e7Fh457C5yPDfnzzI+9vqvocrtqsflZt8MAlgZF4kmENybY8
         R1LurVbW2zEZuayx42XnVl4/mDzkVlfEBCn5vX/gHPE8Rit3FjqFJNuhG9uwMZq0oemO
         dualF01XwAS0OJdRFrBR0+AzFPUtlayQEWwsz/9JtBKODXu5fWqnCex0Hwsk8e+gWlq/
         NldA==
X-Gm-Message-State: APjAAAWPim0/eKeeNQ8isXI+k3G4PgJ409pUqM7z26TX1N8bgMG8hyUW
        N7l3qHkrKSiySuk1P+ffvW3SwAAk
X-Google-Smtp-Source: APXvYqzwi1Gdhwq8k0weTjZQCaMLulGgyJ5xA6AVaPV2K8Hqn5xQs8Q8MRGHz0yqWNxiiaBPcobmqw==
X-Received: by 2002:a17:902:ab98:: with SMTP id f24mr1143773plr.257.1574814484748;
        Tue, 26 Nov 2019 16:28:04 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o124sm14116422pfb.56.2019.11.26.16.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 16:28:04 -0800 (PST)
Subject: Re: [PATCH v2] net: ip/tnl: Set iph->id only when don't fragment is
 not set
To:     Oliver Herms <oliver.peter.herms@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org
References: <20191124132418.GA13864@fuckup>
 <20191125.144139.1331751213975518867.davem@davemloft.net>
 <4e964168-2c83-24bb-8e44-f5f47555e589@gmail.com>
 <10e81a17-6b38-3cfa-8bd2-04ff43a30541@gmail.com>
 <a78cf0a6-3170-bb5f-4626-11c22f438646@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <edbe602e-40ae-3f1e-8abd-a6c36b306865@gmail.com>
Date:   Tue, 26 Nov 2019 16:28:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a78cf0a6-3170-bb5f-4626-11c22f438646@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/26/19 3:32 PM, Oliver Herms wrote:
> Using a simple incrementation here, as with sockets, would solve my problem well enough.
>

I have to ask : Are you aware that linux is SMP OS ?

If on a mostly idle host, two packets need a different ID, using a " simple incrementation" 
wont fit the need.

sockets are protected against concurrent increments by their lock.
