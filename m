Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0952E7725F
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfGZTrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:47:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38895 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbfGZTrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:47:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so24991457pfn.5
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4wGRkgS2FF/uTIQN+Jc8iKQcgvfPp40Yuscy8pEbkUk=;
        b=k0N/C624XI2FN2mhH5DTw+AutJtv8jb67SyDoPs0wDBwbQS35ouoRYmbZTkoS2vOVG
         dXxA0aZKN2a3uLAnuvPdwpndA8/B1P2CgAb9vDaKiKefeykiekPD6Myt/ECb1rNmC+mb
         n4DheuB35AV/p734JTiiUrW6mwgYIK3B3RcYTIIWnn4G+zHIXoDo24vcBzUFUrq/+PI8
         rI1GyFAOs7UuVIDN2aAojE0ATM2yRLNcTog1UKpbS1p5qziyc0qKIfF3gkaloPVmAJgI
         6waQ4aSMuvmYXzBZ0Wtkr7lBj+MjkFY3AqfJGM1oyj1TFXD4UX99skTn5+EMSwyRtHgC
         MowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4wGRkgS2FF/uTIQN+Jc8iKQcgvfPp40Yuscy8pEbkUk=;
        b=m5XXDJHbg3NnZBz3+nTL+pW2Jb25dVvFo3dx9BBRmaVlfGWOtKjv/1wxVYRhHlMWDk
         eCvfFQ/6q6sMRRjMDLsQk4V8FSJ5n6xZ28B4iLe/dmoCUmxUpaaTOkG4S2RmIS40LB3S
         feDNQNtNYl9fHNCsE0yNY+rFUDMRQzyC18tRgiHLETkOq7ZVp4/Ox046AhSYUhSJJtJI
         WFyz6Q0fW9LLpx70tDwuT+zvLl0q/EgBANn9j4ChqS06lEV7fkgcyXkxfj9EUOCc6RsT
         NwBLIW7RHdbhuNrPTGLeF7x52qcyHk8Zf5xH4OqnSwLJoPySaz+Psqnd7Zo2FXAdrVS7
         4Yew==
X-Gm-Message-State: APjAAAVf5hySYVk7EVm6TuHrNbMxj5AdxsbHIFd2dRrX0bhlrZbMSAp0
        5S8jw+cikb44T+YyLnfPu84=
X-Google-Smtp-Source: APXvYqxnrIgL/Ngxp7/Xsh6CnKAkVNbp82e7pNSahawvr02afzTr/erAzDJ3kVBqWvDG0D484sCgHw==
X-Received: by 2002:a63:7d49:: with SMTP id m9mr84214543pgn.161.1564170435062;
        Fri, 26 Jul 2019 12:47:15 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a21sm61270581pfi.27.2019.07.26.12.47.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 12:47:14 -0700 (PDT)
Date:   Fri, 26 Jul 2019 12:47:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>, chrims@mellanox.com
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        alexanderk@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2 1/2] tc: action: fix crash caused by incorrect
 *argv check
Message-ID: <20190726124707.2c53d6a4@hermes.lan>
In-Reply-To: <20190723112538.10977-1-jiri@resnulli.us>
References: <20190723112538.10977-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jul 2019 13:25:37 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> One cannot depend on *argv being null in case of no arg is left on the
> command line. For example in batch mode, this is not always true. Check
> argc instead to prevent crash.
> 
> Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
> Fixes: fd8b3d2c1b9b ("actions: Add support for user cookies")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  tc/m_action.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tc/m_action.c b/tc/m_action.c
> index ab6bc0ad28ff..0f9c3a27795d 100644
> --- a/tc/m_action.c
> +++ b/tc/m_action.c
> @@ -222,7 +222,7 @@ done0:
>  				goto bad_val;
>  			}
>  
> -			if (*argv && strcmp(*argv, "cookie") == 0) {
> +			if (argc && strcmp(*argv, "cookie") == 0) {
>  				size_t slen;
>  
>  				NEXT_ARG();


The logic here is broken at end of file.

	do {
		if (getcmdline(&line_next, &len, stdin) == -1)
			lastline = true;

		largc_next = makeargs(line_next, largv_next, 100);
		bs_enabled_next = batchsize_enabled(largc_next, largv_next);
		if (bs_enabled) {
			struct batch_


getcmdline() will return -1 at end of file.
The code will call make_args on an uninitialized pointer.

I see lots of other unnecessary complexity in the whole batch logic.
It needs to be rewritten.

Rather than me fixing the code, I am probably going to revert.

commit 485d0c6001c4aa134b99c86913d6a7089b7b2ab0
Author: Chris Mi <chrism@mellanox.com>
Date:   Fri Jan 12 14:13:16 2018 +0900

    tc: Add batchsize feature for filter and actions
