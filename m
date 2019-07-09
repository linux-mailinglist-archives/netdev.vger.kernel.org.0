Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A513638A0
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfGIPam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:30:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55625 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGIPal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:30:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so3532749wmj.5
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 08:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FTDOnG+xpjCin6m4Dx6F3SB0KURvbWLQOSOIvgPQmT0=;
        b=cKyFFnDoTbqjgyaJ5QVc98T8xdw6hNYc7DbrbTmW10UMfOR0kUi/Cr9EHwCsZYko4s
         kuQCiolenpHoDq3pwC4k8cwMapbl3uoLBtxd6lOii5+YFy1gHljvmR1i5o9A9UXHgX2n
         wcq2Hag5GnVfp7a76Xt6EyYYBpBecq/y0967Qq5uyEg1mgEB4dq8zUZWdc+YmBQZykhm
         YHy3Yx+D7A/oUIVq7sGUkOniw91EsAVcZiS30Mqkx446nXEG1rMAYxYJS5/UfLPKo1jV
         mWaoOrM9E2KouIToBFjTFLO81vjAUNFIB/rSp8LhbRKYuPPvkLVg48GMsRmXFIV+3fAm
         sXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FTDOnG+xpjCin6m4Dx6F3SB0KURvbWLQOSOIvgPQmT0=;
        b=acWr9CEaIsCjtW4mo9lsiuiWC8crE4l/KemYfon6Sfj+hRjWERCwPv57MZjnlE9D+C
         QJSOkmxKHvhfeNZhkf1aIrxUqLUF1i4P9Er07K8yA/oOg5OXMndx4/Vxrh4ivWB3uurj
         el9kEocQPCawFD19R4xLh2OF2m5lKQLVttQ1xpztXXJ0GADq+oUXELIgSfwcCSlU3dek
         fWsR7Y+OiFLKzs3aRK5zqVoq2tnR8G5cf0mf0G6/TXeBdyHaHNdpxgNAwXuvugTr+Oto
         2mPp9zn+oMRCPRAqR2GCiv3IbFRb6GlrmjuEnCOE5nAWSePZMBaEhXuI5QzytaSG2lFm
         UC6Q==
X-Gm-Message-State: APjAAAXOqWmUkFvF6P1aiHUcAUGMTn2Eva0k5wpY9sSZbfzaUd6w8HWu
        O8SRbj5I8ha4ZQRAJdKIlvM=
X-Google-Smtp-Source: APXvYqzRSMO/n+POAyza1rlGQ7aP54A7HV2RJGD2Ly3GvQkr9hq3xuua7lvY1xNWesSztz1Ip10JiQ==
X-Received: by 2002:a1c:3883:: with SMTP id f125mr520144wma.18.1562686239786;
        Tue, 09 Jul 2019 08:30:39 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g17sm15549554wrm.7.2019.07.09.08.30.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:30:39 -0700 (PDT)
Date:   Tue, 9 Jul 2019 17:30:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 13/16] net/mlx5e: Recover from CQE error on ICOSQ
Message-ID: <20190709153038.GF2301@nanopsycho.orion>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-14-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-14-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:53:05PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Add support for recovery from error on completion on ICOSQ. Deactivate
>RQ and flush, then deactivate ICOSQ. Set the queue back to ready state
>(firmware) and reset the ICOSQ and the RQ (software resources). Finally,
>activate the ICOSQ and the RQ.
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
