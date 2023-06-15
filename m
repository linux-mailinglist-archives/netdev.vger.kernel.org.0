Return-Path: <netdev+bounces-11236-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEF8732183
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 23:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FBC21C20EA5
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A203916403;
	Thu, 15 Jun 2023 21:21:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966E82E0D4
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 21:21:20 +0000 (UTC)
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B931D2961;
	Thu, 15 Jun 2023 14:21:18 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2b1afe57bdfso36418701fa.0;
        Thu, 15 Jun 2023 14:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686864077; x=1689456077;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3xCwMrwUYV0R9yAFqVUBdbC5I8DxDmvwIMXupacMoGo=;
        b=UPr8UAQZRXuQf/vFSnZAFHMamlJVol/qnVdpXnK5wB1dUr7oK4oX9aVKDivtXhR3pR
         AIgZsJ09Tj4vIZ8XfzkmPLYPGs5vqW4sXGMKAG7iAGAJLq5p8JiT4Wdtr5Wuu7VTDWGK
         Svd8QfmnTG3ya/GnvHVqqXNGBo6kItYKACzjYPX1OULvaqSgttsUxJ5ccpjNRbL19wWL
         plSQZosJdWZ6x7w6VJSP0qPWM5vz/FCSbW81YZsSTQH3r9V2VHcxwv7FXipKWonsyt/Y
         +z6o7Uzt+H8KqlQtqZZV7Ots0D4o6vKDDo8Gb9gg+Uu6/+UWD3fnyiFkuI9pjK6xrqv4
         Gikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686864077; x=1689456077;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3xCwMrwUYV0R9yAFqVUBdbC5I8DxDmvwIMXupacMoGo=;
        b=AjCJT4nsn/re0lDzFdXaJJR8JUa1s9uZitZopsBdeyfLpLymibpf0E+BErgPCxINRP
         LP24QEojuGhgHFEyMFTe5qPCYoJkDqVeMEspFytTh8EfYKagj58PtcQOxPcq6IcmWtgO
         TCgvaorzjR94+L7p1FpoVLMg97MN163ZD6kCNiwbbEgpKSZNXKeH0l2Jnom5VW+uQ7UJ
         jgXdxnfklx60+yihLCQYPjuzbRdlAWYj/su56LJb9pos0iM4n6Bw7jCK/tJR+uCPgCav
         4QQoHrjUxoSaDQeukt4HTsEOfLO63MC2hT3sxVACaHosTSmZnHl/KRooeBCClsq4b1QQ
         OF6g==
X-Gm-Message-State: AC+VfDwUhsjv4XvNO1k7ozqVhFWrKqMTBotqpicUUDvuAx2vjBaPcYme
	iPyiLLOMui6d+n5QE0nu+Vg=
X-Google-Smtp-Source: ACHHUZ4h9P8mkpjeXtFSFF48bkvut00rmeYPaS2rRza2Sz26sHrAYleBu63MSN9bjndgZq6MIoAqjw==
X-Received: by 2002:a2e:9d47:0:b0:2b1:b9b9:20d4 with SMTP id y7-20020a2e9d47000000b002b1b9b920d4mr373520ljj.5.1686864076727;
        Thu, 15 Jun 2023 14:21:16 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id hn10-20020a05600ca38a00b003f60eb72cf5sm300263wmb.2.2023.06.15.14.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 14:21:16 -0700 (PDT)
Subject: Re: powerpc: ERROR: modpost: "efx_tc_netevent_event"
 [drivers/net/ethernet/sfc/sfc.ko] undefined!
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Linux-Next Mailing List <linux-next@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
 lkft-triage@lists.linaro.org
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Anders Roxell <anders.roxell@linaro.org>,
 habetsm.xilinx@gmail.com
References: <CA+G9fYsAvbqVr+W4=17sxwguGSQi6cU+9WZ_YQzg3Wj96e70uQ@mail.gmail.com>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <07503ee4-591c-17ba-6e56-91e5b3047c16@gmail.com>
Date: Thu, 15 Jun 2023 22:21:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CA+G9fYsAvbqVr+W4=17sxwguGSQi6cU+9WZ_YQzg3Wj96e70uQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15/06/2023 14:57, Naresh Kamboju wrote:
> Following build regressions noticed on Linux next-20230615.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Regressions found on powerpc:
> 
>  - build/gcc-8-ppc6xx_defconfig
>  - build/gcc-12-ppc6xx_defconfig
> 
> 
> buid log:
> ====
>    ERROR: modpost: "efx_tc_netevent_event"
> [drivers/net/ethernet/sfc/sfc.ko] undefined!
>    ERROR: modpost: "efx_tc_netdev_event"
> [drivers/net/ethernet/sfc/sfc.ko] undefined!
>    make[2]: *** [/builds/linux/scripts/Makefile.modpost:137:
> Module.symvers] Error 1

Known issue with CONFIG_SFC=[ym] and CONFIG_SFC_SRIOV=n.
Fix already under way; v1 [1] had changes requested, v2 coming soon.
But thank you for testing.  I'll cc you on v2 in case you want to test the fix.
-ed

[1]: https://lore.kernel.org/all/20230612205428.1780-1-edward.cree@amd.com/

