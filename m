Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBC42DAD31
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 13:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgLOM2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 07:28:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729426AbgLOM2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 07:28:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608035194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2PFWOUp6BsVeZRIR5zjR2a20420Yo7fOz47E9bHmR0=;
        b=aphvdI4FBnvqL1y8VjiR4/27OBm3ZC5mjwI9+yeLt9sqWCBaEkP/XxtFcYg0dVRqXjFDVw
        T4Kn2nRNngJ9UfO417SCPcB7QWpzMn/E1wXPtj4DMtwA/FS9n6mp1KaCucbX6ClgEa11vV
        8LDcE+1EkBTi/qZ2FN0Ejgkg34APZOo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-OGZZ5TdSPmmz12blCUwJ0w-1; Tue, 15 Dec 2020 07:26:30 -0500
X-MC-Unique: OGZZ5TdSPmmz12blCUwJ0w-1
Received: by mail-ed1-f69.google.com with SMTP id bf13so9867537edb.10
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 04:26:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p2PFWOUp6BsVeZRIR5zjR2a20420Yo7fOz47E9bHmR0=;
        b=oPnj78QstohgAD4Qk8RhsL70tldOG387JHJ6/33syaswBaA6htd13WTZMpzvBFoIR7
         C0SvNqW23uVT9Pj85SfDgy3RyMVUnkMf/jNhSwCJFn23nEbRVPdnWV7nFDSFquEnA4rf
         w+gkXqJm6u0k/XtjMgoTuKzIrSaYX4Zd/Dac3VGTyZ85n3d/xG8xzE5otPUPFBrMJV8s
         5yjOdNS5Sn77R14mrHA/h+lpw5n2GQulP06kAV7baCe/pJkDfwrSZl1Jv+uSk+nkovqk
         biLuYhnfs2IENqGJcw91kKwlTmzjuJCOzJ4DYze5PgAtJygW1Z/NzTDeXBRjCNPm28Vh
         Js5w==
X-Gm-Message-State: AOAM530kaBckMEzKrpAFhUP0592v9ZvvFyePxUDmrUuuq2cK9Zg2nkH6
        SxYEv789brjcs3gudVSRkBTR8NKB9MHyhrEECbPv+Rv1Q4OBSgH9PpbpzpGlQj1jWXF2sfax8yo
        uVelFqnr6p56uvenx
X-Received: by 2002:a05:6402:2292:: with SMTP id cw18mr29573390edb.336.1608035189392;
        Tue, 15 Dec 2020 04:26:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBYKFs3TYtfdNXbnJTsoorusE8rhPx4MUeNvFWOrHdRsAheOVW0szXft9iKrTV55Mu97NNwA==
X-Received: by 2002:a05:6402:2292:: with SMTP id cw18mr29573371edb.336.1608035189103;
        Tue, 15 Dec 2020 04:26:29 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id s26sm17870347edc.33.2020.12.15.04.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 04:26:28 -0800 (PST)
Subject: Re: [PATCH v4 0/4] Improve s0ix flows for systems i219LM
To:     "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        Aaron Ma <aaron.ma@canonical.com>,
        Mark Pearson <mpearson@lenovo.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>
References: <20201214153450.874339-1-mario.limonciello@dell.com>
 <80862f70-18a4-4f96-1b96-e2fad7cc2b35@redhat.com>
 <MN2PR19MB26376EA92CE14DC3ADD328BEFAC70@MN2PR19MB2637.namprd19.prod.outlook.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <1f68c6a4-3dcf-47fa-d3c2-679d1f7c4823@redhat.com>
Date:   Tue, 15 Dec 2020 13:26:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <MN2PR19MB26376EA92CE14DC3ADD328BEFAC70@MN2PR19MB2637.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 12/14/20 8:36 PM, Limonciello, Mario wrote:
>> Hi All,
>>
>> Sasha (and the other intel-wired-lan folks), thank you for investigating this
>> further and for coming up with a better solution.
>>
>> Mario, thank you for implementing the new scheme.
>>
> 
> Sure.
> 
>> I've tested this patch set on a Lenovo X1C8 with vPRO and AMT enabled in the
>> BIOS
>> (the previous issues were soon on a X1C7).
>>
>> I have good and bad news:
>>
>> The good news is that after reverting the
>> "e1000e: disable s0ix entry and exit flows for ME systems"
>> I can reproduce the original issue on the X1C8 (I no longer have
>> a X1C7 to test on).
>>
>> The bad news is that increasing the timeout to 1 second does
>> not fix the issue. Suspend/resume is still broken after one
>> suspend/resume cycle, as described in the original bug-report:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1865570
>>
>> More good news though, bumping the timeout to 250 poll iterations
>> (approx 2.5 seconds) as done in Aaron Ma's original patch for
>> this fixes this on the X1C8 just as it did on the X1C7
>> (it takes 2 seconds for ULP_CONFIG_DONE to clear).
>>
>> I've ran some extra tests and the poll loop succeeds on its
>> first iteration when an ethernet-cable is connected. It seems
>> that Lenovo's variant of the ME firmware waits up to 2 seconds
>> for a link, causing the long wait for ULP_CONFIG_DONE to clear.
>>
>> I think that for now the best fix would be to increase the timeout
>> to 2.5 seconds as done in  Aaron Ma's original patch. Combined
>> with a broken-firmware warning when we waited longer then 1 second,
>> to make it clear that there is a firmware issue here and that
>> the long wait / slow resume is not the fault of the driver.
>>
> 
> OK.  I've submitted v5 with this suggestion.
> 
>> ###
>>
>> I've added Mark Pearson from Lenovo to the Cc so that Lenovo
>> can investigate this issue further.
>>
>> Mark, this thread is about an issue with enabling S0ix support for
>> e1000e (i219lm) controllers. This was enabled in the kernel a
>> while ago, but then got disabled again on vPro / AMT enabled
>> systems because on some systems (Lenovo X1C7 and now also X1C8)
>> this lead to suspend/resume issues.
>>
>> When AMT is active then there is a handover handshake for the
>> OS to get access to the ethernet controller from the ME. The
>> Intel folks have checked and the Windows driver is using a timeout
>> of 1 second for this handshake, yet on Lenovo systems this is
>> taking 2 seconds. This likely has something to do with the
>> ME firmware on these Lenovo models, can you get the firmware
>> team at Lenovo to investigate this further ?
>>
> 
> Please be very careful with nomenclature.  AMT active, or AMT capable?
> The goal for this series is to support AMT capable systems with an i219LM
> where AMT has not been provisioned by the end user or organization.
> OEMs do not ship systems with AMD provisioned.

Ah, sorry about that. What I meant with "active" is set to "Enabled"
in the BIOS.

Also FWIW I just tried disabling AMT in the BIOS (using the "Disabled"
option, not the "Permanently Disabled" option) on the Lenovo X1 Carbon
8th gen, but that does not make a difference.

It still takes 2 seconds for ULP_CONFIG_DONE to clear even with AMT
set to "Disabled" in the BIOS :|

Regards,

Hans


