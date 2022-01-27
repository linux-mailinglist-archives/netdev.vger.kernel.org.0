Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F6849EDE7
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 23:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiA0WBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 17:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiA0WBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 17:01:18 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B67C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:01:18 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o64so4505251pjo.2
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DuLOpK/6bOLP5bJzyANaAKR7sm5Fatt/GUx6mey6sI4=;
        b=T5s64LBo02tIlt37AZU0dvWZHG7r1vDEuZ/jlIbDx8H+iz7YCHxkZ/J6RBHlPYKZXB
         3EobXbRTO/N+P/jALbHJDXOA8CTR3Wr08GxOvF4L4RlRLEle6ETURjEm7oxzDf2ZYkgE
         V+Pi+pezCw284x1PJkLWYzapQ0M/7ZZJAZBxPAsOVuRBLYWpkjew1gv4XbWabA3S5jxK
         myItiQCo8x8QP5BRO0c8Sqfh5mEchNX7HgcDpSoRxiSmXcb2pKNnKBJdJJIeo31AhzN0
         A5ryUkJlDcS08KvfEwE+/nJv8+bFYsPlHYMbvdwaKKoXYeq3M79pKjtaUWyEbA5Dth/d
         T//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DuLOpK/6bOLP5bJzyANaAKR7sm5Fatt/GUx6mey6sI4=;
        b=vhMAFWclgK24+J63uIBbekMuzMzrDgWVPlYskbW4MwbdrYH8gAPECl/U1n6M9BpkGe
         a2BOx0WzJ5C8js4XUYh35y410JRcfqcmTmwv1l8+1rcWq3ikFxsS2oHRPI/67H0wGa14
         OOQShI5kLBo9R/20kN9L97/Lr1X7r2RAST0ECiTm/Ma++w/x4+AFBwVEX4QkLxaMWotr
         wOT850bwkAPyr/NQrtY7S8etuBLKxN+Zw02D8HN2zcFRA8t3UnqaHJk8tDmeTQI1WGOX
         O3J6Sr57Ux+iD7B17lMaPVleJ84eUwfI9NLB/aiirMNG6kZO9kjUusS1XIBqkiM2rcdj
         VFQg==
X-Gm-Message-State: AOAM530sJXAOlV90ACDw+hqCw0dKg8TeLPL2Fkf2KhQpu3RDeX/prdgB
        CPYTfkVcfRntCLMatBs6sX4eo6phA08=
X-Google-Smtp-Source: ABdhPJwOXqBiLp6X837kBkCFJWRmDJY81BdFhAZpiSGsnVtY60b4UxpVUgW6qYxIvQsH/Lf1W6IHdQ==
X-Received: by 2002:a17:90a:8909:: with SMTP id u9mr6330632pjn.9.1643320878476;
        Thu, 27 Jan 2022 14:01:18 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b22sm6739230pfl.121.2022.01.27.14.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 14:01:18 -0800 (PST)
Date:   Thu, 27 Jan 2022 14:01:16 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>
Subject: Re: [PATCH net-next 5/5] ptp: start virtual clocks at current system
 time.
Message-ID: <20220127220116.GB26514@hoboy.vegasvil.org>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
 <20220127114536.1121765-6-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127114536.1121765-6-mlichvar@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:45:36PM +0100, Miroslav Lichvar wrote:
> When a virtual clock is being created, initialize the timecounter to the
> current system time instead of the Unix epoch to avoid very large steps
> when the clock will be synchronized.

I think we agreed that, going forward, new PHC drivers should start at
zero (1970) instead of TAI - 37.

Thanks,
Richard
