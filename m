Return-Path: <netdev+bounces-5077-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E635670F9BA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9297F1C20DAE
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D509019511;
	Wed, 24 May 2023 15:05:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D7C18AE4
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:05:49 +0000 (UTC)
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56095F5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:05:48 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-54f8b7a4feeso363438eaf.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684940747; x=1687532747;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jsXDqOwIthljXpliSBNwW9fUfKgJoKh43UtzFtV9dOU=;
        b=qLup07BqTqy6KbTsvZUZyVtPx3/sc2qHkOeCdXLH2mPxT5WksE/UmyeaXqxs/xZiNr
         Yjzl6miNyUemQI0e+x/SyHr9w0NVy90FIFBMItokZ4WSVbLziRU5a/2A8xMS0EuiNVPw
         6bFh7vRTJ99gZFyUmCAHUtUKlTr/asWIlmR5WZ/xAUUS8P3vBjKpZvkACxnSht4aYnQY
         eoOrC7utzWYU4QGOJtPT7AMJaMDJkWraHlFZUGNyesnxu2OaXvCj6WsH3jcg7PkT3MNr
         /+XtwFQgN3FgfRaFjbuvb1L8XIK+LqJjwl0Yh8TFdmI8Pe+GsP7DH3C8v0yy1PCqYpmq
         1KjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684940747; x=1687532747;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jsXDqOwIthljXpliSBNwW9fUfKgJoKh43UtzFtV9dOU=;
        b=O2qB4SuXsM/rSBEnvog2ModRyFsoa0TETkZjgxsOvxUSBmJ5g9OyHaEEin0deIppP4
         UWCfthE+y1U524d4vr6RFais3j1BHWounb6TMwwJYoJH4HiKM5gW0qX5AO9YbZvEErut
         iHCG7UBSEAsJwx9uBZc/UYJi86ADV9O58RymEBxj5tXbubDFHXW/lL6YCqdO0jy3v2fk
         ZbBKEx6FpjDYj7fm9h6gNRBUiMNcbCcQPaAVCBiJnFpiHQguTd0pWFbN6WuCTKJQD1hm
         AM5MEDxQyNj6VddS9Osw7lZVegMsLvNfUp3nUt034k5Ws/VhGfmVdBPrD0RxE3Q0yRe+
         l2Bg==
X-Gm-Message-State: AC+VfDz4tIniWdICW0wROAo6WwY5LO3KD2hkR/EubtFEN47v/9p88BFP
	rqLK9uaGcxcUdO9UbCfkYhhTKw==
X-Google-Smtp-Source: ACHHUZ5SxBaXmW3shszgya23SMXxWUTnb1BSfAgQZcfVtJPI0Bi6Ve7lvtA1ZzDzTOopnJ+/LM3Xcw==
X-Received: by 2002:a4a:625c:0:b0:555:5ab5:a0e0 with SMTP id y28-20020a4a625c000000b005555ab5a0e0mr3518499oog.8.1684940747668;
        Wed, 24 May 2023 08:05:47 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:522c:f73f:493b:2b5? ([2804:14d:5c5e:44fb:522c:f73f:493b:2b5])
        by smtp.gmail.com with ESMTPSA id z6-20020a056830128600b006a44338c8efsm1856740otp.44.2023.05.24.08.05.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 08:05:47 -0700 (PDT)
Message-ID: <b811578d-bb53-f226-424c-7d2428ffd845@mojatatu.com>
Date: Wed, 24 May 2023 12:05:43 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in
 mini_qdisc_pair_swap
Content-Language: en-US
From: Pedro Tammela <pctammela@mojatatu.com>
To: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
Cc: davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
 jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
 xiyou.wangcong@gmail.com
References: <0000000000006cf87705f79acf1a@google.com>
 <f309f841-3997-93cf-3f30-fa2b06560fc0@mojatatu.com>
In-Reply-To: <f309f841-3997-93cf-3f30-fa2b06560fc0@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

#syz test: https://gitlab.com/tammela/net.git peilin-patches
Let's try with https then...

