Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788966E87CF
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjDTCFq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Apr 2023 22:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbjDTCFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:05:45 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9962F3C31
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 19:05:41 -0700 (PDT)
X-QQ-mid: bizesmtp74t1681956334tk67uxgo
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 20 Apr 2023 10:05:32 +0800 (CST)
X-QQ-SSF: 00400000000000N0R000000A0000000
X-QQ-FEAT: V7Dl5UGFBQ9mZPmBCUpVnasHreIW5SxFjloy5ITduhxZg/OfA9DGbZtsUmLF+
        wgch2egBvtWV+AHDaSpUNI6Q2Q4iso+RVYhnnPPQIv1LHxUXStcT/ri/g42KRhuDSmfkdWM
        esVELpHqxFydKlAcNZvuK8S7IlTGL/qF76d4Mg/KQRHjN5SQJcrr80C+cPgwua3/fpa0jZf
        Ixnkk4/QTuUcGSHfYIO8DzA5yzwk8j1mJApxJG1CgRWmGcViHANTHzFBy7n4K3mK7RbtYT3
        pM/Vmz4Y1MAMeKUSf3aL9izRs8ukVnhAbvdfwwnZ4Tfpl5TEllsrCJZIO12Hu4UesbbdpP1
        glfdJFa4g5A2E5EzMENvYP4mSe4tJDcze9Ui+1VffRQaJl4X9Xm/tXd0BRXiMsMmk+XsBC5
        v7VEGburDJA=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 6372937594665590060
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: [PATCH net-next v2 1/5] net: wangxun: libwx add tx offload
 functions
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <a0ea9822-695b-df3f-c95f-766ef5b3f6a9@huawei.com>
Date:   Thu, 20 Apr 2023 10:05:22 +0800
Cc:     netdev@vger.kernel.org, Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E5EED9F4-A094-417A-8CBC-0A1C022263B3@net-swift.com>
References: <20230417105457.82127-1-mengyuanlou@net-swift.com>
 <20230417105457.82127-2-mengyuanlou@net-swift.com>
 <630e590e-fac3-5f69-688e-ac140ab3464e@huawei.com>
 <4E862584-755D-4EC4-9588-DB0B14D64CD5@net-swift.com>
 <82c37bb4-b2b0-037a-7f63-71324f493e1d@huawei.com>
 <1996D963-EFD9-420E-BEE2-E29B83F3811B@net-swift.com>
 <a0ea9822-695b-df3f-c95f-766ef5b3f6a9@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2023年4月19日 20:40，Yunsheng Lin <linyunsheng@huawei.com> 写道：
> 
> On 2023/4/19 10:27, mengyuanlou@net-swift.com wrote:
>> 
>> 
>>> 2023年4月18日 20:11，Yunsheng Lin <linyunsheng@huawei.com> 写道：
>>> 
>>> On 2023/4/18 15:00, mengyuanlou@net-swift.com wrote:
>>>>>> + goto exit;
>>>>>> + case htons(ETH_P_ARP):
>>>>>> + ptype = WX_PTYPE_L2_ARP;
>>>>>> + goto exit;
>>>>>> + default:
>>>>>> + ptype = WX_PTYPE_L2_MAC;
>>>>> 
>>>>> Is it ok to set ptype to WX_PTYPE_L2_MAC for first->protocol != ETH_P_IP
>>>>> && first->protocol != ETH_P_IPV6? Does hw need to do checksum/tso or other thing
>>>>> about those packet? if not, setting WX_PTYPE_L2_MAC seems enough?
>>>>> 
>>>>   • The hardware needs to parse these packets with these ptype bits.
>>> 
>>> What does hw do after parsing these packets? Updating some stats according to
>>> the protocol type?
>>> It seems really related to hw implementation, I am just curious if it is worth
>>> the added overhead for driver.
>>> 
>> For ETH_P_1588 hw will add timestamp for packets. 
> 
> I am not quite familiar with 1588, but does stack not set the SKBTX_HW_TSTAMP
> in skb_shinfo(skb)->tx_flags when hw timestamp is required?
> 
>> The others are used to loopback scene, because hw can not parse l2 type.
> 
> I suppose that is for sriov loopback case where one function send packet
> to another function under the same PF?
> 
> For the above case, hw just copy the packet type from tx desc to rx desc
> without parsing the packet and assuming the driver always put the correct
> packet type? I am not sure it is safe to assume that driver always put the
> correct packet type, as the driver can be in a vm which may not be trustworthy?
> If this happens, I am also not sure if this may cause problem for other
> vm using different VF under the same PF?

Not for VF/PF scene，I just want to know it cost。
The others will be removed。
> 
>> 
>> According to chip designers, the others are not necessary.
>> Does it really cost a a lot for driver? 
>> Thanks.
>> 
>> 
>> .


