Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575AE9B4BD
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 18:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391046AbfHWQnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 12:43:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36521 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389221AbfHWQnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 12:43:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so6063831pgm.3;
        Fri, 23 Aug 2019 09:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CMg7dz48IyUm/ULuv/1H/MJ+YRjy1SWtr1VrTKhDXkM=;
        b=o7wI99JV5WW84MxLHb+sGgfAzmeVfDQ1XxR9QqYp6MJo/lpbe/u4z5oIJFteUpSfua
         F1EuU5Yz8RLvUvUJn8jUWx6uchBpfQ6SVnQvWkCok3452tGmTEJSppPb4qk0Qz/UP0vz
         ESpe+nr/LM4ZAOOf0/T5zoa8VRNQJWQPVE5827SbHU1pmg5UMvln0I4cdd2Y7jfw0dlk
         xchm8+pBZtVGbIipOipzkxOB9NFUrZ5G0rnI1GFy3Z74nHc6V/60jrefV+WRk0EvH+0e
         HfKvZvLvMz66WIPc6NLaxJmDVMUXaIYrtqvId75gf2l2adYnDv10t5bGoLb4Mj6erozt
         v3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CMg7dz48IyUm/ULuv/1H/MJ+YRjy1SWtr1VrTKhDXkM=;
        b=m3JhVVUVsK7BGUd3npVAdHB37H0I6ql8BVkGtnOzFVREAnkywoegwrahH1ly/jL6Jn
         hoMCYn0CTGllZAtwTbUgi2deMUW8ePWLF7cg4Fri1GEnhPxcKmBd9qBul+dGBcpjLEQY
         hkD52SuyOIar/yZCYNV5nc6i5xWHi/FVp/zdF29qD522fQ7Q2GaY12E+qznhTm/pe/kF
         XTsc6OHDr85BKfd7DpRWzdICDrT9FNBmmOt9hngzjMFkwTH6uybN3Rx6Fjd2MVOZ+pdw
         VZSDRQSAoaEAEepQGtByhyA9l5zYyub2P8TMoCOVm8EZjW7seRnBa9aLsuzd+NuWNuKP
         60sA==
X-Gm-Message-State: APjAAAU6IvfPJXlCunLRHnNDagGg0a+hJDC09Per2KInq7Yc6RbKFaJ2
        6BzTzT9DPxzqioobOGm+2TI=
X-Google-Smtp-Source: APXvYqzp3OniX7nGok/COpPNlZeyPAUV7KniiDTGnJOEN8fVYUKwSUvdYDEYo3zhtx4bLmiV5ZWPKw==
X-Received: by 2002:a63:724f:: with SMTP id c15mr4883466pgn.257.1566578620244;
        Fri, 23 Aug 2019 09:43:40 -0700 (PDT)
Received: from [172.26.99.184] ([2620:10d:c090:180::b6f7])
        by smtp.gmail.com with ESMTPSA id bt18sm3017029pjb.1.2019.08.23.09.43.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 09:43:39 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: Re: [PATCH bpf-next 1/4] xsk: avoid store-tearing when assigning
 queues
Date:   Fri, 23 Aug 2019 09:43:37 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <AE2608DC-C4FD-4406-8ACA-0717A83F3585@gmail.com>
In-Reply-To: <20190822091306.20581-2-bjorn.topel@gmail.com>
References: <20190822091306.20581-1-bjorn.topel@gmail.com>
 <20190822091306.20581-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Aug 2019, at 2:13, Björn Töpel wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
>
> Use WRITE_ONCE when doing the store of tx, rx, fq, and cq, to avoid
> potential store-tearing. These members are read outside of the control
> mutex in the mmap implementation.
>
> Fixes: 37b076933a8e ("xsk: add missing write- and data-dependency barrier")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
