Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0182F37052E
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 05:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhEADrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 23:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhEADrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 23:47:09 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E835BC06174A;
        Fri, 30 Apr 2021 20:46:17 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id z20-20020a0568301294b02902a52ecbaf18so347253otp.8;
        Fri, 30 Apr 2021 20:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5/NcFPlFLMjVigWhNMHGDUWCDLh4MYb6LAEBs/E3gCI=;
        b=UJlpKbFfo/nQvcyZJnCu9wKMd5n4zugS1IpSxcVx7rlB+q6WohYLE/lTR4xU0/2a6A
         aMiOs8ti5hzT6ll0BqLRmnIp0u+r04/NM3hK/64mghXQ2mNl02FTivctb7g1awwjtZQB
         H2QF4ZLLoBz5Aa0KvVqsnt/o2cS/q4LAdzvFFw+IHXQlw/dpbMA0c6PH1H9F97fnxseV
         MGBiLo5tTo9mqTcmhHK7u0vCFs7smHaDYU9SaohAMzeOyvSMBJK+nBtTl4egIoDYosjZ
         QmJ47itCrRLIJlHB+Jiq5iBuVq23UVJX0NS5AmCQU9MkAeaUHZIJ7tXJSlgJ3I1Oi9fw
         SLLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5/NcFPlFLMjVigWhNMHGDUWCDLh4MYb6LAEBs/E3gCI=;
        b=SyFZsL2ltOsMUsacxnMGjXof7Wc6ICAuFlBBFcxb5+eWBOoeOCByhRkrasGVpThAG6
         20Nongl4EyUUEYJIyymFdjrOm0rup6fNB5UhP5u3E2sMWyTde0arBMy7yKpVGdmxR3Ab
         w66hBpJ/+NtkUxLNsQSwmQslDNSy7OjDAImLZxWMYMeJmnK5i7U45y/778AeYtgjZFmx
         vhxcZbAZUSYUUbr20jt91uq0rQSegjdbzKgyDe5Len7wZ10oaRDQKSuey9K9kcmKE6LQ
         eY8zsj2fLVGifoSe8acHKhVmsmJGC7mSgEN7VeBhqbOCombgwVvr9cZg7hvSAOfKLMpP
         0m9g==
X-Gm-Message-State: AOAM5316j9yCX5FjkSbUnCkN1idK3xJkjcPb7THXTv0x0S2x4Srb0h+z
        OpfhVXbe6/7/UtbpfN5MsT5oJ5MxTrxd0omajV73vwhcYIs=
X-Google-Smtp-Source: ABdhPJxBdg0sLVROacP8w9kzRw8JJOeB5p20iVqw5y6Qs8GrvmSUEdjbP/LFx20mHpgbhypCnI/0aBkxBqZcjir2nQQ=
X-Received: by 2002:a9d:2ae1:: with SMTP id e88mr5746030otb.265.1619840777125;
 Fri, 30 Apr 2021 20:46:17 -0700 (PDT)
MIME-Version: 1.0
References: <1618749928154136@kroah.com> <CAPFHKzdKcVDDERr8pmd=65Tf=tWNh_bKar9OLQd0oS2YBVu80Q@mail.gmail.com>
 <YH1xw5s0Uu5i/cRT@kroah.com>
In-Reply-To: <YH1xw5s0Uu5i/cRT@kroah.com>
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
Date:   Fri, 30 Apr 2021 23:45:51 -0400
Message-ID: <CAPFHKzdnmb=rXcAfKZYgAOz1M_5r=Cu6p1g+o0fi8VmncL1dbg@mail.gmail.com>
Subject: Backport: "net: Make tcp_allowed_congestion_control readonly in
 non-init netns"
To:     stable@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Please apply upstream git commit 2671fa4dc010 ("netfilter: conntrack:
Make global sysctls readonly in non-init netns") to the stable trees.

BTW netdev-FAQ.txt said not to send networking patches to stable, but
Greg suggested I do it this way :-)

On Mon, Apr 19, 2021 at 8:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> For something like this, how about just waiting until it hits Linus's
> tree and then email stable@vger.kernel.org saying, "please apply git
> commit <SHA1> to the stable trees." and we can do so then.

If there's a better way I should go about this, please let me know!

Thanks,
Jonathon Reinhart
