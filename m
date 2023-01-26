Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED8E67D541
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 20:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjAZTS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 14:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjAZTSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 14:18:48 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE1423D9E
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:18:46 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id k13so2807005plg.0
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 11:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RDU0jrNVQ4Bx2dNkHpgBN29LnYUs6yNV5udmthSaank=;
        b=q4mwlr5nEI0etnmuPLJgbcMHZDwf7lSfWfc4jHHdBlXQtZbEzqntm+VHMUTQGJV6GP
         XqwGbWmkklfDDdhT8UOqQ3TrtGJtDfcZ+p621saVuAb7rsCrSQFsz9Hm5Y942IjAnAM0
         YCd38GBd/cGV3FOEwfj1zmwBfv69ImR55tVKV85e5Bhpwf883U1rEu0LwxPFAKfLQ6ba
         If46yJUg/nJcUgZMrQK8AAw4ytMm9yvVDpuZT/pr05NLd0EGRH7qnuve9tG9BPcT1tf2
         QMf5sjoaeMHaH4AMpQN2V3dspAbrdHD0d34sINR1FoCqIKZgXiion7E7e1C4moM/p5Nk
         Kxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RDU0jrNVQ4Bx2dNkHpgBN29LnYUs6yNV5udmthSaank=;
        b=Q2GODDuR3fbTX1GhSn42An8cVr4l/NNxNTRAuT4Y+LtMOYzQs0Z/yeL38P40Gh0wJ4
         qSIpcMk12cqxelgDYxHJ68DtgzPFaERW2R4AK4MrUaCV0kVYqB8Jrg91+4VwjVl89Zbl
         odcS1C2+iqrXeIJmKYdKU4LCR4LMAbGgA7SJL6ApJIdESw8nadR73UoXlLhoMuqgtyBW
         pZJUvKe9lyyvF3NyETcFql/LGs31UfquHZB42gBVUdRuaBs/HF/Gm+KAhE/fENiWrfDk
         VvqtHzG3kw+yXB/bLbHAsnizMF3yeykWUGiKxrsZnzwoTBleuq65TG/9CMSTz/nn9288
         Lcyw==
X-Gm-Message-State: AO0yUKXXLBknRJK3VEDb8MHk/SogbBmkKx5i1konP+LwAwB5nntwvTqF
        +MzdmT2cenJyqeRerkyd/WjH1w==
X-Google-Smtp-Source: AK7set9B8Q1J1wSLeoK466yZOda2aOiXBB8Z7V29/zYEoH/NJEEZWHwJwHamC+M68ZIeAVqqWh2PWQ==
X-Received: by 2002:a17:902:f684:b0:196:3232:f495 with SMTP id l4-20020a170902f68400b001963232f495mr7145375plg.16.1674760725519;
        Thu, 26 Jan 2023 11:18:45 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id je5-20020a170903264500b001896522a23bsm1345894plb.39.2023.01.26.11.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 11:18:45 -0800 (PST)
Date:   Thu, 26 Jan 2023 11:18:43 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: Re: [PATCH net-next 01/16] net: bridge: Set strict_start_type at
 two policies
Message-ID: <20230126111843.2544f7d1@hermes.local>
In-Reply-To: <8886e11bde5874305a26c0b7dc397923a1d5a794.1674752051.git.petrm@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
        <8886e11bde5874305a26c0b7dc397923a1d5a794.1674752051.git.petrm@nvidia.com>
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

On Thu, 26 Jan 2023 18:01:09 +0100
Petr Machata <petrm@nvidia.com> wrote:

>  static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
> +	[IFLA_BRPORT_UNSPEC]	= { .strict_start_type =
> +					IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT + 1 },

Is the original IFLA_BRPORT a typo? ETH not EHT
