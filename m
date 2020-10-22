Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D2A2955FE
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 03:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894646AbgJVBUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 21:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894627AbgJVBUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 21:20:39 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813E3C0613CE;
        Wed, 21 Oct 2020 18:20:37 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b26so116878pff.3;
        Wed, 21 Oct 2020 18:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s6E8JGKWm9Xo9ZGpC0uqSMNuXpgNfP/vypt2mGkl+QE=;
        b=eIt/iaAJKHoX2QTxS5jpIm+r8DFkXxZoZdW/5qlxiee7iS4lwHadzkhqBnBZNNsXUd
         XN/tpugnW8Nq6T2PRrGAQa9JhMq42uSqfzebyTRmbJVyTqjdu/LrGFMfkYB/3yS53YTE
         jDO9b9Pd4mxBrU8VJk7Rc5UmyChEzv/TeJBlxrplAfBBVGBgQllrql0a3kekSD9OMwLx
         1FqIiTqhcTsZTBsSEMPIYn9i5297Sd7AhDPf0n/cFu5xJHIBF3ofTJP5IOalHK7j4kRc
         S4q8ntrmrk9O+p7aAmQDO4wfYCOoxY3cVFK9KIrnsWCYDOLm/hKYlX98tfH1ald/yvDH
         KWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s6E8JGKWm9Xo9ZGpC0uqSMNuXpgNfP/vypt2mGkl+QE=;
        b=n+Ja8//ZGlTRBUpEAUrPQMiTYa5h+9uEJKCRRIXByKJTZU0UFfcq7RilN3bWfEMtif
         l25GuWlTAO91IJoHBj8lPZTDkzPJBpp1C/lA4ehBpBf17/FpoWVxuT6bBcKj4W2vhilS
         ocKQZPncfHNbMnTegWT8s21ndTKfQICQU4Y5C+HGHXOivb5VUmou0rtNZ+ntbC+W3Fqr
         A4uXeN6ndhvW1qRKxBMjBK+GcFIB9MyPc/CJ/2Qh3zJCUd/SVKQYud15dn7ccOKMdZ/c
         ocMg4vVEapJGI0JKIxFZtbNm+ElMw6Rf7vX0QvzElBNiW7Is1Ts0ZWGrzhVfdHcBOe+/
         a0mg==
X-Gm-Message-State: AOAM530334mjQDX2Umw5i90pFLwp98EBZvePQLSUy380LCpiHHAuOKnR
        zrO2WKekulTj17yZ9O9kzZCMilDL0oaw5jug5CE=
X-Google-Smtp-Source: ABdhPJxmAMtIyqDOt3B2uIJJBGM1y+crlajN3xWLFuMIuN1qVjWssDSLXj7Q8RoCJRaHN+OJsN3RR+C5Vr5dZoVEH1o=
X-Received: by 2002:a62:3004:0:b029:156:47d1:4072 with SMTP id
 w4-20020a6230040000b029015647d14072mr258727pfw.63.1603329637004; Wed, 21 Oct
 2020 18:20:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201020063420.187497-1-xie.he.0141@gmail.com> <20201021180114.4b478b06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201021180114.4b478b06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 21 Oct 2020 18:20:26 -0700
Message-ID: <CAJht_EOAaVN7=ZjMaKBn2G_bziVgfvAPBAnugOeU0PyZqf-JMA@mail.gmail.com>
Subject: Re: [PATCH net] net: hdlc_raw_eth: Clear the IFF_TX_SKB_SHARING flag
 after calling ether_setup
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 6:02 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Applied, thank you.
>
> In the future please try to provide a Fixes: tag.

OK. Thanks! I'll remember this in the future!
