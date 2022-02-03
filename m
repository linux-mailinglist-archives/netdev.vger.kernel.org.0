Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0254A9017
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355419AbiBCVmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbiBCVmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 16:42:09 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6315C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 13:42:08 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id 124so12443339ybw.6
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 13:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v5TR9sZrLWtStvGOBifJlH3i72bx4wZCcsEX3we5lxU=;
        b=qDLp5fr+AQcjmVl8e6wK49wYzLByQBAnCF4zKf/EiEEzPZgdM3wfAPFaQN9L4HkfG8
         i4TjO9Rfa9CiGCcUSfkBnwKocD5LdTITdrEphktJ39wR2vwf3XUNAUeOaFICGqgg4M4a
         y9ZwrlITSNKUKsEQdiyTZpQ0hQyoXFYBgZozunZh1xcEl9WdWnyyw+z+HFW1BKmIbfKI
         s25XJzhEKXb18dFpPWE4iJUqA9F6CeU0qoZ/FEDzaCuwKi/boo69wlhdXRTFqQPX6RVy
         XJIw0PE8h2d5wtnywRdX4/7iaxJogxxUinASYI3w31awpthf/LtN17GB6BBhsXrNJYkA
         XQnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v5TR9sZrLWtStvGOBifJlH3i72bx4wZCcsEX3we5lxU=;
        b=1Yx9FKOVt74EbSqJ8JJZDTJHrwKQ0zOVLQkWWFu1Msym0JHboz9MsO5036+wF8bwtO
         P8NHrBeKbnJbtl+v9Bc5FkXXEzq2hEUY9qxmOTOBat1t+U8FvEfT1OMr85/uu4V7yQfE
         ByqRpljzBv8qch9lreRT+po2V03CDORSwkBiWASlRtg4FSH7JwQGJe/ivguWMOKrwM1N
         3qR2YMtme6vmIOZ/6W5wUlhqlbZmCO3b1Bqshtelxj7pqd7cWvBeQR1hVHEC+bcmRu8D
         FHkJrcZai56VY1bj+4TGzgiDDiCM5DylYSstgzH83kV0K8PaXlCa+2+ZHKd+epxM2tvX
         ao3Q==
X-Gm-Message-State: AOAM530GMzXHiK0J6RGaXCvKRTN0Om+2h+Fzc5JAxXSp/jpqEpJ/hrRg
        K46kzoUVPBwDc3ri5oYTL3SOL3uapbaG0bAfv1gqlQ==
X-Google-Smtp-Source: ABdhPJy+EZzhXZzhi2eLiEarAsuZmK7eDeklstRSfC7Q1JI4CdMnlhRBy7VqJ3JwS0uZw6T4uKu0Xv2GWAPLysu//tY=
X-Received: by 2002:a81:c54:: with SMTP id 81mr62110ywm.464.1643924527600;
 Thu, 03 Feb 2022 13:42:07 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-6-eric.dumazet@gmail.com> <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
 <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com>
 <CAKgT0UfWd2PyOhVht8ZMpRf1wpVwnJbXxxT68M-hYK9QRZuz2w@mail.gmail.com>
 <CANn89iKzDxLHTVTcu=y_DZgdTHk5w1tv7uycL27aK1joPYbasA@mail.gmail.com> <802be507c28b9c1815e6431e604964b79070cd40.camel@gmail.com>
In-Reply-To: <802be507c28b9c1815e6431e604964b79070cd40.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 13:41:56 -0800
Message-ID: <CANn89iLLgF6f6YQkd26OxL0Fy3hUEx2KQ+PBQ7p6w8zRUpaC_w@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo header
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 1:08 PM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, 2022-02-03 at 11:59 -0800, Eric Dumazet wrote:
> > On Thu, Feb 3, 2022 at 11:45 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> >
> > > It is the fact that you are adding IPv6 specific code to the
> > > net/core/skbuff.c block here. Logically speaking if you are adding the
> > > header in ipv6_gro_receive then it really seems li:ke the logic to
> > > remove the header really belongs in ipv6_gso_segment. I suppose this
> > > is an attempt to optimize it though, since normally updates to the
> > > header are done after segmentation instead of before.
> >
> > Right, doing this at the top level means we do the thing once only,
> > instead of 45 times if the skb has 45 segments.
>
> I'm just wondering if there is a way for us to do it in
> ipv6_gso_segment directly instead though. With this we essentially end
> up having to free the skb if the segmentation fails anyway since it
> won't be able to go out on the wire.
>

Having a HBH jumbo header in place while the current frame is MTU size
(typically MTU < 9000) would
violate the specs. A HBH jumbo header presence implies packet length > 64K.



> If we assume the stack will successfully segment the frame then it
> might make sense to just take care of the hop-by-hop header before we
> start processing the L4 protocol.
