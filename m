Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB1F3D4B04
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 04:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhGYBw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 21:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhGYBw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 21:52:26 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE44C061757
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 19:32:56 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso14708751pjb.1
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 19:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=GFuldiW40zEi5LRcfrN8kb6ZBFJu+WhYPmIUDDyGsio=;
        b=m3s4Ocwn10EeH1/34LgcH2PeRhP8PiQX7V3Sp3Kkuan0xULSPk+YkhsZIY2SHzJAQR
         Vc+o2sO7NKE2IbC19UUWQBF1+R3XRGdLNorCNlPonX4oVrJ/EvfsEwPNvljZ4Wsk8D7e
         BqlNqpjHhkpK8ZENkWDhZxx6qjLaAucdpdoPV9R3Dt7667sg19cmTGGRyZVEbfuxqZZH
         7Gg6BBzfATjZb6VjIVOPEmVggml0ngsfrPKgazILhrgLw/SzZ1/HYLp+4GKi3RoDiF5R
         jwcg5Qp6KK8+1BDCSNO9gMIc+2QucIAuErlKeTUfHeLgTsIL37T13zJ7meO3xEpQI+Zz
         +Dng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GFuldiW40zEi5LRcfrN8kb6ZBFJu+WhYPmIUDDyGsio=;
        b=UEy49zNtDd+76fAkXhb8Yq+97VMIMYiri4AYiIQVJlEWtFe+aZXzArRKhimGCVcKrs
         HwEom7X+UdL6E40/faCEqM+bkoAHoSLenOCX5O+Z487lVFJujyTNVpBHTB9dokpEIIsK
         atcxz0NjMtGrvrx55HtjosrgbTDB2zpGVjQMSV0afhObBCSVk/R7MczA2o4SY3rZiyEJ
         +odmlsNw2wn5B0M1NeLAFPs+Ja9uU2VpuFkQzaWl5QVTESLUxvCiQPmW1sr31mGKhsvc
         WUxa7n9banMKXB1yhDZV2gixSgMv37RrMlE87OJsTxK/Mb1NbI3ir13fpEoYVdOAzPCT
         gY9g==
X-Gm-Message-State: AOAM531lFVNzQg0mT52MYsXtBYtfT6IskAMO/5RZNR9FG2zc6UXhe8zo
        I6GqiYuKlQpm0erTYTz+LUNobu6WX6ps7Q==
X-Google-Smtp-Source: ABdhPJxAdjUBWXH7iWQpIm2MbxTzmKIMvOkJQlEnsmjswprvjEX+IU4ed7IrZMCrVYnugiqyBblkkw==
X-Received: by 2002:a17:90a:420c:: with SMTP id o12mr11047578pjg.101.1627180375696;
        Sat, 24 Jul 2021 19:32:55 -0700 (PDT)
Received: from ?IPv6:2601:647:4f00:3770:a0fe:7ef:f661:cc96? ([2601:647:4f00:3770:a0fe:7ef:f661:cc96])
        by smtp.gmail.com with ESMTPSA id s19sm1240399pju.21.2021.07.24.19.32.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jul 2021 19:32:55 -0700 (PDT)
Subject: Re: question about configuring multiple interfaces on a host within
 the same ipv6 sub-net
From:   hui wang <huiwangforfbjob@gmail.com>
To:     netdev@vger.kernel.org
References: <20210724010117.GA633665@minyard.net>
 <91bce7da-163d-dee3-5309-ebcf27de1abb@gmail.com>
 <25484f7d-e058-0976-5e93-30a8cf7aaf99@gmail.com>
Message-ID: <2abd4f99-02d7-1415-aeb3-bca3e3b7be84@gmail.com>
Date:   Sat, 24 Jul 2021 19:32:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <25484f7d-e058-0976-5e93-30a8cf7aaf99@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/21 11:15 PM, hui wang wrote:
> Hi All
>
> I have an host (running centos8), it has multiple interfaces 
> connecting to the same IPv6 sub-net. Different IPv6 addresses are 
> statically assigned to these interfaces. All these interfaces are 
> assigned with the same gateway address.
>
> I'd like to config the routing policy so that:
>
>     All packets with source IP address specified goes out via the 
> interface where the source IP address was assigned to.
>     When source IP address is not specified by application. (ex. TCP 
> sync packet)

when connect() called without binding to an ip address

> , different interfaces' IP address is picked (as source IP address) 
> randomly (if the destination IP address is different).
>
> How do I config routing policy to achieve these in such an environment.
>
> Please let me know if there are more appropriate mail lists for my 
> question.
>
> Thanks,
>
> Hui
>

