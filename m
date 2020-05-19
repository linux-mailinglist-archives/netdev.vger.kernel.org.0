Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4AE1DA398
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgESV3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESV3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 17:29:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B196FC08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 14:29:34 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f6so429308pgm.1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 14:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aV2/I5RnVkJEm8zBODoUjTytEZBvDuZNCyt9ix7Q9gM=;
        b=KrgcvXFA5dDUdEV/7y47dHxrk5vxjUGeW07P7KpAKJWsglKnOerrd/K/rCM/VBZT37
         QAn44o4PbB+3Ef7fkUcPkneiicap/tez9dxexWRzkIJl/TtyP5ULS/LkSm9/fZ7MUeUL
         84nHgkVa8kpXwQN3CcpSyIpBwZRgj1fsPra6FqwGnZqfCYjNMyLc39P6/wfikTLclmOb
         xVdjXT9+yZbQ4k8eXV+gdUqUnmM3lXT2z3YpCPSR1M667DIqBpu0loXWtNJaycrThbb4
         bH1KaKxprwa4bGhFsE3Rt8KJwhNzyl4OCOn6/yDT9MRzMGnxlm3PDh8ve9CNWb1effCC
         XyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aV2/I5RnVkJEm8zBODoUjTytEZBvDuZNCyt9ix7Q9gM=;
        b=so44I0jVXeB91Qyx6KQjcGvPX9kEy25BdBqASh/QPw9S7kW/ZpPnuQqGzkLeTNSTWs
         m3t/mmCEyF98pBUl/XxdacaXWhbZ6cG4tNX0nKDE31GXMzPnW64fMcHwxYjP8Miq1QuN
         NUnioMnpFtMy7wup9MqzI/fSGC0LoIuEF3XN1l2QhfGvFXCTy98BAJ98v6nwKeTNX5VT
         Vr3QqivvMjRG7TazM27vLdUNhcVZcYdJRbGuI42wJND9CsJBf2B7mulhOrBAWs9jTkDL
         CpqqVsecSljzimxhiS8wuAElqiH89MkYJYkott7fy+z5SzaEb3j02bRGN9aty/SnPlHq
         RgoA==
X-Gm-Message-State: AOAM533lyl2WltgXDzySTUwzQSZTJ7lBk20UvccJazPfr516Z9u1H2o1
        5dlxVZR7/TDOwIVj/dMD7Kj6pg==
X-Google-Smtp-Source: ABdhPJzFmpvW4Yh9asIcYjRTOewB2GU6m2ab6+hUe8uHekPJVpBx5WlduydHe3qGW9v8XYMI+ixmhw==
X-Received: by 2002:a62:e51a:: with SMTP id n26mr1020027pff.301.1589923774047;
        Tue, 19 May 2020 14:29:34 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n19sm396338pjo.5.2020.05.19.14.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 14:29:33 -0700 (PDT)
Date:   Tue, 19 May 2020 14:29:25 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, kernel@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2 1/1] tc: action: fix time values output in JSON
 format
Message-ID: <20200519142925.282bf732@hermes.lan>
In-Reply-To: <1589822958-30545-1-git-send-email-mrv@mojatatu.com>
References: <1589822958-30545-1-git-send-email-mrv@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 13:29:18 -0400
Roman Mashak <mrv@mojatatu.com> wrote:

> Report tcf_t values in seconds, not jiffies, in JSON format as it is now
> for stdout.
> 
> Fixes: 2704bd625583 ("tc: jsonify actions core")
> Cc: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
> ---
>  tc/tc_util.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/tc/tc_util.c b/tc/tc_util.c
> index 12f865cc71bf..118e19da35bb 100644
> --- a/tc/tc_util.c
> +++ b/tc/tc_util.c
> @@ -751,17 +751,20 @@ void print_tm(FILE *f, const struct tcf_t *tm)
>  	int hz = get_user_hz();
>  
>  	if (tm->install != 0) {
> -		print_uint(PRINT_JSON, "installed", NULL, tm->install);
> +		print_uint(PRINT_JSON, "installed", NULL,
> +			   (unsigned int)(tm->install/hz));
>  		print_uint(PRINT_FP, NULL, " installed %u sec",
>  			   (unsigned int)(tm->install/hz));
>  	}

Please use PRINT_ANY, drop the useless casts and fix the style.

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 12f865cc71bf..fd5fcb242b64 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -750,21 +750,17 @@ void print_tm(FILE *f, const struct tcf_t *tm)
 {
        int hz = get_user_hz();
 
-       if (tm->install != 0) {
-               print_uint(PRINT_JSON, "installed", NULL, tm->install);
-               print_uint(PRINT_FP, NULL, " installed %u sec",
-                          (unsigned int)(tm->install/hz));
-       }
-       if (tm->lastuse != 0) {
-               print_uint(PRINT_JSON, "last_used", NULL, tm->lastuse);
-               print_uint(PRINT_FP, NULL, " used %u sec",
-                          (unsigned int)(tm->lastuse/hz));
-       }
-       if (tm->expires != 0) {
-               print_uint(PRINT_JSON, "expires", NULL, tm->expires);
-               print_uint(PRINT_FP, NULL, " expires %u sec",
-                          (unsigned int)(tm->expires/hz));
-       }
+       if (tm->install != 0)
+               print_uint(PRINT_ANY, "installed", " installed %u sec",
+                          tm->install / hz);
+
+       if (tm->lastuse != 0)
+               print_uint(PRINT_ANY, "last_used", " used %u sec",
+                          tm->lastuse / hz);
+
+       if (tm->expires != 0)
+               print_uint(PRINT_ANY, "expires", " expires %u sec",
+                          tm->expires / hz);
 }
