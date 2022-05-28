Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6CD536DA4
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 17:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238212AbiE1P7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 11:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbiE1P67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 11:58:59 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61682FD11
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 08:58:58 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id i74so7545949ioa.4
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 08:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BBBJvhEiZ/miLAzEMHwiZfzQXSxWha3COeffk9ogzNQ=;
        b=ptDj0/yfszX7jBEl2Vd9+Z/u43CZnqZ5VEQMbPuPfhiLKctFhv4ttqU9IpT1txOLlQ
         Q/9Zq9tGlTv/KL0ZGrs1rauRJUYgwK+HiRWzpCBOlDU+8UxJZsvf+7CGL6JcS+3KzaqC
         V4bsiqjdePaIDNtKK6ILZG7o9cZjADFjlXO+PEPw/njfUJ+ULX7DZBP2OREz5JmXKO2r
         5EIZBJnHhOBKFW3y/jYkvUqHZhGXUYOVknIv6DhNlZwMgm7Ghis9PPvNYO97exX8INMN
         rjNwUaIEUJToS5JAnJW9bK4nnxRo2vzs2L9Dittw6IY5N85sc9frd8FUYH8Ptrn0tDyB
         AfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BBBJvhEiZ/miLAzEMHwiZfzQXSxWha3COeffk9ogzNQ=;
        b=pcU97h4UT9QpJMYWPAllmyWSo3+J0Zcm3sri/1jQmmdVgrmqj7EWPAJMqA9g4qSXrX
         u7APHqkpe70ZhBWhHL5eLiLA0oVh9EVQZk7Er9p4gGvtmasM+OQ2jHavGtNFRZ4aPcAk
         NwBIwXjaBvjSDAMcR9JlQm7zr8xgkFk3KRMyOlA8q7h6+o8txe0l2UJkdQIpMBJzME2G
         y578m4UF16KkD7dJAXaQ0vbxskCGtNTN7c6oN8q33s/rCJqPmzDTt8XZGT5hSQ7ow/g/
         K9cJyoiHSTN7hqBU2M/8/05Xk65g1ly8Gtclbg7nLpEKgtMobvwHZdM5BJEHCxZzzJTZ
         Vxbg==
X-Gm-Message-State: AOAM532kKpeGyFx5e7SWC+NOgE7pD/BEgR0PtklCv4qFzMpcW3X1PBHy
        daP2psSTHsv+w7in0mExpsY=
X-Google-Smtp-Source: ABdhPJwZ59CnPxExudi4r/6c4pleZhunqgTs/bUIf6qQAJ3zXQb1TjyxNfUtrJOiP2LrAr/eY4c4nw==
X-Received: by 2002:a05:6602:25d3:b0:65b:1d8a:a8ae with SMTP id d19-20020a05660225d300b0065b1d8aa8aemr21455568iop.131.1653753537806;
        Sat, 28 May 2022 08:58:57 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:c9e6:7243:93a7:1eb2? ([2601:282:800:dc80:c9e6:7243:93a7:1eb2])
        by smtp.googlemail.com with ESMTPSA id l25-20020a5d8f99000000b0065a47e16f44sm1972220iol.22.2022.05.28.08.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 May 2022 08:58:57 -0700 (PDT)
Message-ID: <2d7c3432-591f-54e7-d62c-abc93663b149@gmail.com>
Date:   Sat, 28 May 2022 09:58:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, andrew@lunn.ch, mlxsw@nvidia.com
References: <20220427071447.69ec3e6f@kernel.org> <YmvRRSFeRqufKbO/@nanopsycho>
 <20220429114535.64794e94@kernel.org> <Ymw8jBoK3Vx8A/uq@nanopsycho>
 <20220429153845.5d833979@kernel.org> <YmzW12YL15hAFZRV@nanopsycho>
 <20220502073933.5699595c@kernel.org> <YotW74GJWt0glDnE@nanopsycho>
 <20220523105640.36d1e4b3@kernel.org> <Yox/TkxkTUtd0RMM@nanopsycho>
 <YozsUWj8TQPi7OkM@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YozsUWj8TQPi7OkM@nanopsycho>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/22 8:31 AM, Jiri Pirko wrote:
> 
> $ devlink lc info pci/0000:01:00.0 lc 8
> pci/0000:01:00.0:

...

> 
> $ devlink lc flash pci/0000:01:00.0 lc 8 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2


A lot of your proposed syntax for devlink commands has 'lc' twice. If
'lc' is the subcommand, then you are managing a linecard making 'lc'
before the '8' redundant. How about 'slot 8' or something along those lines?
