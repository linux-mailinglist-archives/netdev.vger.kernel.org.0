Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B035514189
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfEERei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:34:38 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45031 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbfEEReh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:34:37 -0400
Received: by mail-pl1-f194.google.com with SMTP id d3so1147599plj.11
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 10:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=f09nnxjenSK1TzC8fIlPlR7ckp6k8iyj2V5kYZw8G2s=;
        b=Sw7GroRl4Yrm5RynDS0dSpJZ350BC3egVu4v1QfqEs3ED9lSCvTSCPf5STCqRnmjOM
         VhXAVRLgPYChXjD50zMO+9WhGCOFWtbFSylFiRGfcL46+NPfqDu4i56VJGLk+dHwsYtl
         X/IAUV9vxpcL4EQTsyeUrqwbuJEz7Qc8odKd1vfpOVvg36xyG+M9drEaYSpMoFGCPD8g
         ZnAbhQ/EfNQpVcVgxoXM7Q03/BoQJ8BNa3ZoeoWH0RVtrE0DQUZ3mZq3CTo9CaQNOJF1
         48EqBvC9BwxBQgLb0wbLaC1aMuD4JzNryqAMQFGKWRHvQr/utc2vmLa9vWjL/e4b65pV
         QQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=f09nnxjenSK1TzC8fIlPlR7ckp6k8iyj2V5kYZw8G2s=;
        b=NpqEHyTMRln1D12n39NyjW4e8AqQ+1sCyFl/S5VAy8LZ4Dfm8OC7vZCm+7hYJg90CT
         0O6ZJ2NfI1VOljf3NRsy7R83VMkpb9MHVH1C/JpGXjrJMrBfGbAENr7q8OvmDUaXbXVB
         rsBVQwLJjnsuySmLdi+1UJeAvSCGnWaG3v8W7XG3UoaQz6CxORnHe3nxDht5T1XyhPDz
         TMwDXhNz0lrVTV5y8rs0kX4tMjW5CQlqtf1FF6OlqHoCs45mUQlwNjRzZp4InsfHdl5R
         UvPCFqQGM7fbV+o+d2PW1DStGu0y32iyolyHOSWL9zO02du6i26QMxNxK6CC8txs6q6i
         t+QQ==
X-Gm-Message-State: APjAAAVf/6LpHpHSvPMygBG/MANX+7bR0qAHMfuhCRIojVDsn/kaJ5/p
        iBKKWYYiMUdKwSF37etLmI/w66XLBxk=
X-Google-Smtp-Source: APXvYqx+aBSoWY+hTZRRECrptd2j9Um13avjb5ApeK2KKU1srJnoyqAXKTPVhudVzlCQwDR6fPsoeQ==
X-Received: by 2002:a17:902:7207:: with SMTP id ba7mr25443191plb.329.1557077677043;
        Sun, 05 May 2019 10:34:37 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([2601:646:8e00:e50::2])
        by smtp.gmail.com with ESMTPSA id i15sm11533279pfr.8.2019.05.05.10.34.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 05 May 2019 10:34:36 -0700 (PDT)
Date:   Sun, 5 May 2019 13:34:32 -0400
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 10/13] net/sched: add block pointer to
 tc_cls_common_offload structure
Message-ID: <20190505133432.4fb7e978@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20190504131654.GJ9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
        <20190504114628.14755-11-jakub.kicinski@netronome.com>
        <20190504131654.GJ9049@nanopsycho.orion>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 May 2019 15:16:54 +0200, Jiri Pirko wrote:
> Sat, May 04, 2019 at 01:46:25PM CEST, jakub.kicinski@netronome.com wrote:
> >From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> >
> >Some actions like the police action are stateful and could share state
> >between devices. This is incompatible with offloading to multiple devices
> >and drivers might want to test for shared blocks when offloading.
> >Store a pointer to the tcf_block structure in the tc_cls_common_offload
> >structure to allow drivers to determine when offloads apply to a shared
> >block.  
> 
> I don't this this is good idea. If your driver supports shared blocks,
> you should register the callback accordingly. See:
> mlxsw_sp_setup_tc_block_flower_bind() where tcf_block_cb_lookup() and
> __tcf_block_cb_register() are used to achieve that.

Right, in some ways.  Unfortunately we don't support shared blocks
fully, i.e. we register multiple callbacks and get the rules
replicated.  It's a FW limitation, but I don't think we have shared
blocks on the roadmap, since rule storage is not an issue for our HW.

But even if we did support sharing blocks, we'd have to teach TC that
some rules can only be offloaded if there is only a single callback
registered, right?  In case the block is shared between different ASICs.
