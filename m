Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE0463901D
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 19:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiKYS6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 13:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKYS6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 13:58:44 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A708220F6
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 10:58:43 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so8434981pjs.4
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 10:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HjYL6ZT4lKatbPUBunDTrV1IleI1sbAeMGkGHFpgYBI=;
        b=HXnEK5qDOiKS2MacTjw9KzBHJNAXDR3mYfQOYn0V+Y8J0ZgiWvZkW7RkB5Yn5TpXbl
         pvSXf94l5bnnnGH9eqfhm/gsj7H5NtpQ7V5t9D+ho8M98AabARjRpXi2BpOSw4YRHp9y
         6qrKBHwbaGRIaQ1yYFJ0cw+oJ8RftcTg2AtIfC5n4/Sxz/B9K19RCwBnkAerEugriU3v
         3r5lRJ/u3CIqSVk+AKcyEIvq2Wxue0o9ktj18rCtw09kZJRN1YU5BPQoXd5bQ1apqsju
         69y0d1ERU8fY5qJLKNj6b427sm/UkDYw8QaziCpjU6OMU0bR6jn0Sk6FT3NIaAJ9qHQQ
         nMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HjYL6ZT4lKatbPUBunDTrV1IleI1sbAeMGkGHFpgYBI=;
        b=L2VkeITMco+GBCigSFxy5Ep0gHIDYyL9iVtzBIAqoEThDl+WL3DfrYJ2z9htO0hBs0
         l99DM8J8lrZzWA+ryMFst4kshMjRy9JF1h1NsyASOH3U2/78gqv3CRXNQEY1R1XQtD0A
         05yFxohfAh2pq8BHrOAEQMNsjjk1WxkH7MTLPIs/TPe/f0Fcwbpv2MsQNXxZZ+cE0qyW
         I6O+pH9fH6ookRmw+K2VvhZ6KbK5i2MIo3LGU0h292XZREjCCJh48hAqZ8KaXylLqmGW
         r+Ut4d+xwQjHGwvfhPwe9huHCJlxmuc98eMtdges/VhupltA9aBHSWu2l8GtdDxMJaOB
         zV2w==
X-Gm-Message-State: ANoB5pk1f7WoObSI/I9YoJuBtTo/eQfdUU6bm5kGr631SlOsAzg2k6H7
        RY9VS3doAfzuxeum9lfX4xLL02OKAPQB15TH
X-Google-Smtp-Source: AA0mqf7E8QpByv2uPZM7Rss6U9DWJcdHh5J61hpLu5+AxqUccN7gGAbY+uArWQaBBL57A5V2SEkHfg==
X-Received: by 2002:a17:903:230b:b0:189:6cb1:a65e with SMTP id d11-20020a170903230b00b001896cb1a65emr2409619plh.125.1669402722680;
        Fri, 25 Nov 2022 10:58:42 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id iz15-20020a170902ef8f00b001714c36a6e7sm3677127plb.284.2022.11.25.10.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 10:58:42 -0800 (PST)
Date:   Fri, 25 Nov 2022 10:58:40 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [patch iproute2] devlink: load ifname map on demand from
 ifname_map_rev_lookup() as well
Message-ID: <20221125105840.3f598bc3@hermes.local>
In-Reply-To: <Y38rQJkhkZOn4hv4@nanopsycho>
References: <20221109124851.975716-1-jiri@resnulli.us>
        <Y3s8PUndcemwO+kk@nanopsycho>
        <20221121103437.513d13d4@hermes.local>
        <Y38rQJkhkZOn4hv4@nanopsycho>
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

On Thu, 24 Nov 2022 09:28:48 +0100
Jiri Pirko <jiri@resnulli.us> wrote:

> Mon, Nov 21, 2022 at 07:34:37PM CET, stephen@networkplumber.org wrote:
> >On Mon, 21 Nov 2022 09:52:13 +0100
> >Jiri Pirko <jiri@resnulli.us> wrote:
> >  
> >> Wed, Nov 09, 2022 at 01:48:51PM CET, jiri@resnulli.us wrote:  
> >> >From: Jiri Pirko <jiri@nvidia.com>
> >> >
> >> >Commit 5cddbb274eab ("devlink: load port-ifname map on demand") changed
> >> >the ifname map to be loaded on demand from ifname_map_lookup(). However,
> >> >it didn't put this on-demand loading into ifname_map_rev_lookup() which
> >> >causes ifname_map_rev_lookup() to return -ENOENT all the time.
> >> >
> >> >Fix this by triggering on-demand ifname map load
> >> >from ifname_map_rev_lookup() as well.
> >> >
> >> >Fixes: 5cddbb274eab ("devlink: load port-ifname map on demand")
> >> >Signed-off-by: Jiri Pirko <jiri@nvidia.com>    
> >> 
> >> Stephen, its' almost 3 weeks since I sent this. Could you please check
> >> this out? I would like to follow-up with couple of patches to -next
> >> branch which are based on top of this fix.
> >> 
> >> Thanks!  
> >
> >David applied it to iproute2-next branch already  
> 
> Actually, I don't see it in iproute2-next. Am I missing something?
> https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/log/
> 
> Thanks!
> 

It got confused with something else. Applied to iproute2 now.
