Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9E2210BC3
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgGANHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbgGANHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:07:24 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E01CC03E979;
        Wed,  1 Jul 2020 06:07:24 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id x13so8498135vsx.13;
        Wed, 01 Jul 2020 06:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9kY42uCxSEDlX3revzJlre4DMiKVmK9aSIfC5G3GPgA=;
        b=IPLWvNg7xB9YDM41H4ZIbj7pUqpJxUUf6bQlgAewZm6nplKA41D08FBB6ZmVpl00hv
         1h+98jspt/qOxgN/IOGAdiraQORCgx6+eTXMLcvsObveq6YxaLQzGRoIS1+gYz+g3ypJ
         egzNj6LteW7RypdcXqYLo83H8hljw7imwE/Io8SDLj0yzw59kpbmu3IGNJTE+N8ytWzQ
         QtDFmf6AVvM9xZHYGHbPZcjBT4xcpppoTf9uDSfzW2g3le6OMvaIfFVsb/StEGLeHV19
         PlOpVAr035HOKZb/Ey9XbFG56mgoNFl7iwrDna4FbkGdQDP/0Ps8pAzUAo/8wqzfFack
         Xq8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9kY42uCxSEDlX3revzJlre4DMiKVmK9aSIfC5G3GPgA=;
        b=PH1uGWKPYM8p77ge1YeicFDXf3AccYU3Pq/3gu1ngg9xZZFP1FJgVQ12wQF6sH+JP6
         TFJZNQvDIsulvVSVEgFEmkMrElJVgsxR7vUBoIHOq8x+AMDWOdyhJTRZVLUFZiyCbK4z
         JZ4+8OnlNOpTNpF8u9ci6yBXq/Pws94EMl2pUkhX4f9P1eKsvIN8q9T2R8+DNUMAeDeH
         5GsfAyuvB9W9/mzO3uiwMTWxJAdEDO83GiZ8oXYHb1s+iw/WZbGMEt2uo1fYRfyIv4bn
         PJ9x3WGduchvqzegi0F/X1kCmiSag5yektr6djEC2JklSqZ+7GPFekAZqhnSgXiwLHJh
         ZgEQ==
X-Gm-Message-State: AOAM532zBwiGvcThdP7/RatFyMSYJzm0i/7xRwhRJ1Z2VNM4kir/vbX8
        qyUcuguq77xN/HiYAlfVG75JDwBYJ6CLkEu24KwYClTi5zg=
X-Google-Smtp-Source: ABdhPJyjFR0M9l39zpGcHnZCjLQxaJLckOeJB2AHY8OMZvl0LFDxshpp3vzcWIusjEU3RwjC/7CX1ccvr+3v8bFzROg=
X-Received: by 2002:a67:1d02:: with SMTP id d2mr3728739vsd.138.1593608843614;
 Wed, 01 Jul 2020 06:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
In-Reply-To: <20200701125938.639447-1-vaibhavgupta40@gmail.com>
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
Date:   Wed, 1 Jul 2020 18:35:45 +0530
Message-ID: <CAP+cEOM5D3TZhysX=nrwJzSC6MLF1u7yVu6RqZJ3hGc3V=_5=g@mail.gmail.com>
Subject: Re: [PATCH v1 00/11] net: ethernet: use generic power management
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Dillow <dave@thedillows.org>,
        Ion Badulescu <ionut@badula.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jon Mason <jdmason@kudzu.us>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 6:31 PM Vaibhav Gupta <vaibhavgupta40@gmail.com> wrote:
>
> Linux Kernel Mentee: Remove Legacy Power Management.
>
> The purpose of this patch series is to remove legacy power management callbacks
> from amd ethernet drivers.
s/amd/net
--Vaibhav Gupta
>
> The callbacks performing suspend() and resume() operations are still calling
> pci_save_state(), pci_set_power_state(), etc. and handling the power management
> themselves, which is not recommended.
>
> The conversion requires the removal of the those function calls and change the
> callback definition accordingly and make use of dev_pm_ops structure.
>
> All patches are compile-tested only.
>
> Vaibhav Gupta (11):
>   typhoon: use generic power management
>   ne2k-pci: use generic power management
>   starfire: use generic power management
>   ena_netdev: use generic power management
>   liquidio: use generic power management
>   sundance: use generic power management
>   benet: use generic power management
>   mlx4: use generic power management
>   ksz884x: use generic power management
>   vxge: use generic power management
>   natsemi: use generic power management
>
>  drivers/net/ethernet/3com/typhoon.c           | 53 +++++++++++--------
>  drivers/net/ethernet/8390/ne2k-pci.c          | 29 +++-------
>  drivers/net/ethernet/adaptec/starfire.c       | 23 +++-----
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 21 +++-----
>  .../net/ethernet/cavium/liquidio/lio_main.c   | 31 ++---------
>  drivers/net/ethernet/dlink/sundance.c         | 27 +++-------
>  drivers/net/ethernet/emulex/benet/be_main.c   | 22 +++-----
>  drivers/net/ethernet/mellanox/mlx4/main.c     | 11 ++--
>  drivers/net/ethernet/micrel/ksz884x.c         | 25 ++++-----
>  drivers/net/ethernet/natsemi/natsemi.c        | 26 +++------
>  .../net/ethernet/neterion/vxge/vxge-main.c    | 14 ++---
>  11 files changed, 100 insertions(+), 182 deletions(-)
>
> --
> 2.27.0
>
