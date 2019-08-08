Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813B386122
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 13:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732037AbfHHLuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 07:50:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38184 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbfHHLuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 07:50:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id y15so43989731pfn.5;
        Thu, 08 Aug 2019 04:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0b+VDJBWGnColcr58cAsSMIzVs5xE5d5w5nOOKMn04g=;
        b=fX8+ZV0Lz3uM6aK3nQAeV4FtmRo+ZSuAqgxQkNDHYJp9EAQB4Ed4OxSsJrine78rWE
         DmCteKue3E6eko2ZRHTVK9I1bZ50Zc6duFTSqa4UO8xM2OorCNkH6p0D1Z6qqL5oS56Z
         wuZeZ6fo0zXyZVzAbzE4YcR5JD4+gFrF67aSUG+67ALFUv9xXXnOfRbD41hErSOdrTR1
         ge4i8czljZbu2InhSAga+LlLLk/CtZLZxPPbtxMdo4B+1zj3dcUn0juPa3fzG7FS3GWF
         66yWq4rqfyXwFfc7XU02XF0/0GA9ZcAd/Z8hZ9ww4iIc70qZtnjPGm206OlA0Bap2P/C
         jZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0b+VDJBWGnColcr58cAsSMIzVs5xE5d5w5nOOKMn04g=;
        b=tcQ18KoVNvaaGSauQBuhXX6SobVjW4dMfIe8oFdKKILfxUSjnqd634llzytqEyeQ1B
         IZ7ZB3+GcVKn7LSjtjXX61hSVLFdgYsT9zdTD2JYzEQKXabljTSpE+18ZNvCLY7tAWSc
         TaCsDJKXxVLXbET4KHcZQEq5T+ZSDZQax3IXQV/bMyCelc0Vndw7ju3z9MLWjefoLJ29
         5AaiQKF7UYx0jAWxx6EqtL9hXzkoCqUoFR6XYY4TcGmn7XJIalA6oazLC4oGRCO9mK84
         XDJyrk1kLN1GdVkS8Qw666f3r0iwnXR9RYK50+1GPn6dAN20gaPAOgDJlY/drddHvxOu
         GV9g==
X-Gm-Message-State: APjAAAWy+xNktctoAGOLi1S4trLY0NjK+dUuyPInD9uD22BF7t81UPLq
        83FewAHPZQLz5930Q17/KfE=
X-Google-Smtp-Source: APXvYqyAg8pW+1ndhRKOZhX++7RuJhCviNemH89L9pDwySd/BTILgn0OEnzB6zxOsc43CR1MfIp+Ww==
X-Received: by 2002:aa7:8f2c:: with SMTP id y12mr15578183pfr.38.1565265010391;
        Thu, 08 Aug 2019 04:50:10 -0700 (PDT)
Received: from localhost ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id s3sm53516693pgq.17.2019.08.08.04.50.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 08 Aug 2019 04:50:10 -0700 (PDT)
Date:   Thu, 8 Aug 2019 13:49:59 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] r8152: change rx_frag_head_sz and
 rx_max_agg_num dynamically
Message-ID: <20190808134959.00006a58@gmail.com>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18D0D8E@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-289-albertk@realtek.com>
        <1394712342-15778-294-albertk@realtek.com>
        <20190806151007.75a8dd2c@cakuba.netronome.com>
        <0835B3720019904CB8F7AA43166CEEB2F18D0D8E@RTITMBSVM03.realtek.com.tw>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Aug 2019 08:52:51 +0000
Hayes Wang <hayeswang@realtek.com> wrote:

> Jakub Kicinski [mailto:jakub.kicinski@netronome.com]
> > Sent: Wednesday, August 07, 2019 6:10 AM  
> [...]
> > On Tue, 6 Aug 2019 19:18:04 +0800, Hayes Wang wrote:  
> > > Let rx_frag_head_sz and rx_max_agg_num could be modified dynamically
> > > through the sysfs.
> > >
> > > Signed-off-by: Hayes Wang <hayeswang@realtek.com>  
> > 
> > Please don't expose those via sysfs. Ethtool's copybreak and descriptor
> > count should be applicable here, I think.  
> 
> Excuse me again.
> I find the kernel supports the copybreak of Ethtool.
> However, I couldn't find a command of Ethtool to use it.

Ummm there's set_tunable ops. Amazon's ena driver is making use of it from what
I see. Look at ena_set_tunable() in
drivers/net/ethernet/amazon/ena/ena_ethtool.c.

Maciej

> Do I miss something?
> 
> Best Regards,
> Hayes
> 

