Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09EE9570012
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiGKLT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiGKLTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:19:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5E913F51;
        Mon, 11 Jul 2022 03:42:56 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y4so5702276edc.4;
        Mon, 11 Jul 2022 03:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mAxaTXLOONmjNbyePKQ0Oe+76S7dToMI0udvJ0aLQuE=;
        b=nLnSdS2bsTXQRPj1wBTtZ4bEbaghoEJScz9VrFN+2Ky0OqbwKoPYqTL3DcRk/76UKd
         wwy6tVAm+pJevl+P3ZhqWhp5bQ/uqBP8vEEkpOzEv/7C7M90atPtGp94wFkKGlKgDaHQ
         mpafWSFtsqthH8ZGfCOu8sgtvA4YPzzvMVkCvxvkoLRA6rnCyTGRvDSqNGU/wNNSmc9G
         ecmEM4QEQcqy0BEZGZzyndr8OUa9oWZqHHxLpUVoIrnlEcpHjWU3tCPMpgRS9s/o5b8q
         obyR75lpwPTj9zytqI945aFTAuo8/zq06VV4mglM4BVqngS2hBW3FRqz6VwllaFVGgks
         pvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mAxaTXLOONmjNbyePKQ0Oe+76S7dToMI0udvJ0aLQuE=;
        b=crW5yMrfH85DvirVPmGATf7FkAVSSp2ew2kA+3tJUMm5cb5h4OBZJLBApugmxYTRZj
         T0dcMA6gLRzEo+I3Y94JPLm1V/0SUbYzW/vCnhsT7c6h4zsFCQ1VQgm1/ZYLTVddhZNl
         waEHAkNEnFrxXD+rbweRpEUPuicXDxDJ8nuUr3z30CZyARgTQXyAgL8JCe3/stMpvUso
         f8j89dgqzMFRPEKXU7PLYw2QjwgP9ryHjL6VcYCLEMNJPl1M8pI94PwgoRwuBYx7/e3L
         SVqGnn5EpL0fPRTvelW834q6SAtrCfJkF4nFbIbRX2SdVES4K4CBztjXryJtXOt5C4eM
         8Xkg==
X-Gm-Message-State: AJIora+49qFNRYIHGge4cXDZELROL1eygPfglWUvSSBUrOIdSoYD4WOE
        954T/8Ju2ObM6Ik7yTtGKt4=
X-Google-Smtp-Source: AGRyM1uG3vrope7X095RhonOWdp67gsf4EJGO2+BVUXC4bGPf+gT2oFF8Na30DKSVSPj6U11hUBmcg==
X-Received: by 2002:a05:6402:1909:b0:43a:64bb:9f27 with SMTP id e9-20020a056402190900b0043a64bb9f27mr24474339edz.24.1657536175257;
        Mon, 11 Jul 2022 03:42:55 -0700 (PDT)
Received: from krava ([151.14.22.253])
        by smtp.gmail.com with ESMTPSA id f10-20020a1709064dca00b006fef557bb7asm2548684ejw.80.2022.07.11.03.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 03:42:54 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 11 Jul 2022 12:42:51 +0200
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCH bpf-next 3/4] bpf: add bpf_panic() helper
Message-ID: <Ysv+q4VTWPr9wyxn@krava>
References: <20220711083220.2175036-1-asavkov@redhat.com>
 <20220711083220.2175036-4-asavkov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711083220.2175036-4-asavkov@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 10:32:19AM +0200, Artem Savkov wrote:

SNIP

> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 4423874b5da4..e2e2c4de44ee 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3927,6 +3927,12 @@ union bpf_attr {
>   *	Return
>   *		The 64 bit jiffies
>   *
> + * void bpf_panic(const char *msg)
> + *	Description
> + *		Make the kernel panic immediately
> + *	Return
> + *		void
> + *
>   * long bpf_read_branch_records(struct bpf_perf_event_data *ctx, void *buf, u32 size, u64 flags)
>   *	Description
>   *		For an eBPF program attached to a perf event, retrieve the
> @@ -5452,6 +5458,7 @@ union bpf_attr {
>  	FN(tcp_send_ack),		\
>  	FN(send_signal_thread),		\
>  	FN(jiffies64),			\
> +	FN(panic),			\
>  	FN(read_branch_records),	\
>  	FN(get_ns_current_pid_tgid),	\
>  	FN(xdp_output),			\

new helper needs to be added at the end of the list

jirka
