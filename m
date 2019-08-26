Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2A89D223
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 16:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732770AbfHZO5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 10:57:54 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46189 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729592AbfHZO5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 10:57:53 -0400
Received: by mail-qk1-f194.google.com with SMTP id p13so14233909qkg.13
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 07:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NPJGDOo6L0S+CxpwgDKYq0p9QenFZx3WP7pTe8S4sMs=;
        b=AGKzs8O5qznJgGIwpcBHKPCKaBpDnNPQopX6O6DHaXhR0KlirNeInM2VbTizrvmum3
         0f4vpmov8OQjbLJk1Uu16D/TOk9HdYztfjR2UNe9dwmng70wrygV1IvJyjMDJATGZ7yk
         PobQ8qvG35MNY31lVY5cwgH3G7bORvaNch/ljPBUTdENjG6RkvRB2RS2398T2uRSGen5
         ViR0M5vcYyWEOfqp9LX7QdJWMYS6i91HVP7ljpA9/AH4jOB2UJTgVO/bz9QxDRTSh9fV
         2R9wHdvrj+d6EskJaU21USriV0jICM3S69Lq+YySOHBCEcG9R76zVDNftBSWlXet/W2R
         qVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NPJGDOo6L0S+CxpwgDKYq0p9QenFZx3WP7pTe8S4sMs=;
        b=KgyuusKficKYsWZp2vokTEChKRDwezcMs/1KNKXO6EL0AAAZCtNwUL4/cdKXyNxAab
         e7l39jsZY/Fp3lu7fYAq6YGdH0EbxadAbiFc5GQlXRlOSNnWkCFddNlF/d64YH6eq3WS
         U1ENz7JjbluMi1rQ2227++oqlHa4Qef8l6TfTxo07XJI/82npdc2WlvoixKywsa5e4ZY
         qYZN+t+8rIoj7/bDtn8J4PbJY4ysPt9PYjiEfmL3BMjji+D2ZvobT8hRPCUfD+3jOlwj
         NtLf1l8B6x94DQ5wjHm6jWZGvwLlydhY4Q19C20zcWbHXz/7FZoYDf4ctlun/NzGeNlB
         5DFw==
X-Gm-Message-State: APjAAAUn9OCBESVUNGcmrEhIwxZltSCvdRsOBKkXxeBYximIC5jC+EDu
        A/FvoCWdQ/RRFAx8g/s52JpL2A==
X-Google-Smtp-Source: APXvYqylzZdUtT3tWQZ6cbQ0jUMry5R+13+YQvBswaR16gpPILhv7dep1DWgwRIXcXehIisp40eyBA==
X-Received: by 2002:a37:6e03:: with SMTP id j3mr16061933qkc.362.1566831472597;
        Mon, 26 Aug 2019 07:57:52 -0700 (PDT)
Received: from cisco ([2601:282:901:dd7b:3979:c36f:a14f:ef87])
        by smtp.gmail.com with ESMTPSA id m20sm7309611qtk.11.2019.08.26.07.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 07:57:51 -0700 (PDT)
Date:   Mon, 26 Aug 2019 08:57:56 -0600
From:   Tycho Andersen <tycho@tycho.ws>
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     David Abdurachmanov <david.abdurachmanov@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Vincent Chen <vincentc@andestech.com>,
        Alan Kao <alankao@andestech.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, me@carlosedp.com
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
Message-ID: <20190826145756.GB4664@cisco>
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com>
 <alpine.DEB.2.21.9999.1908231717550.25649@viisi.sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.9999.1908231717550.25649@viisi.sifive.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Aug 23, 2019 at 05:30:53PM -0700, Paul Walmsley wrote:
> On Thu, 22 Aug 2019, David Abdurachmanov wrote:
> 
> > There is one failing kernel selftest: global.user_notification_signal
> 
> Also - could you follow up with the author of this failing test to see if 
> we can get some more clarity about what might be going wrong here?  It 
> appears that the failing test was added in commit 6a21cc50f0c7f ("seccomp: 
> add a return code to trap to userspace") by Tycho Andersen 
> <tycho@tycho.ws>.

Can you post an strace and a cat of /proc/$pid/stack for both tasks
where it gets stuck? I don't have any riscv hardware, and it "works
for me" on x86 and arm64 with 100 tries.

Thanks,

Tycho
