Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B972A189556
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 06:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgCRF1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 01:27:06 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42404 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgCRF1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 01:27:05 -0400
Received: by mail-qk1-f196.google.com with SMTP id e11so36740571qkg.9
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 22:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=trNvWrDPyr73C49GNV9Fv9MhQr2rkrGRycOVSgEol6g=;
        b=CvkPdc56rS5jm4tLOKZrjalck28ePux3Il5BEZh9zP3/qXvZampm5/+oH7xmj2cpgJ
         4VuzQX1gjL1Wc4Z4Xs/Exjwin7x95evLFitI37HB5uwWPkm5ZOL6xzcdw2bQQiZ3yDBC
         5lUAfKkpNUSPe6s4b+jJ8QxtpzzCwQyglunDs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=trNvWrDPyr73C49GNV9Fv9MhQr2rkrGRycOVSgEol6g=;
        b=VhUjW5ASnRcPTGjOrjoe7T2kgLdlwuUECs3mtFyAFTlbiIPbS7Zzv81finQUMQwezu
         CJU6BbkIDfLbQ9V3NSK67EFJKhX1H5okBt3amishQMP0p4D0rm5VbG2YBh2WGizv53TY
         NNn3q0Rnvgfib+iQS/sOcBFekNC9VTgtpwAYaE7qCZ0Y6oHSEsObyrhofTo1gJTqu671
         8QC8ZfuE6zXLwJgT/A4th6o+/Xnn4zSYtUa3ydd3a/PFTQDpWaooVEIuDYtqK7IH0Oef
         5YqGjBpQoGiwlOWxS+Whk2kfKEnCo1ELiezYsdFFMb0vOQyPYYWSwO4qZUrqBHsmO8zM
         80CA==
X-Gm-Message-State: ANhLgQ29qsCy2fvuxWQhkh2Yhs/MDjJJXAwRlShSXPmC97ZG8FJpG3DD
        quptMKMzLMcLFJ1Zz1rTD+IPsmbsn0pmF5bJL0uSqQ==
X-Google-Smtp-Source: ADFU+vvWW5EY1FvkfA1oqFb+KengOXN2eF4ayoa+rVZ0an4t5UeNVfSh87D8WpgJgwY+z0xFGh7klSNzUryI1JajojE=
X-Received: by 2002:ae9:eb11:: with SMTP id b17mr2367915qkg.501.1584509224321;
 Tue, 17 Mar 2020 22:27:04 -0700 (PDT)
MIME-Version: 1.0
References: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1584458246-29370-3-git-send-email-vasundhara-v.volam@broadcom.com> <20200317105220.3ae07cad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200317105220.3ae07cad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Wed, 18 Mar 2020 10:56:52 +0530
Message-ID: <CALs4sv0Y5bw85bh9=6T2EmwGKqJvjNr-ptw8Kovyp7Bb6mHDDA@mail.gmail.com>
Subject: Re: [PATCH net-next 09/11] devlink: Add new enable_ecn generic device param
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 11:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 17 Mar 2020 20:47:24 +0530 Vasundhara Volam wrote:
> > From: Pavan Chebbi <pavan.chebbi@broadcom.com>
> >
> > Add new device parameter to enable/disable handling of Explicit
> > Congestion Notification(ECN) in the device.
> >
> > This patch also addresses comments from Jiri Pirko, to update the
> > devlink-info.rst documentation.
> >
> > Cc: Jiri Pirko <jiri@mellanox.com>
> > Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> > Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>
> Nacked-by: Jakub Kicinski <kuba@kernel.org>
>
> We've been over this multiple times. Devlink is not for configuring
> forwarding features. Use qdisc offload.

This is just a config option like enable_sriov and enable_roce.
This will only enable the capability in the device and not configure any rules.
