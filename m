Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BB8423A35
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbhJFJKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhJFJKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 05:10:49 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFF8C061749;
        Wed,  6 Oct 2021 02:08:57 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id v4so2104824vsg.12;
        Wed, 06 Oct 2021 02:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N7fZIrwyriq79kuIfyhhuiAPVblLkfDYcYJj6bllaKQ=;
        b=Imk1yRNpWXhQfss2h3pBFsuVNhn5yHFDIeTF4mj6BwIht3RBbflE4A0rOz8rqhLYt/
         xtsroLkmpBt/qhKVygY+IR85oHUnB4q6Z4FAro/2DPjYr2C6q/5XO6Q1wA2EaeqpXqI5
         IxqWGxcafhCjIoVAE0DQcO03CUha5gqyXYE8XIRn9YiWBUmki2pPdroh7G+i8yTyB18b
         ne8zE2cX00T9UuGroEDnsZ5bjXQ90zcproSTI4qLGTHFvUZmQl6+yTXBL4IgRPbe/d3I
         RaVkNa4DzfwuUnD6Yztisz1XQx60fFvSZqE4yz8PevZ2dNjtfcvDpJOeGo70JglvacDr
         3jKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N7fZIrwyriq79kuIfyhhuiAPVblLkfDYcYJj6bllaKQ=;
        b=MunhkJXvEudfE1v/+V017ie0EivG4ysEbwJ30Krn3JD6T+CJaOD845GOC8MFeGZP0B
         C5XoDUQkWLVfVUClrIli/v8cxn9ZqkdZczl4xl9nwq7l7PenSBr/DSPEPEGm5MRKgbhi
         5sVjpTdxh4CTxnLRtF5/7t7x9/z6rl0SB1vLWYOHbjZuTEacKgnqm/Qs9e8A8wnhdN6J
         Ui8NJ9g9MrBf8dJ6Qw60yZ8kqDfIGpIkBmMEg+iDdb+6odY12kwXdV37svZY32Oh6IyX
         Ov2U4IW5lpiwwV5Yot20c0aDcJkHzDFmDIE04iBu0htWHBtbnyeP2BJWDR6b7qPMxqje
         hJLQ==
X-Gm-Message-State: AOAM531FXBGLlgShoczbdVMIqIwW4osgqZOur8XC0EBOJRVj2hTK2hoG
        vF/1gGsOiYZDZzEAcSYss7ZhmtnoxcC8NuhjqiE=
X-Google-Smtp-Source: ABdhPJwwB/oVmv3aQyWxLX4duWG3UPNmJIw6mjRRUVRIyly9S3luSiL/Oztti7UozHmYysnzm6GOdVjxYOzBam/N5Zc=
X-Received: by 2002:a67:ec8e:: with SMTP id h14mr11600374vsp.44.1633511336624;
 Wed, 06 Oct 2021 02:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20211004114601.13870-1-dnlplm@gmail.com>
In-Reply-To: <20211004114601.13870-1-dnlplm@gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 6 Oct 2021 12:08:45 +0300
Message-ID: <CAHNKnsRA5z+qZEUpQ0xeK2Qw4cvSJK8FiL7UF3ec4+13cXTbuQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers: net: mhi: fix error path in mhi_net_newlink
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 4, 2021 at 2:45 PM Daniele Palmas <dnlplm@gmail.com> wrote:
>
> Fix double free_netdev when mhi_prepare_for_transfer fails.
>
> This is a back-port of upstream:
> commit 4526fe74c3c509 ("drivers: net: mhi: fix error path in mhi_net_newlink")
>
> Fixes: 13adac032982 ("net: mhi_net: Register wwan_ops for link creation")
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Looks good for me too, thank you for taking care of this!

Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
