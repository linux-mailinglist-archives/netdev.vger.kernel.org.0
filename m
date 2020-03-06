Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0C117C546
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 19:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgCFSUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 13:20:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgCFSUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 13:20:12 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FB8520674;
        Fri,  6 Mar 2020 18:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583518811;
        bh=RKMDi1YpwfKc4hbqZzkAeUer29pu5e93WN+MMh0gUeI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rGsyDKd2ap32aL7Rx5stRMgfBCAw49fhiARHuxAjUKBKc+Q0W3HJKyVxx+YSEUREP
         3oqK4OVPdNNacVgICy/otVNJ0IphI+AUMruipIwnMdQr/06zpofgBFRdq/d/pH38ny
         gvkTxgikBewPC4sA0HdyW7L7RKpU1Qya1wQhkPGs=
Date:   Fri, 6 Mar 2020 10:20:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 7/8] ionic: add support for device id 0x1004
Message-ID: <20200306102009.0817bb06@kicinski-fedora-PC1C0HJN>
In-Reply-To: <3b85a630-8387-2dc6-2f8c-8543102d8572@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
        <20200305052319.14682-8-snelson@pensando.io>
        <20200305140322.2dc86db0@kicinski-fedora-PC1C0HJN>
        <d9df0828-91d6-9089-e1b4-d82c6479d44c@pensando.io>
        <20200305171834.6c52b5e9@kicinski-fedora-PC1C0HJN>
        <3b85a630-8387-2dc6-2f8c-8543102d8572@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Mar 2020 23:43:44 -0800 Shannon Nelson wrote:
> Yes, and if we were just writing registers, that would make sense. When 
> I can get to it I do intend to try expand our use of the devlink 
> interfaces where it will work for us.

Yes, please do that.

> However, this device id does exist on some of the DSC configurations, 
> and I'd prefer to explicitly acknowledge its existence in the driver and 
> perhaps keep better control over it, whether or not it gets used by our 
> 3rd party tool, rather than leave it as some obscure port for someone to 
> "discover".

I understand, but disagree. Your driver can certainly bind to that
management device but it has to be for the internal use of the kernel.
You shouldn't just expose that FW interface right out to user space as 
a netdev.
