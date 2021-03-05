Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F98032EB9D
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 13:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCEMuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 07:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhCEMuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 07:50:40 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EEBC061574
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 04:50:40 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id j8so1687507otc.0
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 04:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6HF2gTOyqK7IXK0MEyBALZTkfNBOo9GDBXMBDmk5gQA=;
        b=bQQpD8pUFzapvOM9hjrlq4ps+CpQkod05FQs4R0J1SAe2sx75ipnzFOVmb0y45QZkZ
         9DYR6oVjxMfaj3t8q2gogCYX5MeL5+nVI4uWNictTEja0ivwS4EsNaSa6rZavVIc6FzC
         HHng6Ux3VjDf+4IAG9Im/Huyp00bOtyvTIAOoCEutRQ+U1dYGWA2xvkntYIVFq/qKu2u
         7Mjo2FLSIowzUlK4NjTgbzYwzZ0b2UWWQWAHUhuMzQsYPoqThI5boiajLl/lqp5k9uZ0
         fqt2B6/DEyU/UAdLK0yAaPXlGt1S320glq91BIMan74BbCLhz5arTEZnInA1kV5xSUWE
         x0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6HF2gTOyqK7IXK0MEyBALZTkfNBOo9GDBXMBDmk5gQA=;
        b=Qmed8Q3ubYbny0rJBmHbLP1v1mFSPLLD//oIemNr6Pt4RZYsHD6jJGwfojKw53NiPx
         YsTfILGRh/tE8a7p/nGMKjfNao65uFNFqxFmDN5v6ClFiEd6jgV8ocXVO6zd2r6uv61E
         ah+xitCQSmmjxtKZClNqoDvGKBlGpNtxoO/+1pyxRbwxDPEWK28VpCfJIvY/6VkqGnqB
         e1YbGA/rN8Mo6q7tVDFG6gmTTnY+o0jCBuUjZMb9ZNaf82Rh3L/wF5WQeuoFGU8QzXGd
         29rPG9a0I67yIKyfop/1VhkzXfMzqd33eGDSdMjnYvEN3qYNShQXa1zVgw4MT3auIpRt
         Rveg==
X-Gm-Message-State: AOAM5305cia7f2gB+IBAZxvOTJr9VyyYCi+Rfvd+dEwGrUCF7VBR/S+4
        J0gccSxAD5PpyF4PJ+4r3JyYq3ZJJeTqwlfY/kM=
X-Google-Smtp-Source: ABdhPJznGtIHQcYF/bFkkpZ0pUuqQEqZ7Y0//fou75x2cBys5R4cwx89RHGg0IgMA6duSixZtyi1bfu773BsQUhhYBE=
X-Received: by 2002:a9d:6081:: with SMTP id m1mr2949243otj.38.1614948639654;
 Fri, 05 Mar 2021 04:50:39 -0800 (PST)
MIME-Version: 1.0
References: <CAJH0kmzrf4MpubB1RdcP9mu1baLM0YcN-MXKY41ouFHxD8ndNg@mail.gmail.com>
 <20210302174451.59341082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJH0kmyTgLp4rJGL1EYo4hQ_qcd3t3JQS-s-e9FY8ERTPrmwqQ@mail.gmail.com> <20210304095110.7830dce4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210304095110.7830dce4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Zbynek Michl <zbynek.michl@gmail.com>
Date:   Fri, 5 Mar 2021 13:50:28 +0100
Message-ID: <CAJH0kmzTD2+zbTWrBxN0_2f4A266YhoUTFa4-Tcg+Obx=TDqgA@mail.gmail.com>
Subject: Re: [regression] Kernel panic on resume from sleep
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 6:51 PM Jakub Kicinski <kuba@kernel.org> wrote:

> Depends if kernel attempts to try to send a packet before __alx_open()
> finishes. You can probably make it more likely by running trafgen, iperf
> or such while suspending and resuming?

I've tried "ping -f <GW>" first, but there was no effect - PC woke up
successfully.

Then I've tried TCP connection, like "wget -O /dev/null
https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.11.3.tar.xz" and
this kills the kernel on resume reliably.

So perphaps ICMP and TCP behave differently?

Anyway, I'm happy to be able to finally enforce the kernel crash this way :)

> I didn't look too closely to find out if things indeed worked 100%
> correctly before, but now they will reliably crash on a NULL pointer
> dereference if transmission comes before open is done.

I can confirm that the fix really works and I cannot enforce the
kernel crash anymore.

So can we merge the patch to the mainline, and ideally also to the 5.10?

Thanks
Zbynek
