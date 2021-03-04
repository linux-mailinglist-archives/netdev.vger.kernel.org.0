Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8C832D53C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 15:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbhCDOXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 09:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240834AbhCDOXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 09:23:39 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1E4C061574;
        Thu,  4 Mar 2021 06:22:59 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id i21so27981769oii.2;
        Thu, 04 Mar 2021 06:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6git8wNlDsSLDjVUii3CBUd0Th3PWz6n9wOTfDK7YLc=;
        b=PyZYbk/K2HbO11rQADvYx7sTXh1bBbEWei72K/0itzsP18fthwPDI2pKdDsMfCZmxI
         GW77b2Cal6U1hXniKwHOFUjdilZ2X1DPR8crq2zfd69cAXNBLhFT9RXGI/92W0IS4CNF
         lZ1uo2nHXo2waoRFhTBOTR2MUC4fw7sWAAA6vj6LHuGgw1KS2ODMSZ+9P3130+11WsKk
         UclHf2MkX5YSXZNXBykQeapSGmCNY9qQCA5yXI2JZrbT38xYmQJvG/1DkwRQWE6C9wH1
         UxzcaE+xenuTlGr+hTXP3EBYsQVbFFk7pjQq8hJmQ7emGNEsCdwESNFVw1pSEFj++EZ3
         kcQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6git8wNlDsSLDjVUii3CBUd0Th3PWz6n9wOTfDK7YLc=;
        b=Hf0w4mbHvs4FZ/UTUJuxvTK4fQWsVLT9XFMPFFsgNwAymRp/0cELD3Qb/vpLGloq1k
         ngrFWkhW8b0UF1RwiF7Vr8WOXxGPNiLXXoijq+GubPr7UiPpESaLyv8uGZVIcsjBI05V
         LZGbthmHeWW1pPp3QR6VnHxR+9WCjlvEqnBhlIPVBAJJNXTiSW12Qqx+bMU8Mt/3lKq9
         z2V6GEupMczhrsisjjMQg7yrsmRXyQXvtnsigfp5SD0816CO0WozHjLCUaKTQ4PrRKVs
         E1TOZgG3IInp+U8Cf6rqoYtmyhCJoKkcapVKhL4oJfzqUqplPCVeiIPRq5Z/hjnc2+gm
         09ZQ==
X-Gm-Message-State: AOAM531kvq+ohe3FltqFqtk2xpI9DPtYxDYoNqNtqaMCNrgu5GzH0bbg
        oqM0bMqMrOBmvTUhwictPSAWnhNK9USIHCTIGNc=
X-Google-Smtp-Source: ABdhPJza6KqKND0SPEifCF8m8ht1WDfQzuBen506UAZXyTCDAUig/3hwvnLXFwAD9m0HiOQzLMAR1+OGbypVjsECUJk=
X-Received: by 2002:aca:3d85:: with SMTP id k127mr3251418oia.157.1614867778829;
 Thu, 04 Mar 2021 06:22:58 -0800 (PST)
MIME-Version: 1.0
References: <20210303162757.763502-1-paskripkin@gmail.com> <CAB_54W6-ONBmLhaQqrDD=efiinRosxe06VEGDqmMM-1-XjYcPw@mail.gmail.com>
 <e70d7b45638db427be978c620475a330cb9db57c.camel@gmail.com>
In-Reply-To: <e70d7b45638db427be978c620475a330cb9db57c.camel@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 4 Mar 2021 09:22:47 -0500
Message-ID: <CAB_54W7v1Dk9KjytfO8hAGfiqPJ6qO0SdgwDQ-s4ybA2yvuoCg@mail.gmail.com>
Subject: Re: [PATCH] net: mac802154: Fix null pointer dereference
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        syzbot+12cf5fbfdeba210a89dd@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 4 Mar 2021 at 04:23, Pavel Skripkin <paskripkin@gmail.com> wrote:
...
> >
> > I think this need to be:
> >
> > if (!IS_ERR_OR_NULL(key->tfm[i]))
> >
> > otherwise we still run into issues for the current iterator when
> > key->tfm[i] is in range of IS_ERR().
>
> Oh... I got it completly wrong, I'm sorry. If it's still not fixed,
> I'll send rigth patch for that.
>

please resend your patch. We will review again.

- Alex
