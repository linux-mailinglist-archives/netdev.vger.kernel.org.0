Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F024DCF28
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 21:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiCQUMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 16:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiCQUMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 16:12:07 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519A62ED2E6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 13:10:45 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 137E93F325
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 20:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647547835;
        bh=oGka89Ju4SH1eJbMmEz67bGmXAxdjFKHnHgVhuc4y5I=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=sw/5GufZAgBNmERL1Y9HmuS3umWXoV2LJzjY+01EAlEwJymaQ6Py5UKQg5jQ17e/j
         FJwQFOObsuqqLRyUJuzEC4uBPqopCxzvb+VjLCi2QIr6MEgdodY0JfBWuB2Lli07uZ
         X3PYAjkOeeOqA1lZQl1usTtxfj31YEVn4zzOlX5xeIU9YZcsESK3YewSlqAPQfJ0Jn
         NMxJhP+pwoAPVgQMcfZPQfPc2hvfwnnmpbkb5J+OXoEvI3zhE3uY5VyZIojQX+AAee
         vkJ5hOlqTEtLw7TOTeJZJkWxYxeqqkIKj6biABYlIPbRN3z9AZ3gzf/yRPsG2TESOa
         Mwk7oAUqWWZeQ==
Received: by mail-pj1-f70.google.com with SMTP id rm9-20020a17090b3ec900b001c6317e4715so6923399pjb.6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 13:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=oGka89Ju4SH1eJbMmEz67bGmXAxdjFKHnHgVhuc4y5I=;
        b=yG8X80u9HrVXZiZ0/siUC9E5cPmSAsPaZEPMJ+Njd1Zme1h4RrwGosDmE8K/PbLdAB
         jvHqgPoUhM2zawJ263N/OLkoyTpAzVOqlxA7eVBHc9j/fbvbdeNm+2Q5nB96LjsaRCV6
         5bzKRYMIpVjPCKJXGsvlub8AzvuJdU3NbhbwLhxNt4Co19THvK4sbscibv1Z48Nx2aKQ
         uKEe7/o/StAvrhw1GgbyvBW4HEnB5unHgI9SpKfEm7/WCaG5aGjsJS6ri+CjdCT1ywt5
         qSB1xgOwRPJkmPaxLp+x0RTSK3pc5rFcJfj1ndOsXaYdtyqupJnNk7OjC8U/lbFFx+UO
         iReA==
X-Gm-Message-State: AOAM530JkG+HZIWpjJeXkPQu9s674nj4fetM2RN/mkvxVSKYdqs5Urtn
        WL87F90cQ6Rgl6/W6T3d32GOHkAf+4dkiSar6vktZ7Fgd2y4P4SnqX/Y7sQiLxNA3IJVT3riMfG
        fMpRNhYy/GLXE1aHrR4kSVkc2qnx8hbLZOg==
X-Received: by 2002:a17:90b:1e05:b0:1bf:4673:7e7d with SMTP id pg5-20020a17090b1e0500b001bf46737e7dmr18136862pjb.10.1647547832990;
        Thu, 17 Mar 2022 13:10:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIWov4910PEae3SHu9J2fytnHDI9r4/fCyzFHyStsFyiNnPRcM6KxaBT6Do9lWoJyhJ8XkTA==
X-Received: by 2002:a17:90b:1e05:b0:1bf:4673:7e7d with SMTP id pg5-20020a17090b1e0500b001bf46737e7dmr18136848pjb.10.1647547832729;
        Thu, 17 Mar 2022 13:10:32 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id q10-20020a056a00088a00b004f7ceff389esm8019135pfj.152.2022.03.17.13.10.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Mar 2022 13:10:32 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id D9ACA5FDEE; Thu, 17 Mar 2022 13:10:31 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id D2725A0B18;
        Thu, 17 Mar 2022 13:10:31 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     David Ahern <dsahern@kernel.org>
cc:     Sun Shouxin <sunshouxin@chinatelecom.cn>, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v4] net:bonding:Add support for IPV6 RLB to balance-alb mode
In-reply-to: <eff0021c-5a9b-5c44-3fb7-24387cf13e16@kernel.org>
References: <20220317061521.23985-1-sunshouxin@chinatelecom.cn> <eff0021c-5a9b-5c44-3fb7-24387cf13e16@kernel.org>
Comments: In-reply-to David Ahern <dsahern@kernel.org>
   message dated "Thu, 17 Mar 2022 12:49:54 -0600."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24596.1647547831.1@famine>
Date:   Thu, 17 Mar 2022 13:10:31 -0700
Message-ID: <24597.1647547831@famine>
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> wrote:

>On 3/17/22 12:15 AM, Sun Shouxin wrote:
>> This patch is implementing IPV6 RLB for balance-alb mode.
>> 
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>> changelog:
>> v1-->v2:
>> -Remove ndisc_bond_send_na and refactor ndisc_send_na.
>> -In rlb_nd_xmit, if the lladdr is not local, return curr_active_slave.
>> -Don't send neighbor advertisement message when receiving
>>  neighbor advertisement message in rlb6_update_entry_from_na.
>> 
>> v2-->v3:
>> -Don't export ndisc_send_na.
>> -Use ipv6_stub->ndisc_send_na to replace ndisc_send_na
>>  in rlb6_update_client.
>> 
>> v3-->v4:
>> -Submit all code at a whole patch.
>
>you misunderstood Jakub's comment. The code should evolve with small,
>focused patches and each patch needs to compile and function correctly
>(ie., no breakage).

	Agreed; the split of the patches was not at issue, it was that
each patch in a series must compile and the built kernel must function
rationally.

>You need to respond to Jiri's question about why this feature is needed.

	I'm not entirely sold on adding IPv6 RLB for balance-alb, but
the IPv4 version of it does see moderate levels of use, even now.  It's
less common than LACP by far, though.  I'd like to know why someone
would choose IPv6 RLB over LACP.  I wonder if this is a checklist item
somewhere that something must have "complete support for IPv6" or words
to that effect, versus an actual functional need.

>After that:
>
>1. patch 1 adds void *data to ndisc_send_na stub function and
>ndisc_send_na direct function. Update all places that use both
>ndisc_send_na to pass NULL as the data parameter.
>
>2. patch 2 refactors ndisc_send_na to handle the new data argument
>
>3. patch 3 exports any IPv6 functions. explain why each needs to be
>exported.
>
>4. patch 4 .... bonding changes. (bonding folks can respond on how to
>introduce that change).

	Looking at the previous patch for bonding, my two initial
requests are:

	1) A more detailed commit message.  The only way to understand
how any of this actually works is reading the code, there is no higher
level description.

	2) How does this interact with the IPv4 RLB logic?  Is it
possible for a given bond interface MAC to be "assigned" to two
different peers (one IPv4, one IPv6), and if so, does that behave in an
expected manner?  I.e., two peers on the network could receive
contradictory information via ARP and ND for the MAC address of a given
peer.  This is already possible with the IPv4 RLB, but with an
additional IPv6 RLB, a single peer could see two different MACs for a
given host (one via IPv4, one via IPv6), and another peer could see the
opposite, or even disjoint information across several peers.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
