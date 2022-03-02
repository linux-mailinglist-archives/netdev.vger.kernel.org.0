Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76ED34CAE32
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244896AbiCBTFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244920AbiCBTFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:05:30 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE08FCE912;
        Wed,  2 Mar 2022 11:04:45 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id e6so2440692pgn.2;
        Wed, 02 Mar 2022 11:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=89mCuEEPrHsDNLVc4CIhD+BpAIBZ4ipH8mmu8QHY24I=;
        b=ASaAtjHAZ6ZUzTh4PD6SWipUIIfM/2THlxXj1EddQIJUeNE+f0Ed54nasQgGf6sSRm
         fmGv9F894L/kwRtROdxR+bmzOdzy+ltKxEuR+0ewjxemfuHKW05FZ1fTVPCZVBVp5vxN
         DBF+pVPbE6Snnwa0J+28pRn2uopN4fBBe/peJkEWLEqhO5skx5H0Xser4LjMTXIC0Ncl
         gkhBehQfs2HPUKBwc+ZClo21sS2huqlmadns2kPEzCZvzBwADXCYobjOkWR7PQ/bmPoL
         ijsDDnmWdd7deZhKeNupBsY4puZymFVArw/JyCQHczo/Qm0+RWrwlCj0gsmm029pflPt
         WEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=89mCuEEPrHsDNLVc4CIhD+BpAIBZ4ipH8mmu8QHY24I=;
        b=dFIV+YO+aIs46nSKMUXJiyDGxNLx6TO9liGMj4VFy586duePAkALx9bicY9YhdCn9d
         Kl6sc2Xf7uAsd1Oh8Pywj1YTprWA8zAGQHL3PD7gKtblAiV3i6v6gDkp/VsXTbkwABAL
         v8n9jnvn6/Q5uBLHd9ruXatTV59qAVFrCgMV7dqdMyqJEvG0Ght8mb0zRkdfpkefyE8c
         K8TZJ+Fw0xGg7OHOtPV1qtvifHjgnZIpn9bzKu/q3ntnz3mmqXlbS74H75HbouX6yZ5c
         SEbeHYuFbQlIIAdMjfLlVGNkuIDuTL9DSwXwzA0MVbpZl8W+JkCXqiqcEaPHGEeQr8Gy
         ACVQ==
X-Gm-Message-State: AOAM533ku4sOaMgqC7cdQ1ulRyd28TyfY0qH+zluDDILvjJcZfUandaH
        LHrr7plnEzBoev6nyHF9cFA=
X-Google-Smtp-Source: ABdhPJzSF4lKkKQmBZEuODpUX0JiH/7aVt+3OpLX5P4rezHsTIcSBmTrJlQOsdKcjOnhkR7LWLOTYA==
X-Received: by 2002:a05:6a00:c95:b0:4e1:1f5a:35cf with SMTP id a21-20020a056a000c9500b004e11f5a35cfmr34510025pfv.56.1646247884848;
        Wed, 02 Mar 2022 11:04:44 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::2:156b])
        by smtp.gmail.com with ESMTPSA id q13-20020a056a00088d00b004e1bea9c582sm22324779pfj.43.2022.03.02.11.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 11:04:44 -0800 (PST)
Date:   Wed, 2 Mar 2022 11:04:40 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v8 2/5] Documentation/bpf: Add documentation for
 BPF_PROG_RUN
Message-ID: <20220302190440.t5cvezlkg7ynajam@ast-mbp.dhcp.thefacebook.com>
References: <20220218175029.330224-1-toke@redhat.com>
 <20220218175029.330224-3-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220218175029.330224-3-toke@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 06:50:26PM +0100, Toke Høiland-Jørgensen wrote:
> This adds documentation for the BPF_PROG_RUN command; a short overview of
> the command itself, and a more verbose description of the "live packet"
> mode for XDP introduced in the previous commit.

Overall the patch set looks great. The doc really helps.
One nit below.

> +- When running the program with multiple repetitions, the execution will happen
> +  in batches, where the program is executed multiple times in a loop, the result
> +  is saved, and other actions (like redirecting the packet or passing it to the
> +  networking stack) will happen for the whole batch after the execution. This is
> +  similar to how execution happens in driver-mode XDP for each hardware NAPI
> +  cycle. The batch size defaults to 64 packets (which is same as the NAPI batch
> +  size), but the batch size can be specified by userspace through the
> +  ``batch_size`` parameter, up to a maximum of 256 packets.

This paragraph is a bit confusing.
I've read it as the program can do only one kind of result per batch and
it will apply to the whole batch.
But the program can do XDP_PASS/REDIRECT in any order.
Can you make "the result is saved" a bit more clear?
