Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B8F49F1A1
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 04:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241918AbiA1DBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 22:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241974AbiA1DBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 22:01:11 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA118C06173B;
        Thu, 27 Jan 2022 19:01:10 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id h7so11310795ejf.1;
        Thu, 27 Jan 2022 19:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i/Z7JtNUmS+A5ZG7tJeCZuufyfEVlrrSo8W8DKMEiOA=;
        b=TyXpg4MEOh5akexMN8QKeR/5kyDp4wz2Kb1vrvYAgOLphZhYpiOCqjCOH/GAnCVgG1
         KH/rO+VPf45SEh7ShYTkngAx8LXq8P2BkH/aC7i3GqGWOpDhky1hOR6J0ke5S7A2/Ou2
         0I4zXqujEAy/+WyFWRI7Ufz/vekjlqS0/lW9ts3ZtR9m/IGN9bVmBzp7LhfCR2jEC3OQ
         Vp06shWT0J2SzwzYDUghUKq/YNND1/Zd7BEra+T3FmE3FIQtzSqE0ccoguvYmqZnyJx9
         4kYJxN4/OPSCYWPdVK9r78H7RSOFuLBw8Jyy+823yjwphygqhaO28L0g/OXpGjZ1wGRy
         w1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i/Z7JtNUmS+A5ZG7tJeCZuufyfEVlrrSo8W8DKMEiOA=;
        b=qiP+6udnY6RZtMNTmyv30zKrkmO8bf+ibi2NF3zhPM211cNUeL6BHRAVTqKcpPPCjm
         Ha4TEJBaccCj8LsG+yP7JHgtNudSDCb+k6YZ1ZN6h1BYTgeOvdaja+wmwYQmQiCJ+aMa
         sq1C9NTFSEHIZUn0fWq2VtBzQ4lNa5kgPfPIQ2fc2aetrhad4ehg5/3Cdh/xQd4TLRnN
         FI7m8orls9slmngSAPaUKDMQRhJBjNPyHdUrUSlqzCvIFfjy2OfupWQNRrP5gOPuq/o/
         VyGbg0WdoGD0uyD2IU5u1pM0Z6yjZC0pt035MG9okdbyAqDT4ey4uFSuO9ehYYmXUAAD
         iY+A==
X-Gm-Message-State: AOAM53252VwogUX8dbuFuN6/QhZ3PS/FYmHDElwsthSP0MtILuZRHK9Y
        5a/6TtLTzp7iOqGpOKcUzQyKGKrO09tmQ5MBY/o=
X-Google-Smtp-Source: ABdhPJxgO/qkaFT8kQ2R8bCAjOBxw37M3HjDcAQmXa6zla5lj/Gad+uIclOzTWl5/dpaVZwko4eBvvx33UbD2nUlkJw=
X-Received: by 2002:a17:907:da3:: with SMTP id go35mr5179474ejc.456.1643338869274;
 Thu, 27 Jan 2022 19:01:09 -0800 (PST)
MIME-Version: 1.0
References: <20220127033356.4050072-1-imagedong@tencent.com>
 <cdb189e9-a804-bb02-9490-146acf8ca0a6@gmail.com> <YfLCMFXbGTgef5Uu@shredder>
In-Reply-To: <YfLCMFXbGTgef5Uu@shredder>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 28 Jan 2022 10:56:38 +0800
Message-ID: <CADxym3a7BLRo3r4dyPrG_dWikxrk288V6XLjktakZWtJx=g3eA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] net: drop_monitor: support drop reason
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 12:03 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Thu, Jan 27, 2022 at 08:53:04AM -0700, David Ahern wrote:
> > On 1/26/22 8:33 PM, menglong8.dong@gmail.com wrote:
> > > From: Menglong Dong <imagedong@tencent.com>
> > >
> > > In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
> > > drop reason is introduced to the tracepoint of kfree_skb. Therefore,
> > > drop_monitor is able to report the drop reason to users by netlink.
> > >
> > > For now, the number of drop reason is passed to users ( seems it's
> > > a little troublesome to pass the drop reason as string ). Therefore,
> > > users can do some customized description of the reason.
> > >
> > > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > > ---
> > > v3:
> > > - referring to cb->reason and cb->pc directly in
> > >   net_dm_packet_report_fill()
> > >
> > > v2:
> > > - get a pointer to struct net_dm_skb_cb instead of local var for
> > >   each field
> > > ---
> > >  include/uapi/linux/net_dropmon.h |  1 +
> > >  net/core/drop_monitor.c          | 16 ++++++++++++----
> > >  2 files changed, 13 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> > > index 66048cc5d7b3..b2815166dbc2 100644
> > > --- a/include/uapi/linux/net_dropmon.h
> > > +++ b/include/uapi/linux/net_dropmon.h
> > > @@ -93,6 +93,7 @@ enum net_dm_attr {
> > >     NET_DM_ATTR_SW_DROPS,                   /* flag */
> > >     NET_DM_ATTR_HW_DROPS,                   /* flag */
> > >     NET_DM_ATTR_FLOW_ACTION_COOKIE,         /* binary */
> > > +   NET_DM_ATTR_REASON,                     /* u32 */
> > >
> >
> > For userspace to properly convert reason from id to string, enum
> > skb_drop_reason needs to be moved from skbuff.h to a uapi file.
> > include/uapi/linux/net_dropmon.h seems like the best candidate to me.
> > Maybe others have a better idea.
>
> I think the best option would be to convert it to a string in the kernel
> (or report both). Then you don't need to update user space tools such as
> the Wireshark dissector [1] and DropWatch every time a new reason is
> added.

I think reporting it as a string would be a good choice. Is it ok if we do like
this (not tested yet)?

--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -48,6 +48,16 @@
 static int trace_state = TRACE_OFF;
 static bool monitor_hw;

+#undef EM
+#undef EMe
+
+#define EM(a, b) [a] = #b,
+#define EMe(a, b) [a] = #b
+
+static const char *drop_reasons[SKB_DROP_REASON_MAX + 1] = {
+       TRACE_SKB_DROP_REASON
+};
+
 /* net_dm_mutex
  *
  * An overall lock guarding every operation coming from userspace.
@@ -628,7 +638,8 @@ static int net_dm_packet_report_fill(struct
sk_buff *msg, struct sk_buff *skb,
                              NET_DM_ATTR_PAD))
                goto nla_put_failure;

-       if (nla_put_u32(msg, NET_DM_ATTR_REASON, cb->reason))
+       if (nla_put_string(msg, NET_DM_ATTR_REASON,
+                          drop_reasons[cb->reason]))
                goto nla_put_failure;

        snprintf(buf, sizeof(buf), "%pS", cb->pc);

Besides, I still think moving these reasons to uapi is necessary.
@David Ahern Is it ok to create a new file (such as net_skbuff.h)
for these reasons? Maybe other users need these enum in the
feature, and this job is done the sooner the better.

Thanks!
Menglong Dong

>
> [1] https://www.wireshark.org/docs/dfref/n/net_dm.html
