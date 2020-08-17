Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75D1245C92
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 08:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgHQGhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 02:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgHQGhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 02:37:23 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB3CC061389
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 23:37:22 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 184so12956326wmb.0
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 23:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZGAxLhTODGHqxXYJjtQOn9tVpAUfPOZu1UQ9wodOgrI=;
        b=Jau8UHxbCZTNkgbfTbkB6VmFnXMVrXgTXnGLacRYKA0Q8FBXOMLhp6W6XqZ9Ce853F
         q0UwWh4tKkxIQ40y+5AmQwPKB++v2Rx/ek5G/SXIw3mwVSk6ViiyeMWssBMy8FHsce1W
         4Pg6ThKVposNcwXOGISf0KJ1ceEPAeGzIBxCXxId/XLngLgE5/B4QRrVhL73e00UqKlQ
         DeQv1lCI5hTSi0yoe0uJBo/SrkF8FoeQMRrPUUnDKs8mrZvtWSzEA0tP5Cv5eqU3yJKU
         pjGrPs43TKHDbB12OZNaPiZrzPpbzK7co4Ea1z2vWc0r31ogPKrvVJDCCszSeOX/o1fK
         P6MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZGAxLhTODGHqxXYJjtQOn9tVpAUfPOZu1UQ9wodOgrI=;
        b=Lt3b8iZA89SMDyKmbl146fMD7QeaWbekoALo4RW7WhSc/5sHwpX9FHtm89kFZufcNO
         FJZQhA6JOkAnHcFw6LkYp+ki9RT0MiIMqiWBTh0yyBvOlfqT7sNJVwK5QfjUn5oNCpKw
         wP8Bsbig6j8sBadOHOsUQQG0t7TICRLVkPYXxFDCdjoYXKuVMhxPl6GeFvD8QVmpfvkK
         Hsvy4RblixlKWNmiKoTTxRcxixiD3olTX5hpeKFZpGjq5F+IpEC48pAlailEL405Tib4
         c88gLql5QONH8M/VD04BArQN3vby8LwRydyzWBbxPslzuxU6NvgPW8qoy6ihU26plSbg
         63yg==
X-Gm-Message-State: AOAM533GUpzb4JF6W/zs0ZhbHPUrOSfLMDHHc085id2ir3hG6oYrTRK3
        YNLSmTDa+USZZRD2sl1VQDJn72OJkQQO3KnpSwU=
X-Google-Smtp-Source: ABdhPJxgLhuDH141ArW220LANPYkIrsHDIcUJj1L8l8bTLKgCHir90VmijbBByW0UBI+KoEcK3XqFSkTf29nfmvteMs=
X-Received: by 2002:a7b:cc8e:: with SMTP id p14mr12969602wma.111.1597646241374;
 Sun, 16 Aug 2020 23:37:21 -0700 (PDT)
MIME-Version: 1.0
References: <d20778039a791b9721bb449d493836edb742d1dc.1597570323.git.lucien.xin@gmail.com>
 <CAM_iQpU7iCjAZ3w4cnzZx1iBpUySzP-d+RDwaoAsqTaDBiVMVQ@mail.gmail.com>
In-Reply-To: <CAM_iQpU7iCjAZ3w4cnzZx1iBpUySzP-d+RDwaoAsqTaDBiVMVQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 17 Aug 2020 14:49:50 +0800
Message-ID: <CADvbK_fL=gkc_RFzjsFF0dq+7N1QGwsvzbzpP9e4PzyF7vsO-g@mail.gmail.com>
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 2:29 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sun, Aug 16, 2020 at 4:54 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > When using ipv6_dev_find() in one module, it requires ipv6 not to
> > work as a module. Otherwise, this error occurs in build:
> >
> >   undefined reference to `ipv6_dev_find'.
> >
> > So fix it by adding "depends on IPV6 || IPV6=n" to tipc/Kconfig,
> > as it does in sctp/Kconfig.
>
> Or put it into struct ipv6_stub?
Hi Cong,

That could be one way. We may do it when this new function becomes more common.
By now, I think it's okay to make TIPC depend on IPV6 || IPV6=n.

Thanks.
