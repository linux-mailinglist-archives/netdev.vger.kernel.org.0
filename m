Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD35644A08
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 18:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiLFRNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 12:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbiLFRNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 12:13:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67922272E;
        Tue,  6 Dec 2022 09:13:18 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso18671320pjt.0;
        Tue, 06 Dec 2022 09:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MNTmn4Ppp22XNGK2CIb4/9yQLF2i0XM6RqxIH3zvJQc=;
        b=SvdgCisjFp/nziYy9m+QZ+pn8qZRGnLTVAkKzitorYutPwQLt6+ipo8IsJrizeEtq1
         Ls/fbizT+P25x3BQMlmNbQ6LbeN2NiSNKhb6ILvXLD11IctDzo7ozrHJAFULOJkz//KP
         BHU9HVSm0bU58l748mY2viuvFdzXZT1ta5M+r14WElKfq0ZH726xw0tC/AMUUyEH1RIy
         pKyAXKTXXqaRxYFqb5R5uezgTqi4hMZ9LEAQ1gzQ/fTpa17YCV34tvbm/mIBaT6+SahD
         oYmzaXmk6ByKtzYYLOeQCAV9uwBdbMrW4oYkN2r749frt+m9TWFbUKxrG+fhqsz1ZkqC
         iAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNTmn4Ppp22XNGK2CIb4/9yQLF2i0XM6RqxIH3zvJQc=;
        b=Ury/hoamZeVS7fjiH6SU5maqcIkjtEcxiHdiTDYLeLc5F75f+sySf7M97KdmDSpeqY
         V9UumVee0TRBrTeit/GzYeXVuhe+7RPlSH7WAQarJS7s61jZFq9OVQcdUWt3sEqAPotN
         MJCbvkQYg5GZ/h39VMJbLilcbWeUjMYp0Fqi8hEnFeVr//FDSeOnLQJ0nvaEH8Vy2x1L
         FHqLE1PtXUP3ieH8xsPypBkeBk45pP3LGBmOoQVJEsJnI3oH1CKcv1SjHoHDc5hG/hLy
         cO1BbPaOVw31b9jBF/goIztCzITgNforGAS0SjfBMmJ1GJt8ttZH1HCST6TkAaqHwCTR
         Kj+g==
X-Gm-Message-State: ANoB5pnsMntivWOLkahnvKw3gU4UgP859t0GoalFPTlJTlxtFbRWNvKy
        bIHXfH4Bq+3eMNxsuQs5j44=
X-Google-Smtp-Source: AA0mqf7qytCU0cuB63i3d9xtAkcgDKJgc/IXkjlQg5k+IzGKNzyl6P3OQwWJVW5PrzeB2vPKS23QdA==
X-Received: by 2002:a17:902:c104:b0:189:a931:c8a1 with SMTP id 4-20020a170902c10400b00189a931c8a1mr32927272pli.112.1670346797784;
        Tue, 06 Dec 2022 09:13:17 -0800 (PST)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id i20-20020a170902e49400b00168dadc7354sm12875922ple.78.2022.12.06.09.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 09:13:17 -0800 (PST)
Date:   Mon, 21 Nov 2022 11:02:54 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] virtio/vsock: replace virtio_vsock_pkt with sk_buff
Message-ID: <Y3ta3hGkygJFNZTo@bullseye>
References: <20221202173520.10428-1-bobby.eshleman@bytedance.com>
 <20221205122214.bky3oxipck4hsqqe@sgarzare-redhat>
 <20221205173735.6123b941@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205173735.6123b941@kernel.org>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 05:37:35PM -0800, Jakub Kicinski wrote:
> On Mon, 5 Dec 2022 13:22:14 +0100 Stefano Garzarella wrote:
> > As pointed out in v4, this is net-next material, so you should use the 
> > net-next tag and base the patch on the net-next tree:
> > https://www.kernel.org/doc/html/v6.0/process/maintainer-netdev.html#netdev-faq
> 
> Thanks, yes, please try to do that, makes it much less likely that 
> the patch will be mishandled or lost.
> 
> > I locally applied the patch on net-next and everything is fine, so maybe 
> > the maintainers can apply it, otherwise you should resend it with the 
> > right tag.
> 
> FWIW looks like all the automated guessing kicked in correctly here,
> so no need to repost just for the subject tag (this time).
> 
> > Ah, in that case I suggest you send it before the next merge window 
> > opens (I guess next week), because net-next closes and you'll have to 
> > wait for the next cycle.
> 
> +1, we'll try to take a closer look & apply tomorrow unless someone
> speaks up.

Thanks all, I'll be sure to do that in the future.
