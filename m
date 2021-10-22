Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2400B4371CD
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhJVGfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbhJVGfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 02:35:22 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED58C061220;
        Thu, 21 Oct 2021 23:33:05 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id g79-20020a1c2052000000b00323023159e1so2197250wmg.2;
        Thu, 21 Oct 2021 23:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K3ag/8I6dY0xnXzblFz/1w5mgGcBQvelgLc2shxtkfc=;
        b=PTQEtRJkvbdBeeUpy0SiyY+F0rHKPnxxj2b5Rqzx40gPhHZTjIDHlWOqU1SWf9Ziso
         7L4W22xUMO3/DeZnclGgp8yLPSDsuL5O/f4dgTTrKyomPfAsXmXCb45l4TxZmtGd6bo0
         bJaOm7zJ/NDWtQzmEXnDIx1czxdgusih1AnMgVw7fsqim33dlN2lu+Acy811aBT2CxsY
         sNGnhxhLNUYffLBe8b+JONuyOBmuFJIAD/d1Rd4HFlhgwq6+bhviz5XfSC23vXhDLlCf
         ulrZsBlxyoTcZENsqmH8xAOvFKZMBOv5lSL1s5W62eat5DFy2x7SdBBos1fqHlx608kA
         CXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K3ag/8I6dY0xnXzblFz/1w5mgGcBQvelgLc2shxtkfc=;
        b=yH0DHv5u5omkrciyd2mRq35KO6cTACwtrrYYfdyiW607Gy2BRKBLIlxFiRzLU7Fm9c
         mdFtVI3eVGyj+IL55kezSVzcqMnfabtHh5fheBguNAOZinlQ5hZD9hIJrKEfpbQSQnwb
         krBMq1zREh84MR0y7869YEtL2ONvtTlfSbImWTsVqEbLhzM8mT/s99nEh61SaEnA6mFH
         LT6A+S/SclYnbJf9OQR0SkwykUVSn/iFqCo3AvQh6b9YJUzEc9R1LJ6YtCMlNTSxVWUU
         /DG2FnWFSPmRVbyhqNoyVFS8dChZW5znWSCMwxOB9VBXMzdhB30jbkGA9xewEHNQ3j3i
         1pTg==
X-Gm-Message-State: AOAM531/xLG0OOP9WCfazi811gA2GY3PUBfKvcNiafRhkuiIX22KdGmH
        2kCCNLVsYDXgku7Zdbaylfsi+TSUgv1/FdIVvgZ5Zu1oUSg=
X-Google-Smtp-Source: ABdhPJzCAtRD5QUGKUs2UsgDv4VG1mUB5AiemLTR85yYtzJwMWcMfdK+dnfSplqLyFMDGsyrX5zALXT3wdbfHzhXGus=
X-Received: by 2002:a1c:7dcb:: with SMTP id y194mr8906027wmc.8.1634884383912;
 Thu, 21 Oct 2021 23:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211021153846.745289-1-omosnace@redhat.com> <YXGNZTJPxL9Q/GHt@t14s.localdomain>
In-Reply-To: <YXGNZTJPxL9Q/GHt@t14s.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 22 Oct 2021 14:32:52 +0800
Message-ID: <CADvbK_eHsAjih9bAiH3d2cwkaizuYnn6gL85V6LdpWUrenMAxg@mail.gmail.com>
Subject: Re: [PATCH] sctp: initialize endpoint LSM labels also on the client side
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Haines <richard_c_haines@btinternet.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 11:55 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, Oct 21, 2021 at 05:38:46PM +0200, Ondrej Mosnacek wrote:
> > The secid* fields in struct sctp_endpoint are used to initialize the
> > labels of a peeloff socket created from the given association. Currently
> > they are initialized properly when a new association is created on the
> > server side (upon receiving an INIT packet), but not on the client side.
>
> +Cc Xin
Thanks Marcelo,

security_sctp_assoc_request() is not supposed to call on the client side,
as we can see on TCP. The client side's labels should be set to the
connection by selinux_inet_conn_request(). But we can't do it based
on the current hooks.

The root problem is that the current hooks incorrectly treat sctp_endpoint
in SCTP as request_sock in TCP, while it should've been sctp_association.
We need a bigger change on the current security sctp code.

I will post the patch series in hand, please take a look.
