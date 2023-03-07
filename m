Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591796AF7FC
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjCGVtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjCGVtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:49:12 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F75A76A3;
        Tue,  7 Mar 2023 13:49:07 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id 32-20020a9d0323000000b0069426a71d79so7956789otv.10;
        Tue, 07 Mar 2023 13:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678225747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=inTI/+esstsnj5i3TO7au6XY8GT7xoR846FlgOCno80=;
        b=NOQqfzftEVVKszAGbqu1pMKSpEop/jxPi2WPOo6aoGfPKsySgDVEEbTVoEFzcMvAaK
         M4n7dKCOrgb4jOAXRM/UfrZYa9OZOAGnRnKVO4aEw8Gna5qpT536njrruc9B2/Ty+TUR
         IFSsn5XUOMvbIl82mHjR2RgrOh+4Ca7tfcwo8sQ0nKDKSE+r8eYcFMpEaOR1HtqW/RBP
         dCIYyyOV4LfGsUPbJbZLPKhTNquyip34BayEx5hbJPmdx73bPKvFKDFNa7B/N9SWvoLz
         g/mJnBwvZXy7zpZ4TW58ZCc/hTavBgVcvHFo43AHL9D2YKa/cuF0u6DsSmW74bsSnwgS
         P9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678225747;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=inTI/+esstsnj5i3TO7au6XY8GT7xoR846FlgOCno80=;
        b=5lqEeFhRUOYV20fmPyZ0kjXEvjCs1FTUEbP842k35WsN6TuPktJS3XHsPXercwwq0S
         rAfPK855lBf1NOJ5k/a5oOqruiQkl5VP66IcTbYAkEo0n4H+h0K6Av+jjr/chMuTbZ/R
         N9r3CYhAEs9Nzmrgvj4SyDOY0AuR8pUiJ1w6DXtAdYLfSlH06spWucWLeegSEZrDLb2T
         q++CMykcwN33e9tdocV505viVDUshtl4nXNvoSl+V/qif0Z8pPbgfPWQmBFJtoLgZKhP
         SUhC1s65dILCU/NcLl++I6o4768XlpH4ELEyi9PWdKPtJ+ZnxaC15eYeNnU6XgzEdNjW
         4AYw==
X-Gm-Message-State: AO0yUKUuHx0Zh2OfeBlThgnGIC29dcF+L/8c2ABRLNyJWeg6Ax4aSZWs
        gEuX0UNyAGSOFS1TzKkO1dc=
X-Google-Smtp-Source: AK7set/6PFIE756hbZR1j1qNVLBS/AP1Ix09VnSJhxzFkbB5APOEqg7YzvjUyuySWFBCBWJL9l5W7g==
X-Received: by 2002:a9d:7206:0:b0:68b:dc52:10f9 with SMTP id u6-20020a9d7206000000b0068bdc5210f9mr8252916otj.5.1678225747122;
        Tue, 07 Mar 2023 13:49:07 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:d911:6e2b:27bc:8934:2423])
        by smtp.gmail.com with ESMTPSA id w3-20020a9d70c3000000b0069451a9274bsm5196559otj.28.2023.03.07.13.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:49:06 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 335F84EDE80; Tue,  7 Mar 2023 18:49:05 -0300 (-03)
Date:   Tue, 7 Mar 2023 18:49:05 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net-next 2/2] sctp: add weighted fair queueing stream
 scheduler
Message-ID: <ZAexUWGUCHPj1vXk@t14s.localdomain>
References: <cover.1678224012.git.lucien.xin@gmail.com>
 <61dc1f980ae4cb8c7082446b1334d931404ec9c2.1678224012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61dc1f980ae4cb8c7082446b1334d931404ec9c2.1678224012.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 04:23:27PM -0500, Xin Long wrote:
> As it says in rfc8260#section-3.6 about the weighted fair queueing
> scheduler:
> 
>    A Weighted Fair Queueing scheduler between the streams is used.  The
>    weight is configurable per outgoing SCTP stream.  This scheduler
>    considers the lengths of the messages of each stream and schedules
>    them in a specific way to use the capacity according to the given
>    weights.  If the weight of stream S1 is n times the weight of stream
>    S2, the scheduler should assign to stream S1 n times the capacity it
>    assigns to stream S2.  The details are implementation dependent.
>    Interleaving user messages allows for a better realization of the
>    capacity usage according to the given weights.
> 
> This patch adds Weighted Fair Queueing Scheduler actually based on
> the code of Fair Capacity Scheduler by adding fc_weight into struct
> sctp_stream_out_ext and taking it into account when sorting stream->
> fc_list in sctp_sched_fc_sched() and sctp_sched_fc_dequeue_done().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
