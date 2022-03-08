Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42ADF4D1218
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344977AbiCHIWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344981AbiCHIWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:22:43 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8EC3F88B;
        Tue,  8 Mar 2022 00:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=KkMNVOPLz6N1kK6aCBMc1BMlJmqiMJjsoqzBy2IaBDQ=;
        t=1646727691; x=1647937291; b=ndWkecROorcrQ0Gv8zBZRSa1UfZtTjeWBXy/q/Z0HBaRqPc
        QRU6IexcSUYgCVEQ0+ccU1n5MeZnWVkTl9Q9vSQP1H4HgKTklOdfEdw+1wMlz0tY9GYO/TFHWfG9h
        OjOGF44x7tJhMcYLDO8lmOKswOh1mdrig9p7nI2szHbzXm2L9ad7Hj7thpiB3awMbCtDurcXZekAl
        kAC2XOzWc3BLBxtrkPJbceLtuqKxPIvxXITVzCSdmZukn+r9DN6ewOKiA99qVRn+N6+T0DQqpGCFD
        BDUOxi3TJkpMd+Eqcz75YhWf4UOg2tms1E95vFc+xKzUbJSJ10K/xxBCLAlRY8IQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nRV5r-00ARMb-S0;
        Tue, 08 Mar 2022 09:21:19 +0100
Message-ID: <5bec02cb6a640cafd65c946e10ee4eda99eb4d9c.camel@sipsolutions.net>
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Roi Dayan <roid@nvidia.com>, dev@openvswitch.org,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue, 08 Mar 2022 09:21:18 +0100
In-Reply-To: <20220307214550.2d2c26a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
         <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
         <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
         <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
         <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
         <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
         <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <3a96b606-c3aa-c39b-645e-a3af0c82e44b@ovn.org>
         <20220307144616.05317297@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <45aed9cd-ba65-e2e7-27d7-97e3f9de1fb8@ovn.org>
         <20220307214550.2d2c26a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-03-07 at 21:45 -0800, Jakub Kicinski wrote:
> 
> Let me add some people I associate with genetlink work in my head
> (fairly or not) to keep me fair here.

:)

> It's highly unacceptable for user space to straight up rewrite kernel
> uAPI types
> 

Agree.

> but if it already happened the only fix is something like:
> 
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 9d1710f20505..ab6755621e02 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -351,11 +351,16 @@ enum ovs_key_attr {
>         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
>         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
>         OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
> -       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
>  
>  #ifdef __KERNEL__
>         OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
>  #endif
> +       /* User space decided to squat on types 30 and 31 */
> +       OVS_KEY_ATTR_IPV6_EXTHDRS = 32, /* struct ovs_key_ipv6_exthdr */
> +       /* WARNING: <scary warning to avoid the problem coming back> */

It might be nicer to actually document here in what's at least supposed
to be the canonical documentation of the API what those types were used
for. Note that with strict validation at least they're rejected by the
kernel, but of course I have no idea what kind of contortions userspace
does to make it even think about defining its own types (netlink
normally sits at the kernel/userspace boundary, so where does it make
sense for userspace to have its own types?)

(Though note that technically netlink supports userspace<->userspace
communication, but that's not used much)

> > > Since ovs uses genetlink you should be able to dump the policy from 
> > > the kernel and at least validate that it doesn't overlap.  
> > 
> > That is interesting.  Indeed, this functionality can be used to detect
> > problems or to define userspace-only attributes in runtime based on the
> > kernel reply.  Thanks for the pointer!

As you note, you'd have to do that at runtime since it can change, even
the policy. And things not in the policy probably should never be sent
to the kernel even if strict validation isn't used.

johannes
