Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929656A786D
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 01:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjCBAcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 19:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCBAcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 19:32:51 -0500
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8734AFFA;
        Wed,  1 Mar 2023 16:32:50 -0800 (PST)
Received: by mail-qt1-f169.google.com with SMTP id l18so15366363qtp.1;
        Wed, 01 Mar 2023 16:32:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677717169;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2FLZWAsR5f0jPIqwITafOGGJhUS6StGpjBhKGtgZEfI=;
        b=I+qBq6cD8bP6BlesrGEA73lzQb/CsVNJDuPLg7CTXc2zSDCtd3AirOBr6BcdT0qk5f
         hiTXDgb7oPar/gZvAczsH9jVmo65qhMbo/zMWuUwbtVm3dei9jRFku5mKW3yvGsC6Ibp
         3Q884vz+qE1ZQ5tGdMRYH2ybyVKw/oxbvIg2Xd7R5GAkErf0P9WVrcHmuutVt0RjvZS1
         e3MseVq8hkfSsvJj+Orn9a7Rso6EzUcQY87PWRtFtwnEqLTZtWGjcXGw49FOr9bkBq0J
         GMOKUbxWsvEs7AxLs1saw638IO/4bvn1iBsWFIxhk1au15WN7va1HKkQbnxXyZ6nDHO1
         DvHA==
X-Gm-Message-State: AO0yUKV7/Smi5I/Y/YI3/FkCzu/GYbJ2z2N64oNVFA0/dtajrAeHGc9o
        pCcIsc1UmrRXfKYb4tSx+JQ=
X-Google-Smtp-Source: AK7set9e1Bj9kmCVP+IN/GFm4/PxQAtMaPxshtWWMzhTeuWjtbyokr/moq42WawEBXIvSNo8L7UJMg==
X-Received: by 2002:ac8:59c8:0:b0:3bf:d161:799e with SMTP id f8-20020ac859c8000000b003bfd161799emr14289929qtf.65.1677717169332;
        Wed, 01 Mar 2023 16:32:49 -0800 (PST)
Received: from maniforge ([24.1.27.177])
        by smtp.gmail.com with ESMTPSA id p1-20020ac84601000000b003bd01b232dbsm9279016qtn.43.2023.03.01.16.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 16:32:48 -0800 (PST)
Date:   Wed, 1 Mar 2023 18:32:46 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 5/6] selftests/bpf: Tweak cgroup kfunc test.
Message-ID: <Y//urthbcf16kHBI@maniforge>
References: <20230301223555.84824-1-alexei.starovoitov@gmail.com>
 <20230301223555.84824-6-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301223555.84824-6-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 02:35:54PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Adjust cgroup kfunc test to dereference RCU protected cgroup pointer
> as PTR_TRUSTED and pass into KF_TRUSTED_ARGS kfunc.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: David Vernet <void@manifault.com>
