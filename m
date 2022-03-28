Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE224E8C38
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 04:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbiC1Chb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 22:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiC1Cha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 22:37:30 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DD913E81;
        Sun, 27 Mar 2022 19:35:50 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id v4so12707144pjh.2;
        Sun, 27 Mar 2022 19:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nwT/36IMIBdtHxFGCWtJ9XiKKgzDDQSdkdaTgjxnLU8=;
        b=c2UKp3O/7LQbiI5nggGupsJ4g4IbAFqunyjCelAItHLwzVk8fcXiyIukjcbvifLySs
         kZEMtUPANUNcZb0qhTxUhmHwv6l3kRL1XP8LCbUJhkpLo3v702ILjMW1g6jRldcN4MzZ
         riXXYFWp9rrPTG8DDRQFDzyzwufD50q7q8G0vSHl18L44xAU4Y2vaqrHOXHrP2I0h04K
         2TfXZKiyLKkzddHUL0DbfqH5aSNFpA0gBLZUHlattfPjdPBem7AKEtFjIRM+qkrfdxab
         SdHPeWLCtnMvMkAe6hagDgfFvE/UTOR6R+fnTiQT4Rk1P0ejrdXXjmTzUF6CrJUGgf21
         9PCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nwT/36IMIBdtHxFGCWtJ9XiKKgzDDQSdkdaTgjxnLU8=;
        b=3tIZ6tzKeTqgG+qCFaKqIVTICWHCiKycTHFpHireZkD+OG7HEgrLA/eeT+3K6ufQtA
         5bWXoITxxJ8V3SWLVChowuJ8457WW30vFcRAGDXjbZuuKTNJWbj1thS33w59NsxC82KZ
         QayFnrcjNQjW/tsLVeGfPynaWJeyBYPeXJAPdt8UFaLxZljJT8FC4PoPv/SZf+jMGV+B
         fP8Fl3D7jAERI92NYc/eK1TAe+coanzi32pT+94u8Af3uwK/q4nEtU5qiv1FNu5E5AnM
         +6GcAsvoAxg58o18ujd6nOzICcIWmvcy6fVdD9oSDjO5As8mYApCQituu1bv0fqLqclv
         hlOg==
X-Gm-Message-State: AOAM5322CBzaJm8XiezDWYjKkaQgwSz8l4C1KTKptA50YNGW9e5XVbf6
        eAzOlvLhP20FlUds1jdsF7c=
X-Google-Smtp-Source: ABdhPJzJozfvss5oangSUBVul8biC3VTbOb/jCHT8f0N5SWAv5e5ucdUsUWs9TwTpLoeAtAxXS8SBQ==
X-Received: by 2002:a17:902:e5c3:b0:154:7d95:ba7e with SMTP id u3-20020a170902e5c300b001547d95ba7emr24071034plf.140.1648434950025;
        Sun, 27 Mar 2022 19:35:50 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id w6-20020a17090a460600b001bf355e964fsm18744505pjg.0.2022.03.27.19.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 19:35:49 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, stable@vger.kernel.org,
        vivien.didelot@gmail.com, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator
Date:   Mon, 28 Mar 2022 10:35:42 +0800
Message-Id: <20220328023542.19749-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220327185805.cibcmk4rejgb7jre@skbuf>
References: <20220327185805.cibcmk4rejgb7jre@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Mar 2022 21:58:05 +0300, Vladimir Oltean wrote:
> On Sun, Mar 27, 2022 at 01:55:47PM +0800, Xiaomeng Tong wrote:
> > The bug is here:
> > 	return rule;
> > 
> > The list iterator value 'rule' will *always* be set and non-NULL
> > by list_for_each_entry(), so it is incorrect to assume that the
> > iterator value will be NULL if the list is empty or no element
> > is found.
> > 
> > To fix the bug, return 'rule' when found, otherwise return NULL.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: ae7a5aff783c7 ("net: dsa: bcm_sf2: Keep copy of inserted rules")
> > Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> > ---
> 
> The change looks correct, but from a process standpoint for next time
> (a) you should have copied Florian, the driver's maintainer (which I did now)
>     who appears on the top of the list in the output of ./get_maintainer.pl
> (b) networking bugfixes that apply to the "net" tree shouldn't need
>     stable@vger.kernel.org copied, instead just target the patch against
>     the https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
>     tree and mark the subject prefix as "[PATCH net]".
> 
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Thank you for your patient review and good suggestion, i got it.
I'm sorry I forgot to copy Florian.

--
Xiaomeng tong
