Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8782BA1AA
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 06:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgKTFIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 00:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgKTFIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 00:08:10 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C53C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 21:08:08 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id a15so8249623edy.1
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 21:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XLSwI73WmHabYIrb70KZon+WK8nK9DtKQn4OjxSwzrY=;
        b=ThAXgYD9ilE+rFxsRD+VBnv2rrpZQRj3f539TY0Mdxl7v8JzDwi6MIFS/0Jqu9OdIv
         GrfK6+bvuYtjGZKhLYd2Uh0exYaxvdd/El0PIBZ7Kpt8l4q2nk9N3BpgTBX3/qfuDcbV
         n/QX62Sq+6OYNV4vgRU44adMw4HS6yPpaRhNIQkO53U0C7Rbw3ax5Q9a+3JkqqACeI8v
         /o1ZQ3GvApQHNCX1GhZogVvyeKYPMFRx9exWSQ5GN6SSDtGSIGxXn12YhdSqccxFhmM2
         +wcWoEZ9K55DnphwEBmbkZyZuWl5hYXjRTXaGWMn6zNsDc2Ulk1glE7wGNA3Nmmj7O5Z
         d1vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XLSwI73WmHabYIrb70KZon+WK8nK9DtKQn4OjxSwzrY=;
        b=IwCeEyx5rdd9DaCURFyLKv4MSE6oFNgE9GAJoLPbfvFAVcI+uBu9xszNhMJoGXAWFM
         KBlnfaoWPz3LVxBDlc907sLMtZNwFQjF2uJr06AvuDb1IAEyfeDcA+4sjGpm4L2wi668
         okH4W02aG0xe4+3hbp40BPYb9ZLYT6i8fyADXtSEPmZhuyKJlM3/EIdH+eBhcq8T0G6y
         7f8+/DpD8J6aJBqAw2WZSg955R6ldPyoSa/OmoyA1Pc6HTxGyTnkQcA1NtmZMIOp5qs4
         KlNPly9bXxbduxmlBkBm+XQwUqMYlGpQ1z60aAQoHZPYuNgtlu9KHO6oRkRsS4w5f0jv
         kH/Q==
X-Gm-Message-State: AOAM533pLBFT876Cizcl1jywTwhwzpmXtKeNrTJqZqP459f/8XFidzjc
        GQqFb0IXdwtgAZBTDfFg884MJGCQLxlQBX9DMBCuzw==
X-Google-Smtp-Source: ABdhPJxno+trsFrNPzgpsUAC29o93/cMq+aZ8Ly92a706zNbJWOugsIla4M8Bk+3EiWbnuz9TSHm40DEONDFz5c5CaY=
X-Received: by 2002:aa7:c2d7:: with SMTP id m23mr33623697edp.230.1605848887318;
 Thu, 19 Nov 2020 21:08:07 -0800 (PST)
MIME-Version: 1.0
References: <20201118232014.2910642-1-awogbemila@google.com>
 <20201118232014.2910642-2-awogbemila@google.com> <9b38c47593d2dedd5cad2c425b778a60cc7eeedf.camel@kernel.org>
 <CAL9ddJf1bPH2na9x6G7q22Jk-e_R7gP=yEVTe9y6vzrmnuRm6Q@mail.gmail.com> <20201120020140.GA26162@ranger.igk.intel.com>
In-Reply-To: <20201120020140.GA26162@ranger.igk.intel.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Thu, 19 Nov 2020 21:07:56 -0800
Message-ID: <CAL9ddJckQ3MVMgTMA2pZjrGsCqFMgqbiSL26z7zqozyQ-Ff4tw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/4] gve: Add support for raw addressing
 device option
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, Netdev <netdev@vger.kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 6:10 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Thu, Nov 19, 2020 at 04:22:24PM -0800, David Awogbemila wrote:
> > On Thu, Nov 19, 2020 at 12:21 PM Saeed Mahameed <saeed@kernel.org> wrote:
> > >
> > > On Wed, 2020-11-18 at 15:20 -0800, David Awogbemila wrote:
> > > > From: Catherine Sullivan <csully@google.com>
> > > >
> > > > Add support to describe device for parsing device options. As
> > > > the first device option, add raw addressing.
> > > >
> > > > "Raw Addressing" mode (as opposed to the current "qpl" mode) is an
> > > > operational mode which allows the driver avoid bounce buffer copies
> > > > which it currently performs using pre-allocated qpls
> > > > (queue_page_lists)
> > > > when sending and receiving packets.
> > > > For egress packets, the provided skb data addresses will be
> > > > dma_map'ed and
> > > > passed to the device, allowing the NIC can perform DMA directly - the
> > > > driver will not have to copy the buffer content into pre-allocated
> > > > buffers/qpls (as in qpl mode).
> > > > For ingress packets, copies are also eliminated as buffers are handed
> > > > to
> > > > the networking stack and then recycled or re-allocated as
> > > > necessary, avoiding the use of skb_copy_to_linear_data().
> > > >
> > > > This patch only introduces the option to the driver.
> > > > Subsequent patches will add the ingress and egress functionality.
> > > >
> > > > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > > > Signed-off-by: Catherine Sullivan <csully@google.com>
> > > > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > > > ---
> > > >
> > > ...
> > > > diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c
> > > > b/drivers/net/ethernet/google/gve/gve_adminq.c
> > > > index 24ae6a28a806..1e2d407cb9d2 100644
> > > > --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> > > > +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> > > > @@ -14,6 +14,57 @@
> > > >  #define GVE_ADMINQ_SLEEP_LEN         20
> > > >  #define GVE_MAX_ADMINQ_EVENT_COUNTER_CHECK   100
> > > >
> > > > +#define GVE_DEVICE_OPTION_ERROR_FMT "%s option error:\n" \
> > > > +"Expected: length=%d, feature_mask=%x.\n" \
> > > > +"Actual: length=%d, feature_mask=%x.\n"
> > > > +
> > > > +static inline
> > > > +struct gve_device_option *gve_get_next_option(struct
> > > >
> > >
> > > Following Dave's policy, no static inline functions in C files.
> > > This is control path so you don't really need the inline here.
> >
> > Okay, I'll move it to a header file.
>
> That's not what Saeed meant I suppose. Policy says that we let the
> compiler to make the decision whether or not such static function should
> be inlined. And since it's not a performance critical path as Saeed says
> then drop the inline and keep the rest as-is.

Oh I see, thanks for the clarification, I was going to remove the
inline keyword and move it to a header file but I see now that I can
just remove the inline keyword. thanks.
