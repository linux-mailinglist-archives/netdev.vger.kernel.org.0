Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5902239C221
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFDVPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:15:23 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:33341 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhFDVPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 17:15:22 -0400
Received: by mail-pg1-f174.google.com with SMTP id i5so8879633pgm.0
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 14:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QvSj42IC9X/VM/7EZXZImoBUhNSJheUuiCLl0IF75NU=;
        b=irc52CX95MAUzx3FMzgKRXeLnDxX6Muc8b9w+xbVcfiMOf2H6X8pnfDd+DffnZ5vWE
         obYIvUsRO6ioqnIW9wH46dLgIi7/JwULyVlJfkrblDTozqN43O3LBQChm/wJnB6QYZbP
         oZZ1OV8dOq2cPon4KUlBCLvCBiBBbLKKYlZeXVk2DsLtdnSG1ib9arvcvbUjaGbxxvIh
         1kVyhFMWmhMWWjT1qxryRhBH90VZKUPMwHe8yF3GSow1U7fc2Q/vZZCJBQp9PcllbYy6
         Is9on6kheUi1Wrv19nGEOLt2fbbZrKvTDQZ7fe6BfCGBO51hU2aWip+GQArOv2vWOIkL
         yXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QvSj42IC9X/VM/7EZXZImoBUhNSJheUuiCLl0IF75NU=;
        b=Ffnceh1e9xVgkKYjcTXJAORWMmamElFRhyhfBhn/38V23sAsgaXGvK0ES7VnhTjAx7
         /RYz3IBpuzCixP3OZ94Dewn7lTLAPIeIUSQVUnk/l5ngxtrCl3PC/Ge2XtIS02uaL72m
         TPrBKCxX14qS59cUEetHXFRZfVDM3lhbeux92p4cnBY6L4Yu0Wo2bAUeTKWHsRzzf3k7
         NOaFR2fP6kSNKW3DuXUUHq2Lb0I6I/pGV5VUFuLVDlxthul8KtjTYBX/AhV734iU5KCs
         WE9XVq4CxGNNBR3++fIW51CkWeWsItSMYdmWFVocgKACfiA313pV62NmfMsvNTjJgLty
         f9yg==
X-Gm-Message-State: AOAM532YObIjNTsbE4qkgPkxR0ply0b3RqUN85VlihZweS+qhenqYhqP
        iFit9Sg2Lg4IDM0R5jECmFIw+OVe9P4wK/Wjx3kVrcxXOa8=
X-Google-Smtp-Source: ABdhPJxZZNEEkPnqpVn7w/PtQ4RDsCPYfS+XUYeyuJ7k9JwElrcA87HSuGrHQ+ApctjxsIQnSSKDTyEpP+Dr4832G8s=
X-Received: by 2002:a63:e309:: with SMTP id f9mr6771394pgh.443.1622841141722;
 Fri, 04 Jun 2021 14:12:21 -0700 (PDT)
MIME-Version: 1.0
References: <YLfL9Q+4860uqS8f@gerhold.net>
In-Reply-To: <YLfL9Q+4860uqS8f@gerhold.net>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 4 Jun 2021 23:11:45 +0200
Message-ID: <CAMZdPi9tcye-4P4i0uXZcECJ-Big5T11JdvdXW6k2mEEi9XwyA@mail.gmail.com>
Subject: Re: [RFC] Integrate RPMSG/SMD into WWAN subsystem
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephan,

On Wed, 2 Jun 2021 at 20:20, Stephan Gerhold <stephan@gerhold.net> wrote:
>
> Hi Loic, Hi Bjorn,
>
> I've been thinking about creating some sort of "RPMSG" driver for the
> new WWAN subsystem; this would be used as a QMI/AT channel to the
> integrated modem on some older Qualcomm SoCs such as MSM8916 and MSM8974.
>
> It's easy to confuse all the different approaches that Qualcomm has to
> talk to their modems, so I will first try to briefly give an overview
> about those that I'm familiar with:
>
> ---
> There is USB and MHI that are mainly used to talk to "external" modems.
>
> For the integrated modems in many Qualcomm SoCs there is typically
> a separate control and data path. They are not really related to each
> other (e.g. currently no common parent device in sysfs).
>
> For the data path (network interface) there is "IPA" (drivers/net/ipa)
> on newer SoCs or "BAM-DMUX" on some older SoCs (e.g. MSM8916/MSM8974).
> I have a driver for BAM-DMUX that I hope to finish up and submit soon.
>
> The connection is set up via QMI. The messages are either sent via
> a shared RPMSG channel (net/qrtr sockets in Linux) or via standalone
> SMD/RPMSG channels (e.g. "DATA5_CNTL" for QMI and "DATA1" for AT).
>
> This gives a lot of possible combinations like BAM-DMUX+RPMSG
> (MSM8916, MSM8974), or IPA+QRTR (SDM845) but also other funny
> combinations like IPA+RPMSG (MSM8994) or BAM-DMUX+QRTR (MSM8937).
>
> Simply put, supporting all these in userspace like ModemManager
> is a mess (Aleksander can probably confirm).
> It would be nice if this could be simplified through the WWAN subsystem.
>
> It's not clear to me if or how well QRTR sockets can be mapped to a char
> device for the WWAN subsystem, so for now I'm trying to focus on the
> standalone RPMSG approach (for MSM8916, MSM8974, ...).
> ---
>
> Currently ModemManager uses the RPMSG channels via the rpmsg-chardev
> (drivers/rpmsg/rpmsg_char.c). It wasn't my idea to use it like this,
> I just took that over from someone else. Realistically speaking, the
> current approach isn't too different from the UCI "backdoor interface"
> approach that was rejected for MHI...
>
> I kind of expected that I can just trivially copy some code from
> rpmsg_char.c into a WWAN driver since they both end up as a simple char
> device. But it looks like the abstractions in wwan_core are kind of
> getting in the way here... As far as I can tell, they don't really fit
> together with the RPMSG interface.
>
> For example there is rpmsg_send(...) (blocking) and rpmsg_trysend(...)
> (non-blocking) and even a rpmsg_poll(...) [1] but I don't see a way to
> get notified when the TX queue is full or no longer full so I can call
> wwan_port_txon/off().
>
> Any suggestions or other thoughts?

It would be indeed nice to get this in the WWAN framework.
I don't know much about rpmsg but I think it is straightforward for
the RX path, the ept_cb can simply forward the buffers to
wwan_port_rx. For tx, simply call rpmsg_trysend() in the wwan tx
callback and don't use the txon/off helpers. In short, keep it simple
and check if you observe any issues.

And for sure you can propose changes in the WWAN framework if you
think something is missing to support your specific case.

Regards,
Loic
