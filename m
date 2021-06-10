Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA3C3A2EA9
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhFJOyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbhFJOyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:54:31 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50365C061574;
        Thu, 10 Jun 2021 07:52:23 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id s70-20020a1ca9490000b02901a589651424so4931166wme.0;
        Thu, 10 Jun 2021 07:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jeNB9kebGsKDKuDyLMLxN2kVS9AOIvWoW2KdfQOv7Vg=;
        b=S/ZFsDcUkHjZz0Dc59Y2FyQgRMdUd5NEWCTHaSV2yURRDuWUMz7birox7CAoNSJEBR
         PclwHKJf7MS6I/4BuHvX2AWD/zQQxb31rmo4GPpi1N+9G3D7b5b5rj9ifvyx3y1isUrL
         k9o+MpV3LdMXD93eonLQ6LvaihyvGtVfroeRvx2xH5VkVUtVQ1/XDvu/6sIzNJYW4u/f
         k+FhoMET8JSHgum3t8BR4LPJrAKDEjGGxQN+GcrV2H5y4+n16YbtgmEgPdRHja2Vltkx
         bFrZAYXOqWgeL/ZPaLqIo3q21Qkp6dVNUmlo8CtTqSE+OS4ZNc+mDtPPIlcE4EVJQkOY
         jKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jeNB9kebGsKDKuDyLMLxN2kVS9AOIvWoW2KdfQOv7Vg=;
        b=lmj31AGTH/SWHT1DcdSzvhZlMDadzNrDXz3XXSfxh9TP87IAhsZdFKYhRAF9qMq/Qu
         r6KNMNOHmUd46+c/xVMFDO2+5WsS6b+fbtyDj1qaenC552d8kGx1Tt93M+BrnI5NHtWv
         7MRClb6htpyC2exvUbspkO42I8GbtDFBvtNttsvVQCUMlBxBEGhstcX7ZjwdjGV3spl+
         5uw6sYHZO2+FXaZcOejU3DMHM+G2CvfnQcdN2W0tKqMN4O9rMmcdz1vPEsh+nvJy4R8i
         mqEhQc6txhnb0/kUcGp25V/k2iepEbWrbUeozRW/F0QDzBdjRPnn+D+asFI32fSLlZIQ
         D1+A==
X-Gm-Message-State: AOAM531QlQW83eIHXxqleTYVw5aLw2WH1+M0sI9XCEQ5X0IgimskuWy5
        Qc2ytQBwGSv6eZ7Y1HcuS00ZT7SXzn4bQBnPtuM=
X-Google-Smtp-Source: ABdhPJy3XNdWTKNMu4YNp3T9tPJ/9e/8z7A3BFzYYdr7FGqgUbTF+x1xsEhWT5qL7YN+fL1FuYjy3NHNASb6K7niP4o=
X-Received: by 2002:a7b:c1c5:: with SMTP id a5mr5637396wmj.134.1623336741913;
 Thu, 10 Jun 2021 07:52:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210610125417.3834300-1-wanghai38@huawei.com>
In-Reply-To: <20210610125417.3834300-1-wanghai38@huawei.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 10 Jun 2021 09:52:11 -0500
Message-ID: <CAOhMmr4LQpX79ksQOuZ1ft=M2B4tFOPechV9b_5iJWWL1yekSA@mail.gmail.com>
Subject: Re: [PATCH net-next] ibmvnic: Use list_for_each_entry() to simplify
 code in ibmvnic.c
To:     Wang Hai <wanghai38@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 7:56 AM Wang Hai <wanghai38@huawei.com> wrote:
>
> Convert list_for_each() to list_for_each_entry() where
> applicable. This simplifies the code.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---

Acked-by: Lijun Pan <lijunp213@gmail.com>
