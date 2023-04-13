Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05236E04D6
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 04:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDMCs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 22:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjDMCsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 22:48:14 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7849034
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 19:47:29 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id 21so5382816plg.12
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 19:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681353996; x=1683945996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jd3s/I2dtih+LKo8H/nOICjN1U1WPB5h/DNv+LpvtWw=;
        b=Pq1TUY62McQgttLfS/A2XqEKn/tgmrfUZ9yaJplxXfrN9kGKEuaWx4Xd5AU5vn09PA
         ADKvnkgkIDLrOTEQgOMlSaXDg2b8OisXuneSxmgTwdpP6sAeS6HSrp31f0aOVmqDwbHS
         cQCAOBtput4bfjISGjlU3wfnVAZyUeobsZIgVsQZ7ometWwM3tRsHVl6D6ND1ssrXjuC
         uzq2VmOZrXRQ2NjJUSjEEnR9UKmyqXOlEv9cAgKMfk9YMho3vftwMsiZpgwz3e9Z3AMj
         pRGVOO3xgYL5MUfybmllB/ZhW5GvmpmfzuLLnJF8dSWgui6AQ4xEoJv+Y1jpcvBAU/yS
         P+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681353996; x=1683945996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jd3s/I2dtih+LKo8H/nOICjN1U1WPB5h/DNv+LpvtWw=;
        b=C+fp3+/uv3rnUGMh92KENQDBf0eSvjZGKH/LYDrKWin3ukev/6bGAc/hBLZxqDNVHY
         we3pGxR2rgC6CfuHszV2NK6uCSu/vJDKm73A54KTg0cyOrKozQJJBKtmPoXRdZ7k6Ubi
         d2Z0lDWEQE7Wn+XQBt3/DpXLqg+eAKe0DWEteT+rro1BOKG2dY1jQ62WoZx+OpZSXNCQ
         ifQ0ieI6lUkqgTCUa2z96ZWEpVV7b2mZGhTMtXhwABjXN+w7Nai/e4VcUBL5PRkA6M0f
         VcsLpgVyDPrlcR+CJZweZljh/ayY3LNnziJMM1yhixo2l4kZj4atTOWVmC4buE34FGBu
         EsIQ==
X-Gm-Message-State: AAQBX9eXvI8lip/L/8Wd8JfDZq9pMQwte9Hz/pXv/Gzt6aIyHADMwkjg
        vnlJXi7JsJjcRno8v877IyQ=
X-Google-Smtp-Source: AKy350agQrXr6vNZJ0C8LZwimukxnGXjv8sSztuBcEk4m9U5MCzbzTGFTyKXFCVrHpd9NVYpzoGANg==
X-Received: by 2002:a17:90a:4f4d:b0:234:13a3:6e67 with SMTP id w13-20020a17090a4f4d00b0023413a36e67mr320902pjl.12.1681353996366;
        Wed, 12 Apr 2023 19:46:36 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:7826:7100:99c4:7575:f7e2:a105])
        by smtp.gmail.com with ESMTPSA id m2-20020a17090aab0200b0024677263e36sm239033pjq.43.2023.04.12.19.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 19:46:35 -0700 (PDT)
Date:   Thu, 13 Apr 2023 10:46:31 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Martin Willi <martin@strongswan.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] rtnetlink: Restore RTM_NEW/DELLINK notification
 behavior
Message-ID: <ZDdtB6ib/Rwciv78@Laptop-X1>
References: <20230411074319.24133-1-martin@strongswan.org>
 <ZDUtwwNBLfDuo9dq@Laptop-X1>
 <ec3a6209cdb2bc42e3af457fcee92de92eae9e6d.camel@strongswan.org>
 <ZDavJCLutKC/+oHZ@Laptop-X1>
 <ZDcltmGmTr6XOlsN@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDcltmGmTr6XOlsN@debian>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 11:42:14PM +0200, Guillaume Nault wrote:
> On Wed, Apr 12, 2023 at 09:16:20PM +0800, Hangbin Liu wrote:
> > On Wed, Apr 12, 2023 at 11:21:33AM +0200, Martin Willi wrote:
> > > Hi,
> > > 
> > > > > Fixes: f3a63cce1b4f ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link")
> > > > > Fixes: d88e136cab37 ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create")
> > > > > Signed-off-by: Martin Willi <martin@strongswan.org>
> > > > 
> > > > Not sure if the Fixes tag should be
> > > > 1d997f101307 ("rtnetlink: pass netlink message header and portid to rtnl_configure_link()")
> > > 
> > > While this one adds the infrastructure, the discussed issue manifests
> > 
> > Yes
> > 
> > > only with the two commits above. Anyway, I'm fine with either, let me
> > > know if I shall change it.
> > 
> > In my understanding the above 2 commits only pass netlink header to
> > rtnl_configure_link. The question code in 1d997f101307 didn't check if
> > NLM_F_ECHO is honoured, as your commit pointed.
> 
> That's right, but personally I find it clearer to cite the commits that
> brought the actual behaviour change.

OK, fine by me.

Hangbin
