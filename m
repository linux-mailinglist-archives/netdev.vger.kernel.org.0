Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26D55F81CC
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 03:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJHBLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 21:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiJHBLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 21:11:42 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958DEB5177;
        Fri,  7 Oct 2022 18:11:41 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id cn9so3770572qtb.11;
        Fri, 07 Oct 2022 18:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jszy2riEWK0QKU2jD21ZuCdOx+foIRcPv2tuQxk3bR4=;
        b=NOIUivc9l8lmKntU/P6J3aF16+vIK+Qa1yBhQO50yGgbeJ6z3+KV6QGMtoUenJ6++r
         awSlIKMKjRNW3bE3GMZKtpc/+9H3VKXeW5CmAYf4vmnAGqSjRgP1MOasocCBd8GikffV
         0ZfsLH4YwTZIS7K94qBo4EsFUXha4e4MMz6kkC8cGQQmvIL0eom+zQMM/eWvc+nFW280
         tlTQv0D2kUmr3pF87+PocDmbqJhKTAiUIiwRZCf8QBtR18D/BEJPjJCfgUlEI703vzLX
         UqpZ8+FPZ4WyTscS+1vbqBSKRIj7AEV4hhxsndm69yptGWChBP0q9YDAba7uUN5Ajd8x
         9wow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jszy2riEWK0QKU2jD21ZuCdOx+foIRcPv2tuQxk3bR4=;
        b=RATrYL0eCkjhsXliUB2xLjNObh3Ctt6+teIe5cCO58D5Ub3JR6gj4+1dr7F8O4+aaR
         GNGjdnWrN2YgsTQX9sIS+kj1gWPv/Mc/XvwdCOf1aPuXqKcrkFZBEOWgSHZs4tN7joYI
         M15MVWCdESUCAhovOmNMNh+wFgN1uIYrllLhdVXWJLrVdXIzJz6EKp75zbVluMQBaZyR
         4lsNmGx+x0p0YG4CkKbYBCOM0dNKfk2JLspGVg67vNBK+U6y8gxyC8z6Uhuz0U+WAkRM
         HTWuvPL6qW1v0799jcHYFxIAg3kAKLiTg8Hu4rB1yJNyAfqkVu13QfGrUtqEq80naOmD
         AgHg==
X-Gm-Message-State: ACrzQf2dgbgOO64+QdQ2a4o9PBydvYkUUq2/PXbcgLttIaedFaSNo0e6
        Hd9fYzxx2cdJMwbf5RvlyQ==
X-Google-Smtp-Source: AMsMyM7F+/VTUgoRwbh2EqB9BnZZpiBHTbHVl6FWyJJ8syhTK4UsW4cO4T5/fOmnnkXEySzra0Wy2Q==
X-Received: by 2002:a05:622a:5a0b:b0:35b:b8fc:874f with SMTP id fy11-20020a05622a5a0b00b0035bb8fc874fmr6602579qtb.267.1665191500755;
        Fri, 07 Oct 2022 18:11:40 -0700 (PDT)
Received: from bytedance ([130.44.212.155])
        by smtp.gmail.com with ESMTPSA id k11-20020a05620a0b8b00b006cbc6e1478csm3327947qkh.57.2022.10.07.18.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 18:11:40 -0700 (PDT)
Date:   Fri, 7 Oct 2022 18:11:36 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/sock: Introduce trace_sk_data_ready()
Message-ID: <20221008011136.GA3632@bytedance>
References: <20221007221038.2345-1-yepeilin.cs@gmail.com>
 <202210080809.2SksgA1D-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202210080809.2SksgA1D-lkp@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 08, 2022 at 08:38:06AM +0800, kernel test robot wrote:
> ERROR: modpost: "__SCT__tp_func_sk_data_ready" [fs/dlm/dlm.ko] undefined!
> ERROR: modpost: "__tracepoint_sk_data_ready" [fs/dlm/dlm.ko] undefined!
> ERROR: modpost: "__SCK__tp_func_sk_data_ready" [fs/dlm/dlm.ko] undefined!
> ERROR: modpost: "__SCT__tp_func_sk_data_ready" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
> ERROR: modpost: "__tracepoint_sk_data_ready" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
> ERROR: modpost: "__SCK__tp_func_sk_data_ready" [fs/ocfs2/cluster/ocfs2_nodemanager.ko] undefined!
> ERROR: modpost: "__SCT__tp_func_sk_data_ready" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: modpost: "__tracepoint_sk_data_ready" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: modpost: "__SCK__tp_func_sk_data_ready" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> >> ERROR: modpost: "__SCT__tp_func_sk_data_ready" [net/tls/tls.ko] undefined!
> WARNING: modpost: suppressed 11 unresolved symbol warnings because there were too many)

Similar to [1], we need EXPORT_TRACEPOINT_SYMBOL_GPL() in
net/core/net-traces.c for modules.  Will fix in v3.

[1] https://lore.kernel.org/netdev/20171023.050836.1983843564876160779.davem@davemloft.net/

Thanks,
Peilin Ye

