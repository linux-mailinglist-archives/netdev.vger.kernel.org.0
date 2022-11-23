Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE556361A0
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbiKWO0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236841AbiKWO0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:26:04 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57896DCDB
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:25:02 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id w26-20020a056830061a00b0066c320f5b49so11292982oti.5
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H/UsIvaRVE/k9ro7Rwgem4eqgMnyw8TWs9rPo/tEcqI=;
        b=C4cVZHPXxp3KPdT/uU8avgCX5YdVqxg5I80A2QjzwxkBUmvugGK1LKK5rWTYHcusJQ
         2UihLuhqvB0BDM1Z91LGtV86SZiqtdoSj6bHXJt4kfjktoFveGf6CGe9YmQznyYfRt+f
         IsFt8hbP0goZvkIiPziPrjb9u4kqIDVHqAJ0ou5l9slDZkHaL7zt8uldItPSD7dd/PEI
         n9A/jQq9gvCWtXxnGn1NpjgbBBIJtpC1pYgGOrNtU+iL+6RzYxUaYX/2zOn0CdS0NE0L
         7dQh/Eyx92DqM7kECDZFEzd1ae0aBcahmQiEajFL35VB6bU0GWdlIA0FjF4kKP0Rlxek
         R7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/UsIvaRVE/k9ro7Rwgem4eqgMnyw8TWs9rPo/tEcqI=;
        b=4+aiLyHuHJIMkhUYmCsLCUXbRyL+iJlF0S7WNaRb1V1LwpifP2XgR/dJ7kzyIOA1vJ
         dIYCP9iGEkNtno0LRKb2TyqB5kFExrVgPw5z0qSYphb0KpkJR+vjxrR5ORb+xJPgmLdF
         Z+wQUTW5WUPixb+I/SBOV/ZGEW8lEJH7BSk1XaOLj16Ym6o9OUZmmXlt7JNMX2NM0L81
         ZHMWo0lIVNcn8XFhzODQp+KyXKwun/MktY5sGhEiem4igQEQW7D8f2FTKLVqlHiX0In4
         not1rxdcz65txhCIr2XVFhkUmVAhtcHAfIXygWed6m5nSWm0v6/jAikJOUG8RYCCZKCw
         Pcvw==
X-Gm-Message-State: ANoB5pkZW5QDTmdOUrE4Hlw5zcNju4xxx7uRhLLWCeoky5qLp4MUggcC
        YpMXKBa5/xnt8eRGj1C6mAk=
X-Google-Smtp-Source: AA0mqf4IsCNItNLCHNAAd5cvPY70Jvp5iH2KuLnEsxA/NIY2q84trtpvuMYNXg1kl+gytPX47/9A0w==
X-Received: by 2002:a9d:7515:0:b0:66c:5407:98f7 with SMTP id r21-20020a9d7515000000b0066c540798f7mr14912017otk.85.1669213502188;
        Wed, 23 Nov 2022 06:25:02 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:5412:fa8e:2d33:bd7c:54c7])
        by smtp.gmail.com with ESMTPSA id 7-20020a9d0807000000b00660fe564e12sm7301475oty.58.2022.11.23.06.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:25:01 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 8C6A2459CA2; Wed, 23 Nov 2022 11:24:59 -0300 (-03)
Date:   Wed, 23 Nov 2022 11:24:59 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCHv2 net-next 2/5] openvswitch: return NF_ACCEPT when
 OVS_CT_NAT is net set in info nat
Message-ID: <Y34tO9GANkP3aSfe@t14s.localdomain>
References: <cover.1669138256.git.lucien.xin@gmail.com>
 <834a564cfccd63c3700003d3f9986136a3350d63.1669138256.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <834a564cfccd63c3700003d3f9986136a3350d63.1669138256.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a typo in the subject here, s/is net/is not/ .

