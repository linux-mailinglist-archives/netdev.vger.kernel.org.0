Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418C94FE2C4
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345627AbiDLNe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbiDLNez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:34:55 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD011012
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:32:38 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id p15so37361862ejc.7
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dxiyrkbJ1gI5e17uMzQYH9HmVd7ZbYHU6cmKHA1Eej8=;
        b=0oHfHkL/8/Z16pZuFdu0PP47aaLJV+vInQ3Fxy4U4AodZi8XUZlTg3a/1ht0zAVdLY
         s6Whd9eR+N/3AImhOeUnVLZgUhjbuHeVArpbEw35DyEZ81UAV6POd2oPLDEJgqzFh9Qg
         CL3n3TjznoMqoh9/NF5sr4uklZ9bUvXGTU3YcNVt7lHtjORFxfub2c6LEasA8eAdxNiT
         KxpPuz/m+7f0Ba08nzJeGySdf/qI7U5pDDW1VrfnQo4nGnSqJC/aN+B2LKXUUW6zP0vs
         IoNFrvsPbEVjrBtoYZSb931PPENHwYQoqJOk7GCotozPfvGb3+1lB/SMAXNHWVw3/TZP
         mH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dxiyrkbJ1gI5e17uMzQYH9HmVd7ZbYHU6cmKHA1Eej8=;
        b=m7U4azSBj0ym3ENfF/VCcL+3IF+f7/lSizHdEEfG7MRPH2XCZBJrpGDQcqG4m+5Ze2
         XLG/DtL57eIkd9qrojD8/aAi7jZycG89fxzgp2601D9UP+lbZpts7l8/FKegEKxbSIyH
         MHTzVlZ0JdP2ulOirMf8wjLaUzqgH4BKincDWSnVeQV1IDqaR8sx/NUzeWgw13/X14ww
         i2touftjdtaKJjVds53bPVolyKy0qCCfZ0ZHT72UT5WBZMrcAkIRxxDdoXc/HxdfGlIx
         0NN7eIg5d0SQLcmiYjeL5t9zp9oBWyrOykj6E+4UHd/D6gnoIHdN/z/tJzc2Y3a0mnM+
         ZYUg==
X-Gm-Message-State: AOAM532mZ9JJdIlNw5Ojlz7cPLI5SJx9LpX42p1BH88A9LL0vTZXNiY0
        5S5UrJIAU8TLrLQAPAVx5gl0a1iCpIeIw9C+
X-Google-Smtp-Source: ABdhPJxmv2vdpeWr9kNJHj2itItldgAf2hGzQLGSOQDe2p/DioPn0WkIx5ScXHWtpbDWw+Z7HXhZrA==
X-Received: by 2002:a17:906:d108:b0:6e8:7765:a70b with SMTP id b8-20020a170906d10800b006e87765a70bmr12999379ejz.436.1649770356536;
        Tue, 12 Apr 2022 06:32:36 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090657c300b006d01de78926sm13137685ejr.22.2022.04.12.06.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 06:32:36 -0700 (PDT)
Message-ID: <bf4ed31f-a2a7-a423-5ef4-5cd42b9889de@blackwall.org>
Date:   Tue, 12 Apr 2022 16:32:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 7/8] net: bridge: fdb: add support for flush
 filtering based on ndm flags and state
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
References: <20220412132245.2148794-1-razor@blackwall.org>
 <20220412132245.2148794-8-razor@blackwall.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220412132245.2148794-8-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/04/2022 16:22, Nikolay Aleksandrov wrote:
> Add support for fdb flush filtering based on ndm flags and state. NDM
> state and flags are mapped to bridge-specific flags and matched
> according to the specified masks. NTF_USE is used to represent
> added_by_user flag since it sets it on fdb add and we don't have a 1:1
> mapping for it. Only allowed bits can be set, NTF_USE and NTF_MASTER are
> ignored.

err, *NTF_SELF* and NTF_MASTER are ignored

