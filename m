Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876E450EEF3
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 04:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242755AbiDZC5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 22:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242591AbiDZC47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 22:56:59 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E30B11F637
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 19:53:53 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id i24so16644248pfa.7
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 19:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jIbGFRSUbUA+CjeG4fqZwwNEhl6pgUgn3w4NFyc7sDA=;
        b=Kb/vbAvQV0XCQ/RqCLCDsLVD5hAZCerQC5SXN6nzNNT4ghaFokGa1HqHW7nHFwgW1Y
         jvkVG4GJfut7U3v0ZBnCQboB2ShdPUoON5EI7s74ri9EMzeFnZEnEvRrliuUj6iofJeY
         vCiabRssu08eGNvU0wneJcns6a5NlLAXfXnZuczCrRtb69HGBpOvGATxrPgyA45lwrbB
         qhaAvocRl/GXpHS2qbfr8pNTtzaQPu2r30mYJr2M0zQP1GS+uAzCALdZDvYK/Qb6lhgL
         FSLoGn0FDO0ivh986xwtxJJZ7js8Lkvu1ksdHjoIMRD0duBPZ01ws9BzBZuj7kbVzN6p
         JyYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jIbGFRSUbUA+CjeG4fqZwwNEhl6pgUgn3w4NFyc7sDA=;
        b=0+AIvhBwKVCFcMDtvbbZexSO6pgnN6hn5xcmyzufjrHRY9wL4IyDDfuyyf5ZL3EsrY
         A4fh9oGRsoNwkN533qBqUwaj/Yiil0GRExs5WkIhWRIgnTXxORGCm4QvIKrNQEZHmmCh
         uHqg9C+hGHwoKrPKeoduItOHbQ50sl34S+s45OGiNEJl8IzTY1FYKempTsrEbscMaa5f
         2k4d06xr6pVCtwzxc/E5mQ/veG2uiV+bA20cdjT3TrFGsqYzOlweK0RVXbM9a0qR7GWg
         h0Vxl/FCMGgTlRa/MIB8fDzZ08q2un2ACQQSo1WHLxPPUiSMUtjax2YNTamkjato2niK
         AP5Q==
X-Gm-Message-State: AOAM532vUKvkwhv4WgX7cynifHlD6zOapzQjU7MpOcaFkQ8dctqbkBU/
        MSC7Xco3eYRzuNRQ8Cr6aiE=
X-Google-Smtp-Source: ABdhPJwXeCOzV87wjU+vztuwq95L1uSNxMDbiPVX5WPVxwRoXdNlHdP4UW0pQTgTV9QLUdLnfZeonw==
X-Received: by 2002:a05:6a00:1a01:b0:505:b3e5:b5fc with SMTP id g1-20020a056a001a0100b00505b3e5b5fcmr22049101pfv.53.1650941632775;
        Mon, 25 Apr 2022 19:53:52 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id f14-20020a63380e000000b0038253c4d5casm11042500pga.36.2022.04.25.19.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 19:53:52 -0700 (PDT)
Date:   Mon, 25 Apr 2022 19:53:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 1/4] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220426025349.GB22745@hoboy.vegasvil.org>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-2-jonathan.lemon@gmail.com>
 <20220425013800.GC4472@hoboy.vegasvil.org>
 <20220425235540.vuacu26xb6bzpxob@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425235540.vuacu26xb6bzpxob@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 04:55:40PM -0700, Jonathan Lemon wrote:

> We could just have a chip-specific version of this function.  The
> recovered timestamp is passed back in a structure, so the rest of the
> code would be unchanged.

Yeah, but it means that I'll have to check each and every bit of every
register to see what other random changes are there...

> Jonathan    (no, not volunteering to do this...)

For now, just get your chip merged, and then the next chip's driver
will refactor/reuse as needed.

Thanks,
Richard
