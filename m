Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4D96BF94
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 18:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfGQQ0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 12:26:00 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34762 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfGQQ0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 12:26:00 -0400
Received: by mail-io1-f67.google.com with SMTP id k8so46774822iot.1;
        Wed, 17 Jul 2019 09:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q85Vqz3W3GGbylK1esF8kHL+MDaJe7lgEUVgXvvv680=;
        b=UIZqLy36FrzuqzlSij4fpKHyCDQbyeWmZivDxFkWEHq6TiXCi050zbeQLW+BZ21cCq
         L//0M6e6DLd9c+44KMMxoX01rjvpVgjJc8kSNT6uNMOZFHqwXLgWaGf7J8gAlYN0TBPf
         ySMjgAl2sLyKhIBiDlHlih7OV2WUb1PWSGAgZw8j5NrVE88STnXefzpk7FWqfJye9IGp
         b+u5Ch3Z7YpQmK7zB8TCHps2EAA4DmQKjmho25XfVU9gq3v2m5Ww+LobYQVDUz9ba4Fw
         y2gPW9/RCpphkL83XWalymMZR9vwhPwXmdvZsRiMPuI6KVOEnDz3J3O8NQhXtP0k2Ayg
         mFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q85Vqz3W3GGbylK1esF8kHL+MDaJe7lgEUVgXvvv680=;
        b=ukCntUIAtWNPd/wltpQwNCURn6sIKovh7aR8cP3GzKw5qj4rcMspoopm877fc6nX9e
         bHlPfVFjmzjBTxOXJSx6qymvkatirUUNBfIDAAJwFXiHRONtzm05Py8RvwC5O2QB2Ydo
         g4cEDb8uRGAv6+gt9Ws6PpBaqrvJP3aQtO9OYvshm572vTasepnEEZDwXDvtuZGVG8Am
         pQnBrI4IPfTRvvulHQAeDRbK8jVl5z/tQHRRA3pVf9TswHT7/2feRhcKiz9SkMJ+CIMv
         Wdgfg4RDStK+/7JNQ+HW/eXx1CxvZDGcAIHrrW0xWgTs9yClXFodg8nziIXbU98berg2
         S9lg==
X-Gm-Message-State: APjAAAXovKHeBcNvLOODf9HNNZmTEe8834h0vLDk2bDwfvGhtaEVQU0d
        F56yIE3BcAV0pmzkhxvdl2RHwPbgs69MFjb5y31yJ1KS
X-Google-Smtp-Source: APXvYqwNeyrP61LXt+3XiReh2rpcBk7k2Hir60riIrD3lHk0660TDaWEorO+QAW82L9mtPy2hcFVi3ISWDfPEdKO1IY=
X-Received: by 2002:a5d:9d58:: with SMTP id k24mr37098017iok.116.1563380759162;
 Wed, 17 Jul 2019 09:25:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190716115910.23093-1-iii@linux.ibm.com> <CAH3MdRWGVDjW8cA9EbnFjK8ko1EqeyDyC_LoRTsxhLsYn1fZtw@mail.gmail.com>
 <CAH3MdRU-u1Gn6uj2D=mzXvdC2RDWas3Ec0QXObKsLac1GwuREQ@mail.gmail.com>
 <98C6AA13-A44D-4FF1-BA73-1BD446BD773A@linux.ibm.com> <4311B5C3-8D1B-4958-9CDE-450662A7851D@linux.ibm.com>
In-Reply-To: <4311B5C3-8D1B-4958-9CDE-450662A7851D@linux.ibm.com>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 17 Jul 2019 09:25:23 -0700
Message-ID: <CAH3MdRV-qsJnyZVV1GnxRZ4=3KXTvKSgETp90fyevxycmAiHmA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix narrower loads on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 17, 2019 at 3:36 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> > Am 17.07.2019 um 11:21 schrieb Ilya Leoshkevich <iii@linux.ibm.com>:
> >
> >> Am 17.07.2019 um 07:11 schrieb Y Song <ys114321@gmail.com>:
> >>
> >> [sorry, resend again as previous one has come text messed out due to
> >> networking issues]
> >>
> >> On Tue, Jul 16, 2019 at 10:08 PM Y Song <ys114321@gmail.com> wrote:
> >>>
> >>> On Tue, Jul 16, 2019 at 4:59 AM Ilya Leoshkevich <iii@linux.ibm.com> =
wrote:
> >>>>
> >>>> test_pkt_md_access is failing on s390, since the associated eBPF pro=
g
> >>>> returns TC_ACT_SHOT, which in turn happens because loading a part of=
 a
> >>>> struct __sk_buff field produces an incorrect result.
> >>>>
> >>>> The problem is that when verifier emits the code to replace partial =
load
> >>>> of a field with a full load, a shift and a bitwise AND, it assumes t=
hat
> >>>> the machine is little endian.
> >>>>
> >>>> Adjust shift count calculation to account for endianness.
> >>>>
> >>>> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program co=
ntext fields")
> >>>> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> >>>> ---
> >>>> kernel/bpf/verifier.c | 8 ++++++--
> >>>> 1 file changed, 6 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> >>>> index 5900cbb966b1..3f9353653558 100644
> >>>> --- a/kernel/bpf/verifier.c
> >>>> +++ b/kernel/bpf/verifier.c
> >>>> @@ -8616,8 +8616,12 @@ static int convert_ctx_accesses(struct bpf_ve=
rifier_env *env)
> >>>>               }
> >>>>
> >>>>               if (is_narrower_load && size < target_size) {
> >>>> -                       u8 shift =3D (off & (size_default - 1)) * 8;
> >>>> -
> >>>> +                       u8 load_off =3D off & (size_default - 1);
> >>>> +#ifdef __LITTLE_ENDIAN
> >>>> +                       u8 shift =3D load_off * 8;
> >>>> +#else
> >>>> +                       u8 shift =3D (size_default - (load_off + siz=
e)) * 8;
> >>>> +#endif
> >>>
> >> All the values are in register. The shifting operations should be the
> >> same for big endian and little endian, e.g., value 64 >> 2 =3D 16 when
> >> value "64" is in register. So I did not see a problem here.
> >>
> >> Could you elaborate which field access in test_pkt_md_access
> >> caused problem?
> >
> > The very first one: TEST_FIELD(__u8,  len, 0xFF);
> >
> >> It would be good if you can give detailed memory layout and register v=
alues
> >> to illustrate the problem.
> >
> > Suppose len =3D 0x11223344. On a big endian system, this would be
> >
> > 11 22 33 44
> >
> > Now, we would like to do *(u8 *)&len, the desired result is 0x11.
> > Verifier should emit the following: ((*(u32 *)&len) >> 24) & 0xff, but =
as
> > of today it misses the shift.
> >
> > On a little endian system the layout is:
> >
> > 44 33 22 11
> >
> > and the desired result is different - 0x44. Verifier correctly emits
> > (*(u32 *)&len) & 0xff.
>
> I=E2=80=99ve just realized, that this example does not reflect what the t=
est is
> doing on big-endian systems (there is an #ifdef for those).
>
> Here is a better one: len=3D0x11223344 and we would like to do
> ((u8 *)&len)[3].
>
> len is represented as `11 22 33 44` in memory, so the desired result is
> 0x44. It can be obtained by doing (*(u32 *)&len) & 0xff, but today the
> verifier does ((*(u32 *)&len) >> 24) & 0xff instead.

What you described above for the memory layout all makes sense.
The root cause is for big endian, we should do *((u8 *)&len + 3).
This is exactly what macros in test_pkt_md_access.c tries to do.

if  __BYTE_ORDER__ =3D=3D __ORDER_LITTLE_ENDIAN__
#define TEST_FIELD(TYPE, FIELD, MASK)                                   \
        {                                                               \
                TYPE tmp =3D *(volatile TYPE *)&skb->FIELD;               \
                if (tmp !=3D ((*(volatile __u32 *)&skb->FIELD) & MASK))   \
                        return TC_ACT_SHOT;                             \
        }
#else
#define TEST_FIELD_OFFSET(a, b) ((sizeof(a) - sizeof(b)) / sizeof(b))
#define TEST_FIELD(TYPE, FIELD, MASK)                                   \
        {                                                               \
                TYPE tmp =3D *((volatile TYPE *)&skb->FIELD +             \
                              TEST_FIELD_OFFSET(skb->FIELD, TYPE));     \
                if (tmp !=3D ((*(volatile __u32 *)&skb->FIELD) & MASK))   \
                        return TC_ACT_SHOT;                             \
        }
#endif

Could you check whether your __BYTE_ORDER__ is set
correctly or not for this case? You may need to tweak Makefile
if you are doing cross compilation, I am not sure how as I
did not have environment.
