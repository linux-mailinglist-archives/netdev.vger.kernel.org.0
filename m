Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D10563174
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbiGAKeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbiGAKeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:34:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3296F6F34C
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 03:34:16 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id o9so2354713edt.12
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 03:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LTohJWI+b8uDyJSppZCdNGCHlPoufieuCJSkNbR6M3g=;
        b=m0tqTjW6xsrQk71fMcGeQH/PgiU+w9Vg5HbK6Y4kE53PkoPW/4W/2A3gER/xE0AX8L
         0WZWn5x3vxKLYy/GsbIkp/5mKIM5LZm6H8YhcpQBBatO8+MCgkFWnbhniqnE+C+OLNl0
         tsGyb0dO5JT0qcoxQsnz47ZIEkJO1dHXArG1HStFTKW0XShMBREE2qC+wL/jXgoZkDl5
         269dhwIf8ZIRzaKVOwnKGUpdKDWUtoVB8DFkxShg2q5pN777ILO5vAkEqSEpW0u3CKhf
         9yLlxnhr3iP/g1l4LIvckbzvxU8B3kxKrAUiKIumCcp2/XRovfcTyotmeY68dFqfvz08
         oQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LTohJWI+b8uDyJSppZCdNGCHlPoufieuCJSkNbR6M3g=;
        b=vnksOXd8lHK6rvtVeJGlei3n8y3GlNGnPX9Uj+jfTOEVO3DJWhqU+OY4ROQ7CrDF15
         pjj6VUWIM4cCTknj34kj5ZsUSTwhFVo1G4dlsRXdhRPHgiOKla+j+/Ui7vdZgkyLVVxk
         Y+Lmnl2H7IG9T9rnhVZ/0FXOoHPVheW7NAOYYqL35zeVC4w9F9Qbtk4FjBd5hiJPvV7U
         i2xBzDu98XyUaOxjlm3NHbzNalJDzlkb00na8rdNEWktk+WidyLCeb7g97fTFbzivUKM
         pfaqZ0YO3D1DawinmSz8d48kv1YkivlkK37v4XVVFhyB8mOSTeKWCzKEhP4+IOFFRkf/
         +jZw==
X-Gm-Message-State: AJIora/gajB0TEl4V+yS7qmthMdvcr2lE1qfGsF5nzGhYxjzjTigIHS9
        4Ra4E2ezeOv1gmk9Q3IGMHyiqQ==
X-Google-Smtp-Source: AGRyM1t/5VvDyJJnN5HFs+lSVyqDnFeZMTZZv0M8lYnxTn/Ixsw4Eszejdm6f9bzNPs3VHctCmB5sA==
X-Received: by 2002:a05:6402:e9f:b0:435:644e:4a7d with SMTP id h31-20020a0564020e9f00b00435644e4a7dmr17926951eda.114.1656671654787;
        Fri, 01 Jul 2022 03:34:14 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id cb25-20020a0564020b7900b004359dafe822sm14754408edb.29.2022.07.01.03.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 03:34:14 -0700 (PDT)
Date:   Fri, 1 Jul 2022 12:34:13 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, jdmason@kudzu.us,
        vburru@marvell.com, jiawenwu@trustnetic.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] eth: remove neterion/vxge
Message-ID: <Yr7NpQz6/esZAiZv@nanopsycho>
References: <20220701044234.706229-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701044234.706229-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 01, 2022 at 06:42:34AM CEST, kuba@kernel.org wrote:
>The last meaningful change to this driver was made by Jon in 2011.
>As much as we'd like to believe that this is because the code is
>perfect the chances are nobody is using this hardware.

Hmm, I can understand what for driver for HW that is no longer
developed, the driver changes might be very minimal. The fact that the
code does not change for years does not mean that there are users of
this NIC which this patch would break :/

Isn't there some obsoletion scheme globally applied to kernel device
support? I would expect something like that.
