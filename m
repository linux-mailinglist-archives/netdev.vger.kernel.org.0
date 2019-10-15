Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA8AD8425
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390168AbfJOXCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:02:03 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41077 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387758AbfJOXCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 19:02:02 -0400
Received: by mail-lj1-f196.google.com with SMTP id f5so21961579ljg.8
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 16:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QPyfbHACuxjhdd2SZ5llgAD5VG++2/DtrjOn9tVuJzs=;
        b=0vpgJwtAH6R2Fv8HgPNHD0bclBrFHeE/QUP4yAF1K8LQIpha9xQSYfMkDRmd2yo7vc
         3jPiKitJpnIoQeiGMbJDka9SAMDBxF0T9j56bSGqz97ITaksx68aTLxs036UJ1bfsyps
         hOH9HkoY9wHZJJMbW9XKhuSQrA34aDs7IILueOXPoARiHh49u4iUeTunNLZYKMtClr0H
         k9rnjP2+qztYQwWssJ9NFZuu8pAzB/h7Ljbw71B40b1p+Iof+SUCYJkw2HdL3zjox6TC
         uomdBJ1gEtmDsmU7jZtmXtah1M+i6eYFzkRGYPb3T9JVVTIxjQtn04ItiUibYpc+u1DZ
         NKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QPyfbHACuxjhdd2SZ5llgAD5VG++2/DtrjOn9tVuJzs=;
        b=nQqDudHbkw4+arLoUU6ewxqnyrlYLwK8MZnA9YN+Tci5kjR60a0rYbVMb9OGu30Dg6
         SxF5XrBl3Hno+0u8/JPbvsZj2LQb9yCRyzPF/ZvnuAzoLp6icDL0+SayOpx8MBe2tdgf
         f7L0xRAsC4fpaSKkeLYPRAEYB+x6EoMX1Ih8TZ2YmaSxTZYHCAymHygkoTOEnCXQ/okh
         g3Ba7WvQhNFmvc5/klmjA95ZoX3MhdDMUywcw39lQp/h3r7rIbm9eoE+T+ycZDm1lLPb
         M3I2SmgQhKeh25RwZ8hYRrgZTkon1cbcWJEwQ8LY7maN8OhHbM+AXiV0NR7p4KJlPJYv
         0J/Q==
X-Gm-Message-State: APjAAAW7w8ZRKafPhq9NsPEv0p1bjQGo0kDd9itmIBCX+4GPoVCvvHmK
        wkPQLIqvd6H70YZX3x7wcF9sNQ==
X-Google-Smtp-Source: APXvYqyYezcMdghieu4yZwNeOrgrHopp5WDmHBQkdRZN4tsJKIVQR7uNrtRgkFCOu4v9J/0fgVfcbQ==
X-Received: by 2002:a05:651c:237:: with SMTP id z23mr16035336ljn.214.1571180520806;
        Tue, 15 Oct 2019 16:02:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l3sm5340287lfc.31.2019.10.15.16.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 16:02:00 -0700 (PDT)
Date:   Tue, 15 Oct 2019 16:01:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 4/8] net: mvneta: sync dma buffers before
 refilling hw queues
Message-ID: <20191015160151.2d227995@cakuba.netronome.com>
In-Reply-To: <e458e8e4e1d9aa936d64346ca02e432b3b0b7b34.1571049326.git.lorenzo@kernel.org>
References: <cover.1571049326.git.lorenzo@kernel.org>
        <e458e8e4e1d9aa936d64346ca02e432b3b0b7b34.1571049326.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Oct 2019 12:49:51 +0200, Lorenzo Bianconi wrote:
> mvneta driver can run on not cache coherent devices so it is
> necessary to sync DMA buffers before sending them to the device
> in order to avoid memory corruptions. Running perf analysis we can
> see a performance cost associated with this DMA-sync (anyway it is
> already there in the original driver code). In follow up patches we
> will add more logic to reduce DMA-sync as much as possible.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Should this not be squashed into patch 2? Isn't there a transient bug
otherwise?
