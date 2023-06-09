Return-Path: <netdev+bounces-9652-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D1972A1DF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:13:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D9191C21121
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2AC02099F;
	Fri,  9 Jun 2023 18:13:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D0F1B915
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:13:47 +0000 (UTC)
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0593588
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 11:13:46 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1a28817f70bso955760fac.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 11:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686334424; x=1688926424;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UybNSMgxEjqDNVnj9hGHui9qhqseq3NiqSAuuhUbEUc=;
        b=nyscvgaM5G/rpOKladAAnLK6HSNwNCi2OA6Kwl8UmVEOtvfvrUpVhW5h6ufGEM3Ptm
         JWPng8jUfa/Y6vva0DV0NJoBYsHoCXQ+AJNfoIUljUDKf7hvyy+zYYf4drGvAe6FGNHp
         iN/cnQ4x0hIqOq6Guag6B8WNVUc+fdPO71FbsJhc/sJ3+Qfm9aT5YncNC0imsDQa/td7
         9LElSI6f+WB6hL2RHJlUebh5IJkLi5ERKs1MLpHWfJ7sM+U2RzDXO68gybo150udMvTy
         9hgSzbcURWga/oU+Z40dUZGlLPpYKV1kGZ44v1Y+0W7e+fYqug9X4d8Zq2EyTGm7kews
         S0AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686334424; x=1688926424;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UybNSMgxEjqDNVnj9hGHui9qhqseq3NiqSAuuhUbEUc=;
        b=N8FzBCDbRYxSMCLvpHIZo8lHYOycyFoSFPLTYkYXvx+d41YDMTHoARC6ymqtDcQxIA
         u7c0mG6qjYCqEXSEerw54JTxK/7NbU/jYynFhRqll7YHe9U5usuz5701Aiis0/W0c1a6
         Rb/0dHaU6R9B7yBaNmNpqle6vADDaiuGoG5YaOV99jPRCxurtixZJ1DuKQT8OLf43Gyr
         3g5bsCwkjwfpKJaTQFr6rRZmrzGSk9axiZp0b8AqNmfjhOqN3x2YX8nbDI4pMjmVIQaW
         5eyC99gjurwCjPgpNhkkQe/muPvTWgxpdqbwUVnae0QwC81QiuPbDzXlC+PhCqIpvyVJ
         J4fQ==
X-Gm-Message-State: AC+VfDxMd1og2A7MzXtB25lZIljZUfl+1XGATysFYQorCl2+wppD38LS
	QY9nkkO0UjWJNy71oDwiHH9xNw==
X-Google-Smtp-Source: ACHHUZ6EH0Wma+ktt2yzfIZiAmyROImhW4M7NB1eNsy1Iuv3Z7ztmC+NL0APf7L6muhc85nCLmJqHA==
X-Received: by 2002:a05:6870:e282:b0:19f:5c37:ab9d with SMTP id v2-20020a056870e28200b0019f5c37ab9dmr1989292oad.43.1686334424425;
        Fri, 09 Jun 2023 11:13:44 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:643a:b27d:4a69:3b94? ([2804:14d:5c5e:44fb:643a:b27d:4a69:3b94])
        by smtp.gmail.com with ESMTPSA id v23-20020a056870311700b0019ea8771fb0sm2499977oaa.13.2023.06.09.11.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 11:13:44 -0700 (PDT)
Message-ID: <41d16737-6bdc-2def-402d-04d69127faf9@mojatatu.com>
Date: Fri, 9 Jun 2023 15:13:40 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH net-next 0/4] rhashtable: length helper for rhashtable
 and rhltable
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, tgraf@suug.ch, herbert@gondor.apana.org.au,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 pabeni@redhat.com
References: <20230609151332.263152-1-pctammela@mojatatu.com>
 <20230609103644.7bdd3873@kernel.org>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230609103644.7bdd3873@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09/06/2023 14:36, Jakub Kicinski wrote:
> On Fri,  9 Jun 2023 12:13:28 -0300 Pedro Tammela wrote:
>> Whenever someone wants to retrieve the total number of elements in a
>> rhashtable/rhltable it needs to open code the access to 'nelems'.
>> Therefore provide a helper for such operation and convert two accesses as
>> an example.
> 
> IMHO read of nelems is much more readable than len().

For the case of rhltable it requires:
	atomic_read(rhltable->rt.nelems);

Which feels like it defeats the purpose of the dedicated rhltable type 
in the first place.
But I must admit that there are no use cases in-tree AFAIK.

Another point is that having this sort of helper also conveys that it's 
OK for a consumer to query this value at any time.

> I mean the name of the helper is not great. > IDK what length of a hashtable is. Feels like a Python-ism.

Well 'length' has been the term used in a few languages (Python, Rust, 
Go, etc...) so it felt the most fitting. If you have any suggestions in 
mind, do tell; Some that crossed my mind were:
- count
- size
- elems
- num



