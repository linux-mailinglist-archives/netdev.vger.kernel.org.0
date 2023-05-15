Return-Path: <netdev+bounces-2460-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E860C702132
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 03:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13CC6280FA4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 01:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30EFA1118;
	Mon, 15 May 2023 01:37:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204F710EA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 01:37:46 +0000 (UTC)
X-Greylist: delayed 67 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 May 2023 18:37:40 PDT
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4F9E5B
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 18:37:39 -0700 (PDT)
X-QQ-mid: bizesmtp66t1684114585tz8pw4hf
Received: from smtpclient.apple ( [115.200.228.151])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 15 May 2023 09:36:24 +0800 (CST)
X-QQ-SSF: 00400000000000N0Z000000A0000000
X-QQ-FEAT: HMFEffFGMPFsiQEE4f2CDJsbXlZTG/15kpEQB/plvCRPzUalalk3VRfTrDHgt
	FO2tkQpeiSURr6wLxwcVtBSi2Oy/2rK0HgfE3lJUMwtXthk89S+b1ZDGijmIlgeXWLu289A
	vebjQRDz6xQArPB0zEzHsMIAmiwKNqz5WnHCowNyK9cWmKKqxKEOIZSiQOWQWyiKAGORpJi
	exszzkDyk+IZeh7SXnbtH/mqmxVVstKVHTekSez5DLkqpsLpEK4tOI7G1qadweiq+KSu20g
	WHwiGyKBUuqhQTkuDTQIyu7auClym7CgTe0MRQTjBWe9Dq++h8bnxfI93a1rxyVB4+31e5K
	2S0GB8hqsy3JgJw/3oHRCIyFcVFv6GF9r0/EJljuAcMeqDMfrNROEcz/E5B7bcxvcLcfCnW
	YKizPb2EGjU=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 2430332159841464334
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH net-next v4 2/7] net: wangxun: libwx add rx offload
 functions
From: "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <9715EEB3-0BAD-4D01-A0FA-101B3346F34C@net-swift.com>
Date: Mon, 15 May 2023 09:36:13 +0800
Cc: Yunsheng Lin <linyunsheng@huawei.com>,
 netdev@vger.kernel.org,
 Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5C7C50E0-9014-4D01-8620-F7D8461E7919@net-swift.com>
References: <20230510093845.47446-1-mengyuanlou@net-swift.com>
 <20230510093845.47446-3-mengyuanlou@net-swift.com>
 <b26664c9-7df9-f2dc-ca49-3e5abd3dab70@huawei.com>
 <25FF2886-3FE3-4B20-9A77-217ADE6502B8@net-swift.com>
 <06898ce3-3995-2e83-3b2b-97f92fa46d7c@huawei.com>
 <4AB10E12-CFA2-4879-9346-8C73E926B706@net-swift.com>
 <070f4c8b-c208-9701-7d17-6a2bd2c470f0@huawei.com>
 <9715EEB3-0BAD-4D01-A0FA-101B3346F34C@net-swift.com>
To: mengyuanlou@net-swift.com
X-Mailer: Apple Mail (2.3731.500.231)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sorry=EF=BC=8CI mistook wx_decode_ptype and wx_ptype_lookup.

> 2023=E5=B9=B45=E6=9C=8815=E6=97=A5 09:31=EF=BC=8Cmengyuanlou@net-swift.c=
om =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
>> 2023=E5=B9=B45=E6=9C=8812=E6=97=A5 19:41=EF=BC=8CYunsheng Lin =
<linyunsheng@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>>=20
>> On 2023/5/12 14:00, mengyuanlou@net-swift.com wrote:
>>>> 2023=E5=B9=B45=E6=9C=8811=E6=97=A5 19:48=EF=BC=8CYunsheng Lin =
<linyunsheng@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>=20
>>>> On 2023/5/11 16:34, mengyuanlou@net-swift.com wrote:
>>>>>>> @@ -321,8 +321,31 @@
>>>>>>=20
>>>>>> ...
>>>>>>=20
>>>>>>> +
>>>>>>> +static inline struct wx_dec_ptype wx_decode_ptype(const u8 =
ptype)
>>>>>>=20
>>>>>> If the above is only used in one .c file, maybe it does not need
>>>>>> to be in the .h file?
>>>>>=20
>>>>> If I put it to .c file which use it, when compiling the other .c =
files will say
>>>>> "warning: =E2=80=98wx_ptype_lookup=E2=80=99 defined but not =
used=E2=80=9D.
>>>>=20
>>>> Is 'wx_ptype_lookup' used in other .c file? if not, why not move
>>>> it to .c file too?
>>>>=20
>>> I mean how to you fix this compile warning.
>>=20
>> Doesn't moving wx_decode_ptype() and wx_ptype_lookup to the
>> same C file solve the problem?
>>=20
> Yeah=EF=BC=8C
> Put it in .h do not has the problem.
> Put it in C file, it comes.=20
>>>=20
>>>>>>=20
>>>>>>> +{
>>>>>>> + return wx_ptype_lookup[ptype];
>>>>>>> +}
>>>>>>> +
>>>>=20
>>>=20
>>>=20
>>> .



