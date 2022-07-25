Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FEC580257
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 18:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbiGYP76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiGYP75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:59:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E08012080
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 08:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658764794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tY2aon/f125PpUF2utZCx2LZaCcEv6DZkZmWDwPeZms=;
        b=MKcaqov04xfjtgLisFshHHylv6eNsuUNJNsb8MUHwpvlD88LhBuRpuxgXpCYT59SV5bGMc
        tcboSHwR2yVVwTLC5cC7jdb1mwIoj6Z9GCpeMPN3IZlBQmNCkVKZYVpblu8ws2y9W/cwAm
        tJiSruaEf3Wevbdgj6JqGaDaEL+5nSQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-vISlwUQ9Miau_Bm4s9fmJg-1; Mon, 25 Jul 2022 11:59:53 -0400
X-MC-Unique: vISlwUQ9Miau_Bm4s9fmJg-1
Received: by mail-wm1-f72.google.com with SMTP id z11-20020a05600c0a0b00b003a043991610so4242273wmp.8
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 08:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tY2aon/f125PpUF2utZCx2LZaCcEv6DZkZmWDwPeZms=;
        b=o6b3zV/uD9ax/kuCXUvIxwInknIMF0790mGAzXoU8qCtvP0jO1s60+fLaeyvnT7rB+
         nPPqFbwJcxKicTJyTGZ7vnDLMRMTNeycM5Lc6uo5BSJg+c/9jPOvwBOHz/jLmgStUktv
         Up/f6TvRc4zEisLvkPxlC9HBDE05YYS2kUYXtBwD+hADqrxAYAfGu+k7rz6L8I77UicU
         fepwV8XOHwV3Lj1PhgbbNxVgU89NcwnEiaiJVF9sK9jXYbz36U5x7RCWLM2/vzjHXkt0
         kEAZqhq41W9t0hArjP3evmk2soiIK+Fi2IB9JYAkv/TYOERtqAN1hjtXYO9KrXCEHlgx
         K+5g==
X-Gm-Message-State: AJIora+O0NKjTeQXfxPj396egHrSjfxweymEl0+GPJPV9wArb1RLWOyg
        Kcr0I3hksMYZuVc6S5hLGtf9a8BB53r4c627DSFXKoN2oyrJ9qpG/nTtTACaE/+jjzh+gYgrsjA
        KTW9tqrLR3IGKXlv5
X-Received: by 2002:a5d:47c2:0:b0:21e:37b9:3b0b with SMTP id o2-20020a5d47c2000000b0021e37b93b0bmr8471496wrc.450.1658764792250;
        Mon, 25 Jul 2022 08:59:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ud1B8beje1+rVeYF3sJwS5B0hQU3eYnQhd9GZBmbM1M4Ns7lhVQMyFQQSQeRSi9oM5CqNwfg==
X-Received: by 2002:a5d:47c2:0:b0:21e:37b9:3b0b with SMTP id o2-20020a5d47c2000000b0021e37b93b0bmr8471474wrc.450.1658764791971;
        Mon, 25 Jul 2022 08:59:51 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p20-20020a1c5454000000b003a30c3d0c9csm19132485wmi.8.2022.07.25.08.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 08:59:51 -0700 (PDT)
Date:   Mon, 25 Jul 2022 17:59:48 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        davem@davemloft.net, xiyou.wangcong@gmail.com,
        jesse.brandeburg@intel.com, gustavoars@kernel.org,
        baowen.zheng@corigine.com, boris.sukholitko@broadcom.com,
        edumazet@google.com, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, kurt@linutronix.de, pablo@netfilter.org,
        pabeni@redhat.com, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com, mostrows@speakeasy.net,
        paulus@samba.org
Subject: Re: [RFC PATCH net-next v6 1/4] flow_dissector: Add PPPoE dissectors
Message-ID: <20220725155948.GA18808@pc-4.home>
References: <20220718121813.159102-1-marcin.szycik@linux.intel.com>
 <20220718121813.159102-2-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718121813.159102-2-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 02:18:10PM +0200, Marcin Szycik wrote:
> From: Wojciech Drewek <wojciech.drewek@intel.com>
> 
> Allow to dissect PPPoE specific fields which are:
> - session ID (16 bits)
> - ppp protocol (16 bits)
> - type (16 bits) - this is PPPoE ethertype, for now only
>   ETH_P_PPP_SES is supported, possible ETH_P_PPP_DISC
>   in the future
> 
> The goal is to make the following TC command possible:
> 
>   # tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses \
>       flower \
>         pppoe_sid 12 \
>         ppp_proto ip \
>       action drop
> 
> Note that only PPPoE Session is supported.

Acked-by: Guillaume Nault <gnault@redhat.com>

