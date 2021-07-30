Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1202D3DB5D8
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 11:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238089AbhG3J0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 05:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhG3J0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 05:26:06 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9FCC061765
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 02:26:01 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q3so10505202wrx.0
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 02:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=AkuGs7W3jKofUPHLtLFgYg9f4YA+eRGF5if/gTr/VXg=;
        b=lylUtumRYNonwKmsPvuJom3wxBHkLf4anhWQaqkh04Z4ai4zZJd08vdZ7peV9SRpsh
         8kDAxoMFjhA4/LA7o2la5MrwwsntBQgGjb0I1dUZFTJHnBuxsue7dB41Zed6v8YvFnQx
         EtWmNPzKWs0OwoVonXjeCSLzamGDsOrch7MlE+WtH/ppN38tQ4p8HLRgifhRRjoPlQkI
         e7dhso1fixnA6ExwMDoIvam1wge26Ggl97vNBtGlzBzaYUrpPxGPV5UmfIV5g4S/Vge/
         4ukVRSa4etHYaDGK4EAFlKuotQCFXCnz8HEMRP8pLWuHCS1V7/wsG8+TQIpv8pIama72
         IoVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=AkuGs7W3jKofUPHLtLFgYg9f4YA+eRGF5if/gTr/VXg=;
        b=scv4e2EVlT2+R8rpARpLQ/eJ6tpNNeLChkh3mHOf3FtvtbL8xry6p4NN6PxT+1G8Md
         Sb5dg+r3h7dl7drAhel9qV8LV7p8pDQBBmuK4qaxo4zkdVbU70snGiCkKj7nVHRTuXAR
         2QA7sYmAfQlT1UTJ8IyewfnBu4+riUwkncIbC/jO1t2DnPZ+62iOpYh8z0gv2ssyCGAT
         3cCPdJzLHkyJyI/GO8tPC6VjFNExhNQmlHhYdtdtxVagBck+uFLjvxF1o9stZ+DBipa6
         czjIEbmnEyxsPnSPEUDGGnC4zSCIJ4XRrXZ7GRc6kgmd08QtY0whmSlJhE0lPkIS1t2u
         ROWg==
X-Gm-Message-State: AOAM530vjr+oK1G0TPpLo9HFPCrussRRmtCHOQ7DKQCkIoT5QDlAg6Yo
        gRmUQDqGO3GQdZOrf5KDRZq+/w==
X-Google-Smtp-Source: ABdhPJzeDirH6vZRgzsjdA+6SGrdUfGDvYu5Q0o7XkuF8nVr9uoOebNL2C+zT2PnMdIeL/CWiOquwA==
X-Received: by 2002:a5d:6448:: with SMTP id d8mr1920645wrw.295.1627637160119;
        Fri, 30 Jul 2021 02:26:00 -0700 (PDT)
Received: from grappa.linbit (62-99-137-214.static.upcbusiness.at. [62.99.137.214])
        by smtp.gmail.com with ESMTPSA id v15sm1259298wmj.39.2021.07.30.02.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 02:25:59 -0700 (PDT)
Date:   Fri, 30 Jul 2021 11:25:57 +0200
From:   Lars Ellenberg <lars.ellenberg@linbit.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 48/64] drbd: Use struct_group() to zero algs
Message-ID: <20210730092557.GC909654@grappa.linbit>
Mail-Followup-To: Bart Van Assche <bvanassche@acm.org>,
        Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-49-keescook@chromium.org>
 <1cc74e5e-8d28-6da4-244e-861eac075ca2@acm.org>
 <202107291845.1E1528D@keescook>
 <0d71917d-967f-beaa-d83e-a60fa254627c@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d71917d-967f-beaa-d83e-a60fa254627c@acm.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 07:57:47PM -0700, Bart Van Assche wrote:
> On 7/29/21 7:31 PM, Kees Cook wrote:
> > On Wed, Jul 28, 2021 at 02:45:55PM -0700, Bart Van Assche wrote:
> >> On 7/27/21 1:58 PM, Kees Cook wrote:
> >>> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> >>> field bounds checking for memset(), avoid intentionally writing across
> >>> neighboring fields.
> >>>
> >>> Add a struct_group() for the algs so that memset() can correctly reason
> >>> about the size.
> >>>
> >>> Signed-off-by: Kees Cook <keescook@chromium.org>
> >>> ---
> >>>   drivers/block/drbd/drbd_main.c     | 3 ++-
> >>>   drivers/block/drbd/drbd_protocol.h | 6 ++++--
> >>>   drivers/block/drbd/drbd_receiver.c | 3 ++-
> >>>   3 files changed, 8 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
> >>> index 55234a558e98..b824679cfcb2 100644
> >>> --- a/drivers/block/drbd/drbd_main.c
> >>> +++ b/drivers/block/drbd/drbd_main.c
> >>> @@ -729,7 +729,8 @@ int drbd_send_sync_param(struct drbd_peer_device *peer_device)
> >>>   	cmd = apv >= 89 ? P_SYNC_PARAM89 : P_SYNC_PARAM;
> >>>   	/* initialize verify_alg and csums_alg */
> >>> -	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
> >>> +	BUILD_BUG_ON(sizeof(p->algs) != 2 * SHARED_SECRET_MAX);
> >>> +	memset(&p->algs, 0, sizeof(p->algs));
> >>>   	if (get_ldev(peer_device->device)) {
> >>>   		dc = rcu_dereference(peer_device->device->ldev->disk_conf);
> >>> diff --git a/drivers/block/drbd/drbd_protocol.h b/drivers/block/drbd/drbd_protocol.h
> >>> index dea59c92ecc1..a882b65ab5d2 100644
> >>> --- a/drivers/block/drbd/drbd_protocol.h
> >>> +++ b/drivers/block/drbd/drbd_protocol.h
> >>> @@ -283,8 +283,10 @@ struct p_rs_param_89 {
> >>>   struct p_rs_param_95 {
> >>>   	u32 resync_rate;
> >>> -	char verify_alg[SHARED_SECRET_MAX];
> >>> -	char csums_alg[SHARED_SECRET_MAX];
> >>> +	struct_group(algs,
> >>> +		char verify_alg[SHARED_SECRET_MAX];
> >>> +		char csums_alg[SHARED_SECRET_MAX];
> >>> +	);
> >>>   	u32 c_plan_ahead;
> >>>   	u32 c_delay_target;
> >>>   	u32 c_fill_target;
> >>> diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
> >>> index 1f740e42e457..6df2539e215b 100644
> >>> --- a/drivers/block/drbd/drbd_receiver.c
> >>> +++ b/drivers/block/drbd/drbd_receiver.c
> >>> @@ -3921,7 +3921,8 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
> >>>   	/* initialize verify_alg and csums_alg */
> >>>   	p = pi->data;
> >>> -	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
> >>> +	BUILD_BUG_ON(sizeof(p->algs) != 2 * SHARED_SECRET_MAX);
> >>> +	memset(&p->algs, 0, sizeof(p->algs));
> >>
> >> Using struct_group() introduces complexity. Has it been considered not to
> >> modify struct p_rs_param_95 and instead to use two memset() calls instead of
> >> one (one memset() call per member)?
> > 
> > I went this direction because using two memset()s (or memcpy()s in other
> > patches) changes the machine code. It's not much of a change, but it
> > seems easier to justify "no binary changes" via the use of struct_group().
> > 
> > If splitting the memset() is preferred, I can totally do that instead.
> > :)
> 
> I don't have a strong opinion about this. Lars, do you want to comment
> on this patch?


Fine either way. "no binary changes" sounds good ;-)

Thanks,
    Lars

