Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80616A5DCB
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjB1Q6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjB1Q6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:58:11 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E203360A6;
        Tue, 28 Feb 2023 08:57:42 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id ks17so7298486qvb.6;
        Tue, 28 Feb 2023 08:57:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xi93O+rRn4aRd4H/aiNOFHakc7MP7cPv7/dMUnMwCRE=;
        b=OZ9QL7iVs5apLmxkwJBLKGWwcjtG/84ZZMDk8n31Xx4lYc4DTGrWt4Ov4YkcbfE8c/
         jTy1P/JslbA6fpkIxPk5Dx6sxQaT9krYQjCDnvozsJkwFwUKW4dxXMLQI+e/AaSQv6VR
         SIx0QN914VoUmczSTbcGkWo+Th/0MrFr7pkjljsyVjZBFUA1Nr+FNUolm+Xq6AVdJHw6
         6a/eOG6qC5yEWUKEsV6WhBUc1GjFRgozTglpgGTEAx/wVRlJ180PqiH8y+DrDzQKVsXb
         21Igh8/A7IU/wmx3j33zfKbmlBH4oQe1A+Nd3/3xGm2hzs/jSVS+wZCCCdYs46+DWpDk
         SnpA==
X-Gm-Message-State: AO0yUKUyt1CkkN8++A/BtBSJ0wUVHKy9dow3vBd6KJmRunGbTvJqA6GG
        kUP5pby8y94kf9vjk4YowaHV9DEGVxvi9ywm
X-Google-Smtp-Source: AK7set/gEFAjQcgfZ/eiWt/jHtwc2ppbuYygxK6z4rCCKDWtHnj4jmYn1Se4HaFs1lbhiKUXMZ2Fqw==
X-Received: by 2002:a05:6214:29e9:b0:56b:fa99:7866 with SMTP id jv9-20020a05621429e900b0056bfa997866mr5927742qvb.7.1677603161327;
        Tue, 28 Feb 2023 08:52:41 -0800 (PST)
Received: from maniforge ([2620:10d:c091:480::1:f172])
        by smtp.gmail.com with ESMTPSA id n76-20020a37404f000000b0071aacb2c76asm6962499qka.132.2023.02.28.08.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 08:52:40 -0800 (PST)
Date:   Tue, 28 Feb 2023 10:52:38 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 4/5] selftests/bpf: Add a test case for
 kptr_rcu.
Message-ID: <Y/4xVnKxyB7ovsEF@maniforge>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
 <20230228040121.94253-5-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228040121.94253-5-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 08:01:20PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Tweak existing map_kptr test to check kptr_rcu.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: David Vernet <void@manifault.com>
