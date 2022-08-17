Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027D85967A5
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 05:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiHQDEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 23:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238447AbiHQDEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 23:04:45 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED176A4BF;
        Tue, 16 Aug 2022 20:04:44 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso651315pjd.3;
        Tue, 16 Aug 2022 20:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=QiKcqQGvDQZ0wwxsKELSH16ee9cOyYGIbKKc/TC2lac=;
        b=F19mXXKtLBf6iZVb6OJh9gOPy2/rtD0ZdnW872Bmp9Hgq+BfaOSiyncf8f8FFiLrbw
         sLarg712oGU6m+2FqBAfeZBbnhGkSb3XeZQNewvHJLO5r478kLea8UGdpnvAMfNP4yJO
         KMFnDg2SlEd8+kitF3MHDqBMUfQAENSy08qvPBIhRs04EljBxwF+MIK1XpCyVXjs60lB
         Jf+TqXCq5KkMty7fn0ol9jgro0js6yw5zYaOfv7JSQdwCHRC/+AdarciIMbXvdbfc1rr
         szGau58oFfpvcYt7HhTU5dtxXvr+yD2LAQVfFoBAm8M2Dkccy8NkyPtR0Ai9CmEteSSK
         zZLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=QiKcqQGvDQZ0wwxsKELSH16ee9cOyYGIbKKc/TC2lac=;
        b=p2PggHG/YDBTCI/EYXDeJQlDj186NWEP7jE5N/w7M6e8lk4YD9i7B/+Qf5gmRYBYSz
         9NrgEWCmTpOhxylU0Qa+POLTwB9g6loq/r7ocvgnfLD9OP+kTWzGlKPHxL4t2fsBIkPl
         5kp2H8/AWjMYCXXlsSo6GKERNk86eai84Kr7IT96JVAAO5/kBnjSObfb6kzOVTYRcFQd
         HAB0CSBwRoNfwXIB/bo8KjQWbszhG7689+UeheuxRVKkCuSpABYA/DsWcv1AYKgVhE0r
         xKE/6IMh5E2inAhu0J2DbNOcw+Ozg6ELRz9xmU1pJkRQ2jLu8PMVE/blNUHMutm7XSom
         DVzA==
X-Gm-Message-State: ACgBeo2fZlz2pFFmkZnLD4qdvAzmO03vvWc01ZBBSRf21Q6n7WH+emcO
        zh9KSZXcp+OClC6mTiL4shU=
X-Google-Smtp-Source: AA6agR4d1E+ey3zbI4IF5ML3Se7af3AMcCPqfC/gvLIVoMIKs1/GntGKkkoyWx9ncFVYNz/6oOMyYg==
X-Received: by 2002:a17:902:a3c7:b0:172:8db4:cc54 with SMTP id q7-20020a170902a3c700b001728db4cc54mr3998176plb.99.1660705484047;
        Tue, 16 Aug 2022 20:04:44 -0700 (PDT)
Received: from localhost ([36.112.86.8])
        by smtp.gmail.com with ESMTPSA id r15-20020a17090a0acf00b001f559e00473sm279356pje.43.2022.08.16.20.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 20:04:43 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     kuba@kernel.org
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dhowells@redhat.com,
        edumazet@google.com, jakub@cloudflare.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, songliubraving@fb.com, yhs@fb.com,
        yin31149@gmail.com
Subject: Re: [PATCH] net: Fix suspicious RCU usage in bpf_sk_reuseport_detach()
Date:   Wed, 17 Aug 2022 11:00:13 +0800
Message-Id: <20220817030013.6574-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220816183930.2328d46d@kernel.org>
References: <20220816183930.2328d46d@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 at 07:44, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 16 Aug 2022 22:16:46 +0100 David Howells wrote:
> > So either __rcu_dereference_sk_user_data_with_flags_check() has to be a macro,
> > or we need to go with something like the first version of my patch where I
> > don't pass the condition through.  Do you have a preference?
>
> I like your version because it documents what the lock protecting this
> field is.
In my opinion, I still think we'd better refactor it to a more
geniric function, to avoid adding new functions when meeting
the same problem. However, if this is just a standalone problem,
maybe David's version shoule be better.

So maybe apply the David's version, and refactor it later when
meeting the same problem next time if needed.

On Wed, 17 Aug 2022 at 08:43, Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Aug 16, 2022 at 04:44:35PM -0700, Jakub Kicinski wrote:
> >
> > One the naming - maybe just drop the _with_flags() ? There's no version
> > of locked helper which does not take the flags. And not underscores?
> I am also good with a shorter name.
I also agree, the name is really long.
