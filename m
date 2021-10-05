Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0E3422B40
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhJEOky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbhJEOkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 10:40:53 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446C7C06174E
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 07:39:03 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id n63so1188837oif.7
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 07:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lXEZl61p3YP6BUzkTvBp3K8ieedWxYJW4wQES1XWMKU=;
        b=FJdhyek91PEjWvO7Hj8fb+6AqXPXHJNs3xlFZFqt0KP7xJTSpBhooD+5Zc21nZ+lo7
         BD3T0HYSUkADZueQTtDLjNwtSQIM0pDWdSSIaFLwYWeB7TwCFngtgge0B+JdONBJz2Yl
         CwuADTp8JC2lklwO1FoOEUraFY4Q6YF3RSMfo6Yjrs8q3zJTvzuQAZSX8Rlrml19k+qD
         zVMOOqYqFBRwY11feuSzpeHyiy3pDwEEpNhBxlTf+BnO7yfeSx4ijed2BI6Zc3IfbaYs
         MwAHZxfUBxhv/+wyEUlf3ZKWozZPCgxyyXf3sMPlGH0rAwdlcRiygJdHPF3lxBE+Mmkk
         uVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lXEZl61p3YP6BUzkTvBp3K8ieedWxYJW4wQES1XWMKU=;
        b=Pmze35HfdtL22P0ChgRzhaR4zWL7hJXPYmTIsFykV7VMlQeOcsr4Lyq+Dht6iLLqtH
         vbqs688DsCFnKTEiOp1ir1IirIdoXKSawrzGPRckVgJBRl04SzijEbu5E6QbtYfS8F+y
         hM3tQj8lRz3s+53Px8kUZaf9pqZg8tMi1EAKlAD2OwQ7hrwm9V1N7p/DQ1NPYrrCdbTP
         PRdPGiSVaRY/6oMjxVLl63+ZkPLrNySdbd8nMnW5yJQzpfOU2qZgM4SNVNOjMsH9TfKv
         GMpqwTi1E+AKuYIQsnrsssQ78FugVVRPwNZsf+OZZJQbCdKNVf/5YcLA3Yp/b9Fh8lLw
         Fr0A==
X-Gm-Message-State: AOAM532scxRDfQJ82w9uflbudC3GB2z2g1D2c+PsNCyJFFgpqvjFgf+7
        lzGzY9Zs7DJsBOk/134KkaxTtMWx7f53ZA==
X-Google-Smtp-Source: ABdhPJz+GrNSbZkcfzPEhPNduZRiiJMEeDp2/5IkNi9/vrEWHi1nvOlneiaygnqbMhbQagKGsCyoqA==
X-Received: by 2002:a05:6808:1823:: with SMTP id bh35mr2932937oib.53.1633444742714;
        Tue, 05 Oct 2021 07:39:02 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id l25sm3509118ooh.22.2021.10.05.07.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 07:39:02 -0700 (PDT)
Subject: Re: [iproute2-next] devlink: print maximum number of snapshots if
 available
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>
References: <20210930212050.1673896-1-jacob.e.keller@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fc0d89a5-7ffe-e8a4-e7c0-7694eece400d@gmail.com>
Date:   Tue, 5 Oct 2021 08:39:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210930212050.1673896-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 3:20 PM, Jacob Keller wrote:
> Recently the kernel gained ability to report the maximum number of
> snapshots a region can have. Print this value out if it was reported.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> 
> This requires updating the UAPI headers to the commit which includes the
> DEVLINK_ATTR_REGION_MAX_SNAPSHOTS attribute.
> 
>  devlink/devlink.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

applied to iproute2-next

