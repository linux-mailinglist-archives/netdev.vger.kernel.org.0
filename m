Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372C4517B6
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbfFXPyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:54:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38819 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbfFXPyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:54:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so13888967wmj.3
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 08:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ocqLuWDHS3ozICzu7eGKasp4nYwHIWiIlGkf0Kji4ek=;
        b=PGPy072daP9mAZplfTg+HDXuP8RsOyDPaKsRdE+oTzwJnx/aolDTim03AK8mHx3s1x
         ATxYrarW8l8/cRX6i1w0W82jIEexSr1PIwshHQ3koYDu91/7YIQC/Zu8eXyp2O+ORhMt
         40akO6S2ayD4cfbfyaHaeiRqs4cO9CfgZWmwJ/sWvRc6rqQ5MVLmcuCFcRZ64gtRexih
         5jhB4gtF64JTUJ9gKoQL+8Y2uM5dJU+rV8lDnWCZPRikXwsVRayUARCo0vWHS31ybvF1
         Kq6VhQXNfS4xF/EWFT6P1zsi7d52P30vyuSjAexKuUzqjhMK+AQCxJADQC5IX9ShBQUH
         DHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ocqLuWDHS3ozICzu7eGKasp4nYwHIWiIlGkf0Kji4ek=;
        b=ojJovYJrFNg4a5lageatJ5QzBQjVFw6HMtBSG8Mue979YayACOK5x1YTPZdKmHW4wU
         IkTKRr5MdBou5xnxHRS6KjO1K7KJ8wMQdvmY/jYaR5ehnKNo8fKeQNihq+D6dKabdx1P
         gULP84abFnRVcmIofX2LulxMPVQg1LbOsXcZ2mRwnEtvrymmpCI0/0llyamQOoQRwn/9
         gVXNpiltHezxpvMlljLkQ3ZHSEO32jnOQx+V1dmak9q7X6iRr83PoQ2aRsQz7t26GvyN
         D5G2AXC10GdXZbQmQaKlkySZwhoi0U9TQJivSvw2FJp0MBk4DuAc8i4pDB5NCC0cO7YK
         wFbQ==
X-Gm-Message-State: APjAAAVfP+lB1VvgJJMJXJA7C0qtw9/trOoppSzqm78t+7Bfzu+1sfnZ
        Lj0s6x0EcOZWfe3OEQV3Q0CiPemwUsckvnJB/tU=
X-Google-Smtp-Source: APXvYqwFNhIy64cJL+liPxA+Kbc4lBAHpvltNfQw9pfQ9+ZJBgL1RCCevzMIt0BXrWRzct1oQ5mM4lwrwVn2dhMYbTs=
X-Received: by 2002:a7b:cd15:: with SMTP id f21mr15604677wmj.99.1561391653743;
 Mon, 24 Jun 2019 08:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <a4f39065f0b1cb13da2159339c08d78cb61f88d9.1561363362.git.lucien.xin@gmail.com>
 <20190624.073517.1612706351643151777.davem@davemloft.net>
In-Reply-To: <20190624.073517.1612706351643151777.davem@davemloft.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 24 Jun 2019 23:54:02 +0800
Message-ID: <CADvbK_dcOYbFhiiseoAou_CAELLbta585S=g2jZ249ftO3h+2w@mail.gmail.com>
Subject: Re: [PATCH net] tipc: remove the unnecessary msg->req check from tipc_nl_compat_bearer_set
To:     David Miller <davem@davemloft.net>
Cc:     network dev <netdev@vger.kernel.org>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 10:35 PM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon, 24 Jun 2019 16:02:42 +0800
>
> > tipc_nl_compat_bearer_set() is only called by tipc_nl_compat_link_set()
> > which already does the check for msg->req check, so remove it from
> > tipc_nl_compat_bearer_set(), and do the same in tipc_nl_compat_media_set().
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Is this really appropriate as a fix for 'net'?  Seems more like net-next material
> to me.
kind of code fix, sure, you can apply it to net-next, no conflict.
do you need me to repost?
