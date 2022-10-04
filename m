Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73D25F42F8
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 14:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJDMeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 08:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJDMeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 08:34:00 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A171927DF6
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 05:33:56 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id A88221BF20D;
        Tue,  4 Oct 2022 12:33:51 +0000 (UTC)
Message-ID: <0eb1ea78-d1a1-b085-fa36-c1ca0a0d9549@ovn.org>
Date:   Tue, 4 Oct 2022 14:33:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Cc:     i.maximets@ovn.org, network dev <netdev@vger.kernel.org>,
        davem@davemloft.net, kuba@kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Eelco Chaudron <echaudro@redhat.com>
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>, Paolo Abeni <pabeni@redhat.com>
References: <cover.1663946157.git.lucien.xin@gmail.com>
 <4781b55b0b7498c574ace703a1481e3688e3f18d.1663946157.git.lucien.xin@gmail.com>
 <52ae3eb45615c5d68a955e9a22f5f4915edc4e23.camel@redhat.com>
 <CADvbK_eJk_mRp7V4n1JTa5p3FhvqNUK5+yoocQeYskM7z0ioNA@mail.gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net-next 2/2] net: sched: add helper support in act_ct
In-Reply-To: <CADvbK_eJk_mRp7V4n1JTa5p3FhvqNUK5+yoocQeYskM7z0ioNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/22 17:04, Xin Long wrote:
> On Tue, Sep 27, 2022 at 6:29 AM Paolo Abeni <pabeni@redhat.com> wrote:
>>
>> On Fri, 2022-09-23 at 11:28 -0400, Xin Long wrote:
>>> This patch is to add helper support in act_ct for OVS actions=ct(alg=xxx)
>>> offloading, which is corresponding to Commit cae3a2627520 ("openvswitch:
>>> Allow attaching helpers to ct action") in OVS kernel part.
>>>
>>> The difference is when adding TC actions family and proto cannot be got
>>> from the filter/match, other than helper name in tb[TCA_CT_HELPER_NAME],
>>> we also need to send the family in tb[TCA_CT_HELPER_FAMILY] and the
>>> proto in tb[TCA_CT_HELPER_PROTO] to kernel.
>>>
>>> Note when calling helper->help() in tcf_ct_act(), the packet will be
>>> dropped if skb's family and proto do not match the helper's.
>>>
>>> Reported-by: Ilya Maximets <i.maximets@ovn.org>
>>
>> This tag is a bit out of place here, as it should belong to fixes. Do
>> you mean 'Suggested-by' ?
> This one was reported as an OVS bug, but from TC side, it's a feature.

My 2c:
- The fact that act_ct doesn't execute helpers attached to skb outside
  of TC (in OVS) can be considered as a bug.
- The ability to set helpers in act_ct itself is indeed a new feature.

Though it was decided to implement both things at the same time to
avoid confusion around what is supported and what is not supported,
especially since there will be no meaningful way to detect if the bug
actually fixed in the kernel or not.

CC: Eelco.

P.S. might also make sense to CC: ovs-dev on a next revision for visibility.

Best regards, Ilya Maximets.
