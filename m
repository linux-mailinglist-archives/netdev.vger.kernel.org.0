Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464876AFCF
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 21:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388666AbfGPT20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 15:28:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46007 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbfGPT2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 15:28:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id r1so9570025pfq.12
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 12:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cguvYaDuZVKfbDrFa0dsYmil2ExJSUkiuuupQnmYSho=;
        b=TE+GoL1tfMbVxCN6QUJsYECmal3aj/tVITaAr5783mxdmu4iSNPENqa9X4lYrRk/rg
         o+U6AAf8dD8S0/D09G+FzQxj+f8nb1/HDyND967h8Q1ekNaJ+1EHzuHaAuvEHTKWUzBW
         iP6i1DNu75PF39Yi7Znlkmiv8SXU4ybcnZh3BxmF+UEckA73gJ9hbLxmSJbnXyBObnSO
         M960OrCT74nvcJ4cA4PZ6B1kc+pi7uiO5CAa9zgwrjU/dNvO8M4x0x54LTVQvFZj76s3
         ZXUmZ5XPHJ30VaNTdh1tLPQp65tRQ7NCAhQR29oz+5WbSozV8UGpFHlPf4fVwlEWtL6l
         pibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cguvYaDuZVKfbDrFa0dsYmil2ExJSUkiuuupQnmYSho=;
        b=NUyLV5c5Id0i/A9UzwbVU8hOcV58G9uchrM7cdTwz7FGY7FZRtfGdV/ZRPI5x1dCmI
         W8OLGyDH+qQXh1KlMnU2dLQHi8d4zS9aImwjw7MtHmvICZcrpZnOITs/BL+wNtQ9brSu
         cgfr0inn7PPxRSFu6Set72Mi6b0EDBoTFwbaNNaMqpB3xusmF6x84cZBL5BJx192R2DX
         XHWBBYUt5wIq1e1dSeU2yZwbMz20G05mRGiwE5xUvZP7t7X8q5M3rVSfI3UsXqukdQeM
         S6COfdcc76HRlNmoV/zSzkWRTJUS/KS6LCYjIQzUI1Wlk0FJiKsalYF5N9KeSzwAVomU
         rtPw==
X-Gm-Message-State: APjAAAVQVeplRdvXovfeu7wNQmFe2GV31S3yusvWExwXlo0PkZHos9K2
        ky8PrqH3wlQB5pPZPgADvhU=
X-Google-Smtp-Source: APXvYqyRT5SUt+0NR2StIh1SgpLPIo2GdO6V4Rb9pSRDETAW4xaDkEyg1CC279CbeMKe/o1ZVgpE1g==
X-Received: by 2002:a17:90a:cb12:: with SMTP id z18mr37151606pjt.82.1563305304676;
        Tue, 16 Jul 2019 12:28:24 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a6sm20200618pjs.31.2019.07.16.12.28.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 12:28:24 -0700 (PDT)
Date:   Tue, 16 Jul 2019 12:28:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH iproute2 0/2] Fix IPv6 tunnel add when dev param is used
Message-ID: <20190716122817.43d644cf@hermes.lan>
In-Reply-To: <cover.1562667648.git.aclaudi@redhat.com>
References: <cover.1562667648.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Jul 2019 15:16:49 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> Commit ba126dcad20e6 ("ip6tunnel: fix 'ip -6 {show|change} dev
> <name>' cmds") breaks IPv6 tunnel creation when dev parameter
> is used.
> 
> This series revert the original commit, which mistakenly use
> dev for tunnel name, while addressing a issue on tunnel change
> when no interface name is specified.
> 
> Andrea Claudi (2):
>   Revert "ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds"
>   ip tunnel: warn when changing IPv6 tunnel without tunnel name
> 
>  ip/ip6tunnel.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 

Both applied, thanks
