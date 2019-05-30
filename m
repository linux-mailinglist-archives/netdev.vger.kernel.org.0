Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC112F90F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 11:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfE3JMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 05:12:00 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45411 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfE3JMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 05:12:00 -0400
Received: by mail-lf1-f68.google.com with SMTP id m14so4391687lfp.12
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 02:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=voAp2WtjCrorqQ5ljFVovFNN+W4jtil5Y8wsKYlsKkY=;
        b=AljnxgrcoViOjePLPkPD/RTOG6RAXos1o39z1MBQxUJXhCIvWU2t+ZVa8IUEWmSojD
         J7PdDiDHIaJT0U5E9J6N1bWJPMWoBHMHvxTGmK/s/+/qTiGjAMiVg7HgX6YdtenYpSeT
         TqfBLc2tsAHrhgq5uZHORqxAB4XQPHVUD+9j556B6kymMdNLVUqe9B76zgGqMqN/bCLv
         T27ZgOA5hKVXKudSC1VVCtYLuf5W5U1zD20ts5kTaAmZRFqubrCyf4JQqHaNcma+TETC
         v4dIfV3XTVN3pnw1IlDpaZduN+QmY1RzkCRPSbKBtAqFRQEOv6wOtwO4OMAEKokE8tzJ
         jK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=voAp2WtjCrorqQ5ljFVovFNN+W4jtil5Y8wsKYlsKkY=;
        b=IVJ3qwMPAxK5N5vvSHADiD42WuZ6WjL1Tl9voG1Q3h6ni5qCDdcsRYgikYha3WQmnz
         JqIg/Gi38EIc6nMZRchAde1VHQ7e4Eouz6xzXqLJsklNoTSAOHoV1sh6RM7eixUB3+10
         LpSVK7e6fLW7d0TvwHzf3p1TKdci9LOG9p2eOZXBt+5CoOH2BJZaB+zP1pS5oiUcm2GC
         gDuxC+axmMj8An2l7yutU5bodIg6GAkq6jF1ADBAy+CaZgTll49aCKJK3urwJ2H41NYn
         IJmocl0Ty7u0+v8WTka+CMAVVj8wW+TooFB+VehM2NtQcI4RcZp6OpDCGhDWi0fdMhEL
         9Mtg==
X-Gm-Message-State: APjAAAWIGyX5ofB29Ghd6qReEZfHgyXKcEtHauv+9WZug6lOfTTmFFcc
        vJjyFB+7aKZwz+i2bb6GQviH5lt5YzQ=
X-Google-Smtp-Source: APXvYqzERZfjp5gyfdJ4vSHm7vKm0QHcmqOfCD42yB/j3rJj12bVGfN/kYvcSIKAQCASMC6KDMuRpQ==
X-Received: by 2002:ac2:514b:: with SMTP id q11mr1533656lfd.33.1559207518496;
        Thu, 30 May 2019 02:11:58 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.85.229])
        by smtp.gmail.com with ESMTPSA id t13sm352381lji.47.2019.05.30.02.11.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 02:11:57 -0700 (PDT)
Subject: Re: [PATCH] hooks: fix a missing-check bug in selinux_add_mnt_opt()
To:     Gen Zhang <blackgod016574@gmail.com>, paul@paul-moore.com,
        sds@tycho.nsa.gov, eparis@parisplace.org, ccross@android.com
Cc:     selinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20190530080602.GA3600@zhanggen-UX430UQ>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <e92b727a-bf5f-669a-18d8-7518a248c04c@cogentembedded.com>
Date:   Thu, 30 May 2019 12:11:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530080602.GA3600@zhanggen-UX430UQ>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 30.05.2019 11:06, Gen Zhang wrote:

> In selinux_add_mnt_opt(), 'val' is allcoted by kmemdup_nul(). It returns

    Allocated?

> NULL when fails. So 'val' should be checked.
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
[...]

MBR, Sergei
