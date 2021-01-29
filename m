Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D0D30908E
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhA2XYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhA2XXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 18:23:42 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EC7C061573
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 15:23:02 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id g15so7170853pjd.2
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 15:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4e4/Mi7UyJqjcy/huKoZYuigWyT5PvNjlo5bmm5UYn8=;
        b=be1TOeF1xKvG3wjraRFNT/1zj657FXQyp6Q5i5VsPmsECa8QqSAjDEcEUQcf3Cl/TF
         ATJhAy2+Qo0Gr43BzLy9S/GO49ismBXOdUr7Yf+SK8LsyH+Rw8li1Ny1euQh4R5zcs3B
         5tNCWK6XXeEjoQvlBgqF1obpslzaAq81zrKLFVz8uZ5jY//owCpWfssNUy7nIAnQpxhT
         996GfM9SztXL40JdcPs9oV85sbDKRfm8dnDjKXZuaHMeJxSsdP5fmUtYqzh+Oqo4qFQs
         qu4NzmMWwbqF+sN1APdeJvov2FCRBU6MPlEQIc82+whddpvrvqEfjPi97z148sY5GvE/
         FQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4e4/Mi7UyJqjcy/huKoZYuigWyT5PvNjlo5bmm5UYn8=;
        b=ReAE3xGFjxM99fDsKtYjOLK9YmQaOYbE5fFzeEqr1BXpcPnk/v+B01uBoYNtds56+2
         dvxXMLtdYpzn2TnAxyt/vFZo9+cRyNFIlyMpN8Z6ujaQ76LyYZOx2YKlvYYp9DOAGdlT
         DPGWNLH5qCxRbVMkvDS+0RDpjOCo160RFZrA92b0q87m+YMPUee2l7cWps4b64WY6HiB
         wfnYriFbglIgnwGNKusIeBMIfIWkvbm/uQwaTGQ2GmE1xSuY/sL0EblE+cCiuO9F0gMR
         iTy1fKZF4MW1FSPtC9Li7KpCRO8s7vt0GE+VHQchomSDAKCui7H2wo6h7lqAsGzyDRAR
         H2tw==
X-Gm-Message-State: AOAM5303XjOnXE3h/ICDh/+oz8Lb0QP91lhIfUSFyepnWFonKKU6whGm
        eACnRqFT0HZJOcwwRfeLi5u8Vsl+zK9srFF5wF4+McQlKeX/xw==
X-Google-Smtp-Source: ABdhPJxlPwlnD05RGz1VxQyJVaB0qATPNH/9XR9/+0oRWdmJmDA4E0Cr4M9X1BtOpohIa9GAgJ5J+oEspwlGsJsZjbA=
X-Received: by 2002:a17:90a:5287:: with SMTP id w7mr6947477pjh.52.1611962581592;
 Fri, 29 Jan 2021 15:23:01 -0800 (PST)
MIME-Version: 1.0
References: <20210129120154.316324-1-ovov@yandex-team.ru>
In-Reply-To: <20210129120154.316324-1-ovov@yandex-team.ru>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 Jan 2021 15:22:50 -0800
Message-ID: <CAM_iQpXm6FpaS2YiFE3br6Ktx0fR2xqxyAuJC_LzBcYYiwa9+w@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: replaced invalid qdisc tree flush helper
 in qdisc_replace
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, zeil@yandex-team.ru,
        dmtrmonakhov@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 4:02 AM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
>
> Commit e5f0e8f8e456 ("net: sched: introduce and use qdisc tree flush/purge helpers")
> introduced qdisc tree flush/purge helpers, but erroneously used flush helper
> instead of purge helper in qdisc_replace function.
> This issue was found in our CI, that tests various qdisc setups by configuring
> qdisc and sending data through it. Call of invalid helper sporadically leads
> to corruption of vt_tree/cf_tree of hfsc_class that causes kernel oops:
...
> Fixes: e5f0e8f8e456 ("net: sched: introduce and use qdisc tree flush/purge helpers")
> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>

Looks reasonable to me:

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
