Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4076C6666E7
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 00:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbjAKXBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 18:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjAKXBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 18:01:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F6A2C5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 15:01:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6303AB81D88
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 23:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FD7C433D2;
        Wed, 11 Jan 2023 23:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673478092;
        bh=frremfa0EWqHtX4V5QR9fo/JSeIQfqkkRx7rTgDWDsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=edyTABloK0VDdbLS9fee4LgidPqaN+dUNiTXN0jTzC05il1CHQo7yMpzFCSRst7j9
         zL+gbWNevMX/xJtlVHHMjtQw2FbVMw0+LE77t5/YlN/vzrb6uRLFZ4AojJr6jJyFeH
         SiS4IrH/jet9ElyCqG+4BscigEXLWudjY0Bo/kpeMXdee3owQ0VsJRexzYSpB73nMN
         57j42KgXnfq+cmvLGoqRpWlmEP7e8fQL3PUmJWI/Ld1MWr0kDmgEdWELdKwTtBYyf/
         A5kGBsCwBJJzT2g5PS2eoolJQJz8MM5x9fGGipVzG+L+ec2QXX4C5gwM/tf3Hnt4Jd
         tfnYfo026+KtQ==
Date:   Wed, 11 Jan 2023 15:01:31 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: Add hairpin debugfs files
Message-ID: <Y78/y0cBQ9rmk8ge@x130>
References: <20230111053045.413133-1-saeed@kernel.org>
 <20230111053045.413133-9-saeed@kernel.org>
 <20230111103422.102265b3@kernel.org>
 <Y78gEBXP9BuMq09O@x130>
 <20230111130342.6cef77d7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230111130342.6cef77d7@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11 Jan 13:03, Jakub Kicinski wrote:
>On Wed, 11 Jan 2023 12:46:08 -0800 Saeed Mahameed wrote:
>> On 11 Jan 10:34, Jakub Kicinski wrote:
>> >On Tue, 10 Jan 2023 21:30:38 -0800 Saeed Mahameed wrote:
>> >> +	debugfs_create_file("hairpin_num_queues", 0644, tc->dfs_root,
>> >> +			    &tc->hairpin_params, &fops_hairpin_queues);
>> >> +	debugfs_create_file("hairpin_queue_size", 0644, tc->dfs_root,
>> >> +			    &tc->hairpin_params, &fops_hairpin_queue_size);
>> >
>> >debugfs should be read-only, please LMK if I'm missing something,
>> >otherwise this series is getting reverted
>>
>> I remember asking you about this and you said it's ok to use write for
>> debug features, this is needed for debugging performance bottlenecks.
>
>FWIW I don't think this fits into the debug exemption. What I meant by
>debug was stuff like write to configure what traces or debug features
>of the chip are enabled. This falls into configuration, even if it's
>not expected to be tweaked by users.
>

I see.

>> hairpin + steering performance behaves differently between different
>> hardware versions and under different NIC/E-Switch configs, so it's really
>> important to have some control on some of these attributes when debugging.
>
>Can you expand on the use of this params when debugging? AFAICT these
>configure the RQ/SQ pairs (count and size) so really the only
>"debugging" you can do here is change the config and see if it fixes
>performance...

it's more of understanding the performance effects and characteristics when
combined with other steering configs depending on the HW and current
topology, i don't have exact examples, but usually the debug ends up with
optimizing other places (steering, Firmware, application at the
other end, etc .. )

Sorry i don't have much details here, Maybe Gal can chime in.. 
but what i am sure of is changing the hairpin RQ/SQ configs comes
with a risk.

>
>> Our dilemma was either to use devlink vendor params or a debug interface,
>> since we are pretty sure that our NIC hairpin implementation
>> is unique as it uses software constructs (RQs/SQs) managed internally
>> by Firmware for abstraction of a TC redirect action, thus the only place
>> for this is either devlink vendor params or debugfs, we chose debugfs since
>> we want to keep this for debug purposes on production systems.
>>
>> we also considered extending TC but again since this is unique to CX
>> architecture of the current chips, we didn't want to pollute TC.
>>
>> Also devlink resource wasn't a good match since these resources don't
>> exist until a TC redirect action is offloaded.
>>
>> Please let me know what you think and whether this is acceptable by you.
>
>I don't know of any other devices which need the hairpin setup
>so I won't push for a common API. But we *do* need to list these
>tunables somewhere because my ability to grep them out of mlx5 when
>another vendor comes with the same problem will be very limited.
>Which is one of the reasons why devlink params have to be documented.

Then let's create https://docs.kernel.org/networking/vendor_specific.rst
and record all vendor specific dump in there, including devlink and
ethtool private flags.
once we find a common behavior, it means this should move to be standard? 

>Plus IIRC you already have the EQ configuration via params.

EQ is considered standard parameter in devlink.

We currently have 2 vendor specific params and they are related to
steering pipeline/engines only.
hairpin buffer/queue sizes is only a CX limitation, and implementation
detail.

you can clearly see a pattern here, usually the steering pipeline
requires vendor specific knobs :/ ..

Will you be ok if we moved hairpin config to devlink driver specific param
? given that we will create the vendor_specific.rst for easy tracking and
grepping.

Thanks,
Saeed.
