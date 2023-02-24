Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AEE6A20B3
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 18:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjBXRrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 12:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBXRrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 12:47:17 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A726ADC0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 09:47:14 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-536cd8f6034so271449397b3.10
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 09:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=37s9D2og3kZ3uD1A77ezVyzomxnGQQn4uyAzCeYfINQ=;
        b=RMIJY7+qUrg8v3N2OZanCKqaURWAsqI6FdvbVJC130cDf9bg0M1mylPOOI5m5mxk6P
         ESKdsLF7ZrIqVBS99xa6/rdtxdpdiaMv8k6NM/dvxFrV4LDvR36dJKILplHGqGN0P8Sx
         BwV+QvGl9TT/grj4j/M7NTYTtMe2w75o/S1zPP2TbaZdH/lmKOtG/uXbcsucUJ8zG0S4
         DqnNUyLX1Gs73EYoUloflqjQVtEO35/WWvRwxoILOrM3zXc1Spd98j9LgYJmJ266yCeN
         AKGkKSau6ipIrwg3brSwFT10EWY33fXxK0mdoKWiJHW1rwSE9Y6BPx8lo//FXx/MumyE
         oc+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=37s9D2og3kZ3uD1A77ezVyzomxnGQQn4uyAzCeYfINQ=;
        b=wdSjCB1uhc6abuxOAr5omhhPMHWOcaO8wV62lzjEIWZEKWc0qzai9+0Ze+fnH9fWgF
         Ub+VUvyG62eVu+V3X2WrKCOEpKGDgz+y8Aof9h/aJzTIaSJ003Vdl0Vhw8jrcGr5Iulw
         yfUCdxXwvlrveZtxLKSuLOCfXsgmlHp2hDpcvm/KIsTkR1rw/bum/UbxtiftrVyRoelu
         kCJgDNLcClCGJxId0/Y/q4+ukkW+1gQYR/bF96PfyT5w1Rt8QkB/I4kJkEPwUELcqBon
         lvKp+lWLujfITkcuWSe+ald0QT9cLDLkpUnOKVkguipADBiuVDCD3a71iRlOEfeIWJAO
         85Pw==
X-Gm-Message-State: AO0yUKU5om9cPw43Q+eIrERmsEJpnU2ewSevBgNH/POOTBvnXBHkX6qZ
        q3PKNO7X8kHxj0SkPNDqSyg2tPJcItFhQunB3GhRDg==
X-Google-Smtp-Source: AK7set9FRNV2Fw74dAs2EV3Bn2mipr5YBJI8jYBcZLc9tm/FPYATvOK/glbalGaTWjIlcFF9mMsauyBCEoPPs9YdaDY=
X-Received: by 2002:a81:ad22:0:b0:52e:fb7a:94b7 with SMTP id
 l34-20020a81ad22000000b0052efb7a94b7mr5015926ywh.7.1677260833368; Fri, 24 Feb
 2023 09:47:13 -0800 (PST)
MIME-Version: 1.0
References: <20230224015234.1626025-1-kuba@kernel.org> <20230223192742.36fd977a@hermes.local>
 <20230224091146.39eae414@kernel.org>
In-Reply-To: <20230224091146.39eae414@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 24 Feb 2023 12:47:02 -0500
Message-ID: <CAM0EoM=Ugqtg_jg_kgWjA+eojcV7k+nZuyov8Qn2C7L7aPwSRQ@mail.gmail.com>
Subject: Re: [PATCH iproute2] genl: print caps for all families
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>, dsahern@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 12:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 23 Feb 2023 19:27:42 -0800 Stephen Hemminger wrote:
> > What about JSON support. Is genl not json ready yet?
>
> All the genl code looks quite dated, no JSON anywhere in sight :(

We'll take care of this...

cheers,
jamal
