Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8945E6B60
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 21:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiIVTBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 15:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiIVTBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 15:01:09 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76325EC547
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:01:07 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x1so9671862plv.5
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=a2k7VIf9yApRVASkiouBRAjZ/x7f5BnhPM9mNJfTXt0=;
        b=dSRlqc5HZTD0awe0K+JKMhSru9wlaaHtntIoS81CDl2LJL1Xbsu9j2p8msQZPIlrf7
         xJQV+5ettPRg9D/D+UBR3ooX8cdrFy/y6gc+wnL4lyV4PM76qLeLbuu++3oziJ1tGWZt
         w7rOvuAfnpKZVsqGu66zrN4CEe89XXSG52Vcj5cWNLQAPKVDNjHsZh2eRiOPQsiqUVuM
         zmYMFrPEC1fIgKg7smOnI4N8nW/fOapyftad7iqJ3EIxEOyvBvw9CVz8+CZEg3HDDHXT
         MQYX+yuyUu+hPH/0gt5QeCISJcHFLzareZ+lrdbepP8R5vlBdERuiCGIYNP+gW8z8Xtd
         E7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=a2k7VIf9yApRVASkiouBRAjZ/x7f5BnhPM9mNJfTXt0=;
        b=mMLOQQJZbTeQaQZoOeBskxrytTZQ2sxn/mPSBDXA8L3FQ3GmmSYqx9YUSjHIElh3gb
         GUPJJOWJkEOoqjEOiMiszbKKB+D3XoPKrGd6BDSOCGONoLh4fCc9gvpLOnqsYGU1MOgH
         Wu1G/u4qgm9Gu/gafn/Qg8Odkwf0fI9aNy5TTHfYTEMRgBkcZIMeqs+ojz8mMovBHFkJ
         3ToUpM9vUKVSKv9Q+sT5IQNhWYDFW75lZa4FbEyjcN9O+9mrY7NSrsQQ5+CTWHOW71ps
         EjsiYNtuXxopaT5nITr0QuTbeXWpmxacf7i16h3QMgHaDrR3R+AhrQku+LQNKsjt5Xkm
         1+Uw==
X-Gm-Message-State: ACrzQf1o30zLVaEy5wei4EGSPPpYV87fiZiKTj34z+XYDanIfcJrBZMp
        WiotF33zsp2YCejiTLmzWs9vTIWBzKvAJg==
X-Google-Smtp-Source: AMsMyM4+04PF3vmcOyVxbmORaB0xef1dZKDX/frAqgPGe76uWJOCHyvBf/6cgPvbsvLcSLscdmwmJA==
X-Received: by 2002:a17:90a:ac10:b0:202:9880:4cae with SMTP id o16-20020a17090aac1000b0020298804caemr5141045pjq.173.1663873266869;
        Thu, 22 Sep 2022 12:01:06 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id m14-20020a170902f64e00b001789f6744b8sm4398765plg.214.2022.09.22.12.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 12:01:06 -0700 (PDT)
Date:   Thu, 22 Sep 2022 12:01:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] Fix segv on "-r" option if unknown rpc service
Message-ID: <20220922120105.7a200fd2@hermes.local>
In-Reply-To: <87tu55q48x.fsf@mail.parknet.co.jp>
References: <87tu55q48x.fsf@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Sep 2022 02:50:54 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> +		} else {
> +			const char fmt[] = "%s%u";
> +			char *buf = NULL;
> +			int len = snprintf(buf, 0, fmt, prog,
> +					   rhead->rpcb_map.r_prog);
> +			len++;
> +			buf = malloc(len);
> +			snprintf(buf, len, fmt, prog, rhead->rpcb_map.r_prog);
> +			c->name = buf;
>  		}

Thanks for finding the bug but this could be improved.
This seems like the hard way to do this.
You are reinventing asprintf().

Would this work instead.

diff --git a/misc/ss.c b/misc/ss.c
index ff985cd8cae9..9d3d0bd84df3 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -1596,6 +1596,10 @@ static void init_service_resolver(void)
                if (rpc) {
                        strncat(prog, rpc->r_name, 128 - strlen(prog));
                        c->name = strdup(prog);
+               } else if (asprintf(&c->name, "%s%u",
+                                   prog, rhead->rpcb_map.r_prog) < 0) {
+                       fprintf(stderr, "ss: asprintf failed to allocate buffer\n");
+                       abort();
                }
 
                c->next = rlist;
