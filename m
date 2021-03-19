Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEC4342072
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhCSPCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhCSPCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:02:37 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB860C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:02:36 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id l4so10215761ejc.10
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vUoOu7agSTM4o48gPJLYLcyZ5QlQnr4TzAJ4RXshIiA=;
        b=JinUrHEY3FUG3OBWYgdkbr0nNigXWVhQbYi/zz2Lyw2IQscLLz+ylaA59Vz2ZQIaj2
         XFWDWbhnWISuQXmnhJ37LtdkNW00EcCi7y6vq1DmMb9OsXX+aEjgyJpHFwqTHeVXhOl2
         uK+Qa21XBNANTUm/wEPUOZga/pcdojyhH1bTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vUoOu7agSTM4o48gPJLYLcyZ5QlQnr4TzAJ4RXshIiA=;
        b=D8TGGsWVZIk9pY8zpq376gLbJQ110hfQ4ENpIJNgdpwvrvFlJCQyxlZcufBvtvH8yG
         9iF2g7L7NHX7UUA5xoA/y7yLuGN1cRypDUiFb9TvJzSKyDsleBQgCZdjWNGJfaXYThoI
         l4O8ct0EgxbLRzVRcDbGPBax4fXUmWSdXqfdJsvCKzXJCCvFcJkpc7itXdDFEn//YFl5
         9tJshdUdBCAaNJ9hrwqhuXyf/E2Y9xXZQ0TFRTQL8WempSFax9ZjjSwWIBtzkZiVOgo0
         k2PQggAsr04o/SBVt28LWrtHrXpOIUbM8jvRT8JVXWuywTPGd7Lf2AlG8O0biD0G/Wgu
         7MeQ==
X-Gm-Message-State: AOAM5300MFX0NG4t5pZrUvbOg0HZsYkzCIOlka4FhTXShR/SoMntWAuw
        r6eBNaLiQa0xmwJMcsEesbKA3Q==
X-Google-Smtp-Source: ABdhPJyUA/30/66Jrqj8l7qBqYGrm5xt5nwCoPgbzhEV3H6DWZV55EC2udDYKycYf6M3J8cLgJ5CmQ==
X-Received: by 2002:a17:906:7f01:: with SMTP id d1mr4992321ejr.136.1616166155402;
        Fri, 19 Mar 2021 08:02:35 -0700 (PDT)
Received: from localhost ([2a01:4b00:8432:8a00:fa59:71ff:fe7e:8d21])
        by smtp.gmail.com with ESMTPSA id sb4sm3858358ejb.71.2021.03.19.08.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:02:35 -0700 (PDT)
Date:   Fri, 19 Mar 2021 15:02:34 +0000
From:   Chris Down <chris@chrisdown.name>
To:     linux-nfs@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] SUNRPC: Output oversized frag reclen as ASCII if
 printable
Message-ID: <YFS9CuBO/FxJdRGB@chrisdown.name>
References: <YFS7L4FIQBDtIY9d@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YFS7L4FIQBDtIY9d@chrisdown.name>
User-Agent: Mutt/2.0.5 (da5e3282) (2021-01-21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey folks,

Let me know if you'd like more evidence that this is a persisting problem. Also 
more than happy to change the generation of the whole debug string to go into 
svc_sock_reclen_ascii or use LOG_CONT if you'd prefer to avoid the multiple 
ternaries (but the latter probably needs some thought about how it interacts 
with ratelimit).

Thanks,

Chris
