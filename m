Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FF360467B
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiJSNLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiJSNK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:10:58 -0400
X-Greylist: delayed 1451 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Oct 2022 05:55:40 PDT
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [IPv6:2001:4b98:dc4:8::240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A141A14DF07
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 05:55:39 -0700 (PDT)
Received: from relay5-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::225])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id B8F6FC15F4
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:19:10 +0000 (UTC)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 7A8781C0012;
        Wed, 19 Oct 2022 12:17:43 +0000 (UTC)
Message-ID: <ef15dc87-7e70-55f5-7736-535b4e0a5d5c@ovn.org>
Date:   Wed, 19 Oct 2022 14:17:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Cc:     i.maximets@ovn.org, Marcelo Leitner <mleitner@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
References: <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com>
 <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
 <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
 <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com>
 <CAM0EoM=zWBzivTkEG7uBJepZ0=OZmiuqDF3RmgdWA=FgznRF6g@mail.gmail.com>
 <CALnP8ZY2M3+m_qrg4ox5pjGJ__CAMKfshD+=OxTHCWc=EutapQ@mail.gmail.com>
 <CAM0EoM=5wqbsOL-ZPkuhQXTJh3pTGqhdDDXuEqsjxEoAapApdQ@mail.gmail.com>
 <b9e25530-e618-421c-922e-b9f2380bc19f@ovn.org>
 <CAM0EoMkFhGtT5t0103V=h0YVddBrkwiAngP7BZY-vStijUVvtw@mail.gmail.com>
 <Y0+xh2V7KUMRPaUI@corigine.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload
 stats
In-Reply-To: <Y0+xh2V7KUMRPaUI@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/22 10:12, Simon Horman wrote:
> On Fri, Oct 14, 2022 at 10:40:30AM -0400, Jamal Hadi Salim wrote:
>> On Fri, Oct 14, 2022 at 9:00 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>>>
>>
>> [..]
>>>> I thought it was pipe but maybe it is OK(in my opinion that is a bad code
>>>> for just "count"). We have some (at least NIC) hardware folks on the list.
>>>
>>> IIRC, 'OK' action will stop the processing for the packet, so it can
>>> only be used as a last action in the list.  But we need to count packets
>>> as a very first action in the list.  So, that doesn't help.
>>>
>>
>> That's why i said it is a bad code - but i believe it's what some of
>> the hardware
>> people are doing. Note: it's only bad if you have more actions after because
>> it aborts the processing pipeline.
>>
>>>> Note: we could create an alias to PIPE and call it COUNT if it helps.
>>>
>>> Will that help with offloading of that action?  Why the PIPE is not
>>> offloadable in the first place and will COUNT be offloadable?
>>
>> Offloadable is just a semantic choice in this case. If someone is
>> using OK to count  today - they could should be able to use PIPE
>> instead (their driver needs to do some transformation of course).
> 
> FWIIW, yes, that is my thinking too.

I don't know that code well, but I thought that tcf_gact_offload_act_setup()
is a generic function.  And since it explicitly forbids offload of PIPE
action, no drivers can actually offload it even if they want to.
So it's not really a driver's choice in the current kernel code.  Or am I
missing something?

Best regards, Ilya Maximets.
