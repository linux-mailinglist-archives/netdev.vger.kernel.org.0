Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC0150D2B4
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 17:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiDXPhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 11:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240087AbiDXPZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 11:25:14 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F87F39B9C
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 08:22:13 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l7so25205792ejn.2
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 08:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JvwMaNfpyczcBz5FjlcmZ5tT4tBB4pJUkY5VC5Yl08k=;
        b=Z4XeHrbt4PNpBQEEW2O8Cv/abfRosw9nTHVB11JUPU+VcHQ/OsH2PeKK3Vb++6ZuP6
         Y1Iy2J5QaI3bzFjHOO+j8PtilLUjaceub84QlAlpbkbZZokSkx+q+r6/thQ3+Q+o3YhC
         VT/9LvC77zoZdQD9jcmHpOSpq7LMw6fFpXmrq1VCEabtEM8W7ghuHi10H3lHDkTOYrLE
         XEWkn6Hvu5pjOs5KDqh3hekPTVxDHcOsdWwwWsFQ0VQaVznN5wjm2Ria4Inx3bHlCoct
         bfJyC2GyYYkmQk8tPhX3gFHpoKCn7sKnuq7WgMUig3wjo7msJmasGUZYsnXL0ipCJBGx
         sJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JvwMaNfpyczcBz5FjlcmZ5tT4tBB4pJUkY5VC5Yl08k=;
        b=XBUGKjKMRfJsU3muomZTaEVBrCu35pNENu0+SBpSO7UtbYvBTZLw1yAuLkNgSt0s1a
         pcm5nlBtRnTcW+wgGjDaHCU9WQ+tjt2ZK5VguwHCDDI634wv+SmkpVMx7yIIh7JpOdiU
         KyQXgISZN/3fdRuNUsYkPRM7YiA8FmL51OMHq67xm2B8v/ABscvjfOgEFdwI7WEUS5hV
         4T1g6TblKyCChIjtUSZDuUzQDXNd0vMXo+5P4289fXme+CXarTnqGhbTbS2NzLSjkNvV
         qiVIgMiJtFJFpgsCcveBPaBr6Z+7KhafNfrfs5H58TJhoJlLujY4Mqbce8Cb0awgs+Oa
         HO8Q==
X-Gm-Message-State: AOAM531WlcN6BcQbSnQ2aODoQsxYmeQGu7gtULxfX1Q5uwueuQzN+AFk
        p3dQ2qx1qkPS1YK7wWf9xRkpig==
X-Google-Smtp-Source: ABdhPJzmw2hXC9+KxqcyIogQ1sGB29hYOGxq6qBBX2IiElUpSPzpeEwu7QAlHQ3yskB9NidScLhrew==
X-Received: by 2002:a17:906:66c8:b0:6e8:8b06:1b32 with SMTP id k8-20020a17090666c800b006e88b061b32mr12265608ejp.236.1650813732169;
        Sun, 24 Apr 2022 08:22:12 -0700 (PDT)
Received: from leoy-ThinkPad-X240s ([104.245.96.34])
        by smtp.gmail.com with ESMTPSA id c13-20020a056402100d00b0042294fdbcf9sm3328082edu.14.2022.04.24.08.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 08:22:11 -0700 (PDT)
Date:   Sun, 24 Apr 2022 23:22:04 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Timothy Hayes <timothy.hayes@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 1/3] perf: arm-spe: Fix addresses of synthesized SPE
 events
Message-ID: <20220424152204.GA1810164@leoy-ThinkPad-X240s>
References: <20220421165205.117662-1-timothy.hayes@arm.com>
 <20220421165205.117662-2-timothy.hayes@arm.com>
 <20220424122831.GC978927@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424122831.GC978927@leoy-ThinkPad-X240s>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 08:28:31PM +0800, Leo Yan wrote:
> On Thu, Apr 21, 2022 at 05:52:03PM +0100, Timothy Hayes wrote:
> > This patch corrects a bug whereby synthesized events from SPE
> > samples are missing virtual addresses.
> > 
> > Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> 
> Reviewed-by: Leo Yan <leo.yan@linaro.org>

Supplement for fixed tag:

Since patches 01, 02 are fixing bugs, please add fixed tag [1]:

Fixes: 54f7815efef7 ("perf arm-spe: Fill address info for samples")

Thanks,
Leo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n138
