Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5586C1DF5
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjCTRaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbjCTR3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:29:52 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E7A33CE4;
        Mon, 20 Mar 2023 10:25:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a16so8556176pjs.4;
        Mon, 20 Mar 2023 10:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679333129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TFjbf1hqGKTeNG29GCna0olkfNIXH80B4W/+/wvwthc=;
        b=Jk98EvIs3B0BqU2BquE5gMDbTQB25Jebzbw0h43Pu2Si3wDTISCQ4agjC+8N4iUURS
         5yw8yeqwYdg4l44DJr09Q1YC43CVGhARn2dFQKKnTVr1x2e88UpHOZTfN9KrRqtQM0pW
         4SbAzUj7gt/0OxewlcWqBVhYihaxfIcqABO1tEP7yldeCSQgWyt7gumrVPw/8mBN2hft
         I4ixCRnCK5BWBbAwKYCtcc6X5CMvMehQSPOr1YncIwUvQ5RkullWQjXoT63q5jAIU3ZF
         2DXOhk163onSWhAaVaozEQZvwUZWzaoagCrJXCpWypa+vpC/VktyVyEt7fg/hO1bEoW8
         pp2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679333129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TFjbf1hqGKTeNG29GCna0olkfNIXH80B4W/+/wvwthc=;
        b=ubRsTsqDDYgfXGG2SMwKasyMwVVe38ODzJb1WE8aq3Te+qw/3bxabv1kZ1tqYh5iHj
         l+DssM+Jcgl6vj7z0W5sWFYk8V6TgzvZwuTfBu3waPP4prQ0ZIsojR3Tfxj1hggTPqhn
         Sz90NUaLmAn8G50WdcelqxPXgI3dmvpRBgOK6ho+DtRmgj/N9/MFJA5qe1aD+QYLFcKy
         gPTpuazx6K6yUGQqWKwQIXxGMjgir6u2gcqU4V6MrCJyuKCZv0fmQyqW/tMzNJDv1ZT1
         l1T/jYmyW1G1ZRroZ6EH4ong6sJGYsk+M+3vBOitLjBiOTuH5uFh1LbGsXTzKi/oKRXv
         GXuQ==
X-Gm-Message-State: AO0yUKWxBfeUI/vG1RLYiPgJF+eg7nqptLkZur90x2mldGjWMkePQ+sk
        Zfc/R0V9efwAPp0U9FhiZft/Djo1LYMGYiOz/r+glZxgxJ3M3bsc
X-Google-Smtp-Source: AK7set8A2ig0P7/M3s+VqagZD5H2PiVLLygkBloHuagQwx4lJ2s+gPrNpnecfaoTyt+bkIr5Xtjm/pxKnNjU/qynDCo=
X-Received: by 2002:a17:902:c40c:b0:19f:22aa:692e with SMTP id
 k12-20020a170902c40c00b0019f22aa692emr7406162plk.4.1679333128910; Mon, 20 Mar
 2023 10:25:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAE2MWkm=zvkF_Ge1MH7vn+dmMboNt+pOEEVSgSeNNPRY5VmroA@mail.gmail.com>
 <a4ce2c34-eabe-a11f-682a-4cecf6c3462b@blackwall.org>
In-Reply-To: <a4ce2c34-eabe-a11f-682a-4cecf6c3462b@blackwall.org>
From:   Ujjal Roy <royujjal@gmail.com>
Date:   Mon, 20 Mar 2023 22:55:17 +0530
Message-ID: <CAE2MWkkDNZuThePts_nU-LNYryYyWTYOMk5gmuoCoGPh4bf4ag@mail.gmail.com>
Subject: Re: Multicast: handling of STA disconnect
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, netdev@vger.kernel.org,
        Kernel <linux-kernel@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

Flushing MDB can only be done when we are managing it per station not
per port. For that we need to have MCAST_TO_UCAST, EHT and FAST_LEAVE.

Here one more point is - some vendors may offload MCAST_TO_UCAST
conversion in their own FW to reduce CPU.

So, the best way is to have MCAST_TO_UCAST enabled and MDB will become
per station, so we can delete MDB on disconnect. Shall, I create one
patch for review?

Thanks,
UjjaL Roy

On Mon, Mar 20, 2023 at 5:38=E2=80=AFPM Nikolay Aleksandrov <razor@blackwal=
l.org> wrote:
>
> On 20/03/2023 13:45, Ujjal Roy wrote:
> > Hi Nikolay,
> >
> > I have some query on multicast. When streams running on an STA and STA
> > disconnected due to some reason. So, until the MDB is timed out the
> > stream will be forwarded to the port and in turn to the driver and
> > dropps there as no such STA.
> >
> > So, is the multicast_eht handling this scenario to take any action
> > immediately? If not, can we do this to take quick action to reduce
> > overhead of memory and driver?
> >
> > I have an idea on this. Can we mark this port group (MDB entry) as
> > INACTIVE from the WiFi disconnect event and skip forwarding the stream
> > to this port in br_multicast_flood by applying the check? I can share
> > the patch on this.
> >
> > Thanks,
> > UjjaL Roy
>
> Hi,
> Fast leave and EHT (as that's v3's fast leave version) are about quickly =
converging when
> a leave is received (e.g. when there are no listeners to quickly remove t=
he mdb). They
> don't deal with interface states (IIUC). Why don't you just flush the por=
t's mdb entries
> on disconnect? That would stop fwding.
>
> Cheers,
>  Nik
>
>
