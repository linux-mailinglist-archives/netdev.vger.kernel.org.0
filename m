Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E301B124B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgDTQvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726141AbgDTQvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:51:42 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF26FC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:51:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id np9so102791pjb.4
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 09:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lagOiNmOcrwRrV1/ate4UBE5MpqgcNFKZJhHzH/1ZLQ=;
        b=NM6S4gaxIN4dR6O2NMb+wZxhI8uX2W43DPpldelCebeYv64B/C1REVzV2K0bfetJnZ
         qiHRF/xy7ZVuBthXEw0azsw1QAHNTxhiJhIqrRf80DS5HEF+FVfx1n9r0DaEK94fflwm
         JP9PJyzRmZdHR6qfDsW+lf7wcdM23ABrZYpRjKeKxixpgEPOluKS6vjVYPuqS9J+MMQE
         Vug3s3iC5a2/J3LQ/kC/AyrGKlZSLtarOBovjnLsDIXUvcGQ6u5Dnq8W9jAxePsCyB/q
         GrdMNR1a2PHE0ebV+c2IdyGRT5puv/dvwZo3xcn9RNF2OBkn2oKY3ruRxvMbxSUwzgqz
         C6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lagOiNmOcrwRrV1/ate4UBE5MpqgcNFKZJhHzH/1ZLQ=;
        b=FYkSHgCdtch9siIy7ZbBkZh3LfI+t4EaQ7p04Wrf5ARdJumK9bl4Oy7M3ERJCOsDG8
         Z/UvyNTmbC8RkrsohLyjzYiU1tPpEX+6QLN8Whtg7f+0L/gHzEbpT+d+2Z0RuelsENJQ
         JNBvFVOM42ycOQ1W0Bfic2NMfLFjkGBf7EPRhtAfnOSCdXNeXW5ZLH4pdn07SdZEqnic
         lXLtTgWQzbfQasTSWJxVGpdR4E4vUHZv0A+1/OteYb8TDmDJM24/SqSIlW+LjT+h87vd
         qfTbymXqK+UOyTKXDWJw/jl6Nm0GxFklYE/jFFkZJnu2ofgFqdODE0A/9WCg2H5CuuUj
         yeVQ==
X-Gm-Message-State: AGi0PuZobqZD2/bEi7mgPdCUY4hkhlQYMGmIbqWSExQNG7qQsb83zBWw
        t1zMsaBMmv9N7Mmf5p8rFpEsZO4gYK42Fg==
X-Google-Smtp-Source: APiQypLqHjJg707kI7iibOZvklK6IrdGJOeHGg5wAJ6SAXC0LQqkbjI0wnBkZmeeQTijSGNeSm5WrQ==
X-Received: by 2002:a17:902:6b01:: with SMTP id o1mr17976450plk.100.1587401500546;
        Mon, 20 Apr 2020 09:51:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p10sm1526051pff.210.2020.04.20.09.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:51:40 -0700 (PDT)
Date:   Mon, 20 Apr 2020 09:51:36 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Benjamin Lee <ben@b1c1l1.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc: fq_codel: fix class stat deficit is signed
 int
Message-ID: <20200420095136.59cfd7dd@hermes.lan>
In-Reply-To: <20200415041112.32679-1-ben@b1c1l1.com>
References: <20200415041112.32679-1-ben@b1c1l1.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Apr 2020 21:11:12 -0700
Benjamin Lee <ben@b1c1l1.com> wrote:

> The fq_codel class stat deficit is a signed int.  This is a regression
> from when JSON output was added.
> 
> Fixes: 997f2dc19378 ("tc: Add JSON output of fq_codel stats")
> Signed-off-by: Benjamin Lee <ben@b1c1l1.com>
> ---

Applied, thanks
