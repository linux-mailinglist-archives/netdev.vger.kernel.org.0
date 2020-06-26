Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5817A20BCF4
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgFZW41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgFZW40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:56:26 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB7FC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 15:56:26 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id t11so404873pfq.11
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 15:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dWzP7QZWR34K3jLlm/uWd00nMGQxiM2Ep7f7sCjL+B0=;
        b=lWzgp+Tsl9BvR1kkQbtgQcgtaxzj8ngi2esODZ2y1NMivoIoxeVFduoDnWfigItGD/
         rQ63H0+SJufe6d8wPGQP+JgwTho1ey7xbYw6Hhy84PNggWanNScsWvKUTwevEHb+k9RR
         Cp4en7zjwyGrpRPzGhjTv7iGw5+8u8q/XH6zOze+zTRvx4WvLBFIbxw4QsNYYCyLofL2
         Ja2AN0f62+s2uXLtregv2x/lrDgW36bc33jUojZtvqI4j1Yrrx2kwZ1S8oXdARzJWgTI
         +zWWmL93c8V+x5HptgpGhUmKjtAZpzCHzR0loVpOFtO9z3JuNHSV6llS0kjseycEb+t+
         xQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dWzP7QZWR34K3jLlm/uWd00nMGQxiM2Ep7f7sCjL+B0=;
        b=dtoZlsrv7uq0OQDmMvEVqoeMNcR4yPKd0jFgJxvVj4yYtF18Mg1yGZly4dMTR1VovW
         xkCpYDUpuO2KTg5gP28oKrCjEkzWPFE6we3qxoxhdioulM3ukKAn2XPhBx3X/wnOpfnA
         8DvayQrd0UoPDL5pDeqWx4lEL/k2vqwAsSmGwgTvzb1rsSQ00rccybp55KlX9lwFHzYv
         Ui33SElUkqI2Hf5iqIb66ml9icE2eZKOTONNlKB13JlgVxpobqi2O9QcAWvsbI2XOCKq
         wfXp+hScIbR9jIOXlkva2BcQoe0Cyh5ua3u6rSqKDtrI5SIzGjfxjJutQjusElSZYtqh
         e7PA==
X-Gm-Message-State: AOAM533wlYqf3dUphb9/NV3uNjrqBJX06z1fN0e667hqOd6hDSxr3nvn
        0LryyDDXbCYQCmUA++Q+Ic2vRA==
X-Google-Smtp-Source: ABdhPJzWy1Z2s1209izgXE8LIvWZdwQJr0DGUJPU42sBL0xH6mnrxwhFEOd/VoRp3JJyfox9KvG8Ug==
X-Received: by 2002:a63:d0e:: with SMTP id c14mr927222pgl.206.1593212186090;
        Fri, 26 Jun 2020 15:56:26 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g21sm26355943pfh.134.2020.06.26.15.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 15:56:25 -0700 (PDT)
Date:   Fri, 26 Jun 2020 15:56:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next v1 0/5] TC: Introduce qevents
Message-ID: <20200626155617.7f6a4c4c@hermes.lan>
In-Reply-To: <cover.1593209494.git.petrm@mellanox.com>
References: <cover.1593209494.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Jun 2020 01:45:24 +0300
Petr Machata <petrm@mellanox.com> wrote:

> The Spectrum hardware allows execution of one of several actions as a
> result of queue management decisions: tail-dropping, early-dropping,
> marking a packet, or passing a configured latency threshold or buffer
> size. Such packets can be mirrored, trapped, or sampled.
> 
> Modeling the action to be taken as simply a TC action is very attractive,
> but it is not obvious where to put these actions. At least with ECN marking
> one could imagine a tree of qdiscs and classifiers that effectively
> accomplishes this task, albeit in an impractically complex manner. But
> there is just no way to match on dropped-ness of a packet, let alone
> dropped-ness due to a particular reason.

Would a BPF based hook be more flexible and reuse more existing
infrastructure? 
