Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332721C6035
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgEESgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbgEESgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:36:46 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7744C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 11:36:45 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r26so3490011wmh.0
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 11:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sJPpDHeX2aoj+DGjkdKLPpH7q4rX80l4P9E7ER8uxmk=;
        b=0bBF1w2qPmFKDoAvPl8cy0F5j2WmIPAuIaFEznkGyRy/zIBAhYwu7yFuLrQHXqWE1U
         8hj/XhBHaP8UoaN14tlFc4RZGA3C7xfLd4ZM9pKbAv0q42PsAJNYGinGOPUvgQOrlOoA
         TWbZagugd+34BAKsy1pLLMg0+QvkpVhTH76lRCQCOLkbVYw25f1lCUj4NRCO09XdLq6V
         wRmvZCc+Eidg2qkLVed25fGJwvS6Kuj9PN85aDMl2/4uzdxo/EkP+VtqzGGuRu6VLcgP
         AdgK69dAgnrEc3f7WLg05lwRBxlS8phIOY9mURdY+dqMaOfJ8EmDgOFc76jm0VujcieU
         2nSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJPpDHeX2aoj+DGjkdKLPpH7q4rX80l4P9E7ER8uxmk=;
        b=Gzfn4CwnHfZ1UA/8QaIQfaaS86YrAYrSGirPfggKB0sd5FUzKdZ+LCML8CrTTbPYna
         Ztq9je6HmCUFkf7jTpWpTRJgQgxD0DdTvaZvVaksIzaKe2hvf4ScbbfqlXU8P9VJ7FuM
         c5WGP5lrYGM/kuqXdSEMSEHoBKZ02hP6796Fkbm9bcmaM4mT7aLfiznPP5kDWb6PS5LP
         fuxWEHnVfaYJAnLAIUGQwiVj/ysiQjMcqvGVnve28sjGu1pB826fhkaBOXzpzFrzz3Y2
         tPvbGDKroUk+dFY5Y/ONVcqL4HKi5G53CiSR/LJm5rFGr3xNBfo0bjBr2JUR/YiuOZhj
         FQMA==
X-Gm-Message-State: AGi0PuYnGnTeShK7psBIEwR8+UD76BZzd8SXKxjSiTrUUe/HfrbVWtjK
        Us4SWpf5nfLZvMJi7y2FsIyWfg==
X-Google-Smtp-Source: APiQypJiIfTBLt/aj4qgymQlu59qSNxm77/D0iTgA/c+OxvvZz/BO8MtU9qB42NqDwaQY+DmS5pAaA==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr4515133wmi.187.1588703804607;
        Tue, 05 May 2020 11:36:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o129sm5341367wme.16.2020.05.05.11.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 11:36:44 -0700 (PDT)
Date:   Tue, 5 May 2020 20:36:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, ecree@solarflare.com, kuba@kernel.org
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505183643.GI14398@nanopsycho.orion>
References: <20200505174736.29414-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505174736.29414-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 05, 2020 at 07:47:36PM CEST, pablo@netfilter.org wrote:
>This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
>that the frontend does not need counters, this hw stats type request
>never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
>the driver to disable the stats, however, if the driver cannot disable
>counters, it bails out.
>
>TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
>except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
>(this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
>TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
>
>Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Looks great. Thanks!

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
