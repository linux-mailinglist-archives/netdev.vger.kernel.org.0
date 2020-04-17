Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD851ADA06
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 11:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgDQJdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 05:33:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47959 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730131AbgDQJdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 05:33:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587115991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JhGeUvxGcTXLdmHA9NT0UPQF+FHUIR0Zeja74ZUVplA=;
        b=G3zDI8QCAQdtZA5ptqGoLGtDn16rn/A2R3U+TNl3UiRw54r3pgIgF3nkNztWMod1i1lrI3
        u9yPG3kRS2Sjty9OSl33UezUQ+hX33XV80SQiPflbfYpZTIsycIE37w2viRQRPtAeeCzrb
        Vr+M5vmlSZENOx/7BYrlryF+H+66sL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-OVKHQIXwNXKHVGLh1l_TJQ-1; Fri, 17 Apr 2020 05:33:08 -0400
X-MC-Unique: OVKHQIXwNXKHVGLh1l_TJQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3C53107ACCA;
        Fri, 17 Apr 2020 09:33:06 +0000 (UTC)
Received: from [10.72.13.157] (ovpn-13-157.pek2.redhat.com [10.72.13.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86A0A5C1D6;
        Fri, 17 Apr 2020 09:32:58 +0000 (UTC)
Subject: Re: [PATCH V2] vhost: do not enable VHOST_MENU by default
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20200415024356.23751-1-jasowang@redhat.com>
 <20200416185426-mutt-send-email-mst@kernel.org>
 <b7e2deb7-cb64-b625-aeb4-760c7b28c0c8@redhat.com>
 <20200417022929-mutt-send-email-mst@kernel.org>
 <4274625d-6feb-81b6-5b0a-695229e7c33d@redhat.com>
 <20200417042912-mutt-send-email-mst@kernel.org>
 <fdb555a6-4b8d-15b6-0849-3fe0e0786038@redhat.com>
 <20200417044230-mutt-send-email-mst@kernel.org>
 <73843240-3040-655d-baa9-683341ed4786@redhat.com>
 <20200417045454-mutt-send-email-mst@kernel.org>
 <CAMuHMdXbzd9puG6gGri4jUtUT8rFrqnWwZ1NwP=47WQJ_eBC5g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2f5681bb-a8e6-fe73-57f5-24de7a5a72e8@redhat.com>
Date:   Fri, 17 Apr 2020 17:32:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXbzd9puG6gGri4jUtUT8rFrqnWwZ1NwP=47WQJ_eBC5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/17 =E4=B8=8B=E5=8D=885:25, Geert Uytterhoeven wrote:
> Hi Michael,
>
> On Fri, Apr 17, 2020 at 10:57 AM Michael S. Tsirkin<mst@redhat.com>  wr=
ote:
>> On Fri, Apr 17, 2020 at 04:51:19PM +0800, Jason Wang wrote:
>>> On 2020/4/17 =E4=B8=8B=E5=8D=884:46, Michael S. Tsirkin wrote:
>>>> On Fri, Apr 17, 2020 at 04:39:49PM +0800, Jason Wang wrote:
>>>>> On 2020/4/17 =E4=B8=8B=E5=8D=884:29, Michael S. Tsirkin wrote:
>>>>>> On Fri, Apr 17, 2020 at 03:36:52PM +0800, Jason Wang wrote:
>>>>>>> On 2020/4/17 =E4=B8=8B=E5=8D=882:33, Michael S. Tsirkin wrote:
>>>>>>>> On Fri, Apr 17, 2020 at 11:12:14AM +0800, Jason Wang wrote:
>>>>>>>>> On 2020/4/17 =E4=B8=8A=E5=8D=886:55, Michael S. Tsirkin wrote:
>>>>>>>>>> On Wed, Apr 15, 2020 at 10:43:56AM +0800, Jason Wang wrote:
>>>>>>>>>>> We try to keep the defconfig untouched after decoupling CONFI=
G_VHOST
>>>>>>>>>>> out of CONFIG_VIRTUALIZATION in commit 20c384f1ea1a
>>>>>>>>>>> ("vhost: refine vhost and vringh kconfig") by enabling VHOST_=
MENU by
>>>>>>>>>>> default. Then the defconfigs can keep enabling CONFIG_VHOST_N=
ET
>>>>>>>>>>> without the caring of CONFIG_VHOST.
>>>>>>>>>>>
>>>>>>>>>>> But this will leave a "CONFIG_VHOST_MENU=3Dy" in all defconfi=
gs and even
>>>>>>>>>>> for the ones that doesn't want vhost. So it actually shifts t=
he
>>>>>>>>>>> burdens to the maintainers of all other to add "CONFIG_VHOST_=
MENU is
>>>>>>>>>>> not set". So this patch tries to enable CONFIG_VHOST explicit=
ly in
>>>>>>>>>>> defconfigs that enables CONFIG_VHOST_NET and CONFIG_VHOST_VSO=
CK.
>>>>>>>>>>>
>>>>>>>>>>> Acked-by: Christian Borntraeger<borntraeger@de.ibm.com>    (s=
390)
>>>>>>>>>>> Acked-by: Michael Ellerman<mpe@ellerman.id.au>    (powerpc)
>>>>>>>>>>> Cc: Thomas Bogendoerfer<tsbogend@alpha.franken.de>
>>>>>>>>>>> Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
>>>>>>>>>>> Cc: Paul Mackerras<paulus@samba.org>
>>>>>>>>>>> Cc: Michael Ellerman<mpe@ellerman.id.au>
>>>>>>>>>>> Cc: Heiko Carstens<heiko.carstens@de.ibm.com>
>>>>>>>>>>> Cc: Vasily Gorbik<gor@linux.ibm.com>
>>>>>>>>>>> Cc: Christian Borntraeger<borntraeger@de.ibm.com>
>>>>>>>>>>> Reported-by: Geert Uytterhoeven<geert@linux-m68k.org>
>>>>>>>>>>> Signed-off-by: Jason Wang<jasowang@redhat.com>
>>>>>>>>>> I rebased this on top of OABI fix since that
>>>>>>>>>> seems more orgent to fix.
>>>>>>>>>> Pushed to my vhost branch pls take a look and
>>>>>>>>>> if possible test.
>>>>>>>>>> Thanks!
>>>>>>>>> I test this patch by generating the defconfigs that wants vhost=
_net or
>>>>>>>>> vhost_vsock. All looks fine.
>>>>>>>>>
>>>>>>>>> But having CONFIG_VHOST_DPN=3Dy may end up with the similar sit=
uation that
>>>>>>>>> this patch want to address.
>>>>>>>>> Maybe we can let CONFIG_VHOST depends on !ARM || AEABI then add=
 another
>>>>>>>>> menuconfig for VHOST_RING and do something similar?
>>>>>>>>>
>>>>>>>>> Thanks
>>>>>>>> Sorry I don't understand. After this patch CONFIG_VHOST_DPN is j=
ust
>>>>>>>> an internal variable for the OABI fix. I kept it separate
>>>>>>>> so it's easy to revert for 5.8. Yes we could squash it into
>>>>>>>> VHOST directly but I don't see how that changes logic at all.
>>>>>>> Sorry for being unclear.
>>>>>>>
>>>>>>> I meant since it was enabled by default, "CONFIG_VHOST_DPN=3Dy" w=
ill be left
>>>>>>> in the defconfigs.
>>>>>> But who cares?
>>>>> FYI, please seehttps://www.spinics.net/lists/kvm/msg212685.html
>>>> The complaint was not about the symbol IIUC.  It was that we caused
>>>> everyone to build vhost unless they manually disabled it.
>>> There could be some misunderstanding here. I thought it's somehow sim=
ilar: a
>>> CONFIG_VHOST_MENU=3Dy will be left in the defconfigs even if CONFIG_V=
HOST is
>>> not set.
>>>
>>> Thanks
>> Hmm. So looking at Documentation/kbuild/kconfig-language.rst :
>>
>>          Things that merit "default y/m" include:
>>
>>          a) A new Kconfig option for something that used to always be =
built
>>             should be "default y".
>>
>>          b) A new gatekeeping Kconfig option that hides/shows other Kc=
onfig
>>             options (but does not generate any code of its own), shoul=
d be
>>             "default y" so people will see those other options.
>>
>>          c) Sub-driver behavior or similar options for a driver that i=
s
>>             "default n". This allows you to provide sane defaults.
>>
>>
>> So it looks like VHOST_MENU is actually matching rule b).
>> So what's the problem we are trying to solve with this patch, exactly?
>>
>> Geert could you clarify pls?
> I can confirm VHOST_MENU is matching rule b), so it is safe to always
> enable it.
>
> Gr{oetje,eeting}s,
>
>                          Geert


Right, so I think we can drop this patch.

Thanks


