Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05CEB585B42
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 18:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiG3QWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 12:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiG3QWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 12:22:04 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DBC1057B
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 09:22:03 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l22so9213596wrz.7
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 09:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=0BQC7ztdjoYB/4v5qeCyLiMyRnHfJxj5E3xif1QgE+s=;
        b=WtihCL79/iOXyOmDf5JkST8Z0eK9w4M590s7E8csWckLrVZRAfYaAYr3J7uWTXLg1L
         XDVxg5QjIXMy83XQhAJDQPbaytxEcjapeiBoukUlSHGdlqebVGDsY9jvqY+XuaKPBOUF
         Jf+aF7pnJK/HhD/pkOO1j7sZPIfD7Uqp0iD7IWS4fN1nPA5fOX58HRVe9CfLz8aqf9tL
         697JLhLr/trHae02me2CdJkE8sChwI31rt/PE2zqnUuaH7BiMdMzv/6ctZcHIgfUBiu6
         z/FwBG/DyeKseCtTpdS8mKko6LtY8jqf/GjSfen6Sw+jn9avfKYcTcwiyx/TLMODq+eN
         sBnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=0BQC7ztdjoYB/4v5qeCyLiMyRnHfJxj5E3xif1QgE+s=;
        b=EKl6v4r0cL/jk7qxrWFAEoq5hsJJ+ySq/MM2OdVsSv2x1/u4l2dlXpgFJszDLLj1eT
         6MNYkT8x5eqZxvl/7wFO8NunFpCk5mouLQRvn1WeNguEXGI+N0yDk6tsqhJsjyaXrQhW
         0fnzYMUio9TlLxcDjmyTeFkdYuJ7glUoyQW2NONo9I+324kT/MgNyM+cq6Fv7ZfVOZ+C
         61U40hmUsBy7Iq4iuLdliADU1SxOD3D3GiWKVCcGN0B5AZXvc5C+FSq4chm2vWmSxc6Y
         lGIAjjT6FmMmhm0qn+2W5cFM2DASGa74w9Wvl9ZnKvH3c5sHtuRdUmaNk34INWmgXRIM
         xnSA==
X-Gm-Message-State: ACgBeo0k53NIcoxcCE66dZBis0QmtHVBMsglSK8djDfx912ISHiOxLSp
        qYC70FykvlK7pHA4dggMDjrLjQ==
X-Google-Smtp-Source: AA6agR5HePf8wJw0fTd3HYsWdhMjCAq6Lrl8j879hetdIKwStLc4LFN5jh46fcusXxeRHsnIGz9rcg==
X-Received: by 2002:adf:dc87:0:b0:21e:ecad:a6bc with SMTP id r7-20020adfdc87000000b0021eecada6bcmr5440902wrj.218.1659198121799;
        Sat, 30 Jul 2022 09:22:01 -0700 (PDT)
Received: from [192.168.0.103] (bras-109-160-30-111.comnet.bg. [109.160.30.111])
        by smtp.gmail.com with ESMTPSA id t13-20020adfdc0d000000b0021e4bc9edbfsm6606501wri.112.2022.07.30.09.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Jul 2022 09:22:01 -0700 (PDT)
Message-ID: <f7ede054-f0b3-558a-091f-04b4f7139564@blackwall.org>
Date:   Sat, 30 Jul 2022 19:21:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 0/3] net: vlan: fix bridge binding behavior and
 add selftests
Content-Language: en-US
To:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>, aroulin@nvidia.com
Cc:     sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/22 19:03, Sevinj Aghayeva wrote:
> When bridge binding is enabled for a vlan interface, it is expected
> that the link state of the vlan interface will track the subset of the
> ports that are also members of the corresponding vlan, rather than
> that of all ports.
> 
> Currently, this feature works as expected when a vlan interface is
> created with bridge binding enabled:
> 
>    ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>          bridge_binding on
> 
> However, the feature does not work when a vlan interface is created
> with bridge binding disabled, and then enabled later:
> 
>    ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>          bridge_binding off
>    ip link set vlan10 type vlan bridge_binding on
> 
> After these two commands, the link state of the vlan interface
> continues to track that of all ports, which is inconsistent and
> confusing to users. This series fixes this bug and introduces two
> tests for the valid behavior.
> 
> Sevinj Aghayeva (3):
>    net: bridge: export br_vlan_upper_change
>    net: 8021q: fix bridge binding behavior for vlan interfaces
>    selftests: net: tests for bridge binding behavior
> 
>   include/linux/if_bridge.h                     |   9 ++
>   net/8021q/vlan.h                              |   2 +-
>   net/8021q/vlan_dev.c                          |  21 ++-
>   net/bridge/br_vlan.c                          |   7 +-
>   tools/testing/selftests/net/Makefile          |   1 +
>   .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
>   6 files changed, 176 insertions(+), 7 deletions(-)
>   create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh
> 

Hmm.. I don't like this and don't think this bridge function should be 
exported at all.

Calling bridge state changing functions from 8021q module is not the 
proper way to solve this. The problem is that the bridge doesn't know 
that the state has changed, so you can process NETDEV_CHANGE events and 
check for the bridge vlan which got its state changed and react based on 
it. I haven't checked in detail, but I think it should be doable. So all
the logic is kept inside the bridge.

Cheers,
  Nik
