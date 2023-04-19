Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600256E758D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjDSInt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbjDSIns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:43:48 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9295F35B8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:43:47 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-32ad0eb84ffso4989445ab.3
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681893827; x=1684485827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TGsktBgJ1QXbvB8ShgcNEuNzUeJUOnJ3Rk3wwPSSQo=;
        b=41jEo5IqIKj9iogPeBZ7N768UBpVwx7if8O4nGYOMmENgacrgcdueCYr6W+n9xadS2
         LhAi+STPpz66EML5gMpKWaT+kfYm6BP0ZF+pwEL9FVvLZquxD90Ikx3ZGsVwFKSi+1xw
         Nyw8FhZ28D609y22ewNvCMaFOa+XR1PClBlekic31rrWZeqXnkTxtYzDaMZvkUFgrWLy
         IXGDA1NNbhScyrD+WoFDEYpDa5GWX/SRYHFECNq/CYTzCUtMLJ9X/MJVBTd8N/XhRj3S
         ogloe6/AnuJUqmTZl/hj76rW/UNsXB418VFcmY9R4hOCCUckKLXDXsrJ6cuqndb7fIer
         0mww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681893827; x=1684485827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TGsktBgJ1QXbvB8ShgcNEuNzUeJUOnJ3Rk3wwPSSQo=;
        b=RxLVDbGcMkQgopNrdS1wj4ndNdFMYz79IRsa8fJtfOp7DBnInrRb3A/Ffvko+kCf5b
         RuaINApNoM0gFsXmbFL3g/YZs9fuHwhyguvDX+4I8Ase3anWrPqiv2LO03ltR0Rmqp8X
         eK59efPAIIAowhQazdRNzyhK8G4rMUsdluu/OWprNIVV0yx2aOwtHx8ZyFjlMvNWyS6s
         /QNltAndSSB16LShQ4NeAgcjv92lLADmpuImPoHi4s885XGv93SUUB7IES7PEL+U8WbD
         XpLoQfQANggY1Z0GobdG7KGKzaYWdpoJ+FskTwGybhd8vJd4bBai+myDrrrF2Pa6YLHi
         EqiA==
X-Gm-Message-State: AAQBX9fyuWwUn2zNAC9WO4OkjzQjR6UNuFVyw39z759WV1yIQandV2DR
        OFjQdPcWNDswAbh5ODTLBrWoYO9giuec3nyJfC5O0F5DgOnOHV4AdUw=
X-Google-Smtp-Source: AKy350Y5hNg87qp8du0cB8RCDTg42GONyAbuFf4QmYMRQiuquGjuIvrkia/dh9CnbxE4lupAX0ljoCgHHkqJzTUCkhk=
X-Received: by 2002:a92:b04:0:b0:326:6e97:8137 with SMTP id
 b4-20020a920b04000000b003266e978137mr9709279ilf.6.1681893826754; Wed, 19 Apr
 2023 01:43:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230418165426.1869051-1-mbizon@freebox.fr>
In-Reply-To: <20230418165426.1869051-1-mbizon@freebox.fr>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 19 Apr 2023 10:43:35 +0200
Message-ID: <CANn89i+pwf1RXprQQ-op+L65bhTRvmhJ25By0jRmhpi72edP_g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dst: fix missing initialization of rt_uncached
To:     Maxime Bizon <mbizon@freebox.fr>
Cc:     davem@davemloft.net, tglx@linutronix.de, wangyang.guo@intel.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Apr 18, 2023 at 6:55=E2=80=AFPM Maxime Bizon <mbizon@freebox.fr> wr=
ote:
>
> xfrm_alloc_dst() followed by xfrm4_dst_destroy(), without a
> xfrm4_fill_dst() call in between, causes the following BUG:

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
