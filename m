Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FAA481F39
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 19:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241705AbhL3SdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 13:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241698AbhL3SdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 13:33:18 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D14C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 10:33:17 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id g13so29721372ljj.10
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 10:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kGyOKTZBypRvigr6+yrMoOWs/Qp0QQyfIi99qxABHQc=;
        b=hu4+WAn3Bv/iSoegWo5tIjiYNenp6CfOzCv8DOqNYE+t3+YpLSufSNGfuE33la6umW
         LGFPnR3L27nWQnMPEA4yocwGiCTZSZGe2IK9fI/+JhjDE1vKB+53MiOKEMmgiBB8jKd9
         TQ+GoqIcAft6XkEM2OAWYtcJRAjL1ngkvkPm8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kGyOKTZBypRvigr6+yrMoOWs/Qp0QQyfIi99qxABHQc=;
        b=ANfJFpIPodbobzpQOCjDa+I80m8PkkiOLRpIkXlTqHh83QPXBIz2aB6fXJ37QSnHO0
         FAFRvZdVsw9JeAMtOvaVsv+M/QidmNBy2RJmHmvajtFCNGFBaIguErC136FOUqLP5OYW
         w0fvgwEmkg5l7U8hu3XcjJW1poigfDPWhPJucOo72/JX0X4Fv0ezrKee49GyV8hETTVi
         q041eY/ms9FJVF2A6oNfEu8l16g5JHCCFHA/KIDDa8klUPrVFIoVRH7NlVEg7tF4BedW
         9mUCUyVACOMZigDCDwtmrh4xA0E/hjeNyQU8pu33qS3lBJTeSuFuPePVoqYXF8efiJA8
         Iydg==
X-Gm-Message-State: AOAM532dTyE+0yPpdniKAYdglET8FoKgO9IeWYGZGGzuruey7DFl2KVE
        hwtNZjWHDMyNnIx7wIA2tb8fbcUYxRDe6GtZBLlUbQ==
X-Google-Smtp-Source: ABdhPJxv8cYZ/87KH/UmauYcOUjcFRYYo4AebjMXS1H/f1VhrueYM466Son0fXenpGMs0U6187aS4+L4LgRJfQMFQ40=
X-Received: by 2002:a2e:978a:: with SMTP id y10mr23333953lji.210.1640889196092;
 Thu, 30 Dec 2021 10:33:16 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-4-dmichail@fungible.com> <Yc3vDQ0cFE6vm0Ul@lunn.ch>
In-Reply-To: <Yc3vDQ0cFE6vm0Ul@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 10:33:03 -0800
Message-ID: <CAOkoqZ=ba_QiOdKbN==LU7gKCNSSfAbq29UJBPKB8MvX5sMJPQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/8] net/funeth: probing and netdev ops
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 9:40 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static int msg_enable;
> > +module_param(msg_enable, int, 0644);
> > +MODULE_PARM_DESC(msg_enable, "bitmap of NETIF_MSG_* enables");
> > +
>
> Module params are not liked. Please implement the ethtool op, if you
> have not already done so.

The associated ethtool op is implemented. I think this module param is
fairly common
to control messages during probe and generally before the ethtool path
is available.

>
>      Andrew
