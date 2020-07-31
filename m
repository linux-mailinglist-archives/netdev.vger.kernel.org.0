Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887F6234E83
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgGaXTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgGaXTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:19:47 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382C2C06174A;
        Fri, 31 Jul 2020 16:19:47 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id v6so18007689iow.11;
        Fri, 31 Jul 2020 16:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=QZF0j2865yql6GzIQ1v77ynweBX1P3MGjPStopm1hP4=;
        b=J3bmx4Gx6EDUSPZSTv1tYRdPnIcp31kjrdr/vUzv/z907FRtNCUqmzFcAaF1CJc3Lx
         k367XXUXW51bfezLcfM/o4pXMQifAqx99MmcBdwPCoJQHGmYkPqsuBxY0Lw5YhkEpFYf
         xrMjcZl921Hd7KV50NKHE4Sp0/w/tg+uquxFCcf4Ca7yImP1zADtDHGZ5HOz5t4l24r4
         +pI+Tii+oqX+HTwHvCeqMBLcFEOSjbREb7iELuXWxsBLVD9+hkI/L27mwkoaI/HbDnX1
         dENOGJEOaNzD3KUoDtRFM+1fXkdBGbbL5RG2NvZo1DaakBjwVCnHd1Nx/y3ou8/CV2Xg
         +9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=QZF0j2865yql6GzIQ1v77ynweBX1P3MGjPStopm1hP4=;
        b=gk74XSq85BGl/zXYsNWaKlHznApnuTwnH7F95yrlp95TdY5bbDeMBfl9lfVBjQu5ei
         AQlQvPh8b3jsYygADecl40WpZo4Cszw3m9bWS0EOZYDv+9FJpup7iurc9IUiA1aHQu6c
         3fNiRZYr5rhydG5lTcH4sg6woxB1piFCKxfKjFPFQ27XfegQz74QrvfHrVi+qY7CRWMg
         uzYsEYDGCemCgq1DhnBD4lj3XY9j6DzXMK/ZiHxoojbbFBzus0CNmrTllFdOLxCClyih
         gE7BPUhzcmVKHYngoQCuK5NuqFRl9ouptNpktM/AKr6jS4JNv0A+XEzIdXM2fjpSFVey
         yeww==
X-Gm-Message-State: AOAM531vaZzgDvw2Fp3pqhRJ8PR4m1tIgCNB0jt756zJUZHk49wQj1Px
        ymElaDSF6NggO2xIVHep+5o=
X-Google-Smtp-Source: ABdhPJx1W+rDXmm+W1rpRVmKAHuOFi3ubqcrV1oeJnZm2PqRuVrtpsccxPZVb8VHLpeJFSQr1VeBbg==
X-Received: by 2002:a5d:8b4f:: with SMTP id c15mr5783989iot.197.1596237586376;
        Fri, 31 Jul 2020 16:19:46 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w74sm5874563ilk.24.2020.07.31.16.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 16:19:45 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:19:38 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Message-ID: <5f24a70aa2fa7_54fa2b1d9fe285b4cf@john-XPS-13-9370.notmuch>
In-Reply-To: <20200731182830.286260-2-andriin@fb.com>
References: <20200731182830.286260-1-andriin@fb.com>
 <20200731182830.286260-2-andriin@fb.com>
Subject: RE: [PATCH v2 bpf-next 1/5] bpf: add support for forced LINK_DETACH
 command
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add LINK_DETACH command to force-detach bpf_link without destroying it. It has
> the same behavior as auto-detaching of bpf_link due to cgroup dying for
> bpf_cgroup_link or net_device being destroyed for bpf_xdp_link. In such case,
> bpf_link is still a valid kernel object, but is defuncts and doesn't hold BPF
> program attached to corresponding BPF hook. This functionality allows users
> with enough access rights to manually force-detach attached bpf_link without
> killing respective owner process.
> 
> This patch implements LINK_DETACH for cgroup, xdp, and netns links, mostly
> re-using existing link release handling code.
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Looks necessary otherwise we have no way, as far as I read it, to delete
an XDP program and go back the no prog state after link_{create|update}.

Acked-by: John Fastabend <john.fastabend@gmail.com>
