Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758D340045D
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 19:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350056AbhICRzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 13:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350004AbhICRzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 13:55:06 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79784C061575;
        Fri,  3 Sep 2021 10:54:06 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id x5so6000866ill.3;
        Fri, 03 Sep 2021 10:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Ye2M8PjhiidjldphQgtj41d0RRTFZHgu1gFnmiPIiHE=;
        b=M1TuOkrLsk2gRBJLCVDgyiWgwQ5VD4RzvlCoXdMMpHHLoh5bqGS0DRN1gPJ6NCeJnB
         XVL0mh90T+UrLhiQ92pBWpN3PXiRQW4O9NuxJOelM+BeH+8VO4IXUqHfIBRnDD9+vQZj
         7FTRcGauc79msEFl2mndk3UvAfhlKm5KN1OU9/pJanW//HpvFnevxPaIz2zmRZiihz7W
         UgA6yXgLHDtiUSQpYC7+2RpIXQZN+0aRc8gtYl/FvAsMlfpNUDV0RuhbiQT0A0J+Tu2O
         s8PdxJMq1i8J/Pgl8pEdPEOyjE5IwbJv62VB507sGTnZ2B7t0x7MA+WSDqFJZxkpngOm
         Zp4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Ye2M8PjhiidjldphQgtj41d0RRTFZHgu1gFnmiPIiHE=;
        b=jVVcajjB9FZD4XX9OkzLyz28efnac23xH0De/1XUv9zapXIFibfH3CLf8e+nYKWT7W
         Ffx0V+apXt67lQ91/vd6zkxz/hCa8uSiMvSTaQbrCUyztNB4L5zSiylUJirMiKouNsRP
         DSKq1+9+HtQ3tJH/+RmzlN3jKP6nALEG7M4hUFz20T6OSIi4dgVro9udHD/DpZxNpndP
         /LmORnbNBv732HrlTlM1pZmAwi5D4aNwREhRT9SB6yaIAeTjDnIjozctXFzuU8rUEAhO
         fIc/368Oagc6R9IbolI2ep5kWQMRpgJKpbnMPGPhSRwrEdXVSl7t0BNJfBxOzMWgYzUA
         dXyQ==
X-Gm-Message-State: AOAM532T6zJIAu57mZWyyf/qP3ERT7DVfHx/430bmYW/35d0OEQA8fvp
        sOCaijY/PMXZXtJxRiWWUiQ=
X-Google-Smtp-Source: ABdhPJw/dgsfOotkpsxIJI1DvEzAKMKgmSSDchKGh77p+Wx1xTFmnweviWQzPH6hHpJaXZDaY15M4A==
X-Received: by 2002:a05:6e02:144:: with SMTP id j4mr110033ilr.75.1630691645886;
        Fri, 03 Sep 2021 10:54:05 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id p7sm70069iln.70.2021.09.03.10.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 10:54:05 -0700 (PDT)
Date:   Fri, 03 Sep 2021 10:53:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Message-ID: <6132613457747_1c226208a0@john-XPS-13-9370.notmuch>
In-Reply-To: <20210901104732.10956-2-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
 <20210901104732.10956-2-magnus.karlsson@gmail.com>
Subject: RE: [PATCH bpf-next 01/20] selftests: xsk: simplify xsk and umem
 arrays
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Simplify the xsk_info and umem_info allocation by allocating them
> upfront in an array, instead of allocating an array of pointers to
> future creations of these. Allocating them upfront also has the
> advantage that configuration information can be stored in these
> structures instead of relying on global variables. With the previous
> structure, xsk_info and umem_info were created too late to be able to
> store most configuration information. This will be used to eliminate
> most global variables in later patches in this series.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
