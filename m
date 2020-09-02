Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157A625A521
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 07:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgIBFlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 01:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgIBFlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 01:41:37 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8077FC061244;
        Tue,  1 Sep 2020 22:41:36 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id q3so1748565pls.11;
        Tue, 01 Sep 2020 22:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=62GQnWg+saLh95L3FazhmhEQ+aCOHuTxtO7wk8TeeOM=;
        b=OyPB/gaRCvF2Ij34ZjpKiIInjN9bArFTsogVA9z7zwWoc6Fbh53Pngy4YW24SKPDOE
         fueI1Z+el/+W+jepo7G+zNimZsSRHUtnH9V3dpN25qt6ScOU0/PWwdxx90JCFrDJT4UD
         rR4afUO6XzPPqgjuFZr6FLX+ZHn3R4an9C1UkBlNCJHdLVNuuPtkkdrEL8jO5xHnd5ID
         h3/aoDloXlkfE5bSBiaVv/RfBP2El4jbn2TwlFTvPXDJPjkntsxlunAbQI0C0nAyc3LB
         LB2hFjeNh1sOBQBfSdBQ5ZT7QmpA56QJQmC6peyZGhTuLTrQRTYUifycXLN5A31+gI18
         zZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=62GQnWg+saLh95L3FazhmhEQ+aCOHuTxtO7wk8TeeOM=;
        b=W1+rlwKDYkfTzoOWlynJhn0sLjPq7iiHkPe+tMne0uZsp0QalmgErTAFTkze+3B2WQ
         2JDRzw7y1Nsne+yhVhq4/pd3JjbScnqmXK+HcG9dMED56/rXUqsJqHevCDyEHMTQ6G+i
         c/PVqySaY3gCW1hN5QEL4GpyYOfsIFqvhmGbDzbwLfm/xwG+8ScR6ioufcTMl+K4YPiC
         AxyRRprS9Li1HJVszZEFFeGEnrpBpC5cMTlXzW4yih5n5tN57d2kYW2IlPNyoYZDrdhk
         lUk/xwg6JBWl+z52M7ABtOQAgGhIYsqlB/oJ4SOZADkxcce3ySRCNKyfRJZBkKA33+P9
         LdhA==
X-Gm-Message-State: AOAM530ZsIzs8B7uiCu9bh0CW942Dmmoq3GyfYFAchINrJ5B58ti1tfW
        reEFn1L6W7U8Zvskbs8SaqM=
X-Google-Smtp-Source: ABdhPJzLBNugysdX3s9uHcstowXfAERRmlEn9G6Cbby9hf90bqESZpUoZV7su1voiQyOdMWa6FIpEQ==
X-Received: by 2002:a17:902:b486:: with SMTP id y6mr727306plr.100.1599025295430;
        Tue, 01 Sep 2020 22:41:35 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:c38b])
        by smtp.gmail.com with ESMTPSA id s1sm4520230pgh.47.2020.09.01.22.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 22:41:34 -0700 (PDT)
Date:   Tue, 1 Sep 2020 22:41:32 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 07/14] selftests/bpf: add selftest for
 multi-prog sections and bpf-to-bpf calls
Message-ID: <20200902054132.y3p3spqt6vzxiy2t@ast-mbp.dhcp.thefacebook.com>
References: <20200901015003.2871861-1-andriin@fb.com>
 <20200901015003.2871861-8-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901015003.2871861-8-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 06:49:56PM -0700, Andrii Nakryiko wrote:
> +
> +__noinline int sub1(int x)
> +{
> +	return x + 1;
> +}
> +
> +static __noinline int sub5(int v);
> +
> +__noinline int sub2(int y)
> +{
> +	return sub5(y + 2);
> +}
> +
> +static __noinline int sub3(int z)
> +{
> +	return z + 3 + sub1(4);
> +}
> +
> +static __noinline int sub4(int w)
> +{
> +	return w + sub3(5) + sub1(6);

Did you check that asm has these calls?
Since sub3 is static the compiler doesn't have to do the call.
'static noinline' doesn't mean that compiler have to do the call.
It can compute the value and replace a call with a constant.
It only has to keep the body of the function if the address of it
was taken.
