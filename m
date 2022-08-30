Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C665A67AB
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiH3Prk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiH3Prj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:47:39 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E626212F112
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 08:47:36 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id fy31so22622504ejc.6
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 08:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=vbxWmQfVdH5BfC2fjJlEtBeCvd2IIlmQ8nicdM6ehzA=;
        b=fmnZY2bnczWq4E0jLGkETyEvhThOtEzERAvuHpkE2nTnGY1HLEgXhSRBG2iXn0QMAg
         e8BtUH2Pdk2g9f4Fl9dMyhtjIX3wRwLkvN656ffR8zjllh7WSj1JVVNLUCKdg33xmCMz
         Zfz6psxC+A6LtoEJ5Lj8OnKuPKFiES2XHC0itCt7NUL68EVgmcQP8qGqhgGnTa6MebaI
         DpqMpUe/VpV0UKk4AV0JSsUuOoPLR6FdgBSt/nwiKcA2L/KZbLPG/oACw/coKmCfR9j/
         rROg7LROQhexd3UG4DqbSpRG+Bb6sJ9qEUql0E7zcvJ5zZlTjcmAGxUBzlyNc+aaun6d
         Ispg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=vbxWmQfVdH5BfC2fjJlEtBeCvd2IIlmQ8nicdM6ehzA=;
        b=RE/7sfW282rM8TD3NHnDJybOC1zwBWw9lt3Dlv1W6ZKapFVED8r/Ydz1WvACssyrug
         Ea1VocoMqoKmHYj2jAZ4MqfXjt7se6qkkMmmRxfNjDz0b5DU19bxdW3vmdO0ESg68mj4
         +PlMoktxWTMxxYiEElnng6dBcTGRPG2GZnzFIuiA1tE4w+nXr1fdnvkYREN9XTO6tKHZ
         fwMi63yd5p8byuuq70Xpt4prykMp6ChFwQGTfKw2FDCdSr0abOO8tsQgMyEzRLQJvVRY
         +DonxtkAiDTJzRn1MnRhIiUYPqTiYNDGOW/NNLZipfeBCIW41ae9VS4gXrV+Xw3winUj
         TohQ==
X-Gm-Message-State: ACgBeo0QKEu4W8qt/hQzqK3b0sd7fROhQmrXBpKtmtVUeeiR/tyNXC0p
        In+QExYgtYQuF3lQFFYkbucAOI/Vi+Q=
X-Google-Smtp-Source: AA6agR6NenhEzhmOMWhfSGBaUpY4B0W9H64+2nCsHq0UYL1Jy2ldfIBSfO+nUfDv0t+MbDtFaTx6Aw==
X-Received: by 2002:a17:907:3d89:b0:73d:6a08:b03b with SMTP id he9-20020a1709073d8900b0073d6a08b03bmr16788633ejc.458.1661874455117;
        Tue, 30 Aug 2022 08:47:35 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id n26-20020a056402061a00b004464c3de6dasm7411038edv.65.2022.08.30.08.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 08:47:34 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/3] sfc: support PTP over IPv6/UDP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     habetsm.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20220819082001.15439-1-ihuguet@redhat.com>
 <20220825090242.12848-1-ihuguet@redhat.com>
 <20220825090242.12848-3-ihuguet@redhat.com>
 <20220825183229.447ee747@kernel.org>
 <CACT4oufi28iXQscAcmrQAuiKa+PRB81-27AC4E7D41LG1uzeAg@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <34a1266e-77f1-2b1a-38c3-5d6baa70f8a8@gmail.com>
Date:   Tue, 30 Aug 2022 16:47:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CACT4oufi28iXQscAcmrQAuiKa+PRB81-27AC4E7D41LG1uzeAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/08/2022 07:39, Íñigo Huguet wrote:
> On Fri, Aug 26, 2022 at 3:32 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Thu, 25 Aug 2022 11:02:41 +0200 Íñigo Huguet wrote:
>>> +static inline int
>>> +efx_filter_set_ipv6_local(struct efx_filter_spec *spec, u8 proto,
>>> +                       const struct in6_addr *host, __be16 port)
>>
>> also - unclear why this is defined in the header
>>
> 
> This is just because it's the equivalent of other already existing
> similar functions in that file. I think I should keep this one
> untouched for cohesion.
My preference would be to keep this in filter.h as Íñigo currently
 has it, to follow the existing pattern.  These "populate a filter
 spec" functions are really just typesafe macros.

-ed
