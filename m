Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B344662C8D
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237054AbjAIRVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbjAIRVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:21:12 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC411659D
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:21:10 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id o7so9228710ljj.8
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UmkMrNENzFG1JKYmMl3Q1UuB0T9rdrmeFqUnSAQIEyA=;
        b=Weyb8wVKeq8zb4iVCvJ1/+Xp7EXBoURs5UXg+qScW5ARBAwfBKXN/cn7HJk3Mhf4Qo
         UB2n9TRHtX4zeS4UI6aoediGLagf2Ge7LJCKIvhewlCt7KgIwMBq8gs4/HJgOZSQr1CZ
         IW9/niu4ppNKYeleV6KlKd7ttvE6ALP0AC7iq1MC+5O0YeXJ00Xjc54oc879X1stbmIG
         TxHDKemlQFXneEn8m4Nm/ox8d0l74Xx4rwfladmL5ODLtBHs4Ijan/Gvwa88fFngMZKS
         wq/0HkehQ/k8sAyUB/YFbiE33Dd0p6JxJNISnR/ZuWqIcl2GKy+7FiTJirAGIt1X3ADt
         dtwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UmkMrNENzFG1JKYmMl3Q1UuB0T9rdrmeFqUnSAQIEyA=;
        b=goS61sQwPct7kir1bm3qLKz8EX+uTrUsmKG+jdzBg3p1xThaslM/i6IoveUwhxCHSJ
         EnwbP5/v3c1s85rQEd62g30D9osjCUsMAfSlx3I99vJRv2SBr4EXo93x98CYXDLgP1Sd
         LJJzOZHNY3NsvaHXqZ5Yaf+Qrj+aqZDPEBXGPcH/vhYpfZX8Wdg0Z0CTcXoQ+jQDL3Se
         w6260VNvinw5ftXW/e32S6/A0vpd5XO8UHU2BXlFhIm7PurXm2f+sYQ88EKwXnV/ekMi
         BONTRyKyorKa9NS+gF7+RX7vrJhZ/Tk2icJE9Z010P5Wi1q8J04KA32Q03nOtXe7B4vU
         AyBA==
X-Gm-Message-State: AFqh2kqIlVCfpOk6PPnwEZxLqiNoYZhXgU7AlyW2ZFpSFA71SDCq9Aa+
        +WIPdBWn0m1M0yIkjMnnNoE40U8eXPyBYmRE0KvsNA==
X-Google-Smtp-Source: AMrXdXs8fIZlmmVNNT3gYfD7C96W572kc2z+jnMTMxH5GhcXUeN8Pg/aOvXTeFzoFbZJ7AuxJpFmf76cefe7eZLvq8o=
X-Received: by 2002:a2e:be9b:0:b0:27f:af16:f094 with SMTP id
 a27-20020a2ebe9b000000b0027faf16f094mr3027206ljr.522.1673284868495; Mon, 09
 Jan 2023 09:21:08 -0800 (PST)
MIME-Version: 1.0
References: <20230105214631.3939268-1-willy@infradead.org> <20230105214631.3939268-2-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-2-willy@infradead.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 9 Jan 2023 19:20:32 +0200
Message-ID: <CAC_iWj++_UELnpEB49pKP5bLsNNFqqOdSVCvF04WK_OoOF5qyQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/24] netmem: Create new type
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Jan 2023 at 23:46, Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> As part of simplifying struct page, create a new netmem type which
> mirrors the page_pool members in struct page.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  Documentation/networking/page_pool.rst |  5 +++
>  include/net/page_pool.h                | 46 ++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

[...]
