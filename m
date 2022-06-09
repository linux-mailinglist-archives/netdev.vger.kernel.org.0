Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AE4545033
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343967AbiFIPJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237082AbiFIPJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:09:09 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9452DF45C9
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:09:08 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d13so4807852plh.13
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 08:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OVICZjf0wN2Cx7clP5TRTEbT5tJi8HBFxWPpWO0x2Hs=;
        b=mG1frb4CDL7Gzg8Nv0wdXsLm/r3LYKGwjaEl2ub1Jl+qFJwMSNRnSwh6Dzo8rWmj5y
         U5ZeFb9F3I/A9AkK65MSdbxXyM5AzMgXRuJYxyAL/tT88oacC44txfxvzBTrVVlyyE2O
         5UDrsOZ8CEHj6wnNSn5ujlkTRXKYnyktWqUycnat7l/AN14DhT4VmXcuwVkfB0A1G7Q/
         5eb7UrXr3JfDXcMWiBdVozjscWNZEITpTJRAdxqOIgXb6X2ChuyaC6K9XByt2fjH3R0R
         wd6SxyjY/Tsrbiy5hUOFPRSgNvSMZnrSgr+N1WNokhEsKPJHzud+5PoclzB7HH8PXI+2
         TyCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OVICZjf0wN2Cx7clP5TRTEbT5tJi8HBFxWPpWO0x2Hs=;
        b=e1RzoHAdBgil8hboiYpSpQiMM6HCjySUvT9AIA6bwmwLuoWGKDLVCx+nocYRfyF8KH
         Q89q2IfTrBPCfPgiTf/uXT4Fg62XUqbHnyvfr38gJoJUeEmDDhddLbu0KsC/vkWLuzUH
         MdZtVNfI4Mn4hz4B3Cbh4DxtSqQHVa9UcQL1j3NQf/6XCmN3R7+cqUiZkg/PbGFwUPe1
         4h6srsLznY9zwSVtOSVQva5TREUrcSHbhtP3XKkQuMFax4ADJUai7n5Xu/km34/Rkh7t
         s4MDojBhr6L4QsZT/rrv31Wa6eZgZV0qngtdEVTa8olynR8URue7ax17zFBbuX77FjQl
         P+xg==
X-Gm-Message-State: AOAM530xIqNKxTVXQtYPGTlAN3bZ4e8iu7f0wsBRqwDTrac8A5p4Mjwn
        241g6i+fQK84gZuhGTyByAKnzXyjCnv7QJSYfK5tevVS/xo=
X-Google-Smtp-Source: ABdhPJyEjgUOR+HlF5Gi6tpD9E+hoItYxOt2bJRmAfqWuaHa90JII2XAL8XBqI+RPk2g/6Y1TcZrP1DB8yOXgz3UZqY=
X-Received: by 2002:a17:902:f68a:b0:167:52ee:2c00 with SMTP id
 l10-20020a170902f68a00b0016752ee2c00mr30500415plg.106.1654787347859; Thu, 09
 Jun 2022 08:09:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com> <20220609063412.2205738-2-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-2-eric.dumazet@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 9 Jun 2022 08:08:51 -0700
Message-ID: <CALvZod5g_Qev+0JzEHm+EGY08L7t_afwhnhtLwhVmkN-E7QqEA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] Revert "net: set SK_MEM_QUANTUM to 4096"
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 11:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> This reverts commit bd68a2a854ad5a85f0c8d0a9c8048ca3f6391efb.
>
> This change broke memcg on arches with PAGE_SIZE != 4096
>
> Later, commit 2bb2f5fb21b04 ("net: add new socket option SO_RESERVE_MEM")
> also assumed PAGE_SIZE==SK_MEM_QUANTUM
>
> Following patches in the series will greatly reduce the over allocations
> problem.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
