Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F12EC69
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbfD2WFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:05:13 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35377 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbfD2WFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:05:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id h1so5829757pgs.2
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 15:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oIClW+eAJGN2srX7oH2ruh8rBrCYjy//tpkEI243d30=;
        b=z2/TNPN0HFkL0ngHxNY7PHsryplbslofoOzRL49oyUbENcGYGFb6T9Gf56u4MaG1+C
         1J82aISJq/snOkKC8GiLp6MZv08/Xv+3Ed6HewAtz/t3LhgML8SJWORPCFTEfkohoVGY
         c83eaRpbsI+BG8uqCyIRfRH9hHvSoMONXU7hUsx5Rf1+fT73bzlnLv2MDYUisOnRJiU4
         HFfWqLy96BWVp146ZtG6qBrlsl4j0+mI8uJsw6eybLsV+X7RonzZJdtyGq1nTAPMbpOV
         E7bn5HVMbWebm/d7cX3v22BO/kh/nJBnimiBz58Zqkn6iGAMum84Uz8yGgaZajQX8YIG
         VkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oIClW+eAJGN2srX7oH2ruh8rBrCYjy//tpkEI243d30=;
        b=fxxvpR8Twp9ekv+jH+KJZXu5e5vTgyiqH0t1LVR+C111jKbdimOp6s1RImWpK/HM6n
         0uWQNAz6JmT3v5MeFsc/m7ppvAbPsrU5DDzU68ortnIlA03klIjxXXAOBo+GNjF58PBb
         aptujYpffYOeL2IXQhrktGaxv4t2KvI0/l2SA2bLscGLayxNJU39oE+ZLr2Tk74lrOJR
         pgM/VtuTlyo+mYTskSYRbmvFkpH+vlPeLVHVd1fk/WLt2y1k3PZ9lc1eURaJLS8oObll
         Qiq6BXJczM5J8qxG0nLGo+oD0v+uCWq3tXIV4hN0PTkBieLFARKeelKyi2tRTtshuoFl
         Pzxg==
X-Gm-Message-State: APjAAAWOnLDdLSrtl9p/zYeWIyKJFvrqeeijeJA95WRUd9aWf/TMYqvK
        VpqbU1Cgs3s2skcEx9jonx4VDg==
X-Google-Smtp-Source: APXvYqzkXZ7AJVDKNwSB0GiURr5QYjzm+0Z4j5Zj10YVaT/WMFAZM5hhEzACKhJCumclUAOwFibSgg==
X-Received: by 2002:a63:a1f:: with SMTP id 31mr62597740pgk.427.1556575512715;
        Mon, 29 Apr 2019 15:05:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q87sm61088448pfa.133.2019.04.29.15.05.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 15:05:12 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:05:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com
Subject: Re: [PATCH iproute2] ip: mroute: add fflush to print_mroute
Message-ID: <20190429150505.7f7f17a6@hermes.lan>
In-Reply-To: <20190426105421.32139-1-nikolay@cumulusnetworks.com>
References: <20190426105421.32139-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Apr 2019 13:54:21 +0300
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> Similar to other print functions we need to flush buffered data
> in order to work with pipes and output redirects.
> 
> After this patch ip monitor mroute &>log works properly.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
>  ip/ipmroute.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/ip/ipmroute.c b/ip/ipmroute.c
> index b29c78e4cc86..ede09ca96412 100644
> --- a/ip/ipmroute.c
> +++ b/ip/ipmroute.c
> @@ -57,6 +57,7 @@ int print_mroute(struct nlmsghdr *n, void *arg)
>  	struct rtmsg *r = NLMSG_DATA(n);
>  	int len = n->nlmsg_len;
>  	struct rtattr *tb[RTA_MAX+1];
> +	FILE *fp = (FILE *)arg;

Applied, but the cast here is unnecessary in C.
So I removed it.
