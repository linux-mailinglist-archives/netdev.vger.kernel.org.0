Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504F45F4CE7
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 02:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiJEAGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 20:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiJEAGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 20:06:13 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016513FED1;
        Tue,  4 Oct 2022 17:06:11 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id u28so9377984qku.2;
        Tue, 04 Oct 2022 17:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=rCqt0YEVSShyPm3KuF8oyQCI+31I0hXqTLNlTIQ+j3M=;
        b=J0YImIdGxwf2mJo8Mx28PszwlYT+jDyBV51alNq08nlas7qliw9goYeWoHzTkxH4R3
         ePtT5Oin/OgJxt5BBB0k5N+3cXLyC/vR+7VOpoyVR4tw5lQTt2RCr/lIkRwBrqwR8L3p
         RBmq1LQN4x1nFOGtJGcKT0tbbF0HxlCoiYj1CfT1TsvpBJvWPUUpfEtcbkhA1Ag3j65U
         NOhtZHYNgT5bUDXMyuIixYvpTlbvCE5M8yXMOHlv/p5LXkMRtaOeTm0IDy8Cn3Nf8zr9
         Fukd8rXNedPXe2kH7FB+yhmnwCv+uDKZF62ORvNRnYVOnHwEA9wP+Wr9UwE40IDK0S+r
         fbMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rCqt0YEVSShyPm3KuF8oyQCI+31I0hXqTLNlTIQ+j3M=;
        b=Nt38lkeFFcWeHR37kOmAx13Umf3FWdQ2106Pul58hM4R6NiflxynmTu5Xs9SPKtBCl
         f7/LyjeKPZ2DIYUlhnJeOUAcrNzSMKCmiK7qHYH/rDKKCTutvlnt7jXIhfSMJzw8xMO9
         RBZ/pyVgsGYbXpgMNz9cqlTpcDdZZBbBvPn+G4GRnxxnJeUFJAuBQg2MYPCJ82YuQQu/
         uvXqbD7728X+9R9OvXWzvKeEUGpSfWVt8zPfRyR0KLdyLPI/r5yH4RG4cnJ+ssffh1MD
         3JNbj9RMau4t6iQVkiFyrdg0GLsCzqjWoFDJKkBIKC8LCanqTheFffaEwHsDun0tZlXk
         tfKA==
X-Gm-Message-State: ACrzQf1nu8TD9jDPsE+N/1kpz+3YbJCWO3cjLL9UbvRLlvV2dsT1lyEX
        RLBP9oA4Y2rcq9UTpwY2HQ==
X-Google-Smtp-Source: AMsMyM6Kzq3EB8+NvUBz28oWDYmbZApQ+gnNp72Fth1tSFQzarASlvYWeugpy+NsFyXa1wLSBk7jyA==
X-Received: by 2002:a05:620a:40d5:b0:6cf:3768:5a18 with SMTP id g21-20020a05620a40d500b006cf37685a18mr18404604qko.165.1664928370083;
        Tue, 04 Oct 2022 17:06:10 -0700 (PDT)
Received: from bytedance (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id e4-20020ac84904000000b003434e47515csm12605123qtq.7.2022.10.04.17.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 17:06:09 -0700 (PDT)
Date:   Tue, 4 Oct 2022 17:06:05 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/sock: Introduce trace_sk_data_ready()
Message-ID: <20221005000605.GA2247@bytedance>
References: <20220928221514.27350-1-yepeilin.cs@gmail.com>
 <20220929091840.33126dc6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929091840.33126dc6@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 09:18:40AM -0700, Jakub Kicinski wrote:
>  warning: 'const' type qualifier on return type has no effect [-Wignored-qualifiers]
>                  const void (*data_ready)(struct sock *)),
> 
> Please double check W=1 build before reposting

Sorry; should be "void (*const data_ready)(struct sock *)" instead.
Will fix in v2.

Peilin Ye

