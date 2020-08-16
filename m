Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F02245573
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 04:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgHPC20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 22:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgHPC20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 22:28:26 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B133C061786;
        Sat, 15 Aug 2020 19:28:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f9so6030001pju.4;
        Sat, 15 Aug 2020 19:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hdWuVMBr25WAMERNCsCJ/+D2iaw+OKauMCpYgioq/Tw=;
        b=K8mGhCEWw2CjwKCIlw5S56kNnFLiEPTdk3Mrb8NdZYVgqduliLdJ6vmzmb3vbD1PG2
         JGe1A84KHTwqTQKW3d1oJfFSue6+qIi+4uCzDLp+IqqYo+NCPB28VM2KQZtIzzcDlWIT
         WfVvUIP/BX89mh1uyMlUClSBXnLvFjcbcXySHn/W14gvEDRtPQhfMqXvFjEQErUHQxi7
         K/7CzTiSSU4Bn+foCa3gcMvnSfSNjorEu34wn/Trz1ollGXg2zqBFV6qIAWc6Lf/DMQc
         +oVYWjCCHVexMnoTo3W5SawAseIpYwo/xECcz1Se/byp273PCzfAyV34Rc74GV8CgfWL
         jxrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hdWuVMBr25WAMERNCsCJ/+D2iaw+OKauMCpYgioq/Tw=;
        b=mUreC7Sj9bZroGfRp4QAip9cJ343jAXcUDGx+HTLSgAUEhVFYIft+eRx7Y4Jewaxqs
         aNXKNujyRjUbZPITSDB5XYXSLdA6CP9c7RH/oGPwHnbYnhVNzJLNErE5RiB+1B1RZT9W
         PY+2HI2W9/tHkK+BIbFCh9uPuVWFoHfI/9ACEBBoVnzjz/thC2t3hkwPpgxDUFHYI5kH
         1eE2JEERElI/a9im9Ixvv5IRiSj5HMppW3cFgo8tCHaRX8dI9eSQDugE0RjDAtdZgbYw
         N3jK57gsHz+i1UK06m9c/sPsiPbeG0FSZio9mvxABax/n8aqdokxxxYU81eBYdgtg0KO
         zlyw==
X-Gm-Message-State: AOAM532Vth5X3Nr26speEtw4exsKPJl7gLQYe9tGsBazT5bQW7KPfb4L
        DWmBtBuEYl0v99yefXd6HREJ4GkXGqjq5yvPPKmKIscvhM0=
X-Google-Smtp-Source: ABdhPJyYExaqaMixUHDjbr013pxxLQEBupwdZZx5tENDQ0DmhxhtR2QkekpSzUPOaLZZP0WrZQzztEmHnNIYV/2wUUE=
X-Received: by 2002:a17:90a:aa90:: with SMTP id l16mr7583607pjq.210.1597544905667;
 Sat, 15 Aug 2020 19:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200808175251.582781-1-xie.he.0141@gmail.com>
 <CA+FuTSfxWhq0pxEGPtOMjFUB7-4Vax6XMGsLL++28LwSOU5b3g@mail.gmail.com>
 <CAJht_EM9q9u34LMAeYsYe5voZ54s3Z7OzxtvSomcF9a9wRvuCQ@mail.gmail.com>
 <CA+FuTSdBNn218kuswND5OE4vZ4mxz3_hTDkcRmZn2Z9-gaYQZg@mail.gmail.com> <CAJht_EPGD1RmnU6-ZJYocXCY-qcPxXeEuurQ6GJod=WGO69-jg@mail.gmail.com>
In-Reply-To: <CAJht_EPGD1RmnU6-ZJYocXCY-qcPxXeEuurQ6GJod=WGO69-jg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 15 Aug 2020 19:28:14 -0700
Message-ID: <CAJht_EOsQ-QLFBeJCytTRSRuor6jnCEE+zMBV+ngtwr25OSCSQ@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/lapbether: Added needed_tailroom
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I took some time to look at the history of needed_tailroom. I found it
was added in this commit:
f5184d267c1a (net: Allow netdevices to specify needed head/tailroom)

The author tried to make use of needed_tailroom at various places in
the kernel by replacing the macro LL_RESERVED_SPACE with his new macro
LL_ALLOCATED_SPACE.

However, the macro LL_ALLOCATED_SPACE was later found to have
problems. So it was removed 3 years later and was replaced by explicit
handling of needed_tailroom. See:
https://lkml.org/lkml/2011/11/18/198

So maybe only those places considered by these two authors have taken
needed_tailroom into account.

Other places might not have taken needed_tailroom into account because
of the rarity of the usage of needed_tailroom.

The second author also said in the commit message of his Patch 5/6
(which changes af_packet.c), that:
    While auditing LL_ALLOCATED_SPACE I noticed that packet_sendmsg_spkt
    did not include needed_tailroom when allocating an skb.  This isn't
    a fatal error as we should always tolerate inadequate tail room but
    it isn't optimal.

This shows not taking needed_tailroom into account is not a bug but
it'd be better to take it into account.
