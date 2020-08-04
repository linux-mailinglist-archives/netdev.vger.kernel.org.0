Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCB723B1B8
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 02:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgHDAjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 20:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHDAjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 20:39:24 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0203C06174A;
        Mon,  3 Aug 2020 17:39:24 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id i138so26817554ild.9;
        Mon, 03 Aug 2020 17:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=i7EzZtu1EZzpobatXjZkWfJsiB24K39Oat8YDD/9j4I=;
        b=YcctNyVLqkU5jqUXEvVSx05zo5Cr+bCDNNKaUB6bhH0KZNjqaB+V9GNys35wB0bc8o
         L6M9obtGcAe92l9dJ9EGT4zpNQE96k6O2qg+H9+c9h1NK6POg4+cZVO3+9w4PzeTKzMC
         /CQv1SYhZxfmGT2pRUxrx4LfkGxJiMIHV0L0mxHhb9jccIwWD/nLhec7AM/Gpfg/kmgp
         0lgvrhQL/dU0pkyAc2+O8wDsYpeOqZ9Mk13sCFZe7V0Ulaq4Dy6CIYvqiIO+sMPMdtie
         LLw9M92EZqZUucDKDBiSZgEj3OCx6tZ8EbQGR7FTlLFv49zdQOJfqZpqRXiGk5XYGqKP
         Sjdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=i7EzZtu1EZzpobatXjZkWfJsiB24K39Oat8YDD/9j4I=;
        b=hQFzNTxBMBba5FIx2K2XHR9VgnwEB3Y5L1PP1Ra4trkrYXCdyF15pn3ZHi6O1pO4S2
         IAsD6sH6/dySwF6Uhx9Gp8w7ky0+ffirlyiDSS8XVMSkpqpsljZtpY7PTcF5F1EgoLm5
         7XzB6n1RCuDxQkI4dE98lMjErY5E4Bivw0UjFX3GV0v4tqVwPNlAHvOv4QbKaG58c8z4
         8BaqiRln0KAeygqmqSgXJ/wQDh+p3KLZ+R5w6VxygtgOc+RveXwStH7uOGvbnbgdH1JA
         u9uwglLDahXcc9FJ4JimQpZqcCDwhvD1SPnzEANCXWy289qNIQcnc/pdZIai6co90/Fu
         MXVw==
X-Gm-Message-State: AOAM533nOS+QPsMh6ords35beofzrwvi4xnYhAySzPxyHiTcClq0jwRi
        mI9qUQN3s+Hxt1dy+X/dCp0=
X-Google-Smtp-Source: ABdhPJzKMFBVE+KqtxOv4aCQWPOFe4JCjuF1ep+L8t+XagLVys77Bq4z0pGVWZbn/pZlD8LwcGdSlQ==
X-Received: by 2002:a92:1b9d:: with SMTP id f29mr2159478ill.241.1596501564164;
        Mon, 03 Aug 2020 17:39:24 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n1sm11430269ilo.68.2020.08.03.17.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 17:39:23 -0700 (PDT)
Date:   Mon, 03 Aug 2020 17:39:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Message-ID: <5f28ae345b91b_2a3e2af6c9e325c042@john-XPS-13-9370.notmuch>
In-Reply-To: <20200803224342.2925543-1-yhs@fb.com>
References: <20200803224340.2925417-1-yhs@fb.com>
 <20200803224342.2925543-1-yhs@fb.com>
Subject: RE: [PATCH bpf-next v3 2/2] tools/bpf: support new uapi for map
 element bpf iterator
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song wrote:
> Previous commit adjusted kernel uapi for map
> element bpf iterator. This patch adjusted libbpf API
> due to uapi change. bpftool and bpf_iter selftests
> are also changed accordingly.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
