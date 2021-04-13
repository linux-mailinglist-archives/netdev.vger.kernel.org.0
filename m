Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A27535D88C
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237381AbhDMHNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhDMHNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:13:04 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29333C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:12:44 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f12so15346031wro.0
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:subject:to:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kZ7pRbfksbAsRyZaqanN7SMBLUMG4+C95SI0k9/0TBw=;
        b=Fk3f9q0kuQ6ar8P0an7whR7d7CldfWPQUWVT5Pb0qt2vTOprynBeUiIpwokoiRp7Y8
         vYqAud1UCSMRCEw4R9V/SIXgFXFO1F4QZCJh59Nxc1xwfm2ijx9QihE9qxZio4Xf+vg9
         zMA4k7GyDv4icl40xVo8XhN1glIKR9JPMZJvtNdflDOC/OxgaOApG3a+PdHnQy7NM5kJ
         CUM9wPL4xMSL9ZL2pFFrlshnvVFeRFrvvfwFzk/s2YBEd5Oe9l4JUzvw3QIHodpMc5hB
         8gk2fazC+ICPxE+uXJ8XKymYS8YH2YrOIL6gS7+tcScCI+MgbdSQ+wJWh0tXZR2DdaHl
         WK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:to:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kZ7pRbfksbAsRyZaqanN7SMBLUMG4+C95SI0k9/0TBw=;
        b=RiMRiziInCBzV/tBa2jfC0xm9Bw5BdCTDIDrCaCwqaTO8Bdv1ssxi0roY9jIjaYCsm
         x1/YLh0WigFYoVbsLVrwOGUEt6+ocTOA9NfpmryKhHx9/xnY3LxQ2STRMo5f78FENq2G
         PQkzwgFKHklstVCHwuASffahlOlroCyU9GVBPynpRLdUbxX9e7W5mJStXYHmcJ9tgnJ9
         /G+x1beylS50fUHlZYJ0lPKhl7/d2SgU1w68DWhQ72niiMxHGvPRdByOEAdsuQWVjSn0
         19l19od8IPedcfx8fk7yKG/pHlezOF01Pu5ZXBDoaJNdiF4OB1k6G4Cht03FGmD9+y8T
         Ry9A==
X-Gm-Message-State: AOAM532EIX86WBFUH/FHDoJqa6dENl6jRh4/2NNEfBXcCSYc57uNpQrA
        aWgHL77EYZj/X07aDoePtxk=
X-Google-Smtp-Source: ABdhPJwSF5KW1F6WT03735VShUEOmGDd3ZvOwIvdQSdaEjd5CGeJmnPMc4IrSX8WiQz5NmgQ/2EU9Q==
X-Received: by 2002:a5d:65d2:: with SMTP id e18mr34699836wrw.256.1618297962912;
        Tue, 13 Apr 2021 00:12:42 -0700 (PDT)
Received: from [192.168.1.186] (host86-180-176-157.range86-180.btcentralplus.com. [86.180.176.157])
        by smtp.gmail.com with ESMTPSA id a7sm20623746wrn.50.2021.04.13.00.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 00:12:42 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Reply-To: paul@xen.org
Subject: Re: xen-netback hotplug-status regression bug
To:     Michael Brown <mcb30@ipxe.org>, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>
References: <afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org>
Message-ID: <f469cdee-f97e-da3f-bcab-0be9ed8cd836@xen.org>
Date:   Tue, 13 Apr 2021 08:12:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/04/2021 19:25, Michael Brown wrote:
> Commit https://github.com/torvalds/linux/commit/1f25657 ("xen-netback: 
> remove 'hotplug-status' once it has served its purpose") seems to have 
> introduced a regression that prevents a vif frontend from transitioning 
> more than once into Connected state.
> 
> As far as I can tell:
> 
> - The defined vif script (e.g. /etc/xen/scripts/vif-bridge) executes 
> only once, at domU startup, and sets 
> backend/vif/<domU>/0/hotplug-status="connected"
> 
> - When the frontend first enters Connected state, 
> drivers/net/xen-netback/xenbus.c's connect() sets up a watch on 
> "hotplug-status" with the callback function hotplug_status_changed()
> 
> - When hotplug_status_changed() is triggered by the watch, it 
> transitions the backend to Connected state and calls xenbus_rm() to 
> delete the "hotplug-status" attribute.
> 
> If the frontend subsequently disconnects and reconnects (e.g. 
> transitions through Closed->Initialising->Connected) then:
> 
> - Nothing recreates "hotplug-status"
> 
> - When the frontend re-enters Connected state, connect() sets up a watch 
> on "hotplug-status" again
> 
> - The callback hotplug_status_changed() is never triggered, and so the 
> backend device never transitions to Connected state.
> 

That's not how I read it. Given that "hotplug-status" is removed by the 
call to hotplug_status_changed() then the next call to connect() should 
fail to register the watch and 'have_hotplug_status_watch' should be 0. 
Thus backend_switch_state() should not defer the transition to 
XenbusStateConnected in any subsequent interaction with the frontend.


> 
> Reverting the commit would fix this bug, but would obviously also 
> reintroduce the race condition that the commit was designed to avoid.
> 
> I'm happy to put together a patch, if one of the maintainers could 
> suggest a sensible design approach.
>

Are you seeing the watch successfully re-registered even though the node 
does not exist? Perhaps there has been a change in xenstore behaviour?

   Paul

> I'm not a list member, so please CC me directly on replies.
> 
> Thanks,
> 
> Michael

