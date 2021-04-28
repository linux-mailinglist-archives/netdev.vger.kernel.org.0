Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D6436DBB2
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbhD1PdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhD1PdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:33:08 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1FEC061573
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 08:32:22 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id p6-20020a4adc060000b02901f9a8fc324fso305509oov.10
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 08:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OtRJ2RQQlhB98cige5/FxAcal8ev2iu0kLOtheVkQUU=;
        b=QPck3xpjQzc7cGXahy8+5JIjjPpKZE4FpgskZxaFUJAErAoLs9a7ivz8ZUy4qze8Kv
         V/2VTFY9CWqHprSJNcLaRQp0jXpiJpdtKLIQRKt0ygKYLWg6fRnsn4/mKMgfuUgKvFik
         +eXzGn3ckuH3odw/AN7aQQzTYZAjBPjLiNO/VzEqjP8VcqABd9hWWeujRR09LVy+8dgk
         KXkmkccZaksA86CXl+pzsw4aoJRLYeXDfbrtZkOb81FbMH9ISdhPuTu0pjNWnnWQ+59C
         xgUf3hvGPWHrN0l7LP6N6tiurjUaNJczoCj1WPy23wtA0gQzCkpie+Orw3BkPA76SrU4
         inMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OtRJ2RQQlhB98cige5/FxAcal8ev2iu0kLOtheVkQUU=;
        b=kXELDncfaTFL2hKuewYtUZg20iUizCiOOQ0QOVriXSmxD0urADkLl1vnnsQ6NWd4uj
         FuGa2eIqaPFy75Ex185TMunD80N1qyGpnO74hH/glG8S2/1qjz03Aze8XgJ+43qWWEf7
         Oed/ToJQO9dJU5iaEy3u9m6D+d6MpCELcXLl2FYdCTBqLTJj2SjzXoJHEi7Mg0L+9D9K
         unVSXQ7DJuouEe86ajQBt5f5SAkVPwtiPDLLGDC3ilQyt8BKHTL84KEclNfDN9oeOAih
         o+411itHpoToC6L4Ir9QpwwaIteip4ehkm8x2LbVb3ZlsnYcgA1lBAi5Lav5uzQQ+Ez4
         jWzQ==
X-Gm-Message-State: AOAM532q312i0Oco98FyOF0Cuhgw9tLBq/Iz4hEAbVMxO4/UWXnUO2EY
        ndoaLEULCDPNcqc5jfJ0K7XupEt+rjg=
X-Google-Smtp-Source: ABdhPJz64ATTKyLxpD3L3zuGkRM/LC3k07zzaaNRw5KwXrhlDlpahEruQT8WjYNASlpCem8zJgqWgQ==
X-Received: by 2002:a4a:e386:: with SMTP id l6mr22950650oov.81.1619623941418;
        Wed, 28 Apr 2021 08:32:21 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id n37sm63414otn.9.2021.04.28.08.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 08:32:20 -0700 (PDT)
Subject: Re: [RFC] add extack errors for iptoken
To:     Hongren Zheng <i@zenithal.me>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
References: <YF80x4bBaXpS4s/W@Sun> <20210331204902.78d87b40@hermes.local>
 <YIlbLP5PpaKrE0P2@Sun>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <37c764de-0322-24d8-e185-257658aa47f0@gmail.com>
Date:   Wed, 28 Apr 2021 09:32:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YIlbLP5PpaKrE0P2@Sun>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/21 6:55 AM, Hongren Zheng wrote:
>> Perhaps the following (NOT TESTED) kernel patch will show you how such error messages
>> could be added.
> 
> Since this patch has been tested, and we have waited a long time for
> comments and there is no further response, I wonder if it is the time
> to submit this patch to the kernel.
> 

send the patch
