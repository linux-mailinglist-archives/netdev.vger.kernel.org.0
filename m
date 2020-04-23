Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170481B5342
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgDWDzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWDzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:55:10 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8257DC03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:55:10 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id v24so4340163uak.0
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=scjaDOX3dQLla0SUy2l/ZA9vSlJ/URf+wgTz4+Qt390=;
        b=M/pj2CwIGMydm2+23+gLI+EDdeNTWbmupO+j1ITiesZ/rXrw6QlySaXQFcF7HSvRK/
         bNQTdmMSe8Oa+Pe70yXzmDgo2WbupSWqJUZSkOK1vPQxtLjNjW2YyqjM7wPVGlZdR4t9
         vrt92VPbAnKc38GHjn4YNLxPwgC31jWNWHze/VppBKY9IO3ExF4z6iFW/If29WwksxUm
         9GrpfD4hRLNkdECR8EOWVUD6PFJHo1xW/aIPMHlndpuPL/zFryAD3mUtxrlt+3ZCd/37
         n07KZCrut4O4UHeW7Xnbef0L+3jcFXRsulWIqjrf84LI3HyQOkog0T1rRKvOGUCM4sur
         HXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=scjaDOX3dQLla0SUy2l/ZA9vSlJ/URf+wgTz4+Qt390=;
        b=dkBZ5EJ1lowoekpZQGTLzlEQ587rVVFIrng4ViQSP5D9+bWPmhlS9savxL8zem/hx1
         k+zlk9ZuIjOiAS/S1b62TNUvH6Np4gPVPZ6uaH59wodA3NrVIPJ3BdThBzuYEP6ziKgb
         fko4zl8nlwLbQCpGJRJJMcBTevVoZgJUWzXkJEg+hORxVXXx/CYlTgte3OSWz9FKXru1
         cezX+In5GOkAs2BXBn93dJKdobjGM5G2ZeqMjsFpUcdk/uEYKMPxFoz5rXbYORUnxEht
         qKGb/ceMPloOd+/JhGx6IG5MbsEvPx/jKFGDw0EJduuo7ZRjZHNpLOQBv/+larFknXah
         vFOQ==
X-Gm-Message-State: AGi0Puav0UFiHsiisfEVz+C0mjMgvNeblL27Dq6HqYtKFvVvRFCNsgrW
        Qnqj7soxOrLLryCVovUK5HhL9dGqFWlth2/lHTM=
X-Google-Smtp-Source: APiQypLDXcxAGnRT5/I8WnsoiCFo9V5usIWfjhai//3vq+PwKu5tLPTBfvEq+CBEcPZHnItg68K7+WP5AuPKv7J5vtg=
X-Received: by 2002:ab0:770b:: with SMTP id z11mr1437698uaq.64.1587614109793;
 Wed, 22 Apr 2020 20:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587575340-6790-1-git-send-email-xiangxia.m.yue@gmail.com> <1587575340-6790-6-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1587575340-6790-6-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 22 Apr 2020 20:54:59 -0700
Message-ID: <CAOrHB_CO9QtoM5EXVjWV1AX5_WQq0T1Mu=XARrz8fMOQJ6UC1w@mail.gmail.com>
Subject: Re: [PATCH net-next v3 5/5] net: openvswitch: use u64 for meter bucket
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Andy Zhou <azhou@ovn.org>, Ben Pfaff <blp@ovn.org>,
        William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 10:10 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> When setting the meter rate to 4+Gbps, there is an
> overflow, the meters don't work as expected.
>
> Cc: Pravin B Shelar <pshelar@ovn.org>
> Cc: Andy Zhou <azhou@ovn.org>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/meter.c | 2 +-
>  net/openvswitch/meter.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
Acked-by: Pravin B Shelar <pshelar@ovn.org>

Thanks.
