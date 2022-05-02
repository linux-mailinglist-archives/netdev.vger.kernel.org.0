Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D78A517113
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 15:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352940AbiEBOCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236512AbiEBOCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:02:16 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54471D97
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 06:58:47 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id w17-20020a17090a529100b001db302efed6so11273056pjh.4
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 06:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wmMs79yOJoxJFuuyAgWmB9ghe0EyZkKVicny8EVs0lo=;
        b=n1EZ4atfbH7w1aDJF556c/a6GOM4TDqYy1rdNx0lSE4QhejYr8Y5EETfCulvAPsrp9
         WSsXg91BfaL+qZVaHKCiQasWAj/0Ux1qPH4PKFL0TvTFrD8sr3Z2V/VjaEPlGNWlw+S4
         IVXW+1fPosk2/WrJ+IuTPVyxVu4YwQ7+0t905/OdSdKmStFZWuL1i2Oh0fALKyPnnjl5
         M1QlMajuvYNeBZsZZg8zPHsRaZTLtSQbvQrQHUJaIVQnbqmCYu72Vw0uVk0wrljjqRJE
         +2DbBU5Ewsvnzkdn9t98Qf7myH0GMtJ+hpIDXYbtkcKltxkidTEozxj+EoCdlEtygfye
         mY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wmMs79yOJoxJFuuyAgWmB9ghe0EyZkKVicny8EVs0lo=;
        b=awAhy848iLZLhuR9qAZWwXk/3RHXahj2iazegzKLgXH+c2EunRNuvH/l9aV0O6Qy9a
         OLLzILUJ2Bp5pMq2bIexpk/HMNHSZk82T7nSyKwn0DpW+Yx8LZMpFAIlCW3UJhwtGVGf
         Hz7udNxSEZ1i/K9kEjVlKDfzujIoXoksiGdobH0bxnBtidkP/Amr3EVcJRToZik1AuVT
         fBm6ueI5MIDGolX9m8VirCtgqClNom6EgquFgzUtSUUs68S77hldjEwDyMG3l4dijk+g
         lIMZ2Bbr1X1ZOPFi6zBZvo1kgMJDm5yUMg1FRoLRaf/TEdjvYarQqhNsSbb2FzVleCxq
         jnzg==
X-Gm-Message-State: AOAM531vb6VlUaO2CoibuLy6VlB9hwZZJmT5WG+SWgYZqB3jt8M9US43
        qdmCqufSnpJF949NBJbbIgwiUA==
X-Google-Smtp-Source: ABdhPJx04jXA+XMROQRsD4byeycLDq+y6n0FPn+nVkbJxzj00ASmWN2dJlZYXcgPL7IhxKJRbJSs+Q==
X-Received: by 2002:a17:90b:3b82:b0:1d9:77d4:ea8a with SMTP id pc2-20020a17090b3b8200b001d977d4ea8amr18283849pjb.193.1651499926510;
        Mon, 02 May 2022 06:58:46 -0700 (PDT)
Received: from google.com (201.59.83.34.bc.googleusercontent.com. [34.83.59.201])
        by smtp.gmail.com with ESMTPSA id d10-20020a170903208a00b0015e8d4eb1e8sm4667230plc.50.2022.05.02.06.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 06:58:46 -0700 (PDT)
Date:   Mon, 2 May 2022 13:58:42 +0000
From:   Carlos Llamas <cmllamas@google.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net 1/2] selftests/net: so_txtime: fix parsing of start
 time stamp on 32 bit systems
Message-ID: <Ym/jkkOncw2JT2KZ@google.com>
References: <20220502094638.1921702-1-mkl@pengutronix.de>
 <20220502094638.1921702-2-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502094638.1921702-2-mkl@pengutronix.de>
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

On Mon, May 02, 2022 at 11:46:37AM +0200, Marc Kleine-Budde wrote:
> This patch fixes the parsing of the cmd line supplied start time on 32
> bit systems. A "long" on 32 bit systems is only 32 bit wide and cannot
> hold a timestamp in nano second resolution.
> 
> Fixes: 040806343bb4 ("selftests/net: so_txtime multi-host support")
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---

LGTM, thanks.

Reviewed-by: Carlos Llamas <cmllamas@google.com>

--
Carlos Llamas
