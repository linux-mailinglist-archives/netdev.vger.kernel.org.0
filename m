Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D0551357D
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347529AbiD1Npy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347521AbiD1Npw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:45:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 713445C851
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651153356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0azy+DtovG8mvKEKgP+WR39OqwdFQEe/vQhofXRHF0=;
        b=iY3EmO2k3m+Eedcy/Y0w3hBrx8j46tUe5zyTTbKKuwbp7yvl3HSJgc2/BidwnnfYYU3aXx
        SX0B9ZWo2AKKhAUOFNZ9QgcrVzrAaf9Y6hmIZiXFvZiisjHPbgRLwTA7V5gjZgXPTMtAOM
        2FqGSrjm/2n89mifnHlyd1yri0U4uSs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-Y7Hzt5ThOvaeUt0m3qRPRw-1; Thu, 28 Apr 2022 09:42:33 -0400
X-MC-Unique: Y7Hzt5ThOvaeUt0m3qRPRw-1
Received: by mail-qk1-f197.google.com with SMTP id m6-20020a37a306000000b0069f9aff8ac0so2332427qke.0
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:42:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=t0azy+DtovG8mvKEKgP+WR39OqwdFQEe/vQhofXRHF0=;
        b=A2Q2eUflUdwQmuxpeyfYvRbkcABp6OmbibV0dGOi3JLOdzpM8TjKtnGUVTYFLbM9CJ
         3p4TI46WDgiHoErkmZEoefpPAIhpUrKqlhM+3LyaNfSUmLiVTJihurNsn7qxaVYVrSWC
         vgCcW96oNxkGDL7DM+IFEuLAhSNOR6ezxI1+SibJ1vhGML5DwZ9CpwfcU3oe2TRs4I+F
         +sPPfZzcACanlzGv/zh17fh3uUvVNzJxS1HUGBmKhfLK1JJCMWVFxDbdb/9g9EW5dga8
         xuepp7usY5zn7fkmSwKmmtCxqCBaDcaQsVY2tnblgmviHIj7tXSNqtG/WDRwC1ryjzyv
         7DEQ==
X-Gm-Message-State: AOAM530XlfJD/25CprbsDVjMtSUHrKhWvWnKoYWO1/FZyPpS7sekl/N5
        IVvr6bHHg5yZLt3230TfnlJ9DOpx2XquGJf/kifFCTq3Mi1XypT5fKz/URjbWDBedLKyyFSw8dY
        E1uUW6xmtZbj7R5NQ
X-Received: by 2002:ae9:eb87:0:b0:69e:75b3:6527 with SMTP id b129-20020ae9eb87000000b0069e75b36527mr19857513qkg.386.1651153352571;
        Thu, 28 Apr 2022 06:42:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzokIl/JRaWUMghhni3V9PHgnwjUAMZnI0HyVvX2aW3/E3oEUMo6luK+bXSqhBkIXI2l4/nXQ==
X-Received: by 2002:ae9:eb87:0:b0:69e:75b3:6527 with SMTP id b129-20020ae9eb87000000b0069e75b36527mr19857495qkg.386.1651153352358;
        Thu, 28 Apr 2022 06:42:32 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-13.dyn.eolo.it. [146.241.96.13])
        by smtp.gmail.com with ESMTPSA id bm15-20020a05620a198f00b0069fb41d38e7sm42417qkb.127.2022.04.28.06.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:42:31 -0700 (PDT)
Message-ID: <ff39b718a1eb5a41081beeee24f2c2b57a8a1602.camel@redhat.com>
Subject: Re: [PATCH net-next 08/10] ipv6: refactor opts push in
 __ip6_make_skb()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Date:   Thu, 28 Apr 2022 15:42:26 +0200
In-Reply-To: <3d72bc581954b5a9156661cf6957a72c5940a459.1651071506.git.asml.silence@gmail.com>
References: <cover.1651071506.git.asml.silence@gmail.com>
         <3d72bc581954b5a9156661cf6957a72c5940a459.1651071506.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-04-28 at 11:56 +0100, Pavel Begunkov wrote:
> Don't preload v6_cork->opt before we actually need it, it likely to be
> saved on the stack and read again for no good reason.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

It looks like most part of this series has been lost ?!? only 8/10,
9/10 and 10/10 landed on the ML. Could you please double check?

Thanks

Paolo

