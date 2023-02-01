Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A425686A80
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjBAPjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBAPjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:39:20 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92EB234F9
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:39:19 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id y7so3617884iob.6
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 07:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=McPXi0Wsw094zlljnWMxIPMSnerp8sLMWwxDGW8WaRQ=;
        b=eh8MTFL+5zP6T7KCvNAzkhSmeZ6EulhbLcZfRIs6PGdVCGxVqdyRJdlNgyhBf6PnHU
         oyAa5sn3Fq3Xh8PyMJqq2cB/NMMgYEMqjfCdRWSqPWzt8CiM3FEKEQlGyU4mfcAXptqz
         tZWdmjf5dgZ5ISC2lNcUtR8lYqw3+kG3YYXSq3ikYyWCV/t+NiN1NbxVuBSxQaH7f93+
         /8lVDEHMxgFGw6g+yKjwGdzlBcvkwxFRPYnACdqiHrygTFIt4uePLev3CGhH0YPXsau1
         wHiEbtYxuGdUj42vmRTsBt8w5dWkx3x4zZOUoLFMdKUjnHx84sin2W2JVcNN7WXClLDb
         vRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=McPXi0Wsw094zlljnWMxIPMSnerp8sLMWwxDGW8WaRQ=;
        b=Duv+aBWS23xMjCt1WJY+ZNvl0pZ6PRuvCbT/0wtX1LM9NhlJPw/thBJBZz9n1D4yrB
         nuc2f2xIi4/4E8+n4OAn1e6MIHtBgW+9pHbuJFdj7HEw+9kLYYm6hOd3VEZQkQhIOCMY
         80UB+D7k79fH9Nkh8+yHYJRuMadNQD+EaQrbnPvGV8HfqCO2qK7VnRGlneieFvGrsIMR
         59w2uQ/5Tkmw0Y8JqcjO9O+ZdMz/rCeFRyiTJFQP+ERZvGXbTU7o0iagBFDuVtl91cIG
         kIzNJAq7DSKTh5mknua+jZ5ifqVzjshwZrKCI9RfGPV8+1vHe0itzGQdkqUQeoPOX1z1
         3Ahg==
X-Gm-Message-State: AO0yUKX0bCINwHuBSAXrm3kehw6ux46gyv9UX3GUYZJ5Ut3RFRHxFNYh
        1emMsuDXQ0GEZQa7+Dw1uBE=
X-Google-Smtp-Source: AK7set+aCXAvpE/6yJJox2lvt0C8nLhJrmMEeRP3Iw02NdsCzB8KRpMg75saF8QqYVtNfxLwxYU3SQ==
X-Received: by 2002:a5e:9804:0:b0:707:ad8d:c0ab with SMTP id s4-20020a5e9804000000b00707ad8dc0abmr1718566ioj.10.1675265959197;
        Wed, 01 Feb 2023 07:39:19 -0800 (PST)
Received: from ?IPV6:2601:282:800:7ed0:1dfd:95ca:34d0:dedb? ([2601:282:800:7ed0:1dfd:95ca:34d0:dedb])
        by smtp.googlemail.com with ESMTPSA id i1-20020a6bf401000000b00704608527d1sm5984597iog.37.2023.02.01.07.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 07:39:18 -0800 (PST)
Message-ID: <4445718f-85d6-5ae6-209f-b3e402d483fa@gmail.com>
Date:   Wed, 1 Feb 2023 08:39:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCHv4 net-next 00/10] net: support ipv4 big tcp
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <cover.1674921359.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/23 8:58 AM, Xin Long wrote:
> This is similar to the BIG TCP patchset added by Eric for IPv6:
> 
>   https://lwn.net/Articles/895398/
> 
> Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
> doesn't have exthdrs(options) for the BIG TCP packets' length. To make
> it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
> indicate this might be a BIG TCP packet and use skb->len as the real
> IPv4 total length.
> 
> This will work safely, as all BIG TCP packets are GSO/GRO packets and
> processed on the same host as they were created; There is no padding
> in GSO/GRO packets, and skb->len - network_offset is exactly the IPv4
> packet total length; Also, before implementing the feature, all those
> places that may get iph tot_len from BIG TCP packets are taken care
> with some new APIs:
> 

Thanks for working on this.

