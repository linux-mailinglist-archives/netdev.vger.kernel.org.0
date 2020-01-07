Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A1213227A
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgAGJd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:33:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbgAGJd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 04:33:57 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D9B7206DB;
        Tue,  7 Jan 2020 09:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578389637;
        bh=0RwFzwAEmrIP5sG0tKGrxv2D/cxDWEkx4BvAxCF7YcY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H4MhWpEv9OaFCgT3pOtwNa8691FoPe9u0TYSCg/+0HvXNb3xrg8Z0UMTp3WlgCN9V
         sZneQrxj1cZTzcdnNMP4HyRW3GUYvhQYxpSdzhrj9w+ugT+W+e09aturGqr6jVjdnQ
         EuPegGrp4+ChfhOaNGONnb4I074kMSLOP/LCXt6g=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1iolFL-000143-D1; Tue, 07 Jan 2020 09:33:55 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 07 Jan 2020 09:33:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jianyong Wu <Jianyong.Wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark Rutland <Mark.Rutland@arm.com>, will@kernel.org,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: Re: [RFC PATCH v9 0/8] Enable ptp_kvm for arm64
In-Reply-To: <bf333cdc-3455-7c64-89c2-014639614904@redhat.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <HE1PR0801MB1676CFC9A06B6CE800052A99F43C0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <bf333cdc-3455-7c64-89c2-014639614904@redhat.com>
Message-ID: <7a589be6dc0d5562caf8c8f795b31efc@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, Jianyong.Wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com, Steven.Price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com, Justin.He@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-07 08:15, Paolo Bonzini wrote:
> On 06/01/20 10:38, Jianyong Wu wrote:
>> Ping ...
>> Any comments to this patch set?
> 
> Marc, Will, can you ack it?  Since the sticky point was the detection 
> of
> the clocksource and it was solved by Thomas's patch, I don't have any
> more problems including it.

Boo. I had forgotten about this series. :-(

Going back to it, there is a few ugly points in the arm-specific code
(I'm OK with the generic changes though).

Another thing is that the whole series depends on three patches that 
have
never been posted to any list, hence never reviewed.

Jianyong: Please repost this series *with* the dependencies so that they
can be reviewed, once you've addressed my comments on two of the 
patches.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
