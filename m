Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0CA2C323F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 21:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgKXU57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 15:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgKXU56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 15:57:58 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEF3C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 12:57:58 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id q22so401384qkq.6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 12:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aC7ov2YwKmXAPGs/Z7tBdb+l+DhsryopvRfpz9NlHzU=;
        b=TDzO7U37w9Vb/HyPpFJdn/JOEEqg9u0qfLLATJm9YzU/XxAQTx6y1LEM4acAvnYbug
         UX1eUocNrKxjxnGd/8xg7tsVzjU7VMY5sowYXYdQ/3ThppS+DOVlZzn37HtFb5pcKX4I
         B+aZBO3ma3c/iravHzUQsOpdULR+mS7KFyraUcxXTtlf7CLBhLalJFQdlnTqh+6mJgNT
         N1WH2IFO1d54jPwt+SALlFsC0oyvffcb9TMlPi41WY6FHc9rAuOoNit9+yLSJIH2ZgL7
         vtQMzCeVTICHb1OpbPtCF00Ay8ZPIwBe4zi5zTrf2658mT10MSy6xJMe7/Jiitgj1xVY
         EUXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aC7ov2YwKmXAPGs/Z7tBdb+l+DhsryopvRfpz9NlHzU=;
        b=bJSlsbpCmqvUTPbae7GU/zhm21Z9/UXNoAzuCpsCnzuuxP2MpseNOtzTYjrbNGEuNg
         W8Y+Taijp/YiJ+nu/ZjnmXkHhFXtEsYu4E7cPAamCsvG7gI2q/YB3w5fBR1zYsE6EBYU
         caKyPKUfJq75TEOC6Z0NMj3xoU/NxVji9lLGp1uFCBW+MqkDKW4a7jwf/+k/MCu3YqD+
         7OBjz2bBGKo1t+OPHV4bswJOoBcUltpcHnqcLW1rupfZ0yR+3a8VjTXuzvCEXHQxbuUT
         ckLv0xUVW9n/K9eJIMWAO93KyVUZ4p/FgRRBPypKHuIug1wQX0u6pXe/wpU3jBE1Yz/B
         lWQg==
X-Gm-Message-State: AOAM532vJ6Le+oWd357Wk47lf1qI4HnDURDOKIz3VOUAGSMKpiwxqgJ8
        dwIwii12tfJk2T00P5sW3A==
X-Google-Smtp-Source: ABdhPJxjWsLxudBPyD8whB3mEqLdjGDms4X+HIOey2d/sEaL2tFj4A629IJikzYAu7xESC7f9rhuBg==
X-Received: by 2002:a37:9441:: with SMTP id w62mr77097qkd.474.1606251477663;
        Tue, 24 Nov 2020 12:57:57 -0800 (PST)
Received: from EXT-6P2T573.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id p6sm275966qkh.105.2020.11.24.12.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 12:57:57 -0800 (PST)
Date:   Tue, 24 Nov 2020 15:57:48 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: VRF NS for lladdr sent on the wrong interface
Message-ID: <20201124205748.GA18698@EXT-6P2T573.localdomain>
References: <20201124002345.GA42222@ubuntu>
 <6d0df155-ef2e-f3eb-46df-90d5083c0dc0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d0df155-ef2e-f3eb-46df-90d5083c0dc0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 01:43:54PM -0700, David Ahern wrote:
> On 11/23/20 5:23 PM, Stephen Suryaputra wrote:
> > Hi,
> > 
> > I'm running into a problem with lladdr pinging all-host mcast all nodes
> > addr. The ping intially works but after cycling the interface that
> > receives the ping, the echo request packet causes a neigh solicitation
> > being sent on a different interface.
> > 
> > To repro, I included the attached namespace scripts. This is the
> > topology and an output of my test.
> 
> Can you run your test script on 4.14-4.17 kernel? I am wondering if the
> changes in 4.19-next changed this behavior.
> 
We found the issue on 4.14.200-based kernel.
