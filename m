Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10812A1041
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgJ3Vgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgJ3Vgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 17:36:47 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E10C0613CF;
        Fri, 30 Oct 2020 14:36:47 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z3so51881pfz.6;
        Fri, 30 Oct 2020 14:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jz1ojc56VCax4qjassESi35sE0VVRGRm/xQUCoU7Q+I=;
        b=kOGbl2KExwy1TDwPx1zqxK+U+nTurI4I7M8mPFS/pkoC8UqkQNWv8TjxKEXtbvRnzB
         0v7f8T3wDBXeCTBOF4zEYwBBZvp5tZE471nJN2bEKVftruZcFZtcSC9eHTi6xJNISz6Q
         s1KyjpXtjcPDQ3lkIl1EDVO56p1ZaifA1oEwiVPKdaXmhBqvYgKZsXg5GqCQPOQ+gteE
         Tnn/4rRmvlGzTbnpKPyBv2VXsNJUNTO2ELzRDLxfKf4QD2WLopzSO5Gjh1Qf/3hN7Of5
         b6THQa4BBVTxbfK8Yn+VDCDJJzJ4BXJUUGX45l+bd8FMQ0hePIorTwxR9YzzzseGkblx
         WR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jz1ojc56VCax4qjassESi35sE0VVRGRm/xQUCoU7Q+I=;
        b=I2Gi7ULGL+Yqe9n6B2OM2n5pCr55lcCkyLfIvFLB8/je4x6WV35QydYFs3bS5domRT
         VdRm4w9am4AahmLQfWYwZGDXffGsqtLIuIJfMBeBsMtEP93ozeEc68vfdaa5rtxp5b87
         tzaMRQZQNFvLPYXsNuDOUORNq/5I9jUMJWLw4QAVSqrOG0wkXNqGewzR9GUPNiEr52uL
         P4+khp2yCVCDlP3z8CrIuW61nPbu3DXWgKXycUX3qzCsA0HP9FWdEaAZw5NmBTLB3g1P
         WowVlxs76Py30RDaJwLDH+Knxls5obAaKZvNvnSTMuf4lGm3owO3+UP4GMHrVD8Lzdt5
         gc+w==
X-Gm-Message-State: AOAM532DWj9nsh9rcWYChKhm14JhrUfejCQXv5n5E6y4Zsldhryt1bzB
        7wfuBVDhDCPJJfePaWBYWd4LtggkGBHKw1kEtrE=
X-Google-Smtp-Source: ABdhPJwyCYMmIAjugG5yxEXa/G1YnAmw1oic1Q+6Ao5fsAEkBPRsoZwUHTMqK6BaUpXFa+7WETHfauqx799hIwZRo5U=
X-Received: by 2002:a62:3004:0:b029:156:47d1:4072 with SMTP id
 w4-20020a6230040000b029015647d14072mr11089372pfw.63.1604093807278; Fri, 30
 Oct 2020 14:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-4-xie.he.0141@gmail.com> <CA+FuTSe4yGowGs2ST5bDYZpZ-seFCziOmA8dsMMwAukJMcRuQw@mail.gmail.com>
 <CAJht_EOCba57aFarDYWU=Mhzn+k1ABn8HwgYt=Oq+kXijQPGvA@mail.gmail.com> <CAF=yD-+fQMZxSWT-_XLvdO9bQA_8xTMry49WA-ZsrcOQcz6H2A@mail.gmail.com>
In-Reply-To: <CAF=yD-+fQMZxSWT-_XLvdO9bQA_8xTMry49WA-ZsrcOQcz6H2A@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 30 Oct 2020 14:36:37 -0700
Message-ID: <CAJht_EP60zsbrf9jR8PG6q-xU98eUjpPf4_vysB1uA8hmnBq-w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/5] net: hdlc_fr: Improve the initial checks
 when we receive an skb
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 2:20 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Thanks for that context. If it's not captured in the code, it would be
> great to include in the commit message.

OK. I'll update the commit message.

> From a quick scan, RFC 2427 does not appear to actually define the
> Q.922 address. For that I ended up reading ITU-T doc "Q.922 : ISDN
> data link layer specification for frame mode bearer services", section
> 3.2.

Yeah. Thanks for posting the name of the document. It's good to see
ITU's documents are published in multiple languages because this feels
more international :)
