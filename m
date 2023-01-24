Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE1667A274
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 20:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233955AbjAXTPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 14:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjAXTPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 14:15:35 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BFE4B76F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 11:15:35 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id j5so2410033pjn.5
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 11:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4qsy3LEiupKxYI9DxJf68i2S5/rawXXYVYdql9/4JsU=;
        b=VtZBaVR6SCQcbu1WErwfawsXJwKXPwXlwKDavzjsYlCpmqw3BQYM2Z+l+uGMsYsa7X
         1gtKGzjcxlt455SXmddqrbCKT0DKuMlsVXQAEfkfmTS8MdaEJeJyxW9ZPdpYpiWIzN6c
         uDa4Kn2mCnQFGxxhovaKJtdpnf2dIy1+bgsz9gpO0U57Zc02bafIi8RYHiRmqH+wGqyR
         0Ziz0iiGjDrmgWlmxl+aYkvECnJAB/vbV+0Pa34zlPqHwgTcjliNKl7+fc8G13jRPCSn
         Y6ip1Cqkt0XsjBnfhsROM0E3Ux9x+hA3i23TpDn3dniVepW7ibyRXYclgIkcIvxLZHV5
         s7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qsy3LEiupKxYI9DxJf68i2S5/rawXXYVYdql9/4JsU=;
        b=volI6ZK5Hv3ehvzvzCOSqdZWyUZTxerifUWccSr9PqbDZWVhIMVPtqnhwdj2MhcpQP
         ni68e8Is60GHOTmhlfK9ffINod2SpBGi+xf9ShnMlaRBNxnS2HcWMfuxWr6VJDJmjCSl
         W2XuwECpSO4fkFSgY+zU4/LVVjakLfxDjGEjslFBVoPMBgmvCqO22f+xkJznRBSKuenu
         nVwOyfdDObMqCD/rVboTYO3aJBOgzG9TMOf7YN3YkPcR15fQUTCI+geZ5x6y/c6XQK3p
         xgPbTyJuIYueptKWBmKfw3VqPrIklaGzEJ+rE5Dr0EhtihrufIAeBP1rZp7xbVqaU4Ti
         Dk2g==
X-Gm-Message-State: AFqh2koeiE3NGB2m3PrjXZvpej7tZrQE07+3icYEbtmQX6RSuGIgGXgv
        RjwN7sYXv4DtsCole1NFYHM=
X-Google-Smtp-Source: AMrXdXsdM/jAA9YukclTJcyG2GhfsOG79GzGm5D1hj1AnW/hYQV7Li8zM6hxzfmyNW0BVjk4nk9WMg==
X-Received: by 2002:a05:6a20:4d91:b0:b9:7a34:a78d with SMTP id gj17-20020a056a204d9100b000b97a34a78dmr16090360pzb.9.1674587734755;
        Tue, 24 Jan 2023 11:15:34 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 203-20020a6215d4000000b0058d9e7bed75sm1963591pfv.60.2023.01.24.11.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 11:15:34 -0800 (PST)
Date:   Tue, 24 Jan 2023 11:15:31 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Bar Shapira <bar.shapira.work@gmail.com>
Cc:     Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Message-ID: <Y9AuU4zSQ0++RV7z@hoboy.vegasvil.org>
References: <87r0vpcch0.fsf@nvidia.com>
 <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
 <20230120160609.19160723@kernel.org>
 <87ilgyw9ya.fsf@nvidia.com>
 <Y83vgvTBnCYCzp49@hoboy.vegasvil.org>
 <878rhuj78u.fsf@nvidia.com>
 <Y8336MEkd6R/XU7x@hoboy.vegasvil.org>
 <87y1pt6qgc.fsf@nvidia.com>
 <Y88L6EPtgvW4tSA+@hoboy.vegasvil.org>
 <8fceff1b-180d-b089-8259-cd4caf46e7d2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fceff1b-180d-b089-8259-cd4caf46e7d2@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 12:33:05PM +0200, Bar Shapira wrote:
> I guess this expectation should be part of the documentation too, right? Are
> there more expectations when calling adjphase?

I'll gladly ack improvements to the documentation. I myself won't
spend time on that, because it will only get ignored, even when it is
super clear.  Like ptp_clock_register(), for example.

> In previous responses on the mailing list it said that adjphase should not
> cause the time to 'jump' - is it also correct?

correct.
 
> It seems that "Feeds the given phase offset into the hardware clock's servo"
> is still missing some information.
> Can you help clarify the expected result after calling adjphase from SW?

If you don't have a servo implemented in hardware, then don't
implement .adjphase in your device driver.

Thanks,
Richard
