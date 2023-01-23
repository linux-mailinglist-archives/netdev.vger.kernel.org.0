Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D296782F4
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbjAWRWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjAWRWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:22:36 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB82103
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 09:22:36 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-15f64f2791dso14728589fac.7
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 09:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xfef6yeMmVbsO0sRP+igVc97TuRhY45c/xuGGBv4xGE=;
        b=n9HnoX1eXquZOcMTa2HI4iqEaJ1eIpDozsp3QIv0DZx635PVI84mfpbcRWmez4gXRy
         aQrFBdNSaIppa2GOmDCf9TaifFWxvyRSR48m8ZQePt0BGF4S5nhdbdTRAiBY7U3AxbXd
         DekJMNmnOVl3aB/ODMtxYvn2Aw8yRK5jb/65XK0kDtVJeO0JtKuFt51KEWQ/Ml5VkgCz
         jDk3JI0csSVfraSFZYBJjle/HESlriG1r5zAZwUZKtzmqPO7qtO8TT0eEyACMaGY2DsP
         O8bUS5AP+OV/sypKot6IJzQeL99GFBSJfazAD0sk4SPsFll2Vyj7cWyEZhFiousgwAaz
         gXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xfef6yeMmVbsO0sRP+igVc97TuRhY45c/xuGGBv4xGE=;
        b=Qra3uMYJO4/rjAGIPhvZy+d+UKcwFlqfaP7crqFnMQfnq7syXEqXV60gpFNtKJ81IO
         ykYMIaNgo7oTbjsCbwLQZexpGxRN4Qj1buBUbHZhxy/MsUG0geo+7GKYKD9cIs87S8KD
         roExDt3JwZQioGWNaLl9RCl2xqTfdddoB46g2/IOYhrsK4EKUeHSZAvxGSOl9dehntOr
         led8Ec9QUQJDMtnByfOXcRfgYfD1B5whtZzOzdoA7NmoKaD6XrmoOS/5f1TLIUdP57M4
         4lM9sS96vpnqvY1frh+RzpsMk44dws2S+ouyM+B0ASJR1dxtVaIB0FFQY4Wt5yVhwmPm
         MTeg==
X-Gm-Message-State: AFqh2krGkN3q+D9ru/zZu8yenEFCQwU/qNVUTatcebpuBk6vWUiXAD0X
        6Epf+b1geVSsFr7s9eal9R5Y3U4vGA8=
X-Google-Smtp-Source: AMrXdXu9FE6COV6HzvXT5Spkh3fzSQu/jTMXW3QgTVhOdD86fwz4P0SGAzH7zn/4rmyNcQ45RKjXEA==
X-Received: by 2002:a05:6870:32ce:b0:15b:9460:f1eb with SMTP id r14-20020a05687032ce00b0015b9460f1ebmr26042165oac.37.1674494555353;
        Mon, 23 Jan 2023 09:22:35 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:d30f:6272:a08b:2b30:ac0e])
        by smtp.gmail.com with ESMTPSA id ek40-20020a056870f62800b0015f4d1b195bsm11912293oab.36.2023.01.23.09.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 09:22:34 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 253634AEC87; Mon, 23 Jan 2023 14:22:32 -0300 (-03)
Date:   Mon, 23 Jan 2023 14:22:32 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, jiri@resnulli.us, lucien.xin@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, wizhao@redhat.com,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH net-next 1/2] net/sched: act_mirred: better wording on
 protection against excessive stack growth
Message-ID: <Y87CWGgHk8f0EWfA@t14s.localdomain>
References: <cover.1674233458.git.dcaratti@redhat.com>
 <a59d4d9295e40fe6cfaa0803c5a7cc6e80e7b1a2.1674233458.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a59d4d9295e40fe6cfaa0803c5a7cc6e80e7b1a2.1674233458.git.dcaratti@redhat.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 06:01:39PM +0100, Davide Caratti wrote:
> with commit e2ca070f89ec ("net: sched: protect against stack overflow in
> TC act_mirred"), act_mirred protected itself against excessive stack growth
> using per_cpu counter of nested calls to tcf_mirred_act(), and capping it
> to MIRRED_RECURSION_LIMIT. However, such protection does not detect
> recursion/loops in case the packet is enqueued to the backlog (for example,
> when the mirred target device has RPS or skb timestamping enabled). Change
> the wording from "recursion" to "nesting" to make it more clear to readers.
> 
> CC: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
