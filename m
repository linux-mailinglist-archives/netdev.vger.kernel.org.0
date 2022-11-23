Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27906360F9
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238349AbiKWOCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238640AbiKWOCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:02:09 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823CDCC7;
        Wed, 23 Nov 2022 05:57:29 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id l42-20020a9d1b2d000000b0066c6366fbc3so11241268otl.3;
        Wed, 23 Nov 2022 05:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7CVHZVP3fIe30aVhjf7yUHQEvn8R65IAxKTaVWEtsM8=;
        b=Pr3nUR9um+JPvRY7n/nPYBbznTdsj71zSSoYTu28iy8BEqlNA1C4S3CaivwoEravBT
         y4WihpalpqL7i1krmNAltRkZCYCM0aJxjtBpvxtbFH0DrPjXRJqMuTU4/DJZrPJziaC0
         vxhykaz5ISSFQBXrzS49FNL5OhpDyYcMqUhLh8hep+6LPeUEQIAdQWvb2nLo3bm09y+c
         rNSsf5v0YzYSEq/2YkxYN4EVMPicodqGERVk1+mSBjMB2G7ufPTXynSghmUg+rmFp7BM
         wNC4un5OqwmGA9RdiU4po9ZWsJ8mEUFhmmcZVl+hliPjUFVNb0wrSzgId8itrOgSovib
         GX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7CVHZVP3fIe30aVhjf7yUHQEvn8R65IAxKTaVWEtsM8=;
        b=vWfJi1IGUQe49QzF02G6eaaVWcXPZdFQVT65Icg0IOg8dU/gbW76QwmT3QK1XJEJRy
         0AY6W71b3NK0Wj87tavxUKpEX1UqdBSzHz8LGaCHvCjUzZu1B/P7oblk36+9+IYnXM9C
         EneDNkHiFZm2p+XCaLM1Q6WKzZTYIKtLdfcBQXfnJpHZCN4fSDoR5vR7lQMxPF4Wcliz
         QiIAd/iLbAazUUSq8oHrLpZoI7ghLLuqUJkMzi2V9/i39ZHNMfiu0baHnkzWC2rGA40Y
         qVislW832KzhavEVNlkgTSUVMR0dJcEZO8GfTBK0pfX49Tv5Fncs+0E83Tm1A2F8ByWQ
         fIkg==
X-Gm-Message-State: ANoB5pnUbYuf6fif+8LJ/M5KIEO0Yl9RLE8jI9OhqmgFYQjjbgrYQrFD
        7gjX1q3JEmVRFuGBktZoOGE=
X-Google-Smtp-Source: AA0mqf6Krc0gSP4HoALERy24B1XCceRkMmTX0SaZ3kssMdEd+5vOqcReq+Ckn/5dmOmMOJJ02swf1Q==
X-Received: by 2002:a9d:17ca:0:b0:66d:5fb6:6e8c with SMTP id j68-20020a9d17ca000000b0066d5fb66e8cmr14798529otj.112.1669211848682;
        Wed, 23 Nov 2022 05:57:28 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:5412:fa8e:2d33:bd7c:54c7])
        by smtp.gmail.com with ESMTPSA id eh5-20020a056870f58500b0013cd709659dsm9127442oab.52.2022.11.23.05.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 05:57:28 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id DEBCC459C73; Wed, 23 Nov 2022 10:57:25 -0300 (-03)
Date:   Wed, 23 Nov 2022 10:57:25 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     syzbot <syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        linux-sctp@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH] sctp: relese sctp_stream_priorities at
 sctp_stream_outq_migrate()
Message-ID: <Y34mxTlLaRcR9d4z@t14s.localdomain>
References: <000000000000e99e2705edb7d6cf@google.com>
 <c5ba2194-dbb6-586d-992d-9dfcd27062e7@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5ba2194-dbb6-586d-992d-9dfcd27062e7@I-love.SAKURA.ne.jp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 07:36:00PM +0900, Tetsuo Handa wrote:
> syzbot is reporting memory leak on sctp_stream_priorities [1], for
> sctp_stream_outq_migrate() is resetting SCTP_SO(stream, i)->ext to NULL
> without clearing SCTP_SO(new, i)->ext->prio_head list allocated by
> sctp_sched_prio_new_head(). Since sctp_sched_prio_free() is too late to
> clear if stream->outcnt was already shrunk or SCTP_SO(stream, i)->ext
> was already NULL, add a callback for clearing that list before shrinking
> stream->outcnt and/or resetting SCTP_SO(stream, i)->ext.
> 
> Link: https://syzkaller.appspot.com/bug?exrid=29c402e56c4760763cc0 [1]
> Reported-by: syzbot <syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
> I can observe that the reproducer no longer reports memory leak. But
> is this change correct and sufficient? Are there similar locations?

Thanks, but please see my email from yesterday. This is on the right
way but a cleanup then is possible:
https://lore.kernel.org/linux-sctp/Y31ct%2FlSXNTm9ev9@t14s.localdomain/

  Marcelo
