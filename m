Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7799A5BF33D
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiIUCED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiIUCEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:04:02 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C56C78BE7
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 19:04:01 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so12685930pjk.4
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 19:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=2ZdNHMYRksU5MK2w0lj49TllEMcUfwjag8d5Kp0gkjU=;
        b=GLdAgAUGohKx3xGIz/VyBZjszzwVHBlvzlRoP3Ep1WMryD20503HOC9aPdRwghrYkH
         ERqP4Gqp0aGWKS7YKGHGCxG6BbQhAwt/o1qnlcrmbkJ05zrr1v1W2jowNHuXtv7dHf4G
         Pg28O3IX6kOwfrTA+MMhScb8+aAXqHxMwxQaZyxU1VenQ885LLFuA/yk/p4Lksod3hrF
         5xnBrRwqkkP2QsjwPuFk+cKLhztHZLz+USNIk70ruvLSKq/qhThIXTPOEsFpUPNmyhfn
         8wQdujs2NZVTf4Opk1ZyCnEA4UrD+JqSqrCoxTehGMaQDS+ei8JlrwhTigzIsIwTqHw1
         FUtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=2ZdNHMYRksU5MK2w0lj49TllEMcUfwjag8d5Kp0gkjU=;
        b=SdFHcP0OqgtXSTxwdkZNjkeNOOpco4wb5ZccsZJP8nhXz/nBQhG/nZjn/CF5YO9hlU
         ZO9Daw3PbOLvIdtl/o/kqHu6fbN74RYp4W3Za2JjJCOu6xtrG1N48YV7oaZYqYQ0Kcfi
         jcpdel2A2jxddPXP9cAwJnYSWaDw5WvIACIQtdDOLyCTLQwt1G5Zam5/IyrNUIU+Ew3X
         uIz29I7Y20l9ZsuqTVM2jxxemnqquhQWcUIcuu4zfL6j1dfwer2L+EjHBWPVfYHx2NRx
         gIS7QcQxnIcqB56syEEbBvn5w2SIzIDAoRYbPvNyKUIyVLJMcxmmZ5Bp8k/DaddvOHcz
         kcfQ==
X-Gm-Message-State: ACrzQf2MSIS+XKjAR/1O9LJvMuaoi48Gf8G84evL2WUob+rQWVU5h1EI
        tLNPmzuVtaDsvhsYNNwlRehYnw==
X-Google-Smtp-Source: AMsMyM4kxalXxGemp6jagoOtdqJ1wY8b238esDJJPYWjbDY0DVEruyvXwSDz7zybO5MEr92k0IADRg==
X-Received: by 2002:a17:903:204b:b0:176:a6c5:4277 with SMTP id q11-20020a170903204b00b00176a6c54277mr2497709pla.24.1663725841147;
        Tue, 20 Sep 2022 19:04:01 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c13-20020a170902c1cd00b001782398648dsm630629plc.8.2022.09.20.19.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 19:04:00 -0700 (PDT)
Date:   Tue, 20 Sep 2022 19:03:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Zaharinov <micron10@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, pablo@netfilter.org
Subject: Re: Bug Report kernel 5.19.9 Networking NAT
Message-ID: <20220920190358.64e1548b@hermes.local>
In-Reply-To: <20220920161918.6c40f2a6@kernel.org>
References: <7D92694E-62A2-4030-8420-31271F865844@gmail.com>
        <20220920161918.6c40f2a6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Sep 2022 16:19:18 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Sat, 17 Sep 2022 11:03:55 +0300 Martin Zaharinov wrote:
> > xt_NAT(O)  
> 
> What's this? Can you repro on a vanilla kernel?

Looks like a tainted kernel, could you print more of dmesg?
