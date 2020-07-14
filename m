Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3D021FD44
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgGNTYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728985AbgGNTYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:24:24 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133DBC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 12:24:23 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e4so24928511ljn.4
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 12:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhSUkcDXFHLJ78cwrgDtAEOtF6bqawc8CuEoI8WU4Xc=;
        b=IhZROwhr6+jOB9hWLChPibZRQesaIFxXrrSz/obvCYJoSCNcrr+sPyqUWGJwyZHi+m
         gjk8L76ZhDX4Np98cCkRk4oNg6QHia7Ic/o+G4HQshP4rx0X5K9/Srxrv26O063f+Mw1
         kKrrHzgYdWcj/AeOch8sBNNBm2RG0CP4oHhkmNooNOPGnFN/x+KI41aYU6F+VlHve35i
         nKxroKXKExfNvxoinr6P58uJ9wTiKkN+N/NNCF+ZQuH082ucxRl+Gnr4PkrRxCyq6HkV
         BKEwqtqx/LpCYsbFwJIWRpyrOGegdS0iQXFHzFULnSDpFinsm6gy7EkAngrf/CRD+Qpu
         U/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhSUkcDXFHLJ78cwrgDtAEOtF6bqawc8CuEoI8WU4Xc=;
        b=LHeNVN+paXk3o8msIOcbtLptSL2Sao9TwFN/1ChzvxKpupMYGrIwiW7TwqzdWFAyOW
         SZSm4RsPcc36s90iM8sxSeeOtqP+zTqU1GkEvVRdtF2V8siYBi06GPUkr43iiG97tpmT
         U7ugdEyL8A0NaqoB38pJwmnpZgqYzjuJMDOCUqBneRc6Oogtd2f8aGMOhM4NJDkosh7l
         +ZBBa67ELkNxnIiuINKDO/PVCxF9pWouH+IklGk7dqLYb89T1I4NsFi7PU2rU9oxQjgw
         njhe194LkOJkCoc99ooGTcvabHGsUetiluAcNQ/5Sq8To/J3RTbMM7J3pRrFrYnTWLf7
         ixoA==
X-Gm-Message-State: AOAM530DOab0qAJ8t2t9cnFYQqi2vkpG8jgHsEcfKJVtJ01DV84dtPgi
        73vdPFGT0oWicrkWYmqiuNu//C3uukYrU1poH9nyGg==
X-Google-Smtp-Source: ABdhPJybMmSelQLYeMsNoa4bJc3g0P6aBm61Q3lz/Q6ZfbrGmK2i1aKXJtz09tEIFb4qPC6OdkkAEFKigkafDpK0Kpo=
X-Received: by 2002:a2e:8ec8:: with SMTP id e8mr2846352ljl.51.1594754661571;
 Tue, 14 Jul 2020 12:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200714191830.694674-1-kuba@kernel.org> <20200714191830.694674-2-kuba@kernel.org>
In-Reply-To: <20200714191830.694674-2-kuba@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Jul 2020 12:24:10 -0700
Message-ID: <CAADnVQJYQFy+xdfPY6FSHgUvL-YZy=tZ4w0TU=d4wXCJTU7R1Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 01/12] nfp: convert to new udp_tunnel_nic infra
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, Tom Lendacky <thomas.lendacky@amd.com>,
        Ariel Elior <aelior@marvell.com>, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        anthony.l.nguyen@intel.com, GR-everest-linux-l2@marvell.com,
        shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 12:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> NFP conversion is pretty straightforward. We want to be able
> to sleep, and only get callbacks when the device is open.
>
> NFP did not ask for port replay when ports were removed, now
> new infra will provide this feature for free.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

I received this patch at least 3 times in the last couple of days.
Every time gmail marks it as new and I keep archiving it.
Is it just me  ?
