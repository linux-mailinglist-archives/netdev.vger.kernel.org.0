Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A22265078
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgIJUTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgIJUSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:18:53 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A588C061756;
        Thu, 10 Sep 2020 13:18:52 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id a3so7191991oib.4;
        Thu, 10 Sep 2020 13:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nno7oVfxiZPhHzdT7mF/rGkR7b0YkBK8EDu0Pto+J0w=;
        b=IdqMBF5RI99WZb911lvrb4o8C6BKxdccQCCFtVazNICk7e5BaAhGf5+YgnZEwtXuh7
         r/VmDikQUZJFbGgn1IR4AeeVd+4zI15XF3aJxRMLIarivyEgqAAWs7tnehgD8JMFb6fp
         d86r/h4HTCIotTpiC/4LPvCMVGV7kvSeHOj3o9cDrmTao0z9TH8FXE078qQC7ChLsBFe
         i0+GYbcRUsMz4CfqoDCH50NHViopMmGhXQMHz6PCnFnjxls00QSl50iL/xRyyq1cCPv/
         vJ5poWO0n7DtWRuroJKVAfveXftrM1eTFueikdCNA2iVdW9tPS/hHVq44JGtyaa44RxG
         IsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nno7oVfxiZPhHzdT7mF/rGkR7b0YkBK8EDu0Pto+J0w=;
        b=N3MI9bi08ZPL5cPReLG5AegJrtBunLGvQ1a/5DyQwZjqLi+epiJSOgmLtZ774VRclr
         7mlfQRmbQ8ofJfEUOpWJq0pUGZ+A9UoWJmCcigDeaXPxsLKXLyb6rwSfik4qSu6rc9BD
         7UQftYT+pZV80b5o1DHXY0sh/oCVWEGkCBpB7e/AnLVzZqKTANbBLrHp9AbDi/g9bkJ5
         EPb8mrvVqROp+9wqhw3m7yPIafqDZymB4qaYBJse9AXBQuPK3xPVGsRTrkLKSigmsLCl
         optLjAss33oJiQp0xhDgiZFxVcl0+gwvhhEGiQsYRkU3ha1fR1uj93AtSurfhwAdei/g
         JH+A==
X-Gm-Message-State: AOAM530Zyr3m5AktrhTWL/Qx/zV7q3rd8uaxNaXPUnaYJgB7S3fBt3AT
        yWGz8DCYkc2PzH2S9pjUyfs1amszbZgcyVvqjN0=
X-Google-Smtp-Source: ABdhPJxxnOXqA//qVoVVDLGCUAQSGf4uuDY3sW7WIQg8CvYjcrUq9Eg0z3OfzrdX6kMG/M+Ego/dy18x2w17Ix1fXxk=
X-Received: by 2002:aca:c758:: with SMTP id x85mr1178067oif.102.1599769132073;
 Thu, 10 Sep 2020 13:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161126.30948-1-oded.gabbay@gmail.com> <20200910161126.30948-6-oded.gabbay@gmail.com>
 <20200910130307.5dee086b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910130307.5dee086b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Thu, 10 Sep 2020 23:18:23 +0300
Message-ID: <CAFCwf11xRSQohReDYigJgM=GB7y-O4OF4PbXc2MW-jjd7c3U6Q@mail.gmail.com>
Subject: Re: [PATCH 05/15] habanalabs/gaudi: add NIC Ethernet support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Omer Shpigelman <oshpigelman@habana.ai>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Sep 2020 19:11:16 +0300 Oded Gabbay wrote:
> > +module_param(nic_rx_poll, int, 0444);
> > +MODULE_PARM_DESC(nic_rx_poll,
> > +     "Enable NIC Rx polling mode (0 = no, 1 = yes, default no)");
>
> If your chip does not support IRQ coalescing you can configure polling
> and the timeout via ethtool -C, rather than a module parameter.

Thanks for the pointer, we will take a look at that.

Oded
