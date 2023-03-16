Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9776BCCA6
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjCPKXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjCPKXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:23:14 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDADCBDD2B
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 03:22:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id d13so1194769pjh.0
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 03:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678962144;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A3KFALwhktFrd2wK9DN+B+WKAYtfeDeWKX4/URe2Zcw=;
        b=gBPGXW5OhtmHmfBHV9yURfAl2ARO5/w5Yygay0qthZSV3BDDeTCzO0jY0uVcbyeBnH
         2R854oFKm8SqdFsmMXZz+xcPkmj96G8egzT4VULTLM10v3wKyPn97k7XabLPpGrbRYlM
         VVCqNxyFlWiwyPUbmSEqyyYbfNKZ/BLp626hpPFdsjKv18qVPF2x7wvOvRtMJKguncCp
         06TbeOgG3aVMrDi90xJ6m+QdUIbDU2pFP5IFoy78McruqySkS1v31aqAVI6QBHISRT5H
         Xlb7j0jfSUzQvsZSoF4h1Uvsu84AJsUYiXpi6gWJd/VWNABK1GO8nhjTVKC+BiHHvCJQ
         EU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678962144;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3KFALwhktFrd2wK9DN+B+WKAYtfeDeWKX4/URe2Zcw=;
        b=dWEHC+jxmCBV63q/VMi3DO9oN1QQT8uENIDx11Ih8yWmTXrg717q3x+8k/APuVLhe6
         E6n8aCw9hxonj8UibfTNmDEpulPkwVfkKHQlwdaZnLFoBpbVjWYQiB2WJttZdZXRev1Y
         hpsgEsur8qsias54u7NI9HHET6iZK8uBASaL5dguE3lY9pKENtDsGVllrer2VcO5eDjR
         SbwuEGPRQeAQ9VfuP+mrqg6eO0kBEotsoqESSIVUJbnPIu0WAk0sdV/Sf21oMyeIvzuS
         lkrNasCCDkBblE2QRKcNhFJCJyaymLXpJm7XVcov70+5Wf7icWN+qXNlO88Oaj3zEzOx
         AtJQ==
X-Gm-Message-State: AO0yUKVJYTX8kuSsUPST7SNKZ9S7ECy7hfc4kDQold/bZpNNlqvnmxFK
        7HZR/nirfbCvG3uqtpQ4U4dW4OMz6evJk8P5
X-Google-Smtp-Source: AK7set/99+zMzPRj+qt6SmjBtp1DtaK+XsFfukMKQpcEQTCviFhLLjLE3IwEKObZcneEG2x3cswzdw==
X-Received: by 2002:a17:902:e191:b0:1a0:4531:af58 with SMTP id y17-20020a170902e19100b001a04531af58mr2030160pla.63.1678962143707;
        Thu, 16 Mar 2023 03:22:23 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e16-20020a170902cf5000b0019f0ef910f7sm5225262plg.123.2023.03.16.03.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 03:22:22 -0700 (PDT)
Date:   Thu, 16 Mar 2023 18:22:08 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
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
Message-ID: <ZBLt0MQeltIfTmVw@Laptop-X1>
References: <20230316033753.2320557-1-liuhangbin@gmail.com>
 <ZBKTPrBONJwvm+rP@Laptop-X1>
 <CAM0EoMkytZ26ZafxKBG3-EpXow_nWyrxye18Prr8JQ-VTVovpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoMkytZ26ZafxKBG3-EpXow_nWyrxye18Prr8JQ-VTVovpg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 05:45:28AM -0400, Jamal Hadi Salim wrote:
> On Wed, Mar 15, 2023 at 11:55 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > On Thu, Mar 16, 2023 at 11:37:51AM +0800, Hangbin Liu wrote:
> > > In my previous commit 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG
> > > to report tc extact message") I didn't notice the tc action use different
> > > enum with filter. So we can't use TCA_EXT_WARN_MSG directly for tc action.
> > >
> > > Let's rever the previous fix 923b2e30dc9c ("net/sched: act_api: move
> > > TCA_EXT_WARN_MSG to the correct hierarchy") and add a new
> > > TCA_ROOT_EXT_WARN_MSG for tc action specifically.
> >
> > Sigh. Sorry I sent the mail too quick and forgot to add
> >
> > Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>
> 
> For next time: instead of saying in the commit message "suggested by
> foo" specify it using "suggested-by: foo" semantics.

Sure, I will

Thanks
Hangbin
