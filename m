Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D73D3755E6
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbhEFOtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbhEFOtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:49:46 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7E8C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:48:47 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so1081019oto.0
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 07:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fe7jNPFfSsCqGs5oTprFnGolYz7sqrUXv7Jhv2L/+FI=;
        b=X7SjCSmHEvxa9Df0E2xcKxEbUbLo90uiRTfrM6koRM+5UV8sQ1FE8UP1MXosiAUVKz
         s+277uysDu8VyKAGscO+MSouCRdGvJYDu4Btrjf53bqG0qvkx3qxeXF3HXG3eICcwkqE
         rxAJ41cjLGKntgF4xfoswl2KRWujClYaHVhrClAGHaWeqkP+RMp70jRGOU2TOoNV9dcO
         A6g7hT4d9wGbnP+1oRDLYjKTbTQDnGXCDKi8GtfSLsQ6C5BX6iANU0KUbRXdCVVD11nb
         1eMlGWmfdj8YhM8hbiIxGPneHohbd1NXigcXICN9j8/8woq+PM3Zte1gsSQqjJQgIRH4
         OT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fe7jNPFfSsCqGs5oTprFnGolYz7sqrUXv7Jhv2L/+FI=;
        b=B4S6AN6aue+uH0LcRhOCqTzslA7Ngd8F26bX7rv3WzMyIEnUw+9CwN2041EMWFHs1W
         PFu39tWHrjc32ZLKHX192cHiLZ731X++1yMyPhlQQEtGo3Abz7tmLsDsuAv7MTZfYJUf
         5bwELhPf4jbsLhPxvrgByRn+jlkAfUvqJAnrKBS2R477RsbCL1ZkvQJtmVC/vITu3i6K
         67MH74WX0bs4h5FxvI1eHMN7JHl7AzX6M/YBptwFL2WgvTTLDBFjh7vOI58hMy5dXlBZ
         GnfZPWfxUAmqSpLbf5OQsGwZeyUifyN9qGamDw1wqOdPOs7HiCS9M/yrq7RRT0HxfqDq
         nUPw==
X-Gm-Message-State: AOAM532R/I0PFILdHNwhqPvzR0qBCR2pcHDZakNQJIxPOMd8PzSCPmG4
        /MbEbgBSTk5JOh1cRAEorkQ=
X-Google-Smtp-Source: ABdhPJwviF3l55ZDGYvZFApZcqRB30prdquXgbSDzPO6asxNSF0Olse+VOM0o5IFG134F3Nt+ea7Pw==
X-Received: by 2002:a9d:1ac:: with SMTP id e41mr4012524ote.166.1620312526580;
        Thu, 06 May 2021 07:48:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:73:7507:ad79:a013])
        by smtp.googlemail.com with ESMTPSA id r17sm544835oos.39.2021.05.06.07.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 07:48:46 -0700 (PDT)
Subject: Re: [PATCH iproute2 1/2] dcb: fix return value on dcb_cmd_app_show
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <cover.1619886883.git.aclaudi@redhat.com>
 <d2475b23f31e8cb1eb19d51d8bb10866a06a418c.1619886883.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b5c67f0c-1b9f-bdf7-f9e1-1759b276410f@gmail.com>
Date:   Thu, 6 May 2021 08:48:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d2475b23f31e8cb1eb19d51d8bb10866a06a418c.1619886883.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/21 10:39 AM, Andrea Claudi wrote:
> dcb_cmd_app_show() is supposed to return EINVAL if an incorrect argument
> is provided.
> 
> Fixes: 8e9bed1493f5 ("dcb: Add a subtool for the DCB APP object")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  dcb/dcb_app.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

applied both

