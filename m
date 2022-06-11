Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1058547772
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 22:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiFKULY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 16:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiFKULX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 16:11:23 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB1F50E2E;
        Sat, 11 Jun 2022 13:11:22 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n18so1978987plg.5;
        Sat, 11 Jun 2022 13:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZiH4TRfnRyLIeMYFGZRSlq6I0QJI5DZKCK6Q6FfZ+dI=;
        b=TroryHdp+Mh9Uxb/90OFg6dcmzsKzod+wGc0iByUCHTEejhEVJ2mQ8oEQBGpxAr8uP
         GBUAuuDvcSClS8i5iCy+aaKgBuNTldlUQa06bj86DAhLFI4NbDfrIqn9xhHhwm3QL4cz
         WpWUhY3APEsZHxoVtj6a2VS66IyRMNp6uoICdYUet4kYWtMEqDdD+GoskpCIlX4QzGrN
         9HmNYEAPKPsPEQM9d/sy4IwO1qRziE5PYSYkc1JHhcAONpzES1eguad1/GGREPILDaEG
         xZmDj0GS6kGLCRzzfDoscUij4FzffnI9f0FbdcSlXs3D6mqk3gWZjiitcs4DF9CBHWVG
         QBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZiH4TRfnRyLIeMYFGZRSlq6I0QJI5DZKCK6Q6FfZ+dI=;
        b=CDW5PjuT91mq7tRumCm43+WWAexvOhXsDW5vdwbQsAebQmLzE6MfyS591SwTkxhvNq
         YsCLMtVO1u3GwIKiVfY1jaxSCvTEKgXoIn9knjYELyJoeLEqMoTKD1jSdZQsxyIn7txY
         bd8I3PbvRheC4RTcWin+77uDuYQZNKOG3FpGzWUltQ0ALVYxfvEaw4/5StsxPLddb2tN
         kfeOm22M28G3CTvjHtf02kr6IlVt875vd3xnVf7qiqd2uF70S7NjgtCVeEviyKrQPa3o
         1STUMCJPm/uuuXhmaG1g8OgDJev4HdpoH8rO1Nb7Wg+Pwo7DMOvimDNNaYobodh4veJ2
         JOzA==
X-Gm-Message-State: AOAM533/9IxKB7PP/EfqyaISVZV/kVatHNc+KaRuQH/+mYpjjqhFm971
        U6q+EfzmX1TSOwOIhBKtLVCLFtqAqcw=
X-Google-Smtp-Source: ABdhPJyhptHUrnDjl1evG9JYHqVjnDS7ugr+WiBysKcwjuWyzOqHZ1dVrLcUWIaPvIG1lSeiEwXTQQ==
X-Received: by 2002:a17:902:ceca:b0:166:3418:5267 with SMTP id d10-20020a170902ceca00b0016634185267mr50810227plg.136.1654978281465;
        Sat, 11 Jun 2022 13:11:21 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::4:93e3])
        by smtp.gmail.com with ESMTPSA id a13-20020a62e20d000000b0051c2fc79aa8sm2029560pfi.91.2022.06.11.13.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jun 2022 13:11:20 -0700 (PDT)
Date:   Sat, 11 Jun 2022 13:11:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: Re: [PATCH v4 bpf-next 00/14] net: netfilter: add kfunc helper to
 update ct timeout
Message-ID: <20220611201117.euqca7rgn5wydlwk@macbook-pro-3.dhcp.thefacebook.com>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 11:34:48PM +0200, Lorenzo Bianconi wrote:
> Changes since v3:
> - split bpf_xdp_ct_add in bpf_xdp_ct_alloc/bpf_skb_ct_alloc and
>   bpf_ct_insert_entry
> - add verifier code to properly populate/configure ct entry
> - improve selftests

Kumar, Lorenzo,

are you planning on sending v5 ?
The patches 1-5 look good.
Patch 6 is questionable as Florian pointed out.
What is the motivation to allow writes into ct->status?
The selftest doesn't do that anyway.
Patch 7 (acquire-release pairs) is too narrow.
The concept of a pair will not work well. There could be two acq funcs and one release.
Please think of some other mechanism. Maybe type based? BTF?
Or encode that info into type name? or some other way.
