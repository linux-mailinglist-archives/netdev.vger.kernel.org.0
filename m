Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FE427373E
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgIVAWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729071AbgIVAWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:22:36 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330F6C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:22:36 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z18so10825732pfg.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Qed9akauA0sRjQZPExvOD2QMm275TkRza7ZJWi39w8=;
        b=rKoT0jSXPsFDWCeBdP3XRnHi/3+uRajSRTpP6/rtSVsssGbJlvJXnqAXATm8a7IqxC
         CT8uUeiQK8ik+sky2+k1sY09bgGVIgkNQoWwaxxfI4PR3O5l1Si//mkudXWY4PtH0l1G
         7obCK+lJWT2c3iqrBCgOoyWmSneKToOrzmsiD9AwBJ5NNUB3GdiFTMI+k5aZDRDH2qcO
         L8vstF5olCy640WA0VAYftK1w4elXBv+1tLi79wvMfMvIh3KQ22BKkGnJvtjU+zohazg
         pH0x300wQHp21F2bLeL1RzoyfmYLLIDcxuPioXtE2AYAH3Jsm/sqn8HLXu/PajVUzwyB
         efdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Qed9akauA0sRjQZPExvOD2QMm275TkRza7ZJWi39w8=;
        b=FoxY7kfd0CQ5J/a+0dKMj2mWcOybzAtQLkoCt4LviQY0OKeiUl4q93pf3eilVawG1M
         sinHcTwHbCSQqEv+xG7/ilbe+Pefruo9o5ct5Qiy4MAEpY1Kq9xcGiCQUhBpCSq5iV5c
         4CNCnIvQDu1WIuVldFTnVQPNOiqiZyxwg96/67W0dGMuF3nV/iMuCrr0bmhNdJJDjGbC
         lOud4aAXImnJqMjpQYmQUQtaSVPQA/GBMI2FzSe0/mCMOiJajl3i9+1NdEflVj5r16Jw
         BwE4JFZOntvgJo05KqaD3LdyeT9rUMtRRQWuXPxW32nI0DcIA6UnxUMZWdCF8reXj7gu
         AWJQ==
X-Gm-Message-State: AOAM532UbhNPdrpZ9JGCnlv8vrKFr0z7R2cAmP7JOdmTN7N4DN4hr2UX
        aQvalSnI+lkBu1my+p0HQRAwf26HFMndkw==
X-Google-Smtp-Source: ABdhPJz525iBd1dChpGw+IMbwSqh3n/5JTb5UiwhMNGOffGNb9XLShnRdasNyntywQd9UM84j8C2TA==
X-Received: by 2002:a17:902:dc84:b029:d1:f2e7:586c with SMTP id n4-20020a170902dc84b02900d1f2e7586cmr2185721pld.82.1600734155651;
        Mon, 21 Sep 2020 17:22:35 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j6sm12880602pfi.129.2020.09.21.17.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 17:22:35 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:22:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip: do not exit if RTM_GETNSID failed
Message-ID: <20200921172232.7c51b6b7@hermes.lan>
In-Reply-To: <20200921235318.14001-1-jengelh@inai.de>
References: <20200921235318.14001-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 01:53:18 +0200
Jan Engelhardt <jengelh@inai.de> wrote:

> `ip addr` when run under qemu-user-riscv64, fails. This likely is
> due to qemu-5.1 not doing translation of RTM_GETNSID calls.
> 
> 2: host0@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
>     link/ether 5a:44:da:1a:c4:0b brd ff:ff:ff:ff:ff:ff
> request send failed: Operation not supported
> 
> Treat the situation similar to an absence of procfs.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>

Not a good idea to hide a platform bug in ip command.

When you do this, you risk creating all sorts of issues for people that
run ip commands in container environments where the send is rejected (perhaps by SELinux)
and then things go off into a different failure.
