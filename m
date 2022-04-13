Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6223B4FF600
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiDMLrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiDMLrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:47:23 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A53D53B42
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 04:45:01 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u15so3328465ejf.11
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 04:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZF5ymbpq8nqfH+cVyldAtv4D/nQvZ+8JkjX8fr905X4=;
        b=6pvxQLl+FJLDZsQRAYvna4Ub+8jJ0nY0JS+GWyuxy5lIIN6WlUnKPVbB758QOqQmem
         N5E3Kf9PKtC5GFRUZgW0omH4R/DZ2xieFw52P/FMDzBZP54dITTX3jZnXGnFBL779hqd
         3o4MEVy7rt00wQCDukWTIyD6cJjHUNCXskwKtzS/mUc05xbpRBb6+eTGmYIkTG/MPOuw
         NzG34PXQR/SHcGDp469g/bXGq+eS+n+Eavn8WGq/fNAUSsPaYRJoAVsfM8VeNrMe93yJ
         E53g1MhWYgGic4XeQ0Gr689VHKzsWzDpI16pqwZACwzPiAHk2tMplHDqi3l6qKlgk2Un
         9X0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZF5ymbpq8nqfH+cVyldAtv4D/nQvZ+8JkjX8fr905X4=;
        b=l01BR1E7HOPSk4o1UrN/FZggFgE9MH5ytvoyPWs6T/zPiPgKUDfM/G5rl0r16EjlHi
         /HoOmrwNG9a9wYKjWLCvVCqYUT9wHUqVdkWny3oXEngxy4cUUTtQu0fI08qvsQphkWe0
         u67lSWNbBpKWQrUiII8m9xmJTXWPxhT38ciXf28pA2RxPZgm0lo7odnVPvj87fbzaXO1
         RdaL6vzB5/Qsu3TcC/WGyKLfiQBVzJYy+pkbRInMpyg3ovVn2qpaAyaE+DO49UH0oLwo
         kzD6uCGXPvkEFMZjUZROrqjf1hD59YCrm9bKEzwsVdBK0L6G0jQMeOnkhmetwrtnnZI+
         gVHQ==
X-Gm-Message-State: AOAM532wXosNYzH7DawnbiK2wVVCcrwmiqQwYc0qiIVnHe4Ky8SgOFRq
        uEO4uYkDtGLvd+TDWvp4iw60/w==
X-Google-Smtp-Source: ABdhPJzMO0MHfQWLt14FjtNw0xuNHlpjs+RHbF1wLZhvImw1FtZGj918rwwfDs1QUX0GBex7msPS3Q==
X-Received: by 2002:a17:907:3da5:b0:6e8:c2c8:1f18 with SMTP id he37-20020a1709073da500b006e8c2c81f18mr2512547ejc.728.1649850299982;
        Wed, 13 Apr 2022 04:44:59 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kw5-20020a170907770500b006db075e5358sm13776416ejc.66.2022.04.13.04.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 04:44:58 -0700 (PDT)
Date:   Wed, 13 Apr 2022 13:44:56 +0200
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
Message-ID: <Yla3uGUYIQhHpsvs@nanopsycho>
References: <20220412100236.27244-1-boris.sukholitko@broadcom.com>
 <20220412100236.27244-6-boris.sukholitko@broadcom.com>
 <YlVd79bM00wuK9yW@nanopsycho>
 <20220412114049.GA2451@noodle>
 <YlVsn59Cbe+pnTte@nanopsycho>
 <20220412131610.GB2451@noodle>
 <YlWJ3TCKhih5qM/M@nanopsycho>
 <20220413081417.GA12128@noodle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413081417.GA12128@noodle>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 13, 2022 at 10:14:17AM CEST, boris.sukholitko@broadcom.com wrote:
>On Tue, Apr 12, 2022 at 04:17:01PM +0200, Jiri Pirko wrote:
>> Tue, Apr 12, 2022 at 03:16:10PM CEST, boris.sukholitko@broadcom.com wrote:
>> >On Tue, Apr 12, 2022 at 02:12:15PM +0200, Jiri Pirko wrote:
>> >> Tue, Apr 12, 2022 at 01:40:49PM CEST, boris.sukholitko@broadcom.com wrote:
>> >> >On Tue, Apr 12, 2022 at 01:09:35PM +0200, Jiri Pirko wrote:
>> >> >> Tue, Apr 12, 2022 at 12:02:36PM CEST, boris.sukholitko@broadcom.com wrote:
>> >> >> >Currently the existence of vlan filters is conditional on the vlan
>> >> >> >protocol being matched in the tc rule. I.e. the following rule:
>> >> >> >
>> >> >> >tc filter add dev eth1 ingress flower vlan_prio 5
>> >> >> >
>> >> >> >is illegal because we lack protocol 802.1q in the rule.
>> >> >> >
>> >> >> >Having the num_of_vlans filter configured removes this restriction. The
>> >> >> >following rule becomes ok:
>> >> >> >
>> >> >> >tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
>> >> >> >
>> >> >> >because we know that the packet is single tagged.
>> >> >> >
>> >> >> >We achieve the above by having is_vlan_key helper look at the number of
>> >> >> 
>> >> >> Sorry to be a nitpicker, but who's "we"? When I read the patch
>> >> >> description, I need to understand clearly what the patch is doing, which
>> >> >> is not this case. You suppose to command the codebase what to do.
>> >> >> I fail to see that :/
>> >> >> 
>> >> >> 
>> >> >
>> >> >What do you think of the following description? The description consists
>> >> >of two parts: the first provides motivation for the patch, the second is
>> >> >the way the motivation is implemented. I've judiciously edited out the
>> >> >"we"-word. :)
>> >> >
>> >> ><description>
>> >> >
>> >> >Currently the existence of vlan filters is conditional on the vlan
>> >> >protocol being matched in the tc rule. I.e. the following rule:
>> >> >
>> >> >tc filter add dev eth1 ingress flower vlan_prio 5
>> >> >
>> >> >is illegal because vlan protocol (e.g. 802.1q) does not appear in the rule.
>> >> >
>> >> >Having the num_of_vlans filter configured removes this restriction. The
>> >> >following rule becomes ok:
>> >> >
>> >> >tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
>> >> 
>> >> So this is what this patch allows?
>> >
>> >Yes.
>> >
>> >> You are talking about it as it is
>> >> already possible with the code before this patch being applied.
>> >> 
>> >
>> >Sorry for the confusion. In the updated description I try to make the
>> >distinction much clearer.
>> >
>> >> 
>> >> >
>> >> >because having num_of_vlans==1 implies that the packet is single tagged.
>> >> >
>> >> >To make the above possible, is_vlan_key helper is changed to look at the
>> >> >number of vlans in addition to the vlan ethertype.
>> >> 
>> >> What "is changed"? You should tell the codebase what to do, what toadd,
>> >> remove or change. If you did that, it would be very clear to the reader
>> >> what the patch is supposed to do.
>> >> 
>> >
>> >The "changed" refers to the code of is_vlan_key function which is
>> >changed by this patch. Please see the updated description.
>> >
>> >> 
>> >> >
>> >> >Outer tag vlan filters (e.g.  vlan_prio) require the number of vlan tags
>> >> >be greater than 0. Inner filters (e.g. cvlan_prio) require the number of
>> >> >vlan tags be greater than 1.
>> >> 
>> >> Again, unclear what this describes, if the current code before the patch
>> >> or the state after this patch.
>> >> 
>> >
>> >What about the following:
>> >
>> ><description>
>> >
>> >Before this commit the existence of vlan filters was conditional on the vlan
>> >protocol being matched in the tc rule. For example, the following rule:
>> >
>> >tc filter add dev eth1 ingress flower vlan_prio 5
>> >
>> >was illegal because vlan protocol (e.g. 802.1q) does not appear in the rule.
>> >
>> >This commit removes the above restriction. Having the num_of_vlans
>> 
>> Say rather just "Remove the above restriction. ..."
>> 
>> 
>> >filter configured allows further matching on vlan attributes. The
>> >following rule is ok now:
>> >
>> >tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
>> >
>> >because having num_of_vlans==1 implies that the packet is single tagged.
>> >
>> >To do this, this commit changes is_vlan_key helper to look at the number
>> 
>> "Change the is_vlan_key helper to look..."
>> 
>> Don't talk about "this commit".
>> 
>
>OK. The following incorporates both of the above suggestions:
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
>Remove the above restriction by looking at the num_of_vlans filter to
>allow further matching on vlan attributes. The following rule is ok now:

What's "now"?


>
>tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
>
>because having num_of_vlans==1 implies that the packet is single tagged.
>
>Change is_vlan_key helper to look at the number of vlans in addition to
>the vlan ethertype. Outer (e.g. vlan_prio) and inner (e.g.  cvlan_prio)
>tag vlan filters require the number of vlan tags to be greater then 0
>and 1 accordingly.

I don't get this last sentence. "filters require". Do you do the change
or are you stating what's in before the patch?


>
>As a result of is_vlan_key change, the ethertype may be set to 0 when
>matching on the number of vlans. Update fl_set_key_vlan to avoid setting
>key, mask vlan_tpid for the 0 ethertype.
>
></description>
>
>Thanks,
>Boris.


