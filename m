Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051481F7F61
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 00:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgFLW6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 18:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLW6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 18:58:16 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF78C03E96F;
        Fri, 12 Jun 2020 15:58:15 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x207so4995551pfc.5;
        Fri, 12 Jun 2020 15:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=WF0yayqOy4vitr2gfwwxeEUgwqbRugYbv4Z4Yh4JOl4=;
        b=EbllFoiElAHgOlHuOBsYnZw3EV7nEKET3GVw8VLabZnhR2G5qwcm0KpbXCS434NAa+
         prl7pJAzOJYbKBfeY5NHA4NGBO7fRO6meV9DbBaN5L059YmK8OvR0DlWNvob/0F3uJrz
         APW0jeuNj1Dq4kjUj67nX37v6b5fvtNNxxk7QaXVksRLTC6b3KCQZn4VvIiUe7o2oWe9
         GkYaMJMu/iyET+WA+/95mWHdbrAREXX56i3M0hQB9mbL7EiRhLcKAhMI+/UnFb1aNZsO
         EYr+z7PPwsfmu3ei8mwfam4SaB/eRDevBVPQtoDiv8JAuomvFvFof5u4OJHK8Qb1tgWa
         KxTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=WF0yayqOy4vitr2gfwwxeEUgwqbRugYbv4Z4Yh4JOl4=;
        b=F6gFlu6oVa4hFSxS228BsHYqSp75IlSbXL3xO2IzKDkyE0f2sXg99LqkM//jJeah+D
         mAU0kWIU5b/BkjPpcHo6YTqINE9ESB4OTrevVxLVPvCxx12HN9Cc+AZBekbbFT4G+vVa
         vNHwO+XI/U5+2mLFb0rQxJV5AqwRjn7HqzntvrE/uxk74ZAsVk86TYw//cyXAhzh3Pig
         +pVfYtMSVYVPAK//kN3aRNy3ng9+/G2YvkThVfQRoaymD918F/lg5TP34VyjiaqsPSOx
         WYslREfaw6CM/LLCE7WYBOzjxb/z5/U822VD5YaQe4JYfLw2156Ve5NHmmOu8r7U6vpI
         G9YQ==
X-Gm-Message-State: AOAM532FtXLbvlq69VG2Hl9XWC28gydvw3hB66Wg+HnJIXgMScaJBW+0
        aoYowjB8d78GE2W8b06VUSE=
X-Google-Smtp-Source: ABdhPJx68gvq0ln2m7dj26qlbfcCUwPTiaCl9rQkZuvCNbCfnHJTdrkvJwpSGUzpaBRklRpCfYuAgQ==
X-Received: by 2002:a62:3381:: with SMTP id z123mr14095536pfz.274.1592002695001;
        Fri, 12 Jun 2020 15:58:15 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y5sm6092183pgl.85.2020.06.12.15.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 15:58:13 -0700 (PDT)
Date:   Fri, 12 Jun 2020 15:58:06 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Gaurav Singh <gaurav1086@gmail.com>
Cc:     brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "(open list:XDP \\(eXpress Data Path\\))" <netdev@vger.kernel.org>,
        bpf@vger.kernel.org (open list:XDP \(eXpress Data Path\)),
        "(open list:XDP \\(eXpress Data Path\\) open list)" 
        <linux-kernel@vger.kernel.org>
Message-ID: <5ee4087e2b5a_489d2af902f845b4b7@john-XPS-13-9370.notmuch>
In-Reply-To: <20200612222031.515d5338@carbon>
References: <20200611150221.15665-1-gaurav1086@gmail.com>
 <20200612185328.4671-1-gaurav1086@gmail.com>
 <20200612222031.515d5338@carbon>
Subject: Re: [PATCH] xdp_rxq_info_user: Fix null pointer dereference. Replace
 malloc/memset with calloc.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> On Fri, 12 Jun 2020 14:53:27 -0400
> Gaurav Singh <gaurav1086@gmail.com> wrote:
> 
> > Memset on the pointer right after malloc can cause a
> > null pointer deference if it failed to allocate memory.
> > A simple fix is to replace malloc/memset with a calloc()
> > 
> > Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info")
> > Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
