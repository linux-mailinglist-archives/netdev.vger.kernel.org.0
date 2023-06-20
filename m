Return-Path: <netdev+bounces-12211-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A390736BE2
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 709301C20C19
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC03D1548C;
	Tue, 20 Jun 2023 12:26:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF6BFC01
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 12:26:13 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F2F170A;
	Tue, 20 Jun 2023 05:26:10 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-666eb03457cso1779513b3a.1;
        Tue, 20 Jun 2023 05:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687263970; x=1689855970;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XMzjdDcWatbWNdORl/WAlXXoG9KE2sOD4/NeGpll6Ck=;
        b=Ml7p19DiZD3pT0kEU2uO1Mu/goUuQAHgi/2wWxr7MaBcsQ8dQesQMuX1yInGohwad/
         m3fCxnvmqtg2vh31Kyd/dq5oqCFPMn82HvRLHJ1yBpTGQno5DvZDr0FSqCFTWopotmCu
         1i3wzlWFiylAeLSeqM+4HGmrVpp3jP5NZlIcYmRr4MT71xz15Vkw5s5fZ4BCnXIVQgJO
         KAaxMoc11boG4n+t3kwdCoLWk8nfbdAP2lNURcKIFwPRoAongUbjhvJJdzDiEPp9dbos
         zTebr1pQkSpBGndNeeINDKIaKMH3Q1coW3UNNL2sxusH1etrmhpaufGP/VkP+YBlJosK
         rObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687263970; x=1689855970;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XMzjdDcWatbWNdORl/WAlXXoG9KE2sOD4/NeGpll6Ck=;
        b=BJjI/LLOmovs9HRlnLrB3bSmpedg1PL9OZB4otdrfvGTcje4cW+bkP3h28l3N++lMa
         liwp8zuVC4j8238MhYv0TEolnBjKEFTgzz0mvl0wjXWZe4dwOve2tNiN60QcccOVnC15
         4BwyGoDV89hBTGWTMo9WlOxAiw1ZfkLueaQ8kwHwY8JRsQI8kLN3B4kWQ0335YTnpXD3
         PSIsKWwsQKZhxhhGoZhp5/2CtmAFZEfADbRHweuaiKDfP01xH1keO+AhpegcLNM2Tstb
         TwmC7ySw8rdAG4EVOUovWACCARG0krYScSNQ8g+Ao0dQWQtSRoMzzMdJEX6EyyHOPuGk
         RX4w==
X-Gm-Message-State: AC+VfDyROFxUNqnyr2t+OeNEj84QWZh9Pxv4SWoYsC30NJkMpuUoA0C/
	Re35SZ9ovH3R5+vLGNmO011L30R+HLSbhQ==
X-Google-Smtp-Source: ACHHUZ7h+AU05ndOleXii7rbNbOSmHtEb7hInHvBQ/nPNlLR7lRc7IunpV+ugkjECtjwRZRFGXnPsA==
X-Received: by 2002:a05:6a20:48a:b0:111:1bd6:270b with SMTP id 10-20020a056a20048a00b001111bd6270bmr6990892pzc.7.1687263970104;
        Tue, 20 Jun 2023 05:26:10 -0700 (PDT)
Received: from [192.168.0.103] ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id c24-20020aa78818000000b00640f588b36dsm1278693pfo.8.2023.06.20.05.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 05:26:09 -0700 (PDT)
Message-ID: <4ce78431-d397-a7a5-cb3d-905c61d47cc4@gmail.com>
Date: Tue, 20 Jun 2023 19:25:50 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: Fwd: iosm: detected field-spanning write for XMM7360
Content-Language: en-US
To: Linux regressions mailing list <regressions@lists.linux.dev>,
 Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Wireless <linux-wireless@vger.kernel.org>,
 Linux Networking <netdev@vger.kernel.org>,
 M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, Florian Klink <flokli@flokli.de>
References: <dbfa25f5-64c8-5574-4f5d-0151ba95d232@gmail.com>
 <0826b484-8bbc-d58f-2caf-7015bd30f827@leemhuis.info>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <0826b484-8bbc-d58f-2caf-7015bd30f827@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/20/23 16:12, Linux regression tracking (Thorsten Leemhuis) wrote:
> On 20.06.23 10:44, Bagas Sanjaya wrote:
>>
>> I notice a regression report on Bugzilla [1]. Quoting from it:
> 
> Bagas, you can't know this, as we didn't have such a sitaution until
> now, so FYI:
> 
> Please don't add "field-spanning write" warnings to the regression
> tracking, that's not worth the trouble (at least for the time beeing).
> Just forward them to Kees, who might look into them if the developer in
> question doesn't care. That was the approach we agreed on here:
> 
> https://lore.kernel.org/all/f1ca3cea-01ae-998a-2aa8-c3e40cf46975@leemhuis.info/
> 

OK, thanks for another tip! I always forgot to double-check everywhere...

-- 
An old man doll... just what I always wanted! - Clara


