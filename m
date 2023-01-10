Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5F5663E0F
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbjAJKYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238510AbjAJKX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:23:59 -0500
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1A4BC9
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:23:57 -0800 (PST)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id c4b23c07;
        Tue, 10 Jan 2023 10:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=default; bh=D+5tVKrQWrrEljyagvHaDP
        Gtc/M=; b=gFLFIFIqSKCZ4jmCy+omMGo3n/p75y4ImBmrsCd8Mj6Hpf4vS186BM
        oCOwADQoc8JQFDiTGerRlAnaXTFHnerUiekBgmyfoDN+B+Yn5CcmavRMFdlM0xqz
        objUhgJcFeL6zoVxKSqIdMvJY1PQpBQRF+v5fn5DryNnmzAQawhwM=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; q=dns; s=default; b=fuYuPbyoLWZ5nNkz
        6h+uRoPMW+433HKOHRn5bzLPjEpIME93kqYcqvFAiroq1I3v7vlGcMCDJUFds0wn
        QuVXaLp2UC9x6eX4mO1P3fRLrz1SOlpRkXP6V3W0DmnX2CZOsqu63QJwkN81VvMj
        AKpp2tixPtW7eIzQxcaJLSOpnGU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1673346235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7sSOdn0WRvW7NPuJZ4MhZbcnEp42chKlpjLTArauhPU=;
        b=ss69SPDPkV9IMkrYUAUolvRC9lD2U2cOe/Va3uD2mE0FepO46sDoeuI3MtzOvC5ujoB0/R
        SwPmJjpSbVJDZ81Isk0rnDIconbfGLA/fY4u2EBPsTORmGAee1EhIT52hFwdJX/T7Hbd8c
        5kws0plzs76n4LnrzlKUev9ztDz2y8M=
Received: from dfj (host-87-9-235-24.retail.telecomitalia.it [87.9.235.24])
        by ziongate (OpenSMTPD) with ESMTPSA id 694b57be (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 10 Jan 2023 10:23:55 +0000 (UTC)
Date:   Tue, 10 Jan 2023 11:23:58 +0100 (CET)
From:   Angelo Dureghello <angelo@kernel-space.org>
To:     Andrew Lunn <andrew@lunn.ch>
cc:     netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
In-Reply-To: <Y7yIK4a8mfAUpQ2g@lunn.ch>
Message-ID: <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
References: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org> <Y7yIK4a8mfAUpQ2g@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

thanks a lot for the prompt reply,

actually, seems i can use both cpu ports by
some brctl lines:

ip link add name br0 type bridge
ip link add name br1 type bridge
brctl addif br0 eth0
brctl addif br1 eth1

I verified looking the tx_packets statistics (ethtool -S)
and both eth0 and eth1 ports are used.

Is it something that may work, eventually as a workaround ?

Also, could you help me to know the kernel version
implementing dual cpu port properly ?

I cannot actually upgrade the kernel, due to cpu producer
customizations that are not mainlined, so would try to
downgrade the driver.

Thanks a lot,
regards,
angelo

On Mon, 9 Jan 2023, Andrew Lunn wrote:

> On Mon, Jan 09, 2023 at 09:40:06PM +0100, Angelo Dureghello wrote:
>> Hi All,
>>
>> using kernel 5.4.70,
>> just looking for confirmation this layout
>> can work:
>>
>>    eth0 -> cpu port (port5, mii)  bridging port3 and 4
>>    eth1 -> cpu port (port6, rgmii)  bridging port0, 1, 2
>>
>> My devicetree actaully defines 2 cpu ports, it seems
>> to work, but please let me know if you see any
>> possible issue.
>
> Dual CPU ports is not supported with 5.4.70. Everything will go over
> the first cpu port in DT.
>
>    Andrew
>
