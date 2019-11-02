Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26253ECDC5
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 09:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfKBIiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 04:38:25 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46410 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfKBIiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 04:38:25 -0400
Received: by mail-ot1-f65.google.com with SMTP id n23so128703otr.13
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 01:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0dcAI/VlDr4QWsrQrmxf+1dMc268Vc+aMr6AHm8D5WI=;
        b=gQ/2s7oqiOYhIcwWfzi9eL1qObl8xoHEjBsgCQ7mdOdEXq1R3zY2jorMxu6R8WqdTq
         qiMbrkNB7fwM3SUdmapw5BmI4/gQuWexE/6sgT/xlNeSJUi186tfJYJrvyPFhoLSGma+
         ejT8ob59/xdsMYtxyooN1idFmMuNJQFzeO6AoPgrj0qK/Df2Ryx7CvCKbhEr0/3Sywso
         HkvPuta6+fvuYrSsU10ixsblQzBkZQdfboiNghYgYyedikK6/KBDxDMfwSuT0UCu4DBm
         O15ogjVLqXREqSO2x7Qi+3EtnO+5Uj/It1nxqPOdgAWtjqJVoRQaKu06VzjolVCTCUmR
         A3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0dcAI/VlDr4QWsrQrmxf+1dMc268Vc+aMr6AHm8D5WI=;
        b=OdMhdfcvN0fCSbW/3/ajwfKNpOw58TEr5Sigi4le3fUewIqdmaSm62Ax2JrLcJ6Hr/
         RLcP8Y6NUFl8LNgkW7YNHGYuKP407zdDWT6Lqq+MfUqtFD2G40Mf1ZFQ9pqa4hQkxGIY
         SzEf1KRKEFjSsngn9+Z5belDl4FQgcFZ4ZRx8MTOgNJ1hx6O0GzlUU22P4dk4dT+V78J
         7exVP2lxNUdeNCwBxFNrOoIRArPaJVua/s2zQtbeVPMbBgFfdjnoapmI+6BFkaExYcKW
         4XoKexN5RtVkAc/hf149lTsu6CUiL405VEpM6oWQ4v/51yewlsPvLQfjxUGBY7ytCUC3
         rnlQ==
X-Gm-Message-State: APjAAAVr9uozW9HFU9z8HECNJE7BZJY5UtqI3abxhwxq6hKgr3cdyrpb
        QTAHYR1nZazdXsKy1BfdEXyTrBvf+rWwroM7S+U=
X-Google-Smtp-Source: APXvYqzCKnXWzI38fZFrMHGusifTll/Fq3hSJGPnWoWX8xKcjV56w3cq9hDUvwIo5SJr//piWJZrQL5QKnVyjWQFIQw=
X-Received: by 2002:a9d:600b:: with SMTP id h11mr4207607otj.334.1572683902400;
 Sat, 02 Nov 2019 01:38:22 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1572618234-6904-2-git-send-email-xiangxia.m.yue@gmail.com> <CALDO+Sb3aV=WreJWAGAPaS0eJ2NpAqcZhKnpzXdphEq8chHm8Q@mail.gmail.com>
In-Reply-To: <CALDO+Sb3aV=WreJWAGAPaS0eJ2NpAqcZhKnpzXdphEq8chHm8Q@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 2 Nov 2019 16:37:46 +0800
Message-ID: <CAMDZJNVQ01SiFggPbkr50O760VYyNjLSL+iAfg9y6ZeOykoJ8A@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v6 01/10] net: openvswitch: add
 flow-mask cache for performance
To:     William Tu <u9012063@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        David Miller <davem@davemloft.net>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 2, 2019 at 7:40 AM William Tu <u9012063@gmail.com> wrote:
>
> On Fri, Nov 1, 2019 at 7:25 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > The idea of this optimization comes from a patch which
> > is committed in 2014, openvswitch community. The author
> > is Pravin B Shelar. In order to get high performance, I
> > implement it again. Later patches will use it.
> >
> > Pravin B Shelar, says:
> > | On every packet OVS needs to lookup flow-table with every
> > | mask until it finds a match. The packet flow-key is first
> > | masked with mask in the list and then the masked key is
> > | looked up in flow-table. Therefore number of masks can
> > | affect packet processing performance.
> >
> > Link: https://github.com/openvswitch/ovs/commit/5604935e4e1cbc16611d2d97f50b717aa31e8ec5
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > Tested-by: Greg Rose <gvrose8192@gmail.com>
> > Acked-by: William Tu <u9012063@gmail.com>
> > ---
>
> Do you consider change author of this patch to Pravin?
The commit message of patches explain who is the author, and the url
of patches is in commit message.
we should change the patches again (change the commit author)?
> Regards,
> William
>
> <snip>
