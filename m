Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444F54EAE0A
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 15:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbiC2NCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 09:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbiC2NCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 09:02:38 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4627B81195;
        Tue, 29 Mar 2022 06:00:54 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id w17-20020a056830111100b005b22c584b93so12703992otq.11;
        Tue, 29 Mar 2022 06:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dIBW/AmxWldr1Ome03Y/fPYuT0zzFX/DeE/FlPmJGCs=;
        b=MzrPbYGAczQ/QJXurFEC3nTGPmCbqxof34LITESjRbO8YykJQcd4SvPP/a6JfUqBh6
         OYCONVxsRMJYirRRXwWpTl121A9hQFCEDoLz0IdMB+yqhzKA1rEbYTMXvqmhF3yUr2GF
         cVd4kFEnnURSQ4uwRwXsn5gOIIG6xlzp4zQIZclluhPoa0AVqa+m7vImCBY+vln1WpV9
         TnjqkDriCquEPDGkIcN7GXXEDyCLlRJmSPk3lmfkjAe+dA8mQyc9MsG6c5bwU6YTthHi
         pe+XVND6AnvV8Nk/uiJPbtXo4/s0Ehh7NVED4ea3RAvVIiWPZp4lXXhLXZ8jZ/z07kdN
         B5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dIBW/AmxWldr1Ome03Y/fPYuT0zzFX/DeE/FlPmJGCs=;
        b=QL9ln4/PYJogBiMuQ0V2tfnYYTAqpVLZ+L++VATUkImRL4q44fnloqdEYDS3k46iwl
         yusUXw3EJV9/lz08WmQYwVAKvbqu6conDI2CWTF0+EZaDFqP3LqxpQZi6kPZC9/vVEgi
         bBGRzeYjo7Yf+lY+KLbR4rNb7NmXqw+k3Izrri+o1mojILRWKw3upZNeby55QzAjU1rA
         gESCRmMhjhIKGV5uf9jpd+Mrk2a4WAQRFKeHlcTLUed8i9bDvO+KeTs6nN3AGhmVXsqe
         82+Emq31iKHzw+Zdvdaf3SxXy/CrnOsVR2MbjlC7MPYrRZ7JVHzFhXMgnFYif035BVY7
         caNw==
X-Gm-Message-State: AOAM53074OyXlC4XSGxFZDBfR6M0CqFReYLmiskgQvpwVXBo4pJAv++I
        xsH5sX24SRArRmCFsDavmlc=
X-Google-Smtp-Source: ABdhPJzrtC0poJpXT4gCDsVRmVZe2Vo28UXS3E43yuvt6CFy+RWwqsISp5xj7qn6iI29VzToI9x1uA==
X-Received: by 2002:a05:6830:3112:b0:5cd:b92b:22ea with SMTP id b18-20020a056830311200b005cdb92b22eamr1044663ots.262.1648558853526;
        Tue, 29 Mar 2022 06:00:53 -0700 (PDT)
Received: from t14s.localdomain ([168.194.163.53])
        by smtp.gmail.com with ESMTPSA id l12-20020a056870d3cc00b000ddeb925982sm7953573oag.38.2022.03.29.06.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 06:00:52 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id A892E1D58C6; Tue, 29 Mar 2022 10:00:50 -0300 (-03)
Date:   Tue, 29 Mar 2022 10:00:50 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] sctp: count singleton chunks in assoc user stats
Message-ID: <20220329130050.vwo5zcbgr7z2qpg5@t14s.localdomain>
References: <3369a5f0a632571d7439377175051039db29f91d.1648522807.git.jamie.bainbridge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3369a5f0a632571d7439377175051039db29f91d.1648522807.git.jamie.bainbridge@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 01:13:36PM +1000, Jamie Bainbridge wrote:
> singleton chunks (INIT, and less importantly SHUTDOWN and SHUTDOWN-
> COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
> counter available to the assoc owner.
> 
> INIT (and the SHUTDOWN chunks) are control chunks so they should be
> counted as such.
> 
> Add counting of singleton chunks so they are properly accounted for.
> 
> Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
> ---
>  net/sctp/outqueue.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index a18609f608fb786b2532a4febbd72a9737ab906c..e2d7c955f07c80da17c7525159aaf8a053432ae3 100644
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

Please also fix it for pmtu probes a bit below. They are heartbeats
being handled specially as singletons as well.

  Marcelo
