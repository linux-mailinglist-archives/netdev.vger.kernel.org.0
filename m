Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F73243B36
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 16:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHMOHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 10:07:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43677 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726106AbgHMOHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 10:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597327630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zGXP4qw+AnPxVdaG8af/8IcGg0r93+iBSNIWSEPA6j8=;
        b=QLUvqXVINTXUM8ERNWq/oNzrDPpO8amLPEPmWHRrtlhf9fI6E3gfusAOTIzTu+8LBMxDNm
        QER24JuYaUDER3H7gzjSV6yys+g1zBoydbXft7GQ9295jbZtmreJtOQm/0qB1bL/JQ90ml
        A52klH09zL0qhjPXeoxI+Dz5Xmm26Ws=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-niPElpRhM4u0VNISoZ_uPw-1; Thu, 13 Aug 2020 10:07:07 -0400
X-MC-Unique: niPElpRhM4u0VNISoZ_uPw-1
Received: by mail-oi1-f197.google.com with SMTP id s82so2770783oih.5
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 07:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zGXP4qw+AnPxVdaG8af/8IcGg0r93+iBSNIWSEPA6j8=;
        b=IRpYLn57Md0JvDgTluc/BEE23AE8xREJOKycLWXM/7vnZRnW2yElqfG2loM1JS7OBT
         T7R7J9y7hAABVqYs/qVBCrrd+S++mZmAxW9HRr52vBAYXRoTLQumer2rhOOG4al1u17j
         mmgAtvT1JORNBJCwaLavtwSj/6cqhXIfy/nkKo8eL/dwpQbDViDXDs8UHbS0a7Lnlbz7
         ljSvg7rG23Ppv/COzk4EsAAEX5USXOrJnFEoZsRgMW0Y4LI0a2JCPPaCBcFcsk6lTHAf
         vZcuYwBnOY2m0XYnC8UkM5fzXvC6Y3hfnBrVL9EEnNXURbBUiEDbm8s0702AZBr7uZrq
         GctQ==
X-Gm-Message-State: AOAM531cK4XdSLp9XbHFLPoIGyToVRCExsrjAcY5h7JyB3dqDKlmRJn+
        V7fUv2IcQslV862bybgtUu42OoKJK3jcMMGLpImDCnCNd8AL3kev3TY7dq9Fux0i7yQz36P7Z2x
        BI1yVcd/jjZx2tAEvTfIvelLArEAAGUPk
X-Received: by 2002:a4a:52c2:: with SMTP id d185mr4787880oob.8.1597327626800;
        Thu, 13 Aug 2020 07:07:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeiGfQxpCVrZBxl/IupXG+HiieUJGX1pf9TTQuoJCQy4jQixWt3yjdm0mI9ztVpuUj6EB1hgCns/RG7IOzMsk=
X-Received: by 2002:a4a:52c2:: with SMTP id d185mr4787847oob.8.1597327626508;
 Thu, 13 Aug 2020 07:07:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200813035509.739-1-jarod@redhat.com> <27389.1597296596@famine>
In-Reply-To: <27389.1597296596@famine>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Thu, 13 Aug 2020 10:06:56 -0400
Message-ID: <CAKfmpSeRsh4tYaQPg22d8L92i1jEP3J9Y5G8udutGruVURa=Fg@mail.gmail.com>
Subject: Re: [PATCH net] bonding: show saner speed for broadcast mode
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 1:30 AM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Jarod Wilson <jarod@redhat.com> wrote:
>
> >Broadcast mode bonds transmit a copy of all traffic simultaneously out of
> >all interfaces, so the "speed" of the bond isn't really the aggregate of
> >all interfaces, but rather, the speed of the lowest active interface.
>
>         Did you mean "slowest" here?

I think I was thinking "lowest speed", but the way it's written does
seem a little ambiguous, and slowest would fit better. I'll repost
with slowest.

> >Also, the type of the speed field is u32, not unsigned long, so adjust
> >that accordingly, as required to make min() function here without
> >complaining about mismatching types.
> >
> >Fixes: bb5b052f751b ("bond: add support to read speed and duplex via ethtool")
> >CC: Jay Vosburgh <j.vosburgh@gmail.com>
> >CC: Veaceslav Falico <vfalico@gmail.com>
> >CC: Andy Gospodarek <andy@greyhouse.net>
> >CC: "David S. Miller" <davem@davemloft.net>
> >CC: netdev@vger.kernel.org
> >Signed-off-by: Jarod Wilson <jarod@redhat.com>
>
>         Did you notice this by inspection, or did it come up in use
> somewhere?  I can't recall ever hearing of anyone using broadcast mode,
> so I'm curious if there is a use for it, but this change seems
> reasonable enough regardless.

Someone working on our virt management tools was working on something
displaying bonding speeds in the UI, and reached out, thinking the
reporting for broadcast mode was wrong. My response was similar: I
don't think I've ever actually used broadcast mode or heard of anyone
using it, but for that one person who does, sure, we can probably make
that adjustment. :)

-- 
Jarod Wilson
jarod@redhat.com

