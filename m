Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661B06D5D6F
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbjDDK0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbjDDK0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:26:36 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4423130F7;
        Tue,  4 Apr 2023 03:26:13 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id m2so32238793wrh.6;
        Tue, 04 Apr 2023 03:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680603971;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2cV2Dka8GlFwpI8wHuKuZQguPKqTBu//QF7+SDUmI+o=;
        b=HWxgSnsmYYJ4kXFewV1I5RgQcJ2fWaBRKrZg8CuBKlej6ph+S0CAadS1jGgQZIzBcx
         CLagu6drb50CcyrWGlBXIpO9Jxqq56p0bylaHkOmXJb8UJsR9MvEHAcA3ArI76uyDYM+
         S3ktm6SMT5avSTt7GdXeLZiUt18y1Z2ogTwyQj9kHqbHFNCWrLK0d8xgW2J80MtdPCUO
         Ccwpvvt8kcf9XnZU//DQqnqZPFhspaXNEwQVIu5hQz6h46nPtKnvacybkbuqYDl0reEV
         +SbPGwHbQKlH3M0OqVt9CO1zSfAzeJPaBJoAJ1nk9K33dqh64Akiv/cDKQq7PxOx3FTY
         w7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680603971;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2cV2Dka8GlFwpI8wHuKuZQguPKqTBu//QF7+SDUmI+o=;
        b=2MZUH7v91othfIK3+Um4oXB4Z1Y/rY0JR5MGDThU5TFr8didxcTkPeMCjsUpFIajja
         6QwdLxMvrzxBbZli4afU6Z/do//7lJ4Hu3SzhiXizERlorYbE9FX2qSmu8/+ByhwQs+0
         /msPsSsWjAyCtxVVQ6CmRqJGyXVb0pElPQ7anNmVPGVC/BZTbmcDItH0LR1gg/mw7eMq
         3zqMNl+ezpofrZ87EeceFAXXrUSxvdE5m/BD66rTm6zU1LhxixPnUhXk2y1NU7gUTMbD
         cJ5C5SvQXQZsJpv6syiariqZjH0rrfto4BCr+IWsLhPZhd4tiQaxibjMYhYKh9/PgdvD
         nugQ==
X-Gm-Message-State: AAQBX9fjrPmMUfqPNyYN8Ix0oLPscyEX8rF2eytCzS0VV9eaGhHfPsmK
        cYPuFqOGIxsxneyCXX06yuoUp+Ydq8c=
X-Google-Smtp-Source: AKy350YHoQMowhZLIwsN6WZl0ucoFEqan10GsGRaC52zNTSzA7OjX29QnGQEKicDgSfzLDC2n0n4MA==
X-Received: by 2002:a5d:6102:0:b0:2d2:74d6:6f79 with SMTP id v2-20020a5d6102000000b002d274d66f79mr1035974wrt.59.1680603971554;
        Tue, 04 Apr 2023 03:26:11 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id w6-20020a5d6086000000b002cf8220cc75sm11968665wrt.24.2023.04.04.03.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 03:26:08 -0700 (PDT)
Subject: Re: [External] Re: [PATCH] udp:nat:vxlan tx after nat should recsum
 if vxlan tx offload on
To:     Fei Cheng <chenwei.0515@bytedance.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     dsahern@kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>, ecree@amd.com
References: <20230401023029.967357-1-chenwei.0515@bytedance.com>
 <CAF=yD-Lg_XSnE9frH9UFpJCZLx-gg2KHzVu7KmnigidujCvepQ@mail.gmail.com>
 <fae01ad9-4270-2153-9ba4-cf116c8ed975@gmail.com>
 <25fe50f2-9f1d-ec48-52af-780eb9ba6e09@bytedance.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <aa903bc8-a1d1-3fce-99fa-b0896f149ec1@gmail.com>
Date:   Tue, 4 Apr 2023 11:26:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <25fe50f2-9f1d-ec48-52af-780eb9ba6e09@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/04/2023 02:48, Fei Cheng wrote:
> Thank you for remind plain text.
> Use csum_start to seperate these two cases, maybe a good idea.
> 1.Disable tx csum
> skb->ip_summed ==  CHECKSUM_PARTIAL && skb_transport_header == udp
> 2.Enable tx csum
> skb->ip_summed ==  CHECKSUM_PARTIAL && skb_transport_header != udp
> 
> Correct?

What do you mean by "skb_transport_header == udp"?  That it is a UDP
 header?  Or that it is at the offset of the UDP header?  The inner
 L4 packet could be UDP as well.
And why are you even looking at skb_transport_header when it's
 csum_start that determines what the hardware will do?
AFAICT nothing in nf_nat_proto.c looks at skb_transport_header anyway;
 indeed in nf_nat_icmp_reply_translation() we can call into this code
 with hdroff ending up pointing way deeper in the packet.

In any case, after digging deeper into the netfilter code, it looks to
 me like there's no issue in the first place: netfilter doesn't
 'recompute' the UDP checksum, it just accumulates delta into it to
 account for the changes it made to the packet, on the assumption that
 the existing checksum is correct.
Which AIUI will do the right thing whether the checksum is
* a correct checksum for an unencapsulated packet
* a pseudohdr sum for a CHECKSUM_PARTIAL (unencapsulated) packet
* a correct (LCO) checksum for an encapsulated packet, whose inner L4
  checksum may or may not be CHECKSUM_PARTIAL offloaded.

Do you have a test case that breaks with the current code?

-ed
