Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B4B510279
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352755AbiDZQEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiDZQEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:04:24 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410BF39148;
        Tue, 26 Apr 2022 09:01:16 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23QD4Jhx030290;
        Tue, 26 Apr 2022 09:00:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=Ns64RVPqzj5t8fFzfAwBTaVxmgzfzWvSMQkypzHFSQY=;
 b=VoJsYwyathuslCi7TnqYxzaGxQActrorPTHuJXskaTBt3AuyvzL28dGKlSTOFlZtTAqh
 4MRG6pmR2j61Z/rbWNGyvwbVQdKAz896GYRCZeDfcaz5Ft5necb7DxR2Gcid25kL0lbv
 ugRi6F6DwElLvr91FTjjzYy1iikxIo0qJyQK7V4b6BPA1+IVbdDF5nAN0DL5ubtb4Q/r
 Zd6oRUpwi4ub+sdxyNSD2A1Me0NJCI25R0/Kt/OrzkDbBlETkqBtb2bsAbpbrJLM5b/y
 Z3hWVpkQlOMrUx27YvySK5/5SIkMTl1QBze0R53pdRLsjxCndDXUJT4Kc0tZ9gKHkL6C lQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3fp868arjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 09:00:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Apr
 2022 09:00:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 Apr 2022 09:00:47 -0700
Received: from [10.193.34.141] (unknown [10.193.34.141])
        by maili.marvell.com (Postfix) with ESMTP id 9FF883F7081;
        Tue, 26 Apr 2022 09:00:40 -0700 (PDT)
Message-ID: <23cbe4be-7ced-62da-8fdb-366b726fe10f@marvell.com>
Date:   Tue, 26 Apr 2022 18:00:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101
 Thunderbird/100.0
Subject: Re: [EXT] Re: [PATCH 0/5] net: atlantic: more fuzzing fixes
Content-Language: en-US
To:     Grant Grundler <grundler@chromium.org>,
        Dmitry Bezrukov <dbezrukov@marvell.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        "Yi Chou" <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>
References: <20220418231746.2464800-1-grundler@chromium.org>
 <CANEJEGtaFCRhVBaVtHrQiJvwsuBk3f_4RNTg87CWERHt+453KA@mail.gmail.com>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <CANEJEGtaFCRhVBaVtHrQiJvwsuBk3f_4RNTg87CWERHt+453KA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: JB8P8whE__5bQJcxk04LhDRnwK6mSzrf
X-Proofpoint-GUID: JB8P8whE__5bQJcxk04LhDRnwK6mSzrf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_04,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Grant,

Sorry for the delay, I was on vacation.
Thanks for working on this.

I'm adding here Dmitrii, to help me review the patches.
Dmitrii, here is a full series:

https://patchwork.kernel.org/project/netdevbpf/cover/20220418231746.2464800-1-grundler@chromium.org/

Grant, I've reviewed and also quite OK with patches 1-4.

For patch 5 - why do you think we need these extra comparisons with software head/tail?
From what I see in logic, only the size limiting check is enough there..

Other extra checks are tricky and non intuitive..

Regards,
  Igor

On 4/21/2022 9:53 PM, Grant Grundler wrote:
> External Email
> 
> ----------------------------------------------------------------------
> Igor,
> Will you have a chance to comment on this in the near future?
> Should someone else review/integrate these patches?
> 
> I'm asking since I've seen no comments in the past three days.
> 
> cheers,
> grant
> 
> 
> On Mon, Apr 18, 2022 at 4:17 PM Grant Grundler <grundler@chromium.org> 
> wrote:
>>
>> The Chrome OS fuzzing team posted a "Fuzzing" report for atlantic driver
>> in Q4 2021 using Chrome OS v5.4 kernel and "Cable Matters
>> Thunderbolt 3 to 10 Gb Ethernet" (b0 version):
>>
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__docs.google.com_document_d_e_2PACX-2D1vT4oCGNhhy-5FAuUqpu6NGnW0N9HF-5Fjxf2kS7raOpOlNRqJNiTHAtjiHRthXYSeXIRTgfeVvsEt0qK9qK_pub&d=DwIBaQ&c=nKjWec2b6R0mOyPaz7xtfQ&r=3kUjVPjrPMvlbd3rzgP63W0eewvCq4D-kzQRqaXHOqU&m=QoxR8WoQQ-hpWu_tThQydP3-6zkRWACvRmj_7aY1qo2FG6DdPdI86vAYrfKQFMHX&s=620jqeSvQrGg6aotI35cWwQpjaL94s7TFeFh2cYSyvA&e=
>>
>> It essentially describes four problems:
>> 1) validate rxd_wb->next_desc_ptr before populating buff->next
>> 2) "frag[0] not initialized" case in aq_ring_rx_clean()
>> 3) limit iterations handling fragments in aq_ring_rx_clean()
>> 4) validate hw_head_ in hw_atl_b0_hw_ring_tx_head_update()
>>
>> I've added one "clean up" contribution:
>>     "net: atlantic: reduce scope of is_rsc_complete"
>>
>> I tested the "original" patches using chromeos-v5.4 kernel branch:
>>
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__chromium-2Dreview.googlesource.com_q_hashtag-3Apcinet-2Datlantic-2D2022q1-2B-28status-3Aopen-2520OR-2520status-3Amerged-29&d=DwIBaQ&c=nKjWec2b6R0mOyPaz7xtfQ&r=3kUjVPjrPMvlbd3rzgP63W0eewvCq4D-kzQRqaXHOqU&m=QoxR8WoQQ-hpWu_tThQydP3-6zkRWACvRmj_7aY1qo2FG6DdPdI86vAYrfKQFMHX&s=1a1YwJqrY-be2oDgGAG5oOyZDnqIok_2p5G-N8djo2I&e=
>>
>> The fuzzing team will retest using the chromeos-v5.4 patches and the b0 
>> HW.
>>
>> I've forward ported those patches to 5.18-rc2 and compiled them but am
>> currently unable to test them on 5.18-rc2 kernel (logistics problems).
>>
>> I'm confident in all but the last patch:
>>    "net: atlantic: verify hw_head_ is reasonable"
>>
>> Please verify I'm not confusing how ring->sw_head and ring->sw_tail
>> are used in hw_atl_b0_hw_ring_tx_head_update().
>>
>> Credit largely goes to Chrome OS Fuzzing team members:
>>     Aashay Shringarpure, Yi Chou, Shervin Oloumi
>>
>> cheers,
>> grant
