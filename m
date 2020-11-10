Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570312ADEEC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKJS7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKJS7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 13:59:17 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF41C0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 10:59:15 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id h12so9360266qtc.9
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 10:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B21higyNj6bzDNMHb4enfmgqZOL2zcAgwJDUErvCPCQ=;
        b=ZOjdDukbd3CsDiaYbLka4ZOgrmnBfQainIWSLJBh6wlaGQC55i1ex0Wzx3vo2AKlyD
         TqDUZCXOT84sxT692Levu4UkmG6ePWEOA9qS2kTrKya30G5rF975kOKKxCS3e8V2x+eS
         rWjJcpmw9dlf0ZF0eOXV56xTg9dbN90VQJjhsvgeOCIZad7nmrsSV668DLodHqnAoYY8
         BusaEz1fAfqKSsLvZp6bfXYF9rkOGws0FtN2VS01JtEE1c6USzKjbj8LsseYomDwtJWn
         OYc4BjXgSm1obAN6S/06A5OLZ0hBTb8l79fr9FQwBAmYO6Y5/oM4GvHxVPsCG1EcNi3P
         v7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B21higyNj6bzDNMHb4enfmgqZOL2zcAgwJDUErvCPCQ=;
        b=S0rapodC04Q7d+mCC1nqZvaRsLhg9nZM7nR1RleDFmlSj/i1FG3SzYPcQN2PWgcOby
         +EA+GteB+ewyPCltYVXh6hwe+uyPBHclTg6OmzkXaDRu/AL3bVJ97k8DNPEC+6LO3XfV
         tF/7bmRA8wdJxybCRLi36Sw5++A7XPWiQQMwZxp3BS6JfvfamFU5P+atyAtp4yVBxY+x
         Jdxtfegg8U1u4HVkvrRLAvjWsgxesKFvBTVP8u3KSNi7gMRGVHPtAGraRQRN18sMSxO3
         J60+IVwHOiRzGGTCI09c3NmuwxRFgd2FpxtQ8yK2jbRSRR/hxg3HpVFkhXXfdFoNDGXM
         TKPA==
X-Gm-Message-State: AOAM532Mbuz2oaVDBLyfvDu33+lnNho0ehZDUOjWZl5GA5A9uaiHc/x6
        N3H+KSPLvn3DdvwCyVwu68s=
X-Google-Smtp-Source: ABdhPJxJjBDjWwKJ4PmcwsnHvbF+epz104KJcOyP25tXkVknAmkYaUBqwpn8GvzYd2KmY9NhAm6fAA==
X-Received: by 2002:ac8:6c2a:: with SMTP id k10mr11473036qtu.89.1605034754980;
        Tue, 10 Nov 2020 10:59:14 -0800 (PST)
Received: from localhost.localdomain ([177.220.174.182])
        by smtp.gmail.com with ESMTPSA id a7sm8686850qth.41.2020.11.10.10.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 10:59:13 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 8EA21C0E58; Tue, 10 Nov 2020 15:59:11 -0300 (-03)
Date:   Tue, 10 Nov 2020 15:59:11 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, dcaratti@redhat.com, vladbu@nvidia.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v6 net-next 0/3] net/sched: fix over mtu packet of defrag
 in
Message-ID: <20201110185911.GD3913@localhost.localdomain>
References: <1604989686-8171-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604989686-8171-1-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 02:28:03PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently kernel tc subsystem can do conntrack in act_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
> 
> The first patch fix miss init the qdisc_skb_cb->mru
> The send one refactor the hanle of xmit in act_mirred and prepare for the
> third one
> The last one add implict packet fragment support to fix the over mtu for
> defrag in act_ct.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
