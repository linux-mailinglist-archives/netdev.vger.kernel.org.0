Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CD226E9B6
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 02:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgIRACN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 20:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgIRACM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 20:02:12 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6F7C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 17:02:12 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id jw11so2053071pjb.0
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 17:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Z6/uk13fDdDtxzok5bqvhcNjwfgQSfjItx45RAkKMM=;
        b=hsbyNOmNnu+3dyU50HMPOINq4tVVRyHudxgOhWxe4IOJlFnaIC9FCiM+bC0ZcI/Akk
         VUSzXPk2hc/0qRqxyvt4ivB+71QU4yuBzD8zkngQg6bCqFCiw94eQbxZMRpbMTgAsFNt
         jHtkzEEt5TJgQ1ZHYWWZcVsaz3FYnpls9py69nYJJN+1lhqNr6op4zF4Ch4xl4G6XTNs
         3C60yRDAghia+qJVohd78KAYk7wRrdmAdX80qll/P86Anb5y71VDJ8HWgUTzhEumWwcB
         NL+NoGnzRH4Kg/T6jRZ3ynx/dw4lr8P72jVu8m8HXobN7pccHHcMuP8J4eO9iIZN/xCd
         sdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Z6/uk13fDdDtxzok5bqvhcNjwfgQSfjItx45RAkKMM=;
        b=XKIF0noL8Umv0zsAkCZppcncipCbh2LUdtz7vSSvgZSHsNeJGp6Fx4OqSZcVIAbLJm
         gk6ZLPkoFRX5zvQ8EfVYX+NGX4NuRCfBRJdRNWCY5bhu4s8NjI3BYFfYLmsTya4fx1m7
         4fLPzZxPbgKFbLilfLnb3h8Knh+uzB6rt1qmN+dzGLZzsgIT/1/Z4gj65BLjMinb/sHs
         UMVnbBBy1a5Plx5mHBDlHLRvltCMzFXRiXzGAjstd7uO4hhFBnZHaTTwbhQK9DcMYQC2
         F5v0rZGUtxrCXQcdSiwx2tdZHKNy+6eWxFJ8bIQF3JaSwI5PXi7IKF4U4RI8NIQEMhzW
         eK3w==
X-Gm-Message-State: AOAM5328gp9feANx99EKhqkSPz2K/lDmZ/E2vz9KsK8fX8YYVcmkxpLb
        CzKUDs898hsqfhuvrUA5EW0abA==
X-Google-Smtp-Source: ABdhPJwQp2qR21KZabTeKaqQ56ZDW9ZR64gwodC+vJPyOYuI3+yKcUAEIuLEVY70q4dA9tJ1lJbS5g==
X-Received: by 2002:a17:90a:fc6:: with SMTP id 64mr11048059pjz.194.1600387332194;
        Thu, 17 Sep 2020 17:02:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 16sm749246pjl.27.2020.09.17.17.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 17:02:11 -0700 (PDT)
Date:   Thu, 17 Sep 2020 17:02:03 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     fruggeri@arista.com (Francesco Ruggeri)
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, ap420073@gmail.com, andriin@fb.com,
        edumazet@google.com, jiri@mellanox.com, ast@kernel.org,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3] net: use exponential backoff in netdev_wait_allrefs
Message-ID: <20200917170203.1a363082@hermes.lan>
In-Reply-To: <20200917234953.CB1D295C0A69@us180.sjc.aristanetworks.com>
References: <20200917234953.CB1D295C0A69@us180.sjc.aristanetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 16:49:53 -0700
fruggeri@arista.com (Francesco Ruggeri) wrote:

> The combination of aca_free_rcu, introduced in commit 2384d02520ff
> ("net/ipv6: Add anycast addresses to a global hashtable"), and
> fib6_info_destroy_rcu, introduced in commit 9b0a8da8c4c6 ("net/ipv6:
> respect rcu grace period before freeing fib6_info"), can result in
> an extra rcu grace period being needed when deleting an interface,
> with the result that netdev_wait_allrefs ends up hitting the msleep(250),
> which is considerably longer than the required grace period.
> This can result in long delays when deleting a large number of interfaces,
> and it can be observed with this script:
> 

Is there anyway to make RCU trigger faster?
