Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F238A6F47CF
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbjEBP4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbjEBP4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:56:05 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6ECE5D;
        Tue,  2 May 2023 08:56:04 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6a5f765d5b8so3208042a34.3;
        Tue, 02 May 2023 08:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683042963; x=1685634963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FZ8UF4xE/DaHOcF0ev0zcaqdMoP1UVA3oOmGLCfAh+U=;
        b=gM5gZ3PL1Q6G80SCPdDtglRjNIoneEo2bXgPOWnyugCqi7bLlIrb+rKgLMFESwm1sa
         //2RwsPHcXPqH/jlW6oOauZTOW5gtXLyHE+QbFYqDT/rrS1w6Xru5QDOziCXdhFJBLT6
         6uSg8gk90NvBU261yyncrKA+ZmuE3XDbogZ37gHwQuE+0+QVe0jrGbzaYNIN+QcZggIg
         B5AmUic6/b1Y/PrcPwrYLb6sn+6luVDy54WrEMPku012JabFTptuilglAUhDecNlCNDw
         PFG29AG8h1lBSZdcRdvdyakc0GcsaXa8d3u39fUlUMJHzIMuVT1IGD/qj2CGFwAfylPZ
         ZGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683042963; x=1685634963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZ8UF4xE/DaHOcF0ev0zcaqdMoP1UVA3oOmGLCfAh+U=;
        b=OuvVlIKPULarhdSbKLsSx/TfCn7pS5ofRzKlDeRiKyK4tFbMfZUm5KgbGpE+mZXSeR
         RBzbolvi3gJMNDv+IhJWpr3BTU19HsbFFmAvrMXIng4BDTSMs4eI7ttLgBTMhURJgm7h
         UhssXuohmH8qVq2sQjDNlmezwzGqbuzd/wwIhX1Jd5JTXtiwHhqYQaFRkYo2EKEY30m9
         MGCjBAfm/qKyUS4YVVPTFoFLbVhqaN4bCCYfJC+BjTKt3Js5Ll1Sn9Z4VV68jcFW8Myy
         f++yYjxK8goLvBFlU7YufxPuVtACkOQpDsAl023bbKNzC7ruQBQyEdrs/JTxjfany1J7
         mX+A==
X-Gm-Message-State: AC+VfDwmMeyf16Xl7m6xwHnRa0+6HV05ZUqr5sjiNNUBZ/6vysJOWFyR
        rXccBNkjwCLzJ0ar+iss6XPwCPfWVrC1aAXL
X-Google-Smtp-Source: ACHHUZ7qHamEw4YRfovFtmmb6ZiKfmilYeAQpxUR/KyMkZgMRZ5+WnzsSrqXx5HYKiMCHcSiRGtxYQ==
X-Received: by 2002:a9d:7ac9:0:b0:6a5:e895:1bd3 with SMTP id m9-20020a9d7ac9000000b006a5e8951bd3mr10304285otn.31.1683042963494;
        Tue, 02 May 2023 08:56:03 -0700 (PDT)
Received: from t14s.localdomain ([177.92.48.92])
        by smtp.gmail.com with ESMTPSA id r24-20020a056830121800b006a647f65d03sm10994423otp.41.2023.05.02.08.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:56:02 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id A936359EDE4; Tue,  2 May 2023 12:56:00 -0300 (-03)
Date:   Tue, 2 May 2023 12:56:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH net v2] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Message-ID: <ZFEykMcPb+82PNP7@t14s.localdomain>
References: <ZFD6UgOFeUCbbIOC@corigine.com>
 <20230502130316.2680585-1-Ilia.Gavrilov@infotecs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502130316.2680585-1-Ilia.Gavrilov@infotecs.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 01:03:24PM +0000, Gavrilov Ilia wrote:
> The 'sched' index value must be checked before accessing an element
> of the 'sctp_sched_ops' array. Otherwise, it can lead to buffer overflow.

Buffer overflow? Or you mean, read beyond the buffer and possibly a
bad pointer dereference? Because the buffer itself is not written to.

> 
> Note that it's harmless since the 'sched' parameter is checked before
> calling 'sctp_sched_set_sched'.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> ---
> V2:
>  - Change the order of local variables 
>  - Specify the target tree in the subject
>  net/sctp/stream_sched.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
> index 330067002deb..4d076a9b8592 100644
> --- a/net/sctp/stream_sched.c
> +++ b/net/sctp/stream_sched.c
> @@ -146,18 +146,19 @@ static void sctp_sched_free_sched(struct sctp_stream *stream)
>  int sctp_sched_set_sched(struct sctp_association *asoc,
>  			 enum sctp_sched_type sched)
>  {
> -	struct sctp_sched_ops *n = sctp_sched_ops[sched];
>  	struct sctp_sched_ops *old = asoc->outqueue.sched;
>  	struct sctp_datamsg *msg = NULL;
> +	struct sctp_sched_ops *n;
>  	struct sctp_chunk *ch;
>  	int i, ret = 0;
>  
> -	if (old == n)
> -		return ret;
> -
>  	if (sched > SCTP_SS_MAX)
>  		return -EINVAL;
>  
> +	n = sctp_sched_ops[sched];
> +	if (old == n)
> +		return ret;
> +
>  	if (old)
>  		sctp_sched_free_sched(&asoc->stream);
>  
> -- 
> 2.30.2
