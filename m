Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC2769F9E5
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 18:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjBVRWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 12:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjBVRWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 12:22:43 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A603392A1
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 09:22:42 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id bt6so8268584qtb.4
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 09:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=urt54I/eS/8HI+o0VQThaLcMNHDkXdGsGwBFBUqrL/o=;
        b=bqL/NTLXKGEuL+4m3vQ7ek/8ys4mzYnaQ01HjVZjpjK5gJ0l1od5y20SrxcEZciafi
         wd0dLcVAOjsXK8vlzgbS75ZagoJykvR+i3ffLgfZS9rixLb/OCXsFQ0ttJ369FfW/W+h
         YUz2fvNigpgpsH4FhuH5CKYuJDrOJT7cGaqXVrkaNbe/3QTo9ABey8iGP6GkZbLj8E6d
         U955eINgy9LZrlpUkGsUFA54jZj1D1ZHlvmAXkpbhl+X+Y2vtXCNRz3DZH15e+d3ryl0
         ppqjaDrRuMyjKBTiC2QP3KvchryigCXWtD5rHwXr8e81b1HqhwDXNUPNfiFzxUUx2eBk
         rwkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=urt54I/eS/8HI+o0VQThaLcMNHDkXdGsGwBFBUqrL/o=;
        b=FceIepgUWq3uurNV1nPw/NM17GXC6pFjh327G0cPOiHYSbwMSNO5HIuA1Nk/O4PRbp
         m+eZXRsu8y2d39YpcoB6G+myCUoN/BFRMolaT02olh/ZwUjJQ0T1yLIR+KOB2IKnGGfe
         ouhEbVfTbWbZ3brU/Duf0eMDCtHwFN3By7h+tI3vWKXNvC/P4JURQDowXo4GaslgXy/9
         6Uq7Bp4NG+cOK7W2gWnI3NQeC7FcWQTLxTz0/qhEWj+szfx/TJYu/sjjSsp0qG3U9zoJ
         TCxPQGFGVBbhTOLCBrwhGQHX9PokUTFm68NEt6vHHycjZCDmNAjiylQQaurLwcWa0stK
         4FIQ==
X-Gm-Message-State: AO0yUKUE8Kwe2pbN0DukBcYI1T7+owtv+Pg/2UCM6Ba7DhMD7On16zMS
        KxzI193UP82oc1ckZkuy9nY=
X-Google-Smtp-Source: AK7set8i+vR9JM1Pw3Dm3JrVqhd82Rxrlt8ctyIHuZQSTvzdEikyUMZhaJazcG+yjybr3la6bn52KQ==
X-Received: by 2002:a05:622a:610:b0:3b8:6930:ee6 with SMTP id z16-20020a05622a061000b003b869300ee6mr322025qta.21.1677086561106;
        Wed, 22 Feb 2023 09:22:41 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id oq21-20020a05620a611500b0074235fc7a69sm1560889qkn.68.2023.02.22.09.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 09:22:40 -0800 (PST)
Date:   Wed, 22 Feb 2023 12:22:40 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        alvaro.karsz@solid-run.com, vmireyno@marvell.com, parav@nvidia.com
Message-ID: <63f64f6053a19_189d62088a@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230222110534-mutt-send-email-mst@kernel.org>
References: <20230221144741.316477-1-jiri@resnulli.us>
 <63f4df39e0728_ce6df208fe@willemb.c.googlers.com.notmuch>
 <Y/TltJnD4k5hB6Z1@nanopsycho>
 <63f4ed716af37_d174a20880@willemb.c.googlers.com.notmuch>
 <Y/XLIs+4eg7xPyF0@nanopsycho>
 <63f6314d678bc_2ab6208a@willemb.c.googlers.com.notmuch>
 <20230222110534-mutt-send-email-mst@kernel.org>
Subject: Re: [patch net-next v2] net: virtio_net: implement exact header
 length guest feature
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael S. Tsirkin wrote:
> On Wed, Feb 22, 2023 at 10:14:21AM -0500, Willem de Bruijn wrote:
> > Either including the link that Michael shared or quoting the relevant
> > part verbatim in the commit message would help, thanks.
> > 
> > Thinking it over, my main concern is that the prescriptive section in
> > the spec does not state what to do when the value is clearly garbage,
> > as we have seen with syzkaller.
> > 
> > Having to sanitize input, by dropping if < ETH_HLEN or > length, to
> > me means that the device cannot trust the field, as the spec says it
> > should. 
> 
> Right. I think the implication is that if device detects and illegal
> value it's OK for it to just drop the packet or reset or enter
> a broken mode until reset.
> 
> By contrast without the feature bit the header size can be
> used as a hint e.g. to size allocations but you must
> recover if it's incorrect.
> 
> And yes tap seems to break if you make it too small or if you make
> it huge so it does not really follow the spec in this regard.
> 
> Setting the flag will not fix tap because we can't really
> affort breaking all drivers who don't set it. But it will
> prepare the ground for when tens of years from now we
> actually look back and say all drivers set it, no problem.
> 
> So that's a good reason to ack this patch.

I also have no concerns with the commit itself. It would become an
issue only if tap would support it and trust hdr_len unconditionally.

Acked-by: Willem de Bruijn <willemb@google.com>
 
> However if someone is worried about this then fixing tap
> so it recovers from incorrect header length without
> packet loss is a good idea.
> 
> > Sanitization is harder in the kernel, because it has to support all
> > kinds of link layers, including variable length.
> > 
> > Perhaps that's a discussion for the spec rather than this commit. But
> > it's a point to clarify as we add support to the code.
> 
> -- 
> MST
> 


