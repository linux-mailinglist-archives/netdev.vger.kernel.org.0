Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3624D27FF
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiCIEvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 23:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiCIEvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 23:51:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825E615C195;
        Tue,  8 Mar 2022 20:50:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC5DC61868;
        Wed,  9 Mar 2022 04:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982F5C340E8;
        Wed,  9 Mar 2022 04:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646801404;
        bh=WQ/YZjIqZMFWalzvcOneuAQWvznNpPEfrFfdBo4ciiI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SVevin0TR+8xb+HZXMkZExpjDPA1CROLW9T46rfw5d77tJctCHompabjR7CT4Wm9r
         nMayEdUiHGcHsC6KWbvaXAis64KWGc5D1FB3Olbvr/0DkOSE7gXa+TYTk16pk2VFuT
         g3ggGtGiRn7xNuVLymWzd2t3D2UDj9pIdPynDqcUMaOiwaBh6sJMy5fQZkwwN0wx7f
         dIHbxAYSH5H40yXCV9N3RBBTYfyhjQ6WMKZU6TcQD8qJmv/HrR3zDR2OAEFiBcQvVa
         DwunNSA18K+fMQElB5kQ9/qyplxH5W6ds37hYEWSMlOk0S2DcGrJttxGEjmwtvzk9h
         pgmvj3TWfjjGQ==
Message-ID: <3f6540b8-aeab-02f8-27bc-d78c9eba588c@kernel.org>
Date:   Tue, 8 Mar 2022 21:50:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: This counter "ip6InNoRoutes" does not follow the RFC4293
 specification implementation
Content-Language: en-US
To:     "Xiao, Jiguang" <Jiguang.Xiao@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Pudak, Filip" <Filip.Pudak@windriver.com>
References: <SJ0PR11MB51207CBDB5145A89B8A0A15393359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51202FA2365341740048A64593359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51209200786235187572EE0D93359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB5120426D474963E08936DD2493359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <bcc98227-b99f-5b2f-1745-922c13fe6089@kernel.org>
 <SJ0PR11MB5120EBCF140B940C8FF712B9933D9@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51209DA3F7CAAB45A609633A930A9@SJ0PR11MB5120.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <SJ0PR11MB51209DA3F7CAAB45A609633A930A9@SJ0PR11MB5120.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 7:16 PM, Xiao, Jiguang wrote:
> Hi David
> 
> To confirm whether my test method is correct, could you please briefly describe your test procedure? 
> 
> 
> 

no formal test. Code analysis (ip6_pkt_discard{,_out} -> ip6_pkt_drop)
shows the counters that should be incrementing and then looking at the
counters on a local server.

FIB Lookup failures should generate a dst with one of these handlers:

static void ip6_rt_init_dst_reject(struct rt6_info *rt, u8 fib6_type)
{
        rt->dst.error = ip6_rt_type_to_error(fib6_type);

        switch (fib6_type) {
        case RTN_BLACKHOLE:
                rt->dst.output = dst_discard_out;
                rt->dst.input = dst_discard;
                break;
        case RTN_PROHIBIT:
                rt->dst.output = ip6_pkt_prohibit_out;
                rt->dst.input = ip6_pkt_prohibit;
                break;
        case RTN_THROW:
        case RTN_UNREACHABLE:
        default:
                rt->dst.output = ip6_pkt_discard_out;
                rt->dst.input = ip6_pkt_discard;
                break;
        }
}

They all drop the packet with a given counter bumped.
