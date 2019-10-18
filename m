Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15512DCE6D
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502264AbfJRSke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:40:34 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39545 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505915AbfJRSkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:40:33 -0400
Received: by mail-lj1-f194.google.com with SMTP id y3so7209015ljj.6
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 11:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=DO/a/phXhl0ktnXCOi2dJ5+kOviduNbcapLpkYYyEWk=;
        b=cjFTfPVvbl8MsUWT2blqjI7D/UzWWqMscY/aoCSNagnAdLyZQUeALz92b4699wBlT+
         IdWkW+u7rupW5TONGtLImo8d+MudfU57UxSXGjgQclwP2J1fL00HtCvYrSnItcRQGqqA
         wqAVx4fbKWYXA6welrsOhQbGhWXCy3BH8mA97gbL/9FgT8AxoAL0PzpvUlxvnq5PbQY2
         LEUyZn1y8d0hk2zpgTe/pXYFmaS5Jld+iImenu3pIk7Cue4giiHplBtsQdUznpFBfj72
         4XFpY/UEBA7D54cOpRL8puvNcQ4v8gC62q5GcVphNUe3k1nSIxV8+LVNiYjRAIvABOOg
         mn3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=DO/a/phXhl0ktnXCOi2dJ5+kOviduNbcapLpkYYyEWk=;
        b=VGbrF5X/Xoi5zI5MhXr+pgLamyB4VLS/2dXa4eHLFBZH5mQENtjF82dILCT5xj8LPB
         KLmwEHGKl0leKUEWxDjzeteQSEioPgDCOvz2QmIQuqaguHh8HUu8n7R2nQxwFhLzX/b6
         Qixn5OC5sr4CZsXxP9ZzQI9+ujmvxT7VKjEMP0N8WpE40jgUBqu9bOZm84HdIsR2iW6M
         UHniAA3gHoaaVdbXgaI+VAqjPBt+0xW/wRSIjDHUyzPAs00HMoJOsDHCmqfpLC1p+NUR
         qULNbhlwcgqRZKokcqb1huJwhGWDigLPx0DkS+TtNmh7UVc2SZIw5z9UyFD3KVuR914n
         zh+g==
X-Gm-Message-State: APjAAAWopjLnejMUaqafuhFIqe2O3VdV5dkd8IAxkYuk6/g7yYejFjVw
        6iUbJ+8buH3bk3YiZcxHrI3vubGCg6E=
X-Google-Smtp-Source: APXvYqxVwKHqQth0WuJkrBlEYr1piTk8a9b4URutbVdDlPpWcrSkFRNIVYQf5fyo7E/Y60YvCoBoCw==
X-Received: by 2002:a2e:a41a:: with SMTP id p26mr7331304ljn.49.1571424031135;
        Fri, 18 Oct 2019 11:40:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c4sm2716034lfm.4.2019.10.18.11.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 11:40:30 -0700 (PDT)
Date:   Fri, 18 Oct 2019 11:40:24 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>
Subject: Re: [PATCH net] net: hns3: fix mis-counting IRQ vector numbers
 issue
Message-ID: <20191018114024.2102cde5@cakuba.netronome.com>
In-Reply-To: <1571370179-52008-1-git-send-email-tanhuazhong@huawei.com>
References: <1571370179-52008-1-git-send-email-tanhuazhong@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 11:42:59 +0800, Huazhong Tan wrote:
> From: Yonglong Liu <liuyonglong@huawei.com>
> 
> Currently, the num_msi_left means the vector numbers of NIC,
> but if the PF supported RoCE, it contains the vector numbers
> of NIC and RoCE(Not expected).
> 
> This may cause interrupts lost in some case, because of the
> NIC module used the vector resources which belongs to RoCE.
> 
> This patch adds a new variable num_nic_msi to store the vector
> numbers of NIC, and adjust the default TQP numbers and rss_size
> according to the value of num_nic_msi.
> 
> Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

LGTM, thanks!
