Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4942A3C7169
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 15:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbhGMNsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 09:48:14 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:48448
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhGMNsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 09:48:13 -0400
Received: from [192.168.1.18] (unknown [222.129.38.167])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 08DE1405E6;
        Tue, 13 Jul 2021 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1626183922;
        bh=XFchaAmc9L6ZJAbgvoritLLDGb3RUOvHfIzleghA+mI=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=habbnrJBNcH29BI7CQh8bNqPF/4LUngU9TvbzFiOCYIGJuBzIWvsI16wSn29vO9/o
         2PMGpzdlTGZLSp8joo0aiJkCC4tHsoe4gzSPN8fxq39b0ap1od9qrZUUTBeO+NlhvB
         bAFsl6roxPoTV18hoIdUyjCeu9n7bTq3mNve10yqVUfIps5vjT7XNrjLDxShl20w2r
         Qg6V+AN9o438AqKbrJldHbtRBTlvXWimys19reH0SEsxDpG2MsYbJ8EEKOHs9Y63OU
         htdhkg538ytmoern4qT72H8mtHrTgvN7g5CUFUnHIheh9w4FsihIEdt1lEk1EDrMh4
         IOJdkDFyleHTw==
Subject: Re: [Intel-wired-lan] [PATCH 2/2] igc: wait for the MAC copy when
 enabled MAC passthrough
To:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Edri, Michael" <michael.edri@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Shalev, Avi" <avi.shalev@intel.com>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <20210702045120.22855-2-aaron.ma@canonical.com>
 <613e2106-940a-49ed-6621-0bb00bc7dca5@intel.com>
 <ad3d2d01-1d0a-8887-b057-e6a9531a05f4@canonical.com>
 <f9f9408e-9ba3-7ed9-acc2-1c71913b04f0@intel.com>
 <96106dfe-9844-1d9d-d865-619d78a0d150@canonical.com>
 <47117935-10d6-98e0-5894-ba104912ce25@intel.com>
From:   Aaron Ma <aaron.ma@canonical.com>
Message-ID: <1a539d4d-10b4-5b9b-31e7-6aec57120356@canonical.com>
Date:   Tue, 13 Jul 2021 21:45:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <47117935-10d6-98e0-5894-ba104912ce25@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/8/21 12:24 PM, Neftin, Sasha wrote:
> I would to like suggest checking the following direction:
> 1. principal question: can we update the netdev device address after it is already set during probe? I meant perform another:
> memcpy(netdev->dev_addr, hw->mac.addr, netdev->addr_len) up to demand

Updating MAC addr may work.
Even at the end of probe, it still got the wrong MAC address, delay is still needed.

Aaron

> 2. We need to work with Intel's firmware engineer/group and define the message/event: MAC addressis changed and should be updated.
> As I know MNG FW updates shadow registers. Since shadow registers are different from RAL/RAH registers - it could be a notification that the MAC address changed. Let's check it.
