Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142C75A299F
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 16:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344484AbiHZOek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 10:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344439AbiHZOej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 10:34:39 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B58881B2E
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 07:34:37 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s11so2311776edd.13
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 07:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=9zlwCPVehJQ1qgjHuCqk7QskOCRiDPoz2uVWsDuaHXA=;
        b=ADLsg/Oi/Efwq6v44nXKp2rbwJ1f1EFDTiuc/nAwlP9XuqPA8wEMyg9iDu95s2OYL5
         nnEL67MBpAu1ZKYTrD9IK9hSkutHmoM/esRdyy8AGLGSaQwzvB9oQwhI3aBSJKRT0+4v
         LOkyCY3DrxGC/NM34g3IoQuCRuTdZ0ttk9yWPvBi0vUttFYyXABE5el0cqdP/IgI5YZY
         8EkYbq+he4mJxW0vRz/iym4SmJS5pj0qem9Qlks3m7Hkb88ez/+mQjgqbGC86qALstmI
         DRuW5xsu2gDMNGeSOHxbmopRmmUK1UyWgdPvzQxqdQ2z9YLvCBf6HPDk8o1hdyMLMn7W
         3YNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=9zlwCPVehJQ1qgjHuCqk7QskOCRiDPoz2uVWsDuaHXA=;
        b=Uilj5GWaP473Vb8kReMnmvQ2PpbjZbTI1kW39hp/aq9OhVOUXLHeYnS6YYg11EVgHd
         BAypfTbafBwW2lLyTbawmrY6Ib+cxcbbvhpT2Mzod3KaE3WZXgyF/YiOABzuSqn2t7hP
         kuNUJvPa5I2Yki1GuT+a1FVzg3MrrsGkBGWka+rIbE5CPTBkeDFgeWC5IiYG3xSzK2KW
         V9wS3rJA/Lbfs1NIo/zYbEp/aPORKsPr50uMxhAshimDmJxeKQLUp1DuS4vqxziQtcpy
         uFNA7iWdwjOh/Qp3y+ZfMDULY3UbnoVCfekYmX+fT/Ds/sMnz4A1dMgftBDXaIoq7kg6
         LDyw==
X-Gm-Message-State: ACgBeo01aloCRU2PJAsq1LzvKdEd1qic3l/RDqxZ3aYMT6w2WENVcRxV
        CXO1cXXlO7jBrYHxuEaXdvX5+g==
X-Google-Smtp-Source: AA6agR4XSVmzN1sOs2T2fKu+ihFGyRk7Bm77OfYpfXrHGJiIkQ7cdmBiP7+80PNa8q8VQ0gCXY5GEQ==
X-Received: by 2002:a05:6402:551a:b0:446:1526:85ea with SMTP id fi26-20020a056402551a00b00446152685eamr7159133edb.188.1661524475867;
        Fri, 26 Aug 2022 07:34:35 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b7-20020aa7c907000000b004478e9ab2c5sm1362707edt.69.2022.08.26.07.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 07:34:35 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:34:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "louis.peens@corigine.com" <louis.peens@corigine.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "maksym.glubokiy@plvision.eu" <maksym.glubokiy@plvision.eu>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jchapman@katalix.com" <jchapman@katalix.com>,
        "gnault@redhat.com" <gnault@redhat.com>
Subject: Re: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
Message-ID: <YwjZ+h82UrF2MrxO@nanopsycho>
References: <20220826110059.119927-1-wojciech.drewek@intel.com>
 <YwircDhHhOfqdHy/@nanopsycho>
 <MW4PR11MB5776E6C92351788A0E55B6CBFD759@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW4PR11MB5776E6C92351788A0E55B6CBFD759@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 26, 2022 at 01:36:55PM CEST, wojciech.drewek@intel.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> Sent: piątek, 26 sierpnia 2022 13:16
>> To: Drewek, Wojciech <wojciech.drewek@intel.com>
>> Cc: netdev@vger.kernel.org; Lobakin, Alexandr <alexandr.lobakin@intel.com>; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
>> Nguyen, Anthony L <anthony.l.nguyen@intel.com>; davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
>> pabeni@redhat.com; jhs@mojatatu.com; xiyou.wangcong@gmail.com; marcin.szycik@linux.intel.com;
>> michal.swiatkowski@linux.intel.com; kurt@linutronix.de; boris.sukholitko@broadcom.com; vladbu@nvidia.com;
>> komachi.yoshiki@gmail.com; paulb@nvidia.com; baowen.zheng@corigine.com; louis.peens@corigine.com;
>> simon.horman@corigine.com; pablo@netfilter.org; maksym.glubokiy@plvision.eu; intel-wired-lan@lists.osuosl.org;
>> jchapman@katalix.com; gnault@redhat.com
>> Subject: Re: [RFC PATCH net-next 0/5] ice: L2TPv3 offload support
>> 
>> Fri, Aug 26, 2022 at 01:00:54PM CEST, wojciech.drewek@intel.com wrote:
>> >Add support for dissecting L2TPv3 session id in flow dissector. Add support
>> >for this field in tc-flower and support offloading L2TPv3. Finally, add
>> >support for hardware offload of L2TPv3 packets based on session id in
>> >switchdev mode in ice driver.
>> >
>> >Example filter:
>> >  # tc filter add dev $PF1 ingress prio 1 protocol ip \
>> >      flower \
>> >        ip_proto l2tp \
>> >        l2tpv3_sid 1234 \
>> >        skip_sw \
>> >      action mirred egress redirect dev $VF1_PR
>> >
>> >Changes in iproute2 are required to use the new fields.
>> >
>> >ICE COMMS DDP package is required to create a filter in ice.
>> 
>> I don't understand what do you mean by this. Could you please explain
>> what this mysterious "ICE COMMS DDP package" is? Do I understand it
>> correctly that without it, the solution would not work?
>
>Sorry, I'll include more precise description in the next version.
>DDP (Dynamic Device Personalization) is a firmware package that contains definitions
>protocol's headers and packets. It allows you  to add support for the new protocol to the
>NIC card without rebooting.  If the DDP package does not support L2TPv3 then hw offload 
>will not work, however sw offload will still work.

Hmm, so it is some FW part? Why do we care about it here in patchset
description?


>
>More info on DDP:
>https://www.intel.com/content/www/us/en/architecture-and-technology/ethernet/dynamic-device-personalization-brief.html
>
>> 
>> >
>> >Marcin Szycik (1):
>> >  ice: Add L2TPv3 hardware offload support
>> >
>> >Wojciech Drewek (4):
>> >  uapi: move IPPROTO_L2TP to in.h
>> >  flow_dissector: Add L2TPv3 dissectors
>> >  net/sched: flower: Add L2TPv3 filter
>> >  flow_offload: Introduce flow_match_l2tpv3
>> >
>> > .../ethernet/intel/ice/ice_protocol_type.h    |  8 +++
>> > drivers/net/ethernet/intel/ice/ice_switch.c   | 70 ++++++++++++++++++-
>> > drivers/net/ethernet/intel/ice/ice_tc_lib.c   | 27 ++++++-
>> > drivers/net/ethernet/intel/ice/ice_tc_lib.h   |  6 ++
>> > include/net/flow_dissector.h                  |  9 +++
>> > include/net/flow_offload.h                    |  6 ++
>> > include/uapi/linux/in.h                       |  2 +
>> > include/uapi/linux/l2tp.h                     |  2 -
>> > include/uapi/linux/pkt_cls.h                  |  2 +
>> > net/core/flow_dissector.c                     | 28 ++++++++
>> > net/core/flow_offload.c                       |  7 ++
>> > net/sched/cls_flower.c                        | 16 +++++
>> > 12 files changed, 179 insertions(+), 4 deletions(-)
>> >
>> >--
>> >2.31.1
>> >
