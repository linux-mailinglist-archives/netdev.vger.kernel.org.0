Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E7969020C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 09:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjBIIXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 03:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBIIXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 03:23:18 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C587E41B49
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 00:23:17 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id jg8so4027286ejc.6
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 00:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ugqkr++siywh0swN5b9286pA9cKNm4n0gVMoeMdXOso=;
        b=k6+kCU7weQ3pg25j9OzluTM+hBa1YxXA6LqP1Vx0jd64QJ8TLo5IotmNhoS0o4iQw7
         kuJqLAxev3Bp8iWR/BXjDsesNGO+r8zJ+vV5wtTkseRPEH87c7jj8nv1yKYJNI8dzfNw
         mo8OzNITn0q26EG0ZMADQwbHOvUuIYopaCTiEqbY4hnwO1Dpj9MUtu+Yb4PZLuENRvBo
         JvgKW/ZjX3O9Nd3b506bNQD0lsKnobsWyFAQP5XgKrrd4m3u5uH/sDmVJ1sVj8YFx3eF
         Hrcpr1+uuLvk0vrAGZr6t0xLsilw5/gx3XazOgpWN1WnjCoc0t5Fa/rQLIPbTfe+B9Zw
         +Z2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ugqkr++siywh0swN5b9286pA9cKNm4n0gVMoeMdXOso=;
        b=1GHp9QIPHiiIMM59ZXCY6r0NYTyOGZH3o948SLROB7llTjygjjqQYRgIP7A3W1nO5n
         FS+Ukyz7xt6jyFYFubGaml5O5SETYowORJBHOUxbjzexmHhQYndHNv+GAqhs3B6pTRrW
         QSDAAfxENPMGgRTq0Kbl5IubAk0/QhjDUF00pOEYp+7stlU4Vke5bdoW2JI4xHsOWNoM
         bfMBBq478AngTF6WrYONxBHU2wgrSnp7SNe9IUy8ziD/KZzCFNo4rR8Z9J0pq4Wd8fh8
         AqYIitBjM5vshbOIubP8oNHhx9d+EvCVJNmWEPvGbZeuhjBirlNxGlxiCH3Bv4p6JKhA
         Y/6g==
X-Gm-Message-State: AO0yUKVdnlfFhocyAN1bOWTO95Kb5nookEfg6zQbnZWcZ0oscF403Grf
        AMdaqFvclPWfNHCWDObwEaN75w==
X-Google-Smtp-Source: AK7set+QfkYQ9XGxnLIQkgqJcjbxcTmsrU35IJsn2f4fUZd/7fSK2C5U/kVdtbkNAXyH84Cl/HXJfA==
X-Received: by 2002:a17:907:7e94:b0:85d:dd20:60a4 with SMTP id qb20-20020a1709077e9400b0085ddd2060a4mr15021836ejc.40.1675930995725;
        Thu, 09 Feb 2023 00:23:15 -0800 (PST)
Received: from [192.168.100.228] (212-147-51-13.fix.access.vtx.ch. [212.147.51.13])
        by smtp.gmail.com with ESMTPSA id j4-20020a170906474400b008aac143d9afsm565790ejs.58.2023.02.09.00.23.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 00:23:15 -0800 (PST)
Message-ID: <b5bc02cc-8c81-a4a3-8850-40cb6a4a0600@blackwall.org>
Date:   Thu, 9 Feb 2023 09:23:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 3/4] bridge: mcast: Move validation to a policy
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com
References: <20230209071852.613102-1-idosch@nvidia.com>
 <20230209071852.613102-4-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230209071852.613102-4-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/23 09:18, Ido Schimmel wrote:
> Future patches are going to move parts of the bridge MDB code to the
> common rtnetlink code in preparation for VXLAN MDB support. To
> facilitate code sharing between both drivers, move the validation of the
> top level attributes in RTM_{NEW,DEL}MDB messages to a policy that will
> eventually be moved to the rtnetlink code.
> 
> Use 'NLA_NESTED' for 'MDBA_SET_ENTRY_ATTRS' instead of
> NLA_POLICY_NESTED() as this attribute is going to be validated using
> different policies in the underlying drivers.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>   net/bridge/br_mdb.c | 45 +++++++++++++++++++++++++++------------------
>   1 file changed, 27 insertions(+), 18 deletions(-)
> 


Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


