Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B15C1CCBF4
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 17:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgEJP3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 11:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgEJP3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 11:29:54 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E690CC061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 08:29:53 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id x5so561625ioh.6
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 08:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eprx+aT+rWDuH4XuT3LbKd/fuOw5VGm/22BiyVt0aUQ=;
        b=tE9/xKf0zi0OXeMvHeoFKNrSp2KXCb5v+2TqPf8j6xNgjW/xCwq8cOivkxSwvBWma2
         Hd1lKhshyLwp/I5YVRNJWSSW3WiSUn9tv5AftM8iWftw3R/5b452DHNDzCg3X7rG2OzY
         I2lJaqu3lK36vGAaWy9/nhCyuXM/0u7K4mGvf3r7FxOcq0fKoBZ+Zgj64nk0Caer/98I
         ClTBIE0CQSvAL+ZIywvWY2Ze6TxW6QSH/1joe7DOJNsIlEcz4vp3G3aNkaqpd7kTfog5
         P3Cqf+Sfu29kUnchwlB7v2YhXSOVPP7t5togh0WLXosJde770GRXUih9gZwUQcZbRxsC
         jdmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eprx+aT+rWDuH4XuT3LbKd/fuOw5VGm/22BiyVt0aUQ=;
        b=CjLz1wYmyUF1QG0BP6OAjhoSRuF/oLbPeTyrxieHUV5v30d6L33VSfLtvvDx+WfhQb
         3GwDnrylrNoE/zqTIBl0/GCDoz+4YtTSVqg21usJwNHSpUR/ws15sX1PbDz3ZXyBi5TZ
         vk8CVintOPf6Z27BK6n/1K7M9rXXCGWgKhoIVASIdqIH7PdJ3f3dzVbVcnK1gAqOcMMK
         Bk07SrSLUCM1O+HsK6SCW8/qImUTW7GoqUl+Ip+7SNrpkJP1YRW1PnZkbP0jfiLWDndW
         wxBQnoHkl81/3oqYaX0XeQMIdYRfJJ4V0LAyEYdYbo2TI5QXxSnxmfXhx5T7vjm9aBlN
         yhBg==
X-Gm-Message-State: AGi0Pub0WYg+82AVDZ6C8brcKlqKTh6xYaWWNvrmTwk1x7Fc2mHKWE8M
        hFhwIsMhFJ7whPD1IMv6Lbk+mfjP
X-Google-Smtp-Source: APiQypKov3ain/6WuSwiY4dl6oroHwEj58136v4mLTdfTPB/0RFNDwNd21mEhJP/UjH7mIU1YPpQJA==
X-Received: by 2002:a5d:8615:: with SMTP id f21mr11422576iol.155.1589124592994;
        Sun, 10 May 2020 08:29:52 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f039:2eb:5b70:662e? ([2601:282:803:7700:f039:2eb:5b70:662e])
        by smtp.googlemail.com with ESMTPSA id d23sm3397340ioc.48.2020.05.10.08.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2020 08:29:52 -0700 (PDT)
Subject: Re: [PATCH] net-icmp: make icmp{,v6} (ping) sockets available to all
 by default
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
References: <20200508234223.118254-1-zenczykowski@gmail.com>
 <20200509191536.GA370521@splinter>
 <a4fefa7c-8e8a-6975-aa06-b71ba1885f7b@gmail.com>
 <CANP3RGfr0ziZN9Jg175DD4OULhYtB2g2xFncCqeCnQA9vAYpdA@mail.gmail.com>
 <55a5f7d2-89da-0b6f-3a19-807816574858@gmail.com>
 <CAHo-OozVAnDhMeTfY6mD2d7CFHGnC6dVuMtXaw2qs7NFN6ZPpQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ee76df4f-2a36-a04b-8647-1b809ac21ac6@gmail.com>
Date:   Sun, 10 May 2020 09:29:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAHo-OozVAnDhMeTfY6mD2d7CFHGnC6dVuMtXaw2qs7NFN6ZPpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/20 11:15 PM, Maciej Żenczykowski wrote:
>> Rumors are ugly. If in doubt, ask. LLA with VRF is a primary requirement
>> from the beginning.
> 
> LLA? Link Level Aggregation?

Link Local Address
