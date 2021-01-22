Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F38B300825
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 17:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbhAVQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 11:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729432AbhAVQDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 11:03:08 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B5AC06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:02:27 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id i20so5513440otl.7
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 08:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=usM/rhS6yP+hrg3G4GXLnN0pU6I4Q/Q1vD31JKeIDOk=;
        b=ThmKp5T6UrcsCi4XdFZwjuFYtk2seAHrZ33AFhRuZ6w/2yqtk9R0ofjWVETdq6K3lO
         Q1FGsJ7fBQ13PM25AWhwSk95zSXu7BqBfyiqsRNtVIL+1/4GUnJoO8doXUpoWmZG8PLT
         WXzA50KTcGCLNZjgKi9WSQoEZhKtPUfsnKEXY4nsqR4eLPDJhpkaSSaVzg04oS00D01m
         7wBO6PuCMj/9XRKlNC4Z/DmR68GW6CGbWllEdBnVRfxtOG/RIgb1pQNvrMNAoxj9MUre
         iPw6e+m7Ic0O+2RzD8MSlMy/EyhIFbQHW0SDjKinQPq8GExd8K2XaTt78mgZ3VLnF/do
         L0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=usM/rhS6yP+hrg3G4GXLnN0pU6I4Q/Q1vD31JKeIDOk=;
        b=ZrKM+1CdbkPmji5Hn6UHEi94gs4V2zGPfsI3JE6NKaiQq+CIdnFKNgvWYlzE+l4uGI
         IFhWNx24t0aiSQNiB9TGet1r68c3Sud1+b64PqKusfX9leEH3+z5t5sKiZ14duAJ1IUH
         T1GAc/K2NldMdB6N6kaik4rabJgpMvw+l+fQnsZuRQlvq5EOL+B0r568+PzAnrCQHLmk
         X6+7UxnxPvRgcZAabW4cdx+4HfObkitG7Xg0xn93GozTP3xkErqxbbaIRpVU/LVFwH//
         JOL51KmSASn22zLGRL7hofKmS/kcGx32ULKOSH89REVpgTcBiHnNxh8qjim0LcFZCzMl
         Vtug==
X-Gm-Message-State: AOAM5331ZU1/qdfweHMjZNlbJ77UrpU6mjSIMAGdqlhDFW9n02u2k6t5
        bGBHwtA7GTr1GvDL9K2ZpRSXPIM60zQ=
X-Google-Smtp-Source: ABdhPJzRvkvtU69sDIsd4NHS3mxeWenNF+N2qTcXFILhYwi3O42LLUy4injr8LE5GVognLIM4aIP9w==
X-Received: by 2002:a9d:7194:: with SMTP id o20mr3760727otj.214.1611331346952;
        Fri, 22 Jan 2021 08:02:26 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id g21sm1736071otj.77.2021.01.22.08.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 08:02:26 -0800 (PST)
Subject: Re: VRF: ssh port forwarding between non-vrf and vrf interface.
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <7dcd75bb-b934-e482-2e84-740c5c80efe0@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2dbd0ccb-9209-5682-0ae2-207cc02086ab@gmail.com>
Date:   Fri, 22 Jan 2021 09:02:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <7dcd75bb-b934-e482-2e84-740c5c80efe0@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/21 8:45 AM, Ben Greear wrote:
> Hello,
> 
> I have a system with a management interface that is not in any VRF, and
> then I have
> a port that *is* in a VRF.  I'd like to be able to set up ssh port
> forwarding so that
> when I log into the system on the management interface it will
> automatically forward to
> an IP accessible through the VRF interface.
> 
> Is there a way to do such a thing?
> 

For a while I had a system setup with eth0 in a management VRF and setup
to do NAT and port forwarding of incoming ssh connections, redirecting
to VMs running in a different namespace. Crossing VRFs with netfilter
most likely will not work without some development. You might be able to
do it with XDP - rewrite packet headers and redirect. That too might
need a bit of development depending on the netdevs involved.
