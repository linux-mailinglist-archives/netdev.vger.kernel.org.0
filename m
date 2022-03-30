Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32844ECD71
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 21:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiC3Tqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 15:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiC3Tqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 15:46:33 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019E345ACE;
        Wed, 30 Mar 2022 12:44:48 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id w127so23108425oig.10;
        Wed, 30 Mar 2022 12:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pjsBmPs0l7j1oUF7fQlTyFt6udSAgSvZHxxIq2cVxVg=;
        b=Zt4ic2/4eeolmTp4xGdY9jHR/mQgUvWijyD+B+gLTfsJCCCL0zQrmj+4j06n/1Bh5V
         g8anomcJ6tn0vjOc2BOWbTCQWpWy5D6W1mfbvRYh7373rCMGNWEfzqS7eOA94yfbwm0g
         471O836OZ0+0HZuufHFroyXZ+RKLDl+XTxot7W6EzqqOB93iy4CHt5057Ui7sxtZP4kv
         X1h+C6WUKF2bGrdMovw4K/9/QPHA1wJfKLE3UydAPNsCpnAp0UrfTNSAqEqsl8SGvaF1
         F9SUjDOh5aVvKa2efUdn0vDCDM7vZUt/veQG5L9DWlZdbiNQL3jyvEJdjuATEqvxXVHP
         E/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pjsBmPs0l7j1oUF7fQlTyFt6udSAgSvZHxxIq2cVxVg=;
        b=BTlcBdmGqe0g23RDZMbEhWOHalo4reAOUMsxbT2AOa/SGxtWwxUF+bUTjYYFKQ3+7n
         Siy+V8Ok3mDLm6Q0JCx1gUudNV8TM3G7c4HZGqCI+dlfCID6JMGmB6vFDOkEX4DdAOov
         MlYBrVqgPTFFZNC+YrdKjPeNRlGvolIzJTmNyVLrV67l/bUfd6mr7aXIVKqIcdn1tkZK
         uKOk5CZ2jwpT/Jde7dWLibmu9Y6fvka9FW+taP643sP+mIbQZ+4CoRqGRsiASRJJ94jZ
         /MXzqiS11qaFDKgsTHZalbJZx5BAa+IZNL7epQ4uAvtiRWWADSJFj741aha+Pb+PuZ65
         /lYQ==
X-Gm-Message-State: AOAM532SN7GL5MljxK2dASp0ZecrSHKk0Ewz2ZB36V4I42xdYhsn3mL4
        dAlhebl+Mh80bpcnmV5QC2k=
X-Google-Smtp-Source: ABdhPJwpUA6Xgeh21wKg5aXRvuZvLzMGjvZRstSWL74fU0t8W0tlmCya43yH85/KKmVPloLzuby3jw==
X-Received: by 2002:aca:34d6:0:b0:2ef:93b1:27d6 with SMTP id b205-20020aca34d6000000b002ef93b127d6mr788090oia.255.1648669487094;
        Wed, 30 Mar 2022 12:44:47 -0700 (PDT)
Received: from t14s.localdomain ([177.220.174.113])
        by smtp.gmail.com with ESMTPSA id d3-20020a9d2903000000b005cda765f578sm10850188otb.0.2022.03.30.12.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 12:44:46 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id CCB421D618F; Wed, 30 Mar 2022 16:44:44 -0300 (-03)
Date:   Wed, 30 Mar 2022 16:44:44 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net] sctp: count singleton chunks in assoc user stats
Message-ID: <YkSzLJ72M5f5EL2L@t14s.localdomain>
References: <0dfee8c9d17c20f9a87c39dbc57f635d998b08d2.1648609552.git.jamie.bainbridge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dfee8c9d17c20f9a87c39dbc57f635d998b08d2.1648609552.git.jamie.bainbridge@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 01:06:02PM +1000, Jamie Bainbridge wrote:
> Singleton chunks (INIT, HEARTBEAT PMTU probes, and SHUTDOWN-
> COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
> counter available to the assoc owner.
> 
> These are all control chunks so they should be counted as such.
> 
> Add counting of singleton chunks so they are properly accounted for.
> 
> Fixes: 196d67593439 ("sctp: Add support to per-association statistics via a new SCTP_GET_ASSOC_STATS call")
> Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
> ---
>  net/sctp/outqueue.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index a18609f608fb786b2532a4febbd72a9737ab906c..bed34918b41f24810677adc0cd4fbd0859396a02 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -914,6 +914,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
>  				ctx->asoc->base.sk->sk_err = -error;
>  				return;
>  			}
> +			ctx->asoc->stats.octrlchunks++;
>  			break;
>  
>  		case SCTP_CID_ABORT:
> @@ -939,6 +940,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
>  		case SCTP_CID_HEARTBEAT:
>  			if (chunk->pmtu_probe) {
>  				sctp_packet_singleton(ctx->transport, chunk, ctx->gfp);
> +				ctx->asoc->stats.octrlchunks++;

sctp_packet_singleton can fail. It shouldn't be propagated to the
socket but octrlchunks shouldn't be incremented then. Not too diferent
from the one above.

>  				break;
>  			}
>  			fallthrough;
> -- 
> 2.35.1
> 
