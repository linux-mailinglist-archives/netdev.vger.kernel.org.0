Return-Path: <netdev+bounces-9091-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FEA6727313
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AFEC1C20F71
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0553B410;
	Wed,  7 Jun 2023 23:36:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE593B3E0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 23:36:15 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659482689
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:36:14 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-65131e85be4so8098627b3a.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 16:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1686180974; x=1688772974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bV+QBIRbd/x+WNmZHSjuCVNmS4EwLkVhDD4/QF5LwNk=;
        b=Ik88XCvI4hJ6a3p3dYxnf2+7ZugbODinVbcRE5BytxNEbbTTldgODWhxxfct3EDVl8
         OHla4HcW9Z0Xx9GrUV7HeHYZy4Ubu4XBdf3+GlqLzUfIZinEk8Nlf20AxB9Lvu8ugH2V
         NZbQ9Drkx0s7//LQf/au6HjQpueXauTefGqw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686180974; x=1688772974;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bV+QBIRbd/x+WNmZHSjuCVNmS4EwLkVhDD4/QF5LwNk=;
        b=MWL7K1lqWwZO3KUn4AxnlfUAroxzltHknv+koQgi5B0pQAuyoPxEioGZxGMQyF1eyP
         lx4d0bBVsPiGB3PGD51Y5GNcvmcMacHdYJw6TbIvucTJaNJeo5izb4UeujD5g5xjrmzc
         VMCl/yin8zKc6P0iYtLNrbEuifG6XFY4uqe2D+vLCHninEJ6ODqIJ2MWkZvWK9M7fQO2
         AcoAcZTl4mwaROjFFJ1zoVJFxP3WHUacCEHecU6ojmvSLytc9LFF5zdU6Gwfc2A5C0iI
         INF6f5hl3TFJa8xUfprnwuwWaq0TH0pw2gR39jxMIuLAcRP08CDwm8CsknTrzoSwQOTm
         IcAg==
X-Gm-Message-State: AC+VfDz4/ncaRMUJ5QUXgwXjWzOc+lYymCBw6q8Iygsl0oxiPrKHxY6Q
	IhUJXpyX8ul1sEXfpK+UWVSfqw==
X-Google-Smtp-Source: ACHHUZ6rM0obypKwIxMkqC6ngq19+vr+asPTcSbdh7AN6aPYahbXFRlUpWTXGYmkl8ptSbEvkESl+A==
X-Received: by 2002:a05:6a20:4c8:b0:110:9b0b:71b6 with SMTP id 8-20020a056a2004c800b001109b0b71b6mr3691768pzd.37.1686180973830;
        Wed, 07 Jun 2023 16:36:13 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d18-20020aa78152000000b00640e64aa9b7sm9148225pfn.10.2023.06.07.16.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 16:36:12 -0700 (PDT)
Date: Wed, 7 Jun 2023 16:36:12 -0700
From: Kees Cook <keescook@chromium.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC PATCH 0/1] Integer overflows while scanning for integers
Message-ID: <202306071634.51BBAFD14@keescook>
References: <20230607223755.1610-1-richard@nod.at>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607223755.1610-1-richard@nod.at>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 12:37:54AM +0200, Richard Weinberger wrote:
> Hi!
> 
> Lately I wondered whether users of integer scanning functions check
> for overflows.
> To detect such overflows around scanf I came up with the following
> patch. It simply triggers a WARN_ON_ONCE() upon an overflow.
> 
> After digging into various scanf users I found that the network device
> naming code can trigger an overflow.
> 
> e.g:
> $ ip link add 1 type veth peer name 9999999999
> $ ip link set name "%d" dev 1
> 
> It will trigger the following WARN_ON_ONCE():
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 433 at lib/vsprintf.c:3701 vsscanf+0x6ce/0x990

Hm, it's considered a bug if a WARN or BUG can be reached from
userspace, so this probably needs to be rearranged (or callers fixed).
Do we need to change the scanf API for sane use inside the kernel?

-Kees

-- 
Kees Cook

