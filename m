Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163B85501E0
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 04:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383835AbiFRCML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 22:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiFRCMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 22:12:09 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869AC6AA40;
        Fri, 17 Jun 2022 19:12:08 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id p1so4061926ilj.9;
        Fri, 17 Jun 2022 19:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=r/6+/AHt+HZI8YUEqtv8kZ1LRpMZA4bMPoqnri1dvzY=;
        b=Z2ECTprNLG5NvgN85/BYWE77BKlJc+32WCVomvgYXUmA6x0u2vBGBQx8TwHfmEGN+d
         DBx+uv6XDlzrV8/naTM5V/1ouQz84rBVkSvjYhUbSXx/7V8in8q6ueRn/FDsOeyjmRhv
         2lsgmS28h0s5m6vXh/6LoztD50LZMwq+UGjisKTJeo/9QcZCnuJ1TlyeTdlYwGKTyHxA
         cvWC+xTt89th7+M8qw+vfoZa/BzWJAEcxJRfQWYL6x7xycI7vwYFBfyDCWXSCfHTX68w
         nMeh6W8a8JZIWguaK25AkqjJNItG4YJEH7MfBeqT3u5ySH//ZrObgCqytGT3UpaDZrQH
         ZNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=r/6+/AHt+HZI8YUEqtv8kZ1LRpMZA4bMPoqnri1dvzY=;
        b=yL5D8RYco9QazG/chzcSXdsjsGElDQuEXVKSmDCPEe9jJJ1trWoyt+c5Apa2hF6xDH
         H+wOK6eYj1Xiz+MLISrDGwIzkLfr9S2BCovEdMqGY9xdVIptqQwJFu7hiT4N0rjBMLbI
         Xg5XBJmvqQvP2FNeH9M7GGtxUV+jMCSRBUVRLOUd72Lv/b+QnckcfbcAo3mmWEl5zGzJ
         pAVtp5muDXYIhTg0y9AM0LMubYSxPZlPOrTs+AyNgeruWL1flJQrkT0FCG3sTRJJoNul
         4Ez2azBfQrN0T552vZuhur7BYGnlOEHZddLLY16wOIA0GkXzH+8iSWtYkVmuFascuYMT
         ZDRQ==
X-Gm-Message-State: AJIora8C7GCibZBw9p1LDSwq7z9dCt2nFwHniMm+uNFxsl7am2+DBKTr
        sXfzhc5mZI3iSvvbtST/xj8e8dHSiyZmcw==
X-Google-Smtp-Source: AGRyM1vhOUOJCsI4d1Q3YnauEoFscZEjo0dwBCyxHUR81QIg3Z9Q+JaQGCiGEv6eBemFWJdwql9KwA==
X-Received: by 2002:a05:6e02:19cc:b0:2d3:e20f:4959 with SMTP id r12-20020a056e0219cc00b002d3e20f4959mr7566784ill.40.1655518327802;
        Fri, 17 Jun 2022 19:12:07 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id v3-20020a922e03000000b002d8f50441absm419156ile.10.2022.06.17.19.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 19:12:07 -0700 (PDT)
Date:   Fri, 17 Jun 2022 19:12:00 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <62ad3470573f9_24b342082e@john.notmuch>
In-Reply-To: <20220616180609.905015-6-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-6-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH v4 bpf-next 05/10] selftests: xsk: query for native XDP
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> Currently, xdpxceiver assumes that underlying device supports XDP in
> native mode - it is fine by now since tests can run only on a veth pair.
> Future commit is going to allow running test suite against physical
> devices, so let us query the device if it is capable of running XDP
> programs in native mode. This way xdpxceiver will not try to run
> TEST_MODE_DRV if device being tested is not supporting it.
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 36 ++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index e5992a6b5e09..a1e410f6a5d8 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -98,6 +98,8 @@
>  #include <unistd.h>
>  #include <stdatomic.h>
>  #include <bpf/xsk.h>
> +#include <bpf/bpf.h>
> +#include <linux/filter.h>
>  #include "xdpxceiver.h"
>  #include "../kselftest.h"
>  
> @@ -1605,10 +1607,37 @@ static void ifobject_delete(struct ifobject *ifobj)
>  	free(ifobj);
>  }
>  
> +static bool is_xdp_supported(struct ifobject *ifobject)
> +{
> +	int flags = XDP_FLAGS_DRV_MODE;
> +
> +	LIBBPF_OPTS(bpf_link_create_opts, opts, .flags = flags);
> +	struct bpf_insn insns[2] = {
> +		BPF_MOV64_IMM(BPF_REG_0, XDP_PASS),
> +		BPF_EXIT_INSN()
> +	};
> +	int ifindex = if_nametoindex(ifobject->ifname);
> +	int prog_fd, insn_cnt = ARRAY_SIZE(insns);
> +	int err;
> +
> +	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "GPL", insns, insn_cnt, NULL);
> +	if (prog_fd < 0)
> +		return false;
> +
> +	err = bpf_xdp_attach(ifindex, prog_fd, flags, NULL);
> +	if (err)

Best not to leave around prog_fd in the error case or in the
good case.

> +		return false;
> +
> +	bpf_xdp_detach(ifindex, flags, NULL);
> +

close(prog_fd)

> +	return true;
> +}
> +
