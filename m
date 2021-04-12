Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410A035C9DE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbhDLPb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238498AbhDLPb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 11:31:27 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1828FC061574;
        Mon, 12 Apr 2021 08:31:08 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id m11so9420609pfc.11;
        Mon, 12 Apr 2021 08:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=fPLsROzP5u1+bzqbXopT9VJp7IDfgW9VewxuZek4nHE=;
        b=sr0Nvc/lny0ymJhSKGXiai+sCZoHqRPGjQOsiheEy9wicqdhcEsb9lreGRGUgdnHIP
         678wgURoakNouM1n56N1k0AciZ7OKOP8zMN9rU/gr1o9c2V8mWFqSDQ0nwBM4kS4mI8K
         mo12UoD2l22ZHgtMzsnH5ftxh+sUVElGZldRJFdlxGyET+fYRPfuoYnAzopXgMOMX1i3
         B967RW9tUyT/F5yEpIjlxAq+P+RETwKZ29R4HU4zjlr6kmTYBhcsjBtnrej3zwxRkaN9
         mukzXkioaJUIZgvTL1sLL9oET24AgTR1rzbC0S4iF4/8BNWrJB9K7gLsGhQk4URhfh/1
         9rxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=fPLsROzP5u1+bzqbXopT9VJp7IDfgW9VewxuZek4nHE=;
        b=DwvGoL3fxbHrx6S03jXqfq2uHtAULH9ubF7SAkmLnBBQZq4tWZVLdboWUmdgSjtGuZ
         PYdBI1gLUvirMTEdq8cyPeqFsoYlwcfW1L9CBfg8+5z0GX5i3RgpihW5s+L/YFp/m99a
         21mP/ygdgmHQSRFQ+V+dsWFScnh0fYfP1nzAUPN1XRzOILyWLCzHXAV7fF1WUiZIZWG0
         yjMsHKXKNrfaTPZTojzrZPfJPvvd16iAKkFE6zuML3e5R8pAyVoPkLONSCv4/IlvYDxm
         Q8oVeSw8wceIIfs4fSesNYxKUQUra3U5TubBUEbPnh9/n6ilmLQKQxNq3EY7kL6Qf0oq
         XCXQ==
X-Gm-Message-State: AOAM532iZ19JlnIkTcdKxPJ4FrX0e+ox5ejX7HB8oocCyn+I5t6F7SfL
        Bum3lYpT/m0ts8vhm5g+8nY=
X-Google-Smtp-Source: ABdhPJxK/oTwhT7B82XJHAKi8ykDfjQ/ZeB0wtw18f+QdO/ThapXrzEi+3O9Bjn9v7EG05IQaNwBrQ==
X-Received: by 2002:a62:7d46:0:b029:247:baa2:d95c with SMTP id y67-20020a627d460000b0290247baa2d95cmr14540808pfc.15.1618241467685;
        Mon, 12 Apr 2021 08:31:07 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id e31sm11824864pjk.4.2021.04.12.08.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 08:31:06 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     netdev@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH RFC net-next 1/3] net: dsa: allow for multiple CPU ports
Date:   Mon, 12 Apr 2021 23:30:58 +0800
Message-Id: <20210412153058.929833-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YHPPlnXbElN4qJ/r@Ansuel-xps.localdomain>
References: <20210410133454.4768-1-ansuelsmth@gmail.com> <20210410133454.4768-2-ansuelsmth@gmail.com> <20210412033525.2472820-1-dqfext@gmail.com> <YHPPlnXbElN4qJ/r@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 06:41:58AM +0200, Ansuel Smith wrote:
> > So, drivers will read the name of every port and decide which CPU port
> > does it use?
> >
> 
> Yes, this seems to be an acceptable path to follow. The driver can
> provide a preferred CPU port or just tell DSA that every cpu is equal
> and assign them in a round-robin.
> 

So we somehow configured default CPU port in dts (by port name). In
my opinion we can just add a default CPU property in dts to specify
it (like Frank Wunderlich did earlier), and fall back to round-robin
if the property is not present, while still allow users to change it
in userspace.

