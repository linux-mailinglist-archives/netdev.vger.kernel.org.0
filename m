Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DE95EEE7C
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbiI2HI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235037AbiI2HI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:08:27 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C156E6DDF
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:08:25 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bj12so835533ejb.13
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=+AW/3bga438rCB765SwrbsyApmIQG3fWe3PDegwvZGY=;
        b=S6SIKvJoPzJeZ11QypKS3ijtVGTvanlbinZMY/fSkQXIaCNIqRRP+e10aHzIvY01vu
         i3b840N2XgbSxdSjX0rp/m+pJKclqdoWMc699w59JI4GsD3LQsmSo6qprC15YkMktwKB
         OsCFTHQ9KuWvpeYBH9ywl52fMGLC+HpEMuIUkNo1aSbIlq2rtRi2TChsSeU7qDwHEcNm
         gLY8sUdKXnlVx+gcw/EiyMIH1rBq0ZwAyH3cRpUibe5sAu7GpuzDYU0dwp3HZy9nBPe9
         QfjWcLPzbY2HKSnHwLu5X7QneMFpa7H5ip+0HT9AeQmN+lPO12NZJyp8E4iq5HSXkBnr
         LkRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+AW/3bga438rCB765SwrbsyApmIQG3fWe3PDegwvZGY=;
        b=k5MIbuBIJ0tUNh1E4uPnnh/u9oETCdiPLQAPuFVNkhVGLA1a6HHKv7ZB5jlMfHaRWo
         Mznq51PT5DQo2QnIinD1WpK9KwfTXio6ypOyQuAL8VUMRcPS3HbOac89hyLdtY54x9/D
         hCrjUxrTbZ+2SBHa+ZxO4vMmB6DqOZN/2TMFFZ8dfEPM5xg6oMWNceoLno8hJNIHTotr
         DNZ96QjrTvnCsX6pYU2nGMa839qS0xDb3ItMRjw+54INUWJSgey2C+NwAKxTCXmRyTdi
         z35MHImsGVxLJtJjUh3PepkACnEaj9LeBKhZeDznAC79uf72JEE5l9Cu4RJxqKxHHE9Q
         6kYA==
X-Gm-Message-State: ACrzQf3e2SGni49CozWNlrwdWPi4fzGtEveNVf7khGvo0klNvjNSq5iH
        MG7IGHYqHH3RbiNGn6eQf/5gMA==
X-Google-Smtp-Source: AMsMyM47Az6QiOYvYKy2/XXTS/NsUzSwmwT2sgUGy6cb0DYNL39s+U6rNHJSf3T3T2Zm8jQ6qV34QQ==
X-Received: by 2002:a17:907:2c47:b0:787:6f95:2bfe with SMTP id hf7-20020a1709072c4700b007876f952bfemr1518581ejc.705.1664435303006;
        Thu, 29 Sep 2022 00:08:23 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090618aa00b0073dd1ac2fc8sm3514244ejf.195.2022.09.29.00.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:08:22 -0700 (PDT)
Date:   Thu, 29 Sep 2022 09:08:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        simon.horman@corigine.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <YzVEZWioeVNgMNvK@nanopsycho>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <df4cd224-fc1b-dcd0-b7d4-22b80e6c1821@gmail.com>
 <7ce70b9f-23dc-03c9-f83a-4b620cdc8a7d@intel.com>
 <24690f01-5a4b-840b-52b7-bdc0e6b9376a@gmail.com>
 <YzGT98W0+Pzhahl8@nanopsycho>
 <c89ce464-4374-a3c3-3f58-727a913af870@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c89ce464-4374-a3c3-3f58-727a913af870@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Sep 28, 2022 at 01:53:24PM CEST, michal.wilczynski@intel.com wrote:
>
>
>On 9/26/2022 1:58 PM, Jiri Pirko wrote:
>> Tue, Sep 20, 2022 at 01:09:04PM CEST, ecree.xilinx@gmail.com wrote:
>> > On 19/09/2022 14:12, Wilczynski, Michal wrote:
>> > > Maybe a switchdev case would be a good parallel here. When you enable switchdev, you get port representors on
>> > > the host for each VF that is already attached to the VM. Something that gives the host power to configure
>> > > netdev that it doesn't 'own'. So it seems to me like giving user more power to configure things from the host
>> Well, not really. It gives the user on hypervisor possibility
>> to configure the eswitch vport side. The other side of the wire, which
>> is in VM, is autonomous.
>
>Frankly speaking the VM is still free to assign traffic to queues as before,
>I guess the networking card scheduling algorithm will just drain those
>queues at different pace.

That was not my point, my point is, that with per-queue shaping, you are
basically configuring the other side of the wire (VF), when this config
is out of the domain of hypervisor.

>
>> 
>> 
>> > > is acceptable.
>> > Right that's the thing though: I instinctively Want this to be done
>> > through representors somehow, because it _looks_ like it ought to
>> > be scoped to a single netdev; but that forces the hierarchy to
>> > respect netdev boundaries which as we've discussed is an unwelcome
>> > limitation.
>> Why exacly? Do you want to share a single queue between multiple vport?
>> Or what exactly would the the usecase where you hit the limitation?
>
>Like you've noticed in previous comment traffic is assigned from inside the
>VM,
>this tree simply represents scheduling algorithm in the HW i.e how fast the
>card
>will drain from each queue. So if you have a queue carrying real-time data,
>and the rest carrying bulk, you might want to prioritze real-time data
>it i.e put it on a completely different branch on the scheduling tree.

Yep, so, if you forget about how this is implemented in HW/FW, this is
the VM-side config, correct?


>
>BR,
>Michał
>
>> 
>> 
>> > > In my mind this is a device-wide configuration, since the ice driver registers each port as a separate pci device.
>> > > And each of this devices have their own hardware Tx Scheduler tree global to that port. Queues that we're
>> > > discussing are actually hardware queues, and are identified by hardware assigned txq_id.
>> > In general, hardware being a single unit at the device level does
>> > not necessarily mean its configuration should be device-wide.
>> > For instance, in many NICs each port has a single hardware v-switch,
>> > but we do not have some kind of "devlink filter" API to program it
>> > directly.  Instead we attach TC rules to _many_ netdevs, and driver
>> > code transforms and combines these to program the unitary device.
>> > "device-wide configuration" originally meant things like firmware
>> > version or operating mode (legacy vs. switchdev) that do not relate
>> > directly to netdevs.
>> > 
>> > But I agree with you that your approach is the "least evil method";
>> > if properly explained and documented then I don't have any
>> > remaining objection to your patch, despite that I'm continuing to
>> > take the opportunity to proselytise for "reprs >> devlink" ;)
>> > 
>> > -ed
>
