Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DC42807E0
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgJATlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgJATlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:41:14 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44EA920759;
        Thu,  1 Oct 2020 19:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581274;
        bh=pHcTnghfqS61gbyRMCsz1nuzHpAx6pUWLcPlke83MSo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=0xPfdWAgucUJQLTI88gjaTICWupPtEckhJd8b0QqfteGey/WCwBLcxtxXL32UBFM3
         LwmSQ3DYmPuajOEk4KLn/jKCa9JB5xPSGBEdAG/D4wVSt85KNtKuIPSUHQPH60W7Uy
         3XpfXlvLdlGmHBeuqAj3zVn2hT9SSw2x2zmXcYTI=
Message-ID: <119a39b1c6bae3ef90e61e741399380022000459.camel@kernel.org>
Subject: Re: [net 01/15] net/mlx5: Don't allow health work when device is
 uninitialized
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, shayd@mellanox.com,
        saeedm@mellanox.com
Date:   Thu, 01 Oct 2020 12:41:13 -0700
In-Reply-To: <20201001.122120.1497340751468134272.davem@davemloft.net>
References: <20201001020516.41217-1-saeed@kernel.org>
         <20201001020516.41217-2-saeed@kernel.org>
         <20201001.122120.1497340751468134272.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 12:21 -0700, David Miller wrote:
> From: saeed@kernel.org
> Date: Wed, 30 Sep 2020 19:05:02 -0700
> 
> > @@ -201,6 +206,9 @@ void mlx5_enter_error_state(struct
> mlx5_core_dev *dev, bool force)
> >               err_detected = true;
> >       }
> >       mutex_lock(&dev->intf_state_mutex);
> > +     if (!mlx5_is_device_initialized(dev))
> > +             return;
> > +
> 
> You can return with this mutex held, and that's ok?
> 
> I think you have to "goto unlock;" or similar.

goto unlock is needed,
thanks for spotting this, I will fix and send v2.


