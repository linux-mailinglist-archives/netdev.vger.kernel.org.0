Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D00BB15083
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfEFPmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 11:42:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34656 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfEFPmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 11:42:38 -0400
Received: by mail-pg1-f194.google.com with SMTP id c13so6653479pgt.1
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 08:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5bABSmUJlEcKBPjRKjKtHd6jbmA1GxSpl6ICNk7u3UQ=;
        b=KJnfHAqYdFe95NUgdv2s0/pQ0LB0tBbJz9cM6xchn1924mqdLPMWF/P8DVYVLwWyqk
         OJ2RuOGAY63CqGXh1qXr0ii86ScUPQWozlxNZgSzyqEKnmP7g2h6QyF2ZDblBJRJ7Lxp
         N4Im7yewYDYoi5xzOJvc2Qyb/gEl9ScRSWhZ6PcFOSxG967JReJz4HxcRe4u/BXwgxgd
         RfZYy6tUZF53HU4LIoXnJvj/DXuuFwX+nxleFD8YsJOOGsx2SJ6G3PYgS9KaFiWcf0vj
         6LUKxV4foJWyc1/7kdJXoBZqIKWn3Jto7VJEqy1lN9u4by9NYqkyEWGHexHkIjWF/CIc
         3yMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5bABSmUJlEcKBPjRKjKtHd6jbmA1GxSpl6ICNk7u3UQ=;
        b=iEThnJYrGis/K+bmkW99aTZOYCQM1EMKYweQjnPWuc2Xvpr1+Pea6Zusnz17GAakMK
         PUToTFOdSoI8Hpyf/xe73kekrfC8XfsVR4E1hkalKs3nz/TAFxdvMb2azR8Y5iOvp5mZ
         OdgdwKHDxaJA3910xroy3BAoDqAPGhmRGWH3l2ntSnctcGRFjwGfHlGQJ1SGKcmuVWQq
         ROLUuc3lH5TTiAcKPW0bFAnFApVkjYkDknwVvAT3Rd/C2E3mCdB7ggWl3RK2xTCWiqfp
         Fb8zkE6fU+TdIZpIX1D/xdZBneboPCHUmTx1jHeqzbOpF3yaCRF2DiNlt41aDwtmm3jt
         8JRA==
X-Gm-Message-State: APjAAAUir5cjimzXBmS+Zslm5S8KTo9YT2igngRWf/IdwCe4cWoRYxcY
        XWMvsqQ0hNG4TWo0qD6riOH6Wg==
X-Google-Smtp-Source: APXvYqwVlk2vQ4JyoDzbl01TLGhrrTKn5H7j3km61gQ2nbVi/rqVyZryg0LDJQIzghO8tWIvfgYZsA==
X-Received: by 2002:a63:2d87:: with SMTP id t129mr32819376pgt.451.1557157358110;
        Mon, 06 May 2019 08:42:38 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j19sm13138545pfh.41.2019.05.06.08.42.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 08:42:37 -0700 (PDT)
Date:   Mon, 6 May 2019 08:42:30 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc:     <liuhangbin@gmail.com>, <kuznet@ms2.inr.ac.ru>,
        <nicolas.dichtel@6wind.com>, <phil@nwl.cc>,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>,
        "Zhoukang (A)" <zhoukang7@huawei.com>, <kouhuiying@huawei.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2 v3] ipnetns: use-after-free problem in
 get_netnsid_from_name func
Message-ID: <20190506084230.196fee67@hermes.lan>
In-Reply-To: <1fca256d-fbce-4da9-471f-14573be4ea21@huawei.com>
References: <f6c76a60-d5c4-700f-2fbf-912fc1545a31@huawei.com>
        <815afacc-4cd2-61b4-2181-aabce6582309@huawei.com>
        <1fca256d-fbce-4da9-471f-14573be4ea21@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 May 2019 15:26:25 +0800
Zhiqiang Liu <liuzhiqiang26@huawei.com> wrote:

> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> 
> Follow the following steps:
> # ip netns add net1
> # export MALLOC_MMAP_THRESHOLD_=0
> # ip netns list
> then Segmentation fault (core dumped) will occur.
> 
> In get_netnsid_from_name func, answer is freed before rta_getattr_u32(tb[NETNSA_NSID]),
> where tb[] refers to answer`s content. If we set MALLOC_MMAP_THRESHOLD_=0, mmap will
> be adoped to malloc memory, which will be freed immediately after calling free func.
> So reading tb[NETNSA_NSID] will access the released memory after free(answer).
> 
> Here, we will call get_netnsid_from_name(tb[NETNSA_NSID]) before free(answer).
> 
> Fixes: 86bf43c7c2f ("lib/libnetlink: update rtnl_talk to support malloc buff at run time")
> Reported-by: Huiying Kou <kouhuiying@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Acked-by: Phil Sutter <phil@nwl.cc>

Applied. You can get better and more detailed checks by running with
valgrind. Which is what I did after applying your patch.

