Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038C51DF180
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbgEVVxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:53:53 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33136 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgEVVxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:53:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id n15so5829713pfd.0;
        Fri, 22 May 2020 14:53:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WHmiwszC7LQO/v52gvNdobe9HfM0ASQqSeK8lyvm5D8=;
        b=ASlI4dyDkiUM49EKSiCbjo5EtawadGZJFAkybI8V9M0J/ou36pLFxJ2H3lEqSiS8Nq
         EdngJEkfazwMk8NgiJ8XoLbS2wFZhjtNn5Tf16iWh6uGL0hq1tmxlZCJY2dos7oT1qyq
         85QFLz3NNtavwQppiG3f1wGPklzLxJGy+tNBz98UV4VCuhScWEOVdMNvcusEbgCwhNuk
         JOyWPqoI8QB3yNC6STvmOBF7sWSIf2eFVUjASfskXNApmb/ioIgNnb74JMhHDoBRzNFG
         D1JnU+wcgPwXOrH06hyt/fPtZw/1LTQCxfifCgZSi2cZf7vf+2uBQe4ZeN4bL0vGh9Fl
         GNgg==
X-Gm-Message-State: AOAM531KwK4G5OjcRAoxo2p/CskNem9BbhuFR//GEr2qVih9dKcK1Vih
        IWza235qlw926bJo0Fcfps0=
X-Google-Smtp-Source: ABdhPJyOx3t/vlUoP9cjk+jBlIB2Kjti5P5L4S1KOlIHUZRRYR/m+wgqahLaoMzvrGVmzvh6raILyg==
X-Received: by 2002:a63:521e:: with SMTP id g30mr16018629pgb.106.1590184432635;
        Fri, 22 May 2020 14:53:52 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id p66sm7417524pfb.65.2020.05.22.14.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 14:53:51 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id D2DD040321; Fri, 22 May 2020 21:53:50 +0000 (UTC)
Date:   Fri, 22 May 2020 21:53:50 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Alex Elder <elder@ieee.org>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, aquini@redhat.com,
        cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH v2 10/15] soc: qcom: ipa: use new
 module_firmware_crashed()
Message-ID: <20200522215350.GD11244@42.do-not-panic.com>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-11-mcgrof@kernel.org>
 <0b159c53-57a6-b771-04ab-2a76c45d0ef4@ieee.org>
 <20200522052834.GA11244@42.do-not-panic.com>
 <c23b7a5c-5534-b3e5-afa7-f71e097878de@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c23b7a5c-5534-b3e5-afa7-f71e097878de@ieee.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 03:52:44PM -0500, Alex Elder wrote:
> On 5/22/20 12:28 AM, Luis Chamberlain wrote:
> > OK thanks. Can the user be affected by this crash? If so how? Can
> > we recover ? Is that always guaranteed?
> 
> We can't guarantee anything about recovering from a crash of
> an independent entity.  But by design, recovery from a modem
> crash is possible and is supposed to leave Linux in a
> consistent state.  A modem crash is likely to be observable
> to the user.

Thanks this helps, I'll drop this patch!

 Luis
