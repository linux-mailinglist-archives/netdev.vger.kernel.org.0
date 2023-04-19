Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0EC6E7B74
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjDSOCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDSOCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:02:11 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC6A83
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:02:09 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-187af4a5453so800312fac.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681912928; x=1684504928;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JrNtNa1Bv2XD+S0cvJT5B2jr7CwOR7A5/Dsc61b+5Iw=;
        b=DJ8d7vPk93F2/oRStIDGifpSjV6iU+qgf9qNgywS75cQwdOhYSkpu2XK5ltVvmoJ3H
         01jNTsPAFjJpS+jfBCigjRT8DNMXxWgxStkE09d1xT/BmbPcW7YEUxk80NNtfbWU8/+y
         zZIhBECsgQMa2eRySiK8C5iPbQag3C2p3NcVxCDlDxHeFyX1uahoZZdPpaiHp5Sc96wr
         vYps5GHPGwuSxmBZxAwyujg9z3Qd7xAb9TiaEC0l2LF2xd8LZ7Pk2PXYIUxYMD7t3V6k
         VdBhxf1zc8lfzVRJ4UiSa/9y2w5rmkeukkM6+k1BPU1MmltE/BvG0NJQJLpNmOXiqjbK
         GGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681912928; x=1684504928;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JrNtNa1Bv2XD+S0cvJT5B2jr7CwOR7A5/Dsc61b+5Iw=;
        b=XUdqW4+5zBpAddN8y2Brb6pOVW8dQaAdaXZUWluHPhq+wjgI0FegkaUy13KqvY6dTr
         IY2jufzts6ijNq9bNWj59TYXwoqPxrmo/juC9XY7KFsljgfjrdTZ9bAbD1GoiKTB7qDp
         RaNXvGBIvAZQvzKbkOED06oXzPpus2igihQecqO6ihsbjxOD/r62lEjC9qNBK/lx7uaK
         m09oHGW4uo5kIwM8o1D1lnA8C+qahd/RFqyzVhc+DkMyiYhOZ0g5tmGSKIIbDA1vKnNG
         8zs1wA2YMUD1ZBA3egXuFtExjkw3ozxnGvBrOftSqv0F1zbRGhk9a7KKrnGnuox5G2Ks
         HAQg==
X-Gm-Message-State: AAQBX9c0r1uMGOjW7Br1qEYTFYoQD6iXAvpyPK9CVj3liPoB86ZacJ5g
        DMBrZq4DIOCM0rgxziRvgps=
X-Google-Smtp-Source: AKy350aKmwSP3WKmCeRLyDz79HJuBr0COw8BEsitIvnRUAZVLW1WEc46IxCVMoFStjlVacKPuKjTGg==
X-Received: by 2002:a05:6870:42cd:b0:184:63b5:8643 with SMTP id z13-20020a05687042cd00b0018463b58643mr3409013oah.40.1681912928269;
        Wed, 19 Apr 2023 07:02:08 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id a145-20020ae9e897000000b0074d02ac1c19sm3107144qkg.15.2023.04.19.07.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 07:02:07 -0700 (PDT)
Date:   Wed, 19 Apr 2023 10:02:07 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Message-ID: <643ff45fa94df_3834752945f@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230410014526.4035442-1-william.xuanziyang@huawei.com>
References: <20230410014526.4035442-1-william.xuanziyang@huawei.com>
Subject: RE: [PATCH net v2] ipv4: Fix potential uninit variable access buf in
 __ip_make_skb()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ziyang Xuan wrote:
> Like commit ea30388baebc ("ipv6: Fix an uninit variable access bug in
> __ip6_make_skb()"). icmphdr does not in skb linear region under the
> scenario of SOCK_RAW socket. Access icmp_hdr(skb)->type directly will
> trigger the uninit variable access bug.
> 
> Use a local variable icmp_type to carry the correct value in different
> scenarios.
> 
> Fixes: 96793b482540 ("[IPV4]: Add ICMPMsgStats MIB (RFC 4293)")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
