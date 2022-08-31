Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCC5A7B4E
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 12:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbiHaKYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 06:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiHaKX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 06:23:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268E9AB19A
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 03:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661941437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tsS+L2YjkO3WVV5HkYObnWDH4T6ckh7IBFMzdt529zs=;
        b=POe7mHvCQ8ti69OTHqWHvn2WcVfz6ei5HLZzjGnMBTBZTP8+DTYdKiZFv3p35+6cFm24jF
        c5iuU4hLFvgLI1OD26tYotALeK4uFHB00/uaAd9eipjZGXTygedn61j6IpN1erkWgni8I2
        Bt1ozcPKgdjhkXEw0CEnViuPgeYGBEg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-475-epqFyHyyOuOFLX2rywR3Jg-1; Wed, 31 Aug 2022 06:23:56 -0400
X-MC-Unique: epqFyHyyOuOFLX2rywR3Jg-1
Received: by mail-wr1-f72.google.com with SMTP id v17-20020adfa1d1000000b0022574d4574aso2269946wrv.22
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 03:23:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tsS+L2YjkO3WVV5HkYObnWDH4T6ckh7IBFMzdt529zs=;
        b=j9JZCcE4QV3Xx5+Y2J6gB45TQonOXZpwIpKHZ6SzTnYB9jfU3UjX9radNXgI/NpRaJ
         ONbfeSH7RXI130h8yZUOANiUnU2dG0yIkxZajgB/sIfRRfYctyhoy3W2YJ4j4lbF7Qdi
         jg1IYiVeL0cNv3g2cdwF5E5LRVm5Tg6v7xlrjlN9X30VkPcigyzEQlbOiGh+UkXmhj38
         JB5hZX9QtAM9y3KanFcZiuIdv+ARFOIxYxOX1wnpw6Csj2sl7Cz7j+cjnswhUJnRhtv6
         lmDTfvdO4SmsXQY2YpplblQ6B3srkUXUAnFEYYvtXfc8ZenXduPDeGE3XhY+h6ldE6Eo
         Rh6Q==
X-Gm-Message-State: ACgBeo0PCYZaTH6KQW1HJ+PMbquiW70XxtlFqRvJgHBUCZZ58c30rUnT
        iN0DLHH4HvM2qtCcQJ1sKNsXM9xpRGf1Pt+aKDC6GgPjX02QNP2H/iw0XbWmDzw4IHd0RZEvavd
        rZrMJ/Pk1cc1W7bqy
X-Received: by 2002:a5d:6b49:0:b0:225:6e92:22f5 with SMTP id x9-20020a5d6b49000000b002256e9222f5mr10878287wrw.529.1661941434986;
        Wed, 31 Aug 2022 03:23:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4MTk4YJKv8LPNAZQ8lpm7FcWbRB4lTOKVM8J9PDWuEDMAYwn7MnJgFAQ5hDogEwUWYw+1Zyw==
X-Received: by 2002:a5d:6b49:0:b0:225:6e92:22f5 with SMTP id x9-20020a5d6b49000000b002256e9222f5mr10878260wrw.529.1661941434821;
        Wed, 31 Aug 2022 03:23:54 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id a15-20020a056000050f00b0021f0af83142sm11936974wrf.91.2022.08.31.03.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 03:23:54 -0700 (PDT)
Date:   Wed, 31 Aug 2022 12:23:51 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, marcin.szycik@linux.intel.com,
        michal.swiatkowski@linux.intel.com, kurt@linutronix.de,
        boris.sukholitko@broadcom.com, vladbu@nvidia.com,
        komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH net-next v2 3/5] net/sched: flower: Add L2TPv3 filter
Message-ID: <20220831102351.GC18919@pc-4.home>
References: <20220829094412.554018-1-wojciech.drewek@intel.com>
 <20220829094412.554018-4-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829094412.554018-4-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 11:44:10AM +0200, Wojciech Drewek wrote:
> Add support for matching on L2TPv3 session ID.
> Session ID can be specified only when ip proto was
> set to IPPROTO_L2TP.

Acked-by: Guillaume Nault <gnault@redhat.com>

(I'll stop reviewing here since I have no expertise in ice driver
offload).

