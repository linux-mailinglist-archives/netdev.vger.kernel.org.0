Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BCA3485C9
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 01:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhCYASS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 20:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbhCYASI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 20:18:08 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C0DC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 17:18:03 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id l3so182786pfc.7
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 17:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0QCV5hlsVgot5bsBDYEvWMvrz+fg61EzxqOUbF8ptSA=;
        b=jN/BDr6/RogYbps/S+zZXGdZAlVZSiVXAaDpVWVaDFX/QTYCy+n2gbmq99TeuTiGKs
         2Rbz/NlPfSptNvNYR9Jv0NxY93S69wFXJqCKejmRZCQdzkLoFME+Sg3N2OAAUW5vV4jA
         4+qnrG1j4AMkuCmj9Dismx1PaJ7IBpoABjeuR4K9LPS2V7DGLoTWnYjlUKvuGfG6FzhH
         urlvCWpw3CtCMG31EpCIwmO6Pt7w1+BTtJ8sC+G74XiRC4S6nNMAelDfMaxXF5PSXJcA
         etsS2VhNcQdYQX4Ts62ezAEhIUezV/Q6P9ql0v+OMxXYiy/R/Q1HXzeLT1/jSoQt2hWM
         WTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0QCV5hlsVgot5bsBDYEvWMvrz+fg61EzxqOUbF8ptSA=;
        b=fGnfP79+gNN7PWLIxfAcAsJJ+eLeEj/LzZIPuINSip4Bg/4F6EefePri9b95r/0cLR
         BXwyly7b2gKH6KEztPYPUpx5COxQUZm7OBQzfCIKYXxKkfZ2rNIOu9fmXFFR1coYLcAi
         7BmuUWR/bVCev6wCEhbQFtO8zFZ4dtbXxnYGMHqeoRhpMXRCI4QyHAPyQPFfYmD9JrsI
         O/LqYDhaSExdsW8gJJ7mGi0n/sRI3SmrJBNP5+2Yq3xBviu18SMWf9j/N5dNsZNOk0e9
         ghfobesBF2qgG2kCbVRJZ5hoBbvldgoezWSuBT9RYaNZ0EzpFiPZogqCk0rxeJeHeZEo
         6pBQ==
X-Gm-Message-State: AOAM53233xjkGtIJ9EtQwwx8Pz5lNkrKBpvbMbFKGSgTfYpo7tUsKB1+
        IbWN+vsZrcFIeGrNwhWlQkE=
X-Google-Smtp-Source: ABdhPJzvSAaKt9F2wgAum8bnas0Q9Eh5ouiNJJaBvRBIkLugZs5SOtiikPG+eip4nfQUk5cJgSFF1g==
X-Received: by 2002:a63:e214:: with SMTP id q20mr5166218pgh.4.1616631483364;
        Wed, 24 Mar 2021 17:18:03 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:48:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t16sm3626949pfc.204.2021.03.24.17.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 17:18:02 -0700 (PDT)
Date:   Wed, 24 Mar 2021 17:18:00 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64
 calcalation
Message-ID: <20210325001800.GB6432@hoboy.vegasvil.org>
References: <20210323080229.28283-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323080229.28283-1-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 04:02:29PM +0800, Yangbo Lu wrote:
> Current calculation for diff of TMR_ADD register value may have
> 64-bit overflow in this code line, when long type scaled_ppm is
> large.
> 
> adj *= scaled_ppm;
> 
> This patch is to resolve it by using mul_u64_u64_div_u64().
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
