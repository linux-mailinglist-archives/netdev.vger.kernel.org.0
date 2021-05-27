Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A6A39359B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbhE0Sx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhE0Sx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:53:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2835D613D8;
        Thu, 27 May 2021 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141543;
        bh=2GZ64XTNj38OOEkvxTC8Rz3FuD/x89YeOegCYzDbQF8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mdjtmXSEyLv6ChFKfQRhRoLUM/hX20EbbxCETHqcoD5K/k5Lo1qXai6RAV9vzbomn
         J3l3Z3g/NU/T+xv5iKpHeu7UUzHmUXOVjQcqmLEmpJhlcRIPRLvYr+8uEmLY53mcGS
         sCHNRLzSlyEZcsPd/G3R/sPruHWvHaSIpIsIn/ZNT2dHI/B4RQCDgXHhBXx+IIYJw8
         M9tL2ZbfjIXyJ8VidKuXFXEPDSXKi0RaJrQtWIwYAaWsFZmLK10GXqg3hNNI+pmbl2
         /zl6Qd4xIBM1e0wUDUOoREPjpFr/TJ5v7N3epzvTLkEkxKK9/OkJqGMd1eM9ejhZl7
         5tUJ6ZamyRc8A==
Message-ID: <9763798a76af3b392bf324af6fe3347b46fbd40c.camel@kernel.org>
Subject: Re: [net-next 17/17] net/mlx5: Improve performance in SF allocation
From:   Saeed Mahameed <saeed@kernel.org>
To:     Parav Pandit <parav@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>
Date:   Thu, 27 May 2021 11:52:22 -0700
In-Reply-To: <DM6PR12MB4330F30E51E9D86F2AA212A7DC239@DM6PR12MB4330.namprd12.prod.outlook.com>
References: <20210527043609.654854-1-saeed@kernel.org>
         <20210527043609.654854-18-saeed@kernel.org>
         <DM6PR12MB4330F30E51E9D86F2AA212A7DC239@DM6PR12MB4330.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-05-27 at 05:36 +0000, Parav Pandit wrote:
> 
> > From: Saeed Mahameed <saeed@kernel.org>
> > Sent: Thursday, May 27, 2021 10:06 AM
> > From: Eli Cohen <elic@nvidia.com>
> > 
> > +                       continue;
> >                 }
> > +
> > +               if (hwc->sfs[i].usr_sfnum == usr_sfnum)
> > +                       return -EEXIST;
> >         }
> > -       return -ENOSPC;
> > +
> > +       if (free_idx == -1)
> > +               return -ENOSPC;
> > +
> > +       hwc->sfs[free_idx].usr_sfnum = usr_sfnum;
> > +       hwc->sfs[free_idx].allocated = true;
> > +       return 0;
> This is incorrect. It must return the free_index and not zero.

Thanks Parav, I will drop the patches,
Please post those comments internally so Eli will handle, I waited for
your comments internally for weeks.



