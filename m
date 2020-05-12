Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12741CFDC6
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgELSur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgELSuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 14:50:46 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4F6C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 11:50:46 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g11so2529384plp.1
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 11:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mS+HTmCcgSIxBen7sxET3lCRZ1AYwQapWrIDi2EmSbU=;
        b=EdmKT/bqyax0K9NtMAwusIyxR1uYKjeBs4HER+7YL1HTFDBv/CnXp1kNszE7vZBvb2
         hZrr8FCoS44Bs0lp5XvmX3j2BGiW2u6ugUZhvz14CzodpaCpLd8mw07OLStrNK7UYBLY
         ZUaC4ZPMuc9unlCLC8l1cxYKteMex6Ot8jl+zByH0WUw6ku18lo93CG62HEDhxI8Ccf8
         dk2Wwcc0Jv7y2Zw3l64ExhXZ9iXxeXA7E3AqJYzJIDxdJzCNT7z2QjCBsBsBmU6SqQ+G
         HafmJEVLGz12/VguYZqIwdtZfCepVoxmBnCeGxOfYq570xPzz/hHa2xxFtVI8Zuhgvgh
         hwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mS+HTmCcgSIxBen7sxET3lCRZ1AYwQapWrIDi2EmSbU=;
        b=DATlFJkAopni5/y1JvwUqSmqKKIjunpMwZaq+QayCKXr8D7w4Fl1PyoWZ2xRKGCN9+
         RN/kI7SKp5ER+10MjlaZJWbqzFrkBp3WB+6mWRF8WvJNZrtFfZXn1rVBfK0Vg9J8zJlS
         KRAN/ESl2y7bRYzA+DcF9a6+N8eEVTSSnMIVSKIIdCrzw23yE37X22N0g6XIOaKhMwkX
         Gnm5bs7Ls5yT9sJWk5UWdxtLeMeMxfe1Wp7Ai+Cgdb6pD/W0gVJXJux2YFpdIErwMFhc
         2eUqSfHkw9myWPjxRR1fWXWQXCizcMHDXNyMlfmNgFGDxCsj4GR2OGzoybBFMfv27bkb
         Ja0g==
X-Gm-Message-State: AGi0Puagbnh72J0qLOtF1rTL2XByzzjnoNPyhJ9VdC4zRaJXgcTUKHp9
        wSKTGofV7BuYyjnfGAty3Ks=
X-Google-Smtp-Source: APiQypIQOOyZvoKIbkeazrdxLlOdxUFXG9/jHcAQX8xzsppPSf0hzln/E4UbzfOKy6xnP9jQSREgzA==
X-Received: by 2002:a17:90a:d0c3:: with SMTP id y3mr29537774pjw.25.1589309446064;
        Tue, 12 May 2020 11:50:46 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x132sm12727065pfc.57.2020.05.12.11.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 11:50:45 -0700 (PDT)
Subject: Re: [PATCH net-next] erspan: Check IFLA_GRE_ERSPAN_VER is set.
To:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>
References: <1589304983-100626-1-git-send-email-u9012063@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <df351c5c-9c51-05aa-f484-c32e5e7ba47e@gmail.com>
Date:   Tue, 12 May 2020 11:50:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1589304983-100626-1-git-send-email-u9012063@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 10:36 AM, William Tu wrote:
> Add a check to make sure the IFLA_GRE_ERSPAN_VER is provided by users.
> 
> Fixes: f989d546a2d5 ("erspan: Add type I version 0 support.")
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: William Tu <u9012063@gmail.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.

