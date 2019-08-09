Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338A786EA8
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 02:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404422AbfHIAFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 20:05:17 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32992 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733258AbfHIAFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 20:05:16 -0400
Received: by mail-qt1-f195.google.com with SMTP id v38so1761741qtb.0
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 17:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=eMbvkJMMhKVoLdAFucGO2xR/SA34OH5l6Gu6lVMIR7U=;
        b=CwvrFR0on7zstKP9Y3NJqU8QU4jCWc2ggN8bYirEiSk8qRGADjaxByhPr8NVVxo0Qu
         /c8gK91UpzBrsU5QshTPwcMRWIs93BZqUm1ZF7mGgYYLP1n1VFEbk8FvihwzcmPULmhF
         HeaKL5pR6gAdjhtu+nw8Ff2OBwGMFnKyiBwFpE5PLqJhZgmJxjJYUvfm4olYZo/WxjH/
         nLjd+X9Nqmj1Yht13H4fyzM0YAEGjPi6AUsR5KQ6tKJLUXcM39eNo1GthogGAQ6KOx0w
         vSVwhk2iQx6CGR2AZC79acnPcPcjaCU3Vnefun+Ve5GeDiPhrOJCVJ4ZEsubzk0AQIAC
         DLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=eMbvkJMMhKVoLdAFucGO2xR/SA34OH5l6Gu6lVMIR7U=;
        b=dnbNvCZz8+XycoXOMLmhol0OuwyIMmog1u0awdgNDn7AewSVSQY2SrnV/Z/QZDoCyi
         mz/qKTLKMYqje5Vf7nJp0fDx/errca07bMTxKtptDENCgtjwdEQLLA4B64mamrMBr+2k
         5NvvqJJ4GSDdNDxYxGAvULHdXq/HO8HCZ1TLptPriC177UPnKLpZEStT1Vjd8n2zqkfo
         UnJOyq74R34ddIuvNWdjlwbpXcreIFO8CGC8vrTgcNTULiA5fHBf0Qq7jwEt75wo+xLX
         Xm2MKdG+dgoZc2xVYjNKHC+vrZ2+U84tvhe9prbS/jv0x1F6GtZM9zVmqR81KS/zTVV9
         382Q==
X-Gm-Message-State: APjAAAVAZoAF59I39NJdjp++kvgcpKtRea6wBQbrqc7JJrxWhjA1YsXU
        BPJUZbTxIvNb0s/mSqlIyJG7NQ==
X-Google-Smtp-Source: APXvYqzqUxyxCPIKqh4D/S3W6yFAx0r/OSLty4LcwBDCAVZor66kQACwwgYdrsxGu6A9I15oMFfKNg==
X-Received: by 2002:ac8:72d1:: with SMTP id o17mr8713168qtp.212.1565309115539;
        Thu, 08 Aug 2019 17:05:15 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 18sm43622992qkh.77.2019.08.08.17.05.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 17:05:15 -0700 (PDT)
Date:   Thu, 8 Aug 2019 17:05:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Y Song <ys114321@gmail.com>
Cc:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [v3,2/4] tools: bpftool: add net detach command to detach XDP
 on interface
Message-ID: <20190808170511.08bc93fc@cakuba.netronome.com>
In-Reply-To: <CAH3MdRWeD+9Lmz+mJt3EnNkX8kbcyCW4sNgRindCiObnzAj-yQ@mail.gmail.com>
References: <20190807022509.4214-1-danieltimlee@gmail.com>
        <20190807022509.4214-3-danieltimlee@gmail.com>
        <CAH3MdRW4LgdLoqSpLsWUOwjnNhJA1sodHqSD2Z14JY6aHMaKxg@mail.gmail.com>
        <20190807203041.000020a8@gmail.com>
        <CAH3MdRX2SYj+79+L_FJtxMQZfPQDtYDFEbgH6VGAKMYnBXU4Vw@mail.gmail.com>
        <20190807223807.00002740@gmail.com>
        <CAH3MdRWeD+9Lmz+mJt3EnNkX8kbcyCW4sNgRindCiObnzAj-yQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Aug 2019 12:52:11 -0700, Y Song wrote:
> > Ah ok. In this scenario if driver has a native xdp support we would be invoking
> > its ndo_bpf even if there's no prog currently attached and it wouldn't return
> > error value.
> >
> > Looking at dev_xdp_uninstall, setting driver's prog to NULL is being done only
> > when prog is attached. Maybe we should consider querying the driver in
> > dev_change_xdp_fd regardless of passed fd value? E.g. don't query only when
> > prog >= 0.
> >
> > I don't recall whether this was brought up previously.  
> 
> Thanks for explanation. I think return an error is better in
> such error cases. Otherwise, people mistakenly write wrong
> device name and they may think xdp is detached and it is
> actually not.
> 
> But this probably should not prevent
> this patch as it is more like a kernel issue.

Agreed, we'd probably need a flag here, similar to IF_NOEXIST to keep
backward compat.
