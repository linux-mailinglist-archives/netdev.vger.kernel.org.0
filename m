Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9B2602905
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 12:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJRKJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 06:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiJRKJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 06:09:38 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792181A077
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 03:09:35 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c24so13385426plo.3
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 03:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zKUSHBzIV9AmjcAPIwH4d1e4/pivyZO+yk3jBrIXqik=;
        b=Og8qUuzdDioBAnndTRdVzqW2TKX37JQVBINZ/GxEZMvHmg91nkbp/PJcaf8RpNdIEr
         CX+xnORcAVblgI6/GK7I1zT5c5+88KvTGhc96WQKY4nHKe4MQ34CBQjvxc4GiiK13BwG
         JbpG2Xjma0DFxR3gRlBpequA1KZ/aXUeyFs4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKUSHBzIV9AmjcAPIwH4d1e4/pivyZO+yk3jBrIXqik=;
        b=OrCptjhjs2ovO6FFva6a5HB2Qyc1IjzpZH9sZbvIWB5foPWRu2mOgpFRNcKlNzEy4f
         /S5Im4Exm/XriSvYj1F+6Ec3alRMynhdk3pxaqRE3WFuJsJOU9iyR9jHN6nTmu8EczYJ
         tLT5P4EGaMqAM7mMoIhmNb4sU9ihLS9xkuiel5mNTrau5Mc/D+yjzA2flKr8W1M0WOE0
         5DXXciDXf2RZdG6B1RA+QzxlsV/+WR/JpUMIOMl8LllgxGvAzhvjVNFNgx9G3xecSRkh
         cZ1RhyP98Pi6uopsav0oboVkCnqHC1h8a2jjZYubyDR4G/RckUl1nLa9Qyrt5gWLlOYs
         hXAg==
X-Gm-Message-State: ACrzQf344vdIPeoO0mN0tpb5gHrW/DZNz5BmTi0OWMEnXQnsleN0MkEf
        yRUDYJ1Vsgrxds5InwEM4aQ8tnd/I9QjBw==
X-Google-Smtp-Source: AMsMyM5wU1XEsuBMrD5Wn9zq3F5URSQDleuB2+Yfz06/29+vEOi6q0FdiYAl8IeHpZIEEsdsNB+sDA==
X-Received: by 2002:a17:90b:1c11:b0:20d:459b:ef0e with SMTP id oc17-20020a17090b1c1100b0020d459bef0emr38396657pjb.129.1666087774961;
        Tue, 18 Oct 2022 03:09:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x1-20020a170902ec8100b0017da2798025sm8337107plg.295.2022.10.18.03.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 03:09:33 -0700 (PDT)
Date:   Tue, 18 Oct 2022 03:09:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Michael J Ruhl <michael.j.ruhl@intel.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 0/2] igb: Proactively round up to kmalloc bucket size
Message-ID: <202210180307.484A016FE0@keescook>
References: <20221018092340.never.556-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018092340.never.556-kees@kernel.org>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 02:25:23AM -0700, Kees Cook wrote:
> Kees Cook (2):
>   igb: Do not free q_vector unless new one was allocated
>   igb: Proactively round up to kmalloc bucket size
> 
>  drivers/net/ethernet/intel/igb/igb_main.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

Ugh, yay for my MUA vs commas. Sorry for any future typo bounce spam. :(

-- 
Kees Cook
