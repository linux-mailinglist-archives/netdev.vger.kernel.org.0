Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C928C5BA223
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 23:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiIOVCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 17:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIOVCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 17:02:00 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505DC84EDD
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 14:01:58 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l17so3284800wru.2
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 14:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=x9HhMb/EH064ugR86JndAz/Kpq64oWfSDEuu8XvaFWc=;
        b=KVA1UrUIlLmu9hOk6CS0Z30eQMAs5A1zLQQyZLuBJC2fEW9E++Lcws+ivyjAgF5pzE
         3pbkCdVhA5P2LbRILZWFXtWANlyeCSuc8EavDJrg3MEcLq0shAmgOhFNwgd1RmQaSh4+
         jJoNsiJ1YJVY+CHPSzMtataMeuu+vhl2cA49tv8UJufsRDxpfmgaIUmjpW/Fv/1vjL33
         qmig719qjlEnuRM7+GROnOFDqgb3Gab5ILJJUTqpxayWgU0G9OzAvqxUU63eBD9ZjL3U
         vTnEvFIMjf3CO6FsZA0mWQ6C/ni+2vccRp6d0UiikJC5urZTrPIES4mT9We83oWfocP7
         /sOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=x9HhMb/EH064ugR86JndAz/Kpq64oWfSDEuu8XvaFWc=;
        b=JlIAZKl8a0S0pgI7TxXtqqWQ0cH1XUmoEsB+srDFhfsTZPT5JBXa7w/4IpC3glzZAz
         1MC6OnISDCuRavT+BJ+l1D1NTvUYxbWn7EGJvAkzLizERTIr4jR9ji9KJI5UA/XEH87Q
         cXBG5b2+P4qviKrP+2Clg397xeXKDWr6xx2DIVDspSOtvRaqdlP1WmWnxm5jQH9B3SR/
         ixBpKEAvEMa0PDT411KeiiKf8O9K2BoID3oFua3A6nyN3P7nCHj1cwGVyD6F0ChtP5AY
         hV9xUQ5pxB7ThNDmNcu1Rr9pyb5AixPw3t/deFjE/TMISWIqj7u8Ny8zWPoE4uANbX3n
         vgow==
X-Gm-Message-State: ACrzQf1Jf6BE4uXfM8j5ghHOZKX/uPSy8HHTvg9EIi/TJM9nn45z26gb
        Yx0IfuUHOREdx2l7fUjAvYKk0HMiqOI=
X-Google-Smtp-Source: AMsMyM491tlNUu+Yjmez2qeavEDXk77W1QwvRyXQnuskcK3k4FY3wMze6DTNtEc4kgaHWOndSZiffA==
X-Received: by 2002:a5d:59a6:0:b0:22a:c822:f961 with SMTP id p6-20020a5d59a6000000b0022ac822f961mr931242wrr.608.1663275716741;
        Thu, 15 Sep 2022 14:01:56 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id n13-20020a7bcbcd000000b003a60bc8ae8fsm133642wmi.21.2022.09.15.14.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 14:01:56 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <df4cd224-fc1b-dcd0-b7d4-22b80e6c1821@gmail.com>
Date:   Thu, 15 Sep 2022 22:01:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2022 19:41, Wilczynski, Michal wrote:
> Hi,
> Previously we discussed adding queues to devlink-rate in this thread:
> https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/T/#u
> In our use case we are trying to find a way to expose hardware Tx scheduler tree that is defined
> per port to user. Obviously if the tree is defined per physical port, all the scheduling nodes will reside
> on the same tree.
> 
> Our customer is trying to send different types of traffic that require different QoS levels on the same
> VM, but on a different queues. This requires completely different rate setups for that queue - in the
> implementation that you're mentioning we wouldn't be able to arbitrarily reassign the queue to any node.

I'm not sure I 100% understand what you're describing, but I get the
 impression it's maybe a layering violation — the hypervisor should only
 be responsible for shaping the VM's overall traffic, it should be up to
 the VM to decide how to distribute that bandwidth between traffic types.
But if it's what your customer needs then presumably there's some reason
 for it that I'm not seeing.  I'm not a QoS expert by any means — I just
 get antsy that every time I look at devlink it's gotten bigger and keeps
 escaping further out of the "device-wide configuration" concept it was
 originally sold as :(

> Those queues would still need to share a single parent - their netdev. This wouldn't allow us to fully take
> advantage of the HQoS and would introduce arbitrary limitations.

Oh, so you need a hierarchy within which the VF's queues don't form a
 clade (subtree)?  That sounds like something worth calling out in the
 commit message as the reason why you've designed it this way.

> Regarding the documentation,  sure. I just wanted to get all the feedback from the mailing list and arrive at the final
> solution before writing the docs.

Fair.  But you might get better feedback on the code if people have the
 docs to better understand the intent; just a suggestion.

-ed
