Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75D5374857
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 21:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhEETBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 15:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhEETBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 15:01:36 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22677C061574;
        Wed,  5 May 2021 12:00:39 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id v6so3853867ljj.5;
        Wed, 05 May 2021 12:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FVvHTCqWtGpl0IGBF8jlGEDIVJKl+y97+gtbqKQlMW0=;
        b=QwjCuTvJb6DtTlpb8Eiuk6IOwzDq55dN+V0c+GJa5LkEHVXp9cCyszJ91JM+34tJZ6
         wodlgMd2WfQosHcag/TpshKoJORfN/D+yv4wTh/N1EbZWIILU8MsDDy7OctADUatMkqJ
         Iw2S3K2yrOLil0RdCMasy+9MlUZRVq5npUlZhDg7NhNXAn2qjXfe2E16wCKIygOtyc1G
         dsNTm3/uPyhRwXj1sQ+Pwe7n8pROHH2C6pEngEcyc2HLUf40jj1KFTRI9kvAFeQIOKql
         mzqSlBPaVoOCMffjKR3yScUm9ErxbxCjQVZVpeIB834Wx+jlB6Xr7uXOPzUQuQfh7K7V
         h85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FVvHTCqWtGpl0IGBF8jlGEDIVJKl+y97+gtbqKQlMW0=;
        b=k6+W7Jr7fWvIyy0yyS7uJsn+UUCILE1FDNGWzLo9PZjGKwB+owBOooHi9O8fge6/Mh
         60d7uqmwCGbmIziYX2zVwUGYqY8nzkTUlUUoOpsJQIhfShMtfpzG/h9LGQG8UY4JNwQ3
         gTUMjszs6dcBZtxOiwTQUwJDGis5dpkPCnpIRbcnnVkEFPZUOtTDWnS6/2eQV7DaSEBk
         hlYjCadIq0DILSZHjaTZ6ictBFC1WEQCEplTjwpT90QBi2kGpXerNqdQkr+5dCiAhzRd
         jC+4kOPhHVu+3BMvvG05NZsg9liv28bQrW6PTxwWjuRLO6vGX38tN3E1jgCLmNE7foOE
         yavA==
X-Gm-Message-State: AOAM531wv0jSAhmxZoMFl2VJPem5J8bn9kV5QJRe13YRbibf9bQQEEV4
        r2Bj42upsQEIRNqumk5aNcTu2Cn+ecs=
X-Google-Smtp-Source: ABdhPJyosmh+LR6mHWaiBkYOJquewtQyCmXRwcXwfJp3mmit7oF8hqah3U2ureTL/pqh2iVVLJZzvA==
X-Received: by 2002:a2e:9648:: with SMTP id z8mr230373ljh.328.1620241237538;
        Wed, 05 May 2021 12:00:37 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.85.20])
        by smtp.gmail.com with ESMTPSA id m11sm21297ljp.36.2021.05.05.12.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 12:00:37 -0700 (PDT)
Subject: Re: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
To:     David Miller <davem@davemloft.net>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
 <161902800958.24373.15370499378110944137.git-patchwork-notify@kernel.org>
 <d5dd135b-241f-6116-466d-8505b7e7d697@gmail.com>
 <20210421.112020.2130812672604395386.davem@davemloft.net>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <c9afe6d8-12e8-32af-4fb0-527f6fd51703@gmail.com>
Date:   Wed, 5 May 2021 22:00:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210421.112020.2130812672604395386.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

   Sorry for the late reply -- the patch got into my spam folder, and I haven't seen it
until this evening. Blame GMail for that.

On 4/21/21 9:20 PM, David Miller wrote:

>>    WTF is this rush?! :-/
>>    I was going to review this patch (it didn't look well to me from th 1s glance)...

> Timely reviews are really important.  If I've inspired you to review more quickly in the future,
> then good. :)

   The the patch hit my mailbox in the morning, and I prepared to post comments once I log in
to the Linux laptop. When I was going to start writing comments, I received your mail saying
that the patch was queued -- that's all within one day... :-/

> Just responding "I will review this don't apply yet." as quickly as you can could avoid
> this in the future.

   OK, I'll try to remember...

> Thanks.

MBR, Sergei
