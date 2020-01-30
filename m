Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E94514DF7F
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 17:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgA3Q4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 11:56:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbgA3Q4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 11:56:31 -0500
Received: from cakuba (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D00E420661;
        Thu, 30 Jan 2020 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580403391;
        bh=az4drtTV3z/07jHMflHQhRpgGWLDLLYWRSx98cT5i84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wGNyDgVxcn5Qf0N2nVmxIpUyMeApzsbI3gNWwomlWZaMavHrKTr5uDB0Qps0F/zbc
         wMXgt4wremVU400fG8NiCEURyirx/9rs6Zp8LQwN1l9o4abMuZszZDRTyjnHQR6LmX
         TnSUu/MJkV1bm2Tn/EMJd/OYmcaixZ691U7EfgJg=
Date:   Thu, 30 Jan 2020 08:56:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin T <m4rtntns@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Why is NIC driver queue depth driver dependent when it
 allocates system memory?
Message-ID: <20200130085629.42c71fdf@cakuba>
In-Reply-To: <CAJx5YvHH9CoC8ZDz+MwG8RFr3eg2OtDvmU-EaqG76CiAz+W+5Q@mail.gmail.com>
References: <CAJx5YvHH9CoC8ZDz+MwG8RFr3eg2OtDvmU-EaqG76CiAz+W+5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 15:02:02 +0200, Martin T wrote:
> Hi,
> 
> when I read the source code of for example tg3 driver or e1000e
> driver, then looks like the driver queue is allocated from system
> memory. For example, in e1000_ethtool.c kcalloc() is called to
> allocate GFP_KERNEL memory.
> 
> If system memory is allocated, then why are there driver-dependent
> limits? For example, in my workstation the maximum RX/TX queue for the
> NIC using tg3 driver is 511 while maximum RX/TX queue for the NIC
> using e1000e driver is 4096:

Hi Martin,

the idea is that drivers can choose the initial setting which are
optimal for the implementation and the hardware. Whether they actually
are, or whether values chosen 10 years ago for tg3 and e1000e are
reasonable for modern uses of that hardware could perhaps be questioned.
