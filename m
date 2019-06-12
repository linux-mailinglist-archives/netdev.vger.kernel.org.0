Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F5E42B52
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbfFLPzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:55:12 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42814 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfFLPzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 11:55:12 -0400
Received: by mail-pl1-f195.google.com with SMTP id go2so6789354plb.9
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 08:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qaIDlGsLetS195iKbpbSRoBQmgyL/Yfk4wM2gVVU+ws=;
        b=V3jyaqcqZUH+0AalXPflwvGv2btQ/oVCNyODqGL0zfP8xq0rNX3J9ftdlzVRsgwicW
         wa7kkd+QjVqQ8zlta1AkmwpbPeqbYiepA59asKcCO7dCJkVgX41IpmPFq3APy4kPJeJF
         CSxioF1jQQhDUTb1IfU1dT8LLwKd9vQqB1aDl+Q/ympHIJtp2lCvj4kCrtniZV5C0vGE
         Anuo9OZSVVhZavsHFMFN72oFjs5dHgU/G+cUzZflylHGaaZMFg+yUq1v7utLlPUZ49NQ
         SZAjs10xRYP+jPRqHxpoGTx7Q3trwhtbxePC9XgE1zHdtsdbANfgx0RmnCzDFkYezfDX
         Dg4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qaIDlGsLetS195iKbpbSRoBQmgyL/Yfk4wM2gVVU+ws=;
        b=mdK0/T5+SBrike+Y0TlvqFUFAJY2LTsh5pOhHSuE+u2wC73l6SM/66tvKXWsYqnsCF
         srRelcLrXExZDiBvYzLWyGOnwerZmkIgN6z4uEoCUuVvQHCi41kSPsOmyoabKiHHVjVm
         jjmHNiOOtO0gYdOPLr06PhIcKB3+7OI1c5GRij83qoYRgJYxwciSVDaP6Oe5ckcBpWeG
         PNq/ZD/BdQf1HbRdwnfkxTMg/BMlP1kXPjyw5CoC+tzloiPx74BgJciUuluxWJLNlX+i
         TlYiYPBoZfPO+qGkCLf77Eq/+Cm5AmIllGwotqSbCL+z+vext6Srkrp0/aGOG/JIdH+b
         GT8g==
X-Gm-Message-State: APjAAAUibZVul/cxfyNfHnMw2wuez8a70Hd/0GGWHSUhg4xDIMB4WIfR
        48mFtueknbutdy5CD/U6dQqniQ==
X-Google-Smtp-Source: APXvYqwN9odesF8lpVGloUV4ZHYCOitOTDwGxfvXaz6sHjbiSVhc2t2KdtQJKAoA442uhwplaLHzHw==
X-Received: by 2002:a17:902:8a87:: with SMTP id p7mr65555967plo.124.1560354911823;
        Wed, 12 Jun 2019 08:55:11 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b15sm1325pff.31.2019.06.12.08.55.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 08:55:11 -0700 (PDT)
Date:   Wed, 12 Jun 2019 08:53:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2] testsuite: don't clobber /tmp
Message-ID: <20190612085307.35e42bf4@hermes.lan>
In-Reply-To: <20190611180326.30597-1-mcroce@redhat.com>
References: <20190611180326.30597-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 20:03:26 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> Even if not running the testsuite, every build will leave
> a stale tc_testkenv.* file in the system temp directory.
> Conditionally create the temp file only if we're running the testsuite.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  testsuite/Makefile | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/testsuite/Makefile b/testsuite/Makefile
> index 7f247bbc..5353244b 100644
> --- a/testsuite/Makefile
> +++ b/testsuite/Makefile
> @@ -14,7 +14,9 @@ TESTS_DIR := $(dir $(TESTS))
>  
>  IPVERS := $(filter-out iproute2/Makefile,$(wildcard iproute2/*))
>  
> -KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
> +ifeq ($(MAKECMDGOALS),alltests)
> +	KENVFN := $(shell mktemp /tmp/tc_testkenv.XXXXXX)
> +endif
>  ifneq (,$(wildcard /proc/config.gz))
>  	KCPATH := /proc/config.gz
>  else
> @@ -94,3 +96,4 @@ endif
>  		rm "$$TMP_ERR" "$$TMP_OUT"; \
>  		sudo dmesg > $(RESULTS_DIR)/$@.$$o.dmesg; \
>  	done
> +	@$(RM) $(KENVFN)

My concern is that there are several targets in this one Makefile.

Why not use -u which gives name but does not create the file?
