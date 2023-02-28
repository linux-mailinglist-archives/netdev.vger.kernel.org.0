Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753CE6A5503
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 10:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjB1JBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 04:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjB1JBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 04:01:45 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823D37EEE
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 01:01:44 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id bv17so8899597wrb.5
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 01:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qa2qIogxZuvuxhxmdqENuhd54Z/fQnHO8EzOrXEVeLg=;
        b=LU9MwyVVkV4bY5v9m+XGtruGo/11ZjeH8oom9NluA+kaj+evJ2seNgdq5MrO6Af6Pf
         VSoy1ybsF3XTVXYlVaFgddgEvkSzAX01JhUPjAqIWy9YzETyv6c1hkI2j5AQxx1sLzfq
         A6JK+yqmOEb6ldOOiT8U0P6tx+5obXkT9YzIrd9SuJUhclsCSBao75aY+C/W56YQEGB5
         9msLvKUxhcQ9i/rsUxdivPo1oLDoLQ500RTKy/o348wg0SbzCpb9EMSOOKIxTmNIvOzE
         PZNo8CnmACKbePJUlAQpLJqysXI0QID7jKALN7YgGyVnUPFM6Vfr1I+4Yv73SvjaxssB
         M2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qa2qIogxZuvuxhxmdqENuhd54Z/fQnHO8EzOrXEVeLg=;
        b=qvxRmjYIHHJIhHSK2G0v8gEuWAw8B45jHLNQHlyBffs20k8AydVnXF8SLzJd9oj2ud
         ZSs019IjvWhIeBVnkDaG/BIJpZqAx5rhZX9IypOKVo4yPkeWuHMPe+rEBLQiNSgEBMf0
         GZ3TtprjYJ2vsJacdbVI026oZyEnpYr360bl5I9INOtbfOHr6qfFkEGuanspSmYnMKR8
         is85gR7UzOgU89x8/tko2GyxLWAQs1AqM5N8SxCxyDgvrO3p+jBWNyw3eZEiXMcgYIOg
         rxFOIGLSMAXbfAuTQw2SIxw1/+nsMaZLIdoIdlO4CiLcoWmZXQIu6bwgLB/Cgjsyddky
         5aww==
X-Gm-Message-State: AO0yUKW1QUFP1DuqpOo1NQT3sK1QuR5yzxa5N6CUBpAmAEg8UUCpaGtH
        Q8D9yOGcSV95p1y+gLiSjIQ=
X-Google-Smtp-Source: AK7set8ku7S1O8Yn0UrbmDhd/Een1oneXLldJRI3CEZeAXQO95dBjd5sg2nIkuWYBw82LKw4EnKnYA==
X-Received: by 2002:a5d:6187:0:b0:2ca:e8c2:6d25 with SMTP id j7-20020a5d6187000000b002cae8c26d25mr1697398wru.60.1677574902887;
        Tue, 28 Feb 2023 01:01:42 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id x6-20020adff646000000b002c56046a3b5sm9004990wrp.53.2023.02.28.01.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 01:01:42 -0800 (PST)
Date:   Tue, 28 Feb 2023 09:01:40 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Simon Horman <simon.horman@corigine.com>, edward.cree@amd.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com, leon@kernel.org
Subject: Re: [RFC PATCH v2 net-next] sfc: support offloading TC VLAN push/pop
 actions to the MAE
Message-ID: <Y/3C9Lsjx03qxRXo@gmail.com>
Mail-Followup-To: Edward Cree <ecree.xilinx@gmail.com>,
        Simon Horman <simon.horman@corigine.com>, edward.cree@amd.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com, leon@kernel.org
References: <20230223235026.26066-1-edward.cree@amd.com>
 <Y/iMTcvQZ3uW8bgP@corigine.com>
 <a35e32a0-0520-ce60-5296-39f36b278b5a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a35e32a0-0520-ce60-5296-39f36b278b5a@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 09:33:49PM +0000, Edward Cree wrote:
> On 24/02/2023 10:07, Simon Horman wrote:
> > On Thu, Feb 23, 2023 at 11:50:26PM +0000, edward.cree@amd.com wrote:
> >> +				NL_SET_ERR_MSG_MOD(extack, "More than two VLAN pops, or action order violated");
> > 
> > nit: I'm not sure if there is anything to be done about it,
> >      but checkpatch complains about ling lines here...
> 
> Yeah I don't think these can be helped.  Breaking up the
>  containing function (to reduce indent depth) would be
>  rather synthetic imho, most of it wouldn't even be able
>  to be shared with the decap and conntrack versions when
>  those get added.)

You can put the string on it's own line, i.e. align it under
extack. I think that will pacify checkpatch.

Martin

> 
> >> +			}
> >> +			tci = fa->vlan.vid & 0x0fff;
> >> +			tci |= fa->vlan.prio << 13;
> > 
> > nit: Maybe VLAN_PRIO_SHIFT and VLAN_VID_MASK can be used here.
> 
> Yep good suggestion, incorporated for v3.
> Thanks for the review.
> 
> -ed
