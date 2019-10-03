Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F710CB225
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 01:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730985AbfJCXHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 19:07:46 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:37490 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfJCXHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 19:07:46 -0400
Received: by mail-qt1-f169.google.com with SMTP id l3so6068436qtr.4
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 16:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=npCoL9CKSY7aGk4mFZZl6Ggm0fR45nWSDA/yzULX3Q0=;
        b=qO2BIZks8esl/AHkBr/xf1sM0kn3Uu+xvCZGNqwo2zNh62vrKleVQh4ER10SiJuROo
         13y/1Zq2WvQDaScH5Q4+TxBiguVcEjvqzY0W4vR3g/o4QMfkMe+6UcwwZ3jWTegM9BPB
         OpFgLSud0UxEogSuup5A/9rofe0i8RljU+YJDZyh8ncnhZvd+Sh1HRfa8kZ7EyrU+ney
         RNJ/Rf3tmFxIDBoiv6awWYZ2BbZbFqlLNgiI9sv8j14UWZXKyRt0F+N6UYypE0WNaG3n
         VjNLwELsRHGBdun6tZZ+hNLw2sOhzhB1DOn1nvSaFR2W6C/pUKxANr4A9BeMfCJ4uD6s
         ynGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=npCoL9CKSY7aGk4mFZZl6Ggm0fR45nWSDA/yzULX3Q0=;
        b=n+7l1tbpMogIu5Cx2kvR811G1j88hD5/yciquxS8/pJcP7Lu20FUZ9w9zr4/IGMxGG
         JNDXP+UvpXxXblR4nsLBlQ65jmCQAVVqGh5Gnv/cdZuTCNFySyj0u158RnzNaywsaI+p
         IoSL1SaIVgJtIyymj6DS8B1F5JTJgFUHDuaSBHPUCURpFY1yV0EpoS01OWTSYbWpG1vY
         fMkDmLDIjo9G75NrQMdZB91xAtLpLWYIJyT7GgrtB27IOMQRYgxaUjSfFDhwZkRuNNI9
         CYQgLHjO1SSHtzIZi52DZPUqAfCySqd53O5FAHh05GCchFie2++5iJkMMmiA+KjFn3ju
         c8AA==
X-Gm-Message-State: APjAAAWh6zeAh/gLOw46FCwXaSftEzF7zIqGvEFW9ew7Wb8BXRjucs55
        7iaGcr8J9UfkgpWE1ES/EvoP2w==
X-Google-Smtp-Source: APXvYqwxgMyKMmqxWZ4FOtHOlK5p4RK5hFrvli8Zn291RIkqWCwMrfpCAETaZtzisbpHeIaGeOJL8w==
X-Received: by 2002:ac8:3f11:: with SMTP id c17mr12277496qtk.98.1570144065751;
        Thu, 03 Oct 2019 16:07:45 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d45sm2332281qtc.70.2019.10.03.16.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 16:07:45 -0700 (PDT)
Date:   Thu, 3 Oct 2019 16:07:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 10/15] netdevsim: add all ports in
 nsim_dev_create() and del them in destroy()
Message-ID: <20191003160739.14e043f7@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191003094940.9797-11-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
        <20191003094940.9797-11-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Oct 2019 11:49:35 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently the probe/remove function does this separately. Put the
> addition an deletion of ports into nsim_dev_create() and
> nsim_dev_destroy().
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
