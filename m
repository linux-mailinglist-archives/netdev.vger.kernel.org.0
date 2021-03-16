Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF5333D9A1
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbhCPQk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbhCPQkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:40:16 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFFBC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 09:40:15 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id p8so73229601ejb.10
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 09:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uDwnQpBxKpYlYsvzbZcHi4gPUvE/wvZQ8oBeFGbH7Ik=;
        b=vcgS1LemM9pnnFpmlP6aWtMXz3ClEdAS+x4uH68+DKCLC4l8H1y/V6/YtQKzDHjmIf
         r3twGRNKcQBfqOgyUDiabcVfV+YIXaOtIWGswINMMcXHKmcQT3noqDvr+c+R2Rme7kGS
         FAH+pfAUyVyp5RBQ/IaR7RklfFLOrU8iHVSbSFBG//WihWZBwoI75In3N2TjwiLrj6dV
         uVvS//e+Ijp11yliv/0K/s3A+Av4ScfFVU1wiPiUhYMytmXYvawQjZAefHaGbUdI+iX5
         144ErDzG3YDpBs3vONlXLzAIbwmAOoCvzLq0VZoy1jhq74zhoHcYIg7i4scwYVFyo3w9
         rttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uDwnQpBxKpYlYsvzbZcHi4gPUvE/wvZQ8oBeFGbH7Ik=;
        b=AZQkIw2RSoRYAG9g4fw29rq3By2sn0T87ly+e1w7W0EaFX26Rf4ZN5rtLcjjgRgmky
         otgqXUQjVriTXkLNC0HeLZTpQ13PDQENuG//dzwF9Vy/IHwoNhDiQ7pLgBLLM6QK7M0/
         CaQYJqthPUDqPPYSUd0PSm1TfFa1linvqtrqda6F3UumyPs7hzMQqyhsz/hi3bxLgz/o
         +zPu+byG8czKB0G4xyZ8LNbwhT+rLe5Z2czmtyK2PeYIoGPPOqdcSCRtuMdkZ8M716rf
         rOmCMmahoV7S1sAk81sydGAWxiurtSpz2DkAvA8Gx1zkU2tQ44x49sNS1VB4fjInAf/1
         QJIQ==
X-Gm-Message-State: AOAM532h02/5Xv6B131pZFZa8UCUqfiSrWdmO/mwTwpGgYtte49xoqaP
        56HwNSPNrfu+UE83T96CCMfA4w==
X-Google-Smtp-Source: ABdhPJzRPV0A79J4s29dnocD9YV8f1z1WN77ltFvr5S5UlHjCZE7wBe9cSi26aSWjKEBWy4Mc8EQHg==
X-Received: by 2002:a17:906:dfce:: with SMTP id jt14mr31004655ejc.83.1615912813860;
        Tue, 16 Mar 2021 09:40:13 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id m14sm10309619edd.63.2021.03.16.09.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 09:40:13 -0700 (PDT)
Date:   Tue, 16 Mar 2021 17:40:12 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 net-next 0/3] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210316164011.GC26588@netronome.com>
References: <20210312140831.23346-1-simon.horman@netronome.com>
 <20210312142230.GA25717@netronome.com>
 <2e241510-9020-cf85-4a17-c5f74a59b8a8@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e241510-9020-cf85-4a17-c5f74a59b8a8@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 09:53:49AM -0400, Jamal Hadi Salim wrote:
> On 2021-03-12 9:22 a.m., Simon Horman wrote:
> > On Fri, Mar 12, 2021 at 03:08:28PM +0100, Simon Horman wrote:
> > > This series enhances the TC policer action implementation to allow a
> > > policer action instance to enforce a rate-limit based on
> > > packets-per-second, configurable using a packet-per-second rate and burst
> > > parameters.
> > 
> > ...
> > 
> > Sorry, I missed CCing a number of interested parties when posting
> > this patch-set. I've added them to this email.
> > 
> > Ref: https://lore.kernel.org/netdev/20210312140831.23346-1-simon.horman@netronome.com/
> > 
> 
> For 2/3:
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> 
> If you submit one or two testcases to tools/testing/selftests/tc-testing
> you'll be both a hero and someone committing an act of kindness.

Thanks Jamal,

my team are heroes and are working on testcases.
