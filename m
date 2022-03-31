Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331714EDB83
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbiCaOPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 10:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiCaOPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 10:15:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6A74199E;
        Thu, 31 Mar 2022 07:13:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A9F06199F;
        Thu, 31 Mar 2022 14:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B82C340ED;
        Thu, 31 Mar 2022 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648736005;
        bh=60nh5Gko10VkTAze7+WzVDlod2DwO5XxCr0jcHueyIA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=cGVhPcelSRgTfKEi88H+4LFdWxgOvwOae9LJUZd1Nw1eqOUloO0f039JlKesxSGks
         0dEy0N1ZzsMgg6M+oyE/lrrR8GUM/Y/vf3g/GrRFR4CEQMeITu0gyjGW+X14LXLMos
         GqdKpQFXA40UlYNEJpceO5gfGsNeLRzNalNB4vKTcPBGAGetT/2AN/M2h0qCsC0uHz
         Y84uPXzndSvJjtWCwfVzNCDgDXDqMKy9PIK7zMeUzOeuEDntugA4KEB8yVzcXEev1K
         0EpMGqtzqD23VCvety8Ljos6J4/xJjUCXz8WJUCvxVOU4PR/W1dZxbr3yFxz2sfDkz
         EWiOI8uzvvLHw==
Message-ID: <47987a0e-0626-04f8-b181-ff3bc257a269@kernel.org>
Date:   Thu, 31 Mar 2022 08:13:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: This counter "ip6InNoRoutes" does not follow the RFC4293
 specification implementation
Content-Language: en-US
To:     "Pudak, Filip" <Filip.Pudak@windriver.com>,
        "Xiao, Jiguang" <Jiguang.Xiao@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <SJ0PR11MB51207CBDB5145A89B8A0A15393359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51202FA2365341740048A64593359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51209200786235187572EE0D93359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB5120426D474963E08936DD2493359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <bcc98227-b99f-5b2f-1745-922c13fe6089@kernel.org>
 <SJ0PR11MB5120EBCF140B940C8FF712B9933D9@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51209DA3F7CAAB45A609633A930A9@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <3f6540b8-aeab-02f8-27bc-d78c9eba588c@kernel.org>
 <PH0PR11MB5096F84F64CF00C996F219DAE4E19@PH0PR11MB5096.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <PH0PR11MB5096F84F64CF00C996F219DAE4E19@PH0PR11MB5096.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/22 3:13 AM, Pudak, Filip wrote:
> Hi David,
> 
> So we end up in ip6_pkt_discard -> ip6_pkt_drop :
> 
> ---
> if (netif_is_l3_master(skb->dev) &&
> 	    dst->dev == net->loopback_dev)

That's a bug. I can not think of a case where those 2 conditions will
ever be true at the same time. I think that should '||'


> 		idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
> 	else
> 		idev = ip6_dst_idev(dst);
> 
> 	switch (ipstats_mib_noroutes) {
> 	case IPSTATS_MIB_INNOROUTES:
> 		type = ipv6_addr_type(&ipv6_hdr(skb)->daddr);
> 		if (type == IPV6_ADDR_ANY) {
> 			IP6_INC_STATS(net, idev, IPSTATS_MIB_INADDRERRORS);
> 			break;
> 		}
> 		fallthrough;
> 	case IPSTATS_MIB_OUTNOROUTES:
> 		IP6_INC_STATS(net, idev, ipstats_mib_noroutes);
> 		break;
> 	}
> 
> ---
> What happens in the case where the l3mdev is not used, is that we go into the else branch(idev = ip6_dst_idev(dst);) and then we can see that the counter is incremented on the loopback IF.
> 
> So is the only option that l3mdev should be used or is it strange to expect that the idev where the INNOROUTES should increment is the ingress device by default in this case?
> 

