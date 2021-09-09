Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B094059AC
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241675AbhIIOuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:50:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236703AbhIIOuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:50:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631198931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u9JDbGLr6dkNUoEd0zlqfw7GomTfOIulFrb+2DtUYJA=;
        b=B5M6iD8/K4Z+0ryZ6P9C5iJ8iTkROoppGr4NM+Sk8/spmB5Y07HkrGwrLKEq+DoDUolk+9
        IsXYdR1qQIugo5SlrFqRHElcviVLBWLQPYRHbl5gRj75q7t2M16IMre3/+PZt2ZddJvPjG
        qgi2usmXOilo0hqluxKiQjnL2Y4LbFU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-mWGvMC43N8a7-SUFUFf7Iw-1; Thu, 09 Sep 2021 10:48:50 -0400
X-MC-Unique: mWGvMC43N8a7-SUFUFf7Iw-1
Received: by mail-io1-f70.google.com with SMTP id d23-20020a056602281700b005b5b34670c7so2059259ioe.12
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 07:48:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u9JDbGLr6dkNUoEd0zlqfw7GomTfOIulFrb+2DtUYJA=;
        b=ToEEt9sSf9l5grpMOq7aaPjASV2J5FKrU95ges14piIshYb/8zpN6d987ihltHs9HQ
         Z+ems+Mg6dWHDVpWA7BXOGZGFTlwBoaF1466mWd4yT4DSaVXbWy/YFNBNuCnoQthu9Sy
         i0lG8lDmafAQEAb9cmYd6kLmliFnKlPi+7+E3fOekKSPR++nJdr9d2nFhkH2kgb1+GC+
         gmYEG/kSXiEXDqLk2YQkweCezPuafwSQvWWL+O7KKjEGnyknI3+qC9pkTYclKTpZAALa
         +6eXb7/R/XIXgZoTSdPlxr8ajo4LOJbMPUStK9MLhXpo/bVlV6ETeOKQEq/uiRyPhxTB
         B6xw==
X-Gm-Message-State: AOAM5320G9VZChxGbaHgDHwGnooKd3Ar2JTVPVGREIIR93y1nLLsjthc
        vUquORMfcBRwt69ZNFxomCsaigaiKGuBGRV86QN+V4hFscuoUav9uIG542bWXrgvJQ8hen6SZa7
        2xM8pVhH4/oLcTcSAvrYGjIAf+oOsIY66
X-Received: by 2002:a6b:3f02:: with SMTP id m2mr2975596ioa.136.1631198929422;
        Thu, 09 Sep 2021 07:48:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzG1bHzR6MK4Ss51+mBC39dYSC8m50NMcEX5BeZwpBtCi4rKCrXEQfCjjQYKDJ4jPW6l0G3Uz+rBGHTewBW09Y=
X-Received: by 2002:a6b:3f02:: with SMTP id m2mr2975576ioa.136.1631198929227;
 Thu, 09 Sep 2021 07:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210909092846.18217-1-ihuguet@redhat.com> <5233eedf-42a7-f938-67cd-e7acc5f3bbce@gmail.com>
In-Reply-To: <5233eedf-42a7-f938-67cd-e7acc5f3bbce@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 9 Sep 2021 16:48:38 +0200
Message-ID: <CACT4ouf64jvpjUcmfJ=hc0SjrSGYx4QFL0j6sEitMWi-kjp47A@mail.gmail.com>
Subject: Re: [PATCH net 0/2] sfc: fallback for lack of xdp tx queues
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     habetsm.xilinx@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 9, 2021 at 4:39 PM Edward Cree <ecree.xilinx@gmail.com> wrote:
> Patches LGTM, thanks for working on this.
>
> However, I would like to grumble a bit about process: firstly I would
>  have thought this was more net-next than net material.

I intended to send it for net-next, but by mistake I tagged it as net.
Sorry, my fault.

> Secondly and more importantly, I would really have liked to have had
>  more than 72 minutes to review this before it was applied.  Dave, I
>  realise you never sleep, but the rest of us occasionally have to :P

I go to sleep now too, or at least rest a bit  :-P
--=20
=C3=8D=C3=B1igo Huguet

