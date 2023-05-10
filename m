Return-Path: <netdev+bounces-1356-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C89D16FD951
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9814C280EFC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63E1212B90;
	Wed, 10 May 2023 08:29:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D2B12B83
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:29:32 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F517AA7;
	Wed, 10 May 2023 01:29:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-64115e652eeso48554818b3a.0;
        Wed, 10 May 2023 01:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683707347; x=1686299347;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z8RwRIsfRADOKmrmxPkNV2fLHwpgOdBlB311q+5skVQ=;
        b=jEOcMdkwiWfkDoBrNqA4na8Gdr2MZN3tgMBfXMcXf010KyfCNmgKjfaOebiEpVClxJ
         ujbM3w3bQhCMdH6HnyPlpireLhs+egi5d1aPTyne0LPbHzbhAIziblvsuCdBpHq7B/j3
         BOK3w+nFqnN4tQXBJbDR6VvFpCRf+wEECIkI0OnkkDBOpzacpqfZA8qkIMawg3nOl+1/
         1txIGxtAxFPKqUOWQSH+GVdTSQRC49wUczjaKcjQHrIcoBJDjrMEFDCtlIj8lhyNSQ1o
         iXh5LBk7b7nvIh5kZICoHkjHIFAY9ApCJhj8yNBkewT/zREhY2lIrSTXeXezTce48sIi
         VJ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683707347; x=1686299347;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z8RwRIsfRADOKmrmxPkNV2fLHwpgOdBlB311q+5skVQ=;
        b=FzQiUCHr7uNozxP3X1DN6g8s0x3oA+VBkEGKHMT07Tm9YnXL6bberzR1l6qwBO8VNz
         XM1g1bmI6EDSeeqcIDx8th8VSNVDfY6fv8zBb8x2DzxRMoj1H5JVULWGl8xB7n7kq5Yj
         EKbIAOLBS8TLbv6jn51btq047NJ/6dMGejgCPNnxF5YzQAddazmkw+MGqvcBC0odVkEt
         XOLfQKcxt17G9vjM1VmNTRIpjztO9RmL5mCsJG2sRcG4K++4CqkiHMA06MC1ea2DKG9N
         1ZQnvfnK2k6P45ZQCEQG3cDI0g0wI8vzzNG+yXCU1Um9JaU2yjMVj4hp5bYbpyrzENrq
         aEnQ==
X-Gm-Message-State: AC+VfDyge5kwaM8FItCZMVbtcImOsPT6WWE3Fa9YPw/BiF1eAyKcrtMP
	sAv5KPgi/Y28FRLmsniL0lk=
X-Google-Smtp-Source: ACHHUZ7OM6Sh+tRD+ZbCT6Ey8cEjtr57bo8TKktmhcIpJrEfJdtW9peJDIQ795tG2Ehlh4lyOtZZhQ==
X-Received: by 2002:a05:6a00:1a49:b0:646:24c6:5f9e with SMTP id h9-20020a056a001a4900b0064624c65f9emr10532448pfv.16.1683707347594;
        Wed, 10 May 2023 01:29:07 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-68.three.co.id. [180.214.233.68])
        by smtp.gmail.com with ESMTPSA id r19-20020a62e413000000b0063799398eb9sm3054243pfh.58.2023.05.10.01.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 01:29:07 -0700 (PDT)
Message-ID: <334e9041-5121-3dc7-9ddd-4ce33585fec6@gmail.com>
Date: Wed, 10 May 2023 15:29:03 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] docs: networking: fix x25-iface.rst heading & index order
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
 Martin Schiller <ms@dev.tdt.de>, linux-x25@vger.kernel.org
References: <20230510022914.2230-1-rdunlap@infradead.org>
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20230510022914.2230-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/10/23 09:29, Randy Dunlap wrote:
> -============================-
>  X.25 Device Driver Interface
> -============================-
> +============================
>  

LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara


