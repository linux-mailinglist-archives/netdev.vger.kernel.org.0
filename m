Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C86A63A444
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiK1JIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiK1JIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:08:07 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0D595A9
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:07:51 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id d20so3743899edn.0
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ViIKoc45Vm0AFR8dYL3TB1QqTQuw7vaNQlI/pxTf3Hg=;
        b=ogDL2YlqkEEg646tr3KbuxKVYeg5GyRD3+Cbup257WSwPKizKqTMdlp/k+oubXlFOu
         3obecfWY3u0yS81jC8YOka59Hskl8u86tOWjedOm2aZksjtRUb0a92KRsyTA7cdvu9pV
         gRmO91AiwFjeC+GntRKiN5XWZdIYqJUhd2KqwJj6a3+gEOLKhANB76vbY+9tIIG4YqSn
         zKxzix4jFHdUEAO+fSseMiJyMjgul9SB6Ml212OSeRW7IJQdVIutuX338LpJLWQhc0Kk
         1Ke0XniEzTuvsHfszECVjc5XoFGKKfGdJaDFif4tUtUydXyPyI/C+PQf6JuDQHxJkSWt
         UXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViIKoc45Vm0AFR8dYL3TB1QqTQuw7vaNQlI/pxTf3Hg=;
        b=Gnx1TRlsj6wr8mdRv93iH8mbiZibjaOA171Nnts7pfH4pT7+vJQCpJKfZQmZMrOfE0
         jv65jRA8DNGFTmqAXhMyDruKRMfYh4OfSef/DQj1/eoqG/wHQBbVh8TrZBUVUBTT08Uu
         u6lmIeUx41EK6ukBOk6trdgnZ8ZGZMQl44zenLfyNIwCZZoaYxF7o8rVSfpD7MHaMJkM
         HB8cYjAZLouRJGmtAM21wZVMetCDYxrnVPD7T/4OU2YDeyrlf6t60mvqWz6h0b58Lswk
         r1Zt9YljRj8t9Y00gz1JV5SAnhxELXFZt/ZvXy/C2ET5JH/pLR+/2qx7TREvc9AbQ8g2
         D9tw==
X-Gm-Message-State: ANoB5pk9datwKYHUro/O7ZKDZUC1xVZQkopSF2OtFixF/hYm/DUaGDnt
        81NgD5VPMzj/ubMl+1l9uPe6bg==
X-Google-Smtp-Source: AA0mqf5COGv1u3rNB4x63gCc+GEUxs2b/erLwuAGS90IXf0CcsQdG9chhGI8uRamPyPHX1+eR/CltQ==
X-Received: by 2002:aa7:dbc7:0:b0:45f:b80f:1fe8 with SMTP id v7-20020aa7dbc7000000b0045fb80f1fe8mr44584020edt.118.1669626469881;
        Mon, 28 Nov 2022 01:07:49 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i10-20020a05640242ca00b00467c3cbab6fsm4963371edc.77.2022.11.28.01.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 01:07:49 -0800 (PST)
Date:   Mon, 28 Nov 2022 10:07:48 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [patch iproute2] devlink: load ifname map on demand from
 ifname_map_rev_lookup() as well
Message-ID: <Y4R6ZDklQcnDz98x@nanopsycho>
References: <20221109124851.975716-1-jiri@resnulli.us>
 <Y3s8PUndcemwO+kk@nanopsycho>
 <20221121103437.513d13d4@hermes.local>
 <Y38rQJkhkZOn4hv4@nanopsycho>
 <20221125105840.3f598bc3@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125105840.3f598bc3@hermes.local>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 25, 2022 at 07:58:40PM CET, stephen@networkplumber.org wrote:
>On Thu, 24 Nov 2022 09:28:48 +0100
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> Mon, Nov 21, 2022 at 07:34:37PM CET, stephen@networkplumber.org wrote:
>> >On Mon, 21 Nov 2022 09:52:13 +0100
>> >Jiri Pirko <jiri@resnulli.us> wrote:
>> >  
>> >> Wed, Nov 09, 2022 at 01:48:51PM CET, jiri@resnulli.us wrote:  
>> >> >From: Jiri Pirko <jiri@nvidia.com>
>> >> >
>> >> >Commit 5cddbb274eab ("devlink: load port-ifname map on demand") changed
>> >> >the ifname map to be loaded on demand from ifname_map_lookup(). However,
>> >> >it didn't put this on-demand loading into ifname_map_rev_lookup() which
>> >> >causes ifname_map_rev_lookup() to return -ENOENT all the time.
>> >> >
>> >> >Fix this by triggering on-demand ifname map load
>> >> >from ifname_map_rev_lookup() as well.
>> >> >
>> >> >Fixes: 5cddbb274eab ("devlink: load port-ifname map on demand")
>> >> >Signed-off-by: Jiri Pirko <jiri@nvidia.com>    
>> >> 
>> >> Stephen, its' almost 3 weeks since I sent this. Could you please check
>> >> this out? I would like to follow-up with couple of patches to -next
>> >> branch which are based on top of this fix.
>> >> 
>> >> Thanks!  
>> >
>> >David applied it to iproute2-next branch already  
>> 
>> Actually, I don't see it in iproute2-next. Am I missing something?
>> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/log/
>> 
>> Thanks!
>> 
>
>It got confused with something else. Applied to iproute2 now.

Okay, fine now. Thanks!

