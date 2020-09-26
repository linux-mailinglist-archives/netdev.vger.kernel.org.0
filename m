Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3C1279BD0
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 20:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgIZSSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 14:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgIZSSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 14:18:23 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24234C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 11:18:19 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l17so5796939edq.12
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 11:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wBow5xHk0alTRAIYGKb1jBDdJ8h7ybDbw5MR54nuyX4=;
        b=CUH604KWw3DZlvBv4po+i38CnWcCKtt2xXw5ft1PZgE4oDL4tpxsdqauHVanIhlwiv
         ZEmr1RcSR/udoy8CX05GcbLEopp6vUzJICdJNzXnlk7b4PrKwp7oyfgO3epHeJW7TJuz
         ugHHeH31q8phG6e1bR7gK4GaAgBDxpUN+zO/CEpXBCezBBfuGCw3+RC1HxuBcU84oMLI
         +IM2kT+NLluWNPXfex9FZclaE1O93FMZ/p6lhtlKrbW11xVo7Gli7ozUEJAzAmKAfxCM
         yF/ZLtxEqV7dcpqsAfb7Rq3KEo3iSaYiLHPkclU5Pkv6goGw22y+McfkxpLDjvNKCCSp
         ELmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wBow5xHk0alTRAIYGKb1jBDdJ8h7ybDbw5MR54nuyX4=;
        b=F51E6DXi/6QPc81sXBILIBGg8YEfg5fVdDpOnt+wgSaRITQG+/dbE+79+6tl06ixrz
         3oiqACGOw5yqfwERnQcG36/EzfJO0j1ley20iWPhXtWegmTTJ/4K5MJltSODeg69TMY7
         jwf62lQb0J/ppRSYcV01zpP6OMgUBTKCQ7chnHsfLz136tfpWP3Wfje1u4JzYJR0o7/i
         2sC2OECXMNdF2QC1hIX1XnrqhFwy9Flfvc4KHBJiDWziueRJG1+rlRqG4c8KmQN0Jwqb
         ra3el71F0ghwLtJzLg6TQDXBSMMc5/OvAOsEpmAeAlO7Q45QOnAky2KQeDRAG6clvBKs
         f1oA==
X-Gm-Message-State: AOAM5312xmmQzblman/SoRBEddOKENioYL8dpxmOnN101CjOBl9lUy3e
        8pNGMf/wSvii5oucf+iAjtghk5Q50QA=
X-Google-Smtp-Source: ABdhPJzr18JlgkCakJzAdKu3hVz0yr7tlftrCrI8VXsmeK1b9cg0Qlp70PtY1SN/y1b3N7vMRcvb+A==
X-Received: by 2002:a05:6402:144c:: with SMTP id d12mr7903777edx.168.1601144297682;
        Sat, 26 Sep 2020 11:18:17 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id mb16sm4576415ejb.45.2020.09.26.11.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 11:18:17 -0700 (PDT)
Date:   Sat, 26 Sep 2020 21:18:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net-next 06/16] net: dsa: add a generic procedure for
 the flow dissector
Message-ID: <20200926181814.frtajym5dem4byx4@skbuf>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
 <20200926173108.1230014-7-vladimir.oltean@nxp.com>
 <20200926180545.GD3883417@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926180545.GD3883417@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 08:05:45PM +0200, Andrew Lunn wrote:
> Given spectra and meltdown etc, jumping through a pointer is expensive
> and we try to avoid it on the hot path. Given most of the taggers are
> going to use the generic version, maybe add a test here, is
> ops->flow_dissect the generic version, and if so, call it directly,
> rather than go through the pointer. Or only set ops->flow_dissect if
> the generic version cannot be used.

Agree about the motivation to eliminate an indirect call if possible.

The situation is as follows:
- Some taggers are before DMAC or before EtherType. These are the vast
  majority, and dsa_tag_generic_flow_dissect works well for them. We can
  keep the .flow_dissect callback as an override, but if this is absent,
  then the flow dissector can call dsa_tag_generic_flow_dissect
  directly.
- Some taggers use tail tags. These don't need any massaging at all. But
  we need to tell the flow dissector to not call
  dsa_tag_generic_flow_dissect if it doesn't find a function pointer.
  I'm thinking about adding another "bool tail_tag" in struct
  dsa_device_ops, for this purpose and not only*.
  *Usually tunnel interfaces need to set dev->needed_headroom for the
  memory allocator. But DSA doesn't request that, and needs to check
  manually in the xmit function if the headroom is large enough to push
  a tag. BUT! tail tags don't need dev->needed_headroom, they need
  dev->needed_tailroom, I think. So I was thinking about adding this
  bool anyway, to distinguish between these 2 cases.

What do you think?
