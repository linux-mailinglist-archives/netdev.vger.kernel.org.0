Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852F531C194
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 19:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhBOSfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 13:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhBOSf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 13:35:27 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF36C061756;
        Mon, 15 Feb 2021 10:34:46 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id f20so7672526ioo.10;
        Mon, 15 Feb 2021 10:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=PDRu2nRimj7c7kkm6cdFKBITU7H9b0bg1Z4KO/r0QqE=;
        b=QUmoOcNZml4sc83izSEbYfLeoYYtDEavvelUe4olcPt24DCGMlVrYsM3NW+XG31SxT
         uB+otUI3E0S7kv0CtZh3TM379ggUlh7l7J96uDRWpw5VTY0L7rxEYRvwBDTujxLzJNlY
         8F6x/E0PqcvDw3oyh1TwRwqB5gJRC3vtk+gf3oG8wfyN++09qKT6DB1xE5jlM2/dyHfP
         V9Dc4VDVHdXj+xvDuYwCP14gOtwq3S1zIGJcblLgyUqt2wkkkvtAnCDKvc0iKm/BBsqX
         lTFLqY0ylGzYq84/PkHzGwNo7ipSEMaJEnpRklpuAgBOAL8ZF6fNnj+vh31n8Hxf+HYK
         P3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=PDRu2nRimj7c7kkm6cdFKBITU7H9b0bg1Z4KO/r0QqE=;
        b=dDqy6R/N+ly394ElMzEUfTvptBCZygEQOBvnksg7qVDKamWmbepE58+0ZcKEJjAIXV
         lxewlVNjn9kD4nQV75NVmx1FE7c+1OJIhcI7aqmO/d7BX8MwrU/8PlnFoc3q61Y94lNa
         BS8yhcp7ymnPzE80l3XhY4pfk62MZI34bQ9B8X+ngqCGJ4e62t+SCm4lV8IRstWK6Xrz
         vDHO8PGagow/xdUhwYuPclemksfE9yCQXbjrVeP5GBm/RpOgLrILOvq4XPMR56FP1Skq
         cqArYz1xDbfxhNFV/mw3MCJBj0qjLXDCjA3p22eAcnq2gyKb7XEA88mZgr7WqUXlbEWb
         VWRw==
X-Gm-Message-State: AOAM53367HRoreM0ISJhuTq5bFbSz6cOf8tIx8CiIe1RK8z+US+Y17nW
        dKdiOKJnUGqFK+zXPw8DIshzJ7i59w0=
X-Google-Smtp-Source: ABdhPJxZMQ3e9m4xbizmDU2IwF/jlfccFJ3FW/cyjU7N76GqPC+z+zjfpBecdyj70WSS6nefC68IlQ==
X-Received: by 2002:a5d:939a:: with SMTP id c26mr14178446iol.63.1613414086461;
        Mon, 15 Feb 2021 10:34:46 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id d14sm8254363ilo.18.2021.02.15.10.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 10:34:45 -0800 (PST)
Date:   Mon, 15 Feb 2021 10:34:36 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <602abebc9dd64_3ed4120898@john-XPS-13-9370.notmuch>
In-Reply-To: <20210213214421.226357-2-xiyou.wangcong@gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-2-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v3 1/5] bpf: clean up sockmap related Kconfigs
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> As suggested by John, clean up sockmap related Kconfigs:
> 
> Reduce the scope of CONFIG_BPF_STREAM_PARSER down to TCP stream
> parser, to reflect its name.
> 
> Make the rest sockmap code simply depend on CONFIG_BPF_SYSCALL.
> And leave CONFIG_NET_SOCK_MSG untouched, as it is used by
> non-sockmap cases.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Thanks for doing this.

Acked-by: John Fastabend <john.fastabend@gmail.com>
