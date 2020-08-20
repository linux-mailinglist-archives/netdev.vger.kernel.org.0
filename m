Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B576324BB9D
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 14:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgHTMbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 08:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730103AbgHTMbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 08:31:32 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A472C061385;
        Thu, 20 Aug 2020 05:31:32 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v12so1857046ljc.10;
        Thu, 20 Aug 2020 05:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sLaFDqmhBKvCa66SIGjGPAggYoHsxbTGhHXTzFaeO7I=;
        b=RljuvLmGHRDuQE1e9PkIln2c5TnJO/Q3bCV+HDJ3ERWcd5eu5GWH8U8447eR+Q6UKN
         NE5OiBZgS5s35Mrm8r57nkzmMONIEQNV4wDJGyW+zzOHUr1/Go5eZ9pkW/0nZkHbtjxj
         OhED3iBZDaRsu7yaihnMLUSLcgTeJvrtYWJzYIFoQQtDH90ihQ1NeM7CtN9Em7OxuXIN
         jC9Hyh8b25NKF4+MKzbxxSr8vpWFdYH+R02jxcrsTtJpXV4K03Dh4BDaXbEEPDwsIvCx
         HsqqEmkyAuKsNOJmJdQ8WzxCOc7lU8ogbGogN4vGUE8xMhOHy57wypnssPMdP1ldDlD8
         d3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sLaFDqmhBKvCa66SIGjGPAggYoHsxbTGhHXTzFaeO7I=;
        b=pQEf9UVtefVUcYmIRs4t9sxZ+CNlm2/GQiBgMTFCUt1ac6XGvB1xqCswI3Sum+5naD
         RLbnKe7Q56r44xtnmWNpQ7/dxSiWkIBLpvXsk9H7EWpPvHX84sxhcyavtVG1t82L3NH9
         wEY6NEvJGAnHz51/qltpWQdWvwUj+/xkC51KBQAbBXaDNE2VaoRkyg480nizGOHWyQrJ
         IE8wdILKlKTXN7w3sv3cJ2D0noloA3SDRyPSs3tTj5zCgCQ25J9pk2EOeFhgnP9/mJO4
         +fRRU5EhATpRsewC0WWJHwFaTyo1m8+OzLDRgU5/LKF5vUaim18IAx24QsqW2meGaiy2
         s4vg==
X-Gm-Message-State: AOAM533gEs0zMeeA4DKe3RU0qMU6nTbk5Eiby9HAG2yWnqmuU5G6//27
        0yBUuFQ4q91JDZaLO6SkjeAfTza03ubMwA==
X-Google-Smtp-Source: ABdhPJwtTloWdfwP67KjGtYImwnrwLGmvfiVdtdTgpJ7Hs/0RAHkHZhjbJGS3dfCWQwB0iE/od+SpQ==
X-Received: by 2002:a2e:8215:: with SMTP id w21mr1493576ljg.43.1597926690796;
        Thu, 20 Aug 2020 05:31:30 -0700 (PDT)
Received: from wasted.omprussia.ru ([2a00:1fa0:46d7:4a60:acca:c7f9:9bba:62e5])
        by smtp.gmail.com with ESMTPSA id b16sm430034ljk.24.2020.08.20.05.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 05:31:30 -0700 (PDT)
Subject: Re: [PATCH v3] ravb: Fixed to be able to unload modules
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20200820094307.3977-1-ashiduka@fujitsu.com>
 <f5cf5e82-cc35-4141-982a-7abc4794e789@gmail.com>
Message-ID: <bd5d2d20-eeb0-12fb-4e25-c596f0ff5898@gmail.com>
Date:   Thu, 20 Aug 2020 15:31:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <f5cf5e82-cc35-4141-982a-7abc4794e789@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/20 3:29 PM, Sergei Shtylyov wrote:

>    Also, s/Fixed/fix/ in the subject. Nearly missed it. :-)

   And overall, I'd call the patch "ravb: fix module unloading".

MBR, Sergei
