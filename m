Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0496020EBD7
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgF3DKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgF3DKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:10:11 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7ECDC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 20:10:10 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v8so19375155iox.2
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 20:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oneconvergence-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5sTuKDfyl1mkdOI/db2xp+PNOUs7h6lOfuJTwBwFcKk=;
        b=IZXVWHGTshI0giL308Wjk/oSFrYoVtDqtW0nMdcmh4nKQUUwclb8g/hz9oXQHByZgn
         bLn7JpZyRA4OBdJOVayqr8vM1oQYksB89D97/mHxxgbdlkcUQf/DMxldJL2RR5UGQXR3
         sh2tbIEh24ChP/WsY+Fk8HTrKOsH4vXnfSiam6ovDIJoq3b1CPngus2iEs7wl08JURWk
         NRJo8bnT7LtMmeCE0MhIu9ZWJ5wwErDP5owEAdUN+fDPg2XDOg5bmKWJzvLgSigde6uu
         V1/tolDuJHGt2uK9R8djtdPKIyUNY5hsT7PvCVzspX+wQw8kikfYhJzgpB7zk4HdVnif
         Iqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5sTuKDfyl1mkdOI/db2xp+PNOUs7h6lOfuJTwBwFcKk=;
        b=KHUwQjAL+MIWa6olG1ruDMNRgWWb/qKb3zqphy5pO4OjUQswcionXbBaTLYG3teGwa
         ODrRVuId95AM4GUCDOF97vcMbfrd3kZpvBERTSDk539CYNAWNxGleSX9vAp+YV1ewsFN
         XVc8tUnHxuLjr42/SGGoYh3QR02ismafPfqEXQLR4NgskHe7iQSnvThXye/fwvDbNWx7
         cR+Nego3Oksn3h8ANvCvtYDxSrXGUD3lX1o+pz/Xlzg4BvJn9U+aHc22Na46ndzPhiYo
         c5j4YJMJm7/ztPxnHfDzZ4sXU4yB/wPNJGBM4Va5k+lp1Yaj8bhSC4BUHJeq7JZ/kzum
         0daQ==
X-Gm-Message-State: AOAM532UTFhXAvPFCvE3jn1wxZ2HB9CLYKDbBe3rHjFy01rc/cKtLoyz
        SBjmke0oSrZuisewfziXLNG3XaQXNblpi+zy3rPSNA==
X-Google-Smtp-Source: ABdhPJzgZHCMW1GV81qT63Kl0Fu3cTF7qm0Lpa1TXZ0ibwyptpfYUPHPue1oPDmKL4iEMMTG/gj+mUCapzvBqc71jmk=
X-Received: by 2002:a02:7f89:: with SMTP id r131mr20586284jac.98.1593486609920;
 Mon, 29 Jun 2020 20:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200619094156.31184-1-satish.d@oneconvergence.com> <20200619.131233.353256561480957986.davem@davemloft.net>
In-Reply-To: <20200619.131233.353256561480957986.davem@davemloft.net>
From:   Satish <satish.d@oneconvergence.com>
Date:   Tue, 30 Jun 2020 08:39:54 +0530
Message-ID: <CAO+9nP5M2so3QnDPK+ucWG4J5764mbZ+eQ2aKrb9QmOLX7Yo=g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] cls_flower: Offload unmasked key
To:     David Miller <davem@davemloft.net>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, xiyou.wangcong@gmail.com,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        kuba@kernel.org, netdev@vger.kernel.org,
        Simon Horman <simon.horman@netronome.com>, kesavac@gmail.com,
        Prathibha Nagooru <prathibha.nagooru@oneconvergence.com>,
        Intiyaz Basha <intiyaz.basha@oneconvergence.com>,
        Jai Rana <jai.rana@oneconvergence.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thank you so much for providing your review comments. We decided to
withdraw this patch for the time being. We'll resubmit this patch
addressing all your comments with the driver code in future".


On Sat, Jun 20, 2020 at 1:42 AM David Miller <davem@davemloft.net> wrote:
>
>
> You are giving no context on what hardware and with what driver
> your changes make a difference for.
>
> This kind of context and information is required in order for
> anyone to understand your changes.
>
> We're not accepting these changes until you explain all of this.
>
> Thank you.
