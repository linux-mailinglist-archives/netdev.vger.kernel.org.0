Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8135F6E94
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 22:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiJFUEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 16:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJFUEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 16:04:30 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25E7B1BBC;
        Thu,  6 Oct 2022 13:04:29 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s2so4389419edd.2;
        Thu, 06 Oct 2022 13:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CbX17zyeqGpxUhDbllE/IZ5gcvd2y3iJ70NgCSA4d7c=;
        b=efDHX24d11Gqby8OWWO15PesJdSkhVFkd4WvzA0cZFc019I84BuRFaKtLiT/J8c2NG
         y5CgggOjngsVGwGFG2hY6GeCrz3CDi4m7Eq3fmIoVn0isLAPm+LrcRllfemjUiEJv0aa
         zl5dhGPT0Yic3YuW4CQPKIfDgGGWr18QORK9f94jpr75/3OQX3I5VFfY3pB1KwzQ2Rut
         3OBwGjK9vPP5iTOuC9wsPjEczTwzCxq6yCrmDF7q0e6j3aBPxuPgGMYrUSuwl4Yg61nM
         GgHI1uvfYQbQuRgwjJKMAOZlgdP3/srZ12gXkRvAnl42PbmEilB3BAXyF4p/1PSMejqu
         9Mtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CbX17zyeqGpxUhDbllE/IZ5gcvd2y3iJ70NgCSA4d7c=;
        b=bcemAw1HS5EJVahVdKpv4b5FNsDWICQ5/bgfIA6w1+0xngSzWgmA4GxA9tYCh+b+hn
         1Yb4ZWKBmXmwEmQqUIh9aDlZWLXpIWWDc3nV+yIL1bBtvpQzEfiWZcD+nYw/AxKuQOJL
         lEGahO7hU7ucEt02Ljv3jhMQ2gWMNKhpITHeA6m2kNm1y908Fn3p1oMS6lFTf460ACXf
         g36cnrSeWAFpWC98Igx7dpq3bzhQdLt+eG098w7rdDBbb27a/b9ea1hq38ekK0LLwBX+
         HbMPTiqdxtRT21ZiyfTuVEKVHMa6PSHpzM39yK7+6ylp6MxCKemfTTItdnKShrBX9wXE
         joeg==
X-Gm-Message-State: ACrzQf0QzJBhwjjXWm+eh1mo+yv+B5jW+3RszSvkfQCqkh0qFsvMPUvR
        eKJMVk2rQArzlgMjE5JbOmo=
X-Google-Smtp-Source: AMsMyM7KdH9xZap62bO609qHFz5E7/TCeFx+TM/MTjShbd1eB8/e6hDULf2DbdD9dqoPXqLbwHi+dw==
X-Received: by 2002:a05:6402:40d3:b0:451:5249:d516 with SMTP id z19-20020a05640240d300b004515249d516mr1438097edb.154.1665086668149;
        Thu, 06 Oct 2022 13:04:28 -0700 (PDT)
Received: from debian64.daheim (p5b0d7ff5.dip0.t-ipconnect.de. [91.13.127.245])
        by smtp.gmail.com with ESMTPSA id qt4-20020a170906ece400b00773f3cb67ffsm175447ejb.28.2022.10.06.13.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 13:04:27 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1ogVDd-000RBz-0u;
        Thu, 06 Oct 2022 22:04:26 +0200
Message-ID: <a859515d-8c6d-3757-a4cc-1fe5c8360908@gmail.com>
Date:   Thu, 6 Oct 2022 22:04:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] wifi: carl9170: Remove -Warray-bounds exception
Content-Language: de-DE
To:     Kees Cook <keescook@chromium.org>,
        Christian Lamparter <chunkeey@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20221006192051.1742930-1-keescook@chromium.org>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20221006192051.1742930-1-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/10/2022 21:20, Kees Cook wrote:
> GCC-12 emits false positive -Warray-bounds warnings with
> CONFIG_UBSAN_SHIFT (-fsanitize=shift). This is fixed in GCC 13[1],
> and there is top-level Makefile logic to remove -Warray-bounds for
> known-bad GCC versions staring with commit f0be87c42cbd ("gcc-12: disable
> '-Warray-bounds' universally for now").
> 
> Remove the local work-around.
> 
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105679
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Lamparter <chunkeey@gmail.com>

