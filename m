Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBAD583755
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbiG1DJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237869AbiG1DJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:09:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037D55C36B
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 20:09:51 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w10so695162plq.0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 20:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X9ZKQ3GKnl/MtSQ9gY0vccKfv9CguoiZDMMIeqqSPt0=;
        b=k9uT9QfiGf6YUIGfnIzUBlwtBLwOIPdTKXdbG1rxFuXRM0AdjkuhuEaglbZoDKZm2F
         MXmnThnQAarvkG+oYjcg3g993zlaV8rdUd2wQxuxc9xQtyHOSWMzO2HL6A9ikjLn4LMO
         r3YVUVGMf4V+o/+Kt10Nu6Gl5KJki94iyM3vS29Qg2uHp7xihn16r0mafslpBuQUM9e7
         uRTZfaisFBRqLAOz2wGrCD5PHKH4UwOE0sQUF3Tc6r2dUKYZbyJ4VbK+p0uPcstq/o7G
         XYkcW94CGKy0/+knNOqTNFGwPfn2sgJGlqjVH9xMzFbtjaTP1oxHYZzJ6hpnKwxfAZeJ
         YB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X9ZKQ3GKnl/MtSQ9gY0vccKfv9CguoiZDMMIeqqSPt0=;
        b=YqnRIwYfXdu+VrYx3HbZ/2mCUNAAE5cfOxhGiNU4hOMEu2ZteoS8tRBU5ydP2FXBEY
         mMQ1haJZIB4pFBNID4zS1Pz923bhnau00agTwyBe+xx6qrIcjZveWIv74bs2vxsSDLvM
         LzYyqHYNjOE5+TTgXBxTcrF6+es3uSFLhxzewgfAcawWzXcsr8gwp1xbI04exuNIYEV/
         haBByK8HOIiN1z/osiDO4xFrDhkvp2YoeF2IGzYEx7emE5gb9Ai4VZCUzKfhNkPiadkK
         LWBjvArFFBWIZ7PdyTAmN6zjmREPnP03v7oPNJGTKkO/6AsgctfJEGYpj3CqWfJkQ6H/
         nTxw==
X-Gm-Message-State: AJIora8ZXV89Nr3lcVrAR5kGqr6JbajMycF5a/d1+HTqHH4gXsYCvkJR
        q2Q0GDHjbqQfgzSir4TB3oY=
X-Google-Smtp-Source: AGRyM1uZJXMR0J7aBj+X4HDG9uP3WGXA88uQDTtls6U8CviRADOGq44uGb4dRBOG2/9ONciVWumbiA==
X-Received: by 2002:a17:903:2352:b0:16d:80f0:c8a4 with SMTP id c18-20020a170903235200b0016d80f0c8a4mr15328060plh.89.1658977790913;
        Wed, 27 Jul 2022 20:09:50 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902780200b0016c0eb202a5sm14518237pll.225.2022.07.27.20.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 20:09:50 -0700 (PDT)
Date:   Wed, 27 Jul 2022 20:09:47 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 0/9] mlxsw: Add PTP support for Spectrum-2 and
 newer ASICs
Message-ID: <YuH9+/7OrCLzb8vJ@hoboy.vegasvil.org>
References: <20220727062328.3134613-1-idosch@nvidia.com>
 <YuFIvxvB2AxKt9PV@hoboy.vegasvil.org>
 <YuFPYS10iXdco5rM@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuFPYS10iXdco5rM@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 05:44:49PM +0300, Ido Schimmel wrote:

> Right. The hardware can support a TC operation, but I did not find any
> Linux interfaces to configure it (did I miss something?) nor got any
> requirements to support it at the moment.

linuxptp can operate as a TC, but it sounds like your HW does E2E TC
without any software support.

P2P TC does need SW support, because the ports must generate peer
delay requests.

Thanks,
Richard
