Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FC74FE390
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 16:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356495AbiDLOT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 10:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356500AbiDLOTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 10:19:25 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576402C677
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 07:17:05 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bv19so14631811ejb.6
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 07:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6IOYxPkGhplaK2xmTX0hwnzlBdDrdH2LjwUkhFGHUFU=;
        b=T3ddyfVGy0S9TaJXBRFxkmr/lIYihdcBRIxrhV+eY2uzrmMx8ZJEwkL8l2G1Uvil7u
         YloCtrr/aWjXJ4vb5w9LYBcq6OWfeB4xfS0cMSxRkzXIEeL2/FGwgScHvbgWRsklLv9w
         KclWDueIUf5SPd7SuN4zxHKWfkR6txS/Gd0MDPvm6pBcT7W59jOFxzvv8RESysQQL+de
         wp698Hi2VGM9MP2A1b3KCMKbBe/mAj5SGGPiOzfiHOfS7KUJc6n91UzWoy8zA5NZRfAH
         BRHXB4YraOKyEU/LyQDw66yngFM/CzP1H8b9rIgaCLSlnYi1C00S2XGVVvTh5Bh85/Cc
         5RDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6IOYxPkGhplaK2xmTX0hwnzlBdDrdH2LjwUkhFGHUFU=;
        b=q5axvMrTYJC00tboDRv/0UilfgNQMaxbneQV9DJSA2yPiZL/v1tUjbxOOdZRxyJRD3
         SPq9Bo7ZOc9o+wH8W5wGxf/DnvmBGkL00QQ+PDQHZlFsn5ndAr75Zpd3s0RzQYJ9Qxuj
         0D2mbAKXNmIHe051tikFp+OD4WoQgbIugZce2fFfvEoIOlN/qG4IMcdmRZ9gmFTemojC
         Dw8Idi7g2dQ+wYvnvc3/6oCdtayQkDPzDJyXKhgxjUGSk0hY/o2p1Db7QmU1VrhxxPfW
         3T4moeCUJoJl6+ZGhVuZM74/L7K2WorQiaqNtNYbURmUmj8KbesQomU0haBzZ7Mt5jlX
         ZZYQ==
X-Gm-Message-State: AOAM532pSpTnqDISu0x5EoA2KaX2S+0t78Ua7KlkZIKjUqSaGG16WqRs
        tIegXgEtoligFD9wLBjUSAIAZQ==
X-Google-Smtp-Source: ABdhPJyELrjPJv9/yeGFpJUv/faYGUC8dy4QoXlHF7TGyaDHh/r4lMvs6NWvUqbI38ngnh8vFtMOtg==
X-Received: by 2002:a17:907:3ea3:b0:6e8:74b3:178c with SMTP id hs35-20020a1709073ea300b006e874b3178cmr14036893ejc.230.1649773023673;
        Tue, 12 Apr 2022 07:17:03 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id hu8-20020a170907a08800b006dfd2056ab2sm13213844ejc.97.2022.04.12.07.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:17:03 -0700 (PDT)
Date:   Tue, 12 Apr 2022 16:17:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH net-next v2 5/5] net/sched: flower: Consider the number
 of tags for vlan filters
Message-ID: <YlWJ3TCKhih5qM/M@nanopsycho>
References: <20220412100236.27244-1-boris.sukholitko@broadcom.com>
 <20220412100236.27244-6-boris.sukholitko@broadcom.com>
 <YlVd79bM00wuK9yW@nanopsycho>
 <20220412114049.GA2451@noodle>
 <YlVsn59Cbe+pnTte@nanopsycho>
 <20220412131610.GB2451@noodle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412131610.GB2451@noodle>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 12, 2022 at 03:16:10PM CEST, boris.sukholitko@broadcom.com wrote:
>On Tue, Apr 12, 2022 at 02:12:15PM +0200, Jiri Pirko wrote:
>> Tue, Apr 12, 2022 at 01:40:49PM CEST, boris.sukholitko@broadcom.com wrote:
>> >On Tue, Apr 12, 2022 at 01:09:35PM +0200, Jiri Pirko wrote:
>> >> Tue, Apr 12, 2022 at 12:02:36PM CEST, boris.sukholitko@broadcom.com wrote:
>> >> >Currently the existence of vlan filters is conditional on the vlan
>> >> >protocol being matched in the tc rule. I.e. the following rule:
>> >> >
>> >> >tc filter add dev eth1 ingress flower vlan_prio 5
>> >> >
>> >> >is illegal because we lack protocol 802.1q in the rule.
>> >> >
>> >> >Having the num_of_vlans filter configured removes this restriction. The
>> >> >following rule becomes ok:
>> >> >
>> >> >tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
>> >> >
>> >> >because we know that the packet is single tagged.
>> >> >
>> >> >We achieve the above by having is_vlan_key helper look at the number of
>> >> 
>> >> Sorry to be a nitpicker, but who's "we"? When I read the patch
>> >> description, I need to understand clearly what the patch is doing, which
>> >> is not this case. You suppose to command the codebase what to do.
>> >> I fail to see that :/
>> >> 
>> >> 
>> >
>> >What do you think of the following description? The description consists
>> >of two parts: the first provides motivation for the patch, the second is
>> >the way the motivation is implemented. I've judiciously edited out the
>> >"we"-word. :)
>> >
>> ><description>
>> >
>> >Currently the existence of vlan filters is conditional on the vlan
>> >protocol being matched in the tc rule. I.e. the following rule:
>> >
>> >tc filter add dev eth1 ingress flower vlan_prio 5
>> >
>> >is illegal because vlan protocol (e.g. 802.1q) does not appear in the rule.
>> >
>> >Having the num_of_vlans filter configured removes this restriction. The
>> >following rule becomes ok:
>> >
>> >tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
>> 
>> So this is what this patch allows?
>
>Yes.
>
>> You are talking about it as it is
>> already possible with the code before this patch being applied.
>> 
>
>Sorry for the confusion. In the updated description I try to make the
>distinction much clearer.
>
>> 
>> >
>> >because having num_of_vlans==1 implies that the packet is single tagged.
>> >
>> >To make the above possible, is_vlan_key helper is changed to look at the
>> >number of vlans in addition to the vlan ethertype.
>> 
>> What "is changed"? You should tell the codebase what to do, what toadd,
>> remove or change. If you did that, it would be very clear to the reader
>> what the patch is supposed to do.
>> 
>
>The "changed" refers to the code of is_vlan_key function which is
>changed by this patch. Please see the updated description.
>
>> 
>> >
>> >Outer tag vlan filters (e.g.  vlan_prio) require the number of vlan tags
>> >be greater than 0. Inner filters (e.g. cvlan_prio) require the number of
>> >vlan tags be greater than 1.
>> 
>> Again, unclear what this describes, if the current code before the patch
>> or the state after this patch.
>> 
>
>What about the following:
>
><description>
>
>Before this commit the existence of vlan filters was conditional on the vlan
>protocol being matched in the tc rule. For example, the following rule:
>
>tc filter add dev eth1 ingress flower vlan_prio 5
>
>was illegal because vlan protocol (e.g. 802.1q) does not appear in the rule.
>
>This commit removes the above restriction. Having the num_of_vlans

Say rather just "Remove the above restriction. ..."


>filter configured allows further matching on vlan attributes. The
>following rule is ok now:
>
>tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
>
>because having num_of_vlans==1 implies that the packet is single tagged.
>
>To do this, this commit changes is_vlan_key helper to look at the number

"Change the is_vlan_key helper to look..."

Don't talk about "this commit".


>of vlans in addition to the vlan ethertype. Outer (e.g. vlan_prio) and
>inner (e.g. cvlan_prio) tag vlan filters require the number of vlan tags
>to be greater then 0 and 1 accordingly.
>
>As a result of this commit, the ethertype may be set to 0 when matching
>on the number of vlans. This commit changes fl_set_key_vlan to avoid
>setting key, mask vlan_tpid for the 0 ethertype.
>
></description>
>
>Is this going into the right direction?
>
>Thanks,
>Boris.


