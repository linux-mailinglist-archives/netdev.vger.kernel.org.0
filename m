Return-Path: <netdev+bounces-11936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1453F73558E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44F751C20AEF
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8197C8E8;
	Mon, 19 Jun 2023 11:14:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD493C8CD
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:14:59 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8B7B9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 04:14:57 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5196a728d90so4592053a12.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 04:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1687173296; x=1689765296;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YYO+FdD02HoQtON3gY3N67r0LjDnfpgEGatkCF/SPuM=;
        b=vmBfiw9NB0m0oRyziSLMIbgVVuWC8KucOqqtglZqMCYjfwBwb2yaY8khBcq+6D8OBR
         MdPMNQKT2L+9alij30NUHbXFPbCgPhaOcYTe0dFD1vf53SG7W+UgBXUVpTUGPLrZwpIj
         ZM4pKV5YC9OgEb/tF4xUDQR+/JwLPY1t7Y+hlyVIhFACLYP2/ETBzG08uoas7Qp6cIJ+
         oKFyiCKC6LhRt3sLbAlB9WHiaPGGCCq4lWfJ+cRmqQVSp5Xb0pU24CfJ8s03Uq5+iBJ9
         w1RtVzQV8cm7xeYE6XGLIk0koOuLmAft1JsU4eCKmu65Pjiumyd5DVaTrBG5CZv8EWCB
         mrHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687173296; x=1689765296;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YYO+FdD02HoQtON3gY3N67r0LjDnfpgEGatkCF/SPuM=;
        b=NtR6MPTVuS0hUcjHgwME2Iv6Upe2qtAhGCjn4S9ghGJbnou/1OP91FpU2GrcyQXuwv
         jXPgl2+RDgm3Q/wsCKwkaK586NR1NoJ4zQAU6Eq0CwWoKW19EwM4tktslZff/cr2YU1B
         kpmDVZADs4OvrdVfRXTCJ+qmPpB6uGKJBKtl3iVhXuXwvWcwlV5jmTNB8O4RAv9dVzpb
         UPd9TWulhezHWRHRrHiH3j5WtOrroKFS0xPF1ItulSZUg0x1eSVSWvJGxsSDJL4xGVUw
         kEItMQ3fma9VMVKyiWwjRm2DPdOaY0bU17i9f257FGq2c4MHfp6hmhym5Vs3pSvtZ+k0
         yzVA==
X-Gm-Message-State: AC+VfDz4kZEs4CcX2l1zO1XNUU95BZ7h4XXZGABnA28Vh7Xsov44lygK
	NujkPnZV+TkwWqSOlII1qcfPPw==
X-Google-Smtp-Source: ACHHUZ6KrZgsHnmsIkFvEKH2MSdqPB9TyfdERyrH3BK4EWJ+r0jnQQb3AE+Pg2hladpawECOYZvXWg==
X-Received: by 2002:a17:907:7f13:b0:988:74eb:b6d8 with SMTP id qf19-20020a1709077f1300b0098874ebb6d8mr3266923ejc.51.1687173296058;
        Mon, 19 Jun 2023 04:14:56 -0700 (PDT)
Received: from [10.44.2.5] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id v12-20020a170906338c00b009887a671017sm2111636eja.179.2023.06.19.04.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 04:14:55 -0700 (PDT)
Message-ID: <7472fb6b-5884-586c-0965-b3bef83109f3@tessares.net>
Date: Mon, 19 Jun 2023 13:14:55 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net-next] mptcp: Reorder fields in 'struct
 mptcp_pm_add_entry'
Content-Language: en-GB
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Mat Martineau <martineau@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 netdev@vger.kernel.org, mptcp@lists.linux.dev
References: <e47b71de54fd3e580544be56fc1bb2985c77b0f4.1687081558.git.christophe.jaillet@wanadoo.fr>
From: Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <e47b71de54fd3e580544be56fc1bb2985c77b0f4.1687081558.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Christophe,

On 18/06/2023 11:46, Christophe JAILLET wrote:
> Group some variables based on their sizes to reduce hole and avoid padding.
> On x86_64, this shrinks the size of 'struct mptcp_pm_add_entry'
> from 136 to 128 bytes.
> 
> It saves a few bytes of memory and is more cache-line friendly.

Good catch and thank you for having shared this patch, it looks good to me!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net

