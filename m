Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C48C212AC7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgGBRED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgGBREC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 13:04:02 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE5AC08C5C1;
        Thu,  2 Jul 2020 10:04:01 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id q15so8940647uap.4;
        Thu, 02 Jul 2020 10:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W7abyQ+nO1e3zFNQVjcKFt0DBVozSRyUVCzzjyEn7XU=;
        b=mLb/Puisrsyl9e+9wKRiHp5Tq8N9Qqi7AXkGnpjEMryA62rF5gsqxzAyij4m2HL6JK
         tkOQpczKTmoudMKJ1io0MWq3hk5u3Z6m++a8HHvikgtlyQw/FDuVxeefDGmVs/QubBIf
         fo07ggUC666fnwuzvOQIrj5Vbo/u7eYAdiymADO1Z1AH76x932TWNfovz0EdwpGi86Ob
         q9CYiaxcNx77cukdGp+m33xZVBQC0Sce2Idw3UoDkHb4T4R1panpKoFR3HnbqJj7qIOq
         ie46ml7vo9rFVOqfirf64zwiOqbpcp7WNuuN8VqETbVItChNFBDnoeAG1RFdTNPi6/yB
         kWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W7abyQ+nO1e3zFNQVjcKFt0DBVozSRyUVCzzjyEn7XU=;
        b=Oqv8ESsSq+2Ekl68e5cm5/8UiKw7ucFgonKRTqLJ84HYBCjvN5btNmvk/75dISwCyJ
         2ztLLDPbN2G93lwnmqmOOvdepWl2sXUE0ukwPpFWlQu1nHkTivW5JvmYfwc+2H4NzFbp
         UYmPh2eOiozTWT5oHVItof8WUw54VxUqauAtYBr1WoK2mGQp7sYHdG1jcPcbqXWlo6el
         Oj402BkACJLrqzaZ9aH96nzXsqlt6k9UP3tuaZSroMr4gnqJRNhRwVbiFbx386xpN0dO
         B5C2bsO7498dARHEREh272T9G9gWGKEa3Nf3OI/HPf+YdzuIcIXliAh1iC0+O8PztJjP
         +DPg==
X-Gm-Message-State: AOAM533dPZrqMporYCiTBnEVujeO5GI/kAb8B3J5EhB2Cthcaf3CQhh+
        qZ8gFsfSfX3A58UdgHjgsW3yD8DSyx4nR+mvwtU=
X-Google-Smtp-Source: ABdhPJxFGYCFDj2+ZKyRT9CJQ3VzeAHEvXOH+lMAstiCkuNZfVamKCSrktgnyH3ne9pM+ZVH+mPwjKvz6JjpBOzcvzM=
X-Received: by 2002:ab0:7056:: with SMTP id v22mr16569896ual.67.1593709440909;
 Thu, 02 Jul 2020 10:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200702063632.289959-1-vaibhavgupta40@gmail.com>
 <20200702063632.289959-3-vaibhavgupta40@gmail.com> <20200702093645.13e0018a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200702093645.13e0018a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
Date:   Thu, 2 Jul 2020 22:32:21 +0530
Message-ID: <CAP+cEONGianqeie9HsVqVm6=LwKn_caF285U=vpdha0-+8B-ZA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] qlcninc: use generic power management
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Shahed Shaikh <shshaikh@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 10:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  2 Jul 2020 12:06:32 +0530 Vaibhav Gupta wrote:
> > With legacy PM, drivers themselves were responsible for managing the
> > device's power states and takes care of register states. And they use P=
CI
> > helper functions to do it.
> >
> > After upgrading to the generic structure, PCI core will take care of
> > required tasks and drivers should do only device-specific operations.
> >
> > .suspend() calls __qlcnic_shutdown, which then calls qlcnic_82xx_shutdo=
wn;
> > .resume()  calls __qlcnic_resume,   which then calls qlcnic_82xx_resume=
;
> >
> > Both ...82xx..() are define in
> > drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c and are used only in
> > drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c.
> >
> > Hence upgrade them and remove PCI function calls, like pci_save_state()=
 and
> > pci_enable_wake(), inside them
> >
> > Compile-tested only.
> >
> > Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
>
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c: In function =E2=80=98qlcn=
ic_82xx_shutdown=E2=80=99:
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c:1652:6: warning: unused va=
riable =E2=80=98retval=E2=80=99 [-Wunused-variable]
>  1652 |  int retval;
>       |      ^~~~~~
Fixed in v2.
Thanks!

--Vaibhav Gupta
