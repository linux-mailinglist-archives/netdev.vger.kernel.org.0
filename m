Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CEF1BC6D6
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgD1RbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbgD1RbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 13:31:24 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04E0C03C1AB;
        Tue, 28 Apr 2020 10:31:24 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 18so9800069pfv.8;
        Tue, 28 Apr 2020 10:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o1hvJ7qJ286Xh+ZpEY5biAu9CzmRlIJ2PwFJ0cbItFo=;
        b=Kpifsw0qbOFcSjhI0V7+etB+KLPHGw7vdnW7iYqftCfWKdyVyHgS7FgTbbfRmV3PjD
         Twi1SLBi3v2UcidAh3om5V6LNNBvyqXspnH0nYPHG5hi4KuacYh4UBVDWQEufXrSA0R4
         O/FKoxL+jL83PHfG9aqPJliWxrNbpfjIHtHamHyb3gmIkxOaib+CJj8tcX22Rh9kuzFU
         WRT6c4B3N0y0Y+yDP7CO6flNVQq+G2Xk7GzBse15i6AFLDmX7FpdpXrp7I2twStj4ZbT
         NEjDUAwAZEtiEh4gN5jmjC6xdVtwWba2fSZ1/nb6t+IKHKa2frsuukI2/474ejcDd9/e
         q4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o1hvJ7qJ286Xh+ZpEY5biAu9CzmRlIJ2PwFJ0cbItFo=;
        b=P4p+zUPZ10qTBSAtJZzS3lQmsXDsiEQQ0KPoA7r/+Sg52uk7swwnHD5VMI3z1AS3uT
         Uu31e2yR/9aCQcF4e0Xq3BqeJRTXmuhXKSCWr3hED1/yeHpokRjTO9pOoOqRJN+L9lc9
         HCmNPerkBGCp15wMS9597C2m9wIcJ8s3iZYiKlE6zQMH7GCcHOQ15VvjBYqQCLyn6o8I
         Q676zfF2AwCHqT+alFykhzICDpP9uPupm9yxgLh8yO6H/6EAeh9/i+F1txxwnCH/c2Hc
         O+j3iVmtrgln200jAOWEb2KUTRmwn+rurRvziXd9SPMEcL3j9BOQ5sL9VfbCTgZtEZje
         jkiw==
X-Gm-Message-State: AGi0PuYh0isbQmv8C5oPtbe/P7aSiZTxb0Nu1FDjomHxMVoB9u09ad5D
        nWjOKbhocE8X8mwbYuWzIkw=
X-Google-Smtp-Source: APiQypIRVSOGKZHDBB5yU/ZOWxmZRb3LKojyM0t6qFlCW4oiGl8ytR6ak7C9j2SkMGv+y1vQMXugZQ==
X-Received: by 2002:a63:63c1:: with SMTP id x184mr14465633pgb.116.1588095084126;
        Tue, 28 Apr 2020 10:31:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id c28sm15588485pfp.200.2020.04.28.10.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 10:31:23 -0700 (PDT)
Date:   Tue, 28 Apr 2020 10:31:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 02/10] bpf: allocate ID for bpf_link
Message-ID: <20200428173120.lof25gzz75bx5ot7@ast-mbp.dhcp.thefacebook.com>
References: <20200428054944.4015462-1-andriin@fb.com>
 <20200428054944.4015462-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428054944.4015462-3-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 10:49:36PM -0700, Andrii Nakryiko wrote:
> +int bpf_link_settle(struct bpf_link_primer *primer)
> +{
> +	/* make bpf_link fetchable by ID */
> +	WRITE_ONCE(primer->link->id, primer->id);

what does WRITE_ONCE serve here?
bpf_link_settle can only be called at the end of attach.
If attach is slow than parallel get_fd_by_id can get an new FD
instance for link with zero id.
In such case deref of link->id will race with above assignment?
But I don't see READ_ONCE in patch 3.
It's under link_idr_lock there.
How about grabbing link_idr_lock here as well ?
otherwise it's still racy since WRITE_ONCE is not paired.

The mix of spin_lock_irqsave(&link_idr_lock)
and spin_lock_bh(&link_idr_lock) looks weird.
We do the same for map_idr because maps have complicated freeing logic,
but prog_idr is consistent.
If you see the need for irqsave variant then please use it in all cases.
