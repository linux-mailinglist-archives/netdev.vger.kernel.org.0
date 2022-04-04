Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF0B4F17F9
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 17:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378434AbiDDPLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 11:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238001AbiDDPLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 11:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEC31263C;
        Mon,  4 Apr 2022 08:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB1A0615B5;
        Mon,  4 Apr 2022 15:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2849C340EE;
        Mon,  4 Apr 2022 15:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649084983;
        bh=BWDMZT5MsnbaX8sYS7b8jZF3jfpkUR2RMrgmsUgYSAQ=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=V06joN+06bBR1JkcLJvQixcfa0SoyM2wR/CA4iZVFHSruxOVAzEGxRVcU2P3qcihF
         6mFMgFZ/lS9oSDCOZTqG9UMV4G9wygWKU/PLOtMHxQ82PC0pZR/J7/3OlmZPTujNk6
         07Csiex+hGdEdE9H9Si2bdgMzoJqKRbgsjhDQHOqb/rjTDkcUGiLB/ru5iR6gE2BNq
         U3VZHw9k89VQPBQnkw4RpiaiVklfB8gB/XC5T5VNxhrFeouLi915YwCiDcA+reyGTf
         /JjijME2pAs6mZTc0dWS1ux7zsWQb36O6AT+ArrC6F6PAHp5W3WOq+a4kHKlzIcIgl
         PyzSNEoj0IkpQ==
Message-ID: <284ba579-7d5a-2bf4-2640-951d5e5829b6@kernel.org>
Date:   Mon, 4 Apr 2022 09:09:40 -0600
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
 <47987a0e-0626-04f8-b181-ff3bc257a269@kernel.org>
 <PH0PR11MB50964D048E779CD7B71088F6E4E59@PH0PR11MB5096.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <PH0PR11MB50964D048E779CD7B71088F6E4E59@PH0PR11MB5096.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/22 1:09 AM, Pudak, Filip wrote:
> It was indeed a bug. We've retested with '||' and the counter is incremented properly.
> 
> How do we go about including this change to the kernel? Will you perform the update?

patch sent.
