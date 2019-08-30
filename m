Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1DEA40C2
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 01:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfH3XFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 19:05:16 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41527 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbfH3XFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 19:05:16 -0400
Received: by mail-pl1-f196.google.com with SMTP id m9so3996072pls.8
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 16:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NI9BDtZfkfrCl+dTZfqEJB4bWNMIfe/Up4Cdd59pL2g=;
        b=ni7eJCNBVuVRlLYnYl2bzjCuTIJPzlxVlk/TLefYHHLlJaJ99uhbajuSFCW/XPipa+
         88fyw05AqcMrAkaMzNX3w04s57ImGDkDpMnAVzWadsFUxcSJVdYZ89Xl7YonchbOXEaD
         PCgVN/r18gqfh33GPPJEYFRZXpR568EKqe3VpFNXH8/1+LFh/khSAvJPmq1OvX+EXc11
         txa2pj+KqMzjtM8hBtBSvFyDJgHGph/S91GzdIgoNntqWC8o6hLFb1aAu1lVmH6PNSbe
         NSBgfEYDyAXL5NxDwJaFjdiLImMSDWj4+Jsjn3anvWPjKg/XlhuH1qHinwqYSs90Rvkg
         IBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NI9BDtZfkfrCl+dTZfqEJB4bWNMIfe/Up4Cdd59pL2g=;
        b=C7jjF+JQ+lEkMxt9i946B7UUvM8Qe2+isES7hTugdDWvllOVz6F1TFayWGA9prgKyD
         8IIrBlQBl+zpNaSUX670qevymS4rIWfxJVKDvx1AZT8RkR9KmEWaVpSWm2qunT/1LnOE
         zUO76GRmPtiXohsaRJOHX/uKJ+CcHTIVdmYMZ0bnXq2trEfT97nxsFPdnsUhldl9eVJK
         KfnxrhGVgqkh9OpIOd7+kydMoxpFY+3qX9UfkaLzUEbBnBrXdtnJ69jFY0H6Ehami6sW
         RrnkOhFLeWEmhQz0lN+xgQ6TxZcuC85pgMLZVPpzxAsgeN2BnoAYwIw/dqnHn+XyfQ1n
         le0w==
X-Gm-Message-State: APjAAAV8NnN+nO23RAXSLP1IQUgXaO0Q+bUzEOKeiUtDuz3YbHS+wjAX
        A8Rxs3pmnJbWhp5j84+bYBERGw==
X-Google-Smtp-Source: APXvYqzlZrhD2umfyBqhvQCNE0YD3z96OCMV30W6iz0UXOvGDit5ze7lKPsitEvryrSAN2eP6WlPmg==
X-Received: by 2002:a17:902:1107:: with SMTP id d7mr17857245pla.184.1567206315345;
        Fri, 30 Aug 2019 16:05:15 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m145sm7947995pfd.68.2019.08.30.16.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 16:05:15 -0700 (PDT)
Date:   Fri, 30 Aug 2019 16:04:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH net-next, 2/2] hv_netvsc: Sync offloading features to VF
 NIC
Message-ID: <20190830160451.43a61cf9@cakuba.netronome.com>
In-Reply-To: <1567136656-49288-3-git-send-email-haiyangz@microsoft.com>
References: <1567136656-49288-1-git-send-email-haiyangz@microsoft.com>
        <1567136656-49288-3-git-send-email-haiyangz@microsoft.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 03:45:38 +0000, Haiyang Zhang wrote:
> VF NIC may go down then come up during host servicing events. This
> causes the VF NIC offloading feature settings to roll back to the
> defaults. This patch can synchronize features from synthetic NIC to
> the VF NIC during ndo_set_features (ethtool -K),
> and netvsc_register_vf when VF comes back after host events.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Mark Bloch <markb@mellanox.com>

If we want to make this change in behaviour we should change
net_failover at the same time.
