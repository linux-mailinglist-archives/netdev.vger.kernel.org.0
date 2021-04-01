Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71F53518AC
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhDARrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235122AbhDARmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:42:17 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32ACC02FEB1;
        Thu,  1 Apr 2021 09:25:07 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id x16so2807715iob.1;
        Thu, 01 Apr 2021 09:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=QZAzGw5cAuzFncKhsA5KKXaUsF0O+/nPG6lugtZwnpA=;
        b=Ut8lxiYJjz1KZOfwAMhO+g/2mqpm5XorxQ2F8c/6rapd0RukkW5Ax7UPdC6AyIeAG8
         RSE8ZTauPT29yMddEVsSUb3FsKHkqyvGMrPjJGQ7NWL7P+VltGOHWCs/26jeWTOs4pCQ
         GqU0XVj4h+mYr8QPcKUMwT+Jm8m3Lt6HZhdOUQ4MRKewdX1nIcUEKxgv8FbwsyL2va0T
         7Ch4968Wj80Nc/S7D8TVpWAOUWWzgIx4rG5iAg4QohnOEpA2EuRbak282cwbn+I9n1/H
         N4miA1S0vmGjL8amqThicqPVaibChDBlHisX5Nb1SfFveTLAdvRU5gZQEMf831PVHrxV
         uPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=QZAzGw5cAuzFncKhsA5KKXaUsF0O+/nPG6lugtZwnpA=;
        b=HhxZVyNAL3GABygBdr0q0DopEtUMtIYLAsGHqmYOS79PHxbygeAsTgE8DgaMowOslL
         FdmkcS9UCMPY5wt2yS3xDajLALl/516S/WwlSZrHCXynEtQo0aS1HmjPelp6zUlXZMt2
         vMjkvCJvEqN8q7tjI7bZf7MNOl7oPBY8rsDj75l1bQIPIyekBlmA8bm30d+tnXl/F+lO
         0WDF5eQbL38XNYVhGe0nb66m3UDSg4t/yPnk87JRiv8kwvxTtKz8JoyGANVLC003UqXC
         wA10Ydn7hex107Xl+iTC6s4XKcovzWdkdHagLVQU0AidsgfRB6HXrW+AH8ZNzSs9tMwk
         Eokw==
X-Gm-Message-State: AOAM530EsdM0D+qcek4JwbdFx5pRmeOvMkaBu+2RQiJD8t35JFDvTFK+
        X+rM63ZPSYZwMzH/o6MB+Q0=
X-Google-Smtp-Source: ABdhPJwm5qc3c1ZsCEVxdPoR9B3vWt8yT57uFcZN2VW4mTt6Oo4cJADImzmp1X1YtdqxSlyWy6BuOg==
X-Received: by 2002:a05:6638:3399:: with SMTP id h25mr8714141jav.15.1617294307095;
        Thu, 01 Apr 2021 09:25:07 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id l14sm2780151ilj.14.2021.04.01.09.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:25:05 -0700 (PDT)
Date:   Thu, 01 Apr 2021 09:24:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6065f3da5b75e_27eb2081c@john-XPS-13-9370.notmuch>
In-Reply-To: <20210331023237.41094-14-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-14-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v8 13/16] udp: implement udp_bpf_recvmsg() for
 sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> We have to implement udp_bpf_recvmsg() to replace the ->recvmsg()
> to retrieve skmsg from ingress_msg.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

Acked-by: John Fastabend <john.fastabend@gmail.com>
