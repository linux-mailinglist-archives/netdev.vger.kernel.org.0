Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C4E1C4CBF
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEEDwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:52:31 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4DAC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:52:29 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id w2so637414edx.4
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vcg4kYewXh0RDkvAQ3aECJMf0d5Yi9kJkpEKmk0Bc60=;
        b=NE+ch08yuvCPpuUw6kaSjCewvvPCiLN+XNWssnLBldRTVNUD7WWd+t+DjrJy77/z8X
         OwlCsC3pkTXk+KfffuyOfzEIMUEvx4P5auOKcVndQSCEhwG1AAOfuWeLFjnCG/3fCXv7
         xlzNQy1GRjA9vwbpWdytCqRjm/lB08Td7n81s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vcg4kYewXh0RDkvAQ3aECJMf0d5Yi9kJkpEKmk0Bc60=;
        b=mj/mGj+UqY4AZe/dBAJ3lhjebBiTddISK1e81i8E6nXZN+XF1enPaCXCfAPP5WlLeh
         aVVEqjiPQcLpbJEJzkStcrsqMXhtaivk6xAReusMSIr/fTkjoVN9v5/wfoXT+eKq2WIv
         78WyOT10jG96zv6R5Bn8CSC2KHRxdD/HxbecGutJfP/s4PEloc6UhhX8uN59cswSiuGh
         QA4lDCv8LrZqzNHKAPAN2QoT64RvTNa28BXQ9m8rwW1Fvnz7Te9A8EJ3LvkXvb1cyhP/
         V4wOsAccVs0o0RSsdyCMHIOsc48Tml0DwSPNBZDtVdHRK67r+hgWjEjkUgQ1DYyHOMy/
         HpVQ==
X-Gm-Message-State: AGi0PuYYRYZ+oNx8507Yjbvt2brhMQEM8NZfrmRxZ5cqlNpbUJOd6n1X
        TpJ+PYrzs6s+waGRNfGYDmGfNeSm+GPGpxeGKZrIWA==
X-Google-Smtp-Source: APiQypKd29fzNU6+1E6KLGFGbvP80zROrZRNMOdNEnn9+nRZKZj0forjhq4MqRgkblm4snsqk6Zd4lhR91lnbVhK9bs=
X-Received: by 2002:a05:6402:2208:: with SMTP id cq8mr925535edb.293.1588650748162;
 Mon, 04 May 2020 20:52:28 -0700 (PDT)
MIME-Version: 1.0
References: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
 <1588631301-21564-3-git-send-email-roopa@cumulusnetworks.com> <3af21621-2868-612e-f8c5-649f1f4cb602@gmail.com>
In-Reply-To: <3af21621-2868-612e-f8c5-649f1f4cb602@gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 4 May 2020 20:52:20 -0700
Message-ID: <CAJieiUgkb1db1VB7JS7tOJBSNE65rL=NSMroF-VBE6DPbpKaUA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/5] vxlan: ecmp support for mac fdb entries
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 8:36 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/4/20 4:28 PM, Roopa Prabhu wrote:
> > diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> > index cd144e3..eefcda8 100644
> > --- a/include/uapi/linux/neighbour.h
> > +++ b/include/uapi/linux/neighbour.h
> > @@ -29,6 +29,7 @@ enum {
> >       NDA_LINK_NETNSID,
> >       NDA_SRC_VNI,
> >       NDA_PROTOCOL,  /* Originator of entry */
> > +     NDA_NH_ID,
> >       __NDA_MAX
> >  };
>
> those attributes are shared by neighbor and bridge code for example.
>
> nda_policy should reject it, and a new attribute provides a means for
> starting strict checking (add NDA_UNSPEC with .strict_start_type =
> NDA_NH_ID).
>
> Similar for the fdb code in rtnetlink.c. Shame AF_BRIDGE parsing does
> not have a policy attribute.

okay, will look
