Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448CF4C1D3E
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 21:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241379AbiBWUiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 15:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbiBWUiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 15:38:00 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B862147AD9
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 12:37:32 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 12so17666074pgd.0
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 12:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vytxi60ZgkqynyzIJNOXGnsmlScq9QVQp0td/1B9Teo=;
        b=RprWX9y+HamWJobWrFfcGllbqNswt6rsP15QOpcnEGhGeQiGLQSb56iqHTFSfdzx5o
         NyKIMwnIiwek5u7W5u8AXzYh9EMOiwg5maPHBb9bVBYHpzMgelO9eSaXhmL6JA5RzuXX
         ljAX07bz/tbI/Tb022eBUh3sk1MTMzxuJrfVOHWchCXQjboA/QRm7aKZbL0y5kcnkYbK
         S2yRcrMX0zgFHaLQFKekALxtAcY4tFRpIqWZTMGXXOqNcztvkINoVlO+UzVO/jf57aTI
         JYZJRUZ4uZqNrDUf8GtHNIALv5Bsb7DWY2TmJ8WSv9Qm2gL3sRzEvlSj4rG9jQeidjgD
         VF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vytxi60ZgkqynyzIJNOXGnsmlScq9QVQp0td/1B9Teo=;
        b=icPz3YgEj5KkQnv6XkrsYd5EWLkCLvMPcDrATeDtr7oni417ppnX4WUCi26/0iRtmu
         Gs8fHze6MCq4Cw1EfrTnzDdRyHh+5G/CA495r7E3hofTRiOFu3ePZ34p/FGcKJybmtZ6
         8h4DRFW2HK/J4vdz/cXD9nr2FXt3jzsYx4TLT6UUqB6Tssyyrrup35DkyeHtho0MEuW0
         dslv23D/u3DFbWjunfCtndr/ndIdCghiITUelaRMUOsFXDQJAU7oSex0PF84lpkRm/hs
         9Dbr+wzBeU/wB9xia4ZYJpdt/F7LDQrG/DU8lGsknzTiFlLFfGWCsCz7++U2fYbqsjyW
         lw2w==
X-Gm-Message-State: AOAM530Tv9KFwp63J9fXdj+C14boZl4gVwEywAEo/Pm9KKZp5LjMRAKZ
        YZXllj8Bob96uqb4ayyP5diY5BZ6/i8=
X-Google-Smtp-Source: ABdhPJzTgcQAuF50BfbfEDeUqxZqV7lgavFg6NOej7pQE/XIiwlB2OsFZrS0GpALPl3nIlL+RLzgxg==
X-Received: by 2002:a62:7554:0:b0:4e1:5898:4fbb with SMTP id q81-20020a627554000000b004e158984fbbmr1333356pfc.2.1645648652101;
        Wed, 23 Feb 2022 12:37:32 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k18sm414547pfi.10.2022.02.23.12.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 12:37:31 -0800 (PST)
Date:   Wed, 23 Feb 2022 12:37:29 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>,
        "Mishra, Sudhansu Sekhar" <sudhansu.mishra@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] ice: add TTY for GNSS module for E810T
 device
Message-ID: <20220223203729.GA22419@hoboy.vegasvil.org>
References: <20220214231536.1603051-1-anthony.l.nguyen@intel.com>
 <20220215001807.GA16337@hoboy.vegasvil.org>
 <4242cef091c867f93164b88c6c9613e982711abc.camel@intel.com>
 <19a3969bec1921a5fde175299ebc9dd41bef2e83.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19a3969bec1921a5fde175299ebc9dd41bef2e83.camel@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 07:20:43PM +0000, Nguyen, Anthony L wrote:

> I haven't heard anything back. Are we ok with this convention? Just to
> add this usage is fairly standard for our driver structures especially
> in this ice_adminq.h file.

I would put the #defines just above the struct, but maybe that is more
of a personal preference of mine.  I don't think there is a tree wide
CodingStyle rule about this.

Thanks,
Richard
