Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663BD287143
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgJHJMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbgJHJMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:12:09 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132B9C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 02:12:06 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id p15so5639396wmi.4
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 02:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cxXxymXsXsO9pRcHRVV5fnC5fn/lM4IojFxd2R/Zbd4=;
        b=K3wjgeYKDWZ/EbVfReNe+8lhNe9PUbthF2OHw1AglJx2q0CRoiQ+/jQ6txDjRwDtHk
         lg5JxftbiMwwWG19mqCA6LD66mpKR7E+UB6/8ZzCrBXK2q1v4+h/YAw8xwQ7amUFl7X3
         tdqUAEd8kr/POnA64AK6j9oe7i/Bxd6WRkXlwH41VUrQZbq/XsqgJ5Lp5i+9kmhGBfhY
         Eqd4gneKZZTkLDbLNWlYpYX5RAmw/tEDTz1wFmQBHMvRy/cducY5Dbq6cciquL9CT2Um
         hA+Vxg1DMUib2xVwf06EhsmrZc91Iex/OJbmsj9sMaPo0jJ/yPzDjvmIuraZfxVmty0S
         oyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cxXxymXsXsO9pRcHRVV5fnC5fn/lM4IojFxd2R/Zbd4=;
        b=U0S9kNuPl7SCBzOfFok/Fb+bahkmKC6Asq7Grso60k0OelWp+fx/l7eq7Yw9Qmo6tc
         rse2zvfDkAx2UFGCpJBVZ2QtZuXGTEYAN8XQq8AQMzON89WoG/YrBSlsfj5IiyPBmCXM
         iXHIenPC8KXMN/kFiE1mjIRVJ9PETwGc3n86B+F8zYQNtf0+QkuicROoxKraah2WxJdq
         /9B+6wHpyrKsJlLrb1lVTmfvVGJXbTnQWVbPUPELKB9reIyJMNj232Gcz6UAWd8ulCLr
         eGG+RDlPluW8IZG9+ME6yijCi518OEriLwbBl2g6u1+CKOgz+4EDPFphpMbku2BFhaXi
         66xg==
X-Gm-Message-State: AOAM5309lPz2w1fZYblnK903PxlxlsB/jyZgamavFmGE2HYP7V9FQmzc
        zfKki+LamcSv6Gw+5wVYnCw=
X-Google-Smtp-Source: ABdhPJzUoTdpKhof5CXem0Wt6sBSrN1G6ZwlereTnJ9H2XuDMHZ7CESdWsSEiXzOJ79SzV5ekBzLPw==
X-Received: by 2002:a1c:1f89:: with SMTP id f131mr8034054wmf.10.1602148324725;
        Thu, 08 Oct 2020 02:12:04 -0700 (PDT)
Received: from [192.168.8.147] ([37.173.145.65])
        by smtp.gmail.com with ESMTPSA id 142sm6633770wma.14.2020.10.08.02.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:12:04 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/7] ethtool: trim policy tables
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, andrew@lunn.ch,
        mkubecek@suse.cz
References: <20201005220739.2581920-1-kuba@kernel.org>
 <20201005220739.2581920-4-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7d89d3a5-884c-5aba-1248-55f9cbecbd89@gmail.com>
Date:   Thu, 8 Oct 2020 11:12:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005220739.2581920-4-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/6/20 12:07 AM, Jakub Kicinski wrote:
> Since ethtool uses strict attribute validation there's no need
> to initialize all attributes in policy tables. 0 is NLA_UNSPEC
> which is going to be rejected. Remove the NLA_REJECTs.
> 
> Similarly attributes above maxattrs are rejected, so there's
> no need to always size the policy tables to ETHTOOL_A_..._MAX.
> 

This implies that all policy tables must be 'complete'.

strset_stringsets_policy[] for example is :

static const struct nla_policy strset_stringsets_policy[] = {
    [ETHTOOL_A_STRINGSETS_STRINGSET]    = { .type = NLA_NESTED },
};

So when later strset_parse_request() does :

req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];

We have an out-of-bound access since ETHTOOL_A_STRSET_COUNTS_ONLY > ETHTOOL_A_STRINGSETS_STRINGSET

Not sure what was the expected type for this attribute, the kernel
only looks at its presence, not its value.
