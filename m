Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AD5411894
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242043AbhITPqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242030AbhITPqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:46:37 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96878C061760
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:45:10 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id s69so17778895oie.13
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZjnjqzFOzVjZ24cgOzV3Zk25xpuNdhtjiU75egDCc4A=;
        b=GFbHUWFbjL8GiBemZi8Pk/prYMV39692ogZCynLnfX1QHWGgp4LzEn42osb69ehjZb
         Ir1s6RuiqHR7Z4UxoS/95abqyZ1d+4unaUWm9UNN6ZgouUj6vSsnAz0RD/ui1RbpRU88
         1ARDCVMRvrX3pj0pF9sMjTwfyLSrZf50/KfI7YjXuJebHpZGIQzf6x036LEFYal4gNsO
         LoCHvqiqGa00oMZQTyOMAGD1c+wZo+MbiK7HZtfkoTd99J8msLdHxfCvvk+ymAj/23tw
         h681NOcP9O+ryMGsbbdKwgqMC+KdstrHd9rA8PPMU2I9jQQ+aScmDgj8237NBvjsx9f9
         POEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZjnjqzFOzVjZ24cgOzV3Zk25xpuNdhtjiU75egDCc4A=;
        b=rnjHpGBnu1TJk7BlXfBQXG2gKz502G72IpP8MvMDecD3TWqwtFLoPM+bmDsMFHRPj/
         x/1iP5bY61j4mcwKhA/xlk24QFN1QEyXf6gzWiSqnM4leV0oNtyueacLbeTipH1n//7q
         dqB1EtDhbKMY/f7FsTFDH6ODZMZShKgBPO27DTaR0PhsMa/hyll7MAhESLlbsfjJTVM4
         LKtFWIwuRuHGv+v7cCGVwQSCeoMisTqkVIPS1WXXzgSJah0EDofNZzDG04d/a64DGXir
         bpzwOm0W2LKJBkFwbHDa66sOuLKUknk9y+WovqjYNH2+Kewu8hn/VHn+MrIauEr05s5s
         8SVw==
X-Gm-Message-State: AOAM530IV6qk99lVZtmJVmQ3c5y6tyksrda4Yjg3n6FOdLMJk/ZbdWOO
        XkJkehprOIUzlISVD1v3oP4=
X-Google-Smtp-Source: ABdhPJyZYh8XtXfq2r8rfInnEBYDBjva+AtrpBoUzyj04Ti9YWA92YjDPBH1ch5Jy69all9zo68fyw==
X-Received: by 2002:aca:b903:: with SMTP id j3mr2709470oif.24.1632152710031;
        Mon, 20 Sep 2021 08:45:10 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id q31sm3530095otv.57.2021.09.20.08.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 08:45:09 -0700 (PDT)
Subject: Re: [PATCH net-next] openvswitch: allow linking a VRF to an OVS
 bridge
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pshelar@ovn.org, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, ltomasbo@redhat.com,
        echaudro@redhat.com
References: <20210920153454.433252-1-atenart@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b3bee3ec-72c0-0cbf-d1ce-65796907812f@gmail.com>
Date:   Mon, 20 Sep 2021 09:45:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210920153454.433252-1-atenart@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/21 9:34 AM, Antoine Tenart wrote:
> There might be questions about the setup in which a VRF is linked to an
> OVS bridge; I cc'ed Luis Tomás who wrote the article.

My head just exploded. You want to make an L3 device a port of an L2
device.

Can someone explain how this is supposed to work and why it is even
needed? ie., given how an OVS bridge handles packets and the point of a
VRF device (to direct lookups to a table), the 2 are at odds in my head.
