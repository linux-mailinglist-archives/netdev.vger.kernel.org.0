Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A827C434CFC
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 16:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhJTOFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 10:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhJTOFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 10:05:18 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20381C06174E;
        Wed, 20 Oct 2021 07:03:04 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id i22so6752620ual.10;
        Wed, 20 Oct 2021 07:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f8IZsbe4qFH+FKhmMa+PYWRqGe/fsoacOUgqe5PAJhg=;
        b=mN3lWsxeb/gbvlLZZR4VwWN381uX++1x7iIVbRNxE1ouNFTaa2EHuZA1tuuHUn3H+L
         +DJBHSxMpwOTzx92r31vFgz715UwG2k4A3slsZ9UNk1x39GPEh6xAlLRISZDMyGRirlK
         b69rxi40DFirhObWg6Gzhp/O+J76oEgEamh/gn3rxN4G8w4tIWbxmYOPprtePc1ncshT
         GpH4Tep3O4NZDGWWv2Iv/iMsq+XSf2WzTGYGDX+KC8eeu5KxmNoxBWk/havDqa7FChBM
         dOoSxft18R9N0eqHZ2H5VQVbi+7DeLoXJbst+RB1Pzz+3zrgAJzh21C1jqRiYyLZK2p2
         3ASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f8IZsbe4qFH+FKhmMa+PYWRqGe/fsoacOUgqe5PAJhg=;
        b=uYIlNLSfpT83XKjZMUC+4OTk3kDv/7vlqp1R1wEt8K6/wP6rO/Uo5Mn/OiVY98q7x3
         thhhUITOj4tgzYQz6GBYWnzid98h1hQBMKXUoqXq/xKcRqMskixBTwr5cnDhokah8qya
         es7gqdfZPiRmluWNEey4CbMBHX97XpavsKT1UnOP0AxJ6SP9F5+e3G8XGl0yoLBtMBDV
         UocjvOwEzvpzV5K5Om9oU65wP/bv4aYJJpSOV3FKrHOQx8CKmU2NLxGxELll2HkfM0fz
         LRNRA+v0xaZxkZb9c1Z6EHbiF2WCImRHkHuMITf5j/Qagb278Y0+MC1uVFB6oIr34oPJ
         lQEQ==
X-Gm-Message-State: AOAM530grQhY0S+rilEv3kFIY2vK4pAykWRDYcDV6YhGXHIm6qw4qJKX
        gjQRYp408sahN5xx8lpqJrt+RAvQLPd5SmnLI+Hy0j+uhSY=
X-Google-Smtp-Source: ABdhPJwQwQJmH4uoa0PKw2GW4eH27MEKMsB2aueL7S0Iid25dyPywUOk+1cK5pCjHy0FNj2gJ1OvcpPkhYNKgR0/hqM=
X-Received: by 2002:ab0:3d06:: with SMTP id f6mr7757911uax.65.1634738583113;
 Wed, 20 Oct 2021 07:03:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211020095707.GA16295@ircssh-2.c.rugged-nimbus-611.internal>
In-Reply-To: <20211020095707.GA16295@ircssh-2.c.rugged-nimbus-611.internal>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Wed, 20 Oct 2021 17:03:56 +0300
Message-ID: <CAHNKnsRFah6MRxECTLNwu+maN0o9jS9ENzSAiWS4v1247BqYdg@mail.gmail.com>
Subject: Re: Retrieving the network namespace of a socket
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sargun,

On Wed, Oct 20, 2021 at 12:57 PM Sargun Dhillon <sargun@sargun.me> wrote:
> I'm working on a problem where I need to determine which network namespace a
> given socket is in. I can currently bruteforce this by using INET_DIAG, and
> enumerating namespaces and working backwards.

Namespace is not a per-socket, but a per-process attribute. So each
socket of a process belongs to the same namespace.

Could you elaborate what kind of problem you are trying to solve?
Maybe there is a more simple solution. for it.

-- 
Sergey
