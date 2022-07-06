Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497FD567B9D
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiGFBoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGFBoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:44:00 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203D8A471;
        Tue,  5 Jul 2022 18:44:00 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id p128so12800965iof.1;
        Tue, 05 Jul 2022 18:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9M+eP8kZKrYzfAAuegT2HypltPw65L06W86icoY0R3A=;
        b=E+O6eYpDENEiZDGw2MCgh5roJjO5vL5MaF+OMHlD2thS9YGxwQcugwvKvFeJi+ylu8
         4uG1os++6YEwv8wFHLlKDeVe+3u9pwvMMzIAQejN9WUgsOf/NoFFyALhGNqfSV6Uvk0h
         dd4TApngiw0pvgmDZQMXo5TnW68iGAANH4O9RM5uNaOGRNV6Hcm6QDzcYvjy3qaAV0fy
         8Dz2dknv0LfIAEqYe2Isalv4cVeCA9bAGvN1ozAJsDUXs2WnPAaUj7C4ul08uVqaDSOB
         NuO9yIP4fEFgFOojqeDZfaVZfa4E7TJGxF6uqIbANgjVZEI180zV95hae19VbrAkHV75
         9seA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9M+eP8kZKrYzfAAuegT2HypltPw65L06W86icoY0R3A=;
        b=eHTALOtw3EondYDsDHsmqByrXMAqro5k44rf3qEtZBq42mWi4umIfsX21E49jxAXUd
         EmDzWUOMnA03Jhw120B9Azc6QSONSQQWhzyyGrDGCXOjTn13q07iNPOMU4uGNt5aumNx
         69BuNeuLPpksP+MindJLvlxUoVomYimTgAAd7fq9Uu1za7XWx9xqTo/mPt/BTw++xpAN
         I5Ecttffowpc6hKOmmmkCm5CrPKALUFDxOglmguXindzjzX4CR7B8WB+30q75Vr56ENe
         1uhc1PiPMUC8+XOGKdYWfxVSCjuiWE74Wf4TG1mTorh01D+luHXlcLq98rQ3Hkgayetw
         mNDw==
X-Gm-Message-State: AJIora8ACq0ey4K9JjRyfRupwtYA2p6AUvFwWnjVNpy6eJ382rNpaNN9
        ExrPPXkx+AHU+ElQKhqHCLY0LmULkhA=
X-Google-Smtp-Source: AGRyM1uENejtTd6rMYqMq9k5aDEY84ONBnwplfH7iccm9wmHN1kqfPp1hFw5ge/owP6Rqmu82T+WLw==
X-Received: by 2002:a05:6602:4:b0:674:2761:fd0e with SMTP id b4-20020a056602000400b006742761fd0emr20412149ioa.75.1657071839570;
        Tue, 05 Jul 2022 18:43:59 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:341e:8c4d:12df:40ce? ([2601:282:800:dc80:341e:8c4d:12df:40ce])
        by smtp.googlemail.com with ESMTPSA id x11-20020a0566380cab00b00335c432c4b9sm15287399jad.136.2022.07.05.18.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 18:43:59 -0700 (PDT)
Message-ID: <8eef927e-27e0-83d0-24a2-20732608788e@gmail.com>
Date:   Tue, 5 Jul 2022 19:43:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] neighbor: tracing: Have neigh_create event use __string()
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20220705183741.35387e3f@rorschach.local.home>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220705183741.35387e3f@rorschach.local.home>
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

On 7/5/22 4:37 PM, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The dev field of the neigh_create event uses __dynamic_array() with a
> fixed size, which defeats the purpose of __dynamic_array(). Looking at the
> logic, as it already uses __assign_str(), just use the same logic in
> __string to create the size needed. It appears that because "dev" can be
> NULL, it needs the check. But __string() can have the same checks as
> __assign_str() so use them there too.
> 
> Cc: David Ahern <dsahern@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> 
> [ This is simpler logic than the fib* events, so I figured just
>   convert to __string() instead of a static __array() ]
> 

agreed.

Reviewed-by: David Ahern <dsahern@kernel.org>

