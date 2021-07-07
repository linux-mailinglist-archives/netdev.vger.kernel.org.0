Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AC33BE34C
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 08:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhGGG4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 02:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbhGGG4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 02:56:17 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEB7C061574
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 23:53:36 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w22so1260576pff.5
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 23:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9dO6qu6W+sggBKwJuAPJLjJF2cGAq0+eORoykvlURLg=;
        b=LdqPUqDeXeqk28NXNOYUCTQLuAxj8pkYveSg6n+N7tyZEf8SrfeHJfrIQfrNCpnGWb
         s/ecT3F1xD2Xk9vWtRgDCsUCpnjM6BGrxmPR1SH1uGFOJ+8qB4UGAL2jhbYRsUqG61B7
         4y23Sah2USmSEaTw6vv1iPWxRDEFGIVh31N5L98vr8kivzNqHj1lt+7qd3gd5d1gctMl
         +xYE+cgxISx1UWi/S0RHj8K8jQU4AZVkhzSbO+eER9s4dySW7YtDEWviEA7cS7NDxBTk
         zNaR0rE36lIS07AGsxL0bHDLmmO94bPgeQLan6hmlDXHWlVuB2IsmnLfiQuIfdU5/yq5
         9M0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9dO6qu6W+sggBKwJuAPJLjJF2cGAq0+eORoykvlURLg=;
        b=XdBQNKeAiVfrbsD4HVv7mInPJx5CnBMlr2HgGU2eoZpvz/UM6mBCD5M7ZvyR1X2kxp
         2LTNryLPFrJhdpDkp2DL0GDIzCWr/choGC8jg6zPK7CB3KyK6lUkwIrWK0uPpQeBdS4S
         gYEhWyYD9lT7Oql2cGKSoBd/4LZD6YXawDbdGhk4LzHjmViRlZxO0o39ffVtVzycmMl5
         7FOdWstRakUDShG6HNR51zkZjFMbsdohdivs9P+U+7il4OzAA194t72OF6K37nQ8bLMj
         5Yu+/E+UhBiiXlm20JqefFkF6QM4EDAyUmhfVOeaK0o/xk1STgueXK5pie3u66lomj6s
         QAqQ==
X-Gm-Message-State: AOAM5326g9vkmvFKkEbqx/011WfQORZGkCKe8B5XDNO0cpnP8GrU05TG
        OoSu9A6YmsMhMvVpB0GFX9E=
X-Google-Smtp-Source: ABdhPJxYZrKgOud9XMUifO+h35BvWWeFB6IbR4WshjwwuoIVCcJW37pu5e8y3Xho5Ny+N8nqiWnhUQ==
X-Received: by 2002:a62:3344:0:b029:25e:a0a8:1c51 with SMTP id z65-20020a6233440000b029025ea0a81c51mr24187026pfz.58.1625640816273;
        Tue, 06 Jul 2021 23:53:36 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm16487928pjq.5.2021.07.06.23.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 23:53:35 -0700 (PDT)
Date:   Wed, 7 Jul 2021 14:53:29 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
Message-ID: <YOVPafYxzaNsQ1Qm@fedora>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <YOLh4U4JM7lcursX@fedora>
 <YOQT9lQuLAvLbaLn@dcaratti.users.ipa.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOQT9lQuLAvLbaLn@dcaratti.users.ipa.redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 10:27:34AM +0200, Davide Caratti wrote:
> my 2 cents:
> 
> what about using PRINT_FP / PRINT_JSON, so we fix the JSON output only to show "index", and
> preserve the human-readable printout iproute and kselftests? besides avoiding failures because
> of mismatching kselftests / iproute, this would preserve functionality of scripts that
> configure / dump the "police" action. WDYT?

+1
