Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4536F5FE103
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiJMSWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiJMSWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:22:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1001E163384;
        Thu, 13 Oct 2022 11:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DA0A61902;
        Thu, 13 Oct 2022 18:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A79C433D6;
        Thu, 13 Oct 2022 18:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665684983;
        bh=UC8qjVBhAcbWmNHDpCYDWFXyB9qDYiOhbvM3GKIu1ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZoGYywN0WzUBZslXwMeB9JvVAJgGq7eyddXjjPoem96tqKlb6ZbKzJmf3KERD5hPD
         cb3jQSY3S8Q30n7sVu5QM8dt0BP8OlsPUfFa7/tJv0+x0bCIMLeGnAa5Wggp6rOp1U
         woS5eS61ZA7kwype77SCF7ssN0o6h3qin/Lz8lJG32MxM6R2XNzF9NDUzdLAFlVnlI
         Zej8lhBcZfI5LiwaOd7rId+9vhT8c72u+wqZYYhmvsPo2aWiGHLs5h+MMZLxs3Y4nG
         NjEn7pJdkUTXBJ05Ul44zpXaeuaDS6+1Y4rgBwKgqCQBkQreY+QJbsVV3AdmgzKIR7
         /Eiekv0CRiLhA==
Date:   Thu, 13 Oct 2022 14:16:22 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nicolas.dichtel@6wind.com,
        gnault@redhat.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 17/77] genetlink: hold read cb_lock during
 iteration of genl_fam_idr in genl_bind()
Message-ID: <Y0hV9l0of0eWtvKb@sashalap>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-17-sashal@kernel.org>
 <20221010084946.5d32cd60@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221010084946.5d32cd60@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 08:49:46AM -0700, Jakub Kicinski wrote:
>On Sun,  9 Oct 2022 18:06:54 -0400 Sasha Levin wrote:
>> In genl_bind(), currently genl_lock and write cb_lock are taken
>> for iteration of genl_fam_idr and processing of static values
>> stored in struct genl_family. Take just read cb_lock for this task
>> as it is sufficient to guard the idr and the struct against
>> concurrent genl_register/unregister_family() calls.
>>
>> This will allow to run genl command processing in genl_rcv() and
>> mnl_socket_setsockopt(.., NETLINK_ADD_MEMBERSHIP, ..) in parallel.
>
>Not stable material, please drop.

Will do, thanks!

-- 
Thanks,
Sasha
