Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47D2DA334
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 03:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389955AbfJQBdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 21:33:09 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37978 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbfJQBdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 21:33:09 -0400
Received: by mail-lf1-f66.google.com with SMTP id u28so465666lfc.5
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 18:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=tYG8C0JKzORc+5dYOCIn/21BVZWCYMghLXihrMVQ54M=;
        b=X9w80PtrLlVIaGKEWD6FdEwxLD8kLljv3QsiwLlGVNwFJBbzhkXJSSnLoohL7RMA8H
         dqYiQAAdjkk2AYwxiYodZUiqaMgXA1rSjSD+86cdJGIAldnqHNMgh48I0PpgQrhae/aV
         Fypvjplw7Gr5UmxJtSfvmeZXstD7e0gV3pvyvak0lmHSAwKh8LZrr+TYgUUuFanx1mJe
         VyUJSyCc0qFG5TpHuuvIGxyttZ7u2DuYmfuEBKqPXqyY/EujL3qQL2EYqMFXC5ZQnrfJ
         6Z7f7Tdtn1hj9ra8BwpR6B3LNIZcS/4hF/YEVAQkqEtSSHZnhyAneADQupCi99fJi/Y/
         RbiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tYG8C0JKzORc+5dYOCIn/21BVZWCYMghLXihrMVQ54M=;
        b=j38b2vV2Gu9F4/rr2KX2P0Y7Gg0BzvRY6uU2c4vqyv+Wr1yDEijpw8F/w3YHzv/KIG
         lxj170rLzmK+NrFEIRJ+tn/cIKCnIs1NVCdxm8Ky5j7kE4+G9o9RzHRv1qchIrw9aWEp
         aZT4bJLwrqMpUYj75zYLRq233TaIMTGcHBLjMu/5mbzQFpPKXuUk30Myrx/HQToSd1cP
         RrKjHIRFbfoZcPbmJ66gg4OWbyrop1uNYg6HJkqzY1pWoeu8ROMQxxm27ejfEi49rbaM
         Sv2jb3+QvI3Etfy7IhrW7cIWKs/P52439O61GHynUPe5xh5i4cK3zIKx4H7uuzZCqWAH
         dJaA==
X-Gm-Message-State: APjAAAXnQSG/2hb4btkP9EUxpdncKEC6azVuV9nAGF7x/tLhtvXVidr0
        GnyelKeFAoI7SvgciMBnP7fvUw==
X-Google-Smtp-Source: APXvYqzfJ8IyXPEZG4XslMmSrMrgW058lrEdPil0XmDSB/K770kN23nXhejr395qA4EaOcrV/8vwJA==
X-Received: by 2002:ac2:4d1b:: with SMTP id r27mr400457lfi.133.1571275987087;
        Wed, 16 Oct 2019 18:33:07 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t8sm319046ljd.18.2019.10.16.18.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 18:33:06 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:33:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>,
        <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH 03/10 net-next] net/mlx5e: RX, Internal DMA mapping in
 page_pool
Message-ID: <20191016183300.63eb3cd1@cakuba.netronome.com>
In-Reply-To: <20191016225028.2100206-4-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
        <20191016225028.2100206-4-jonathan.lemon@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 15:50:21 -0700, Jonathan Lemon wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> After RX page-cache is removed in previous patch, let the
> page_pool be responsible for the DMA mapping.
> 
> Issue: 1487631
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

IIUC you'll need to add DMA syncs here, no? map/unmap has syncing as
side effect.
