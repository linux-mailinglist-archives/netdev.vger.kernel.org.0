Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC7666BC7A
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjAPLJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjAPLJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:09:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B85F14EB5
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673867312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q60r+2VNBYJtckLr6uP8zImm8XdmDd5V/44BH08p1gQ=;
        b=Y9f6pBODct0tdp9O7YReg1MgUtqGkrNhdRxMqUWxPXxLi354wjGan7OPB2NAUEetCU1EfN
        VN3vPmxAphKCBg8+Ii5i+gN99kKELxd7oaC3u/ysBpNjZxW4xB1zwuS15i5l4+ungGTiLJ
        DmCXZMyDucpTgs8HkwU3W7m2Th7CHx0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-478--iUSFrf4N9eePlh-PLEtuQ-1; Mon, 16 Jan 2023 06:08:27 -0500
X-MC-Unique: -iUSFrf4N9eePlh-PLEtuQ-1
Received: by mail-wr1-f70.google.com with SMTP id s20-20020adfa294000000b002b81849101eso5201817wra.16
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:08:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q60r+2VNBYJtckLr6uP8zImm8XdmDd5V/44BH08p1gQ=;
        b=CINBM9g43aXXxaeMuYcjHHeYze0+yPn6BGsC18KegRnd10nOGjFjyIWQpnoejaEbP1
         3I2wlHuGxYVQx/XYC2CnClDdOXew2qPr5fwiduT64KpwilcSRAYWUigJ3ej/iHKtz8E8
         L1SVMFLYVnfd3rFnW2zXzCgnACdIzqhRitL5fVC5CzCa/754CFyI5Oea0CkDILG3h1En
         yOpe9I4sGVEtl11W9gt+vS+XcDEJDQdOiwxMlCW5ZzHONlCgVZdnnGrW+1w6qVPFkGQk
         z/tUpX7EBt48fKPvSM64Q5l/4kfUDwF9P0b4BwJEJNacSYyZT+jhh4HRDUk0lyjmFAsA
         apXA==
X-Gm-Message-State: AFqh2kqPkIx6PHoY9DiC72ZSMQWsSRyyxQ3o3AJ0jmTmdEVVoq2XrLoT
        PFiXZ6B40NdgBbabG/7eU40Z7/7Oy/B2xUdT7NrA41UeeIfw29nNTbmCqORXma27B4+8txTapgX
        4ZVSxb16bLvSXbMmf
X-Received: by 2002:a05:600c:540b:b0:3da:282b:e774 with SMTP id he11-20020a05600c540b00b003da282be774mr7747731wmb.38.1673867305425;
        Mon, 16 Jan 2023 03:08:25 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtjH08/0SDJQ+A3E4lPrP5s0LkWqoiviGeCehqIWiIxA1jXkdqRgrcx3C9UVf2iycBHvoraPQ==
X-Received: by 2002:a05:600c:540b:b0:3da:282b:e774 with SMTP id he11-20020a05600c540b00b003da282be774mr7747719wmb.38.1673867305254;
        Mon, 16 Jan 2023 03:08:25 -0800 (PST)
Received: from debian (2a01cb058918ce0062ec02bb72e8945c.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:62ec:2bb:72e8:945c])
        by smtp.gmail.com with ESMTPSA id ay15-20020a05600c1e0f00b003dab77aa911sm6694371wmb.23.2023.01.16.03.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 03:08:24 -0800 (PST)
Date:   Mon, 16 Jan 2023 12:08:22 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, saeed@kernel.org, tparkin@katalix.com,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com,
        syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net v3 2/2] l2tp: close all race conditions in
 l2tp_tunnel_register()
Message-ID: <Y8UwJkRY1ISej+Zu@debian>
References: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
 <20230114030137.672706-3-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114030137.672706-3-xiyou.wangcong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 07:01:37PM -0800, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> The code in l2tp_tunnel_register() is racy in several ways:
> 
> 1. It modifies the tunnel socket _after_ publishing it.
> 
> 2. It calls setup_udp_tunnel_sock() on an existing socket without
>    locking.
> 
> 3. It changes sock lock class on fly, which triggers many syzbot
>    reports.
> 
> This patch amends all of them by moving socket initialization code
> before publishing and under sock lock. As suggested by Jakub, the
> l2tp lockdep class is not necessary as we can just switch to
> bh_lock_sock_nested().

Reviewed-by: Guillaume Nault <gnault@redhat.com>

