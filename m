Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9BE4B2CF9
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352682AbiBKSaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:30:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343586AbiBKSaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:30:15 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4538184
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 10:30:13 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id e17so13679179ljk.5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 10:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:cc:references:subject
         :content-language:from:in-reply-to:content-transfer-encoding;
        bh=Q5mx6lMK1dw3X/W8XKuzwNhGN1FLd4hv3nsJNymhD5o=;
        b=g97BPqxdxYIfo35g2XcTU7a7qlvTjcR40GpgiNl2mTkIZsG4sr3rJPF/d7ntpXIWJk
         HyeDJu2lXpwRR6WdQwxZyjG7TVzpeJVGdsRHfa9+85UxFejpv2DyLkM2f3WR/LVgexni
         bQv68r2fDoLsLlWTP+qkp7k5BYbonIzkPjAyt8wnd9AYxxLHWoBZUtouXkHFcMKY68Wx
         k8t3YKk5q/8anOifZk/Z+5xBIUa6ERzWPd4J+/F8lv5I9KASDDRR3XluZS6UyvMuXpc8
         NFAqqFVnWOKDV7xNdsLp8ygMJrC6opPwOrDv/+cIsyQ1I0phMxl/eUgWd7Eeuw8LCeNq
         EWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to:cc
         :references:subject:content-language:from:in-reply-to
         :content-transfer-encoding;
        bh=Q5mx6lMK1dw3X/W8XKuzwNhGN1FLd4hv3nsJNymhD5o=;
        b=PI95QYIr9Xt7e+cGIqgaIi36x53uagl76L46xGJkf1SxxiNDwWmt5KJyqeTDOOTLI8
         KxfrZW4v5+WObpBZ2wlDrGVbfoZUI7VootBZWqFurZ/eSs/AEs8y6LmjwVwufiQyTL0I
         HJUw0QNsODgJBKBea6BTx90ChyshDrAIdS+yvF3ZzWTPVOQeP2vhBAQkBt943BCX1IHG
         ImBZKBu/LqCCdNC5PLAgvQgqVD+A1gtV//i9x1UXNiq9PiEVjEmJdW3FQFtom1Fqh7kl
         hdBmOZ245SENgR7NaYB8u0osV/vejZLnQ0JuqfCD9zcUExi2jp8dOVC/FnLiP7eWhgla
         RVPA==
X-Gm-Message-State: AOAM530frfEuNHYjlP40nDt5HznU5QB+QoiakkNOJPuD5u8YN2K+/O9r
        I4adOlychq19qpP7s03OGWFe+pHR3lI=
X-Google-Smtp-Source: ABdhPJx+uowB5BPh+J/crH9ZnvsZlZ6cfDe7G95Bfu3X1L0Mly/UlWGMhzJ5V5994AhLLIcDAD0SQg==
X-Received: by 2002:a2e:bf0f:: with SMTP id c15mr1760738ljr.408.1644604212192;
        Fri, 11 Feb 2022 10:30:12 -0800 (PST)
Received: from [192.168.88.200] (pppoe.178-66-239-7.dynamic.avangarddsl.ru. [178.66.239.7])
        by smtp.gmail.com with ESMTPSA id z20sm3280290ljn.92.2022.02.11.10.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 10:30:11 -0800 (PST)
Message-ID: <8da15fe8-92be-ee9c-0c45-1a4af38fc9bd@gmail.com>
Date:   Fri, 11 Feb 2022 21:30:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <20220210171903.66f35b6c@hermes.local>
Subject: Re: [PATCH iproute2] libnetlink: fix socket leak in
 rtnl_open_byproto()
Content-Language: en-US
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
In-Reply-To: <20220210171903.66f35b6c@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Stephen!

On 2022-02-11 01:19 UTC, Stephen Hemminger wrote:
> +	} else {
> +		rth->seq = time(NULL);
> +		return 0;
>  	}

For me it looks slightly alien as the normal flow jumps from one 'else if' to
another, and the final return statement is hidden inside the else block. The
original version is straightforward and less surprising.

> Can do the same thing without introducing a goto
But what's wrong with the goto here? I thought it is a perfectly legal C way to
handle errors, and iproute2 uses it for that purpose almost everywhere.
