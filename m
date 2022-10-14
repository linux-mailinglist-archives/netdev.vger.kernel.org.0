Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1627D5FEE48
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 15:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJNNAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 09:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiJNNAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 09:00:52 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538F41974F1
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 06:00:49 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 47E3210000D;
        Fri, 14 Oct 2022 13:00:33 +0000 (UTC)
Message-ID: <b9e25530-e618-421c-922e-b9f2380bc19f@ovn.org>
Date:   Fri, 14 Oct 2022 15:00:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     i.maximets@ovn.org, Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>,
        Simon Horman <simon.horman@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload
 stats
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>
References: <eeb0c590-7364-a00e-69fc-2326678d6bdf@ovn.org>
 <PH0PR13MB4793A85169BB60B8609B192194499@PH0PR13MB4793.namprd13.prod.outlook.com>
 <0aac2127-0b14-187e-0adb-7d6b8fe8cfb1@ovn.org>
 <e71b2bf2-cfd5-52f4-5fd4-1c852f2a8c6c@ovn.org>
 <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com>
 <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
 <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
 <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com>
 <CAM0EoM=zWBzivTkEG7uBJepZ0=OZmiuqDF3RmgdWA=FgznRF6g@mail.gmail.com>
 <CALnP8ZY2M3+m_qrg4ox5pjGJ__CAMKfshD+=OxTHCWc=EutapQ@mail.gmail.com>
 <CAM0EoM=5wqbsOL-ZPkuhQXTJh3pTGqhdDDXuEqsjxEoAapApdQ@mail.gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
In-Reply-To: <CAM0EoM=5wqbsOL-ZPkuhQXTJh3pTGqhdDDXuEqsjxEoAapApdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NEUTRAL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/22 14:32, Jamal Hadi Salim wrote:
> On Fri, Oct 7, 2022 at 1:37 PM Marcelo Leitner <mleitner@redhat.com> wrote:
>>
>> On Fri, Oct 07, 2022 at 11:59:42AM -0400, Jamal Hadi Salim wrote:
>>> On Fri, Oct 7, 2022 at 11:01 AM Marcelo Leitner <mleitner@redhat.com> wrote:
>>>>
> 
> [..]
>>>
>>> It's mostly how people who offload (not sure about OVS) do it;
>>> example some of the switches out there.
>>
>> You mean with OK, DROP, TRAP or GOTO actions, right?
>>
>> Because for PIPE, it has:
>>                 } else if (is_tcf_gact_pipe(act)) {
>>                         NL_SET_ERR_MSG_MOD(extack, "Offload of
>> \"pipe\" action is not supported");
>>                         return -EOPNOTSUPP;
>>
> 
> I thought it was pipe but maybe it is OK(in my opinion that is a bad code
> for just "count"). We have some (at least NIC) hardware folks on the list.

IIRC, 'OK' action will stop the processing for the packet, so it can
only be used as a last action in the list.  But we need to count packets
as a very first action in the list.  So, that doesn't help.

> Note: we could create an alias to PIPE and call it COUNT if it helps.

Will that help with offloading of that action?  Why the PIPE is not
offloadable in the first place and will COUNT be offloadable?

> And yes, in retrospect we should probably have separated out accounting
> from the actions in tc. It makes a lot of sense in s/w - and would work fine for
> modern hardware but when you dont have as many counters as actions
> it's a challenge. Same thing with policers/meters.
> 
> cheers,
> jamal

