Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0C763899B
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiKYMWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKYMWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:22:43 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992AC1DDC2;
        Fri, 25 Nov 2022 04:22:42 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-12c8312131fso4966651fac.4;
        Fri, 25 Nov 2022 04:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ceZTx1M8soZE/qoR5gLXxJDp9J9HvM0NblTOfBxXJiE=;
        b=bDpSHoe17/IH+4+zBvk2+vJR033y2oY8FCYTNZxBZItoGmI+fnvkiWcub8VWZfKA3W
         XCK5B4AvHf4tNXLpN0fQJq0gpnz03kBUpdq3hND+F5WQIFBzFB2kw9TCfCYdzYsizxBs
         0HI+3Fygx5zJA5ajwM7gOOWT33pfRHnqr7R9LgW4i4PHreaEjTAtuYbKGLPMcIuFAc3K
         VVnQAtqz+LeLPwOtVNMxfuegpDwXQjfrliMkLHAszDD9t1h8Y4eikkn52o770J/y5OWR
         baNCBkgihr2qCj/WZEvWmqJOMjTcZiuIjbPETJNTpPYnanOBeaxbw6AT258NudOpIiR/
         yQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ceZTx1M8soZE/qoR5gLXxJDp9J9HvM0NblTOfBxXJiE=;
        b=RCX9Rimxd/mywQWwX83R+1zNnV4tRXWohATmpxPeSzde8fu6MvA9Ow13LI1Z81vL+6
         d7hEU1bLu2ol12ZOcxe2ly7FDM7gZeOB1x3ML8JMhFFtpNJ538t5JaCGOVzfyAfSJYDP
         kpvxNjKDVDxgrH1i/ExmOYR2yLJbLSUtTBhfFBaY6smWCZZgkREVkYheU59ok1OxVJFC
         2QMuEPZIcAXMEL6/cjH/PNI+0ccE8+Mo8VOGody65+PzzOliY3uzuUy+TqmnAyGJbX7S
         S0LKb39NdAid7dt6voCqaM4gQCc2Rz7G1su/FGzkNE3pSrerBKXyKgxQGqkuf4scWrDk
         s+iQ==
X-Gm-Message-State: ANoB5pnODbjRshz2ttU7btuShun9S8x7GmBxNv0olWbXa0SEB8xjOeSf
        utcNiwPbr4NBMR4kJLdwXO8=
X-Google-Smtp-Source: AA0mqf5xiWxUwAEnJZuO/3rupSaPLLYPygtSJ3RZXZTDdIUZenogQlK8XYQPFgaBsbPtXpLRRYwPOQ==
X-Received: by 2002:a05:6870:3b0d:b0:142:d063:11f5 with SMTP id gh13-20020a0568703b0d00b00142d06311f5mr11539655oab.143.1669378961702;
        Fri, 25 Nov 2022 04:22:41 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:8471:4ef9:baca:5f1a:c3fc])
        by smtp.gmail.com with ESMTPSA id cy26-20020a056870b69a00b0012779ba00fesm1992525oab.2.2022.11.25.04.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 04:22:40 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id CEB81467A99; Fri, 25 Nov 2022 09:22:38 -0300 (-03)
Date:   Fri, 25 Nov 2022 09:22:38 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Firo Yang <firo.yang@suse.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, mkubecek@suse.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com
Subject: Re: [PATCH v2 1/1] sctp: sysctl: make extra pointers netns aware
Message-ID: <Y4CzjgncdsrEe8tg@t14s.localdomain>
References: <20221125121127.40815-1-firo.yang@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125121127.40815-1-firo.yang@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 08:11:27PM +0800, Firo Yang wrote:
> Recently, a customer reported that from their container whose
> net namespace is different to the host's init_net, they can't set
> the container's net.sctp.rto_max to any value smaller than
> init_net.sctp.rto_min.
> 
> For instance,
> Host:
> sudo sysctl net.sctp.rto_min
> net.sctp.rto_min = 1000
> 
> Container:
> echo 100 > /mnt/proc-net/sctp/rto_min
> echo 400 > /mnt/proc-net/sctp/rto_max
> echo: write error: Invalid argument
> 
> This is caused by the check made from this'commit 4f3fdf3bc59c
> ("sctp: add check rto_min and rto_max in sysctl")'
> When validating the input value, it's always referring the boundary
> value set for the init_net namespace.
> 
> Having container's rto_max smaller than host's init_net.sctp.rto_min
> does make sense. Consider that the rto between two containers on the
> same host is very likely smaller than it for two hosts.
> 
> So to fix this problem, as suggested by Marcelo, this patch makes the
> extra pointers of rto_min, rto_max, pf_retrans, and ps_retrans point
> to the corresponding variables from the newly created net namespace while
> the new net namespace is being registered in sctp_sysctl_net_register.
> 
> Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Firo Yang <firo.yang@suse.com>

and
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks Firo.

