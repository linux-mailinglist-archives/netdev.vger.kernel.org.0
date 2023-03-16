Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC5E6BC501
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCPDzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCPDzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:55:50 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B966040F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:55:49 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id ay18so381641pfb.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678938948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aDnZfC1K/l9a4GdScHsrf7+6oNj25FfLdh1wvbWsjqU=;
        b=MWOAnBe/hnX4WS8BTxbbVJvJAGJ5Wjxl33W7i4sjhctyL1fXJnkTmM56VvkrLD80xc
         mAqdKSKWFm3GJWoUPAkCFDfaM/SSfYp5oDxSH7X1j92C1mjOrNe7i6CdKNCTMUtYOYBC
         pR+kxXWmVzEbBr9/R6TkN5Mu8q7b4mRges4HzWRP8qOMQ8/tLGR2AlegQs6lxqHAU1fZ
         JDM9HFZ4MCXiwyzh/l2QNp6PRy/LHuCQHAO/jwjwDTTMk7CEcNY6x8RltWymcAl7PUU2
         DlEPgG+mCK5SfMtGoKvWUNTDc+YINXk8+iRaK8q0qGx2vonZJ95awqSKHPQT0oPOZFNx
         8P9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678938948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDnZfC1K/l9a4GdScHsrf7+6oNj25FfLdh1wvbWsjqU=;
        b=xzuqLKgu7o95ljwa0HZNh1Rd1fEqs0C5/CAvCanvr+/rPQQMUEVWkQcYGud4bc0PEq
         iRPOnfG/b/f81YnvK4KIMoamjta5K/93TWKmRvydMJSBVWc0ts8oHJUT3wsrrC0A4+KV
         nv4yBhoplGsOdX0aa8hGxtkzH/UrH2+HDptRnyPlcwCgCvBkwmfuPoj/Fm5pT1Am5/UO
         pD/2aRVxYXQnW2kn0U/lkmJeSfOjCBjht/4pa20PnPg+N/8UpKwrehSPtRcYAtTKrWi+
         3WGht8RWYrjFWbf1DIj73JqtlEVgwRGjBOAPBoqpYadOQzZxUMR5151ZLF0vbE2UOkKp
         cWYA==
X-Gm-Message-State: AO0yUKU7jK4rUfHqGT537Gy/Xc67f8JSwsR9+Pp1zSiHh8zWoZ6hfqfT
        exP6bombMiAMaBxR8OHLF/oyESquJ72+8ACW
X-Google-Smtp-Source: AK7set9EIYoUeSm1I8chZ/nijOpPJCVbaN28w4xoIVe4gQL7ATka8tYxRZHl65kvgWjzxrdAhceTbg==
X-Received: by 2002:a62:1990:0:b0:5b4:beb2:2042 with SMTP id 138-20020a621990000000b005b4beb22042mr1533846pfz.19.1678938948673;
        Wed, 15 Mar 2023 20:55:48 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s26-20020a62e71a000000b006259beddb63sm2181673pfh.44.2023.03.15.20.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:55:48 -0700 (PDT)
Date:   Thu, 16 Mar 2023 11:55:42 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Subject: Re: [PATCHv2 net 0/2] net/sched: fix parsing of TCA_EXT_WARN_MSG for
 tc action
Message-ID: <ZBKTPrBONJwvm+rP@Laptop-X1>
References: <20230316033753.2320557-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316033753.2320557-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 11:37:51AM +0800, Hangbin Liu wrote:
> In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG
> to report tc extact message") I didn't notice the tc action use different
> enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action.
> 
> Let's rever the previous fix 923b2e30dc9c ("net/sched: act_api: move
> TCA_EXT_WARN_MSG to the correct hierarchy") and add a new
> TCA_ROOT_EXT_WARN_MSG for tc action specifically.

Sigh. Sorry I sent the mail too quick and forgot to add

Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>
