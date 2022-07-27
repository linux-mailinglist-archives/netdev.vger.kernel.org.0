Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F173458285B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiG0OQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbiG0OQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:16:35 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ED71135
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 07:16:34 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d7so16221870plr.9
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 07:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xuOlvkQBLrdWUBYkNNFfJ9Knn9FBvjzl9wYpptd3E84=;
        b=FQw8QhbhOBfBcMdWUQDwGYDiQKDXcismfmjxH5gIylEJZ743NImDdaZwGjJYGR5tpd
         yIEq8vtRLDUw4reJWYtvMgVDGD5cY+ZpUmKW8o20gLtZVkaU0NQkem0UfSqP0vClUqGG
         DvtdAJmZZeRMUTK51Hh9UwYS0GsvbnYM6m0GoBRvUP4gn1A3WKksTojtw832wjISR34t
         CgjtH1WCYX6Z8N3hhB0K/j75B1fgAecsi0qBdK5QwCN0u/3lMS32tJx5lB8DStWpk8E6
         EAw9PGSqMK0NBss6fAuh/QRheE5V0xV3W1UD6ZXqhrYwYW7Wv4BSisrs4VczEIjqXeHH
         VDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xuOlvkQBLrdWUBYkNNFfJ9Knn9FBvjzl9wYpptd3E84=;
        b=jgf86bFEzI+mHqgJ6TXwR4Y0KU4pAUTlggRkY94bqPsnSIw5XEgN/a0wES6fjaO+7M
         NtkZ3vfj61t28yBqU4ZCDalhTtvVb+pRf3xDwU5+w7qME3dLH1bPC+OX0Mf9wxbZfnzU
         HpmlrR0nEVH1XZzfKydPepgnjN+Zq7FzBlsFHTphYmLCUz1qaqsPM00SDFvDg80fwfSm
         HQ6nNXgbjn3C/nw/JsCQo4GocQaxkg+OunjseyXLsWsu+MH6tkqhmRIzCLypvTxh4i51
         ZMTsNB0BH9sNlP23VG5GEitHcuH9vNActMXrSBqKoNYChpWpFH7FxuNUIIQ3bgj0mrPH
         WRRw==
X-Gm-Message-State: AJIora84Yhya8gecnDpr2cyJZoc60tqf3Kzi8dvuorD967FL1DX8Oly0
        gaFh/Ex3wDurr2NoAp9DMmqL+ZSMw7A=
X-Google-Smtp-Source: AGRyM1s4TMU/fu68gYA+gkefpVsbm67S+o7EXO1kdwuRBPxVgcGqb3zJ4nU2Bg/g5ihVWJZc+hN6fQ==
X-Received: by 2002:a17:90b:4b0a:b0:1f2:a904:8af7 with SMTP id lx10-20020a17090b4b0a00b001f2a9048af7mr4946189pjb.76.1658931394081;
        Wed, 27 Jul 2022 07:16:34 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902ce0400b0016d42244886sm11415369plg.94.2022.07.27.07.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:16:33 -0700 (PDT)
Date:   Wed, 27 Jul 2022 07:16:31 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 0/9] mlxsw: Add PTP support for Spectrum-2 and
 newer ASICs
Message-ID: <YuFIvxvB2AxKt9PV@hoboy.vegasvil.org>
References: <20220727062328.3134613-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 09:23:19AM +0300, Ido Schimmel wrote:

> Specifically, the hardware will subtract the current time stamp from the
> correction field at the ingress port and will add the current time stamp
> to the correction field at the egress port.

Doing this in pure HW TC mode, the time scale of the switch's clock
does not matter at all.  It can be a free running counter.

> For the purpose of an
> ordinary or boundary clock (this patchset), the correction field will
> always be adjusted between the CPU port and one of the front panel
> ports, but never between two front panel ports.

To clarify, the only reason why you say "never between two front panel
ports" is because the switch will configured not to forward PTP frames
over the front panel ports, for BC mode.  For TC operation, the switch
will apply the correction, right?

Thanks,
Richard
