Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657B66C1E30
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjCTRiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbjCTRhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:37:47 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778DE1258E
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:33:51 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id w11so7016374wmo.2
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679333625;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5wPFy650NtYWbMwwrvt+1dtXJ58EWb5IAcc9o8PvI1Y=;
        b=zTL/ZRzJhW62lJFASpKOBYQdzErtrgf9ZqSSsQeEZVRbBc1YfqkTNLz98GY0ae72yu
         1g1mLGKwj5iIS4Au1hpI215yodzmQCHde1NrCJ8TWu9TI8yjAhOaI8lSmBIEhWvJ+UoG
         rXlIJQF2leSmhCYNkMOBIDbUzZErlD9cWI4sVN3ujvyN2mJdNw4BgOmafBl74DVsL/HT
         zAfXZCSIspNhoE69b0PIWwy2o5klnowtDaJ0UQH+g045Ftja7rr3pzDoLkZKL8I/IK05
         X3xdImd/vRWljrhnsx0CeaO6wofasgVrmnqijfrf7Ho3FvLpEW1IpFW2/1eBdDLi/hXF
         C54Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679333625;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5wPFy650NtYWbMwwrvt+1dtXJ58EWb5IAcc9o8PvI1Y=;
        b=qNoag/2hCCfyW7HBFt5FL7QdQYAfK+P/36lJ1evJ27wRo/eswXcotut+eZrs0Traf3
         HoqMOPsMXOPU6uTTHo2Qoa451JiW1uohsDMS46rkbkyaqGrxdH0lN7yIo4zKH57Fv399
         HjNsz/oYZpuojp0ao56kTVFPN+z5YS79ysXseMhgLlj9sNSwQf51mc25S8FeYlG0wLqk
         sTOKsIqYLZzPym0oP6ugUWaRoynFAav1PJjriwfuR4gfNBxIJhLzofmyXwr7vkZWTpOI
         kKQWGDz7bRoQIkqB+gGUplKMY30/8QSuS1jlTZxYUALV5zQlA7UlipmYSO4WhHCfjozl
         n7gA==
X-Gm-Message-State: AO0yUKX5xtJ7Pfjpb3eeV2z2qOJoX/ZUUgUYnDJ6gXLpmQLaqM63pe9/
        IZ/XGRfLtH9evLU4bzkLKk4Qrg==
X-Google-Smtp-Source: AK7set/pClYE2H4LW/4eWJ+dxNnK1LGgrpUERPTuo73wuHEEGkQoGfA+iT1XGOn5crvRpYe+p2CSnA==
X-Received: by 2002:a1c:4c1a:0:b0:3ed:8780:f27b with SMTP id z26-20020a1c4c1a000000b003ed8780f27bmr274368wmf.16.1679333624812;
        Mon, 20 Mar 2023 10:33:44 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id h20-20020a1ccc14000000b003dc522dd25esm11057908wmb.30.2023.03.20.10.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 10:33:44 -0700 (PDT)
Message-ID: <14361063-5005-4dd6-a314-737aaea7bf2c@blackwall.org>
Date:   Mon, 20 Mar 2023 19:33:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Multicast: handling of STA disconnect
Content-Language: en-US
To:     Ujjal Roy <royujjal@gmail.com>
Cc:     roopa@nvidia.com, netdev@vger.kernel.org,
        Kernel <linux-kernel@vger.kernel.org>,
        bridge@lists.linux-foundation.org
References: <CAE2MWkm=zvkF_Ge1MH7vn+dmMboNt+pOEEVSgSeNNPRY5VmroA@mail.gmail.com>
 <a4ce2c34-eabe-a11f-682a-4cecf6c3462b@blackwall.org>
 <CAE2MWkkDNZuThePts_nU-LNYryYyWTYOMk5gmuoCoGPh4bf4ag@mail.gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <CAE2MWkkDNZuThePts_nU-LNYryYyWTYOMk5gmuoCoGPh4bf4ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/03/2023 19:25, Ujjal Roy wrote:
> Hi Nik,
> 
> Flushing MDB can only be done when we are managing it per station not
> per port. For that we need to have MCAST_TO_UCAST, EHT and FAST_LEAVE.
> 
> Here one more point is - some vendors may offload MCAST_TO_UCAST
> conversion in their own FW to reduce CPU.
> 
> So, the best way is to have MCAST_TO_UCAST enabled and MDB will become
> per station, so we can delete MDB on disconnect. Shall, I create one
> patch for review?
> 
> Thanks,
> UjjaL Roy
> 
> On Mon, Mar 20, 2023 at 5:38 PM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>
>> On 20/03/2023 13:45, Ujjal Roy wrote:
>>> Hi Nikolay,
>>>
>>> I have some query on multicast. When streams running on an STA and STA
>>> disconnected due to some reason. So, until the MDB is timed out the
>>> stream will be forwarded to the port and in turn to the driver and
>>> dropps there as no such STA.
>>>
>>> So, is the multicast_eht handling this scenario to take any action
>>> immediately? If not, can we do this to take quick action to reduce
>>> overhead of memory and driver?
>>>
>>> I have an idea on this. Can we mark this port group (MDB entry) as
>>> INACTIVE from the WiFi disconnect event and skip forwarding the stream
>>> to this port in br_multicast_flood by applying the check? I can share
>>> the patch on this.
>>>
>>> Thanks,
>>> UjjaL Roy
>>
>> Hi,
>> Fast leave and EHT (as that's v3's fast leave version) are about quickly converging when
>> a leave is received (e.g. when there are no listeners to quickly remove the mdb). They
>> don't deal with interface states (IIUC). Why don't you just flush the port's mdb entries
>> on disconnect? That would stop fwding.
>>
>> Cheers,
>>  Nik
>>
>>

Hi,
Alright, let's see the patch to better understand what is necessary.
Also please don't top post on netdev@.

Cheers,
 Nik

