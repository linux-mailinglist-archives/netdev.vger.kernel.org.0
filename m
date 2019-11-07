Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E992F39AE
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 21:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfKGUnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 15:43:05 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45904 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfKGUnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 15:43:04 -0500
Received: by mail-pf1-f195.google.com with SMTP id z4so3259068pfn.12
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 12:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oCsTVCq1tQgxv9nxqwe0qeFwhq6XGkTCN3Hs4h2HIRc=;
        b=UIScBZHWyzEhzrW6Ee+rDwKrpK0dUyDsC9atPOnLD9BYejPhwqXy2R0N71p7tAF1LV
         VdDNLcEyicjsZ307doxz7qDkoQk7xmnOCxcRfnxvvY3SVX5uUvZ62SUR1UMjcIGkDCAo
         g6J83PyytFe93QomQ+NXMDSVvw8RIJfSatsEHfkbdy+kkrQy3JzSfWvy7cq3ObnA1D4O
         l8Oywh/emvMYtyo989fZjr917697qhI0w7R8lQB7Y8/duUz3xrk09rxWRtXp6cmkFdT4
         sNpueELPW/DfIf+XqgWYEJ3Hm0ZQoQrcQ/QMe2U+NkxAADOxkx5nBkAmvDDaiIVZw+zQ
         proQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oCsTVCq1tQgxv9nxqwe0qeFwhq6XGkTCN3Hs4h2HIRc=;
        b=eNPLYLq9bXsYN9bVTGbS70hhbKPnx5SOQc6pOB+KvJypm+cPFeAoWXciP4Uhjsjp5a
         7JFO8c/N9tEp7JlKxCFlSqryYiIk/z9Y4SvJ3lk2iBpkJI9+28NoLpBiNbIRRrpwCYW6
         B4tfPm2+zP09gmylz3oHkOCLqPpNMlxtZJDPJJf7pH9fW2TSxtwABS90IjOqemvns1H1
         lWrKzqu3LaXYPAlkP+BHsErnOnRmaTm74KiHyMHbmSz/gENSoeebbI/XrPWxjZLAcdGa
         phhU0uVo31SryxKvJ39pxSh0DJZmBJN+W2h8wagoMr1KP52+3pfJ5g1aFNtvxVlQ2xPh
         QQGg==
X-Gm-Message-State: APjAAAUL6c3Mcgwpt3JdEyEFmNrGyRB/OnajNGpXFFRiTS8orFqdAOVo
        bV7EXmnJgH8iLmP2df4NsMDpRg==
X-Google-Smtp-Source: APXvYqyvmZZM009+2/glhhKH328qJEZP5bLvefLceygilCRIbv5Ww29lexK4aWSSUU0O5Ow5KzUVTg==
X-Received: by 2002:a62:1454:: with SMTP id 81mr6698710pfu.86.1573159383422;
        Thu, 07 Nov 2019 12:43:03 -0800 (PST)
Received: from cakuba.netronome.com ([65.196.126.174])
        by smtp.gmail.com with ESMTPSA id r20sm6495560pgo.74.2019.11.07.12.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 12:43:03 -0800 (PST)
Date:   Thu, 7 Nov 2019 15:42:56 -0500
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 16/19] net/mlx5: Implement dma ops and params
 for mediated device
Message-ID: <20191107154256.21629e5a@cakuba.netronome.com>
In-Reply-To: <20191107160834.21087-16-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-16-parav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Nov 2019 10:08:31 -0600, Parav Pandit wrote:
> Implement dma ops wrapper to divert dma ops to its parent PCI device
> because Intel IOMMU (and may be other IOMMU) is limited to PCI devices.
> 
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>

Isn't this supposed to use PASSID or whatnot? Could you explain a
little? This mdev stuff is pretty new to networking folks..
