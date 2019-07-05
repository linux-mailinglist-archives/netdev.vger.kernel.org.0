Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C18060A20
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfGEQVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:21:49 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44022 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbfGEQVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 12:21:49 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so4513371pgv.10
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 09:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lQkcIspV/hWUgm/7X54UWk2DWtKP3n9DW/djDoTJYQ0=;
        b=PEsj8vdp3P06DP672dfHEmOXtHa77vJHIc8TlobQv0A7hRKsEfeoYc3+DX061kmlP3
         rBb3+G53w64WmqXPXzvMU0LbPJJ9wkztQubnC+YYQHOvW8EPzrLuuat0QzZnSJPl9UzA
         8b0PC5SAzDS7/eU/74czZGgBATto2Q/YZezPYVJSnQOcDJbp5+p0dNzZbNyaGOzNsMGo
         kwPod9YQcXEJeYf387rruNXuGoxdvlZixcsXVIF2p9kZqfUOpxkfMm2CIV+5Oi50LnHi
         l4ZMi3oRh6hptaCL5LLyoEXB8zru/I5s0XQO8fmsKpsRVU80DEqFImBnJcnnWCZRveyb
         LtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lQkcIspV/hWUgm/7X54UWk2DWtKP3n9DW/djDoTJYQ0=;
        b=A7EK0F5kC5bf0E2t2WzDF8Sm6YmmNRzu/LzMozl2qsGvHnlFlX5R/6v04ynlNJEP/f
         kj0LCyypPx3eBStfO8WFf4EU6TsPmB9Hapd8ZWc1G3RnjymwnOGoTmeZQWK4JsqbpnCO
         2oVXwgbicpc/UwcbOSHTBEPTBmCAa6Bljo42+BhNdOtsgObcEui6fsU4lSLnemtsOZQR
         EvIcvwCbnHeuu8e3WfzHuDxj9vm8vtcdutZVtcepdX4zLKboUZm7EulFYmL5pSVdy8jF
         SiXZmyMFBVK4yeqS1AORHSYfG+g+KdPI6CVfTK5VUwpGNMzHCq6/dnPEOMCO+xZ+ugSM
         i8Ww==
X-Gm-Message-State: APjAAAXOtfZlE40CsPugEyBjpch9gcWJOvmCUT04h0kZMriHtFpV4Kqx
        OGBr3r2QkJoG7Y6SLufV9waajA==
X-Google-Smtp-Source: APXvYqzyqYn0hPZ4twe4vutvxQcr/p/SOxOYoeQIYGdLdsokN6yJjozbGbqOS+KqetvJRvq3w7JClQ==
X-Received: by 2002:a63:5964:: with SMTP id j36mr6330859pgm.428.1562343708812;
        Fri, 05 Jul 2019 09:21:48 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::3])
        by smtp.gmail.com with ESMTPSA id t26sm7751056pgu.43.2019.07.05.09.21.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 09:21:48 -0700 (PDT)
Date:   Fri, 5 Jul 2019 09:21:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        <oss-drivers@netronome.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] nfp: tls: fix error return code in
 nfp_net_tls_add()
Message-ID: <20190705092146.6d9b183f@cakuba.netronome.com>
In-Reply-To: <20190705082625.168515-1-weiyongjun1@huawei.com>
References: <20190705082625.168515-1-weiyongjun1@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Jul 2019 08:26:25 +0000, Wei Yongjun wrote:
> Fix to return negative error code -EINVAL from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 1f35a56cf586 ("nfp: tls: add/delete TLS TX connections")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
