Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EF1647EB0
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiLIHlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLIHlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:41:10 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F308645090
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:41:08 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id n9-20020a05600c3b8900b003d0944dba41so2767816wms.4
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XjECm/4N2trZe4kiGn1Tlhopv0nTjHCSPh6BnIZekRc=;
        b=GJC3UEEPsBIMK6B7wuyDLiQdilx7IUpryQMKON/j09pU5ACdzMID0Vk7DbFTJHbYJO
         EBv1R3iqekj8rXA5waLmo4XRps+p2jAve1AP5WO7YxekxVmO3HURwiidvHjuzlghYvZ/
         CmwiEUYRADvnBOff5qAbHk+vs30ycr5dNFs2P0KniG/XND06VmEjSG7Puxcrcc78SDX/
         orisiLsTYK+idq6NCPvHmf655nX6b7j8RZHfpdB/fQ/RcGEyT9idbEy8dB6LB2WxvuB+
         2da0NW66tdJlEjGcRk+4hNq6fDm3FFcfdvJIALuua1AtKZBYKmkeJfCxdD6Kn/eJNFxd
         ZLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XjECm/4N2trZe4kiGn1Tlhopv0nTjHCSPh6BnIZekRc=;
        b=KpEkR9riDmofv5wP41OfXc/9NSq04e9BUW6UAqGW5P8XaNPmihyLqfsElaidI0mHMv
         NTwB9h665IQ57pCMyOEtGaLKgwUob5IFG5NP0/9ZbTQZBiZNeGzJzoVvBjRZo1+TfRyI
         Czy4f/hFX8ORuECOKJI+3NhSxfBdOwDJ+bLxDV7DABwJDnqaAoXSbNSpUIlPXT5RRLkU
         9tXgpfhC96jvFVQt1kVK7YcYwnzmJBa8Jz7xrIMP0HRKqz7gq94tq/aPW644pp3DBP18
         PoCTSU4t3ezMdVI6rbnYUUhixMv7C429Yr7vMp6kIAdaUu+NatNCDI8i7sXBh+Y2ta9O
         Ir3g==
X-Gm-Message-State: ANoB5pnFXc4+MnRVFMwLcyxkWBTAtMbuJJWfn+H43xAEnnluVL91qFAK
        xaQTb5IuOoKJ2o1cyzFrMJTzGQ==
X-Google-Smtp-Source: AA0mqf6j0DYVtfB1vsCsCP7gP4JzIXjQ+lJfdXJYe29sHTy5lopwMtJ3+VH1Io9tl4f7T35S0/kyMg==
X-Received: by 2002:a05:600c:4f96:b0:3d1:c895:930c with SMTP id n22-20020a05600c4f9600b003d1c895930cmr3838202wmq.35.1670571667415;
        Thu, 08 Dec 2022 23:41:07 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id j20-20020a05600c191400b003c6f1732f65sm8464582wmq.38.2022.12.08.23.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:41:06 -0800 (PST)
Message-ID: <22583106-8f39-0c7e-1c61-47ec5c614418@blackwall.org>
Date:   Fri, 9 Dec 2022 09:41:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 09/14] bridge: mcast: Add support for (*, G) with
 a source list and filter mode
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-10-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-10-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2022 17:28, Ido Schimmel wrote:
> In preparation for allowing user space to add (*, G) entries with a
> source list and associated filter mode, add the necessary plumbing to
> handle such requests.
> 
> Extend the MDB configuration structure with a currently empty source
> array and filter mode that is currently hard coded to EXCLUDE.
> 
> Add the source entries and the corresponding (S, G) entries before
> making the new (*, G) port group entry visible to the data path.
> 
> Handle the creation of each source entry in a similar fashion to how it
> is created from the data path in response to received Membership
> Reports: Create the source entry, arm the source timer (if needed), add
> a corresponding (S, G) forwarding entry and finally mark the source
> entry as installed (by user space).
> 
> Add the (S, G) entry by populating an MDB configuration structure and
> calling br_mdb_add_group_sg() as if a new entry is created by user
> space, with the sole difference that the 'src_entry' field is set to
> make sure that the group timer of such entries is never armed.
> 
> Note that it is not currently possible to add more than 32 source
> entries to a port group entry. If this proves to be a problem we can
> either increase 'PG_SRC_ENT_LIMIT' or avoid forcing a limit on entries
> created by user space.
> 

That can be tricky wrt EHT. If the limit is increased we have to consider the
complexity and runtime, we might have to optimize it. In practice I think it's
rare to have so many sources, but evpn might change that. :)

> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1:
>     * Use an array instead of a list to store source entries.
> 
>  net/bridge/br_mdb.c     | 128 +++++++++++++++++++++++++++++++++++++++-
>  net/bridge/br_private.h |   7 +++
>  2 files changed, 132 insertions(+), 3 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

